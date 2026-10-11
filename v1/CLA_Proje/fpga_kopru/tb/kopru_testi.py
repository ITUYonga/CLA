# -*- coding: utf-8 -*-
"""Kopru + CLA_Top (kv260_b_top) uctan uca testi: kartta FpgaKontrolcu'nun gonderecegi paketlerin aynisi
tezgaha verilir (YANKI, parametre YAZ, N adet ADIM); her ADIM'in ciktilari ve CLA cevrim sayisi
golden'la (core.py, boru hatti modeli) bit bit karsilastirilir.

    python3 kopru_testi.py [adim sayisi] [mimari ...]     (bu klasorden; Verilator 5 gerekir)
    ornek: python3 kopru_testi.py 200 ick ic tek
"""
import os
import random
import shutil
import subprocess
import sys

BURASI = os.path.dirname(os.path.abspath(__file__))
KOK = os.path.normpath(os.path.join(BURASI, "..", ".."))
DRONE = os.path.join(KOK, "uygulama", "drone_sim")
sys.dont_write_bytecode = True
sys.path.insert(0, DRONE)
sys.path.insert(0, os.path.join(KOK, "golden_model"))
import core                                              # noqa: E402
import paket                                             # noqa: E402
import uart_protokol as U                                # noqa: E402
from kontrolcu import GoldenKontrolcu, _bitisik         # noqa: E402

RTL = os.path.join(KOK, "rtl")
KAYNAK = ([os.path.join(RTL, "kontrol", f) for f in ("cla_pkg.sv", "cla_decoder.sv", "cla_ctrl_gen.sv", "cla_gorev_denetci.sv")] +
          [os.path.join(RTL, "yazmac_bellek", f) for f in ("cla_data_ram.sv", "cla_mvect_regs.sv")] +
          sorted(os.path.join(d, f) for d, _, fs in os.walk(os.path.join(RTL, "alu")) for f in fs if f.endswith(".sv")) +
          sorted(os.path.join(RTL, "top", f) for f in os.listdir(os.path.join(RTL, "top")) if f.endswith(".sv")) +
          [os.path.join(KOK, "fpga_kopru", "rtl", f) for f in ("cla_kopru_cekirdek.sv", "cla_axi_kopru.sv", "kv260_b_top.sv")] +
          [os.path.join(BURASI, "tb_kopru_cla.sv")])


def derle(l3_hex, ad):
    obj = os.path.join(BURASI, "obj_" + ad)
    shutil.rmtree(obj, ignore_errors=True)  # yeniden derleme: eski bagimlilik dosyasi "kayan_nokta birimi"deki boslukta make'i bozuyor
    komut = ["verilator", "--binary", "--timing", "-Wno-fatal", "-Wno-lint", "-Wno-style", "--top-module", "tb_kopru_cla",
             "-GPROG=\"%s\"" % l3_hex, "-Mdir", obj] + KAYNAK
    r = subprocess.run(komut, capture_output=True, text=True)
    if r.returncode != 0:
        hata = [l for l in (r.stdout + r.stderr).splitlines() if "rror" in l]
        raise SystemExit("derleme hatasi:\n" + "\n".join(hata[:20] or (r.stdout + r.stderr).splitlines()[-20:]))
    return os.path.join(obj, "Vtb_kopru_cla")


def l3_hazirla(duzen):
    """Duzenin programi -> tam L3 goruntusu (4096 x 16 bit), bu klasorde <ad>_l3_tam.hex."""
    metin = open(duzen.casm, encoding="utf-8").read()
    satirlar, _ = core.cevir(metin, 16, 4096, semboller=duzen.semboller())
    l3 = os.path.join(BURASI, duzen.ad + "_l3_tam.hex")
    open(l3, "w").write("\n".join(satirlar) + "\n")
    return l3


def test(mimari, adim, tohum=1):
    duzen = paket.DUZENLER[mimari]
    tb = derle(l3_hazirla(duzen), mimari)

    golden = GoldenKontrolcu(duzen=duzen, model="boru")
    girdi_ofs = _bitisik(duzen.girdiler, U.M2C_TABAN)
    param_ofs = _bitisik(duzen.parametreler, U.M2C_TABAN)
    istekler = [(U.yanki_istegi(b"CLA"), U.YANKI),
                (U.yaz_istegi(param_ofs, U.kelimelere([b for _, b in duzen.parametre_bitleri()])), U.YAZ)]
    r = random.Random(tohum)
    beklenen = []
    for _ in range(adim):
        girdi = [paket.f2b(v) for v in duzen.rastgele_girdi(r)]
        istekler.append((U.adim_istegi(girdi_ofs, 2 * len(duzen.ciktilar), U.kelimelere(girdi)), U.ADIM))
        beklenen.append((golden.adim(girdi), golden.cevrim))
    ist = os.path.join(BURASI, mimari + "_istek.txt")
    cev = os.path.join(BURASI, mimari + "_cevap.txt")
    with open(ist, "w") as f:
        for b, _ in istekler:
            f.write("%d %s\n" % (len(b), " ".join("%02x" % x for x in b)))
    sim = subprocess.run([tb, "+ISTEK=" + ist, "+CEVAP=" + cev], capture_output=True, text=True, cwd=os.path.join(KOK, "rtl", "alu"))
    if sim.returncode != 0:
        raise SystemExit("simulasyon hatasi:\n" + sim.stdout[-2000:])
    cevaplar = []
    for satir in open(cev):
        p = satir.split()
        cevaplar += U.Cozucu().ekle(bytes(int(x, 16) for x in p[1:]))
    if len(cevaplar) != len(istekler):
        raise SystemExit("%d istek, %d cevap" % (len(istekler), len(cevaplar)))
    if U.cevabi_coz(cevaplar[0][0], cevaplar[0][1], U.YANKI) != b"CLA":
        raise SystemExit("YANKI yanlis")
    U.cevabi_coz(cevaplar[1][0], cevaplar[1][1], U.YAZ)
    fark_cikti = fark_cevrim = 0
    for i, ((tip, veri), (g_cikti, g_cevrim)) in enumerate(zip(cevaplar[2:], beklenen)):
        kel, cevrim = U.cevabi_coz(tip, veri, U.ADIM)
        cikti = U.degerlere(kel)
        if cikti != g_cikti:
            fark_cikti += 1
            if fark_cikti <= 3:
                print("  adim %d cikti: kart %s golden %s" % (i, [hex(x) for x in cikti], [hex(x) for x in g_cikti]))
        if cevrim != g_cevrim:
            fark_cevrim += 1
            if fark_cevrim <= 3:
                print("  adim %d cevrim: kart %d golden %d" % (i, cevrim, g_cevrim))
    print("%-4s %d adim: cikti farki %d, cevrim farki %d (cevrim %s)"
          % (mimari, adim, fark_cikti, fark_cevrim, sorted(set(c for _, c in beklenen))))
    return fark_cikti + fark_cevrim


if __name__ == "__main__":
    adim = int(sys.argv[1]) if len(sys.argv) > 1 else 100
    mimariler = sys.argv[2:] or ["ick", "ic", "tek"]
    toplam = sum(test(m, adim) for m in mimariler)
    print("SONUC: %s" % ("GECTI" if toplam == 0 else "KALDI (%d fark)" % toplam))
    sys.exit(0 if toplam == 0 else 1)
