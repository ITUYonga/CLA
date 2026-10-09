# -*- coding: utf-8 -*-
"""Kart yokken KV260'in yerine gecen sanal seri cihaz.

Bir pty (sahte seri port) acar ve karttaki koprunun (fpga_kopru: cla_kopru_cekirdek +
CLA_Top) protokolunu Python'da uygular. PC tarafi (FpgaKontrolcu) gercek port yerine bu
yola baglanir; boylece pyserial, paketleme, zaman asimi ve sim.py'nin FPGA modu kartsiz
denenir. Icinde secilen programla CLA'nin golden modeli kosar; ADIM'in cevrim sayisi
karttakiyle ayni tanimdir (ilk getirmeden boru hatti bosalana kadar; kart ile golden'in
esitligi fpga_kopru/tb/kopru_testi.py'de dogrulandi).

UART hizi da taklit edilir: cevap, istek + cevap baytlarinin 921600 baud'da
alacagi sure kadar geciktirilir (USB gecikmesi haric).

    .venv/bin/python sanal_fpga.py                  # ic_kestirim.casm (sim.py varsayilani)
    .venv/bin/python sanal_fpga.py --mimari ic      # ic_dongu.casm (sim.py --sensor ideal)
    .venv/bin/python sanal_fpga.py --rtl            # golden yerine RTL (Verilator, fpga_kopru/tb)

RtlFpga: ayni pty, ama paketler karttaki RTL'in simulasyonuna gider (kv260_b_top = kopru +
CLA_Top, Verilator; fpga_kopru/tb/tb_kopru_cla.sv). Baytlar, kartta ARM aktaricisinin yaptigi
gibi AXI4-Lite'tan koprunun VERI/CEVAP yazmaclarina yazilip okunur. Verilator 5 gerekir.
"""
import os
import select
import subprocess
import sys
import tempfile
import threading
import time
import tty

import paket
import uart_protokol as U


class SanalFpga(object):
    def __init__(self, model="hizli", baud=921600, hiz_taklidi=True, duzen=None):
        from kontrolcu import GoldenKontrolcu
        self.ana, self.uydu = os.openpty()
        tty.setraw(self.uydu)
        self.yol = os.ttyname(self.uydu)
        self.baud, self.hiz_taklidi = baud, hiz_taklidi
        self.duzen = duzen or paket.ICK
        self.golden = GoldenKontrolcu(duzen=self.duzen, model=model)
        self.istek_sayisi = 0
        self._dur = False
        self._is = threading.Thread(target=self._dongu, daemon=True)
        self._is.start()

    # ---------------------------------------------------------- bellek
    def _m2c_yaz(self, ofs, kelimeler):
        for i, k in enumerate(kelimeler):
            self.golden.mem.write16(U.M2C_TABAN + ofs + i, k, who="cpu")

    def _c2m(self, ofs, n):
        return [self.golden.mem.read16(U.C2M_TABAN + ofs + i, who="cpu") for i in range(n)]

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
            cevrim = self.golden.gorev_kostur()
            k = self._c2m(0, veri[1])
            return U.ADIM, b"".join(bytes([w & 0xFF, w >> 8]) for w in k) + cevrim.to_bytes(4, "little")
        if tip == U.OKU:
            if n != 2 or veri[1] > U.EN_COK_CEVAP or veri[0] + veri[1] > U.RAM_KELIME:
                return hata(4)
            return U.OKU, b"".join(bytes([w & 0xFF, w >> 8]) for w in self._c2m(veri[0], veri[1]))
        if tip == U.SIFIRLA:
            if n:
                return hata(4)
            self.golden.st.__init__()       # kartta: CLA yazmaclari sifirlanir, RAM'ler korunur
            return U.SIFIRLA, b""
        return hata(2)

    def yanit(self, ham):
        """Bir istek paketi (baslik dahil) -> cevap paketi."""
        tip, n = ham[1], ham[2]
        veri, s = ham[3:3 + n], ham[3 + n]
        if s != U.saglama(tip, veri):
            ctip, cveri = U.HATA, b"\x01"
        else:
            ctip, cveri = self.isle(tip, veri)
        return U.cerceve(ctip, cveri, bas=U.CEVAP)

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
                ham = bytes(tampon[:4 + n])
                del tampon[:4 + n]
                cevap = self.yanit(ham)
                self.istek_sayisi += 1
                if self.hiz_taklidi:
                    time.sleep((n + 4 + len(cevap)) * 10.0 / self.baud)
                os.write(self.ana, cevap)

    def kapat(self):
        self._dur = True
        self._is.join(timeout=1)
        os.close(self.ana)
        os.close(self.uydu)


