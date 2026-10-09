"""CLA_Top rastgele tam boru hatti testi.
Rastgele program (MAR'li adresleme, ileri dallar, MCCNDD/MRCNDD cagrisi, dur_r1, gorev gecisinde dur_exe,
1-3 gorev, gecersiz buyruk) uretir, golden lint'ten gecirir, golden BORU HATTINDA kosturur; RTL tezgahinin
iziyle, son bellek ve yazmaclarla karsilastirir.  Kullanim: rastgele_top.py N [tohum]

Yaz-oku tehlikesi olmasin diye bellek bolgeleri ayrik:
  okuma : L1 0x8900-0x89FF, L2 0x8D00-0x8DFF, C2M 0x14C0-0x14FF, M2C (MAR0 kipi de burada), MAR1 kipi L2 okuma yarisi
  yazma : L1 0x8800-0x88FF, L2 0x8C00-0x8CFF, C2M 0x1480-0x14BF
  MMOVD32 (okur + yazar) : L1 0x8A00-0x8AFF, her biri kendi 4 kelimelik yuvasinda (bir kez kullanilir)
Okuma ile yazma ayni blokta oldugunda dur_r1 olusur."""
import sys, os, random, collections
from top_ortak import *
from golden_model import erisim as E
from golden_model.pipeline import BoruState, BoruBellek, BoruKaydi

N = int(sys.argv[1]); TOHUM = int(sys.argv[2]) if len(sys.argv) > 2 else 1
rnd = random.Random(TOHUM)
DALLAR = {"MBCNDD 16BitDest {, CNDF}", "MCCNDD 16BitDest {, CNDF}", "MRCNDD {CNDF}"}
MAR_YUKLE_SERBEST = {"MMOV16 MARx, MRa, #16I", "MMOV16 MARx, mem16"}      # MAR'a rastgele deger yukler
MSTF_YUKLE = "MMOV32 MSTF, mem32"                                           # RPC'yi de yukler
CNDF = [0, 1, 2, 3, 4, 5, 10, 11, 12, 13, 14, 15]
OZEL = [0x00000000, 0x80000000, 0x7F800000, 0xFF800000, 0x7FC00000, 0x00000001, 0x807FFFFF, 0x3F800000,
        0xBF800000, 0x7F7FFFFF, 0x00800000, 0x40490FDB, 0x0000FFFF, 0xFFFF8000, 0x4F000000, 0x5F800000]
OKU = [(0x8900, 0x89FF), (0x8D00, 0x8DFF), (0x14C0, 0x14FF), (0x1500, 0x157F)]
YAZ = [(0x8800, 0x88FF), (0x8C00, 0x8CFF), (0x1480, 0x14BF)]
BELLEK = [e for e in TABLO if "addr" in e["fields"]]                       # bellege erisen buyruklar
d32_yuvalari = []                                                          # program basina bos yuvalar


def gecersiz_kelime():
    while True:
        w = rnd.getrandbits(32)
        try: decode(w)
        except Exception: return w


def rastgele_buyruk(mar_serbest=False, mar_kipi=True, mstf_yukle=True, tur=None, blok=None):
    """tur: None, "yaz" (bellege yazan) ya da "oku" (bellekten okuyan); blok: 0 L1, 1 L2, 2 C2M"""
    while True:
        e = rnd.choice(BELLEK if (tur or rnd.random() < 0.3) else TABLO)
        s = e["syntax"]
        if s in DALLAR or s in ("MSTOP", "MMOVI16 MARx, #16I"): continue
        if s in MAR_YUKLE_SERBEST and not mar_serbest: continue
        if s == MSTF_YUKLE and not mstf_yukle: continue
        if s == "MMOVD32 MRa, mem32" and (not d32_yuvalari or blok not in (None, 0)): continue
        okur = E.okur16(s) or E.okur32(s); yazar = E.yazar16(s) or E.yazar32(s)
        if tur == "yaz" and not yazar: continue
        if tur == "oku" and not okur: continue
        w = (rnd.getrandbits(32) & ~e["mask"]) | e["match"]
        f = e["fields"]
        for ad in ("cndf", "CNDF"):
            if ad in f: w = yerlestir(w, e, ad, rnd.choice(CNDF))
        d32 = None
        if "addr" in f:
            t = rnd.random()
            if okur and not yazar and mar_kipi and blok is None and t < 0.25:      # *MAR0[m]++ : M2C
                w = yerlestir(w, e, "addr", 1); w = yerlestir(w, e, "m", rnd.randint(-2, 2) & 0xFFFF)
            elif okur and not yazar and mar_kipi and blok is None and t < 0.45:    # *MAR1[m]++ : L2 okuma yarisi
                w = yerlestir(w, e, "addr", 2); w = yerlestir(w, e, "m", rnd.randint(-4, 4) & 0xFFFF)
            else:
                w = yerlestir(w, e, "addr", 0)
                if s == "MMOVD32 MRa, mem32":
                    d32 = rnd.choice(d32_yuvalari); adr = d32 + rnd.choice([0, 1])
                elif okur: adr = rnd.randint(*(OKU[blok] if blok is not None else rnd.choice(OKU)))
                else: adr = rnd.randint(*(YAZ[blok] if blok is not None else rnd.choice(YAZ)))
                w = yerlestir(w, e, "m", adr)
        c = decode(w)
        try:
            st = ClaState(); k = BoruKaydi(); k.gecerli = 1; k.cozum = c; k.okunan = 0; k.mar_before = [0, 0]
            D.dagit(c, BoruState(st, k), BoruBellek(k))
        except ValueError:
            continue                                                      # TI kisitlari
        if d32 is not None: d32_yuvalari.remove(d32)
        return w


