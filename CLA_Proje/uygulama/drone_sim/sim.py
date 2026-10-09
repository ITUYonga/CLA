# -*- coding: utf-8 -*-
"""CLA drone simulasyonu - gercek zamanli 2B gorsel.

Is bolumu (C2000'deki gibi): dis dongu (konum PID, 50 Hz) simulasyonun
CPU'sunda (cpu_dongu.py); aci kestirimi + ic dongu (500 Hz) CLA'da
(ic_kestirim.casm: golden ya da KV260). Sensorler sensor.py: IMU 500 Hz,
konum sistemi 50 Hz (gecikmeli, gurultulu). --sensor ideal: eski ic_dongu.casm.
Govde: ~450 g yaris sinifi (fizik.py).

    .venv/bin/python sim.py                 # golden (boru hatti) kontrolcu
    .venv/bin/python sim.py --model ardisik # golden, ardisik model (daha hizli)
    .venv/bin/python sim.py --kontrolcu fpga --port /dev/tty.usbserial-XXXX
                                            # KV260'taki CLA, UART uzerinden
    .venv/bin/python sim.py --kontrolcu ikisi --port ...
                                            # drone'u FPGA surer, golden ile bit bit karsilastir
    .venv/bin/python sim.py --kontrolcu sanal
                                            # kart yok: sanal KV260 (pty) + golden

Fare (sol tus basili): hedef | sag tus: burada asili kal
Sol/Sag ok: ortalama ruzgar | T: turbulans | G: ani esinti | Y: yuk (+0.15 kg)
I: ic dongu hizi 100/250/500/1000 Hz (kazanc sabit)
N: sensor gurultusu | O: otomatik rota | R: sifirla | Bosluk: duraklat | H: yardim
Tab: ucus / CLA paneli | C: "CLA nedir?" ekrani | S: sunum modu | F: tam ekran
"""
import argparse
import collections
import math
import random
import time

import pygame

import paket
from fizik import Drone, DroneParam, Ruzgar, G
from kontrolcu import GoldenKontrolcu, FpgaKontrolcu, IkiliKontrolcu
from cpu_dongu import Zincir
from sensor import SensorSeti
import cla_vitrin

# ---------------------------------------------------------------- yerlesim
W, H = 1320, 820
PANEL = 380                     # sag panel genisligi
VIEW_W = W - PANEL
YER_Y = H - 92                  # zemin cizgisi (px)
XMIN, XMAX = -11.0, 11.0
S = VIEW_W / (XMAX - XMIN)      # px / m
YMAX = (YER_Y - 30) / S
VIS = 3.4                       # drone cizim buyutmesi (fizik degismez)

IC_HZ, DIS_HZ = 500, 50         # ic dongu (CLA), dis dongu (CPU)
IC_HIZLARI = (100, 250, 500, 1000)
H_FIZIK = 0.0005                # fizik adimi: RK4, 2 kHz
DARBE_TORK, DARBE_SURE = 0.15, 0.06   # D tusu: kola vurus (dongu_hizi.py ile ayni)
ADIM_BUTCESI = 0.012            # kare basina en cok bu kadar saniye adim (yoksa agir cekim)
CIZ_L, CIZ_AYAK = 0.25, 0.09    # cizimdeki govde olcusu [m] (fizik degil; VIS kat buyutulur)

# ---------------------------------------------------------------- renkler
GOK_UST = (118, 172, 228)
GOK_ALT = (214, 233, 247)
DAG1 = (150, 175, 200)
DAG2 = (120, 150, 175)
CIM = (98, 150, 78)
CIM2 = (74, 120, 60)
TOPRAK = (96, 78, 58)
PANEL_BG = (16, 22, 30)
PANEL_KART = (24, 32, 43)
CIZGI = (44, 56, 70)
YAZI = (226, 233, 240)
SOLUK = (140, 156, 172)
VURGU = (79, 184, 192)
TURUNCU = (240, 161, 74)
MOR = (168, 145, 236)
YESIL = (124, 196, 127)
KIRMIZI = (240, 112, 96)
GOVDE = (38, 44, 52)
GOVDE2 = (64, 72, 84)


def dunya2ekran(x, y):
    return (VIEW_W * 0.0 + (x - XMIN) * S, YER_Y - y * S)


def ekran2dunya(px, py):
    return (XMIN + px / S, (YER_Y - py) / S)


def yazi_tipi(boy, kalin=False, mono=False):
    adlar = "Menlo,Monaco,Consolas,DejaVu Sans Mono" if mono else "Helvetica Neue,Helvetica,Arial,DejaVu Sans"
    return pygame.font.SysFont(adlar, boy, bold=kalin)


