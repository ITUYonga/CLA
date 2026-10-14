`timescale 1ns / 1ps

// MOD_CLA_GOREV_DENETCI : 8 görevli CLA öncelik hakemi, görev durum makinesi (FSM) ve CPU kesme (PIE) üreticisi
//
//   Amaç:     Bekleyen ve izin verilen görevleri (bekleyen = MIFR & MIER)
//             izleyerek Görev 1 en yüksek öncelikli olacak şekilde sıradaki
//             görevi seçer. BOSTA, HAKEM1, HAKEM2, CALISIYOR ve DONDU
//             durumlarından oluşan FSM ile görev başlatma (gorev_basla),
//             görev bitirme (gorev_bitti), F1 buyruk getirme izni
//             (getir_izin), boru hattı temizleme (on_temizle, tumu_temizle)
//             ve CPU kesme (pie_kesme) sinyallerini üretir.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           clk:            Sistem saati
//           rst_n:          Aktif-düşük sıfırlama sinyali
//           bekleyen:       MIFR & MIER çarpımından oluşan 8-bitlik bekleyen
//                           görev vektörü
//           softreset:      MCTL[1] yazmasından gelen 1 çevrimlik soft reset
//                           darbesi
//           hardreset:      MCTL[0] yazmasından gelen 1 çevrimlik hard reset
//                           darbesi
//           d2_gecerli:     D2 aşamasında geçerli ve ilerleyen bir buyruk
//                           olduğunu belirten sinyal
//           d2_mstop:       D2 aşamasındaki buyruğun MSTOP olduğunu belirten
//                           sinyal
//           d2_gecersiz:    D2 aşamasındaki buyruğun geçersiz olduğunu
//                           belirten sinyal
//   Outputlar:
//           gorev_basla:    HAKEM2 durumunda seçilen görevi başlatan 1
//                           çevrimlik darbe
//           gorev_no:       Başlatılan görevin 3-bitlik numarası (0..7 ->
//                           Görev 1..8)
//           gorev_bitti:    MSTOP görüldüğünde MIRUN yazmacını temizleyen 1
//                           çevrimlik darbe
//           pie_kesme:      Görev bittiğinde veya geçersiz buyrukta CPU'ya
//                           giden 8-bitlik kesme darbesi
//           getir_izin:     CALISIYOR durumunda (MSTOP hariç) F1 aşamasına
//                           buyruk getirme izni veren sinyal
//           on_temizle:     MSTOP D2'de görüldüğünde F1, F2 ve D1 aşamalarını
//                           temizleyen sinyal
//           tumu_temizle:   Soft veya hard reset geldiğinde tüm boru hattını
//                           temizleyen sinyal
//           dondur:         Geçersiz buyruk görüldüğünde boru hattını DONDU
//                           durumunda kilitleyen sinyal
//           calisiyor:      Denetçinin CALISIYOR durumunda olduğunu gösteren
//                           izleme çıkışı
//           aktif_gorev:    O anda koşan görevin 3-bitlik numarası
//
//   Notlar:
//           MSTOP buyruğu D2'de n. çevrimde görüldüğünde n. çevrimde MIRUN
//           temizlenir ve PIE kesmesi üretilir; n+1 ve n+2 çevrimlerinde 2
//           hakem çevrimi (HAKEM1, HAKEM2) koşar ve bekleyen görev varsa
//           n+3'te ilk F1 yapılır.
//
//           D2'de geçersiz bir buyruk görülürse FSM DONDU durumuna geçer
//           ve boru hattını dondurur; bu durumdan yalnızca softreset,
//           hardreset veya sistem reseti ile çıkılabilir.

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
