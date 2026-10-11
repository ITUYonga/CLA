# -*- coding: utf-8 -*-
"""CLA programi -> program RAM'i (L3) icin $readmemh dosyasi.

Golden'in (core.py) casm2hex bolumu ile ayni yerlesim (16 bit/satir, LSW once);
paket.py sembolleri verilir ve once boru hatti lint'i kosar.

    .venv/bin/python -B l3_uret.py                       # ic_kestirim_l3.hex (16 bit, sensorlu)
    .venv/bin/python -B l3_uret.py --mimari ic           # ic_dongu_l3.hex (ideal sensor)
    .venv/bin/python -B l3_uret.py --mimari tek          # kontrolcu_l3.hex (ilk surum)
    .venv/bin/python -B l3_uret.py --genislik 32 --doldur 4096
"""
import argparse
import os
import sys

sys.dont_write_bytecode = True
import paket  # noqa: E402
from kontrolcu import VARSAYILAN_GOLDEN  # noqa: E402


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--mimari", choices=("ick", "ic", "tek"), default="ick")
    ap.add_argument("-o", "--cikti", help="varsayilan: <program>_l3.hex, programin yaninda")
    ap.add_argument("--genislik", type=int, choices=(16, 32), default=16)
    ap.add_argument("--doldur", type=int, default=None, help="16 bitlik kelime sayisina sifirla tamamla (4096 = tam L3)")
    ap.add_argument("--yorum", action="store_true")
    a = ap.parse_args()

    sys.path.insert(0, os.path.abspath(VARSAYILAN_GOLDEN))
    from core import cevir, denetle, HATA

    D = paket.DUZENLER[a.mimari]
    a.cikti = a.cikti or os.path.splitext(D.casm)[0] + "_l3.hex"
    metin = open(D.casm, encoding="utf-8").read()
    sem = D.semboller()
    satirlar, kelimeler = cevir(metin, a.genislik, a.doldur, a.yorum, semboller=sem)
    hatalar = [b for b in denetle(metin, sem, kelimeler) if b.agirlik == HATA]
    if hatalar:
        sys.exit("lint hatasi, hex uretilmedi:\n" + "\n".join(map(str, hatalar)))
    with open(a.cikti, "w") as f:
        f.write("\n".join(satirlar) + "\n")
    print("%s: %d komut, %d satir (%d bit)" % (a.cikti, len(kelimeler), len(satirlar), a.genislik))


if __name__ == "__main__":
    main()
