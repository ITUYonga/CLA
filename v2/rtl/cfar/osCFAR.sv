module osCfarRTL import parameters::*; (
    input  logic                                  clk_i,
    input  logic                                  rst_ni,

    input  logic                                  valid_i,
    input  logic                                  sof_i,
    input  logic [XLEN_LOG_OUT-1:0]               power_i,
    input  logic [XLEN_LOG_OUT-1:0]               alpha_i,
    input  logic [$clog2(CFAR_REF+1)-1:0]         k_i,

    output logic                                  valid_o,
    output logic                                  sof_o,
    output logic                                  detect_o,
    output logic [XLEN_LOG_OUT-1:0]               cut_o,
    output logic [XLEN_LOG_OUT-1:0]               threshold_o,
    output logic [$clog2(FAST_SIGNAL)-1:0]        rangeIdx_o,
    output logic [$clog2(FFT_POINT)-1:0]          dopplerIdx_o
);
    localparam int W          = XLEN_LOG_OUT;
    localparam int WX         = W + 1;
    localparam int HALF_REF   = CFAR_REF / 2;
    localparam int HALF_GUARD = CFAR_GUARD / 2;
    localparam int HALF       = HALF_REF + HALF_GUARD;
    localparam int WIN        = 2*HALF + 1;
    localparam int R_W        = $clog2(FAST_SIGNAL + HALF + 1);
    localparam int RO_W       = $clog2(FAST_SIGNAL);
    localparam int D_W        = $clog2(FFT_POINT);
    localparam int RANK_W     = $clog2(CFAR_REF);
    localparam int K_W        = $clog2(CFAR_REF + 1);
    localparam int PAIRS      = CFAR_REF * (CFAR_REF - 1) / 2;

    logic [W-1:0]   window[0:WIN-1];
    logic [R_W-1:0] rNew;
    logic [R_W-1:0] rNewNow;
    logic [D_W-1:0] dopplerCnt;
    logic [D_W-1:0] dopplerNow;
    logic           flushing;
    logic           shiftEn;

    logic           wValid, wSof;
    logic [R_W-1:0] wCut;
    logic [D_W-1:0] wDoppler;

    logic [WX-1:0]    refComb[0:CFAR_REF-1];
    logic [CFAR_REF-1:0] maskComb;
    logic [PAIRS-1:0] belowComb;

    logic           s1Valid, s1Sof;
    logic [R_W-1:0] s1Cut;
    logic [D_W-1:0] s1Doppler;
    logic [W-1:0]   s1CutVal;
    logic [WX-1:0]  s1Ref[0:CFAR_REF-1];
    logic [PAIRS-1:0] s1Below;
    logic [K_W-1:0] s1NValid;

    logic [CFAR_REF-1:0] belowVec[0:CFAR_REF-1];
    logic [RANK_W-1:0]   rankComb[0:CFAR_REF-1];

    logic           s2Valid, s2Sof;
    logic [R_W-1:0] s2Cut;
    logic [D_W-1:0] s2Doppler;
    logic [W-1:0]   s2CutVal;
    logic [WX-1:0]  s2Ref[0:CFAR_REF-1];
    logic [RANK_W-1:0] s2Rank[0:CFAR_REF-1];
    logic [K_W-1:0] s2KEff;

    logic [WX-1:0]  selectComb;

    logic           s3Valid, s3Sof;
    logic [R_W-1:0] s3Cut;
    logic [D_W-1:0] s3Doppler;
    logic [W-1:0]   s3CutVal;
    logic [W-1:0]   s3Select;

    logic [W:0]     thresholdSum;
    logic [W-1:0]   thresholdComb;

    function automatic int pairIndex(input int i, input int j);
        return i*CFAR_REF - (i*(i+1))/2 + (j - i - 1);
    endfunction

    assign flushing   = (rNew >= R_W'(FAST_SIGNAL)) && (rNew < R_W'(FAST_SIGNAL + HALF));
    assign shiftEn    = valid_i || flushing;
    assign rNewNow    = sof_i ? '0 : rNew;
    assign dopplerNow = sof_i ? dopplerCnt + 1'b1 : dopplerCnt;

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            rNew       <= R_W'(FAST_SIGNAL + HALF);
            dopplerCnt <= '1;
            wValid     <= 0;
            wSof       <= 0;
        end else begin
            if(shiftEn)begin
                rNew <= rNewNow + 1'b1;
            end
            if(valid_i)begin
                dopplerCnt <= dopplerNow;
            end
            wValid <= shiftEn && (rNewNow >= R_W'(HALF));
            wSof   <= shiftEn && (rNewNow == R_W'(HALF));
        end
    end

    always_ff @(posedge clk_i)begin
        if(shiftEn)begin
            window[0] <= valid_i ? power_i : '0;
            for(int i = 1; i < WIN; i++)begin
                window[i] <= window[i-1];
            end
            wCut     <= rNewNow - R_W'(HALF);
            wDoppler <= dopplerNow;
        end
    end

    always_comb begin
        for(int i = 0; i < CFAR_REF; i++)begin
            if(i < HALF_REF)begin
                maskComb[i] = (wCut + R_W'(HALF - i)) <= R_W'(FAST_SIGNAL - 1);
                refComb[i]  = maskComb[i] ? {1'b0, window[i]} : '1;
            end else begin
                maskComb[i] = wCut >= R_W'(i + 2*HALF_GUARD + 1 - HALF);
                refComb[i]  = maskComb[i] ? {1'b0, window[i + 2*HALF_GUARD + 1]} : '1;
            end
        end
        for(int i = 0; i < CFAR_REF; i++)begin
            for(int j = i + 1; j < CFAR_REF; j++)begin
                belowComb[pairIndex(i, j)] = (refComb[i] <= refComb[j]);
            end
        end
    end

    always_ff @(posedge clk_i)begin
        s1Cut     <= wCut;
        s1Doppler <= wDoppler;
        s1CutVal  <= window[HALF];
        s1Below   <= belowComb;
        s1NValid  <= K_W'($countones(maskComb));
        for(int i = 0; i < CFAR_REF; i++)begin
            s1Ref[i] <= refComb[i];
        end
    end

    always_comb begin
        for(int i = 0; i < CFAR_REF; i++)begin
            for(int j = 0; j < CFAR_REF; j++)begin
                if(j < i)begin
                    belowVec[i][j] = s1Below[pairIndex(j, i)];
                end else if(j > i)begin
                    belowVec[i][j] = !s1Below[pairIndex(i, j)];
                end else begin
                    belowVec[i][j] = 1'b0;
                end
            end
            rankComb[i] = RANK_W'($countones(belowVec[i]));
        end
    end

    always_ff @(posedge clk_i)begin
        s2Cut     <= s1Cut;
        s2Doppler <= s1Doppler;
        s2CutVal  <= s1CutVal;
        s2KEff    <= (k_i < s1NValid) ? k_i : s1NValid;
        for(int i = 0; i < CFAR_REF; i++)begin
            s2Ref[i]  <= s1Ref[i];
            s2Rank[i] <= rankComb[i];
        end
    end

    always_comb begin
        selectComb = '0;
        for(int i = 0; i < CFAR_REF; i++)begin
            selectComb = selectComb | ((RANK_W'(s2Rank[i]) == RANK_W'(s2KEff - 1'b1)) ? s2Ref[i] : '0);
        end
    end

    always_ff @(posedge clk_i)begin
        s3Cut     <= s2Cut;
        s3Doppler <= s2Doppler;
        s3CutVal  <= s2CutVal;
        s3Select  <= selectComb[W-1:0];
    end

    assign thresholdSum  = {1'b0, s3Select} + {1'b0, alpha_i};
    assign thresholdComb = thresholdSum[W] ? '1 : thresholdSum[W-1:0];

    always_ff @(posedge clk_i)begin
        detect_o     <= (s3CutVal > thresholdComb);
        cut_o        <= s3CutVal;
        threshold_o  <= thresholdComb;
        rangeIdx_o   <= RO_W'(s3Cut);
        dopplerIdx_o <= s3Doppler;
    end

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            s1Valid <= 0;
            s1Sof   <= 0;
            s2Valid <= 0;
            s2Sof   <= 0;
            s3Valid <= 0;
            s3Sof   <= 0;
            valid_o <= 0;
            sof_o   <= 0;
        end else begin
            s1Valid <= wValid;
            s1Sof   <= wSof;
            s2Valid <= s1Valid;
            s2Sof   <= s1Sof;
            s3Valid <= s2Valid;
            s3Sof   <= s2Sof;
            valid_o <= s3Valid;
            sof_o   <= s3Sof;
        end
    end
endmodule
