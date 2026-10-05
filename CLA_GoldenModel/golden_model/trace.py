# -*- coding: utf-8 -*-
"""Cevrim basina iz uretici ve okuyucu.

Format SOZLESMESI: docs/trace_format.md  (surum 1)
Bicimi buradan okumayin - oradan okuyun; burasi onun uygulamasi.

Neden hem yazici hem okuyucu ayni dosyada: `tools/compare_trace.py` de
`golden_model` de ayni alan listesini kullanmak zorunda. Iki yerde
tutulursa bir gun ayrisirlar ve karsilastirma sessizce yanlis hizalanir.

KULLANIM
--------
    core = ClaCore(st, mem, Pipeline(st, mem))
    with open("model.trace", "w") as f:
        n = iz_al(core, f)                 # tek gorev
        n = iz_al_gorevler(core, f)        # hakemli, cok gorev

ARDISIK MODEL DESTEKLENMIYOR: iz cevrim tabanli, ardisik modelin cevrim
kavrami yok. `pipeline=None` ile cagrilirsa hata verir - karsilastirilmasi
imkansiz bir dosya uretmektense.
"""

import re

SURUM = 1

ALANLAR = ["cycle", "exe_pc", "exe_op", "mpc",
           "mr0", "mr1", "mr2", "mr3",
           "mar0", "mar1", "mstf",
           "wr_addr", "wr_data", "wr_w"]

#  alan -> (genislik, onaltilik mi)
BICIM = {
    "cycle":   (0, False), "exe_pc": (3, True), "exe_op": (8, True),
    "mpc":     (3, True),
    "mr0":     (8, True), "mr1": (8, True), "mr2": (8, True), "mr3": (8, True),
    "mar0":    (4, True), "mar1": (4, True), "mstf": (8, True),
    "wr_addr": (4, True), "wr_data": (8, True), "wr_w": (2, False),
}


class IzHatasi(Exception):
    pass


# ---------------------------------------------------------------------
#  yazma
# ---------------------------------------------------------------------
def _alan(ad, deger):
    genislik, onaltilik = BICIM[ad]
    if deger is None:
        return "-" * (genislik or 1)
    if not onaltilik:
        return str(deger) if genislik == 0 else str(deger).rjust(genislik, "0")
    maske = (1 << (4 * genislik)) - 1
    return format(deger & maske, "0%dx" % genislik)


def basligi_yaz(akis):
    akis.write("#CLATRACE %d\n" % SURUM)
    akis.write("#FIELDS %s\n" % " ".join(ALANLAR))


def satir_metni(degerler):
    """Cozulmus satiri dosyadaki haline geri cevirir (gidis-donus)."""
    return " ".join(_alan(ad, degerler.get(ad)) for ad in ALANLAR)


def satir_yaz(akis, degerler):
    akis.write(satir_metni(degerler) + "\n")


