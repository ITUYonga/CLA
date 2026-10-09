"""CLA assembly metnini 32-bit komut word'lerine cevirir.

Tasarim: disassembler gibi tabloya dayali. Komut adlarina gore dallanma yok;
tablodaki 'syntax' alani hem yer tutucu listesi hem de form secme olcutu.

Iki gecis:
  1. Etiketleri ve adreslerini topla (ileri dallanma icin sart)
  2. Her satiri kodla

MPC word ofseti oldugu icin her komut MPC'yi 2 artirir (s.717).
"""

import re
import struct

from .disassembler import (ADRESLEME_DOGRUDAN, ADRESLEME_MAR0, ADRESLEME_MAR1,
                           CNDF_ADLARI)
from .isa_table import load_table

KOSUL_KODLARI = {ad: kod for kod, ad in CNDF_ADLARI.items()}

# Tablo 10-9 dipnot 2 (s.586): "This is the default operation if no CNDF field is specified."
# UNCF ayrica kosullu islemlerde ZF/NF'yi guncelleyen TEK kosuldur; diger
# kosullar (UNC dahil) bayraklara dokunmaz. Yani kosul yazilmamis bir komudu
# NEQ (0000) diye kodlamak hem yanlis kosul hem yanlis bayrak davranisi verir.
UNCF = 0b1111

# s.660 ve s.663: kendi opcode'u olmayan, assembler'in iki komuda actigi
# yazimlar. TUZAK: bunlar IKI komut yer kaplar, gecis 1'de boyle sayilmali.
SAHTE_KOMUTLAR = {"MMOVF32", "MMOVI32"}

# ---------------------------------------------------------------------
#  MSETFLG'nin adli sozdizimi:  MSETFLG RND32=0, TF=0, NF=1
#
#  Manuel (s.686) assembler'in bu formu kabul ettigini soyluyor. Elle
#  maske hesaplamak, RND32'nin maskede 7'de MSTF'te 9'da olmasi yuzunden
#  tam da hata yapilacak yer - o yuzden cevrimi assembler yapiyor.
#
#  NOT: buradaki bit numaralari MSTF'in DEGIL, FLAG/VALUE maskesinin
#  numaralari. Esleme ops_control.MASKE_BAYRAK ile ayni kaynaktan.
# ---------------------------------------------------------------------
MSETFLG_MASKE = {"RND32": 7, "RNDF32": 7,   # TI iki yazimi da kullaniyor
                 "TF": 6, "ZF": 3, "NF": 2, "LUF": 1, "LVF": 0}


def _msetflg_adli(jetonlar, satir_no):
    """['RND32=0', 'TF=0', 'NF=1'] -> ['#0xC4', '#0x04'] ; adli form
    degilse None doner."""
    if not jetonlar or not all("=" in j for j in jetonlar):
        return None
    flag = deger = 0
    for j in jetonlar:
        ad, _, v = j.partition("=")
        ad = ad.strip().upper()
        v = v.strip()
        if ad not in MSETFLG_MASKE:
            raise AssemblerError(
                "satir %d: MSETFLG'de bilinmeyen bayrak: %s" % (satir_no, ad))
        if v not in ("0", "1"):
            raise AssemblerError(
                "satir %d: MSETFLG %s icin deger 0 ya da 1 olmali: %s"
                % (satir_no, ad, v))
        bit = MSETFLG_MASKE[ad]
        if (flag >> bit) & 1:
            raise AssemblerError(
                "satir %d: MSETFLG'de %s iki kez verilmis" % (satir_no, ad))
        flag |= 1 << bit
        if v == "1":
            deger |= 1 << bit
    return ["#0x%02X" % flag, "#0x%02X" % deger]


class AssemblerError(Exception):
    """Kaynak metinde hata. Mesaj satir numarasini tasir."""


# =====================================================================
#  Operand ayristirma
# =====================================================================

REG = "REG"
MAR = "MAR"
MEM = "MEM"
IMM = "IMM"
COND = "COND"
DEST = "DEST"
LIT = "LIT"
NUM = "NUM"      # ciplak sayi: IMM veya DEST yuvasina uyabilir


