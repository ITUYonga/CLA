"""CLA_Top testleri icin ortak: kodlama, golden boru hatti kosusu, paket dosyalari, RTL tezgahi ve karsilastirma."""
import sys, os, io, subprocess
GK = os.environ.get("CLA_GOLDEN", os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "golden_model"))
sys.path.insert(0, GK)
from golden_model.isa_table import load_table
from golden_model.decoder import decode
from golden_model.disassembler import disassemble
from golden_model.cla_state import ClaState
from golden_model.cla_memory import ClaMemory
from golden_model.cla_core import ClaCore
from golden_model.pipeline import Pipeline
from golden_model.cla_regs import ClaRegs
from golden_model.task_arbiter import TaskArbiter
from golden_model import trace as TR
from golden_model import dagitici as D
from golden_model.lint import denetle, HATA

PY = os.environ.get("PY", sys.executable)            # golden icin Python 3.10+ ve PyYAML
TB = os.environ.get("TB", "./obj_tb_top/tb_top")
TABLO = load_table()
MSTOP, MNOP = 0x7F800000, 0x7FA00000
BOLGE = {"L1": 2, "L2": 3, "M2C": 1, "C2M": 0}                             # ClaMemory.regions sirasi


def giris(syntax, mar=None):
    a = [e for e in TABLO if e["syntax"] == syntax]
    if mar is not None: a = [e for e in a if D._mar_indeksi(e) == mar]
    return a[0]


def yerlestir(w, e, ad, deger):
    konum = e["fields"][ad]; L = len(konum)
    for i, b in enumerate(konum):
        w = (w & ~(1 << b)) | (((deger >> (L - 1 - i)) & 1) << b)
    return w


def kodla(syntax, mar=None, **alanlar):
    e = giris(syntax, mar); w = e["match"]
    for ad, deger in alanlar.items(): w = yerlestir(w, e, ad, deger)
    assert decode(w).syntax == syntax, syntax
    return w


def mr_yukle(x, v):
    return [kodla("MMOVIZ MRa, #16FHi", a=x, I=v >> 16), kodla("MMOVXI MRa, #16FLoHex", a=x, I=v & 0xFFFF)]


def lint_hatalari(kel):
    return [b for b in denetle("", None, kel) if b.agirlik == HATA]


def golden(kel, mvect, l1, l2, m2c, c2m):
    st, mem = ClaState(), ClaMemory()
    mem.load_program(kel)
    for bas, veri, kim in ((0x8800, l1, "cla"), (0x8C00, l2, "cla"), (0x1500, m2c, "cpu"), (0x1480, c2m, "cla")):
        for i, v in enumerate(veri): mem.write16(bas + i, v, who=kim)
    regs = ClaRegs(); maske = 0
    for i, v in enumerate(mvect):
        if v is not None: regs.cpu_write(i, v); maske |= 1 << i
    regs.cpu_write(0x25, maske); regs.cpu_write(0x22, maske)
    arb = TaskArbiter(regs)
    core = ClaCore(st, mem, Pipeline(st, mem), arbiter=arb)
    mem.write_log.clear()
    akis = io.StringIO()
    TR.iz_al_gorevler(core, akis)
    return akis.getvalue(), st, mem, regs, arb, maske


def hex_yaz(yol, kelimeler):
    open(yol, "w").write("\n".join("%04x" % (w & 0xFFFF) for w in kelimeler) + "\n")


def hex_oku(yol):
    v = []
    for l in open(yol):
        l = l.split("//")[0].strip()
        if l and not l.startswith("@"): v.append(int(l, 16))
    return v


def kostur(on, kel, mvect, l1, l2, m2c, c2m):
    """Golden'i kosturur, paket dosyalarini yazar, RTL tezgahini kosturur, karsilastirir.
    (tamam, rapor satirlari, sayac sozlugu, iz satir sayisi) doner. Golden hata verirse istisna yukselir."""
    iz, st, mem, regs, arb, maske = golden(kel, mvect, l1, l2, m2c, c2m)
    l3 = [0] * 4096
    for i, w in enumerate(kel): l3[2 * i] = w & 0xFFFF; l3[2 * i + 1] = w >> 16
    hex_yaz(on + "_L3.hex", l3); hex_yaz(on + "_L1.hex", l1); hex_yaz(on + "_L2.hex", l2)
    hex_yaz(on + "_M2C.hex", m2c); hex_yaz(on + "_C2M.hex", c2m)
    with open(on + "_yazmac_baslangic.txt", "w") as f:
        for i in range(8): f.write("MVECT%d %03x\n" % (i + 1, (mvect[i] or 0) if i < len(mvect) else 0))
        f.write("MIER %02x\nMIFRC %02x\nMSTF %08x\n" % (maske, maske, 0))
    open(on + "_golden.trace", "w").write(iz)
    satir = sum(1 for l in iz.splitlines() if l and not l.startswith("#"))
    r = subprocess.run([TB, "+PROG=" + on, "+CIKTI=" + on + "_rtl"], capture_output=True, text=True)
    if r.returncode != 0 or not os.path.exists(on + "_rtl_son_yazmac.txt"):
        return False, ["TEZGAH HATASI " + (r.stdout + r.stderr)[-300:]], {}, satir
    sayac = {}
    for l in r.stdout.splitlines():
        if l.startswith("SAYAC"):
            sayac = dict(zip(("dur_exe", "dur_r1", "dal_alindi", "cagri", "mar_artis", "gorev_basla", "gecis_bekleme"),
                             map(int, l.split()[1:])))
    c = subprocess.run([PY, "-B", GK + "/tools/compare_trace.py", on + "_golden.trace", on + "_rtl.trace"],
                       capture_output=True, text=True, env=dict(os.environ, PYTHONDONTWRITEBYTECODE="1"))
    bel = [b for b in ("L1", "L2", "C2M") if hex_oku(on + "_rtl_son_%s.hex" % b) != mem.regions[BOLGE[b]].words]
    ry = {l.split()[0]: [x.lower() for x in l.split()[1:]] for l in open(on + "_rtl_son_yazmac.txt") if l.strip()}
    gy = {"MR0": ["%08x" % st.get_mr(0)], "MR1": ["%08x" % st.get_mr(1)], "MR2": ["%08x" % st.get_mr(2)],
          "MR3": ["%08x" % st.get_mr(3)], "MAR0": ["%04x" % st.get_mar(0)], "MAR1": ["%04x" % st.get_mar(1)],
          "MSTF": ["%08x" % st.mstf], "MPC": ["%03x" % st.mpc], "MIRUN": ["%02x" % regs.mirun],
          "MIFR": ["%02x" % regs.mifr], "MIOVF": ["%02x" % regs.miovf], "PIE": ["%02x" % x for x in arb.pie_kesmeleri]}
    yaz = [k for k in gy if gy[k] != ry.get(k, [])]
    tamam = c.returncode == 0 and not bel and not yaz
    rapor = []
    if not tamam:
        rapor.append("iz %s, bellek %s, yazmac %s" % ("AYNI" if c.returncode == 0 else "FARKLI", bel or "AYNI",
                     ["%s g=%s r=%s" % (k, gy[k], ry.get(k)) for k in yaz] or "AYNI"))
        rapor += c.stdout.strip().splitlines()[:14]
    return tamam, rapor, sayac, satir


def temizle(on):
    d, b = os.path.dirname(on), os.path.basename(on) + "_"
    for y in os.listdir(d):
        if y.startswith(b): os.remove(os.path.join(d, y))
