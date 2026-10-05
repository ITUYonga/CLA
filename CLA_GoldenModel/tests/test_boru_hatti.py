# -*- coding: utf-8 -*-
"""Boru hatti regresyonu: FPU K1/K2 (M2), interlock (M3), R1/W durmasi (M4),
D2 kurali (M5). model_kararlari.md §51.

Her test kucuk bir CASM programini hakemli boru hattinda kosar ve
  - gorev cevrim sayisini,
  - izdeki durma satirlarini (exe_pc / mpc),
  - son yazmac ve bellek degerlerini
sabitler. pytest ile ya da dogrudan calisir:

    python3 tests/test_boru_hatti.py
"""
import io
import os
import sys

sys.dont_write_bytecode = True
KOK = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if KOK not in sys.path:
    sys.path.insert(0, KOK)

from golden_model.assembler import assemble          # noqa: E402
from golden_model.cla_state import ClaState           # noqa: E402
from golden_model.cla_memory import ClaMemory         # noqa: E402
from golden_model.cla_core import ClaCore             # noqa: E402
from golden_model.pipeline import Pipeline            # noqa: E402
from golden_model.cla_regs import ClaRegs             # noqa: E402
from golden_model.task_arbiter import TaskArbiter     # noqa: E402
from golden_model import trace as TR                  # noqa: E402


class Kosu(object):
    """Bir programin kosusu: state, bellek, iz satirlari, gorev cevrimleri."""

    def __init__(self, kaynak, veri=(), gorevler=None):
        st, mem = ClaState(), ClaMemory()
        mem.load_program(assemble(kaynak))
        for adr, deger in veri:
            kim = "cpu" if 0x1500 <= adr <= 0x157F else "cla"
            mem.write32(adr, deger, who=kim)
        regs = ClaRegs()
        maske = 0
        for no, mvect in (gorevler or [(1, 0)]):
            regs.cpu_write(no - 1, mvect)
            maske |= 1 << (no - 1)
        regs.cpu_write(0x25, maske)            # MIER
        regs.cpu_write(0x22, maske)            # MIFRC
        core = ClaCore(st, mem, Pipeline(st, mem), arbiter=TaskArbiter(regs))
        akis = io.StringIO()
        self.gorevler = TR.iz_al_gorevler(core, akis)
        self.st, self.mem = st, mem
        self.satirlar = [l.split() for l in akis.getvalue().splitlines()
                         if l and not l.startswith("#")]

    def cevrim(self):
        return self.gorevler[0][1]

    def mr(self, i):
        return self.st.get_mr(i)

    def satir(self, cevrim):
        """cycle exe_pc exe_op mpc mr0 mr1 mr2 mr3 mar0 mar1 mstf wr_addr wr_data wr_w"""
        return self.satirlar[cevrim - 1]

    def exe_tekrar(self):
        """dur_exe satirlari: EXE'de bekleyen komut sonraki satirda tekrar eder."""
        return [int(a[0]) for a, b in zip(self.satirlar, self.satirlar[1:])
                if a[1] != "---" and a[1] == b[1]]


ON = " MNOP\n MNOP\n MNOP\n"
SON = " MSTOP\n MNOP\n MNOP\n MNOP\n"

F1_0, F2_0, F3_0, F5_0, F6_0, F8_0 = (0x3F800000, 0x40000000, 0x40400000,
                                      0x40A00000, 0x40C00000, 0x41000000)


# ---------------------------------------------------------------------------
#  M2: FP sonucu W'nin sonunda
# ---------------------------------------------------------------------------
def test_m2_fp_sonucu_W_satirinda_gorunur():
    k = Kosu(" MMOVIZ MR1, #2.0\n MMOVIZ MR2, #3.0\n" + ON +
             " MMPYF32 MR0, MR1, MR2\n" + ON + SON)
    exe = [int(s[0]) for s in k.satirlar if s[2] == "7c000024"]   # MMPYF32 MR0,MR1,MR2
    assert len(exe) == 1
    n = exe[0]
    assert int(k.satir(n)[4], 16) == 0            # EXE satirinda MR0 henuz eski
    assert int(k.satir(n + 1)[4], 16) == F6_0     # W satirinda yeni (2 x 3)


