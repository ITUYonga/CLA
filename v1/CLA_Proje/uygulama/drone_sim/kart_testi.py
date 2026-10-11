# -*- coding: utf-8 -*-
"""KV260 kart testi: simulasyondan once karttaki CLA'yi golden modelle karsilastirir.

    python kart_testi.py --port auto                  # kart (karta_yukle.tcl'den sonra)
    python kart_testi.py --port COM5 --adim 5000      # Windows, belirli port
    python kart_testi.py --port auto --sensor ideal   # bitstream'de ic_dongu.casm varsa
    python kart_testi.py --rtl                        # kart yok: karttaki RTL'in Verilator simulasyonu
    python kart_testi.py --sanal                      # kart yok: golden'li sanal KV260

Sinanan (her biri TAMAM / HATA; sonda GECTI ya da KALDI, cikis kodu 0 / 1):
    1 baglanti     KV260 bulunur, YANKI 1, 32 ve 200 bayt
    2 program      parametreler yazilir, karttaki CLA programi secilenle ayni (cevrim sayisi)
    3 adimlar      N adim rastgele girdi: ciktilar bit bit ve CLA cevrim sayisi golden'la ayni
    4 OKU          C2M'nin OKU ile okunan hali son adimin ciktisiyla ayni
    5 SIFIRLA      CLA resetlenir, sonraki adimlar yine golden'la ayni
    6 hata kodlari bozuk saglama (1), bilinmeyen tip (2), yanlis uzunluk (4); sonra kopru calisiyor
    7 hiz          gidis-donus suresi; 500 Hz ic dongu icin 2 ms (asilirsa simulasyon agir cekimde)
"""
import argparse
import random
import statistics
import sys
import time

sys.dont_write_bytecode = True
import paket                                                             # noqa: E402
import uart_protokol as U                                                # noqa: E402
from kontrolcu import FpgaKontrolcu, GoldenKontrolcu, IkiliKontrolcu, ProgramUyusmazligi    # noqa: E402

sonuclar = []


def bildir(ad, tamam, ayrinti=""):
    sonuclar.append(tamam)
    print("%-15s %s  %s" % (ad, "TAMAM" if tamam else "HATA ", ayrinti))


def ham_istek(fpga, bayt, sure=0.5):
    """Istegi gonderir, ilk cevap cercevesini (tip, veri) olarak doner (HATA dahil)."""
    fpga.ser.reset_input_buffer()
    fpga.ser.write(bayt)
    coz, bitis = U.Cozucu(), time.perf_counter() + sure
    while time.perf_counter() < bitis:
        gelen = coz.ekle(fpga.ser.read(max(1, fpga.ser.in_waiting)))
        if gelen:
            return gelen[0]
    return None


