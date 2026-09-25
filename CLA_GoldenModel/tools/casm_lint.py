#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""CASM denetleyicisi - donanimin korumadigi uc kurali derleme zamaninda yakalar.

    python3 tools/casm_lint.py gorev.casm
    python3 tools/casm_lint.py gorev.casm --sembol _iref=0x8800 --katı

Kurallar ve gerekceleri: golden_model/lint.py basligi.

Cikis kodu:  0 = hata yok    1 = hata var    2 = dosya/derleme hatasi
`--kati` ile UYARI ve COZULEMEDI de hata sayilir.
"""

import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from golden_model.assembler import AssemblerError          # noqa: E402
from golden_model.lint import COZULEMEDI, HATA, UYARI, denetle   # noqa: E402

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from casm2hex import Casm2HexHatasi, sembolleri_coz        # noqa: E402


def main(argv=None):
    ap = argparse.ArgumentParser(description="CASM boru hatti denetleyicisi")
    ap.add_argument("kaynak", help="girdi .casm dosyasi ('-' = stdin)")
    ap.add_argument("--sembol", action="append", metavar="AD=ADRES",
                    help="veri sembolu (birden fazla kez verilebilir)")
    ap.add_argument("--kati", action="store_true",
                    help="uyari ve cozulemedi de hata sayilsin")
    ap.add_argument("--sadece", metavar="AGIRLIK",
                    choices=(HATA, UYARI, COZULEMEDI),
                    help="yalniz bu agirliktakileri bas")
    a = ap.parse_args(argv)

    try:
        metin = sys.stdin.read() if a.kaynak == "-" else \
            open(a.kaynak, encoding="utf-8").read()
        bulgular = denetle(metin, sembolleri_coz(a.sembol))
    except (AssemblerError, Casm2HexHatasi) as e:
        sys.stderr.write("HATA: %s\n" % e)
        return 2
    except OSError as e:
        sys.stderr.write("HATA: %s\n" % e)
        return 2

    gosterilecek = [b for b in bulgular
                    if a.sadece is None or b.agirlik == a.sadece]
    for b in gosterilecek:
        print(b)

    sayim = {}
    for b in bulgular:
        sayim[b.agirlik] = sayim.get(b.agirlik, 0) + 1
    if not bulgular:
        print("temiz.")
    else:
        print("\n%s" % ", ".join("%s: %d" % (k, sayim[k])
                                 for k in (HATA, UYARI, COZULEMEDI)
                                 if k in sayim))
        if COZULEMEDI in sayim:
            print("NOT: 'cozulemedi' = dolayli adresleme; statik olarak "
                  "ispatlanamadi, TEMIZ DEMEK DEGIL.")

    kotu = [b for b in bulgular
            if b.agirlik == HATA or (a.kati and b.agirlik != HATA)]
    return 1 if kotu else 0


if __name__ == "__main__":
    sys.exit(main())
