# -*- coding: utf-8 -*-
"""CLA <-> simulasyon veri sozlesmesi (iki mimari).

Butun degerler IEEE-754 float32, 32 bit kelime; adresler 16 bitlik CLA
kelime adresi (32 bit deger iki kelime, LSW alt adreste).

    CPU->CLA mesaj RAM'i (0x1500-0x157F)  her adim: girdiler; bir kez: parametreler
    CLA->CPU mesaj RAM'i (0x1480-0x14FF)  her adim: ciktilar
    L1 veri RAM'i (0x8800-)               CLA'nin kendi durumu ve ara degiskenleri

IC  (varsayilan, ic_dongu.casm): dis dongu (konum PID, 50 Hz) CPU'da yani
    simulasyonda (cpu_dongu.py); CLA yalniz ic donguyu (aci PD, itki,
    motorlar) her ic adimda (500 Hz) kosar.
TEK (ilk surum, kontrolcu.casm): butun kaskad CLA'da, 100 Hz, 1 kg govde.

Golden modunda bu adreslere Python'dan yazilir; FPGA modunda ayni degerler
UART paketiyle gelir. Iki tarafta da ayni CASM programi kosar.
"""
import math
import os
import struct

BURASI = os.path.dirname(os.path.abspath(__file__))

# =====================================================================
#  IC: ic dongu CLA'da (varsayilan)
# =====================================================================
GIRDILER_IC = [         # her ic adim: sensor + CPU'nun dis dongu ciktisi
    ("_TH",  0x1500, "egim acisi [rad] (olculen)"),
    ("_W",   0x1502, "acisal hiz [rad/s] (olculen)"),
    ("_THD", 0x1504, "istenen egim [rad] (CPU dis dongusu)"),
    ("_TV",  0x1506, "dikey itki istegi m (g + a_y) [N] (CPU dis dongusu)"),
]

# ic dongu kazanclari: KPT = w^2, KDT = 2 zeta w. dongu_hizi.py olcumu:
# iyi sonumlu en buyuk w (450 g govde) 100 Hz 34.5, 250 Hz 43.5, 500 Hz 46.9,
# 1 kHz 50.7, 2 kHz 50.7 rad/s. Her hiz icin w = 0.8 * w_max.
IC_ZETA = 0.8
IC_OMEGA = {100: 27.6, 250: 34.8, 500: 37.5, 1000: 40.5}   # [rad/s]
IC_OMEGA_ESKI = {100: 14.9, 250: 17.4, 500: 17.4, 1000: 18.8}   # ilk 1 kg govde (w_max 18.6..23.5)

PARAMETRELER_IC = [     # bir kez (govdeye ve kazanca bagli)
    ("_KPT",  0x1520, IC_OMEGA[500] ** 2,              "aci P [1/s^2]"),
    ("_KDT",  0x1522, 2 * IC_ZETA * IC_OMEGA[500],     "aci D [1/s]"),
    ("_KTAU", 0x1524, 1.3e-3 / (2 * 0.09),             "I / (2L): aci ivmesi -> itki farki [kg m]"),
    ("_FMAX", 0x1526, 12.0,                            "yan basina en buyuk itki [N]"),
    ("_C24",  0x1528, 1.0 / 24.0,                      "sabit 1/24 (cos)"),
    ("_CMIN", 0x152A, 0.5,                             "cos alt siniri"),
]

CIKTILAR_IC = [
    ("_FL", 0x1480, "sol itki istegi [N]"),
    ("_FR", 0x1482, "sag itki istegi [N]"),
    ("_T",  0x1484, "toplam itki TV / cos(th) [N]"),
]

YEREL_IC = []


def ic_kazanc(hz, omega=None, eski=False):
    """{sembol: deger}: verilen ic dongu hizi (ve govde) icin KPT, KDT."""
    tablo = IC_OMEGA_ESKI if eski else IC_OMEGA
    w = omega if omega is not None else tablo.get(hz, tablo[500])
    return {"_KPT": w * w, "_KDT": 2 * IC_ZETA * w}


