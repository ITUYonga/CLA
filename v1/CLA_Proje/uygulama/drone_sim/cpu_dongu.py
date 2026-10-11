# -*- coding: utf-8 -*-
"""Simulasyondaki CPU: dis dongu ve iki hizli zamanlayici.

Gercek C2000'deki is bolumu:

    CPU (C28x)  dis dongu, yavas (50 Hz) : konum PID, anti-windup -> th_d, TV
    CLA         ic dongu, hizli (500 Hz) : aci PD, itki, motorlar (ic_dongu.casm)

Burada CPU'nun yerini PC'deki bu modul aliyor: `Zincir` her ic adimda CLA
gorevini (golden ya da FPGA) cagirir, her `bolum` adimda bir dis donguyu
kendisi hesaplar. Simulasyon zamani duvar saatinden bagimsizdir: CLA'ya
giden yol (USB) yavassa simulasyon agir cekime gecer, sonuc degismez.

Sensorlu duzende (paket.ICK) CPU dis donguyu gecikmeli konum sistemiyle kosar
ve olculen hizlardan gercek ivmeyi kestirip CLA'ya yollar (CLA'nin aci
kestirimi ivmeolcerden bu ivmeyi cikarir). CLA ham IMU'yla aciyi kendisi kestirir.

`ic_yasa` ic_dongu.casm'in float64 aynasi (test ve dongu_hizi.py icin).
"""
import math

import paket


def sinirla(v, alt, ust):
    return max(min(v, ust), alt)


# dis dongu parametreleri (CPU'da; mesaj RAM'ine gitmez)
DIS_PARAM = {
    "KPX": 3.0, "KDX": 3.2, "KIX": 0.8,      # yatay PID  [1/s^2, 1/s, 1/s^3]
    "KPY": 6.0, "KDY": 4.5, "KIY": 2.0,      # dikey PID
    "AXMAX": 8.0, "AYMAX": 6.0, "AYMIN": -3.5,
    "IMAXX": 8.0, "IMAXY": 3.0, "EIMAX": 1.0, "VZONE": 1.0,
    "GYMIN": 2.0, "THMAX": 0.6,
    "M": 0.45, "G": 9.81,                    # kontrolcunun bildigi kutle (yuk takilinca yanlis)
}


class DisDongu(object):
    """Konum PID (kosullu integral: ivme doymadiysa ve |v| < VZONE iken)."""

    def __init__(self, dt, param=None):
        self.dt = dt
        self.p = dict(DIS_PARAM)
        self.p.update(param or {})
        self.sifirla()

    def sifirla(self):
        self.ix = self.iy = 0.0
        self.ax = self.ay = 0.0

    def _eksen(self, e, v, i_eski, kp, kd, ki, amax, amin, imax):
        p = self.p
        a_ham = kp * e + ki * i_eski - kd * v
        a = sinirla(a_ham, amin, amax)
        aday = sinirla(i_eski + sinirla(e, -p["EIMAX"], p["EIMAX"]) * self.dt, -imax, imax)
        if abs(v) >= p["VZONE"]:
            aday = i_eski
        return a, (aday if a_ham == a else i_eski)

    def adim(self, olc, hedef):
        """olc: x, y, vx, vy, th, w; hedef: xr, yr -> (th_d, TV)."""
        p = self.p
        x, y, vx, vy = olc[:4]
        self.ax, self.ix = self._eksen(hedef[0] - x, vx, self.ix, p["KPX"], p["KDX"], p["KIX"],
                                       p["AXMAX"], -p["AXMAX"], p["IMAXX"])
        self.ay, self.iy = self._eksen(hedef[1] - y, vy, self.iy, p["KPY"], p["KDY"], p["KIY"],
                                       p["AYMAX"], p["AYMIN"], p["IMAXY"])
        gy = max(p["G"] + self.ay, p["GYMIN"])
        thd = sinirla(-math.atan(self.ax / gy), -p["THMAX"], p["THMAX"])
        return thd, p["M"] * gy


