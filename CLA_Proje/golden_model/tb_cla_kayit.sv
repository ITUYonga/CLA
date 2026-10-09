`timescale 1ns / 1ps
// =====================================================================
//  tb_cla_kayit - CLA_Top test kaydi tezgahi
// ---------------------------------------------------------------------
//  Programi ve baslangic bellegini giris dosyasindan yukler, gorevleri CPU portundan tetikler,
//  HER SAAT CEVRIMI bir IZ satiri yazar (yazmaclar, E'deki buyruk, bellek yazmasi, kontrol
//  sinyalleri); sonda bellek ve yazmaclari doker. Bicim test_karsilastirici.py ile birebir ayni:
//
//    python3 test_karsilastirici.py hazirla prog.casm        -> prog_giris.hex
//    <simulasyon> +GIRIS=prog_giris.hex +KAYIT=prog_kayit.hex  -> prog_kayit.hex
//    python3 test_karsilastirici.py prog_kayit.hex            -> golden ile cevrim cevrim karsilastirma
//
//  Derleme (Verilator 5, CLA_Proje klasorunden):
//    $ verilator --binary --timing -Wno-fatal -Wno-lint -Wno-style --top-module tb_cla_kayit -Mdir obj_kayit \
//      rtl/kontrol/cla_pkg.sv rtl/kontrol/cla_decoder.sv rtl/kontrol/cla_ctrl_gen.sv rtl/kontrol/cla_gorev_denetci.sv \
//      rtl/yazmac_bellek/cla_data_ram.sv rtl/yazmac_bellek/cla_mvect_regs.sv \
//      rtl/alu/*.sv "rtl/alu/kayan_nokta birimi"/*.sv "rtl/alu/kayan_nokta birimi"/*/*.sv \
//      rtl/top/*.sv golden_model/tb_cla_kayit.sv
//    $ cp rtl/alu/estimate_lut.hex .      (kestirme.sv tabloyu calisma klasorunden okur)
//    $ obj_kayit/Vtb_cla_kayit +GIRIS=prog_giris.hex +KAYIT=prog_kayit.hex
//  Vivado: ayni dosyalar + estimate_lut.hex simulasyon kaynagi; plusarg'lar xsim -testplusarg ile.
// =====================================================================
module tb_cla_kayit;
    import cla_pkg::*;

    logic clk = 0, rst_n = 0;
    always #5 clk = ~clk;

    logic cpu_wr_en = 0; logic [2:0] cpu_reg_addr = 0; logic [15:0] cpu_wr_data = 0; logic [15:0] cpu_rd_data;
    logic mvect_wr_en = 0; logic [2:0] mvect_gorev = 0; logic [15:0] mvect_veri = 0; logic [15:0] mvect_oku;
    logic [7:0] pie_kesme; logic [15:0] mirun;
    logic [6:0] m2c_addr, c2m_addr; logic [1:0] m2c_rd_en, c2m_wr_en, c2m_rd_en; logic [31:0] m2c_dout, c2m_din, c2m_dout;

    CLA_Top DUT(.clk(clk), .rst_n(rst_n),
        .cpu_wr_en(cpu_wr_en), .cpu_reg_addr(cpu_reg_addr), .cpu_wr_data(cpu_wr_data), .cpu_rd_data(cpu_rd_data),
        .mvect_wr_en(mvect_wr_en), .mvect_gorev(mvect_gorev), .mvect_veri(mvect_veri), .mvect_oku(mvect_oku),
        .hw_task_trig(8'h00), .pie_kesme(pie_kesme), .mirun(mirun),
        .m2c_addr(m2c_addr), .m2c_rd_en(m2c_rd_en), .m2c_dout(m2c_dout),
        .c2m_addr(c2m_addr), .c2m_wr_en(c2m_wr_en), .c2m_rd_en(c2m_rd_en), .c2m_din(c2m_din), .c2m_dout(c2m_dout));

    // mesaj RAM'leri (CLA tarafi; kartta kopru icinde)
    cla_data_ram #(.ADDR_WIDTH(7)) M2C(.clk(clk), .addr(m2c_addr), .wr_en(2'b00), .rd_en(m2c_rd_en), .din(32'h0), .dout(m2c_dout));
    cla_data_ram #(.ADDR_WIDTH(7)) C2M(.clk(clk), .addr(c2m_addr), .wr_en(c2m_wr_en), .rd_en(c2m_rd_en), .din(c2m_din), .dout(c2m_dout));

    string giris, kayit, satir_metni, anahtar, blok;
    integer fg, fk, r, i, j;
    logic [31:0] v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, ofset;
    logic [11:0] mvect [0:7];
    logic [7:0] mier, mifrc;
    logic [15:0] tampon [0:4095];

    // ---- bellek <-> tampon
    task automatic tampona_al(input string b);
        for (int a = 0; a < 4096; a++) begin
            case (b)
                "L3":  tampon[a] = DUT.F2.l3[a];
                "L1":  tampon[a] = (a < 1024) ? DUT.L1.ram[a] : 16'h0;
                "L2":  tampon[a] = (a < 1024) ? DUT.L2.ram[a] : 16'h0;
                "M2C": tampon[a] = (a < 128) ? M2C.ram[a] : 16'h0;
                default: tampon[a] = (a < 128) ? C2M.ram[a] : 16'h0;
            endcase
        end
    endtask

    task automatic yukle(input string b, input logic [31:0] a, input logic [15:0] k);
        case (b)
            "L3":  DUT.F2.l3[a[11:0]] = k;
            "L1":  DUT.L1.ram[a[9:0]] = k;
            "L2":  DUT.L2.ram[a[9:0]] = k;
            "M2C": M2C.ram[a[6:0]] = k;
            "C2M": C2M.ram[a[6:0]] = k;
            default: $fatal(1, "tanimsiz bellek: %s", b);
        endcase
    endtask

    function automatic integer boyut(input string b);
        if (b == "L3") return 4096;
        if (b == "L1" || b == "L2") return 1024;
        return 128;
    endfunction

    // 8 kelimelik satirlar; tamami 0 olan satir yazilmaz
    task automatic bellek_yaz(input string on, input string b);
        tampona_al(b);
        for (int a = 0; a < boyut(b); a += 8)
            if ((tampon[a] | tampon[a+1] | tampon[a+2] | tampon[a+3] | tampon[a+4] | tampon[a+5] | tampon[a+6] | tampon[a+7]) != 16'h0)
                $fwrite(fk, "%s%s %h %h %h %h %h %h %h %h %h\n", on, b, 16'(a), tampon[a], tampon[a+1], tampon[a+2],
                        tampon[a+3], tampon[a+4], tampon[a+5], tampon[a+6], tampon[a+7]);
    endtask

    function automatic logic [15:0] taban(input logic [1:0] b);
        case (b) 2'b00: return 16'h8800; 2'b01: return 16'h8C00; 2'b10: return 16'h1480; default: return 16'h1500; endcase
    endfunction

    // ---- iz durumu (cevrim icinde negedge'de orneklenir, satir posedge'den sonra yazilir)
    integer satir, mstop_satiri, son_satir;
    logic   basladi, zaman_asimi;
    logic   s_ev; logic [11:0] s_epc; logic [31:0] s_eop;
    logic [1:0] s_wen, s_blok; logic [9:0] s_wadr; logic [31:0] s_wdin;
    logic   s_bos, s_durma, s_mstop, s_gorev_yok, s_donma;
    logic [7:0] s_sinyal;
    string  pie_listesi;

    initial begin
        if (!$value$plusargs("GIRIS=%s", giris)) $fatal(1, "+GIRIS=<prog_giris.hex> gerekli");
        if (!$value$plusargs("KAYIT=%s", kayit)) kayit = "rtl_kayit.hex";

        // ---- giris dosyasi: BASLANGIC ve BAS_<blok> satirlari
        for (i = 0; i < 4096; i++) DUT.F2.l3[i] = 16'h0;
        for (i = 0; i < 1024; i++) begin DUT.L1.ram[i] = 16'h0; DUT.L2.ram[i] = 16'h0; end
        for (i = 0; i < 128; i++) begin M2C.ram[i] = 16'h0; C2M.ram[i] = 16'h0; end
        for (i = 0; i < 8; i++) mvect[i] = 12'h0;
        mier = 8'h0; mifrc = 8'h0;
        fg = $fopen(giris, "r");
        if (fg == 0) $fatal(1, "giris dosyasi acilamadi: %s", giris);
        while ($fgets(satir_metni, fg) != 0) begin
            anahtar = "";
            r = $sscanf(satir_metni, "%s", anahtar);
            if (r != 1 || anahtar.len() < 2 || anahtar.substr(0, 1) == "//") continue;
            if (anahtar == "BASLANGIC") begin
                r = $sscanf(satir_metni, "%s %h %h %h %h %h %h %h %h %h %h", anahtar, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9);
                if (r != 11) $fatal(1, "BASLANGIC satiri bozuk: %s", satir_metni);
                mvect[0] = v0[11:0]; mvect[1] = v1[11:0]; mvect[2] = v2[11:0]; mvect[3] = v3[11:0];
                mvect[4] = v4[11:0]; mvect[5] = v5[11:0]; mvect[6] = v6[11:0]; mvect[7] = v7[11:0];
                mier = v8[7:0]; mifrc = v9[7:0];
            end
            else if (anahtar.len() > 4 && anahtar.substr(0, 3) == "BAS_") begin
                r = $sscanf(satir_metni, "%s %h %h %h %h %h %h %h %h %h", anahtar, ofset, v0, v1, v2, v3, v4, v5, v6, v7);
                if (r != 10) $fatal(1, "bellek satiri bozuk: %s", satir_metni);
                blok = anahtar.substr(4, anahtar.len() - 1);
                yukle(blok, ofset, v0[15:0]); yukle(blok, ofset + 1, v1[15:0]); yukle(blok, ofset + 2, v2[15:0]);
                yukle(blok, ofset + 3, v3[15:0]); yukle(blok, ofset + 4, v4[15:0]); yukle(blok, ofset + 5, v5[15:0]);
                yukle(blok, ofset + 6, v6[15:0]); yukle(blok, ofset + 7, v7[15:0]);
            end
            else $fatal(1, "giris dosyasinda tanimsiz satir: %s", satir_metni);
        end
        $fclose(fg);

        // ---- kayit: baslik, giris (RTL'e yuklenmis haliyle)
        fk = $fopen(kayit, "w");
        if (fk == 0) $fatal(1, "kayit dosyasi acilamadi: %s", kayit);
        $fwrite(fk, "// CLA KAYIT v1 - butun sayilar onaltilik (hex)\n");
        $fwrite(fk, "// BASLANGIC mvect1 mvect2 mvect3 mvect4 mvect5 mvect6 mvect7 mvect8 mier mifrc\n");
        $fwrite(fk, "// BAS_<blok> / SON_<blok> : <16 bitlik kelime ofseti> <8 kelime> (tamami 0 olan satir yazilmaz)\n");
        $fwrite(fk, "// IZ cevrim sinyal exe_pc exe_op mpc mr0 mr1 mr2 mr3 mar0 mar1 mstf yaz yaz_adr yaz_veri\n");
        $fwrite(fk, "//   sinyal bitleri (0 = en dusuk): 0 E_gecerli, 1 dur_exe, 2 dur_r1, 3 dal_alindi, 4 K2_yazma, 5 MSTOP, 6 gorev_basla, 7 donma\n");
        $fwrite(fk, "//   yaz: 0 yazma yok, 1 16 bit, 2 32 bit\n");
        $fwrite(fk, "// SON_YAZMAC mr0 mr1 mr2 mr3 mar0 mar1 mstf mpc mirun mifr miovf\n");
        $fwrite(fk, "BASLANGIC %h %h %h %h %h %h %h %h %h %h\n", mvect[0], mvect[1], mvect[2], mvect[3],
                mvect[4], mvect[5], mvect[6], mvect[7], mier, mifrc);
        bellek_yaz("BAS_", "L3"); bellek_yaz("BAS_", "L1"); bellek_yaz("BAS_", "L2");
        bellek_yaz("BAS_", "M2C"); bellek_yaz("BAS_", "C2M");

        // ---- reset, MVECT1-8, MIER, MIFRC (gorevleri tetikler)
        repeat (3) @(negedge clk);
        rst_n = 1;
        @(negedge clk);
        for (i = 0; i < 8; i++) begin
            mvect_wr_en = 1; mvect_gorev = i[2:0]; mvect_veri = {4'h0, mvect[i]};
            @(negedge clk);
        end
        mvect_wr_en = 0;
        cpu_wr_en = 1; cpu_reg_addr = 3'd5; cpu_wr_data = {8'h00, mier};
        @(negedge clk);
        cpu_wr_en = 1; cpu_reg_addr = 3'd4; cpu_wr_data = {8'h00, mifrc};
        @(negedge clk);
        cpu_wr_en = 0;

        // ---- cevrim cevrim iz
        basladi = 0; zaman_asimi = 0; satir = 0; mstop_satiri = -1; son_satir = -1; pie_listesi = "";
        forever begin
            if (!basladi && DUT.getir_izin) basladi = 1;              // satir 1 = ilk F1
            if (basladi) begin
                s_ev = DUT.r2e_gecerli; s_epc = DUT.r2e_pc; s_eop = DUT.r2e_kelime;
                s_wen = DUT.w_wr_en; s_blok = DUT.w_blok; s_wadr = DUT.w_ram_adr; s_wdin = DUT.w_din;
                s_bos = !DUT.d2r1_gecerli && !DUT.r1r2_gecerli && !DUT.r2e_gecerli;
                s_durma = DUT.dur_exe || DUT.dur_r1;
                s_mstop = DUT.d2_gecerli && DUT.d2_mstop;
                s_gorev_yok = (DUT.bekleyen == 8'h00);
                s_donma = DUT.dondur && !DUT.dondur_q;                  // gecersiz buyruk D2'de goruldu
                s_sinyal = {s_donma,                                    // 7 donma
                            DUT.gorev_basla_e,                          // 6 yeni gorev basliyor
                            s_mstop,                                    // 5 MSTOP D2'de
                            |(DUT.WR.t_maske | DUT.WR.c_maske),         // 4 K2 yazmasi (W)
                            DUT.dal_alindi,                             // 3 dal alindi (D2)
                            DUT.dur_r1 && !DUT.dur_exe,                 // 2 dur_r1
                            DUT.dur_exe,                                // 1 dur_exe
                            s_ev};                                      // 0 E'de gecerli buyruk
            end
            if (pie_kesme != 8'h00) pie_listesi = {pie_listesi, $sformatf(" %h", pie_kesme)};
            @(posedge clk); #1;
            if (basladi) begin
                satir++;
                $fwrite(fk, "IZ %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h\n", 20'(satir), s_sinyal,
                        s_ev ? s_epc : 12'h0, s_ev ? s_eop : 32'h0, DUT.mpc,
                        DUT.mr0_out, DUT.mr1_out, DUT.mr2_out, DUT.mr3_out, DUT.mar0, DUT.mar1, DUT.mstf,
                        (s_wen == 2'b11) ? 4'd2 : (s_wen != 2'b00) ? 4'd1 : 4'd0,
                        (s_wen != 2'b00) ? taban(s_blok) + {6'b0, s_wadr} : 16'h0,
                        (s_wen == 2'b11) ? s_wdin : (s_wen != 2'b00) ? {16'h0, s_wdin[15:0]} : 32'h0);
                // bitis (golden): MSTOP'tan sonra durmasiz bir cevrimde R1, R2, E bos ve bekleyen gorev yoksa
                if (s_mstop) mstop_satiri = satir;
                if (s_donma) son_satir = satir;                         // donmada kuyruk yok
                if (son_satir < 0 && mstop_satiri > 0 && !s_durma && s_bos && s_gorev_yok && !DUT.calisiyor)
                    son_satir = (satir > mstop_satiri + 3) ? satir : mstop_satiri + 3;
                if (son_satir > 0 && satir >= son_satir) break;
                if (satir >= 20000) begin zaman_asimi = 1; break; end
            end
        end
        repeat (8) @(posedge clk);                                      // iz bittikten sonra hicbir sey degismemeli
        #1;

        // ---- son durum
        if (zaman_asimi) $fwrite(fk, "// ZAMAN ASIMI: 20000 cevrimde bitmedi\n");
        bellek_yaz("SON_", "L1"); bellek_yaz("SON_", "L2"); bellek_yaz("SON_", "C2M");
        $fwrite(fk, "SON_YAZMAC %h %h %h %h %h %h %h %h %h %h %h\n", DUT.mr0_out, DUT.mr1_out, DUT.mr2_out, DUT.mr3_out,
                DUT.mar0, DUT.mar1, DUT.mstf, DUT.mpc, DUT.mirun[7:0], DUT.mifr_out[7:0], DUT.miovf_out[7:0]);
        $fwrite(fk, "PIE%s\n", pie_listesi);
        $fclose(fk);
        $display("tb_cla_kayit: %0d cevrim -> %s", satir, kayit);
        $finish;
    end
endmodule