def main(argv=None):
    ap = argparse.ArgumentParser(description="KV260 kart testi (golden karsilastirmali)")
    ap.add_argument("--port", help="auto, /dev/cu.usbserial-XXXX, /dev/ttyUSB1, COM5 ...")
    ap.add_argument("--baud", type=int, default=921600)
    ap.add_argument("--adim", type=int, default=2000)
    ap.add_argument("--sensor", choices=("gercek", "ideal"), default="gercek",
                    help="gercek: ic_kestirim.casm (varsayilan bitstream) | ideal: ic_dongu.casm")
    ap.add_argument("--rtl", action="store_true", help="kart yerine RTL simulasyonu (Verilator gerekir)")
    ap.add_argument("--sanal", action="store_true", help="kart yerine golden'li sanal KV260")
    a = ap.parse_args(argv)
    D = paket.ICK if a.sensor == "gercek" else paket.IC
    sanal = None
    if a.rtl or a.sanal:
        from sanal_fpga import RtlFpga, SanalFpga
        sanal = RtlFpga(duzen=D) if a.rtl else SanalFpga(duzen=D, hiz_taklidi=False)
        port, pty = sanal.yol, True
    elif a.port:
        port, pty = a.port, False
    else:
        ap.error("--port gerekli (ya da --rtl / --sanal)")
    print("program: %s, %d adim" % (D.casm.split("/")[-1].split("\\")[-1], a.adim))

    # 1-2 baglanti, parametreler, program denetimi (FpgaKontrolcu acilista yapar)
    try:
        fpga = FpgaKontrolcu(port, a.baud, duzen=D, pty=pty)
    except ProgramUyusmazligi as e:
        bildir("1 baglanti", True, "YANKI tamam")
        bildir("2 program", False, str(e))
        return 1
    except U.ProtokolHatasi as e:
        bildir("1 baglanti", False, str(e))
        return 1
    except OSError as e:
        bildir("1 baglanti", False, "port acilamadi: %s" % e)
        return 1
    tamam = all(fpga.istek(U.yanki_istegi(bytes(range(n))), U.YANKI) == bytes(range(n)) for n in (1, 32, 200))
    bildir("1 baglanti", tamam, "%s, YANKI 1/32/200 bayt" % fpga.port)
    bildir("2 program", True, "%s, %d cevrim (parametreler yazildi)" % (D.ad, fpga.cevrim))

    # 3 adimlar: kart ve golden bit bit
    k = IkiliKontrolcu(fpga, GoldenKontrolcu(duzen=D, model="hizli"))
    r = random.Random(1)
    sure = []
    son = None
    for i in range(a.adim):
        try:
            son = k.adim([paket.f2b(v) for v in D.rastgele_girdi(r)])
        except U.ProtokolHatasi as e:
            bildir("3 adimlar", False, "adim %d: %s" % (i, e))
            return 1
        sure.append(fpga.tur_ms)
    ayrinti = "%d adim, cikti farki %d, cevrim farki %d (cevrim %d)" % (a.adim, k.fark_sayisi, k.cevrim_farki, fpga.cevrim)
    if k.son_fark:
        ayrinti += "; son fark: %s" % k.son_fark[:2]
    bildir("3 adimlar", k.fark_sayisi == 0 and k.cevrim_farki == 0, ayrinti)

    # 4 OKU: C2M son adimin ciktisi
    n = 2 * len(D.ciktilar)
    okunan = fpga.istek(U.oku_istegi(0, n), U.OKU)
    bildir("4 OKU", list(okunan) == list(U.kelimelere(son)), "C2M[0..%d]" % (n - 1))

    # 5 SIFIRLA: kartta CLA yazmaclari sifirlanir; golden'da da
    fpga.istek(U.sifirla_istegi(), U.SIFIRLA)
    k.golden.st.__init__()
    once = k.fark_sayisi, k.cevrim_farki
    for _ in range(100):
        k.adim([paket.f2b(v) for v in D.rastgele_girdi(r)])
    bildir("5 SIFIRLA", (k.fark_sayisi, k.cevrim_farki) == once, "sonra 100 adim golden'la ayni")

    # 6 hata kodlari
    bozuk = bytearray(U.yanki_istegi(b"abc")); bozuk[-1] ^= 0xFF
    beklenen = [(bytes(bozuk), 1), (U.cerceve(0x55, b""), 2), (U.cerceve(U.YAZ, bytes([0, 1, 2, 3])), 4)]
    kodlar = []
    for bayt, kod in beklenen:
        c = ham_istek(fpga, bayt)
        kodlar.append(c[1][0] if c and c[0] == U.HATA and c[1] else None)
    sonra = fpga.istek(U.yanki_istegi(b"tamam"), U.YANKI) == b"tamam"
    bildir("6 hata kodlari", kodlar == [1, 2, 4] and sonra, "beklenen [1, 2, 4], gelen %s; sonra YANKI %s"
           % (kodlar, "tamam" if sonra else "YOK"))

    # 7 hiz
    sure.sort()
    ort, p95, en = statistics.mean(sure), sure[int(0.95 * (len(sure) - 1))], sure[-1]
    print("%-15s %s  gidis-donus ort %.2f ms, %%95 %.2f ms, en cok %.2f ms (500 Hz icin 2 ms)"
          % ("7 hiz", "bilgi", ort, p95, en))
    if p95 > 2.0 and not (a.rtl or a.sanal):
        print("                ipucu: USB seri gecikmesi yuksek; simulasyon agir cekimde calisir (sonuc degismez).")
        print("                Windows: Aygit Yoneticisi > COM portu > Gelismis > Gecikme suresi (Latency Timer) = 1 ms")
        print("                Linux:   echo 1 | sudo tee /sys/bus/usb-serial/devices/ttyUSBx/latency_timer")
        print("                ya da simulasyonu --ic-hz 250 / 100 ile calistirin.")

    fpga.kapat()
    if sanal:
        sanal.kapat()
    gecti = all(sonuclar)
    print("SONUC: %s" % ("GECTI - simulasyon: python sim.py --kontrolcu ikisi --port %s%s"
                         % (a.port or "auto", " --sensor ideal" if a.sensor == "ideal" else "") if gecti else "KALDI"))
    return 0 if gecti else 1


if __name__ == "__main__":
    sys.exit(main())