def test_m2_ayni_cevrimde_exe_yazmasi_K2yi_yener():
    # MADDF32 MR2 W'de (K2) iken MMOV32 MR2 EXE'de: son deger bellekteki 5.0
    k = Kosu(" MMOVIZ MR0, #1.0\n MMOVIZ MR1, #2.0\n" + ON +
             " MADDF32 MR2, MR0, MR1\n MMOV32 MR2, @0x8800\n" + ON + SON,
             veri=[(0x8800, F5_0)])
    assert k.mr(2) == F5_0


def test_m2_mmacf32_MRd_MR3_ise_toplama_kazanir():
    k = Kosu(" MMOVIZ MR0, #2.0\n MMOVIZ MR1, #3.0\n MMOVIZ MR2, #4.0\n"
             " MMOVIZ MR3, #1.0\n" + ON +
             " MMACF32 MR3, MR2, MR3, MR0, MR1 || MMOV32 MR2, @0x8800\n" + ON + SON,
             veri=[(0x8800, 0x41200000)])
    assert k.mr(3) == F5_0          # 1 + 4 (carpim 6 dusmeli)
    assert k.mr(2) == 0x41200000    # paralel yukleme EXE'de


def test_m2_paralel_yuklemenin_MRa_si_EXE_de_yazilir():
    k = Kosu(" MMOVIZ MR1, #2.0\n MMOVIZ MR2, #3.0\n" + ON +
             " MMPYF32 MR0, MR1, MR2 || MMOV32 MR3, @0x8800\n" + ON + SON,
             veri=[(0x8800, F3_0)])
    n = [int(s[0]) for s in k.satirlar if s[2] == "09308800"][0]
    assert int(k.satir(n)[7], 16) == F3_0     # MR3 (yukleme) EXE satirinda
    assert int(k.satir(n)[4], 16) == 0        # MR0 (carpim) henuz yok
    assert int(k.satir(n + 1)[4], 16) == F6_0


def test_m2_bekleyen_LVF_D2_dalina_gorunur():
    # tasan carpim, 3 MNOP, MBCNDD LV: dal alinmali (MR3 yazilmamali)
    k = Kosu(" MMOVIZ MR1, #0x7F00\n" + ON + " MMPYF32 MR0, MR1, MR1\n" + ON +
             " MBCNDD ATLA, LV\n MMOVIZ MR2, #1.0\n MNOP\n MNOP\n MMOVIZ MR3, #2.0\n"
             "ATLA:\n" + SON)
    assert k.mr(3) == 0
    assert k.mr(2) == F1_0          # gecikme yuvasi calisti
    assert k.st.mstf & 1 == 1


def test_m2_ayni_cevrimde_MSETFLG_K2_bayragini_yener():
    k = Kosu(" MMOVIZ MR1, #0x7F00\n" + ON +
             " MMPYF32 MR0, MR1, MR1\n MSETFLG LVF=0\n" + ON + SON)
    assert k.st.mstf & 1 == 0


def test_m2_kestirim_bayragi_EXE_de_yazilir():
    k = Kosu(" MMOVIZ MR0, #0.0\n" + ON + " MEINVF32 MR1, MR0\n" + ON + SON)
    n = [int(s[0]) for s in k.satirlar if s[2] == "7f000001"][0]
    assert int(k.satir(n)[10], 16) & 1 == 1   # LVF EXE satirinda


# ---------------------------------------------------------------------------
#  M3: interlock (dur_exe)
# ---------------------------------------------------------------------------
P_RAW = (" MMOVIZ MR1, #2.0\n MMOVIZ MR2, #3.0\n" + ON +
         " MMPYF32 MR0, MR1, MR2\n MADDF32 MR3, MR0, MR1\n" + ON + SON)


def test_m3_K2_hedefini_okuyan_bir_cevrim_bekler():
    k = Kosu(P_RAW)
    assert k.cevrim() == 18
    assert k.mr(3) == F8_0                    # 6 + 2
    assert k.exe_tekrar() == [13]             # EXE'de bekleyen MADDF32 iki satir
    assert k.satir(13)[1] == "00c" and k.satir(13)[3] == "012"   # MPC = D2'deki


