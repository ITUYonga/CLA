//------------------------------------------------------------------------------
// complexMulRTL   (a + jb) * (c + jd) = (ac - bd) + j(ad + bc)
//
// Duzeltmeler:
//   * signed
//   * twiddle Q2.FRAC -> carpim sonrasi yuvarlama + >>> FRAC
//   * |W| <= 1 oldugundan cikis giris genisliginde kalir
//   * 2 evreli boru hatti (DSP48 carpim kaydi kullanilsin diye)
//------------------------------------------------------------------------------
module complexMulRTL #(
    parameter int DW   = 21,
    parameter int TW   = 18,
    parameter int FRAC = 16
)(
    input  logic                  clk_i,
    input  logic                  rst_ni,
    input  logic                  en_i,

    input  logic signed [DW-1:0]  in0Reel_i,
    input  logic signed [DW-1:0]  in0Complex_i,
    input  logic signed [TW-1:0]  in1Reel_i,
    input  logic signed [TW-1:0]  in1Complex_i,

    output logic signed [DW-1:0]  reelOut_o,
    output logic signed [DW-1:0]  complexOut_o
);
    localparam int PW = DW + TW;

    logic signed [PW-1:0] ac, bd, ad, bc;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            ac <= '0; bd <= '0; ad <= '0; bc <= '0;
        end else if (en_i) begin
            ac <= in0Reel_i    * in1Reel_i;
            bd <= in0Complex_i * in1Complex_i;
            ad <= in0Reel_i    * in1Complex_i;
            bc <= in0Complex_i * in1Reel_i;
        end
    end

    localparam logic signed [PW:0] RND = (PW+1)'(1) <<< (FRAC-1);

    logic signed [PW:0] sumReel, sumComplex;
    always_comb begin
        sumReel    = ac - bd + RND;
        sumComplex = ad + bc + RND;
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            reelOut_o    <= '0;
            complexOut_o <= '0;
        end else if (en_i) begin
            reelOut_o    <= DW'(sumReel    >>> FRAC);
            complexOut_o <= DW'(sumComplex >>> FRAC);
        end
    end
endmodule
