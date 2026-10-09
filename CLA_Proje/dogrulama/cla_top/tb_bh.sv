`timescale 1ns / 1ps
// Execute + Write: art arda buyruk (boru hatti zamanlamasi) testi.
// Tezgah D2 -> R1 -> R2 -> R2/E on ucunu taklit eder (dur_exe'de hepsi tutulur,
// MAR degeri D2'den ilerlerken yakalanir). Her cevrim golden iz satiri bicimiyle basilir.
module tb_bh;
    import cla_pkg::*;

    logic clk = 0, rst_n = 0;
    always #5 clk = ~clk;

    localparam int MAKS = 512;
    logic [31:0] p_kelime [0:MAKS-1];
    logic [15:0] p_ea     [0:MAKS-1];
    logic [31:0] p_okunan [0:MAKS-1];
    logic        p_marh   [0:MAKS-1];
    int          p_n;

    // on uc yuvalari
    logic d2_v, r1_v, r2_v, e_v;
    int   d2_i, r1_i, r2_i, e_i, sonraki;
    logic [15:0] r1_mar, r2_mar, e_mar;
    logic [15:0] mar0, mar1;

    logic [31:0] kelime;
    op_e op; logic gecersiz, kip_gecersiz; alanlar_t alan; kontrol_t k;
    assign kelime = e_v ? p_kelime[e_i] : 32'h7FA00000;
    cla_decoder  DEC(.buyruk(kelime), .op(op), .gecersiz(gecersiz), .kip_gecersiz(kip_gecersiz), .alan(alan));
    cla_ctrl_gen GEN(.op(op), .alan(alan), .kip_gecersiz(kip_gecersiz), .k(k));

    logic [31:0] mr0, mr1, mr2, mr3, mstf, gorunen_32;
    logic [4:0]  gorunen_5;
    logic        rnd32, dur_exe;
    logic [11:0] rpc;
    logic        e_yaz1, e_yaz2; logic [1:0] e_hedef1, e_hedef2; logic [31:0] e_veri1, e_veri_2;
    logic [15:0] mar_veri; logic mar_sec, mar_en;
    logic [18:0] e_mstf_veri, e_mstf_maske;
    logic        w_gecerli; logic [11:0] w_pc; logic [1:0] w_bellek_yaz; logic [15:0] w_adr; logic [31:0] w_veri;
    logic [31:0] result_topla, result_carp; logic lvf_topla, luf_topla, valid_topla, lvf_carp, luf_carp, valid_carp;
    logic [1:0]  hedef_mr_out_topla, hedef_mr_out_carp;
    logic [1:0]  w_blok, w_wr_en; logic [9:0] w_ram_adr; logic [31:0] w_din;
    logic ew_gecerli; logic [11:0] ew_pc; logic [1:0] ew_bellek_yaz; logic [15:0] ew_yaz_adr; logic [31:0] ew_yaz_veri;

    Execute EX(.clk(clk), .rst_n(rst_n),
        .gecerli(e_v), .pc(12'(e_i * 2)), .ea(p_ea[e_i]), .m(alan.m), .shift(alan.shift), .okunan(p_okunan[e_i]),
        .mar_d2(e_mar), .veri_mr(alan.ra), .kosul(k.kosul), .alu(k.alu),
        .a_mr(k.a_mr), .b_mr(k.b_mr), .c_mr(k.c_mr), .d_mr(k.d_mr), .d_kaynak(k.d_kaynak),
        .exe_yaz(k.exe_yaz), .exe_hedef(k.exe_hedef), .exe_kaynak(k.exe_kaynak), .exe_kaynak_mr(k.exe_kaynak_mr),
        .exe_yaz_2(k.exe_yaz_2), .exe_hedef_2(k.exe_hedef_2), .exe_kaynak_mr_2(k.exe_kaynak_mr_2),
        .exe_kosullu(k.exe_kosullu), .mar_yukle(k.mar_yukle), .mar_hedef(k.mar_hedef), .mar_kaynak(k.mar_kaynak),
        .zn_kaynak(k.zn_kaynak), .lvf_luf_kestirme(k.lvf_luf_kestirme), .tf_yaz(k.tf_yaz),
        .meallow_yaz(k.meallow_yaz), .meallow_deger(k.meallow_deger), .msetflg(k.msetflg), .mstf_yukle(k.mstf_yukle),
        .bellek_yaz(k.bellek_yaz), .yaz_veri(k.yaz_veri), .yaz_adres_arti2(k.yaz_adres_arti2),
        .mr0_out(mr0), .mr1_out(mr1), .mr2_out(mr2), .mr3_out(mr3), .rnd32(rnd32),
        .gorunen_5(gorunen_5), .gorunen_32(gorunen_32), .dur_exe(dur_exe), .dondur(1'b0),
        .e_yaz1(e_yaz1), .e_hedef1(e_hedef1), .e_veri1(e_veri1), .e_yaz2(e_yaz2), .e_hedef2(e_hedef2), .e_veri_2(e_veri_2),
        .mar_veri(mar_veri), .mar_sec(mar_sec), .mar_en(mar_en),
        .e_mstf_veri(e_mstf_veri), .e_mstf_maske(e_mstf_maske),
        .w_gecerli(w_gecerli), .w_pc(w_pc), .w_bellek_yaz(w_bellek_yaz), .w_adr(w_adr), .w_veri(w_veri),
        .result_topla(result_topla), .lvf_topla(lvf_topla), .luf_topla(luf_topla), .valid_topla(valid_topla),
        .hedef_mr_out_topla(hedef_mr_out_topla), .result_carp(result_carp), .lvf_carp(lvf_carp), .luf_carp(luf_carp),
        .valid_carp(valid_carp), .hedef_mr_out_carp(hedef_mr_out_carp));

    Write WR(.clk(clk), .rst_n(rst_n),
        .w_gecerli(w_gecerli), .w_pc(w_pc), .w_bellek_yaz(w_bellek_yaz), .w_adr(w_adr), .w_veri(w_veri),
        .e_yaz1(e_yaz1), .e_hedef1(e_hedef1), .e_veri1(e_veri1), .e_yaz2(e_yaz2), .e_hedef2(e_hedef2), .e_veri_2(e_veri_2),
        .e_mstf_veri(e_mstf_veri), .e_mstf_maske(e_mstf_maske),
        .result_topla(result_topla), .lvf_topla(lvf_topla), .luf_topla(luf_topla), .valid_topla(valid_topla),
        .hedef_mr_out_topla(hedef_mr_out_topla), .result_carp(result_carp), .lvf_carp(lvf_carp), .luf_carp(luf_carp),
        .valid_carp(valid_carp), .hedef_mr_out_carp(hedef_mr_out_carp),
        .r2e_gecerli(e_v), .okunan_mr(k.okunan_mr), .rpc_en(1'b0), .rpc_deger(12'h000),
        .dondur(1'b0), .tumu_temizle(1'b0),
        .mr0_out(mr0), .mr1_out(mr1), .mr2_out(mr2), .mr3_out(mr3),
        .mstf(mstf), .rnd32(rnd32), .rpc(rpc), .gorunen_5(gorunen_5), .gorunen_32(gorunen_32), .dur_exe(dur_exe),
        .w_blok(w_blok), .w_ram_adr(w_ram_adr), .w_wr_en(w_wr_en), .w_din(w_din),
        .ew_gecerli(ew_gecerli), .ew_pc(ew_pc), .ew_bellek_yaz(ew_bellek_yaz), .ew_yaz_adr(ew_yaz_adr),
        .ew_yaz_veri(ew_yaz_veri));

    // ---------------- on uc ve MAR modeli
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            d2_v <= 0; r1_v <= 0; r2_v <= 0; e_v <= 0;
            d2_i <= 0; r1_i <= 0; r2_i <= 0; e_i <= 0; sonraki <= 0;
            r1_mar <= 0; r2_mar <= 0; e_mar <= 0; mar0 <= 0; mar1 <= 0;
        end else begin
            if (mar_en) begin
                if (mar_sec) mar1 <= mar_veri; else mar0 <= mar_veri;
            end
            if (!dur_exe) begin
                e_v <= r2_v;  e_i <= r2_i;  e_mar <= r2_mar;
                r2_v <= r1_v; r2_i <= r1_i; r2_mar <= r1_mar;
                r1_v <= d2_v; r1_i <= d2_i; r1_mar <= p_marh[d2_i] ? mar1 : mar0;   // D2'den ilerlerken
                if (sonraki < p_n) begin d2_v <= 1; d2_i <= sonraki; sonraki <= sonraki + 1; end
                else d2_v <= 0;
            end
        end
    end

    // ---------------- iz
    integer fp, fo, r, i, prg;
    logic [31:0] a_kelime; logic [15:0] a_ea; logic [31:0] a_ok; logic a_marh;
    logic iz_basladi, s_ev; int s_ei; logic [1:0] s_wen, s_blok; logic [9:0] s_adr; logic [31:0] s_din;
    string satir;
    logic [15:0] tam_adr;

    function automatic logic [15:0] taban(input logic [1:0] b);
        case (b) 2'b00: return 16'h8800; 2'b01: return 16'h8C00; 2'b10: return 16'h1480; default: return 16'h1500; endcase
    endfunction

    initial begin
        fp = $fopen("programlar.txt", "r");
        fo = $fopen("rtl_iz.txt", "w");
        prg = 0;
        while (!$feof(fp)) begin
            r = $fscanf(fp, "PROGRAM %d\n", p_n);
            if (r != 1) break;
            for (i = 0; i < p_n; i++) begin
                r = $fscanf(fp, "%h %h %h %h\n", a_kelime, a_ea, a_ok, a_marh);
                p_kelime[i] = a_kelime; p_ea[i] = a_ea; p_okunan[i] = a_ok; p_marh[i] = a_marh;
            end
            rst_n = 0; repeat (2) @(negedge clk); rst_n = 1;
            $fwrite(fo, "PROGRAM %0d\n", prg);
            iz_basladi = 0;
            forever begin
                @(negedge clk);
                // onceki cevrimin satiri: yakalanan E/W bilgisi + simdiki (cevrim sonu) durum
                if (iz_basladi) begin
                    if (s_wen != 2'b00) begin
                        tam_adr = taban(s_blok) + {6'b0, s_adr};
                        $fwrite(fo, "%s %08h %08h %08h %08h %04h %04h %08h %04h %08h %0d\n",
                                s_ev ? $sformatf("%03h", 12'(s_ei * 2)) : "---", mr0, mr1, mr2, mr3, mar0, mar1, mstf,
                                tam_adr, (s_wen == 2'b11) ? s_din : {16'h0, s_din[15:0]}, (s_wen == 2'b11) ? 32 : 16);
                    end else
                        $fwrite(fo, "%s %08h %08h %08h %08h %04h %04h %08h ---- -------- --\n",
                                s_ev ? $sformatf("%03h", 12'(s_ei * 2)) : "---", mr0, mr1, mr2, mr3, mar0, mar1, mstf);
                end
                if (e_v) iz_basladi = 1;
                if (iz_basladi && !e_v && !r2_v && !r1_v && !d2_v && sonraki >= p_n && !ew_gecerli &&
                    !valid_topla && !valid_carp) break;
                s_ev = e_v; s_ei = e_i; s_wen = w_wr_en; s_blok = w_blok; s_adr = w_ram_adr; s_din = w_din;
            end
            prg++;
        end
        $fclose(fo);
        $display("%0d program", prg);
        $finish;
    end
endmodule
