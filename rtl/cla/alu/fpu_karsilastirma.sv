`timescale 1ns / 1ps

// MOD_FPU_KARSILASTIRMA : MCMPF32, MMAXF32, MMINF32, MABSF32 ve MNEGF32 buyrukları için sınıflandırıcı ve karşılaştırıcı sarmalayıcısı
//
//   Amaç:     İki 32-bit FP32 operandını (fp_1, fp_2) clasify modüllerinden
//             geçirerek özel durum kodlarını (NORMAL, INF, ZERO, NAN)
//             çıkarır ve karsilastirma çekirdeğine bağlar. Seçilen işleme
//             göre 32-bit sonucu ve ZF/NF bayraklarını kombinasyonel olarak
//             üretir.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           fp_1:           1. 32-bit kayan nokta operandı (MRa)
//           fp_2:           2. 32-bit kayan nokta operandı (MRb veya #16FHi)
//           islem:          3-bit işlem kodu (000:MCMPF32, 001:MMAXF32,
//                           010:MMINF32, 011:MABSF32, 100:MNEGF32)
//           cndf:           MNEGF32 buyruğu için 4-bit koşul kodu (diğer
//                           buyruklarda UNCF = 4'b1111)
//           mstf:           Koşul değerlendirmesi için 5-bit görünen MSTF
//                           bayrakları ({TF, ZF, NF, LUF, LVF})
//   Outputlar:
//           result:         32-bit işlem sonucu (MCMPF32'de yazماca yazılmaz)
//           zf:             Karşılaştırma veya işlem sonucu üretilen sıfır
//                           (Zero) bayrağı
//           nf:             Karşılaştırma veya işlem sonucu üretilen negatif
//                           (Negative) bayrağı
//
//   Notlar:
//           karsilastirma alt modülüne gizli bit eklenmemiş ham 23-bit
//           mantissa (fp_1[22:0], fp_2[22:0]) ile clasify tarafından
//           üretilen 2-bitlik özel durum kodları (kod_1, kod_2) birlikte
//           aktarılır.

module fpu_karsilastirma(

    input  logic [31:0] fp_1,
    input  logic [31:0] fp_2,

    input  logic [2:0]  islem,   // karsilastirma.sv: 000 MCMPF32, 001 MMAXF32, 010 MMINF32, 011 MABSF32, 100 MNEGF32
    input  logic [3:0]  cndf,    // MNEGF32 kosulu (diger buyruklarda 4'b1111 = UNCF verilebilir)
    input  logic [4:0]  mstf,    // 4: TF 3: ZF 2: NF 1: LUF 0: LVF

    output logic [31:0] result,
    output logic        zf,
    output logic        nf

    );

logic       sign_1, sign_2;
logic [7:0] exp_1,  exp_2;
logic [23:0] mantissa_1, mantissa_2;   // clasify cikisi; karsilastirma'ya ham 23 bit fp'den gidiyor
logic [1:0] kod_1,  kod_2;

clasify C_1(.fp(fp_1) , .sign(sign_1) , .exp(exp_1) , .mantissa(mantissa_1) , .ozel_durumlar(kod_1));
clasify C_2(.fp(fp_2) , .sign(sign_2) , .exp(exp_2) , .mantissa(mantissa_2) , .ozel_durumlar(kod_2));

karsilastirma K(.exp_1(exp_1) , .mantissa_1(fp_1[22:0]) , .sign_1(sign_1) ,
                .CNDF(cndf) , .op_type(islem) ,
                .exp_2(exp_2) , .mantissa_2(fp_2[22:0]) , .sign_2(sign_2) ,
                .mstf(mstf) , .kod_1(kod_1) , .kod_2(kod_2) ,
                .zf(zf) , .nf(nf) , .result(result));

endmodule
