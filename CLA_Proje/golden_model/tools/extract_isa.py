# -*- coding: utf-8 -*-
"""SPRUI10A Bolum 10.6.3'ten CLA Type-0 komut tablosunu cikarir.

Kullanim:
    pdftotext -q "Texas Instrument CLA.pdf" cla.txt
    python tools/extract_isa.py cla.txt > isa/cla_type0.yaml

Cikti: her komut icin sozdizimi, opcode maskesi, operand alanlari,
etkilenen bayraklar, pipeline notu ve kilavuz sayfasi.
"""
import io
import re
import sys

# pdftotext'in bozuk cikardigi desenler (bosluk kaymasi).
# Duzeltme, ayni ailedeki temiz desenlerden dogrulandi:
# MAND32 / MMPYF32 / MOR32 / MSUB32 / MSUBF32 / MXOR32 hepsi 0000000000ccbbaa.
ELLE_DUZELTME = {
    # 21.09: s.590'in MSW'si de hatali (0x7EC0 -> MF32TOUI16R ile cakisiyordu).
    # cl2000 0x7CC0 kodluyor. 'yorum' satirlari yaml'a kaydin icine yazilir.
    "MADD32 MRa, MRb, MRc":  {"lsw": "0000000000ccbbaa",
                              "msw": "0111110011000000",
                              "yorum": (
        'DIKKAT - TRM s.590 "MSW: 0111 1110 1100 0000" (0x7EC0) yaziyor, YANLIS.',
        'cl2000 6.2.0 ayni komutu 0x7CC0 kodluyor (olculdu: ti_capraz/kodlama.lst).',
        'Ayni sayfanin LSW satiri da bozuk: "0000 0000 000cc bbaa" = 17 bit',
        '(bolumdeki ayni operand bicimli 8 komutun hepsi "00cc bbaa" = 16 bit).',
        "Yani s.590'in opcode kutusunda iki dizgi hatasi var. 0x7CC0 ayrica",
        'uc operandli tamsayi dizisindeki BOS yuvayi dolduruyor:',
        '  7C60 MAND32 / 7C80 MOR32 / 7CA0 MXOR32 / [7CC0] / 7CE0 MSUB32',
                              )},
    "MADDF32 MRa, MRb, MRc": {"lsw": "0000000000ccbbaa"},
    # s.691'de 'baaa' basilmis: b 1 bit, a 3 bit. Yazmac alani 3 bit olamaz
    # (MR0-MR3, 2 bit yeter) ve kardes komut MADDF32 MRa,#16FHi,MRb ayni
    # yerde 'bbaa' kullaniyor. Sabit bitler degismiyor, sadece alan bolunmesi.
    "MSUBF32 MRa, #16FHi, MRb": {"msw": "011110000000bbaa"},
}

BAYRAKLAR = ["TF", "ZF", "NF", "LUF", "LVF"]
SYNTAX = re.compile(r"^M[A-Z0-9]+( .*)?$")


def yukle(yol):
    return io.open(yol, encoding="utf-8", errors="replace").read().split("\n")


def sayfa_haritasi(satir):
    """Her satirin hangi basili sayfada oldugu.

    Sayfa numarasi sayfanin ALT bilgisinde geciyor; numarayi gorunce
    sonraki satirlar bir sonraki sayfada demektir.
    """
    harita = [0] * len(satir)
    p = 0
    for i, l in enumerate(satir):
        s = l.strip()
        if re.fullmatch(r"[0-9]{3}", s) and 560 <= int(s) <= 720:
            p = int(s)
        harita[i] = p + 1
    return harita


def maske_uret(msw, lsw):
    """Desenden (maske, eslesme) cifti uretir.

    0/1 -> sabit bit (maskede 1), harf -> operand alani (maskede 0).
    MSW bit 31-16, LSW bit 15-0.
    """
    desen = msw + lsw
    maske = 0
    eslesme = 0
    for k, ch in enumerate(desen):
        bit = 31 - k
        if ch in "01":
            maske |= 1 << bit
            if ch == "1":
                eslesme |= 1 << bit
    return maske, eslesme


# TUZAK: bazi operand alanlari tek harfle degil, kelimeyle yaziliyor.
# Harf harf ayristirilirsa 'addr' -> a,d,d,r olur ve yazmac alanlariyla
# (aa, dd) karisir. Bu jetonlar once, butun olarak taninmali.
COK_HARFLI = ["shift", "SHIFT", "dest", "DEST", "addr", "ADDR",
              "cndf", "CNDF"]