def _sayi(metin):
    metin = metin.strip()
    try:
        if metin.lower().startswith(("0x", "-0x", "+0x")):
            return int(metin, 16)
        return int(metin, 10)
    except ValueError:
        return None


def operand_coz(jeton):
    """Bir operand jetonunu (tip, deger) ciftine cevirir."""
    j = jeton.strip()

    m = re.fullmatch(r"MR([0-3])", j, re.I)
    if m:
        return REG, int(m.group(1))

    m = re.fullmatch(r"MAR([01])", j, re.I)
    if m:
        return MAR, int(m.group(1))

    if j.upper() == "MSTF":
        return LIT, "MSTF"

    # *MAR0[2]++  /  *MAR1[-2]++  /  *MAR0   (s.584: [0]++ varsayilan)
    m = re.fullmatch(r"\*MAR([01])(?:\[(-?(?:0x)?[0-9A-Fa-f]+)\])?(?:\+\+)?", j)
    if m:
        kip = ADRESLEME_MAR0 if m.group(1) == "0" else ADRESLEME_MAR1
        artis = 0 if m.group(2) is None else _sayi(m.group(2))
        if artis is None:
            return None
        return MEM, (kip, artis & 0xFFFF)

    # @0x8800  /  @_VarA
    if j.startswith("@"):
        deger = _sayi(j[1:])
        if deger is None:
            return MEM, (ADRESLEME_DOGRUDAN, j[1:])   # sembol, sonra cozulur
        return MEM, (ADRESLEME_DOGRUDAN, deger & 0xFFFF)

    if j.startswith("#"):
        govde = j[1:]
        deger = _sayi(govde)
        if deger is not None:
            return IMM, deger
        try:
            # s.591: #16FHi hem hex hem float kabul ediyor. Float verilirse
            # float32'nin UST 16 biti alinir, alt 16 bit sifir varsayilir.
            ham = struct.unpack("<I", struct.pack("<f", float(govde)))[0]
            return IMM, (ham >> 16) & 0xFFFF
        except ValueError:
            return None

    if j == "||":
        return LIT, "||"

    if j.upper() in KOSUL_KODLARI:
        return COND, KOSUL_KODLARI[j.upper()]

    # Ciplak sayi hem dallanma hedefi hem immediate olabilir; hangisi oldugu
    # yuvadan anlasilir, o yuzden NUM olarak isaretlenip ikisine de uyar.
    deger = _sayi(j)
    if deger is not None:
        return NUM, deger
    if re.fullmatch(r"[A-Za-z_][A-Za-z_0-9]*", j):
        return DEST, j          # etiket, gecis 2'de cozulur
    return None


# =====================================================================
#  Sozdizimi sablonundan yuva listesi
# =====================================================================

IMM_JETONLARI = ("#16FHiHex", "#16FLoHex", "#32FHex", "#16FHi", "#32F", "#16I")


def _devam_satirlarini_birlestir(satirlar):
    """'||' ile baslayan satiri bir oncekine ekler.

    TI listelerinde paralel komutlar iki satira yayiliyor (s.594):

        MMPYF32 MR1,MR1,MR0 ; Multiply M1*X1
        || MMOV32 MR0,@B1   ; and in parallel load MR0 with B1

    Iki satir TEK bir 32-bit kelime uretir, o yuzden birlestirilmeleri
    gerekiyor - yoksa ikinci satir basli basina bir komut sanilir.

    Birlestirme satir SAYISINI korur (birlesen satirin yerine bos satir
    konur) ki hata mesajlarindaki satir numaralari kaynakla ortussun.
    """
    cikti = []
    for no, ham in enumerate(satirlar, 1):
        govde = ham.split(";", 1)[0].strip()
        if not govde.startswith("||"):
            cikti.append(ham)
            continue
        # Geriye dogru yalnizca BOS / yorum satirlari atlanir.
        # Araya ETIKET girerse birlestirmek sessizce anlam degistirirdi:
        # etiket birlesen komutu degil, ondan SONRAKI komutu gostermeye
        # baslardi. O yuzden hata veriyoruz.
        k = len(cikti) - 1
        while k >= 0:
            etiket, mnemonic, _ = satir_coz(cikti[k])
            if mnemonic:
                break
            if etiket:
                raise AssemblerError(
                    "satir %d: '||' ile komut arasina '%s:' etiketi girmis; "
                    "etiket birlesen komutu degil sonrakini gosterirdi"
                    % (no, etiket))
            k -= 1
        if k < 0:
            raise AssemblerError(
                "satir %d: '||' ile baslayan satirin oncesinde komut yok" % no)
        cikti[k] = cikti[k].split(";", 1)[0].rstrip() + " " + govde
        cikti.append("")               # satir numaralari kaysin diye
    return cikti


