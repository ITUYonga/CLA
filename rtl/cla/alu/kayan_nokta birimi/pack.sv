`timescale 1ns / 1ps

// MOD_PACK : Normalleştirilmiş mantissa ve üssü yuvarlayarak 32-bit IEEE-754 FP32 formatında paketleyen birim
//
//   Amaç:     FP32 toplayıcı ve çarpıcının K2 aşamasından gelen 27-bitlik
//             mantissayı ([26:3] 24-bit mantissa, [2] Guard, [1] Round, [0]
//             Sticky), 10-bitlik işaretli ön üssü (exp_on) ve 2-bitlik özel
//             durum kodunu (kod) alır. Yuvarlama moduna (rnd = 0: sıfıra
//             kesme RZ, rnd = 1: en yakın çifte yuvarlama RNE) göre
//             yuvarlama, taşma (overflow) ve alt-taşma (underflow / FTZ)
//             kurallarını uygulayarak 32-bit FP32 sonucu ve LVF/LUF
//             bayraklarını üretir.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           kod:            2-bitlik özel durum kodu (00: NORMAL, 01: INF, 10:
//                           ZERO, 11: NAN)
//           rnd:            Yuvarlama modu (0: sıfıra kesme RZ, 1: en yakın
//                           çifte yuvarlama RNE)
//           sign:           Sonucun işaret biti
//           exp_on:         10-bitlik işaretli ön üs değeri
//           n_mantissa:     GRS bitlerini içeren 27-bitlik normalleştirilmiş
//                           mantissa ({M[23:0], G, R, S})
//   Outputlar:
//           lvf:            Taşma (Overflow) bayrağı (NORMAL durumda exp_on >=
//                           255 veya yuvarlama taşmasında 1 olur)
//           luf:            Alt-taşma (Underflow) bayrağı (NORMAL durumda
//                           exp_on <= 0 olduğunda 1 olur)
//           result:         Paketlenmiş 32-bit IEEE-754 FP32 sonucu
//
//   Notlar:
//           Taşma durumunda RZ modunda maksimum sonlu sayı (exp = 8'hFE,
//           mantissa = 23'h7FFFFF), RNE modunda ise Sonsuz (exp = 8'hFF,
//           mantissa = 0) üretilir.
//
//           NAN durumunda kanonik sessiz NaN (32'h7FC0_0000), ZERO
//           durumunda ise +0.0 (32'h0000_0000) döndürülür ve LVF/LUF 0
//           tutulur.

import kod_sinifi::*;

module pack (
    input  logic [1:0]  kod,         // 00 -> NORMAL, 01 -> SONSUZ, 10 -> SIFIR, 11 -> NAN
    input  logic        rnd,
    input  logic        sign,
    input  logic [9:0]  exp_on,
    input  logic [26:0] n_mantissa,  // [26:3] -> M, [2] -> G, [1] -> R, [0] -> S
    
    output logic        lvf,
    output logic        luf,
    output logic [31:0] result
);

    logic [23:0] out_mantissa;
    logic [7:0]  out_exp;
    logic        out_sign;
    logic        out_mantissa_sign;
    logic        increment;
    
    logic        UNDERFLOW;
    logic        OVERFLOW;

    logic        G, R, S;

    always_comb begin
    
        OVERFLOW = 1'b0;         
        UNDERFLOW = 1'b0; 
        
        // --- 1. LATCH ENGELLEMEK İÇİN VARSAYILAN DEĞERLER ---
        G            = n_mantissa[2];
        R            = n_mantissa[1];
        S            = n_mantissa[0];
        
        out_sign     = sign;
        out_exp      = exp_on[7:0];
        out_mantissa = n_mantissa[26:3];
        increment    = 1'b0;
        out_mantissa_sign = 1'b0;

        // --- 2. ÖZEL DURUMLAR VE FLAG HESABI ---
        case (kod)
            NAN: begin
                out_sign     = 1'b0;
                out_exp = 8'hFF;
                out_mantissa = 24'hC0_0000;
                lvf          = 1'b0;
                luf          = 1'b0;
            end
            
            INF: begin
                out_sign     = sign;
                out_exp      = 8'hFF;
                out_mantissa = 24'h0;
                lvf          = 1'b0;
                luf          = 1'b0;
            end
            
            ZERO: begin
                out_sign     = 1'b0; // Görsel: SIFIR -> 32'h0 (+0)
                out_exp      = 8'h00;
                out_mantissa = 24'h0;
                lvf          = 1'b0;
                luf          = 1'b0;
            end
            
            default: begin // NORMAL
                // Doğru taşma formülü:
                OVERFLOW  = ($signed(exp_on) >= 255) || 
                            (($signed(exp_on) == 254) && (n_mantissa[26:3] == 24'hFFFFFF) && (G == 1'b1));
                
                UNDERFLOW = ($signed(exp_on) <= 0);
                
                lvf = OVERFLOW;
                luf = UNDERFLOW;

                // --- 3. YUVARLAMA VE NORMAL İŞLEMLER ---
                if (rnd == 1'b0) begin // RZ MODU
                    if (!OVERFLOW && !UNDERFLOW) begin
                        out_mantissa = n_mantissa[26:3];
                        out_exp      = exp_on[7:0];
                    end 
                    else if (OVERFLOW) begin
                        out_exp            = 8'hFE;
                        out_mantissa[22:0] = 23'h7FFFFF;
                    end 
                    else if (UNDERFLOW) begin
                        // e_on < -23 veya tam eşik durumu
                        if ($signed(exp_on) <= -23) 
                             begin
                            out_sign     = sign;  // ±0
                            out_exp      = 8'b0;
                            out_mantissa = 24'b0;
                        end else begin
                            out_sign     = 1'b0;  // +0 (FTZ)
                            out_exp      = 8'b0;
                            out_mantissa = 24'b0;
                        end
                    end
                end 
                else begin // RNE MODU (rnd == 1'b1)
                    if (!OVERFLOW && !UNDERFLOW) begin
                        increment = G && (R || S || n_mantissa[3]);
                        {out_mantissa_sign, out_mantissa} = n_mantissa[26:3] + increment;
                        
                        if (out_mantissa_sign) begin
                            out_mantissa = 24'h800000;
                            out_exp      = exp_on[7:0] + 8'd1;
                        end else begin
                            out_exp      = exp_on[7:0];
                        end
                    end 
                    else if (OVERFLOW) begin
                        out_exp      = 8'hFF;
                        out_mantissa = 24'b0;
                    end 
                    else if (UNDERFLOW) begin
                        // ±MIN_NORMAL kurtarma durumu
                        if (($signed(exp_on) == 0) && (n_mantissa[26:3] == 24'hFFFFFF)) begin
                            out_exp            = 8'h01;
                            out_mantissa[22:0] = 23'h0;
                        end 
                        // Kesin ±0 durumu
                        else if (($signed(exp_on) < -23) || 
                                 (($signed(exp_on) == -23) && (n_mantissa[26:3] == 24'h800000) && !G && !R && !S)) begin
                            out_sign     = sign;
                            out_exp      = 8'b0;
                            out_mantissa = 24'b0;
                        end 
                        // Diğerleri -> +0 (FTZ)
                        else begin
                            out_sign     = 1'b0;
                            out_exp      = 8'b0;
                            out_mantissa = 24'b0;
                        end
                    end
                end
            end
        endcase

        // --- 4. PAKETLEME ---
        result = {out_sign, out_exp, out_mantissa[22:0]};
    end

endmodule
