`timescale 1ns / 1ps

// MOD_CLA_DECODER : 32-bitlik CLA buyruk kelimesini kombinasyonel olarak çözen buyruk çözücü (Instruction Decoder)
//
//   Amaç:     L3 program belleğinden okunan 32-bitlik buyruğu (MSW [31:16] |
//             LSW [15:0]) unique casez yapısı ile paralel olarak
//             karşılaştırarak hangi buyruk olduğunu (op_e) belirler ve
//             buyruk formatına göre farklı bit konumlarında bulunan yazmaç
//             indeksleri (MRa..MRf), adresleme kipi, koşul kodu (cndf),
//             kaydırma miktarı ve 16-bit LSW (m) alanlarını standart
//             alanlar_t yapısına toplar.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           buyruk:         F2/D1 yazmacından gelen 32-bitlik ham buyruk
//                           kelimesi
//   Outputlar:
//           op:             Tanınan buyruk kimliği (op_e enum tipi; eşleşme
//                           yoksa OP_GECERSIZ)
//           gecersiz:       Buyruk hiçbir geçerli kodlamayla eşleşmediğinde 1
//                           olan bayrak
//           kip_gecersiz:   Bellek buyruğunda addr alanı 0011..1111 (ayrılmış
//                           kip) olduğunda 1 olan bayrak
//           alan:           Buyruktan çıkarılan standartlaştırılmış operand ve
//                           kontrol alanları (alanlar_t)
//
//   Notlar:
//           Tüm bit desenleri birbirinden ayrık olduğu için unique casez
//           kullanılmıştır; sentez aracı öncelik zinciri kurmak yerine tüm
//           desenleri paralel karşılaştırır.
//
//           Buyrukta açık bir CNDF alanı bulunmayan komutlarda alan.cndf
//           varsayılan olarak CNDF_UNCF (4'b1111) olarak atanır.

module cla_decoder
    import cla_pkg::*;
(
    input  logic [31:0] buyruk,       // MSW = [31:16], LSW = [15:0]

    output op_e         op,
    output logic        gecersiz,     // hicbir kodlamayla eslesmedi
    output logic        kip_gecersiz, // bellek buyrugunda addr = 0011..1111 (ayrilmis)
    output alanlar_t    alan
);

    // ------------------------------------------------------------------
    // 1) Taniyici
    // ------------------------------------------------------------------
    always_comb begin
        unique casez (buyruk)
            //            MSW [31:16]            LSW [15:0]
            // Paralel: FP || MMOV32  -> ffee ddaa addr | mmmm
            32'b0000_????_????_????_????_????_????_????: op = OP_MMPYF32_PAR_LD;
            32'b0001_????_????_????_????_????_????_????: op = OP_MADDF32_PAR_LD;
            32'b0010_????_????_????_????_????_????_????: op = OP_MSUBF32_PAR_LD;
            32'b0011_????_????_????_????_????_????_????: op = OP_MMACF32_PAR_LD;
            32'b0100_????_????_????_????_????_????_????: op = OP_MMPYF32_PAR_ST;
            32'b0101_????_????_????_????_????_????_????: op = OP_MADDF32_PAR_ST;
            32'b0110_????_????_????_????_????_????_????: op = OP_MSUBF32_PAR_ST;

            // Bellek  -> ..aa addr | mmmm
            32'b0111_00??_????_????_????_????_????_????: op = OP_MMOV32_MR_MEM;   // 00 cndf aa addr
            32'b0111_0100_00??_????_????_????_????_????: op = OP_MMOVD32;
            32'b0111_0100_01??_????_????_????_????_????: op = OP_MI32TOF32_MEM;
            32'b0111_0100_10??_????_????_????_????_????: op = OP_MUI32TOF32_MEM;
            32'b0111_0100_11??_????_????_????_????_????: op = OP_MMOV32_MEM_MR;
            32'b0111_0101_00??_????_????_????_????_????: op = OP_MI16TOF32_MEM;
            32'b0111_0101_01??_????_????_????_????_????: op = OP_MUI16TOF32_MEM;
            32'b0111_0101_10??_????_????_????_????_????: op = OP_MMOVZ16;
            32'b0111_0101_11??_????_????_????_????_????: op = OP_MMOV16_MEM_MR;
            32'b0111_0110_0?00_????_????_????_????_????: op = OP_MMOV16_MAR_MEM;  // bit 22 = MARx
            32'b0111_0110_1?00_????_????_????_????_????: op = OP_MMOV16_MEM_MAR;  // bit 22 = MARx
            32'b0111_0111_0000_????_????_????_????_????: op = OP_MMOV32_MSTF_MEM;
            32'b0111_0111_0100_????_????_????_????_????: op = OP_MMOV32_MEM_MSTF;

            // Anlik  -> bbaa | IIII
            32'b0111_0111_1000_????_????_????_????_????: op = OP_MMPYF32_IMM;
            32'b0111_0111_1100_????_????_????_????_????: op = OP_MADDF32_IMM;
            32'b0111_1000_0000_????_????_????_????_????: op = OP_MSUBF32_IMM;
            32'b0111_1000_0100_00??_????_????_????_????: op = OP_MMOVIZ;
            32'b0111_1000_1000_00??_????_????_????_????: op = OP_MMOVXI;
            32'b0111_1000_1100_00??_????_????_????_????: op = OP_MCMPF32_IMM;
            32'b0111_1001_0000_00??_????_????_????_????: op = OP_MMAXF32_IMM;
            32'b0111_1001_0100_00??_????_????_????_????: op = OP_MMINF32_IMM;

            // Akis kontrolu  -> cndf | dest
            32'b0111_1001_1000_????_????_????_????_????: op = OP_MBCNDD;
            32'b0111_1001_1001_????_????_????_????_????: op = OP_MCCNDD;
            32'b0111_1001_1010_????_0000_0000_0000_0000: op = OP_MRCNDD;
            32'b0111_1001_1100_0000_????_????_????_????: op = OP_MSETFLG;          // FLAG | VALUE

            // Paralel: MMPYF32 || MADDF32/MSUBF32  -> ffee ddcc bbaa
            32'b0111_1010_0000_0000_0000_????_????_????: op = OP_MMPYF32_PAR_ADD;
            32'b0111_1010_0100_0000_0000_????_????_????: op = OP_MMPYF32_PAR_SUB;

            // Kosullu yazmac  -> cndf bbaa
            32'b0111_1010_1000_0000_0000_0000_????_????: op = OP_MNEGF32;
            32'b0111_1010_1100_0000_0000_0000_????_????: op = OP_MMOV32_MR_MR;
            32'b0111_1011_0000_0000_0000_0000_????_????: op = OP_MSWAPF;

            // Kaydirma  -> 0 shift aa
            32'b0111_1011_0100_0000_0000_0000_0???_????: op = OP_MASR32;
            32'b0111_1011_1000_0000_0000_0000_0???_????: op = OP_MLSR32;
            32'b0111_1011_1100_0000_0000_0000_0???_????: op = OP_MLSL32;

            // Uc yazmac  -> 00cc bbaa
            32'b0111_1100_0000_0000_0000_0000_00??_????: op = OP_MMPYF32_RRR;
            32'b0111_1100_0010_0000_0000_0000_00??_????: op = OP_MADDF32_RRR;
            32'b0111_1100_0100_0000_0000_0000_00??_????: op = OP_MSUBF32_RRR;
            32'b0111_1100_0110_0000_0000_0000_00??_????: op = OP_MAND32;
            32'b0111_1100_1000_0000_0000_0000_00??_????: op = OP_MOR32;
            32'b0111_1100_1010_0000_0000_0000_00??_????: op = OP_MXOR32;
            32'b0111_1100_1100_0000_0000_0000_00??_????: op = OP_MADD32;
            32'b0111_1100_1110_0000_0000_0000_00??_????: op = OP_MSUB32;

            // Iki yazmac  -> bbaa
            32'b0111_1101_0000_0000_0000_0000_0000_????: op = OP_MCMPF32_RR;
            32'b0111_1101_0010_0000_0000_0000_0000_????: op = OP_MMAXF32_RR;
            32'b0111_1101_0100_0000_0000_0000_0000_????: op = OP_MMINF32_RR;
            32'b0111_1101_0110_0000_0000_0000_0000_????: op = OP_MF32TOI32;
            32'b0111_1101_1000_0000_0000_0000_0000_????: op = OP_MI32TOF32_RR;
            32'b0111_1101_1010_0000_0000_0000_0000_????: op = OP_MF32TOUI32;
            32'b0111_1101_1100_0000_0000_0000_0000_????: op = OP_MUI32TOF32_RR;
            32'b0111_1101_1110_0000_0000_0000_0000_????: op = OP_MF32TOI16;
            32'b0111_1110_0000_0000_0000_0000_0000_????: op = OP_MFRACF32;
            32'b0111_1110_0010_0000_0000_0000_0000_????: op = OP_MABSF32;
            32'b0111_1110_0100_0000_0000_0000_0000_????: op = OP_MEISQRTF32;
            32'b0111_1110_0110_0000_0000_0000_0000_????: op = OP_MF32TOI16R;
            32'b0111_1110_1000_0000_0000_0000_0000_????: op = OP_MI16TOF32_RR;
            32'b0111_1110_1010_0000_0000_0000_0000_????: op = OP_MF32TOUI16;
            32'b0111_1110_1100_0000_0000_0000_0000_????: op = OP_MF32TOUI16R;
            32'b0111_1110_1110_0000_0000_0000_0000_????: op = OP_MUI16TOF32_RR;
            32'b0111_1111_0000_0000_0000_0000_0000_????: op = OP_MEINVF32;
            32'b0111_1111_0010_0000_0000_0000_0000_????: op = OP_MCMP32;

            // Islenen almayan
            32'b0111_1111_0100_0000_0000_0000_0000_????: op = OP_MTESTTF;          // cndf
            32'b0111_1111_0110_0000_0000_0000_0000_0000: op = OP_MDEBUGSTOP;
            32'b0111_1111_1000_0000_0000_0000_0000_0000: op = OP_MSTOP;
            32'b0111_1111_1001_0000_0000_0000_0000_0000: op = OP_MEALLOW;
            32'b0111_1111_1010_0000_0000_0000_0000_0000: op = OP_MNOP;
            32'b0111_1111_1011_0000_0000_0000_0000_0000: op = OP_MEDIS;

            // MAR yukleme  -> bit 21 = MARx
            32'b0111_1111_11?0_0000_????_????_????_????: op = OP_MMOVI16;
            32'b0111_1111_11?1_00??_????_????_????_????: op = OP_MMOV16_MAR_MR;    // AA | IIII

            default:                                     op = OP_GECERSIZ;
        endcase
    end

    assign gecersiz = (op == OP_GECERSIZ);

    // ------------------------------------------------------------------
    // 2) Alan cikarici
    //
    // Once en yaygin konumlar varsayilan olarak atanir (yazmac formlari:
    // aa [1:0], bb [3:2], cc [5:4], dd [7:6], ee [9:8], ff [11:10]).
    // Alanlari baska yerde duran buyruk gruplari asagida ezilir.
    // ------------------------------------------------------------------
    always_comb begin
        alan.ra       = buyruk[1:0];
        alan.rb       = buyruk[3:2];
        alan.rc       = buyruk[5:4];
        alan.rd       = buyruk[7:6];
        alan.re       = buyruk[9:8];
        alan.rf       = buyruk[11:10];
        alan.mar_x    = 1'b0;
        alan.addr_kip = buyruk[19:16];
        alan.cndf     = CNDF_UNCF;
        alan.shift    = {1'b0, buyruk[6:2]} + 6'd1;   // alan 0 -> 1 bit, 31 -> 32 bit
        alan.m        = buyruk[15:0];

        case (op)
            // Paralel FP || MMOV32: ff ee dd aa MSW'de
            OP_MMPYF32_PAR_LD, OP_MADDF32_PAR_LD, OP_MSUBF32_PAR_LD, OP_MMACF32_PAR_LD,
            OP_MMPYF32_PAR_ST, OP_MADDF32_PAR_ST, OP_MSUBF32_PAR_ST: begin
                alan.ra = buyruk[21:20];
                alan.rd = buyruk[23:22];
                alan.re = buyruk[25:24];
                alan.rf = buyruk[27:26];
            end

            // MMOV32 MRa, mem32 {,CNDF}: cndf [25:22], aa [21:20]
            OP_MMOV32_MR_MEM: begin
                alan.ra   = buyruk[21:20];
                alan.cndf = buyruk[25:22];
            end

            // Diger MRa'li bellek buyruklari: aa [21:20]
            OP_MMOVD32, OP_MI32TOF32_MEM, OP_MUI32TOF32_MEM, OP_MMOV32_MEM_MR,
            OP_MI16TOF32_MEM, OP_MUI16TOF32_MEM, OP_MMOVZ16, OP_MMOV16_MEM_MR: begin
                alan.ra = buyruk[21:20];
            end

            // MAR <-> bellek: MARx secimi bit 22
            OP_MMOV16_MAR_MEM, OP_MMOV16_MEM_MAR: begin
                alan.mar_x = buyruk[22];
            end

            // FP anlik formlari: bb [19:18], aa [17:16]
            OP_MMPYF32_IMM, OP_MADDF32_IMM, OP_MSUBF32_IMM: begin
                alan.ra = buyruk[17:16];
                alan.rb = buyruk[19:18];
            end

            // Tek yazmacli anlik formlar: aa [17:16]
            OP_MMOVIZ, OP_MMOVXI, OP_MCMPF32_IMM, OP_MMAXF32_IMM, OP_MMINF32_IMM: begin
                alan.ra = buyruk[17:16];
            end

            // Dallanmalar: cndf [19:16]
            OP_MBCNDD, OP_MCCNDD, OP_MRCNDD: begin
                alan.cndf = buyruk[19:16];
            end

            // Kosullu yazmac islemleri: cndf [7:4]
            OP_MNEGF32, OP_MMOV32_MR_MR, OP_MSWAPF: begin
                alan.cndf = buyruk[7:4];
            end

            OP_MTESTTF: begin
                alan.cndf = buyruk[3:0];
            end

            // MAR anlik yukleme: MARx secimi bit 21, AA [17:16]
            OP_MMOVI16: begin
                alan.mar_x = buyruk[21];
            end
            OP_MMOV16_MAR_MR: begin
                alan.mar_x = buyruk[21];
                alan.ra    = buyruk[17:16];
            end

            default: ;
        endcase
    end

    // ------------------------------------------------------------------
    // Ayrilmis adresleme kipi
    //
    // Maske addr alanini kapsamadigi icin taniyici bu buyruklari yine
    // tanir; kipin gecerli olup olmadigini ayrica bildiriyoruz. Ne
    // yapilacagina (gecersiz opcode gibi durmak mi?) kontrol birimi karar
    // verir.
    // ------------------------------------------------------------------
    logic bellek_adresler;

    always_comb begin
        case (op)
            OP_MMPYF32_PAR_LD, OP_MADDF32_PAR_LD, OP_MSUBF32_PAR_LD, OP_MMACF32_PAR_LD,
            OP_MMPYF32_PAR_ST, OP_MADDF32_PAR_ST, OP_MSUBF32_PAR_ST,
            OP_MMOV32_MR_MEM, OP_MMOVD32, OP_MI32TOF32_MEM, OP_MUI32TOF32_MEM,
            OP_MMOV32_MEM_MR, OP_MI16TOF32_MEM, OP_MUI16TOF32_MEM, OP_MMOVZ16,
            OP_MMOV16_MEM_MR, OP_MMOV16_MAR_MEM, OP_MMOV16_MEM_MAR,
            OP_MMOV32_MSTF_MEM, OP_MMOV32_MEM_MSTF:
                bellek_adresler = 1'b1;
            default:
                bellek_adresler = 1'b0;
        endcase
    end

    assign kip_gecersiz = bellek_adresler &&
                          (alan.addr_kip != KIP_DOGRUDAN) &&
                          (alan.addr_kip != KIP_MAR0) &&
                          (alan.addr_kip != KIP_MAR1);

endmodule