# =================================================================== sahne
class Sahne(object):
    def __init__(self):
        self.r = random.Random(3)
        self.gok = pygame.Surface((VIEW_W, H))
        for y in range(H):
            u = min(1.0, y / YER_Y)
            c = [int(a + (b - a) * u ** 1.2) for a, b in zip(GOK_UST, GOK_ALT)]
            pygame.draw.line(self.gok, c, (0, y), (VIEW_W, y))
        self._daglar()
        self._zemin()
        self.bulutlar = [[self.r.uniform(XMIN - 4, XMAX + 4), self.r.uniform(9, YMAX - 1),
                          self.r.uniform(1.6, 3.4), self.r.uniform(0.25, 0.6)] for _ in range(7)]
        self.parcaciklar = [[self.r.uniform(XMIN, XMAX), self.r.uniform(0.2, YMAX), self.r.random()]
                            for _ in range(240)]

    def _daglar(self):
        for renk, taban, genlik, adim, tohum in ((DAG1, 2.6, 2.2, 0.8, 11), (DAG2, 1.2, 1.6, 0.6, 5)):
            r = random.Random(tohum)
            nok = [(0, YER_Y)]
            x = XMIN
            h = taban
            while x <= XMAX + adim:
                h = max(0.3, min(taban + genlik, h + r.uniform(-0.55, 0.55)))
                nok.append(dunya2ekran(x, h))
                x += adim
            nok.append((VIEW_W, YER_Y))
            pygame.draw.polygon(self.gok, renk, nok)

    def _zemin(self):
        g = self.gok
        pygame.draw.rect(g, TOPRAK, (0, YER_Y + 14, VIEW_W, H - YER_Y))
        for y in range(YER_Y, YER_Y + 16):
            u = (y - YER_Y) / 16
            c = [int(a + (b - a) * u) for a, b in zip(CIM, CIM2)]
            pygame.draw.line(g, c, (0, y), (VIEW_W, y))
        f = yazi_tipi(12, mono=True)
        for m in range(int(XMIN), int(XMAX) + 1):
            px, _ = dunya2ekran(m, 0)
            uzun = m % 2 == 0
            pygame.draw.line(g, (60, 50, 40), (px, YER_Y + 16), (px, YER_Y + (28 if uzun else 22)), 2)
            if uzun:
                t = f.render("%d m" % m, True, (214, 200, 180))
                g.blit(t, (px - t.get_width() / 2, YER_Y + 32))
        # pist
        x0, _ = dunya2ekran(-0.8, 0)
        x1, _ = dunya2ekran(0.8, 0)
        pygame.draw.rect(g, (70, 74, 80), (x0, YER_Y - 3, x1 - x0, 6), border_radius=2)
        pygame.draw.rect(g, (230, 200, 90), (x0, YER_Y - 3, x1 - x0, 6), 1, border_radius=2)
        # yukseklik cetveli
        for m in range(1, int(YMAX) + 1):
            _, py = dunya2ekran(0, m)
            pygame.draw.line(g, (255, 255, 255), (0, py), (8 if m % 2 else 14, py), 1)
            if m % 2 == 0:
                t = f.render("%d" % m, True, (60, 80, 110))
                g.blit(t, (18, py - 7))

    def guncelle(self, dt, ruzgar, t):
        wx, wy, _ = ruzgar.hiz(t)
        for b in self.bulutlar:
            b[0] += wx * 0.25 * dt
            if b[0] > XMAX + 5:
                b[0] = XMIN - 5
            if b[0] < XMIN - 5:
                b[0] = XMAX + 5
        for p in self.parcaciklar:
            yer = 0.6 + 0.4 * math.sin(p[1] * 1.7 + p[2] * 9 + t * 0.7)
            p[0] += (wx * yer) * dt
            p[1] += (wy + 0.3 * math.sin(t * 1.3 + p[2] * 20)) * dt
            if p[0] > XMAX:
                p[0] -= XMAX - XMIN
            if p[0] < XMIN:
                p[0] += XMAX - XMIN
            if p[1] > YMAX or p[1] < 0.2:
                p[1] = random.uniform(0.2, YMAX)

    def ciz(self, ekran, ruzgar, t):
        ekran.blit(self.gok, (0, 0))
        katman = pygame.Surface((VIEW_W, H), pygame.SRCALPHA)
        for x, y, r, a in self.bulutlar:
            cx, cy = dunya2ekran(x, y)
            for dx, dy, k in ((-0.6, 0, 0.7), (0.0, 0.25, 1.0), (0.7, 0.05, 0.75), (0.25, -0.15, 0.8)):
                pygame.draw.ellipse(katman, (255, 255, 255, int(150 * a)),
                                    pygame.Rect(cx + (dx * r - r * k) * S, cy - (dy * r + r * k * 0.45) * S,
                                                2 * r * k * S, r * k * 0.9 * S))
        wx, wy, _ = ruzgar.hiz(t)
        hiz = math.hypot(wx, wy)
        if hiz > 0.3:
            boy = min(1.6, 0.08 * hiz)
            for x, y, ph in self.parcaciklar:
                a = int(min(150, 30 + 9 * hiz) * (0.5 + 0.5 * ph))
                p0 = dunya2ekran(x, y)
                p1 = dunya2ekran(x - wx / hiz * boy, y - wy / hiz * boy)
                pygame.draw.line(katman, (255, 255, 255, a), p0, p1, 1)
        ekran.blit(katman, (0, 0))


# =================================================================== drone
def govde2ekran(d, bx, by, th=None, x=None, y=None):
    th = d.th if th is None else th
    x = d.x if x is None else x
    y = (d.y if y is None else y) + ciz_ofset(d)
    c, s = math.cos(th), math.sin(th)
    wx = x + (bx * c - by * s) * VIS
    wy = y + (bx * s + by * c) * VIS
    return dunya2ekran(wx, wy)


SS = 3                          # drone sprite'i icin super ornekleme


def ciz_ofset(d):
    """Yerdeki drone'un cizimde ayaklari yere degsin: govde merkezi kaydirmasi [m]."""
    return CIZ_AYAK * VIS - d.p.ayak


def _drone_sprite(d, faz):
    """Drone'u govde ekseninde, SS kat cozunurlukte cizer (y yukari)."""
    p = d.p
    k = VIS * S * SS                    # px / m (govde ekseni)
    gen, yuk = 2 * (CIZ_L + 0.14), 0.30
    w, h = int(gen * k), int(yuk * k)
    sp = pygame.Surface((w, h), pygame.SRCALPHA)
    def P(bx, by):                      # govde metresi -> sprite pikseli
        return (w / 2 + bx * k, h / 2 - by * k)
    def R(bx, by, bw, bh):              # merkez + boyut
        return pygame.Rect(P(bx - bw / 2, by + bh / 2), (bw * k, bh * k))
    # ayaklar (kizak)
    for sx in (-1, 1):
        pygame.draw.line(sp, (58, 64, 74), P(sx * 0.045, -0.025), P(sx * 0.085, -0.088), int(0.012 * k))
        pygame.draw.line(sp, (40, 45, 52), P(sx * 0.11, -0.09), P(sx * 0.055, -0.09), int(0.012 * k))
    # kollar (karbon)
    pygame.draw.rect(sp, (36, 40, 46), R(0, 0.018, 2 * CIZ_L, 0.022), border_radius=int(0.011 * k))
    pygame.draw.line(sp, (88, 96, 108), P(-CIZ_L, 0.024), P(CIZ_L, 0.024), max(1, int(0.004 * k)))
    # govde
    pygame.draw.rect(sp, (226, 230, 236), R(0, 0.012, 0.19, 0.07), border_radius=int(0.022 * k))
    pygame.draw.rect(sp, (150, 158, 170), R(0, 0.012, 0.19, 0.07), max(1, int(0.004 * k)), border_radius=int(0.022 * k))
    pygame.draw.rect(sp, (190, 196, 205), R(0, 0.052, 0.12, 0.022), border_radius=int(0.011 * k))
    pygame.draw.rect(sp, (79, 184, 192), R(0, 0.006, 0.13, 0.008), border_radius=int(0.004 * k))
    led = KIRMIZI if d.carpti else (YESIL if not d.yerde else TURUNCU)
    pygame.draw.circle(sp, led, P(0.07, 0.03), int(0.008 * k))
    # kamera gimbali
    pygame.draw.circle(sp, (30, 34, 40), P(0.0, -0.032), int(0.018 * k))
    pygame.draw.circle(sp, (70, 120, 160), P(0.006, -0.032), int(0.008 * k))
    for i, kol in enumerate((-CIZ_L, CIZ_L)):
        u = max(0.0, min(1.0, d.F[i] / p.F_max))
        # motor
        pygame.draw.rect(sp, (52, 58, 66), R(kol, 0.045, 0.05, 0.045), border_radius=int(0.01 * k))
        pygame.draw.rect(sp, (120, 128, 140), R(kol, 0.064, 0.05, 0.008), border_radius=int(0.004 * k))
        pygame.draw.rect(sp, (30, 34, 40), R(kol, 0.072, 0.012, 0.012))
        # pervane: hiz ile koyulasan bulanik disk + donen pal
        disk = pygame.Surface((w, h), pygame.SRCALPHA)
        pygame.draw.ellipse(disk, (210, 220, 232, int(40 + 110 * u)), R(kol, 0.08, 0.26, 0.018))
        pygame.draw.ellipse(disk, (255, 255, 255, int(30 + 60 * u)), R(kol, 0.08, 0.20, 0.008))
        sp.blit(disk, (0, 0))
        c = math.cos(faz[i]) * 0.13
        pygame.draw.line(sp, (24, 28, 34, 255), P(kol - c, 0.081), P(kol + c, 0.081), max(2, int(0.008 * k)))
        pygame.draw.circle(sp, (200, 205, 212), P(kol, 0.081), int(0.007 * k))
    return sp