def mar_baslat():
    return [kodla("MMOVI16 MARx, #16I", mar=0, I=rnd.randint(0x1538, 0x1548)),
            kodla("MMOVI16 MARx, #16I", mar=1, I=rnd.randint(0x8D60, 0x8DA0)),
            MNOP, MNOP, MNOP]                                             # MAR golgesi (3 buyruk)


def govde(boy, cagri):
    """cagri: alt program cagrisi yapilacak mi. Kelime listesi ve MCCNDD'nin indeksini doner."""
    k = []
    for x in range(4):
        k += mr_yukle(x, rnd.choice(OZEL) if rnd.random() < 0.5 else rnd.getrandbits(32))
    k.append(kodla("MSETFLG FLAG, VALUE", F=rnd.getrandbits(8), V=rnd.getrandbits(8)))
    k += mar_baslat()
    i, son_dal, sonraki_mar, mar_kirli, cagri_i = 0, -10, 12, False, None
    while i < boy:
        cagriya_yakin = cagri and cagri_i is None and i >= boy // 2 - 12   # RPC'yi bozacak MSTF yuklemesi yok
        if cagri and cagri_i is None and i >= boy // 2:                   # alt program cagrisi
            cagri_i = len(k)
            k.append(kodla("MCCNDD 16BitDest {, CNDF}", dest=0, cndf=rnd.choice([10, 11, 14, 15, 0, 1])))
            for _ in range(3): k.append(rastgele_buyruk(mar_kipi=not mar_kirli, mstf_yukle=False))
            k += [MNOP, MNOP, MNOP]                                         # donus noktasi
            son_dal = i; i += 7; continue
        if i - son_dal > 8 and rnd.random() < 0.08 and i < boy - 10:       # ileri dal: 3 yuva + atla
            atla = rnd.randint(1, 3)
            k.append(kodla("MBCNDD 16BitDest {, CNDF}", dest=2 * (4 + atla), cndf=rnd.choice(CNDF)))
            for _ in range(3 + atla):
                k.append(rastgele_buyruk(mar_kipi=not mar_kirli, mstf_yukle=not cagriya_yakin))
            son_dal = i; i += 4 + atla; continue
        if rnd.random() < 0.12 and i < boy - 8:                            # dur_r1 kalibi
            b = rnd.randrange(3)
            k.append(rastgele_buyruk(mstf_yukle=not cagriya_yakin, tur="yaz", blok=b))
            ara = rnd.randint(0, 3)
            for _ in range(ara): k.append(rastgele_buyruk(mar_kipi=not mar_kirli, mstf_yukle=not cagriya_yakin))
            k.append(rastgele_buyruk(mstf_yukle=not cagriya_yakin, tur="oku", blok=b))
            i += ara + 2; continue
        if i >= sonraki_mar and not mar_kirli:
            k += mar_baslat(); sonraki_mar = i + 12; i += 1; continue
        if i > boy - 6 and rnd.random() < 0.5:                              # sona dogru MAR'a serbest yukleme
            w = rastgele_buyruk(mar_serbest=True, mar_kipi=not mar_kirli, mstf_yukle=not cagriya_yakin)
            if decode(w).syntax in MAR_YUKLE_SERBEST: mar_kirli = True
        else:
            w = rastgele_buyruk(mar_kipi=not mar_kirli, mstf_yukle=not cagriya_yakin)
        k.append(w); i += 1
    t = rnd.random()
    if t < 0.35:
        k += [MNOP, MNOP, MNOP]
    elif t < 0.75:                                                          # FP sonucu MSTOP'tan hemen once okunur:
        x, y = rnd.randrange(4), rnd.randrange(4)                           # gorev gecisinde dur_exe (n+1 / n+2)
        k.append(kodla(rnd.choice(["MADDF32 MRa, MRb, MRc", "MMPYF32 MRa, MRb, MRc", "MSUBF32 MRa, MRb, MRc"]),
                       a=x, b=y, c=rnd.randrange(4)))
        k += [MNOP] * rnd.randint(0, 1)
        k.append(kodla("MMOV32 mem32, MRa", addr=0, m=rnd.randint(*rnd.choice(YAZ)), a=x) if rnd.random() < 0.5
                 else kodla("MADDF32 MRa, MRb, MRc", a=rnd.randrange(4), b=x, c=x))
        k += [MNOP] * rnd.randint(0, 1)
    k += [MSTOP, MNOP, MNOP, MNOP]
    return k, cagri_i


