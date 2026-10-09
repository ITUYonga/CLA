"""Execute + Write tek buyruk anlam testi: golden modelin BORU HATTI siniflariyla
(BoruState, BoruBellek, K2 ertelemesi, mar_before) beklenen degerleri uretir.
Kullanim: anlam_testi.py uret N | anlam_testi.py karsilastir"""
import sys, os, random, collections
GK = os.environ.get("CLA_GOLDEN", os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "golden_model"))
sys.path.insert(0, GK)
from golden_model.isa_table import load_table
from golden_model.decoder import decode
from golden_model import erisim as E
from golden_model.cla_state import ClaState
from golden_model.cla_memory import ClaMemory
from golden_model.pipeline import BoruState, BoruBellek, BoruKaydi
from golden_model import dagitici as D

rnd = random.Random(20261009)
DALLAR = {"MBCNDD 16BitDest {, CNDF}", "MCCNDD 16BitDest {, CNDF}", "MRCNDD {CNDF}"}
OZEL = [0x00000000, 0x80000000, 0x7F800000, 0xFF800000, 0x7FC00000, 0xFFC00001, 0x00000001, 0x807FFFFF,
        0x3F800000, 0xBF800000, 0x7F7FFFFF, 0xFF7FFFFF, 0x00800000, 0x80800000, 0x40490FDB, 0x0000FFFF,
        0xFFFF8000, 0x00007FFF, 0x4F000000, 0xCF000000, 0x47000000, 0x5F800000, 0x00400000, 0x7F000000]


def rmr():
    return rnd.choice(OZEL) if rnd.random() < 0.3 else rnd.getrandbits(32)


def adres_sec():
    t = rnd.random()
    if t < 0.35: return rnd.randint(0x8800, 0x8BFF)      # L1
    if t < 0.55: return rnd.randint(0x8C00, 0x8FFF)      # L2
    if t < 0.70: return rnd.randint(0x1480, 0x14FF)      # C2M
    if t < 0.82: return rnd.randint(0x1500, 0x157F)      # M2C (CLA yazamaz)
    return rnd.getrandbits(16)                           # cogu haritada yok


def kelime_uret(e):
    while True:
        w = (rnd.getrandbits(32) & ~e["mask"]) | e["match"]
        c = decode(w)
        f = c.fields
        if 'cndf' in f and 6 <= f['cndf'] <= 9: continue
        if 'CNDF' in f and 6 <= f['CNDF'] <= 9: continue
        if 'addr' in f and f['addr'] not in (0, 1, 2): continue
        if E.adres_uretir(c.syntax) and f['addr'] == 0:   # dogrudan kipte m = adres
            w = (w & 0xFFFF0000) | adres_sec()
            c = decode(w)
        return w, c


def golden(c, mr, mstf, mar_before, okunan):
    st = ClaState()
    st.mr = list(mr); st.mstf = mstf; st.mar = list(mar_before)
    kayit = BoruKaydi()
    kayit.gecerli = 1; kayit.cozum = c; kayit.okunan = okunan; kayit.mar_before = list(mar_before)
    D.dagit(c, BoruState(st, kayit), BoruBellek(kayit))           # E
    for i, v in kayit.k2_hedef_mr.items():                          # W sonu: K2
        st.set_mr(i, v)
    if kayit.latch_overflow: st.latch_overflow()
    if kayit.latch_underflow: st.latch_underflow()
    s = c.syntax
    yazma = None
    if E.yazar16(s): yazma = (kayit.yaz_ea, kayit.yaz_veri & 0xFFFF, 16)
    elif E.yazar32(s): yazma = (kayit.yaz_ea, kayit.yaz_veri & 0xFFFFFFFF, 32)
    return st, yazma


BLOK = [(0x8800, 0x8BFF, 0, True), (0x8C00, 0x8FFF, 1, True), (0x1480, 0x14FF, 2, True), (0x1500, 0x157F, 3, False)]


def yazma_bekle(yazma):
    if yazma is None: return (0, None, None, None)
    adr, deger, gen = yazma
    if gen == 32 and adr % 2: adr -= 1                    # golden write32: alttaki cifte hizalar
    for bas, son, kod, yazilir in BLOK:
        if bas <= adr <= son:
            if not yazilir: return (0, None, None, None)  # M2C: yazma yutulur
            return (3 if gen == 32 else 1, kod, adr - bas, deger)
    return (0, None, None, None)                          # haritada yok


