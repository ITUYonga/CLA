# -*- coding: utf-8 -*-
"""Kontrolcu arka uclari.

Simulasyon yalniz `Kontrolcu.adim(girdiler) -> ciktilar` arayuzunu bilir.
Girdi ve cikti float32 BITLERIDIR (int); boylece golden ile FPGA'nin
cevaplari bit bit karsilastirilabilir.

    GoldenKontrolcu : duzenin CLA programi (varsayilan ic_kestirim.casm) golden modelde
                      (../../golden_model/core.py) kosar.
    FpgaKontrolcu   : ayni degerler UART ile KV260'a gider (uart_protokol.py); kartta
                      fpga_kopru (kopru + CLA_Top), program bitstream'e gomulu. Kart
                      yokken sanal_fpga.SanalFpga'ya da baglanabilir.
    IkiliKontrolcu  : ikisini birden kosturur; ciktilari ve cevrim sayisini bit bit karsilastirir.
"""
import os
import sys
import time

import paket
import uart_protokol as U

BURASI = os.path.dirname(os.path.abspath(__file__))
VARSAYILAN_GOLDEN = os.environ.get(
    "CLA_GOLDEN", os.path.join(BURASI, "..", "..", "golden_model"))


class Kontrolcu(object):
    ad = "?"
    cevrim = 0              # son gorevin CLA cevrim sayisi
    tur_ms = None           # PC'den FPGA'ya gidis-donus [ms] (yalniz UART)

    def kapat(self):
        pass

    def parametreleri_yukle(self, degisen=None):
        raise NotImplementedError

    def adim(self, girdiler):
        """girdiler: duzen.girdiler sirasinda float32 bitleri.
        Doner: duzen.ciktilar sirasinda float32 bitleri."""
        raise NotImplementedError


class GoldenKontrolcu(Kontrolcu):
    """CLA'nin golden modeli. model="boru": 8 kademeli boru hatti (altin
    referans, cevrim dogru); model="ardisik": ayni sonuc, daha hizli;
    model="hizli": degerler ardisik modelden, cevrim sayisi bir kez boru hatti
    modelinde olculur (programlar dalsiz, cevrim sabit: test_kontrolcu.py)."""

    def __init__(self, duzen=None, golden_kok=VARSAYILAN_GOLDEN, model="boru", degisen=None):
        sys.dont_write_bytecode = True
        kok = os.path.abspath(golden_kok)
        if kok not in sys.path:
            sys.path.insert(0, kok)
        from core import assemble, ClaState, ClaMemory, ClaCore, Pipeline, ClaRegs, TaskArbiter, denetle, HATA

        self.duzen = duzen = duzen or paket.IC
        metin = open(duzen.casm, encoding="utf-8").read()
        sem = duzen.semboller()
        words = assemble(metin, semboller=sem)
        hatalar = [b for b in denetle(metin, sem, words) if b.agirlik == HATA]
        if hatalar:
            raise ValueError("%s lint hatasi:\n" % os.path.basename(duzen.casm) + "\n".join(map(str, hatalar)))
        self.komut_sayisi = len(words)

        self.st, self.mem = ClaState(), ClaMemory()
        self.mem.load_program(words)
        self.regs = ClaRegs()
        self.regs.cpu_write(0x00, 0)        # MVECT1 = programin basi
        self.regs.cpu_write(0x25, 0x01)     # MIER: gorev 1
        self.hakem = TaskArbiter(self.regs)
        boru = Pipeline(self.st, self.mem) if model == "boru" else None
        self.sabit_cevrim = None
        if model == "hizli":
            olcer = GoldenKontrolcu(duzen=duzen, golden_kok=golden_kok, model="boru", degisen=degisen)
            olcer.adim([paket.f2b(v) for v in duzen.ornek])
            self.sabit_cevrim = olcer.cevrim
        self.cekirdek = ClaCore(self.st, self.mem, boru, arbiter=self.hakem)
        self.model = model
        self.ad = "CLA golden modeli (%s)" % {"boru": "boru hattı", "ardisik": "ardışık",
                                               "hizli": "hızlı"}.get(model, model)
        self.cevrim = 0                     # son gorevin cevrim sayisi
        self.tur_ms = None                  # yalniz FPGA'da anlamli
        self.parametreleri_yukle(degisen)

    def parametreleri_yukle(self, degisen=None):
        for adr, bit in self.duzen.parametre_bitleri(degisen):
            self.mem.write32(adr, bit, who="cpu")

    def gorev_kostur(self):
        """CPU'nun yaptigi gibi: MIFRC ile gorev 1, bitene kadar kostur."""
        self.regs.cpu_write(0x22, 0x01)
        kosan = self.cekirdek.run_tasks()
        self.cevrim = kosan[-1][1] if kosan else 0
        if self.sabit_cevrim is not None:
            self.cevrim = self.sabit_cevrim     # boru hatti modelinde olculen sabit sure
        self.hakem.pie_kesmeleri.clear()
        return self.cevrim

    def adim(self, girdiler):
        for (_, adr, _), bit in zip(self.duzen.girdiler, girdiler):
            self.mem.write32(adr, bit, who="cpu")
        self.gorev_kostur()
        return [self.mem.read32(adr) for _, adr, _ in self.duzen.ciktilar]


