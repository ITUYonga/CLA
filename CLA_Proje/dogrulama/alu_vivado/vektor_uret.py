# -*- coding: utf-8 -*-
"""Vivado testbench'i icin golden vektor dosyasi (metin, $fscanf ile okunur).

Satir: op A B c1 c2 beklenen_sonuc beklenen_bayrak maske   (hepsi onaltilik)
  op: 0 MADDF32, 1 MSUBF32, 2 MMPYF32, 10..17 tamsayi, 20/21 kestirim,
      30..34 karsilastirma, 40..50 donusum
  bayrak: bit0 LVF, bit1 LUF, bit2 NF, bit3 ZF ; maske: bit0 sonuc, bit1 LVF/LUF, bit2 ZF/NF
Beklenen degerler PROJEDEKI golden modelden (ops_*.py) hesaplanir.
"""
import sys
sys.dont_write_bytecode = True
import os
import random

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import gm_alu as G                                              # noqa: E402


def uret(r):
    recs = []
    oz = G.OZEL
    for op in (G.OP_FADD, G.OP_FSUB, G.OP_FMUL):
        recs += [(op, a, b, rnd, 0) for a in oz[::2] for b in oz[::2] for rnd in (0, 1)]
        gen = G.carpma_cifti if op == G.OP_FMUL else G.toplama_cifti
        for _ in range(25000):
            a, b = gen(r)
            recs.append((op, a, b, r.getrandbits(1), 0))
    for k in range(8):
        for _ in range(3000):
            b = r.randrange(1, 33) if k >= 5 else r.getrandbits(32)
            recs.append((G.OP_INT + k, r.getrandbits(32), b, 0, 0))
    recs += [(G.OP_INT + 100, r.getrandbits(32), r.getrandbits(32), 0, 0) for _ in range(3000)]
    for op in (G.OP_EINV, G.OP_EISQRT):
        recs += [(op, G.f32(s, e, (hi << 15) | r.getrandbits(15)), 0, 0, 0)
                 for s in (0, 1) for e in range(256) for hi in range(0, 256, 4)]
    for k in range(3):
        recs += [(G.OP_CMP + k, a, b, 0xF, 0) for a in oz[::2] for b in oz[::2]]
        recs += [(G.OP_CMP + k, G.rastgele_f32(r), G.rastgele_f32(r), 0xF, 0) for _ in range(5000)]
    recs += [(G.OP_CMP + 3, r.getrandbits(32), G.rastgele_f32(r), 0xF, 0) for _ in range(5000)]
    recs += [(G.OP_CMP + 4, r.getrandbits(32), v, c, fl) for c in range(16) if c not in G.AYRILMIS_CNDF
             for fl in range(32) for v in oz[::4]]
    for k in range(11):
        recs += [(G.OP_CVT + k, G.f32(s, e, m), 0, r.getrandbits(1), 0) for s in (0, 1) for e in range(256)
                 for m in (0, 1, 0x400000, 0x7FFFFF, r.getrandbits(23))]
        recs += [(G.OP_CVT + k, r.getrandbits(32), 0, r.getrandbits(1), 0) for _ in range(4000)]
    return recs


if __name__ == "__main__":
    cikti = sys.argv[1]
    kayit = G.golden_toplu(uret(random.Random(1011)))
    with open(cikti, "w") as f:
        for k in kayit:
            f.write(" ".join("%x" % (x & 0xFFFFFFFF) for x in k) + "\n")
    print("%d vektor -> %s" % (len(kayit), cikti))
