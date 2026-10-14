`timescale 1ns / 1ps

// MOD_FPU_DONUSUM : clasify ve donusum modüllerini birleştiren FP32/tamsayı dönüşüm sarmalayıcısı
//
//   Amaç:     32-bitlik giriş verisini (fp) önce clasify modülü ile işaret,
//             üs ve 24-bit mantissa bileşenlerine ayırır, ardından donusum
//             modülüne ileterek seçilen tip dönüşümü veya kesir alma
//             işleminin 32-bitlik sonucunu üretir.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           fp:             Dönüştürülecek 32-bitlik kayan nokta veya tamsayı
//                           giriş verisi
//           donusum_cntrl:  4-bitlik dönüşüm işlem kodu (fpu_op_e)
//           rnd:            MSTF.RND32 yuvarlama modu biti (int -> float
//                           dönüşümleri için)
//   Outputlar:
//           result:         32-bit dönüşüm sonucu
//
//   Notlar:
//           Tamamen kombinasyoneldir; sonuç Execute (E) aşamasının sonunda
//           doğrudan hedef MR yazmacına yazılır.

module fpu_donusum(

    input logic [31:0]fp,

    input logic [3:0]donusum_cntrl, //CONTROL (donusum.sv fpu_op_e)
    input logic rnd ,               //CONTROL RND32 (yalniz int -> float)

    output logic [31:0]result

    );

    logic [23:0]mantissa_out;
    logic sign_out;
    logic [7:0]exp_out;
    logic [1:0]ozel_durumlar;

clasify C_d(.fp(fp) , .sign(sign_out) , .exp(exp_out) , .mantissa(mantissa_out), .ozel_durumlar(ozel_durumlar));

donusum D(.op_type(donusum_cntrl) , .rnd(rnd) , .sign(sign_out) , .exp(exp_out) , .mantissa(mantissa_out) , .result(result) );



endmodule
