module rxPadRTL import parameters::*; (
    input  logic                        clk_i,
    input  logic                        rst_ni,

    input  logic [2*MF_RX_IN-1:0]       s_axis_tdata,
    input  logic                        s_axis_tvalid,
    input  logic                        s_axis_tlast,
    output logic                        s_axis_tready,

    output logic                        valid_o,
    output logic                        sof_o,
    output logic signed [MF_RX_IN-1:0]  reel_o,
    output logic signed [MF_RX_IN-1:0]  complex_o,

    output logic                        cpiStart_o,
    output logic                        cpiEnd_o
);
    localparam int LEN   = FAST_SIGNAL + MF_PAD;
    localparam int C_W   = $clog2(LEN);
    localparam int P_W   = $clog2(SLOW_SIGNAL);

    logic [C_W-1:0] cnt;
    logic [P_W-1:0] pulse;
    logic           padding;
    logic           take;

    assign padding       = (cnt >= C_W'(FAST_SIGNAL));
    assign s_axis_tready = !padding;
    assign take          = s_axis_tvalid && !padding;

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            cnt        <= 0;
            pulse      <= 0;
            valid_o    <= 0;
            sof_o      <= 0;
            cpiStart_o <= 0;
            cpiEnd_o   <= 0;
        end else begin
            valid_o    <= take || padding;
            sof_o      <= take && (cnt == 0);
            cpiStart_o <= take && (cnt == 0) && (pulse == 0);
            cpiEnd_o   <= take && (cnt == C_W'(FAST_SIGNAL-1)) && (pulse == P_W'(SLOW_SIGNAL-1));
            if(take || padding)begin
                if(cnt == C_W'(LEN-1))begin
                    cnt   <= 0;
                    pulse <= (pulse == P_W'(SLOW_SIGNAL-1)) ? '0 : pulse + 1'b1;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

    always_ff @(posedge clk_i)begin
        reel_o    <= padding ? '0 : s_axis_tdata[MF_RX_IN-1:0];
        complex_o <= padding ? '0 : s_axis_tdata[2*MF_RX_IN-1:MF_RX_IN];
    end
endmodule
