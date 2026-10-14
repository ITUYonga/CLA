`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2026 09:10:36
// Design Name: 
// Module Name: carp_k1
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
import kod_sinifi::*;

module carp_k1(
       
       input logic [1:0]kod_a,
       input logic [1:0]kod_b,
       
       input logic sign_a , sign_b,
       
       input logic[7:0] exp_a , exp_b , 
       
       input logic[23:0] mantissa_a , 
       input logic[23:0] mantissa_b , 

        output logic [1:0]out_kod,
        output logic out_sign,
        output logic [9:0]out_exp,
        output logic [47:0]out_mantissa

    );

always_comb begin
    
    if((kod_a == NAN || kod_b == NAN)||(kod_a == INF && kod_b == ZERO) ||(kod_a == ZERO && kod_b == INF))
        out_kod = NAN ;
    
    else if(kod_a == INF || kod_b == INF)begin
        out_kod = INF ;
    end
    
    else if(kod_a == ZERO || kod_b == ZERO)begin
         out_kod = ZERO;
    end
    
    else
        out_kod = NORMAL;
    
    
    
    out_mantissa = mantissa_a * mantissa_b ; 
    out_sign  = sign_a ^ sign_b ; 
    
    out_exp = {2'b0 , exp_a } + {2'b0 , exp_b } - 8'd127; 
 
    end
endmodule
