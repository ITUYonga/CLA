`timescale 1ns / 1ps

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
    input  logic [22:0] mantissa_1, // 23-bit standart IEEE 754 mantis alaný
    input  logic        sign_1,
    
    input  logic [3:0]  CNDF,       // cmp_e
    input  logic [2:0]  op_type,    // islemler_e
    
    input  logic [7:0]  exp_2,
    input  logic [22:0] mantissa_2,
    input  logic        sign_2,
    input  logic [4:0]  mstf,       // [4]->Z, [3]->N, [2]->TF, [1]->LUF, [0]->LVF
    
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

    // 1. Giriþ Sayýlarýný Normalize Etme / IEEE Standartlaþtýrma
    always_comb begin
        // Ham 32-bit float oluþturma
        fp_1 = {sign_1, exp_1, mantissa_1};
        fp_2 = {sign_2, exp_2, mantissa_2};

        // Sýfýr ve Denormal yakalama (+0.0 veya -0.0)
        if (exp_1 == 8'd0 || fp_1 == 32'h8000_0000) fp_1 = 32'h0000_0000;
        if (exp_2 == 8'd0 || fp_2 == 32'h8000_0000) fp_2 = 32'h0000_0000;

        // NaN dönüþümleri (Kanonik qNaN)
        if (kod_1 == NAN) fp_1 = 32'h7FC0_0000;
        if (kod_2 == NAN) fp_2 = 32'h7FC0_0000;
    end

    // 2. Karþýlaþtýrma Mantýðý
    always_comb begin
        // a > b kontrolü
        a_gt_b = (fp_1[31] != fp_2[31]) ? !fp_1[31] : 
                 (!fp_1[31])            ? (fp_1[30:0] > fp_2[30:0]) : 
                                          (fp_1[30:0] < fp_2[30:0]);

        // b > a kontrolü
        b_gt_a = (fp_2[31] != fp_1[31]) ? !fp_2[31] : 
                 (!fp_2[31])            ? (fp_2[30:0] > fp_1[30:0]) : 
                                          (fp_2[30:0] < fp_1[30:0]);

        a_eq_b = (fp_1 == fp_2);
    end

    // 3. Koþul Kontrolü (CNDF Deðerlendirmesi)[cite: 1]
    always_comb begin
        case (CNDF)
            CMP_NEQ  : is_cndf = (mstf[4] == 1'b0);
            CMP_EQ   : is_cndf = (mstf[4] == 1'b1);
            CMP_GT   : is_cndf = (mstf[4] == 1'b0) && (mstf[3] == 1'b0);
            CMP_GEQ  : is_cndf = (mstf[3] == 1'b0);
            CMP_LT   : is_cndf = (mstf[3] == 1'b1);
            CMP_LEQ  : is_cndf = (mstf[4] == 1'b1) || (mstf[3] == 1'b1);
            CMP_TF   : is_cndf = (mstf[2] == 1'b1);
            CMP_NTF  : is_cndf = (mstf[2] == 1'b0);
            CMP_LU   : is_cndf = (mstf[1] == 1'b1);
            CMP_LV   : is_cndf = (mstf[0] == 1'b1);
            CMP_UNC  : is_cndf = 1'b1;
            CMP_UNCF : is_cndf = 1'b1;
            default  : is_cndf = 1'b0;
        endcase
    end

    // 4. Ana Ýþlem Yürütme (ALU Mantýðý)
    always_comb begin
        // Varsayýlan atamalar (Latch oluþmasýný engeller)
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
                result   = {1'b0, fp_2[30:0]}; // Mutlak deðer: Ýþareti zorla 0 yap
                zf_nf[0] = 1'b0;
                zf_nf[1] = (fp_2[30:0] == 31'd0); // Sýfýrsa ZF = 1
            end

            MNEGF32: begin
                if (is_cndf) begin
                    result = {~fp_2[31], fp_2[30:0]}; // Koþul saðlandýysa iþareti tersle
                end else begin
                    result = fp_2;
                end

                if (CNDF == CMP_UNCF)
                    zf_nf = 2'b11;

            end

            default: begin
                result = 32'd0;
                zf_nf  = 2'b00;
            end
        endcase

        // Bayrak çýkýþlarýna atama
        {zf, nf} = zf_nf;
    end

endmodule