#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""FPGA kabul testi icin golden paket ureticisi.

    python3.11 golden_beklenen.py test.casm [-o cikti_klasoru] [--golden CLA_GoldenModel] [--zorla]

test.casm, normal CASM kaynagi + yorum satirinda yonergeler:
    ;#sembol  _A  0x8800          veri sembolu (@_A)
    ;#veri    0x8800 0x3FC00000   baslangic bellegi, 32 bit (tek adres alttaki cifte hizalanir)
    ;#veri16  0x1500 0x1234       baslangic bellegi, 16 bit
    ;#gorev   1 GOREV1            gorev 1 GOREV1 etiketinden baslar (MVECT1); yoksa gorev 1 = 0
Butun gorevler ayni anda tetiklenir (MIFRC), hakem oncelik sirasiyla kosar.

Golden boru hatti FPU K1/K2, interlock (dur_exe), R1/W durmasi (dur_r1) ve
D2 kuralini uyguluyor (model_kararlari §51): golden.trace RTL/FPGA iziyle cevrim
cevrim karsilastirilabilir (tools/compare_trace.py).

Lint:
    HATA         program reddedilir (cikis 1); dosyalar yine yazilir. --zorla ile
                 yalniz uyari olur (TRM kenar durumlarini bilerek deneyen testler).
    S5.2-bayrak  daldan onceki 3 komutta bayrak yazan komut: UYARI. Golden ile
    S5.3-mar     RTL ayni sonucu verir ama program durmalara bagli ve kirilgan.
    COZULEMEDI   dolayli adresle yaz-oku: adreslerin farkli oldugunu elle dogrulayin.

Uretilenler (<ad>_ onekiyle, hepsi $readmemh uyumlu, satir basina 16 bit, alt adres once):
    L3.hex (4096)  L1.hex (1024)  L2.hex (1024)  M2C.hex (CPU->CLA mesaj, 128)  C2M.hex (CLA->CPU, 128)
    yazmac_baslangic.txt          MVECT1..8, MIER, MIFRC, MSTF
    beklenen_L1.hex  beklenen_L2.hex  beklenen_C2M.hex   gorevler bittikten sonraki bellek
    beklenen_yazmac.txt           MR0..3, MAR0..1, MSTF, MPC, MIRUN, MIFR, MIOVF, PIE kesmeleri
    golden.trace                  cevrim basina iz (docs/trace_format.md v1)
