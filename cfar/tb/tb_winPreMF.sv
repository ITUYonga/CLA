`timescale 1ns/1ps

module tb_winPreMF;
    import parameters::*;

    localparam int N    = 20;
    localparam int W    = WIN_PRE_MF;
    localparam int CW   = WIN_PRE_MF_COEF_WIDTH;
    localparam int FRAC = CW - 2;

    logic clk_i  = 0;
    logic rst_ni = 0;
    always #2.5 clk_i = ~clk_i;

    logic                 valid_i = 0;
    logic                 sof_i   = 0;
    logic signed [W-1:0]  reel_i    = 0;
    logic signed [W-1:0]  complex_i = 0;
    logic                 valid_o;
    logic                 sof_o;
    logic signed [W-1:0]  reel_o;
    logic signed [W-1:0]  complex_o;

    winPreMF dut (
        .clk_i     (clk_i),
        .rst_ni    (rst_ni),
        .complex_i (complex_i),
        .reel_i    (reel_i),
        .valid_i   (valid_i),
        .sof_i     (sof_i),
        .valid_o   (valid_o),
        .sof_o     (sof_o),
        .complex_o (complex_o),
        .reel_o    (reel_o)
    );

    logic signed [CW-1:0] coef [0:N-1];
    initial $readmemh(WIN_PRE_MF_COEF, coef);

    logic signed [W-1:0] expRe  [$];
    logic signed [W-1:0] expIm  [$];
    logic                expSof [$];
    int                  expIdx [$];
    int                  expTest[$];

    int  errors    = 0;
    int  checked   = 0;
    int  sofIn     = 0;
    int  sofOut    = 0;
    int  testNo    = 0;
    int  refIdx    = 0;
    bit  showTable = 0;

    function automatic logic signed [W-1:0] model(logic signed [W-1:0] x, logic signed [CW-1:0] c);
        longint p;
        p = longint'(x) * longint'(c);
        return W'(p >>> FRAC);
    endfunction

    task automatic push(input logic signed [W-1:0] re, input logic signed [W-1:0] im, input bit sof);
        if (sof) refIdx = 0;
        reel_i    <= re;
        complex_i <= im;
        sof_i     <= sof;
        valid_i   <= 1'b1;
        expRe.push_back(model(re, coef[refIdx]));
        expIm.push_back(model(im, coef[refIdx]));
        expSof.push_back(sof);
        expIdx.push_back(refIdx);
        expTest.push_back(testNo);
        if (sof) sofIn++;
        refIdx = (refIdx == N-1) ? 0 : refIdx + 1;
        @(posedge clk_i);
    endtask

    task automatic idle(input int cycles);
        valid_i <= 1'b0;
        sof_i   <= 1'b0;
        reel_i    <= 'x;
        complex_i <= 'x;
        repeat (cycles) @(posedge clk_i);
    endtask

    function automatic logic signed [W-1:0] rnd();
        return $signed(W'($urandom));
    endfunction

    task automatic frame(input int kind);
        logic signed [W-1:0] a, b;
        for (int n = 0; n < N; n++) begin
            case (kind)
                0: begin a = 16384;          b = -16384;         end
                1: begin a = {1'b0, {(W-1){1'b1}}}; b = {1'b1, {(W-1){1'b0}}}; end
                2: begin a = {1'b1, {(W-1){1'b0}}}; b = {1'b0, {(W-1){1'b1}}}; end
                default: begin a = rnd(); b = rnd(); end
            endcase
            push(a, b, n == 0);
        end
    endtask

    always @(posedge clk_i) begin
        if (valid_o) begin
            if (expRe.size() == 0) begin
                errors++;
                $display("HATA t=%0t: beklenmeyen valid_o (giris yokken cikis geldi)", $time);
            end else begin
                logic signed [W-1:0] eR, eI;
                logic eS;
                int   k, tn;
                eR = expRe.pop_front();
                eI = expIm.pop_front();
                eS = expSof.pop_front();
                k  = expIdx.pop_front();
                tn = expTest.pop_front();
                checked++;
                if (sof_o) sofOut++;
                if (showTable && tn == 1)
                    $display("  n=%2d  w=%6d  giris=%6d  cikis=%6d  beklenen=%6d  sof=%b  %s",
                             k, coef[k], 16384, reel_o, eR, sof_o, (reel_o === eR) ? "ok" : "<-- HATA");
                if (reel_o !== eR || complex_o !== eI || sof_o !== eS) begin
                    errors++;
                    if (errors <= 10)
                        $display("HATA test%0d n=%0d: reel %0d/%0d  complex %0d/%0d  sof %b/%b  (cikan/beklenen)",
                                 tn, k, reel_o, eR, complex_o, eI, sof_o, eS);
                end
            end
        end
    end

    initial begin
        #20us;
        $display("HATA: zaman asimi");
        $finish;
    end

    initial begin
        repeat (4) @(posedge clk_i);
        rst_ni <= 1'b1;
        repeat (2) @(posedge clk_i);

        testNo = 1; showTable = 1;
        $display("TEST 1: sabit giris 0.5 (16384) -> cikis = w[n]/2 olmali");
        frame(0);
        idle(6);
        showTable = 0;

        testNo = 2;
        $display("TEST 2: en buyuk / en kucuk degerler");
        frame(1);
        frame(2);
        idle(3);

        testNo = 3;
        $display("TEST 3: arka arkaya 50 rastgele cerceve, bosluksuz");
        repeat (50) frame(3);
        idle(3);

        testNo = 4;
        $display("TEST 4: cerceve ortasinda valid bosluklari");
        for (int f = 0; f < 10; f++)
            for (int n = 0; n < N; n++) begin
                push(rnd(), rnd(), n == 0);
                if ($urandom % 4 == 0) idle(1 + $urandom % 3);
            end
        idle(3);

        testNo = 5;
        $display("TEST 5: erken sof (7. ornekte yeni cerceve) -> indeks 0'a donmeli");
        for (int n = 0; n < 7; n++)  push(rnd(), rnd(), n == 0);
        for (int n = 0; n < N; n++)  push(rnd(), rnd(), n == 0);
        idle(3);

        testNo = 6;
        $display("TEST 6: sof olmadan 20'yi asan akis -> indeks 19'dan 0'a sarmali");
        for (int n = 0; n < 45; n++) push(rnd(), rnd(), n == 0);
        idle(10);

        $display("--------------------------------------------------------------");
        $display("kontrol edilen   : %0d ornek", checked);
        $display("sof giris/cikis  : %0d / %0d", sofIn, sofOut);
        $display("cikmayan ornek   : %0d", expRe.size());
        $display("hata             : %0d", errors);
        if (errors == 0 && expRe.size() == 0 && sofIn == sofOut)
            $display("SONUC: GECTI");
        else
            $display("SONUC: KALDI");
        $display("--------------------------------------------------------------");
        $finish;
    end
endmodule
