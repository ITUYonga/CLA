# -*- coding: utf-8 -*-
"""Ic dongu hizi deneyi: CLA'nin ic donguyu hizlandirmasi ne kazandirir?

Iki govde (fizik.py):  450 g yaris sinifi (tau 15 ms)  ve  ilk 1 kg govde (tau 35 ms).
Ic dongu hizlari: 100, 250, 500, 1000, 2000 Hz. Dis dongu hep 50 Hz (CPU).

1) Bant genisligi: dis dongu kapali, istenen egime 0.05 rad basamak. Kazanc
   KPT = w^2, KDT = 2*0.8*w; w taranir. "Iyi sonumlu" = asim <= %20 ve
   0.6 s sonra kalan hata < %3. En buyuk iyi sonumlu w = w_max.
2) Bozucu bastirma: tam kaskad, hedefte asili; ortalama ruzgar 4 m/s,
   turbulans 3, ani esinti; sensor gurultusu yogunluk modeliyle (ornek
   basina sigma ~ sqrt(hiz): hizli ornekleme gurultusuz bedava degil).
   (a) her hizda AYNI kazanc (100 Hz'de iyi sonumlu en buyuk w)
   (b) her hizda KENDI kazanci (0.8 * w_max): adil karsilastirma.
   Olculen: aci hatasi rms, konum hatasi rms, motor cabasi (itki farki rms).
3) Darbe: asili dururken kola 60 ms'lik tork vurusu (DARBE_TORK). Ayni
   kazanc (500 Hz'inki) ve kendi kazanciyla tepe aci, geri tepme, toparlanma.
   sim.py'deki D tusu ayni darbeyi uygular.

Sonuc dongu_hizi_sonuc.json'a yazilir; sim.py'nin CLA ekrani onu gosterir.

    .venv/bin/python -B dongu_hizi.py
"""
import json
import math
import os
import random
import sys

sys.dont_write_bytecode = True
import paket  # noqa: E402
from cpu_dongu import DisDongu, ic_yasa  # noqa: E402
from fizik import Drone, DroneParam, Ruzgar, G  # noqa: E402

HIZLAR = [100, 250, 500, 1000, 2000]
H_FIZIK = 0.0005
DIS_HZ = 50
ZETA = paket.IC_ZETA
GYRO_YOGUNLUK = 0.03 / math.sqrt(500.0)     # 1 kHz'de ornek basina 0.03 rad/s
ACI_YOGUNLUK = 0.004 / math.sqrt(500.0)
DARBE_TORK, DARBE_SURE = 0.15, 0.06         # [N m], [s]


def ic_param(p, w):
    q = paket.IC.varsayilan()
    q.update({"_KPT": w * w, "_KDT": 2 * ZETA * w, "_KTAU": p.ktau, "_FMAX": p.F_max})
    return q


def kos(p, hz, w, sure, basamak=None, ruzgar=None, gurultu=False, tohum=1, darbe_t=None):
    """Doner: kayit listesi [(t, th, thd, x, y, dF)]."""
    d = Drone(p, x=0.0, y=5.0)
    d.yerde = False
    h0 = p.kutle * G / 2
    d.s[6] = d.s[7] = h0
    q = ic_param(p, w)
    dis = DisDongu(1.0 / DIS_HZ, {"M": p.m})
    bolum = hz // DIS_HZ if hz >= DIS_HZ else 1
    alt = max(1, int(round(1.0 / hz / H_FIZIK)))
    h = 1.0 / hz / alt
    r = random.Random(tohum)
    sg = GYRO_YOGUNLUK * math.sqrt(hz / 2.0) if gurultu else 0.0
    sa = ACI_YOGUNLUK * math.sqrt(hz / 2.0) if gurultu else 0.0
    thd, tv = 0.0, p.m * G
    t, k, kayit = 0.0, 0, []
    while t < sure:
        th = d.th + (r.gauss(0, sa) if sa else 0.0)
        om = d.w + (r.gauss(0, sg) if sg else 0.0)
        if basamak is not None:
            thd, tv = (basamak if t >= 0.1 else 0.0), p.kutle * G
        elif k % bolum == 0:
            thd, tv = dis.adim([d.x, d.y, d.vx, d.vy, th, om], (0.0, 5.0))
        fl, fr, _ = ic_yasa(th, om, thd, tv, q)
        for _ in range(alt):
            if darbe_t is not None:
                d.ek_tork = DARBE_TORK if darbe_t <= t < darbe_t + DARBE_SURE else 0.0
            hz_r = ruzgar.hiz(t) if ruzgar else (0.0, 0.0, 0.0)
            if ruzgar:
                ruzgar.adim(t, h)
            d.adim(h, (fl, fr), hz_r)
            t += h
        k += 1
        kayit.append((t, d.th, thd, d.x, d.y, (fr - fl) / 2))
        if abs(d.th) > 1.2 or d.carpti:
            return None
    return kayit


