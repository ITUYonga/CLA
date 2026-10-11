module cornerTurn2RTL import parameters::*; #(
    parameter bit FFTSHIFT = 1'b1
)(
    input  logic                    clk_i,
    input  logic                    rst_ni,

    input  logic                    valid_i,
    input  logic                    sof_i,
    input  logic [XLEN_LOG_OUT-1:0] data_i,

    output logic                    valid_o,
    output logic                    sof_o,
    output logic [XLEN_LOG_OUT-1:0] data_o,

    output logic                    busy_o
);
    localparam int DEPTH  = FAST_SIGNAL * FFT_POINT;
    localparam int ADDR_W = $clog2(DEPTH);
    localparam int R_W    = $clog2(FAST_SIGNAL);
    localparam int K_W    = $clog2(FFT_POINT);
    localparam int GAP    = CFAR_HALF + 4;
    localparam int C_W    = $clog2(FAST_SIGNAL + GAP);

    (* ram_style = "block" *) logic [XLEN_LOG_OUT-1:0] ram [0:DEPTH-1];

    logic readMode;

    logic [K_W-1:0]    wrBin;
    logic [K_W-1:0]    wrBinNow;
    logic [R_W-1:0]    wrRange;
    logic [R_W-1:0]    wrRangeNow;
    logic [K_W-1:0]    wrRow;
    logic [ADDR_W-1:0] wrRowBase;
    logic [ADDR_W-1:0] wrAddr;
    logic              wrEn;
    logic              lastWrite;
    logic              started;

    logic [C_W-1:0]    rdCol;
    logic [K_W-1:0]    rdRow;
    logic [ADDR_W-1:0] rdAddr;
    logic              rdEn;
    logic              lastRead;

    logic [XLEN_LOG_OUT-1:0] rdData;
    logic [XLEN_LOG_OUT-1:0] rdDataReg;
    logic [1:0]              stageValid;
    logic [1:0]              stageSof;

    function automatic logic [K_W-1:0] bitrev(input logic [K_W-1:0] v);
        for(int b = 0; b < K_W; b++)begin
            bitrev[b] = v[K_W-1-b];
        end
    endfunction

    assign wrEn       = valid_i & !readMode;
    assign wrBinNow   = sof_i ? '0 : wrBin;
    assign wrRangeNow = (sof_i && started) ? wrRange + 1'b1 : wrRange;
    assign wrRow      = bitrev(wrBinNow) ^ (FFTSHIFT ? K_W'(FFT_POINT/2) : K_W'(0));
    assign wrRowBase  = (ADDR_W'(wrRow) << 10) - (ADDR_W'(wrRow) << 4) - (ADDR_W'(wrRow) << 3);
    assign wrAddr     = wrRowBase + ADDR_W'(wrRangeNow);
    assign lastWrite  = wrEn && (wrRangeNow == R_W'(FAST_SIGNAL-1)) && (wrBinNow == K_W'(FFT_POINT-1));

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            wrBin   <= 0;
            wrRange <= 0;
            started <= 0;
        end else if(wrEn)begin
            if(lastWrite)begin
                wrBin   <= 0;
                wrRange <= 0;
                started <= 0;
            end else begin
                wrBin   <= wrBinNow + 1'b1;
                wrRange <= wrRangeNow;
                started <= 1;
            end
        end
    end

    always_ff @(posedge clk_i)begin
        if(wrEn)begin
            ram[wrAddr] <= data_i;
        end
    end

    assign rdEn     = readMode && (rdCol < C_W'(FAST_SIGNAL));
    assign lastRead = (rdRow == K_W'(FFT_POINT-1)) && (rdCol == C_W'(FAST_SIGNAL-1));

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            readMode <= 0;
            rdCol    <= 0;
            rdRow    <= 0;
            rdAddr   <= 0;
        end else if(!readMode)begin
            if(lastWrite)begin
                readMode <= 1;
                rdCol    <= 0;
                rdRow    <= 0;
                rdAddr   <= 0;
            end
        end else begin
            if(rdEn)begin
                rdAddr <= rdAddr + 1'b1;
            end
            if(rdCol == C_W'(FAST_SIGNAL + GAP - 1))begin
                rdCol <= 0;
                rdRow <= rdRow + 1'b1;
            end else begin
                rdCol <= rdCol + 1'b1;
            end
            if(lastRead)begin
                readMode <= 0;
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
            stageSof   <= {stageSof[0], rdEn && (rdCol == 0)};
        end
    end

    assign valid_o = stageValid[1];
    assign sof_o   = stageSof[1];
    assign data_o  = rdDataReg;
    assign busy_o  = readMode;
endmodule
