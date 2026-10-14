`timescale 1ns / 1ps

// MOD_FETCH1 : Boru hattının 1. aşaması (F1); getirme program sayacını (getir_pc) ve L3 bellek adresini üretir
//
//   Amaç:     Görev başlangıcı (mvect_pc), D2 aşamasından gelen dallanma
//             hedefi (dal_hedef) veya ardışık akış (getir_pc + 2) arasından
//             bir sonraki buyruk adresini seçer. L3 program BRAM'ine 32-bit
//             satır adresini (getir_pc[11:1]) sürer ve F1/F2 boru hattı
//             yazmacını besler.
//
//   Parametreler:
//           yok
//
//   Inputlar:
//           clk:            Sistem saati
//           rst_n:          Aktif-düşük sıfırlama sinyali
//           getir_izin:     Görev denetçisinin yeni buyruk getirmeye izin
//                           verdiğini gösteren sinyal
//           gorev_basla:    Yeni bir görevin başladığını ve mvect_pc'nin
//                           yükleneceğini belirten tek çevrimlik sinyal
//           mvect_pc:       Başlayan görevin MVECT yazmacından gelen 12-bitlik
//                           başlangıç adresi
//           dal_alindi:     D2 aşamasındaki dallanma buyruğunun koşulunun
//                           tuttuğunu belirten sinyal
//           dal_hedef:      D2 aşamasında hesaplanan 12-bitlik
//                           dallanma/çağrı/dönüş hedef adresi
//           en:             Boru hattı ilerleme izni (~(dur_exe | dur_r1 |
//                           dondur))
//           balon:          MSTOP veya reset durumunda F1/F2 yazmacını
//                           geçersizleştiren (bubble) sinyal
//   Outputlar:
//           l3_adr:         L3 program belleğine giden 11-bitlik 32-bit satır
//                           adresi (getir_pc[11:1])
//           f1f2_gecerli:   F1/F2 boru hattı yazmacındaki buyruğun geçerli
//                           olduğunu belirten bit
//           f1f2_pc:        F1/F2 boru hattı yazmacına aktarılan 12-bit buyruk
//                           adresi
//
//   Notlar:
//           Her CLA buyruğu 32-bit (2 adet 16-bit kelime) olduğundan
//           ardışık akışta getir_pc her çevrimde +2 artar.
//
//           Dallanma kararı D2 aşamasında verildiği için dallanma
//           buyruğundan sonraki 3 gecikme yuvası (delay slot) her koşulda
//           boru hattına girer ve yürütülür.

module Fetch1(
                input logic clk ,
                input logic rst_n ,

                //////////////gorev denetcisi ve MVECT'ten
                input logic getir_izin ,
                input logic gorev_basla ,
                input logic [11:0]mvect_pc ,

                //////////////D2'den (dal birimi)
                input logic dal_alindi ,
                input logic [11:0]dal_hedef ,

                //////////////boru hatti denetiminden
                input logic en ,                        // F1 ve F1/F2 ilerler
                input logic balon ,                     // F1/F2 <- balon (MSTOP, reset)

                //////////////L3 program bellegine
                output logic [10:0]l3_adr ,             // 32 bitlik satir (getir_pc[11:1])

                //////////////F1/F2 yazmaci
                output logic f1f2_gecerli ,
                output logic [11:0]f1f2_pc

                );



/////////////////////////SONRAKI GETIRME ADRESI

logic [11:0]getir_pc;
logic [11:0]sonraki_pc;

always_comb begin

if(gorev_basla) sonraki_pc = mvect_pc;                  // gorev basi
else if(dal_alindi) sonraki_pc = dal_hedef;             // dal karari D2'de, 3 gecikme yuvasi calisir
else if(getir_izin) sonraki_pc = getir_pc + 12'd2;      // siradaki buyruk (buyruk = 2 kelime)
else sonraki_pc = getir_pc;

end



/////////////////////////GETIRME SAYACI

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        getir_pc <= 12'h000;
    end
    else if(gorev_basla) begin
        getir_pc <= mvect_pc;                           // beklemeden bagimsiz yuklenir
    end
    else if(en) begin
        getir_pc <= sonraki_pc;
    end

end

assign l3_adr = getir_pc[11:1];



/////////////////////////F1/F2 YAZMACI

always_ff@(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        f1f2_gecerli <= 1'b0;
        f1f2_pc <= 12'h000;
    end
    else if(balon) begin
        f1f2_gecerli <= 1'b0;
    end
    else if(en) begin
        f1f2_gecerli <= getir_izin;                     // gorev yokken getirme yok
        f1f2_pc <= getir_pc;
    end

end



endmodule