class Izci:
    """Bir Pipeline'in cevrim sonu durumunu satira cevirir."""

    def __init__(self, cekirdek, akis):
        if getattr(cekirdek, "pipeline", None) is None:
            raise IzHatasi("iz cevrim tabanli; ClaCore bir Pipeline ile "
                           "kurulmali (ardisik model izlenemez)")
        self.cekirdek = cekirdek
        self.state = cekirdek.state
        self.memory = cekirdek.memory
        self.akis = akis
        self.cevrim = 0
        self._yazma_indeksi = len(self.memory.write_log)
        self.mstop_satiri = None      # son gorevin MSTOP'unun D2'ye girdigi satir

    def basla(self):
        basligi_yaz(self.akis)

    def yazmalari_esitle(self):
        """Simdiye kadarki yazmalari 'gorulmus' say.

        write_log kimin yazdigini tutmuyor (CPU da CLA da ayni listeye
        dusuyor). Iki gorev arasinda test tezgahi CPU adina bellege yazarsa
        (orn. mesaj RAM'ine yeni komut) o yazma, esitlenmezse, sonraki
        gorevin ILK cevrimine CLA yazmasi diye basilirdi. `iz_al` her
        gorevin basinda cagiriyor.
        """
        self._yazma_indeksi = len(self.memory.write_log)

    def _bu_cevrimdeki_yazma(self):
        """write_log'un bu cevrimde uzayip uzamadigina bakar.

        Cevrimde en fazla BIR yazma (docs/trace_format.md S2): TRM'deki
        sekiz yazan bicimin her biri tek konuma yazar ve W'de cevrim basina
        tek komut var. Birden fazla cikarsa format yalan soyluyor demektir
        - sessizce sonuncuyu basmak yerine hata.

        write_log yalniz ETKILI yazmalari tutuyor: CLA'nin yazamadigi
        bolgeye (CPU->CLA mesaj RAM'i, s.571) yazma yok sayiliyor ve ize
        dusmuyor - S2 "wr_* etkili yazmadir".
        """
        log = self.memory.write_log
        yeni = log[self._yazma_indeksi:]
        self._yazma_indeksi = len(log)
        if not yeni:
            return None, None, None
        if len(yeni) > 1:
            raise IzHatasi(
                "cevrim %d'de %d yazma var; format tek yazma varsayiyor "
                "(docs/trace_format.md S2)" % (self.cevrim, len(yeni)))
        adres, veri, genislik = yeni[0]
        return adres, veri, genislik

    def satir(self):
        """Az once kosan cevrimin satirini basar."""
        self.cevrim += 1
        boru = self.cekirdek.pipeline
        # exe_* = o cevrim EXE kademesindeki komut (S2). Normal cevrimde EXE'den
        # gecen komut W'ye ([6]) kaydi; dur_exe cevriminde EXE'deki komut
        # calismadan bekledi ve [5]'te duruyor, W'ye balon girdi (S6.8:
        # exe_pc iki satir ayni kalir).
        kayit = boru.pipeline_kaydi[5] if getattr(boru, "exe_bekledi", False) \
            else boru.pipeline_kaydi[6]
        gecerli = (kayit.gecerli == 1 and kayit.pc is not None)
        wr_addr, wr_data, wr_w = self._bu_cevrimdeki_yazma()
        satir_yaz(self.akis, {
            "cycle":   self.cevrim,
            "exe_pc":  kayit.pc if gecerli else None,
            "exe_op":  kayit.ham if gecerli else None,
            "mpc":     self.state.mpc,
            "mr0":     self.state.get_mr(0), "mr1": self.state.get_mr(1),
            "mr2":     self.state.get_mr(2), "mr3": self.state.get_mr(3),
            "mar0":    self.state.get_mar(0), "mar1": self.state.get_mar(1),
            "mstf":    self.state.mstf,
            "wr_addr": wr_addr, "wr_data": wr_data, "wr_w": wr_w,
        })


def iz_al(cekirdek, akis, max_cevrim=10000, izci=None):
    """Tek gorevi MSTOP'a kadar kosturur, her cevrim bir satir basar.

    `izci` verilirse baslik yeniden basilmaz ve sayac devam eder -
    `iz_al_gorevler` bunu kullaniyor; o zaman gorevin bittigi cevrimde
    donulur (Tablo 10-19: MSTOP D2 + 2), sonraki gorev bir sonraki
    cevrimde baslar. Tek basina cagrilinca bundan sonra KUYRUK da basilir:
    iz MSTOP D2 + 3'te biter (docs/trace_format.md S4). Basilan satir
    sayisini doner.
    """
    kendi = izci is None
    if kendi:
        izci = Izci(cekirdek, akis)
        izci.basla()
    izci.yazmalari_esitle()                  # gorev disi yazma bu goreve yazilmasin
    cekirdek.pipeline.durdu = False          # yeni gorev -> getirme acilir
    izci.mstop_satiri = None
    n = 0
    while n < max_cevrim:
        devam = cekirdek.step()
        n += 1
        izci.satir()
        if izci.mstop_satiri is None and cekirdek.pipeline.durdu:
            izci.mstop_satiri = izci.cevrim  # MSTOP bu cevrimde D2'ye girdi
        if not devam:
            if kendi:
                n += _kuyruk(cekirdek, izci)
            return n
    raise IzHatasi("iz %d cevrimde bitmedi (MSTOP yok ya da sonsuz dongu)"
                   % max_cevrim)


