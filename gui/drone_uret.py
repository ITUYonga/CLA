# -*- coding: utf-8 -*-
"""drone_uret.py - drone.casm'i uretir (eksen tekrarlarini elle yazmamak icin).

    python3 drone_uret.py            -> drone.casm

Sembol adresleri sim_baglanti.py'deki M_/K_/C_ tablolarindan gelir; yerlesim degisirse
bu betik yeniden kosturulur. Uretilen drone.casm okunabilir ve tek basina kullanilir.

Gorevler (TI CLA: gorev 1 en yuksek oncelik):
  1  hiz dongusu (PI + olcumden D) + motor karistirici       her adim (1 kHz)
  2  aci dongusu (P)                                          2 adimda bir
  3  konum (P) -> hiz (PI) -> ivme -> aci / itki referansi    10 adimda bir
  4  bozucu gozlemcisi (hiz tabanli , dis ivme kestirimi)     10 adimda bir
  8  C2M durumunu sifirla                                     SK_SIFIRLA'da
Kural: kalici durum C2M'de , kazanclar M2C'de ; L1 yalniz gorev ici gecici.
"""
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "pc"))
import sim_baglanti as sb  # noqa: E402

M2C_TABAN, C2M_TABAN, L1_TABAN = 0x1500, 0x1480, 0x8800
C2M_DURUM = sb.C_DURUM_SAYI                      # gorev 8'in sifirladigi kelime sayisi

satirlar = []


def y(s=""):
    satirlar.append(s)


def semboller():
    y("; ---- semboller (drone_uret.py uretti)")
    for ad in dir(sb):
        v = getattr(sb, ad)
        if ad.startswith("M_") and ad not in ("M_KAZANC", "M_SAYI"):
            y(";#sembol _m_%s 0x%04X" % (ad[2:].lower(), M2C_TABAN + 2 * v))
        elif ad.startswith("K_") and ad != "K_SAYI":
            y(";#sembol _k_%s 0x%04X" % (ad[2:].lower(), M2C_TABAN + 2 * (sb.M_KAZANC + v)))
        elif ad.startswith("C_") and ad not in ("C_SAYI", "C_DURUM_SAYI"):
            y(";#sembol _c_%s 0x%04X" % (ad[2:].lower(), C2M_TABAN + 2 * v))
    for i, ad in enumerate(["dx", "dy", "dz", "amx", "amy"]):
        y(";#sembol _l_%s 0x%04X" % (ad, L1_TABAN + 2 * i))
    for no, et in ((1, "GOREV1"), (2, "GOREV2"), (3, "GOREV3"), (4, "GOREV4"), (8, "GOREV8")):
        y(";#gorev %d %s" % (no, et))
    y()


def kirp(r, lim, tmp):
    """r = min(max(r , -lim) , lim) ; lim bellekte , tmp bozulur."""
    y("    MMOV32  %s, @%s" % (tmp, lim))
    y("    MMINF32 %s, %s" % (r, tmp))
    y("    MNEGF32 %s, %s" % (tmp, tmp))
    y("    MMAXF32 %s, %s" % (r, tmp))


def sayac(ad):
    y("    MMOVIZ  MR1, #0.0")
    y("    MMOVXI  MR1, #1")
    y("    MMOV32  MR0, @%s" % ad)
    y("    MADD32  MR0, MR0, MR1")
    y("    MMOV32  @%s, MR0" % ad)


