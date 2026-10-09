# -*- coding: utf-8 -*-
"""Kart yokken KV260'in yerine gecen sanal seri cihaz.

Bir pty (sahte seri port) acar ve cla_uart_kopru.sv'nin protokolunu
Python'da uygular. PC tarafi (FpgaKontrolcu, kart_testi.py) gercek USB-TTL
portu yerine bu yola baglanir; boylece pyserial, paketleme, zaman asimi ve
sim.py'nin FPGA modu kartsiz denenir.

    cekirdek="golden" : icinde CLA'nin golden modeli kosar (kontrolcu.casm)
    cekirdek="taklit" : cla_cekirdek_taklidi.sv gibi davranir (C2M = M2C + 1)

UART hizi da taklit edilir: cevap, istek + cevap baytlarinin 921600 baud'da
alacagi sure kadar geciktirilir (USB gecikmesi haric).

    .venv/bin/python sanal_fpga.py          # yolu yazar, Ctrl-C'ye kadar acik kalir
"""
import os
import select
import sys
import threading
import time
import tty

import uart_protokol as U

TAKLIT_KELIME, TAKLIT_CEVRIM = 9, 200


class SanalFpga(object):
    def __init__(self, cekirdek="golden", model="hizli", baud=921600, hiz_taklidi=True, duzen=None):
        self.ana, self.uydu = os.openpty()
        tty.setraw(self.uydu)
        self.yol = os.ttyname(self.uydu)
        self.baud, self.hiz_taklidi = baud, hiz_taklidi
        self.cekirdek = cekirdek
        self.m2c, self.c2m = [0] * U.RAM_KELIME, [0] * U.RAM_KELIME
        self.takili = False                 # MIRUN takili (taklit kancasi)
        self.golden = None
        if cekirdek == "golden":
            from kontrolcu import GoldenKontrolcu
            self.golden = GoldenKontrolcu(duzen=duzen, model=model)
        self.istek_sayisi = 0
        self._dur = False
        self._is = threading.Thread(target=self._dongu, daemon=True)
        self._is.start()

    # ---------------------------------------------------------- bellek
    def _m2c_yaz(self, ofs, kelimeler):
        for i, k in enumerate(kelimeler):
            self.m2c[ofs + i] = k
            if self.golden:
                self.golden.mem.write16(U.M2C_TABAN + ofs + i, k, who="cpu")

    def _c2m(self, ofs, n):
        if self.golden:
            return [self.golden.mem.read16(U.C2M_TABAN + ofs + i, who="cpu") for i in range(n)]
        return self.c2m[ofs:ofs + n]

    def _gorev(self):
        """None: zaman asimi; yoksa cevrim sayisi."""
        if self.takili:
            return None
        if self.golden:
            return self.golden.gorev_kostur()
        for j in range(TAKLIT_KELIME):
            v = ((self.m2c[2 * j] | self.m2c[2 * j + 1] << 16) + 1) & 0xFFFFFFFF
            self.c2m[2 * j], self.c2m[2 * j + 1] = v & 0xFFFF, v >> 16
        if self.m2c[127] == 0xDEAD:         # taklit cekirdegin kancasi
            self.takili = True
            return None
        return TAKLIT_CEVRIM

    # ---------------------------------------------------------- komutlar
    def isle(self, tip, veri):
        """Bir istek -> (cevap tipi, cevap verisi); RTL ile ayni kurallar."""
        n = len(veri)
        hata = lambda kod: (U.HATA, bytes([kod]))     # noqa: E731
        kel = lambda b: [b[i] | b[i + 1] << 8 for i in range(0, len(b) - 1, 2)]  # noqa: E731
        if tip == U.YANKI:
            return U.YANKI, veri
        if tip == U.YAZ:
            if n % 2 == 0 or veri[0] + (n - 1) // 2 > U.RAM_KELIME:
                return hata(4)
            self._m2c_yaz(veri[0], kel(veri[1:]))
            return U.YAZ, b""
        if tip == U.ADIM:
            if n < 2 or n % 2 or veri[1] > U.EN_COK_CEVAP or veri[0] + (n - 2) // 2 > U.RAM_KELIME:
                return hata(4)
            self._m2c_yaz(veri[0], kel(veri[2:]))
            cevrim = self._gorev()
            if cevrim is None:
                return hata(3)
            k = self._c2m(0, veri[1])
            return U.ADIM, b"".join(bytes([w & 0xFF, w >> 8]) for w in k) + cevrim.to_bytes(4, "little")
        if tip == U.OKU:
            if n != 2 or veri[1] > U.EN_COK_CEVAP or veri[0] + veri[1] > U.RAM_KELIME:
                return hata(4)
            return U.OKU, b"".join(bytes([w & 0xFF, w >> 8]) for w in self._c2m(veri[0], veri[1]))
        if tip == U.SIFIRLA:
            if n:
                return hata(4)
            self.takili = False
            return U.SIFIRLA, b""
        return hata(2)

    # ---------------------------------------------------------- seri dongu
    def _dongu(self):
        tampon = bytearray()
        while not self._dur:
            r, _, _ = select.select([self.ana], [], [], 0.05)
            if not r:
                if tampon:                  # bayt zaman asimi: yarim paketi at
                    tampon.clear()
                continue
            try:
                tampon += os.read(self.ana, 4096)
            except OSError:
                return
            while True:
                i = tampon.find(bytes([U.ISTEK]))
                if i < 0:
                    tampon.clear()
                    break
                del tampon[:i]
                if len(tampon) < 3 or len(tampon) < 4 + tampon[2]:
                    break
                tip, n = tampon[1], tampon[2]
                veri, s = bytes(tampon[3:3 + n]), tampon[3 + n]
                del tampon[:4 + n]
                if s != U.saglama(tip, veri):
                    ctip, cveri = U.HATA, b"\x01"
                else:
                    ctip, cveri = self.isle(tip, veri)
                cevap = U.cerceve(ctip, cveri, bas=U.CEVAP)
                self.istek_sayisi += 1
                if self.hiz_taklidi:
                    time.sleep((n + 4 + len(cevap)) * 10.0 / self.baud)
                os.write(self.ana, cevap)

    def kapat(self):
        self._dur = True
        self._is.join(timeout=1)
        os.close(self.ana)
        os.close(self.uydu)


def main():
    sys.dont_write_bytecode = True
    cekirdek = "taklit" if "--taklit" in sys.argv else "golden"
    s = SanalFpga(cekirdek=cekirdek)
    print("sanal KV260 (%s cekirdek) hazir: %s" % (cekirdek, s.yol))
    print("ornek:  .venv/bin/python sim.py --kontrolcu fpga --port %s" % s.yol)
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n%d istek islendi" % s.istek_sayisi)
        s.kapat()


if __name__ == "__main__":
    main()
