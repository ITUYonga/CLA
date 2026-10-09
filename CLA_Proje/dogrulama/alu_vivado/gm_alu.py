# -*- coding: utf-8 -*-
"""RTL ALU <-> Golden Model: vektor uretimi, golden hesaplama, RTL kosusu.

Golden tarafi PROJEDEKI fonksiyonlari dogrudan cagirir (kopya yok):
ops_float, ops_int, ops_convert, ops_estimate. Proje dosyalarina yazilmaz
(sys.dont_write_bytecode).
"""
import sys
sys.dont_write_bytecode = True
import os
import struct
import re
import subprocess
import random
import multiprocessing as mp

GM_KOK = os.environ.get("CLA_GOLDEN", os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "golden_model"))
if GM_KOK not in sys.path:
    sys.path.insert(0, GM_KOK)

from golden_model.cla_state import ClaState                     # noqa: E402
from golden_model import ops_float as F                          # noqa: E402
from golden_model import ops_int as I                            # noqa: E402
from golden_model import ops_convert as C                        # noqa: E402

SP = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RTL_DIR = os.path.join(SP, "rtl")
RTL_DIR = os.environ.get("ALU_RTL_DIR", RTL_DIR)
TB = os.environ.get("ALU_TB", os.path.join(RTL_DIR, "obj_dir", "Vtb_alu"))

OP_FADD, OP_FSUB, OP_FMUL = 0, 1, 2
OP_INT = 10            # +0..7: SUM SUB AND OR XOR LSL LSR ASR
OP_EINV, OP_EISQRT = 20, 21
OP_CMP = 30            # +0..4: MCMPF32 MMAXF32 MMINF32 MABSF32 MNEGF32
OP_CVT = 40            # +0..10 donusum.sv fpu_op_e
OP_BUBBLE = 99

# c2 bayrak kodlamasi: ALU mstf_in [4]TF [3]ZF [2]NF [1]LUF [0]LVF
UNCF = 0xF
AYRILMIS_CNDF = {6, 7, 8, 9}

# ops_convert dizisi donusum.sv fpu_op_e sirasiyla
CVT_FN = [C.mf32toi16_rr, C.mf32toi16r_rr, C.mf32toi32_rr, C.mf32toui16_rr,
          C.mf32toui16r_rr, C.mf32toui32_rr, F.mfracf32_rr, C.mi16tof32_rr,
          C.mi32tof32_rr, C.mui16tof32_rr, C.mui32tof32_rr]
CVT_AD = ["MF32TOI16", "MF32TOI16R", "MF32TOI32", "MF32TOUI16", "MF32TOUI16R",
          "MF32TOUI32", "MFRACF32", "MI16TOF32", "MI32TOF32", "MUI16TOF32",
          "MUI32TOF32"]
INT_AD = ["MADD32", "MSUB32", "MAND32", "MOR32", "MXOR32", "MLSL32", "MLSR32", "MASR32"]
CMP_AD = ["MCMPF32", "MMAXF32", "MMINF32", "MABSF32", "MNEGF32"]


def _alu_mstf_to_reg(c2):
    """ALU 5-bit bayrak -> MSTF yazmac bitleri (TF 6, ZF 3, NF 2, LUF 1, LVF 0)."""
    return (((c2 >> 4) & 1) << 6) | (((c2 >> 3) & 1) << 3) | (((c2 >> 2) & 1) << 2) \
        | (((c2 >> 1) & 1) << 1) | (c2 & 1)


