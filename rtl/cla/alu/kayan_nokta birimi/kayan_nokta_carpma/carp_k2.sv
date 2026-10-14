`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2026 13:31:54
// Design Name: 
// Module Name: carp_k2
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


module carp_k2(

    input logic[9:0] exp, 
    input logic[47:0] mantissa,
    
    output logic [26:0]out_n_mantissa,
    
    output logic [9:0]exp_out

    );
    
    logic G ,R,S;
    
    always_comb begin
    
        if(mantissa[47]== 1'b1)begin
            
            exp_out = exp + 1'b1 ; 
            S = |mantissa[21:0];
            R = mantissa[22];
            G = mantissa[23] ; 
            
            
            out_n_mantissa = {mantissa[47:24] , G ,R ,S } ; 
            
            end
            
        else begin 
            
            S = |mantissa[20:0];
            R = mantissa[21];
            G = mantissa[22] ; 
            out_n_mantissa = {mantissa[46:23], G , R , S} ; 
            
            exp_out = exp ; 
    
    end
    end
    
endmodule
