`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2026 16:53:51
// Design Name: 
// Module Name: fpu
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
    

    

    

module fpu_carpma(
    
    input logic[1:0] hedef_mr,
    input logic rnd, 
    input logic valid,
    input logic clk,
    input logic rst,
    input logic [31:0]fp_a  ,
    input logic [31:0]fp_b,
 
    
    output logic lvf,
    output logic luf , 
    output logic [31:0] result ,
    output logic valid_out,
    output logic [1:0]hedef_mr_out   

    );

logic[64:0] k_yazmaci ; 



//Clasify ciktilari
logic [1:0]ozel_durumlar_a;
logic sign_a_out ; 
logic [7:0]exp_a_out;
logic [23:0]mantissa_a_out;

logic [1:0]ozel_durumlar_b;
logic sign_b_out ; 
logic [7:0]exp_b_out;
logic [23:0]mantissa_b_out;

//Carp_K1 ciktilari 
 logic [1:0]out_kod;
 logic out_sign;          
 logic [9:0]out_exp;      
 logic [47:0]out_mantissa;
 
 //Carp_K2 ciktilari
  logic [26:0] out_n_mantissa;   
  logic [9:0]exp_out;   
 
  logic lvf_out;
  logic luf_out;
 
clasify C_a(.fp(fp_a) , .sign(sign_a_out) , .exp(exp_a_out) , .mantissa(mantissa_a_out), .ozel_durumlar(ozel_durumlar_a));
clasify C_b(.fp(fp_b) , .sign(sign_b_out) , .exp(exp_b_out) , .mantissa(mantissa_b_out), .ozel_durumlar(ozel_durumlar_b));




carp_k1 M1(.kod_a(ozel_durumlar_a) , .kod_b(ozel_durumlar_b) , .sign_a(sign_a_out) , 
        .sign_b(sign_b_out ), .exp_a(exp_a_out) , .exp_b(exp_b_out) ,
        .mantissa_a(mantissa_a_out), .mantissa_b(mantissa_b_out) , .out_kod(out_kod),
        .out_sign(out_sign) , .out_exp(out_exp) ,.out_mantissa(out_mantissa)); 



     
always_ff@(posedge clk or negedge rst)begin
    if(!rst)
        k_yazmaci <= 65'b0 ; 

     else begin
        
        k_yazmaci <= {valid , hedef_mr , rnd , out_sign , out_exp , out_mantissa , out_kod};
        
            
     end

end




carp_k2 M2(.exp(k_yazmaci[59:50]) , .mantissa(k_yazmaci[49:2]) , .out_n_mantissa(out_n_mantissa) , .exp_out(exp_out));









pack P(.kod(k_yazmaci[1:0]) , .rnd(k_yazmaci[61]) , .sign(k_yazmaci[60]) , .exp_on(exp_out),
        .n_mantissa(out_n_mantissa) , .lvf(lvf_out) , .luf(luf_out) , .result(result));


assign valid_out = k_yazmaci[64] ; 
assign hedef_mr_out = k_yazmaci[63:62] ; 
assign lvf = lvf_out & valid_out;
assign luf = luf_out & valid_out;






endmodule 
