`timescale 1ns / 1ps
// Yalniz zamanlama olcumu icin: ALU'nun butun giris ve cikislari yazmacli.
// Boylece kombinasyonel birimlerin (EXE) ve FPU K1/K2'nin gecikmesi
// yazmactan yazmaca yol olarak raporlanir. Tasarimda KULLANILMAZ.
module ALU_zamanlama (
  input  logic        clk,
  input  logic        rst,
  input  logic [31:0] a_i, b_i, c_i, d_i,
  input  logic [4:0]  topla_i, carpma_i,
  input  logic [2:0]  tamsayi_i,
  input  logic        kestirme_i,
  input  logic [6:0]  karsilastirma_i,
  input  logic [4:0]  mstf_i, donusum_i,
  input  logic [19:0] mux_i,
  output logic [31:0] topla_o, carp_o, tamsayi_o, kestirme_o, karsilastirma_o, donusum_o,
  output logic [18:0] bayrak_o
);
  logic [31:0] a, b, c, d;
  logic [4:0]  topla_cntrl, carpma_cntrl, mstf_in, donusum_cntrl;
  logic [2:0]  tamsayi_cntrl;
  logic        kestirme_cntrl;
  logic [6:0]  karsilastirma_cntrl;
  logic [19:0] mx;
  wire         lvf_topla, luf_topla, lvf_carp, luf_carp, lvf_kestirme, luf_kestirme;
  wire  [31:0] result_kestirme, result_topla, result_carp, result_tamsayi, result_karsilastirma, result_donusum;
  wire  [4:0]  mstf_out;
  wire         zf_karsilastirma, nf_karsilastirma, valid_carp, valid_topla;
  wire  [1:0]  hedef_mr_out_carp, hedef_mr_out_topla;

  always_ff @(posedge clk) begin
    a <= a_i; b <= b_i; c <= c_i; d <= d_i;
    topla_cntrl <= topla_i; carpma_cntrl <= carpma_i; tamsayi_cntrl <= tamsayi_i;
    kestirme_cntrl <= kestirme_i; karsilastirma_cntrl <= karsilastirma_i;
    mstf_in <= mstf_i; donusum_cntrl <= donusum_i; mx <= mux_i;
  end

  ALU u_alu (
    .clk(clk), .rst(rst), .a(a), .b(b), .c(c), .d(d),
    .topla_cntrl(topla_cntrl), .carpma_cntrl(carpma_cntrl), .tamsayi_cntrl(tamsayi_cntrl),
    .kestirme_cntrl(kestirme_cntrl), .karsilastirma_cntrl(karsilastirma_cntrl), .mstf_in(mstf_in),
    .donusum_cntrl(donusum_cntrl),
    .mux_1(mx[1:0]), .mux_2(mx[3:2]), .mux_3(mx[5:4]), .mux_4(mx[7:6]), .mux_5(mx[9:8]),
    .mux_6(mx[11:10]), .mux_7(mx[13:12]), .mux_8(mx[15:14]), .mux_9(mx[17:16]), .mux_10(mx[19:18]),
    .lvf_topla(lvf_topla), .luf_topla(luf_topla), .lvf_carp(lvf_carp), .luf_carp(luf_carp),
    .result_kestirme(result_kestirme), .lvf_kestirme(lvf_kestirme), .luf_kestirme(luf_kestirme),
    .result_topla(result_topla), .result_carp(result_carp), .result_tamsayi(result_tamsayi),
    .mstf_out(mstf_out), .result_karsilastirma(result_karsilastirma),
    .zf_karsilastirma(zf_karsilastirma), .nf_karsilastirma(nf_karsilastirma),
    .result_donusum(result_donusum), .valid_carp(valid_carp), .hedef_mr_out_carp(hedef_mr_out_carp),
    .valid_topla(valid_topla), .hedef_mr_out_topla(hedef_mr_out_topla));

  always_ff @(posedge clk) begin
    topla_o <= result_topla; carp_o <= result_carp; tamsayi_o <= result_tamsayi;
    kestirme_o <= result_kestirme; karsilastirma_o <= result_karsilastirma; donusum_o <= result_donusum;
    bayrak_o <= {lvf_topla, luf_topla, lvf_carp, luf_carp, lvf_kestirme, luf_kestirme, mstf_out,
                 zf_karsilastirma, nf_karsilastirma, valid_carp, hedef_mr_out_carp, valid_topla,
                 hedef_mr_out_topla};
  end
endmodule
