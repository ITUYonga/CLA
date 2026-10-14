# -*- coding: utf-8 -*-
"""cla_dongu.py - drone.casm'i golden modelde kapali dongude kosturur (kart gerekmez).

    python3 cla_dongu.py [adim] [--c-ref]

Fizik: sw/sim_fizik.c (pc/libsim.so). Her adim golden CLA ile hesaplanir; --c-ref verilirse
ayni adim sw/cla_ref.c ile de hesaplanir ve C2M bit bit karsilastirilir (SAHTE_DONANIM dogrulamasi).
Senaryo: kalkis , hedef degisimi , ruzgar , darbe , motor verimi , ek yuk , gozlemci kapat/ac.
"""
import os
import sys
import time

burasi = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(burasi, "..", "pc"))
from sim_baglanti import *            # noqa: E402,F403
from cla_golden import GoldenCla       # noqa: E402

OLAYLAR = {0: (SK_HEDEF, (0, 0, 2)), 1500: (SK_HEDEF, (2, 1, 2)), 3000: (SK_RUZGAR, (6, 0, 0)),
           4500: (SK_DARBE, (0, 8, 0), (0.3, 0)), 6000: (SK_MOTOR, (0, 0, 0), (1, 0.7)),
           7000: (SK_YUK, (0, 0, 0), (0.3, 0)), 8000: (SK_GOZLEMCI, (0, 0, 0), (0, 0)),
           8500: (SK_RUZGAR, (-6, 0, 0)), 9500: (SK_GOZLEMCI, (0, 0, 0), (1, 0))}


def main():
    n = int(next((a for a in sys.argv[1:] if a.isdigit()), 3000))
    cref = "--c-ref" in sys.argv
    g = GoldenCla(os.path.join(burasi, "drone.casm"))
    d = Drone()
    c, _ = g.calistir(0x80, d.m2c(), [0] * 64)
    ck = list(c)
    fark, cmaks, t0 = 0, 0, time.time()
    for i in range(n):
        if i in OLAYLAR:
            d.komut(*OLAYLAR[i])
        m, mk = d.m2c(), d.maske()
        if cref:
            ck = list(c)
            cla_ref(d.lib, mk, m, ck)
        c, cy = g.calistir(mk, m, c)
        cmaks = max(cmaks, cy)
        if cref and ck[:C_DURUM_SAYI] != c[:C_DURUM_SAYI]:
            fark += 1
            if fark <= 3:
                k = [j for j in range(C_DURUM_SAYI) if ck[j] != c[j]]
                print("adim %d maske 0x%x: farkli kelimeler %s" % (i, mk, k[:8]))
        d.c2m_al(c)
        d.adim()
        if i % 500 == 0 or i == n - 1:
            s = d.s
            hata = sum((a - b) ** 2 for a, b in zip(s.poz, s.hedef)) ** 0.5
            print("%6d poz %6.2f %6.2f %6.2f  hata %.3f m  u %.2f %.2f %.2f %.2f  kestirim %5.2f %5.2f %5.2f"
                  % ((i,) + tuple(s.poz) + (hata,) + tuple(s.u) + tuple(s.kestirim)))
    print("%d adim , %.1f s , en uzun adim %d cevrim%s" % (n, time.time() - t0, cmaks,
          (" , C referans ile farkli adim: %d" % fark) if cref else ""))
    return 1 if fark else 0


if __name__ == "__main__":
    sys.exit(main())
