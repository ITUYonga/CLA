`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2026 18:26:26
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(

input logic clk ,
input logic rst,
input logic [31:0]a,
input logic [31:0]b,
input logic [31:0]c,
input logic [31:0]d,

input logic [4:0]topla_cntrl,
input logic [4:0]carpma_cntrl,
input logic [2:0]tamsayi_cntrl,

input logic [1:0]mux_1,
input logic [1:0]mux_2,
input logic [1:0]mux_3,
input logic [1:0]mux_4,
input logic [1:0]mux_5,
input logic [1:0]mux_6,


output logic lvf,
output logic luf,
output logic [31:0] result_topla, // KAYAN NOKTA
output logic [31:0] result_carp, // KAYAN NOKTA
output logic [31:0] result_tamsayi,
output logic [4:0]mstf_out //  4: TF 3: ZF 2:NF 1: LUF 0:LVF

    );
    

    
 logic [31:0]topla_in_1;
 logic [31:0]topla_in_2;
 
 logic [31:0]carpma_in_1;
 logic [31:0]carpma_in_2;
    
 logic [31:0]tamsayi_in_1;
 logic [31:0]tamsayi_in_2;
 


always_comb begin
    
    case(mux_1)
        
        2'b00 : topla_in_1 = a;
        2'b01 : topla_in_1 = b;
        2'b10 : topla_in_1 = c;
        2'b11 : topla_in_1 = d;
    
    endcase
    
        case(mux_2)
        
        2'b00 : topla_in_2 = a;
        2'b01 : topla_in_2 = b;
        2'b10 : topla_in_2 = c;
        2'b11 : topla_in_2 = d;
    
    endcase
    
        case(mux_3)
        
        2'b00 : carpma_in_1 = a;
        2'b01 : carpma_in_1 = b;
        2'b10 : carpma_in_1 = c;
        2'b11 : carpma_in_1 = d;
    
    endcase
        
        case(mux_4)
        
        2'b00 : carpma_in_2 = a;
        2'b01 : carpma_in_2 = b;
        2'b10 : carpma_in_2 = c;
        2'b11 : carpma_in_2 = d;
    
    endcase
        
                case(mux_5)
        
        2'b00 : tamsayi_in_1 = a;
        2'b01 : tamsayi_in_1  = b;
        2'b10 : tamsayi_in_1  = c;
        2'b11 : tamsayi_in_1  = d;
    
    endcase
            case(mux_6)
        
        2'b00 : tamsayi_in_2 = a;
        2'b01 : tamsayi_in_2  = b;
        2'b10 : tamsayi_in_2 = c;
        2'b11 : tamsayi_in_2  = d;
    
    endcase

end



fpu_toplama T(.clk(clk) , .rst(rst) , .fp_a(topla_in_1) , .fp_b(topla_in_2),
                .lvf(lvf) , .luf(luf) , .result(result_topla), .hedef_mr(topla_cntrl[4:3]),
                .rnd(topla_cntrl[2]) , .valid(topla_cntrl[1]) ,.cikarma(topla_cntrl[0]));






fpu_carpma C(.clk(clk) , .rst(rst) ,  .fp_a(carpma_in_1) , .fp_b(carpma_in_2),
                .valid(carpma_cntrl[1]) , .rnd(carpma_cntrl[2]) , .hedef_mr(carpma_cntrl[4:3]),
                .lvf(lvf) , .luf(luf) , .result(result_carp));
                


tamsayi_islem I(.in_1(tamsayi_in_1) , .in_2(tamsayi_in_2) , .alu_cntrl_1(tamsayi_cntrl),
                .mr_out3(result_tamsayi) , .mstf_out3(mstf_out));
        
    
endmodule
