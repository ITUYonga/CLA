//------------------------------------------------------------------------------
// fftRTL  -  FFT_POINT noktali radix-2 SDF FFT zinciri
//
// Duzeltmeler:
//   * STEP parametresi eklendi (twiddle us adimi = 2^i)
//   * bit buyumesi: kademe i girisi XLEN+i, cikisi XLEN+i+1
//   * ara sinyaller signed
//   * FFT_STAGE kullanildi
//
// Cikis BIT-REVERSED siradadir.
//------------------------------------------------------------------------------
module fftRTL import parameters::*; (
    input  logic                          clk_i,
    input  logic                          rst_ni,
    input  logic                          fftEn_i,

    input  logic signed [XLEN-1:0]        in_i,
    input  logic signed [XLEN-1:0]        inComplex_i,
    output logic signed [XLEN+FFT_STAGE-1:0] resultReel_o,
    output logic signed [XLEN+FFT_STAGE-1:0] resultComplex_o,
    output logic                          resultEn_o
);
    localparam int DWO = XLEN + FFT_STAGE;   // 27

    // Kademeler arasi veri en genis formatta tasinir, her kademe kendi
    // alt dilimini alir. signed -> signed atamada isaret otomatik genisler.
    logic signed [DWO-1:0] dataReel    [0:FFT_STAGE];
    logic signed [DWO-1:0] dataComplex [0:FFT_STAGE];
    logic                  enChain     [0:FFT_STAGE];

    assign dataReel[0]    = in_i;
    assign dataComplex[0] = inComplex_i;
    assign enChain[0]     = fftEn_i;

    genvar i;
    generate
        for (i = 0; i < FFT_STAGE; i++) begin : gStage
            localparam int ST_DEPTH = FFT_POINT >> (i+1);   // 64,32,16,8,4,2,1
            localparam int ST_DW    = XLEN + i;             // 20..26
            localparam int ST_STEP  = 1 << i;               // 1,2,4,...,64

            logic signed [ST_DW:0]  outReel, outComplex;
            logic signed [DWO-1:0]  outReelExt, outComplexExt;

            subFFT #(
                .DW    (ST_DW),
                .DEPTH (ST_DEPTH),
                .STEP  (ST_STEP)
            ) subFFT (
                .clk_i         (clk_i),
                .rst_ni        (rst_ni),
                .en_i          (enChain[i]),
                .dataReel_i    (dataReel[i][ST_DW-1:0]),
                .dataComplex_i (dataComplex[i][ST_DW-1:0]),
                .dataReel_o    (outReel),
                .dataComplex_o (outComplex),
                .en_o          (enChain[i+1])
            );

            assign outReelExt         = outReel;      // isaret genisletme
            assign outComplexExt      = outComplex;
            assign dataReel[i+1]      = outReelExt;
            assign dataComplex[i+1]   = outComplexExt;
        end
    endgenerate

    assign resultReel_o    = dataReel[FFT_STAGE];
    assign resultComplex_o = dataComplex[FFT_STAGE];
    assign resultEn_o      = enChain[FFT_STAGE];
endmodule
