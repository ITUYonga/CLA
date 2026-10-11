// powerRTL.sv — kare yasa dedektör: P = I^2 + Q^2
//   giriş : 27b işaretli I/Q (Q12.15, FFT çıkışı)
//   çıkış : 54b işaretsiz güç
//   kaynak: 4 DSP48E2 (27x27 çarpım = 2 DSP, iki çarpım)
//   gecikme: PIPE = 4 çevrim, 1 örnek/çevrim, durma yok
//
// Kurallar:
//   * veri kayıtlarında reset YOK  → Vivado A/B, M, P kayıtlarını DSP'nin içine alır
//   * valid/sof zinciri PIPE'tan türetilir, sabit indeks yok
module powerRTL
  import parameters::*;
#(
  parameter int W_IN  = FFT_OUT_LEN,   // 27
  parameter int W_OUT = XLEN_LOG_IN    // 54
)(
  input  logic                    clk_i,
  input  logic                    rst_ni,
  input  logic                    valid_i,
  input  logic                    sof_i,
  input  logic signed [W_IN-1:0]  reel_i,
  input  logic signed [W_IN-1:0]  imag_i,
  output logic                    valid_o,
  output logic                    sof_o,
  output logic        [W_OUT-1:0] power_o
);

  localparam int PIPE = 4;

  // ---- veri yolu: A/B → M → M2 → P ----
  (* use_dsp = "yes" *) logic signed [W_IN-1:0]    iA, qA;
  (* use_dsp = "yes" *) logic signed [2*W_IN-1:0]  iM, qM, iM2, qM2;
  logic               [W_OUT-1:0]   pR;

  always_ff @(posedge clk_i) begin
    iA  <= reel_i;               // 1: giriş kaydı (A/B)
    qA  <= imag_i;
    iM  <= iA * iA;              // 2: çarpım (M)
    qM  <= qA * qA;
    iM2 <= iM;                   // 3: ikinci çarpım kaydı (27x27 kaskadı için)
    qM2 <= qM;
    pR  <= W_OUT'(unsigned'(iM2)) + W_OUT'(unsigned'(qM2));  // 4: toplam (P)
  end
  // Kare negatif olamaz: iM2, qM2 ≥ 0, işaretsiz yorumlamak güvenli.
  // Max = 2 * (2^26)^2 = 2^53 → 54 bite sığar.

  assign power_o = pR;

  // ---- kontrol: PIPE derinliğinde kaydırma, sadece burada reset ----
  logic [PIPE-1:0] vSh, sSh;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      vSh <= '0;
      sSh <= '0;
    end else begin
      vSh <= {vSh[PIPE-2:0], valid_i};
      sSh <= {sSh[PIPE-2:0], sof_i & valid_i};
    end
  end
  assign valid_o = vSh[PIPE-1];
  assign sof_o   = sSh[PIPE-1];

endmodule
