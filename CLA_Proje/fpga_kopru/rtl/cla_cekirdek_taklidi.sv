`timescale 1ns / 1ps
// =====================================================================
//  cla_cekirdek_taklidi - gercek CLA hazir olana kadar yerine gecen cekirdek
// ---------------------------------------------------------------------
//  Kopru + cla_ctrl_regs + UART zincirini KV260'ta CLA olmadan denemek icin.
//  task_start_req gelince M2C'den N_KELIME adet 32 bitlik deger okur,
//  her birine 1 ekleyip C2M'de ayni ofsete yazar, toplam GECIKME cevrim
//  sonra task_done verir (gercek gorev ~200 cevrim surer).
//  PC tarafi cevabin girdi+1 oldugunu denetler: bit kaymasi, bayt sirasi
//  ve adres hatalari hemen gorunur.
//  Deneme kancasi: M2C[127] == 16'hDEAD ise gorev hic bitmez; kopru zaman
//  asimi (HATA 3) ve SIFIRLA komutu kartta da boyle denenebilir.
// =====================================================================
module cla_cekirdek_taklidi #(
    parameter int N_KELIME = 9,         // 32 bitlik deger sayisi (M2C/C2M 0..2N-1)
    parameter int GECIKME  = 200
)(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        task_start_req,
    output logic        task_done,
    // M2C okuma
    output logic [6:0]  m2c_addr,
    output logic [1:0]  m2c_rd_en,
    input  logic [31:0] m2c_dout,
    // C2M yazma
    output logic [6:0]  c2m_addr,
    output logic [1:0]  c2m_wr_en,
    output logic [31:0] c2m_din
);
    typedef enum logic [2:0] {BOS, OKU, VERI, YAZ, KANCA, KANCA_V, KANCA_K, BEKLE} durum_t;
    durum_t d;
    logic [6:0]  j;
    logic [15:0] say;
    logic        takili;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            d <= BOS; j <= '0; say <= '0; task_done <= 1'b0; takili <= 1'b0;
            m2c_addr <= '0; m2c_rd_en <= '0; c2m_addr <= '0; c2m_wr_en <= '0; c2m_din <= '0;
        end else begin
            task_done <= 1'b0;
            m2c_rd_en <= '0;
            c2m_wr_en <= '0;
            if (d != BOS) say <= say + 1'b1;
            case (d)
                BOS:  if (task_start_req) begin d <= OKU; j <= '0; say <= 16'd1; end
                OKU:  begin m2c_addr <= {j[5:0], 1'b0}; m2c_rd_en <= 2'b11; d <= VERI; end
                VERI: d <= YAZ;                          // RAM okumayi kaydediyor
                YAZ:  begin
                          c2m_addr <= {j[5:0], 1'b0}; c2m_din <= m2c_dout + 32'd1; c2m_wr_en <= 2'b11;
                          j <= j + 1'b1;
                          d <= (j == 7'(N_KELIME - 1)) ? KANCA : OKU;
                      end
                KANCA:   begin m2c_addr <= 7'd127; m2c_rd_en <= 2'b01; d <= KANCA_V; end
                KANCA_V: d <= KANCA_K;
                KANCA_K: begin takili <= (m2c_dout[15:0] == 16'hDEAD); d <= BEKLE; end
                BEKLE: if (!takili && say >= 16'(GECIKME - 1)) begin task_done <= 1'b1; d <= BOS; end
                default: d <= BOS;
            endcase
        end
    end
endmodule
