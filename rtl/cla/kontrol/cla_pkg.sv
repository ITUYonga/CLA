`timescale 1ns / 1ps

// PKG_CLA_PKG : CLA boru hattı, buyruk çözücü ve kontrol üretici tarafından paylaşılan veri tipleri ve sabitler paketi
//
//   Amaç:     TI TMS320F2803x Type-0 CLA (SPRUI10A Bölüm 10) mimarisinin 78
//             buyruk kodlamasını temsil eden 75 elemanlı op_e enum tipini,
//             koşul kodlarını (CNDF_*), adresleme kiplerini (KIP_*), çözücü
//             alan yapısını (alanlar_t), ALU kontrol yapısını
//             (alu_kontrol_t) ve D2'den W'ye taşınan statik kontrol paketini
//             (kontrol_t) tanımlar.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           yok
//   Outputlar:
//           yok
//
//   Notlar:
//           MAR0 ve MAR1 hedefli 4 çift buyruk aynı op_e kimliğini
//           paylaşır ve hedef yazmaç alanlar_t.mar_x bitiyle ayrılır;
//           böylece 78 YAML kodlaması 74 tekil buyruk + OP_GECERSIZ olarak
//           temsil edilir.
//
//           kontrol_t yapısı yalnızca buyruktan çıkan statik bilgileri
//           taşır; RND32, görünen MSTF bayrakları ve duraklatma sinyalleri
//           gibi dinamik bilgiler boru hattı aşamalarında eklenir.

package cla_pkg;

    // ------------------------------------------------------------------
    // Buyruk kimligi (op_e)
    //
    // YAML'da 78 kodlama var. MAR0/MAR1 formlari (4 cift) ayni isleri
    // yapiyor, sadece hedef MAR farkli; onlari tek kimlikte topluyoruz ve
    // hangi MAR oldugunu alan.mar_x tasiyor. Sonuc: 74 buyruk + GECERSIZ.
    //
    // Ek isimleri:
    //   _RR / _RRR   yazmac formu (2 / 3 yazmac)
    //   _IMM         anlik (#16FHi) formu
    //   _MEM         bellekten okuyan form
    //   _PAR_LD/_ST  paralel form: "|| MMOV32 MRa, mem32" (LD) ya da
    //                "|| MMOV32 mem32, MRa" (ST)
    // ------------------------------------------------------------------
    typedef enum logic [6:0] {
        OP_GECERSIZ = 7'd0,      // hicbir kodlamayla eslesmedi

        // Paralel: FP islem || bellek tasima          (MSW[31:28] = 0000..0110)
        OP_MMPYF32_PAR_LD,       // MMPYF32 MRd,MRe,MRf || MMOV32 MRa,mem32
        OP_MADDF32_PAR_LD,       // MADDF32 MRd,MRe,MRf || MMOV32 MRa,mem32
        OP_MSUBF32_PAR_LD,       // MSUBF32 MRd,MRe,MRf || MMOV32 MRa,mem32
        OP_MMACF32_PAR_LD,       // MMACF32 MR3,MR2,MRd,MRe,MRf || MMOV32 MRa,mem32
        OP_MMPYF32_PAR_ST,       // MMPYF32 MRd,MRe,MRf || MMOV32 mem32,MRa
        OP_MADDF32_PAR_ST,       // MADDF32 MRd,MRe,MRf || MMOV32 mem32,MRa
        OP_MSUBF32_PAR_ST,       // MSUBF32 MRd,MRe,MRf || MMOV32 mem32,MRa

        // Bellek erisimi                                (0x70xx .. 0x77xx)
        OP_MMOV32_MR_MEM,        // MMOV32 MRa, mem32 {,CNDF}
        OP_MMOVD32,              // MMOVD32 MRa, mem32
        OP_MI32TOF32_MEM,        // MI32TOF32 MRa, mem32
        OP_MUI32TOF32_MEM,       // MUI32TOF32 MRa, mem32
        OP_MMOV32_MEM_MR,        // MMOV32 mem32, MRa
        OP_MI16TOF32_MEM,        // MI16TOF32 MRa, mem16
        OP_MUI16TOF32_MEM,       // MUI16TOF32 MRa, mem16
        OP_MMOVZ16,              // MMOVZ16 MRa, mem16
        OP_MMOV16_MEM_MR,        // MMOV16 mem16, MRa
        OP_MMOV16_MAR_MEM,       // MMOV16 MARx, mem16
        OP_MMOV16_MEM_MAR,       // MMOV16 mem16, MARx
        OP_MMOV32_MSTF_MEM,      // MMOV32 MSTF, mem32
        OP_MMOV32_MEM_MSTF,      // MMOV32 mem32, MSTF

        // Anlik (#16) formlari
        OP_MMPYF32_IMM,          // MMPYF32 MRa, #16FHi, MRb
        OP_MADDF32_IMM,          // MADDF32 MRa, #16FHi, MRb
        OP_MSUBF32_IMM,          // MSUBF32 MRa, #16FHi, MRb
        OP_MMOVIZ,               // MMOVIZ MRa, #16FHi
        OP_MMOVXI,               // MMOVXI MRa, #16FLoHex
        OP_MCMPF32_IMM,          // MCMPF32 MRa, #16FHi
        OP_MMAXF32_IMM,          // MMAXF32 MRa, #16FHi
        OP_MMINF32_IMM,          // MMINF32 MRa, #16FHi

        // Akis kontrolu ve bayrak
        OP_MBCNDD,               // MBCNDD 16BitDest {,CNDF}
        OP_MCCNDD,               // MCCNDD 16BitDest {,CNDF}
        OP_MRCNDD,               // MRCNDD {CNDF}
        OP_MSETFLG,              // MSETFLG FLAG, VALUE

        // Paralel: FP islem || FP islem
        OP_MMPYF32_PAR_ADD,      // MMPYF32 MRa,MRb,MRc || MADDF32 MRd,MRe,MRf
        OP_MMPYF32_PAR_SUB,      // MMPYF32 MRa,MRb,MRc || MSUBF32 MRd,MRe,MRf

        // Kosullu yazmac islemleri ve kaydirma
        OP_MNEGF32,              // MNEGF32 MRa, MRb {,CNDF}
        OP_MMOV32_MR_MR,         // MMOV32 MRa, MRb {,CNDF}
        OP_MSWAPF,               // MSWAPF MRa, MRb {,CNDF}
        OP_MASR32,               // MASR32 MRa, #SHIFT
        OP_MLSR32,               // MLSR32 MRa, #SHIFT
        OP_MLSL32,               // MLSL32 MRa, #SHIFT

        // Uc yazmacli                                    (0x7C00 .. 0x7CE0)
        OP_MMPYF32_RRR,
        OP_MADDF32_RRR,
        OP_MSUBF32_RRR,
        OP_MAND32,
        OP_MOR32,
        OP_MXOR32,
        OP_MADD32,
        OP_MSUB32,

        // Iki yazmacli                                   (0x7D00 .. 0x7F20)
        OP_MCMPF32_RR,
        OP_MMAXF32_RR,
        OP_MMINF32_RR,
        OP_MF32TOI32,
        OP_MI32TOF32_RR,
        OP_MF32TOUI32,
        OP_MUI32TOF32_RR,
        OP_MF32TOI16,
        OP_MFRACF32,
        OP_MABSF32,
        OP_MEISQRTF32,
        OP_MF32TOI16R,
        OP_MI16TOF32_RR,
        OP_MF32TOUI16,
        OP_MF32TOUI16R,
        OP_MUI16TOF32_RR,
        OP_MEINVF32,
        OP_MCMP32,

        // Islenen almayan / sistem
        OP_MTESTTF,              // MTESTTF CNDF
        OP_MDEBUGSTOP,
        OP_MSTOP,
        OP_MEALLOW,
        OP_MNOP,
        OP_MEDIS,

        // MAR yukleme (anlik)
        OP_MMOVI16,              // MMOVI16 MARx, #16I
        OP_MMOV16_MAR_MR         // MMOV16 MARx, MRa, #16I
    } op_e;

    // ------------------------------------------------------------------
    // CNDF kodlari (TRM Tablo 10-9). 0110..1001 ayrilmis.
    // ------------------------------------------------------------------
    localparam logic [3:0] CNDF_NEQ  = 4'b0000;  // ZF = 0
    localparam logic [3:0] CNDF_EQ   = 4'b0001;  // ZF = 1
    localparam logic [3:0] CNDF_GT   = 4'b0010;  // ZF = 0 ve NF = 0
    localparam logic [3:0] CNDF_GEQ  = 4'b0011;  // NF = 0
    localparam logic [3:0] CNDF_LT   = 4'b0100;  // NF = 1
    localparam logic [3:0] CNDF_LEQ  = 4'b0101;  // ZF = 1 ya da NF = 1
    localparam logic [3:0] CNDF_TF   = 4'b1010;  // TF = 1
    localparam logic [3:0] CNDF_NTF  = 4'b1011;  // TF = 0
    localparam logic [3:0] CNDF_LU   = 4'b1100;  // LUF = 1
    localparam logic [3:0] CNDF_LV   = 4'b1101;  // LVF = 1
    localparam logic [3:0] CNDF_UNC  = 4'b1110;  // her zaman
    localparam logic [3:0] CNDF_UNCF = 4'b1111;  // her zaman, ZF/NF de yazilir

    // ------------------------------------------------------------------
    // Adresleme kipi: addr alani (TRM Tablo 10-6). 0011..1111 ayrilmis.
    // ------------------------------------------------------------------
    localparam logic [3:0] KIP_DOGRUDAN = 4'b0000;  // adres = m
    localparam logic [3:0] KIP_MAR0     = 4'b0001;  // adres = MAR0, sonra MAR0 += m
    localparam logic [3:0] KIP_MAR1     = 4'b0010;  // adres = MAR1, sonra MAR1 += m

    // ------------------------------------------------------------------
    // Decoder'in cikardigi alanlar.
    //
    // Ayni alan buyruga gore farkli bitlerde durur (ornegin MRa bazen
    // [1:0], bazen [17:16], bazen [21:20]). Decoder bunlari tek bir yere
    // toplar; boylece kontrol birimi bitlerin nerede oldugunu bilmek
    // zorunda kalmaz.
    //
    // Buyrukta olmayan alanin degeri onemsizdir; kontrol birimi o alani
    // kullanip kullanmayacagina op'a bakarak karar verir.
    // ------------------------------------------------------------------
    typedef struct packed {
        logic [1:0]  ra;        // MRa (MMOV16 MARx,MRa,#16I'deki "AA" dahil)
        logic [1:0]  rb;        // MRb
        logic [1:0]  rc;        // MRc
        logic [1:0]  rd;        // MRd
        logic [1:0]  re;        // MRe
        logic [1:0]  rf;        // MRf
        logic        mar_x;     // MARx buyruklarinda 0: MAR0, 1: MAR1
        logic [3:0]  addr_kip;  // bellek buyruklarinda adresleme kipi
        logic [3:0]  cndf;      // kosul; buyrukta CNDF yoksa UNCF
        logic [5:0]  shift;     // kaydirma miktari 1..32 (alan + 1)
        logic [15:0] m;         // LSW: mem adresi / MAR ofseti, #16 anlik,
                                // dallanma ofseti, MSETFLG {FLAG, VALUE}
    } alanlar_t;

    // ==================================================================
    // KONTROL PAKETI
    //
    // Kontrol uretici (cla_ctrl_gen) D2'de op + alan'dan bu paketi
    // uretir. Paket buyrukla birlikte boru hatti yazmaclarinda R1, R2, E
    // ve W'ye tasinir; her kademe kendi grubunu kullanir.
    //
    // Pakette yalniz STATIK bilgi var: buyrugun kendisinden cikan,
    // calisma anina bagli olmayan kararlar. Su dinamik bilgiler pakete
    // girmez, ust modulde eklenir:
    //   - RND32 (MSTF'den), FPU valid'lerinin gecerli/dur_exe ile AND'i
    //   - mstf_in (gorunen bayraklar), kosullarin o anki sonucu
    //   - bellek durmasi, dur_exe, dallanmanin alinip alinmadigi
    //
    // Kaynaklar: ALU_Kontrol_Referansi (port duzeni, 17 kontrol girisi),
    //            golden model erisim.py (bellek/MAR kumeleri), ops_*.py
    // ==================================================================

    // Bellek erisimi. Kodlama Arda'nin cla_data_ram rd_en/wr_en'i ile ayni:
    // 01 = 16 bit, 11 = 32 bit.
    typedef enum logic [1:0] {
        ERISIM_YOK = 2'b00,
        ERISIM_16  = 2'b01,
        ERISIM_32  = 2'b11
    } erisim_e;

    // ALU d portuna ne konacak (a, b, c portlari her zaman bir MR'dir)
    typedef enum logic [1:0] {
        D_MR     = 2'd0,   // MR[d_mr]
        D_IMM_HI = 2'd1,   // {m, 16'h0}        #16FHi
        D_SHIFT  = 2'd2,   // {26'b0, shift}    #SHIFT (1..32)
        D_BELLEK = 2'd3    // R2'de okunan veri (16 bitte ust yari 0)
    } d_kaynak_e;

    // E'de MR'ye yazilan verinin kaynagi
    typedef enum logic [2:0] {
        EXE_TAMSAYI       = 3'd0,  // result_tamsayi
        EXE_KESTIRME      = 3'd1,  // result_kestirme
        EXE_KARSILASTIRMA = 3'd2,  // result_karsilastirma
        EXE_DONUSUM       = 3'd3,  // result_donusum
        EXE_BELLEK        = 3'd4,  // R2'de okunan veri (MMOVZ16'da ust yari 0)
        EXE_IMM_HI        = 3'd5,  // {m, 16'h0}                 MMOVIZ
        EXE_IMM_LO        = 3'd6,  // {MR[hedef][31:16], m}      MMOVXI
        EXE_MR            = 3'd7   // MR[exe_kaynak_mr]          MMOV32 MRa,MRb / MSWAPF
    } exe_kaynak_e;

    // E'de MAR'a yuklenen verinin kaynagi
    typedef enum logic [1:0] {
        MAR_IMM         = 2'd0,    // m                           MMOVI16
        MAR_MR_ARTI_IMM = 2'd1,    // MR[ra][15:0] + m (16 bit)   MMOV16 MARx, MRa, #16I
        MAR_BELLEK      = 2'd2     // R2'de okunan 16 bit         MMOV16 MARx, mem16
    } mar_kaynak_e;

    // E'de ZF/NF nereden yazilacak
    typedef enum logic [2:0] {
        ZN_YOK             = 3'd0,
        ZN_TAMSAYI         = 3'd1,  // ALU mstf_out[3:2]
        ZN_KARSILASTIRMA   = 3'd2,  // zf_/nf_karsilastirma
        ZN_YAZILAN_FLOAT   = 3'd3,  // MR'ye yazilan deger, float kurali:
                                    //   ZF = ust (exp) 0, NF = isaret ve ZF degil
        ZN_YAZILAN_TAMSAYI = 3'd4   // MR'ye yazilan deger, tamsayi kurali (MMOVZ16)
    } zn_kaynak_e;

    // W'de bellege yazilan verinin kaynagi
    typedef enum logic [1:0] {
        VERI_MR     = 2'd0,  // MR[ra] (16 bitte alt yari)
        VERI_MAR    = 2'd1,  // {16'h0, MAR[mar_hedef]}
        VERI_MSTF   = 2'd2,  // gorunen MSTF
        VERI_BELLEK = 2'd3   // R2'de okunan veri (MMOVD32)
    } yaz_veri_e;

    // D2'de akis kontrolu
    typedef enum logic [1:0] {
        DAL_YOK    = 2'd0,
        DAL_MBCNDD = 2'd1,   // kosul tutarsa MPC = pc + m
        DAL_MCCNDD = 2'd2,   // kosul tutarsa RPC = pc + 8, MPC = pc + m
        DAL_MRCNDD = 2'd3    // kosul tutarsa MPC = RPC
    } dal_e;

    // ALU kontrolleri. Bicim ALU.sv ile ayni; RND32 ve valid'in dinamik
    // kismi ust modulde eklenir:
    //   topla_cntrl   = {topla_hedef, RND32, topla_kullan & gecerli & ~dur_exe, topla_cikarma}
    //   carpma_cntrl  = {carp_hedef,  RND32, carp_kullan  & gecerli & ~dur_exe, 1'b0}
    //   donusum_cntrl = {RND32, donusum_islem}
    typedef struct packed {
        logic             topla_kullan;
        logic [1:0]       topla_hedef;
        logic             topla_cikarma;      // 0: 1.+2., 1: 1.-2.
        logic             carp_kullan;
        logic [1:0]       carp_hedef;
        logic [2:0]       tamsayi_islem;
        logic             kestirme_islem;     // 0: MEINVF32, 1: MEISQRTF32
        logic [2:0]       karsilastirma_islem;
        logic [3:0]       karsilastirma_cndf; // MNEGF32 disinda UNCF
        logic [3:0]       donusum_islem;
        logic [10:1][1:0] mux;                // mux[1] .. mux[10]; 00 a, 01 b, 10 c, 11 d
    } alu_kontrol_t;

    typedef struct packed {
        // ---------------- D2: adres ve akis ----------------
        logic          gecersiz;      // gecersiz opcode ya da ayrilmis addr kipi
        logic          bellek_adres;  // efektif adres uretilecek (addr_kip, m);
                                      // kip MAR0/MAR1 ise D2'de MARx += m
        dal_e          dal;
        logic          mstop;         // gorev sonu
        logic          mdebugstop;    // kesme noktalari kapaliyken MNOP gibi
        logic [3:0]    kosul;         // CNDF (dallanma, kosullu yazma, MTESTTF)

        // ---------------- R1/R2: bellek okuma ----------------
        erisim_e       bellek_oku;

        // ---------------- E: ALU ve portlar ----------------
        alu_kontrol_t  alu;
        logic [1:0]    a_mr;          // a portu = MR[a_mr]
        logic [1:0]    b_mr;
        logic [1:0]    c_mr;
        d_kaynak_e     d_kaynak;
        logic [1:0]    d_mr;          // d_kaynak = D_MR ise
        logic [3:0]    okunan_mr;     // E'de okunan MR'ler (bit x = MRx); dur_exe icin

        // ---------------- E: MR yazma ----------------
        logic          exe_yaz;
        logic [1:0]    exe_hedef;
        exe_kaynak_e   exe_kaynak;
        logic [1:0]    exe_kaynak_mr;   // exe_kaynak = EXE_MR ise
        logic          exe_yaz_2;       // ikinci yazma (yalniz MSWAPF):
        logic [1:0]    exe_hedef_2;     //   MR[exe_hedef_2] <= MR[exe_kaynak_mr_2]
        logic [1:0]    exe_kaynak_mr_2;
        logic          exe_kosullu;     // yazmalar yalniz kosul tutarsa

        // ---------------- E: MAR yukleme ----------------
        logic          mar_yukle;
        logic          mar_hedef;     // 0: MAR0, 1: MAR1 (VERI_MAR'da okunan MAR da bu)
        mar_kaynak_e   mar_kaynak;

        // ---------------- E: MSTF ----------------
        zn_kaynak_e    zn_kaynak;        // CNDF != UNCF ise zaten ZN_YOK verilir
        logic          lvf_luf_kestirme; // LVF/LUF |= kestirme bayraklari
        logic          tf_yaz;           // MTESTTF: TF <= kosul sonucu
        logic          meallow_yaz;
        logic          meallow_deger;    // 1: MEALLOW, 0: MEDIS
        logic          msetflg;          // m = {FLAG, VALUE}
        logic          mstf_yukle;       // MMOV32 MSTF, mem32

        // ---------------- W: bellek yazma ----------------
        erisim_e       bellek_yaz;
        yaz_veri_e     yaz_veri;
        logic          yaz_adres_arti2;  // MMOVD32: [adres + 2] <= [adres]
    } kontrol_t;

endpackage
