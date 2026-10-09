# -*- coding: utf-8 -*-
"""CASM denetleyicisi - donanimin KORUMADIGI seyleri derleme zamaninda yakalar.

CLA'nin boru hattinda uc yerde "kod dikkat etmek zorunda" durumu var; ucunde
de donanim kilitlemesi YOK, yani model de RTL de sessizce yanlis sonuc verir.
Kilavuzun kendi ifadesiyle (s.578):

    "The CLA does not have this protection mechanism.
     Instead the code must wait to perform the read."

Denetlenen uc kural:

  A) GECIKME YUVASI (s.579)
     Dallanmadan onceki 3 ve sonraki 3 konumda MSTOP/MDEBUGSTOP/dal/cagri/
     donus bulunamaz. Ayrica onceki 3 komutun kurdugu bayraklar o dallanmaya
     YETISMEZ (karar D2'de verilir) - bu sessiz bir tuzak, uyari veriliyor.

  B) YAZMA-SONRASI-OKUMA (s.578, Tablo 10-1/10-2)
     Bir adrese yazdiktan sonra ayni adresten okumak icin araya EN AZ 3
     komut girmeli (TRM Tablo 10-2: I1 yazar, I5 okur).

  C) MAR GOLGE GECIKMESI (s.580, Ornek 10-2)
     MARx yuklemesinden sonraki 2 komut eski degeri gorur, 3. komut MARx'i
     hic kullanamaz, 4.'ten itibaren yeni deger.

MESAFE SECIMI - bilincli
------------------------
B kuralinda model I4'u guvenli sayiyor, TRM Tablo 10-2 I5'i gosteriyor;
aradaki bosluk borc 27.1 (model_kararlari.md). Denetleyici **TRM'in
mesafesini** kullaniyor: cozulmemis bir borca dayanip "temiz" dememeli.
Model gevsek kalabilir - o donanimi taklit ediyor; lint siki olmali - o
programciyi koruyor.

KULLANIM
--------
    from golden_model.lint import denetle
    for b in denetle(kaynak, semboller):
        print(b)

    python3 tools/casm_lint.py gorev.casm
"""

from . import erisim as E
from .assembler import SAHTE_KOMUTLAR, assemble, satir_coz, \
    _devam_satirlarini_birlestir, _sahte_ac
from .dagitici import _mar_indeksi
from .decoder import decode

DURDURUCU = frozenset({"MSTOP", "MDEBUGSTOP"})
YASAK_YUVA = DURDURUCU | E.DALLANIR          # dal yuvalarinda bulunamayacaklar

YUVA_SAYISI = 3          # dallanma: onceki 3 / sonraki 3   (s.579)
YAZ_OKU_ARA = 3          # yazma ile okuma arasina girmesi gereken komut
MAR_GOLGE = 3            # yuklemeden sonra MAR'in guvenilmez oldugu komut

HATA, UYARI, COZULEMEDI = "hata", "uyari", "cozulemedi"


class Bulgu(object):
    def __init__(self, kural, agirlik, indeks, mesaj, kaynak_satir=None):
        self.kural = kural
        self.agirlik = agirlik
        self.indeks = indeks                 # komut sirasi (0'dan)
        self.pc = 2 * indeks
        self.mesaj = mesaj
        self.kaynak_satir = kaynak_satir

    def __repr__(self):
        return "<%s %s pc=0x%03x %s>" % (self.agirlik, self.kural,
                                         self.pc, self.mesaj)

    def __str__(self):
        s = "%-11s %-10s komut %-4d (pc 0x%03x)  %s" % (
            self.agirlik.upper(), self.kural, self.indeks, self.pc, self.mesaj)
        if self.kaynak_satir:
            s += "\n                                          | %s" % self.kaynak_satir
        return s


# ---------------------------------------------------------------------
#  kaynak <-> komut eslemesi
# ---------------------------------------------------------------------
def kaynak_haritasi(kaynak):
    """Komut indeksi -> kaynak satiri metni.

    SAHTE_KOMUTLAR (MMOVF32/MMOVI32) bir ya da iki komuta aciliyor
    (alt 16 bit sifirsa tek MMOVIZ, s.660); bire bir
    esleme yapilamaz, o yuzden sayarak yuruyoruz.
    """
    harita = {}
    k = 0
    for satir in _devam_satirlarini_birlestir(kaynak.splitlines()):
        _, mnemonic, jetonlar = satir_coz(satir)
        if mnemonic is None:
            continue
        adet = len(_sahte_ac(mnemonic, jetonlar, 0)) if mnemonic in SAHTE_KOMUTLAR else 1
        for _ in range(adet):
            harita[k] = satir.strip()
            k += 1
    return harita


class _Komut(object):
    """Denetim icin gereken ozet - her sey `decode`dan turetiliyor."""

    __slots__ = ("syntax", "mnemonic", "yazar", "okur", "dolayli",
                 "yazar_mi", "okur_mi", "mar_kullanir", "mar_yukler",
                 "bayrak_degistirir")

    def __init__(self, word):
        d = decode(word)
        self.syntax = d.syntax
        self.mnemonic = d.mnemonic
        kip = d.fields.get("addr")
        m = d.fields.get("m")
        erisir = (E.okur16(self.syntax) or E.okur32(self.syntax)
                  or E.yazar16(self.syntax) or E.yazar32(self.syntax))
        self.dolayli = erisir and kip in (0b0001, 0b0010)
        adres = None if (self.dolayli or not erisir) else m
        self.yazar_mi = E.yazar16(self.syntax) or E.yazar32(self.syntax)
        self.okur_mi = E.okur16(self.syntax) or E.okur32(self.syntax)
        self.yazar = adres if self.yazar_mi else None
        self.okur = adres if self.okur_mi else None
        self.mar_kullanir = ({0b0001: 0, 0b0010: 1}.get(kip)
                             if erisir else None)
        self.mar_yukler = (_mar_indeksi(d.entry)
                           if E.mar_yukler(self.syntax) else None)
        self.bayrak_degistirir = any(d.entry.get("flags", {}).values())


