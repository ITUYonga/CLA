`timescale 1ns / 1ps

// PKG_KOD_SINIFI : Kayan nokta alt birimleri için 2-bitlik özel durum sınıflandırma (fp_durum_e) paketi
//
//   Amaç:     IEEE-754 tek duyarlıklı (FP32) sayıların sınıflandırılmasında
//             kullanılan fp_durum_e enum tipini (NORMAL = 2'b00, INF =
//             2'b01, ZERO = 2'b10, NAN = 2'b11) içeren kod_sinifi paketini
//             ve sentez hiyerarşisi için boş kodlar modülünü tanımlar.
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
//           carp_k1, topla_k1, topla_k2, pack ve karsilastirma modülleri
//           özel durum propagasyonunu bu paketteki 2-bitlik kodlamayla
//           yürütür.

package kod_sinifi;

  typedef enum logic [1:0] {
    NORMAL = 2'b00,
    INF    = 2'b01,  // SONSUZ
    ZERO   = 2'b10,  // SIFIR
    NAN    = 2'b11
  } fp_durum_e;

endpackage

module kodlar(

    );
endmodule
