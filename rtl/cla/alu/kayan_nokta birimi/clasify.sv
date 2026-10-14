`timescale 1ns / 1ps

// MOD_CLASIFY : 32-bit IEEE-754 FP32 sayısını işaret, üs, gizli bitli mantissa ve özel durum koduna ayıran sınıflandırıcı
//
//   Amaç:     32-bitlik FP32 girişini (fp) inceleyerek NORMAL (00), INF
//             (01), ZERO (10, denormal sayılar dahil) veya NAN (11) olarak
//             sınıflandırır. Ayrıca işaret bitini (fp[31]), 8-bit üssü
//             (fp[30:23]) ve normal sayılar için gizli '1' biti eklenmiş
//             24-bitlik mantissayı ({exp != 0, fp[22:0]}) üretir.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           fp:             Sınıflandırılacak 32-bit IEEE-754 tek duyarlıklı
//                           kayan nokta sayısı
//   Outputlar:
//           ozel_durumlar:  2-bitlik durum kodu (00: NORMAL, 01: INF, 10:
//                           ZERO/DENORMAL, 11: NAN)
//           sign:           1-bit işaret çıkışı (fp[31])
//           exp:            8-bit üs çıkışı (fp[30:23])
//           mantissa:       Gizli bit (hidden 1) eklenmiş 24-bit mantissa
//                           çıkışı ({exp != 0, fp[22:0]})
//
//   Notlar:
//           TI CLA mimarisi denormal (subnormal) sayıları sıfıra
//           bastırdığı (flush-to-zero) için exp == 0 ve mantissa != 0 olan
//           denormal girişler ZERO (2'b10) sınıfına atanır.

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

