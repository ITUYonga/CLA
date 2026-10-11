`timescale 1ns / 1ps

module Fetch2 #(
                parameter string PROGRAM_HEX = ""       // L3 icerigi : satir basina 16 bit, alt adres once
)(
                input logic clk ,
                input logic rst_n ,

                //////////////F1'den
                input logic [10:0]l3_adr ,
                input logic l3_en ,                     // F1 ilerlerken (en_F1F2) okunur, beklemede cikis korunur
                input logic f1f2_gecerli ,
                input logic [11:0]f1f2_pc ,

                //////////////boru hatti denetiminden
                input logic en ,
                input logic balon ,

                //////////////F2/D1 yazmaci
                output logic f2d1_gecerli ,
                output logic [11:0]f2d1_pc ,
                output logic [31:0]f2d1_kelime

                );



/////////////////////////L3 PROGRAM BELLEGI (4K x 16)

logic [15:0]l3 [0:4095];
logic [31:0]kelime;

initial begin
    if(PROGRAM_HEX != "") $readmemh(PROGRAM_HEX , l3);
end

always_ff@(posedge clk) begin

    if(l3_en) kelime <= {l3[{l3_adr , 1'b1}] , l3[{l3_adr , 1'b0}]};     // {MSW, LSW} : kelime F2'de hazir

end



/////////////////////////F2/D1 YAZMACI

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        f2d1_gecerli <= 1'b0;
        f2d1_pc <= 12'h000;
        f2d1_kelime <= 32'h0000_0000;
    end
    else if(balon) begin
        f2d1_gecerli <= 1'b0;
    end
    else if(en) begin
        f2d1_gecerli <= f1f2_gecerli;
        f2d1_pc <= f1f2_pc;
        f2d1_kelime <= kelime;
    end

end



endmodule