# =====================================================================
#  ICK: aci kestirimi + ic dongu CLA'da (sensorlu, varsayilan)
# =====================================================================
ICK_TAU = 1.5           # tamamlayici suzgec zaman sabiti [s] (sensor_deney.py)
GIRDILER_ICK = [        # her ic adim: ham IMU + CPU'dan
    ("_GX",   0x1500, "jiroskop [rad/s] (govde)"),
    ("_FX",   0x1502, "ivmeolcer x [m/s^2] (govde, ozgul kuvvet)"),
    ("_FZ",   0x1504, "ivmeolcer z [m/s^2] (govde, ozgul kuvvet)"),
    ("_THD",  0x1506, "istenen egim [rad] (CPU dis dongusu)"),
    ("_TV",   0x1508, "dikey itki istegi [N] (CPU dis dongusu)"),
    ("_AXW",  0x150A, "olculen yatay ivme [m/s^2] (CPU, konum sisteminden)"),
    ("_AYW",  0x150C, "olculen dikey ivme [m/s^2] (CPU, konum sisteminden)"),
    ("_KORU", 0x150E, "1.0: kestirimi koru, 0.0: sifirla"),
]
PARAMETRELER_ICK = PARAMETRELER_IC + [
    ("_DT",    0x152C, 1.0 / 500,            "ic adim [s]"),
    ("_KK",    0x152E, (1.0 / 500) / ICK_TAU, "tamamlayici suzgec kazanci DT/tau"),
    ("_FZMIN", 0x1530, 2.0,                  "g_bz alt siniri [m/s^2]"),
    ("_UMAX",  0x1532, 1.0,                  "atan girdisi siniri"),
    ("_A1",    0x1534, 0.9998660,            "atan katsayilari (A&S 4.4.47)"),
    ("_A3",    0x1536, -0.3302995,           ""),
    ("_A5",    0x1538, 0.1801410,            ""),
    ("_A7",    0x153A, -0.0851330,           ""),
    ("_A9",    0x153C, 0.0208351,            ""),
    ("_C6",    0x153E, 1.0 / 6.0,            "sabit 1/6 (sin)"),
    ("_C120",  0x1540, 1.0 / 120.0,          "sabit 1/120 (sin)"),
]
CIKTILAR_ICK = CIKTILAR_IC + [
    ("_OTHK", 0x1486, "kestirilen egim [rad]"),
]
YEREL_ICK = [("_THK", 0x8800), ("_S0", 0x8810), ("_S1", 0x8812), ("_S2", 0x8814), ("_S3", 0x8816)]


def ick_hiz(hz):
    """{sembol: deger}: ic dongu hizina bagli kestirim parametreleri."""
    return {"_DT": 1.0 / hz, "_KK": (1.0 / hz) / ICK_TAU}


# =====================================================================
#  TEK: butun kaskad CLA'da (ilk surum, 1 kg govde)
# =====================================================================
# --- her adim: simulasyon -> CLA ---------------------------------------
GIRDILER_TEK = [            # (sembol, adres, aciklama)
    ("_X",   0x1500, "yatay konum [m]"),
    ("_Y",   0x1502, "yukseklik [m]"),
    ("_VX",  0x1504, "yatay hiz [m/s]"),
    ("_VY",  0x1506, "dikey hiz [m/s]"),
    ("_TH",  0x1508, "egim acisi [rad], saat yonu tersi +"),
    ("_W",   0x150A, "acisal hiz [rad/s]"),
    ("_XR",  0x150C, "hedef x [m]"),
    ("_YR",  0x150E, "hedef y [m]"),
    ("_KORU", 0x1510, "1.0: integratorleri koru, 0.0: sifirla (ilk adim, R tusu)"),
]

# --- bir kez: simulasyon -> CLA (kontrol parametreleri) -----------------
PARAMETRELER_TEK = [        # (sembol, adres, varsayilan, aciklama)
    ("_KPX",   0x1520, 3.0,   "yatay P [1/s^2]"),
    ("_KDX",   0x1522, 3.2,   "yatay D [1/s]"),
    ("_KIX",   0x1524, 0.8,   "yatay I [1/s^3]"),
    ("_KPY",   0x1526, 6.0,   "dikey P"),
    ("_KDY",   0x1528, 4.5,   "dikey D"),
    ("_KIY",   0x152A, 2.0,   "dikey I"),
    ("_KPT",   0x152C, 150.0, "aci P [1/s^2]"),
    ("_KDT",   0x152E, 22.0,  "aci D [1/s]"),
    ("_M",     0x1530, 1.0,   "kutle (kontrolcunun bildigi) [kg]"),
    ("_G",     0x1532, 9.81,  "yercekimi [m/s^2]"),
    ("_KTAU",  0x1534, 0.024, "I / (2L): aci ivmesi -> itki farki [kg m]"),
    ("_FMAX",  0x1536, 11.0,  "motor basina en buyuk itki [N]"),
    ("_THMAX", 0x1538, 0.6,   "en buyuk egim [rad]"),
    ("_AXMAX", 0x153A, 8.0,   "en buyuk yatay ivme istegi [m/s^2]"),
    ("_AYMAX", 0x153C, 6.0,   "en buyuk yukari ivme istegi [m/s^2]"),
    ("_DT",    0x153E, 0.01,  "kontrol adimi [s]"),
    ("_IMAXX", 0x1540, 8.0,   "yatay integrator siniri"),
    ("_GYMIN", 0x1542, 2.0,   "g + a_y alt siniri [m/s^2]"),
    ("_C3",    0x1544, 1.0 / 3.0,  "sabit 1/3 (atan)"),
    ("_C5",    0x1546, 0.2,        "sabit 1/5 (atan)"),
    ("_C24",   0x1548, 1.0 / 24.0, "sabit 1/24 (cos)"),
    ("_CMIN",  0x154A, 0.5,   "cos alt siniri"),
    ("_UMAX",  0x154C, 0.7,   "atan girdisi siniri"),
    ("_IMAXY", 0x154E, 3.0,   "dikey integrator siniri"),
    ("_AYMIN", 0x1550, -3.5,  "en buyuk asagi ivme istegi (negatif) [m/s^2]"),
    ("_EIMAX", 0x1552, 1.0,   "integratore giren hata siniri [m]"),
    ("_VZONE", 0x1554, 1.0,   "integrator yalniz |v| bunun altindayken calisir [m/s]"),
]

