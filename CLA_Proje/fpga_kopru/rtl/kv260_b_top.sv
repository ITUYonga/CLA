`timescale 1ns / 1ps
// =====================================================================
//  kv260_b_top - B yolu ust modulu (CLA'siz ilk deneme)
// ---------------------------------------------------------------------
//      PC --micro-USB--> PS UART --> ARM (aktarici.elf) --AXI4-Lite--+
//                                                                    |
//      cla_axi_kopru (mesaj RAM'leri) --+--> cla_ctrl_regs (Arda)    |
//                                       +--> cla_cekirdek_taklidi    |
//  Blok tasarima kv260_b_sarmal.v ile (Verilog sarmal) eklenir:
//  clk = pl_clk0 (100 MHz), rst_n = pl_resetn0, s_axi = M_AXI_HPM0_LPD.
//  Gercek CLA hazir olunca cla_cekirdek_taklidi yerine o baglanir.
// =====================================================================
module kv260_b_top #(
    parameter int ZAMAN_ASIMI = 1_000_000,   // 10 ms @100 MHz
    parameter int BAYT_ASIMI  = 1_000_000,
    parameter int GECIKME     = 200          // taklit gorevin suresi
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
    logic [15:0] cpu_wr_data, cpu_rd_data;
    logic [15:0] mifr, miovf, mier, mirun;
    logic        task_start_req, task_done;
    logic [2:0]  selected_task;
    logic        hw_trig [7:0];
    always_comb for (int t = 0; t < 8; t++) hw_trig[t] = 1'b0;

    logic [6:0]  m2c_addr, c2m_addr;
    logic [1:0]  m2c_rd_en, c2m_wr_en;
    logic [31:0] m2c_dout, c2m_din, c2m_dout;

    cla_axi_kopru #(.ZAMAN_ASIMI(ZAMAN_ASIMI), .BAYT_ASIMI(BAYT_ASIMI)) u_kopru (
        .clk, .rst_n(rstn),
        .s_axi_awaddr, .s_axi_awvalid, .s_axi_awready, .s_axi_wdata, .s_axi_wstrb, .s_axi_wvalid,
        .s_axi_wready, .s_axi_bresp, .s_axi_bvalid, .s_axi_bready, .s_axi_araddr, .s_axi_arvalid,
        .s_axi_arready, .s_axi_rdata, .s_axi_rresp, .s_axi_rvalid, .s_axi_rready,
        .m2c_addr, .m2c_rd_en, .m2c_dout,
        .c2m_addr, .c2m_wr_en, .c2m_rd_en(2'b00), .c2m_din, .c2m_dout,
        .cpu_wr_en, .cpu_reg_addr, .cpu_wr_data, .mirun, .cla_rst_n,
        .durum(izle));

    cla_ctrl_regs u_ctrl (
        .clk, .rst_n(cla_rstn),
        .cpu_wr_en, .cpu_reg_addr, .cpu_wr_data, .cpu_rd_data,
        .hw_task_trig(hw_trig),
        .task_done, .task_start_req, .selected_task,
        .mifr_out(mifr), .miovf_out(miovf), .mier_out(mier), .mirun_out(mirun));

    cla_cekirdek_taklidi #(.GECIKME(GECIKME)) u_cekirdek (
        .clk, .rst_n(cla_rstn), .task_start_req, .task_done,
        .m2c_addr, .m2c_rd_en, .m2c_dout,
        .c2m_addr, .c2m_wr_en, .c2m_din);
endmodule
