module matchedFilterRTL import parameters::*;(
    input logic clk_i,
    input logic rst_ni,

    input logic signed [MF_RX_IN-1:0]rxComplex_i,
    input logic signed [MF_RX_IN-1:0]rxReel_i,

    input logic signed [MF_RX_IN-1:0]txComplex_i,
    input logic signed [MF_RX_IN-1:0]txReel_i,
    input logic txValid_i,

    input logic valid_i,
    input logic sof_i,

    output logic signed [MF_OUT-1:0]resultComplex_o,
    output logic signed [MF_OUT-1:0]resultReel_o,

    output logic valid_o,
    output logic sof_o
);
    localparam int TAP     = 20;
    localparam int MUL_W   = MF_RX_IN*2 + 1;
    localparam int ACC_W   = MUL_W + $clog2(TAP);
    localparam int FRAC_SH = MF_SHIFT;
    localparam logic signed [ACC_W-1:0] RND = ACC_W'(1) <<< (FRAC_SH-1);
    localparam int TOP     = FRAC_SH + MF_OUT - 1;

    logic signed [MF_RX_IN-1:0] txComplexBank[TAP-1:0];
    logic signed [MF_RX_IN-1:0] txReelBank[TAP-1:0];

    logic signed [MF_RX_IN-1:0] stageRxComplex;
    logic signed [MF_RX_IN-1:0] stageRxReel;

    logic signed [MUL_W-1:0] mulComplex[TAP-1:0];
    logic signed [MUL_W-1:0] mulReel[TAP-1:0];

    logic signed [ACC_W-1:0] accComplex[TAP-1:0];
    logic signed [ACC_W-1:0] accReel[TAP-1:0];

    logic stageValid;
    logic stageSof;
    logic accValid;
    logic accSof;

    always_ff @(posedge clk_i)begin
        if(txValid_i)begin
            txComplexBank[0] <= txComplex_i;
            txReelBank[0] <= txReel_i;
            for(int k = 1; k < TAP; k++)begin
                txComplexBank[k] <= txComplexBank[k-1];
                txReelBank[k] <= txReelBank[k-1];
            end
        end
    end

    always_ff @(posedge clk_i)begin
        stageRxComplex <= rxComplex_i;
        stageRxReel <= rxReel_i;
    end

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            stageValid <= 0;
            stageSof <= 0;
            accValid <= 0;
            accSof <= 0;
            valid_o <= 0;
            sof_o <= 0;
        end else begin
            stageValid <= valid_i;
            stageSof <= sof_i & valid_i;
            accValid <= stageValid;
            accSof <= stageSof;
            valid_o <= accValid;
            sof_o <= accSof;
        end
    end

    always_comb begin
        for(int k = 0; k < TAP; k++)begin
            mulReel[k]    = (MUL_W'(txReelBank[k]) * stageRxReel) + (MUL_W'(txComplexBank[k]) * stageRxComplex);
            mulComplex[k] = (MUL_W'(txReelBank[k]) * stageRxComplex) - (MUL_W'(txComplexBank[k]) * stageRxReel);
        end
    end

    always_ff @(posedge clk_i)begin
        if(stageValid)begin
            accComplex[TAP-1] <= ACC_W'(mulComplex[TAP-1]);
            accReel[TAP-1] <= ACC_W'(mulReel[TAP-1]);
            for(int k = 0; k < TAP-1; k++)begin
                accComplex[k] <= mulComplex[k] + (stageSof ? ACC_W'(0) : accComplex[k+1]);
                accReel[k] <= mulReel[k] + (stageSof ? ACC_W'(0) : accReel[k+1]);
            end
        end
    end

    function automatic logic signed [MF_OUT-1:0] sat(input logic signed [ACC_W-1:0] acc);
        if(acc[ACC_W-1:TOP] == '0 || acc[ACC_W-1:TOP] == '1)
            return acc[TOP:FRAC_SH];
        else if(acc[ACC_W-1])
            return {1'b1, {(MF_OUT-1){1'b0}}};
        else
            return {1'b0, {(MF_OUT-1){1'b1}}};
    endfunction

    always_ff @(posedge clk_i)begin
        resultComplex_o <= sat(accComplex[0] + RND);
        resultReel_o <= sat(accReel[0] + RND);
    end
endmodule
