`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.09.2026 19:54:46
// Design Name: 
// Module Name: clasify
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


module clasify(

    input logic [31:0]fp,
    
    output logic [1:0]ozel_durumlar,
    output logic sign,
    output logic [7:0]exp,
    output logic [23:0]mantissa
    
    );
    
 logic POS_ZERO;
 logic NEG_ZERO;
 logic DENORMAL;
 logic NORMAL ;
 logic POS_INF ;
 logic NEG_INF ;
 logic INF;
 logic NAN ;
 logic ZERO ; 
    
    
    
    
    
    
    
    always_comb begin
    
         sign = fp[31];
         exp = fp[30:23];
         mantissa = fp[22:0];
    
         POS_ZERO = (fp == 32'b0);
         NEG_ZERO = (fp == 32'h80000000);
         DENORMAL = (exp == 8'b0) && (mantissa != 23'b0) ;
         NORMAL = (exp <= 8'hFE && exp >= 8'h01);
         POS_INF = (sign == 1'b0) && (exp == 8'hFF) && (mantissa == 23'b0);
         NEG_INF =  (sign == 1'b1) && (exp == 8'hFF) && (mantissa == 23'b0);
         INF = POS_INF || NEG_INF ; 
         ZERO = POS_ZERO || NEG_ZERO||DENORMAL ;
         NAN = (exp == 8'hFF) && (mantissa != 23'b0);
      
        if(NAN)
            ozel_durumlar = 2'b11;
        
        if(ZERO)
            ozel_durumlar = 2'b10;
        
        if(INF)
            ozel_durumlar = 2'b01 ; 
            
        
        if(NORMAL)
            ozel_durumlar = 2'b00 ; 
            
      
        
        sign = fp[31];
        exp = fp[30:23];
        mantissa = {exp != 0 , fp[22:0]};

        
    end
    
    
    
endmodule