# --- her adim: CLA -> simulasyon ----------------------------------------
CIKTILAR_TEK = [
    ("_FL",  0x1480, "sol motor itkisi [N]"),
    ("_FR",  0x1482, "sag motor itkisi [N]"),
    ("_THD", 0x1484, "istenen egim [rad]"),
    ("_T",   0x1486, "toplam itki istegi [N]"),
    ("_OIX", 0x1488, "yatay integrator"),
    ("_OIY", 0x148A, "dikey integrator"),
]

# --- CLA'nin kendi bellegi (L1) -----------------------------------------
YEREL_TEK = [
    ("_IX", 0x8800), ("_IY", 0x8802),                       # integratorler (adimlar arasi)
    ("_S0", 0x8810), ("_S1", 0x8812), ("_S2", 0x8814), ("_S3", 0x8816),   # ara degerler
    ("_S5", 0x881A),
]




# =====================================================================
class Duzen(object):
    """Bir CLA programinin mesaj RAM sozlesmesi."""

    def __init__(self, ad, casm, girdiler, parametreler, ciktilar, yerel, ornek, aciklama):
        self.ad, self.casm, self.aciklama = ad, os.path.join(BURASI, casm), aciklama
        self.girdiler, self.parametreler, self.ciktilar, self.yerel = girdiler, parametreler, ciktilar, yerel
        self.ornek = ornek                  # tipik girdi (float), boru hatti izi icin

    def semboller(self):
        """Assembler icin {sembol: adres}."""
        s = {}
        for liste in (self.girdiler, self.ciktilar):
            for ad, adr, _ in liste:
                s[ad] = adr
        for ad, adr, *_ in self.parametreler:
            s[ad] = adr
        for ad, adr in self.yerel:
            s[ad] = adr
        return s

    def parametre_bitleri(self, degisen=None):
        """[(adres, bitler)] - varsayilanlar + degisen {sembol: deger}."""
        degisen = degisen or {}
        return [(adr, f2b(degisen.get(ad, v))) for ad, adr, v, _ in self.parametreler]

    def varsayilan(self):
        return {ad: v for ad, _, v, _ in self.parametreler}

    def rastgele_girdi(self, r):
        """Gercekci aralikta rastgele girdi (float) - kart/golden karsilastirmasi icin."""
        if self.ad == "ic":
            return [r.gauss(0, 0.3), r.gauss(0, 3.0), r.uniform(-0.6, 0.6), r.uniform(1.0, 10.0)]
        if self.ad == "ick":
            th = r.gauss(0, 0.3)
            return [r.gauss(0, 3.0), 9.81 * math.sin(th) + r.gauss(0, 1.0), 9.81 * math.cos(th) + r.gauss(0, 2.0),
                    r.uniform(-0.6, 0.6), r.uniform(1.0, 10.0), r.gauss(0, 3.0), r.gauss(0, 2.0), 1.0]
        return [r.uniform(-8, 8), r.uniform(0, 12), r.gauss(0, 1), r.gauss(0, 1), r.gauss(0, 0.2),
                r.gauss(0, 1), r.uniform(-8, 8), r.uniform(0.5, 12), 1.0]


IC = Duzen("ic", "ic_dongu.casm", GIRDILER_IC, PARAMETRELER_IC, CIKTILAR_IC, YEREL_IC,
           [0.05, 0.3, 0.1, 0.45 * 9.81], "iç döngü CLA'da, dış döngü CPU'da (ideal sensör)")
ICK = Duzen("ick", "ic_kestirim.casm", GIRDILER_ICK, PARAMETRELER_ICK, CIKTILAR_ICK, YEREL_ICK,
            [0.3, 0.5, 9.8, 0.1, 0.45 * 9.81, 0.2, 0.0, 1.0],
            "açı kestirimi + iç döngü CLA'da, dış döngü CPU'da (sensörlü)")
TEK = Duzen("tek", "kontrolcu.casm", GIRDILER_TEK, PARAMETRELER_TEK, CIKTILAR_TEK, YEREL_TEK,
            [0, 1, 0, 0, 0, 0, 0, 2, 1], "bütün kaskad CLA'da (ilk sürüm)")
DUZENLER = {"ick": ICK, "ic": IC, "tek": TEK}


def f2b(x):
    """float -> float32 bitleri (en yakin cift)."""
    return struct.unpack("<I", struct.pack("<f", float(x)))[0]


def b2f(b):
    return struct.unpack("<f", struct.pack("<I", b & 0xFFFFFFFF))[0]