def _yuvalar(syntax):
    """'MMOV32 MRa, mem32 {, CNDF}' -> yuva listesi.

    Kosullu ek varsa iki varyant doner: kosulsuz ve kosullu.
    """
    govde = syntax.split(None, 1)[1] if " " in syntax else ""
    kosullu = bool(re.search(r"\{\s*,?\s*CNDF\s*\}", govde))
    govde = re.sub(r"\s*\{\s*,?\s*CNDF\s*\}", "", govde)
    govde = govde.replace("||", " || ")

    temel = [p.strip() for p in re.split(r"[,\s]+", govde) if p.strip()]
    if kosullu:
        return [temel, temel + ["CNDF"]]
    return [temel]


def _yuva_tipi(yuva):
    if re.fullmatch(r"MR[a-f]", yuva):
        return REG
    if yuva == "MARx":
        return MAR
    if yuva in ("mem16", "mem32"):
        return MEM
    if yuva in IMM_JETONLARI or yuva == "#SHIFT":
        return IMM
    if yuva == "CNDF":
        return COND
    if yuva == "16BitDest":
        return DEST
    if yuva in ("FLAG", "VALUE"):
        return IMM
    return LIT


def _alan_adi(kayit, adaylar):
    for ad in adaylar:
        if ad in (kayit.get("fields") or {}):
            return ad
    return None


# =====================================================================
#  Form secme ve kodlama
# =====================================================================

def _uyar_mi(yuva, tip, deger, kayit):
    beklenen = _yuva_tipi(yuva)
    if beklenen == LIT:
        if tip == REG:                       # MMACF32'deki sabit MR3, MR2
            return yuva.upper() == "MR%d" % deger
        return tip in (LIT, DEST) and str(deger).upper() == yuva.upper()
    if tip == NUM and beklenen in (IMM, DEST):
        return True
    if beklenen != tip:
        return False
    if beklenen == MAR:
        return _mar_numarasi(kayit) == deger
    return True


def _mar_numarasi(kayit):
    """MARx yuvasi olan kayitlarda hangi MAR oldugunu bulur (bkz. disassembler)."""
    not_ = kayit.get("note")
    if not_:
        m = re.search(r"MAR([01])", not_)
        if m:
            return int(m.group(1))
    kardesler = sorted(k["match"] for k in load_table()
                       if k["syntax"] == kayit["syntax"])
    return 0 if kayit["match"] == kardesler[0] else 1


def _form_bul(mnemonic, cozulmus):
    """Mnemonic + operand tipleri -> tablo kaydi ve eslesen yuva listesi.

    Takma adlar da gecerli yazilistir (s.591: "This instruction can also be
    written as MADDF32 MRa, MRb, #16FHi"). Ayni opcode, farkli operand
    SIRASI - o yuzden yuva listesi takma adin kendi sozdiziminden uretilir.
    """
    adaylar = []
    for kayit in load_table():
        if kayit["mnemonic"] != mnemonic:
            continue
        yazilislar = [kayit["syntax"]] + list(kayit.get("aliases") or [])
        for sozdizimi in yazilislar:
            for yuva_listesi in _yuvalar(sozdizimi):
                if len(yuva_listesi) != len(cozulmus):
                    continue
                if all(_uyar_mi(y, t, d, kayit)
                       for y, (t, d) in zip(yuva_listesi, cozulmus)):
                    adaylar.append((kayit, yuva_listesi))
    return adaylar


def _bitleri_yerlestir(word, bitler, deger):
    for sira, bit in enumerate(bitler):
        if (deger >> (len(bitler) - 1 - sira)) & 1:
            word |= 1 << bit
    return word


