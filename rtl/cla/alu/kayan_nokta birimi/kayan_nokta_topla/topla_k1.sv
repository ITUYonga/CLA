`timescale 1ns / 1ps

// MOD_TOPLA_K1 : 2 aşamalı FP32 toplayıcı/çıkarıcının 1. aşaması (K1); üs farkı hesabı, mantissa hizalama ve GRS bit üretimini yapar
//
//   Amaç:     İki FP32 operandının büyüklüklerini ({exp, mantissa})
//             karşılaştırarak büyük olanın üssünü ortak üs (out_exp) ve
//             işaretini sonuç işareti (out_sign) olarak seçer. Küçük olan
//             operandın 24-bitlik mantissasını üs farkı kadar (en fazla 26
//             bit) sağa kaydırarak hizalar ve dışarı kayan bitlerden Guard,
//             Round ve Sticky bitlerini koruyacak şekilde iki 27-bitlik
//             mantissa (out_mantissa_a, out_mantissa_b) ve etkin işlem
//             yönünü (cik) üretir.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           cikarma:        Buyruk tipi (0: MADDF32 toplama, 1: MSUBF32
//                           çıkarma -> 2. operandın işaretini tersler)
//           sign_a:         1. operandın işaret biti
//           sign_b:         2. operandın işaret biti
//           kod_a:          1. operandın 2-bitlik özel durum kodu
//           kod_b:          2. operandın 2-bitlik özel durum kodu
//           exp_a:          1. operandın 8-bit üs alanı
//           exp_b:          2. operandın 8-bit üs alanı
//           mantissa_a:     1. operandın 24-bit mantissa alanı
//           mantissa_b:     2. operandın 24-bit mantissa alanı
//   Outputlar:
//           out_kod:        Sonucun 2-bitlik özel durum kodu (zıt işaretli iki
//                           INF toplanırsa NAN döner)
//           sign_out_b:     2. operandın çıkarma ile XOR'lanmış etkin işareti
//                           (sign_b ^ cikarma)
//           out_exp:        Büyük operandın 8-bitlik ortak üssü
//           out_mantissa_a: Büyük operandın {mantissa, 3'b000} şeklinde
//                           genişletilmiş 27-bitlik mantissası
//           out_mantissa_b: Küçük operandın sağa kaydırılmış ve G, R, S
//                           bitleri eklenmiş 27-bitlik mantissası
//           out_sign:       Mutlak değeri büyük olan operandın işareti (sonuç
//                           işareti)
//           cik:            K2 aşamasında mantissaların toplanacağını (0) mı
//                           yoksa çıkarılacağını (1) mı belirten bit
//
//   Notlar:
//           Tamamen kombinasyoneldir; büyük olan operand her zaman
//           out_mantissa_a çıkışına konulduğu için K2 aşamasında yapılan
//           çıkarma (out_mantissa_a - out_mantissa_b) hiçbir zaman negatif
//           çıkmaz.

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
