`timescale 1ns / 1ps

// Mesaj RAM'i (M2C / C2M) : CLA portu cla_data_ram ile birebir ayni davranir, yanina AXI portu eklendi.
//   CLA portu : 16 bit word adresli , 2'b01 16 bit / 2'b11 32 bit erisim (addr , addr+1) ,
//               senkron okuma (1 cevrim) , rd_en biti 0 iken ilgili yari 0 okunur
//   AXI portu : paketli 32 bit word ; alt yari {axi_adr,0} , ust yari {axi_adr,1} , asenkron okuma
// Ayni 16 bitlik yere ayni cevrimde iki taraf yazarsa AXI kazanir
// (wrapper'da her RAM'e tek taraf yazar : M2C'ye AXI , C2M'ye CLA).

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
