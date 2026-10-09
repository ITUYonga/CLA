"""Art arda buyruk testi: rastgele programlar golden BORU HATTINDA kosulur, iz satirlari
(E'deki pc, MR0-3, MAR0-1, MSTF, bellek yazmasi) RTL tezgahinin iziyle cevrim cevrim karsilastirilir.
Kisitlar: dallanma yok, MAR'li adresleme yok; okumalar M2C'den (CLA yazamaz), yazmalar L1'e.
Kullanim: bh_testi.py uret N_PROGRAM BOY | bh_testi.py karsilastir"""
import sys, os, io, random, pickle, collections
GK = os.environ.get("CLA_GOLDEN", os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "golden_model"))
sys.path.insert(0, GK)
from golden_model.isa_table import load_table
from golden_model.decoder import decode
from golden_model import erisim as E
from golden_model.cla_state import ClaState
from golden_model.cla_memory import ClaMemory
from golden_model.cla_core import ClaCore
from golden_model.pipeline import Pipeline, BoruState, BoruBellek, BoruKaydi
from golden_model.cla_regs import ClaRegs
from golden_model.task_arbiter import TaskArbiter
from golden_model import trace as TR
from golden_model import dagitici as D

rnd = random.Random(7)
TABLO = load_table()
HARIC = {"MBCNDD 16BitDest {, CNDF}", "MCCNDD 16BitDest {, CNDF}", "MRCNDD {CNDF}", "MSTOP", "MDEBUGSTOP"}
GOVDE = [e for e in TABLO if e["syntax"] not in HARIC]
OZEL = [0x00000000, 0x80000000, 0x7F800000, 0xFF800000, 0x7FC00000, 0x00000001, 0x807FFFFF, 0x3F800000,
        0xBF800000, 0x7F7FFFFF, 0x00800000, 0x40490FDB, 0x0000FFFF, 0xFFFF8000, 0x4F000000, 0x5F800000]
MSTOP = 0x7F800000


def giris(syntax, mar=None):
    adaylar = [e for e in TABLO if e["syntax"] == syntax]
    if mar is not None:
        adaylar = [e for e in adaylar if D._mar_indeksi(e) == mar]
    return adaylar[0]


def yerlestir(w, e, ad, deger):
    konum = e["fields"][ad]
    L = len(konum)
    for i, b in enumerate(konum):
        bit = (deger >> (L - 1 - i)) & 1
        w = (w & ~(1 << b)) | (bit << b)
    return w


def kodla(syntax, **alanlar):
    e = giris(syntax)
    w = e["match"]
    for ad, deger in alanlar.items():
        w = yerlestir(w, e, ad, deger)
    assert decode(w).syntax == syntax
    return w


def rastgele_buyruk():
    while True:
        e = rnd.choice(GOVDE)
        w = (rnd.getrandbits(32) & ~e["mask"]) | e["match"]
        f = e["fields"]
        for ad in ("cndf", "CNDF"):
            if ad in f:
                w = yerlestir(w, e, ad, rnd.choice([0, 1, 2, 3, 4, 5, 10, 11, 12, 13, 14, 15]))
        if "addr" in f:
            w = yerlestir(w, e, "addr", 0)
            s = e["syntax"]
            if E.okur16(s) or E.okur32(s):
                adr = rnd.randint(0x1500, 0x157C if s == "MMOVD32 MRa, mem32" else 0x157F)   # M2C: yalniz okunur
            else:
                adr = rnd.randint(0x8800, 0x8BFF)      # L1
            w = yerlestir(w, e, "m", adr)
        c = decode(w)
        try:                                            # TI kisitlari (paralelde MRa == MRd vb.)
            st = ClaState(); k = BoruKaydi(); k.gecerli = 1; k.cozum = c; k.okunan = 0; k.mar_before = [0, 0]
            D.dagit(c, BoruState(st, k), BoruBellek(k))
        except ValueError:
            continue
        return w, c