Proje dosyalarina yazmaz.
"""
import argparse
import os
import re
import sys

sys.dont_write_bytecode = True

BOLGE = {"L1": 2, "L2": 3, "M2C": 1, "C2M": 0, "L3": 4}       # ClaMemory.regions sirasi


def yonergeler(metin):
    sembol, veri, gorev = {}, [], []
    for satir in metin.splitlines():
        s = satir.strip()
        m = re.match(r";#sembol\s+(\S+)\s+(\S+)", s)
        if m:
            sembol[m.group(1)] = int(m.group(2), 0)
        m = re.match(r";#veri(16)?\s+(\S+)\s+(\S+)", s)
        if m:
            veri.append((int(m.group(2), 0), int(m.group(3), 0), 16 if m.group(1) else 32))
        m = re.match(r";#gorev\s+(\d)\s+(\S+)", s)
        if m:
            gorev.append((int(m.group(1)), m.group(2)))
    return sembol, veri, gorev


def etiket_adresleri(metin):
    """Gecis 1'i tekrarlamadan: assembler'in kendi satir cozumleyicisiyle sayar."""
    from golden_model.assembler import (satir_coz, SAHTE_KOMUTLAR, _sahte_ac,
                                        _devam_satirlarini_birlestir)
    adres, mpc = {}, 0
    for no, satir in enumerate(_devam_satirlarini_birlestir(metin.splitlines()), 1):
        etiket, mn, jet = satir_coz(satir)
        if etiket:
            adres[etiket] = mpc
        if mn:
            mpc += 2 * len(_sahte_ac(mn, jet, no)) if mn in SAHTE_KOMUTLAR else 2
    return adres


def hex_yaz(yol, kelimeler):
    with open(yol, "w", newline="\n") as f:
        f.write("\n".join("%04x" % (w & 0xFFFF) for w in kelimeler) + "\n")


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("kaynak")
    ap.add_argument("-o", "--cikti", default=".")
    ap.add_argument("--golden", default=os.environ.get("CLA_GOLDEN", os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "golden_model")))
    ap.add_argument("--zorla", action="store_true",
                    help="lint HATA'larini uyariya cevir (TRM kenar durumu testleri)")
    a = ap.parse_args(argv)
    sys.path.insert(0, os.path.abspath(a.golden))
    from golden_model.assembler import assemble
    from golden_model.cla_state import ClaState
    from golden_model.cla_memory import ClaMemory
    from golden_model.cla_core import ClaCore
    from golden_model.pipeline import Pipeline
    from golden_model.cla_regs import ClaRegs
    from golden_model.task_arbiter import TaskArbiter
    from golden_model import trace as TR
    from golden_model.lint import denetle, HATA, UYARI, COZULEMEDI

    metin = open(a.kaynak, encoding="utf-8").read()
    ad = os.path.splitext(os.path.basename(a.kaynak))[0]
    os.makedirs(a.cikti, exist_ok=True)
    yol = lambda s: os.path.join(a.cikti, "%s_%s" % (ad, s))      # noqa: E731

    sembol, veri, gorev = yonergeler(metin)
    words = assemble(metin, semboller=sembol)
    bulgu = denetle(metin, sembol, words)
    hatalar = [b for b in bulgu if b.agirlik == HATA]
    durmaya_duyarli = [b for b in bulgu if b.agirlik == UYARI and b.kural in ("S5.2-bayrak", "S5.3-mar")]
    cozulemedi = [b for b in bulgu if b.agirlik == COZULEMEDI]
    for b in bulgu:
        print("  lint: %s" % b)

    st, mem = ClaState(), ClaMemory()
    mem.load_program(words)
    for adr, deger, gen in veri:
        kim = "cpu" if 0x1500 <= adr <= 0x157F else "cla"
        (mem.write32 if gen == 32 else mem.write16)(adr, deger, who=kim)
    regs = ClaRegs()
    etiket = etiket_adresleri(metin)
    if not gorev:
        gorev = [(1, None)]
    maske = 0
    for no, et in gorev:
        regs.cpu_write(no - 1, 0 if et is None else etiket[et])
        maske |= 1 << (no - 1)
    regs.cpu_write(0x25, maske)                       # MIER

    # baslangic goruntuleri (gorevler kosmadan once)
    for b in ("L3", "L1", "L2", "M2C", "C2M"):
        hex_yaz(yol("%s.hex" % b), mem.regions[BOLGE[b]].words)
    with open(yol("yazmac_baslangic.txt"), "w") as f:
        for i in range(8):
            f.write("MVECT%d %03x\n" % (i + 1, regs.mvect[i]))
        f.write("MIER %02x\nMIFRC %02x\nMSTF %08x\n" % (maske, maske, st.mstf))

    regs.cpu_write(0x22, maske)                       # MIFRC: gorevleri tetikle
    arb = TaskArbiter(regs)
    core = ClaCore(st, mem, Pipeline(st, mem), arbiter=arb)
    mem.write_log.clear()
    with open(yol("golden.trace"), "w") as f:
        kosan = TR.iz_al_gorevler(core, f)

    for b in ("L1", "L2", "C2M"):
        hex_yaz(yol("beklenen_%s.hex" % b), mem.regions[BOLGE[b]].words)
    with open(yol("beklenen_yazmac.txt"), "w") as f:
        for i in range(4):
            f.write("MR%d %08x\n" % (i, st.get_mr(i)))
        f.write("MAR0 %04x\nMAR1 %04x\nMSTF %08x\nMPC %03x\n" % (st.get_mar(0), st.get_mar(1), st.mstf, st.mpc))
        f.write("MIRUN %02x\nMIFR %02x\nMIOVF %02x\n" % (regs.mirun, regs.mifr, regs.miovf))
        f.write("PIE %s\n" % " ".join("%02x" % p for p in arb.pie_kesmeleri))
    print("%s: %d komut, %d gorev kostu (MIRUN, cevrim): %s -> %s"
          % (ad, len(words), len(kosan), kosan, os.path.abspath(a.cikti)))
    if cozulemedi:
        print("DIKKAT: %d dolayli adresli yaz-oku bulgusu (COZULEMEDI). Yazilan ve okunan adresin "
              "farkli oldugunu elle dogrulayin; ayniysa programi kabul testinde kullanmayin." % len(cozulemedi))
    if durmaya_duyarli:
        print("UYARI: %d durmaya duyarli kalip (S5.2-bayrak / S5.3-mar). Golden ve RTL ayni sonucu "
              "verir, ama sonuc bellek durmasina bagli; kabul programinda kacinin." % len(durmaya_duyarli))
    if hatalar and not a.zorla:
        print("RED: %d boru hatti kurali ihlali (s.578-580): TRM bu durumda bayat deger / "
              "tanimsiz davranis soyluyor. Kabul testinde kullanmayin (bilerek deniyorsaniz --zorla)."
              % len(hatalar))
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
