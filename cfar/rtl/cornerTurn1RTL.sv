module cornerTurn1RTL import parameters::*;(
    input logic clk_i,
    input logic rst_ni,

    input logic signed [MF_OUT-1:0]complex_i,
    input logic signed [MF_OUT-1:0]reel_i,
    input logic valid_i,
    input logic sof_i,

    output logic signed [MF_OUT-1:0]complex_o,
    output logic signed [MF_OUT-1:0]reel_o,
    output logic valid_o,
    output logic sof_o,

    output logic busy_o
);
    localparam int DEPTH  = FAST_SIGNAL * SLOW_SIGNAL;
    localparam int ADDR_W = $clog2(DEPTH);
    localparam int R_W    = $clog2(FAST_SIGNAL);
    localparam int P_W    = $clog2(SLOW_SIGNAL);
    localparam int K_W    = $clog2(FFT_POINT);

    (* ram_style = "block" *) logic [2*MF_OUT-1:0] ram [0:DEPTH-1];

    logic readMode;

    logic [P_W-1:0]    wrPulse;
    logic [R_W-1:0]    wrRange;
    logic [ADDR_W-1:0] wrBase;
    logic [ADDR_W-1:0] wrAddr;
    logic              wrEn;
    logic              lastWrite;

    logic [R_W-1:0]    rdRange;
    logic [P_W-1:0]    rdPulse;
    logic [K_W-1:0]    rdSlot;
    logic [ADDR_W-1:0] rdAddr;
    logic              rdEn;
    logic              lastRead;

    logic [2*MF_OUT-1:0] rdData;
    logic [2*MF_OUT-1:0] rdDataReg;
    logic [1:0]          stageValid;
    logic [1:0]          stageSof;

    assign wrEn      = valid_i & !readMode;
    assign wrAddr    = wrBase + (sof_i ? '0 : wrRange);
    assign lastWrite = wrEn && (wrPulse == P_W'(SLOW_SIGNAL-1)) && !sof_i && (wrRange == R_W'(FAST_SIGNAL-1));

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            wrPulse <= 0;
            wrRange <= 0;
            wrBase  <= 0;
        end else if(wrEn)begin
            if(sof_i)begin
                wrRange <= 1;
            end else begin
                wrRange <= wrRange + 1;
            end
            if(lastWrite)begin
                wrPulse <= 0;
                wrBase  <= 0;
            end else if(!sof_i && wrRange == R_W'(FAST_SIGNAL-1))begin
                wrPulse <= wrPulse + 1;
                wrBase  <= wrBase + ADDR_W'(FAST_SIGNAL);
            end
        end
    end

    always_ff @(posedge clk_i)begin
        if(wrEn)begin
            ram[wrAddr] <= {complex_i, reel_i};
        end
    end

    assign rdEn     = readMode && (rdSlot < K_W'(SLOW_SIGNAL));
    assign lastRead = (rdRange == R_W'(FAST_SIGNAL-1)) && (rdSlot == K_W'(FFT_POINT-1));

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            readMode <= 0;
            rdRange  <= 0;
            rdPulse  <= 0;
            rdSlot   <= 0;
            rdAddr   <= 0;
        end else if(!readMode)begin
            if(lastWrite)begin
                readMode <= 1;
                rdRange  <= 0;
                rdPulse  <= 0;
                rdSlot   <= 0;
                rdAddr   <= 0;
            end
        end else begin
            rdSlot <= rdSlot + 1;
            if(rdEn)begin
                if(rdPulse == P_W'(SLOW_SIGNAL-1))begin
                    rdPulse <= 0;
                end else begin
                    rdPulse <= rdPulse + 1;
                    rdAddr  <= rdAddr + ADDR_W'(FAST_SIGNAL);
                end
            end
            if(rdSlot == K_W'(FFT_POINT-1))begin
                if(lastRead)begin
                    readMode <= 0;
                end else begin
                    rdRange <= rdRange + 1;
                    rdAddr  <= ADDR_W'(rdRange) + 1;
                end
            end
        end
    end

    always_ff @(posedge clk_i)begin
        rdData    <= ram[rdAddr];
        rdDataReg <= rdData;
    end

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            stageValid <= 0;
            stageSof   <= 0;
        end else begin
            stageValid <= {stageValid[0], rdEn};
            stageSof   <= {stageSof[0], rdEn && (rdPulse == 0)};
        end
    end

    assign valid_o   = stageValid[1];
    assign sof_o     = stageSof[1];
    assign complex_o = rdDataReg[2*MF_OUT-1:MF_OUT];
    assign reel_o    = rdDataReg[MF_OUT-1:0];
    assign busy_o    = readMode;
endmodule
