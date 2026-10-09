`timescale 1ns / 1ps
// =====================================================================
//  cla_kopru_cekirdek - PC ile CLA arasindaki kopru, bayt arayuzlu cekirdek
// ---------------------------------------------------------------------
//  Gercek sistemde C28x CPU'nun yaptigi isi yapar:
//    * CPU->CLA mesaj RAM'ine (0x1500-0x157F) yazar,
//    * cla_ctrl_regs'in CPU portundan MIER ve MIFRC yazip gorev 1'i tetikler,
//    * MIRUN'un inmesini (MSTOP D2'de), sonra boru hattinin bosalmasini bekler
//      (CLA_Top.bosta; MSTOP'tan onceki son yazmalar W'ye kadar akar), zaman asimi var,
//    * CLA->CPU mesaj RAM'inden (0x1480-0x14FF) sonucu okuyup geri yollar.
//  Bayt akisi disaridan gelir/gider: UART (cla_uart_kopru, A yolu) ya da
//  ARM'in AXI-Lite kapisi (cla_axi_kopru, B yolu). Paket kurallari ayni.
//  Iki mesaj RAM'i bu modulun icindedir; CLA'ya bakan portlari
//  cla_data_ram ile ayni arayuzdedir (kelime adresi, wr_en/rd_en[1:0],
//  kayitli okuma). Top modul adres cozumunde bu iki blogu da secer.
//
//  Paket (butun baytlar):
//    istek : A5 | tip | uzunluk | veri[uzunluk] | saglama
//    cevap : 5A | tip | uzunluk | veri[uzunluk] | saglama
//    saglama = tip ^ uzunluk ^ veri[0] ^ ... ; kelimeler LSB once.
//  tip 00 YANKI : veri aynen geri doner (baglanti testi)
//      01 YAZ   : veri = ofs, k kelime -> M2C[ofs..]; cevap bos
//      02 ADIM  : veri = ofs, n, k kelime -> M2C'ye yaz, gorev 1'i kostur,
//                 cevap = C2M[0..n-1] + gorevin cevrim sayisi (32 bit): ilk getirmeden
//                 boru hatti bosalana kadar (golden'in gorev suresiyle ayni: core.ClaCore.run)
//      03 OKU   : veri = ofs, n -> cevap = C2M[ofs..ofs+n-1]
//      04 SIFIRLA: veri bos -> cla_rst_n 16 cevrim 0 (takilan gorevi kurtarir); cevap bos
//      7F HATA  : (cevap) veri = kod: 1 saglama, 2 tip, 3 zaman asimi, 4 uzunluk
// =====================================================================
module cla_kopru_cekirdek #(
    parameter int ZAMAN_ASIMI = 1_000_000,      // gorev icin en cok cevrim
    parameter int BAYT_ASIMI  = 1_000_000       // paket ortasinda bayt bekleme siniri
)(
    input  logic        clk,
    input  logic        rst_n,
    // bayt akisi
    input  logic        giris_gecerli,    // 1 cevrim: giris_veri gecerli
    input  logic [7:0]  giris_veri,
    output logic        cikis_gonder,     // 1 cevrim: cikis_veri'yi al
    output logic [7:0]  cikis_veri,
    input  logic        cikis_mesgul,     // alici dolu: bekle
    // CPU->CLA mesaj RAM'i, CLA tarafi (yalniz okuma)
    input  logic [6:0]  m2c_addr,
    input  logic [1:0]  m2c_rd_en,
    output logic [31:0] m2c_dout,
    // CLA->CPU mesaj RAM'i, CLA tarafi
    input  logic [6:0]  c2m_addr,
    input  logic [1:0]  c2m_wr_en,
    input  logic [1:0]  c2m_rd_en,
    input  logic [31:0] c2m_din,
    output logic [31:0] c2m_dout,
    // cla_ctrl_regs CPU portu
    output logic        cpu_wr_en,
    output logic [2:0]  cpu_reg_addr,     // 4: MIFRC, 5: MIER
    output logic [15:0] cpu_wr_data,
    input  logic [15:0] mirun,
    input  logic        cla_bosta,        // CLA_Top.bosta: gorev yok, boru hatti bos
    output logic        cla_rst_n,        // CLA'nin resetine AND'lenir
    // izleme (LED)
    output logic [3:0]  durum             // {cla mesgul, hata, tx, rx}
);
    localparam logic [7:0] ISTEK = 8'hA5, CEVAP = 8'h5A;
    localparam logic [7:0] T_YANKI = 8'h00, T_YAZ = 8'h01, T_ADIM = 8'h02, T_OKU = 8'h03, T_SIFIRLA = 8'h04, T_HATA = 8'h7F;

    // ------------------------------------------------------------ mesaj RAM'leri
    logic [15:0] m2c [0:127];
    logic [15:0] c2m [0:127];

    always_ff @(posedge clk) begin                        // CLA tarafi (cla_data_ram gibi)
        m2c_dout[15:0]  <= m2c_rd_en[0] ? m2c[m2c_addr]          : 16'h0000;
        m2c_dout[31:16] <= m2c_rd_en[1] ? m2c[7'(m2c_addr + 1)]  : 16'h0000;
        if (c2m_wr_en[0]) c2m[c2m_addr]         <= c2m_din[15:0];
        if (c2m_wr_en[1]) c2m[7'(c2m_addr + 1)] <= c2m_din[31:16];
        c2m_dout[15:0]  <= c2m_rd_en[0] ? c2m[c2m_addr]          : 16'h0000;
        c2m_dout[31:16] <= c2m_rd_en[1] ? c2m[7'(c2m_addr + 1)]  : 16'h0000;
    end

    // ------------------------------------------------------------ durum makinesi
    typedef enum logic [3:0] {
        S_BASLIK, S_TIP, S_UZUN, S_VERI, S_SAGLAMA, S_KOMUT,
        S_YAZ, S_MIER, S_MIFRC, S_BEKLE_BASLA, S_BEKLE_BIT, S_BOSALT, S_CEVAP, S_SIFIR
    } durum_t;
    durum_t d;

    logic [7:0]  tampon [0:255];
    logic [7:0]  tip, uzun, idx, sag;
    logic [7:0]  ofs, k, n, i, taban;         // taban: verideki ilk kelimenin bayt indisi
    logic [31:0] cevrim, zaman, bayt_zaman;
    logic        hata_led;
    logic [3:0]  sifir_say;

    // cevap ureteci
    logic [7:0]  c_tip, c_uzun, c_idx, c_xor, c_ofs, c_n, c_kod;
    logic [1:0]  c_kaynak;                    // 0 tampon, 1 C2M+cevrim, 2 C2M, 3 hata kodu
    logic [2:0]  c_asama;                     // 0 baslik, 1 tip, 2 uzun, 3 veri, 4 saglama
    logic [15:0] c_kelime;
    logic [7:0]  c_bayt;

    assign c_kelime = c2m[7'(c_ofs + (c_idx >> 1))];
    always_comb begin
        case (c_kaynak)
            2'd0: c_bayt = tampon[c_idx];
            2'd3: c_bayt = c_kod;
            default:
                if (c_kaynak == 2'd1 && c_idx >= {c_n[6:0], 1'b0})
                    c_bayt = cevrim[8 * (c_idx - {c_n[6:0], 1'b0}) +: 8];
                else
                    c_bayt = c_idx[0] ? c_kelime[15:8] : c_kelime[7:0];
        endcase
    end

    // cevap baslatma (makro: ayni always_ff icinde kalsin diye)
    `define CEVAP_BASLAT(t, u, kay) begin c_tip <= (t); c_uzun <= (u); c_kaynak <= (kay); c_asama <= 3'd0; c_idx <= '0; d <= S_CEVAP; end
    `define HATA_VER(kod) begin `CEVAP_BASLAT(T_HATA, 8'd1, 2'd3) c_kod <= (kod); hata_led <= 1'b1; end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            d <= S_BASLIK; tip <= '0; uzun <= '0; idx <= '0; sag <= '0;
            ofs <= '0; k <= '0; n <= '0; i <= '0; taban <= '0;
            cevrim <= '0; zaman <= '0; bayt_zaman <= '0; hata_led <= 1'b0;
            c_tip <= '0; c_uzun <= '0; c_idx <= '0; c_xor <= '0; c_ofs <= '0; c_n <= '0;
            c_kod <= '0; c_kaynak <= '0; c_asama <= '0;
            cikis_gonder <= 1'b0; cikis_veri <= '0;
            cpu_wr_en <= 1'b0; cpu_reg_addr <= '0; cpu_wr_data <= '0;
            cla_rst_n <= 1'b1; sifir_say <= '0;
        end else begin
            cikis_gonder <= 1'b0;
            cpu_wr_en <= 1'b0;

            // paket ortasinda uzun bekleme: bastan basla
            if (d inside {S_TIP, S_UZUN, S_VERI, S_SAGLAMA}) begin
                if (giris_gecerli) bayt_zaman <= '0;
                else if (bayt_zaman == 32'(BAYT_ASIMI)) begin d <= S_BASLIK; bayt_zaman <= '0; end
                else bayt_zaman <= bayt_zaman + 1;
            end

            case (d)
                // ---------------- paket alma
                S_BASLIK: if (giris_gecerli && giris_veri == ISTEK) begin d <= S_TIP; bayt_zaman <= '0; end
                S_TIP:    if (giris_gecerli) begin tip <= giris_veri; sag <= giris_veri; d <= S_UZUN; end
                S_UZUN:   if (giris_gecerli) begin
                              uzun <= giris_veri; sag <= sag ^ giris_veri; idx <= '0;
                              d <= (giris_veri == 8'd0) ? S_SAGLAMA : S_VERI;
                          end
                S_VERI:   if (giris_gecerli) begin                   // bayt tampon'a asagida yazilir
                              sag <= sag ^ giris_veri; idx <= idx + 1'b1;
                              if (idx == uzun - 1'b1) d <= S_SAGLAMA;
                          end
                S_SAGLAMA: if (giris_gecerli) begin
                              if (giris_veri == sag) d <= S_KOMUT;
                              else `HATA_VER(8'd1)
                          end

                // ---------------- komut
                S_KOMUT: begin
                    hata_led <= 1'b0;
                    case (tip)
                        T_YANKI: `CEVAP_BASLAT(T_YANKI, uzun, 2'd0)
                        T_YAZ:   if (uzun[0] && 9'(tampon[0]) + 9'((uzun - 1'b1) >> 1) <= 9'd128) begin
                                     ofs <= tampon[0]; k <= (uzun - 1'b1) >> 1; taban <= 8'd1; i <= '0; d <= S_YAZ;
                                 end else `HATA_VER(8'd4)
                        T_ADIM:  if (uzun >= 8'd2 && !uzun[0] && tampon[1] <= 8'd64 &&
                                     9'(tampon[0]) + 9'((uzun - 8'd2) >> 1) <= 9'd128) begin
                                     ofs <= tampon[0]; n <= tampon[1]; k <= (uzun - 8'd2) >> 1;
                                     taban <= 8'd2; i <= '0; d <= S_YAZ;
                                 end else `HATA_VER(8'd4)
                        T_OKU:   if (uzun == 8'd2 && 9'(tampon[0]) + 9'(tampon[1]) <= 9'd128 && tampon[1] <= 8'd64) begin
                                     c_ofs <= tampon[0]; c_n <= tampon[1];
                                     `CEVAP_BASLAT(T_OKU, {tampon[1][6:0], 1'b0}, 2'd2)
                                 end else `HATA_VER(8'd4)
                        T_SIFIRLA: if (uzun == 8'd0) begin sifir_say <= '1; cla_rst_n <= 1'b0; d <= S_SIFIR; end
                                   else `HATA_VER(8'd4)
                        default: `HATA_VER(8'd2)
                    endcase
                end

                S_SIFIR: if (sifir_say == '0) begin cla_rst_n <= 1'b1; `CEVAP_BASLAT(T_SIFIRLA, 8'd0, 2'd0) end
                         else sifir_say <= sifir_say - 1'b1;

                S_YAZ: begin
                    if (i == k) begin
                        if (tip == T_YAZ) `CEVAP_BASLAT(T_YAZ, 8'd0, 2'd0)
                        else d <= S_MIER;
                    end else i <= i + 1'b1;                     // kelime m2c'ye asagida yazilir
                end

                // ---------------- gorev 1'i kostur
                S_MIER:  begin cpu_wr_en <= 1'b1; cpu_reg_addr <= 3'd5; cpu_wr_data <= 16'h0001; d <= S_MIFRC; end
                S_MIFRC: begin cpu_wr_en <= 1'b1; cpu_reg_addr <= 3'd4; cpu_wr_data <= 16'h0001;
                               zaman <= '0; d <= S_BEKLE_BASLA; end
                S_BEKLE_BASLA: begin
                    if (mirun[0]) begin cevrim <= 32'd1; zaman <= '0; d <= S_BEKLE_BIT; end
                    else if (zaman == 32'(ZAMAN_ASIMI)) `HATA_VER(8'd3)
                    else zaman <= zaman + 1;
                end
                S_BEKLE_BIT: begin                                  // MIRUN MSTOP D2'deyken duser
                    if (!mirun[0]) begin cevrim <= cevrim + 1; d <= S_BOSALT; end
                    else if (zaman == 32'(ZAMAN_ASIMI)) `HATA_VER(8'd3)
                    else begin zaman <= zaman + 1; cevrim <= cevrim + 1; end
                end
                S_BOSALT: begin                                     // son buyruklar W'ye kadar akar
                    if (cla_bosta) begin
                        cevrim <= cevrim + 1; c_ofs <= '0; c_n <= n;
                        `CEVAP_BASLAT(T_ADIM, {n[6:0], 1'b0} + 8'd4, 2'd1)
                    end else if (zaman == 32'(ZAMAN_ASIMI)) `HATA_VER(8'd3)
                    else begin zaman <= zaman + 1; cevrim <= cevrim + 1; end
                end

                // ---------------- cevap gonderme
                S_CEVAP: if (!cikis_mesgul && !cikis_gonder) begin
                    cikis_gonder <= 1'b1;
                    case (c_asama)
                        3'd0: begin cikis_veri <= CEVAP;  c_asama <= 3'd1; end
                        3'd1: begin cikis_veri <= c_tip;  c_xor <= c_tip; c_asama <= 3'd2; end
                        3'd2: begin cikis_veri <= c_uzun; c_xor <= c_xor ^ c_uzun;
                                    c_asama <= (c_uzun == 8'd0) ? 3'd4 : 3'd3; end
                        3'd3: begin cikis_veri <= c_bayt; c_xor <= c_xor ^ c_bayt; c_idx <= c_idx + 1'b1;
                                    if (c_idx == c_uzun - 1'b1) c_asama <= 3'd4; end
                        default: begin cikis_veri <= c_xor; d <= S_BASLIK; end  // son bayt giderken yeni istek alinabilir
                    endcase
                end

                default: d <= S_BASLIK;
            endcase
        end
    end

    // tampon ve M2C yazmalari: sifirlamasiz blok (RAM cikarimi icin)
    always_ff @(posedge clk) begin
        if (d == S_VERI && giris_gecerli) tampon[idx] <= giris_veri;
        if (d == S_YAZ && i != k)
            m2c[7'(ofs + i)] <= {tampon[8'(taban + {i[6:0], 1'b0} + 8'd1)], tampon[8'(taban + {i[6:0], 1'b0})]};
    end

    assign durum = {mirun[0], hata_led, cikis_mesgul, (d != S_BASLIK)};
`undef CEVAP_BASLAT
`undef HATA_VER
endmodule
