# -*- coding: utf-8 -*-
"""2B (duzlemsel) quadrotor fizigi ve ruzgar modeli.

Koordinatlar: x saga, y yukari [m]. th: govdenin egimi, saat yonu tersi +.
Iki motor, govde merkezinden L uzakta; itki govdeye dik (govde yukarisi).

    m x'' = -(F_L + F_R) sin th + D_x
    m y'' =  (F_L + F_R) cos th + D_y - m g
    I th''= (F_R - F_L) L - c_w w + tau_ruzgar
    F'    = (F_istek - F) / tau_motor          (motor gecikmesi)

D: bagil hava hizina gore dogrusal + karesel surtunme. RK4, adim disaridan (0.5 ms).
"""
import math
import random

G = 9.81


class DroneParam(object):
    """Varsayilan: ~450 g, 4-5 inc pervaneli kucuk (yaris sinifi) quad.

    Duzlemsel modelde her "motor" bir yandaki iki motoru temsil eder.
    Degerler bu sinif icin tipik mertebeler, OLCULMUS DEGIL:
      kol 0.09 m (yunuslama ekseninde motor - agirlik merkezi mesafesi),
      eylemsizlik ~4 x 30 g motor + govde -> 1.3e-3 kg m^2,
      motor + pervane zaman sabiti 10-20 ms (hafif pervane) -> 15 ms,
      itki/agirlik ~5.4 (yan basina 12 N).
    Eski 1 kg'lik govde karsilastirma icin: DroneParam.eski_1kg().
    """

    def __init__(self):
        self.kod, self.ad = "yaris", "450 g yarış sınıfı"
        self.m = 0.45           # govde kutlesi [kg]
        self.yuk = 0.0          # takili yuk [kg]
        self.yuk_ek = 0.15      # Y tusuyla takilan yuk [kg] (kontrolcu bilmez)
        self.L = 0.09           # motor kolu [m]
        self.I = 1.3e-3         # eylemsizlik [kg m^2]
        self.tau_motor = 0.015  # motor zaman sabiti [s]
        self.F_max = 12.0       # yan basina itki siniri [N] (2 motor)
        self.c_lin = 0.02       # dogrusal surtunme [N s/m]
        self.c_kare = 0.012     # karesel surtunme [N s^2/m^2] (1/2 rho Cd A, A ~ 0.02 m^2)
        self.c_w = 0.0005       # donus sonumu [N m s]
        self.c_ruzgar_tork = 0.0006   # bagil yatay hizdan dogan tork [N s]
        self.c_turb_tork = 0.0025     # turbulans torku katsayisi [N m / birim]
        self.ayak = 0.04        # govde merkezinin yere yuksekligi (ayaklar) [m]

    @classmethod
    def eski_1kg(cls):
        """Ilk surumdeki 1 kg, 35 ms'lik govde (karsilastirma icin)."""
        p = cls()
        p.kod, p.ad = "eski", "1 kg (ilk sürüm)"
        p.m, p.yuk_ek, p.L, p.I, p.tau_motor, p.F_max = 1.0, 0.4, 0.25, 0.012, 0.035, 11.0
        p.c_lin, p.c_kare, p.c_w, p.c_ruzgar_tork, p.c_turb_tork, p.ayak = 0.05, 0.045, 0.004, 0.006, 0.02, 0.09
        return p

    @property
    def kutle(self):
        return self.m + self.yuk

    @property
    def ktau(self):
        """Aci ivmesi -> itki farki (yan basina): I / (2L) [kg m]."""
        return self.I / (2.0 * self.L)


class Ruzgar(object):
    """Ortalama ruzgar + Ornstein-Uhlenbeck turbulans + 1-cos ani esinti."""

    def __init__(self, tohum=7):
        self.ortalama = 0.0     # [m/s], + saga
        self.turbulans = 1      # 0..3
        self.r = random.Random(tohum)
        self.tx = self.ty = self.tw = 0.0
        self.esinti_t = None    # esinti baslangic zamani
        self.esinti_A = 0.0
        self.esinti_T = 2.0

    def esinti(self, t, genlik=7.0):
        yon = 1.0 if self.ortalama >= 0 else -1.0
        self.esinti_t, self.esinti_A = t, yon * genlik

    def adim(self, t, dt):
        tau = 1.2
        s = 1.1 * self.turbulans
        a = math.exp(-dt / tau)
        b = s * math.sqrt(1 - a * a)
        self.tx = a * self.tx + b * self.r.gauss(0, 1)
        self.ty = a * self.ty + 0.45 * b * self.r.gauss(0, 1)
        self.tw = a * self.tw + 0.6 * b * self.r.gauss(0, 1)

    def esinti_degeri(self, t):
        if self.esinti_t is None:
            return 0.0
        u = (t - self.esinti_t) / self.esinti_T
        if u < 0 or u > 1:
            if u > 1:
                self.esinti_t = None
            return 0.0
        return self.esinti_A * 0.5 * (1 - math.cos(2 * math.pi * u))

    def hiz(self, t):
        """(wx, wy, tork_turbulansi) - drone konumundaki ruzgar."""
        return (self.ortalama + self.tx + self.esinti_degeri(t), self.ty, self.tw)


