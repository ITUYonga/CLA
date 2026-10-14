`timescale 1ns / 1ps

// MOD_KARSILASTIRMA : FP32 karşılaştırma (MCMPF32), maksimum (MMAXF32), minimum (MMINF32), mutlak değer (MABSF32) ve koşullu işaret tersleme (MNEGF32) çekirdeği
//
//   Amaç:     İki FP32 sayısını IEEE-754 ve TI CLA kurallarına göre
//             (denormalleri ve -0.0'ı +0.0'a eşitleyerek) karşılaştırır.
//             MCMPF32, MMAXF32 ve MMINF32'de büyüklük ilişkisine göre sonucu
//             ve ZF/NF bayraklarını üretir; MABSF32'de işareti sıfırlar;
//             MNEGF32'de ise CNDF koşulu tutarsa işareti tersler.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           exp_1:          1. operandın 8-bit üs alanı
//           mantissa_1:     1. operandın 23-bit IEEE-754 kesir (mantissa)
//                           alanı
//           sign_1:         1. operandın işaret biti
//           CNDF:           MNEGF32 için 4-bitlik koşul kodu (cmp_e)
//           op_type:        3-bitlik işlem seçimi (islemler_e: MCMPF32,
//                           MMAXF32, MMINF32, MABSF32, MNEGF32)
//           exp_2:          2. operandın 8-bit üs alanı
//           mantissa_2:     2. operandın 23-bit kesir alanı
//           sign_2:         2. operandın işaret biti
//           mstf:           Koşul testi için 5-bit görünen MSTF bayrakları
//                           ({TF, ZF, NF, LUF, LVF})
//           kod_1:          1. operandın clasify özel durum kodu (NORMAL, INF,
//                           ZERO, NAN)
//           kod_2:          2. operandın clasify özel durum kodu
//   Outputlar:
//           zf:             Hesaplanan sıfır bayrağı (ZF)
//           nf:             Hesaplanan negatif bayrağı (NF)
//           result:         32-bit işlem sonucu
//
//   Notlar:
//           Karşılaştırma öncesinde denormal sayılar (exp == 0) ve -0.0
//           (32'h8000_0000) +0.0'a dönüştürülür; böylece +0.0 == -0.0
//           eşitliği sağlanır.
//
//           MNEGF32 buyruğunda ZF ve NF bayrakları yalnızca CNDF ==
//           CMP_UNCF (4'b1111) olduğunda güncellenir.

import kod_sinifi::*;

typedef enum logic [2:0] {
    MCMPF32 = 3'b000, 
    MMAXF32 = 3'b001, 
    MMINF32 = 3'b010, 
    MABSF32 = 3'b011, 
    MNEGF32 = 3'b100
} islemler_e;

typedef enum logic [3:0] {
    CMP_NEQ  = 4'b0000,
    CMP_EQ   = 4'b0001,
    CMP_GT   = 4'b0010,
    CMP_GEQ  = 4'b0011,
    CMP_LT   = 4'b0100,
    CMP_LEQ  = 4'b0101,
    CMP_TF   = 4'b1010,
    CMP_NTF  = 4'b1011,
    CMP_LU   = 4'b1100,
    CMP_LV   = 4'b1101,
    CMP_UNC  = 4'b1110,
    CMP_UNCF = 4'b1111
} cmp_e;

module karsilastirma(
    input  logic [7:0]  exp_1,
    input  logic [22:0] mantissa_1, // 23-bit standart IEEE 754 mantis alan�
    input  logic        sign_1,
    
    input  logic [3:0]  CNDF,       // cmp_e
    input  logic [2:0]  op_type,    // islemler_e
    
    input  logic [7:0]  exp_2,
    input  logic [22:0] mantissa_2,
    input  logic        sign_2,
    input  logic [4:0]  mstf,       // [4]->TF, [3]->ZF, [2]->NF, [1]->LUF, [0]->LVF (ALU.sv / tamsayi_islem ile ayni)
    
    input  logic [1:0]  kod_1,
    input  logic [1:0]  kod_2,
    
    output logic        zf,
    output logic        nf,
    output logic [31:0] result
);

    logic [31:0] fp_1, fp_2;
    logic        a_gt_b, b_gt_a, a_eq_b;
    logic [1:0]  zf_nf;
    logic        is_cndf;

    // 1. Giri� Say�lar�n� Normalize Etme / IEEE Standartla�t�rma
    always_comb begin
        // Ham 32-bit float olu�turma
        fp_1 = {sign_1, exp_1, mantissa_1};
        fp_2 = {sign_2, exp_2, mantissa_2};

        // S�f�r ve Denormal yakalama (+0.0 veya -0.0)
        if (exp_1 == 8'd0 || fp_1 == 32'h8000_0000) fp_1 = 32'h0000_0000;
        if (exp_2 == 8'd0 || fp_2 == 32'h8000_0000) fp_2 = 32'h0000_0000;

        // NaN d�n���mleri (Kanonik qNaN)
        if (kod_1 == NAN) fp_1 = {sign_1, 8'hFF, 23'd0};
        if (kod_2 == NAN) fp_2 = {sign_2, 8'hFF, 23'd0};
    end

    // 2. Kar��la�t�rma Mant���
    always_comb begin
        // a > b kontrol�
        a_gt_b = (fp_1[31] != fp_2[31]) ? !fp_1[31] : 
                 (!fp_1[31])            ? (fp_1[30:0] > fp_2[30:0]) : 
                                          (fp_1[30:0] < fp_2[30:0]);

        // b > a kontrol�
        b_gt_a = (fp_2[31] != fp_1[31]) ? !fp_2[31] : 
                 (!fp_2[31])            ? (fp_2[30:0] > fp_1[30:0]) : 
                                          (fp_2[30:0] < fp_1[30:0]);

        a_eq_b = (fp_1 == fp_2);
    end

    // 3. Ko�ul Kontrol� (CNDF De�erlendirmesi)[cite: 1]
    always_comb begin
        case (CNDF)
            CMP_NEQ  : is_cndf = (mstf[3] == 1'b0);
            CMP_EQ   : is_cndf = (mstf[3] == 1'b1);
            CMP_GT   : is_cndf = (mstf[3] == 1'b0) && (mstf[2] == 1'b0);
            CMP_GEQ  : is_cndf = (mstf[2] == 1'b0);
            CMP_LT   : is_cndf = (mstf[2] == 1'b1);
            CMP_LEQ  : is_cndf = (mstf[3] == 1'b1) || (mstf[2] == 1'b1);
            CMP_TF   : is_cndf = (mstf[4] == 1'b1);
            CMP_NTF  : is_cndf = (mstf[4] == 1'b0);
            CMP_LU   : is_cndf = (mstf[1] == 1'b1);
            CMP_LV   : is_cndf = (mstf[0] == 1'b1);
            CMP_UNC  : is_cndf = 1'b1;
            CMP_UNCF : is_cndf = 1'b1;
            default  : is_cndf = 1'b0;
        endcase
    end

    // 4. Ana ��lem Y�r�tme (ALU Mant���)
    always_comb begin
        // Varsay�lan atamalar (Latch olu�mas�n� engeller)
        result = fp_1;
        zf_nf  = 2'b00;

        case (op_type)
            MCMPF32: begin
                result = 32'd0;
                if (a_gt_b)      zf_nf = 2'b00;
                else if (b_gt_a) zf_nf = 2'b01;
                else             zf_nf = 2'b10;
            end

            MMAXF32: begin
                if (a_gt_b) begin
                    zf_nf  = 2'b00;
                    result = fp_1;
                end else if (b_gt_a) begin
                    zf_nf  = 2'b01;
                    result = fp_2;
                end else begin
                    zf_nf  = 2'b10;
                    result = fp_1;
                end
            end

            MMINF32: begin
                if (a_gt_b) begin
                    zf_nf  = 2'b00;
                    result = fp_2;
                end else if (b_gt_a) begin
                    zf_nf  = 2'b01;
                    result = fp_1;
                end else begin
                    zf_nf  = 2'b10;
                    result = fp_1;
                end
            end

            MABSF32: begin
                result   = {1'b0, exp_2 , mantissa_2 }; // Mutlak de�er: ��areti zorla 0 yap
                zf_nf[0] = 1'b0;
                zf_nf[1] = (exp_2  == 31'd0); // S�f�rsa ZF = 1
            end

            MNEGF32: begin
                if (is_cndf) begin
                    result = {~sign_2, exp_2 , mantissa_2 }; // Ko�ul sa�land�ysa i�areti tersle
                end else begin
                    result = {sign_2, exp_2 , mantissa_2 };
                end

                if (CNDF == CMP_UNCF)begin
                    zf_nf[1] = exp_2 == 0; 
                    zf_nf[0] = (result[31] == 1)& ~zf_nf[1] ;
                end

            end

            default: begin
                result = 32'd0;
                zf_nf  = 2'b00;
            end
        endcase

        // Bayrak ��k��lar�na atama
        {zf, nf} = zf_nf;
    end

endmodule
