# -*- coding: utf-8 -*-
"""derle.py - drone.casm -> L3 hex (bitstream) + sw/drone_cla.h (sunucunun MVECT degerleri).

    python3 drone_uret.py && python3 derle.py

Uretilenler:
  drone_l3.hex      PROGRAM_HEX olarak cla_wrapper'a verilir (satir basina 16 bit , alt adres once , 4096 satir)
  ../sw/drone_cla.h radar_server: MVECT1..8 ve gorev maskeleri
Program degisirse bitstream yeniden uretilir ve sunucu yeniden derlenir (ikisi birlikte).
core.py bu klasorde ya da CLA_CORE ortam degiskeninde olmali.
"""
import os
import re
import sys
import zlib

burasi = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(burasi, "..", "pc"))
from cla_golden import GoldenCla, core  # noqa: E402


def main():
    casm = os.path.join(burasi, "drone.casm")
    g = GoldenCla(casm)                                 # assemble + lint (HATA varsa durur)
    metin = open(casm, encoding="utf-8").read()
    for b in core.denetle(metin, {m.group(1): int(m.group(2), 0) for m in
                                  re.finditer(r";#sembol\s+(\S+)\s+(\S+)", metin)}, g.kelimeler):
        print("  lint: %s" % b)
    satirlar = core.hex_satirlari(g.kelimeler, genislik=16, doldur=core.L3_WORD)
    with open(os.path.join(burasi, "drone_l3.hex"), "w", newline="\n") as f:
        f.write("\n".join(satirlar) + "\n")
    imza = zlib.crc32(b"".join(w.to_bytes(4, "little") for w in g.kelimeler)) & 0xFFFFFFFF
    with open(os.path.join(burasi, "..", "sw", "drone_cla.h"), "w", newline="\n") as f:
        f.write("/* drone_cla.h - cla/derle.py uretti , elle duzenlemeyin */\n")
        f.write("#ifndef DRONE_CLA_H\n#define DRONE_CLA_H\n\n")
        f.write("#define DRONE_CLA_KOMUT  %d\n" % len(g.kelimeler))
        f.write("#define DRONE_CLA_CRC    0x%08XU   /* program kelimelerinin crc32'si */\n" % imza)
        for i, v in enumerate(g.mvect):
            f.write("#define DRONE_MVECT%d     0x%03X\n" % (i + 1, v))
        f.write("#define DRONE_MIER       0x8FU     /* gorev 1-4 ve 8 */\n")
        f.write("#define DRONE_GOREV_SIFIRLA 0x80U\n")
        f.write("\n#endif\n")
    print("drone_l3.hex: %d komut (%d / %d word) , crc32 0x%08X" % (len(g.kelimeler), 2 * len(g.kelimeler),
                                                                     core.L3_WORD, imza))
    print("MVECT: %s" % " ".join("%d=0x%03X" % (i + 1, v) for i, v in enumerate(g.mvect) if v))


if __name__ == "__main__":
    main()
