`timescale 1ns / 1ps
// CLA_Top kabul tezgahi: golden paketinin bellek goruntulerini yukler, gorevleri CPU portundan
// tetikler, her cevrim golden iz satirini basar (trace_format v1), sonda bellek ve yazmaclari doker.
//   +PROG=<yol/onek>  (onek_L3.hex, _L1.hex, _L2.hex, _M2C.hex, _C2M.hex, _yazmac_baslangic.txt)
//   +CIKTI=<yol/onek> (onek.trace, onek_son_L1.hex, _son_L2.hex, _son_C2M.hex, _son_yazmac.txt)
module tb_cla_top;
    import cla_pkg::*;

    logic clk = 0, rst_n = 0;
    always #5 clk = ~clk;

    logic cpu_wr_en = 0; logic [2:0] cpu_reg_addr = 0; logic [15:0] cpu_wr_data = 0; logic [15:0] cpu_rd_data;
    logic mvect_wr_en = 0; logic [2:0] mvect_gorev = 0; logic [15:0] mvect_veri = 0; logic [15:0] mvect_oku;
    logic [7:0] pie_kesme; logic [15:0] mirun;
    logic [6:0] m2c_addr, c2m_addr; logic [1:0] m2c_rd_en, c2m_wr_en, c2m_rd_en; logic [31:0] m2c_dout, c2m_din, c2m_dout;

    CLA_Top DUT(.clk(clk), .rst_n(rst_n),
        .cpu_wr_en(cpu_wr_en), .cpu_reg_addr(cpu_reg_addr), .cpu_wr_data(cpu_wr_data), .cpu_rd_data(cpu_rd_data),
        .mvect_wr_en(mvect_wr_en), .mvect_gorev(mvect_gorev), .mvect_veri(mvect_veri), .mvect_oku(mvect_oku),
        .hw_task_trig(8'h00), .pie_kesme(pie_kesme), .mirun(mirun),
        .m2c_addr(m2c_addr), .m2c_rd_en(m2c_rd_en), .m2c_dout(m2c_dout),
        .c2m_addr(c2m_addr), .c2m_wr_en(c2m_wr_en), .c2m_rd_en(c2m_rd_en), .c2m_din(c2m_din), .c2m_dout(c2m_dout));

    // kopruyle ayni davranista mesaj RAM'leri (CLA tarafi)
    cla_data_ram #(.ADDR_WIDTH(7)) M2C(.clk(clk), .addr(m2c_addr), .wr_en(2'b00), .rd_en(m2c_rd_en), .din(32'h0), .dout(m2c_dout));
    cla_data_ram #(.ADDR_WIDTH(7)) C2M(.clk(clk), .addr(c2m_addr), .wr_en(c2m_wr_en), .rd_en(c2m_rd_en), .din(c2m_din), .dout(c2m_dout));

    string prog, cikti, ad, dosya;
    integer f, fi, r, i, deger;
    logic [11:0] mvect [0:7];
    logic [7:0] mier, mifrc;
    logic [31:0] mstf_bas;

    function automatic logic [15:0] taban(input logic [1:0] b);
        case (b) 2'b00: return 16'h8800; 2'b01: return 16'h8C00; 2'b10: return 16'h1480; default: return 16'h1500; endcase
    endfunction

    // iz durumu
    integer satir, mstop_satiri, son_satir;
    logic   basladi, bitti_adayi;
    logic   s_ev; logic [11:0] s_epc; logic [31:0] s_eop;
    logic [1:0] s_wen, s_blok; logic [9:0] s_wadr; logic [31:0] s_wdin;
    logic   s_bos, s_durma, s_mstop, s_gorev_yok, s_donma;
    string  pie_listesi;
    integer n_dur_exe = 0, n_dur_r1 = 0, n_dal = 0, n_cagri = 0, n_mar = 0, n_gorev = 0, n_bekle = 0;

    initial begin
        if (!$value$plusargs("PROG=%s", prog)) $fatal(1, "+PROG gerekli");
        if (!$value$plusargs("CIKTI=%s", cikti)) cikti = "rtl";
        // bellek goruntuleri
        $readmemh({prog, "_L3.hex"}, DUT.F2.l3);
        $readmemh({prog, "_L1.hex"}, DUT.L1.ram);
        $readmemh({prog, "_L2.hex"}, DUT.L2.ram);
        $readmemh({prog, "_M2C.hex"}, M2C.ram);
        $readmemh({prog, "_C2M.hex"}, C2M.ram);
        // baslangic yazmaclari
        fi = $fopen({prog, "_yazmac_baslangic.txt"}, "r");
        if (fi == 0) $fatal(1, "yazmac_baslangic yok");
        for (i = 0; i < 8; i++) mvect[i] = 0;
        mier = 0; mifrc = 0; mstf_bas = 0;
        while (!$feof(fi)) begin
            r = $fscanf(fi, "%s %h\n", ad, deger);
            if (r != 2) break;
            if (ad.substr(0, 4) == "MVECT") mvect[ad.substr(5, 5).atoi() - 1] = deger[11:0];
            else if (ad == "MIER") mier = deger[7:0];
            else if (ad == "MIFRC") mifrc = deger[7:0];
            else if (ad == "MSTF") mstf_bas = deger;
        end
        $fclose(fi);
        if (mstf_bas != 0) $fatal(1, "baslangic MSTF 0 olmali");

        repeat (3) @(negedge clk);
        rst_n = 1;
        @(negedge clk);
        for (i = 0; i < 8; i++) begin                       // MVECT1-8
            mvect_wr_en = 1; mvect_gorev = i[2:0]; mvect_veri = {4'h0, mvect[i]};
            @(negedge clk);
        end
        mvect_wr_en = 0;
        cpu_wr_en = 1; cpu_reg_addr = 3'd5; cpu_wr_data = {8'h00, mier};    // MIER
        @(negedge clk);
        cpu_wr_en = 1; cpu_reg_addr = 3'd4; cpu_wr_data = {8'h00, mifrc};   // MIFRC: gorevleri tetikle
        @(negedge clk);
        cpu_wr_en = 0;

        f = $fopen({cikti, ".trace"}, "w");
        $fwrite(f, "#CLATRACE 1\n#FIELDS cycle exe_pc exe_op mpc mr0 mr1 mr2 mr3 mar0 mar1 mstf wr_addr wr_data wr_w\n");
        basladi = 0; satir = 0; mstop_satiri = -1; son_satir = -1; pie_listesi = "";
        forever begin
            // ---- cevrim icinde (negedge): bu cevrimin E, W ve boru hatti bilgisi
            if (!basladi && DUT.getir_izin) basladi = 1;          // satir 1 = ilk F1
            if (basladi) begin
                s_ev = DUT.r2e_gecerli; s_epc = DUT.r2e_pc; s_eop = DUT.r2e_kelime;
                s_wen = DUT.w_wr_en; s_blok = DUT.w_blok; s_wadr = DUT.w_ram_adr; s_wdin = DUT.w_din;
                s_bos = !DUT.d2r1_gecerli && !DUT.r1r2_gecerli && !DUT.r2e_gecerli;
                s_durma = DUT.dur_exe || DUT.dur_r1;
                s_mstop = DUT.d2_gecerli && DUT.d2_mstop;
                s_gorev_yok = (DUT.bekleyen == 8'h00);
                s_donma = DUT.dondur && !DUT.dondur_q;              // gecersiz buyruk D2'de goruldu
                n_dur_exe += DUT.dur_exe; n_dur_r1 += (DUT.dur_r1 && !DUT.dur_exe); n_dal += DUT.dal_alindi;
                n_cagri += DUT.rpc_en; n_mar += DUT.mar_artis_en; n_gorev += DUT.gorev_basla; n_bekle += DUT.basla_bekliyor;
            end
            if (pie_kesme != 8'h00) pie_listesi = {pie_listesi, $sformatf(" %02h", pie_kesme)};
            @(posedge clk); #1;
            if (basladi) begin
                // ---- cevrim sonu durumu ile satiri bas
                satir++;
                $fwrite(f, "%0d %s %s %03h %08h %08h %08h %08h %04h %04h %08h", satir,
                        s_ev ? $sformatf("%03h", s_epc) : "---", s_ev ? $sformatf("%08h", s_eop) : "--------",
                        DUT.mpc, DUT.mr0_out, DUT.mr1_out, DUT.mr2_out, DUT.mr3_out, DUT.mar0, DUT.mar1, DUT.mstf);
                if (s_wen != 2'b00)
                    $fwrite(f, " %04h %08h %0d\n", taban(s_blok) + {6'b0, s_wadr},
                            (s_wen == 2'b11) ? s_wdin : {16'h0, s_wdin[15:0]}, (s_wen == 2'b11) ? 32 : 16);
                else
                    $fwrite(f, " ---- -------- --\n");
                // ---- bitis (golden iz_al): MSTOP'tan sonra, durmasiz bir cevrimde R1, R2, E bos ve bekleyen gorev yoksa
                if (s_mstop) mstop_satiri = satir;
                if (s_donma) son_satir = satir;                     // golden: donmada kuyruk yok
                if (son_satir < 0 && mstop_satiri > 0 && !s_durma && s_bos && s_gorev_yok && !DUT.calisiyor)
                    son_satir = (satir > mstop_satiri + 3) ? satir : mstop_satiri + 3;
                if (son_satir > 0 && satir >= son_satir) break;
                if (satir > 20000) $fatal(1, "iz bitmedi");
            end
        end
        $fclose(f);
        repeat (8) @(posedge clk);                              // iz bittikten sonra hicbir sey degismemeli
        #1;

        // ---- son durum
        $writememh({cikti, "_son_L1.hex"}, DUT.L1.ram);
        $writememh({cikti, "_son_L2.hex"}, DUT.L2.ram);
        $writememh({cikti, "_son_C2M.hex"}, C2M.ram);
        f = $fopen({cikti, "_son_yazmac.txt"}, "w");
        $fwrite(f, "MR0 %08h\nMR1 %08h\nMR2 %08h\nMR3 %08h\n", DUT.mr0_out, DUT.mr1_out, DUT.mr2_out, DUT.mr3_out);
        $fwrite(f, "MAR0 %04h\nMAR1 %04h\nMSTF %08h\nMPC %03h\n", DUT.mar0, DUT.mar1, DUT.mstf, DUT.mpc);
        $fwrite(f, "MIRUN %02h\nMIFR %02h\nMIOVF %02h\n", DUT.mirun[7:0], DUT.mifr_out[7:0], DUT.miovf_out[7:0]);
        $fwrite(f, "PIE%s\n", pie_listesi);
        $fclose(f);
        $display("SAYAC %0d %0d %0d %0d %0d %0d %0d", n_dur_exe, n_dur_r1, n_dal, n_cagri, n_mar, n_gorev, n_bekle);
        $finish;
    end
endmodule