def drone_ciz(ekran, d, istek, t, faz):
    p = d.p
    katman = pygame.Surface((VIEW_W, H), pygame.SRCALPHA)
    # golge
    gx, _ = dunya2ekran(d.x, 0)
    yuk = max(0.0, d.y - p.ayak)
    gen = max(12, 70 - yuk * 4)
    a = int(max(18, 120 - yuk * 9))
    pygame.draw.ellipse(katman, (20, 30, 20, a), (gx - gen / 2, YER_Y - 5, gen, 10))
    # hava akimi (itkiyle orantili, govdeye gore asagi)
    for i, kol in enumerate((-CIZ_L, CIZ_L)):
        u = max(0.0, min(1.0, d.F[i] / p.F_max))
        if u <= 0.02:
            continue
        for kk in range(7):
            bx = kol + (kk - 3) * 0.03
            for j in range(7):
                b0 = 0.06 - j * 0.06 * (0.5 + u)
                b1 = b0 - 0.045 * (0.5 + u)
                yay = 1 + j * 0.12
                alfa = int(95 * u * (1 - j / 7.0))
                if alfa > 3:
                    pygame.draw.line(katman, (225, 242, 255, alfa), govde2ekran(d, kol + (bx - kol) * yay, b0),
                                     govde2ekran(d, kol + (bx - kol) * yay, b1), 2)
    ekran.blit(katman, (0, 0))
    # drone
    sp = _drone_sprite(d, faz)
    sp = pygame.transform.rotozoom(sp, math.degrees(d.th), 1.0 / SS)
    cx, cy = govde2ekran(d, 0.0, 0.0)
    ekran.blit(sp, (cx - sp.get_width() / 2, cy - sp.get_height() / 2))


# =================================================================== grafik
def grafik(ekran, rect, seriler, baslik, f, birim="", sinir=None):
    pygame.draw.rect(ekran, PANEL_KART, rect, border_radius=8)
    x0, y0, w, h = rect
    ic = pygame.Rect(x0 + 8, y0 + 22, w - 16, h - 30)
    t = f.render(baslik, True, SOLUK)
    ekran.blit(t, (x0 + 10, y0 + 5))
    tum = [v for _, s, _ in seriler for v in s]
    if not tum:
        return
    lo, hi = (min(tum), max(tum)) if sinir is None else sinir
    if sinir is None:
        orta, yari = (lo + hi) / 2, max((hi - lo) / 2 * 1.15, 0.25)
        lo, hi = orta - yari, orta + yari
    for k in range(5):
        yy = ic.y + ic.h * k / 4
        pygame.draw.line(ekran, CIZGI, (ic.x, yy), (ic.right, yy), 1)
    et = f.render("%.1f%s" % (hi, birim), True, (100, 116, 132))
    ekran.blit(et, (ic.right - et.get_width(), y0 + 5))
    et = f.render("%.1f%s" % (lo, birim), True, (100, 116, 132))
    ekran.blit(et, (ic.right - et.get_width(), ic.bottom - 12))
    lx = x0 + 10 + t.get_width() + 12
    for ad, s, renk in seriler:
        if len(s) > 1:
            n = len(s)
            nok = [(ic.x + ic.w * i / (n - 1), ic.bottom - (v - lo) / (hi - lo) * ic.h) for i, v in enumerate(s)]
            pygame.draw.lines(ekran, renk, False, nok, 2)
        e = f.render(ad, True, renk)
        ekran.blit(e, (lx, y0 + 5))
        lx += e.get_width() + 10


def cubuk(ekran, x, y, w, h, deger, enbuyuk, renk, etiket, f, ek=""):
    pygame.draw.rect(ekran, (34, 44, 58), (x, y, w, h), border_radius=4)
    u = max(0.0, min(1.0, deger / enbuyuk)) if enbuyuk else 0
    if u > 0:
        pygame.draw.rect(ekran, renk, (x, y, max(4, w * u), h), border_radius=4)
    t = f.render("%s  %.2f%s" % (etiket, deger, ek), True, YAZI)
    ekran.blit(t, (x + 6, y + (h - t.get_height()) / 2))


