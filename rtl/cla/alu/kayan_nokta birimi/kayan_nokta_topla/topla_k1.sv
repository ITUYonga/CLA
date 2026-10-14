`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2026 14:15:18
// Design Name: 
// Module Name: topla_k1
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

module topla_k1(

    input logic cikarma , 
    input logic sign_a,
    input logic sign_b,
    input logic [1:0]kod_a ,
    input logic [1:0] kod_b , 
    input logic [7:0] exp_a , 
    input logic [7:0] exp_b ,
    input logic [23:0] mantissa_a ,
    input logic [23:0] mantissa_b ,
    
    output logic[1:0] out_kod, 
    output logic sign_out_b,
    output logic [7:0]out_exp,
    output logic [26:0]out_mantissa_a,
    output logic [26:0]out_mantissa_b,
    output logic out_sign ,
    output logic cik

    );
    
    logic [23:0]mantissa_a_m;
    logic [23:0]mantissa_b_m;
    logic [8:0]d;
    logic [49:0]shifted_mantissa ;
    logic [26:0] aligned_mantissa;
    always_comb begin
    logic [4:0]min_shift ; 
      
      
      sign_out_b = sign_b ^cikarma ;      
      
      if(kod_a == NAN || kod_b == NAN || (kod_a == INF && kod_b == INF && sign_a != sign_out_b))
            out_kod = NAN;
    
        
       else if(kod_a == INF || kod_b == INF)
            out_kod = INF;
            
       
       else
             out_kod = NORMAL;
       
       mantissa_a_m = mantissa_a;
       mantissa_b_m = mantissa_b;
       
       if(kod_a ==ZERO)
            mantissa_a_m = 0 ; 
       
       if(kod_b == ZERO)
            mantissa_b_m = 0;
       
      if({exp_b, mantissa_b_m[22:0]} > {exp_a, mantissa_a_m[22:0]} )begin
        
            out_sign = sign_out_b ; 
      
            d = exp_b - exp_a  ;
             min_shift = (d < 26) ? d : 26;
            shifted_mantissa =  {mantissa_a_m , 26'b0 } >> min_shift ; 
            out_exp = exp_b;
            out_mantissa_a = {mantissa_b_m , 3'b000 } ; 
       end
       else begin
       
            out_sign = sign_a ; 
            d = exp_a - exp_b  ;
            min_shift = (d < 26) ? d : 26;
            shifted_mantissa =  {mantissa_b_m , 26'b0 } >> min_shift ;
            out_exp = exp_a;
            out_mantissa_a = {mantissa_a_m , 3'b000 } ; 
       end
        
        aligned_mantissa = {shifted_mantissa[49:26] , shifted_mantissa[25:24] , |shifted_mantissa[23:0] } ; 
        out_mantissa_b = aligned_mantissa;
        cik = sign_a ^ sign_out_b ; 
        
    end
    
    
endmodule
