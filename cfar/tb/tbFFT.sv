//------------------------------------------------------------------------------
// tbFFT.sv  -  basit Verilog tarzi testbench
//
// KOSTURMA: Tcl Console'a "run all" yaz (varsayilan 1000 ns yetmez).
//
// HIZALAMA:
//   resultEn_o yalnizca BORU HATTI gecikmesini tasir (NSTAGE * PIPE = 14).
//   Gercek veri gecikmesi FIFO derinliklerini de icerir:
//        sum(DEPTH_i) = 64+32+16+8+4+2+1 = NFFT-1 = 127
//        toplam       = 127 + 14 = 141 cevrim
//   Bu yuzden resultEn_o yukseldikten sonra ILK (NFFT-1) cikis atlanir,
//   sonraki NFFT ornek bir tam frame olusturur.
//
// TEST_CASE:
//   0 = impuls n=0 -> tum X[k] esit (twiddle'dan BAGIMSIZ). ONCE BUNU GECIR.
//   1 = impuls n=1 -> reel kisim kosinus (twiddle testi)
//   2 = DC
//------------------------------------------------------------------------------
`timescale 1ns/1ps

module tb_fftRTL;

  //---------------------------------------------------------------- ayarlar --
  localparam integer NFFT      = 128;            // parameters::FFT_POINT
  localparam integer NMTI      = 18;             // parameters::MTI_SIGNAL
  localparam integer DWI       = 20;             // parameters::XLEN
  localparam integer NSTAGE    = 7;              // parameters::FFT_STAGE
  localparam integer DWO       = DWI + NSTAGE;   // 27
  localparam integer TEST_CASE = 1;
  localparam integer AMP       = 4096;
  localparam integer SKIP      = NFFT - 1;       // 127  <-- FIFO gecikmesi
  localparam integer NFRAME    = 6;              // SKIP+NFFT'yi karsilamali
  localparam integer TOL       = 64;

  //------------------------------------------------------------ saat / reset --
  reg clk_i;
  reg rst_ni;

  initial clk_i = 1'b0;
  always #2.5 clk_i = ~clk_i;                    // 200 MHz

  //---------------------------------------------------------- DUT baglantisi --
  reg                    fftEn_i;
  reg  signed [DWI-1:0]  in_i;
  wire signed [DWO-1:0]  resultReel_o;
  wire signed [DWO-1:0]  resultComplex_o;
  wire                   resultEn_o;

  fftRTL dut (
    .clk_i           (clk_i),
    .rst_ni          (rst_ni),
    .fftEn_i         (fftEn_i),
    .in_i            (in_i),
    .resultReel_o    (resultReel_o),
    .resultComplex_o (resultComplex_o),
    .resultEn_o      (resultEn_o)
  );

  //---------------------------------------------------------------- degisken --
  integer i;
  integer si;
  integer co;          // resultEn_o ile sayilan toplam cikis
  integer ci;          // dizide saklanan gecerli ornek sayisi
  integer fd;
  integer minVal;
  integer maxVal;
  integer nErr;
  integer nX;
  integer done;

  reg signed [DWI-1:0] stim  [0:NFFT-1];
  reg signed [DWO-1:0] outRe [0:NFFT-1];
  reg signed [DWO-1:0] outIm [0:NFFT-1];

  //------------------------------------------------------- uyaran hazirligi --
  initial begin
    for (i = 0; i < NFFT; i = i + 1) stim[i] = 0;

    if (TEST_CASE == 0) begin
      stim[0] = AMP;
      $display("[TB] TEST 0: impuls n=0 -> tum X[k] esit beklenir");
    end
    else if (TEST_CASE == 1) begin
      stim[1] = AMP;
      $display("[TB] TEST 1: impuls n=1 -> reel kisim kosinus beklenir");
    end
    else begin
      for (i = 0; i < NMTI; i = i + 1) stim[i] = AMP;
      $display("[TB] TEST 2: DC -> sinc beklenir");
    end
  end

  //------------------------------------------------------------------ surucu --
  // Frame'ler BOSLUKSUZ ve SUREKLI ayni uyaranla surulur. Bosaltma fazi yok;
  // boylece yakalanan frame her zaman gecerli veriden gelir.
  initial begin
    rst_ni  = 1'b0;
    fftEn_i = 1'b0;
    in_i    = 0;
    done    = 0;

    repeat (10) @(posedge clk_i);
    rst_ni = 1'b1;
    repeat (2) @(posedge clk_i);

    for (si = 0; si < NFRAME*NFFT; si = si + 1) begin
      fftEn_i <= 1'b1;
      in_i    <= stim[si % NFFT];
      @(posedge clk_i);
    end

    fftEn_i <= 1'b0;
    repeat (10) @(posedge clk_i);
    done = 1;
  end

  //-------------------------------------------------------- cikis yakalama ---
  initial begin
    co = 0;
    ci = 0;
    @(posedge rst_ni);
    forever begin
      @(posedge clk_i);
      if (resultEn_o === 1'b1) begin
        // ilk SKIP cikis FIFO'lardan gelen gecersiz veridir
        if (co >= SKIP && ci < NFFT) begin
          outRe[ci] = resultReel_o;
          outIm[ci] = resultComplex_o;
          ci = ci + 1;
        end
        co = co + 1;
      end
    end
  end

  //--------------------------------------------------------------- kontrol ---
  initial begin
    wait (done == 1);
    repeat (5) @(posedge clk_i);

    $display("--------------------------------------------------");
    $display("[TB] resultEn_o cikis sayisi = %0d, saklanan = %0d", co, ci);

    if (ci < NFFT) begin
      $display("[TB] >>> tam frame yakalanamadi. NFRAME degerini artir.");
      $finish;
    end

    // X kontrolu
    nX = 0;
    for (i = 0; i < NFFT; i = i + 1)
      if (outRe[i] === {DWO{1'bx}} || outIm[i] === {DWO{1'bx}}) nX = nX + 1;

    if (nX > 0) begin
      $display("[TB] >>> %0d cikis X. subFFT.sv guncel mi?", nX);
      $display("[TB] >>> 'select index -1 into cnt' uyarisi hala varsa K_W hatasi surer.");
    end

    $display("[TB] ilk 8 cikis:");
    for (i = 0; i < 8; i = i + 1)
      $display("      X[%0d] = %0d  %0dj", i, outRe[i], outIm[i]);

    fd = $fopen("fft_out.txt", "w");
    if (fd == 0) $display("[TB] UYARI: fft_out.txt yazilamadi");
    else begin
      for (i = 0; i < NFFT; i = i + 1)
        $fwrite(fd, "%0d %0d %0d\n", i, outRe[i], outIm[i]);
      $fclose(fd);
      $display("[TB] fft_out.txt yazildi (%0d nokta)", NFFT);
    end

    minVal = outRe[0];
    maxVal = outRe[0];
    for (i = 1; i < NFFT; i = i + 1) begin
      if (outRe[i] < minVal) minVal = outRe[i];
      if (outRe[i] > maxVal) maxVal = outRe[i];
    end
    $display("[TB] reel min=%0d  max=%0d  yayilma=%0d",
             minVal, maxVal, maxVal - minVal);

    nErr = 0;
    if (nX > 0) nErr = nErr + 1;

    if (TEST_CASE == 0) begin
      if (nX == 0 && (maxVal - minVal) <= TOL)
        $display("[TB] GECTI: spektrum duz");
      else begin
        $display("[TB] KALDI: spektrum duz degil -> kelebek/FIFO/faz hatasi");
        nErr = nErr + 1;
      end
    end

    if (TEST_CASE == 1) begin
      $display("[TB] tepe = %0d  (beklenen ~%0d)", maxVal, AMP);
      if (nX > 0 || maxVal > (AMP + AMP/4) || maxVal < (AMP - AMP/4)) begin
        $display("[TB] KALDI: tepe genlik uzak -> olcekleme/twiddle hatasi");
        nErr = nErr + 1;
      end
      else begin
        $display("[TB] tepe makul. MATLAB'de sekli kontrol et:");
        $display("      d = load('fft_out.txt'); plot(d(:,2));");
      end
    end

    $display("--------------------------------------------------");
    if (nErr == 0) $display("[TB] SONUC: GECTI");
    else           $display("[TB] SONUC: KALDI");

    $finish;
  end

  //--------------------------------------------------- zaman asimi korumasi --
  initial begin
    #100000;
    $display("[TB] ZAMAN ASIMI (co = %0d)", co);
    $finish;
  end

endmodule