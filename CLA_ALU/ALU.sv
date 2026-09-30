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

input logic [4:0]topla_cntrl, //CONTROL
input logic [4:0]carpma_cntrl, //CONTROL
input logic [2:0]tamsayi_cntrl, //CONTROL
input logic kestirme_cntrl, //CONTROL
input logic [6:0]karsilastirma_cntrl, //CONTROL [6:4] islem (000 MCMPF32, 001 MMAXF32, 010 MMINF32, 011 MABSF32, 100 MNEGF32) [3:0] CNDF
input logic [4:0]mstf_in, //CONTROL 4: TF 3: ZF 2:NF 1: LUF 0:LVF (MNEGF32 kosulu icin)
input logic [4:0]donusum_cntrl, //CONTROL [4] RND32 (yalniz int -> float) [3:0] islem (donusum.sv fpu_op_e)
input logic [1:0]mux_1, //CONTROL
input logic [1:0]mux_2, //CONTROL
input logic [1:0]mux_3, //CONTROL
input logic [1:0]mux_4, //CONTROL
input logic [1:0]mux_5, //CONTROL
input logic [1:0]mux_6, //CONTROL
input logic [1:0]mux_7, //CONTROL
input logic [1:0]mux_8, //CONTROL
input logic [1:0]mux_9, //CONTROL
input logic [1:0]mux_10, //CONTROL


output logic lvf_topla,
output logic luf_topla,
output logic lvf_carp,
output logic luf_carp,
output logic [31:0] result_kestirme, // KAYAN NOKTA
output logic lvf_kestirme,
output logic luf_kestirme,
output logic [31:0] result_topla, // KAYAN NOKTA
output logic [31:0] result_carp, // KAYAN NOKTA
output logic [31:0] result_tamsayi,
output logic [4:0]mstf_out, //  4: TF 3: ZF 2:NF 1: LUF 0:LVF
output logic [31:0] result_karsilastirma, // KAYAN NOKTA (MCMPF32'de yazilmaz)
output logic zf_karsilastirma,
output logic nf_karsilastirma,
output logic [31:0] result_donusum, // KAYAN NOKTA veya TAMSAYI (buyruga gore)
    output logic valid_carp,
    output logic [1:0]hedef_mr_out_carp, 
    output logic valid_topla,
    output logic [1:0]hedef_mr_out_topla

    );
    

    
 logic [31:0]topla_in_1;
 logic [31:0]topla_in_2;
 
 logic [31:0]carpma_in_1;
 logic [31:0]carpma_in_2;
    
 logic [31:0]tamsayi_in_1;
 logic [31:0]tamsayi_in_2;

 logic [31:0]kestirim_in;

 logic [31:0]karsilastirma_in_1;
 logic [31:0]karsilastirma_in_2;

 logic [31:0]donusum_in;
 


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

                case(mux_7)
        
        2'b00 : kestirim_in = a;
        2'b01 : kestirim_in  = b;
        2'b10 : kestirim_in = c;
        2'b11 : kestirim_in  = d;
    
    endcase


                case(mux_8)
        
        2'b00 : karsilastirma_in_1 = a;
        2'b01 : karsilastirma_in_1  = b;
        2'b10 : karsilastirma_in_1 = c;
        2'b11 : karsilastirma_in_1  = d;
    
    endcase

                case(mux_9)
        
        2'b00 : karsilastirma_in_2 = a;
        2'b01 : karsilastirma_in_2  = b;
        2'b10 : karsilastirma_in_2 = c;
        2'b11 : karsilastirma_in_2  = d;
    
    endcase

                case(mux_10)
        
        2'b00 : donusum_in = a;
        2'b01 : donusum_in  = b;
        2'b10 : donusum_in = c;
        2'b11 : donusum_in  = d;
    
    endcase

end



fpu_toplama T(.clk(clk) , .rst(rst) , .fp_a(topla_in_1) , .fp_b(topla_in_2),
                .lvf(lvf_topla) , .luf(luf_topla) , .result(result_topla), .hedef_mr(topla_cntrl[4:3]),
                .rnd(topla_cntrl[2]) , .valid(topla_cntrl[1]) ,.cikarma(topla_cntrl[0]),
                .valid_out(valid_topla) , .hedef_mr_out(hedef_mr_out_topla));






fpu_carpma C(.clk(clk) , .rst(rst) ,  .fp_a(carpma_in_1) , .fp_b(carpma_in_2),
                .valid(carpma_cntrl[1]) , .rnd(carpma_cntrl[2]) , .hedef_mr(carpma_cntrl[4:3]),
                .lvf(lvf_carp) , .luf(luf_carp) , .result(result_carp),
                .valid_out(valid_carp) , .hedef_mr_out(hedef_mr_out_carp));
                


tamsayi_islem I(.in_1(tamsayi_in_1) , .in_2(tamsayi_in_2) , .alu_cntrl_1(tamsayi_cntrl),
                .mr_out3(result_tamsayi) , .mstf_out3(mstf_out)
                 );




fpu_kestirme Ke(.fp(kestirim_in) , .kestirme_cntrl(kestirme_cntrl) , .result(result_kestirme) , .lvf(lvf_kestirme) , .luf(luf_kestirme));
        

    
fpu_karsilastirma Ka(.fp_1(karsilastirma_in_1) , .fp_2(karsilastirma_in_2) ,
                .islem(karsilastirma_cntrl[6:4]) , .cndf(karsilastirma_cntrl[3:0]) , .mstf(mstf_in) ,
                .result(result_karsilastirma) , .zf(zf_karsilastirma) , .nf(nf_karsilastirma));


fpu_donusum Do(.fp(donusum_in) , .donusum_cntrl(donusum_cntrl[3:0]) , .rnd(donusum_cntrl[4]) , .result(result_donusum));

endmodule
