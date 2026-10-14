# -*- coding: utf-8 -*-
"""cla_golden.py - golden CLA modeli (core.py) uzerinde adim adim gorev kosturma.

Bir drone adimi = (gorev_maske , M2C , adim oncesi C2M) -> adim sonrasi C2M.
Kartin sim_kayit_t kayitlari ayni girisle burada kosturulup C2M bit bit karsilastirilir.

    g = GoldenCla("../cla/drone.casm")
    c2m_sonra, cevrim = g.calistir(maske, m2c32, c2m_once32)

core.py ve test_karsilastirici.py bu dosyayla ayni klasorde ya da CLA_CORE ortam degiskeninde.
"""
import os
import re
import sys

_burasi = os.path.dirname(os.path.abspath(__file__))
for _yol in (os.environ.get("CLA_CORE"), _burasi, os.path.join(_burasi, "..", "cla")):
    if _yol and os.path.exists(os.path.join(_yol, "core.py")):
        sys.path.insert(0, _yol)
        break
import core  # noqa: E402

M2C_ADR, C2M_ADR = 0x1500, 0x1480
BOLGE_C2M, BOLGE_M2C = 0, 1


def _yarim(kelimeler32):
    out = []
    for w in kelimeler32:
        out += [w & 0xFFFF, (w >> 16) & 0xFFFF]
    return out


class GoldenCla(object):
    def __init__(self, casm_yolu):
        metin = open(casm_yolu, encoding="utf-8").read()
        sembol = {m.group(1): int(m.group(2), 0) for m in re.finditer(r";#sembol\s+(\S+)\s+(\S+)", metin)}
        gorev = [(int(m.group(1)), m.group(2)) for m in re.finditer(r";#gorev\s+(\d)\s+(\S+)", metin)]
        self.kelimeler = core.assemble(metin, semboller=sembol)
        hatalar = [b for b in core.denetle(metin, sembol, self.kelimeler) if b.agirlik == core.HATA]
        if hatalar:
            raise RuntimeError("lint: %s" % "; ".join(str(b) for b in hatalar))
        etiket, mpc = {}, 0
        for no, satir in enumerate(core._devam_satirlarini_birlestir(metin.splitlines()), 1):
            et, mn, jet = core.satir_coz(satir)
            if et:
                etiket[et] = mpc
            if mn:
                mpc += 2 * len(core._sahte_ac(mn, jet, no)) if mn in core.SAHTE_KOMUTLAR else 2
        self.mvect = [0] * 8
        for no, et in gorev:
            self.mvect[no - 1] = etiket[et]
        self.mem = core.ClaMemory()
        self.mem.load_program(self.kelimeler)

    def calistir(self, maske, m2c32, c2m32, max_cevrim=20000):
        """Maskedeki gorevleri oncelik sirasiyla kosturur. Doner: (C2M 32 bit listesi , toplam cevrim)."""
        mem = self.mem
        mem.regions[BOLGE_M2C].words[:] = _yarim(list(m2c32) + [0] * (64 - len(m2c32)))
        mem.regions[BOLGE_C2M].words[:] = _yarim(list(c2m32) + [0] * (64 - len(c2m32)))
        st = core.ClaState()
        regs = core.ClaRegs()
        for i in range(8):
            regs.cpu_write(i, self.mvect[i])
        regs.cpu_write(0x25, maske)                     # MIER
        regs.cpu_write(0x22, maske)                     # MIFRC
        hakem = core.TaskArbiter(regs)
        boru = core.Pipeline(st, mem)
        cek = core.ClaCore(st, mem, boru, arbiter=hakem)
        cevrim = 0
        while hakem.gorev_basla(st):
            boru.durdu = False
            for _ in range(max_cevrim):
                cevrim += 1
                if not cek.step():
                    break
            else:
                raise RuntimeError("gorev %d cevrimde bitmedi" % max_cevrim)
        w = mem.regions[BOLGE_C2M].words
        return [w[2 * i] | (w[2 * i + 1] << 16) for i in range(64)], cevrim
