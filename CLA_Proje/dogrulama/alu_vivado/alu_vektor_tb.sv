`timescale 1ns / 1ps
// ALU <-> Golden Model vektor testbench'i.
// Vivado xsim'de hem davranissal hem sentez sonrasi fonksiyonel simulasyonda
// ayni dosyayla kosar (sentez sonrasi netlist'te ALU'nun port adlari ayni kalir).
//
// alu_vektorler.txt satiri (onaltilik): op A B c1 c2 beklenen_sonuc beklenen_bayrak maske
//   op    : 0 MADDF32, 1 MSUBF32, 2 MMPYF32, 10..17 tamsayi_cntrl 0..7,
//           20 MEINVF32, 21 MEISQRTF32, 30..34 karsilastirma islem 0..4, 40..50 donusum op 0..10
//   c1    : FP/donusumde RND32 (bit0); MNEGF32'de CNDF.  c2: MNEGF32'de mstf_in
//   bayrak: bit0 LVF, bit1 LUF, bit2 NF, bit3 ZF
//   maske : bit0 sonuc, bit1 LVF/LUF, bit2 ZF/NF denetlenir
// Beklenen degerler golden modelden (CLA_GoldenModel/golden_model/ops_*.py).
// Simulasyon dizininde estimate_lut.hex ve alu_vektorler.txt bulunmali.
module alu_vektor_tb;
  parameter string VEKTOR  = "alu_vektorler.txt";
  parameter int    MAX_YAZ = 20;

  logic clk = 1'b0;
  logic rst = 1'b0;
  logic [31:0] a, b, c, d;
  logic [4:0]  topla_cntrl, carpma_cntrl;
  logic [2:0]  tamsayi_cntrl;
  logic        kestirme_cntrl;
  logic [6:0]  karsilastirma_cntrl;
  logic [4:0]  mstf_in, donusum_cntrl;
  logic [1:0]  mux_1, mux_2, mux_3, mux_4, mux_5, mux_6, mux_7, mux_8, mux_9, mux_10;
  wire         lvf_topla, luf_topla, lvf_carp, luf_carp, lvf_kestirme, luf_kestirme;
  wire  [31:0] result_kestirme, result_topla, result_carp, result_tamsayi;
  wire  [31:0] result_karsilastirma, result_donusum;
  wire  [4:0]  mstf_out;
  wire         zf_karsilastirma, nf_karsilastirma, valid_carp, valid_topla;
  wire  [1:0]  hedef_mr_out_carp, hedef_mr_out_topla;

  ALU dut (.*);

  always #5 clk = ~clk;

  integer fd, r, n, hata;
  logic [31:0] op, va, vb, c1, c2, er, ef, mask;
  logic [31:0] got_r;
  logic [3:0]  got_f;            // {ZF, NF, LUF, LVF}
  logic        yan, ok;
  logic [1:0]  hedef;

  initial begin
    a = '0; b = '0; c = '0; d = '0;
    topla_cntrl = '0; carpma_cntrl = '0; tamsayi_cntrl = '0; kestirme_cntrl = 1'b0;
    karsilastirma_cntrl = 7'h0F; mstf_in = '0; donusum_cntrl = '0;
    {mux_1, mux_2, mux_3, mux_4, mux_5, mux_6, mux_7, mux_8, mux_9, mux_10} = '0;
    fd = $fopen(VEKTOR, "r");
    if (fd == 0) begin
      $display("ALU_TB HATA: %s acilamadi", VEKTOR);
      $finish;
    end
    #200;                                    // sentez sonrasi sim: GSR ilk 100 ns
    rst = 1'b0;
    @(negedge clk); @(negedge clk);
    rst = 1'b1;                              // 0'da etkin, asenkron
    n = 0; hata = 0;
    while (!$feof(fd)) begin
      r = $fscanf(fd, "%h %h %h %h %h %h %h %h\n", op, va, vb, c1, c2, er, ef, mask);
      if (r != 8) break;
      @(negedge clk);
      topla_cntrl = '0; carpma_cntrl = '0;
      a = va; b = vb; c = 32'hDEADBEEF ^ n; d = ~va;
      mux_1 = 2'b00; mux_2 = 2'b01; mux_3 = 2'b00; mux_4 = 2'b01; mux_5 = 2'b00;
      mux_6 = 2'b01; mux_7 = 2'b00; mux_8 = 2'b00; mux_9 = 2'b01; mux_10 = 2'b00;
      hedef = n[1:0];
      yan = 1'b0;
      got_r = '0; got_f = '0;
      if (op == 0 || op == 1) begin
        topla_cntrl = {hedef, c1[0], 1'b1, op[0]};
        @(posedge clk); #1;
        got_r = result_topla; got_f = {2'b00, luf_topla, lvf_topla};
        if (!valid_topla || hedef_mr_out_topla != hedef || valid_carp) yan = 1'b1;
      end else if (op == 2) begin
        carpma_cntrl = {hedef, c1[0], 1'b1, 1'b0};
        @(posedge clk); #1;
        got_r = result_carp; got_f = {2'b00, luf_carp, lvf_carp};
        if (!valid_carp || hedef_mr_out_carp != hedef || valid_topla) yan = 1'b1;
      end else if (op >= 10 && op <= 17) begin
        tamsayi_cntrl = 3'(op - 10);
        #1;
        got_r = result_tamsayi; got_f = {mstf_out[3], mstf_out[2], 2'b00};
        if (mstf_out[4] || mstf_out[1] || mstf_out[0]) yan = 1'b1;
      end else if (op == 20 || op == 21) begin
        kestirme_cntrl = op[0];
        #1;
        got_r = result_kestirme; got_f = {2'b00, luf_kestirme, lvf_kestirme};
      end else if (op >= 30 && op <= 34) begin
        karsilastirma_cntrl = {3'(op - 30), c1[3:0]};
        mstf_in = c2[4:0];
        #1;
        got_r = result_karsilastirma; got_f = {zf_karsilastirma, nf_karsilastirma, 2'b00};
      end else if (op >= 40 && op <= 50) begin
        donusum_cntrl = {c1[0], 4'(op - 40)};
        #1;
        got_r = result_donusum;
      end else begin
        $display("ALU_TB HATA: bilinmeyen op %0d", op);
        yan = 1'b1;
      end
      ok = !yan && (!mask[0] || got_r == er) && (!mask[1] || got_f[1:0] == ef[1:0])
                && (!mask[2] || got_f[3:2] == ef[3:2]);
      if (!ok) begin
        if (hata < MAX_YAZ)
          $display("FARK op=%0d A=%08h B=%08h c1=%0h c2=%0h | alu=%08h bayrak=%04b yan=%0b | golden=%08h bayrak=%04b maske=%03b",
                   op, va, vb, c1, c2, got_r, got_f, yan, er, ef[3:0], mask[2:0]);
        hata = hata + 1;
      end
      n = n + 1;
    end
    $fclose(fd);
    $display("ALU_TB SONUC: %0d vektor, %0d hata %s", n, hata, (hata == 0 && n > 0) ? "-> GECTI" : "-> KALDI");
    $finish;
  end
endmodule
