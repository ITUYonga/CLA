`timescale 1ns / 1ps

// MOD_FPU_TOPLAMA : E ve W aşamalarına yayılmış 2 çevrimli boru hatlı IEEE-754 FP32 toplayıcı ve çıkarıcı (MADDF32 / MSUBF32)
//
//   Amaç:     İki 32-bit FP32 sayısını (fp_a, fp_b) 2 aşamalı boru hattı
//             üzerinden toplar veya çıkarır. 1. aşamada (E) clasify ve
//             topla_k1 modülleriyle hizalama yapıp ara verileri 70-bitlik
//             k_yazmaci boru hattı yazmacına kaydeder; 2. aşamada (W)
//             topla_k2 ve pack modülleriyle normalleştirme ve yuvarlama
//             yaparak 32-bit sonucu, LVF/LUF bayraklarını ve hedef MR
//             adresini üretir.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           hedef_mr:       Sonucun yazılacağı 2-bitlik hedef MR indeksi
//                           (MR0..MR3)
//           rnd:            MSTF.RND32 yuvarlama modu biti (0: RZ, 1: RNE)
//           valid:          Bu çevrimde E aşamasında geçerli bir
//                           toplama/çıkarma buyruğu olduğunu belirten bit
//           clk:            Sistem saati
//           rst:            Aktif-düşük sıfırlama sinyali
//           cikarma:        İşlem seçimi (0: MADDF32 toplama, 1: MSUBF32
//                           çıkarma)
//           fp_a:           1. 32-bit IEEE-754 FP32 operandı
//           fp_b:           2. 32-bit IEEE-754 FP32 operandı
//   Outputlar:
//           lvf:            Geçerli işlem sonucunda taşma olduğunu belirten
//                           bayrak (lvf_out & valid_out)
//           luf:            Geçerli işlem sonucunda alt-taşma olduğunu
//                           belirten bayrak (luf_out & valid_out)
//           result:         W aşamasında hazır olan 32-bit IEEE-754 FP32
//                           toplama/çıkarma sonucu
//           valid_out:      result çıkışının bu çevrimde geçerli olduğunu
//                           belirten bit (valid girişinden 1 çevrim sonra)
//           hedef_mr_out:   k_yazmaci üzerinden W aşamasına taşınan 2-bitlik
//                           hedef MR indeksi
//
//   Notlar:
//           70-bitlik k_yazmaci E ve W aşamalarını birbirinden ayırır;
//           Execute aşamasında dur_exe beklemesi oluştuğunda valid girişi
//           0 yapılarak W aşamasına balon sürülür.

module fpu_toplama(
    
    input logic[1:0] hedef_mr,
    input logic rnd, 
    input logic valid,
    input logic clk,
    input logic rst,
    input logic cikarma , //TOPLAMA isleminde lazim
    
    input logic [31:0]fp_a  ,
    input logic [31:0]fp_b,
    
    
     output logic lvf,
     output logic luf,  
     output logic [31:0] result,
     output logic valid_out,
     output logic [1:0]hedef_mr_out   

    );

logic[69:0] k_yazmaci ; 


//Clasify ciktilari
logic [1:0]ozel_durumlar_a;
logic sign_a_out ; 
logic [7:0]exp_a_out;
logic [23:0]mantissa_a_out;

logic [1:0]ozel_durumlar_b;
logic sign_b_out ; 
logic [7:0]exp_b_out;
logic [23:0]mantissa_b_out;

//Topla_K1 ciktilari
 logic[1:0] out_kod;
 logic sign_out_b;
 logic [7:0]out_exp;
 logic [26:0]out_mantissa_a;
 logic [26:0]out_mantissa_b;
 logic out_sign ;
 logic cik;

//Topla_K2 ciktilari

 logic [1:0]kod_out;
 logic [9:0]exp_out;
 logic [26:0]mantissa_out;
 
 
logic lvf_out;
logic luf_out;



clasify C_a(.fp(fp_a) , .sign(sign_a_out) , .exp(exp_a_out) , .mantissa(mantissa_a_out), .ozel_durumlar(ozel_durumlar_a));
clasify C_b(.fp(fp_b) , .sign(sign_b_out) , .exp(exp_b_out) , .mantissa(mantissa_b_out), .ozel_durumlar(ozel_durumlar_b));

topla_k1 T1(.cikarma(cikarma) , .sign_a(sign_a_out) , 
            .sign_b(sign_b_out) , .kod_a(ozel_durumlar_a) , .kod_b(ozel_durumlar_b) , 
            .exp_a(exp_a_out) , .exp_b(exp_b_out) , 
            .mantissa_a(mantissa_a_out) , .mantissa_b(mantissa_b_out) , 
            .out_kod(out_kod) , .sign_out_b(sign_out_b) ,.out_exp(out_exp) , 
            .out_mantissa_a(out_mantissa_a) , .out_mantissa_b(out_mantissa_b),
            .out_sign(out_sign) , .cik(cik));
     
     
always_ff@(posedge clk or negedge rst)begin
    if(!rst)
        k_yazmaci <= 70'b0 ; 

     else begin
        k_yazmaci <= {valid , hedef_mr , rnd , out_sign , out_exp , out_mantissa_a,
                      out_mantissa_b , cik , out_kod};  
    
     end

end



topla_k2 T2(.cik(k_yazmaci[2]) , .kod(k_yazmaci[1:0]) , .exp_a(k_yazmaci[64:57]) , 
            .mantissa_a(k_yazmaci[56:30]), .mantissa_b(k_yazmaci[29:3]),
            .kod_out(kod_out) , .exp_out(exp_out) , .mantissa_out(mantissa_out));
            




pack P(.kod(kod_out) , .rnd(k_yazmaci[66]) , .sign(k_yazmaci[65]) , .exp_on(exp_out),
        .n_mantissa(mantissa_out) , .lvf(lvf_out) , .luf(luf_out) , .result(result));




assign valid_out = k_yazmaci[69] ; 
assign hedef_mr_out = k_yazmaci[68:67] ; 
assign lvf = lvf_out & valid_out;
assign luf = luf_out & valid_out;


endmodule
