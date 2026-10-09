"""Cozulmus komutu okunabilir metne cevirir.

Neden ayri dosya: decoder.py word -> yapi donusumunu yapiyor, burasi
yapi -> metin. Ikisi bagimsiz test edilebiliyor ve assembler'in
round-trip testi (assemble(disassemble(w)) == w) buradan besleniyor.

Neden 80 dalli if/else yok: tablodaki 'syntax' alani zaten bir sablon.
"MADDF32 MRa, MRb, MRc" icindeki MRa/MRb/MRc yer tutucularini cozulmus
operand degerleriyle degistirmek yetiyor. Yeni bir komut tabloya
eklendiginde bu dosyaya dokunmak gerekmez.
"""

import re

from .decoder import decode
from .isa_table import load_table

# Tablo 10-9, s.586. Listelenmeyen degerler ayrilmis.
CNDF_ADLARI = {
    0b0000: "NEQ",   # ZF == 0
    0b0001: "EQ",    # ZF == 1
    0b0010: "GT",    # ZF == 0 AND NF == 0
    0b0011: "GEQ",   # NF == 0
    0b0100: "LT",    # NF == 1
    0b0101: "LEQ",   # ZF == 1 OR NF == 1
    0b1010: "TF",    # TF == 1
    0b1011: "NTF",   # TF == 0
    0b1100: "LU",    # LUF == 1
    0b1101: "LV",    # LVF == 1
    0b1110: "UNC",   # kosulsuz
    0b1111: "UNCF",  # kosulsuz, bayrak degistirmez
}

# Tablo 10-6, s.584
ADRESLEME_DOGRUDAN = 0b0000
ADRESLEME_MAR0 = 0b0001
ADRESLEME_MAR1 = 0b0010


def _isaretli(deger, genislik=16):
    """Ham biti isaretli tam sayiya cevirir (0xFFFE -> -2)."""
    ust = 1 << (genislik - 1)
    return deger - (1 << genislik) if deger & ust else deger


def _mar_adi(kayit):
    """MARx'in MAR0 mi MAR1 mi oldugunu bulur.

    Sozdizimi ikisini ayirt etmiyor; ayrim sabit bitte. Iki kaynak var:
      1. Kilavuzun opcode satirindaki not ("opcode of MMOVI16 MAR0, #16I")
      2. Not yoksa: ayni sozdizimine sahip kayitlar arasinda match'i
         kucuk olan MAR0 (secim biti 0), buyuk olan MAR1
    """
    not_ = kayit.get("note")
    if not_:
        bulunan = re.search(r"MAR([01])", not_)
        if bulunan:
            return "MAR" + bulunan.group(1)

    kardesler = sorted(k["match"] for k in load_table()
                       if k["syntax"] == kayit["syntax"])
    return "MAR0" if kayit["match"] == kardesler[0] else "MAR1"


def _bellek(kayit, alanlar):
    """mem16 / mem32 yer tutucusunu adresleme kipine gore yazar.

    TUZAK: 'm' alani kipe gore iki farkli sey (s.584 Tablo 10-6).
    Dogrudan kipte 16-bit adres, dolayli kipte ISARETLI artis miktari.
    """
    kip = alanlar.get("addr")
    m = alanlar.get("m", 0)
    if kip == ADRESLEME_DOGRUDAN:
        return "@0x%04X" % m
    if kip == ADRESLEME_MAR0:
        return "*MAR0[%d]++" % _isaretli(m)
    if kip == ADRESLEME_MAR1:
        return "*MAR1[%d]++" % _isaretli(m)
    return "*<ayrilmis kip 0x%X>" % (kip if kip is not None else 0)


def _kosul(alanlar):
    ham = alanlar.get("cndf", alanlar.get("CNDF"))
    if ham is None:
        return None
    return CNDF_ADLARI.get(ham, "CNDF=0x%X" % ham)


def disassemble(hedef):
    """32-bit word ya da DecodedInstruction -> metin.

    Ornek: 0x7C200036 -> "MADDF32 MR2, MR1, MR3"
    """
    d = decode(hedef) if isinstance(hedef, int) else hedef
    kayit, alanlar = d.entry, d.fields
    metin = d.syntax

    # Kosul once: "{, CNDF}" ve "{CNDF}" kaliplarini temizle ki sonraki
    # degistirmeler suslu parantez artigiyla ugrasmasin.
    kosul = _kosul(alanlar)
    kalip = re.search(r"\s*\{\s*(,?)\s*CNDF\s*\}", metin)
    if kalip:
        # "{, CNDF}" virgullu, "{CNDF}" virgulsuz - yazim ikisinde farkli
        ayirac = ", " if kalip.group(1) else " "
        ek = (ayirac + kosul) if kosul else ""
        metin = metin[:kalip.start()] + ek + metin[kalip.end():]
    elif "CNDF" in metin and kosul:
        metin = metin.replace("CNDF", kosul)

    # Bellek operandlari (adresleme kipini kullanir)
    if "mem32" in metin or "mem16" in metin:
        yazim = _bellek(kayit, alanlar)
        metin = metin.replace("mem32", yazim).replace("mem16", yazim)

    # MARx -> MAR0 / MAR1
    if "MARx" in metin:
        metin = metin.replace("MARx", _mar_adi(kayit))

    # Immediate'ler. Uzun jetonlar once, kisa olan uzunun icinde gecmesin.
    imm = alanlar.get("I")
    if imm is not None:
        for jeton in ("#16FHiHex", "#16FLoHex", "#32FHex", "#16FHi", "#16I"):
            metin = metin.replace(jeton, "#0x%04X" % imm)

    if "#SHIFT" in metin and "shift" in alanlar:
        # Tablo 10-7: kodlama 0 -> 1 bit kaydirma
        metin = metin.replace("#SHIFT", "#%d" % (alanlar["shift"] + 1))

    if "16BitDest" in metin and "dest" in alanlar:
        metin = metin.replace("16BitDest", "%d" % _isaretli(alanlar["dest"]))

    # MSETFLG FLAG, VALUE
    if "FLAG" in metin and "F" in alanlar:
        metin = metin.replace("FLAG", "0x%02X" % alanlar["F"])
    if "VALUE" in metin and "V" in alanlar:
        metin = metin.replace("VALUE", "0x%02X" % alanlar["V"])

    # Yazmaclar en son: MRa..MRf. Uzun eslesme sorunu yok, hepsi 3 karakter.
    for harf in "abcdef":
        if "MR" + harf in metin and harf in alanlar:
            metin = metin.replace("MR" + harf, "MR%d" % alanlar[harf])

    # MMOV16 MARx, MRa, #16I icindeki MRa alani 'A' olarak kodlanmis
    if "MRa" in metin and "A" in alanlar:
        metin = metin.replace("MRa", "MR%d" % alanlar["A"])

    return metin
