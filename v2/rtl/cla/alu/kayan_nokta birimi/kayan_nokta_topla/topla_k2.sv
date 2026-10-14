`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2026 15:35:21
// Design Name: 
// Module Name: topla_k2
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

module topla_k2(
    
    input logic cik ,
    input logic[1:0] kod , 
    input logic [7:0]exp_a , 
    input logic [26:0]mantissa_a, 
    input logic [26:0]mantissa_b,
    
    output logic [1:0]kod_out,
    output logic [9:0]exp_out,
    output logic [26:0]mantissa_out
    
    



    );
    
    logic G , R, S ; 
    logic [4:0]leading_zeros;
    logic [27:0]ara_deger_top;
    logic [26:0]ara_deger_cik;
    
    always_comb begin 
    
    leading_zeros = 5'd24; // Varsayılan değer (hepsi sıfırsa)
    
    // MSB'den (23) LSB'ye doğru ilk '1' bitini bulma

    
    
    
        if(cik == 0)begin
            
            ara_deger_top = mantissa_a + mantissa_b ; 
            if(ara_deger_top[27] == 1)begin
                exp_out = exp_a + 1  ;
                mantissa_out = {ara_deger_top[27:2] , ara_deger_top[1]|ara_deger_top[0]};
            end    
            
            else begin
                exp_out = exp_a  ;
                mantissa_out = {ara_deger_top[26:0]};
            end  
            
            
        
        end
        
        else begin
            ara_deger_cik = mantissa_a - mantissa_b;
                for (int i = 26; i >= 0; i--) begin
             
                if (ara_deger_cik[i]) begin
                    leading_zeros = 5'd26 - i[4:0];
                    break; // Sentezlenebilir 'break' ilk karşılaşılan biti kilitler
                end
            end
            
                mantissa_out = ara_deger_cik << leading_zeros ; 
                exp_out = exp_a - leading_zeros ; 
        
        end
    
  
       if(kod == NORMAL && mantissa_out == 0 )
            kod_out = ZERO; 
       
       else
            kod_out = kod ; 
    
    
    
    end
    
    
    
    
endmodule
