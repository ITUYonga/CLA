`timescale 1ns / 1ps
// =====================================================================
//  cla_axi_kopru - B yolu: ARM'in AXI4-Lite kapisi + cla_kopru_cekirdek
// ---------------------------------------------------------------------
//  PC --micro-USB--> PS UART --> ARM (aktarici.elf: bayt kopyalar)
//                                  |  AXI4-Lite (M_AXI_HPM0_LPD)
//                                  v
//                    bu modul: VERI'ye yazilan bayt -> cekirdek
//                              cekirdegin cevabi -> FIFO -> CEVAP okunur
//  ARM yalniz bayt tasir; mesaj RAM'leri ve gorev tetikleme cekirdekte.
//
//  Yazmaclar (32 bit, bayt adresi):
//    0x00 VERI   (Y) [7:0] cekirdege bir bayt
//    0x04 CEVAP  (O) bos degilse {1, 23'b0, bayt} ve FIFO'dan cikarir; bossa 0
//    0x08 DURUM  (O) {FIFO doluluk[15:0], 12'b0, cekirdek durumu[3:0]}
//    0x0C KIMLIK (O) 0x434C4131 ("CLA1")
// =====================================================================
module cla_axi_kopru #(
    parameter int ZAMAN_ASIMI = 1_000_000,
    parameter int BAYT_ASIMI  = 1_000_000,
    parameter int FIFO_LOG2   = 9                  // 512 bayt (en uzun cevap 259)
)(
    input  logic        clk,
    input  logic        rst_n,
    // AXI4-Lite bagimli
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
    // CLA tarafi (cla_kopru_cekirdek ile ayni)
    input  logic [6:0]  m2c_addr,
    input  logic [1:0]  m2c_rd_en,
    output logic [31:0] m2c_dout,
    input  logic [6:0]  c2m_addr,
    input  logic [1:0]  c2m_wr_en,
    input  logic [1:0]  c2m_rd_en,
    input  logic [31:0] c2m_din,
    output logic [31:0] c2m_dout,
    output logic        cpu_wr_en,
    output logic [2:0]  cpu_reg_addr,
    output logic [15:0] cpu_wr_data,
    input  logic [15:0] mirun,
    output logic        cla_rst_n,
    output logic [3:0]  durum
);
    localparam int N = 1 << FIFO_LOG2;
    localparam logic [31:0] KIMLIK = 32'h434C_4131;

    // ------------------------------------------------------------ cekirdek
    logic       giris_gecerli, cikis_gonder;
    logic [7:0] giris_veri, cikis_veri;
    logic       dolu, bos;

    cla_kopru_cekirdek #(.ZAMAN_ASIMI(ZAMAN_ASIMI), .BAYT_ASIMI(BAYT_ASIMI)) u_cekirdek (
        .clk, .rst_n,
        .giris_gecerli, .giris_veri,
        .cikis_gonder, .cikis_veri, .cikis_mesgul(dolu),
        .m2c_addr, .m2c_rd_en, .m2c_dout,
        .c2m_addr, .c2m_wr_en, .c2m_rd_en, .c2m_din, .c2m_dout,
        .cpu_wr_en, .cpu_reg_addr, .cpu_wr_data, .mirun, .cla_rst_n, .durum);

    // ------------------------------------------------------------ cevap FIFO'su
    logic [7:0]         fifo [0:N-1];
    logic [FIFO_LOG2:0] yaz_p, oku_p;                // bir bit fazla: dolu/bos ayrimi
    logic               cek;                         // AXI okumasi bir bayt cikariyor
    wire  [FIFO_LOG2:0] doluluk = yaz_p - oku_p;
    assign bos  = (doluluk == '0);
    assign dolu = (doluluk == (FIFO_LOG2 + 1)'(N));

    always_ff @(posedge clk)
        if (cikis_gonder && !dolu) fifo[yaz_p[FIFO_LOG2-1:0]] <= cikis_veri;

    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            yaz_p <= '0; oku_p <= '0;
        end else begin
            if (cikis_gonder && !dolu) yaz_p <= yaz_p + 1'b1;
            if (cek) oku_p <= oku_p + 1'b1;
        end

    // ------------------------------------------------------------ AXI yazma
    wire yaz_al = s_axi_awvalid && s_axi_wvalid && !s_axi_bvalid;
    assign s_axi_awready = yaz_al;
    assign s_axi_wready  = yaz_al;
    assign s_axi_bresp   = 2'b00;

    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            s_axi_bvalid <= 1'b0; giris_gecerli <= 1'b0; giris_veri <= '0;
        end else begin
            giris_gecerli <= 1'b0;
            if (yaz_al) begin
                s_axi_bvalid <= 1'b1;
                if (s_axi_awaddr[11:2] == 10'd0 && s_axi_wstrb[0]) begin
                    giris_gecerli <= 1'b1;
                    giris_veri    <= s_axi_wdata[7:0];
                end
            end else if (s_axi_bvalid && s_axi_bready)
                s_axi_bvalid <= 1'b0;
        end

    // ------------------------------------------------------------ AXI okuma
    assign s_axi_arready = !s_axi_rvalid;
    assign s_axi_rresp   = 2'b00;
    wire oku_al = s_axi_arvalid && s_axi_arready;
    assign cek = oku_al && s_axi_araddr[11:2] == 10'd1 && !bos;

    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            s_axi_rvalid <= 1'b0; s_axi_rdata <= '0;
        end else if (oku_al) begin
            s_axi_rvalid <= 1'b1;
            case (s_axi_araddr[11:2])
                10'd1:   s_axi_rdata <= bos ? 32'd0 : {1'b1, 23'd0, fifo[oku_p[FIFO_LOG2-1:0]]};
                10'd2:   s_axi_rdata <= {16'(doluluk), 12'd0, durum};
                10'd3:   s_axi_rdata <= KIMLIK;
                default: s_axi_rdata <= 32'd0;
            endcase
        end else if (s_axi_rvalid && s_axi_rready)
            s_axi_rvalid <= 1'b0;
endmodule
