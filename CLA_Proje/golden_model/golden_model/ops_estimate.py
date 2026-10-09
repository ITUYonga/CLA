# -*- coding: utf-8 -*-
"""MEINVF32 / MEISQRTF32 kestirimleri - PROJE SOZLESMESI.

TRM s.617 / s.618:
    "generates an estimate of 1/X [1/sqrt(X)] in 32-bit floating-point
     format accurate to approximately 8 bits ... will not generate a
     negative zero, DeNorm or NaN value."
    LUF = 1 alt tasmada, LVF = 1 tasmada; TF, ZF, NF degismez.

TI tablonun icerigini YAYIMLAMIYOR (model_kararlari §6.1). Secenek 1
secildi: tablo projenin tanimi. Bu dosyadaki FORMUL tek kaynaktir;
`tools/lut_uret.py` ondan `isa/estimate_lut.hex`'i uretir (duzen asagida),
RTL onu $readmemh ile okur, `tests/test_estimate.py` dosyanin formulle
birebir ayni oldugunu denetler. Sonuc "Python == RTL"
garantisi verir; "Python == TI silikonu" DEGIL.

Newton-Raphson komutun ICINDE YOK: TRM iterasyonlari programa birakiyor
(s.617 ornegi: MEINVF32 + iki kez MMPYF32/MSUBF32). Komut yalniz tohumu
uretir.

YONTEM
------
Girdinin kesir alaninin ust 8 biti f[22:15] = i araligi secer:

    m ∈ [1 + i/256, 1 + (i+1)/256)       orta nokta  m_i = (513 + 2i) / 512

Tablo, orta noktadaki degeri 8 kesir bitiyle tutar (1.q, q = 0..255), en
yakina yuvarlanmis. Sonuc = isaret | us << 23 | q << 15 (alt 15 bit sifir).

    1/x    q = round(2^18 / (513 + 2i)) - 256              (2/m_i ∈ (1, 2))
           us = 253 - e

    1/√x   indeks = (e & 1) << 8 | i
           e cift (E = e-127 tek):  q = round(sqrt(2^26/(513+2i))) - 256
                                    (√2/√m_i ∈ (1, √2])
           e tek  (E cift):         q = min(round(sqrt(2^27/(513+2i))), 511) - 256
                                    (2/√m_i; yalniz i = 0 kirpiliyor, 512 -> 511)
           us = (380 - e) >> 1

Yuvarlamalar tamsayi aritmetigiyle; esitlik (tam .5) durumu yok: payda tek,
pay 2'nin kuvveti. Olculen en buyuk goreli hata, butun 2^23 mantis:
1/x 2^-8.45, 1/√x 2^-8.71 (tek E) / 2^-9.00 (cift E) - "yaklasik 8 bit".

OZEL DURUMLAR (TRM yalniz "-0, denormal, NaN uretmez" diyor; gerisi karar)
-----------------------------------------------------------------------
    1/x    e = 0   (±0, denormal = sifir sayilir)  -> ±sonsuz, LVF
           e = 255 (±sonsuz, NaN)                  -> +0
           e >= 253 (sonuc normal araligin altinda) -> +0, LUF   (-0 degil)
    1/√x   isaret yok sayilir (|x|): negatif girdi TRM'de tanimsiz ve NaN
           uretilemez
           e = 0                                    -> +sonsuz, LVF
           e = 255                                  -> +0
           normal girdide sonuc hep normal: us 63..189, tasma/alt tasma yok
"""

from math import isqrt

TERS_BOY = 256
KAREKOK_BOY = 512


def _ters_q(i):
    b = 513 + 2 * i
    return (2 * (1 << 18) + b) // (2 * b) - 256           # round(2^18 / b)


def _karekok_q(indeks):
    i = indeks & 0xFF
    tek_E = (indeks >> 8) == 0                             # e cift -> E tek
    A = (1 << 26) if tek_E else (1 << 27)
    b = 513 + 2 * i
    k = (isqrt(4 * A // b) + 1) // 2                       # round(sqrt(A / b))
    return min(k, 511) - 256


TERS_LUT = tuple(_ters_q(i) for i in range(TERS_BOY))
KAREKOK_LUT = tuple(_karekok_q(i) for i in range(KAREKOK_BOY))


def ters_kestirim(bits):
    """MEINVF32 cekirdegi: ham 32 bit -> (sonuc_bitleri, luf, lvf)."""
    isaret = bits & 0x80000000
    e = (bits >> 23) & 0xFF
    if e == 0xFF:
        return 0x00000000, False, False
    if e == 0:
        return isaret | 0x7F800000, False, True
    us = 253 - e
    if us <= 0:
        return 0x00000000, True, False
    return isaret | (us << 23) | (TERS_LUT[(bits >> 15) & 0xFF] << 15), False, False


def karekok_ters_kestirim(bits):
    """MEISQRTF32 cekirdegi: ham 32 bit -> (sonuc_bitleri, luf, lvf)."""
    e = (bits >> 23) & 0xFF
    if e == 0xFF:
        return 0x00000000, False, False
    if e == 0:
        return 0x7F800000, False, True
    us = (380 - e) >> 1
    indeks = ((e & 1) << 8) | ((bits >> 15) & 0xFF)
    return (us << 23) | (KAREKOK_LUT[indeks] << 15), False, False


# ---------------------------------------------------------------------
#  isa/estimate_lut.hex  -  RTL'in okudugu TEK dosya (768 x 8 bit)
#
#      0x000-0x0FF  1/sqrt, e cift  (E tek)    adres = {1'b0, e[0], f[22:15]}
#      0x100-0x1FF  1/sqrt, e tek   (E cift)
#      0x200-0x2FF  1/x                         adres = {2'b10, f[22:15]}
#
#  Iki komutun adresi de bit birlestirmesi - RTL'de toplayici gerekmiyor.
#  Satir basina bir giris, 2 onaltilik hane, yorumsuz ($readmemh).
# ---------------------------------------------------------------------
LUT_DOSYASI = "estimate_lut.hex"
KAREKOK_TABAN = 0x000
TERS_TABAN = 0x200


def lut_satirlari():
    """Dosyanin satirlari, adres sirasiyla."""
    return ["%02x" % q for q in KAREKOK_LUT + TERS_LUT]