def test_m3_yalniz_yazan_beklemez_saklama_bekler():
    k = Kosu(" MMOVIZ MR1, #2.0\n MMOVIZ MR2, #3.0\n" + ON +
             " MMPYF32 MR0, MR1, MR2\n MMOV32 MR0, @0x8800\n"
             " MMPYF32 MR3, MR1, MR2\n MMOV32 @0x8802, MR3\n" + ON + SON,
             veri=[(0x8800, F5_0)])
    assert k.cevrim() == 20
    assert k.exe_tekrar() == [15]             # yalniz saklama bekledi
    assert k.mr(0) == F5_0
    assert k.mem.read32(0x8802) == F6_0


# ---------------------------------------------------------------------------
#  M4: R1/W bellek durmasi (dur_r1)
# ---------------------------------------------------------------------------
def _r1w(yaz, oku, ara=" MNOP\n MNOP\n"):
    return (" MMOVIZ MR0, #2.0\n" + ON + " MMOV32 @%s, MR0\n" % yaz + ara +
            " MMOV32 MR1, @%s\n" % oku + ON + SON)


def test_m4_ayni_blok_farkli_adres_bir_cevrim_durur():
    k = Kosu(_r1w("0x8800", "0x8810"), veri=[(0x8810, F5_0)])
    assert k.cevrim() == 19
    assert k.mr(1) == F5_0
    assert k.satir(14)[1] == "---"            # balon iki cevrim sonra EXE'de


def test_m4_farkli_blok_durmaz():
    k = Kosu(_r1w("0x8800", "0x8C10"), veri=[(0x8C10, F5_0)])
    assert k.cevrim() == 18


def test_m4_zincirleme_durma():
    k = Kosu(" MMOVIZ MR0, #2.0\n" + ON + " MMOV32 @0x8800, MR0\n MMOV32 @0x8802, MR0\n"
             " MNOP\n MMOV32 MR1, @0x8810\n" + ON + SON, veri=[(0x8810, F5_0)])
    assert k.cevrim() == 20
    assert [s[1] for s in k.satirlar[13:15]] == ["---", "---"]
    assert [s[3] for s in k.satirlar[11:13]] == ["010", "010"]   # durmada MPC = D2'deki


def test_m4_cpu_cla_mesaj_ram_i_durmaz_cla_cpu_durur():
    k = Kosu(" MMOVIZ MR0, #2.0\n" + ON +
             " MMOV32 @0x1480, MR0\n MNOP\n MNOP\n MMOV32 MR1, @0x1500\n" + ON +
             " MMOV32 @0x1482, MR0\n MNOP\n MNOP\n MMOV32 MR2, @0x14A0\n" + ON + SON,
             veri=[(0x1500, F5_0)])
    assert k.cevrim() == 26                   # yalniz ikinci cift durdu
    assert k.mr(1) == F5_0


def test_m4_16_bit_yazma_ve_okuma():
    k = Kosu(" MMOVIZ MR0, #2.0\n" + ON + " MMOV16 @0x8C00, MR0\n MNOP\n MNOP\n"
             " MMOVZ16 MR1, @0x8C10\n" + ON + SON, veri=[(0x8C10, F5_0)])
    assert k.cevrim() == 19


def test_m4_okuyan_yoksa_durmaz():
    k = Kosu(" MMOVIZ MR0, #2.0\n" + ON + " MMOV16 @0x8800, MR0\n MNOP\n MNOP\n"
             " MMOVIZ MR1, #3.0\n" + ON + SON)
    assert k.cevrim() == 18


