`timescale 1ns / 1ps

// cla_wrapper : CLA_AXI_Lite icin Verilog-2001 kabugu (Vivado block design "Add Module" icin).
// BD SystemVerilog ust modul kabul etmedigi icin vardir ; mantik CLA_AXI_Lite.sv'de.
//
// BD baglantisi :
//   s_axi_aclk    : pl_clk0 (radar ile ayni saat) ; FREQ_HZ yazilmadi , BD'den yayilir
//   s_axi_aresetn : proc_sys_reset peripheral_aresetn
//   S_AXI         : HPM0 -> SmartConnect -> S_AXI , Address Editor'de 4 KB (oneri 0xA001_0000)
//   irq           : xlconcat -> pl_ps_irq0[1] (radar irq [0]'da) , seviye , yuksek etkin
//
// hw_task_trig ve ham pie_kesme disari cikarilmadi : gorevler yazilimla (MIFRC) tetiklenir.
// Gerekirse CLA_AXI_Lite'taki portlar buraya aynen eklenir.

module cla_wrapper #(
    parameter PROGRAM_HEX = "C:/Users/beyen/Downloads/cla_kv260/cla_kv260/cladrone_l3.hex"                  // L3 programi (satir basina 16 bit , alt adres once)
)(
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axi_aclk CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn" *)
    input  wire        s_axi_aclk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axi_aresetn RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
    input  wire        s_axi_aresetn,

    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWADDR" *)
    (* X_INTERFACE_PARAMETER = "PROTOCOL AXI4LITE, DATA_WIDTH 32, ADDR_WIDTH 12" *)
    input  wire [11:0] s_axi_awaddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWPROT" *)
    input  wire [2:0]  s_axi_awprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWVALID" *)
    input  wire        s_axi_awvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *)
    output wire        s_axi_awready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WDATA" *)
    input  wire [31:0] s_axi_wdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WSTRB" *)
    input  wire [3:0]  s_axi_wstrb,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WVALID" *)
    input  wire        s_axi_wvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WREADY" *)
    output wire        s_axi_wready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BRESP" *)
    output wire [1:0]  s_axi_bresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BVALID" *)
    output wire        s_axi_bvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BREADY" *)
    input  wire        s_axi_bready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARADDR" *)
    input  wire [11:0] s_axi_araddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARPROT" *)
    input  wire [2:0]  s_axi_arprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARVALID" *)
    input  wire        s_axi_arvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARREADY" *)
    output wire        s_axi_arready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RDATA" *)
    output wire [31:0] s_axi_rdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RRESP" *)
    output wire [1:0]  s_axi_rresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RVALID" *)
    output wire        s_axi_rvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RREADY" *)
    input  wire        s_axi_rready,

    (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 irq INTERRUPT" *)
    (* X_INTERFACE_PARAMETER = "SENSITIVITY LEVEL_HIGH" *)
    output wire        irq
);

    CLA_AXI_Lite #(.PROGRAM_HEX(PROGRAM_HEX), .TRIG_SENKRON(1'b0)) u_cla (
        .S_AXI_ACLK(s_axi_aclk),       .S_AXI_ARESETN(s_axi_aresetn),
        .S_AXI_AWADDR(s_axi_awaddr),   .S_AXI_AWPROT(s_axi_awprot),   .S_AXI_AWVALID(s_axi_awvalid), .S_AXI_AWREADY(s_axi_awready),
        .S_AXI_WDATA(s_axi_wdata),     .S_AXI_WSTRB(s_axi_wstrb),     .S_AXI_WVALID(s_axi_wvalid),   .S_AXI_WREADY(s_axi_wready),
        .S_AXI_BRESP(s_axi_bresp),     .S_AXI_BVALID(s_axi_bvalid),   .S_AXI_BREADY(s_axi_bready),
        .S_AXI_ARADDR(s_axi_araddr),   .S_AXI_ARPROT(s_axi_arprot),   .S_AXI_ARVALID(s_axi_arvalid), .S_AXI_ARREADY(s_axi_arready),
        .S_AXI_RDATA(s_axi_rdata),     .S_AXI_RRESP(s_axi_rresp),     .S_AXI_RVALID(s_axi_rvalid),   .S_AXI_RREADY(s_axi_rready),
        .hw_task_trig(8'h00),
        .irq(irq),
        .pie_kesme()
    );

endmodule
