# -*- coding: utf-8 -*-
"""test_karsilastirici.py - RTL test kaydini (.hex) golden modelle cevrim cevrim karsilastirir.

    python3 test_karsilastirici.py prog_kayit.hex          # karsilastir; golden kaydi prog_kayit_golden.hex
    python3 test_karsilastirici.py hazirla prog.casm       # tezgah girisi uret: prog_giris.hex

AKIS
    1) hazirla : CASM programi -> prog_giris.hex (program, baslangic bellegi, gorev yazmaclari)
    2) RTL     : tb_cla_kayit.sv  +GIRIS=prog_giris.hex +KAYIT=prog_kayit.hex
    3) bu dosya: kaydin icindeki girisle golden modeli (core.py) kosturur, AYNI BICIMDE bir kayit
                 uretir ve ikisini karsilastirir. Yalniz kayit dosyasi yeterli.

KAYIT DOSYASI (v1) - butun sayilar onaltilik, satir basina bir kayit, "//" ile baslayan satir yorum
    BASLANGIC mvect1 .. mvect8 mier mifrc
    BAS_<B> ofset k0 .. k7      gorevden once bellek <B>: L3 L1 L2 M2C C2M (8 x 16 bit; tamami 0 satir yazilmaz)
    IZ cevrim sinyal exe_pc exe_op mpc mr0 mr1 mr2 mr3 mar0 mar1 mstf yaz yaz_adr yaz_veri
    SON_<B> ofset k0 .. k7      gorevler bittikten sonra bellek: L1 L2 C2M
    SON_YAZMAC mr0 mr1 mr2 mr3 mar0 mar1 mstf mpc mirun mifr miovf
    PIE k1 k2 ..                gorev sonu kesmeleri (MIRUN degeri), sirayla

    IZ satiri her saat cevriminin SONUNDAKI durumdur. Satir 1 = ilk getirme (F1). Son satir:
    MSTOP'tan sonra durmasiz bir cevrimde R1-R2-E bos ve bekleyen gorev yoksa (en az MSTOP + 3);
    gecersiz buyrukta donma cevrimi.
      exe_pc/exe_op : o cevrim E'deki buyruk (dur_exe cevriminde E'de bekleyen buyruk), yoksa 0
      sinyal bitleri: SINYALLER listesi (0 = en dusuk bit)
      yaz           : W'deki bellek yazmasi: 0 yok, 1 16 bit, 2 32 bit; yaz_adr CLA veri adresi
"""
import os
import re
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import core  # noqa: E402

SURUM = "CLA KAYIT v1"
BLOKLAR = ["L3", "L1", "L2", "M2C", "C2M"]
SON_BLOKLAR = ["L1", "L2", "C2M"]
BOYUT = {"L3": 4096, "L1": 1024, "L2": 1024, "M2C": 128, "C2M": 128}
BOLGE = {"C2M": 0, "M2C": 1, "L1": 2, "L2": 3, "L3": 4}                 # core.ClaMemory.regions sirasi
IZ_ALANLARI = [("cevrim", 5), ("sinyal", 2), ("exe_pc", 3), ("exe_op", 8), ("mpc", 3),
               ("mr0", 8), ("mr1", 8), ("mr2", 8), ("mr3", 8), ("mar0", 4), ("mar1", 4), ("mstf", 8),
               ("yaz", 1), ("yaz_adr", 4), ("yaz_veri", 8)]
SINYALLER = ["E_gecerli", "dur_exe", "dur_r1", "dal_alindi", "K2_yazma", "MSTOP", "gorev_basla", "donma"]
SON_YAZMAC = [("mr0", 8), ("mr1", 8), ("mr2", 8), ("mr3", 8), ("mar0", 4), ("mar1", 4), ("mstf", 8),
              ("mpc", 3), ("mirun", 2), ("mifr", 2), ("miovf", 2)]
BASLIK = """// %s - butun sayilar onaltilik (hex)
// BASLANGIC mvect1 mvect2 mvect3 mvect4 mvect5 mvect6 mvect7 mvect8 mier mifrc
// BAS_<blok> / SON_<blok> : <16 bitlik kelime ofseti> <8 kelime> (tamami 0 olan satir yazilmaz)
// IZ %s
//   sinyal bitleri (0 = en dusuk): %s
//   yaz: 0 yazma yok, 1 16 bit, 2 32 bit
// SON_YAZMAC %s
""" % (SURUM, " ".join(a for a, _ in IZ_ALANLARI),
       ", ".join("%d %s" % (i, s) for i, s in enumerate(SINYALLER)), " ".join(a for a, _ in SON_YAZMAC))