# ---------------------------------------------------------------------------
#  M5: D2 isi bir kez, D2'den ilerledigi cevrimde
# ---------------------------------------------------------------------------
def test_m5_durmada_MAR_artisi_bir_kez():
    k = Kosu(" MMOVIZ MR0, #2.0\n MMOVI16 MAR0, #0x8810\n" + ON +
             " MMOV32 @0x8800, MR0\n MNOP\n MNOP\n MMOV32 MR1, @0x8820\n"
             " MMOV32 MR2, *MAR0[2]++\n" + ON + SON,
             veri=[(0x8810, F5_0), (0x8812, F6_0)])
    assert k.st.get_mar(0) == 0x8812
    assert k.mr(2) == F5_0
    mar = [s[8] for s in k.satirlar]
    assert mar[12] == "8810" and mar[13] == "8812"   # artis ilerledigi cevrimde (14)


def test_m5_durmada_dal_bir_kez_ve_3_gecikme_yuvasi():
    k = Kosu(" MMOVIZ MR0, #2.0\n" + ON +
             " MMOV32 @0x8800, MR0\n MNOP\n MNOP\n MMOV32 MR1, @0x8820\n"
             " MBCNDD HEDEF, UNC\n MMOVIZ MR1, #1.0\n MMOVIZ MR2, #2.0\n"
             " MMOVIZ MR3, #3.0\n MMOVIZ MR0, #4.0\nHEDEF:\n" + SON)
    assert (k.mr(1), k.mr(2), k.mr(3)) == (F1_0, F2_0, F3_0)
    assert k.mr(0) == F2_0                    # 4. komut atlandi


# ---------------------------------------------------------------------------
#  TRM'den gelen (K1/K2 oncesi de olan) davranislar
# ---------------------------------------------------------------------------
def test_kosullu_yuklemede_MAR_artisi_kosulsuz():
    # MCMPF32 1.0 ile 2.0: ZF = 0, EQ tutmaz -> MR0 yuklenmez, MAR0 yine artar (D2)
    k = Kosu(" MMOVI16 MAR0, #0x8810\n MMOVIZ MR1, #1.0\n MNOP\n MNOP\n"
             " MCMPF32 MR1, #2.0\n" + ON + " MMOV32 MR0, *MAR0[2]++, EQ\n" + ON + SON,
             veri=[(0x8810, F5_0)])
    assert k.mr(0) == 0
    assert k.st.get_mar(0) == 0x8812


def test_daldan_onceki_3_buyrugun_bayragi_yetismez():
    k = Kosu(" MMOVIZ MR0, #1.0\n" + ON + " MCMPF32 MR0, #1.0\n MNOP\n MNOP\n"
             " MBCNDD ATLA, EQ\n MMOVIZ MR1, #1.0\n MNOP\n MNOP\n MMOVIZ MR2, #2.0\n"
             "ATLA:\n" + SON)
    assert k.mr(2) == F2_0                    # dal alinmadi (eski ZF = 0)


def test_yazmadan_2_sonra_okuma_eski_degeri_gorur():
    k = Kosu(" MMOVIZ MR0, #2.0\n" + ON + " MMOV32 @0x8800, MR0\n MNOP\n"
             " MMOV32 MR1, @0x8800\n" + ON + SON, veri=[(0x8800, 0x11111111)])
    assert k.mr(1) == 0x11111111


def test_gorev_sonundaki_FP_sonucu_kaybolmaz():
    kaynak = (" MMOVIZ MR1, #3.0\n" + ON + " MMPYF32 MR0, MR1, MR1\n" + SON +
              " MMOV32 @0x1480, MR0\n MADDF32 MR2, MR0, MR1\n" + ON +
              " MMOV32 @0x1482, MR2\n" + SON)
    k = Kosu(kaynak, gorevler=[(1, 0), (2, 0x12)])
    assert k.mem.read32(0x1480) == 0x41100000         # 9.0
    assert k.mem.read32(0x1482) == 0x41400000         # 12.0


if __name__ == "__main__":
    testler = [(ad, f) for ad, f in sorted(globals().items()) if ad.startswith("test_")]
    hata = 0
    for ad, f in testler:
        try:
            f()
            print("GECTI  " + ad)
        except AssertionError as e:
            hata += 1
            print("KALDI  %s  %s" % (ad, e))
    print("%d test, %d hata" % (len(testler), hata))
    sys.exit(1 if hata else 0)
