`timescale 1ns / 1ps

// CLA ust modulu : F1 F2 D1 D2 R1 R2 E W boru hatti, gorev denetimi, MAR, MPC, L1/L2 veri RAM'leri.
// Mesaj RAM'leri (M2C, C2M) disarida durur (kopru: cla_kopru_cekirdek ile ayni arayuz).

module CLA_Top
    import cla_pkg::*;
#(
                parameter string PROGRAM_HEX = ""       // L3 : satir basina 16 bit, alt adres once
)(
                input logic clk ,
                input logic rst_n ,

                //////////////CPU : gorev yazmaclari (0 MIFR, 1 MIOVF, 2 MICLR, 3 MICLROVF, 4 MIFRC, 5 MIER, 6 MIRUN, 7 MCTL)
                input logic cpu_wr_en ,
                input logic [2:0]cpu_reg_addr ,
                input logic [15:0]cpu_wr_data ,
                output logic [15:0]cpu_rd_data ,

                //////////////CPU : MVECT1-8
                input logic mvect_wr_en ,
                input logic [2:0]mvect_gorev ,
                input logic [15:0]mvect_veri ,
                output logic [15:0]mvect_oku ,

                //////////////cevre birimi tetikleri
                input logic [7:0]hw_task_trig ,

                //////////////CPU'ya
                output logic [7:0]pie_kesme ,
                output logic [15:0]mirun ,
                output logic bosta ,                     // gorev yok ve boru hatti bosaldi (golden gorev sonu)

                //////////////mesaj RAM'leri
                output logic [6:0]m2c_addr ,
                output logic [1:0]m2c_rd_en ,
                input logic [31:0]m2c_dout ,
                output logic [6:0]c2m_addr ,
                output logic [1:0]c2m_wr_en ,
                output logic [1:0]c2m_rd_en ,
                output logic [31:0]c2m_din ,
                input logic [31:0]c2m_dout

                );



/////////////////////////SINYALLER

// gorev denetimi
logic [7:0]bekleyen;
logic softreset;
logic hardreset;
logic gorev_basla;
logic [2:0]gorev_no;
logic gorev_bitti;
logic getir_izin;
logic on_temizle;
logic tumu_temizle;
logic dondur;
logic calisiyor;
logic [2:0]aktif_gorev;
logic [15:0]mvect_hedef;
logic [11:0]mvect_pc;

// boru hatti denetimi
logic dur_exe;
logic dur_r1;
logic dondur_q;
logic on_en;
logic arka_en;
logic on_balon;

// F1, F2, D1
logic [10:0]l3_adr;
logic f1f2_gecerli;
logic [11:0]f1f2_pc;
logic f2d1_gecerli;
logic [11:0]f2d1_pc;
logic [31:0]f2d1_kelime;
logic d1d2_gecerli;
logic [11:0]d1d2_pc;
logic [31:0]d1d2_kelime;
op_e d1d2_op;
alanlar_t d1d2_alan;
logic d1d2_kip_gecersiz;

// D2
logic dal_alindi;
logic [11:0]dal_hedef;
logic mar_artis_en;
logic mar_artis_sec;
logic [15:0]mar_artis_deger;
logic rpc_en;
logic [11:0]rpc_deger;
logic d2_gecerli;
logic d2_mstop;
logic d2_gecersiz;
logic mpc_en;
logic [11:0]mpc_deger;
logic d2r1_gecerli;
logic [11:0]d2r1_pc;
logic [31:0]d2r1_kelime;
kontrol_t d2r1_k;
logic [15:0]d2r1_ea;
logic [15:0]d2r1_m;
logic [5:0]d2r1_shift;
logic [1:0]d2r1_veri_mr;
logic [15:0]d2r1_mar_d2;

// R1, L1, L2
logic [9:0]l1_addr;
logic [1:0]l1_wr_en;
logic [1:0]l1_rd_en;
logic [31:0]l1_din;
logic [31:0]l1_dout;
logic [9:0]l2_addr;
logic [1:0]l2_wr_en;
logic [1:0]l2_rd_en;
logic [31:0]l2_din;
logic [31:0]l2_dout;
logic r1r2_gecerli;
logic [11:0]r1r2_pc;
logic [31:0]r1r2_kelime;
kontrol_t r1r2_k;
logic [15:0]r1r2_ea;
logic [15:0]r1r2_m;
logic [5:0]r1r2_shift;
logic [1:0]r1r2_veri_mr;
logic [15:0]r1r2_mar_d2;

// R2/E
logic r2e_gecerli;
logic [11:0]r2e_pc;
logic [31:0]r2e_kelime;
kontrol_t r2e_k;
logic [15:0]r2e_ea;
logic [15:0]r2e_m;
logic [5:0]r2e_shift;
logic [1:0]r2e_veri_mr;
logic [15:0]r2e_mar_d2;
logic [31:0]r2e_okunan;

// E <-> W
logic [31:0]mr0_out;
logic [31:0]mr1_out;
logic [31:0]mr2_out;
logic [31:0]mr3_out;
logic [31:0]mstf;
logic rnd32;
logic [11:0]rpc;
logic [4:0]gorunen_5;
logic [31:0]gorunen_32;
logic e_yaz1;
logic [1:0]e_hedef1;
logic [31:0]e_veri1;
logic e_yaz2;
logic [1:0]e_hedef2;
logic [31:0]e_veri_2;
logic [15:0]mar_veri;
logic mar_sec;
logic mar_en;
logic [18:0]e_mstf_veri;
logic [18:0]e_mstf_maske;
logic w_gecerli;
logic [11:0]w_pc;
logic [1:0]w_bellek_yaz;
logic [15:0]w_adr;
logic [31:0]w_veri;
logic [31:0]result_topla;
logic lvf_topla;
logic luf_topla;
logic valid_topla;
logic [1:0]hedef_mr_out_topla;
logic [31:0]result_carp;
logic lvf_carp;
logic luf_carp;
logic valid_carp;
logic [1:0]hedef_mr_out_carp;
logic [1:0]w_blok;
logic [9:0]w_ram_adr;
logic [1:0]w_wr_en;
logic [31:0]w_din;
logic ew_gecerli;
logic [11:0]ew_pc;
logic [1:0]ew_bellek_yaz;
logic [15:0]ew_yaz_adr;
logic [31:0]ew_yaz_veri;

// durum
logic [15:0]mar0;
logic [15:0]mar1;
logic [11:0]mpc;
logic [15:0]mifr_out;
logic [15:0]miovf_out;
logic [15:0]mier_out;



/////////////////////////GOREV YAZMACLARI, MVECT, GOREV DENETCISI

Gorev_Yazmaclari GY(.clk(clk) , .rst_n(rst_n) ,
        .cpu_wr_en(cpu_wr_en) , .cpu_reg_addr(cpu_reg_addr) , .cpu_wr_data(cpu_wr_data) , .cpu_rd_data(cpu_rd_data) ,
        .hw_task_trig(hw_task_trig) , .gorev_basla(gorev_basla) , .gorev_no(gorev_no) , .gorev_bitti(gorev_bitti) ,
        .bekleyen(bekleyen) , .softreset(softreset) , .hardreset(hardreset) ,
        .mifr_out(mifr_out) , .miovf_out(miovf_out) , .mier_out(mier_out) , .mirun_out(mirun));

cla_mvect_regs MV(.clk(clk) , .rst_n(rst_n) ,
        .cpu_wr_en(mvect_wr_en) , .cpu_wr_task_id(mvect_gorev) , .cpu_wr_data(mvect_veri) , .cpu_rd_data(mvect_oku) ,
        .active_task_id(gorev_basla ? gorev_no : aktif_gorev) , .target_pc_out(mvect_hedef));    // bekleyen baslamada aktif_gorev

assign mvect_pc = mvect_hedef[11:0];                    // MPC 12 bit

cla_gorev_denetci GD(.clk(clk) , .rst_n(rst_n) ,
        .bekleyen(bekleyen) , .softreset(softreset) , .hardreset(hardreset) ,
        .d2_gecerli(d2_gecerli) , .d2_mstop(d2_mstop) , .d2_gecersiz(d2_gecersiz) ,
        .gorev_basla(gorev_basla) , .gorev_no(gorev_no) , .gorev_bitti(gorev_bitti) , .pie_kesme(pie_kesme) ,
        .getir_izin(getir_izin) , .on_temizle(on_temizle) , .tumu_temizle(tumu_temizle) , .dondur(dondur) ,
        .calisiyor(calisiyor) , .aktif_gorev(aktif_gorev));



/////////////////////////BORU HATTI DENETIMI

// gecersiz buyrugun D2'de goruldugu cevrim tamamlanir, sonraki cevrimden itibaren her sey durur (golden)

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) dondur_q <= 1'b0;
    else dondur_q <= dondur;

end

assign on_en = ~(dur_exe | dur_r1 | dondur_q);          // F1, F1/F2, F2/D1, D1/D2, D2/R1
assign arka_en = ~(dur_exe | dondur_q);                 // R1/R2, R2/E (dur_r1'de R1/R2'ye balon)
assign on_balon = on_temizle | tumu_temizle;            // MSTOP D2'de : F1-D1'dekiler ve MSTOP silinir



/////////////////////////GOREV GECISI

// golden yeni gorevi MSTOP balonu R2/E'ye gectigi cevrimde baslatir (MSTOP D2'de n ise durmasiz n+2).
// denetci n+2'de sabit baslatir : n+1 , n+2'deki her dur_exe kadar baslama (F1 , MPC) ve getirme burada bekler.

logic mstop_d2r1;                                       // MSTOP balonu D2/R1'de
logic mstop_r1r2;                                       // MSTOP balonu R1/R2'de
logic bosaliyor;                                        // eski gorevin MSTOP balonu R2/E'ye henuz gecmedi
logic basla_bekliyor;                                   // denetci baslatti , boru hattinin bosalmasi bekleniyor
logic gorev_basla_e;                                    // golden ile ayni cevrimde baslama
logic getir_izin_e;

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        mstop_d2r1 <= 1'b0;
        mstop_r1r2 <= 1'b0;
        basla_bekliyor <= 1'b0;
    end
    else if(tumu_temizle) begin
        mstop_d2r1 <= 1'b0;
        mstop_r1r2 <= 1'b0;
        basla_bekliyor <= 1'b0;
    end
    else begin
        if(on_en) mstop_d2r1 <= d2_gecerli & d2_mstop;
        if(arka_en) mstop_r1r2 <= mstop_d2r1 & ~dur_r1;
        basla_bekliyor <= (gorev_basla | basla_bekliyor) & bosaliyor;
    end

end

assign bosaliyor = mstop_d2r1 | (mstop_r1r2 & ~arka_en);
assign gorev_basla_e = (gorev_basla | basla_bekliyor) & ~bosaliyor;
assign getir_izin_e = getir_izin & ~basla_bekliyor;     // baslama cevriminde getirme yok , ilk F1 sonraki cevrim



/////////////////////////F1

Fetch1 F1(.clk(clk) , .rst_n(rst_n) ,
        .getir_izin(getir_izin_e) , .gorev_basla(gorev_basla_e) , .mvect_pc(mvect_pc) ,
        .dal_alindi(dal_alindi) , .dal_hedef(dal_hedef) ,
        .en(on_en) , .balon(on_balon) ,
        .l3_adr(l3_adr) , .f1f2_gecerli(f1f2_gecerli) , .f1f2_pc(f1f2_pc));



/////////////////////////F2

Fetch2 #(.PROGRAM_HEX(PROGRAM_HEX)) F2(.clk(clk) , .rst_n(rst_n) ,
        .l3_adr(l3_adr) , .l3_en(on_en) , .f1f2_gecerli(f1f2_gecerli) , .f1f2_pc(f1f2_pc) ,
        .en(on_en) , .balon(on_balon) ,
        .f2d1_gecerli(f2d1_gecerli) , .f2d1_pc(f2d1_pc) , .f2d1_kelime(f2d1_kelime));



/////////////////////////D1

Decode1 D1(.clk(clk) , .rst_n(rst_n) ,
        .f2d1_gecerli(f2d1_gecerli) , .f2d1_pc(f2d1_pc) , .f2d1_kelime(f2d1_kelime) ,
        .en(on_en) , .balon(on_balon) ,
        .d1d2_gecerli(d1d2_gecerli) , .d1d2_pc(d1d2_pc) , .d1d2_kelime(d1d2_kelime) ,
        .d1d2_op(d1d2_op) , .d1d2_alan(d1d2_alan) , .d1d2_kip_gecersiz(d1d2_kip_gecersiz));



/////////////////////////D2

Decode2 D2(.clk(clk) , .rst_n(rst_n) ,
        .d1d2_gecerli(d1d2_gecerli) , .d1d2_pc(d1d2_pc) , .d1d2_kelime(d1d2_kelime) ,
        .d1d2_op(d1d2_op) , .d1d2_alan(d1d2_alan) , .d1d2_kip_gecersiz(d1d2_kip_gecersiz) ,
        .mar0(mar0) , .mar1(mar1) , .rpc(rpc) , .gorunen_5(gorunen_5) ,
        .dur_exe(dur_exe) , .dur_r1(dur_r1) , .dondur(dondur_q) , .en(on_en) , .balon(on_balon) ,
        .dal_alindi(dal_alindi) , .dal_hedef(dal_hedef) ,
        .mar_artis_en(mar_artis_en) , .mar_artis_sec(mar_artis_sec) , .mar_artis_deger(mar_artis_deger) ,
        .rpc_en(rpc_en) , .rpc_deger(rpc_deger) ,
        .d2_gecerli(d2_gecerli) , .d2_mstop(d2_mstop) , .d2_gecersiz(d2_gecersiz) ,
        .mpc_en(mpc_en) , .mpc_deger(mpc_deger) ,
        .d2r1_gecerli(d2r1_gecerli) , .d2r1_pc(d2r1_pc) , .d2r1_kelime(d2r1_kelime) , .d2r1_k(d2r1_k) ,
        .d2r1_ea(d2r1_ea) , .d2r1_m(d2r1_m) , .d2r1_shift(d2r1_shift) , .d2r1_veri_mr(d2r1_veri_mr) ,
        .d2r1_mar_d2(d2r1_mar_d2));



/////////////////////////R1 ve L1, L2 VERI RAM'LERI

Read1 R1(.clk(clk) , .rst_n(rst_n) ,
        .d2r1_gecerli(d2r1_gecerli) , .d2r1_pc(d2r1_pc) , .d2r1_kelime(d2r1_kelime) , .d2r1_k(d2r1_k) ,
        .d2r1_ea(d2r1_ea) , .d2r1_m(d2r1_m) , .d2r1_shift(d2r1_shift) , .d2r1_veri_mr(d2r1_veri_mr) ,
        .d2r1_mar_d2(d2r1_mar_d2) ,
        .w_blok(w_blok) , .w_ram_adr(w_ram_adr) , .w_wr_en(w_wr_en) , .w_din(w_din) ,
        .dur_exe(dur_exe) , .dondur(dondur_q) , .en(arka_en) , .tumu_temizle(tumu_temizle) ,
        .dur_r1(dur_r1) ,
        .l1_addr(l1_addr) , .l1_wr_en(l1_wr_en) , .l1_rd_en(l1_rd_en) , .l1_din(l1_din) ,
        .l2_addr(l2_addr) , .l2_wr_en(l2_wr_en) , .l2_rd_en(l2_rd_en) , .l2_din(l2_din) ,
        .c2m_addr(c2m_addr) , .c2m_wr_en(c2m_wr_en) , .c2m_rd_en(c2m_rd_en) , .c2m_din(c2m_din) ,
        .m2c_addr(m2c_addr) , .m2c_rd_en(m2c_rd_en) ,
        .r1r2_gecerli(r1r2_gecerli) , .r1r2_pc(r1r2_pc) , .r1r2_kelime(r1r2_kelime) , .r1r2_k(r1r2_k) ,
        .r1r2_ea(r1r2_ea) , .r1r2_m(r1r2_m) , .r1r2_shift(r1r2_shift) , .r1r2_veri_mr(r1r2_veri_mr) ,
        .r1r2_mar_d2(r1r2_mar_d2));

cla_data_ram #(.ADDR_WIDTH(10)) L1(.clk(clk) , .addr(l1_addr) , .wr_en(l1_wr_en) , .rd_en(l1_rd_en) ,
        .din(l1_din) , .dout(l1_dout));                 // 0x8800 - 0x8BFF

cla_data_ram #(.ADDR_WIDTH(10)) L2(.clk(clk) , .addr(l2_addr) , .wr_en(l2_wr_en) , .rd_en(l2_rd_en) ,
        .din(l2_din) , .dout(l2_dout));                 // 0x8C00 - 0x8FFF



/////////////////////////R2

Read2 R2(.clk(clk) , .rst_n(rst_n) ,
        .r1r2_gecerli(r1r2_gecerli) , .r1r2_pc(r1r2_pc) , .r1r2_kelime(r1r2_kelime) , .r1r2_k(r1r2_k) ,
        .r1r2_ea(r1r2_ea) , .r1r2_m(r1r2_m) , .r1r2_shift(r1r2_shift) , .r1r2_veri_mr(r1r2_veri_mr) ,
        .r1r2_mar_d2(r1r2_mar_d2) ,
        .l1_dout(l1_dout) , .l2_dout(l2_dout) , .c2m_dout(c2m_dout) , .m2c_dout(m2c_dout) ,
        .en(arka_en) , .tumu_temizle(tumu_temizle) ,
        .r2e_gecerli(r2e_gecerli) , .r2e_pc(r2e_pc) , .r2e_kelime(r2e_kelime) , .r2e_k(r2e_k) ,
        .r2e_ea(r2e_ea) , .r2e_m(r2e_m) , .r2e_shift(r2e_shift) , .r2e_veri_mr(r2e_veri_mr) ,
        .r2e_mar_d2(r2e_mar_d2) , .r2e_okunan(r2e_okunan));



/////////////////////////E

Execute EX(.clk(clk) , .rst_n(rst_n) ,
        .gecerli(r2e_gecerli) , .pc(r2e_pc) , .ea(r2e_ea) , .m(r2e_m) , .shift(r2e_shift) , .okunan(r2e_okunan) ,
        .mar_d2(r2e_mar_d2) , .veri_mr(r2e_veri_mr) , .kosul(r2e_k.kosul) , .alu(r2e_k.alu) ,
        .a_mr(r2e_k.a_mr) , .b_mr(r2e_k.b_mr) , .c_mr(r2e_k.c_mr) , .d_mr(r2e_k.d_mr) , .d_kaynak(r2e_k.d_kaynak) ,
        .exe_yaz(r2e_k.exe_yaz) , .exe_hedef(r2e_k.exe_hedef) , .exe_kaynak(r2e_k.exe_kaynak) ,
        .exe_kaynak_mr(r2e_k.exe_kaynak_mr) , .exe_yaz_2(r2e_k.exe_yaz_2) , .exe_hedef_2(r2e_k.exe_hedef_2) ,
        .exe_kaynak_mr_2(r2e_k.exe_kaynak_mr_2) , .exe_kosullu(r2e_k.exe_kosullu) ,
        .mar_yukle(r2e_k.mar_yukle) , .mar_hedef(r2e_k.mar_hedef) , .mar_kaynak(r2e_k.mar_kaynak) ,
        .zn_kaynak(r2e_k.zn_kaynak) , .lvf_luf_kestirme(r2e_k.lvf_luf_kestirme) , .tf_yaz(r2e_k.tf_yaz) ,
        .meallow_yaz(r2e_k.meallow_yaz) , .meallow_deger(r2e_k.meallow_deger) , .msetflg(r2e_k.msetflg) ,
        .mstf_yukle(r2e_k.mstf_yukle) , .bellek_yaz(r2e_k.bellek_yaz) , .yaz_veri(r2e_k.yaz_veri) ,
        .yaz_adres_arti2(r2e_k.yaz_adres_arti2) ,
        .mr0_out(mr0_out) , .mr1_out(mr1_out) , .mr2_out(mr2_out) , .mr3_out(mr3_out) , .rnd32(rnd32) ,
        .gorunen_5(gorunen_5) , .gorunen_32(gorunen_32) , .dur_exe(dur_exe) , .dondur(dondur_q) ,
        .e_yaz1(e_yaz1) , .e_hedef1(e_hedef1) , .e_veri1(e_veri1) ,
        .e_yaz2(e_yaz2) , .e_hedef2(e_hedef2) , .e_veri_2(e_veri_2) ,
        .mar_veri(mar_veri) , .mar_sec(mar_sec) , .mar_en(mar_en) ,
        .e_mstf_veri(e_mstf_veri) , .e_mstf_maske(e_mstf_maske) ,
        .w_gecerli(w_gecerli) , .w_pc(w_pc) , .w_bellek_yaz(w_bellek_yaz) , .w_adr(w_adr) , .w_veri(w_veri) ,
        .result_topla(result_topla) , .lvf_topla(lvf_topla) , .luf_topla(luf_topla) , .valid_topla(valid_topla) ,
        .hedef_mr_out_topla(hedef_mr_out_topla) ,
        .result_carp(result_carp) , .lvf_carp(lvf_carp) , .luf_carp(luf_carp) , .valid_carp(valid_carp) ,
        .hedef_mr_out_carp(hedef_mr_out_carp));



/////////////////////////W

Write WR(.clk(clk) , .rst_n(rst_n) ,
        .w_gecerli(w_gecerli) , .w_pc(w_pc) , .w_bellek_yaz(w_bellek_yaz) , .w_adr(w_adr) , .w_veri(w_veri) ,
        .e_yaz1(e_yaz1) , .e_hedef1(e_hedef1) , .e_veri1(e_veri1) ,
        .e_yaz2(e_yaz2) , .e_hedef2(e_hedef2) , .e_veri_2(e_veri_2) ,
        .e_mstf_veri(e_mstf_veri) , .e_mstf_maske(e_mstf_maske) ,
        .result_topla(result_topla) , .lvf_topla(lvf_topla) , .luf_topla(luf_topla) , .valid_topla(valid_topla) ,
        .hedef_mr_out_topla(hedef_mr_out_topla) ,
        .result_carp(result_carp) , .lvf_carp(lvf_carp) , .luf_carp(luf_carp) , .valid_carp(valid_carp) ,
        .hedef_mr_out_carp(hedef_mr_out_carp) ,
        .r2e_gecerli(r2e_gecerli) , .okunan_mr(r2e_k.okunan_mr) ,
        .rpc_en(rpc_en) , .rpc_deger(rpc_deger) ,
        .dondur(dondur_q) , .tumu_temizle(tumu_temizle) ,
        .mr0_out(mr0_out) , .mr1_out(mr1_out) , .mr2_out(mr2_out) , .mr3_out(mr3_out) ,
        .mstf(mstf) , .rnd32(rnd32) , .rpc(rpc) , .gorunen_5(gorunen_5) , .gorunen_32(gorunen_32) ,
        .dur_exe(dur_exe) ,
        .w_blok(w_blok) , .w_ram_adr(w_ram_adr) , .w_wr_en(w_wr_en) , .w_din(w_din) ,
        .ew_gecerli(ew_gecerli) , .ew_pc(ew_pc) , .ew_bellek_yaz(ew_bellek_yaz) , .ew_yaz_adr(ew_yaz_adr) ,
        .ew_yaz_veri(ew_yaz_veri));



/////////////////////////MAR YAZMACLARI

// D2 sonunda artis, E sonunda yukleme. Ayni MAR'a ayni cevrimde ikisi duserse artis kazanir (TRM s.579).

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        mar0 <= 16'h0000;
        mar1 <= 16'h0000;
    end
    else begin

        if(mar_artis_en && mar_artis_sec == 1'b0) mar0 <= mar_artis_deger;
        else if(mar_en && mar_sec == 1'b0) mar0 <= mar_veri;

        if(mar_artis_en && mar_artis_sec == 1'b1) mar1 <= mar_artis_deger;
        else if(mar_en && mar_sec == 1'b1) mar1 <= mar_veri;

    end

end



/////////////////////////BOSTA

// golden'in gorev sonu kosulu : calisan ve bekleyen gorev yok , R1 R2 E bos , durma yok.
// MIRUN MSTOP D2'deyken duser ; son buyruklar bundan sonra W'ye kadar akar.

assign bosta = ~calisiyor & (bekleyen == 8'h00) & ~d2r1_gecerli & ~r1r2_gecerli & ~r2e_gecerli & ~dur_exe & ~dur_r1;



/////////////////////////MPC

// D2'deki buyrugun adresi. Gorev basinda MVECT, gorevin ilk cevriminde (F1) yazilir:
// golden hakem cevriminin satirindan sonra yukler.

logic gorev_basla_q;
logic [11:0]mvect_pc_q;

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        gorev_basla_q <= 1'b0;
        mvect_pc_q <= 12'h000;
    end
    else begin
        gorev_basla_q <= gorev_basla_e;
        if(gorev_basla_e) mvect_pc_q <= mvect_pc;
    end

end

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) mpc <= 12'h000;
    else if(gorev_basla_q) mpc <= mvect_pc_q;
    else if(mpc_en) mpc <= mpc_deger;

end



endmodule