def gorev1():
    y("; ================================================================ GOREV 1 : hiz dongusu + karistirici")
    y("GOREV1:")
    y("    MSETFLG RNDF32=1")
    for eks, w, kp, ki, kd, cik in (("z", "r", "kp_r_z", "ki_r_z", None, "dz"),
                                    ("x", "p", "kp_r_xy", "ki_r_xy", "kd_r_xy", "dx"),
                                    ("y", "q", "kp_r_xy", "ki_r_xy", "kd_r_xy", "dy")):
        y("    ; -- eksen %s : d = kirp(kp*e + I - kd*(w - w_once)) , I = kirp(I + ki*e)" % eks)
        y("    MMOV32  MR0, @_c_wref_%s" % eks)
        y("    MMOV32  MR1, @_m_%s" % w)
        y("    MSUBF32 MR0, MR0, MR1        ; e")
        y("    MMOV32  MR2, @_k_%s" % ki)
        y("    MMPYF32 MR2, MR2, MR0")
        y("    MMOV32  MR3, @_c_ir_%s" % eks)
        y("    MADDF32 MR3, MR3, MR2        ; I + ki*e")
        kirp("MR3", "_k_ilim_r", "MR2")
        y("    MMOV32  @_c_ir_%s, MR3" % eks)
        y("    MMOV32  MR2, @_k_%s" % kp)
        y("    MMPYF32 MR0, MR2, MR0")
        y("    MADDF32 MR0, MR0, MR3        ; kp*e + I")
        if kd:
            y("    MMOV32  MR3, @_c_wp_%s" % eks)
            y("    MSUBF32 MR3, MR1, MR3        ; w - w_once")
            y("    MMOV32  MR2, @_k_%s" % kd)
            y("    MMPYF32 MR3, MR2, MR3")
            y("    MSUBF32 MR0, MR0, MR3")
        y("    MMOV32  @_c_wp_%s, MR1" % eks)
        kirp("MR0", "_k_dlim", "MR2")
        if cik != "dy":
            y("    MMOV32  @_l_%s, MR0" % cik)
    y("    ; -- karistirici : u1 = t-dy+dz , u2 = t+dx-dz , u3 = t+dy+dz , u4 = t-dx-dz ; [0,1]")
    y("    MMOV32  MR1, MR0                ; dy")
    y("    MMOV32  MR0, @_c_t")
    y("    MMOV32  MR2, @_l_dz")
    for ad, ilk, ikinci in (("u1", "MSUBF32", "MADDF32"), ("u3", "MADDF32", "MADDF32")):
        y("    %s MR3, MR0, MR1" % ilk)
        y("    %s MR3, MR3, MR2" % ikinci)
        y("    MMINF32 MR3, #1.0")
        y("    MMAXF32 MR3, #0.0")
        y("    MMOV32  @_c_%s, MR3" % ad)
    y("    MMOV32  MR1, @_l_dx")
    for ad, ilk in (("u2", "MADDF32"), ("u4", "MSUBF32")):
        y("    %s MR3, MR0, MR1" % ilk)
        y("    MSUBF32 MR3, MR3, MR2")
        y("    MMINF32 MR3, #1.0")
        y("    MMAXF32 MR3, #0.0")
        y("    MMOV32  @_c_%s, MR3" % ad)
    sayac("_c_say1")
    y("    MSTOP")
    y()


def gorev2():
    y("; ================================================================ GOREV 2 : aci dongusu")
    y("GOREV2:")
    y("    MSETFLG RNDF32=1")
    for ref, olc, ka, wm, cik in (("_c_roll_ref", "_m_roll", "_k_ka_xy", "_k_wmax_xy", "_c_wref_x"),
                                  ("_c_pitch_ref", "_m_pitch", "_k_ka_xy", "_k_wmax_xy", "_c_wref_y"),
                                  ("_k_yaw_ref", "_m_yaw", "_k_ka_z", "_k_wmax_z", "_c_wref_z")):
        y("    MMOV32  MR0, @%s" % ref)
        y("    MMOV32  MR1, @%s" % olc)
        y("    MSUBF32 MR0, MR0, MR1")
        y("    MMOV32  MR1, @%s" % ka)
        y("    MMPYF32 MR0, MR1, MR0")
        kirp("MR0", wm, "MR2")
        y("    MMOV32  @%s, MR0" % cik)
    sayac("_c_say2")
    y("    MSTOP")
    y()


