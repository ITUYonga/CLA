module top import parameters::*; (
    input  logic                  clk_i,
    input  logic                  rst_ni,

    input  logic [7:0]            s_axil_awaddr,
    input  logic                  s_axil_awvalid,
    output logic                  s_axil_awready,
    input  logic [31:0]           s_axil_wdata,
    input  logic [3:0]            s_axil_wstrb,
    input  logic                  s_axil_wvalid,
    output logic                  s_axil_wready,
    output logic [1:0]            s_axil_bresp,
    output logic                  s_axil_bvalid,
    input  logic                  s_axil_bready,
    input  logic [7:0]            s_axil_araddr,
    input  logic                  s_axil_arvalid,
    output logic                  s_axil_arready,
    output logic [31:0]           s_axil_rdata,
    output logic [1:0]            s_axil_rresp,
    output logic                  s_axil_rvalid,
    input  logic                  s_axil_rready,

    input  logic [2*MF_RX_IN-1:0] s_axis_rx_tdata,
    input  logic                  s_axis_rx_tvalid,
    input  logic                  s_axis_rx_tlast,
    output logic                  s_axis_rx_tready,

    output logic                  irq_o
);
    localparam int R_W = $clog2(FAST_SIGNAL);

    logic                          txValid;
    logic signed [MF_TX_IN-1:0]    txReel;
    logic signed [MF_TX_IN-1:0]    txComplex;

    logic [$clog2(CFAR_REF+1)-1:0] cfarK;
    logic [XLEN_LOG_OUT-1:0]       cfarAlpha;
    logic signed [XLEN_LOG_OUT-1:0] ppLogRatio;
    logic [R_W-1:0]                ppMaxGap;

    logic                          cpiStart;
    logic                          cpiEnd;
    logic                          ct1Busy;
    logic                          ct2Busy;

    logic                          padValid;
    logic                          padSof;
    logic signed [MF_RX_IN-1:0]    padReel;
    logic signed [MF_RX_IN-1:0]    padComplex;

    logic                          mfValid;
    logic                          mfSof;
    logic signed [MF_OUT-1:0]      mfReel;
    logic signed [MF_OUT-1:0]      mfComplex;

    logic                          trimValid;
    logic                          trimSof;
    logic signed [MF_OUT-1:0]      trimReel;
    logic signed [MF_OUT-1:0]      trimComplex;

    logic                          ct1Valid;
    logic                          ct1Sof;
    logic signed [MF_OUT-1:0]      ct1Reel;
    logic signed [MF_OUT-1:0]      ct1Complex;

    logic                          mtiValid;
    logic                          mtiSof;
    logic signed [MTI_OUT-1:0]     mtiReel;
    logic signed [MTI_OUT-1:0]     mtiComplex;

    logic                          winFftValid;
    logic                          winFftSof;
    logic signed [WIN_PRE_FFT-1:0] winFftReel;
    logic signed [WIN_PRE_FFT-1:0] winFftComplex;

    logic                          fftValid;
    logic                          fftSof;
    logic signed [FFT_OUT_LEN-1:0] fftReel;
    logic signed [FFT_OUT_LEN-1:0] fftComplex;

    logic                          powValid;
    logic                          powSof;
    logic [XLEN_LOG_IN-1:0]        power;

    logic                          logValid;
    logic                          logSof;
    logic [XLEN_LOG_OUT-1:0]       logData;

    logic                          ct2Valid;
    logic                          ct2Sof;
    logic [XLEN_LOG_OUT-1:0]       ct2Data;

    logic                          cfarValid;
    logic                          cfarSof;
    logic                          cfarDetect;
    logic [XLEN_LOG_OUT-1:0]       cfarCut;
    logic [XLEN_LOG_OUT-1:0]       cfarThreshold;
    logic [R_W-1:0]                cfarRange;
    logic [$clog2(FFT_POINT)-1:0]  cfarDoppler;

    logic                          ppDone;
    logic [$clog2(MAXDET+1)-1:0]   ppCount;
    logic                          ppOverflow;
    logic [MAXDET*R_W-1:0]         ppIdx;

    axiLiteRegsRTL axiLiteRegsRTL (
        .clk_i          (clk_i),
        .rst_ni         (rst_ni),
        .s_axil_awaddr  (s_axil_awaddr),
        .s_axil_awvalid (s_axil_awvalid),
        .s_axil_awready (s_axil_awready),
        .s_axil_wdata   (s_axil_wdata),
        .s_axil_wstrb   (s_axil_wstrb),
        .s_axil_wvalid  (s_axil_wvalid),
        .s_axil_wready  (s_axil_wready),
        .s_axil_bresp   (s_axil_bresp),
        .s_axil_bvalid  (s_axil_bvalid),
        .s_axil_bready  (s_axil_bready),
        .s_axil_araddr  (s_axil_araddr),
        .s_axil_arvalid (s_axil_arvalid),
        .s_axil_arready (s_axil_arready),
        .s_axil_rdata   (s_axil_rdata),
        .s_axil_rresp   (s_axil_rresp),
        .s_axil_rvalid  (s_axil_rvalid),
        .s_axil_rready  (s_axil_rready),
        .txValid_o      (txValid),
        .txReel_o       (txReel),
        .txComplex_o    (txComplex),
        .cfarK_o        (cfarK),
        .cfarAlpha_o    (cfarAlpha),
        .ppLogRatio_o   (ppLogRatio),
        .ppMaxGap_o     (ppMaxGap),
        .cpiStart_i     (cpiStart),
        .cpiEnd_i       (cpiEnd),
        .done_i         (ppDone),
        .count_i        (ppCount),
        .overflow_i     (ppOverflow),
        .idx_i          (ppIdx),
        .ct1Busy_i      (ct1Busy),
        .ct2Busy_i      (ct2Busy),
        .irq_o          (irq_o)
    );

    rxPadRTL rxPadRTL (
        .clk_i         (clk_i),
        .rst_ni        (rst_ni),
        .s_axis_tdata  (s_axis_rx_tdata),
        .s_axis_tvalid (s_axis_rx_tvalid),
        .s_axis_tlast  (s_axis_rx_tlast),
        .s_axis_tready (s_axis_rx_tready),
        .valid_o       (padValid),
        .sof_o         (padSof),
        .reel_o        (padReel),
        .complex_o     (padComplex),
        .cpiStart_o    (cpiStart),
        .cpiEnd_o      (cpiEnd)
    );

    matchedFilterRTL matchedFilterRTL (
        .clk_i           (clk_i),
        .rst_ni          (rst_ni),
        .rxComplex_i     (padComplex),
        .rxReel_i        (padReel),
        .txComplex_i     (txComplex),
        .txReel_i        (txReel),
        .txValid_i       (txValid),
        .valid_i         (padValid),
        .sof_i           (padSof),
        .resultComplex_o (mfComplex),
        .resultReel_o    (mfReel),
        .valid_o         (mfValid),
        .sof_o           (mfSof)
    );

    mfTrimRTL mfTrimRTL (
        .clk_i     (clk_i),
        .rst_ni    (rst_ni),
        .valid_i   (mfValid),
        .sof_i     (mfSof),
        .reel_i    (mfReel),
        .complex_i (mfComplex),
        .valid_o   (trimValid),
        .sof_o     (trimSof),
        .reel_o    (trimReel),
        .complex_o (trimComplex)
    );

    cornerTurn1RTL cornerTurn1RTL (
        .clk_i     (clk_i),
        .rst_ni    (rst_ni),
        .complex_i (trimComplex),
        .reel_i    (trimReel),
        .valid_i   (trimValid),
        .sof_i     (trimSof),
        .complex_o (ct1Complex),
        .reel_o    (ct1Reel),
        .valid_o   (ct1Valid),
        .sof_o     (ct1Sof),
        .busy_o    (ct1Busy)
    );

    mtiFilterRTL mtiFilterRTL (
        .clk_i     (clk_i),
        .rst_ni    (rst_ni),
        .valid_i   (ct1Valid),
        .sof_i     (ct1Sof),
        .reel_i    (ct1Reel),
        .complex_i (ct1Complex),
        .valid_o   (mtiValid),
        .sof_o     (mtiSof),
        .complex_o (mtiComplex),
        .reel_o    (mtiReel)
    );

    winPreFFT winPreFFT (
        .clk_i     (clk_i),
        .rst_ni    (rst_ni),
        .complex_i (mtiComplex),
        .reel_i    (mtiReel),
        .valid_i   (mtiValid),
        .sof_i     (mtiSof),
        .valid_o   (winFftValid),
        .sof_o     (winFftSof),
        .complex_o (winFftComplex),
        .reel_o    (winFftReel)
    );

    dopplerFftRTL dopplerFftRTL (
        .clk_i     (clk_i),
        .rst_ni    (rst_ni),
        .valid_i   (winFftValid),
        .sof_i     (winFftSof),
        .reel_i    (winFftReel),
        .complex_i (winFftComplex),
        .valid_o   (fftValid),
        .sof_o     (fftSof),
        .reel_o    (fftReel),
        .complex_o (fftComplex)
    );

    powerRTL powerRTL (
        .clk_i   (clk_i),
        .rst_ni  (rst_ni),
        .valid_i (fftValid),
        .sof_i   (fftSof),
        .reel_i  (fftReel),
        .imag_i  (fftComplex),
        .valid_o (powValid),
        .sof_o   (powSof),
        .power_o (power)
    );

    logDomainRTL logDomainRTL (
        .clk_i   (clk_i),
        .rst_ni  (rst_ni),
        .valid_i (powValid),
        .sof_i   (powSof),
        .in_i    (power),
        .valid_o (logValid),
        .sof_o   (logSof),
        .out_o   (logData)
    );

    cornerTurn2RTL cornerTurn2RTL (
        .clk_i   (clk_i),
        .rst_ni  (rst_ni),
        .valid_i (logValid),
        .sof_i   (logSof),
        .data_i  (logData),
        .valid_o (ct2Valid),
        .sof_o   (ct2Sof),
        .data_o  (ct2Data),
        .busy_o  (ct2Busy)
    );

    osCfarRTL osCfarRTL (
        .clk_i        (clk_i),
        .rst_ni       (rst_ni),
        .valid_i      (ct2Valid),
        .sof_i        (ct2Sof),
        .power_i      (ct2Data),
        .alpha_i      (cfarAlpha),
        .k_i          (cfarK),
        .valid_o      (cfarValid),
        .sof_o        (cfarSof),
        .detect_o     (cfarDetect),
        .cut_o        (cfarCut),
        .threshold_o  (cfarThreshold),
        .rangeIdx_o   (cfarRange),
        .dopplerIdx_o (cfarDoppler)
    );

    postProcRTL postProcRTL (
        .clk_i        (clk_i),
        .rst_ni       (rst_ni),
        .valid_i      (cfarValid),
        .cut_i        (cfarCut),
        .threshold_i  (cfarThreshold),
        .rangeIdx_i   (cfarRange),
        .dopplerIdx_i (cfarDoppler),
        .logRatio_i   (ppLogRatio),
        .maxGap_i     (ppMaxGap),
        .done_o       (ppDone),
        .count_o      (ppCount),
        .overflow_o   (ppOverflow),
        .idx_o        (ppIdx)
    );
endmodule
