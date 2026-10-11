module mtiFilterRTL import parameters::*; (
    input logic clk_i,
    input logic rst_ni,

    input logic valid_i,
    input logic sof_i,

    input logic signed [MTI_IN-1:0]reel_i,
    input logic signed [MTI_IN-1:0]complex_i,

    output logic valid_o,
    output logic sof_o,

    output logic signed [MTI_OUT-1:0] complex_o,
    output logic signed [MTI_OUT-1:0] reel_o
);  
    logic signed [MTI_IN-1:0]complexMem[2:0];
    logic signed [MTI_IN-1:0]reelMem[2:0];

    logic stageValid;
    logic stageSof;

    logic [1:0]counter;
    logic [1:0]counterNow;

    logic signed [MTI_OUT-1:0]mtiComplex;
    logic signed [MTI_OUT-1:0]mtiReel;

    assign counterNow = sof_i ? 2'd0 : counter;

    always_ff @(posedge clk_i)begin
        if(valid_i)begin
            complexMem[2] <= complex_i;
            complexMem[1] <= complexMem[2];
            complexMem[0] <= complexMem[1];
            reelMem[2] <= reel_i;
            reelMem[1] <= reelMem[2];
            reelMem[0] <= reelMem[1];
        end
    end

    always_ff @(posedge clk_i , negedge rst_ni)begin
        if(!rst_ni)begin
            counter <= 0;
            stageValid <= 0;
            stageSof <= 0;
            valid_o <= 0;
            sof_o <= 0;
        end else begin
            if(valid_i && counterNow != 2'd3)begin
                counter <= counterNow + 1;
            end else if(valid_i)begin
                counter <= counterNow;
            end
            stageValid <= valid_i && (counterNow >= 2'd2);
            stageSof <= valid_i && (counterNow == 2'd2);
            valid_o <= stageValid;
            sof_o <= stageSof;
        end
    end

    assign mtiComplex = MTI_OUT'(complexMem[0]) - (MTI_OUT'(complexMem[1]) <<< 1) + MTI_OUT'(complexMem[2]);
    assign mtiReel = MTI_OUT'(reelMem[0]) - (MTI_OUT'(reelMem[1]) <<< 1) + MTI_OUT'(reelMem[2]);

    always_ff @(posedge clk_i)begin
        complex_o <= mtiComplex;
        reel_o <= mtiReel;
    end
endmodule
