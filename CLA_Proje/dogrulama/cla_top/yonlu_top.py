"""CLA_Top yonlu testleri: gorev gecisinde dur_exe, ard arda gorevler, gecersiz buyrukta donma."""
import os, random
from top_ortak import *

rnd = random.Random(5)
os.makedirs("yonlu", exist_ok=True)
SIFIR_L = [0] * 1024; SIFIR_M = [0] * 128
A, B = 0x3FC00000, 0x40200000                 # 1.5 , 2.5


def fp(ad, **f):
    return kodla(ad, **f)


ADD = "MADDF32 MRa, MRb, MRc"
MPY = "MMPYF32 MRa, MRb, MRc"
ST32 = "MMOV32 mem32, MRa"
LD32 = "MMOV32 MRa, mem32 {, CNDF}"
KUYRUK = [MSTOP, MNOP, MNOP, MNOP]


def gorev(govde):
    return mr_yukle(1, A) + mr_yukle(2, B) + govde + KUYRUK


senaryolar = {}
# gorev 1'in son buyruklari K2 sonucunu okuyor -> MSTOP'tan sonra dur_exe (n+2, n+1, iki kez)
g_n2 = gorev([fp(ADD, a=0, b=1, c=2), fp(ST32, addr=0, m=0x8800, a=0)])
g_n1 = gorev([fp(ADD, a=0, b=1, c=2), fp(ST32, addr=0, m=0x8800, a=0), MNOP])
g_iki = gorev([fp(ADD, a=0, b=1, c=2), fp(MPY, a=3, b=0, c=0), fp(ST32, addr=0, m=0x8804, a=3)])
g_duz = gorev([fp(ADD, a=0, b=1, c=2), MNOP, MNOP, MNOP])
g2 = mr_yukle(3, B) + [fp(ST32, addr=0, m=0x8810, a=3), fp(ADD, a=0, b=3, c=3), fp(ST32, addr=0, m=0x8812, a=0)] + KUYRUK
for ad, g1 in (("dur_n2", g_n2), ("dur_n1", g_n1), ("dur_iki", g_iki), ("dursuz", g_duz)):
    senaryolar["gecis_" + ad] = (g1 + g2, [0, 2 * len(g1)])
# uc gorev, hepsi dur_exe ile bitiyor
g3 = mr_yukle(1, B) + [fp(MPY, a=2, b=1, c=1), fp(ST32, addr=0, m=0x8C00, a=2)] + KUYRUK
kel = g_n2 + g_iki + g3
senaryolar["gecis_uc_gorev"] = (kel, [0, 2 * len(g_n2), 2 * (len(g_n2) + len(g_iki))])
# gorev 2 bos degil ama yalniz MSTOP (en kisa gorev)
senaryolar["gecis_kisa_gorev"] = (g_n2 + KUYRUK + g2, [0, 2 * len(g_n2), 2 * (len(g_n2) + 4)])

# gecersiz buyruk (tek gorev): E/W'de, K2'de ve R'de is varken D2'de goruluyor
GEC = 0xFFFFFFFF
for i, onu in enumerate(([fp(ADD, a=0, b=1, c=2)],                                          # K2 bekliyor
                         [fp(ST32, addr=0, m=0x8800, a=1)],                                 # W yazmasi
                         [fp(ADD, a=0, b=1, c=2), fp(ST32, addr=0, m=0x8800, a=0)],         # dur_exe ile
                         [fp(LD32, a=3, addr=0, m=0x8900, cndf=14), fp(MPY, a=0, b=1, c=2), MNOP],
                         [MNOP, MNOP, MNOP, MNOP, fp(ADD, a=0, b=1, c=2), fp(ST32, addr=0, m=0x8C00, a=2)])):
    senaryolar["gecersiz_%d" % i] = (mr_yukle(1, A) + mr_yukle(2, B) + onu + [GEC] + [MNOP] * 3 + KUYRUK, [0])
# gecersiz buyruk atlanan dal yolunda: hic D2'ye gelmez
senaryolar["gecersiz_atlanan"] = (mr_yukle(1, A) + [kodla("MBCNDD 16BitDest {, CNDF}", dest=10, cndf=14),
                                  MNOP, MNOP, MNOP, GEC, fp(ST32, addr=0, m=0x8800, a=1), MNOP, MNOP, MNOP] + KUYRUK, [0])

hatali = 0
for ad, (kel, mvect) in senaryolar.items():
    temiz = [MNOP if w == GEC else w for w in kel]
    lh = lint_hatalari(temiz)
    tamam, rapor, sayac, satir = kostur("yonlu/" + ad, kel, mvect, SIFIR_L, SIFIR_L, SIFIR_M, SIFIR_M)
    hatali += not tamam
    print("%-22s %3d satir  %-6s  dur_exe %d  lint %s" % (ad, satir, "AYNI" if tamam else "FARKLI",
          sayac.get("dur_exe", -1), "temiz" if not lh else lh))
    for r in rapor: print("    " + r)
print("senaryo: %d  hatali: %d" % (len(senaryolar), hatali))