def iki_yonlu_cubuk(ekran, x, y, w, h, deger, enbuyuk, renk, etiket, f):
    pygame.draw.rect(ekran, (34, 44, 58), (x, y, w, h), border_radius=4)
    orta = x + w / 2
    u = max(-1.0, min(1.0, deger / enbuyuk))
    if u >= 0:
        pygame.draw.rect(ekran, renk, (orta, y, w / 2 * u, h), border_radius=3)
    else:
        pygame.draw.rect(ekran, renk, (orta + w / 2 * u, y, -w / 2 * u, h), border_radius=3)
    pygame.draw.line(ekran, SOLUK, (orta, y), (orta, y + h), 1)
    t = f.render("%s  %+.2f" % (etiket, deger), True, YAZI)
    ekran.blit(t, (x + 6, y + (h - t.get_height()) / 2))


# =================================================================== uygulama
def ic_parametreler(p, ic_hz):
    """CLA'ya bir kez yazilan ic dongu parametreleri: govdeden KTAU/FMAX, hiza gore kazanc."""
    q = paket.ic_kazanc(ic_hz, eski=(p.kod == "eski"))
    q.update({"_KTAU": p.ktau, "_FMAX": p.F_max})
    q.update(paket.ick_hiz(ic_hz))          # kestirim: DT ve tamamlayici suzgec kazanci
    return q


def kontrolcu_kur(tur, model, port=None, baud=921600, degisen=None, D=None):
    """CLA arka ucu: (kontrolcu, sanal_cihaz ya da None). D: paket.ICK (varsayilan) ya da paket.IC"""
    D = D or paket.ICK
    if tur == "golden":
        return GoldenKontrolcu(duzen=D, model=model, degisen=degisen), None
    sanal = None
    if tur == "sanal" or (tur == "ikisi" and not port):
        from sanal_fpga import SanalFpga
        sanal = SanalFpga(cekirdek="golden", model="hizli", baud=baud, duzen=D)
        fpga = FpgaKontrolcu(sanal.yol, baud, duzen=D, degisen=degisen, pty=True)
        fpga.ad = "sanal KV260 (pty)"
    elif not port:
        raise SystemExit("--kontrolcu fpga icin --port gerekli (or. /dev/tty.usbserial-XXXX)")
    else:
        fpga = FpgaKontrolcu(port, baud, duzen=D, degisen=degisen)
    if tur == "ikisi":
        # karsilastirici gercek zamana yetissin: hizli golden (degerler bit bit ayni, cevrim sabit)
        return IkiliKontrolcu(fpga, GoldenKontrolcu(duzen=D, model="hizli", degisen=degisen)), sanal
    return fpga, sanal


