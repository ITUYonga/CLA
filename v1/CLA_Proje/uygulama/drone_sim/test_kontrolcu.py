# -*- coding: utf-8 -*-
"""CLA programlarinin dogrulamasi (uc mimari).

ic_kestirim.casm (ICK), ic_dongu.casm (IC) ve kontrolcu.casm (TEK) icin:
1) Golden'da kosan CLA programi, ayni kontrol yasasinin Python (float64)
   referansiyla karsilastirilir: 2000 rastgele adim, goreli hata < 1e-4.
2) Golden'in boru hatti ve ardisik modelleri bit bit ayni cikti vermeli.
3) Gorev suresi girdiden bagimsiz (dalsiz kod): her adimda ayni cevrim.

    .venv/bin/python test_kontrolcu.py
"""
import random
import sys

import paket
from cpu_dongu import ic_yasa
from sensor import kestirim_yasa
from kontrolcu import GoldenKontrolcu

sys.dont_write_bytecode = True
P = paket.TEK.varsayilan()


def sinirla(v, alt, ust):
    return max(min(v, ust), alt)


class Referans(object):
    def __init__(self):
        self.ix = self.iy = 0.0

    def _eksen(self, e, v, i_eski, kp, kd, ki, amax, amin, imax):
        a_ham = kp * e + ki * i_eski - kd * v
        a = sinirla(a_ham, amin, amax)
        aday = sinirla(i_eski + sinirla(e, -P["_EIMAX"], P["_EIMAX"]) * P["_DT"], -imax, imax)
        if abs(v) >= P["_VZONE"]:
            aday = i_eski
        return a, (aday if a_ham == a else i_eski)

    def adim(self, x, y, vx, vy, th, w, xr, yr, koru):
        self.ix, self.iy = self.ix * koru, self.iy * koru
        ax, self.ix = self._eksen(xr - x, vx, self.ix, P["_KPX"], P["_KDX"], P["_KIX"],
                                  P["_AXMAX"], -P["_AXMAX"], P["_IMAXX"])
        ay, self.iy = self._eksen(yr - y, vy, self.iy, P["_KPY"], P["_KDY"], P["_KIY"],
                                  P["_AYMAX"], P["_AYMIN"], P["_IMAXY"])
        gy = max(P["_G"] + ay, P["_GYMIN"])
        u = sinirla(ax / gy, -P["_UMAX"], P["_UMAX"])
        u2 = u * u
        thd = sinirla(-u * (1 + u2 * (u2 * P["_C5"] - P["_C3"])), -P["_THMAX"], P["_THMAX"])
        t2 = th * th
        c = max(1 + t2 * (t2 * P["_C24"] - 0.5), P["_CMIN"])
        T = P["_M"] * gy / c
        dF = P["_KTAU"] * (P["_KPT"] * (thd - th) - P["_KDT"] * w)
        fr = sinirla(T / 2 + dF, 0.0, P["_FMAX"])
        fl = sinirla(T / 2 - dF, 0.0, P["_FMAX"])
        return [fl, fr, thd, T, self.ix, self.iy]


def karsilastir(duzen, uret, referans, esitle=None, n=2000):
    r = random.Random(2026)
    boru, ardisik = GoldenKontrolcu(duzen=duzen, model="boru"), GoldenKontrolcu(duzen=duzen, model="ardisik")
    en_kotu, bit_fark, cevrimler = 0.0, 0, set()
    for k in range(n):
        g = [paket.b2f(paket.f2b(v)) for v in uret(r, k)]       # float32'ye yuvarla
        bits = [paket.f2b(v) for v in g]
        c1, c2 = boru.adim(bits), ardisik.adim(bits)
        cevrimler.add(boru.cevrim)
        if c1 != c2:
            bit_fark += 1
        for ad, gelen, bek in zip([c[0] for c in duzen.ciktilar], c1, referans(g)):
            gel = paket.b2f(gelen)
            hata = abs(gel - bek) / max(1.0, abs(bek))
            en_kotu = max(en_kotu, hata)
            if hata > 1e-4:
                print("FARK %s adim %d %s: golden %.6f referans %.6f" % (duzen.ad, k, ad, gel, bek))
                return False
        if esitle:
            esitle(c1)
    tamam = bit_fark == 0 and len(cevrimler) == 1
    print("%-4s %d adim: golden ~ referans (en kotu %.2e), boru == ardisik: %s, cevrim: %s  [%d buyruk]"
          % (duzen.ad, n, en_kotu, "evet" if bit_fark == 0 else "%d adimda FARK" % bit_fark,
             "hep %d" % min(cevrimler) if len(cevrimler) == 1 else sorted(cevrimler), boru.komut_sayisi))
    return tamam


def main():
    qk = paket.ICK.varsayilan()
    durum = {"th": 0.0}

    def ick_uret(r, k):
        g = paket.ICK.rastgele_girdi(r)
        if k % 7 == 0:                      # serbest dusus / ters: g_bz alt siniri, u siniri
            g[2] = r.uniform(-5.0, 1.5)
        if k % 50 == 0:
            g[7] = 0.0                      # KORU = 0: kestirim sifirlanir
        return g

    def ick_ref(g):
        th = kestirim_yasa(durum["th"], g[0], g[1], g[2], g[5], g[6], g[7], qk)
        return list(ic_yasa(th, g[0], g[3], g[4], q=qk)) + [th]

    def ick_esitle(c):
        durum["th"] = paket.b2f(c[3])       # L1'deki kestirimi referansla esitle

    ok0 = karsilastir(paket.ICK, ick_uret, ick_ref, ick_esitle)

    q = paket.IC.varsayilan()

    def ic_uret(r, k):
        g = paket.IC.rastgele_girdi(r)
        if k % 4 == 0:                      # buyuk aci: cos alt siniri ve motor doymasi
            g[0] = r.uniform(-1.2, 1.2)
        return g

    ok1 = karsilastir(paket.IC, ic_uret, lambda g: ic_yasa(*g, q=q))

    ref = Referans()

    def tek_uret(r, k):
        g = [r.uniform(-10, 10), r.uniform(0, 14), r.gauss(0, 2), r.gauss(0, 2),
             r.gauss(0, 0.3), r.gauss(0, 2), r.uniform(-10, 10), r.uniform(0.5, 14),
             0.0 if k % 50 == 0 else 1.0]
        if k % 3 == 0:                      # yakin hedef: integratorler calissin
            g[6], g[7], g[2], g[3] = g[0] + r.gauss(0, 0.3), g[1] + r.gauss(0, 0.3), r.gauss(0, 0.3), r.gauss(0, 0.3)
        return g

    def tek_esitle(c):
        ref.ix, ref.iy = paket.b2f(c[4]), paket.b2f(c[5])   # integrator durumunu esitle

    ok2 = karsilastir(paket.TEK, tek_uret, lambda g: ref.adim(*g), tek_esitle)
    return 0 if ok0 and ok1 and ok2 else 1


if __name__ == "__main__":
    sys.exit(main())
