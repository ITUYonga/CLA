`timescale 1ns / 1ps

// MOD_DECODE2 : Boru hattının 4. aşaması (D2); kontrol paketi üretimi, etkin adres hesabı, MAR artışı ve dallanma kararını yürütür
//
//   Amaç:     D1'den gelen çözülmiş buyruk için cla_ctrl_gen üzerinden
//             kontrol paketini (kontrol_t) üretir. Doğrudan (@dir) veya
//             MAR0/MAR1 dolaylı adresleme kiplerine göre 16-bit etkin adresi
//             (ea) hesaplar ve post-increment artışını üretir. Görünen MSTF
//             bayraklarını (gorunen_5) değerlendirerek MBCNDD, MCCNDD ve
//             MRCNDD dallanma kararlarını verir; MSTOP ve geçersiz buyruk
//             olaylarını görev denetçisine bildirir.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           clk:            Sistem saati
//           rst_n:          Aktif-düşük sıfırlama sinyali
//           d1d2_gecerli:   D1/D2 yazmacından gelen buyruk geçerlilik biti
//           d1d2_pc:        D1/D2 yazmacından gelen 12-bit program sayacı
//           d1d2_kelime:    D1/D2 yazmacından gelen 32-bit buyruk kelimesi
//           d1d2_op:        D1 aşamasında çözülen buyruk kimliği (op_e)
//           d1d2_alan:      D1 aşamasında ayıklanan buyruk alanları
//                           (alanlar_t)
//           d1d2_kip_gecersiz: Ayrılmış adresleme kipi bayrağı
//           mar0:           MAR0 yardımcı adres yazmacının güncel 16-bit
//                           değeri
//           mar1:           MAR1 yardımcı adres yazmacının güncel 16-bit
//                           değeri
//           rpc:            MSTF içindeki 12-bit dönüş program sayacı (MRCNDD
//                           için)
//           gorunen_5:      W aşamasından yönlendirilen güncel bayraklar ({TF,
//                           ZF, NF, LUF, LVF})
//           dur_exe:        E aşaması kaynaklı boru hattı bekleme sinyali
//           dur_r1:         R1 aşaması BRAM çakışması kaynaklı bekleme sinyali
//           dondur:         Geçersiz buyruk nedeniyle boru hattını dondurma
//                           sinyali
//           en:             D2/R1 yazmacı ilerleme izni
//           balon:          D2/R1 yazmacını sıfırlayan balon sinyali
//   Outputlar:
//           dal_alindi:     Koşullu dallanmanın gerçekleştiğini F1 aşamasına
//                           bildiren sinyal
//           dal_hedef:      F1 aşamasına gönderilen 12-bitlik dallanma hedef
//                           adresi
//           mar_artis_en:   Dolaylı adreslemede (*MARx[#imm]++) MAR yazmacını
//                           güncelleme izni
//           mar_artis_sec:  Artırılacak MAR seçimi (0: MAR0, 1: MAR1)
//           mar_artis_deger: MAR yazmacına yazılacak yeni 16-bit adres (ea +
//                            m)
//           rpc_en:         MCCNDD çağrı buyruğunda RPC yazmacını güncelleme
//                           izni
//           rpc_deger:      MCCNDD buyruğunda RPC'ye kaydedilecek dönüş adresi
//                           (d1d2_pc + 8)
//           d2_gecerli:     D2 aşamasındaki buyruğun bu çevrimde ilerlediğini
//                           görev denetçisine bildiren sinyal
//           d2_mstop:       D2'deki buyruğun MSTOP olduğunu belirten sinyal
//           d2_gecersiz:    D2'deki buyruğun geçersiz opkod veya kip
//                           içerdiğini belirten sinyal
//           mpc_en:         Mimari MPC yazmacını güncelleme izni
//           mpc_deger:      Mimari MPC yazmacına yazılacak 12-bit D2 program
//                           sayacı
//           d2r1_gecerli:   D2/R1 yazmacındaki buyruğun geçerli olduğunu
//                           belirten bit
//           d2r1_pc:        D2/R1 yazmacına aktarılan 12-bit program sayacı
//           d2r1_kelime:    D2/R1 yazmacına aktarılan 32-bit buyruk kelimesi
//           d2r1_k:         D2/R1 yazmacına aktarılan statik kontrol paketi
//                           (kontrol_t)
//           d2r1_ea:        Hesaplanan 16-bit etkin bellek adresi
//           d2r1_m:         Buyruğun 16-bitlik LSW / anlık (immediate) alanı
//           d2r1_shift:     Kaydırma buyrukları için 6-bitlik kaydırma miktarı
//                           (1..32)
//           d2r1_veri_mr:   Belleğe yazılacak veya MAR'a eklenecek kaynak MR
//                           indeksi (MRa)
//           d2r1_mar_d2:    MMOV16 mem16, MARx buyruğu için D2 artışından
//                           önceki MAR değeri
//
//   Notlar:
//           D2 yan etkileri (MAR post-increment, dallanma, RPC yazımı ve
//           MSTOP bildirimi) yalnızca d2_ilerle = 1 iken (boru hattı
//           duraklatılmamışken) her buyruk için tam bir kez uygulanır.
//
//           Dallanma buyrukları (MBCNDD, MCCNDD, MRCNDD) ve geçersiz
//           buyruklar D2'de işini tamamladığı için D2/R1 yazmacına balon
//           (d2r1_gecerli = 0) olarak aktarılır.

module Decode2
    import cla_pkg::*;
(
                input logic clk ,
                input logic rst_n ,

                //////////////D1/D2 yazmacindan
                input logic d1d2_gecerli ,
                input logic [11:0]d1d2_pc ,
                input logic [31:0]d1d2_kelime ,
                input op_e d1d2_op ,
                input alanlar_t d1d2_alan ,
                input logic d1d2_kip_gecersiz ,

                //////////////durum yazmaclarindan
                input logic [15:0]mar0 ,
                input logic [15:0]mar1 ,
                input logic [11:0]rpc ,
                input logic [4:0]gorunen_5 ,              // {TF, ZF, NF, LUF, LVF}

                //////////////boru hatti denetiminden
                input logic dur_exe ,
                input logic dur_r1 ,
                input logic dondur ,
                input logic en ,
                input logic balon ,

                //////////////F1'e (dal)
                output logic dal_alindi ,
                output logic [11:0]dal_hedef ,

                //////////////MAR yazmaclarina (D2 sonunda artis)
                output logic mar_artis_en ,
                output logic mar_artis_sec ,
                output logic [15:0]mar_artis_deger ,

                //////////////MSTF'ye (MCCNDD)
                output logic rpc_en ,
                output logic [11:0]rpc_deger ,

                //////////////gorev denetcisine
                output logic d2_gecerli ,
                output logic d2_mstop ,
                output logic d2_gecersiz ,

                //////////////MPC'ye
                output logic mpc_en ,
                output logic [11:0]mpc_deger ,

                //////////////D2/R1 yazmaci
                output logic d2r1_gecerli ,
                output logic [11:0]d2r1_pc ,
                output logic [31:0]d2r1_kelime ,
                output kontrol_t d2r1_k ,
                output logic [15:0]d2r1_ea ,
                output logic [15:0]d2r1_m ,
                output logic [5:0]d2r1_shift ,
                output logic [1:0]d2r1_veri_mr ,
                output logic [15:0]d2r1_mar_d2

                );



/////////////////////////KONTROL URETICI

kontrol_t k;

cla_ctrl_gen GEN(.op(d1d2_op) , .alan(d1d2_alan) , .kip_gecersiz(d1d2_kip_gecersiz) , .k(k));



/////////////////////////D2 ILERLEME

logic d2_ilerle;

assign d2_ilerle = d1d2_gecerli & ~dur_exe & ~dur_r1 & ~dondur;     // D2 isi her buyrukta bir kez, ilerledigi cevrimde



/////////////////////////ETKIN ADRES VE MAR ARTISI

logic [15:0]ea;

always_comb begin

case(d1d2_alan.addr_kip)

    4'b0001 : ea = mar0 ;                       // *MAR0[m]++
    4'b0010 : ea = mar1 ;                       // *MAR1[m]++
    default : ea = d1d2_alan.m ;                // dogrudan : adres = m


endcase

mar_artis_en = d2_ilerle & k.bellek_adres & ((d1d2_alan.addr_kip == 4'b0001) | (d1d2_alan.addr_kip == 4'b0010));
mar_artis_sec = (d1d2_alan.addr_kip == 4'b0010);
mar_artis_deger = ea + d1d2_alan.m;             // 16 bit, tasma atilir

end



///////////////////////DAL BIRIMI

//gorunen_5[4] -> tf , gorunen_5[3] -> zf , gorunen_5[2] -> nf , gorunen_5[1] -> luf , gorunen_5[0] -> lvf

logic tuttu;
logic dal_var;

always_comb begin

case(k.kosul)

       4'b0000 : tuttu = (gorunen_5[3] == 1'b0);                            // NEQ
       4'b0001 : tuttu = (gorunen_5[3] == 1'b1);                            // EQ
       4'b0010 : tuttu = (gorunen_5[3] == 1'b0) && (gorunen_5[2] == 1'b0);  // GT
       4'b0011 : tuttu = (gorunen_5[2] == 1'b0);                            // GEQ
       4'b0100 : tuttu = (gorunen_5[2] == 1'b1);                            // LT
       4'b0101 : tuttu = (gorunen_5[3] == 1'b1) || (gorunen_5[2] == 1'b1);  // LEQ
       4'b1010 : tuttu = (gorunen_5[4] == 1'b1);                            // TF
       4'b1011 : tuttu = (gorunen_5[4] == 1'b0);                            // NTF
       4'b1100 : tuttu = (gorunen_5[1] == 1'b1);                            // LU
       4'b1101 : tuttu = (gorunen_5[0] == 1'b1);                            // LV
       4'b1110 : tuttu = 1'b1;                                              // UNC
       4'b1111 : tuttu = 1'b1;                                              // UNCF
       default : tuttu = 1'b0;                                              // 0110..1001 ayrilmis


endcase

dal_var = (k.dal != DAL_YOK);

dal_alindi = d2_ilerle & dal_var & tuttu;
dal_hedef = (k.dal == DAL_MRCNDD) ? rpc : (d1d2_pc + d1d2_alan.m[11:0]);     // taban = dalin kendi adresi
rpc_en = d2_ilerle & (k.dal == DAL_MCCNDD) & tuttu;
rpc_deger = d1d2_pc + 12'd8;                    // dal + 3 gecikme yuvasi

end



/////////////////////////D2 OLAYLARI

always_comb begin

d2_gecerli = d2_ilerle;
d2_mstop = k.mstop;
d2_gecersiz = k.gecersiz;

mpc_en = d1d2_gecerli & ~dondur;                // MPC = D2'deki buyruk (beklemede de)
mpc_deger = d1d2_pc;

end



/////////////////////////D2/R1 YAZMACI

// dallar ve gecersiz buyruk D2'den sonra balon olur (E'de yapacaklari is yok)

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        d2r1_gecerli <= 1'b0;
        d2r1_pc <= 12'h000;
        d2r1_kelime <= 32'h0000_0000;
        d2r1_k <= '0;
        d2r1_ea <= 16'h0000;
        d2r1_m <= 16'h0000;
        d2r1_shift <= 6'd0;
        d2r1_veri_mr <= 2'b00;
        d2r1_mar_d2 <= 16'h0000;
    end
    else if(balon) begin
        d2r1_gecerli <= 1'b0;
    end
    else if(en) begin
        d2r1_gecerli <= d1d2_gecerli & ~dal_var & ~k.gecersiz;
        d2r1_pc <= d1d2_pc;
        d2r1_kelime <= d1d2_kelime;
        d2r1_k <= k;
        d2r1_ea <= ea;
        d2r1_m <= d1d2_alan.m;
        d2r1_shift <= d1d2_alan.shift;
        d2r1_veri_mr <= d1d2_alan.ra;            // saklanan / MAR'a eklenen MR (MRa)
        d2r1_mar_d2 <= k.mar_hedef ? mar1 : mar0; // MMOV16 mem16, MARx : artistan onceki deger
    end

end



endmodule
