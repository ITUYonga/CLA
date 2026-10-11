`timescale 1ns/1ps
module tb_golden;
    import parameters::*;

    parameter string DIR          = "D:/github/RoC-CFAR/golden_model/vectors/vec_nominal_nfft128/";
    parameter int    EXP_COUNT    = 1;
    parameter int    EXP_IDX0     = 564;
    parameter int    TOL_MF       = 2;
    parameter int    TOL_MTI      = 6;
    parameter int    TOL_WIN      = 3;

    localparam int NR = FAST_SIGNAL, NP = SLOW_SIGNAL, NM = MTI_SIGNAL, NF = FFT_POINT;

    logic clk_i = 0, rst_ni = 0;
    always #2.5 clk_i = ~clk_i;

    logic [7:0]  awaddr = 0, araddr = 0;
    logic        awvalid = 0, wvalid = 0, bready = 1, arvalid = 0, rready = 1;
    logic [31:0] wdata = 0;
    logic        awready, wready, bvalid, arready, rvalid;
    logic [1:0]  bresp, rresp;
    logic [31:0] rdata;
    logic [31:0] tdata = 0;
    logic        tvalid = 0, tlast = 0, tready, irq;

    top dut (
        .clk_i(clk_i), .rst_ni(rst_ni),
        .s_axil_awaddr(awaddr), .s_axil_awvalid(awvalid), .s_axil_awready(awready),
        .s_axil_wdata(wdata), .s_axil_wstrb(4'hF), .s_axil_wvalid(wvalid), .s_axil_wready(wready),
        .s_axil_bresp(bresp), .s_axil_bvalid(bvalid), .s_axil_bready(bready),
        .s_axil_araddr(araddr), .s_axil_arvalid(arvalid), .s_axil_arready(arready),
        .s_axil_rdata(rdata), .s_axil_rresp(rresp), .s_axil_rvalid(rvalid), .s_axil_rready(rready),
        .s_axis_rx_tdata(tdata), .s_axis_rx_tvalid(tvalid), .s_axis_rx_tlast(tlast), .s_axis_rx_tready(tready),
        .irq_o(irq));

    logic [15:0] t0r[0:TX_DEPTH-1], t0i[0:TX_DEPTH-1];
    logic [15:0] t1r[0:NR*NP-1],    t1i[0:NR*NP-1];
    logic [17:0] t2r[0:NR*NP-1],    t2i[0:NR*NP-1];
    logic [19:0] t3r[0:NR*NM-1],    t3i[0:NR*NM-1];
    logic [19:0] t4r[0:NR*NM-1],    t4i[0:NR*NM-1];
    logic [23:0] t5r[0:NR*NF-1],    t5i[0:NR*NF-1];
    logic [39:0] t6b[0:NR*NF-1];

    initial begin
        $readmemh({DIR, "t0_tx_pulse_win_re.mem"}, t0r); $readmemh({DIR, "t0_tx_pulse_win_im.mem"}, t0i);
        $readmemh({DIR, "t1_rx_re.mem"}, t1r);           $readmemh({DIR, "t1_rx_im.mem"}, t1i);
        $readmemh({DIR, "t2_matched_re.mem"}, t2r);      $readmemh({DIR, "t2_matched_im.mem"}, t2i);
        $readmemh({DIR, "t3_mti_re.mem"}, t3r);          $readmemh({DIR, "t3_mti_im.mem"}, t3i);
        $readmemh({DIR, "t4_mti_win_re.mem"}, t4r);      $readmemh({DIR, "t4_mti_win_im.mem"}, t4i);
        $readmemh({DIR, "t5_fft_re.mem"}, t5r);          $readmemh({DIR, "t5_fft_im.mem"}, t5i);
        $readmemh({DIR, "t6b_os_cfar_out.mem"}, t6b);
    end

    function automatic int iabs(input longint v); return (v < 0) ? -v : v; endfunction
    function automatic int bitrev(input int v);
        int r; r = 0;
        for (int b = 0; b < FFT_STAGE; b++) if (v[b]) r = r + (1 << (FFT_STAGE-1-b));
        return r;
    endfunction

    int sN[3], sEx[3], sMx[3], sOv[3];
    real   fftErrSq, fftSigSq; int fftN, fftMax;
    int    cfarN, cfarAgree, cfarRtl, cfarGold;

    task automatic acc(input int i, input int e, input int tol);
        sN[i]++; if (e == 0) sEx[i]++; if (e > sMx[i]) sMx[i] = e; if (e > tol) sOv[i]++;
    endtask

    int mfP = -1, mfR = 0;
    always @(posedge clk_i) if (dut.trimValid) begin
        int k, e;
        if (dut.trimSof) begin mfP++; mfR = 0; end
        k = mfP*NR + mfR;
        e = iabs(dut.trimReel - $signed(t2r[k])); if (iabs(dut.trimComplex - $signed(t2i[k])) > e) e = iabs(dut.trimComplex - $signed(t2i[k]));
        acc(0, e, TOL_MF);
        mfR++;
    end

    int mtiR = -1, mtiP = 0;
    always @(posedge clk_i) if (dut.mtiValid) begin
        int k, e;
        if (dut.mtiSof) begin mtiR++; mtiP = 0; end
        k = mtiP*NR + mtiR;
        e = iabs(dut.mtiReel - $signed(t3r[k])); if (iabs(dut.mtiComplex - $signed(t3i[k])) > e) e = iabs(dut.mtiComplex - $signed(t3i[k]));
        acc(1, e, TOL_MTI);
        mtiP++;
    end

    int winR = -1, winP = 0;
    always @(posedge clk_i) if (dut.winFftValid) begin
        int k, e;
        if (dut.winFftSof) begin winR++; winP = 0; end
        k = winP*NR + winR;
        e = iabs(dut.winFftReel - $signed(t4r[k])); if (iabs(dut.winFftComplex - $signed(t4i[k])) > e) e = iabs(dut.winFftComplex - $signed(t4i[k]));
        acc(2, e, TOL_WIN);
        winP++;
    end

    int fftR = -1, fftK = 0;
    always @(posedge clk_i) if (dut.fftValid) begin
        int col, k; real dr, di, gr, gi;
        if (dut.fftSof) begin fftR++; fftK = 0; end
        col = (bitrev(fftK) + NF/2) % NF;
        k   = fftR*NF + col;
        gr = $signed(t5r[k]); gi = $signed(t5i[k]);
        dr = dut.fftReel - gr; di = dut.fftComplex - gi;
        fftErrSq += dr*dr + di*di; fftSigSq += gr*gr + gi*gi; fftN++;
        if (iabs($rtoi(dr)) > fftMax) fftMax = iabs($rtoi(dr));
        if (iabs($rtoi(di)) > fftMax) fftMax = iabs($rtoi(di));
        fftK++;
    end

    always @(posedge clk_i) if (dut.cfarValid) begin
        int k; bit g;
        k = dut.cfarRange*NF + dut.cfarDoppler;
        g = (t6b[k] != 0);
        cfarN++; if (g == dut.cfarDetect) cfarAgree++;
        if (dut.cfarDetect) cfarRtl++;
        if (g) cfarGold++;
    end

    task automatic axiWrite(input logic [7:0] a, input logic [31:0] d);
        @(posedge clk_i);
        awaddr <= a; awvalid <= 1; wdata <= d; wvalid <= 1;
        do @(posedge clk_i); while (!(awready && wready));
        awvalid <= 0; wvalid <= 0;
        do @(posedge clk_i); while (!bvalid);
    endtask

    task automatic axiRead(input logic [7:0] a, output logic [31:0] d);
        @(posedge clk_i);
        araddr <= a; arvalid <= 1;
        do @(posedge clk_i); while (!rvalid);
        arvalid <= 0; d = rdata;
        @(posedge clk_i);
    endtask

    initial begin #30ms $display("zaman asimi"); $finish; end

    initial begin
        logic [31:0] cnt, ovf, lat, v;
        int idx[MAXDET], ok;

        for (int i = 0; i < 3; i++) begin sN[i] = 0; sEx[i] = 0; sMx[i] = 0; sOv[i] = 0; end
        fftErrSq = 0; fftSigSq = 0; fftN = 0; fftMax = 0;
        cfarN = 0; cfarAgree = 0; cfarRtl = 0; cfarGold = 0;

        repeat (5) @(posedge clk_i); rst_ni <= 1; repeat (5) @(posedge clk_i);

        for (int k = 0; k < TX_DEPTH; k++) axiWrite(8'h80 + 8'(4*k), {t0i[k], t0r[k]});
        axiWrite(8'h00, 32'h1);
        repeat (40) @(posedge clk_i);

        for (int k = 0; k < NR*NP; k++) begin
            tdata <= {t1i[k], t1r[k]}; tvalid <= 1; tlast <= (k == NR*NP-1);
            do @(posedge clk_i); while (!tready);
        end
        tvalid <= 0; tlast <= 0;
        $display("RX gonderildi (%0t), zincir isleniyor...", $time);

        wait (irq);
        repeat (5) @(posedge clk_i);
        axiRead(8'h18, cnt); axiRead(8'h1C, ovf); axiRead(8'h20, lat);
        for (int i = 0; i < MAXDET; i++) begin axiRead(8'h40 + 8'(4*i), v); idx[i] = v; end

        $display("==============================================================");
        $display(" GOLDEN (Seviye A) KARSILASTIRMASI - %s", DIR);
        $display("==============================================================");
        $display(" T2 MF     : %0d/%0d ornek, birebir %%%0.1f, en buyuk fark %0d LSB, tol(%0d) disi %0d",
                 sN[0], NR*NP, 100.0*sEx[0]/sN[0], sMx[0], TOL_MF, sOv[0]);
        $display(" T3 MTI    : %0d/%0d ornek, birebir %%%0.1f, en buyuk fark %0d LSB, tol(%0d) disi %0d",
                 sN[1], NR*NM, 100.0*sEx[1]/sN[1], sMx[1], TOL_MTI, sOv[1]);
        $display(" T4 pencere: %0d/%0d ornek, birebir %%%0.1f, en buyuk fark %0d LSB, tol(%0d) disi %0d",
                 sN[2], NR*NM, 100.0*sEx[2]/sN[2], sMx[2], TOL_WIN, sOv[2]);
        $display(" T5 FFT    : %0d/%0d bin, SQNR %0.1f dB, en buyuk fark %0d LSB",
                 fftN, NR*NF, 10.0*$log10(fftSigSq/(fftErrSq+1e-9)), fftMax);
        $display(" T6 CFAR   : %0d/%0d hucre, uyum %%%0.4f (golden %0d tespit, RTL %0d)",
                 cfarN, NR*NF, 100.0*cfarAgree/cfarN, cfarGold, cfarRtl);
        $write(  " T7 sonuc  : count=%0d overflow=%0d idx=", cnt, ovf);
        for (int i = 0; i < cnt; i++) $write("%0d ", idx[i]);
        $display("  (beklenen count=%0d idx0=%0d)", EXP_COUNT, EXP_IDX0);
        $display(" latency   : %0d saat = %0.3f ms @200 MHz", lat, lat*5.0e-6);
        ok = (cnt == EXP_COUNT) && (EXP_COUNT == 0 || idx[0] == EXP_IDX0) && (sOv[0] == 0) && (sOv[1] == 0)
             && (sOv[2] == 0) && (sN[0] == NR*NP) && (fftN == NR*NF) && (cfarN == NR*NF);
        $display(" SONUC: %s", ok ? "GECTI" : "KALDI");
        $display("==============================================================");
        $finish;
    end
endmodule