def program_uret(boy):
    kelimeler = []
    for x in range(4):
        v = rnd.choice(OZEL) if rnd.random() < 0.5 else rnd.getrandbits(32)
        kelimeler.append(kodla("MMOVIZ MRa, #16FHi", a=x, I=v >> 16))
        kelimeler.append(kodla("MMOVXI MRa, #16FLoHex", a=x, I=v & 0xFFFF))
    kelimeler.append(kodla("MSETFLG FLAG, VALUE", F=rnd.getrandbits(8), V=rnd.getrandbits(8)))
    for _ in range(boy):
        kelimeler.append(rastgele_buyruk()[0])
    m2c = {a: rnd.getrandbits(16) for a in range(0x1500, 0x1580)}
    for a in range(0x1500, 0x1580, 2):                  # bazi ciftler ozel kayan nokta
        if rnd.random() < 0.3:
            v = rnd.choice(OZEL); m2c[a] = v & 0xFFFF; m2c[a + 1] = v >> 16
    return kelimeler, m2c


def yonlu_program(cift):
    """K2 taşması (LVF/LUF) W'deyken E'deki buyruk görünen MSTF'yi okur ya da yazar."""
    kelimeler = []
    buyuk, kucuk = 0x7F7FFFFF, 0x00800000                       # çarpımı taşar / alttan taşar
    degerler = [buyuk, kucuk, rnd.choice(OZEL), rnd.getrandbits(32)]
    for x in range(4):
        kelimeler.append(kodla("MMOVIZ MRa, #16FHi", a=x, I=degerler[x] >> 16))
        kelimeler.append(kodla("MMOVXI MRa, #16FLoHex", a=x, I=degerler[x] & 0xFFFF))
    for _ in range(cift):
        kelimeler.append(kodla("MSETFLG FLAG, VALUE", F=0x03, V=0x00))     # LVF = LUF = 0
        kaynak = rnd.choice([0, 1])                                       # MR0: taşma, MR1: alttan taşma
        hedef = rnd.choice([2, 3])
        X = rnd.choice(["MMPYF32 MRa, MRb, MRc", "MADDF32 MRa, MRb, MRc"])
        if X.startswith("MADD") and kaynak == 1:
            X = "MMPYF32 MRa, MRb, MRc"                                   # toplama alttan taşmaz
        kelimeler.append(kodla(X, a=hedef, b=kaynak, c=kaynak))
        b, c = rnd.sample([0, 1, 5 - hedef], 2)                           # hedefi okumayan yazmaçlar
        kosul = rnd.choice([0b1101, 0b1100])                              # LV, LU
        Y = rnd.choice(["MTESTTF", "MMOV32RR", "MNEGF32", "MSWAPF", "MSTF_SAKLA", "MSETFLG", "MSTF_YUKLE", "MMOV32_YUKLE"])
        if Y == "MTESTTF": w = kodla("MTESTTF CNDF", cndf=kosul)
        elif Y == "MMOV32RR": w = kodla("MMOV32 MRa, MRb {, CNDF}", a=b, b=c, cndf=kosul)
        elif Y == "MNEGF32": w = kodla("MNEGF32 MRa, MRb{, CNDF}", a=b, b=c, cndf=kosul)
        elif Y == "MSWAPF": w = kodla("MSWAPF MRa, MRb {, CNDF}", a=b, b=c, CNDF=kosul)
        elif Y == "MSTF_SAKLA": w = kodla("MMOV32 mem32, MSTF", addr=0, m=rnd.randint(0x8800, 0x8BFF))
        elif Y == "MSETFLG": w = kodla("MSETFLG FLAG, VALUE", F=rnd.getrandbits(8), V=rnd.getrandbits(8))
        elif Y == "MSTF_YUKLE": w = kodla("MMOV32 MSTF, mem32", addr=0, m=rnd.randint(0x1500, 0x157F))
        else: w = kodla("MMOV32 MRa, mem32 {, CNDF}", a=b, addr=0, cndf=kosul, m=rnd.randint(0x1500, 0x157F))
        kelimeler.append(w)
        for _ in range(rnd.randint(0, 2)):
            kelimeler.append(rastgele_buyruk()[0])
        for x in (0, 1):                                                  # kaynakları geri yükle
            kelimeler.append(kodla("MMOVIZ MRa, #16FHi", a=x, I=degerler[x] >> 16))
            kelimeler.append(kodla("MMOVXI MRa, #16FLoHex", a=x, I=degerler[x] & 0xFFFF))
    m2c = {a: rnd.getrandbits(16) for a in range(0x1500, 0x1580)}
    return kelimeler, m2c


