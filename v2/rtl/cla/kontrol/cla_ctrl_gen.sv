`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: cla_ctrl_gen
// Description: Kontrol uretici. Decoder'in ciktisindan (op + alan) buyrugun
//              kontrol paketini (kontrol_t) uretir. Tamamen kombinasyonel.
//
//   Pakette yalniz statik bilgi var (bkz. cla_pkg.sv "KONTROL PAKETI").
//   Ilk olarak her alan 0 yapilir; her buyruk yalniz kendi kullandigi
//   alanlari doldurur. Kullanilmayan mux'lar 0 kalir (ALU referansi:
//   "x = onemsiz, 0 verilebilir").
//
// Kaynaklar:
//   ALU alanlari, port duzeni : ALU_Kontrol_Referansi (ALU.sv, 29.09 surumu)
//   Bellek ve MAR             : CLA_GoldenModel/golden_model/erisim.py
//   MR yazma, bayraklar       : CLA_GoldenModel/golden_model/ops_*.py
//
// Varsayimlar (Ahmet, 04.10.2026):
//   - Ayrilmis adresleme kipi (kip_gecersiz) gecersiz opcode gibi ele alinir.
//   - MAR post-increment kosulsuz: kosullu MMOV32'de kosul tutmasa da artar
//     (golden model su an artirmiyor; netlesecek).
//////////////////////////////////////////////////////////////////////////////////

module cla_ctrl_gen
    import cla_pkg::*;
(
    input  op_e      op,
    input  alanlar_t alan,
    input  logic     kip_gecersiz,  // decoder'dan
    output kontrol_t k
);

    // MRx'in okunan_mr maskesindeki biti
    function automatic logic [3:0] mr_bit(input logic [1:0] x);
        return 4'b0001 << x;
    endfunction

    // CNDF'li buyruklar ZF/NF'yi yalniz CNDF = UNCF ise yazar (TRM Tablo 10-9 dipnot 2)
    logic uncf;
    assign uncf = (alan.cndf == CNDF_UNCF);

    always_comb begin
        k = '0;
        k.alu.karsilastirma_cndf = CNDF_UNCF;  // MNEGF32 disinda hep UNCF
        k.kosul                  = alan.cndf;

        unique case (op)
            // ==========================================================
            // Paralel: FP islem || MMOV32  (MRd = MRe op MRf)
            // Port: a = MRe, b = MRf. MMACF32: a = MR3, b = MR2, c = MRe, d = MRf
            // ==========================================================
            OP_MMPYF32_PAR_LD, OP_MADDF32_PAR_LD, OP_MSUBF32_PAR_LD, OP_MMACF32_PAR_LD,
            OP_MMPYF32_PAR_ST, OP_MADDF32_PAR_ST, OP_MSUBF32_PAR_ST: begin
                k.bellek_adres = 1'b1;

                unique case (op)
                    OP_MMACF32_PAR_LD: begin
                        // MR3 = MR3 + MR2 (toplayici), MRd = MRe * MRf (carpici)
                        k.a_mr      = 2'd3;
                        k.b_mr      = 2'd2;
                        k.c_mr      = alan.re;
                        k.d_kaynak  = D_MR;
                        k.d_mr      = alan.rf;
                        k.okunan_mr = mr_bit(2'd3) | mr_bit(2'd2) | mr_bit(alan.re) | mr_bit(alan.rf);
                        k.alu.topla_kullan = 1'b1;
                        k.alu.topla_hedef  = 2'd3;
                        k.alu.mux[1]       = 2'b00;
                        k.alu.mux[2]       = 2'b01;
                        k.alu.carp_kullan  = 1'b1;
                        k.alu.carp_hedef   = alan.rd;
                        k.alu.mux[3]       = 2'b10;
                        k.alu.mux[4]       = 2'b11;
                    end
                    OP_MMPYF32_PAR_LD, OP_MMPYF32_PAR_ST: begin
                        k.a_mr      = alan.re;
                        k.b_mr      = alan.rf;
                        k.okunan_mr = mr_bit(alan.re) | mr_bit(alan.rf);
                        k.alu.carp_kullan = 1'b1;
                        k.alu.carp_hedef  = alan.rd;
                        k.alu.mux[3]      = 2'b00;
                        k.alu.mux[4]      = 2'b01;
                    end
                    default: begin  // MADDF32 / MSUBF32
                        k.a_mr      = alan.re;
                        k.b_mr      = alan.rf;
                        k.okunan_mr = mr_bit(alan.re) | mr_bit(alan.rf);
                        k.alu.topla_kullan  = 1'b1;
                        k.alu.topla_hedef   = alan.rd;
                        k.alu.topla_cikarma = (op == OP_MSUBF32_PAR_LD) || (op == OP_MSUBF32_PAR_ST);
                        k.alu.mux[1]        = 2'b00;
                        k.alu.mux[2]        = 2'b01;
                    end
                endcase

                unique case (op)
                    // || MMOV32 MRa, mem32: E'de MRa <= bellek, ZF/NF yuklenen degerden
                    OP_MMPYF32_PAR_LD, OP_MADDF32_PAR_LD, OP_MSUBF32_PAR_LD, OP_MMACF32_PAR_LD: begin
                        k.bellek_oku = ERISIM_32;
                        k.exe_yaz    = 1'b1;
                        k.exe_hedef  = alan.ra;
                        k.exe_kaynak = EXE_BELLEK;
                        k.zn_kaynak  = ZN_YAZILAN_FLOAT;
                    end
                    // || MMOV32 mem32, MRa: MRa'nin eski degeri W'de yazilir
                    default: begin
                        k.okunan_mr  = k.okunan_mr | mr_bit(alan.ra);
                        k.bellek_yaz = ERISIM_32;
                        k.yaz_veri   = VERI_MR;
                    end
                endcase
            end

            // ==========================================================
            // Bellek erisimi
            // ==========================================================
            OP_MMOV32_MR_MEM: begin             // MMOV32 MRa, mem32 {,CNDF}
                k.bellek_adres = 1'b1;
                k.bellek_oku   = ERISIM_32;
                k.exe_yaz      = 1'b1;
                k.exe_hedef    = alan.ra;
                k.exe_kaynak   = EXE_BELLEK;
                k.exe_kosullu  = 1'b1;
                k.zn_kaynak    = uncf ? ZN_YAZILAN_FLOAT : ZN_YOK;
            end
            OP_MMOVD32: begin                   // MRa = [adr], [adr+2] = [adr]
                k.bellek_adres    = 1'b1;
                k.bellek_oku      = ERISIM_32;
                k.exe_yaz         = 1'b1;
                k.exe_hedef       = alan.ra;
                k.exe_kaynak      = EXE_BELLEK;
                k.zn_kaynak       = ZN_YAZILAN_FLOAT;
                k.bellek_yaz      = ERISIM_32;
                k.yaz_veri        = VERI_BELLEK;
                k.yaz_adres_arti2 = 1'b1;
            end
            OP_MI32TOF32_MEM, OP_MUI32TOF32_MEM,
            OP_MI16TOF32_MEM, OP_MUI16TOF32_MEM: begin  // donusum birimi, d = bellek
                k.bellek_adres = 1'b1;
                k.bellek_oku   = (op == OP_MI32TOF32_MEM || op == OP_MUI32TOF32_MEM) ? ERISIM_32 : ERISIM_16;
                k.d_kaynak     = D_BELLEK;
                k.alu.mux[10]  = 2'b11;
                unique case (op)
                    OP_MI32TOF32_MEM:  k.alu.donusum_islem = 4'b1000;
                    OP_MUI32TOF32_MEM: k.alu.donusum_islem = 4'b1010;
                    OP_MI16TOF32_MEM:  k.alu.donusum_islem = 4'b0111;
                    default:           k.alu.donusum_islem = 4'b1001;  // MUI16TOF32
                endcase
                k.exe_yaz      = 1'b1;
                k.exe_hedef    = alan.ra;
                k.exe_kaynak   = EXE_DONUSUM;
            end
            OP_MMOV32_MEM_MR: begin             // MMOV32 mem32, MRa
                k.bellek_adres = 1'b1;
                k.okunan_mr    = mr_bit(alan.ra);
                k.bellek_yaz   = ERISIM_32;
                k.yaz_veri     = VERI_MR;
            end
            OP_MMOVZ16: begin                   // MRa = {16'h0, [adr]}
                k.bellek_adres = 1'b1;
                k.bellek_oku   = ERISIM_16;
                k.exe_yaz      = 1'b1;
                k.exe_hedef    = alan.ra;
                k.exe_kaynak   = EXE_BELLEK;
                k.zn_kaynak    = ZN_YAZILAN_TAMSAYI;
            end
            OP_MMOV16_MEM_MR: begin             // [adr] = MRa[15:0]
                k.bellek_adres = 1'b1;
                k.okunan_mr    = mr_bit(alan.ra);
                k.bellek_yaz   = ERISIM_16;
                k.yaz_veri     = VERI_MR;
            end
            OP_MMOV16_MAR_MEM: begin            // MARx = [adr]
                k.bellek_adres = 1'b1;
                k.bellek_oku   = ERISIM_16;
                k.mar_yukle    = 1'b1;
                k.mar_hedef    = alan.mar_x;
                k.mar_kaynak   = MAR_BELLEK;
            end
            OP_MMOV16_MEM_MAR: begin            // [adr] = MARx
                k.bellek_adres = 1'b1;
                k.mar_hedef    = alan.mar_x;
                k.bellek_yaz   = ERISIM_16;
                k.yaz_veri     = VERI_MAR;
            end
            OP_MMOV32_MSTF_MEM: begin           // MSTF = [adr] (MEALLOW korunur)
                k.bellek_adres = 1'b1;
                k.bellek_oku   = ERISIM_32;
                k.mstf_yukle   = 1'b1;
            end
            OP_MMOV32_MEM_MSTF: begin           // [adr] = MSTF
                k.bellek_adres = 1'b1;
                k.bellek_yaz   = ERISIM_32;
                k.yaz_veri     = VERI_MSTF;
            end

            // ==========================================================
            // Anlik (#16) formlari: d = {m, 16'h0}
            // ==========================================================
            OP_MADDF32_IMM, OP_MSUBF32_IMM: begin   // MRa = anlik +/- MRb
                k.a_mr      = alan.rb;
                k.d_kaynak  = D_IMM_HI;
                k.okunan_mr = mr_bit(alan.rb);
                k.alu.topla_kullan  = 1'b1;
                k.alu.topla_hedef   = alan.ra;
                k.alu.topla_cikarma = (op == OP_MSUBF32_IMM);
                k.alu.mux[1]        = 2'b11;
                k.alu.mux[2]        = 2'b00;
            end
            OP_MMPYF32_IMM: begin                   // MRa = anlik * MRb
                k.a_mr      = alan.rb;
                k.d_kaynak  = D_IMM_HI;
                k.okunan_mr = mr_bit(alan.rb);
                k.alu.carp_kullan = 1'b1;
                k.alu.carp_hedef  = alan.ra;
                k.alu.mux[3]      = 2'b11;
                k.alu.mux[4]      = 2'b00;
            end
            OP_MMOVIZ: begin                        // MRa = {m, 16'h0}
                k.exe_yaz    = 1'b1;
                k.exe_hedef  = alan.ra;
                k.exe_kaynak = EXE_IMM_HI;
            end
            OP_MMOVXI: begin                        // MRa = {MRa[31:16], m}: MRa okunur
                k.okunan_mr  = mr_bit(alan.ra);
                k.exe_yaz    = 1'b1;
                k.exe_hedef  = alan.ra;
                k.exe_kaynak = EXE_IMM_LO;
            end
            OP_MCMPF32_IMM, OP_MMAXF32_IMM, OP_MMINF32_IMM: begin  // MRa ile anlik
                k.a_mr      = alan.ra;
                k.d_kaynak  = D_IMM_HI;
                k.okunan_mr = mr_bit(alan.ra);
                k.alu.mux[8] = 2'b00;
                k.alu.mux[9] = 2'b11;
                k.zn_kaynak  = ZN_KARSILASTIRMA;
                unique case (op)
                    OP_MCMPF32_IMM: k.alu.karsilastirma_islem = 3'b000;
                    OP_MMAXF32_IMM: k.alu.karsilastirma_islem = 3'b001;
                    default:        k.alu.karsilastirma_islem = 3'b010;  // MMINF32
                endcase
                if (op != OP_MCMPF32_IMM) begin
                    k.exe_yaz    = 1'b1;
                    k.exe_hedef  = alan.ra;
                    k.exe_kaynak = EXE_KARSILASTIRMA;
                end
            end

            // ==========================================================
            // Akis kontrolu ve bayrak
            // ==========================================================
            OP_MBCNDD: k.dal = DAL_MBCNDD;
            OP_MCCNDD: k.dal = DAL_MCCNDD;
            OP_MRCNDD: k.dal = DAL_MRCNDD;
            OP_MSETFLG: k.msetflg = 1'b1;

            // ==========================================================
            // Paralel: MMPYF32 MRa,MRb,MRc || MADDF32/MSUBF32 MRd,MRe,MRf
            // Port: a = MRb, b = MRc, c = MRe, d = MRf
            // ==========================================================
            OP_MMPYF32_PAR_ADD, OP_MMPYF32_PAR_SUB: begin
                k.a_mr      = alan.rb;
                k.b_mr      = alan.rc;
                k.c_mr      = alan.re;
                k.d_kaynak  = D_MR;
                k.d_mr      = alan.rf;
                k.okunan_mr = mr_bit(alan.rb) | mr_bit(alan.rc) | mr_bit(alan.re) | mr_bit(alan.rf);
                k.alu.carp_kullan   = 1'b1;
                k.alu.carp_hedef    = alan.ra;
                k.alu.mux[3]        = 2'b00;
                k.alu.mux[4]        = 2'b01;
                k.alu.topla_kullan  = 1'b1;
                k.alu.topla_hedef   = alan.rd;
                k.alu.topla_cikarma = (op == OP_MMPYF32_PAR_SUB);
                k.alu.mux[1]        = 2'b10;
                k.alu.mux[2]        = 2'b11;
            end

            // ==========================================================
            // Kosullu yazmac islemleri
            // ==========================================================
            OP_MNEGF32: begin                       // MRa = kosul ? -MRb : MRb (ALU karar verir)
                k.a_mr      = alan.rb;
                k.okunan_mr = mr_bit(alan.rb);
                k.alu.karsilastirma_islem = 3'b100;
                k.alu.karsilastirma_cndf  = alan.cndf;
                k.alu.mux[9] = 2'b00;
                k.exe_yaz    = 1'b1;                // kosuldan bagimsiz hep yazilir
                k.exe_hedef  = alan.ra;
                k.exe_kaynak = EXE_KARSILASTIRMA;
                k.zn_kaynak  = uncf ? ZN_KARSILASTIRMA : ZN_YOK;
            end
            OP_MMOV32_MR_MR: begin                  // kosul tutarsa MRa = MRb
                k.okunan_mr     = mr_bit(alan.rb);
                k.exe_yaz       = 1'b1;
                k.exe_hedef     = alan.ra;
                k.exe_kaynak    = EXE_MR;
                k.exe_kaynak_mr = alan.rb;
                k.exe_kosullu   = 1'b1;
                k.zn_kaynak     = uncf ? ZN_YAZILAN_FLOAT : ZN_YOK;
            end
            OP_MSWAPF: begin                        // kosul tutarsa MRa <-> MRb, bayrak yok
                k.okunan_mr       = mr_bit(alan.ra) | mr_bit(alan.rb);
                k.exe_yaz         = 1'b1;
                k.exe_hedef       = alan.ra;
                k.exe_kaynak      = EXE_MR;
                k.exe_kaynak_mr   = alan.rb;
                k.exe_yaz_2       = 1'b1;
                k.exe_hedef_2     = alan.rb;
                k.exe_kaynak_mr_2 = alan.ra;
                k.exe_kosullu     = 1'b1;
            end

            // ==========================================================
            // Tamsayi birimi: kaydirma (a = MRa, d = SHIFT) ve 3 yazmacli
            // (a = MRb, b = MRc), MCMP32 (a = MRa, b = MRb, yazma yok)
            // ==========================================================
            OP_MASR32, OP_MLSR32, OP_MLSL32: begin
                k.a_mr      = alan.ra;
                k.d_kaynak  = D_SHIFT;
                k.okunan_mr = mr_bit(alan.ra);
                k.alu.mux[5] = 2'b00;
                k.alu.mux[6] = 2'b11;
                unique case (op)
                    OP_MLSL32: k.alu.tamsayi_islem = 3'b101;
                    OP_MLSR32: k.alu.tamsayi_islem = 3'b110;
                    default:   k.alu.tamsayi_islem = 3'b111;  // MASR32
                endcase
                k.exe_yaz    = 1'b1;
                k.exe_hedef  = alan.ra;
                k.exe_kaynak = EXE_TAMSAYI;
                k.zn_kaynak  = ZN_TAMSAYI;
            end
            OP_MADD32, OP_MSUB32, OP_MAND32, OP_MOR32, OP_MXOR32: begin
                k.a_mr      = alan.rb;
                k.b_mr      = alan.rc;
                k.okunan_mr = mr_bit(alan.rb) | mr_bit(alan.rc);
                k.alu.mux[5] = 2'b00;
                k.alu.mux[6] = 2'b01;
                unique case (op)
                    OP_MADD32: k.alu.tamsayi_islem = 3'b000;
                    OP_MSUB32: k.alu.tamsayi_islem = 3'b001;
                    OP_MAND32: k.alu.tamsayi_islem = 3'b010;
                    OP_MOR32:  k.alu.tamsayi_islem = 3'b011;
                    default:   k.alu.tamsayi_islem = 3'b100;  // MXOR32
                endcase
                k.exe_yaz    = 1'b1;
                k.exe_hedef  = alan.ra;
                k.exe_kaynak = EXE_TAMSAYI;
                k.zn_kaynak  = ZN_TAMSAYI;
            end
            OP_MCMP32: begin
                k.a_mr      = alan.ra;
                k.b_mr      = alan.rb;
                k.okunan_mr = mr_bit(alan.ra) | mr_bit(alan.rb);
                k.alu.mux[5] = 2'b00;
                k.alu.mux[6] = 2'b01;
                k.alu.tamsayi_islem = 3'b001;
                k.zn_kaynak  = ZN_TAMSAYI;
            end

            // ==========================================================
            // FP 3 yazmacli: MRa = MRb op MRc (a = MRb, b = MRc)
            // ==========================================================
            OP_MMPYF32_RRR: begin
                k.a_mr      = alan.rb;
                k.b_mr      = alan.rc;
                k.okunan_mr = mr_bit(alan.rb) | mr_bit(alan.rc);
                k.alu.carp_kullan = 1'b1;
                k.alu.carp_hedef  = alan.ra;
                k.alu.mux[3]      = 2'b00;
                k.alu.mux[4]      = 2'b01;
            end
            OP_MADDF32_RRR, OP_MSUBF32_RRR: begin
                k.a_mr      = alan.rb;
                k.b_mr      = alan.rc;
                k.okunan_mr = mr_bit(alan.rb) | mr_bit(alan.rc);
                k.alu.topla_kullan  = 1'b1;
                k.alu.topla_hedef   = alan.ra;
                k.alu.topla_cikarma = (op == OP_MSUBF32_RRR);
                k.alu.mux[1]        = 2'b00;
                k.alu.mux[2]        = 2'b01;
            end

            // ==========================================================
            // Iki yazmacli: karsilastirma (a = MRa, b = MRb)
            // ==========================================================
            OP_MCMPF32_RR, OP_MMAXF32_RR, OP_MMINF32_RR: begin
                k.a_mr      = alan.ra;
                k.b_mr      = alan.rb;
                k.okunan_mr = mr_bit(alan.ra) | mr_bit(alan.rb);
                k.alu.mux[8] = 2'b00;
                k.alu.mux[9] = 2'b01;
                k.zn_kaynak  = ZN_KARSILASTIRMA;
                unique case (op)
                    OP_MCMPF32_RR: k.alu.karsilastirma_islem = 3'b000;
                    OP_MMAXF32_RR: k.alu.karsilastirma_islem = 3'b001;
                    default:       k.alu.karsilastirma_islem = 3'b010;  // MMINF32
                endcase
                if (op != OP_MCMPF32_RR) begin
                    k.exe_yaz    = 1'b1;
                    k.exe_hedef  = alan.ra;
                    k.exe_kaynak = EXE_KARSILASTIRMA;
                end
            end
            OP_MABSF32: begin                       // MRa = |MRb| (tek islenen mux_9'da)
                k.a_mr      = alan.rb;
                k.okunan_mr = mr_bit(alan.rb);
                k.alu.karsilastirma_islem = 3'b011;
                k.alu.mux[9] = 2'b00;
                k.exe_yaz    = 1'b1;
                k.exe_hedef  = alan.ra;
                k.exe_kaynak = EXE_KARSILASTIRMA;
                k.zn_kaynak  = ZN_KARSILASTIRMA;
            end

            // ==========================================================
            // Iki yazmacli: donusum (a = MRb), bayrak yok
            // ==========================================================
            OP_MF32TOI32, OP_MI32TOF32_RR, OP_MF32TOUI32, OP_MUI32TOF32_RR,
            OP_MF32TOI16, OP_MFRACF32, OP_MF32TOI16R, OP_MI16TOF32_RR,
            OP_MF32TOUI16, OP_MF32TOUI16R, OP_MUI16TOF32_RR: begin
                k.a_mr      = alan.rb;
                k.okunan_mr = mr_bit(alan.rb);
                k.alu.mux[10] = 2'b00;
                unique case (op)
                    OP_MF32TOI16:     k.alu.donusum_islem = 4'b0000;
                    OP_MF32TOI16R:    k.alu.donusum_islem = 4'b0001;
                    OP_MF32TOI32:     k.alu.donusum_islem = 4'b0010;
                    OP_MF32TOUI16:    k.alu.donusum_islem = 4'b0011;
                    OP_MF32TOUI16R:   k.alu.donusum_islem = 4'b0100;
                    OP_MF32TOUI32:    k.alu.donusum_islem = 4'b0101;
                    OP_MFRACF32:      k.alu.donusum_islem = 4'b0110;
                    OP_MI16TOF32_RR:  k.alu.donusum_islem = 4'b0111;
                    OP_MI32TOF32_RR:  k.alu.donusum_islem = 4'b1000;
                    OP_MUI16TOF32_RR: k.alu.donusum_islem = 4'b1001;
                    default:          k.alu.donusum_islem = 4'b1010;  // MUI32TOF32
                endcase
                k.exe_yaz    = 1'b1;
                k.exe_hedef  = alan.ra;
                k.exe_kaynak = EXE_DONUSUM;
            end

            // ==========================================================
            // Iki yazmacli: kestirme (a = MRb), LVF/LUF OR'lanir
            // ==========================================================
            OP_MEINVF32, OP_MEISQRTF32: begin
                k.a_mr      = alan.rb;
                k.okunan_mr = mr_bit(alan.rb);
                k.alu.kestirme_islem = (op == OP_MEISQRTF32);
                k.alu.mux[7]         = 2'b00;
                k.exe_yaz            = 1'b1;
                k.exe_hedef          = alan.ra;
                k.exe_kaynak         = EXE_KESTIRME;
                k.lvf_luf_kestirme   = 1'b1;
            end

            // ==========================================================
            // Islenen almayan / sistem
            // ==========================================================
            OP_MTESTTF:    k.tf_yaz     = 1'b1;
            OP_MDEBUGSTOP: k.mdebugstop = 1'b1;
            OP_MSTOP:      k.mstop      = 1'b1;
            OP_MEALLOW: begin
                k.meallow_yaz   = 1'b1;
                k.meallow_deger = 1'b1;
            end
            OP_MEDIS: begin
                k.meallow_yaz   = 1'b1;
                k.meallow_deger = 1'b0;
            end
            OP_MNOP: ;

            // ==========================================================
            // MAR yukleme (E)
            // ==========================================================
            OP_MMOVI16: begin                       // MARx = m
                k.mar_yukle  = 1'b1;
                k.mar_hedef  = alan.mar_x;
                k.mar_kaynak = MAR_IMM;
            end
            OP_MMOV16_MAR_MR: begin                 // MARx = MRa[15:0] + m
                k.okunan_mr  = mr_bit(alan.ra);
                k.mar_yukle  = 1'b1;
                k.mar_hedef  = alan.mar_x;
                k.mar_kaynak = MAR_MR_ARTI_IMM;
            end

            OP_GECERSIZ: ;
        endcase

        // Gecersiz buyruk (ya da ayrilmis adresleme kipi): hicbir sey yapma,
        // yalniz bildir. Boru hatti D2'de durur (RTL sartlari madde 8).
        if (op == OP_GECERSIZ || kip_gecersiz) begin
            k                        = '0;
            k.alu.karsilastirma_cndf = CNDF_UNCF;
            k.gecersiz               = 1'b1;
        end
    end

endmodule
