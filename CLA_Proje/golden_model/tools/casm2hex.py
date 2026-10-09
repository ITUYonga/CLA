#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""CASM kaynagini RTL'in $readmemh ile okuyacagi hex dosyasina cevirir.

    python3 tools/casm2hex.py gorev.casm -o gorev.hex
    python3 tools/casm2hex.py gorev.casm --doldur 4096             # tam L3
    python3 tools/casm2hex.py gorev.casm --genislik 32 --doldur 4096
                                          # tam L3 -> 2048 satir

NEDEN AYRI BIR ARAC
-------------------
Python modeli programi `assemble()` ciktisindan dogrudan yukluyor; RTL
ise bellegi bir dosyadan okuyor. Iki taraf ayni programi kosmuyorsa iz
karsilastirmasinin hicbir anlami kalmaz. Bu arac o tek kaynagi uretiyor:
ayni `assemble()`, ayni yerlesim.

YERLESIM - `ClaMemory.load_program` ile BIREBIR
-----------------------------------------------
L3 program RAM'i 16-bit word adresli. Her komut 32 bit ve:

    words[2k]   = komut[15:0]    (LSW, DUSUK adres)
    words[2k+1] = komut[31:16]   (MSW)

Varsayilan cikti bu duzeni satir satir basar (16-bit/satir), yani
`$readmemh` 16-bit genisligindeki bir diziye dogrudan okuyabilir.
Komut belleginizi 32-bit genisliginde kurduysaniz `--genislik 32`.

`--doldur N` HER IKI genislikte 16-bit WORD sayisidir (L3'un dogal birimi,
TRM "4K x 16"): 32-bit ciktida N/2 satir uretir. Satir sayisi olsaydi
`--genislik 32 --doldur 4096` L3'un iki katini, 8192 word basardi ve
`$readmemh` 2048 girisli bir diziye tasardi.

L3 kapasitesi (4096 word = 2048 komut; MPC 12 bit) `ClaMemory`'deki
'L3_Prog' bolgesinden okunur - model yuklemeyi reddettigi programi bu
arac da reddeder, iki taraf ayri sinir tutmaz.

