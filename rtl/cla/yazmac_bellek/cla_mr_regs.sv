`timescale 1ns / 1ps

// MOD_CLA_MR_REGS : Çift yazma portlu 4x32-bit kayan nokta çalışma yazmaç öbeği (MR0 - MR3)
//
//   Amaç:     CLA'nın 4 adet 32-bitlik ana çalışma yazmacını (MR0, MR1, MR2,
//             MR3) barındırır. Paralel (Dual-Issue) buyrukların aynı saat
//             çevriminde iki ayrı yazmacı güncelleyebilmesi için iki
//             bağımsız senkron yazma portu (wr_en_0, wr_en_1) sunar.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           clk:            Sistem saati
//           rst_n:          Aktif-düşük sıfırlama sinyali
//           wr_en_0:        1. yazma portu etkinleştirme sinyali
//           wr_addr_0:      1. yazma portu hedef yazmaç seçimi (2'b00:MR0 ..
//                           2'b11:MR3)
//           wr_data_0:      1. yazma portundan yazılacak 32-bit veri
//           wr_en_1:        2. yazma portu etkinleştirme sinyali
//           wr_addr_1:      2. yazma portu hedef yazmaç seçimi (2'b00:MR0 ..
//                           2'b11:MR3)
//           wr_data_1:      2. yazma portundan yazılacak 32-bit veri
//   Outputlar:
//           mr0_out:        MR0 yazmacının 32-bit çıkışı
//           mr1_out:        MR1 yazmacının 32-bit çıkışı
//           mr2_out:        MR2 yazmacının 32-bit çıkışı
//           mr3_out:        MR3 yazmacının 32-bit çıkışı
//
//   Notlar:
//           Bu modül 2 yazma portlu temel sürümdür; CLA_Top içindeki
//           Write.sv aşaması hem E aşaması (2 port) hem de K2 FPU (2 port)
//           sonuçlarını aynı çevrimde kabul edebilmek için 4 yazma portlu
//           MR öbeği kullanır.

module cla_mr_regs (
    input  logic        clk,
    input  logic        rst_n,         

    // 1.yazma portu 
    input  logic        wr_en_0,          // 1. yazma izni (enable)
    input  logic [1:0]  wr_addr_0,        // 2'b00: MR0, 2'b01: MR1, 2'b10: MR2, 2'b11: MR3 (belirlenen MR)
    input  logic [31:0] wr_data_0,        // Yazılacak 32-bit sonuç (alu'dan gelen birinci veri)

    // 2.yazma portu 
    input  logic        wr_en_1,          // 2. yazma izni (enable)
    input  logic [1:0]  wr_addr_1,        // belirlenen MR
    input  logic [31:0] wr_data_1,        // Yazılacak 32-bit sonuç (alu'dan gelen ikinci veri)
    
    
    // cpu debug portu
    output logic [31:0] mr0_out,
    output logic [31:0] mr1_out,
    output logic [31:0] mr2_out,
    output logic [31:0] mr3_out
);

    // 4 adet 32-bit register dizisi 
    logic [31:0] mr_reg [0:3];

    // Senkron yazma
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mr_reg[0] <= 32'h0;
            mr_reg[1] <= 32'h0;
            mr_reg[2] <= 32'h0;
            mr_reg[3] <= 32'h0;
        end else if (wr_en_0) begin
            mr_reg[wr_addr_0] <= wr_data_0;
        end
        
        if(wr_en_1) begin
            if(!(wr_en_0) && (wr_addr_0 == wr_addr_1)) begin // iki farklı verinin aynı register'a yazılmaması için
            mr_reg[wr_addr_1] <= wr_data_1;
            end
        end
    end

    // Debug çıkışları
    assign mr0_out = mr_reg[0];
    assign mr1_out = mr_reg[1];
    assign mr2_out = mr_reg[2];
    assign mr3_out = mr_reg[3];

endmodule
