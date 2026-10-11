module mfTrimRTL import parameters::*; (
    input  logic                      clk_i,
    input  logic                      rst_ni,

    input  logic                      valid_i,
    input  logic                      sof_i,
    input  logic signed [MF_OUT-1:0]  reel_i,
    input  logic signed [MF_OUT-1:0]  complex_i,

    output logic                      valid_o,
    output logic                      sof_o,
    output logic signed [MF_OUT-1:0]  reel_o,
    output logic signed [MF_OUT-1:0]  complex_o
);
    localparam int LEN = FAST_SIGNAL + MF_PAD;
    localparam int C_W = $clog2(LEN);

    logic [C_W-1:0] cnt;
    logic [C_W-1:0] cntNow;

    assign cntNow = sof_i ? '0 : cnt;

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            cnt     <= 0;
            valid_o <= 0;
            sof_o   <= 0;
        end else begin
            if(valid_i)begin
                cnt <= cntNow + 1'b1;
            end
            valid_o <= valid_i && (cntNow >= C_W'(MF_PAD));
            sof_o   <= valid_i && (cntNow == C_W'(MF_PAD));
        end
    end

    always_ff @(posedge clk_i)begin
        reel_o    <= reel_i;
        complex_o <= complex_i;
    end
endmodule