def _kodla(kayit, yuvalar, cozulmus, mpc, etiketler, satir_no, semboller=None):
    word = kayit["match"]
    alanlar = kayit.get("fields") or {}
    semboller = semboller or {}

    # Kosul yuvasi kullanilmadiysa alan sifir kalirdi (NEQ). Varsayilan UNCF.
    kosul_alani = _alan_adi(kayit, ["cndf", "CNDF"])
    if kosul_alani and not any(_yuva_tipi(y) == COND for y in yuvalar):
        word = _bitleri_yerlestir(word, alanlar[kosul_alani], UNCF)

    for yuva, (tip, deger) in zip(yuvalar, cozulmus):
        beklenen = _yuva_tipi(yuva)

        if beklenen == LIT or beklenen == MAR:
            continue                                  # sabit bitte, alan yok

        if beklenen == REG:
            ad = _alan_adi(kayit, [yuva[-1], yuva[-1].upper()])
            word = _bitleri_yerlestir(word, alanlar[ad], deger)

        elif beklenen == MEM:
            kip, m = deger
            if isinstance(m, str):
                if m not in semboller:
                    raise AssemblerError(
                        "satir %d: tanimsiz veri sembolu: %s "
                        "(assemble(kaynak, semboller={...}) ile verin)"
                        % (satir_no, m))
                m = semboller[m] & 0xFFFF
            word = _bitleri_yerlestir(word, alanlar["addr"], kip)
            word = _bitleri_yerlestir(word, alanlar["m"], m)

        elif beklenen == COND:
            ad = _alan_adi(kayit, ["cndf", "CNDF"])
            word = _bitleri_yerlestir(word, alanlar[ad], deger)

        elif beklenen == IMM:
            if yuva == "#SHIFT":
                if not 1 <= deger <= 32:
                    raise AssemblerError(
                        "satir %d: kaydirma 1-32 araliginda olmali" % satir_no)
                word = _bitleri_yerlestir(word, alanlar["shift"], deger - 1)
            elif yuva == "FLAG":
                word = _bitleri_yerlestir(word, alanlar["F"], deger)
            elif yuva == "VALUE":
                word = _bitleri_yerlestir(word, alanlar["V"], deger)
            else:
                word = _bitleri_yerlestir(word, alanlar["I"], deger & 0xFFFF)

        elif beklenen == DEST:
            if isinstance(deger, str) and deger in etiketler or (
                    isinstance(deger, str) and not _sayi(deger)):
                if deger not in etiketler:
                    raise AssemblerError(
                        "satir %d: tanimsiz etiket: %s" % (satir_no, deger))
                # Taban dalin KENDI adresi: s.600 'MPC += 16BitDest' ve MPC =
                # D2'deki komut (s.717). TI cl2000 ciktisi da boyle (ti_capraz,
                # 6/6 dal). s.600'deki '0xFFFE' cumlesi TRM hatasi (§47).
                deger = etiketler[deger] - mpc
            word = _bitleri_yerlestir(word, alanlar["dest"], deger & 0xFFFF)

    return word


# =====================================================================
#  Satir ayristirma
# =====================================================================

def satir_coz(satir):
    """Ham satir -> (etiket, mnemonic, operand jetonlari).

    Bos satir veya sadece yorum ise (etiket, None, []) doner.
    """
    metin = satir.split(";", 1)[0].strip()
    if not metin:
        return None, None, []

    etiket = None
    m = re.match(r"^([A-Za-z_][A-Za-z_0-9]*)\s*:\s*(.*)$", metin)
    if m:
        etiket, metin = m.group(1), m.group(2).strip()
    if not metin:
        return etiket, None, []

    parcalar = metin.split(None, 1)
    mnemonic = parcalar[0].upper()
    kalan = parcalar[1] if len(parcalar) > 1 else ""
    kalan = kalan.replace("||", " || ")
    jetonlar = [p.strip() for p in re.split(r",|\s+", kalan) if p.strip()]
    return etiket, mnemonic, jetonlar