def iyi_sonumlu(p, hz, w, a=0.05):
    k = kos(p, hz, w, 1.0, basamak=a)
    if k is None:
        return False
    th = [s[1] for s in k if s[0] >= 0.1]
    if max(th) > 1.2 * a:
        return False
    kuyruk = [abs(s[1] - a) for s in k if s[0] >= 0.7]
    return max(kuyruk) < 0.03 * a


def w_max(p, hz):
    w, en_iyi = 4.0, None
    while w < 400:
        if iyi_sonumlu(p, hz, w):
            en_iyi = w
        elif en_iyi is not None and w > 1.5 * en_iyi:
            break
        w *= 1.08
    return en_iyi


def bozucu(p, hz, w, tohum=3):
    r = Ruzgar(tohum=tohum)
    r.ortalama, r.turbulans = 4.0, 3
    r.esinti(4.0)
    k = kos(p, hz, w, 12.0, ruzgar=r, gurultu=True, tohum=tohum)
    if k is None:
        return None
    k = [s for s in k if s[0] >= 2.0]
    rms = lambda v: math.sqrt(sum(x * x for x in v) / len(v))   # noqa: E731
    return {"aci_rms_derece": math.degrees(rms([s[1] - s[2] for s in k])),
            "konum_rms_cm": 100 * rms([math.hypot(s[3], s[4] - 5.0) for s in k]),
            "caba_N": rms([s[5] for s in k])}


def darbe(p, hz, w):
    k = kos(p, hz, w, 2.0, darbe_t=0.5)
    if k is None:
        return None
    th = [(s[0], s[1]) for s in k]
    tepe = max(abs(a) for _, a in th)
    geri = min(a for t, a in th if t > 0.5 + DARBE_SURE)
    otur = max([t for t, a in th if abs(a) > 0.1 * tepe] or [0.5]) - 0.5
    return {"tepe_derece": math.degrees(tepe), "geri_derece": math.degrees(geri), "toparlanma_ms": 1000 * otur}


def main():
    sonuc = {"hizlar": HIZLAR, "govdeler": []}
    for p in (DroneParam(), DroneParam.eski_1kg()):
        print("\n== %s  (tau_motor %.0f ms, I %.2g, L %.2f)" % (p.ad, p.tau_motor * 1e3, p.I, p.L))
        wm = {hz: w_max(p, hz) for hz in HIZLAR}
        w_sabit = wm[HIZLAR[0]]
        g = {"ad": p.ad, "tau_ms": p.tau_motor * 1e3, "w_max": wm, "sabit": {}, "ayarli": {}}
        print("%6s  %7s | %-28s | %-28s" % ("hiz", "w_max", "ayni kazanc (w=%.0f)" % w_sabit,
                                            "kendi kazanci (0.8 w_max)"))
        for hz in HIZLAR:
            a = bozucu(p, hz, w_sabit)
            b = bozucu(p, hz, 0.8 * wm[hz])
            g["sabit"][hz], g["ayarli"][hz] = a, b
            f = lambda s: ("aci %.2f°  konum %.1f cm  caba %.2f N" % (   # noqa: E731
                s["aci_rms_derece"], s["konum_rms_cm"], s["caba_N"])) if s else "kararsiz"
            print("%5d   %6.1f | %s | %s" % (hz, wm[hz], f(a), f(b)))
        w500 = 0.8 * wm[500]
        g["darbe_sabit"], g["darbe_ayarli"] = {}, {}
        print("  darbe %.2f N m, %.0f ms:  ayni kazanc (500 Hz'inki)       | kendi kazanci" % (
            DARBE_TORK, DARBE_SURE * 1e3))
        for hz in HIZLAR:
            a, b = darbe(p, hz, w500), darbe(p, hz, 0.8 * wm[hz])
            g["darbe_sabit"][hz], g["darbe_ayarli"][hz] = a, b
            f = lambda s: ("tepe %.1f°  geri %+.1f°  %3.0f ms" % (    # noqa: E731
                s["tepe_derece"], s["geri_derece"], s["toparlanma_ms"])) if s else "kararsiz"
            print("%5d   %s | %s" % (hz, f(a), f(b)))
        sonuc["govdeler"].append(g)
    yol = os.path.join(os.path.dirname(os.path.abspath(__file__)), "dongu_hizi_sonuc.json")
    with open(yol, "w") as f:
        json.dump(sonuc, f, indent=1)
    print("\n-> %s" % yol)


if __name__ == "__main__":
    main()