class Kayit(object):
    def __init__(self):
        self.baslangic = [0] * 10
        self.bas = {b: [0] * BOYUT[b] for b in BLOKLAR}
        self.iz = []                                    # her satir IZ_ALANLARI sirasinda sayi listesi
        self.son = {b: [0] * BOYUT[b] for b in SON_BLOKLAR}
        self.son_yazmac = None
        self.pie = []


# ---------------------------------------------------------------------
#  okuma / yazma
# ---------------------------------------------------------------------
def oku(yol):
    k = Kayit()
    for no, satir in enumerate(open(yol, encoding="ascii", errors="replace"), 1):
        p = satir.split("//")[0].split()
        if not p:
            continue
        try:
            d = [int(x, 16) for x in p[1:]]
        except ValueError:
            raise SystemExit("%s:%d: onaltilik olmayan deger: %s" % (yol, no, satir.strip()))
        ad = p[0]
        if ad == "BASLANGIC" and len(d) == 10:
            k.baslangic = d
        elif ad.startswith(("BAS_", "SON_")) and ad[4:] in BOYUT and len(d) == 9:
            hedef = (k.bas if ad.startswith("BAS_") else k.son)[ad[4:]]
            hedef[d[0]:d[0] + 8] = d[1:]
        elif ad == "IZ" and len(d) == len(IZ_ALANLARI):
            k.iz.append(d)
        elif ad == "SON_YAZMAC" and len(d) == len(SON_YAZMAC):
            k.son_yazmac = d
        elif ad == "PIE":
            k.pie = d
        else:
            raise SystemExit("%s:%d: tanimsiz satir: %s" % (yol, no, satir.strip()))
    return k


def _bellek_satirlari(on, ad, kelimeler):
    for i in range(0, len(kelimeler), 8):
        parca = kelimeler[i:i + 8]
        if any(parca):
            yield "%s%s %04x %s" % (on, ad, i, " ".join("%04x" % w for w in parca))


def yaz(k, yol):
    with open(yol, "w", encoding="ascii", newline="\n") as f:
        f.write(BASLIK)
        f.write("BASLANGIC %s %s\n" % (" ".join("%03x" % v for v in k.baslangic[:8]),
                                       " ".join("%02x" % v for v in k.baslangic[8:])))
        for b in BLOKLAR:
            for s in _bellek_satirlari("BAS_", b, k.bas[b]):
                f.write(s + "\n")
        for r in k.iz:
            f.write("IZ " + " ".join("%0*x" % (g, v) for (_, g), v in zip(IZ_ALANLARI, r)) + "\n")
        if k.son_yazmac is not None:
            for b in SON_BLOKLAR:
                for s in _bellek_satirlari("SON_", b, k.son[b]):
                    f.write(s + "\n")
            f.write("SON_YAZMAC " + " ".join("%0*x" % (g, v) for (_, g), v in zip(SON_YAZMAC, k.son_yazmac)) + "\n")
            f.write("PIE" + "".join(" %02x" % v for v in k.pie) + "\n")


