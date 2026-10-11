module postProcRTL import parameters::*; (
    input  logic                                   clk_i,
    input  logic                                   rst_ni,

    input  logic                                   valid_i,
    input  logic [XLEN_LOG_OUT-1:0]                cut_i,
    input  logic [XLEN_LOG_OUT-1:0]                threshold_i,
    input  logic [$clog2(FAST_SIGNAL)-1:0]         rangeIdx_i,
    input  logic [$clog2(FFT_POINT)-1:0]           dopplerIdx_i,

    input  logic signed [XLEN_LOG_OUT-1:0]         logRatio_i,
    input  logic [$clog2(FAST_SIGNAL)-1:0]         maxGap_i,

    output logic                                   done_o,
    output logic [$clog2(MAXDET+1)-1:0]            count_o,
    output logic                                   overflow_o,
    output logic [MAXDET*$clog2(FAST_SIGNAL)-1:0]   idx_o
);
    localparam int W   = XLEN_LOG_OUT;
    localparam int R_W = $clog2(FAST_SIGNAL);
    localparam int N_W = $clog2(MAXDET+1);

    (* ram_style = "block" *) logic [2*W-1:0] mem [0:FAST_SIGNAL-1];

    logic           acValid;
    logic           acFirst;
    logic [R_W-1:0] acRange;
    logic [W-1:0]   acCut;
    logic [W-1:0]   acThr;
    logic [2*W-1:0] acOld;
    logic           acLast;

    logic           scanning;
    logic [R_W-1:0] scanAddr;
    logic           rdValid;
    logic [R_W-1:0] rdIdx;
    logic           rdEnd;
    logic [2*W-1:0] rdData;

    logic [W-1:0]   curP;
    logic [W-1:0]   curT;
    logic           crossing;

    logic           inRun;
    logic [R_W-1:0] bestIdx;
    logic [W-1:0]   bestP;

    logic           candValid;
    logic [R_W-1:0] candIdx;
    logic [W-1:0]   candP;

    logic           hasDet;
    logic [R_W-1:0] lastIdx;
    logic [W-1:0]   lastP;
    logic [R_W:0]   total;
    logic           ovf;
    logic [R_W-1:0] detIdx[MAXDET];

    logic           finish;

    always_ff @(posedge clk_i)begin
        if(valid_i)begin
            acOld <= mem[rangeIdx_i];
        end
        acCut   <= cut_i;
        acThr   <= threshold_i;
        acRange <= rangeIdx_i;
        acFirst <= (dopplerIdx_i == '0);
        if(acValid)begin
            mem[acRange] <= acFirst ? {acCut, acThr}
                                    : {(acCut > acOld[2*W-1:W]) ? acCut : acOld[2*W-1:W],
                                       (acThr > acOld[W-1:0])   ? acThr : acOld[W-1:0]};
        end
        if(scanning)begin
            rdData <= mem[scanAddr];
        end
        rdIdx <= scanAddr;
    end

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            acValid  <= 0;
            acLast   <= 0;
            scanning <= 0;
            scanAddr <= 0;
            rdValid  <= 0;
            rdEnd    <= 0;
        end else begin
            acValid <= valid_i;
            acLast  <= valid_i && (dopplerIdx_i == $clog2(FFT_POINT)'(FFT_POINT-1)) && (rangeIdx_i == R_W'(FAST_SIGNAL-1));
            rdValid <= scanning;
            rdEnd   <= scanning && (scanAddr == R_W'(FAST_SIGNAL-1));
            if(acLast)begin
                scanning <= 1;
                scanAddr <= 0;
            end else if(scanning)begin
                if(scanAddr == R_W'(FAST_SIGNAL-1))begin
                    scanning <= 0;
                end else begin
                    scanAddr <= scanAddr + 1'b1;
                end
            end
        end
    end

    assign curP     = rdData[2*W-1:W];
    assign curT     = rdData[W-1:0];
    assign crossing = curP > curT;

    always_comb begin
        candValid = 1'b0;
        candIdx   = bestIdx;
        candP     = bestP;
        if(rdValid)begin
            if(crossing && rdEnd)begin
                candValid = 1'b1;
                if(!inRun || curP > bestP)begin
                    candIdx = rdIdx;
                    candP   = curP;
                end
            end else if(!crossing && inRun)begin
                candValid = 1'b1;
            end
        end
    end

    logic signed [W+1:0] diff;
    logic                close;
    logic                similar;
    assign diff    = $signed({2'b00, candP}) - $signed({2'b00, lastP});
    assign close   = (candIdx - lastIdx) < maxGap_i;
    assign similar = (diff >= $signed(logRatio_i)) && (diff <= -$signed(logRatio_i));

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            inRun   <= 0;
            bestIdx <= 0;
            bestP   <= 0;
            hasDet  <= 0;
            lastIdx <= 0;
            lastP   <= 0;
            total   <= 0;
            ovf     <= 0;
            finish  <= 0;
            done_o  <= 0;
            count_o <= 0;
            overflow_o <= 0;
            for(int i = 0; i < MAXDET; i++)begin
                detIdx[i] <= 0;
            end
            idx_o <= 0;
        end else begin
            finish <= rdValid && rdEnd;
            done_o <= finish;

            if(acLast)begin
                inRun  <= 0;
                hasDet <= 0;
                total  <= 0;
                ovf    <= 0;
            end

            if(rdValid)begin
                if(crossing)begin
                    if(!inRun)begin
                        inRun   <= 1;
                        bestIdx <= rdIdx;
                        bestP   <= curP;
                    end else if(curP > bestP)begin
                        bestIdx <= rdIdx;
                        bestP   <= curP;
                    end
                end else begin
                    inRun <= 0;
                end
                if(rdEnd)begin
                    inRun <= 0;
                end
            end

            if(candValid)begin
                if(hasDet && close && !similar)begin
                    if(candP > lastP)begin
                        lastIdx <= candIdx;
                        lastP   <= candP;
                        if(total <= (R_W+1)'(MAXDET))begin
                            detIdx[total-1] <= candIdx;
                        end
                    end
                end else begin
                    hasDet  <= 1;
                    lastIdx <= candIdx;
                    lastP   <= candP;
                    total   <= total + 1'b1;
                    if(total < (R_W+1)'(MAXDET))begin
                        detIdx[total] <= candIdx;
                    end else begin
                        ovf <= 1;
                    end
                end
            end

            if(finish)begin
                count_o    <= (total > (R_W+1)'(MAXDET)) ? N_W'(MAXDET) : N_W'(total);
                overflow_o <= ovf;
                for(int i = 0; i < MAXDET; i++)begin
                    idx_o[i*R_W +: R_W] <= (i < total) ? detIdx[i] : '0;
                end
            end
        end
    end
endmodule
