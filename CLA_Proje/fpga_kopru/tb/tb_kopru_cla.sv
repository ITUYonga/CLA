`timescale 1ns / 1ps
// =====================================================================
//  tb_kopru_cla - kv260_b_top (kopru + CLA_Top) tezgahi
// ---------------------------------------------------------------------
//  Karttaki ARM aktaricisi gibi davranir: istek paketinin baytlarini AXI4-Lite'tan VERI'ye
//  (0x00) yazar, cevap paketinin baytlarini CEVAP'tan (0x04) okur.
//    +ISTEK=<dosya>   her satir: <bayt sayisi> <bayt> <bayt> ... (onaltilik)
//    +CEVAP=<dosya>   her istegin cevabi ayni bicimde
//    PROG parametresi: L3 programi (kv260_b_top PROGRAM_HEX), Verilator: -GPROG='"yol"'
//  kopru_testi.py bu tezgahi derler, isteklerini uretir ve cevaplari golden'la karsilastirir.
// =====================================================================
module tb_kopru_cla #(parameter string PROG = "");

    logic clk = 0, rst_n = 0;
    always #5 clk = ~clk;

    logic [11:0] awaddr = 0, araddr = 0;
    logic        awvalid = 0, wvalid = 0, bready = 0, arvalid = 0, rready = 0;
    logic [31:0] wdata = 0;
    logic [3:0]  wstrb = 0;
    logic        awready, wready, bvalid, arready, rvalid;
    logic [1:0]  bresp, rresp;
    logic [31:0] rdata;
    logic [3:0]  izle;

    kv260_b_top #(.PROGRAM_HEX(PROG), .ZAMAN_ASIMI(200_000)) DUT(
        .clk, .rst_n,
        .s_axi_awaddr(awaddr), .s_axi_awvalid(awvalid), .s_axi_awready(awready),
        .s_axi_wdata(wdata), .s_axi_wstrb(wstrb), .s_axi_wvalid(wvalid), .s_axi_wready(wready),
        .s_axi_bresp(bresp), .s_axi_bvalid(bvalid), .s_axi_bready(bready),
        .s_axi_araddr(araddr), .s_axi_arvalid(arvalid), .s_axi_arready(arready),
        .s_axi_rdata(rdata), .s_axi_rresp(rresp), .s_axi_rvalid(rvalid), .s_axi_rready(rready),
        .izle);

    // ---- AXI4-Lite yonetici (sinyaller negedge'de degisir, aktarim posedge'de)
    task automatic axi_yaz(input logic [11:0] a, input logic [31:0] v);
        @(negedge clk);
        awaddr = a; wdata = v; wstrb = 4'hF; awvalid = 1; wvalid = 1; bready = 1;
        #1;                                             // kombinasyonel ready otursun
        while (!(awready && wready)) begin @(negedge clk); #1; end
        @(negedge clk);
        awvalid = 0; wvalid = 0;
        while (!bvalid) @(negedge clk);
        @(negedge clk);                                 // B el sikismasi posedge'de
    endtask

    task automatic axi_oku(input logic [11:0] a, output logic [31:0] v);
        @(negedge clk);
        araddr = a; arvalid = 1; rready = 1;
        #1;
        while (!arready) begin @(negedge clk); #1; end
        @(negedge clk);
        arvalid = 0;
        while (!rvalid) @(negedge clk);
        v = rdata;
        @(negedge clk);
    endtask

    string istek, cevap;
    integer fi, fo, r, n, i, beklenen, alinan, bekleme;
    logic [7:0] bayt;
    logic [31:0] okunan;
    logic [7:0] gelen [0:300];

    initial begin
        if (!$value$plusargs("ISTEK=%s", istek)) $fatal(1, "+ISTEK gerekli");
        if (!$value$plusargs("CEVAP=%s", cevap)) cevap = "cevap.txt";
        repeat (4) @(negedge clk);
        rst_n = 1;
        repeat (8) @(negedge clk);
        fi = $fopen(istek, "r");
        fo = $fopen(cevap, "w");
        if (fi == 0 || fo == 0) $fatal(1, "dosya acilamadi");
        while ($fscanf(fi, "%d", n) == 1) begin
            for (i = 0; i < n; i++) begin
                r = $fscanf(fi, "%h", bayt);
                axi_yaz(12'h000, {24'h0, bayt});
            end
            // cevap: 5A tip uzunluk veri[uzunluk] saglama
            alinan = 0; beklenen = 4; bekleme = 0;
            while (alinan < beklenen) begin
                axi_oku(12'h004, okunan);
                if (okunan[31]) begin
                    gelen[alinan] = okunan[7:0];
                    alinan++;
                    if (alinan == 3) beklenen = 4 + okunan[7:0];
                end
                else if (++bekleme > 100_000) $fatal(1, "cevap gelmedi");
            end
            $fwrite(fo, "%0d", alinan);
            for (i = 0; i < alinan; i++) $fwrite(fo, " %h", gelen[i]);
            $fwrite(fo, "\n");
        end
        $fclose(fi);
        $fclose(fo);
        $finish;
    end
endmodule
