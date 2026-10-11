module convFIFO import parameters::SLOW_SIGNAL, parameters::FAST_SIGNAL; #(
    parameter XLEN = 16
)(
    input logic clk_i,
    input logic rst_ni,

    input logic signed [XLEN-1:0] data_i [SLOW_SIGNAL-1:0],
    input logic writeEn_i,
    input logic readEn_i,
    output logic signed [XLEN-1:0] data_o [FAST_SIGNAL-1:0][SLOW_SIGNAL-1:0]
);  
    logic [9:0]writeCounter;
    logic signed [XLEN-1:0] mem [FAST_SIGNAL-1:0][SLOW_SIGNAL-1:0];
    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            mem <= '{default:0};
        end else begin
            if(writeEn_i)begin
                mem[writeCounter] <= data_i;
                writeCounter <= writeCounter + 1;
            end
        end
    end 

    assign data_o = mem;
endmodule
