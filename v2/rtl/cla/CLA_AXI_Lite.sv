`timescale 1ns / 1ps

// CLA_Top icin AXI4-Lite slave sarmalayicisi. Tek saat : clk = S_AXI_ACLK , rst_n = S_AXI_ARESETN.
//
// Adres haritasi (byte adresli , 32 bit word) :
//   0x000 - 0x01C : gorev yazmaclari 0-7 , ofset = no*4 (MIFR, MIOVF, MICLR, MICLROVF, MIFRC, MIER, MIRUN, MCTL)
//   0x020 - 0x03C : MVECT1-8
//   0x040         : IRQ_DURUM (R/W1C) , bit i : gorev i+1 bitti (pie_kesme[i] yukselen kenari)
//   0x044         : IRQ_MASKE (RW)    , irq = |(IRQ_DURUM & IRQ_MASKE)
//   0x048         : KONTROL (RW)      , bit0 CLA_SIFIRLA : 1 iken CLA_Top resette tutulur (gorev yazmaclari ,
//                                       MVECT , boru hatti) ; AXI arayuzu , IRQ yazmaclari ve mesaj RAM'leri etkilenmez
//   0x04C         : KIMLIK (R)        , 0x434C_4101 ("CLA" + surum 01) : dogru bitstream denetimi
//   0x100 - 0x1FC : M2C (RW) , paketli : [15:0] cift 16 bit word , [31:16] tek 16 bit word
//   0x200 - 0x2FC : C2M (R)  , paketli , yazma yok sayilir
//   diger         : 0 okunur , yazma yok sayilir
// 16 bitlik yazmaclarin ust 16 biti 0 okunur.
// WSTRB : 16 bitlik bir yari yalnizca iki bayti da etkinse yazilir (yazmaclarda [1:0] , RAM'de [1:0] / [3:2]).
// Yanit her zaman OKAY. Islemler tek tek yurutulur ; yazma ve okuma ayni anda gelirse sirayla (round robin).
// Gecikme : AW+W kabulunden 2 cevrim sonra BVALID , AR kabulunden 2 cevrim sonra RVALID.

module CLA_AXI_Lite
#(
                parameter string PROGRAM_HEX = "" ,      // CLA_Top'a aynen gecer
                parameter bit TRIG_SENKRON = 1'b0 ,       // 1 : hw_task_trig asenkron kaynaktan , 2 flop senkronlayici
                parameter logic [31:0]KIMLIK = 32'h434C_4101
)(
                //////////////saat , reset
                input logic S_AXI_ACLK ,
                input logic S_AXI_ARESETN ,

                //////////////yazma adresi
                input logic [11:0]S_AXI_AWADDR ,
                input logic [2:0]S_AXI_AWPROT ,
                input logic S_AXI_AWVALID ,
                output logic S_AXI_AWREADY ,

                //////////////yazma verisi
                input logic [31:0]S_AXI_WDATA ,
                input logic [3:0]S_AXI_WSTRB ,
                input logic S_AXI_WVALID ,
                output logic S_AXI_WREADY ,

                //////////////yazma yaniti
                output logic [1:0]S_AXI_BRESP ,
                output logic S_AXI_BVALID ,
                input logic S_AXI_BREADY ,

                //////////////okuma adresi
                input logic [11:0]S_AXI_ARADDR ,
                input logic [2:0]S_AXI_ARPROT ,
                input logic S_AXI_ARVALID ,
                output logic S_AXI_ARREADY ,

                //////////////okuma verisi
                output logic [31:0]S_AXI_RDATA ,
                output logic [1:0]S_AXI_RRESP ,
                output logic S_AXI_RVALID ,
                input logic S_AXI_RREADY ,

                //////////////cevre birimi tetikleri (gorev 1-8) , yukselen kenar tetikler
                input logic [7:0]hw_task_trig ,

                //////////////kesme
                output logic irq ,                       // seviye , IRQ_DURUM temizlenene kadar 1
                output logic [7:0]pie_kesme              // CLA_Top'tan ham

                );



/////////////////////////SINYALLER

logic clk;
logic rst_n;

assign clk = S_AXI_ACLK;
assign rst_n = S_AXI_ARESETN;

// AXI durum makinesi
typedef enum logic [2:0] {BOS , YAZ , YAZ_YANIT , OKU , OKU_YANIT} durum_e;

durum_e durum;
logic son_yazma;                                        // son kabul edilen islem yazma ise 1
logic yaz_istek;
logic oku_istek;
logic yaz_sec;
logic oku_sec;
logic [11:0]islem_adr;
logic [31:0]islem_veri;
logic [3:0]islem_strb;
logic [31:0]oku_veri;

// adres cozme
logic sec_gorev;
logic sec_mvect;
logic sec_irq_durum;
logic sec_irq_maske;
logic sec_kontrol;
logic sec_kimlik;
logic sec_m2c;
logic sec_c2m;
logic yaz_cevrim;
logic alt_yaz;
logic ust_yaz;

// CLA_Top CPU portlari
logic cpu_wr_en;
logic [2:0]cpu_reg_addr;
logic [15:0]cpu_wr_data;
logic [15:0]cpu_rd_data;
logic mvect_wr_en;
logic [2:0]mvect_gorev;
logic [15:0]mvect_veri;
logic [15:0]mvect_oku;

// tetik , kesme
logic [7:0]trig_giris;
logic [7:0]trig_q;
logic [7:0]trig_kenar;
logic [7:0]pie_q;
logic [7:0]pie_kenar;
logic [7:0]irq_durum;
logic [7:0]irq_maske;
logic [7:0]irq_temizle;

// mesaj RAM'leri
logic [6:0]m2c_addr;
logic [1:0]m2c_rd_en;
logic [31:0]m2c_dout;
logic [6:0]c2m_addr;
logic [1:0]c2m_wr_en;
logic [1:0]c2m_rd_en;
logic [31:0]c2m_din;
logic [31:0]c2m_dout;
logic [1:0]m2c_axi_wr_en;
logic [31:0]m2c_axi_dout;
logic [31:0]c2m_axi_dout;

// CLA reset
logic cla_sifirla;
logic cla_rst_n;



/////////////////////////AXI EL SIKISMA

// yazma AW ve W birlikte gelince kabul edilir ; ikisi ve okuma ayni anda bekliyorsa sirayla

assign yaz_istek = S_AXI_AWVALID & S_AXI_WVALID;
assign oku_istek = S_AXI_ARVALID;
assign yaz_sec = (durum == BOS) & yaz_istek & (~oku_istek | ~son_yazma);
assign oku_sec = (durum == BOS) & oku_istek & ~yaz_sec;

assign S_AXI_AWREADY = yaz_sec;
assign S_AXI_WREADY = yaz_sec;
assign S_AXI_ARREADY = oku_sec;

assign S_AXI_BVALID = (durum == YAZ_YANIT);
assign S_AXI_BRESP = 2'b00;
assign S_AXI_RVALID = (durum == OKU_YANIT);
assign S_AXI_RRESP = 2'b00;
assign S_AXI_RDATA = oku_veri;

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        durum <= BOS;
        son_yazma <= 1'b0;
        islem_adr <= 12'h000;
        islem_veri <= 32'h0000_0000;
        islem_strb <= 4'h0;
    end
    else begin

        case(durum)
            BOS : begin
                if(yaz_sec) begin
                    islem_adr <= S_AXI_AWADDR;
                    islem_veri <= S_AXI_WDATA;
                    islem_strb <= S_AXI_WSTRB;
                    son_yazma <= 1'b1;
                    durum <= YAZ;
                end
                else if(oku_sec) begin
                    islem_adr <= S_AXI_ARADDR;
                    son_yazma <= 1'b0;
                    durum <= OKU;
                end
            end
            YAZ : durum <= YAZ_YANIT;                               // yazma bu cevrimde uygulanir
            YAZ_YANIT : if(S_AXI_BREADY) durum <= BOS;
            OKU : durum <= OKU_YANIT;                               // okunan veri bu cevrimde yakalanir
            OKU_YANIT : if(S_AXI_RREADY) durum <= BOS;
            default : durum <= BOS;
        endcase

    end

end



/////////////////////////ADRES COZME

assign sec_gorev = (islem_adr[11:5] == 7'h00);          // 0x000 - 0x01C
assign sec_mvect = (islem_adr[11:5] == 7'h01);          // 0x020 - 0x03C
assign sec_irq_durum = (islem_adr[11:2] == 10'h010);    // 0x040
assign sec_irq_maske = (islem_adr[11:2] == 10'h011);    // 0x044
assign sec_kontrol = (islem_adr[11:2] == 10'h012);      // 0x048
assign sec_kimlik = (islem_adr[11:2] == 10'h013);       // 0x04C
assign sec_m2c = (islem_adr[11:8] == 4'h1);             // 0x100 - 0x1FC
assign sec_c2m = (islem_adr[11:8] == 4'h2);             // 0x200 - 0x2FC

assign yaz_cevrim = (durum == YAZ);
assign alt_yaz = (islem_strb[1:0] == 2'b11);
assign ust_yaz = (islem_strb[3:2] == 2'b11);



/////////////////////////CLA_Top CPU PORTLARI

assign cpu_wr_en = yaz_cevrim & sec_gorev & alt_yaz;
assign cpu_reg_addr = islem_adr[4:2];
assign cpu_wr_data = islem_veri[15:0];

assign mvect_wr_en = yaz_cevrim & sec_mvect & alt_yaz;
assign mvect_gorev = islem_adr[4:2];                    // 0 : MVECT1 ... 7 : MVECT8
assign mvect_veri = islem_veri[15:0];

assign m2c_axi_wr_en = {ust_yaz , alt_yaz} & {2{yaz_cevrim & sec_m2c}};



/////////////////////////OKUMA VERISI

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) oku_veri <= 32'h0000_0000;
    else if(durum == OKU) begin
        if(sec_gorev) oku_veri <= {16'h0000 , cpu_rd_data};
        else if(sec_mvect) oku_veri <= {16'h0000 , mvect_oku};
        else if(sec_irq_durum) oku_veri <= {24'h000000 , irq_durum};
        else if(sec_irq_maske) oku_veri <= {24'h000000 , irq_maske};
        else if(sec_kontrol) oku_veri <= {31'h0 , cla_sifirla};
        else if(sec_kimlik) oku_veri <= KIMLIK;
        else if(sec_m2c) oku_veri <= m2c_axi_dout;
        else if(sec_c2m) oku_veri <= c2m_axi_dout;
        else oku_veri <= 32'h0000_0000;
    end

end



/////////////////////////CEVRE BIRIMI TETIKLERI

// Gorev_Yazmaclari 1 olan her cevrimi ayri tetik sayar ; seviye tutan kaynak MIOVF kurar.
// Bu yuzden yalnizca yukselen kenar gecirilir.

generate
    if(TRIG_SENKRON) begin : g_trig_senkron
        logic [7:0]trig_s1;
        logic [7:0]trig_s2;
        always_ff@(posedge clk or negedge rst_n) begin
            if(!rst_n) begin
                trig_s1 <= 8'h00;
                trig_s2 <= 8'h00;
            end
            else begin
                trig_s1 <= hw_task_trig;
                trig_s2 <= trig_s1;
            end
        end
        assign trig_giris = trig_s2;
    end
    else begin : g_trig_dogrudan
        assign trig_giris = hw_task_trig;
    end
endgenerate

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) trig_q <= 8'h00;
    else trig_q <= trig_giris;

end

assign trig_kenar = trig_giris & ~trig_q;



/////////////////////////KESME

// IRQ_DURUM : pie_kesme yukselen kenarinda kurulur , 1 yazilan bit temizlenir.
// Ayni cevrimde kurma ve temizleme : kurma kazanir (kesme kaybolmaz).

assign pie_kenar = pie_kesme & ~pie_q;
assign irq_temizle = (yaz_cevrim & sec_irq_durum & alt_yaz) ? islem_veri[7:0] : 8'h00;

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        pie_q <= 8'h00;
        irq_durum <= 8'h00;
        irq_maske <= 8'h00;
    end
    else begin
        pie_q <= pie_kesme;
        irq_durum <= (irq_durum & ~irq_temizle) | pie_kenar;
        if(yaz_cevrim & sec_irq_maske & alt_yaz) irq_maske <= islem_veri[7:0];
    end

end

assign irq = |(irq_durum & irq_maske);                 // flop cikislarindan , W1C'den hemen sonra duser



/////////////////////////CLA RESET

// cla_sifirla flop cikisi oldugu icin reset hem kenarsiz hem saate senkron kalkar

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) cla_sifirla <= 1'b0;
    else if(yaz_cevrim & sec_kontrol & alt_yaz) cla_sifirla <= islem_veri[0];

end

assign cla_rst_n = rst_n & ~cla_sifirla;



/////////////////////////CLA

CLA_Top #(.PROGRAM_HEX(PROGRAM_HEX)) CLA(.clk(clk) , .rst_n(cla_rst_n) ,
        .cpu_wr_en(cpu_wr_en) , .cpu_reg_addr(cpu_reg_addr) , .cpu_wr_data(cpu_wr_data) , .cpu_rd_data(cpu_rd_data) ,
        .mvect_wr_en(mvect_wr_en) , .mvect_gorev(mvect_gorev) , .mvect_veri(mvect_veri) , .mvect_oku(mvect_oku) ,
        .hw_task_trig(trig_kenar) ,
        .pie_kesme(pie_kesme) , .mirun() ,                         // MIRUN 0x018'den okunur
        .m2c_addr(m2c_addr) , .m2c_rd_en(m2c_rd_en) , .m2c_dout(m2c_dout) ,
        .c2m_addr(c2m_addr) , .c2m_wr_en(c2m_wr_en) , .c2m_rd_en(c2m_rd_en) , .c2m_din(c2m_din) , .c2m_dout(c2m_dout));



/////////////////////////MESAJ RAM'LERI

// M2C : CPU yazar/okur , CLA okur

cla_mesaj_ram #(.ADDR_WIDTH(7)) M2C(.clk(clk) ,
        .addr(m2c_addr) , .wr_en(2'b00) , .rd_en(m2c_rd_en) , .din(32'h0000_0000) , .dout(m2c_dout) ,
        .axi_adr(islem_adr[7:2]) , .axi_wr_en(m2c_axi_wr_en) , .axi_din(islem_veri) , .axi_dout(m2c_axi_dout));

// C2M : CLA yazar/okur , CPU okur

cla_mesaj_ram #(.ADDR_WIDTH(7)) C2M(.clk(clk) ,
        .addr(c2m_addr) , .wr_en(c2m_wr_en) , .rd_en(c2m_rd_en) , .din(c2m_din) , .dout(c2m_dout) ,
        .axi_adr(islem_adr[7:2]) , .axi_wr_en(2'b00) , .axi_din(32'h0000_0000) , .axi_dout(c2m_axi_dout));



endmodule
