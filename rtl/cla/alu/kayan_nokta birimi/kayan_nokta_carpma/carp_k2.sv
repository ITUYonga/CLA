`timescale 1ns / 1ps

// MOD_CARP_K2 : 2 aşamalı FP32 çarpıcının 2. aşaması (K2); 48-bit çarpımı normalleştirir ve Guard/Round/Sticky bitlerini çıkarır
//
//   Amaç:     K1 aşamasından gelen 48-bitlik mantissa çarpımının en üst
//             bitini (mantissa[47]) kontrol eder. mantissa[47] == 1 ise üssü
//             1 artırıp [47:24] bitlerini mantissa olarak alır; 0 ise üssü
//             koruyup [46:23] bitlerini alır. Alt bitlerden G, R ve Sticky
//             (S) bitlerini oluşturarak 27-bitlik out_n_mantissa çıkışını
//             pack modülüne sunar.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           exp:            K yazmacından gelen 10-bitlik ön üs
//           mantissa:       K yazmacından gelen 48-bitlik ham mantissa çarpımı
//   Outputlar:
//           out_n_mantissa: Normalleştirilmiş 24-bit mantissa ve G, R, S
//                           bitlerinden oluşan 27-bitlik paket
//           exp_out:        Normalleştirme sonrası güncellenmiş 10-bitlik üs
//
//   Notlar:
//           Tamamen kombinasyoneldir; Write (W) aşamasında çalışır ve
//           çıkışı doğrudan pack modülüne bağlanır.

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
