`timescale 1ns / 1ps

// MOD_FPU_KESTIRME : clasify ve kestirme modüllerini birleştiren FP32 ters (1/x) ve ters karekök (1/sqrt(x)) sarmalayıcısı
//
//   Amaç:     32-bit FP32 girişini (fp) clasify modülü ile işaret, 8-bit üs
//             ve 24-bit mantissa alanlarına ayırır ve kestirme modülüne
//             bağlayarak MEINVF32 (1/x) veya MEISQRTF32 (1/sqrt(x)) kestirim
//             sonucunu ve LVF/LUF bayraklarını üretir.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           fp:             32-bit IEEE-754 kayan nokta girişi
//           kestirme_cntrl: İşlem seçimi (0: MEINVF32 1/x, 1: MEISQRTF32
//                           1/sqrt(x))
//   Outputlar:
//           result:         32-bit FP32 kestirim sonucu
//           lvf:            Taşma (overflow / sıfıra bölme) bayrağı
//           luf:            Alt-taşma (underflow) bayrağı
//
//   Notlar:
//           Tamamen kombinasyoneldir; tek çevrimde (E aşamasında) sonuç ve
//           bayrak üretir.

module fpu_kestirme(

    input logic [31:0]fp,
 
    input logic kestirme_cntrl, //CONTROL
   
    output logic [31:0]result ,

    output logic lvf ,
    output logic luf
    

    );

    logic [23:0]mantissa_out;
    logic sign_out;
    logic [7:0]exp_out;
    logic [1:0]ozel_durumlar;
    
clasify C_b(.fp(fp) , .sign(sign_out) , .exp(exp_out) , .mantissa(mantissa_out), .ozel_durumlar(ozel_durumlar));

kestirme K(.sign(sign_out) , .mantissa(mantissa_out) , .exp(exp_out) , .op_type(kestirme_cntrl) , .result(result) , .lvf(lvf) , .luf(luf) );
     


    
    
    
endmodule
