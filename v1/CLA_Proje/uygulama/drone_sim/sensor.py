# -*- coding: utf-8 -*-
"""Sensor modelleri ve aci kestiriminin float64 karsiligi.

IMU (her ic adimda, govde ekseninde):
    jiroskop   gx = w + b_g + n_g                       [rad/s]
    ivmeolcer  f  = R(-th) (a + g) + b_a + n_a           [m/s^2] ozgul kuvvet (fx, fz)
  a, son ic adimdaki ortalama ivme (hiz farkindan; yer temasi dahil).
  Gurultu yogunlukla verilir: ornek basina sigma = yogunluk * sqrt(hiz/2).
  Yogunluklar MEMS degerinin ustune motor titresimini de katar (taban: hafif titresim).
  Sabitler (b_g, b_a) her sifirlamada yeniden cekilir: kalibrasyon sonrasi kalinti.
Konum sistemi (dis dongu hizinda, bir ornek gecikmeli): x, y, vx, vy + gurultu
  (kamera tabanli konum sistemi / optik akis + UWB gibi).

Aci kestirimi (CLA'da, ic_kestirim.casm; burada aynasi): tamamlayici suzgec
    th_tahmin = th + gx dt
    g_govde   = f - R(-th_tahmin) a_istek        (CPU'nun istedigi ivme cikarilir)
    th_ivme   = atan(g_x / g_z)
    th        = th_tahmin + K (th_ivme - th_tahmin),   K = dt / tau
  Ivmeolcer manevrada yalniz yercekimini olcmez; CPU'nun bildigi istenen ivme
  cikarilmazsa kestirim manevralarda derecelerce kayar (sensor_deney.py).
"""
import math
import random

G = 9.81

# atan(x), |x| <= 1: Abramowitz & Stegun 4.4.47, hata < 1e-5
ATAN_K = (0.9998660, -0.3302995, 0.1801410, -0.0851330, 0.0208351)


def atan_yaklasik(u):
    u2 = u * u
    p = ATAN_K[4]
    for c in (ATAN_K[3], ATAN_K[2], ATAN_K[1], ATAN_K[0]):
        p = p * u2 + c
    return u * p


def sin_yaklasik(t):
    t2 = t * t
    return t * (1.0 + t2 * (t2 / 120.0 - 1.0 / 6.0))


def cos_yaklasik(t):
    t2 = t * t
    return 1.0 + t2 * (t2 / 24.0 - 0.5)


class SensorSeti(object):
    def __init__(self, ic_hz=500, dis_hz=50, tohum=None):
        self.ic_hz, self.dis_hz = ic_hz, dis_hz
        self.r = random.Random(tohum)
        self.titresim = 1.0                 # N tusu: 3 (guclu titresim)
        self.gyro_yog = 6.3e-4              # rad/s/sqrt(Hz)  (~0.01 rad/s @500 Hz)
        self.ivme_yog = 0.019               # m/s^2/sqrt(Hz)  (~0.3 m/s^2 @500 Hz)
        self.gyro_sabit_s = math.radians(0.3)
        self.ivme_sabit_s = 0.05
        self.konum_s, self.hiz_s = 0.01, 0.03
        self.sifirla()

    def sifirla(self):
        self.b_g = self.r.gauss(0, self.gyro_sabit_s)
        self.b_ax, self.b_az = self.r.gauss(0, self.ivme_sabit_s), self.r.gauss(0, self.ivme_sabit_s)
        self.bekleyen = None                # gecikmeli konum olcumu
        self.a = (0.0, 0.0)                 # son ic adimdaki ivme

    def ivme_guncelle(self, v_once, v_sonra, dt):
        self.a = ((v_sonra[0] - v_once[0]) / dt, (v_sonra[1] - v_once[1]) / dt)

    def imu(self, d):
        """(gx, fx, fz): govde ekseninde jiroskop ve ozgul kuvvet."""
        k = math.sqrt(self.ic_hz / 2.0) * self.titresim
        th = d.th
        fwx, fwz = self.a[0], self.a[1] + G
        c, s = math.cos(th), math.sin(th)
        fx = c * fwx + s * fwz + self.b_ax + self.r.gauss(0, self.ivme_yog * k)
        fz = -s * fwx + c * fwz + self.b_az + self.r.gauss(0, self.ivme_yog * k)
        gx = d.w + self.b_g + self.r.gauss(0, self.gyro_yog * k)
        return gx, fx, fz

    def konum(self, d):
        """Bir dis dongu ornegi gecikmeli (x, y, vx, vy)."""
        yeni = (d.x + self.r.gauss(0, self.konum_s), d.y + self.r.gauss(0, self.konum_s),
                d.vx + self.r.gauss(0, self.hiz_s), d.vy + self.r.gauss(0, self.hiz_s))
        eski, self.bekleyen = self.bekleyen, yeni
        return eski if eski is not None else yeni


def kestirim_yasa(th, gx, fx, fz, axw, ayw, koru, q):
    """ic_kestirim.casm'in aci kestirimi (float64, adim adim ayni). q: paket.ICK parametreleri."""
    tp = koru * th + gx * q["_DT"]
    t2 = tp * tp
    c = 1.0 + t2 * (t2 * q["_C24"] - 0.5)
    s = tp * (1.0 + t2 * (t2 * q["_C120"] - q["_C6"]))
    gbx = fx - (axw * c + ayw * s)
    gbz = max(fz - (-axw * s + ayw * c), q["_FZMIN"])
    u = max(min(gbx / gbz, q["_UMAX"]), -q["_UMAX"])
    u2 = u * u
    p = q["_A9"]
    for k in ("_A7", "_A5", "_A3", "_A1"):
        p = p * u2 + q[k]
    return tp + q["_KK"] * (u * p - tp)
