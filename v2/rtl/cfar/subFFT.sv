`timescale 1ns/1ps
//------------------------------------------------------------------------------
// subFFT  -  tek SDF kademesi
//
//   ctrl = 1 : FIFO'ya fark,  cikisa toplam        (twiddle = 1)
//   ctrl = 0 : FIFO'ya giris, cikisa FIFO cikisi   (twiddle uygulanir)
//
// Twiddle ustu = k * STEP,  STEP = 2^i
// Ceyrek dalga ROM: cos(2*pi*j/N), j = 0..N/4  (TW_DEPTH giris)
//------------------------------------------------------------------------------
module subFFT import parameters::*; #(
    parameter int DW    = XLEN,        // bu kademenin giris genisligi
    parameter int DEPTH = 64,          // FFT_POINT >> (i+1)
    parameter int STEP  = 1            // 2^i
)(
    input  logic                 clk_i,
    input  logic                 rst_ni,
    input  logic                 en_i,

    input  logic signed [DW-1:0] dataReel_i,
    input  logic signed [DW-1:0] dataComplex_i,

    output logic signed [DW:0]   dataReel_o,
    output logic signed [DW:0]   dataComplex_o,
    output logic                 en_o
);
    localparam int FW    = DW + 1;
    localparam int CNT_W = $clog2(2*DEPTH);
    localparam int PIPE  = 2;

    // DUZELTME: DEPTH=1 iken CNT_W=1 -> K_W=0 -> cnt[-1:0] gecersizdi.
    // K_W en az 1 tutuluyor. DEPTH=1'de tek twiddle zaten W^0=1 oldugu icin
    // twIndex'in degeri sonucu etkilemez.
    localparam int K_W   = (CNT_W >= 2) ? (CNT_W - 1) : 1;

    //---------------------------------------------------------- TEK ctrl -----
    logic [CNT_W-1:0] cnt;
    logic             ctrl;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni)   cnt <= '0;
        else if (en_i) cnt <= cnt + 1'b1;
    end

    assign ctrl = cnt[CNT_W-1];

    //---------------------------------------------------- geri besleme FIFO --
    logic signed [FW-1:0] fifoInReel,  fifoInComplex;
    logic signed [FW-1:0] fifoOutReel, fifoOutComplex;

    fftFifoRTL #(.WIDTH(2*FW), .FIFO_DEPTH(DEPTH)) fftFifoRTL (
        .clk_i     (clk_i),
        .rst_ni    (rst_ni),
        .data_i    ({fifoInComplex,  fifoInReel}),
        .writeEn_i (en_i),
        .readEn_i  (en_i),
        .data_o    ({fifoOutComplex, fifoOutReel})
    );

    //------------------------------------------------------------- kelebek ---
    logic signed [FW-1:0] sumReel, sumComplex, difReel, difComplex;

    butterflyUnit #(.DW(DW)) butterflyUnit (
        .data0Reel_i      (fifoOutReel),
        .data0Complex_i   (fifoOutComplex),
        .data1Reel_i      (dataReel_i),
        .data1Complex_i   (dataComplex_i),
        .dataReelSum_o    (sumReel),
        .dataComplexSum_o (sumComplex),
        .dataReelDif_o    (difReel),
        .dataComplexDif_o (difComplex)
    );

    assign fifoInReel    = ctrl ? difReel    : FW'(dataReel_i);
    assign fifoInComplex = ctrl ? difComplex : FW'(dataComplex_i);

    //---------------------------------------------- ceyrek dalga twiddle ROM --
    logic signed [TWLEN-1:0] cosTable [0:TW_DEPTH-1];
    initial $readmemh(TW_FILE, cosTable);

    localparam int Q     = FFT_POINT/4;
    localparam int EXP_W = $clog2(FFT_POINT/2);
    localparam int IDX_W = $clog2(Q+1);

    logic [K_W-1:0]          twIndex;
    logic [EXP_W-1:0]        twExp;
    logic                    upperHalf;
    logic [IDX_W-1:0]        mPrime, cosIdx, sinIdx;
    logic signed [TWLEN-1:0] twReel, twComplex;

    assign twIndex   = cnt[K_W-1:0];
    assign twExp     = EXP_W'(twIndex * STEP);
    assign upperHalf = (twExp >= EXP_W'(Q));
    assign mPrime    = upperHalf ? IDX_W'(twExp - Q) : IDX_W'(twExp);
    assign cosIdx    = upperHalf ? IDX_W'(Q - mPrime) : mPrime;
    assign sinIdx    = upperHalf ? mPrime             : IDX_W'(Q - mPrime);

    assign twReel    = ctrl ? TWLEN'(1 <<< TWFRAC)
                            : (upperHalf ? -cosTable[cosIdx] : cosTable[cosIdx]);
    assign twComplex = ctrl ? '0 : -cosTable[sinIdx];

    //----------------------------------------------- cikis secimi + carpim ---
    logic signed [FW-1:0] muxReel, muxComplex;
    assign muxReel    = ctrl ? sumReel    : fifoOutReel;
    assign muxComplex = ctrl ? sumComplex : fifoOutComplex;

    complexMulRTL #(.DW(FW), .TW(TWLEN), .FRAC(TWFRAC)) complexMulRTL (
        .clk_i        (clk_i),
        .rst_ni       (rst_ni),
        .en_i         (en_i),
        .in0Reel_i    (muxReel),
        .in0Complex_i (muxComplex),
        .in1Reel_i    (twReel),
        .in1Complex_i (twComplex),
        .reelOut_o    (dataReel_o),
        .complexOut_o (dataComplex_o)
    );

    //---------------------------------------------------------- en zinciri ---
    logic [PIPE-1:0] enShift;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) enShift <= '0;
        else         enShift <= {enShift[PIPE-2:0], en_i};
    end

    assign en_o = enShift[PIPE-1];
endmodule


//------------------------------------------------------------------------------
// butterflyUnit  -  sadece toplama/cikarma
//------------------------------------------------------------------------------
`timescale 1ns/1ps
module butterflyUnit #(
    parameter int DW = 20
)(
    input  logic signed [DW:0]   data0Reel_i,
    input  logic signed [DW:0]   data0Complex_i,
    input  logic signed [DW-1:0] data1Reel_i,
    input  logic signed [DW-1:0] data1Complex_i,

    output logic signed [DW:0]   dataReelSum_o,
    output logic signed [DW:0]   dataComplexSum_o,
    output logic signed [DW:0]   dataReelDif_o,
    output logic signed [DW:0]   dataComplexDif_o
);
    always_comb begin
        dataReelSum_o    = data0Reel_i    + data1Reel_i;
        dataComplexSum_o = data0Complex_i + data1Complex_i;
        dataReelDif_o    = data0Reel_i    - data1Reel_i;
        dataComplexDif_o = data0Complex_i - data1Complex_i;
    end
endmodule
