`timescale 1ns / 1ps

module Write(
                input logic clk ,
                input logic rst_n ,

                //////////////Execute'tan gelenler (E'deki buyruk, bu cevrim)
                input logic w_gecerli ,
                input logic [11:0]w_pc ,
                input logic [1:0]w_bellek_yaz ,
                input logic [15:0]w_adr ,
                input logic [31:0]w_veri ,
                input logic e_yaz1 ,
                input logic [1:0]e_hedef1 ,
                input logic [31:0]e_veri1 ,
                input logic e_yaz2 ,
                input logic [1:0]e_hedef2 ,
                input logic [31:0]e_veri_2 ,
                input logic [18:0]e_mstf_veri ,         // {RPC 12, MEALLOW, RND32, TF, ZF, NF, LUF, LVF}
                input logic [18:0]e_mstf_maske ,

                //////////////Execute'taki ALU'nun K2 cikislari (W'deki buyruk, bu cevrim)
                input logic [31:0]result_topla ,
                input logic lvf_topla ,
                input logic luf_topla ,
                input logic valid_topla ,
                input logic [1:0]hedef_mr_out_topla ,
                input logic [31:0]result_carp ,
                input logic lvf_carp ,
                input logic luf_carp ,
                input logic valid_carp ,
                input logic [1:0]hedef_mr_out_carp ,

                //////////////R2/E yazmacindan (dur_exe icin)
                input logic r2e_gecerli ,
                input logic [3:0]okunan_mr ,

                //////////////D2'den (MCCNDD)
                input logic rpc_en ,
                input logic [11:0]rpc_deger ,

                //////////////gorev denetcisinden
                input logic dondur ,
                input logic tumu_temizle ,

                //////////////MR yazmaclari (Execute ve iz icin)
                output logic [31:0]mr0_out ,
                output logic [31:0]mr1_out ,
                output logic [31:0]mr2_out ,
                output logic [31:0]mr3_out ,

                //////////////MSTF
                output logic [31:0]mstf ,                // mimari bit duzeni
                output logic rnd32 ,
                output logic [11:0]rpc ,
                output logic [4:0]gorunen_5 ,            // {TF, ZF, NF, LUF, LVF}
                output logic [31:0]gorunen_32 ,

                //////////////boru hatti
                output logic dur_exe ,

                //////////////RAM yazma portu (R1'deki port seciciye)
                output logic [1:0]w_blok ,               // 00 L1 , 01 L2 , 10 C2M , 11 M2C
                output logic [9:0]w_ram_adr ,
                output logic [1:0]w_wr_en ,              // 01: 16 bit , 11: 32 bit
                output logic [31:0]w_din ,

                //////////////E/W yazmaci (iz icin)
                output logic ew_gecerli ,
                output logic [11:0]ew_pc ,
                output logic [1:0]ew_bellek_yaz ,
                output logic [15:0]ew_yaz_adr ,
                output logic [31:0]ew_yaz_veri

                );



/////////////////////////E/W YAZMACI

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        ew_gecerli <= 1'b0;
        ew_pc <= 12'h000;
        ew_bellek_yaz <= 2'b00;
        ew_yaz_adr <= 16'h0000;
        ew_yaz_veri <= 32'h0000_0000;
    end
    else if(tumu_temizle) begin
        ew_gecerli <= 1'b0;                       // soft/hard reset : balon
    end
    else if(!dondur) begin
        ew_gecerli <= w_gecerli;                  // dur_exe'de Execute 0 verir : W'ye balon
        ew_pc <= w_pc;
        ew_bellek_yaz <= w_bellek_yaz;
        ew_yaz_adr <= w_adr;
        ew_yaz_veri <= w_veri;
    end

end



/////////////////////////dur_exe BIRIMI

// E'deki buyruk, W'deki buyrugun K2'de yazacagi bir MR'yi okuyorsa 1 cevrim bekler

logic [3:0]k2_maske;

always_comb begin

k2_maske = 4'b0000;

if(valid_topla) k2_maske[hedef_mr_out_topla] = 1'b1;
if(valid_carp) k2_maske[hedef_mr_out_carp] = 1'b1;

dur_exe = r2e_gecerli & (|(okunan_mr & k2_maske));

end



/////////////////////////MR YAZMA BIRIMI

// 4 kaynak : E1, E2 (E'deki buyruk), K2 topla, K2 carp (W'deki buyruk)
// ayni MR'ye birden fazla yazma : E > topla K2 > carp K2

logic [3:0]e1_maske;
logic [3:0]e2_maske;
logic [3:0]t_maske;
logic [3:0]c_maske;
logic [3:0]mr_en;
logic [31:0]mr_veri [0:3];

always_comb begin

e1_maske = e_yaz1 ? (4'b0001 << e_hedef1) : 4'b0000;
e2_maske = e_yaz2 ? (4'b0001 << e_hedef2) : 4'b0000;
t_maske = (valid_topla & ~dondur) ? (4'b0001 << hedef_mr_out_topla) : 4'b0000;
c_maske = (valid_carp & ~dondur) ? (4'b0001 << hedef_mr_out_carp) : 4'b0000;

mr_en = e1_maske | e2_maske | t_maske | c_maske;

for(int x = 0 ; x < 4 ; x++) begin
    if(e1_maske[x]) mr_veri[x] = e_veri1;
    else if(e2_maske[x]) mr_veri[x] = e_veri_2;
    else if(t_maske[x]) mr_veri[x] = result_topla;
    else mr_veri[x] = result_carp;
end

end



/////////////////////////MR YAZMACLARI

logic [31:0]mr_reg [0:3];

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        mr_reg[0] <= 32'h0;
        mr_reg[1] <= 32'h0;
        mr_reg[2] <= 32'h0;
        mr_reg[3] <= 32'h0;
    end
    else begin
        for(int x = 0 ; x < 4 ; x++) begin
            if(mr_en[x]) mr_reg[x] <= mr_veri[x];
        end
    end

end

assign mr0_out = mr_reg[0];
assign mr1_out = mr_reg[1];
assign mr2_out = mr_reg[2];
assign mr3_out = mr_reg[3];



/////////////////////////MSTF W GUNCELLEMESI

// K2'nin LVF/LUF'u yapiskan (pack cikislari zaten valid ile VE'li)

logic w_lvf_set;
logic w_luf_set;

assign w_lvf_set = (lvf_topla | lvf_carp) & ~dondur;
assign w_luf_set = (luf_topla | luf_carp) & ~dondur;



/////////////////////////MSTF YAZMACI

// oncelik : E guncellemesi > K2 LVF/LUF > D2 (RPC)

logic lvf_q;
logic luf_q;
logic nf_q;
logic zf_q;
logic tf_q;
logic rnd32_q;
logic meallow_q;
logic [11:0]rpc_q;

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        lvf_q <= 1'b0;
        luf_q <= 1'b0;
        nf_q <= 1'b0;
        zf_q <= 1'b0;
        tf_q <= 1'b0;
        rnd32_q <= 1'b0;
        meallow_q <= 1'b0;
        rpc_q <= 12'h000;
    end
    else begin

        if(e_mstf_maske[0]) lvf_q <= e_mstf_veri[0];
        else if(w_lvf_set) lvf_q <= 1'b1;

        if(e_mstf_maske[1]) luf_q <= e_mstf_veri[1];
        else if(w_luf_set) luf_q <= 1'b1;

        if(e_mstf_maske[2]) nf_q <= e_mstf_veri[2];
        if(e_mstf_maske[3]) zf_q <= e_mstf_veri[3];
        if(e_mstf_maske[4]) tf_q <= e_mstf_veri[4];
        if(e_mstf_maske[5]) rnd32_q <= e_mstf_veri[5];
        if(e_mstf_maske[6]) meallow_q <= e_mstf_veri[6];

        if(|e_mstf_maske[18:7]) rpc_q <= (rpc_q & ~e_mstf_maske[18:7]) | (e_mstf_veri[18:7] & e_mstf_maske[18:7]);
        else if(rpc_en) rpc_q <= rpc_deger;

    end

end

assign mstf = {8'h00 , rpc_q , meallow_q , 1'b0 , rnd32_q , 2'b00 , tf_q , 2'b00 , zf_q , nf_q , luf_q , lvf_q};
assign rnd32 = rnd32_q;
assign rpc = rpc_q;



/////////////////////////GORUNEN MSTF

// bu cevrimde K2'nin kurdugu LVF/LUF da gorunur (D2 dal karari, E kosulu, VERI_MSTF)
// golden'da D2 E'den once calisir : MCCNDD'nin bu cevrimde yazdigi RPC E'deki VERI_MSTF'ye gorunur

logic gorunen_lvf;
logic gorunen_luf;
logic [11:0]gorunen_rpc;

assign gorunen_lvf = lvf_q | lvf_topla | lvf_carp;
assign gorunen_luf = luf_q | luf_topla | luf_carp;
assign gorunen_rpc = rpc_en ? rpc_deger : rpc_q;

assign gorunen_5 = {tf_q , zf_q , nf_q , gorunen_luf , gorunen_lvf};
assign gorunen_32 = {8'h00 , gorunen_rpc , meallow_q , 1'b0 , rnd32_q , 2'b00 , tf_q , 2'b00 , zf_q , nf_q , gorunen_luf , gorunen_lvf};



/////////////////////////RAM YAZMA

logic blok_yazilir;

always_comb begin

w_blok = 2'b00;
w_ram_adr = 10'd0;
blok_yazilir = 1'b0;

if(ew_yaz_adr >= 16'h8800 && ew_yaz_adr <= 16'h8BFF) begin            // L1
    w_blok = 2'b00;
    w_ram_adr = ew_yaz_adr[9:0];                                        // adres - 0x8800
    blok_yazilir = 1'b1;
end
else if(ew_yaz_adr >= 16'h8C00 && ew_yaz_adr <= 16'h8FFF) begin       // L2
    w_blok = 2'b01;
    w_ram_adr = ew_yaz_adr[9:0];                                        // adres - 0x8C00
    blok_yazilir = 1'b1;
end
else if(ew_yaz_adr >= 16'h1480 && ew_yaz_adr <= 16'h14FF) begin       // C2M (CLA -> CPU mesaj RAM)
    w_blok = 2'b10;
    w_ram_adr = {3'b000 , ew_yaz_adr[6:0]};                             // adres - 0x1480
    blok_yazilir = 1'b1;
end
else if(ew_yaz_adr >= 16'h1500 && ew_yaz_adr <= 16'h157F) begin       // M2C : CLA yazamaz, yazma yutulur
    w_blok = 2'b11;
    w_ram_adr = {3'b000 , ew_yaz_adr[6:0]};
    blok_yazilir = 1'b0;
end

if(ew_bellek_yaz == 2'b11) w_ram_adr[0] = 1'b0;                        // 32 bit : alttaki cift adrese hizala

w_wr_en = (ew_gecerli & blok_yazilir & ~dondur) ? ew_bellek_yaz : 2'b00;
w_din = ew_yaz_veri;

end



endmodule
