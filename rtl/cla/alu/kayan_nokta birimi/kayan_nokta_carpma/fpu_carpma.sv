`timescale 1ns / 1ps

// MOD_FPU_CARPMA : E ve W aşamalarına yayılmış 2 çevrimli boru hatlı IEEE-754 FP32 çarpıcı (MMPYF32)
//
//   Amaç:     İki 32-bit FP32 sayısını (fp_a, fp_b) 2 aşamalı boru hattı
//             üzerinden çarpar. 1. aşamada (E) clasify ve carp_k1
//             modüllerini çalıştırıp ara sonuçları 65-bitlik k_yazmaci
//             yazmacına kaydeder; 2. aşamada (W) carp_k2 ve pack modüllerini
//             çalıştırarak 32-bit sonucu, LVF/LUF taşma bayraklarını,
//             geçerlilik bitini (valid_out) ve hedef MR indeksini
//             (hedef_mr_out) üretir.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           hedef_mr:       Çarpım sonucunun yazılacağı 2-bitlik hedef MR
//                           indeksi (MR0..MR3)
//           rnd:            MSTF.RND32 yuvarlama modu biti (0: RZ, 1: RNE)
//           valid:          Bu çevrimde E aşamasında geçerli bir çarpma
//                           buyruğu olduğunu belirten bit
//           clk:            Sistem saati
//           rst:            Aktif-düşük sıfırlama sinyali
//           fp_a:           1. 32-bit IEEE-754 FP32 çarpanı
//           fp_b:           2. 32-bit IEEE-754 FP32 çarpanı
//   Outputlar:
//           lvf:            Geçerli çarpma sonucunda taşma olduğunu belirten
//                           bayrak (lvf_out & valid_out)
//           luf:            Geçerli çarpma sonucunda alt-taşma olduğunu
//                           belirten bayrak (luf_out & valid_out)
//           result:         W aşamasında hazır olan 32-bit IEEE-754 FP32
//                           çarpım sonucu
//           valid_out:      result çıkışının bu çevrimde geçerli olduğunu
//                           belirten bit (valid girişinden 1 çevrim sonra)
//           hedef_mr_out:   k_yazmaci üzerinden W aşamasına taşınan 2-bitlik
//                           hedef MR indeksi
//
//   Notlar:
//           k_yazmaci her saat kenarında güncellenir; E aşamasında dur_exe
//           beklemesi olduğunda üst modül (Execute.sv) valid girişini 0'a
//           çekerek K2 aşamasına balon sürer.

module fpu_carpma(
    
    input logic[1:0] hedef_mr,
    input logic rnd, 
    input logic valid,
    input logic clk,
    input logic rst,
    input logic [31:0]fp_a  ,
    input logic [31:0]fp_b,
 
    
    output logic lvf,
    output logic luf , 
    output logic [31:0] result ,
    output logic valid_out,
    output logic [1:0]hedef_mr_out   

    );

logic[64:0] k_yazmaci ; 



//Clasify ciktilari
logic [1:0]ozel_durumlar_a;
logic sign_a_out ; 
logic [7:0]exp_a_out;
logic [23:0]mantissa_a_out;

logic [1:0]ozel_durumlar_b;
logic sign_b_out ; 
logic [7:0]exp_b_out;
logic [23:0]mantissa_b_out;

//Carp_K1 ciktilari 
 logic [1:0]out_kod;
 logic out_sign;          
 logic [9:0]out_exp;      
 logic [47:0]out_mantissa;
 
 //Carp_K2 ciktilari
  logic [26:0] out_n_mantissa;   
  logic [9:0]exp_out;   
 
  logic lvf_out;
  logic luf_out;
 
clasify C_a(.fp(fp_a) , .sign(sign_a_out) , .exp(exp_a_out) , .mantissa(mantissa_a_out), .ozel_durumlar(ozel_durumlar_a));
clasify C_b(.fp(fp_b) , .sign(sign_b_out) , .exp(exp_b_out) , .mantissa(mantissa_b_out), .ozel_durumlar(ozel_durumlar_b));




carp_k1 M1(.kod_a(ozel_durumlar_a) , .kod_b(ozel_durumlar_b) , .sign_a(sign_a_out) , 
        .sign_b(sign_b_out ), .exp_a(exp_a_out) , .exp_b(exp_b_out) ,
        .mantissa_a(mantissa_a_out), .mantissa_b(mantissa_b_out) , .out_kod(out_kod),
        .out_sign(out_sign) , .out_exp(out_exp) ,.out_mantissa(out_mantissa)); 



     
always_ff@(posedge clk or negedge rst)begin
    if(!rst)
        k_yazmaci <= 65'b0 ; 

     else begin
        
        k_yazmaci <= {valid , hedef_mr , rnd , out_sign , out_exp , out_mantissa , out_kod};
        
            
     end

end




carp_k2 M2(.exp(k_yazmaci[59:50]) , .mantissa(k_yazmaci[49:2]) , .out_n_mantissa(out_n_mantissa) , .exp_out(exp_out));









pack P(.kod(k_yazmaci[1:0]) , .rnd(k_yazmaci[61]) , .sign(k_yazmaci[60]) , .exp_on(exp_out),
        .n_mantissa(out_n_mantissa) , .lvf(lvf_out) , .luf(luf_out) , .result(result));


assign valid_out = k_yazmaci[64] ; 
assign hedef_mr_out = k_yazmaci[63:62] ; 
assign lvf = lvf_out & valid_out;
assign luf = luf_out & valid_out;






endmodule 
