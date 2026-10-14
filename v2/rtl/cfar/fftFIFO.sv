module fftFifoRTL #(
    parameter int WIDTH      = 42,
    parameter int FIFO_DEPTH = 64
)(
    input  logic             clk_i,
    input  logic             rst_ni,

    input  logic [WIDTH-1:0] data_i,
    input  logic             writeEn_i,
    input  logic             readEn_i,
    output logic [WIDTH-1:0] data_o
);
    // DUZELTME: FIFO_DEPTH=1 icin $clog2(1)=0 -> [-1:0] gecersiz aralik olurdu.
    // Son kademe (DEPTH=1) icin ayri kol.
    generate
        if (FIFO_DEPTH <= 1) begin : gSingle
            always_ff @(posedge clk_i or negedge rst_ni) begin
                if (!rst_ni) data_o <= '0;
                else if (writeEn_i) data_o <= data_i;
            end

        end else begin : gRam
            localparam int PW = $clog2(FIFO_DEPTH);

            // DUZELTME: mem reset'ten cikarildi. '{default:'0} SRL/BRAM
            // cikarimini engelliyor ve devasa reset fanout'u yaratiyordu.
            (* srl_style = "srl" *) logic [WIDTH-1:0] mem [0:FIFO_DEPTH-1];
            logic [PW-1:0] wPtr;

            always_ff @(posedge clk_i or negedge rst_ni) begin
                if (!rst_ni) begin
                    wPtr <= '0;
                end else if (writeEn_i) begin
                    mem[wPtr] <= data_i;
                    wPtr      <= wPtr + 1'b1;      // PW bit, dogal sarar
                end
            end

            // wPtr yazilacak konumu gosterir; oradaki ESKI deger tam
            // FIFO_DEPTH cevrim oncesinin verisidir -> gecikme = FIFO_DEPTH
            assign data_o = mem[wPtr];
        end
    endgenerate
endmodule
