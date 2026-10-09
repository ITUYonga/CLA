`timescale 1ns / 1ps

module Read2
    import cla_pkg::*;
(
                input logic clk ,
                input logic rst_n ,

                //////////////R1/R2 yazmacindan
                input logic r1r2_gecerli ,
                input logic [11:0]r1r2_pc ,
                input logic [31:0]r1r2_kelime ,
                input kontrol_t r1r2_k ,
                input logic [15:0]r1r2_ea ,
                input logic [15:0]r1r2_m ,
                input logic [5:0]r1r2_shift ,
                input logic [1:0]r1r2_veri_mr ,
                input logic [15:0]r1r2_mar_d2 ,

                //////////////RAM cikislari (R1 sonunda okundu)
                input logic [31:0]l1_dout ,
                input logic [31:0]l2_dout ,
                input logic [31:0]c2m_dout ,
                input logic [31:0]m2c_dout ,

                //////////////boru hatti denetiminden
                input logic en ,                         // R2/E ilerler : ~(dur_exe | dondur)
                input logic tumu_temizle ,

                //////////////R2/E yazmaci (Execute'a)
                output logic r2e_gecerli ,
                output logic [11:0]r2e_pc ,
                output logic [31:0]r2e_kelime ,
                output kontrol_t r2e_k ,
                output logic [15:0]r2e_ea ,
                output logic [15:0]r2e_m ,
                output logic [5:0]r2e_shift ,
                output logic [1:0]r2e_veri_mr ,
                output logic [15:0]r2e_mar_d2 ,
                output logic [31:0]r2e_okunan

                );



/////////////////////////OKUNAN SECICI

// blok R1 ile ayni kuralla ea'dan bulunur. 16 bitte RAM ust yariyi zaten 0 verir.

logic [31:0]okunan_canli;

always_comb begin

if(r1r2_ea >= 16'h8800 && r1r2_ea <= 16'h8BFF) okunan_canli = l1_dout;          // L1
else if(r1r2_ea >= 16'h8C00 && r1r2_ea <= 16'h8FFF) okunan_canli = l2_dout;     // L2
else if(r1r2_ea >= 16'h1480 && r1r2_ea <= 16'h14FF) okunan_canli = c2m_dout;    // C2M
else if(r1r2_ea >= 16'h1500 && r1r2_ea <= 16'h157F) okunan_canli = m2c_dout;    // M2C
else okunan_canli = 32'h0000_0000;

end



/////////////////////////OKUNANI TUT

// RAM verisi yalniz R1/R2'nin yuklendigi kenardan sonraki cevrimde gecerli (RAM okumayinca cikisi 0'lar).
// dur_exe'de R2 beklerken veri bu yazmactan gelir.

logic taze;
logic [31:0]okunan_tut;
logic [31:0]okunan;

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        taze <= 1'b0;
        okunan_tut <= 32'h0000_0000;
    end
    else begin
        taze <= en;                              // R1/R2 bu kenarda yuklendi mi
        if(taze) okunan_tut <= okunan_canli;
    end

end

assign okunan = taze ? okunan_canli : okunan_tut;



/////////////////////////R2/E YAZMACI

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        r2e_gecerli <= 1'b0;
        r2e_pc <= 12'h000;
        r2e_kelime <= 32'h0000_0000;
        r2e_k <= '0;
        r2e_ea <= 16'h0000;
        r2e_m <= 16'h0000;
        r2e_shift <= 6'd0;
        r2e_veri_mr <= 2'b00;
        r2e_mar_d2 <= 16'h0000;
        r2e_okunan <= 32'h0000_0000;
    end
    else if(tumu_temizle) begin
        r2e_gecerli <= 1'b0;
    end
    else if(en) begin
        r2e_gecerli <= r1r2_gecerli;
        r2e_pc <= r1r2_pc;
        r2e_kelime <= r1r2_kelime;
        r2e_k <= r1r2_k;
        r2e_ea <= r1r2_ea;
        r2e_m <= r1r2_m;
        r2e_shift <= r1r2_shift;
        r2e_veri_mr <= r1r2_veri_mr;
        r2e_mar_d2 <= r1r2_mar_d2;
        r2e_okunan <= okunan;
    end

end



endmodule