def golden(op, a, b, c1, c2, imm=False):
    """Tek vektor -> (beklenen_sonuc, beklenen_bayrak, maske) ya da None (atla).

    bayrak: bit0 LVF, bit1 LUF, bit2 NF, bit3 ZF
    maske : bit0 sonuc, bit1 LVF/LUF, bit2 ZF/NF
    imm   : MCMPF32/MMAXF32/MMINF32'nin #16FHi bicimi (b = I << 16)
    """
    st = ClaState()
    if op in (OP_FADD, OP_FSUB, OP_FMUL):
        st.mr[1] = a; st.mr[2] = b; st.rnd32 = c1 & 1
        {OP_FADD: F.maddf32_rrr, OP_FSUB: F.msubf32_rrr, OP_FMUL: F.mmpyf32_rrr}[op](st, 0, 1, 2)
        return st.get_mr(0), (st.lvf | (st.luf << 1)), 3
    if OP_INT <= op <= OP_INT + 7:
        k = op - OP_INT
        st.mr[1] = a; st.mr[2] = b
        if k <= 4:
            [I.madd32_rrr, I.msub32_rrr, I.mand32_rrr, I.mor32_rrr, I.mxor32_rrr][k](st, 0, 1, 2)
            r = st.get_mr(0)
        else:
            [I.mlsl32_ri, I.mlsr32_ri, I.masr32_ri][k - 5](st, 1, b)
            r = st.get_mr(1)
        return r, (st.nf << 2) | (st.zf << 3), 1 | 4
    if op == OP_INT + 100:          # MCMP32: RTL'de SUB, yalniz bayrak
        st.mr[1] = a; st.mr[2] = b
        I.mcmp32_rr(st, 1, 2)
        return 0, (st.nf << 2) | (st.zf << 3), 4
    if op in (OP_EINV, OP_EISQRT):
        st.mr[1] = a
        (F.minvf32 if op == OP_EINV else F.misqrtf32)(st, 0, 1)
        return st.get_mr(0), (st.lvf | (st.luf << 1)), 3
    if OP_CMP <= op <= OP_CMP + 4:
        k = op - OP_CMP
        st.mr[1] = a; st.mr[2] = b
        if k == 0:
            if imm:
                F.mcmpf32_imm(st, mra=1, imm=(b >> 16) & 0xFFFF)
            else:
                F.mcmpf32_rr(st, 1, 2)
            return 0, (st.nf << 2) | (st.zf << 3), 4
        if k in (1, 2):
            if imm:
                (F.mmaxf32_imm if k == 1 else F.mminf32_imm)(st, mra=1, upper_16=(b >> 16) & 0xFFFF)
            else:
                (F.mmaxf32_rr if k == 1 else F.mminf32_rr)(st, 1, 2)
            return st.get_mr(1), (st.nf << 2) | (st.zf << 3), 1 | 4
        if k == 3:
            F.mabsf32_rr(st, 0, 2)
            return st.get_mr(0), (st.nf << 2) | (st.zf << 3), 1 | 4
        # MNEGF32
        cndf = c1 & 0xF
        if cndf in AYRILMIS_CNDF:
            return None
        st.mstf = _alu_mstf_to_reg(c2)
        F.mnegf32_rrc(st, 0, 2, cndf)
        m = 1 | (4 if cndf == UNCF else 0)
        return st.get_mr(0), (st.nf << 2) | (st.zf << 3), m
    if OP_CVT <= op <= OP_CVT + 10:
        st.mr[1] = a; st.rnd32 = c1 & 1
        CVT_FN[op - OP_CVT](st, 0, 1)
        return st.get_mr(0), 0, 1
    raise ValueError(op)


def _golden_chunk(args):
    recs, imm = args
    out = []
    for (op, a, b, c1, c2) in recs:
        g = golden(op, a, b, c1, c2, imm)
        if g is None:
            continue
        er, ef, mask = g
        rtl_op = OP_INT + 1 if op == OP_INT + 100 else op
        out.append((rtl_op, a, b, c1, c2, er, ef, mask))
    return out


_POOL = None


def pool():
    global _POOL
    if _POOL is None:
        _POOL = mp.get_context("fork").Pool(max(1, (os.cpu_count() or 2) - 1))
    return _POOL


def golden_toplu(recs, imm=False, parca=20000):
    parcalar = [(recs[i:i + parca], imm) for i in range(0, len(recs), parca)]
    sonuc = []
    for p in pool().map(_golden_chunk, parcalar):
        sonuc.extend(p)
    return sonuc


