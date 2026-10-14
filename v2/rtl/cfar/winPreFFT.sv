module winPreFFT import parameters::*;(
    input   logic                           clk_i,
    input   logic                           rst_ni,

    input   logic signed [WIN_PRE_FFT-1:0]  complex_i,
    input   logic signed [WIN_PRE_FFT-1:0]  reel_i,

    input   logic                           valid_i,
    input   logic                           sof_i,

    output  logic                           valid_o,
    output  logic                           sof_o,
    output  logic signed [WIN_PRE_FFT-1:0]  complex_o,
    output  logic signed [WIN_PRE_FFT-1:0]  reel_o
);
    localparam int N    = MTI_SIGNAL;
    localparam int FRAC = WIN_PRE_FFT_COEF_WIDTH - 2;
    localparam logic signed [WIN_PRE_FFT_MUL-1:0] RND = WIN_PRE_FFT_MUL'(1) <<< (FRAC-1);

    (* rom_style = "distributed" *) logic signed [WIN_PRE_FFT_COEF_WIDTH-1:0]mem[0:N-1];
    logic [4:0]address;
    logic [4:0]addressNow;
    logic signed [WIN_PRE_FFT_MUL-1:0]mulComplex;
    logic signed [WIN_PRE_FFT_MUL-1:0]mulReel;
    initial begin
        $readmemh(WIN_PRE_FFT_FILE, mem);
    end

    logic signed [WIN_PRE_FFT_COEF_WIDTH-1:0]coef;
    logic signed [WIN_PRE_FFT-1:0]stageComplex;
    logic signed [WIN_PRE_FFT-1:0]stageReel;
    logic stageValid;
    logic stageSof;

    assign addressNow = sof_i ? 0 : address;

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            address <= 0;
            stageValid <= 0;
            stageSof <= 0;
            valid_o <= 0;
            sof_o <= 0;
        end else begin
            if(valid_i)begin
                if(addressNow == N-1)begin
                    address <= 0;
                end else begin
                    address <= addressNow + 1;
                end
            end
            stageValid <= valid_i;
            stageSof <= sof_i & valid_i;
            valid_o <= stageValid;
            sof_o <= stageSof;
        end
    end

    always_ff @(posedge clk_i)begin
        coef <= mem[addressNow];
        stageComplex <= complex_i;
        stageReel <= reel_i;
    end

    assign mulComplex = coef * stageComplex + RND;
    assign mulReel = coef * stageReel + RND;

    always_ff @(posedge clk_i)begin
        complex_o <= mulComplex[FRAC +: WIN_PRE_FFT];
        reel_o <= mulReel[FRAC +: WIN_PRE_FFT];
    end
endmodule