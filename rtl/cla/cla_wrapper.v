`timescale 1ns / 1ps

// MOD_CLA_WRAPPER : Vivado Block Design entegrasyonu için CLA_AXI_Lite modülünü sarmalayan Verilog-2001 üst kabuğu
//
//   Amaç:     Vivado IP Integrator (Block Design) doğrudan SystemVerilog üst
//             modüllerini kabul etmediği için CLA_AXI_Lite modülünü standart
//             Verilog-2001 portlarıyla ve Xilinx AXI4-Lite / saat / reset /
//             kesme arayüz öznitelikleriyle (X_INTERFACE_INFO) sarmalar.
//             Zynq UltraScale+ HPM0 portundan gelen 4 KB adres alanını CLA
//             çekirdeğine bağlar.
//
//   Parametreler:
//           PROGRAM_HEX:    L3 program belleğine ($readmemh) yüklenecek 16-bit
//                           satırlı başlangıç hex dosyası (varsayılan:
//                           "drone_l3.hex")
//
//   Inputlar:
//           s_axi_aclk:     AXI4-Lite ve CLA çekirdeği ortak çalışma saati
//                           (pl_clk0)
//           s_axi_aresetn:  Aktif-düşük senkron/asenkron sistem sıfırlama
//                           sinyali
//           s_axi_awaddr:   12-bit AXI4-Lite yazma adresi (4 KB adres alanı)
//           s_axi_awprot:   AXI4-Lite yazma koruma tipi sinyali
//           s_axi_awvalid:  Yazma adresinin geçerli olduğunu belirten el
//                           sıkışma sinyali
//           s_axi_wdata:    32-bit AXI4-Lite yazma verisi
//           s_axi_wstrb:    4-bit bayt yazma maskesi (alt yarı [1:0], üst yarı
//                           [3:2])
//           s_axi_wvalid:   Yazma verisinin geçerli olduğunu belirten sinyal
//           s_axi_bready:   AXI master'ın yazma yanıtını kabul etmeye hazır
//                           olduğunu belirten sinyal
//           s_axi_araddr:   12-bit AXI4-Lite okuma adresi
//           s_axi_arprot:   AXI4-Lite okuma koruma tipi sinyali
//           s_axi_arvalid:  Okuma adresinin geçerli olduğunu belirten el
//                           sıkışma sinyali
//           s_axi_rready:   AXI master'ın okunan veriyi kabul etmeye hazır
//                           olduğunu belirten sinyal
//   Outputlar:
//           s_axi_awready:  Slave'in yazma adresini kabul ettiğini belirten
//                           sinyal
//           s_axi_wready:   Slave'in yazma verisini kabul ettiğini belirten
//                           sinyal
//           s_axi_bresp:    2-bit yazma yanıt durumu (her zaman 2'b00 OKAY)
//           s_axi_bvalid:   Yazma yanıtının geçerli olduğunu belirten sinyal
//           s_axi_arready:  Slave'in okuma adresini kabul ettiğini belirten
//                           sinyal
//           s_axi_rdata:    32-bit AXI4-Lite okunan veri çıkışı
//           s_axi_rresp:    2-bit okuma yanıt durumu (her zaman 2'b00 OKAY)
//           s_axi_rvalid:   Okunan verinin geçerli olduğunu belirten sinyal
//           irq:            Zynq PS kesme denetçisine (pl_ps_irq0) giden
//                           seviye-etkin (aktif-yüksek) kesme çıkışı
//
//   Notlar:
//           Donanımsal görev tetikleri (hw_task_trig) bu kabukta 8'h00'a
//           bağlanmıştır; görevler PS tarafından AXI üzerinden MIFRC
//           yazmacına yazılarak yazılımla tetiklenir.
//
//           Vivado Address Editor'de 4 KB büyüklüğünde (önerilen taban
//           adres: 0xA001_0000) bir alana eşlenmesi beklenir.

module cla_wrapper #(
    parameter PROGRAM_HEX = "drone_l3.hex"                  // L3 programi (satir basina 16 bit , alt adres once)
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