def yaz_bin(yol, kayitlar):
    with open(yol, "wb") as f:
        pk = struct.Struct("<8I")
        for k in kayitlar:
            f.write(pk.pack(*[x & 0xFFFFFFFF for x in k]))


def rtl_kos(kayitlar, ad, max_yaz=30, tohum=1):
    """Kayitlari RTL tezgahinda kosar -> (vektor, fark, cikti_metni)."""
    yol = os.path.join(RTL_DIR, "vec_%s_%d.bin" % (re.sub(r"[^A-Za-z0-9]+", "_", ad), os.getpid()))
    yaz_bin(yol, kayitlar)
    p = subprocess.run([TB, yol, str(max_yaz), str(tohum)], cwd=RTL_DIR,
                       capture_output=True, text=True)
    os.remove(yol)
    metin = p.stdout + p.stderr
    n = fark = None
    for satir in metin.splitlines():
        if satir.startswith("OZET"):
            parca = dict(x.split("=") for x in satir.split()[1:])
            n, fark = int(parca["vektor"]), int(parca["fark"])
    if n is None:
        raise RuntimeError("tezgah ozet basmadi:\n" + metin)
    return n, fark, metin


# ---------------------------------------------------------------------
#  float32 desen uretimi
# ---------------------------------------------------------------------
def f32(s, e, m):
    return ((s & 1) << 31) | ((e & 0xFF) << 23) | (m & 0x7FFFFF)


OZEL = sorted(set([
    0x00000000, 0x80000000,                      # +-0
    0x00000001, 0x80000001, 0x007FFFFF, 0x807FFFFF, 0x00400000, 0x80400000,  # denormal
    0x00000002, 0x00123456, 0x80654321,
    0x00800000, 0x80800000, 0x00800001, 0x80800001, 0x00FFFFFF, 0x80FFFFFF,  # MIN_NORMAL
    0x01000000, 0x81000000, 0x0B800000, 0x0C000000,
    0x7F7FFFFF, 0xFF7FFFFF, 0x7F7FFFFE, 0xFF7FFFFE, 0x7F000000, 0xFF000000,  # MAX
    0x7E800000, 0x7EFFFFFF, 0x7F400000, 0x73800000, 0x73000000,
    0x7F800000, 0xFF800000,                      # +-inf
    0x7FC00000, 0xFFC00000, 0x7F800001, 0xFF800001, 0x7FFFFFFF, 0xFFFFFFFF,  # NaN
    0x7FA00000, 0x7FBFFFFF,
    0x3F800000, 0xBF800000, 0x3FC00000, 0xBFC00000, 0x40000000, 0xC0000000,
    0x3F7FFFFF, 0xBF7FFFFF, 0x3F800001, 0xBF800001, 0x3FFFFFFF, 0x3F000000,
    0x3EFFFFFF, 0x3F000001, 0x4B000000, 0x4B7FFFFF, 0x4B800000, 0x4B000001,
    0x4EFFFFFF, 0x4F000000, 0x4F000001, 0xCF000000, 0xCF000001, 0x4F7FFFFF,
    0x4F800000, 0x5F000000, 0x5F7FFFFF, 0x46FFFE00, 0x47000000, 0x477FFF00,
    0x477FFF80, 0x477FFFFF, 0x47800000, 0xC7000000, 0xC7000080, 0xC7000100,
    0x3FC00001, 0x40400000, 0x40490FDB, 0x41200000, 0xC1200000,
    0x01800000, 0x0D800000, 0x19800000, 0x1F800000, 0x20000000, 0x5F800000,
    0x5E800000, 0x3F400000, 0x3E800000, 0x34000000, 0x33800000, 0x33000000,
]))


