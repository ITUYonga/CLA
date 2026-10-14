`timescale 1ns / 1ps

module Read1
    import cla_pkg::*;
(
                input logic clk ,
                input logic rst_n ,

                //////////////D2/R1 yazmacindan
                input logic d2r1_gecerli ,
                input logic [11:0]d2r1_pc ,
                input logic [31:0]d2r1_kelime ,
                input kontrol_t d2r1_k ,
                input logic [15:0]d2r1_ea ,
                input logic [15:0]d2r1_m ,
                input logic [5:0]d2r1_shift ,
                input logic [1:0]d2r1_veri_mr ,
                input logic [15:0]d2r1_mar_d2 ,

                //////////////Write'tan (W'deki bellek yazmasi)
                input logic [1:0]w_blok ,
                input logic [9:0]w_ram_adr ,
                input logic [1:0]w_wr_en ,
                input logic [31:0]w_din ,

                //////////////boru hatti denetiminden
                input logic dur_exe ,
                input logic dondur ,
                input logic en ,                         // R1/R2 ilerler : ~(dur_exe | dondur)
                input logic tumu_temizle ,

                //////////////boru hatti denetimine
                output logic dur_r1 ,

                //////////////L1, L2 veri RAM'leri (cla_data_ram)
                output logic [9:0]l1_addr ,
                output logic [1:0]l1_wr_en ,
                output logic [1:0]l1_rd_en ,
                output logic [31:0]l1_din ,
                output logic [9:0]l2_addr ,
                output logic [1:0]l2_wr_en ,
                output logic [1:0]l2_rd_en ,
                output logic [31:0]l2_din ,

                //////////////mesaj RAM'leri (kopru)
                output logic [6:0]c2m_addr ,
                output logic [1:0]c2m_wr_en ,
                output logic [1:0]c2m_rd_en ,
                output logic [31:0]c2m_din ,
                output logic [6:0]m2c_addr ,
                output logic [1:0]m2c_rd_en ,

                //////////////R1/R2 yazmaci
                output logic r1r2_gecerli ,
                output logic [11:0]r1r2_pc ,
                output logic [31:0]r1r2_kelime ,
                output kontrol_t r1r2_k ,
                output logic [15:0]r1r2_ea ,
                output logic [15:0]r1r2_m ,
                output logic [5:0]r1r2_shift ,
                output logic [1:0]r1r2_veri_mr ,
                output logic [15:0]r1r2_mar_d2

                );



/////////////////////////OKUMA ADRESI

// blok : 00 L1 , 01 L2 , 10 C2M , 11 M2C

logic [1:0]r1_blok;
logic r1_blok_var;
logic [9:0]r1_adr;
logic [1:0]r1_rd_en;

always_comb begin

r1_blok = 2'b00;
r1_adr = 10'd0;
r1_blok_var = 1'b0;

if(d2r1_ea >= 16'h8800 && d2r1_ea <= 16'h8BFF) begin            // L1
    r1_blok = 2'b00;
    r1_adr = d2r1_ea[9:0];                                       // adres - 0x8800
    r1_blok_var = 1'b1;
end
else if(d2r1_ea >= 16'h8C00 && d2r1_ea <= 16'h8FFF) begin       // L2
    r1_blok = 2'b01;
    r1_adr = d2r1_ea[9:0];                                       // adres - 0x8C00
    r1_blok_var = 1'b1;
end
else if(d2r1_ea >= 16'h1480 && d2r1_ea <= 16'h14FF) begin       // C2M
    r1_blok = 2'b10;
    r1_adr = {3'b000 , d2r1_ea[6:0]};                            // adres - 0x1480
    r1_blok_var = 1'b1;
end
else if(d2r1_ea >= 16'h1500 && d2r1_ea <= 16'h157F) begin       // M2C
    r1_blok = 2'b11;
    r1_adr = {3'b000 , d2r1_ea[6:0]};                            // adres - 0x1500
    r1_blok_var = 1'b1;
end

if(d2r1_k.bellek_oku == ERISIM_32) r1_adr[0] = 1'b0;            // 32 bit : alttaki cift adrese hizala

r1_rd_en = (d2r1_gecerli & r1_blok_var & ~dur_exe & ~dur_r1 & ~dondur) ? d2r1_k.bellek_oku : 2'b00;

end



/////////////////////////dur_r1 BIRIMI

// W ayni bloga yaziyorsa R1 bir cevrim bekler (tek portlu blok). M2C'de bekleme yok (CLA yazamaz).

always_comb begin

dur_r1 = d2r1_gecerli & (d2r1_k.bellek_oku != ERISIM_YOK) & r1_blok_var & (r1_blok != 2'b11) &
         (w_wr_en != 2'b00) & (w_blok == r1_blok);

end



/////////////////////////RAM PORT SECICI

// her blogun tek portu : W yaziyorsa W'nin, degilse R1'in

always_comb begin

if(w_wr_en != 2'b00 && w_blok == 2'b00) begin                    // L1
    l1_addr = w_ram_adr;
    l1_wr_en = w_wr_en;
    l1_rd_en = 2'b00;
end
else begin
    l1_addr = r1_adr;
    l1_wr_en = 2'b00;
    l1_rd_en = (r1_blok == 2'b00) ? r1_rd_en : 2'b00;
end

if(w_wr_en != 2'b00 && w_blok == 2'b01) begin                    // L2
    l2_addr = w_ram_adr;
    l2_wr_en = w_wr_en;
    l2_rd_en = 2'b00;
end
else begin
    l2_addr = r1_adr;
    l2_wr_en = 2'b00;
    l2_rd_en = (r1_blok == 2'b01) ? r1_rd_en : 2'b00;
end

if(w_wr_en != 2'b00 && w_blok == 2'b10) begin                    // C2M
    c2m_addr = w_ram_adr[6:0];
    c2m_wr_en = w_wr_en;
    c2m_rd_en = 2'b00;
end
else begin
    c2m_addr = r1_adr[6:0];
    c2m_wr_en = 2'b00;
    c2m_rd_en = (r1_blok == 2'b10) ? r1_rd_en : 2'b00;
end

m2c_addr = r1_adr[6:0];                                          // M2C : CLA yalniz okur
m2c_rd_en = (r1_blok == 2'b11) ? r1_rd_en : 2'b00;

l1_din = w_din;
l2_din = w_din;
c2m_din = w_din;

end



/////////////////////////R1/R2 YAZMACI

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        r1r2_gecerli <= 1'b0;
        r1r2_pc <= 12'h000;
        r1r2_kelime <= 32'h0000_0000;
        r1r2_k <= '0;
        r1r2_ea <= 16'h0000;
        r1r2_m <= 16'h0000;
        r1r2_shift <= 6'd0;
        r1r2_veri_mr <= 2'b00;
        r1r2_mar_d2 <= 16'h0000;
    end
    else if(tumu_temizle) begin
        r1r2_gecerli <= 1'b0;
    end
    else if(en) begin
        if(dur_r1) begin
            r1r2_gecerli <= 1'b0;                // R1 bekler, R2'ye balon
        end
        else begin
            r1r2_gecerli <= d2r1_gecerli;
            r1r2_pc <= d2r1_pc;
            r1r2_kelime <= d2r1_kelime;
            r1r2_k <= d2r1_k;
            r1r2_ea <= d2r1_ea;
            r1r2_m <= d2r1_m;
            r1r2_shift <= d2r1_shift;
            r1r2_veri_mr <= d2r1_veri_mr;
            r1r2_mar_d2 <= d2r1_mar_d2;
        end
    end

end



endmodule
