module axiLiteRegsRTL import parameters::*; (
    input  logic                                  clk_i,
    input  logic                                  rst_ni,

    input  logic [7:0]                            s_axil_awaddr,
    input  logic                                  s_axil_awvalid,
    output logic                                  s_axil_awready,
    input  logic [31:0]                           s_axil_wdata,
    input  logic [3:0]                            s_axil_wstrb,
    input  logic                                  s_axil_wvalid,
    output logic                                  s_axil_wready,
    output logic [1:0]                            s_axil_bresp,
    output logic                                  s_axil_bvalid,
    input  logic                                  s_axil_bready,
    input  logic [7:0]                            s_axil_araddr,
    input  logic                                  s_axil_arvalid,
    output logic                                  s_axil_arready,
    output logic [31:0]                           s_axil_rdata,
    output logic [1:0]                            s_axil_rresp,
    output logic                                  s_axil_rvalid,
    input  logic                                  s_axil_rready,

    output logic                                  txValid_o,
    output logic signed [MF_TX_IN-1:0]            txReel_o,
    output logic signed [MF_TX_IN-1:0]            txComplex_o,

    output logic [$clog2(CFAR_REF+1)-1:0]         cfarK_o,
    output logic [XLEN_LOG_OUT-1:0]               cfarAlpha_o,
    output logic signed [XLEN_LOG_OUT-1:0]        ppLogRatio_o,
    output logic [$clog2(FAST_SIGNAL)-1:0]        ppMaxGap_o,

    input  logic                                  cpiStart_i,
    input  logic                                  cpiEnd_i,
    input  logic                                  done_i,
    input  logic [$clog2(MAXDET+1)-1:0]           count_i,
    input  logic                                  overflow_i,
    input  logic [MAXDET*$clog2(FAST_SIGNAL)-1:0] idx_i,
    input  logic                                  ct1Busy_i,
    input  logic                                  ct2Busy_i,

    output logic                                  irq_o
);
    localparam int R_W = $clog2(FAST_SIGNAL);

    logic [31:0] txReg[TX_DEPTH];
    logic        txLoaded;
    logic        txLoading;
    logic [$clog2(TX_DEPTH)-1:0] txPtr;

    logic        doneFlag;
    logic        timing;
    logic [31:0] latency;
    logic [31:0] latencyCnt;
    logic [31:0] cpiCount;

    logic        wrFire;
    logic [7:0]  wrAddr;
    logic        awHold, wHold;
    logic [7:0]  awAddrHold;
    logic [31:0] wDataHold;

    assign s_axil_awready = !awHold;
    assign s_axil_wready  = !wHold;
    assign s_axil_bresp   = 2'b00;
    assign s_axil_rresp   = 2'b00;
    assign wrFire         = (awHold || s_axil_awvalid) && (wHold || s_axil_wvalid) && !s_axil_bvalid;
    assign wrAddr         = awHold ? awAddrHold : s_axil_awaddr;

    logic [31:0] wrData;
    assign wrData = wHold ? wDataHold : s_axil_wdata;

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            awHold        <= 0;
            wHold         <= 0;
            awAddrHold    <= 0;
            wDataHold     <= 0;
            s_axil_bvalid <= 0;
            cfarK_o       <= CFAR_K;
            cfarAlpha_o   <= CFAR_ALPHA;
            ppLogRatio_o  <= PP_LOGRATIO;
            ppMaxGap_o    <= PP_MAX_GAP;
            txLoading     <= 0;
            txLoaded      <= 0;
            txPtr         <= 0;
            txValid_o     <= 0;
            doneFlag      <= 0;
            for(int i = 0; i < TX_DEPTH; i++)begin
                txReg[i] <= 0;
            end
        end else begin
            if(s_axil_awvalid && s_axil_awready && !wrFire)begin
                awHold     <= 1;
                awAddrHold <= s_axil_awaddr;
            end
            if(s_axil_wvalid && s_axil_wready && !wrFire)begin
                wHold     <= 1;
                wDataHold <= s_axil_wdata;
            end
            if(s_axil_bvalid && s_axil_bready)begin
                s_axil_bvalid <= 0;
            end

            txValid_o <= txLoading;
            if(txLoading)begin
                if(txPtr == $clog2(TX_DEPTH)'(TX_DEPTH-1))begin
                    txLoading <= 0;
                    txLoaded  <= 1;
                end
                txPtr <= txPtr + 1'b1;
            end

            if(done_i)begin
                doneFlag <= 1;
            end
            if(cpiStart_i)begin
                doneFlag <= 0;
            end

            if(wrFire)begin
                awHold        <= 0;
                wHold         <= 0;
                s_axil_bvalid <= 1;
                case(wrAddr)
                    8'h00: begin
                        if(wrData[0])begin
                            txLoading <= 1;
                            txLoaded  <= 0;
                            txPtr     <= 0;
                        end
                        if(wrData[1])begin
                            doneFlag <= 0;
                        end
                    end
                    8'h08: cfarK_o      <= wrData[$clog2(CFAR_REF+1)-1:0];
                    8'h0C: cfarAlpha_o  <= wrData[XLEN_LOG_OUT-1:0];
                    8'h10: ppLogRatio_o <= wrData[XLEN_LOG_OUT-1:0];
                    8'h14: ppMaxGap_o   <= wrData[R_W-1:0];
                    default: begin
                        if(wrAddr >= 8'h80 && wrAddr < 8'h80 + 8'(4*TX_DEPTH))begin
                            txReg[(wrAddr - 8'h80) >> 2] <= wrData;
                        end
                    end
                endcase
            end
        end
    end

    always_ff @(posedge clk_i)begin
        txReel_o    <= txReg[txPtr][MF_TX_IN-1:0];
        txComplex_o <= txReg[txPtr][2*MF_TX_IN-1:MF_TX_IN];
    end

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            timing     <= 0;
            latencyCnt <= 0;
            latency    <= 0;
            cpiCount   <= 0;
        end else begin
            if(cpiEnd_i)begin
                timing     <= 1;
                latencyCnt <= 0;
            end else if(timing)begin
                latencyCnt <= latencyCnt + 1'b1;
                if(done_i)begin
                    timing   <= 0;
                    latency  <= latencyCnt + 1'b1;
                    cpiCount <= cpiCount + 1'b1;
                end
            end
        end
    end

    assign irq_o = doneFlag;

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            s_axil_arready <= 0;
            s_axil_rvalid  <= 0;
            s_axil_rdata   <= 0;
        end else begin
            s_axil_arready <= 0;
            if(s_axil_rvalid && s_axil_rready)begin
                s_axil_rvalid <= 0;
            end
            if(s_axil_arvalid && !s_axil_arready && !s_axil_rvalid)begin
                s_axil_arready <= 1;
                s_axil_rvalid  <= 1;
                case(s_axil_araddr)
                    8'h04: s_axil_rdata <= {28'd0, txLoaded, ct2Busy_i, ct1Busy_i, doneFlag};
                    8'h08: s_axil_rdata <= 32'(cfarK_o);
                    8'h0C: s_axil_rdata <= 32'(cfarAlpha_o);
                    8'h10: s_axil_rdata <= 32'($signed(ppLogRatio_o));
                    8'h14: s_axil_rdata <= 32'(ppMaxGap_o);
                    8'h18: s_axil_rdata <= 32'(count_i);
                    8'h1C: s_axil_rdata <= 32'(overflow_i);
                    8'h20: s_axil_rdata <= latency;
                    8'h24: s_axil_rdata <= cpiCount;
                    default: begin
                        if(s_axil_araddr >= 8'h40 && s_axil_araddr < 8'h40 + 8'(4*MAXDET))begin
                            s_axil_rdata <= 32'(idx_i[((s_axil_araddr - 8'h40) >> 2)*R_W +: R_W]);
                        end else if(s_axil_araddr >= 8'h80 && s_axil_araddr < 8'h80 + 8'(4*TX_DEPTH))begin
                            s_axil_rdata <= txReg[(s_axil_araddr - 8'h80) >> 2];
                        end else begin
                            s_axil_rdata <= 32'hDEAD_BEEF;
                        end
                    end
                endcase
            end
        end
    end
endmodule
