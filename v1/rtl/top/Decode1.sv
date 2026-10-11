`timescale 1ns / 1ps

module Decode1
    import cla_pkg::*;
(
                input logic clk ,
                input logic rst_n ,

                //////////////F2/D1 yazmacindan
                input logic f2d1_gecerli ,
                input logic [11:0]f2d1_pc ,
                input logic [31:0]f2d1_kelime ,

                //////////////boru hatti denetiminden
                input logic en ,
                input logic balon ,

                //////////////D1/D2 yazmaci
                output logic d1d2_gecerli ,
                output logic [11:0]d1d2_pc ,
                output logic [31:0]d1d2_kelime ,
                output op_e d1d2_op ,
                output alanlar_t d1d2_alan ,
                output logic d1d2_kip_gecersiz

                );



/////////////////////////COZUCU

op_e op;
logic gecersiz;
logic kip_gecersiz;
alanlar_t alan;

cla_decoder DEC(.buyruk(f2d1_kelime) , .op(op) , .gecersiz(gecersiz) , .kip_gecersiz(kip_gecersiz) , .alan(alan));



/////////////////////////D1/D2 YAZMACI

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        d1d2_gecerli <= 1'b0;
        d1d2_pc <= 12'h000;
        d1d2_kelime <= 32'h0000_0000;
        d1d2_op <= OP_GECERSIZ;
        d1d2_alan <= '0;
        d1d2_kip_gecersiz <= 1'b0;
    end
    else if(balon) begin
        d1d2_gecerli <= 1'b0;
    end
    else if(en) begin
        d1d2_gecerli <= f2d1_gecerli;
        d1d2_pc <= f2d1_pc;
        d1d2_kelime <= f2d1_kelime;
        d1d2_op <= op;
        d1d2_alan <= alan;
        d1d2_kip_gecersiz <= kip_gecersiz;
    end

end



endmodule
