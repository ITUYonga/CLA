module dolpChev1000x18RTL import parameters::*;(
    input logic signed [XLEN-1:0]in_i[FAST_SIGNAL-1:0][SLOW_SIGNAL-3:0],
    output logic signed [XLEN-1:0]result_o[FAST_SIGNAL-1:0][SLOW_SIGNAL-3:0]
);
    logic signed[XLEN-1:0]mem[FAST_SIGNAL-1:0][SLOW_SIGNAL-1:0];
    initial begin
        $readmemh("win_doppler.mem", mem);    
    end
    
    always_comb begin
        for(int i=0 ; i<FAST_SIGNAL-1 ; i++)begin
            for(int j=0 ; j<SLOW_SIGNAL-3 ; j++)begin
                result_o[i][j] = in_i[i][j] * mem[i][j];
            end
        end
    end
endmodule