def gorev3():
    y("; ================================================================ GOREV 3 : konum / hiz dongusu")
    y("GOREV3:")
    y("    MSETFLG RNDF32=1")
    for eks, kp, vm, kv, ki in (("x", "kp_p_xy", "vmax_xy", "kp_v_xy", "ki_v_xy"),
                                ("y", "kp_p_xy", "vmax_xy", "kp_v_xy", "ki_v_xy"),
                                ("z", "kp_p_z", "vmax_z", "kp_v_z", "ki_v_z")):
        y("    ; -- eksen %s : vr = kirp(kp*(h-p)) , ev = vr-v , I = kirp(I + dff*eh + ki*ev) , a = kv*ev + I - ff*eh" % eks)
        y("    MMOV32  MR0, @_m_h%s" % eks)
        y("    MMOV32  MR1, @_m_p%s" % eks)
        y("    MSUBF32 MR0, MR0, MR1")
        y("    MMOV32  MR1, @_k_%s" % kp)
        y("    MMPYF32 MR0, MR1, MR0")
        kirp("MR0", "_k_" + vm, "MR1")
        y("    MMOV32  MR1, @_m_v%s" % eks)
        y("    MSUBF32 MR0, MR0, MR1        ; ev")
        y("    MMOV32  MR1, @_m_ff")
        y("    MMOV32  MR2, @_c_ff_once")
        y("    MSUBF32 MR1, MR1, MR2        ; dff : gozlemci acilip kapaninca integrali kaydir")
        y("    MMOV32  MR2, @_c_eh_%s" % eks)
        y("    MMPYF32 MR1, MR1, MR2")
        y("    MMOV32  MR2, @_c_iv_%s" % eks)
        y("    MADDF32 MR1, MR2, MR1")
        y("    MMOV32  MR2, @_k_%s" % ki)
        y("    MMPYF32 MR2, MR2, MR0")
        y("    MADDF32 MR1, MR1, MR2")
        kirp("MR1", "_k_ilim_v", "MR2")
        y("    MMOV32  @_c_iv_%s, MR1" % eks)
        y("    MMOV32  MR2, @_k_%s" % kv)
        y("    MMPYF32 MR0, MR2, MR0")
        y("    MADDF32 MR0, MR0, MR1")
        y("    MMOV32  MR1, @_m_ff")
        y("    MMOV32  MR2, @_c_eh_%s" % eks)
        y("    MMPYF32 MR1, MR1, MR2")
        y("    MSUBF32 MR0, MR0, MR1        ; a")
        y("    MMOV32  @_c_ac_%s, MR0" % eks)
    y("    ; -- aci referansi (kucuk aci , yaw ile dondur) : pitch = (cy*ax + sy*ay)/g , roll = (sy*ax - cy*ay)/g")
    y("    MMOV32  MR0, @_c_ac_x")
    y("    MMOV32  MR1, @_c_ac_y")
    y("    MMOV32  MR2, @_m_cosy")
    y("    MMOV32  MR3, @_m_siny")
    y("    MMPYF32 MR2, MR2, MR0")
    y("    MMPYF32 MR3, MR3, MR1")
    y("    MADDF32 MR2, MR2, MR3")
    y("    MMOV32  MR3, @_k_inv_g")
    y("    MMPYF32 MR2, MR2, MR3")
    kirp("MR2", "_k_aci_max", "MR3")
    y("    MMOV32  @_c_pitch_ref, MR2")
    y("    MMOV32  MR2, @_m_siny")
    y("    MMPYF32 MR0, MR2, MR0")
    y("    MMOV32  MR2, @_m_cosy")
    y("    MMPYF32 MR1, MR2, MR1")
    y("    MSUBF32 MR0, MR0, MR1")
    y("    MMOV32  MR3, @_k_inv_g")
    y("    MMPYF32 MR0, MR0, MR3")
    kirp("MR0", "_k_aci_max", "MR3")
    y("    MMOV32  @_c_roll_ref, MR0")
    y("    MMOV32  MR0, @_m_ff")
    y("    MMOV32  @_c_ff_once, MR0")
    y("    ; -- itki : t = [tmin,tmax](ct * (g + az) * (1 + (roll^2 + pitch^2)/2))")
    y("    MMOV32  MR0, @_m_roll")
    y("    MMPYF32 MR0, MR0, MR0")
    y("    MMOV32  MR1, @_m_pitch")
    y("    MMPYF32 MR1, MR1, MR1")
    y("    MADDF32 MR0, MR0, MR1")
    y("    MMPYF32 MR0, #0.5, MR0")
    y("    MADDF32 MR0, #1.0, MR0")
    y("    MMOV32  MR1, @_k_g")
    y("    MMOV32  MR2, @_c_ac_z")
    y("    MADDF32 MR1, MR1, MR2")
    y("    MMOV32  MR2, @_k_ct")
    y("    MMPYF32 MR1, MR2, MR1")
    y("    MMPYF32 MR1, MR1, MR0")
    y("    MMOV32  MR2, @_k_tmin")
    y("    MMAXF32 MR1, MR2")
    y("    MMOV32  MR2, @_k_tmax")
    y("    MMINF32 MR1, MR2")
    y("    MMOV32  @_c_t, MR1")
    sayac("_c_say3")
    y("    MSTOP")
    y()