def golden_iz(kelimeler, m2c):
    st, mem = ClaState(), ClaMemory()
    mem.load_program(kelimeler + [MSTOP])
    for a, v in m2c.items():
        mem.write16(a, v, who="cpu")
    regs = ClaRegs()
    regs.cpu_write(0, 0); regs.cpu_write(0x25, 1); regs.cpu_write(0x22, 1)
    core = ClaCore(st, mem, Pipeline(st, mem), arbiter=TaskArbiter(regs))
    akis = io.StringIO()
    TR.iz_al_gorevler(core, akis)
    return [l.split() for l in akis.getvalue().splitlines() if l and not l.startswith("#")]


def tezgah_satirlari(kelimeler, m2c):
    out = []
    for w in kelimeler:
        c = decode(w); s = c.syntax
        ea = c.fields["m"] if E.adres_uretir(s) else 0
        if E.okur32(s):
            a = ea & ~1; ok = (m2c[a + 1] << 16) | m2c[a]
        elif E.okur16(s):
            ok = m2c[ea]
        else:
            ok = 0
        marh = D._mar_indeksi(c.entry) if s == "MMOV16 mem16, MARx" else 0
        out.append("%08x %04x %08x %d" % (w, ea, ok, marh))
    return out


def uret(n, boy):
    satirlar, izler = [], []
    for p in range(n):
        kelimeler, m2c = program_uret(boy) if p % 2 == 0 else yonlu_program(15)
        izler.append(golden_iz(kelimeler, m2c))
        satirlar.append("PROGRAM %d" % len(kelimeler))
        satirlar += tezgah_satirlari(kelimeler, m2c)
    open("programlar.txt", "w").write("\n".join(satirlar) + "\n")
    pickle.dump(izler, open("golden_iz.pkl", "wb"))
    print(n, "program uretildi")


def karsilastir():
    izler = pickle.load(open("golden_iz.pkl", "rb"))
    rtl, cur = [], None
    for l in open("rtl_iz.txt"):
        if l.startswith("PROGRAM"):
            cur = []; rtl.append(cur)
        else:
            cur.append(l.split())
    assert len(rtl) == len(izler), (len(rtl), len(izler))
    toplam_satir = toplam_dur = hatali = 0
    ilk = []
    for p, (g, r) in enumerate(zip(izler, rtl)):
        bas = next(i for i, s in enumerate(g) if s[1] != "---")
        g = [[s[1]] + s[4:14] for s in g[bas:]]        # exe_pc mr0..3 mar0 mar1 mstf wr_addr wr_data wr_w
        n = min(len(g), len(r))
        fark = None
        for i in range(n):
            if g[i] != r[i]:
                fark = (i, g[i], r[i]); break
        # fazla satirlar bos olmali (E yok, yazma yok, durum degismez)
        if fark is None:
            for fazla, son in ((g[n:], g[n - 1]), (r[n:], r[n - 1])):
                for s in fazla:
                    if s[0] != "---" or s[8] != "----" or s[1:8] != son[1:8]:
                        fark = ("fazla", s, son); break
        toplam_satir += n
        toplam_dur += sum(1 for i in range(1, n) if g[i][0] == g[i - 1][0] and g[i][0] != "---")
        if fark:
            hatali += 1
            if len(ilk) < 5: ilk.append((p, fark))
    print("program: %d  karsilastirilan satir: %d  dur_exe cevrimi: %d  hatali program: %d"
          % (len(izler), toplam_satir, toplam_dur, hatali))
    for p, f in ilk:
        print("  program %d ilk fark: %s" % (p, f))


if __name__ == "__main__":
    if sys.argv[1] == "uret": uret(int(sys.argv[2]), int(sys.argv[3]))
    else: karsilastir()
