`timescale 1ns / 1ps

// MOD_FETCH2 : Boru hattının 2. aşaması (F2); L3 program BRAM'inden 32-bit buyruk kelimesini okur ve F2/D1 yazmacına aktarır
//
//   Amaç:     4096 x 16-bit (2048 x 32-bit) kapasiteli L3 program belleğini
//             barındırır. F1 aşamasının sürdüğü l3_adr adresinden alt
//             ({l3_adr, 0}) ve üst ({l3_adr, 1}) 16-bitlik yarıları
//             birleştirerek 32-bitlik buyruğu ({MSW, LSW}) oluşturur ve
//             F2/D1 boru hattı yazmacına kaydeder.
//
//   Parametreler:
//           PROGRAM_HEX:    Simülasyon ve sentez başlangıcında $readmemh ile
//                           L3 dizisine yüklenecek hex dosyası
//
//   Inputlar:
//           clk:            Sistem saati
//           rst_n:          Aktif-düşük sıfırlama sinyali
//           l3_adr:         F1 aşamasından gelen 11-bitlik 32-bit buyruk
//                           adresi
//           l3_en:          L3 BRAM okuma etkinleştirme sinyali (boru hattı
//                           beklerken çıkış korunur)
//           f1f2_gecerli:   F1/F2 yazmacından gelen buyruk geçerlilik biti
//           f1f2_pc:        F1/F2 yazmacından gelen 12-bit program sayacı
//           en:             F2/D1 boru hattı yazmacı ilerleme izni
//           balon:          MSTOP veya reset durumunda F2/D1 yazmacını
//                           temizleyen sinyal
//   Outputlar:
//           f2d1_gecerli:   F2/D1 yazmacındaki buyruğun geçerli olduğunu
//                           belirten bit
//           f2d1_pc:        F2/D1 yazmacına aktarılan 12-bit program sayacı
//           f2d1_kelime:    L3 program belleğinden okunan 32-bit buyruk
//                           kelimesi ({MSW, LSW})
//
//   Notlar:
//           L3 belleği satır başına 16-bit kelime tutar; çift indexte LSW
//           ([15:0]), tek indexte MSW ([31:16]) yer alır.
//
//           Boru hattı duraklatıldığında l3_en sıfıra çekilerek BRAM çıkış
//           yazmacındaki (kelime) mevcut buyruk korunur.

module Fetch2 #(
                parameter string PROGRAM_HEX = ""       // L3 icerigi : satir basina 16 bit, alt adres once
)(
                input logic clk ,
                input logic rst_n ,

                //////////////F1'den
                input logic [10:0]l3_adr ,
                input logic l3_en ,                     // F1 ilerlerken (en_F1F2) okunur, beklemede cikis korunur
                input logic f1f2_gecerli ,
                input logic [11:0]f1f2_pc ,

                //////////////boru hatti denetiminden
                input logic en ,
                input logic balon ,

                //////////////F2/D1 yazmaci
                output logic f2d1_gecerli ,
                output logic [11:0]f2d1_pc ,
                output logic [31:0]f2d1_kelime

                );



/////////////////////////L3 PROGRAM BELLEGI (4K x 16)

logic [15:0]l3 [0:4095];
logic [31:0]kelime;

initial begin
    if(PROGRAM_HEX != "") $readmemh(PROGRAM_HEX , l3);
end

always_ff@(posedge clk) begin

    if(l3_en) kelime <= {l3[{l3_adr , 1'b1}] , l3[{l3_adr , 1'b0}]};     // {MSW, LSW} : kelime F2'de hazir

end



/////////////////////////F2/D1 YAZMACI

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        f2d1_gecerli <= 1'b0;
        f2d1_pc <= 12'h000;
        f2d1_kelime <= 32'h0000_0000;
    end
    else if(balon) begin
        f2d1_gecerli <= 1'b0;
    end
    else if(en) begin
        f2d1_gecerli <= f1f2_gecerli;
        f2d1_pc <= f1f2_pc;
        f2d1_kelime <= kelime;
    end

end



endmodule