def uret(n_her):
    tablo = load_table()
    vek, bek = [], []
    sayac = collections.Counter()
    for e in tablo:
        if e["syntax"] in DALLAR: continue
        k = 0
        while k < n_her:
            w, c = kelime_uret(e)
            mr = [rmr() for _ in range(4)]
            mstf = rnd.getrandbits(32) & 0x00FFFA4F
            mar_before = [adres_sec(), adres_sec()]
            if E.okur32(c.syntax): ok = rmr()
            elif E.okur16(c.syntax): ok = rnd.getrandbits(16)
            else: ok = rnd.getrandbits(32)                 # okumayan buyruk bunu kullanmamali
            f = c.fields
            kip = f.get('addr', 0)
            ea = (f['m'] if kip == 0 else mar_before[kip - 1]) if E.adres_uretir(c.syntax) else rnd.getrandbits(16)
            if "MARx" in c.syntax: mar_d2 = mar_before[D._mar_indeksi(c.entry)]
            else: mar_d2 = rnd.getrandbits(16)
            try:
                st, yazma = golden(c, mr, mstf, mar_before, ok)
            except ValueError:
                continue                                   # TI kisiti (paralelde MRa == MRd vb.)
            mar_bek = (1, D._mar_indeksi(c.entry), st.mar[D._mar_indeksi(c.entry)]) if E.mar_yukler(c.syntax) else (0, None, None)
            vek.append("%08x %08x %08x %08x %08x %08x %04x %04x %08x" % (w, *mr, mstf, mar_d2, ea, ok))
            bek.append((c.syntax, [x & 0xFFFFFFFF for x in st.mr], st.mstf & 0xFFFFFFFF, mar_bek, yazma_bekle(yazma)))
            sayac[c.syntax] += 1
            k += 1
    open("vektorler.txt", "w").write("\n".join(vek) + "\n")
    import pickle
    pickle.dump(bek, open("beklenen.pkl", "wb"))
    print(len(vek), "vektor,", len(sayac), "sozdizim")


def karsilastir():
    import pickle
    bek = pickle.load(open("beklenen.pkl", "rb"))
    rtl = [l.split() for l in open("rtl_sonuc.txt")]
    assert len(rtl) == len(bek), (len(rtl), len(bek))
    hata = collections.Counter(); ornek = {}
    for (s, mr, mstf, mar_bek, wr), r in zip(bek, rtl):
        rmr_ = [int(x, 16) for x in r[0:4]]; rmstf = int(r[4], 16)
        r_mar = (int(r[5]), int(r[6]), int(r[7], 16)); r_wr = (int(r[8]), int(r[9]), int(r[10], 16), int(r[11], 16))
        dur = int(r[12])
        def h(tur, ayr):
            hata[(s, tur)] += 1; ornek.setdefault((s, tur), ayr)
        for i in range(4):
            if rmr_[i] != mr[i]: h("MR%d" % i, "golden %08x rtl %08x" % (mr[i], rmr_[i]))
        if rmstf != mstf: h("MSTF", "golden %08x rtl %08x" % (mstf, rmstf))
        if mar_bek[0] != r_mar[0]: h("mar_en", "golden %d rtl %d" % (mar_bek[0], r_mar[0]))
        elif mar_bek[0] and (mar_bek[1], mar_bek[2]) != (r_mar[1], r_mar[2]):
            h("MAR", "golden MAR%d=%04x rtl MAR%d=%04x" % (mar_bek[1], mar_bek[2], r_mar[1], r_mar[2]))
        if wr[0] != r_wr[0]: h("wr_en", "golden %s rtl %s" % (wr, r_wr))
        elif wr[0]:
            maske = 0xFFFFFFFF if wr[0] == 3 else 0xFFFF
            if (wr[1], wr[2], wr[3] & maske) != (r_wr[1], r_wr[2], r_wr[3] & maske):
                h("RAM", "golden blok %d adr %03x veri %08x rtl blok %d adr %03x veri %08x" % (wr[1], wr[2], wr[3], r_wr[1], r_wr[2], r_wr[3]))
        if dur: h("dur_exe", "tek buyrukta dur_exe olmamali")
    print("vektor:", len(bek), " uyusmazlik:", sum(hata.values()))
    for (s, tur), say in sorted(hata.items()):
        print("  %-52s %-8s %5d  ornek: %s" % (s, tur, say, ornek[(s, tur)]))


if __name__ == "__main__":
    if sys.argv[1] == "uret": uret(int(sys.argv[2]))
    else: karsilastir()