def alt_program():
    k = [rastgele_buyruk(mstf_yukle=False) for _ in range(rnd.randint(2, 5))]
    k += [MNOP, MNOP, MNOP, kodla("MRCNDD {CNDF}", cndf=14)]
    k += [rastgele_buyruk() for _ in range(3)] + [MNOP, MNOP, MNOP]
    return k


def program_uret():
    """(kelimeler, mvect listesi, gecersiz indeks): 1-3 gorev, gorev 1'de belki bir alt program cagrisi"""
    global d32_yuvalari
    for _ in range(50):
        d32_yuvalari = list(range(0x8A00, 0x8B00, 4))
        gorev_sayisi = rnd.choice([1, 1, 1, 2, 2, 3])
        cagri = rnd.random() < 0.6
        g1, cagri_i = govde(rnd.randint(30, 70), cagri)
        ap = alt_program() if cagri else []
        if cagri_i is not None:                                            # gercek alt program adresiyle kodla
            g1[cagri_i] = kodla("MCCNDD 16BitDest {, CNDF}", dest=(2 * len(g1) - 2 * cagri_i) & 0xFFFF,
                                cndf=decode(g1[cagri_i]).fields["cndf"])
        kel, mvect = g1 + ap, [0]
        for _ in range(gorev_sayisi - 1):
            mvect.append(2 * len(kel)); kel = kel + govde(rnd.randint(15, 40), False)[0]
        if lint_hatalari(kel):
            continue
        gec = None
        if rnd.random() < 0.15:                                            # gecersiz buyruk (lint MNOP ile yapildi)
            gec = rnd.randrange(9, len(kel)); kel = list(kel); kel[gec] = gecersiz_kelime()
        return kel, mvect, gec
    raise RuntimeError("lint'ten gecen program uretilemedi")


def bellek_uret():
    l1 = [rnd.getrandbits(16) for _ in range(1024)]
    l2 = [rnd.getrandbits(16) for _ in range(1024)]
    m2c = [rnd.getrandbits(16) for _ in range(128)]
    c2m = [rnd.getrandbits(16) for _ in range(128)]
    for d in (l1, l2, m2c, c2m):
        for a in range(0, len(d), 2):
            if rnd.random() < 0.25:
                v = rnd.choice(OZEL); d[a] = v & 0xFFFF; d[a + 1] = v >> 16
    return l1, l2, m2c, c2m


os.makedirs("rastgele", exist_ok=True)
hatali, toplam_satir = 0, 0
atlanan = collections.Counter()
kapsam = collections.Counter()
for p in range(N):
    kel, mvect, gec = program_uret()
    l1, l2, m2c, c2m = bellek_uret()
    on = "rastgele/t%d_p%03d" % (TOHUM, p)
    try:
        tamam, rapor, sayac, satir = kostur(on, kel, mvect, l1, l2, m2c, c2m)
    except Exception as h:
        atlanan[type(h).__name__ + ": " + str(h)[:60]] += 1                 # haritada olmayan erisim vb.
        if os.environ.get("AYIKLA"):
            import traceback; traceback.print_exc()
            for j, w in enumerate(kel):
                try: print("  %03x  %08x  %s" % (2 * j, w, disassemble(w)))
                except Exception: print("  %03x  %08x  GECERSIZ" % (2 * j, w))
        continue
    toplam_satir += satir
    kapsam.update(sayac)
    kapsam["program"] += 1; kapsam["gorev_" + str(len(mvect))] += 1; kapsam["gecersiz_buyruklu"] += gec is not None
    if not tamam:
        hatali += 1
        print("%s FARK (gorev %d, gecersiz %s):" % (on, len(mvect), gec))
        for r in rapor: print("    " + r)
    elif not os.environ.get("SAKLA"):
        temizle(on)
print("tohum %d  program: %d  hatali: %d  atlanan: %d  karsilastirilan iz satiri: %d"
      % (TOHUM, kapsam["program"], hatali, sum(atlanan.values()), toplam_satir))
print("kapsam (cevrim/olay):", dict(kapsam))
if atlanan: print("atlananlar:", dict(atlanan))