def _kuyruk(cekirdek, izci):
    """Son gorevden sonra: iz, MSTOP'un D2'ye girdigi satirdan (n) 3 satir
    sonra biter. Tablo 10-19 (s.688): n+1 ve n+2 hakem cevrimleri, n+3'te
    MSTOP'tan onceki son komutun W'si (bir sonraki gorev olsaydi onun ilk
    F1'i de o cevrimde). Boru hatti bosalmayi kendisi yapmaz; cevrimi
    `step()` surer - satir basina bir cevrim, kural degismez.

    Gecersiz opcode'da boru hatti donar, MSTOP yoktur: kuyruk yok (S4).
    Kac satir bastigini doner.
    """
    if izci.mstop_satiri is None or cekirdek.pipeline.donduruldu:
        return 0
    ek = 0
    while izci.cevrim < izci.mstop_satiri + 3:
        cekirdek.step()
        izci.satir()
        ek += 1
    return ek


def iz_al_gorevler(cekirdek, akis, max_cevrim=10000, max_gorev=64):
    """Hakemli kosu: butun gorevler TEK dosyaya, sayac kesilmeden.

    docs/trace_format.md S4: "yeni gorev yeni bir iz dosyasi demek degil".
    """
    if cekirdek.arbiter is None:
        raise IzHatasi("iz_al_gorevler icin hakem gerekli")
    izci = Izci(cekirdek, akis)
    izci.basla()
    kosan = []
    while len(kosan) < max_gorev:
        if not cekirdek.arbiter.gorev_basla(cekirdek.state):
            _kuyruk(cekirdek, izci)          # son gorevin W'si n+3'te (S4)
            return kosan
        mirun = cekirdek.arbiter.regs.mirun
        kosan.append((mirun, iz_al(cekirdek, akis, max_cevrim, izci=izci)))
    raise IzHatasi("%d gorevden sonra hala bekleyen var" % max_gorev)


# ---------------------------------------------------------------------
#  okuma
# ---------------------------------------------------------------------
#  Sozlesme okuyucuda UYGULANIR (docs/trace_format.md S2-S4): karsilastirma
#  araci ancak buradan gecen dosyaya guvenebilir. Buradaki her kural,
#  aksi halde SESSIZ yanlis hizalanma ya da sessiz "AYRISMA YOK" ureten
#  somut bir durumu kapatiyor.
DESTEKLENEN_SURUMLER = (SURUM,)

_ONALTILIK = re.compile(r"[0-9a-fA-F]+\Z")
_ONDALIK = re.compile(r"[0-9]+\Z")
_BOS = re.compile(r"-+\Z")
#  Verilog %h: butun bitleri X olan hane 'x', bazisi X olan hane 'X'
#  (Z icin z/Z). Bunlar bicim hatasi DEGIL, RTL'in gercek bir durumu.
_BILINMEYENLI = re.compile(r"[0-9a-fA-FxXzZ]*[xXzZ][0-9a-fA-FxXzZ]*\Z")


def _coz(ad, metin, satir_no=None):
    """Tek alani cozer: sayi, None (tire) ya da ham metin (X/Z).

    X/Z iceren deger METIN olarak doner: hicbir sayiya esit olmaz, yani
    karsilastirmada AYRISMA olarak gorunur - baglamiyla birlikte. Bicim
    hatasi (cikis 2) sayilsaydi RTL'in reset edilmemis bir yazmacini
    "dosya bozuk" diye gosterirdik; asil soru "hangi cevrimde, hangi
    alanda" ve onu ancak karsilastirma cevaplar.
    """
    genislik, onaltilik = BICIM[ad]
    if _BOS.match(metin):
        return None
    if (_ONALTILIK if onaltilik else _ONDALIK).match(metin):
        return int(metin, 16 if onaltilik else 10)
    #  X/Z yalniz TAM genislikte kabul: Verilog %h sinyalin butun
    #  genisligini basar ("xxxxxxxx"). Boylece "0x40e0" gibi onekli bir
    #  sayi X sanilmaz - '0x' + hex, genislikten 2 uzun cikar.
    if (ad != "cycle" and len(metin) == genislik
            and _BILINMEYENLI.match(metin)):
        return metin
    if metin[:2] in ("0x", "0X"):
        neden = "'0x' oneki olmamali (S2)"
    else:
        neden = ("gecerli bir %s deger degil"
                 % ("onaltilik" if onaltilik else "ondalik"))
    raise IzHatasi("satir %s, alan %s: %r %s" % (satir_no, ad, metin, neden))