class ProgramUyusmazligi(U.ProtokolHatasi):
    """Karttaki CLA programi secilen duzenle ayni degil (yanlis bitstream)."""


_beklenen = {}


def beklenen_cevrim(duzen):
    """Duzenin CLA gorevinin cevrim sayisi (golden boru hatti). Programlar dalsiz: her adimda ayni,
    ve kart (fpga_kopru) ayni tanimla sayar: ilk getirmeden boru hatti bosalana kadar."""
    if duzen.ad not in _beklenen:
        g = GoldenKontrolcu(duzen=duzen, model="boru")
        g.adim([paket.f2b(v) for v in duzen.ornek])
        _beklenen[duzen.ad] = g.cevrim
    return _beklenen[duzen.ad]


def _bitisik(liste, taban):
    """Sembol listesi ardisik 32 bitlik adreslerde mi? -> ilk ofset."""
    adr = [x[1] for x in liste]
    if adr != list(range(adr[0], adr[0] + 2 * len(adr), 2)):
        raise ValueError("paket adresleri bitisik degil: %s" % [hex(a) for a in adr])
    return U.adr_ofs(adr[0], taban)


def kv260_bul(baud=921600, sure=0.4):
    """Seri portlari tek tek dener; YANKI'ya dogru cevap veren ilk portu dondurur.
    KV260'in micro-USB'si (FTDI) birden cok port acar; aktarici bunlardan birinde."""
    import serial
    from serial.tools import list_ports
    adaylar = [p.device for p in list_ports.comports()
               if any(k in p.device for k in ("usbserial", "usbmodem", "ttyUSB", "ttyACM", "COM"))]
    denenen = []
    for d in sorted(adaylar):
        try:
            with serial.Serial(d, baud, timeout=0.05, write_timeout=0.2) as s:
                s.reset_input_buffer()
                s.write(U.yanki_istegi(b"KV260?"))
                coz, bitis = U.Cozucu(), time.perf_counter() + sure
                while time.perf_counter() < bitis:
                    for tip, veri in coz.ekle(s.read(64)):
                        if tip == U.YANKI and veri == b"KV260?":
                            return d
        except Exception as e:              # mesgul port, izin, bozuk cerceve: siradakine gec
            denenen.append("%s (%s)" % (d, str(e)[:40]))
            continue
        denenen.append(d)
    raise U.ProtokolHatasi("KV260 bulunamadi; denenen portlar: %s" % (", ".join(denenen) or "yok"))


