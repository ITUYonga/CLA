`timescale 1ns / 1ps

// MOD_CLA_MESAJ_RAM : CLA çekirdeği ile AXI4-Lite veriyolu arasında veri paylaşımı sağlayan çift portlu mesaj RAM'i
//
//   Amaç:     CPU ile CLA arasındaki M2C (0x1500) ve C2M (0x1480) köprü
//             belleklerini gerçekler. CLA tarafında 16-bit kelime adresli,
//             16/32-bit senkron okuma ve yazma desteği sunarken; AXI
//             tarafında 32-bit paketlenmiş kelime adresli senkron yazma ve
//             kombinasyonel okuma sağlar.
//
//   Parametreler:
//           ADDR_WIDTH:     16-bitlik kelime adresi genişliği (varsayılan: 7
//                           -> 128 x 16-bit = 64 x 32-bit kelime)
//
//   Inputlar:
//           clk:            Sistem saati
//           addr:           CLA portu 16-bit kelime başlangıç adresi
//           wr_en:          CLA yazma izni (2'b01: 16-bit alt yarı, 2'b11:
//                           32-bit addr ve addr+1)
//           rd_en:          CLA okuma izni (2'b01: 16-bit alt yarı, 2'b11:
//                           32-bit okuma)
//           din:            CLA portundan yazılacak 32-bit veri
//           axi_adr:        AXI portu 32-bitlik çift kelime adresi
//                           (ADDR_WIDTH-1 bit)
//           axi_wr_en:      AXI yazma izni (bit 0: alt 16-bit yarı, bit 1: üst
//                           16-bit yarı)
//           axi_din:        AXI portundan yazılacak 32-bit veri
//   Outputlar:
//           dout:           CLA portundan 1 çevrim gecikmeyle okunan 32-bit
//                           veri (rd_en biti 0 olan yarılar 0 döner)
//           axi_dout:       AXI portundan kombinasyonel olarak okunan 32-bit
//                           paketli veri ({ram[{axi_adr,1}],
//                           ram[{axi_adr,0}]})
//
//   Notlar:
//           Aynı çevrimde aynı 16-bitlik hücreye hem CLA hem AXI yazarsa
//           kod sırası gereği AXI yazması kazanır; ancak üst tasarımda
//           M2C'ye yalnızca AXI, C2M'ye ise yalnızca CLA yazar.
//
//           CLA okuma portu cla_data_ram modülü ile birebir aynı
//           zamanlamaya sahiptir; rd_en[0] veya rd_en[1] sıfır olduğunda
//           ilgili 16-bitlik yarı çıkışa 16'h0000 olarak sürülür.

module cla_mesaj_ram #(
                parameter ADDR_WIDTH = 7                 // 16 bitlik word adresi
)(
                input logic clk ,

                //////////////CLA portu
                input logic [ADDR_WIDTH-1:0]addr ,
                input logic [1:0]wr_en ,
                input logic [1:0]rd_en ,
                input logic [31:0]din ,
                output logic [31:0]dout ,

                //////////////AXI portu
                input logic [ADDR_WIDTH-2:0]axi_adr ,    // 32 bitlik word adresi
                input logic [1:0]axi_wr_en ,             // bit0 alt yari , bit1 ust yari
                input logic [31:0]axi_din ,
                output logic [31:0]axi_dout

                );



logic [15:0]ram[0:(1<<ADDR_WIDTH)-1];



/////////////////////////YAZMA

always_ff@(posedge clk) begin

    if(wr_en[0]) ram[addr] <= din[15:0];
    if(wr_en[1]) ram[addr+1] <= din[31:16];

    if(axi_wr_en[0]) ram[{axi_adr , 1'b0}] <= axi_din[15:0];
    if(axi_wr_en[1]) ram[{axi_adr , 1'b1}] <= axi_din[31:16];

end



/////////////////////////CLA OKUMA (cla_data_ram ile ayni)

always_ff@(posedge clk) begin

    if(rd_en[0]) dout[15:0] <= ram[addr];
    else dout[15:0] <= 16'h0000;

    if(rd_en[1]) dout[31:16] <= ram[addr+1];
    else dout[31:16] <= 16'h0000;

end



/////////////////////////AXI OKUMA

assign axi_dout = {ram[{axi_adr , 1'b1}] , ram[{axi_adr , 1'b0}]};



endmodule
