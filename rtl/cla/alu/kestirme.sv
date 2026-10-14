`timescale 1ns / 1ps

// MOD_KESTIRME : 1024x8-bit LUT (estimate_lut.hex) tabanlı FP32 ters (1/x) ve ters karekök (1/sqrt(x)) kestirim çekirdeği
//
//   Amaç:     Newton-Raphson iterasyonlarına başlangıç değeri sağlamak üzere
//             1024x8-bitlik tek bir ROM/LUT tablosu kullanarak 1/x (op_type
//             = 0) ve 1/sqrt(x) (op_type = 1) kestirimlerini kombinasyonel
//             olarak hesaplar. 1/x için {2'b10, mantissa[22:15]} adresini ve
//             253 - exp üssünü; 1/sqrt(x) için ise {1'b0, exp[0],
//             mantissa[22:15]} adresini ve (380 - exp) >> 1 üssünü kullanır.
//
//   Parametreler:
//           DATA_WIDTH:     LUT tablosu veri genişliği (varsayılan: 8 bit)
//           ADDR_WIDTH:     LUT tablosu adres genişliği (varsayılan: 10 bit)
//           DEPTH:          LUT tablosu derinliği (varsayılan: 1024 satır)
//           HEX_FILE:       $readmemh ile yüklenecek LUT dosyası adı
//                           (varsayılan: "estimate_lut.hex")
//
//   Inputlar:
//           sign:           Giriş sayısının işaret biti
//           mantissa:       Gizli biti içeren 24-bit mantissa alanı
//           exp:            8-bit üs (exponent) alanı
//           op_type:        İşlem tipi (0: MEINVF32 1/x, 1: MEISQRTF32
//                           1/sqrt(x))
//   Outputlar:
//           result:         32-bit IEEE-754 kestirim sonucu ({sign, yeni_exp,
//                           estimate[7:0], 15'b0})
//           lvf:            Sıfır/denormal girişte (exp == 0) kurulan taşma
//                           bayrağı
//           luf:            1/x işleminde çok büyük üslerde (exp == 253 veya
//                           254) kurulan alt-taşma bayrağı
//
//   Notlar:
//           Giriş sıfır veya denormal (exp == 0) olduğunda çıkış +/-Sonsuz
//           ({sign, 8'hFF, 23'd0}) olur ve lvf = 1 kurulur; giriş Sonsuz
//           (exp == 8'hFF) olduğunda çıkış +0.0 olur.

module kestirme #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 10,
    parameter int DEPTH      = 1024,
    parameter string HEX_FILE = "estimate_lut.hex"
)(
    
    input logic sign ,
    input logic [23:0]mantissa,
    input logic [7:0]exp ,
    input logic op_type , // 0-> inverse 1-> sqrt inverse
    

    output logic [31:0]result,
    output logic lvf,
    output logic luf 
);

    // Bellek dizisi tan�m�
    
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    logic [7:0]estimate ;
    logic [9:0] address;
    // Sim�lasyon ve sentez ba�lang�c�nda hex dosyas�n� y�kler
    initial begin
        $readmemh(HEX_FILE, mem);
    end


   
    
    always_comb begin
        lvf = 0;
        luf = 0;
        if(op_type == 1'b0)begin
            
            address = {2'b10 , mantissa[22:15]};
            estimate = mem[address];
            result = {sign , 8'(253-exp) , estimate, 15'b0};
       if(exp == 8'b0)begin
               // En temiz ve risksiz yaz�m:
                result = {sign, 8'hFF, 23'd0}; // 1 + 8 + 23 = 32 bit (+/- Sonsuz);
                lvf = 1 ; 
                end
        if(exp == 8'hFF)
                result = 32'b0 ;
        
        if(exp == 253 || exp == 254)begin
            result = 32'b0;
            luf = 1;
        end
            
        
            end
            
       
        else     begin
        
            address = {1'b0 , exp[0] , mantissa[22:15]} ;
            estimate = mem[address];
            result = {1'b0 , 8'((380-exp) >> 1), estimate , 15'b0};
        
             if(exp == 8'b0)begin
               // En temiz ve risksiz yaz�m:
                result = {1'b0, 8'hFF, 23'd0}; // 1 + 8 + 23 = 32 bit (+/- Sonsuz) 
                lvf = 1 ; 
                end
                
              if(exp == 8'hFF)
                result = 32'b0 ;
           
            
             
        end

                
    
    end
    
    

endmodule
