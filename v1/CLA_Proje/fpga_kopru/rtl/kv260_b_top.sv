`timescale 1ns / 1ps
// =====================================================================
//  kv260_b_top - B yolu ust modulu: kopru + CLA
// ---------------------------------------------------------------------
//      PC --micro-USB--> PS UART --> ARM (aktarici.elf) --AXI4-Lite--+
//                                                                    |
//      cla_axi_kopru (mesaj RAM'leri, CPU yerine gecer) <---> CLA_Top
//  CLA_Top gorev yazmaclarini (MIFR, MIER, MIRUN ...) kendi icinde tutar.
//  Program L3'e bitstream'le gelir: PROGRAM_HEX (16 bit/satir, l3_uret.py ciktisi).
//  Blok tasarima kv260_b_sarmal.v ile (Verilog sarmal) eklenir:
//  clk = pl_clk0 (100 MHz), rst_n = pl_resetn0, s_axi = M_AXI_HPM0_LPD.
// =====================================================================
module kv260_b_top #(
    parameter int ZAMAN_ASIMI = 1_000_000,   // 10 ms @100 MHz
    parameter int BAYT_ASIMI  = 1_000_000,
    parameter string PROGRAM_HEX = ""        // L3 baslangic goruntusu
)(
    input  logic        clk,
    input  logic        rst_n,
    input  logic [11:0] s_axi_awaddr,
    input  logic        s_axi_awvalid,
    output logic        s_axi_awready,
    input  logic [31:0] s_axi_wdata,
    input  logic [3:0]  s_axi_wstrb,
    input  logic        s_axi_wvalid,
    output logic        s_axi_wready,
    output logic [1:0]  s_axi_bresp,
    output logic        s_axi_bvalid,
    input  logic        s_axi_bready,
    input  logic [11:0] s_axi_araddr,
    input  logic        s_axi_arvalid,
    output logic        s_axi_arready,
    output logic [31:0] s_axi_rdata,
    output logic [1:0]  s_axi_rresp,
    output logic        s_axi_rvalid,
    input  logic        s_axi_rready,
    output logic [3:0]  izle                 // {cla mesgul, hata, cevap bekliyor, paket aliniyor}
);
    // reset senkronlayici
    /* verilator lint_off SYNCASYNCNET */
    logic [1:0] rs;
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) rs <= 2'b00;
        else        rs <= {rs[0], 1'b1};
    wire rstn = rs[1];
    logic cla_rst_n;                         // SIFIRLA komutu CLA tarafini resetler
    logic [1:0] crs;
    always_ff @(posedge clk or negedge rstn)
        if (!rstn) crs <= 2'b00;
        else       crs <= {crs[0], cla_rst_n};
    wire cla_rstn = crs[1];
    /* verilator lint_on SYNCASYNCNET */

    logic        cpu_wr_en;
    logic [2:0]  cpu_reg_addr;
    logic [15:0] cpu_wr_data, cpu_rd_data, mvect_oku;
    logic [15:0] mirun;
    logic [7:0]  pie_kesme;
    logic        cla_bosta;

    logic [6:0]  m2c_addr, c2m_addr;
    logic [1:0]  m2c_rd_en, c2m_wr_en, c2m_rd_en;
    logic [31:0] m2c_dout, c2m_din, c2m_dout;

    cla_axi_kopru #(.ZAMAN_ASIMI(ZAMAN_ASIMI), .BAYT_ASIMI(BAYT_ASIMI)) u_kopru (
        .clk, .rst_n(rstn),
        .s_axi_awaddr, .s_axi_awvalid, .s_axi_awready, .s_axi_wdata, .s_axi_wstrb, .s_axi_wvalid,
        .s_axi_wready, .s_axi_bresp, .s_axi_bvalid, .s_axi_bready, .s_axi_araddr, .s_axi_arvalid,
        .s_axi_arready, .s_axi_rdata, .s_axi_rresp, .s_axi_rvalid, .s_axi_rready,
        .m2c_addr, .m2c_rd_en, .m2c_dout,
        .c2m_addr, .c2m_wr_en, .c2m_rd_en, .c2m_din, .c2m_dout,
        .cpu_wr_en, .cpu_reg_addr, .cpu_wr_data, .mirun, .cla_bosta, .cla_rst_n,
        .durum(izle));

    // MVECT1 = 0 (reset degeri): gorev 1 programin basindan baslar
    CLA_Top #(.PROGRAM_HEX(PROGRAM_HEX)) u_cla (
        .clk, .rst_n(cla_rstn),
        .cpu_wr_en, .cpu_reg_addr, .cpu_wr_data, .cpu_rd_data,
        .mvect_wr_en(1'b0), .mvect_gorev(3'd0), .mvect_veri(16'h0000), .mvect_oku,
        .hw_task_trig(8'h00), .pie_kesme, .mirun, .bosta(cla_bosta),
        .m2c_addr, .m2c_rd_en, .m2c_dout,
        .c2m_addr, .c2m_wr_en, .c2m_rd_en, .c2m_din, .c2m_dout);
endmodule
