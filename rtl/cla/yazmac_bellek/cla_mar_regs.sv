`timescale 1ns / 1ps

// MOD_CLA_MAR_REGS : Dolaylı bellek adreslemede kullanılan 2x16-bit yardımcı adres yazmaçları (MAR0 ve MAR1)
//
//   Amaç:     16-bitlik MAR0 ve MAR1 işaretçi (pointer) yazmaçlarını tutar.
//             Seçili yazmaca doğrudan yeni adres yükleme (wr_en) veya adresi
//             1 artırma (inc_en) / 1 azaltma (dec_en) işlemlerini senkron
//             olarak uygular.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           clk:            Sistem saati
//           rst_n:          Aktif-düşük sıfırlama sinyali
//           mar_sel:        İşlem yapılacak hedef yazmaç seçimi (0: MAR0, 1:
//                           MAR1)
//           wr_en:          Yeni adres yükleme etkinleştirme sinyali
//           inc_en:         Seçili MAR yazmacını +1 artırma etkinleştirme
//                           sinyali
//           dec_en:         Seçili MAR yazmacını -1 azaltma etkinleştirme
//                           sinyali
//           wr_addr_data:   Yüklenecek 16-bitlik yeni adres verisi
//   Outputlar:
//           mar0_out:       MAR0 yazmacının güncel 16-bit değeri
//           mar1_out:       MAR1 yazmacının güncel 16-bit değeri
//           active_mar_out: mar_sel ile seçilen aktif MAR yazmacının 16-bit
//                           değeri
//
//   Notlar:
//           Yazmaç güncelleme önceliği: wr_en > inc_en > dec_en.

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