def gorev4():
    y("; ================================================================ GOREV 4 : bozucu gozlemcisi")
    y("; model ivmesi (olculen aci + komut itkisi) : A = t/ct")
    y(";   amx = A*(cy*pitch + sy*roll) , amy = A*(sy*pitch - cy*roll) , amz = A*(1 - (roll^2+pitch^2)/2) - g")
    y("; her eksen: e = v - vh , vh += ts*(am + eh) + l1*e , eh = kirp(eh + l2*e)")
    y("GOREV4:")
    y("    MSETFLG RNDF32=1")
    y("    MMOV32  MR0, @_c_t")
    y("    MMOV32  MR1, @_k_inv_ct")
    y("    MMPYF32 MR0, MR0, MR1        ; A")
    y("    MMOV32  MR1, @_m_cosy")
    y("    MMOV32  MR2, @_m_pitch")
    y("    MMPYF32 MR1, MR1, MR2")
    y("    MMOV32  MR2, @_m_siny")
    y("    MMOV32  MR3, @_m_roll")
    y("    MMPYF32 MR2, MR2, MR3")
    y("    MADDF32 MR1, MR1, MR2")
    y("    MMPYF32 MR1, MR0, MR1")
    y("    MMOV32  @_l_amx, MR1")
    y("    MMOV32  MR1, @_m_siny")
    y("    MMOV32  MR2, @_m_pitch")
    y("    MMPYF32 MR1, MR1, MR2")
    y("    MMOV32  MR2, @_m_cosy")
    y("    MMPYF32 MR2, MR2, MR3")
    y("    MSUBF32 MR1, MR1, MR2")
    y("    MMPYF32 MR1, MR0, MR1")
    y("    MMOV32  @_l_amy, MR1")
    y("    MMPYF32 MR1, MR3, MR3")
    y("    MMOV32  MR2, @_m_pitch")
    y("    MMPYF32 MR2, MR2, MR2")
    y("    MADDF32 MR1, MR1, MR2")
    y("    MMPYF32 MR1, #0.5, MR1")
    y("    MSUBF32 MR1, #1.0, MR1")
    y("    MMPYF32 MR1, MR0, MR1")
    y("    MMOV32  MR2, @_k_g")
    y("    MSUBF32 MR1, MR1, MR2        ; amz")
    for eks in ("z", "x", "y"):
        if eks != "z":
            y("    MMOV32  MR1, @_l_am%s" % eks)
        y("    ; -- eksen %s" % eks)
        y("    MMOV32  MR0, @_m_v%s" % eks)
        y("    MMOV32  MR2, @_c_vh_%s" % eks)
        y("    MSUBF32 MR0, MR0, MR2        ; e")
        y("    MMOV32  MR3, @_c_eh_%s" % eks)
        y("    MADDF32 MR1, MR1, MR3        ; am + eh")
        y("    MMOV32  MR3, @_k_ts_obs")
        y("    MMPYF32 MR1, MR3, MR1")
        y("    MADDF32 MR2, MR2, MR1")
        y("    MMOV32  MR3, @_k_l1")
        y("    MMPYF32 MR1, MR3, MR0")
        y("    MADDF32 MR2, MR2, MR1")
        y("    MMOV32  @_c_vh_%s, MR2" % eks)
        y("    MMOV32  MR3, @_k_l2")
        y("    MMPYF32 MR0, MR3, MR0")
        y("    MMOV32  MR1, @_c_eh_%s" % eks)
        y("    MADDF32 MR1, MR1, MR0")
        kirp("MR1", "_k_elim", "MR2")
        y("    MMOV32  @_c_eh_%s, MR1" % eks)
    sayac("_c_say4")
    y("    MSTOP")
    y()


def gorev8():
    y("; ================================================================ GOREV 8 : C2M durumunu sifirla")
    y("GOREV8:")
    y("    MMOVIZ  MR0, #0.0")
    for i in range(C2M_DURUM):
        y("    MMOV32  @0x%04X, MR0" % (C2M_TABAN + 2 * i))
    y("    MSTOP")
    y()


def main():
    y("; drone.casm - KV260 CLA drone ucus kontrolcusu (drone_uret.py uretti , elle duzenlemeyin)")
    y("; yerlesim: sw/sim_fizik.h ; algoritma ve kazanclar: doc/cla_drone.md")
    y()
    semboller()
    gorev1()
    gorev2()
    gorev3()
    gorev4()
    gorev8()
    yol = os.path.join(os.path.dirname(os.path.abspath(__file__)), "drone.casm")
    with open(yol, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(satirlar) + "\n")
    print("%s: %d satir" % (yol, len(satirlar)))


if __name__ == "__main__":
    main()