class RtlFpga(SanalFpga):
    """Paketleri karttaki RTL'in Verilator simulasyonuna iletir (fpga_kopru/tb/tb_kopru_cla.sv).
    Tezgah istekleri bir FIFO'dan okur, cevaplari obur FIFO'ya yazar; CLA programi L3'e
    bitstream'deki gibi PROGRAM_HEX ile girer (duzene gore derlenir)."""

    def __init__(self, baud=921600, hiz_taklidi=False, duzen=None):
        kok = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
        sys.path.insert(0, os.path.join(kok, "fpga_kopru", "tb"))
        import kopru_testi
        self.duzen = duzen or paket.ICK
        print("RTL derleniyor (%s)..." % os.path.basename(self.duzen.casm))
        tb = kopru_testi.derle(kopru_testi.l3_hazirla(self.duzen), self.duzen.ad)
        self._gecici = tempfile.mkdtemp(prefix="cla_rtl_")
        istek, cevap = os.path.join(self._gecici, "istek"), os.path.join(self._gecici, "cevap")
        os.mkfifo(istek)
        os.mkfifo(cevap)
        self._tb = subprocess.Popen([tb, "+ISTEK=" + istek, "+CEVAP=" + cevap], cwd=os.path.join(kok, "rtl", "alu"),
                                    stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
        self._yaz = open(istek, "w")            # tezgahla ayni sirada ac: once istek, sonra cevap
        self._oku = open(cevap, "r")
        self.ana, self.uydu = os.openpty()
        tty.setraw(self.uydu)
        self.yol = os.ttyname(self.uydu)
        self.baud, self.hiz_taklidi = baud, hiz_taklidi
        self.istek_sayisi = 0
        self._dur = False
        self._is = threading.Thread(target=self._dongu, daemon=True)
        self._is.start()

    def yanit(self, ham):
        self._yaz.write("%d %s\n" % (len(ham), " ".join("%02x" % b for b in ham)))
        self._yaz.flush()
        satir = self._oku.readline()
        if not satir:
            raise RuntimeError("RTL tezgahi durdu: %s" % self._tb.stderr.read().decode()[-300:])
        return bytes(int(x, 16) for x in satir.split()[1:])

    def kapat(self):
        super().kapat()
        for f in (self._yaz, self._oku):
            try:
                f.close()
            except OSError:
                pass
        try:
            self._tb.wait(timeout=5)
        except subprocess.TimeoutExpired:
            self._tb.kill()
        for ad in ("istek", "cevap"):
            os.remove(os.path.join(self._gecici, ad))
        os.rmdir(self._gecici)


def main():
    sys.dont_write_bytecode = True
    mimari = sys.argv[sys.argv.index("--mimari") + 1] if "--mimari" in sys.argv else "ick"
    s = (RtlFpga if "--rtl" in sys.argv else SanalFpga)(duzen=paket.DUZENLER[mimari])
    print("sanal KV260 (%s, %s, %s) hazir: %s" % ("RTL" if "--rtl" in sys.argv else "golden", mimari,
                                                os.path.basename(s.duzen.casm), s.yol))
    print("ornek:  .venv/bin/python sim.py --kontrolcu fpga --port %s%s"
          % (s.yol, " --sensor ideal" if mimari == "ic" else ""))
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n%d istek islendi" % s.istek_sayisi)
        s.kapat()


if __name__ == "__main__":
    main()
