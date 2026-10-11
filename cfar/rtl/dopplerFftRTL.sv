module dopplerFftRTL import parameters::*; (
    input  logic                                clk_i,
    input  logic                                rst_ni,

    input  logic                                valid_i,
    input  logic                                sof_i,
    input  logic signed [XLEN-1:0]              reel_i,
    input  logic signed [XLEN-1:0]              complex_i,

    output logic                                valid_o,
    output logic                                sof_o,
    output logic signed [XLEN+FFT_STAGE-1:0]    reel_o,
    output logic signed [XLEN+FFT_STAGE-1:0]    complex_o
);
    localparam int LAT   = FFT_POINT - 1 + 2*FFT_STAGE;
    localparam int FLUSH = 2*FFT_POINT;
    localparam int K_W   = $clog2(FFT_POINT);
    localparam int F_W   = $clog2(FLUSH);
    localparam int DWO   = XLEN + FFT_STAGE;

    logic           running;
    logic           flushing;
    logic [K_W-1:0] k;
    logic [F_W-1:0] flushCnt;

    logic           start;
    logic           emit;
    logic           realSample;
    logic signed [XLEN-1:0] padReel;
    logic signed [XLEN-1:0] padComplex;

    logic           fftEn;
    logic signed [XLEN-1:0] fftReel;
    logic signed [XLEN-1:0] fftComplex;
    logic           tagValid;
    logic           tagSof;

    logic [LAT-1:0] tagValidDelay;
    logic [LAT-1:0] tagSofDelay;

    logic signed [DWO-1:0] resultReel;
    logic signed [DWO-1:0] resultComplex;
    logic                  resultEn;

    assign start      = valid_i & sof_i;
    assign emit       = start | running | flushing;
    assign realSample = valid_i & (start | (running && k < K_W'(MTI_SIGNAL)));
    assign padReel    = realSample ? reel_i    : '0;
    assign padComplex = realSample ? complex_i : '0;

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            running  <= 0;
            flushing <= 0;
            k        <= 0;
            flushCnt <= 0;
        end else begin
            if(start)begin
                running  <= 1;
                flushing <= 0;
                k        <= 1;
            end else if(running)begin
                k <= k + 1;
                if(k == K_W'(FFT_POINT-1))begin
                    running  <= 0;
                    flushing <= 1;
                    flushCnt <= 0;
                end
            end else if(flushing)begin
                flushCnt <= flushCnt + 1;
                if(flushCnt == F_W'(FLUSH-1))begin
                    flushing <= 0;
                end
            end
        end
    end

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            fftEn    <= 0;
            tagValid <= 0;
            tagSof   <= 0;
        end else begin
            fftEn    <= emit;
            tagValid <= start | running;
            tagSof   <= start;
        end
    end

    always_ff @(posedge clk_i)begin
        fftReel    <= padReel;
        fftComplex <= padComplex;
    end

    fftRTL fftRTL (
        .clk_i           (clk_i),
        .rst_ni          (rst_ni),
        .fftEn_i         (fftEn),
        .in_i            (fftReel),
        .inComplex_i     (fftComplex),
        .resultReel_o    (resultReel),
        .resultComplex_o (resultComplex),
        .resultEn_o      (resultEn)
    );

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            tagValidDelay <= 0;
            tagSofDelay   <= 0;
            valid_o       <= 0;
            sof_o         <= 0;
        end else begin
            tagValidDelay <= {tagValidDelay[LAT-2:0], tagValid};
            tagSofDelay   <= {tagSofDelay[LAT-2:0], tagSof};
            valid_o       <= tagValidDelay[LAT-1] & resultEn;
            sof_o         <= tagSofDelay[LAT-1] & resultEn;
        end
    end

    always_ff @(posedge clk_i)begin
        reel_o    <= resultReel;
        complex_o <= resultComplex;
    end
endmodule
