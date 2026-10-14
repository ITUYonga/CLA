`timescale 1ns / 1ps

// MOD_CARP_K1 : 2 aşamalı FP32 çarpıcının 1. aşaması (K1); 24x24-bit mantissa çarpımı, üs toplamı ve özel durum tespitini yapar
//
//   Amaç:     İki FP32 operandının 24-bitlik mantissalarını çarparak
//             48-bitlik çarpım sonucunu (out_mantissa) üretir, 8-bitlik
//             üslerini toplayıp 127 bias değerini çıkararak 10-bitlik ön
//             üssü (out_exp) hesaplar, işaret bitlerini XOR'lar ve 0*Inf ->
//             NaN dahil özel durum kodunu (out_kod) belirler.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           kod_a:          1. operandın 2-bitlik özel durum kodu
//           kod_b:          2. operandın 2-bitlik özel durum kodu
//           sign_a:         1. operandın işaret biti
//           sign_b:         2. operandın işaret biti
//           exp_a:          1. operandın 8-bit üs alanı
//           exp_b:          2. operandın 8-bit üs alanı
//           mantissa_a:     1. operandın 24-bit mantissa alanı
//           mantissa_b:     2. operandın 24-bit mantissa alanı
//   Outputlar:
//           out_kod:        Çarpım sonucunun 2-bitlik özel durum kodu (NORMAL,
//                           INF, ZERO, NAN)
//           out_sign:       Çarpım sonucunun işaret biti (sign_a ^ sign_b)
//           out_exp:        10-bitlik bias düzeltmeli ön üs (exp_a + exp_b -
//                           127)
//           out_mantissa:   48-bitlik ham mantissa çarpımı (mantissa_a *
//                           mantissa_b)
//
//   Notlar:
//           Tamamen kombinasyoneldir; çıkışları Execute aşaması sonunda
//           fpu_carpma içindeki 65-bitlik k_yazmaci boru hattı yazmacına
//           kaydedilir.

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
