#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""MEINVF32 / MEISQRTF32 kestirim tablosunu isa/estimate_lut.hex'e yazar.

    python3 tools/lut_uret.py              # dosyayi (yeniden) uret
    python3 tools/lut_uret.py --denetle    # dosya formulle ayni mi? (0/1)

Tek kaynak `golden_model/ops_estimate.py`'deki formul; bu arac yalniz onu
dosyaya doker. Dosyayi ELLE DUZELTMEYIN: test (tests/test_estimate.py)
formulden sapmayi yakalar. Duzen ve yontem: ops_estimate.py.
"""

import argparse
import os
import sys

KOK = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, KOK)

from golden_model import ops_estimate as KES                  # noqa: E402

VARSAYILAN = os.path.join(KOK, "isa", KES.LUT_DOSYASI)


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("-o", "--cikti", default=VARSAYILAN)
    ap.add_argument("--denetle", action="store_true",
                    help="yazma; dosya formulle ayni degilse 1 ile cik")
    a = ap.parse_args(argv)
    satirlar = KES.lut_satirlari()
    if a.denetle:
        try:
            with open(a.cikti, encoding="ascii") as f:
                dosya = f.read().split()
        except OSError as e:
            sys.stderr.write("HATA: %s\n" % e)
            return 2
        if dosya != satirlar:
            fark = next((i for i, (x, y) in enumerate(zip(dosya, satirlar))
                         if x != y), min(len(dosya), len(satirlar)))
            sys.stderr.write("FARKLI: %s formulle ayni degil (ilk fark adres "
                             "0x%03x, %d/%d satir)\n"
                             % (a.cikti, fark, len(dosya), len(satirlar)))
            return 1
        print("ayni: %s (%d giris)" % (a.cikti, len(satirlar)))
        return 0
    with open(a.cikti, "w", encoding="ascii", newline="\n") as f:
        f.write("\n".join(satirlar) + "\n")
    print("%d giris -> %s" % (len(satirlar), a.cikti))
    return 0


if __name__ == "__main__":
    sys.exit(main())