Varsayilan olarak YORUMSUZ basar: `$readmemh` yorumlari destekler ama
her arac ayni derecede hosgoru gostermiyor. `--yorum` ile acilir.
"""

import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from golden_model.assembler import assemble, AssemblerError   # noqa: E402
from golden_model.cla_memory import ClaMemory                 # noqa: E402
from golden_model.disassembler import disassemble             # noqa: E402


def _l3_word():
    """L3 kapasitesi (16-bit word), modelin kendi tanimindan."""
    for bolge in ClaMemory().regions:
        if bolge.name == "L3_Prog":
            return bolge.size_word
    raise RuntimeError("ClaMemory'de 'L3_Prog' bolgesi yok - casm2hex "
                       "L3 sinirini bilemez")


L3_WORD = _l3_word()


class Casm2HexHatasi(Exception):
    pass


def sembolleri_coz(cift_listesi):
    """['_ruzgar=0x8800', ...] -> {'_ruzgar': 0x8800}"""
    semboller = {}
    for cift in cift_listesi or []:
        if "=" not in cift:
            raise Casm2HexHatasi("sembol 'ad=adres' biciminde olmali: %r" % cift)
        ad, adres = cift.split("=", 1)
        try:
            semboller[ad.strip()] = int(adres, 0)
        except ValueError:
            raise Casm2HexHatasi("sembol adresi sayi degil: %r" % cift)
    return semboller


def hex_satirlari(wordler, genislik=16, doldur=None, yorum=False):
    """32-bit komut listesini hex satirlarina cevirir.

    `doldur` 16-bit word cinsinden (genislikten bagimsiz) - bkz. modul notu.
    """
    if genislik not in (16, 32):
        raise Casm2HexHatasi("genislik 16 ya da 32 olmali, %r verildi" % genislik)
    program_word = 2 * len(wordler)
    if program_word > L3_WORD:
        raise Casm2HexHatasi(
            "program %d komut = %d word; L3 %d word (%d komut). Model de "
            "bu programi yuklemez (ClaMemory.load_program)."
            % (len(wordler), program_word, L3_WORD, L3_WORD // 2))

    satirlar = []
    for i, w in enumerate(wordler):
        if genislik == 32:
            metin = "%08x" % (w & 0xFFFFFFFF)
            if yorum:
                metin += "   // %03x  %s" % (2 * i, _ad(w))
            satirlar.append(metin)
        else:
            lsw, msw = w & 0xFFFF, (w >> 16) & 0xFFFF
            if yorum:
                satirlar.append("%04x   // %03x  %s" % (lsw, 2 * i, _ad(w)))
                satirlar.append("%04x   // %03x" % (msw, 2 * i + 1))
            else:
                satirlar.append("%04x" % lsw)
                satirlar.append("%04x" % msw)

    if doldur is not None:
        if doldur < program_word:
            raise Casm2HexHatasi(
                "program %d word, --doldur %d bundan kucuk"
                % (program_word, doldur))
        if doldur > L3_WORD:
            raise Casm2HexHatasi(
                "--doldur %d, L3 %d word - L3'ten buyuk bellek goruntusu "
                "anlamsiz (MPC 12 bit)" % (doldur, L3_WORD))
        if genislik == 32 and doldur % 2:
            raise Casm2HexHatasi(
                "--genislik 32 ile --doldur cift olmali (satir = 2 word); "
                "%d verildi" % doldur)
        hedef = doldur if genislik == 16 else doldur // 2
        bos = "%0*x" % (genislik // 4, 0)
        satirlar += [bos] * (hedef - len(satirlar))
    return satirlar


def _ad(word):
    """Yoruma yazilacak insan okunur karsilik; cozulemezse '?'."""
    try:
        return disassemble(word)
    except Exception:
        return "?"


def cevir(kaynak_metin, genislik=16, doldur=None, yorum=False, semboller=None):
    wordler = assemble(kaynak_metin, semboller=semboller)
    return hex_satirlari(wordler, genislik, doldur, yorum), wordler


def main(argv=None):
    ap = argparse.ArgumentParser(description="CASM -> $readmemh hex")
    ap.add_argument("kaynak", help="girdi .casm dosyasi ('-' = stdin)")
    ap.add_argument("-o", "--cikti", help="cikti dosyasi (varsayilan stdout)")
    ap.add_argument("--genislik", type=int, default=16, choices=(16, 32),
                    help="satir basina bit (varsayilan 16 - ClaMemory duzeni)")
    ap.add_argument("--doldur", type=int, default=None,
                    help="goruntuyu sifirla bu kadar 16-bit WORD'e tamamla "
                         "(genislikten bagimsiz; 4096 = tam L3)")
    ap.add_argument("--yorum", action="store_true",
                    help="her satira adres ve komut adini yorum olarak ekle")
    ap.add_argument("--sembol", action="append", metavar="AD=ADRES",
                    help="veri sembolu (birden fazla kez verilebilir)")
    ap.add_argument("--denetle", action="store_true",
                    help="cevirmeden once boru hatti kurallarini denetle; "
                         "hata bulunursa hex URETILMEZ (bkz. casm_lint.py)")
    a = ap.parse_args(argv)

    try:
        metin = sys.stdin.read() if a.kaynak == "-" else \
            open(a.kaynak, encoding="utf-8").read()
        semboller = sembolleri_coz(a.sembol)
        if a.denetle:
            from golden_model.lint import denetle as _denetle, hatalar
            bulgular = _denetle(metin, semboller)
            for b in bulgular:
                sys.stderr.write("%s\n" % b)
            if hatalar(bulgular):
                sys.stderr.write(
                    "HATA: %d boru hatti ihlali - hex uretilmedi\n"
                    % len(hatalar(bulgular)))
                return 1
        satirlar, wordler = cevir(metin, a.genislik, a.doldur, a.yorum, semboller)
    except (AssemblerError, Casm2HexHatasi) as e:
        sys.stderr.write("HATA: %s\n" % e)
        return 2
    except OSError as e:
        sys.stderr.write("HATA: %s\n" % e)
        return 2

    cikti = "\n".join(satirlar) + "\n"
    if a.cikti:
        with open(a.cikti, "w", encoding="utf-8") as f:
            f.write(cikti)
        sys.stderr.write("%d komut -> %d satir (%d bit) -> %s\n"
                         % (len(wordler), len(satirlar), a.genislik, a.cikti))
    else:
        sys.stdout.write(cikti)
    return 0


if __name__ == "__main__":
    sys.exit(main())
