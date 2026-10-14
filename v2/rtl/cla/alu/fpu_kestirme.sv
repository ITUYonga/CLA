`timescale 1ns / 1ps


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