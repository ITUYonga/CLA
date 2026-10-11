# -*- coding: utf-8 -*-
"""sim_baglanti.py - sim_fizik.c'ye ctypes baglantisi ve M2C/C2M yerlesim sabitleri.

Kartta fizik radar_server icinde (C) kosar; PC'de ayni C kodu bu modulle kullanilir:
kapali dongu golden testi (cla_dongu.py) ve GUI'nin --model modu.

    gcc -O2 -ffp-contract=off -shared -fPIC -o libsim.so ../sw/sim_fizik.c ../sw/cla_ref.c -lm
    (Windows / MinGW: ayni komut , cikti libsim.dll)
"""
import ctypes
import os
import struct
import sys

M_PX, M_PY, M_PZ, M_VX, M_VY, M_VZ = range(6)
M_ROLL, M_PITCH, M_YAW, M_P, M_Q, M_R = range(6, 12)
M_HX, M_HY, M_HZ, M_COSY, M_SINY, M_FF = range(12, 18)
M_KAZANC, M_SAYI = 20, 64

(K_KP_R_XY, K_KI_R_XY, K_KD_R_XY, K_KP_R_Z, K_KI_R_Z, K_ILIM_R, K_DLIM,
 K_KA_XY, K_KA_Z, K_WMAX_XY, K_WMAX_Z,
 K_KP_P_XY, K_KP_P_Z, K_VMAX_XY, K_VMAX_Z, K_KP_V_XY, K_KP_V_Z, K_KI_V_XY, K_KI_V_Z, K_ILIM_V,
 K_ACI_MAX, K_G, K_INV_G, K_CT, K_TMIN, K_TMAX,
 K_L1, K_L2, K_TS_OBS, K_ELIM, K_YAW_REF, K_INV_CT, K_SAYI) = range(33)

(C_U1, C_U2, C_U3, C_U4, C_WREF_X, C_WREF_Y, C_WREF_Z, C_ROLL_REF, C_PITCH_REF, C_T,
 C_IR_X, C_IR_Y, C_IR_Z, C_WP_X, C_WP_Y, C_WP_Z, C_IV_X, C_IV_Y, C_IV_Z, C_AC_X, C_AC_Y, C_AC_Z,
 C_VH_X, C_VH_Y, C_VH_Z, C_EH_X, C_EH_Y, C_EH_Z, C_SAY1, C_SAY2, C_SAY3, C_SAY4, C_FF_ONCE, C_DURUM_SAYI) = range(34)
C_SAYI = 64

SK_SIFIRLA, SK_HEDEF, SK_RUZGAR, SK_DARBE, SK_MOTOR, SK_YUK, SK_GOZLEMCI = 3, 4, 5, 6, 7, 8, 9

F3 = ctypes.c_float * 3
F4 = ctypes.c_float * 4


class Sim(ctypes.Structure):
    _fields_ = [("kutle", ctypes.c_float), ("kol", ctypes.c_float), ("ixx", ctypes.c_float),
                ("iyy", ctypes.c_float), ("izz", ctypes.c_float), ("kt", ctypes.c_float),
                ("km", ctypes.c_float), ("motor_tau", ctypes.c_float), ("surtunme", ctypes.c_float),
                ("bolen", ctypes.c_uint32 * 4), ("kazanc", ctypes.c_float * 40), ("kazanc_n", ctypes.c_uint32),
                ("poz", F3), ("hiz", F3), ("euler", F3), ("w", F3), ("itki", F4), ("u", F4), ("hedef", F3),
                ("adim", ctypes.c_uint32),
                ("ruzgar", F3), ("darbe", F3), ("darbe_kalan_s", ctypes.c_float), ("motor_verim", F4),
                ("ek_kutle", ctypes.c_float), ("gozlemci", ctypes.c_int), ("kestirim", F3)]


def kutuphane(yol=None):
    if yol is None:
        ad = "libsim.dll" if sys.platform.startswith("win") else "libsim.so"
        yol = os.path.join(os.path.dirname(os.path.abspath(__file__)), ad)
    lib = ctypes.CDLL(yol)
    lib.sim_boyut.restype = ctypes.c_uint32
    if lib.sim_boyut() != ctypes.sizeof(Sim):
        raise RuntimeError("sim_t boyutu uyusmuyor: C %d , Python %d" % (lib.sim_boyut(), ctypes.sizeof(Sim)))
    lib.sim_gorev_maske.restype = ctypes.c_uint32
    lib.sim_komut.restype = ctypes.c_int
    return lib


def cla_ref(lib, maske, m2c, c2m):
    """sw/cla_ref.c (CASM'in C karsiligi) ile bir adim; c2m listesi yerinde guncellenir."""
    m = (ctypes.c_uint32 * 64)(*m2c)
    c = (ctypes.c_uint32 * 64)(*c2m)
    lib.cla_ref_calistir(ctypes.c_uint32(maske), m, c)
    c2m[:] = list(c)


class Drone(object):
    """Fizik + M2C/C2M donusumu. CLA arka ucu disaridan verilir (golden ya da kart)."""

    def __init__(self, lib=None):
        self.lib = lib or kutuphane()
        self.s = Sim()
        self.lib.sim_varsayilan(ctypes.byref(self.s))

    def komut(self, k, a=(0, 0, 0), b=(0, 0)):
        if self.lib.sim_komut(ctypes.byref(self.s), k, F3(*a), (ctypes.c_float * 2)(*b)) != 0:
            raise ValueError("gecersiz komut %d" % k)

    def maske(self):
        return self.lib.sim_gorev_maske(ctypes.byref(self.s))

    def m2c(self):
        b = (ctypes.c_uint32 * M_SAYI)()
        self.lib.sim_m2c_doldur(ctypes.byref(self.s), b)
        return list(b)

    def c2m_al(self, c2m):
        self.lib.sim_c2m_al(ctypes.byref(self.s), (ctypes.c_uint32 * C_SAYI)(*c2m))

    def adim(self):
        self.lib.sim_adim(ctypes.byref(self.s))


def f2u(f):
    return struct.unpack("<I", struct.pack("<f", f))[0]


def u2f(u):
    return struct.unpack("<f", struct.pack("<I", u & 0xFFFFFFFF))[0]