def alanlari_cikar(msw, lsw):
    """Operand alani -> kapladigi bit konumlari (yuksekten alcaga)."""
    desen = msw + lsw
    alanlar = {}
    k = 0
    while k < len(desen):
        for jeton in COK_HARFLI:
            if desen.startswith(jeton, k):
                for n in range(len(jeton)):
                    alanlar.setdefault(jeton, []).append(31 - (k + n))
                k += len(jeton)
                break
        else:
            ch = desen[k]
            if ch not in "01":
                alanlar.setdefault(ch, []).append(31 - k)
            k += 1
    return alanlar


def bayraklari_bul(satir, bas, son):
    """Komut govdesindeki 'Modified' tablosunu okur.

    Iki yerlesim var: bazi komutlarda tablo aciklama cumlesinin hemen
    ardinda, bazilarinda basliklardan sonra geliyor. Ikisini de yakalamak
    icin dogrudan 'Modified' + 5 Yes/No dizisini ariyoruz.
    """
    dolu = [l.strip() for l in satir[bas:son] if l.strip()]
    for m, t in enumerate(dolu):
        if t != "Modified":
            continue
        degerler = dolu[m + 1:m + 1 + 5]
        if len(degerler) == 5 and all(v in ("Yes", "No") for v in degerler):
            return {b: (v == "Yes") for b, v in zip(BAYRAKLAR, degerler)}
    for t in dolu:
        if ("does not affect any flags" in t) or ("does not modify" in t and "flag" in t):
            return {b: False for b in BAYRAKLAR}
    return None


def pipeline_notu(satir, bas, son):
    """Pipeline bolumunun cumlesi. Sayfa mizanpaji yuzunden basliklar
    ile metin arasina sayfa alt bilgisi girebiliyor; 'cycle' gecen
    cumleyi dogrudan ariyoruz."""
    for i in range(bas, son):
        t = satir[i].strip()
        if "cycle" in t and t.endswith("."):
            return t
    for i in range(bas, son):
        if satir[i].strip() == "Pipeline":
            for j in range(i + 1, min(i + 12, son)):
                t = satir[j].strip()
                if (t and not re.fullmatch(r"[0-9]{3}", t)
                        and t not in ("Example", "See also", "Flags")):
                    return t
    return None


def basliklari_bul(satir, bas, son):
    """Gercek komut basliklarini bulur.

    TUZAK: komut adlari 'See also' listelerinde de geciyor. Gercek baslik,
    kendisinden sonraki birkac satirda 'Operands' ve 'Opcode' basliklarinin
    gelmesiyle ayirt edilir.
    """
    basliklar = []
    for i in range(bas, son):
        t = satir[i].strip()
        if not SYNTAX.match(t) or t.startswith(("LSW:", "MSW:")) or len(t) >= 70:
            continue
        if t.endswith("(continued)"):
            continue
        pencere = [l.strip() for l in satir[i + 1:i + 8] if l.strip()]
        if "Operands" in pencere and "Opcode" in pencere:
            basliklar.append((i, t))
    return basliklar