def _sahte_ac(mnemonic, jetonlar, satir_no):
    """MMOVF32 / MMOVI32 -> MMOVIZ + MMOVXI (s.660, s.663).

    Alt 16 bit sifirsa yalniz MMOVIZ (TRM: "the assembler will convert
    ... into only MMOVIZ instruction"). Donen liste 1 ya da 2 komut.
    """
    if len(jetonlar) != 2:
        raise AssemblerError("satir %d: %s iki operand bekler" % (satir_no, mnemonic))
    hedef, imm = jetonlar
    govde = imm.lstrip("#")
    deger = _sayi(govde)
    if deger is None:
        try:
            deger = struct.unpack("<I", struct.pack("<f", float(govde)))[0]
        except ValueError:
            raise AssemblerError("satir %d: gecersiz immediate: %s" % (satir_no, imm))
    ust, alt = (deger >> 16) & 0xFFFF, deger & 0xFFFF
    if alt == 0:        # s.660/s.663: alt 16 bit sifirsa assembler yalniz MMOVIZ uretir
        return [("MMOVIZ", [hedef, "#0x%04X" % ust])]
    return [("MMOVIZ", [hedef, "#0x%04X" % ust]),
            ("MMOVXI", [hedef, "#0x%04X" % alt])]


# =====================================================================
#  Ana giris
# =====================================================================

def assemble(kaynak, semboller=None):
    """Assembly metnini 32-bit word listesine cevirir.

    semboller: veri sembolu -> 16-bit adres eslemesi.
        {"_ruzgar": 0x8800, "_cikti": 0x8802}
    Kaynakta @_ruzgar yazildiginda bu sozlukten cozulur.

    NEDEN AYRI: etiketler (gecis 1'de toplanan dallanma hedefleri) PROGRAM
    adresidir ve MPC word ofsetidir. Veri sembolleri VERI adresidir ve
    16-bit mutlak adrestir. Ikisi ayri ad alani - ayni sozlukte tutulursa
    bir dallanma hedefi yanlislikla veri adresi gibi cozulebilir.
    """
    semboller = semboller or {}
    satirlar = _devam_satirlarini_birlestir(kaynak.splitlines())

    # --- gecis 1: etiketler ---
    etiketler = {}
    mpc = 0
    for no, satir in enumerate(satirlar, 1):
        etiket, mnemonic, jetonlar = satir_coz(satir)
        if etiket:
            if etiket in etiketler:
                raise AssemblerError("satir %d: etiket tekrar tanimlanmis: %s"
                                     % (no, etiket))
            etiketler[etiket] = mpc
        if mnemonic is None:
            continue
        mpc += 2 * len(_sahte_ac(mnemonic, jetonlar, no)) if mnemonic in SAHTE_KOMUTLAR else 2

    # --- gecis 2: kodlama ---
    wordler = []
    mpc = 0
    for no, satir in enumerate(satirlar, 1):
        _, mnemonic, jetonlar = satir_coz(satir)
        if mnemonic is None:
            continue

        if mnemonic in SAHTE_KOMUTLAR:
            parcalar = _sahte_ac(mnemonic, jetonlar, no)
        elif mnemonic == "MSETFLG":
            adli = _msetflg_adli(jetonlar, no)
            parcalar = [(mnemonic, adli if adli else jetonlar)]
        else:
            parcalar = [(mnemonic, jetonlar)]

        for alt_mnemonic, alt_jetonlar in parcalar:
            cozulmus = []
            for j in alt_jetonlar:
                c = operand_coz(j)
                if c is None:
                    raise AssemblerError(
                        "satir %d: anlasilmayan operand: %s" % (no, j))
                cozulmus.append(c)

            adaylar = _form_bul(alt_mnemonic, cozulmus)
            if not adaylar:
                raise AssemblerError(
                    "satir %d: %s icin uyan form yok (%d operand)"
                    % (no, alt_mnemonic, len(cozulmus)))
            if len(adaylar) > 1:
                raise AssemblerError(
                    "satir %d: %s birden fazla forma uyuyor: %s"
                    % (no, alt_mnemonic, [k["syntax"] for k, _ in adaylar]))

            kayit, yuvalar = adaylar[0]
            wordler.append(
                _kodla(kayit, yuvalar, cozulmus, mpc, etiketler, no, semboller))
            mpc += 2

    return wordler
