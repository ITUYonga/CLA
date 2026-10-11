`timescale 1ns / 1ps

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