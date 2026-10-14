module dolpChev1x20RTL import parameters::*;(
    input logic signed [XLEN_IN-1:0]tx_i[SLOW_SIGNAL-1:0],
    output logic signed [XLEN_IN-1:0]winOut_o[SLOW_SIGNAL-1:0]
);
    logic signed [XLEN_IN-1:0]winCoeff[SLOW_SIGNAL-1:0];
    initial begin
        $readmemh("win_tx.mem" , winCoeff);
    end

    always_comb begin
        for(int i=0 ; i<SLOW_SIGNAL ; i=i+1)begin
            winOut_o[i] = tx_i[i] * winCoeff[i];
        end
    end
endmodule
