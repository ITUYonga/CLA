`timescale 1ns / 1ps

// MOD_DECODE1 : Boru hattının 3. aşaması (D1); 32-bit buyruğu kombinasyonel olarak çözer ve D1/D2 yazmacına kaydeder
//
//   Amaç:     F2/D1 yazmacından gelen 32-bitlik ham buyruk kelimesini
//             cla_decoder alt modülüne uygulayarak buyruk kimliğini (op_e),
//             operand/adres alanlarını (alanlar_t) ve geçersiz adresleme
//             kipi bayrağını (kip_gecersiz) çıkarır; sonuçları D1/D2 boru
//             hattı yazmacına kaydeder.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           clk:            Sistem saati
//           rst_n:          Aktif-düşük sıfırlama sinyali
//           f2d1_gecerli:   F2/D1 yazmacından gelen buyruk geçerlilik biti
//           f2d1_pc:        F2/D1 yazmacından gelen 12-bit program sayacı
//           f2d1_kelime:    Çözülecek 32-bit buyruk kelimesi
//           en:             D1/D2 boru hattı yazmacı ilerleme izni
//           balon:          MSTOP veya reset durumunda D1/D2 yazmacını
//                           temizleyen sinyal
//   Outputlar:
//           d1d2_gecerli:   D1/D2 yazmacındaki buyruğun geçerli olduğunu
//                           belirten bit
//           d1d2_pc:        D1/D2 yazmacına aktarılan 12-bit program sayacı
//           d1d2_kelime:    İzleme (trace) amacıyla D1/D2 yazmacına taşınan
//                           32-bit buyruk kelimesi
//           d1d2_op:        Çözülen buyruk kimliği (op_e enum tipi)
//           d1d2_alan:      Buyruktan ayıklanan yazmaç, kip, koşul ve sabit
//                           alanlar paketi (alanlar_t)
//           d1d2_kip_gecersiz: Bellek buyruğunda ayrılmış adresleme kipi
//                              (0011..1111) kullanıldığını gösteren bayrak
//
//   Notlar:
//           Buyruk çözme (cla_decoder) tamamen kombinasyoneldir; kontrol
//           sinyali üretimi ise kritik yolu bölmek amacıyla bir sonraki
//           aşama olan Decode2'de (cla_ctrl_gen) yapılır.

module Decode1
    import cla_pkg::*;
(
                input logic clk ,
                input logic rst_n ,

                //////////////F2/D1 yazmacindan
                input logic f2d1_gecerli ,
                input logic [11:0]f2d1_pc ,
                input logic [31:0]f2d1_kelime ,

                //////////////boru hatti denetiminden
                input logic en ,
                input logic balon ,

                //////////////D1/D2 yazmaci
                output logic d1d2_gecerli ,
                output logic [11:0]d1d2_pc ,
                output logic [31:0]d1d2_kelime ,
                output op_e d1d2_op ,
                output alanlar_t d1d2_alan ,
                output logic d1d2_kip_gecersiz

                );



/////////////////////////COZUCU

op_e op;
logic gecersiz;
logic kip_gecersiz;
alanlar_t alan;

cla_decoder DEC(.buyruk(f2d1_kelime) , .op(op) , .gecersiz(gecersiz) , .kip_gecersiz(kip_gecersiz) , .alan(alan));



/////////////////////////D1/D2 YAZMACI

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        d1d2_gecerli <= 1'b0;
        d1d2_pc <= 12'h000;
        d1d2_kelime <= 32'h0000_0000;
        d1d2_op <= OP_GECERSIZ;
        d1d2_alan <= '0;
        d1d2_kip_gecersiz <= 1'b0;
    end
    else if(balon) begin
        d1d2_gecerli <= 1'b0;
    end
    else if(en) begin
        d1d2_gecerli <= f2d1_gecerli;
        d1d2_pc <= f2d1_pc;
        d1d2_kelime <= f2d1_kelime;
        d1d2_op <= op;
        d1d2_alan <= alan;
        d1d2_kip_gecersiz <= kip_gecersiz;
    end

end



endmodule
