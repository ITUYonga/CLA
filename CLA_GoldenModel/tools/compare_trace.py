#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Iki izi satir satir karsilastirir ve ILK ayrismayi bildirir.

    python3 tools/compare_trace.py model.trace rtl.trace
    python3 tools/compare_trace.py a.trace b.trace --gormezden-gel mpc
    python3 tools/compare_trace.py a.trace b.trace --baglam 5

Cikis kodu:  0 = ayni    1 = ayrisma var    2 = karsilastirma YAPILAMADI
             (dosya/format hatasi, bos iz, karsilastirilacak alan yok,
             beklenmeyen istisna). 1 yalnizca gercek ayrisma demek: bir
             CI betigi 'kod == 1' diye bakiyorsa cokme onu kandiramaz.

NE ISPATLAR, NE ISPATLAMAZ
--------------------------
Bu arac yalnizca "RTL == Python modeli" der. Modelin KENDISININ dogru
oldugunu soylemez - onun icin CCS simulatoru ya da gercek kart gerekir
(yol haritasi Faz 7, Tuzak 2).

ILK AYRISMA NEDEN ONEMLI
------------------------
Boru hattinda bir cevrim kayarsa ondan sonraki her satir farkli cikar.
Butun farklari listelemek 5000 satirlik gurultu uretir; hata ARANACAK
yer ilk ayrisan satirdir. O yuzden rapor ilk farkin cevresini gosterir,
gerisini sayar.
"""

import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from golden_model.trace import (ALANLAR, BICIM, IzHatasi,        # noqa: E402
                                bilinmeyen_mi, oku)


class Rapor(object):
    def __init__(self):
        self.ilk_fark = None          # (indeks, [alan, ...])
        self.fark_sayisi = 0
        self.alan_sayaci = {}
        self.uzunluk_a = 0
        self.uzunluk_b = 0
        self.karsilastirilan = 0

    @property
    def ayni(self):
        return self.fark_sayisi == 0 and self.uzunluk_a == self.uzunluk_b


def karsilastir(a_satirlar, b_satirlar, gormezden_gel=()):
    """Iki satir listesini karsilastirir.

    `cycle` karsilastirilmaz: oku() onu 1'den ardisik olmaya zorluyor, yani
    iki tarafta da satir numarasinin aynisi - tek basina bilgi tasimaz.

    Bos girdi ve bos alan listesi REDDEDILIR (IzHatasi): ikisi de "AYRISMA
    YOK" uretirdi ve o cevap yalan olurdu - hicbir sey karsilastirilmadi.
    """
    bakilacak = [a for a in ALANLAR
                 if a != "cycle" and a not in gormezden_gel]
    if not bakilacak:
        raise IzHatasi("karsilastirilacak alan kalmadi (hepsi gormezden "
                       "gelindi) - 'ayni' demek anlamsiz olurdu")
    if not a_satirlar or not b_satirlar:
        raise IzHatasi("bos iz: %s satir yok - karsilastirilacak bir sey yok"
                       % ("iki tarafta da" if not (a_satirlar or b_satirlar)
                          else ("a'da" if not a_satirlar else "b'de")))
    r = Rapor()
    r.uzunluk_a, r.uzunluk_b = len(a_satirlar), len(b_satirlar)
    for i, (sa, sb) in enumerate(zip(a_satirlar, b_satirlar)):
        farklar = [alan for alan in bakilacak if sa[alan] != sb[alan]]
        r.karsilastirilan += 1
        if farklar:
            r.fark_sayisi += 1
            for alan in farklar:
                r.alan_sayaci[alan] = r.alan_sayaci.get(alan, 0) + 1
            if r.ilk_fark is None:
                r.ilk_fark = (i, farklar)
    return r


def _goster(alan, deger):
    """Alan degerini dosyadaki gosterimiyle bas - ondalik sayi degil."""
    genislik, onaltilik = BICIM[alan]
    if deger is None:
        return "-" * (genislik or 1)
    if bilinmeyen_mi(deger):                      # RTL X/Z - ham metin
        return deger
    return ("%0*x" % (genislik, deger)) if onaltilik else str(deger)


def rapor_yaz(r, a_satirlar, b_satirlar, ad_a, ad_b, baglam=3, akis=sys.stdout):
    y = akis.write
    y("karsilastirilan satir : %d\n" % r.karsilastirilan)
    y("%-22s: %d satir\n" % (ad_a, r.uzunluk_a))
    y("%-22s: %d satir\n" % (ad_b, r.uzunluk_b))

    if r.uzunluk_a != r.uzunluk_b:
        uzun, kisa = ((ad_a, r.uzunluk_a), (ad_b, r.uzunluk_b))
        if r.uzunluk_b > r.uzunluk_a:
            uzun, kisa = kisa, uzun
        y("\nUZUNLUK FARKI: %s %d satir fazla. Kisa dosya bitince "
          "karsilastirma durdu.\n" % (uzun[0], uzun[1] - kisa[1]))
        y("  Muhtemel sebep: gorev sonunda taraflardan biri birkac cevrim "
          "daha saat uretiyor (bkz. trace_format S6.4).\n")

    if r.fark_sayisi == 0:
        y("\nAYRISMA YOK.\n" if r.uzunluk_a == r.uzunluk_b
          else "\nOrtak satirlarda ayrisma yok.\n")
        return

    i, farklar = r.ilk_fark
    y("\nILK AYRISMA: satir %d (cycle %s), alan(lar): %s\n"
      % (i + 1, a_satirlar[i]["cycle"], ", ".join(farklar)))

    bas = max(0, i - baglam)
    son = min(min(r.uzunluk_a, r.uzunluk_b), i + baglam + 1)
    #  sutun genisligi = max(baslik, deger) - baslik ile satirlar hizali kalsin
    gen = {ad: max(len(ad), len(_goster(ad, 0))) for ad in ALANLAR}

    def _satir(satir):
        return " ".join(_goster(ad, satir.get(ad)).rjust(gen[ad])
                        for ad in ALANLAR)

    y("\n  %-4s %s %s\n" % ("#", " ",
                             " ".join(ad.rjust(gen[ad]) for ad in ALANLAR)))
    for j in range(bas, son):
        isaret = ">" if j == i else " "
        y("  %-4d %s %s\n" % (j + 1, isaret, _satir(a_satirlar[j])))
        if j == i:
            y("  %-4s %s %s\n" % ("", "|", _satir(b_satirlar[j])))

    y("\n  alan ayrintisi (satir %d):\n" % (i + 1))
    for alan in farklar:
        da, db = a_satirlar[i][alan], b_satirlar[i][alan]
        y("    %-8s %-10s != %-10s%s\n"
          % (alan, _goster(alan, da), _goster(alan, db),
             "   <- X/Z: RTL'de bilinmeyen deger (reset edilmemis ya da "
             "surulmeyen sinyal)" if bilinmeyen_mi(da) or bilinmeyen_mi(db)
             else ""))

    y("\ntoplam ayrisan satir : %d\n" % r.fark_sayisi)
    y("alan bazinda          : %s\n"
      % ", ".join("%s=%d" % (k, v)
                  for k, v in sorted(r.alan_sayaci.items(),
                                     key=lambda x: -x[1])))


def main(argv=None):
    ap = argparse.ArgumentParser(description="iki CLA izini karsilastir")
    ap.add_argument("a", help="birinci iz (genelde Python modeli)")
    ap.add_argument("b", help="ikinci iz (genelde RTL)")
    ap.add_argument("--gormezden-gel", default="", metavar="ALAN[,ALAN...]",
                    help="karsilastirilmayacak alanlar (orn: mpc,exe_op)")
    ap.add_argument("--baglam", type=int, default=3,
                    help="ilk farkin cevresinde kac satir gosterilsin")
    a = ap.parse_args(argv)
    if a.baglam < 0:
        sys.stderr.write("HATA: --baglam negatif olamaz\n")
        return 2

    gormezden = {x.strip() for x in a.gormezden_gel.split(",") if x.strip()}
    bilinmeyen = gormezden - set(ALANLAR)
    if bilinmeyen:
        sys.stderr.write("HATA: bilinmeyen alan: %s\n"
                         % ", ".join(sorted(bilinmeyen)))
        return 2

    try:
        with open(a.a, encoding="utf-8") as f:
            _, satir_a = oku(f)
        with open(a.b, encoding="utf-8") as f:
            _, satir_b = oku(f)
    except (OSError, IzHatasi, UnicodeDecodeError) as e:
        sys.stderr.write("HATA: %s\n" % e)
        return 2

    #  Surum farki burada ayrica denetlenmiyor: oku() yalniz
    #  DESTEKLENEN_SURUMLER'i kabul ediyor, v99 dosyasi zaten yukarida durdu.
    for ad, satirlar in ((a.a, satir_a), (a.b, satir_b)):
        if not satirlar:
            sys.stderr.write(
                "HATA: %s basliktan baska satir icermiyor. Kosu hic "
                "cevrim uretmemis; 'AYRISMA YOK' demek yalan olurdu.\n" % ad)
            return 2

    try:
        r = karsilastir(satir_a, satir_b, gormezden)
    except IzHatasi as e:
        sys.stderr.write("HATA: %s\n" % e)
        return 2
    if gormezden:
        sys.stdout.write("gormezden gelinen alan: %s\n"
                         % ", ".join(sorted(gormezden)))
    rapor_yaz(r, satir_a, satir_b, a.a, a.b, a.baglam)
    return 0 if r.ayni else 1


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception:                              # noqa: BLE001
        #  Python'un yakalanmamis istisnasi cikis kodu 1 verir - bu aracta
        #  1 "ayrisma var" demek. Cokmeyi ayrisma diye raporlamamak icin 2.
        import traceback
        traceback.print_exc()
        sys.stderr.write("HATA: beklenmeyen istisna - karsilastirma "
                         "YAPILMADI\n")
        sys.exit(2)