# ---------------------------------------------------------------------
#  golden kosusu: kaydin girisinden ayni bicimde kayit
# ---------------------------------------------------------------------
def golden_kos(giris, max_cevrim=10000, max_gorev=64):
    k = Kayit()
    k.baslangic = list(giris.baslangic)
    k.bas = {b: list(giris.bas[b]) for b in BLOKLAR}
    st, mem = core.ClaState(), core.ClaMemory()
    for b in BLOKLAR:
        mem.regions[BOLGE[b]].words[:] = k.bas[b]
    regs = core.ClaRegs()
    for i in range(8):
        regs.cpu_write(i, k.baslangic[i])
    regs.cpu_write(0x25, k.baslangic[8])                        # MIER
    regs.cpu_write(0x22, k.baslangic[9])                        # MIFRC: gorevleri tetikle
    hakem = core.TaskArbiter(regs)
    boru = core.Pipeline(st, mem)
    cekirdek = core.ClaCore(st, mem, boru, arbiter=hakem)
    mem.write_log.clear()
    yazma = [0]

    def adim():
        """Bir saat cevrimi: golden'i ilerletir, cevrim sonu satirini ekler."""
        dur_exe, dur_r1, durdu, dondu, w = boru.dur_exe, boru.dur_r1, boru.durdu, boru.donduruldu, boru.pipeline_kaydi[6]
        devam = cekirdek.step()
        d2_calisti = not (dur_exe or dur_r1 or dondu)
        e = boru.pipeline_kaydi[5] if boru.exe_bekledi else boru.pipeline_kaydi[6]
        gecerli = e.gecerli == 1 and e.pc is not None
        bitler = [gecerli, dur_exe, dur_r1,
                  d2_calisti and bool(boru.pipeline_kaydi[3].dal_alindi),
                  not dondu and w.gecerli == 1 and bool(w.k2_hedef_mr),
                  not durdu and boru.durdu, False, not dondu and boru.donduruldu]
        yeni = mem.write_log[yazma[0]:]
        yazma[0] = len(mem.write_log)
        if len(yeni) > 1:
            raise RuntimeError("cevrim %d'de %d bellek yazmasi" % (len(k.iz) + 1, len(yeni)))
        adr, veri, gen = yeni[0] if yeni else (0, 0, 0)
        k.iz.append([len(k.iz) + 1, sum(1 << i for i, b in enumerate(bitler) if b),
                     e.pc if gecerli else 0, e.ham if gecerli else 0, st.mpc,
                     st.get_mr(0), st.get_mr(1), st.get_mr(2), st.get_mr(3), st.get_mar(0), st.get_mar(1),
                     st.mstf, {16: 1, 32: 2}.get(gen, 0), adr, veri])
        return devam

    mstop_satiri = None
    for _ in range(max_gorev):
        if not hakem.gorev_basla(st):
            break
        if k.iz:
            k.iz[-1][1] |= 1 << SINYALLER.index("gorev_basla")   # onceki gorevin son cevrimi
        yazma[0] = len(mem.write_log)
        boru.durdu = False
        mstop_satiri = None
        for _ in range(max_cevrim):
            devam = adim()
            if mstop_satiri is None and boru.durdu:
                mstop_satiri = len(k.iz)
            if not devam:
                break
        else:
            raise RuntimeError("gorev %d cevrimde bitmedi" % max_cevrim)
    if mstop_satiri is not None and not boru.donduruldu:    # son gorev: iz en az MSTOP + 3'te biter
        while len(k.iz) < mstop_satiri + 3:
            adim()
    k.son = {b: list(mem.regions[BOLGE[b]].words) for b in SON_BLOKLAR}
    k.son_yazmac = [st.get_mr(0), st.get_mr(1), st.get_mr(2), st.get_mr(3), st.get_mar(0), st.get_mar(1),
                    st.mstf, st.mpc, regs.mirun, regs.mifr, regs.miovf]
    k.pie = list(hakem.pie_kesmeleri)
    return k


# ---------------------------------------------------------------------
#  karsilastirma
# ---------------------------------------------------------------------
def _sinyal_adlari(v):
    return ",".join(s for i, s in enumerate(SINYALLER) if v >> i & 1) or "-"


def _iz_metni(r):
    return " ".join("%0*x" % (g, v) for (_, g), v in zip(IZ_ALANLARI, r))


def karsilastir(rtl, gld, cikti=print):
    hatalar = 0
    farkli = [i for i in range(min(len(rtl.iz), len(gld.iz))) if rtl.iz[i] != gld.iz[i]]
    if len(rtl.iz) != len(gld.iz):
        hatalar += 1
        cikti("IZ uzunlugu FARKLI: rtl %d satir, golden %d satir" % (len(rtl.iz), len(gld.iz)))
    if farkli:
        hatalar += len(farkli)
        i = farkli[0]
        cikti("IZ FARKLI: %d satir; ilk ayrisma satir %d (cevrim 0x%x)" % (len(farkli), i + 1, gld.iz[i][0]))
        for (ad, g), a, b in zip(IZ_ALANLARI, gld.iz[i], rtl.iz[i]):
            if a != b:
                ek = "   (%s / %s)" % (_sinyal_adlari(a), _sinyal_adlari(b)) if ad == "sinyal" else ""
                cikti("    %-8s golden %0*x  rtl %0*x%s" % (ad, g, a, g, b, ek))
        cikti("    " + " ".join(a for a, _ in IZ_ALANLARI))
        for j in range(max(0, i - 3), i):
            cikti("    " + _iz_metni(gld.iz[j]))
        cikti("  G " + _iz_metni(gld.iz[i]))
        cikti("  R " + _iz_metni(rtl.iz[i]))
        if len(farkli) > 1:
            cikti("    diger farkli satirlar: %s" % " ".join(str(j + 1) for j in farkli[1:11]) +
                  (" ..." if len(farkli) > 11 else ""))
    elif len(rtl.iz) == len(gld.iz):
        cikti("IZ AYNI: %d satir" % len(rtl.iz))
    if rtl.son_yazmac is None:
        hatalar += 1
        cikti("SON durum RTL kaydinda yok (tezgah yarida kalmis olabilir)")
        return hatalar
    for b in SON_BLOKLAR:
        fark = [i for i in range(BOYUT[b]) if rtl.son[b][i] != gld.son[b][i]]
        if fark:
            hatalar += len(fark)
            cikti("SON %s FARKLI: %d kelime; ilk ofset %03x golden %04x rtl %04x"
                  % (b, len(fark), fark[0], gld.son[b][fark[0]], rtl.son[b][fark[0]]))
    for (ad, g), a, b in zip(SON_YAZMAC, gld.son_yazmac, rtl.son_yazmac):
        if a != b:
            hatalar += 1
            cikti("SON %s FARKLI: golden %0*x rtl %0*x" % (ad, g, a, g, b))
    if rtl.pie != gld.pie:
        hatalar += 1
        cikti("PIE FARKLI: golden %s rtl %s" % (gld.pie, rtl.pie))
    if hatalar == len(farkli) and len(rtl.iz) == len(gld.iz):
        cikti("SON bellek (L1 L2 C2M), yazmaclar ve PIE AYNI")
    return hatalar


