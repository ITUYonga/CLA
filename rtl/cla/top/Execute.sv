`timescale 1ns / 1ps

// MOD_EXECUTE : Boru hattının 7. aşaması (E); operand seçimi, tek çevrimlik ALU/FPU işlemleri ve 2 aşamalı FPU'nun K1 kademesini yürütür
//
//   Amaç:     MR0-MR3 yazmaçlarından, bellekten veya anlık (immediate)
//             alanlardan ALU operandlarını (a, b, c, d) hazırlar ve ALU
//             modülünü sürer. Tamsayı işlemleri, karşılaştırma, tip
//             dönüşümü, LUT tabanlı kestirim (1/x, 1/sqrt(x)), bellekten
//             yükleme (MMOV32/MMOVZ16), MAR yükleme ve MSTF bayrak
//             güncellemelerini bu aşamada tamamlar; 2 aşamalı FP32 toplama
//             ve çarpmanın ise ilk aşamasını (K1) başlatıp K2 sonuçlarını
//             Write aşamasına aktarır.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           clk:            Sistem saati
//           rst_n:          Aktif-düşük sıfırlama sinyali
//           gecerli:        R2/E yazmacından gelen buyruk geçerlilik biti
//           pc:             R2/E yazmacından gelen 12-bit program sayacı
//           ea:             16-bit etkin bellek adresi
//           m:              16-bit anlık veri / ofset alanı
//           shift:          6-bit kaydırma miktarı
//           okunan:         R2 aşamasından gelen 32-bit bellek verisi
//           mar_d2:         D2 aşamasında yakalanan artış öncesi 16-bit MAR
//                           değeri
//           veri_mr:        Belleğe yazılacak veya MAR'a eklenecek MR indeksi
//                           (MRa)
//           kosul:          Koşullu buyruklar için 4-bitlik CNDF koşul kodu
//           alu:            ALU alt birimlerini yönlendiren kontrol yapısı
//                           (alu_kontrol_t)
//           a_mr:           ALU a portuna bağlanacak MR seçicisi
//           b_mr:           ALU b portuna bağlanacak MR seçicisi
//           c_mr:           ALU c portuna bağlanacak MR seçicisi
//           d_mr:           ALU d portuna bağlanacak MR seçicisi (d_kaynak ==
//                           D_MR iken)
//           d_kaynak:       ALU d portu veri kaynağı seçicisi (MR, #16FHi,
//                           #SHIFT, Bellek)
//           exe_yaz:        E aşaması sonunda 1. MR yazma portunun etkin
//                           olduğunu belirten bit
//           exe_hedef:      E aşaması 1. yazma portunun hedef MR indeksi
//           exe_kaynak:     E aşaması 1. yazma portunun veri kaynağı seçicisi
//                           (exe_kaynak_e)
//           exe_kaynak_mr:  MMOV32 MRa,MRb ve MSWAPF için kaynak MR indeksi
//           exe_yaz_2:      MSWAPF buyruğunda 2. MR yazma portunun etkin
//                           olduğunu belirten bit
//           exe_hedef_2:    E aşaması 2. yazma portunun hedef MR indeksi
//           exe_kaynak_mr_2: E aşaması 2. yazma portunun kaynak MR indeksi
//           exe_kosullu:    Yazmaç yazımının CNDF koşuluna bağlı olduğunu
//                           belirten bit
//           mar_yukle:      MMOVI16 / MMOV16 buyruklarında MAR yazmacına
//                           yükleme izni
//           mar_hedef:      Yüklenecek hedef MAR seçimi (0: MAR0, 1: MAR1)
//           mar_kaynak:     MAR'a yüklenecek verinin kaynağı (anlık, MR+anlık,
//                           bellek)
//           zn_kaynak:      MSTF ZF/NF bayraklarının hangi kaynaktan
//                           güncelleneceğini seçen kod
//           lvf_luf_kestirme: Kestirim biriminin LVF/LUF taşma bayraklarını
//                             MSTF'ye yazma izni
//           tf_yaz:         MTESTTF buyruğunda TF bayrağını güncelleme izni
//           meallow_yaz:    MEALLOW/MEDIS buyruklarında MEALLOW bitini
//                           güncelleme izni
//           meallow_deger:  MEALLOW bitine yazılacak değer (1: MEALLOW, 0:
//                           MEDIS)
//           msetflg:        MSETFLG buyruğu ile bayrakların maskeli
//                           güncelleneceğini belirten bit
//           mstf_yukle:     MMOV32 MSTF, mem32 buyruğu ile MSTF'nin bellekten
//                           yükleneceğini belirten bit
//           bellek_yaz:     W aşamasında yapılacak bellek yazma tipi (00:yok,
//                           01:16-bit, 11:32-bit)
//           yaz_veri:       Belleğe yazılacak verinin kaynağı (MR, MAR, MSTF,
//                           Bellek/MMOVD32)
//           yaz_adres_arti2: MMOVD32 buyruğunda okunan verinin ea + 2 adresine
//                            yazılacağını belirten bit
//           mr0_out:        MR0 yazmacının güncel 32-bit değeri
//           mr1_out:        MR1 yazmacının güncel 32-bit değeri
//           mr2_out:        MR2 yazmacının güncel 32-bit değeri
//           mr3_out:        MR3 yazmacının güncel 32-bit değeri
//           rnd32:          MSTF yazmacındaki RND32 yuvarlama modu biti
//           gorunen_5:      W aşamasından yönlendirilen 5-bitlik güncel
//                           bayraklar ({TF, ZF, NF, LUF, LVF})
//           gorunen_32:     MMOV32 mem32, MSTF için W aşamasından
//                           yönlendirilen 32-bit MSTF değeri
//           dur_exe:        RAW bağımlılığı nedeniyle E aşamasını 1 çevrim
//                           bekleten sinyal
//           dondur:         Geçersiz buyruk durumunda boru hattını donduran
//                           sinyal
//   Outputlar:
//           e_yaz1:         Write modülündeki 1. E yazma portuna giden yazma
//                           izni
//           e_hedef1:       1. E yazma portunun 2-bitlik hedef MR adresi
//           e_veri1:        1. E yazma portunun 32-bitlik yazma verisi
//           e_yaz2:         Write modülündeki 2. E yazma portuna giden yazma
//                           izni (MSWAPF)
//           e_hedef2:       2. E yazma portunun 2-bitlik hedef MR adresi
//           e_veri_2:       2. E yazma portunun 32-bitlik yazma verisi
//           mar_veri:       MAR yazmacına yüklenecek 16-bit veri
//           mar_sec:        Yüklenecek MAR seçimi (0: MAR0, 1: MAR1)
//           mar_en:         MAR yazmacı yükleme etkinleştirme sinyali
//           e_mstf_veri:    E aşamasının MSTF alanlarına yazacağı 19-bitlik
//                           paket ({RPC, MEALLOW, RND32, TF, ZF, NF, LUF,
//                           LVF})
//           e_mstf_maske:   E aşamasının değiştireceği MSTF bitlerini
//                           belirleyen 19-bitlik maske
//           w_gecerli:      E/W boru hattı yazmacına aktarılan geçerlilik biti
//           w_pc:           E/W boru hattı yazmacına aktarılan 12-bit program
//                           sayacı
//           w_bellek_yaz:   W aşamasında uygulanacak bellek yazma izni (2'b01
//                           veya 2'b11)
//           w_adr:          W aşamasında belleğe yazılacak 16-bit etkin adres
//                           (ea veya ea + 2)
//           w_veri:         W aşamasında belleğe yazılacak 32-bit veri
//           result_topla:   ALU içindeki 2 aşamalı FP32 toplayıcının K2
//                           aşaması 32-bit sonucu
//           lvf_topla:      FP32 toplayıcı K2 aşaması taşma (overflow) bayrağı
//           luf_topla:      FP32 toplayıcı K2 aşaması alt-taşma (underflow)
//                           bayrağı
//           valid_topla:    FP32 toplayıcı K2 sonucunun bu çevrimde geçerli
//                           olduğunu belirten bit
//           hedef_mr_out_topla: FP32 toplayıcı K2 sonucunun yazılacağı 2-bit
//                               hedef MR adresi
//           result_carp:    ALU içindeki 2 aşamalı FP32 çarpıcının K2 aşaması
//                           32-bit sonucu
//           lvf_carp:       FP32 çarpıcı K2 aşaması taşma (overflow) bayrağı
//           luf_carp:       FP32 çarpıcı K2 aşaması alt-taşma (underflow)
//                           bayrağı
//           valid_carp:     FP32 çarpıcı K2 sonucunun bu çevrimde geçerli
//                           olduğunu belirten bit
//           hedef_mr_out_carp: FP32 çarpıcı K2 sonucunun yazılacağı 2-bit
//                              hedef MR adresi
//
//   Notlar:
//           FP32 toplama ve çarpma birimlerinin içindeki K yazmacı (K1->K2
//           boru hattı yazmacı) ALU modülünün içinde yer alır; valid
//           sinyalleri e_ilerle ile kapılanarak dur_exe sırasında K2'ye
//           sahte işlem sızması engellenir.
//
//           MMOVD32 buyruğu R2'de okunan 32-bit veriyi hem hedef MR
//           yazmacına yazar hem de yaz_adres_arti2 = 1 ile bir sonraki
//           bellek adresine (ea + 2) geri yazar (gecikme hattı
//           kaydırması).

module Execute
    import cla_pkg::*;
(
                input logic clk ,
                input logic rst_n ,

                //////////////R2/E yazmacindan gelenler
                input logic gecerli ,
                input logic [11:0]pc ,
                input logic [15:0]ea ,
                input logic [15:0]m ,
                input logic [5:0]shift ,
                input logic [31:0]okunan ,
                input logic [15:0]mar_d2 ,              // D2'de okunan MAR[mar_hedef] (D2'deki artistan once)
                input logic [1:0]veri_mr ,              // saklanan / MAR'a eklenen MR (MRa)
                input logic [3:0]kosul ,
                input alu_kontrol_t alu ,
                input logic [1:0]a_mr ,
                input logic [1:0]b_mr ,
                input logic [1:0]c_mr ,
                input logic [1:0]d_mr ,
                input logic [1:0]d_kaynak ,
                input logic exe_yaz ,
                input logic [1:0]exe_hedef ,
                input logic [2:0]exe_kaynak ,
                input logic [1:0]exe_kaynak_mr ,
                input logic exe_yaz_2 ,
                input logic [1:0]exe_hedef_2 ,
                input logic [1:0]exe_kaynak_mr_2 ,
                input logic exe_kosullu ,
                input logic mar_yukle ,
                input logic mar_hedef ,
                input logic [1:0]mar_kaynak ,
                input logic [2:0]zn_kaynak ,
                input logic lvf_luf_kestirme ,
                input logic tf_yaz ,
                input logic meallow_yaz ,
                input logic meallow_deger ,
                input logic msetflg ,
                input logic mstf_yukle ,
                input logic [1:0]bellek_yaz ,
                input logic [1:0]yaz_veri ,
                input logic yaz_adres_arti2 ,

                //////////////Write'tan gelenler
                input logic [31:0]mr0_out ,
                input logic [31:0]mr1_out ,
                input logic [31:0]mr2_out ,
                input logic [31:0]mr3_out ,
                input logic rnd32 ,
                input logic [4:0]gorunen_5 ,            // {TF, ZF, NF, LUF, LVF} (ALU mstf_in ile ayni sira)
                input logic [31:0]gorunen_32 ,
                input logic dur_exe ,

                //////////////gorev denetcisinden
                input logic dondur ,

                //////////////MR yazma birimine (Write)
                output logic e_yaz1 ,
                output logic [1:0]e_hedef1 ,
                output logic [31:0]e_veri1 ,
                output logic e_yaz2 ,
                output logic [1:0]e_hedef2 ,
                output logic [31:0]e_veri_2 ,

                //////////////MAR yazmaclarina
                output logic [15:0]mar_veri ,
                output logic mar_sec ,
                output logic mar_en ,

                //////////////MSTF'ye (Write) : {RPC 12, MEALLOW, RND32, TF, ZF, NF, LUF, LVF}
                output logic [18:0]e_mstf_veri ,
                output logic [18:0]e_mstf_maske ,

                //////////////E/W yazmacina (Write)
                output logic w_gecerli ,
                output logic [11:0]w_pc ,
                output logic [1:0]w_bellek_yaz ,
                output logic [15:0]w_adr ,
                output logic [31:0]w_veri ,

                //////////////ALU K2 cikislari (bir cevrim sonra, W asamasi)
                output logic [31:0]result_topla ,
                output logic lvf_topla ,
                output logic luf_topla ,
                output logic valid_topla ,
                output logic [1:0]hedef_mr_out_topla ,
                output logic [31:0]result_carp ,
                output logic lvf_carp ,
                output logic luf_carp ,
                output logic valid_carp ,
                output logic [1:0]hedef_mr_out_carp

                );



/////////////////////////E ILERLEME

logic e_ilerle ;

assign e_ilerle = gecerli & ~dur_exe & ~dondur ;     // E'deki buyruk bu cevrimde gercekten calisiyor



//////////////////8 tane MR okuma muxu

logic [31:0]a;
logic [31:0]b;
logic [31:0]c;
logic [31:0]d_mux;
logic [31:0]sonuc_mux;
logic [31:0]imm_w;
logic [31:0]imm_e;

always_comb begin

case(a_mr)
    2'b00 : a = mr0_out;
    2'b01 : a = mr1_out;
    2'b10 : a = mr2_out;
    2'b11 : a = mr3_out;

endcase

case(b_mr)
    2'b00 : b = mr0_out;
    2'b01 : b = mr1_out;
    2'b10 : b = mr2_out;
    2'b11 : b = mr3_out;

endcase

case(c_mr)
    2'b00 : c = mr0_out;
    2'b01 : c = mr1_out;
    2'b10 : c = mr2_out;
    2'b11 : c = mr3_out;

endcase

case(d_mr)
    2'b00 : d_mux = mr0_out;
    2'b01 : d_mux = mr1_out;
    2'b10 : d_mux = mr2_out;
    2'b11 : d_mux = mr3_out;

endcase

case(exe_kaynak_mr)

    2'b00 : sonuc_mux = mr0_out;
    2'b01 : sonuc_mux = mr1_out;
    2'b10 : sonuc_mux = mr2_out;
    2'b11 : sonuc_mux = mr3_out;


endcase

case(exe_kaynak_mr_2)

    2'b00 : e_veri_2 = mr0_out;
    2'b01 : e_veri_2 = mr1_out;
    2'b10 : e_veri_2 = mr2_out;
    2'b11 : e_veri_2 = mr3_out;


endcase


case(veri_mr)

    2'b00 : imm_w = mr0_out;
    2'b01 : imm_w = mr1_out;
    2'b10 : imm_w = mr2_out;
    2'b11 : imm_w = mr3_out;


endcase

case(exe_hedef)

    2'b00 : imm_e = mr0_out;
    2'b01 : imm_e = mr1_out;
    2'b10 : imm_e = mr2_out;
    2'b11 : imm_e = mr3_out;

endcase

end



//////ANLIK GENISLETME BIRIMI

logic [15:0]mar_mr;
logic [15:0]mar_imm;
logic [31:0]imm_lo;
logic [31:0]imm_shift;
logic [31:0]imm_hi;

always_comb begin

imm_hi = {m , 16'h0};                   // #16FHi , MMOVIZ
imm_shift = {26'b0 , shift};            // #SHIFT (1..32)
imm_lo = {imm_e[31:16] , m};            // MMOVXI : MRa'nin ust yarisi korunur
mar_imm = m;                            // MMOVI16
mar_mr = imm_w[15:0] + m;               // MMOV16 MARx, MRa, #16I (16 bit, tasma atilir)

end



////////////d kaynagi mux

logic [31:0]d ;

always_comb begin

case(d_kaynak)

    2'b00 : d = d_mux ;                 // D_MR
    2'b01 : d = imm_hi ;                // D_IMM_HI
    2'b10 : d = imm_shift ;             // D_SHIFT
    2'b11 : d = okunan ;                // D_BELLEK


endcase

end



///////////////////////kosul degerlendirici

//gorunen_5[4] -> tf , gorunen_5[3] -> zf , gorunen_5[2] -> nf , gorunen_5[1] -> luf , gorunen_5[0] -> lvf

logic kosul_tuttu;

always_comb begin

case(kosul)

       4'b0000 : kosul_tuttu = (gorunen_5[3] == 1'b0);                            // NEQ
       4'b0001 : kosul_tuttu = (gorunen_5[3] == 1'b1);                            // EQ
       4'b0010 : kosul_tuttu = (gorunen_5[3] == 1'b0) && (gorunen_5[2] == 1'b0);  // GT
       4'b0011 : kosul_tuttu = (gorunen_5[2] == 1'b0);                            // GEQ
       4'b0100 : kosul_tuttu = (gorunen_5[2] == 1'b1);                            // LT
       4'b0101 : kosul_tuttu = (gorunen_5[3] == 1'b1) || (gorunen_5[2] == 1'b1);  // LEQ
       4'b1010 : kosul_tuttu = (gorunen_5[4] == 1'b1);                            // TF
       4'b1011 : kosul_tuttu = (gorunen_5[4] == 1'b0);                            // NTF
       4'b1100 : kosul_tuttu = (gorunen_5[1] == 1'b1);                            // LU
       4'b1101 : kosul_tuttu = (gorunen_5[0] == 1'b1);                            // LV
       4'b1110 : kosul_tuttu = 1'b1;                                              // UNC
       4'b1111 : kosul_tuttu = 1'b1;                                              // UNCF
       default : kosul_tuttu = 1'b0;                                              // 0110..1001 ayrilmis


endcase

end



///////////////////////////ALU KONTROL SOZCUKLER

logic [4:0]topla_cntrl;
logic [4:0]carpma_cntrl;
logic [2:0]tamsayi_cntrl;
logic kestirme_cntrl;
logic [6:0]karsilastirma_cntrl;
logic [4:0]donusum_cntrl;
logic [4:0]mstf_in;
logic [1:0]mux_1 ,mux_2 , mux_3 ,mux_4 ,mux_5 ,mux_6 ,mux_7 , mux_8 ,mux_9 , mux_10 ;

always_comb begin

topla_cntrl[0] = alu.topla_cikarma;
topla_cntrl[1] = alu.topla_kullan & e_ilerle;       // bekleme ve balonda K yazmacina gecersiz is girer
topla_cntrl[2] = rnd32 ;
topla_cntrl[4:3] = alu.topla_hedef;

carpma_cntrl[0] = 1'b0;
carpma_cntrl[1] = alu.carp_kullan & e_ilerle;
carpma_cntrl[2] = rnd32;
carpma_cntrl[4:3] = alu.carp_hedef;


tamsayi_cntrl = alu.tamsayi_islem;

kestirme_cntrl = alu.kestirme_islem;

karsilastirma_cntrl = {alu.karsilastirma_islem , alu.karsilastirma_cndf};

donusum_cntrl = {rnd32 , alu.donusum_islem};

mux_1 = alu.mux[1];
mux_2 = alu.mux[2];
mux_3 = alu.mux[3];
mux_4 = alu.mux[4];
mux_5 = alu.mux[5];
mux_6 = alu.mux[6];
mux_7 = alu.mux[7];
mux_8 = alu.mux[8];
mux_9 = alu.mux[9];
mux_10 = alu.mux[10];
mstf_in = gorunen_5;

end



/////////////////////////////////ALU

logic [31:0]result_donusum;
logic [31:0]result_karsilastirma;
logic [31:0]result_kestirme;
logic [31:0]result_tamsayi;
logic [4:0]mstf_out;
logic lvf_kestirme;
logic luf_kestirme;
logic zf_karsilastirma;
logic nf_karsilastirma;

ALU AL(.clk(clk) , .rst(rst_n) , .a(a) , .b(b) , .c(c) , .d(d) ,
        .topla_cntrl(topla_cntrl) , .carpma_cntrl(carpma_cntrl) , .tamsayi_cntrl(tamsayi_cntrl) ,
        .kestirme_cntrl(kestirme_cntrl) , .karsilastirma_cntrl(karsilastirma_cntrl) , .mstf_in(mstf_in) ,
        .donusum_cntrl(donusum_cntrl) ,
        .mux_1(mux_1) , .mux_2(mux_2) , .mux_3(mux_3) , .mux_4(mux_4) , .mux_5(mux_5) ,
        .mux_6(mux_6) , .mux_7(mux_7) , .mux_8(mux_8) , .mux_9(mux_9) , .mux_10(mux_10) ,
        .lvf_topla(lvf_topla) , .luf_topla(luf_topla) , .lvf_carp(lvf_carp) , .luf_carp(luf_carp) ,
        .result_kestirme(result_kestirme) , .lvf_kestirme(lvf_kestirme) , .luf_kestirme(luf_kestirme) ,
        .result_topla(result_topla) , .result_carp(result_carp) , .result_tamsayi(result_tamsayi) ,
        .mstf_out(mstf_out) , .result_karsilastirma(result_karsilastirma) ,
        .zf_karsilastirma(zf_karsilastirma) , .nf_karsilastirma(nf_karsilastirma) ,
        .result_donusum(result_donusum) ,
        .valid_carp(valid_carp) , .hedef_mr_out_carp(hedef_mr_out_carp) ,
        .valid_topla(valid_topla) , .hedef_mr_out_topla(hedef_mr_out_topla));



/////////////////////E YAZMA IZINLERI

logic mar_yaz;
logic [5:0]mstf_izin;

always_comb begin

e_yaz1 = e_ilerle & exe_yaz & (~exe_kosullu | kosul_tuttu);
e_yaz2 = e_ilerle & exe_yaz_2 & (~exe_kosullu | kosul_tuttu);

mar_yaz = e_ilerle & mar_yukle;
mstf_izin[5] = e_ilerle & (zn_kaynak != 3'd0);   // ZF, NF yazilacak
mstf_izin[4] = e_ilerle & tf_yaz;                // TF yazilacak
mstf_izin[3] = e_ilerle & meallow_yaz;           // MEALLOW yazilacak
mstf_izin[2] = e_ilerle & msetflg;               // MSETFLG
mstf_izin[1] = e_ilerle & mstf_yukle;            // MSTF bellekten yuklenecek
mstf_izin[0] = e_ilerle & lvf_luf_kestirme;      // LVF/LUF kestirim biriminden kurulacak

end



////////////////////////E SONUC MUXU

always_comb begin

case(exe_kaynak)

    3'b000 : e_veri1 = result_tamsayi ;           // EXE_TAMSAYI
    3'b001 : e_veri1 = result_kestirme ;          // EXE_KESTIRME
    3'b010 : e_veri1 = result_karsilastirma ;     // EXE_KARSILASTIRMA
    3'b011 : e_veri1 = result_donusum ;           // EXE_DONUSUM
    3'b100 : e_veri1 = okunan ;                   // EXE_BELLEK
    3'b101 : e_veri1 = imm_hi ;                   // EXE_IMM_HI
    3'b110 : e_veri1 = imm_lo ;                   // EXE_IMM_LO
    3'b111 : e_veri1 = sonuc_mux ;                // EXE_MR


endcase

e_hedef1 = exe_hedef;
e_hedef2 = exe_hedef_2;                          // ikinci yazma yalniz MSWAPF (e_veri_2 = MR[exe_kaynak_mr_2])

end



///////////////////ZF/NF Birimi

logic zf_e;
logic nf_e;

always_comb begin

case(zn_kaynak)

    3'd1 : begin                                  // ZN_TAMSAYI
        zf_e = mstf_out[3];
        nf_e = mstf_out[2];
    end

    3'd2 : begin                                  // ZN_KARSILASTIRMA
        zf_e = zf_karsilastirma;
        nf_e = nf_karsilastirma;
    end

    3'd3 : begin                                  // ZN_YAZILAN_FLOAT : us 0 ise sifir (denormal ve -0 dahil)
        zf_e = (e_veri1[30:23] == 8'd0);
        nf_e = e_veri1[31] & (e_veri1[30:23] != 8'd0);
    end

    3'd4 : begin                                  // ZN_YAZILAN_TAMSAYI (MMOVZ16)
        zf_e = (e_veri1 == 32'd0);
        nf_e = e_veri1[31];
    end

    default : begin                               // ZN_YOK
        zf_e = 1'b0;
        nf_e = 1'b0;
    end

endcase

end



///////////////////MSTF E GUNCELLEMESI

// bit duzeni : [18:7] RPC , [6] MEALLOW , [5] RND32 , [4] TF , [3] ZF , [2] NF , [1] LUF , [0] LVF
// maske 1 olan alan veri'yi alir, 0 olan korunur

always_comb begin

e_mstf_veri = 19'd0;
e_mstf_maske = 19'd0;

if(mstf_izin[5]) begin                            // ZF, NF
    e_mstf_veri[3] = zf_e;
    e_mstf_veri[2] = nf_e;
    e_mstf_maske[3] = 1'b1;
    e_mstf_maske[2] = 1'b1;
end

if(mstf_izin[4]) begin                            // MTESTTF : TF = kosul sonucu
    e_mstf_veri[4] = kosul_tuttu;
    e_mstf_maske[4] = 1'b1;
end

if(mstf_izin[3]) begin                            // MEALLOW / MEDIS
    e_mstf_veri[6] = meallow_deger;
    e_mstf_maske[6] = 1'b1;
end

if(mstf_izin[2]) begin                            // MSETFLG : m[15:8] FLAG , m[7:0] VALUE
    if(m[8]) begin                                // FLAG 0 -> LVF
        e_mstf_veri[0] = m[0];
        e_mstf_maske[0] = 1'b1;
    end
    if(m[9]) begin                                // FLAG 1 -> LUF
        e_mstf_veri[1] = m[1];
        e_mstf_maske[1] = 1'b1;
    end
    if(m[10]) begin                               // FLAG 2 -> NF
        e_mstf_veri[2] = m[2];
        e_mstf_maske[2] = 1'b1;
    end
    if(m[11]) begin                               // FLAG 3 -> ZF
        e_mstf_veri[3] = m[3];
        e_mstf_maske[3] = 1'b1;
    end
    if(m[14]) begin                               // FLAG 6 -> TF
        e_mstf_veri[4] = m[6];
        e_mstf_maske[4] = 1'b1;
    end
    if(m[15]) begin                               // FLAG 7 -> RND32
        e_mstf_veri[5] = m[7];
        e_mstf_maske[5] = 1'b1;
    end
end

if(mstf_izin[1]) begin                            // MMOV32 MSTF, mem32 : MEALLOW korunur
    e_mstf_veri[18:7] = okunan[23:12];            // RPC
    e_mstf_veri[5] = okunan[9];                   // RND32
    e_mstf_veri[4] = okunan[6];                   // TF
    e_mstf_veri[3:0] = okunan[3:0];               // ZF NF LUF LVF
    e_mstf_maske[18:7] = 12'hFFF;
    e_mstf_maske[5:0] = 6'b111111;
end

if(mstf_izin[0]) begin                            // MEINVF32 / MEISQRTF32 : LVF, LUF yapiskan
    if(lvf_kestirme) begin
        e_mstf_veri[0] = 1'b1;
        e_mstf_maske[0] = 1'b1;
    end
    if(luf_kestirme) begin
        e_mstf_veri[1] = 1'b1;
        e_mstf_maske[1] = 1'b1;
    end
end

end



///////////////////MAR YUKLEME

always_comb begin

case(mar_kaynak)

    2'b00 : mar_veri = mar_imm ;                  // MAR_IMM
    2'b01 : mar_veri = mar_mr ;                   // MAR_MR_ARTI_IMM
    2'b10 : mar_veri = okunan[15:0] ;             // MAR_BELLEK
    default : mar_veri = 16'h0000 ;


endcase

mar_sec = mar_hedef;
mar_en = mar_yaz;

end



///////////////////W'YE VERI VE ADRES

always_comb begin

case(yaz_veri)

    2'b00 : w_veri = imm_w ;                      // VERI_MR : MR[veri_mr] (16 bitte alt yari yazilir)
    2'b01 : w_veri = {16'h0000 , mar_d2} ;        // VERI_MAR
    2'b10 : w_veri = gorunen_32 ;                 // VERI_MSTF
    2'b11 : w_veri = okunan ;                     // VERI_BELLEK (MMOVD32)


endcase

w_adr = yaz_adres_arti2 ? (ea + 16'd2) : ea;     // MMOVD32 : [ea + 2] <= [ea]
w_bellek_yaz = bellek_yaz;
w_gecerli = e_ilerle;                            // dur_exe ve dondur'da W'ye balon gider
w_pc = pc;

end



endmodule
