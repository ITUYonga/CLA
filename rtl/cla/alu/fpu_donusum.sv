`timescale 1ns / 1ps


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