class Drone(object):
    """Durum: x, y, vx, vy, th, w, F_L, F_R (gercek motor itkileri)."""

    def __init__(self, p=None, x=0.0, y=None):
        self.p = p or DroneParam()
        self.sifirla(x, y)

    def sifirla(self, x=0.0, y=None):
        y = self.p.ayak if y is None else y
        self.s = [x, y, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        self.yerde = y <= self.p.ayak + 1e-6
        self.carpti = False
        self.carpma_mesaji = ""
        self.ek_tork = 0.0                  # dis darbe torku [N m] (D tusu: kola vurus)

    # ---- turev ----------------------------------------------------------
    def _turev(self, s, istek, ruzgar):
        p = self.p
        x, y, vx, vy, th, w, fl, fr = s
        wx, wy, wt = ruzgar
        rx, ry = vx - wx, vy - wy
        v = math.hypot(rx, ry)
        dx = -p.c_lin * rx - p.c_kare * v * rx
        dy = -p.c_lin * ry - p.c_kare * v * ry
        T = fl + fr
        m = p.kutle
        ax = (-T * math.sin(th) + dx) / m
        ay = (T * math.cos(th) + dy) / m - G
        tork = (fr - fl) * p.L - p.c_w * w + p.c_ruzgar_tork * rx + p.c_turb_tork * wt + self.ek_tork
        al = tork / p.I
        fl_hedef, fr_hedef = istek
        return [vx, vy, ax, ay, w, al,
                (fl_hedef - fl) / p.tau_motor, (fr_hedef - fr) / p.tau_motor]

    def adim(self, dt, istek, ruzgar):
        """istek: (F_L, F_R) motor istekleri [N]; ruzgar: (wx, wy, tork)."""
        p = self.p
        if self.carpti:
            istek = (0.0, 0.0)
        fl = min(max(istek[0], 0.0), p.F_max)
        fr = min(max(istek[1], 0.0), p.F_max)
        istek = (fl, fr)
        s = self.s
        k1 = self._turev(s, istek, ruzgar)
        k2 = self._turev([a + 0.5 * dt * b for a, b in zip(s, k1)], istek, ruzgar)
        k3 = self._turev([a + 0.5 * dt * b for a, b in zip(s, k2)], istek, ruzgar)
        k4 = self._turev([a + dt * b for a, b in zip(s, k3)], istek, ruzgar)
        s = [a + dt / 6.0 * (b + 2 * c + 2 * d + e) for a, b, c, d, e in zip(s, k1, k2, k3, k4)]
        self._zemin(s, dt)
        self.s = s

    def _zemin(self, s, dt):
        p = self.p
        if s[1] > p.ayak:
            self.yerde = False
            return
        # temas: carpma mi, inis mi?
        if not self.yerde and not self.carpti:
            if s[3] < -3.5 or abs(s[4]) > math.radians(55):
                self.carpti = True
                self.carpma_mesaji = "Çarptı: %.1f m/s, %.0f°" % (-s[3], math.degrees(s[4]))
        self.yerde = True
        s[1] = p.ayak
        if s[3] < 0:
            s[3] = 0.0
        s[2] *= max(0.0, 1.0 - 8.0 * dt)          # yer surtunmesi
        s[4] *= max(0.0, 1.0 - 25.0 * dt)         # ayaklar govdeyi duzeltir
        s[5] *= max(0.0, 1.0 - 25.0 * dt)

    # ---- yardimcilar ----------------------------------------------------
    @property
    def x(self): return self.s[0]
    @property
    def y(self): return self.s[1]
    @property
    def vx(self): return self.s[2]
    @property
    def vy(self): return self.s[3]
    @property
    def th(self): return self.s[4]
    @property
    def w(self): return self.s[5]
    @property
    def F(self): return self.s[6], self.s[7]
