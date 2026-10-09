`timescale 1ns / 1ps
// Execute + Write: tek buyruk anlam testi. Her vektor:
//   kurulum (4 cevrim): MR0-MR3 ve MSTF Write'in giris portlarindan yuklenir
//   E cevrimi: buyruk R2/E'de (decoder + ctrl_gen ciktisi)
//   W cevrimi: E'de balon
//   okuma: MR, MSTF; E'de MAR yuklemesi, W'de RAM yazmasi yakalanir
module tb_ew;
    import cla_pkg::*;

    logic clk = 0, rst_n = 0;
    always #5 clk = ~clk;

    // ---------------- R2/E (tezgah surer)
    logic [31:0] kelime = 32'h7FA00000;   // MNOP
    logic        gecerli = 0;
    logic [15:0] ea = 0, mar_d2 = 0;
    logic [31:0] okunan = 0;

    op_e op; logic gecersiz, kip_gecersiz; alanlar_t alan; kontrol_t k;
    cla_decoder  DEC(.buyruk(kelime), .op(op), .gecersiz(gecersiz), .kip_gecersiz(kip_gecersiz), .alan(alan));
    cla_ctrl_gen GEN(.op(op), .alan(alan), .kip_gecersiz(kip_gecersiz), .k(k));

    // ---------------- baglantilar
    logic [31:0] mr0, mr1, mr2, mr3, mstf, gorunen_32;
    logic [4:0]  gorunen_5;
    logic        rnd32, dur_exe;
    logic [11:0] rpc;
    logic        x_e_yaz1, x_e_yaz2; logic [1:0] x_e_hedef1, x_e_hedef2; logic [31:0] x_e_veri1, x_e_veri_2;
    logic [15:0] mar_veri; logic mar_sec, mar_en;
    logic [18:0] x_mstf_veri, x_mstf_maske;
    logic        w_gecerli; logic [11:0] w_pc; logic [1:0] w_bellek_yaz; logic [15:0] w_adr; logic [31:0] w_veri;
    logic [31:0] result_topla, result_carp; logic lvf_topla, luf_topla, valid_topla, lvf_carp, luf_carp, valid_carp;
    logic [1:0]  hedef_mr_out_topla, hedef_mr_out_carp;

    Execute EX(.clk(clk), .rst_n(rst_n),
        .gecerli(gecerli), .pc(12'h000), .ea(ea), .m(alan.m), .shift(alan.shift), .okunan(okunan),
        .mar_d2(mar_d2), .veri_mr(alan.ra), .kosul(k.kosul), .alu(k.alu),
        .a_mr(k.a_mr), .b_mr(k.b_mr), .c_mr(k.c_mr), .d_mr(k.d_mr), .d_kaynak(k.d_kaynak),
        .exe_yaz(k.exe_yaz), .exe_hedef(k.exe_hedef), .exe_kaynak(k.exe_kaynak), .exe_kaynak_mr(k.exe_kaynak_mr),
        .exe_yaz_2(k.exe_yaz_2), .exe_hedef_2(k.exe_hedef_2), .exe_kaynak_mr_2(k.exe_kaynak_mr_2),
        .exe_kosullu(k.exe_kosullu), .mar_yukle(k.mar_yukle), .mar_hedef(k.mar_hedef), .mar_kaynak(k.mar_kaynak),
        .zn_kaynak(k.zn_kaynak), .lvf_luf_kestirme(k.lvf_luf_kestirme), .tf_yaz(k.tf_yaz),
        .meallow_yaz(k.meallow_yaz), .meallow_deger(k.meallow_deger), .msetflg(k.msetflg), .mstf_yukle(k.mstf_yukle),
        .bellek_yaz(k.bellek_yaz), .yaz_veri(k.yaz_veri), .yaz_adres_arti2(k.yaz_adres_arti2),
        .mr0_out(mr0), .mr1_out(mr1), .mr2_out(mr2), .mr3_out(mr3), .rnd32(rnd32),
        .gorunen_5(gorunen_5), .gorunen_32(gorunen_32), .dur_exe(dur_exe), .dondur(1'b0),
        .e_yaz1(x_e_yaz1), .e_hedef1(x_e_hedef1), .e_veri1(x_e_veri1),
        .e_yaz2(x_e_yaz2), .e_hedef2(x_e_hedef2), .e_veri_2(x_e_veri_2),
        .mar_veri(mar_veri), .mar_sec(mar_sec), .mar_en(mar_en),
        .e_mstf_veri(x_mstf_veri), .e_mstf_maske(x_mstf_maske),
        .w_gecerli(w_gecerli), .w_pc(w_pc), .w_bellek_yaz(w_bellek_yaz), .w_adr(w_adr), .w_veri(w_veri),
        .result_topla(result_topla), .lvf_topla(lvf_topla), .luf_topla(luf_topla), .valid_topla(valid_topla),
        .hedef_mr_out_topla(hedef_mr_out_topla), .result_carp(result_carp), .lvf_carp(lvf_carp), .luf_carp(luf_carp),
        .valid_carp(valid_carp), .hedef_mr_out_carp(hedef_mr_out_carp));

    // kurulum: MR ve MSTF'yi Write'in kendi giris portlarindan yukle
    logic kur = 0, kur_mstf = 0; logic [1:0] kur_mr = 0; logic [31:0] kur_deger = 0; logic [18:0] kur_mstf_veri = 0;

    logic [1:0] w_blok, w_wr_en; logic [9:0] w_ram_adr; logic [31:0] w_din;
    logic ew_gecerli; logic [11:0] ew_pc; logic [1:0] ew_bellek_yaz; logic [15:0] ew_yaz_adr; logic [31:0] ew_yaz_veri;

    Write WR(.clk(clk), .rst_n(rst_n),
        .w_gecerli(w_gecerli), .w_pc(w_pc), .w_bellek_yaz(w_bellek_yaz), .w_adr(w_adr), .w_veri(w_veri),
        .e_yaz1(kur ? 1'b1 : x_e_yaz1), .e_hedef1(kur ? kur_mr : x_e_hedef1), .e_veri1(kur ? kur_deger : x_e_veri1),
        .e_yaz2(kur ? 1'b0 : x_e_yaz2), .e_hedef2(x_e_hedef2), .e_veri_2(x_e_veri_2),
        .e_mstf_veri(kur_mstf ? kur_mstf_veri : x_mstf_veri), .e_mstf_maske(kur_mstf ? 19'h7FFFF : x_mstf_maske),
        .result_topla(result_topla), .lvf_topla(lvf_topla), .luf_topla(luf_topla), .valid_topla(valid_topla),
        .hedef_mr_out_topla(hedef_mr_out_topla), .result_carp(result_carp), .lvf_carp(lvf_carp), .luf_carp(luf_carp),
        .valid_carp(valid_carp), .hedef_mr_out_carp(hedef_mr_out_carp),
        .r2e_gecerli(gecerli), .okunan_mr(k.okunan_mr), .rpc_en(1'b0), .rpc_deger(12'h000),
        .dondur(1'b0), .tumu_temizle(1'b0),
        .mr0_out(mr0), .mr1_out(mr1), .mr2_out(mr2), .mr3_out(mr3),
        .mstf(mstf), .rnd32(rnd32), .rpc(rpc), .gorunen_5(gorunen_5), .gorunen_32(gorunen_32), .dur_exe(dur_exe),
        .w_blok(w_blok), .w_ram_adr(w_ram_adr), .w_wr_en(w_wr_en), .w_din(w_din),
        .ew_gecerli(ew_gecerli), .ew_pc(ew_pc), .ew_bellek_yaz(ew_bellek_yaz), .ew_yaz_adr(ew_yaz_adr),
        .ew_yaz_veri(ew_yaz_veri));

    // ---------------- vektorler
    integer fv, fo, n, i, r;
    logic [31:0] v_kelime, v_mr [0:3], v_mstf, v_okunan; logic [15:0] v_mar_d2, v_ea;
    logic        c_mar_en, c_mar_sec; logic [15:0] c_mar_veri;
    logic [1:0]  c_wr_en, c_blok; logic [9:0] c_adr; logic [31:0] c_din;
    logic        dur_goruldu;

    initial begin
        fv = $fopen("vektorler.txt", "r");
        fo = $fopen("rtl_sonuc.txt", "w");
        repeat (2) @(negedge clk);
        rst_n = 1;
        n = 0;
        while (!$feof(fv)) begin
            r = $fscanf(fv, "%h %h %h %h %h %h %h %h %h\n", v_kelime, v_mr[0], v_mr[1], v_mr[2], v_mr[3],
                        v_mstf, v_mar_d2, v_ea, v_okunan);
            if (r != 9) break;
            // kurulum
            gecerli = 0; kur = 1;
            for (i = 0; i < 4; i++) begin
                kur_mr = i[1:0]; kur_deger = v_mr[i];
                kur_mstf = (i == 0);
                kur_mstf_veri = {v_mstf[23:12], v_mstf[11], v_mstf[9], v_mstf[6], v_mstf[3], v_mstf[2], v_mstf[1], v_mstf[0]};
                @(negedge clk);
            end
            kur = 0; kur_mstf = 0;
            // E cevrimi
            kelime = v_kelime; ea = v_ea; mar_d2 = v_mar_d2; okunan = v_okunan; gecerli = 1;
            #1;
            c_mar_en = mar_en; c_mar_sec = mar_sec; c_mar_veri = mar_veri;
            dur_goruldu = dur_exe;
            @(negedge clk);
            // W cevrimi (E'de balon)
            gecerli = 0;
            #1;
            c_wr_en = w_wr_en; c_blok = w_blok; c_adr = w_ram_adr; c_din = w_din;
            dur_goruldu = dur_goruldu | dur_exe;
            @(negedge clk);
            $fwrite(fo, "%08h %08h %08h %08h %08h %0d %0d %04h %0d %0d %03h %08h %0d\n", mr0, mr1, mr2, mr3, mstf,
                    c_mar_en, c_mar_sec, c_mar_veri, c_wr_en, c_blok, c_adr, c_din, dur_goruldu);
            n++;
        end
        $fclose(fo);
        $display("%0d vektor", n);
        $finish;
    end
endmodule
