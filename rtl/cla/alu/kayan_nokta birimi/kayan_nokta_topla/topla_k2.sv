`timescale 1ns / 1ps

// MOD_TOPLA_K2 : 2 aşamalı FP32 toplayıcı/çıkarıcının 2. aşaması (K2); 27-bit toplama/çıkarma, baştaki sıfır sayma (LZC) ve normalleştirme yapar
//
//   Amaç:     K1 aşamasında hizalanmış 27-bitlik iki mantissayı cik bitine
//             göre toplar veya çıkarır. Toplamada taşma (bit 27 == 1) olursa
//             üssü 1 artırıp sağa 1 bit kaydırır (Sticky bitini koruyarak);
//             çıkarmada ise baştaki ilk '1' bitini (leading zeros) bularak
//             mantissayı sola kaydırır ve üssü kaydırma miktarı kadar
//             azaltır.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           cik:            Etkin işlem tipi (0: mantissa toplama, 1: mantissa
//                           çıkarma)
//           kod:            K1 aşamasından gelen 2-bitlik özel durum kodu
//           exp_a:          K1 aşamasından gelen 8-bitlik ortak üs
//           mantissa_a:     Büyük operandın 27-bitlik mantissası
//           mantissa_b:     Küçük operandın hizalanmış 27-bitlik mantissası
//   Outputlar:
//           kod_out:        Güncellenmiş 2-bitlik özel durum kodu (normal
//                           çıkarma sonucu 0 çıkarsa ZERO'ya döner)
//           exp_out:        Normalleştirme sonrası 10-bitlik işaretli üs
//           mantissa_out:   Normalleştirilmiş 27-bitlik mantissa ({M[23:0], G,
//                           R, S})
//
//   Notlar:
//           İki eşit büyüklükteki sayının farkı 0 olduğunda (kod == NORMAL
//           && mantissa_out == 0) kod_out = ZERO yapılarak pack modülünün
//           +0.0 (32'h0000_0000) üretmesi sağlanır.

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