def ic_yasa(th, w, thd, tv, q):
    """ic_dongu.casm'in float64 karsiligi. q: {sembol: deger} -> (F_L, F_R, T)."""
    t2 = th * th
    c = max(1.0 + t2 * (t2 * q["_C24"] - 0.5), q["_CMIN"])
    T = tv / c
    dF = q["_KTAU"] * (q["_KPT"] * (thd - th) - q["_KDT"] * w)
    return (sinirla(T / 2 - dF, 0.0, q["_FMAX"]), sinirla(T / 2 + dF, 0.0, q["_FMAX"]), T)


class ReferansCla(object):
    """CLA yerine float64 Python (yalniz deney ve test icin)."""
    ad, cevrim, tur_ms, duzen = "Python referansı", 0, None, paket.IC

    def __init__(self, degisen=None):
        self.q = paket.IC.varsayilan()
        self.q.update(degisen or {})

    def adim(self, girdiler):
        return [paket.f2b(v) for v in ic_yasa(*[paket.b2f(b) for b in girdiler], q=self.q)]

    def kapat(self):
        pass


IVME_TAU = 0.05         # olculen hizdan ivme kestiriminin alcak geciren suzgeci [s]


class Zincir(object):
    """CPU'nun zamanlayicisi: her ic adimda CLA gorevi, her `bolum` adimda dis dongu.

    paket.IC  : CLA'ya olculen aci ve acisal hiz gider (ideal sensor).
    paket.ICK : CLA'ya ham IMU gider, aciyi CLA kestirir; CPU konum sisteminden
                ivme kestirip CLA'ya yollar."""

    def __init__(self, cla, ic_hz=500, dis_hz=50, dis_param=None):
        if ic_hz % dis_hz:
            raise ValueError("ic dongu hizi dis dongunun tam kati olmali")
        self.cla, self.ic_hz, self.dis_hz = cla, ic_hz, dis_hz
        self.duzen = getattr(cla, "duzen", paket.IC)
        self.kestirimli = self.duzen.ad == "ick"
        self.dt = 1.0 / ic_hz
        self.bolum = ic_hz // dis_hz
        self.dis = DisDongu(1.0 / dis_hz, dis_param)
        self.sifirla()

    def sifirla(self):
        self.dis.sifirla()
        self.sayac = 0
        self.thd, self.tv = 0.0, self.dis.p["M"] * self.dis.p["G"]
        self.T = self.tv
        self.koru = 0.0                     # ilk adimda CLA'daki kestirim sifirlanir
        self.a_olc, self.v_eski = [0.0, 0.0], None
        self.th_k = 0.0                     # CLA'nin kestirdigi aci

    def adim(self, olc, hedef, imu=None, konum=None):
        """Bir ic adim. olc: gercek durum (x, y, vx, vy, th, w); imu: (gx, fx, fz);
        konum: dis dongu orneginde konum sistemi (x, y, vx, vy). Doner (F_L, F_R).
        CLA hatasi (UART) istisna olarak cikar."""
        if self.sayac % self.bolum == 0:
            kx = list(konum) if konum is not None else list(olc[:4])
            self.thd, self.tv = self.dis.adim(kx + [0.0, 0.0], hedef)
            if self.kestirimli:
                dtd = 1.0 / self.dis_hz
                alfa = dtd / (IVME_TAU + dtd)
                if self.v_eski is not None:
                    for i in (0, 1):
                        self.a_olc[i] += alfa * ((kx[2 + i] - self.v_eski[i]) / dtd - self.a_olc[i])
                self.v_eski = (kx[2], kx[3])
        self.sayac += 1
        if self.kestirimli:
            girdi = (imu[0], imu[1], imu[2], self.thd, self.tv, self.a_olc[0], self.a_olc[1], self.koru)
        else:
            girdi = (olc[4], olc[5], self.thd, self.tv)
        cikti = [paket.b2f(b) for b in self.cla.adim([paket.f2b(v) for v in girdi])]
        self.koru = 1.0
        fl, fr, self.T = cikti[:3]
        self.th_k = cikti[3] if self.kestirimli else olc[4]
        return fl, fr
