`timescale 1ns / 1ps
// Kenar durumlari: dondur (E ve W), tumu_temizle, D2'den RPC yazmasi ve E ile cakismasi
module tb_kenar;
    import cla_pkg::*;

    logic clk = 0, rst_n = 0;
    always #5 clk = ~clk;

    logic [31:0] kelime = 32'h7FA00000;
    logic gecerli = 0, dondur = 0, tumu_temizle = 0, rpc_en = 0;
    logic [11:0] rpc_deger = 0;
    logic [15:0] ea = 0;
    logic [31:0] okunan = 0;

    op_e op; logic gecersiz, kip_gecersiz; alanlar_t alan; kontrol_t k;
    cla_decoder  DEC(.buyruk(kelime), .op(op), .gecersiz(gecersiz), .kip_gecersiz(kip_gecersiz), .alan(alan));
    cla_ctrl_gen GEN(.op(op), .alan(alan), .kip_gecersiz(kip_gecersiz), .k(k));

    logic [31:0] mr0, mr1, mr2, mr3, mstf, gorunen_32; logic [4:0] gorunen_5; logic rnd32, dur_exe; logic [11:0] rpc;
    logic x_e_yaz1, x_e_yaz2; logic [1:0] x_e_hedef1, x_e_hedef2; logic [31:0] x_e_veri1, x_e_veri_2;
    logic [15:0] mar_veri; logic mar_sec, mar_en; logic [18:0] x_mstf_veri, x_mstf_maske;
    logic w_gecerli; logic [11:0] w_pc; logic [1:0] w_bellek_yaz; logic [15:0] w_adr; logic [31:0] w_veri;
    logic [31:0] result_topla, result_carp; logic lvf_topla, luf_topla, valid_topla, lvf_carp, luf_carp, valid_carp;
    logic [1:0] hedef_mr_out_topla, hedef_mr_out_carp;
    logic [1:0] w_blok, w_wr_en; logic [9:0] w_ram_adr; logic [31:0] w_din;
    logic ew_gecerli; logic [11:0] ew_pc; logic [1:0] ew_bellek_yaz; logic [15:0] ew_yaz_adr; logic [31:0] ew_yaz_veri;

    Execute EX(.clk(clk), .rst_n(rst_n),
        .gecerli(gecerli), .pc(12'h000), .ea(ea), .m(alan.m), .shift(alan.shift), .okunan(okunan),
        .mar_d2(16'h0), .veri_mr(alan.ra), .kosul(k.kosul), .alu(k.alu),
        .a_mr(k.a_mr), .b_mr(k.b_mr), .c_mr(k.c_mr), .d_mr(k.d_mr), .d_kaynak(k.d_kaynak),
        .exe_yaz(k.exe_yaz), .exe_hedef(k.exe_hedef), .exe_kaynak(k.exe_kaynak), .exe_kaynak_mr(k.exe_kaynak_mr),
        .exe_yaz_2(k.exe_yaz_2), .exe_hedef_2(k.exe_hedef_2), .exe_kaynak_mr_2(k.exe_kaynak_mr_2),
        .exe_kosullu(k.exe_kosullu), .mar_yukle(k.mar_yukle), .mar_hedef(k.mar_hedef), .mar_kaynak(k.mar_kaynak),
        .zn_kaynak(k.zn_kaynak), .lvf_luf_kestirme(k.lvf_luf_kestirme), .tf_yaz(k.tf_yaz),
        .meallow_yaz(k.meallow_yaz), .meallow_deger(k.meallow_deger), .msetflg(k.msetflg), .mstf_yukle(k.mstf_yukle),
        .bellek_yaz(k.bellek_yaz), .yaz_veri(k.yaz_veri), .yaz_adres_arti2(k.yaz_adres_arti2),
        .mr0_out(mr0), .mr1_out(mr1), .mr2_out(mr2), .mr3_out(mr3), .rnd32(rnd32),
        .gorunen_5(gorunen_5), .gorunen_32(gorunen_32), .dur_exe(dur_exe), .dondur(dondur),
        .e_yaz1(x_e_yaz1), .e_hedef1(x_e_hedef1), .e_veri1(x_e_veri1), .e_yaz2(x_e_yaz2), .e_hedef2(x_e_hedef2),
        .e_veri_2(x_e_veri_2), .mar_veri(mar_veri), .mar_sec(mar_sec), .mar_en(mar_en),
        .e_mstf_veri(x_mstf_veri), .e_mstf_maske(x_mstf_maske),
        .w_gecerli(w_gecerli), .w_pc(w_pc), .w_bellek_yaz(w_bellek_yaz), .w_adr(w_adr), .w_veri(w_veri),
        .result_topla(result_topla), .lvf_topla(lvf_topla), .luf_topla(luf_topla), .valid_topla(valid_topla),
        .hedef_mr_out_topla(hedef_mr_out_topla), .result_carp(result_carp), .lvf_carp(lvf_carp), .luf_carp(luf_carp),
        .valid_carp(valid_carp), .hedef_mr_out_carp(hedef_mr_out_carp));

    logic kur = 0, kur_mstf = 0; logic [1:0] kur_mr = 0; logic [31:0] kur_deger = 0; logic [18:0] kur_mstf_veri = 0;

    Write WR(.clk(clk), .rst_n(rst_n),
        .w_gecerli(w_gecerli), .w_pc(w_pc), .w_bellek_yaz(w_bellek_yaz), .w_adr(w_adr), .w_veri(w_veri),
        .e_yaz1(kur ? 1'b1 : x_e_yaz1), .e_hedef1(kur ? kur_mr : x_e_hedef1), .e_veri1(kur ? kur_deger : x_e_veri1),
        .e_yaz2(kur ? 1'b0 : x_e_yaz2), .e_hedef2(x_e_hedef2), .e_veri_2(x_e_veri_2),
        .e_mstf_veri(kur_mstf ? kur_mstf_veri : x_mstf_veri), .e_mstf_maske(kur_mstf ? 19'h7FFFF : x_mstf_maske),
        .result_topla(result_topla), .lvf_topla(lvf_topla), .luf_topla(luf_topla), .valid_topla(valid_topla),
        .hedef_mr_out_topla(hedef_mr_out_topla), .result_carp(result_carp), .lvf_carp(lvf_carp), .luf_carp(luf_carp),
        .valid_carp(valid_carp), .hedef_mr_out_carp(hedef_mr_out_carp),
        .r2e_gecerli(gecerli), .okunan_mr(k.okunan_mr), .rpc_en(rpc_en), .rpc_deger(rpc_deger),
        .dondur(dondur), .tumu_temizle(tumu_temizle),
        .mr0_out(mr0), .mr1_out(mr1), .mr2_out(mr2), .mr3_out(mr3),
        .mstf(mstf), .rnd32(rnd32), .rpc(rpc), .gorunen_5(gorunen_5), .gorunen_32(gorunen_32), .dur_exe(dur_exe),
        .w_blok(w_blok), .w_ram_adr(w_ram_adr), .w_wr_en(w_wr_en), .w_din(w_din),
        .ew_gecerli(ew_gecerli), .ew_pc(ew_pc), .ew_bellek_yaz(ew_bellek_yaz), .ew_yaz_adr(ew_yaz_adr),
        .ew_yaz_veri(ew_yaz_veri));

    int hata = 0, kontrol = 0;
    task automatic bak(input string ad, input logic kosul);
        kontrol++;
        if (!kosul) begin hata++; $display("HATA: %s", ad); end
    endtask

    task automatic kur_mr_mstf(input logic [31:0] v0, v1, v2, v3, input logic [18:0] mv);
        logic [31:0] v [0:3];
        v[0] = v0; v[1] = v1; v[2] = v2; v[3] = v3;
        gecerli = 0; kur = 1;
        for (int i = 0; i < 4; i++) begin
            kur_mr = i[1:0]; kur_deger = v[i]; kur_mstf = (i == 0); kur_mstf_veri = mv;
            @(negedge clk);
        end
        kur = 0; kur_mstf = 0;
        @(negedge clk); @(negedge clk);          // K yazmaclari bosalsin
    endtask

    logic [31:0] eski_mstf;
    initial begin
        repeat (2) @(negedge clk); rst_n = 1;

        // 1) dondur E'de: MADD32 MR0 = MR1 + MR2 yazmamali
        kur_mr_mstf(32'h11111111, 32'd5, 32'd7, 32'h0, 19'h0);
        kelime = 32'h7CC00024; gecerli = 1; dondur = 1; #1;
        bak("dondur E: e_yaz1 = 0", x_e_yaz1 == 0);
        bak("dondur E: w_gecerli = 0", w_gecerli == 0);
        @(negedge clk); gecerli = 0; dondur = 0;
        bak("dondur E: MR0 degismedi", mr0 == 32'h11111111);
        // ayni buyruk donmadan: MR0 = 12
        kelime = 32'h7CC00024; gecerli = 1; @(negedge clk); gecerli = 0;
        bak("normal: MR0 = 12", mr0 == 32'd12);

        // 2) dondur E'de: MSETFLG (FLAG FF, VALUE 00) MSTF'ye dokunmamali
        kur_mr_mstf(0, 0, 0, 0, 19'b000000000000_1_1_1_1_1_1_1);
        eski_mstf = mstf;
        kelime = 32'h79C0FF00; gecerli = 1; dondur = 1; @(negedge clk); gecerli = 0; dondur = 0;
        bak("dondur E: MSETFLG MSTF'yi degistirmedi", mstf == eski_mstf);
        kelime = 32'h79C0FF00; gecerli = 1; @(negedge clk); gecerli = 0;
        bak("normal: MSETFLG LVF LUF NF ZF TF RND32 = 0, MEALLOW kalir", mstf == 32'h0000_0800);

        // 3) dondur E'de: MMOVI16 MAR0 yuklememeli
        kelime = 32'h7FC01234; gecerli = 1; dondur = 1; #1;
        bak("dondur E: mar_en = 0", mar_en == 0);
        dondur = 0; #1;
        bak("normal: mar_en = 1, MAR0 <= 1234", mar_en == 1 && mar_sec == 0 && mar_veri == 16'h1234);
        @(negedge clk); gecerli = 0;

        // 4) dondur W'de: tasan MMPYF32 MR3 = MR1 * MR2, K2 yazmasi ve LVF olmamali
        kur_mr_mstf(0, 32'h7F7FFFFF, 32'h7F7FFFFF, 32'hCAFEBABE, 19'h0);
        kelime = 32'h7C000027; gecerli = 1; @(negedge clk);          // E (normal)
        gecerli = 0; dondur = 1; #1;                                 // W (dondur)
        bak("W'de K2 gecerli", valid_carp == 1);
        @(negedge clk); dondur = 0;
        bak("dondur W: MR3 degismedi", mr3 == 32'hCAFEBABE);
        bak("dondur W: LVF kurulmadi", mstf[0] == 0);
        // ayni buyruk donmadan: RND32 = 0 -> en buyuk sonlu sayi, LVF = 1
        kelime = 32'h7C000027; gecerli = 1; @(negedge clk); gecerli = 0; @(negedge clk);
        bak("normal: MR3 = 0x7F7FFFFF, LVF = 1", mr3 == 32'h7F7FFFFF && mstf[0] == 1);

        // 5) dondur W'de: MMOV32 @0x8800, MR1 RAM'e yazmamali
        kelime = 32'h74D08800; ea = 16'h8800; gecerli = 1; @(negedge clk);   // E
        gecerli = 0; dondur = 1; #1;
        bak("dondur W: w_wr_en = 0", w_wr_en == 2'b00);
        dondur = 0; #1;
        bak("normal W: w_wr_en = 11, L1 adres 0, veri MR1", w_wr_en == 2'b11 && w_blok == 2'b00 && w_ram_adr == 10'd0 && w_din == mr1);
        @(negedge clk);

        // 6) D2'den RPC yazmasi
        rpc_en = 1; rpc_deger = 12'hABC; @(negedge clk); rpc_en = 0;
        bak("RPC = ABC", rpc == 12'hABC && mstf[23:12] == 12'hABC);

        // 7) RPC (D2) ile MMOV32 MSTF, mem32 (E) ayni cevrimde: E kazanir
        eski_mstf = mstf;
        kelime = 32'h77001500; ea = 16'h1500; okunan = 32'hFF12_3A4F; gecerli = 1;
        rpc_en = 1; rpc_deger = 12'h555; @(negedge clk); rpc_en = 0; gecerli = 0;
        bak("E MSTF yuklemesi D2 RPC'ye ustun", rpc == 12'h123);
        bak("MSTF yukleme: maske 0x00FFFA4F, MEALLOW korunur", mstf == ((32'hFF12_3A4F & 32'h00FF_FA4F & ~32'h0000_0800) | (eski_mstf & 32'h0000_0800)));

        // 7b) RPC (D2) ile MMOV32 mem32, MSTF (E) ayni cevrimde: golden'da D2 once calisir, saklanan MSTF yeni RPC'yi tasir
        kelime = 32'h77408800; ea = 16'h8800; gecerli = 1;
        rpc_en = 1; rpc_deger = 12'h3C5; @(negedge clk); rpc_en = 0; gecerli = 0; #1;
        bak("VERI_MSTF ayni cevrimdeki D2 RPC'sini gorur", w_wr_en == 2'b11 && w_din[23:12] == 12'h3C5 && w_din == mstf);
        @(negedge clk);

        // 8) tumu_temizle: E'deki saklama E/W'ye balon olarak girer
        kelime = 32'h74D08800; ea = 16'h8800; gecerli = 1; tumu_temizle = 1; @(negedge clk);
        gecerli = 0; tumu_temizle = 0; #1;
        bak("tumu_temizle: E/W balon, RAM yazmasi yok", ew_gecerli == 0 && w_wr_en == 2'b00);

        $display("kenar testi: %0d kontrol, %0d hata", kontrol, hata);
        $finish;
    end
endmodule