# ---------------------------------------------------------------------
#  hazirla: CASM -> tezgah girisi
# ---------------------------------------------------------------------
def hazirla(casm, cikti=None, zorla=False):
    """;#sembol _A 0x8800 | ;#veri 0x8800 0x3FC00000 | ;#veri16 0x1500 0x1234 | ;#gorev 2 ETIKET"""
    metin = open(casm, encoding="utf-8").read()
    sembol = {m.group(1): int(m.group(2), 0) for m in re.finditer(r";#sembol\s+(\S+)\s+(\S+)", metin)}
    veri = [(int(m.group(2), 0), int(m.group(3), 0), m.group(1)) for m in re.finditer(r";#veri(16)?\s+(\S+)\s+(\S+)", metin)]
    gorev = [(int(m.group(1)), m.group(2)) for m in re.finditer(r";#gorev\s+(\d)\s+(\S+)", metin)] or [(1, None)]
    kelimeler = core.assemble(metin, semboller=sembol)
    hatalar = 0
    for b in core.denetle(metin, sembol, kelimeler):
        print("  lint: %s" % b)
        hatalar += b.agirlik == core.HATA
    if hatalar and not zorla:
        raise SystemExit("RED: %d boru hatti kurali ihlali (TRM: bayat deger). Bilerek deniyorsaniz --zorla." % hatalar)
    etiket, mpc = {}, 0                                         # etiket adresleri (assembler'in satir cozumleyicisi)
    for no, satir in enumerate(core._devam_satirlarini_birlestir(metin.splitlines()), 1):
        et, mn, jet = core.satir_coz(satir)
        if et:
            etiket[et] = mpc
        if mn:
            mpc += 2 * len(core._sahte_ac(mn, jet, no)) if mn in core.SAHTE_KOMUTLAR else 2
    mem = core.ClaMemory()
    mem.load_program(kelimeler)
    for adr, deger, on16 in veri:
        kim = "cpu" if 0x1500 <= adr <= 0x157F else "cla"
        (mem.write16 if on16 else mem.write32)(adr, deger, who=kim)
    k = Kayit()
    maske = 0
    for no, et in gorev:
        k.baslangic[no - 1] = 0 if et is None else etiket[et]
        maske |= 1 << (no - 1)
    k.baslangic[8] = k.baslangic[9] = maske
    k.bas = {b: list(mem.regions[BOLGE[b]].words) for b in BLOKLAR}
    cikti = cikti or os.path.splitext(casm)[0] + "_giris.hex"
    yaz(k, cikti)
    print("%s: %d buyruk, %d gorev -> %s" % (casm, len(kelimeler), len(gorev), cikti))
    return cikti


def main(argv):
    if len(argv) >= 2 and argv[0] == "hazirla":
        cikti = argv[argv.index("-o") + 1] if "-o" in argv else None
        hazirla(argv[1], cikti, zorla="--zorla" in argv)
        return 0
    if len(argv) != 1 or not argv[0].endswith(".hex"):
        print(__doc__)
        return 2
    rtl = oku(argv[0])
    if not rtl.iz:
        print("%s: IZ satiri yok" % argv[0])
        return 2
    gld = golden_kos(rtl)
    golden_yolu = os.path.splitext(argv[0])[0] + "_golden.hex"
    yaz(gld, golden_yolu)
    print("RTL kaydi   : %s (%d satir)" % (argv[0], len(rtl.iz)))
    print("golden kaydi: %s (%d satir)" % (golden_yolu, len(gld.iz)))
    hatalar = karsilastir(rtl, gld)
    print("SONUC: %s" % ("GECTI" if hatalar == 0 else "KALDI (%d fark)" % hatalar))
    return 0 if hatalar == 0 else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