class FpgaKontrolcu(Kontrolcu):
    """KV260'taki CLA: micro-USB -> ARM aktarici -> fpga_kopru (cla_kopru_cekirdek + CLA_Top).

    port: 'auto' (KV260'i kendisi bulur), '/dev/cu.usbserial-XXXX' (macOS), 'COM5' (Windows)
    ya da sanal_fpga'nin pty yolu. Her adim tek ADIM paketi: girdiler M2C'ye, gorev 1 kosar,
    ciktilar ve gorevin cevrim sayisi doner. CLA programi bitstream'e gomulu oldugu icin
    acilista denetlenir (program_denetle): yanlis bitstream anlasilir bir hatayla durur."""

    def __init__(self, port, baud=921600, duzen=None, degisen=None, zaman_asimi=0.25, pty=False, denetle=True):
        import serial
        if port == "auto":
            port = kv260_bul(baud)
        self.port = port
        # pty'de hiz anlamsiz; macOS 921600 gibi standart disi hizi pty'ye kuramaz
        self.ser = serial.Serial(port, 115200 if pty else baud, timeout=0.02, write_timeout=zaman_asimi)
        self.zaman_asimi = zaman_asimi
        self.coz = U.Cozucu()
        self.ad = "KV260 FPGA (%s)" % os.path.basename(port)
        self.cevrim, self.tur_ms, self.hata_sayisi = 0, 0.0, 0
        self.duzen = duzen = duzen or paket.IC
        self.girdi_ofs = _bitisik(duzen.girdiler, U.M2C_TABAN)
        self.param_ofs = _bitisik(duzen.parametreler, U.M2C_TABAN)
        if _bitisik(duzen.ciktilar, U.C2M_TABAN) != 0:
            raise ValueError("ADIM cevabi C2M[0]'dan baslar; CIKTILAR 0x1480'de baslamali")
        self.ser.reset_input_buffer()
        if self.istek(U.yanki_istegi(b"CLA"), U.YANKI) != b"CLA":
            raise U.ProtokolHatasi("yanki yanlis dondu")
        self.parametreleri_yukle(degisen)
        self.denetim_girdisi = None
        if denetle:
            self.program_denetle()

    def program_denetle(self):
        """Karttaki program secilen duzenin programi mi? Ornek girdiyle bir ADIM: cevrim sayisi
        programi belirler (ick 160, ic 59, tek 207). Sonraki ilk adimda KORU = 0 kestirimi sifirlar;
        IkiliKontrolcu ayni adimi golden'a da kosturur (denetim_girdisi)."""
        beklenen = beklenen_cevrim(self.duzen)
        self.denetim_girdisi = [paket.f2b(v) for v in self.duzen.ornek]
        self.adim(self.denetim_girdisi)
        if self.cevrim == beklenen:
            return
        hex_adi = lambda d: os.path.splitext(os.path.basename(d.casm))[0] + "_l3.hex"      # noqa: E731
        secim = {"ick": "sim.py --sensor gercek (varsayilan)", "ic": "sim.py --sensor ideal"}
        aday = [d for d in paket.DUZENLER.values() if d is not self.duzen and beklenen_cevrim(d) == self.cevrim]
        ipucu, uret = "", "Bitstream'i"
        if aday:
            ipucu = "\n  Karttaki program buyuk olasilikla '%s' (%s)" % (aday[0].ad, hex_adi(aday[0]))
            if aday[0].ad in secim:
                ipucu += "; simulasyonda onu secin: %s" % secim[aday[0].ad]
                uret = "Ya da bitstream'i"
            else:
                ipucu += "; sim.py bu programi kullanmaz"
        raise ProgramUyusmazligi(
            "Karttaki CLA programi '%s' (%s) degil: kart %d cevrim, beklenen %d.%s\n"
            "  %s bu programla uretin (fpga_kopru klasorunden):\n"
            "    vivado -mode batch -source b_yolu/vivado_olustur.tcl -tclargs 4 ../uygulama/drone_sim/%s"
            % (self.duzen.ad, os.path.basename(self.duzen.casm), self.cevrim, beklenen, ipucu, uret,
               hex_adi(self.duzen)))

    def istek(self, bayt, tip):
        self.ser.reset_input_buffer()       # gec gelmis eski cevap yenisiyle karismasin
        self.ser.write(bayt)
        bitis = time.perf_counter() + self.zaman_asimi
        while True:
            gelen = self.coz.ekle(self.ser.read(max(1, self.ser.in_waiting)))
            if gelen:
                return U.cevabi_coz(gelen[-1][0], gelen[-1][1], tip)
            if time.perf_counter() > bitis:
                self.coz = U.Cozucu()
                raise U.ProtokolHatasi("%.0f ms icinde cevap gelmedi" % (self.zaman_asimi * 1e3))

    def parametreleri_yukle(self, degisen=None):
        bitler = [b for _, b in self.duzen.parametre_bitleri(degisen)]
        self.istek(U.yaz_istegi(self.param_ofs, U.kelimelere(bitler)), U.YAZ)

    def adim(self, girdiler):
        t0 = time.perf_counter()
        kel, self.cevrim = self.istek(
            U.adim_istegi(self.girdi_ofs, 2 * len(self.duzen.ciktilar), U.kelimelere(girdiler)), U.ADIM)
        self.tur_ms = (time.perf_counter() - t0) * 1e3
        return U.degerlere(kel)

    def kapat(self):
        self.ser.close()


class IkiliKontrolcu(Kontrolcu):
    """Drone'u FPGA surer; ayni girdiler golden'a da gider, ciktilar bit bit
    karsilastirilir. fark_sayisi > 0 ise RTL ile golden ayrismis demektir.
    Golden boru hatti modelindeyse gorevin cevrim sayisi da karsilastirilir
    (RTL boru hattinin cevrim dogrulugu)."""

    def __init__(self, fpga, golden):
        self.fpga, self.golden = fpga, golden
        self.duzen = golden.duzen
        if getattr(fpga, "denetim_girdisi", None):         # acilis denetim adimi: golden da ayni adimi kossun
            golden.adim(fpga.denetim_girdisi)
        self.ad = "%s + golden" % fpga.ad
        self.fark_sayisi, self.son_fark = 0, None
        self.cevrim_farki = 0 if golden.model in ("boru", "hizli") else None

    def parametreleri_yukle(self, degisen=None):
        self.fpga.parametreleri_yukle(degisen)
        self.golden.parametreleri_yukle(degisen)

    def adim(self, girdiler):
        c = self.fpga.adim(girdiler)
        g = self.golden.adim(girdiler)
        if c != g:
            self.fark_sayisi += 1
            self.son_fark = [(ad, "%08X" % a, "%08X" % b)
                             for (ad, _, _), a, b in zip(self.duzen.ciktilar, c, g) if a != b]
        if self.cevrim_farki is not None and self.fpga.cevrim != self.golden.cevrim:
            self.cevrim_farki += 1
        return c

    @property
    def cevrim(self):
        return self.fpga.cevrim

    @property
    def tur_ms(self):
        return self.fpga.tur_ms

    @property
    def golden_cevrim(self):
        return self.golden.cevrim