def cikar(satir):
    bas = next(i for i, l in enumerate(satir) if l.strip() == "10.6.3 Instructions")
    son = next(i for i, l in enumerate(satir)
               if l.strip() == "10.7 CLA Registers" and i > bas)
    harita = sayfa_haritasi(satir)
    basliklar = basliklari_bul(satir, bas, son)

    kayitlar = []
    for n, (i, sozdizimi) in enumerate(basliklar):
        blok_son = basliklar[n + 1][0] if n + 1 < len(basliklar) else son

        # Opcode sutunu blogun basinda, 'Flags' basligindan once yer alir.
        # Sonrasindaki LSW/MSW satirlari 'See also' / sonraki komut sizintisidir.
        opcode_son = blok_son
        for j in range(i, blok_son):
            if satir[j].strip() == "Flags":
                opcode_son = j
                break

        ciftler = []
        notlar = []
        j = i
        while j < opcode_son:
            t = satir[j].strip()
            if t.startswith("LSW:"):
                govde = t.split(":", 1)[1]
                lsw = re.sub(r"\s", "", govde.split("(")[0])
                # "(opcode of MMOVI16 MAR0, #16I)" gibi notlar MARx'in hangi
                # yazmac oldugunu soyluyor - sozdizimi tek basina soylemiyor
                not_ = re.search(r"\(opcode of ([^)]*)\)", govde)
                notlar.append(not_.group(1).strip() if not_ else None)
                for k in range(j + 1, min(j + 6, opcode_son)):
                    if satir[k].strip().startswith("MSW:"):
                        msw = re.sub(r"\s", "",
                                     satir[k].split(":", 1)[1].split("(")[0])
                        ciftler.append((lsw, msw))
                        j = k
                        break
            j += 1

        # TUZAK: bazi sayfalarda pdftotext 'Flags' basligini operand
        # satirlarindan ONCE yaziyor; o zaman yukaridaki sinir opcode'u da
        # disarida birakiyor. Hic cift bulunamadiysa blogun tamamina bak ve
        # ilk cifti al.
        if not ciftler:
            notlar = []
            j = i
            while j < blok_son and not ciftler:
                t = satir[j].strip()
                if t.startswith("LSW:"):
                    lsw = re.sub(r"\s", "", t.split(":", 1)[1].split("(")[0])
                    for k2 in range(j + 1, min(j + 6, blok_son)):
                        if satir[k2].strip().startswith("MSW:"):
                            msw = re.sub(r"\s", "",
                                         satir[k2].split(":", 1)[1].split("(")[0])
                            ciftler.append((lsw, msw))
                            notlar.append(None)
                            break
                j += 1

        bayrak = bayraklari_bul(satir, i, blok_son)
        boru = pipeline_notu(satir, i, blok_son)

        for sira, (lsw, msw) in enumerate(ciftler):
            duzeltme = ELLE_DUZELTME.get(sozdizimi, {})
            kayitlar.append({
                "note": notlar[sira] if sira < len(notlar) else None,
                "syntax": sozdizimi,
                "mnemonic": sozdizimi.split()[0],
                "lsw": duzeltme.get("lsw", lsw),
                "msw": duzeltme.get("msw", msw),
                "sayfa": harita[i],
                "varyant": sira,
                "flags": bayrak,
                "pipeline": boru,
                "yorum": duzeltme.get("yorum"),
            })
    return birlestir_takma_adlari(kayitlar)


def birlestir_takma_adlari(kayitlar):
    """Ayni kodlamaya sahip AYNI komudun farkli yazilislarini tek kayda indirir.

    Ornek (s.591): 'MADDF32 MRa, MRb, #16FHi' ve 'MADDF32 MRa, #16FHi, MRb'
    ayni opcode'u paylasir; kilavuz 'This instruction can also be written as...'
    diyor. Bunlar cakisma degil, takma addir.

    Ayni kodlamayi FARKLI komutlar paylasiyorsa birlestirmeyiz - o gercek bir
    celiskidir ve cakisma testinde gorunmeye devam etmelidir.
    """
    gruplar = {}
    sira = []
    for k in kayitlar:
        anahtar = (k["msw"], k["lsw"])
        if anahtar not in gruplar:
            gruplar[anahtar] = []
            sira.append(anahtar)
        gruplar[anahtar].append(k)

    sonuc = []
    for anahtar in sira:
        grup = gruplar[anahtar]
        if len(grup) > 1 and len(set(g["mnemonic"] for g in grup)) == 1:
            ana = grup[0]
            ana["aliases"] = [g["syntax"] for g in grup[1:]]
            sonuc.append(ana)
        else:
            sonuc.extend(grup)
    return sonuc


