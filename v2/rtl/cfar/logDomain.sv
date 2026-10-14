`timescale 1ns/1ps
module logDomainRTL import parameters::*;(
    input   logic                       clk_i,
    input   logic                       rst_ni,

    input   logic                       valid_i,
    input   logic                       sof_i,
    input   logic   [XLEN_LOG_IN-1:0]   in_i,

    output  logic                       valid_o,
    output  logic                       sof_o,
    output  logic   [XLEN_LOG_OUT-1:0]  out_o
);
    localparam int EXP_W  = $clog2(XLEN_LOG_IN);
    localparam int FRAC_W = XLEN_LOG_OUT - EXP_W;
    localparam int PIPE   = 3;

    logic [EXP_W-1:0]       expComb;
    logic                   nonZeroComb;

    always_comb begin
        expComb     = '0;
        nonZeroComb = 1'b0;
        for (int i = 0; i < XLEN_LOG_IN; i++) begin
            if (in_i[i]) begin
                expComb     = EXP_W'(i);
                nonZeroComb = 1'b1;
            end
        end
    end

    logic [XLEN_LOG_IN-1:0] dataS1;
    logic [EXP_W-1:0]       expS1;
    logic                   nonZeroS1;

    always_ff @(posedge clk_i) begin
        dataS1    <= in_i;
        expS1     <= expComb;
        nonZeroS1 <= nonZeroComb;
    end

    logic [XLEN_LOG_IN-1:0] normComb;
    assign normComb = dataS1 << (EXP_W'(XLEN_LOG_IN-1) - expS1);

    logic [EXP_W-1:0]  expS2;
    logic [FRAC_W-1:0] fracS2;
    logic              nonZeroS2;

    always_ff @(posedge clk_i) begin
        expS2     <= expS1;
        fracS2    <= normComb[XLEN_LOG_IN-2 -: FRAC_W];
        nonZeroS2 <= nonZeroS1;
    end

    always_ff @(posedge clk_i) begin
        out_o <= nonZeroS2 ? {expS2, fracS2} : '0;
    end

    logic [PIPE-1:0] validPipe;
    logic [PIPE-1:0] sofPipe;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            validPipe <= '0;
            sofPipe   <= '0;
        end else begin
            validPipe <= {validPipe[PIPE-2:0], valid_i};
            sofPipe   <= {sofPipe[PIPE-2:0], valid_i & sof_i};
        end
    end

    assign valid_o = validPipe[PIPE-1];
    assign sof_o   = sofPipe[PIPE-1];
endmodule
