`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: cla_gorev_denetci
// Description: Gorev denetcisi. CLA'nin hangi gorevi ne zaman baslatip
//              bitirecegine karar verir ve CPU'ya giden gorev kesmesini (PIE)
//              uretir.
//
//   Is bolumu (04.10.2026):
//     - Yazmaclar (MIFR, MIER, MIRUN, MIOVF, MVECT) Arda'nin cla_ctrl_regs /
//       cla_mvect_regs modullerinde durur. Cevre tetikleri ve tasma (MIOVF)
//       de orada.
//     - Bu modul yalniz KARAR verir ve olay uretir:
//         gorev_basla -> MIRUN[no] <= 1, MIFR[no] <= 0, getirme <= MVECT[no]
//         gorev_bitti -> MIRUN <= 0
//
//   Durumlar:
//     BOSTA      gorev yok; bekleyen (MIFR & MIER) gelirse HAKEM1
//     HAKEM1/2   iki hakem cevrimi; HAKEM2'de en oncelikli gorev baslar
//                (bekleyen kalmadiysa BOSTA)
//     CALISIYOR  gorev kosuyor; MSTOP D2'ye gelince HAKEM1
//     DONDU      gecersiz opcode D2'de; yalniz SOFT/HARD reset cikarir
//
//   Zamanlama (TRM Tablo 10-19, s.688): MSTOP D2'de cevrim n ise
//     n   : MIRUN temizlenir, PIE kesmesi, arkadaki 3 buyruk (F1 F2 D1) silinir
//     n+1 : hakem
//     n+2 : hakem, yeni gorev secilir (gorev_basla)
//     n+3 : yeni gorevin ilk F1'i
//
// Kaynaklar: TRM s.570 (gorev akisi), s.576 (gecersiz opcode, resetler),
//            s.688 (MSTOP), s.710-711 (MIOVF, MIER); golden model
//            task_arbiter.py, model_kararlari.md §14, 04_rtl_sartlari.md 7-8.
//
// Varsayim (TRM'de yok): BOSTA'dayken gelen istek de MSTOP sonrasi gibi
// iki hakem cevrimi bekler; istek t'de gorulurse ilk F1 t+3'te.
//////////////////////////////////////////////////////////////////////////////////

module cla_gorev_denetci (
    input  logic       clk,
    input  logic       rst_n,

    // cla_ctrl_regs'ten
    input  logic [7:0] bekleyen,      // MIFR & MIER; bit i = gorev i+1
    input  logic       softreset,     // MCTL[SOFTRESET]'e 1 yazildi (1 cevrim)
    input  logic       hardreset,     // MCTL[HARDRESET]'e 1 yazildi (1 cevrim)

    // Boru hattindan: D2'deki buyruk
    input  logic       d2_gecerli,    // D2'de gecerli buyruk var ve bu cevrim islenir
                                      // (durma varken 0; D2 isi bir kez yapilir)
    input  logic       d2_mstop,      // kontrol.mstop
    input  logic       d2_gecersiz,   // kontrol.gecersiz

    // cla_ctrl_regs / cla_mvect_regs'e
    output logic       gorev_basla,   // 1 cevrim: MIRUN[gorev_no] <= 1, MIFR[gorev_no] <= 0,
                                      //           getirme sayaci <= MVECT[gorev_no]
    output logic [2:0] gorev_no,      // 0..7 (TRM'de gorev 1..8)
    output logic       gorev_bitti,   // 1 cevrim: MIRUN <= 0

    // CPU'ya (PIE)
    output logic [7:0] pie_kesme,     // 1 cevrim; biten (ya da donan) gorevin biti

    // Boru hattina
    output logic       getir_izin,    // F1 yeni buyruk getirebilir
    output logic       on_temizle,    // F1, F2, D1'dekileri sil (MSTOP'un arkasindaki 3 buyruk)
    output logic       tumu_temizle,  // butun kademeleri sil (SOFT/HARD reset)
    output logic       dondur,        // butun boru hattini dondur (gecersiz opcode)

    // Izleme
    output logic       calisiyor,
    output logic [2:0] aktif_gorev
);

    typedef enum logic [2:0] {
        BOSTA, HAKEM1, HAKEM2, CALISIYOR, DONDU
    } durum_e;

    durum_e durum, sonraki;

    // ------------------------------------------------------------------
    // Oncelik: en kucuk numarali bekleyen gorev (gorev 1 en yuksek)
    // ------------------------------------------------------------------
    logic [2:0] secilen;
    logic       var_mi;

    always_comb begin
        casez (bekleyen)
            8'b???????1: secilen = 3'd0;
            8'b??????10: secilen = 3'd1;
            8'b?????100: secilen = 3'd2;
            8'b????1000: secilen = 3'd3;
            8'b???10000: secilen = 3'd4;
            8'b??100000: secilen = 3'd5;
            8'b?1000000: secilen = 3'd6;
            default:     secilen = 3'd7;   // 10000000 (ya da hic yok: var_mi = 0)
        endcase
    end
    assign var_mi = |bekleyen;

    // ------------------------------------------------------------------
    // D2 olaylari (yalniz gorev kosarken)
    // ------------------------------------------------------------------
    logic d2_bitis, d2_gecersiz_gordu, sifirla;

    assign d2_gecersiz_gordu = (durum == CALISIYOR) && d2_gecerli && d2_gecersiz;
    assign d2_bitis          = (durum == CALISIYOR) && d2_gecerli && d2_mstop && !d2_gecersiz;
    assign sifirla           = softreset || hardreset;

    // ------------------------------------------------------------------
    // Sonraki durum ve ciktilar
    // ------------------------------------------------------------------
    always_comb begin
        sonraki      = durum;
        gorev_basla  = 1'b0;
        gorev_no     = secilen;
        gorev_bitti  = 1'b0;
        pie_kesme    = 8'h00;
        on_temizle   = 1'b0;
        tumu_temizle = 1'b0;
        dondur       = 1'b0;

        unique case (durum)
            BOSTA:
                if (var_mi) sonraki = HAKEM1;

            HAKEM1:
                sonraki = HAKEM2;

            HAKEM2:
                if (var_mi) begin
                    gorev_basla = 1'b1;
                    sonraki     = CALISIYOR;
                end else begin
                    sonraki     = BOSTA;
                end

            CALISIYOR:
                if (d2_gecersiz_gordu) begin
                    // s.576: D2'de dur, PIE kesmesi gider, MIRUN set kalir
                    pie_kesme = 8'b1 << aktif_gorev;
                    dondur    = 1'b1;
                    sonraki   = DONDU;
                end else if (d2_bitis) begin
                    gorev_bitti = 1'b1;
                    pie_kesme   = 8'b1 << aktif_gorev;
                    on_temizle  = 1'b1;
                    sonraki     = HAKEM1;
                end

            DONDU:
                dondur = 1'b1;

            default:
                sonraki = BOSTA;
        endcase

        // SOFTRESET: gorev durur, MIRUN ve MIER temizlenir (cla_ctrl_regs), PIE YOK.
        // HARDRESET: her sey sifirlanir. Ikisinde de boru hatti bosaltilir.
        if (sifirla) begin
            sonraki      = BOSTA;
            gorev_basla  = 1'b0;
            gorev_bitti  = 1'b0;
            pie_kesme    = 8'h00;
            on_temizle   = 1'b0;
            dondur       = 1'b0;
            tumu_temizle = 1'b1;
        end
    end

    // Getirme yalniz gorev kosarken (MSTOP cevriminde getirilen zaten silinir)
    assign getir_izin = (durum == CALISIYOR) && !dondur && !sifirla;
    assign calisiyor  = (durum == CALISIYOR) || (durum == DONDU);  // MIRUN ile ayni

    // ------------------------------------------------------------------
    // Yazmaclar
    // ------------------------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            durum       <= BOSTA;
            aktif_gorev <= 3'd0;
        end else begin
            durum <= sonraki;
            if (gorev_basla)
                aktif_gorev <= secilen;
        end
    end

endmodule