def yaml_yaz(kayitlar, akis):
    akis.write("# CLA Type-0 komut tablosu\n")
    akis.write("# Kaynak: SPRUI10A Bolum 10.6.3 (s.589-703)\n")
    akis.write("# tools/extract_isa.py tarafindan uretildi - elle duzenlerken\n")
    akis.write("# duzeltmeyi ELLE_DUZELTME sozlugune de islemeyi unutma.\n")
    akis.write("#\n")
    akis.write("# mask/match: 32-bit word (MSW bit31-16, LSW bit15-0).\n")
    akis.write("#   (word & mask) == match  ->  bu komut\n")
    akis.write("# fields: operand harfi -> kapladigi bit konumlari\n")
    akis.write("#\n")
    akis.write("# NOT: 'uygulandi mi' bilgisi burada TUTULMAZ - bu dosya uretiliyor,\n")
    akis.write("# her uretimde silinirdi. O bilgi Python tarafindaki dagitim\n")
    akis.write("# sozlugunde durur (cla_core.py): mnemonic sozlukte varsa uygulanmistir.\n")
    akis.write("#\n")
    akis.write("# aliases: ayni opcode'un kilavuzda gecen diger yazilisi (s.591).\n")
    akis.write("#\n")
    akis.write('# KESTIRIM KOMUTLARI - MEINVF32 (s.617) ve MEISQRTF32 (s.618):\n')
    akis.write('#   Kodlamalari asagida, digerleri gibi. Urettikleri DEGERI TI yayimlamiyor\n')
    akis.write('#   ("accurate to approximately 8 bits"); o deger proje sozlesmesi:\n')
    akis.write("#   golden_model/ops_estimate.py (formul), isa/estimate_lut.hex (RTL'in\n")
    akis.write('#   okudugu tablo; tools/lut_uret.py uretir, --denetle ile dogrular).\n')
    akis.write('#   Ayrinti: docs/model_kararlari.md, madde 42.\n')
    akis.write('#\n')
    akis.write("# TABLODA OLMAYAN 2 KOMUT (kasitli):\n")
    akis.write("#   MMOVF32 MRa, #32F   (s.660)  ve  MMOVI32 MRa, #32FHex (s.663)\n")
    akis.write("#   Bunlarin kendi opcode'u YOK. Kilavuz: 'This instruction is an alias\n")
    akis.write("#   for MMOVIZ and MMOVXI'. Assembler bunlari iki komuta acar.\n")
    akis.write("#   Faz 2'de assembler'a sahte komut (pseudo-instruction) olarak eklenecek.\n")
    akis.write("#\n")
    akis.write('# COZULDU (2026-09-21, cl2000 6.2.0 ile):\n')
    akis.write('#     MADD32 MRa,MRb,MRc  <->  MF32TOUI16R MRa,MRb  ikisi de MSW 0x7EC0 idi.\n')
    akis.write("#     Suphe MADD32'nin uzerindeydi ve DOGRU cikti: TI'nin kendi assembler'i\n")
    akis.write("#     MADD32'yi 0x7CC0 kodluyor. TRM s.590'daki opcode kutusu hatali.\n")
    akis.write('#     Tablo duzeltildi; artik cakisma yok.\n\n')
    akis.write("instructions:\n")
    for k in kayitlar:
        maske, eslesme = maske_uret(k["msw"], k["lsw"])
        alanlar = alanlari_cikar(k["msw"], k["lsw"])
        akis.write("  - syntax: \"%s\"\n" % k["syntax"])
        akis.write("    mnemonic: %s\n" % k["mnemonic"])
        if k.get("aliases"):
            akis.write("    aliases:\n")
            for t in k["aliases"]:
                akis.write("      - \"%s\"\n" % t)
        akis.write("    page: %d\n" % k["sayfa"])
        if k.get("note"):
            akis.write("    note: \"%s\"\n" % k["note"])
        for satir in k.get("yorum") or ():
            akis.write("    # %s\n" % satir)
        akis.write("    lsw: \"%s\"\n" % k["lsw"])
        akis.write("    msw: \"%s\"\n" % k["msw"])
        akis.write("    mask: 0x%08X\n" % maske)
        akis.write("    match: 0x%08X\n" % eslesme)
        if alanlar:
            akis.write("    fields:\n")
            for harf in sorted(alanlar):
                akis.write("      %s: %s\n" % (harf, alanlar[harf]))
        else:
            akis.write("    fields: {}\n")
        if k["flags"] is None:
            akis.write("    flags: null      # ELLE KONTROL EDILECEK\n")
        else:
            akis.write("    flags: {%s}\n" % ", ".join(
                "%s: %s" % (b, str(k["flags"][b]).lower()) for b in BAYRAKLAR))
        if k["pipeline"]:
            akis.write("    pipeline: \"%s\"\n" % k["pipeline"].replace('"', "'"))


if __name__ == "__main__":
    kayitlar = cikar(yukle(sys.argv[1]))
    yaml_yaz(kayitlar, sys.stdout)