class Uygulama(object):
    def __init__(self, kontrolcu, sanal=None, ic_hz=IC_HZ, dis_hz=DIS_HZ, govde=None):
        pygame.init()
        pygame.display.set_caption("CLA Drone Simülasyonu")
        try:                                # SCALED: tam ekranda (F) cizim olcegi korunur
            self.ekran = pygame.display.set_mode((W, H), pygame.SCALED)
        except pygame.error:
            self.ekran = pygame.display.set_mode((W, H))
        self.saat = pygame.time.Clock()
        self.f = {k: yazi_tipi(*v) for k, v in {
            "baslik": (21, True), "alt": (13,), "kucuk": (12,), "orta": (14,), "mono": (13, False, True),
            "mono_k": (11, False, True), "buyuk": (30, True), "orta_k": (15, True),
            "baslik_k": (18, True)}.items()}
        self.kontrolcu, self.sanal = kontrolcu, sanal
        self.iletisim_hatasi, self.son_hata = 0, ""
        # CLA vitrini: boru hatti izi (golden, bir kez), olculen cevrim ve PC sureleri
        self.boru_izi = cla_vitrin.BoruIzi(getattr(kontrolcu, "duzen", paket.ICK))
        self.deney = cla_vitrin.deney_sonucu()
        self.olc_cevrim = collections.deque(maxlen=3000)
        self.olc_pc_ms = collections.deque(maxlen=3000)
        self.sayfa, self.cla_ekrani, self.sunum, self.sunum_t = "ucus", False, False, 0.0
        self.oynat = 0.0
        self.sahne = Sahne()
        self.ruzgar = Ruzgar()
        self.drone = Drone(govde)
        self.zincir = Zincir(kontrolcu, ic_hz, dis_hz, {"M": self.drone.p.m})
        self.sensor = SensorSeti(ic_hz, dis_hz) if self.zincir.kestirimli else None
        self.kazanc_hz = ic_hz              # CLA kazanclari bu hiz icin ayarli (I tusu degistirmez)
        self.istek = (0.0, 0.0)
        self.darbe_kalan, self.darbe_yon, self.darbe_t = 0.0, 1.0, -9.0
        self.ardisik_hata = 0
        self.yardim = True
        self.sifirla()

    def sifirla(self):
        self.zincir.sifirla()               # CPU: dis dongu integratorleri, CLA: aci kestirimi
        if self.sensor:
            self.sensor.sifirla()           # yeni kalibrasyon kalintisi (sabit hatalar)
        self.drone.sifirla(0.0)
        p = self.drone.p
        p.yuk = p.yuk_ek if getattr(self, "yuk_acik", False) else 0.0
        self.t = 0.0
        self.hedef = [0.0, 4.0]
        self.istek = (0.0, 0.0)
        self.kayit = collections.deque(maxlen=1000)
        self.iz = collections.deque(maxlen=400)
        self.birikim = 0.0
        self.faz = [0.0, 0.0]
        self.duraklat = False
        self.gurultu = getattr(self, "gurultu", False)
        self.oto = False
        self.adim_sayisi = 0
        self.kont_ms = 0.0
        self.tur_ms = getattr(self, "tur_ms", 0.0)
        self.gz_oran = 1.0
        self._gz = collections.deque(maxlen=60)
        self.yuk_acik = getattr(self, "yuk_acik", False)

    # ------------------------------------------------------------- adim
    def ic_adimi(self):
        """Bir ic dongu adimi: (her `bolum` adimda CPU dis dongusu) + CLA gorevi + fizik."""
        d, r, z = self.drone, self.ruzgar, self.zincir
        olc = [d.x, d.y, d.vx, d.vy, d.th, d.w]
        imu = konum = None
        if self.sensor:                     # gercekci sensorler: ham IMU + gecikmeli konum sistemi
            self.sensor.titresim = 3.0 if self.gurultu else 1.0
            imu = self.sensor.imu(d)
            if z.sayac % z.bolum == 0:
                konum = self.sensor.konum(d)
        elif self.gurultu:                  # ideal sensor + gurultu (yogunluk: sigma ~ sqrt(hiz))
            k = math.sqrt(z.ic_hz / 100.0)
            for i, s in enumerate((0.02, 0.02, 0.05, 0.05, 0.005 * k, 0.03 * k)):
                olc[i] += random.gauss(0, s)
        if self.oto:
            self.hedef = [6.5 * math.sin(0.22 * self.t), 5.5 + 2.8 * math.sin(0.44 * self.t)]
        t0 = time.perf_counter()
        try:
            self.istek = z.adim(olc, self.hedef, imu, konum)
            self.ardisik_hata = 0
            k = self.kontrolcu
            if k.cevrim:
                self.olc_cevrim.append(k.cevrim)
            self.olc_pc_ms.append(k.tur_ms if k.tur_ms is not None else (time.perf_counter() - t0) * 1e3)
        except Exception as e:              # UART: zaman asimi, hata kodu, kopuk kablo
            self.iletisim_hatasi += 1       # motorlar son istekte kalir
            self.ardisik_hata += 1
            self.son_hata = str(e)[:60]
            if self.ardisik_hata >= 3:      # kart cevap vermiyor: dondurma, duraklat
                self.duraklat = True
        self.kont_ms = 0.9 * self.kont_ms + 0.1 * (time.perf_counter() - t0) * 1e3
        if self.kontrolcu.tur_ms:           # UART gidis-donus (golden'da None)
            self.tur_ms = 0.9 * self.tur_ms + 0.1 * self.kontrolcu.tur_ms
        alt = max(1, int(round(z.dt / H_FIZIK)))
        h = z.dt / alt
        v0 = (d.vx, d.vy)
        for _ in range(alt):
            d.ek_tork = self.darbe_yon * DARBE_TORK if self.darbe_kalan > 0 else 0.0
            self.darbe_kalan -= h
            r.adim(self.t, h)
            d.adim(h, self.istek, r.hiz(self.t))
            self.t += h
        if self.sensor:
            self.sensor.ivme_guncelle(v0, (d.vx, d.vy), z.dt)        # ivmeolcerin olcecegi ivme
        self.adim_sayisi += 1
        if self.adim_sayisi % max(1, z.ic_hz // 100) == 0:           # grafikler: 100 Hz
            self.kayit.append((d.y, self.hedef[1], d.x, self.hedef[0], math.degrees(d.th),
                               math.degrees(z.thd), d.F[0], d.F[1], math.degrees(z.th_k)))
        if self.adim_sayisi % max(1, z.ic_hz * 3 // 100) == 0:       # iz: 30 ms
            self.iz.append((d.x, d.y))

    def ic_hiz_degistir(self):
        """I tusu: ic dongu hizi degisir, CLA kazanclari AYNI kalir (kazanc_hz icin ayarli)."""
        z = self.zincir
        i = IC_HIZLARI.index(z.ic_hz) if z.ic_hz in IC_HIZLARI else 0
        z.ic_hz = IC_HIZLARI[(i + 1) % len(IC_HIZLARI)]
        z.dt, z.bolum = 1.0 / z.ic_hz, z.ic_hz // z.dis_hz
        if self.sensor:                     # kestirim DT'ye bagli: kazanclar ayni, DT ve KK yeni hiza
            self.sensor.ic_hz = z.ic_hz
            q = ic_parametreler(self.drone.p, self.kazanc_hz)
            q.update(paket.ick_hiz(z.ic_hz))
            try:
                self.kontrolcu.parametreleri_yukle(q)
            except Exception as e:
                self.son_hata = str(e)[:60]
        self.birikim = 0.0

    # ------------------------------------------------------------- olaylar
    def olaylar(self):
        for e in pygame.event.get():
            if e.type == pygame.QUIT:
                return False
            if e.type == pygame.KEYDOWN:
                k = e.key
                if k == pygame.K_ESCAPE:
                    return False
                elif k == pygame.K_LEFT:
                    self.ruzgar.ortalama = max(-15, self.ruzgar.ortalama - 1)
                elif k == pygame.K_RIGHT:
                    self.ruzgar.ortalama = min(15, self.ruzgar.ortalama + 1)
                elif k == pygame.K_t:
                    self.ruzgar.turbulans = (self.ruzgar.turbulans + 1) % 4
                elif k == pygame.K_g:
                    self.ruzgar.esinti(self.t)
                elif k == pygame.K_y:
                    self.yuk_acik = not self.yuk_acik
                    self.drone.p.yuk = self.drone.p.yuk_ek if self.yuk_acik else 0.0
                elif k == pygame.K_i:
                    self.ic_hiz_degistir()
                elif k == pygame.K_d:
                    self.darbe_kalan, self.darbe_t = DARBE_SURE, self.t
                    self.darbe_yon = -self.darbe_yon
                elif k == pygame.K_n:
                    self.gurultu = not self.gurultu
                elif k == pygame.K_o:
                    self.oto = not self.oto
                elif k == pygame.K_r:
                    self.sifirla()
                elif k == pygame.K_SPACE:
                    self.duraklat = not self.duraklat
                elif k == pygame.K_h:
                    self.yardim = not self.yardim
                elif k == pygame.K_TAB:
                    self.sayfa = "cla" if self.sayfa == "ucus" else "ucus"
                elif k == pygame.K_c:
                    self.cla_ekrani = not self.cla_ekrani
                elif k == pygame.K_s:
                    self.sunum = not self.sunum
                    self.sunum_t = 0.0
                    if self.sunum:
                        self.oto, self.yardim = True, False
                        self.ruzgar.turbulans = max(self.ruzgar.turbulans, 1)
                elif k == pygame.K_f:
                    pygame.display.toggle_fullscreen()
            if e.type == pygame.MOUSEBUTTONDOWN and self.cla_ekrani:
                self.cla_ekrani = False             # anlatim ekranini tiklayinca kapat
                continue
            if e.type == pygame.MOUSEBUTTONDOWN and e.pos[0] < VIEW_W:
                if e.button == 3:
                    self.oto = False
                    self.hedef = [self.drone.x, max(0.5, self.drone.y)]
        b = pygame.mouse.get_pressed()
        mx, my = pygame.mouse.get_pos()
        if b[0] and mx < VIEW_W and not self.cla_ekrani:
            self.oto = False
            x, y = ekran2dunya(mx, my)
            self.hedef = [max(XMIN + 0.5, min(XMAX - 0.5, x)), max(0.5, min(YMAX - 0.5, y))]
        return True

    # ------------------------------------------------------------- cizim
    def ciz(self):
        e, d, f = self.ekran, self.drone, self.f
        self.sahne.ciz(e, self.ruzgar, self.t)
        # iz
        if len(self.iz) > 2:
            katman = pygame.Surface((VIEW_W, H), pygame.SRCALPHA)
            n = len(self.iz)
            pts = [dunya2ekran(x, y + ciz_ofset(d)) for x, y in self.iz]
            for i in range(1, n):
                pygame.draw.line(katman, (40, 90, 160, int(170 * i / n)), pts[i - 1], pts[i], 2)
            e.blit(katman, (0, 0))
        # hedef
        hx, hy = dunya2ekran(*self.hedef)
        nab = 1 + 0.12 * math.sin(time.time() * 5)
        pygame.draw.circle(e, TURUNCU, (hx, hy), 14 * nab, 2)
        pygame.draw.circle(e, TURUNCU, (hx, hy), 3)
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            pygame.draw.line(e, TURUNCU, (hx + dx * 18, hy + dy * 18), (hx + dx * 26, hy + dy * 26), 2)
        dx_, dy_ = dunya2ekran(d.x, d.y + ciz_ofset(d))
        uz = math.hypot(hx - dx_, hy - dy_)
        if uz > 30:
            for k in range(0, int(uz) - 20, 12):
                u0, u1 = k / uz, min(1.0, (k + 6) / uz)
                pygame.draw.line(e, (240, 161, 74), (dx_ + (hx - dx_) * u0, dy_ + (hy - dy_) * u0),
                                 (dx_ + (hx - dx_) * u1, dy_ + (hy - dy_) * u1), 1)
        drone_ciz(e, d, self.istek, self.t, self.faz)
        if self.t - self.darbe_t < 0.6:     # darbe isareti: vurulan kolun ustunde
            kol = CIZ_L * (1 if self.darbe_yon < 0 else -1)
            px, py = govde2ekran(d, kol, 0.16)
            a = 1.0 - (self.t - self.darbe_t) / 0.6
            pygame.draw.circle(e, KIRMIZI, (int(px), int(py)), int(10 + 14 * (1 - a)), 3)
            t = f["mono_k"].render("DARBE", True, KIRMIZI)
            e.blit(t, (px - t.get_width() / 2, py - 32))
        if self.gz_oran < 0.93 and not self.duraklat:
            t = f["orta_k"].render("AĞIR ÇEKİM ×%s  ·  CLA'ya giden yol (USB) adıma yetişemiyor; fizik ve kontrol "
                                   "yine doğru" % ("%.2f" % self.gz_oran).replace(".", ","), True, (40, 60, 90))
            e.blit(t, ((VIEW_W - t.get_width()) / 2, 96))
        if d.carpti:
            t = f["buyuk"].render(d.carpma_mesaji, True, KIRMIZI)
            e.blit(t, ((VIEW_W - t.get_width()) / 2, 120))
            t = f["orta"].render("R ile yeniden başlat", True, YAZI)
            e.blit(t, ((VIEW_W - t.get_width()) / 2, 160))
        if self.duraklat:
            t = f["buyuk"].render("DURAKLATILDI", True, (40, 60, 90))
            e.blit(t, ((VIEW_W - t.get_width()) / 2, 70))
        self.ruzgar_gostergesi()
        if self.yardim and not self.cla_ekrani:
            self.yardim_ciz()
        if self.cla_ekrani:
            cla_vitrin.cla_nedir(e, VIEW_W, H, f, self.boru_izi, self.olcum())
        self.panel()

    def olcum(self):
        k = self.kontrolcu
        uart = k.tur_ms is not None
        o = {"cevrimler": list(self.olc_cevrim), "pc_ms": list(self.olc_pc_ms), "adim": self.adim_sayisi,
             "kaynak": ("sanal KV260, golden" if self.sanal else "FPGA donanım sayacı") if uart else "golden model",
             "pc_ad": "UART gidiş-dönüş" if uart else "PC'de golden taklidi",
             "pc_kisa": "USB/UART: değişken" if uart else "Python: değişken",
             "fark": None, "cevrim_farki": None,
             "ic_hz": self.zincir.ic_hz, "dis_hz": self.zincir.dis_hz, "deney": self.deney,
             "kestirimli": self.zincir.kestirimli}
        if isinstance(k, IkiliKontrolcu):
            o["fark"], o["cevrim_farki"] = k.fark_sayisi, k.cevrim_farki
        return o

    def ruzgar_gostergesi(self):
        e, f = self.ekran, self.f
        wx, wy, _ = self.ruzgar.hiz(self.t)
        x, y = 50, 20
        kut = pygame.Surface((210, 64), pygame.SRCALPHA)
        pygame.draw.rect(kut, (16, 22, 30, 170), kut.get_rect(), border_radius=10)
        e.blit(kut, (x, y))
        t = f["kucuk"].render("RÜZGÂR", True, (190, 205, 220))
        e.blit(t, (x + 12, y + 8))
        t = f["mono"].render("%+5.1f m/s" % wx, True, YAZI)
        e.blit(t, (x + 12, y + 28))
        bilgi = "türb. %d%s" % (self.ruzgar.turbulans, "  ESİNTİ" if self.ruzgar.esinti_t is not None else "")
        t = f["kucuk"].render(bilgi, True, TURUNCU if self.ruzgar.esinti_t is not None else SOLUK)
        e.blit(t, (x + 12, y + 46))
        cx, cy = x + 170, y + 34
        boy = min(28, 2 + abs(wx) * 2.2)
        yon = 1 if wx >= 0 else -1
        if abs(wx) > 0.2:
            uc = (cx + yon * boy / 2, cy)
            pygame.draw.line(e, VURGU, (cx - yon * boy / 2, cy), uc, 3)
            pygame.draw.polygon(e, VURGU, [uc, (uc[0] - yon * 8, cy - 6), (uc[0] - yon * 8, cy + 6)])
        else:
            pygame.draw.circle(e, SOLUK, (cx, cy), 3)

    def yardim_ciz(self):
        e, f = self.ekran, self.f
        satirlar = [("Fare sol (basılı)", "hedef"), ("Fare sağ", "burada asılı kal"), ("← →", "ortalama rüzgâr"),
                    ("T", "türbülans 0–3"), ("G", "ani esinti"), ("Y", "yük +%s kg (kontrolcü bilmez)" % ("%.2f" % self.drone.p.yuk_ek).replace(".", ",")),
                    ("I", "iç döngü hızı (kazanç sabit)"), ("D", "kola darbe (açı bozucusu)"),
                    ("N", "sensör gürültüsü"), ("O", "otomatik rota"), ("R", "sıfırla"), ("Boşluk", "duraklat"),
                    ("Tab", "uçuş / CLA paneli"), ("C", "CLA nedir? ekranı"), ("S", "sunum modu (otomatik)"),
                    ("F", "tam ekran"), ("H", "bu yardımı gizle")]
        w, h = 330, 22 + 19 * len(satirlar)
        x, y = VIEW_W - w - 18, 20
        kut = pygame.Surface((w, h), pygame.SRCALPHA)
        pygame.draw.rect(kut, (16, 22, 30, 175), kut.get_rect(), border_radius=10)
        e.blit(kut, (x, y))
        for i, (tus, ne) in enumerate(satirlar):
            e.blit(f["mono_k"].render(tus, True, TURUNCU), (x + 14, y + 12 + 19 * i))
            e.blit(f["kucuk"].render(ne, True, YAZI), (x + 150, y + 11 + 19 * i))

    def panel(self):
        e, f, d = self.ekran, self.f, self.drone
        x0 = VIEW_W
        pygame.draw.rect(e, PANEL_BG, (x0, 0, PANEL, H))
        pygame.draw.line(e, CIZGI, (x0, 0), (x0, H), 1)
        x = x0 + 18
        e.blit(f["baslik_k"].render("CLA Drone Simülasyonu", True, YAZI), (x, 17))
        sx = x0 + PANEL - 18
        for ad, kod in (("CLA", "cla"), ("UÇUŞ", "ucus")):  # sayfa sekmeleri (Tab)
            t = f["mono_k"].render(ad, True, YAZI if self.sayfa == kod else SOLUK)
            sx -= t.get_width() + 14
            r = pygame.Rect(sx, 18, t.get_width() + 10, 18)
            pygame.draw.rect(e, VURGU if self.sayfa == kod else PANEL_KART, r, 0 if self.sayfa == kod else 1,
                             border_radius=5)
            e.blit(f["mono_k"].render(ad, True, PANEL_BG if self.sayfa == kod else SOLUK), (sx + 5, 20))
        e.blit(f["alt"].render("Kontrolcü: %s" % self.kontrolcu.ad, True, VURGU), (x, 44))
        # durum cipleri
        k = self.kontrolcu
        z = self.zincir
        cipler = [("%d Hz iç · %d dış" % (z.ic_hz, z.dis_hz), YAZI if z.ic_hz == self.kazanc_hz else TURUNCU),
                  ("%d çevrim" % k.cevrim, SOLUK),
                  ("%.1f ms tur" % self.tur_ms if k.tur_ms is not None else "%.1f ms/adım" % self.kont_ms, SOLUK)]
        if isinstance(k, IkiliKontrolcu):
            cipler.append(("golden≠FPGA %d" % k.fark_sayisi, YESIL if k.fark_sayisi == 0 else KIRMIZI))
        if self.iletisim_hatasi:
            cipler.append(("UART hata %d" % self.iletisim_hatasi, KIRMIZI))
        cx = x
        for c, renk in cipler:
            t = f["mono_k"].render(c, True, renk)
            if cx + t.get_width() + 14 > x0 + PANEL - 12:      # sigmazsa alt satir yok: kisalt
                break
            r = pygame.Rect(cx, 66, t.get_width() + 14, 20)
            pygame.draw.rect(e, PANEL_KART, r, border_radius=10)
            e.blit(t, (cx + 7, 69))
            cx += r.w + 6
        if self.sayfa == "cla":
            cla_vitrin.cla_sayfasi(e, x, 98, PANEL - 36, f, self.boru_izi, self.olcum(), int(self.oynat))
        else:
            # telemetri
            y = 98
            pygame.draw.rect(e, PANEL_KART, (x, y, PANEL - 36, 92), border_radius=8)
            deg = [("x", d.x, "m"), ("y", d.y, "m"), ("θ", math.degrees(d.th), "°"),
                   ("vx", d.vx, "m/s"), ("vy", d.vy, "m/s"), ("ω", math.degrees(d.w), "°/s")]
            for i, (ad, v, b) in enumerate(deg):
                cxx = x + 12 + (i % 3) * 112
                cyy = y + 10 + (i // 3) * 40
                e.blit(f["kucuk"].render(ad, True, SOLUK), (cxx, cyy))
                e.blit(f["mono"].render("%+7.2f %s" % (v, b), True, YAZI), (cxx, cyy + 16))
            # motorlar
            y = 200
            e.blit(f["kucuk"].render("MOTORLAR  (istek: CLA çıktısı, çubuk: gerçek itki)", True, SOLUK), (x, y))
            Fmax = d.p.F_max
            for i, (ad, renk) in enumerate((("F_L", TURUNCU), ("F_R", MOR))):
                yy = y + 18 + i * 26
                cubuk(e, x, yy, PANEL - 36, 22, d.F[i], Fmax, renk, ad, f["mono_k"], " N")
                ix = x + (PANEL - 36) * max(0.0, min(1.0, self.istek[i] / Fmax))
                pygame.draw.line(e, YAZI, (ix, yy - 2), (ix, yy + 24), 2)
            agirlik = d.p.kutle * G
            e.blit(f["kucuk"].render("toplam %.1f N  ·  ağırlık %.1f N%s" % (sum(d.F), agirlik,
                   "  ·  yük takılı" if d.p.yuk else ""), True, SOLUK), (x, y + 74))
            # CLA durumu
            y = 296
            e.blit(f["kucuk"].render("CPU DIŞ DÖNGÜ  (%d Hz, konum PID integratörleri)" % self.zincir.dis_hz, True, SOLUK), (x, y))
            iki_yonlu_cubuk(e, x, y + 18, PANEL - 36, 20, z.dis.ix, z.dis.p["IMAXX"], MOR, "ix", f["mono_k"])
            iki_yonlu_cubuk(e, x, y + 42, PANEL - 36, 20, z.dis.iy, z.dis.p["IMAXY"], MOR, "iy", f["mono_k"])
            # grafikler
            k = list(self.kayit)
            gy = 372
            gw = PANEL - 36
            grafik(e, (x, gy, gw, 100), [("y", [q[0] for q in k], VURGU), ("hedef", [q[1] for q in k], TURUNCU)],
                   "YÜKSEKLİK", f["kucuk"], " m")
            grafik(e, (x, gy + 108, gw, 100), [("x", [q[2] for q in k], VURGU), ("hedef", [q[3] for q in k], TURUNCU)],
                   "YATAY", f["kucuk"], " m")
            egim = [("θ", [q[4] for q in k], VURGU), ("θ istek", [q[5] for q in k], MOR)]
            if self.sensor:
                egim.append(("θ kestirim", [q[8] for q in k], TURUNCU))
            grafik(e, (x, gy + 216, gw, 100), egim, "EĞİM", f["kucuk"], "°")
            grafik(e, (x, gy + 324, gw, 80), [("F_L", [q[6] for q in k], TURUNCU), ("F_R", [q[7] for q in k], MOR)],
                   "İTKİ", f["kucuk"], " N", sinir=(0, Fmax))
        # alt satir
        bayrak = []
        if self.oto:
            bayrak.append("otomatik rota")
        if self.gurultu:
            bayrak.append("sensör gürültüsü")
        if self.duraklat:
            bayrak.append("duraklatıldı")
        if self.son_hata:
            bayrak.append("son UART hatası: " + self.son_hata)
        k = self.kontrolcu
        if isinstance(k, IkiliKontrolcu) and k.cevrim_farki:
            bayrak.append("çevrim farkı %d adımda (FPGA %d, golden %d)" % (k.cevrim_farki, k.cevrim, k.golden_cevrim))
        if isinstance(k, IkiliKontrolcu) and k.son_fark:
            bayrak.append("son fark: " + ", ".join("%s %s≠%s" % f for f in k.son_fark[:2]))
        alt = "t = %.1f s  ·  adım %d  ·  gerçek zaman ×%.2f" % (self.t, self.adim_sayisi, self.gz_oran)
        e.blit(f["kucuk"].render(alt, True, SOLUK), (x, H - 38))
        if bayrak:
            e.blit(f["kucuk"].render("açık: " + ", ".join(bayrak), True, TURUNCU), (x, H - 20))

    SUNUM = (("ucus", False, 20.0), ("cla", False, 30.0), ("cla", True, 25.0))

    def sunum_adimi(self, dt):
        """Sunum modu: ucus paneli -> CLA paneli -> "CLA nedir?" ekrani, dongu."""
        self.sunum_t = (self.sunum_t + dt) % sum(s for _, _, s in self.SUNUM)
        t = self.sunum_t
        for sayfa, ekran, sure in self.SUNUM:
            if t < sure:
                self.sayfa, self.cla_ekrani = sayfa, ekran
                return
            t -= sure

    # ------------------------------------------------------------- dongu
    def calistir(self):
        calisiyor = True
        while calisiyor:
            dt = self.saat.tick(60) / 1000.0
            calisiyor = self.olaylar()
            if not self.duraklat:
                self.birikim += min(dt, 0.1)
                t_once, bas = self.t, time.perf_counter()
                z = self.zincir
                while self.birikim >= z.dt and time.perf_counter() - bas < ADIM_BUTCESI and not self.duraklat:
                    self.ic_adimi()
                    self.birikim -= z.dt
                if self.birikim >= z.dt:    # yetisemedi: geri kalani at -> agir cekim
                    self.birikim = 0.0
                self._gz.append((self.t - t_once, dt))
                tg = sum(a for a, _ in self._gz)
                tr = sum(b for _, b in self._gz)
                self.gz_oran = tg / tr if tr else 1.0
                self.sahne.guncelle(dt, self.ruzgar, self.t)
                for i in range(2):
                    rpm = 40 + 70 * math.sqrt(max(0.0, self.drone.F[i]) / self.drone.p.F_max)
                    self.faz[i] += rpm * dt * (1 if i else -1)
            self.oynat += dt * 12.0             # boru hatti canlandirmasi: 12 cevrim/s
            if self.sunum:
                self.sunum_adimi(dt)
            self.ciz()
            pygame.display.flip()
        self.kontrolcu.kapat()
        if self.sanal:
            self.sanal.kapat()
        pygame.quit()


def main():
    ap = argparse.ArgumentParser(description="CLA drone simülasyonu")
    ap.add_argument("--kontrolcu", choices=("golden", "fpga", "ikisi", "sanal"), default="golden",
                    help="golden: Python modeli | fpga: KV260 (UART) | ikisi: FPGA sürer, golden "
                         "karşılaştırır | sanal: kart yok, pty üzerinde sanal KV260")
    ap.add_argument("--port", help="seri port (/dev/cu.usbserial-..., COM5) ya da 'auto': KV260'ı kendisi bulur")
    ap.add_argument("--baud", type=int, default=921600)
    ap.add_argument("--model", choices=("boru", "hizli", "ardisik"), default="boru",
                    help="golden modeli: boru hattı (çevrim doğru) ya da ardışık (hızlı)")
    ap.add_argument("--ic-hz", type=int, choices=IC_HIZLARI, default=IC_HZ,
                    help="iç döngü (CLA) hızı; kazançlar bu hıza göre ayarlanır")
    ap.add_argument("--dis-hz", type=int, default=DIS_HZ, help="dış döngü (CPU) hızı")
    ap.add_argument("--sensor", choices=("gercek", "ideal"), default="gercek",
                    help="gercek: ham IMU + konum sistemi, açıyı CLA kestirir (ic_kestirim.casm) | "
                         "ideal: açı doğrudan ölçülür (ic_dongu.casm)")
    ap.add_argument("--govde", choices=("yaris", "eski"), default="yaris",
                    help="yaris: 450 g, motor 15 ms | eski: ilk 1 kg, motor 35 ms")
    a = ap.parse_args()
    govde = DroneParam() if a.govde == "yaris" else DroneParam.eski_1kg()
    D = paket.ICK if a.sensor == "gercek" else paket.IC
    kontrolcu, sanal = kontrolcu_kur(a.kontrolcu, a.model, a.port, a.baud, ic_parametreler(govde, a.ic_hz), D)
    Uygulama(kontrolcu, sanal, a.ic_hz, a.dis_hz, govde).calistir()


if __name__ == "__main__":
    main()
