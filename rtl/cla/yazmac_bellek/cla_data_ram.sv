`timescale 1ns / 1ps

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
