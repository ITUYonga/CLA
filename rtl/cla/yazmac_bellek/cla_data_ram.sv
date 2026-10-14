`timescale 1ns / 1ps

// MOD_CLA_DATA_RAM : 16-bit kelime adresli, 16/32-bit senkron okuma ve yazma destekli yerel veri BRAM modülü (L1 / L2)
//
//   Amaç:     CLA çekirdeğinin yerel L1 (0x8800) ve L2 (0x8C00) veri
//             belleklerini gerçekler. Her adres hücresi 16-bit
//             genişliğindedir; wr_en ve rd_en kontrol bitlerine göre tek
//             çevrimde 16-bit (yalnızca addr) veya 32-bit (addr ve addr+1
//             birlikte) okuma ve yazma yapar.
//
//   Parametreler:
//           ADDR_WIDTH:     16-bitlik kelime adresi bit genişliği (CLA_Top
//                           içinde L1 ve L2 için 10 -> 1024 x 16-bit = 2 KB)
//
//   Inputlar:
//           clk:            Sistem saati
//           addr:           16-bitlik kelime başlangıç adresi
//           wr_en:          Yazma izni (2'b01: alt 16-bit ram[addr], 2'b11:
//                           32-bit ram[addr] ve ram[addr+1])
//           rd_en:          Okuma izni (2'b01: alt 16-bit okunur üst yarı 0
//                           olur, 2'b11: 32-bit okunur)
//           din:            Belleğe yazılacak 32-bit veri
//   Outputlar:
//           dout:           Saat kenarında okunan 32-bit veri çıkışı
//
//   Notlar:
//           Okuma işlemi senkrondur (1 çevrim gecikmeli); rd_en[0] veya
//           rd_en[1] aktif değilse ilgili 16-bitlik yarı çıkışa 16'h0000
//           olarak sürülür.

module cla_data_ram #(

    parameter ADDR_WIDTH = 11
)(
input logic clk,

// CLA / CPU Arayüzü

input logic [ADDR_WIDTH-1:0] addr, // başlangıç adresi

input logic [1:0] wr_en, 
input logic [1:0] rd_en, // kontrol sinyalleri: 2'b01 ise 16 bit, 2'b11 ise 32 bit erişim

//32 bit veriyolları

input logic [31:0] din,
output logic [31:0] dout
);

logic [15:0] ram [0:(1<<ADDR_WIDTH)-1];

//yazma
always_ff@(posedge clk) begin
    
    if (wr_en[0]) begin //32 bitlik girişin alt yarısı yazılır
    ram [addr] <= din[15:0];
    end
    
    if (wr_en[1]) begin //32 bitlik girişin üst yarısı yazılır
    ram [addr+1] <= din[31:16];
    end    
end

always_ff@(posedge clk) begin

    if(rd_en[0])begin
    dout[15:0] <= ram[addr];
    end else begin
    dout[15:0] <= 16'h0000;
    end
    
    if(rd_en[1])begin
    dout[31:16] <= ram[addr+1];
    end else begin
    dout[31:16] <= 16'h0000;    
    end
end

endmodule