def rastgele_f32(r):
    """Ozel bolgelere agirlik veren rastgele float32 deseni."""
    t = r.random()
    s = r.getrandbits(1)
    if t < 0.08:
        return r.choice(OZEL) ^ (r.getrandbits(1) << 31)
    if t < 0.13:
        e = r.choice([0, 0xFF])
    elif t < 0.30:
        e = r.choice([1, 2, 3, 4, 23, 24, 25, 26, 100, 126, 127, 128, 150, 151,
                      157, 158, 159, 170, 180, 200, 250, 251, 252, 253, 254])
    else:
        e = r.randrange(256)
    u = r.random()
    if u < 0.5:
        m = r.getrandbits(23)
    elif u < 0.6:
        m = 0
    elif u < 0.7:
        m = 0x7FFFFF
    elif u < 0.8:
        m = 1 << r.randrange(23)
    elif u < 0.9:
        m = r.getrandbits(23) & ~((1 << r.randrange(24)) - 1)
    else:
        m = (0x7FFFFF >> r.randrange(23)) ^ r.getrandbits(3)
    return f32(s, e, m)


def toplama_cifti(r):
    """Toplama/cikarma icin hizalama, iptal, yuvarlama ve sinir bolgeleri."""
    t = r.random()
    if t < 0.25:
        return rastgele_f32(r), rastgele_f32(r)
    ea = r.randrange(1, 255)
    if t < 0.40:
        eb = ea                                   # esit us: iptal / tasima
    elif t < 0.75:
        eb = ea - r.randrange(0, 32)              # hizalama kaydirmasi 0..31
    elif t < 0.85:
        eb = ea - r.randrange(32, 60)
    else:
        ea = r.choice([1, 2, 3, 24, 25, 26, 253, 254])
        eb = ea - r.randrange(0, 5)
    eb = max(0, min(254, eb))
    ma = r.getrandbits(23)
    k = r.random()
    if k < 0.3:
        mb = r.getrandbits(23)
    elif k < 0.55:
        mb = (ma + r.randrange(-8, 9)) & 0x7FFFFF     # neredeyse esit -> buyuk iptal
    elif k < 0.8:
        mb = r.getrandbits(23) & ~((1 << r.randrange(1, 24)) - 1)  # esitlik (tie) icin
    else:
        mb = r.choice([0, 0x7FFFFF, 0x400000, 1, 0x7FFFFE])
    sa, sb = r.getrandbits(1), r.getrandbits(1)
    a, b = f32(sa, ea, ma), f32(sb, eb, mb)
    return (a, b) if r.random() < 0.5 else (b, a)


def carpma_cifti(r):
    """Carpma icin tasma/alt tasma sinirlari ve esitlik (tie) desenleri."""
    t = r.random()
    if t < 0.25:
        return rastgele_f32(r), rastgele_f32(r)
    if t < 0.55:
        hedef = r.choice([-30, -25, -24, -23, -22, -21, -2, -1, 0, 1, 2, 3,
                          126, 127, 128, 200, 252, 253, 254, 255, 256, 257])
        ea = r.randrange(1, 255)
        eb = hedef + 127 - ea
        if not 1 <= eb <= 254:
            eb = r.randrange(1, 255)
        ma, mb = r.getrandbits(23), r.getrandbits(23)
        if r.random() < 0.3:
            ma, mb = 0x7FFFFF, r.choice([0x7FFFFF, 0x7FFFFE, 0, 1, r.getrandbits(23)])
    else:
        # A = 1.5 / 1.25 / 1.75 / 1.125 ... -> dusen bitler tam yari olabilir
        ea, eb = r.randrange(1, 255), r.randrange(1, 255)
        if r.random() < 0.3:
            ea = r.randrange(40, 90); eb = r.randrange(40, 90)
        ma = r.choice([0x400000, 0x200000, 0x600000, 0x100000, 0x500000, 0x700000,
                       0x080000, 0x480000, 0x7FFFFF, 0x000001, 0x000003])
        mb = r.getrandbits(23)
        if r.random() < 0.5:
            mb = (mb & ~3) | r.choice([0, 1, 2, 3])
        if r.random() < 0.5:
            ma, mb = mb, ma
    return f32(r.getrandbits(1), ea, ma), f32(r.getrandbits(1), eb, mb)