# ---------------------------------------------------------------------
#  kurallar
# ---------------------------------------------------------------------
def _kural_a_gecikme_yuvalari(k, bulgu):
    n = len(k)
    for i, komut in enumerate(k):
        if komut.syntax not in E.DALLANIR:
            continue
        for j in range(max(0, i - YUVA_SAYISI), i):
            if k[j].syntax in YASAK_YUVA:
                bulgu(j, HATA, "S5.2-yuva",
                      "%s dallanmadan %d komut once (komut %d); bu 3 konumda "
                      "durdurucu/dallanma yasak (s.579)"
                      % (k[j].mnemonic, i - j, i))
            elif k[j].bayrak_degistirir:
                bulgu(j, UYARI, "S5.2-bayrak",
                      "%s bayrak degistiriyor ama komut %d'deki dallanmaya "
                      "YETISMEZ (karar D2'de)" % (k[j].mnemonic, i))
        for j in range(i + 1, i + 1 + YUVA_SAYISI):
            if j >= n:
                bulgu(i, HATA, "S5.2-yuva",
                      "gecikme yuvasi program sonuna tasti: dallanmadan sonra "
                      "%d komut var, %d gerekiyor (s.579)"
                      % (n - 1 - i, YUVA_SAYISI))
                break
            if k[j].syntax in YASAK_YUVA:
                bulgu(j, HATA, "S5.2-yuva",
                      "%s gecikme yuvasinda (komut %d'deki dallanmadan %d "
                      "sonra); bu konumlarda yasak (s.579)"
                      % (k[j].mnemonic, i, j - i))


def _kural_b_yazma_sonrasi_okuma(k, bulgu):
    """Her (yazan i, okuyan j) cifti icin j-i <= YAZ_OKU_ARA ise bak.

    Ikisi de dogrudan adresli ise adres karsilastirilir; biri bile dolayli
    ise guvenlik ISPATLANAMAZ - sessiz gecmek yerine COZULEMEDI basiyoruz.
    Statik denetleyicinin en tehlikeli hatasi "bir sey bulamadim"i
    "temiz"le karistirmaktir.
    """
    n = len(k)
    for i, yazan in enumerate(k):
        if not yazan.yazar_mi:
            continue
        for j in range(i + 1, min(i + 1 + YAZ_OKU_ARA, n)):
            okuyan = k[j]
            if not okuyan.okur_mi:
                continue
            if yazan.dolayli or okuyan.dolayli:
                bulgu(j, COZULEMEDI, "S5.4-yaz-oku",
                      "komut %d yaziyor, %d komut sonra okuma var; en az "
                      "biri dolayli adresli, cakisma statik olarak "
                      "bilinemiyor" % (i, j - i))
            elif yazan.yazar == okuyan.okur:
                bulgu(j, HATA, "S5.4-yaz-oku",
                      "0x%04X komut %d'de yazildi, %d komut sonra okunuyor; "
                      "araya en az %d komut girmeli - donanimda koruma YOK, "
                      "BAYAT deger okunur (s.578)"
                      % (yazan.yazar, i, j - i, YAZ_OKU_ARA))


def _kural_c_mar_golgesi(k, bulgu):
    n = len(k)
    for i, komut in enumerate(k):
        x = komut.mar_yukler
        if x is None:
            continue
        for j in range(i + 1, min(i + 1 + MAR_GOLGE, n)):
            if k[j].mar_kullanir != x:
                continue
            mesafe = j - i
            if mesafe == MAR_GOLGE:
                bulgu(j, HATA, "S5.3-mar",
                      "MAR%d komut %d'de yuklendi; %d komut sonra MAR%d HIC "
                      "kullanilamaz (cakismada post-increment kazanir, "
                      "s.579 Ornek 10-2)" % (x, i, mesafe, x))
            else:
                bulgu(j, UYARI, "S5.3-mar",
                      "MAR%d komut %d'de yuklendi; %d komut sonra ESKI deger "
                      "gorulur (kasitli olabilir, s.579 Ornek 10-2)"
                      % (x, i, mesafe))


KURALLAR = (_kural_a_gecikme_yuvalari,
            _kural_b_yazma_sonrasi_okuma,
            _kural_c_mar_golgesi)


# ---------------------------------------------------------------------
def denetle(kaynak, semboller=None, wordler=None):
    """Kaynagi denetler, Bulgu listesi doner (komut sirasina gore).

    `wordler` verilirse yeniden derlenmez - ayni kaynagi iki kez
    derlemekten kacinmak isteyen cagiranlar icin.
    """
    if wordler is None:
        wordler = assemble(kaynak, semboller=semboller)
    komutlar = [_Komut(w) for w in wordler]
    harita = kaynak_haritasi(kaynak)

    bulgular = []

    def bulgu(indeks, agirlik, kural, mesaj):
        bulgular.append(Bulgu(kural, agirlik, indeks, mesaj,
                              harita.get(indeks)))

    for kural in KURALLAR:
        kural(komutlar, bulgu)

    bulgular.sort(key=lambda b: (b.indeks, b.kural))
    return bulgular


def hatalar(bulgular):
    return [b for b in bulgular if b.agirlik == HATA]
