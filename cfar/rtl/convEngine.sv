module convEngineRTL import parameters::*;(
    input logic clk_i,
    output logic rst_ni,

    input logic signed [XLEN_IN-1:0]rx_i[SLOW_SIGNAL-1:0],
    input logic signed [XLEN_IN-1:0]windowedTx_i[SLOW_SIGNAL-1:0],

    input logic valid_i,
    output logic valid_o,

    output logic signed [XLEN_CONV-1:0]result_o[SLOW_SIGNAL-1:0]
);  
    logic signed [2*XLEN_IN-1:0]scaledValue;
    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            scaledValue <= 0;
        end else begin
            valid_o <= valid_i;
            for(int i = 0; i < SLOW_SIGNAL; i++) begin
                scaledValue <= scaledValue + (rx_i[i] * windowedTx_i[i]);
            end
        end
    end 

endmodule
