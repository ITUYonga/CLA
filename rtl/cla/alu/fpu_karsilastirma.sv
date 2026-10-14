`timescale 1ns / 1ps

// MCMPF32, MMAXF32, MMINF32, MABSF32, MNEGF32 icin sarmalama (fpu_kestirme ile ayni duzen).
// fp_1 = MRa, fp_2 = MRb. Kombinasyonel: sonuc ve bayraklar EXE'de yazilir.

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
