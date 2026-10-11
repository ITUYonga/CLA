`timescale 1ns / 1ps

module cla_mar_regs (
    input  logic        clk,
    input  logic        rst_n,

    // mar_sel, mar0 ya da mar1'i seçer:
    input  logic        mar_sel,

    input  logic        wr_en,        // yeni adres yükleme
    input  logic        inc_en,       // Adresi 1 artırma
    input  logic        dec_en,       // Adresi 1 azaltma

    // yeni yüklenecek adresin girişi
    input  logic [15:0] wr_addr_data,

    output logic [15:0] mar0_out,
    output logic [15:0] mar1_out,

    // seçili olan aktif pointer adresi
    output logic [15:0] active_mar_out
);

    // 2 tane 16 bitlik register
    logic [15:0] mar_reg [0:1];

    // senkron güncelleme
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mar_reg[0] <= 16'h0000;
            mar_reg[1] <= 16'h0000;
        end else begin
            // yeni adres yazma
            if (wr_en) begin
                mar_reg[mar_sel] <= wr_addr_data;
            end
            // adres arttırma
            else if (inc_en) begin
                mar_reg[mar_sel] <= mar_reg[mar_sel] + 16'd1;
            end
            // adres azaltma
            else if (dec_en) begin
                mar_reg[mar_sel] <= mar_reg[mar_sel] - 16'd1;
            end
        end
    end

   
    assign mar0_out       = mar_reg[0];
    assign mar1_out       = mar_reg[1];
    assign active_mar_out = mar_reg[mar_sel];

endmodule