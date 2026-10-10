`timescale 1ns / 1ps

// CLA_AXI_Lite testbench : AXI4-Lite master BFM + kendini denetleyen testler.
//
// Programdan bagimsiz testler (her zaman kosar) :
//   1  reset degerleri
//   2  MVECT1-8 yaz/oku , ust 16 bit 0
//   3  gorev yazmaclari : MIER RW , MIFRC / MICLR (MIER = 0 iken , gorev baslamaz)
//   4  WSTRB : eksik bayt etkinlestirmesinde yazma yok sayilir
//   5  hw_task_trig yukselen kenar : seviye tutulsa da tek tetik , ikinci kenar MIOVF kurar
//   6  MCTL HARDRESET
//   7  M2C : paketli yerlesim (RAM icine hiyerarsik bakarak) , yarim yazmalar , geri okuma
//   8  C2M : AXI'den yazma yok sayilir
//   9  gecersiz adresler 0 okunur , yazma hicbir seyi bozmaz
//  10  kesme mantigi : pie_kesme force ile darbelenir , IRQ_DURUM / IRQ_MASKE / W1C / irq
//  11  es zamanli okuma + yazma , rastgele AW/W gecikmesi ve BREADY/RREADY geri basinci
//  13  KONTROL.CLA_SIFIRLA : CLA_Top yazmaclari sifirlanir , AXI tarafi (IRQ_MASKE , M2C) korunur ; KIMLIK
//
// Program gerektiren test (GOREV_TESTI = 1) :
//  12  gorev 1 , MVECT1 = GOREV_PC adresinden MIFRC ile baslatilir ; MSTOP ile bitmesi ,
//      irq'nin gelmesi , MIRUN'un 0'a donmesi ve W1C ile irq'nin dusmesi denetlenir.
//      PROGRAM_HEX'te GOREV_PC'den baslayip MSTOP ile biten bir gorev olmali.

module tb_CLA_AXI_Lite
#(
                parameter string PROGRAM_HEX = "" ,
                parameter bit TRIG_SENKRON = 1'b0 ,
                parameter bit GOREV_TESTI = 1'b0 ,
                parameter logic [15:0]GOREV_PC = 16'h0000 ,
                parameter int ZAMAN_ASIMI = 10000         // gorev testi icin cevrim
)();



/////////////////////////ADRESLER

localparam logic [11:0]A_MIFR = 12'h000;
localparam logic [11:0]A_MIOVF = 12'h004;
localparam logic [11:0]A_MICLR = 12'h008;
localparam logic [11:0]A_MICLROVF = 12'h00C;
localparam logic [11:0]A_MIFRC = 12'h010;
localparam logic [11:0]A_MIER = 12'h014;
localparam logic [11:0]A_MIRUN = 12'h018;
localparam logic [11:0]A_MCTL = 12'h01C;
localparam logic [11:0]A_MVECT1 = 12'h020;
localparam logic [11:0]A_IRQ_DURUM = 12'h040;
localparam logic [11:0]A_IRQ_MASKE = 12'h044;
localparam logic [11:0]A_KONTROL = 12'h048;
localparam logic [11:0]A_KIMLIK = 12'h04C;
localparam logic [11:0]A_M2C = 12'h100;
localparam logic [11:0]A_C2M = 12'h200;



/////////////////////////SINYALLER

logic clk = 1'b0;
logic rst_n = 1'b0;

logic [11:0]awaddr = '0;
logic awvalid = 1'b0;
logic awready;
logic [31:0]wdata = '0;
logic [3:0]wstrb = '0;
logic wvalid = 1'b0;
logic wready;
logic [1:0]bresp;
logic bvalid;
logic bready = 1'b0;
logic [11:0]araddr = '0;
logic arvalid = 1'b0;
logic arready;
logic [31:0]rdata;
logic [1:0]rresp;
logic rvalid;
logic rready = 1'b0;

logic [7:0]hw_task_trig = '0;
logic irq;
logic [7:0]pie_kesme;

int hata = 0;
int denetim = 0;
bit geri_basinc = 1'b0;                                 // 1 : rastgele gecikme ve geri basinc
logic [7:0]pie_zorla = 8'h00;                           // force kaynagi (statik : force automatic degisken alamaz)

always #5 clk = ~clk;                                   // 100 MHz



/////////////////////////DUT

CLA_AXI_Lite #(.PROGRAM_HEX(PROGRAM_HEX) , .TRIG_SENKRON(TRIG_SENKRON)) dut(
        .S_AXI_ACLK(clk) , .S_AXI_ARESETN(rst_n) ,
        .S_AXI_AWADDR(awaddr) , .S_AXI_AWPROT(3'b000) , .S_AXI_AWVALID(awvalid) , .S_AXI_AWREADY(awready) ,
        .S_AXI_WDATA(wdata) , .S_AXI_WSTRB(wstrb) , .S_AXI_WVALID(wvalid) , .S_AXI_WREADY(wready) ,
        .S_AXI_BRESP(bresp) , .S_AXI_BVALID(bvalid) , .S_AXI_BREADY(bready) ,
        .S_AXI_ARADDR(araddr) , .S_AXI_ARPROT(3'b000) , .S_AXI_ARVALID(arvalid) , .S_AXI_ARREADY(arready) ,
        .S_AXI_RDATA(rdata) , .S_AXI_RRESP(rresp) , .S_AXI_RVALID(rvalid) , .S_AXI_RREADY(rready) ,
        .hw_task_trig(hw_task_trig) , .irq(irq) , .pie_kesme(pie_kesme));



/////////////////////////DENETIM

task automatic denetle(input string ad , input logic [31:0]gercek , input logic [31:0]beklenen);

    denetim++;
    if(gercek !== beklenen) begin
        hata++;
        $display("[%0t] HATA  %s : okunan 0x%08h , beklenen 0x%08h", $time , ad , gercek , beklenen);
    end

endtask

task automatic bekle(input int n);

    repeat(n) @(negedge clk);

endtask

function automatic int gecikme();

    return geri_basinc ? $urandom_range(0 , 3) : 0;

endfunction



/////////////////////////AXI MASTER BFM

// sinyaller negedge'de surulur , el sikisma bir sonraki posedge'de olur

task automatic aw_kanal(input logic [11:0]adr);

    bekle(gecikme());
    awaddr = adr;
    awvalid = 1'b1;
    #1;
    while(!awready) begin @(negedge clk); #1; end
    @(posedge clk);
    @(negedge clk);
    awvalid = 1'b0;

endtask

task automatic w_kanal(input logic [31:0]veri , input logic [3:0]strb);

    bekle(gecikme());
    wdata = veri;
    wstrb = strb;
    wvalid = 1'b1;
    #1;
    while(!wready) begin @(negedge clk); #1; end
    @(posedge clk);
    @(negedge clk);
    wvalid = 1'b0;

endtask

task automatic axi_yaz(input logic [11:0]adr , input logic [31:0]veri , input logic [3:0]strb = 4'hF);

    @(negedge clk);
    fork
        aw_kanal(adr);
        w_kanal(veri , strb);
    join

    bekle(gecikme());
    bready = 1'b1;
    #1;
    while(!bvalid) begin @(negedge clk); #1; end
    @(posedge clk);
    @(negedge clk);
    bready = 1'b0;

    denetim++;
    if(bresp !== 2'b00) begin
        hata++;
        $display("[%0t] HATA  BRESP 0x%03h : %b", $time , adr , bresp);
    end

endtask

task automatic axi_oku(input logic [11:0]adr , output logic [31:0]veri);

    @(negedge clk);
    bekle(gecikme());
    araddr = adr;
    arvalid = 1'b1;
    #1;
    while(!arready) begin @(negedge clk); #1; end
    @(posedge clk);
    @(negedge clk);
    arvalid = 1'b0;

    bekle(gecikme());
    rready = 1'b1;
    #1;
    while(!rvalid) begin @(negedge clk); #1; end
    veri = rdata;
    @(posedge clk);
    @(negedge clk);
    rready = 1'b0;

    denetim++;
    if(rresp !== 2'b00) begin
        hata++;
        $display("[%0t] HATA  RRESP 0x%03h : %b", $time , adr , rresp);
    end

endtask

task automatic oku_denetle(input logic [11:0]adr , input logic [31:0]beklenen , input string ad);

    logic [31:0]v;
    axi_oku(adr , v);
    denetle(ad , v , beklenen);

endtask



/////////////////////////TESTLER

task automatic t1_reset();

    $display("1  reset degerleri");
    oku_denetle(A_MIFR , 32'h0 , "MIFR");
    oku_denetle(A_MIOVF , 32'h0 , "MIOVF");
    oku_denetle(A_MIER , 32'h0 , "MIER");
    oku_denetle(A_MIRUN , 32'h0 , "MIRUN");
    oku_denetle(A_MCTL , 32'h0 , "MCTL");
    oku_denetle(A_IRQ_DURUM , 32'h0 , "IRQ_DURUM");
    oku_denetle(A_IRQ_MASKE , 32'h0 , "IRQ_MASKE");
    oku_denetle(A_KONTROL , 32'h0 , "KONTROL");
    oku_denetle(A_KIMLIK , 32'h434C_4101 , "KIMLIK");
    for(int i = 0 ; i < 8 ; i++) oku_denetle(A_MVECT1 + 12'(i*4) , 32'h0 , $sformatf("MVECT%0d", i+1));
    denetle("irq" , {31'b0 , irq} , 32'h0);

endtask

task automatic t2_mvect();

    $display("2  MVECT1-8");
    for(int i = 0 ; i < 8 ; i++) axi_yaz(A_MVECT1 + 12'(i*4) , {16'hFFFF , 16'h0100 + 16'(i*16'h0111)});
    for(int i = 0 ; i < 8 ; i++)
        oku_denetle(A_MVECT1 + 12'(i*4) , {16'h0000 , 16'h0100 + 16'(i*16'h0111)} , $sformatf("MVECT%0d", i+1));

endtask

task automatic t3_gorev_yazmaclari();

    $display("3  MIER , MIFRC , MICLR");
    axi_yaz(A_MIER , 32'hFFFF_FFA5);
    oku_denetle(A_MIER , 32'h0000_00A5 , "MIER RW");
    axi_yaz(A_MIER , 32'h0);
    oku_denetle(A_MIER , 32'h0 , "MIER = 0");

    axi_yaz(A_MIFRC , 32'h0000_0081);                   // MIER = 0 : gorev baslamaz
    oku_denetle(A_MIFR , 32'h0000_0081 , "MIFRC");
    oku_denetle(A_MIRUN , 32'h0 , "MIRUN (MIER = 0)");
    axi_yaz(A_MICLR , 32'h0000_0001);
    oku_denetle(A_MIFR , 32'h0000_0080 , "MICLR bit0");
    axi_yaz(A_MICLR , 32'h0000_0080);
    oku_denetle(A_MIFR , 32'h0 , "MICLR bit7");
    oku_denetle(A_MIFRC , 32'h0 , "MIFRC 0 okunur");
    oku_denetle(A_MICLR , 32'h0 , "MICLR 0 okunur");

endtask

task automatic t4_wstrb();

    $display("4  WSTRB");
    axi_yaz(A_MIER , 32'h0000_00FF , 4'b0001);
    oku_denetle(A_MIER , 32'h0 , "MIER strb 0001");
    axi_yaz(A_MIER , 32'h0000_00FF , 4'b1100);
    oku_denetle(A_MIER , 32'h0 , "MIER strb 1100");
    axi_yaz(A_MVECT1 , 32'h0000_1234 , 4'b0010);
    oku_denetle(A_MVECT1 , 32'h0000_0100 , "MVECT1 strb 0010");
    axi_yaz(A_MVECT1 , 32'h0000_1234 , 4'b0011);
    oku_denetle(A_MVECT1 , 32'h0000_1234 , "MVECT1 strb 0011");
    axi_yaz(A_MVECT1 , 32'h0000_0100);

endtask

task automatic t5_hw_trig();

    $display("5  hw_task_trig yukselen kenar");
    @(negedge clk) hw_task_trig = 8'h04;                // 10 cevrim seviye
    bekle(10);
    hw_task_trig = 8'h00;
    bekle(4);                                            // olasi senkronlayici gecikmesi
    oku_denetle(A_MIFR , 32'h0000_0004 , "MIFR seviye tetik");
    oku_denetle(A_MIOVF , 32'h0 , "MIOVF seviye tetik");

    @(negedge clk) hw_task_trig = 8'h04;                // ikinci kenar , bayrak kurulu
    @(negedge clk) hw_task_trig = 8'h00;
    bekle(4);
    oku_denetle(A_MIOVF , 32'h0000_0004 , "MIOVF ikinci kenar");

    axi_yaz(A_MICLROVF , 32'h0000_0004);
    axi_yaz(A_MICLR , 32'h0000_0004);
    oku_denetle(A_MIFR , 32'h0 , "MIFR temiz");
    oku_denetle(A_MIOVF , 32'h0 , "MIOVF temiz");

endtask

task automatic t6_hardreset();

    $display("6  MCTL HARDRESET");
    axi_yaz(A_MIFRC , 32'h0000_0030);
    axi_yaz(A_MIER , 32'h0000_000F);                    // MIFR & MIER = 0 : gorev baslamaz
    @(negedge clk) hw_task_trig = 8'h10;
    @(negedge clk) hw_task_trig = 8'h00;                // MIOVF[4]
    bekle(4);
    axi_yaz(A_MCTL , 32'h0000_0004);
    oku_denetle(A_MCTL , 32'h0000_0004 , "MCTL IACKE");
    axi_yaz(A_MCTL , 32'h0000_0001);
    oku_denetle(A_MIFR , 32'h0 , "MIFR hardreset");
    oku_denetle(A_MIOVF , 32'h0 , "MIOVF hardreset");
    oku_denetle(A_MIER , 32'h0 , "MIER hardreset");
    oku_denetle(A_MCTL , 32'h0 , "MCTL hardreset");

endtask

task automatic t7_m2c();

    logic [31:0]v;

    $display("7  M2C");
    for(int i = 0 ; i < 64 ; i++) axi_yaz(A_M2C + 12'(i*4) , {16'(16'hA000 + i) , 16'(16'h5000 + i)});

    for(int i = 0 ; i < 64 ; i++) begin
        oku_denetle(A_M2C + 12'(i*4) , {16'(16'hA000 + i) , 16'(16'h5000 + i)} , $sformatf("M2C[%0d]", i));
        denetle($sformatf("M2C ram[%0d] (alt yari)", 2*i) , {16'h0 , dut.M2C.ram[2*i]} , {16'h0 , 16'(16'h5000 + i)});
        denetle($sformatf("M2C ram[%0d] (ust yari)", 2*i+1) , {16'h0 , dut.M2C.ram[2*i+1]} , {16'h0 , 16'(16'hA000 + i)});
    end

    axi_yaz(A_M2C + 12'h010 , 32'h1111_2222 , 4'b0011);  // yalniz alt yari
    oku_denetle(A_M2C + 12'h010 , 32'hA004_2222 , "M2C strb 0011");
    axi_yaz(A_M2C + 12'h010 , 32'h3333_4444 , 4'b1100);  // yalniz ust yari
    oku_denetle(A_M2C + 12'h010 , 32'h3333_2222 , "M2C strb 1100");
    axi_yaz(A_M2C + 12'h010 , 32'h5555_6666 , 4'b0111);  // ust yari eksik
    oku_denetle(A_M2C + 12'h010 , 32'h3333_6666 , "M2C strb 0111");
    axi_yaz(A_M2C + 12'h010 , 32'h7777_8888 , 4'b0000);
    oku_denetle(A_M2C + 12'h010 , 32'h3333_6666 , "M2C strb 0000");

    axi_oku(A_M2C + 12'h0FC , v);                       // son word
    denetle("M2C son word" , v , 32'hA03F_503F);

endtask

task automatic t8_c2m();

    logic [31:0]once;
    logic [31:0]sonra;

    $display("8  C2M salt okunur");
    for(int i = 0 ; i < 64 ; i += 21) begin
        axi_oku(A_C2M + 12'(i*4) , once);
        axi_yaz(A_C2M + 12'(i*4) , ~once);
        axi_oku(A_C2M + 12'(i*4) , sonra);
        denetle($sformatf("C2M[%0d] degismedi", i) , sonra , once);
        denetle($sformatf("C2M[%0d] ram ile ayni", i) , once , {dut.C2M.ram[2*i+1] , dut.C2M.ram[2*i]});
    end

endtask

task automatic t9_gecersiz();

    logic [11:0]adr[6] = '{12'h050 , 12'h080 , 12'h0FC , 12'h300 , 12'h800 , 12'hFFC};

    $display("9  gecersiz adresler");
    foreach(adr[i]) begin
        axi_yaz(adr[i] , 32'hFFFF_FFFF);
        oku_denetle(adr[i] , 32'h0 , $sformatf("0x%03h", adr[i]));
    end
    oku_denetle(A_MIER , 32'h0 , "MIER bozulmadi");
    oku_denetle(A_IRQ_MASKE , 32'h0 , "IRQ_MASKE bozulmadi");
    oku_denetle(A_M2C , 32'hA000_5000 , "M2C[0] bozulmadi");

endtask

task automatic pie_darbe(input logic [7:0]bitler);

    @(negedge clk);
    pie_zorla = bitler;
    force dut.pie_kesme = pie_zorla;                    // surekli : pie_zorla degisince pie_kesme de degisir
    @(negedge clk) pie_zorla = 8'h00;
    @(negedge clk) release dut.pie_kesme;

endtask

task automatic t10_kesme();

    $display("10 kesme mantigi (pie_kesme force)");
    axi_yaz(A_IRQ_MASKE , 32'hFFFF_FF5A);
    oku_denetle(A_IRQ_MASKE , 32'h0000_005A , "IRQ_MASKE RW");
    axi_yaz(A_IRQ_MASKE , 32'h0);

    pie_darbe(8'h05);                                    // gorev 1 ve 3
    oku_denetle(A_IRQ_DURUM , 32'h0000_0005 , "IRQ_DURUM yakaladi");
    denetle("irq (maske 0)" , {31'b0 , irq} , 32'h0);

    axi_yaz(A_IRQ_MASKE , 32'h0000_0004);
    bekle(1);
    denetle("irq (maske bit2)" , {31'b0 , irq} , 32'h1);

    axi_yaz(A_IRQ_DURUM , 32'h0000_0001);               // maskeli olmayan bit
    oku_denetle(A_IRQ_DURUM , 32'h0000_0004 , "W1C bit0");
    denetle("irq hala 1" , {31'b0 , irq} , 32'h1);

    axi_yaz(A_IRQ_DURUM , 32'h0000_0004);
    bekle(1);
    denetle("irq dustu" , {31'b0 , irq} , 32'h0);
    oku_denetle(A_IRQ_DURUM , 32'h0 , "IRQ_DURUM temiz");

    // seviye pie_kesme : yalniz yukselen kenar sayilir , W1C sonrasi yeniden kurulmaz
    @(negedge clk);
    pie_zorla = 8'h80;
    force dut.pie_kesme = pie_zorla;
    bekle(3);
    axi_yaz(A_IRQ_DURUM , 32'h0000_0080);
    oku_denetle(A_IRQ_DURUM , 32'h0 , "seviye pie , W1C sonrasi");
    @(negedge clk) release dut.pie_kesme;

    axi_yaz(A_IRQ_MASKE , 32'h0);

endtask

task automatic t11_es_zamanli();

    logic [31:0]v;

    $display("11 es zamanli okuma/yazma , geri basinc");
    geri_basinc = 1'b1;

    for(int i = 0 ; i < 32 ; i++) begin
        fork
            axi_yaz(A_M2C + 12'((32 + i) * 4) , 32'hC0DE_0000 | i);
            begin
                axi_oku(A_M2C + 12'(i*4) , v);
                denetle($sformatf("es zamanli M2C[%0d]", i) , v , (i == 4) ? 32'h3333_6666 : {16'(16'hA000 + i) , 16'(16'h5000 + i)});
            end
        join
    end
    for(int i = 0 ; i < 32 ; i++) oku_denetle(A_M2C + 12'((32 + i) * 4) , 32'hC0DE_0000 | i , $sformatf("geri basinc M2C[%0d]", 32 + i));
    for(int i = 0 ; i < 8 ; i++) begin
        axi_yaz(A_MVECT1 + 12'(i*4) , 32'h0000_0F00 + i);
        oku_denetle(A_MVECT1 + 12'(i*4) , 32'h0000_0F00 + i , $sformatf("geri basinc MVECT%0d", i+1));
    end

    geri_basinc = 1'b0;

endtask

task automatic t13_cla_sifirla();

    $display("13 KONTROL.CLA_SIFIRLA , KIMLIK");
    axi_yaz(A_KIMLIK , 32'h0);                          // salt okunur
    oku_denetle(A_KIMLIK , 32'h434C_4101 , "KIMLIK salt okunur");

    axi_yaz(A_MIER , 32'h0000_0003);
    axi_yaz(A_MVECT1 + 12'h008 , 32'h0000_0ABC);       // MVECT3
    axi_yaz(A_IRQ_MASKE , 32'h0000_0081);
    axi_yaz(A_M2C + 12'h0F8 , 32'h1357_9BDF);

    axi_yaz(A_KONTROL , 32'hFFFF_FFFF);                 // CLA resette
    oku_denetle(A_KONTROL , 32'h0000_0001 , "KONTROL = 1");
    oku_denetle(A_MIER , 32'h0 , "MIER resette");
    oku_denetle(A_MVECT1 + 12'h008 , 32'h0 , "MVECT3 resette");
    axi_yaz(A_MIER , 32'h0000_00FF);                    // resetteyken yazma etkisiz
    oku_denetle(A_MIER , 32'h0 , "MIER resetteyken yazilamaz");

    axi_yaz(A_KONTROL , 32'h0);
    oku_denetle(A_KONTROL , 32'h0 , "KONTROL = 0");
    oku_denetle(A_MIER , 32'h0 , "MIER resetten sonra");
    oku_denetle(A_IRQ_MASKE , 32'h0000_0081 , "IRQ_MASKE korundu");
    oku_denetle(A_M2C + 12'h0F8 , 32'h1357_9BDF , "M2C korundu");
    axi_yaz(A_MIER , 32'h0000_0005);
    oku_denetle(A_MIER , 32'h0000_0005 , "MIER resetten sonra yazilir");

    axi_yaz(A_MIER , 32'h0);
    axi_yaz(A_IRQ_MASKE , 32'h0);

endtask

task automatic t12_gorev();

    logic [31:0]v;
    int n;

    $display("12 gorev 1 (MVECT1 = 0x%04h)", GOREV_PC);
    axi_yaz(A_MCTL , 32'h0000_0001);                    // temiz baslangic
    axi_yaz(A_IRQ_DURUM , 32'h0000_00FF);
    axi_yaz(A_MVECT1 , {16'h0 , GOREV_PC});
    axi_yaz(A_IRQ_MASKE , 32'h0000_0001);
    axi_yaz(A_MIER , 32'h0000_0001);
    axi_yaz(A_MIFRC , 32'h0000_0001);

    n = 0;
    while(!irq && n < ZAMAN_ASIMI) begin @(negedge clk); n++; end
    if(!irq) begin
        hata++;
        $display("[%0t] HATA  gorev 1 %0d cevrimde bitmedi (MSTOP ?)", $time , ZAMAN_ASIMI);
        return;
    end
    $display("   gorev 1 yaklasik %0d cevrimde bitti", n);

    oku_denetle(A_IRQ_DURUM , 32'h0000_0001 , "IRQ_DURUM gorev 1");
    oku_denetle(A_MIRUN , 32'h0 , "MIRUN gorev sonrasi");
    oku_denetle(A_MIFR , 32'h0 , "MIFR gorev sonrasi");
    oku_denetle(A_MIOVF , 32'h0 , "MIOVF gorev sonrasi");

    axi_yaz(A_IRQ_DURUM , 32'h0000_0001);
    bekle(1);
    denetle("irq W1C sonrasi" , {31'b0 , irq} , 32'h0);

    axi_yaz(A_MIER , 32'h0);
    axi_yaz(A_IRQ_MASKE , 32'h0);

endtask



/////////////////////////AKIS

initial begin

    bekle(5);
    rst_n = 1'b1;
    bekle(5);

    t1_reset();
    t2_mvect();
    t3_gorev_yazmaclari();
    t4_wstrb();
    t5_hw_trig();
    t6_hardreset();
    t7_m2c();
    t8_c2m();
    t9_gecersiz();
    t10_kesme();
    t11_es_zamanli();
    t13_cla_sifirla();
    if(GOREV_TESTI) t12_gorev();

    $display("--------------------------------------------");
    if(hata == 0) $display("GECTI : %0d denetim , 0 hata", denetim);
    else $display("KALDI : %0d denetim , %0d hata", denetim , hata);
    $display("--------------------------------------------");
    $finish;

end

initial begin

    #5ms;
    $display("KALDI : genel zaman asimi (AXI el sikismasi takildi mi ?)");
    $finish;

end

endmodule