def bilinmeyen_mi(deger):
    """_coz'un X/Z iceren alan icin dondurdugu ham metin mi?"""
    return isinstance(deger, str)


def satir_coz(metin, satir_no=None):
    parca = metin.split()
    if len(parca) != len(ALANLAR):
        raise IzHatasi("satir %s: %d alan var, %d bekleniyordu"
                       % (satir_no, len(parca), len(ALANLAR)))
    return dict(zip(ALANLAR, (_coz(a, p, satir_no)
                              for a, p in zip(ALANLAR, parca))))


def _surum_coz(parca, no):
    if len(parca) != 2 or not _ONDALIK.match(parca[1]):
        raise IzHatasi("satir %d: bozuk surum satiri %r ('#CLATRACE <sayi>' "
                       "bekleniyordu)" % (no, " ".join(parca)))
    surum = int(parca[1])
    if surum not in DESTEKLENEN_SURUMLER:
        raise IzHatasi(
            "satir %d: iz surumu %d, bu okuyucu yalniz %s okuyor. Baska "
            "surumun alanlarini v%d diye okumak sessizce yanlis hizalar."
            % (no, surum, "/".join("v%d" % s for s in DESTEKLENEN_SURUMLER),
               SURUM))
    return surum


def oku(akis):
    """Iz dosyasini (surum, [satir sozlugu]) olarak doner.

    Reddedilenler (hepsi IzHatasi):
      * '#CLATRACE' ya da '#FIELDS' yok, ya da veri satirindan SONRA geliyor
      * desteklenmeyen surum; ikinci baslik (iki iz ust uste eklenmis)
      * '#FIELDS' ALANLAR ile birebir ayni sirada degil - sutun sirasi
        farkli bir dosya degerleri yanlis alanlara dagitirdi
      * cycle 1'den baslayip +1 artmiyor - eksik ya da fazla tek satir
        ondan sonraki HER satiri kaydirir (S1, S4)
      * alan sayisi yanlis, sayi olmayan alan (X/Z haric, bkz. _coz)
    """
    surum = None
    alanlar_tamam = False
    satirlar = []
    for no, ham in enumerate(akis, 1):
        ham = ham.strip()
        if not ham:
            continue
        if ham.startswith("#"):
            parca = ham.split()
            if parca[0] == "#CLATRACE":
                if surum is not None:
                    raise IzHatasi(
                        "satir %d: ikinci '#CLATRACE' basligi - iki iz ust "
                        "uste eklenmis olabilir; her kosu tek dosya, tek "
                        "baslik (S3, S4)" % no)
                surum = _surum_coz(parca, no)
            elif parca[0] == "#FIELDS":
                if alanlar_tamam:
                    raise IzHatasi("satir %d: ikinci '#FIELDS' satiri" % no)
                if parca[1:] != ALANLAR:
                    raise IzHatasi(
                        "satir %d: alan listesi sozlesmeyle ayni degil\n"
                        "  dosya     : %s\n  beklenen  : %s"
                        % (no, " ".join(parca[1:]), " ".join(ALANLAR)))
                alanlar_tamam = True
            continue
        if surum is None or not alanlar_tamam:
            raise IzHatasi(
                "satir %d: veri satiri '#CLATRACE' ve '#FIELDS' "
                "basliklarindan once geliyor (S3)" % no)
        satir = satir_coz(ham, no)
        beklenen = len(satirlar) + 1
        if satir["cycle"] != beklenen:
            raise IzHatasi(
                "satir %d: cycle %d, %d bekleniyordu - sayac 1'den baslar ve "
                "her satirda 1 artar (S1, S4). Eksik ya da fazla tek satir "
                "sonraki her satiri kaydirir." % (no, satir["cycle"], beklenen))
        satirlar.append(satir)
    if surum is None:
        raise IzHatasi("dosyada '#CLATRACE <surum>' basligi yok")
    if not alanlar_tamam:
        raise IzHatasi("dosyada '#FIELDS ...' satiri yok (S3)")
    return surum, satirlar
