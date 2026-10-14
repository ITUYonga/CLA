# -*- coding: utf-8 -*-
"""CLA vitrini: simulasyonda CLA'nin avantajlarini gosteren paneller.

    BoruIzi      CLA programinin golden boru hattindaki cevrim cevrim izi
                 (hangi kademede hangi buyruk, durmalar). Kontrolcu dalsiz
                 oldugu icin iz her adimda aynidir; bir kez cikarilir.
    cla_sayfasi  sag paneldeki "CLA" sayfasi: zaman butcesi, determinizm,
                 boru hatti canlandirmasi, dogrulama.
    cla_nedir    ucus alaninin ustune acilan anlatim ekrani: CPU / CLA is
                 bolumu, paralellik, bu demoda kim ne yapiyor.

Sayilar uydurulmaz: cevrim sayisi gorevden (FPGA'da koprunun donanim
sayacindan), sureler PC'de olculur, boru hatti golden modelden gelir.
"""
import math
import os
import re
import sys

import pygame

import paket

KADEMELER = ["F1", "F2", "D1", "D2", "R1", "R2", "E", "W"]
CLA_MHZ = 100.0            # KV260 pl_clk0
TI_MHZ = 60.0              # TMS320F2803x CLA saati
DENEY = os.path.join(os.path.dirname(os.path.abspath(__file__)), "dongu_hizi_sonuc.json")


def deney_sonucu():
    """dongu_hizi.py'nin olcumu (yoksa None)."""
    try:
        import json
        with open(DENEY) as f:
            return json.load(f)
    except (OSError, ValueError):
        return None

# buyruk sinifi -> renk
SINIF_RENK = {
    "bellek": (79, 160, 220),     # MMOV32 / MMOV16 yukleme-saklama
    "carpma": (168, 145, 236),    # MMPYF32
    "toplama": (240, 161, 74),    # MADDF32 / MSUBF32
    "karsi": (124, 196, 127),     # MMINF32 MMAXF32 MCMPF32 MABSF32 MNEGF32
    "kestirim": (232, 110, 160),  # MEINVF32
    "diger": (140, 156, 172),     # MNOP MSTOP
}


def sinif(metin):
    ad = metin.split()[0] if metin else ""
    if ad.startswith("MMOV"):
        return "bellek"
    if ad.startswith("MMPY"):
        return "carpma"
    if ad.startswith(("MADD", "MSUB")):
        return "toplama"
    if ad.startswith(("MMIN", "MMAX", "MCMP", "MABS", "MNEG")):
        return "karsi"
    if ad.startswith("MEINV"):
        return "kestirim"
    return "diger"


# =================================================================== iz
class BoruIzi(object):
    """CLA programinin bir gorevlik boru hatti izi (golden, boru modeli).

    cevrimler[k] = {"kademe": [pc ya da None] * 8, "durma": None|"dur_exe"|"dur_r1",
                    "bekleyen": kademe indisi (durmada bekleyen kademe)}
    """

    def __init__(self, duzen=None):
        from kontrolcu import GoldenKontrolcu
        duzen = duzen or paket.IC
        g = GoldenKontrolcu(duzen=duzen, model="boru")
        self.kaynak = self._kaynak_satirlari(duzen.casm)
        boru = g.cekirdek.pipeline
        cekirdek = g.cekirdek
        # tipik girdiler (iz veriden bagimsiz: program dalsiz)
        for (_, adr, _), v in zip(duzen.girdiler, duzen.ornek):
            g.mem.write32(adr, paket.f2b(v), who="cpu")
        g.regs.cpu_write(0x22, 0x01)
        if not g.hakem.gorev_basla(g.st):
            raise RuntimeError("gorev baslamadi")
        boru.durdu = False
        self.cevrimler = []
        for _ in range(5000):
            once = [(k.gecerli == 1 and k.pc is not None, k.pc) for k in boru.pipeline_kaydi]
            f1_pc = boru.getir_pc if not boru.durdu else None
            dur_exe, dur_r1 = boru.dur_exe, boru.dur_r1
            devam = cekirdek.step()
            sonra = [(k.gecerli == 1 and k.pc is not None, k.pc) for k in boru.pipeline_kaydi]
            pc = lambda t: t[1] if t[0] else None          # noqa: E731
            if dur_exe:
                kad = [f1_pc] + [pc(t) for t in once[0:6]] + [pc(once[6])]
                durma, bekleyen = "dur_exe", 6
            elif dur_r1:
                kad = [f1_pc] + [pc(t) for t in once[0:4]] + [pc(sonra[5]), pc(sonra[6]), pc(once[6])]
                durma, bekleyen = "dur_r1", 4
            else:
                kad = [pc(t) for t in sonra] + [pc(once[6])]
                durma, bekleyen = None, None
            self.cevrimler.append({"kademe": kad, "durma": durma, "bekleyen": bekleyen})
            if not devam:
                break
        g.hakem.pie_kesmeleri.clear()
        self.cevrim = len(self.cevrimler)
        self.buyruk = len(self.kaynak)
        dolu = [sum(1 for p in c["kademe"] if p is not None) for c in self.cevrimler]
        self.ort_dolu = sum(dolu) / float(self.cevrim)
        self.en_dolu = max(dolu)
        self.tam_dolu = sum(1 for d in dolu if d == 8)
        self.dur_exe = sum(1 for c in self.cevrimler if c["durma"] == "dur_exe")
        self.dur_r1 = sum(1 for c in self.cevrimler if c["durma"] == "dur_r1")
        self.ardisik = self.buyruk * len(KADEMELER)        # boru hatti olmasaydi

    @staticmethod
    def _kaynak_satirlari(yol):
        satirlar = []
        for s in open(yol, encoding="utf-8"):
            s = s.split(";")[0].strip()
            if s:
                satirlar.append(re.sub(r"\s+", " ", s))
        return satirlar

    def metin(self, pc):
        if pc is None:
            return ""
        i = pc // 2
        return self.kaynak[i] if 0 <= i < len(self.kaynak) else "?"


# =================================================================== yardimcilar
def _kart(e, rect, baslik, f, renk=None):
    pygame.draw.rect(e, (24, 32, 43), rect, border_radius=8)
    t = f.render(baslik, True, renk or (140, 156, 172))
    e.blit(t, (rect[0] + 10, rect[1] + 7))


def _yaz(e, f, metin, renk, x, y, sag=False, orta=False):
    t = f.render(metin, True, renk)
    if sag:
        x -= t.get_width()
    elif orta:
        x -= t.get_width() / 2
    e.blit(t, (x, y))
    return t.get_width()


def _sayi(v, basamak=2):
    """Turkce ondalik virgul."""
    return ("%.*f" % (basamak, v)).replace(".", ",")


def _sure(us):
    if us < 1000:
        return "%s µs" % _sayi(us, 2 if us < 10 else 1)
    return "%s ms" % _sayi(us / 1000.0, 2 if us < 10000 else 1)


# =================================================================== CLA sayfasi
# projede olculmus sonuclar (golden_model/test_karsilastirici.py, fpga_kopru/tb/kopru_testi.py, test_kontrolcu.py)
DOGRULAMA = ["RTL ↔ golden: 10 000 program, 0 fark",
             "köprü+CLA ↔ golden: 900 adım, 0 fark",
             "CLA programı ↔ Python ref.: 2000 adım, ≤1,5e-6"]
YAZI = (226, 233, 240)
SOLUK = (140, 156, 172)
CIZGI = (44, 56, 70)
VURGU = (79, 184, 192)
TURUNCU = (240, 161, 74)
YESIL = (124, 196, 127)
KIRMIZI = (240, 112, 96)
MOR = (168, 145, 236)


def cla_sayfasi(e, x, y, w, f, iz, olcum, oynat_cevrim):
    """olcum: {"cevrimler": [..], "pc_ms": [..], "pc_ad": str, "fark": int|None,
               "cevrim_farki": int|None, "adim": int, "kaynak": str}"""
    cev = olcum["cevrimler"]
    son = cev[-1] if cev else iz.cevrim
    us = son / CLA_MHZ
    periyot = 1e6 / olcum["ic_hz"]

    # ---------------- 1) ZAMAN
    h = 150
    _kart(e, (x, y, w, h), "ZAMAN  ·  bir iç döngü adımı", f["kucuk"])
    _yaz(e, f["buyuk"], _sure(us), YAZI, x + 12, y + 26)
    _yaz(e, f["kucuk"], "%d çevrim @ %d MHz  (%s)" % (son, CLA_MHZ, olcum["kaynak"]), SOLUK, x + 12, y + 62)
    pc = olcum["pc_ms"]
    pc_us = (sorted(pc)[len(pc) // 2] * 1000.0) if pc else None
    cubuklar = [("CLA hesabı", us, VURGU)]
    if pc_us:
        cubuklar.append((olcum["pc_ad"], pc_us, TURUNCU))
    cubuklar.append(("iç döngü periyodu (%d Hz)" % olcum["ic_hz"], periyot, SOLUK))
    lo, hi = math.log10(0.1), math.log10(30000.0)
    bx, bw = x + 12, w - 24
    for i, (ad, v, renk) in enumerate(cubuklar):
        yy = y + 84 + i * 18
        u = (math.log10(max(v, 0.1)) - lo) / (hi - lo)
        pygame.draw.rect(e, (34, 44, 58), (bx, yy, bw, 13), border_radius=3)
        pygame.draw.rect(e, renk, (bx, yy, max(3, bw * u), 13), border_radius=3)
        _yaz(e, f["mono_k"], "%s  %s" % (ad, _sure(v)), (16, 22, 30) if u > 0.55 else YAZI, bx + 5, yy)
    tavan = 1000.0 / us                     # kHz
    _yaz(e, f["mono_k"], "log ölçek · CLA yükü %%%s · tavan ~%s" % (_sayi(100.0 * us / periyot, 2),
         ("%s MHz" % _sayi(tavan / 1000.0, 1)) if tavan >= 1000 else ("%d kHz" % round(tavan))),
         SOLUK, x + 12, y + h - 13)
    y += h + 8

    # ---------------- 2) DETERMINIZM
    h = 112
    _kart(e, (x, y, w, h), "DETERMİNİZM  ·  her adım aynı süre", f["kucuk"])
    yarim = (w - 30) / 2
    # CLA cevrim histogrami
    hx, hy, hh = x + 10, y + 30, 50
    if cev:
        say = {}
        for c in cev:
            say[c] = say.get(c, 0) + 1
        mn, mx = min(cev), max(cev)
        alt, ust = mn - 12, mx + 12
        for c, n in say.items():
            bx_ = hx + (c - alt) / float(ust - alt) * yarim
            bh = hh * n / float(len(cev))
            pygame.draw.rect(e, VURGU, (bx_ - 3, hy + hh - bh, 6, bh))
        pygame.draw.line(e, CIZGI, (hx, hy + hh), (hx + yarim, hy + hh), 1)
        sapma = mx - mn
        _yaz(e, f["mono_k"], "CLA: %d–%d çevrim" % (mn, mx) if sapma else "CLA: hep %d çevrim" % mn,
             YAZI, hx, hy + hh + 4)
        _yaz(e, f["mono_k"], "sapma %d · %d adım" % (sapma, len(cev)), YESIL if sapma == 0 else KIRMIZI,
             hx, hy + hh + 18)
    # PC tarafi histogram
    px = x + 20 + yarim
    if len(pc) > 5:
        lo_, hi_ = min(pc), max(pc)
        kutu = 18
        say = [0] * kutu
        for v in pc:
            k = int((v - lo_) / max(hi_ - lo_, 1e-9) * (kutu - 1))
            say[k] += 1
        m = max(say)
        for k, n in enumerate(say):
            bh = hh * n / float(m)
            pygame.draw.rect(e, TURUNCU, (px + k * yarim / kutu, hy + hh - bh, yarim / kutu - 1, bh))
        pygame.draw.line(e, CIZGI, (px, hy + hh), (px + yarim, hy + hh), 1)
        _yaz(e, f["mono_k"], "PC: %s–%s ms" % (_sayi(lo_, 1), _sayi(hi_, 1)), YAZI, px, hy + hh + 4)
        _yaz(e, f["mono_k"], olcum["pc_kisa"], SOLUK, px, hy + hh + 18)
    y += h + 8

    # ---------------- 3) BORU HATTI
    satir_h = 21
    h = 66 + 8 * satir_h + 54
    _kart(e, (x, y, w, h), "PARALELLİK  ·  8 kademeli boru hattı", f["kucuk"])
    _yaz(e, f["mono_k"], "%d buyruk, %d çevrim · ort. %s aynı anda" % (
        iz.buyruk, iz.cevrim, _sayi(iz.ort_dolu, 1)), YAZI, x + 10, y + 26)
    _yaz(e, f["mono_k"], "boru hattısız %d çevrim olurdu → ×%s" % (
        iz.ardisik, _sayi(iz.ardisik / float(iz.cevrim), 1)), YAZI, x + 10, y + 42)
    k = oynat_cevrim % iz.cevrim
    c = iz.cevrimler[k]
    ty = y + 62
    for i, ad in enumerate(KADEMELER):
        yy = ty + i * satir_h
        pc_ = c["kademe"][i]
        bekliyor = c["bekleyen"] is not None and i <= c["bekleyen"] and pc_ is not None
        _yaz(e, f["mono_k"], ad, SOLUK, x + 10, yy + 3)
        r = pygame.Rect(x + 36, yy, w - 46, satir_h - 3)
        if pc_ is None:
            pygame.draw.rect(e, (34, 44, 58), r, 1, border_radius=4)
            onceki = iz.cevrimler[k - 1]["durma"] if k else None
            if (onceki == "dur_exe" and i == 7) or (onceki == "dur_r1" and i == 5):
                _yaz(e, f["mono_k"], "balon (durmanın izi)", SOLUK, r.x + 6, yy + 3)
            continue
        m = iz.metin(pc_)
        renk = SINIF_RENK[sinif(m)]
        pygame.draw.rect(e, tuple(int(v * 0.35) for v in renk), r, border_radius=4)
        pygame.draw.rect(e, KIRMIZI if bekliyor else renk, r, 2 if bekliyor else 1, border_radius=4)
        _yaz(e, f["mono_k"], m[:34], YAZI, r.x + 6, yy + 3)
    # zaman seridi: butun gorev, kademe x cevrim
    sy = ty + 8 * satir_h + 4
    sw = w - 20
    hucre = sw / float(iz.cevrim)
    if getattr(iz, "_serit", None) is None or iz._serit.get_width() != int(sw) + 2:
        iz._serit = pygame.Surface((int(sw) + 2, 24), pygame.SRCALPHA)   # bir kez cizilir
        for j, cc in enumerate(iz.cevrimler):
            for i in range(8):
                p = cc["kademe"][i]
                if p is not None:
                    renk = SINIF_RENK[sinif(iz.metin(p))]
                    if cc["durma"] and i <= cc["bekleyen"]:
                        renk = KIRMIZI
                    pygame.draw.rect(iz._serit, renk, (j * hucre, i * 3, max(1, hucre), 3))
    e.blit(iz._serit, (x + 10, sy))
    pygame.draw.line(e, YAZI, (x + 10 + k * hucre, sy - 3), (x + 10 + k * hucre, sy + 26), 2)
    _yaz(e, f["mono_k"], "çevrim %3d/%d  ·  durma: %d FPU, %d bellek" % (
        k + 1, iz.cevrim, iz.dur_exe, iz.dur_r1), SOLUK, x + 10, sy + 28)
    if c["durma"]:
        _yaz(e, f["mono_k"], "DURMA: %s" % ("E, W'deki FPU sonucunu bekliyor" if c["durma"] == "dur_exe"
                                            else "R1, W'deki yazmayı bekliyor"), KIRMIZI, x + 10, sy + 42)
    y += h + 8

    # ---------------- 4) DOGRULAMA
    h = 84
    _kart(e, (x, y, w, h), "DOĞRULAMA  ·  golden model referans", f["kucuk"])
    if olcum.get("fark") is not None:
        renk = YESIL if olcum["fark"] == 0 and not olcum.get("cevrim_farki") else KIRMIZI
        metin = "canlı: golden ↔ %s %d adım, %d fark" % (olcum.get("karsi_taraf", "FPGA"), olcum["adim"], olcum["fark"])
        if olcum.get("cevrim_farki"):
            metin += ", %d çevrim farkı" % olcum["cevrim_farki"]
    else:
        renk, metin = SOLUK, "canlı karşılaştırma: --kontrolcu ikisi"
    _yaz(e, f["mono_k"], metin, renk, x + 10, y + 26)
    for i, s in enumerate(DOGRULAMA):
        _yaz(e, f["mono_k"], s, YAZI, x + 10, y + 42 + i * 14)
    y += h + 6
    _yaz(e, f["mono_k"], "C: CLA nedir?  ·  Tab: uçuş paneli  ·  S: sunum", SOLUK, x + 4, y)
    return y


# =================================================================== CLA nedir
def _kutu(e, f, rect, baslik, alt, renk, kalin=None):
    r = pygame.Rect(rect)
    pygame.draw.rect(e, tuple(int(v * 0.3) for v in renk), r, border_radius=10)
    pygame.draw.rect(e, renk, r, 2, border_radius=10)
    _yaz(e, kalin or f["orta_k"], baslik, YAZI, r.centerx, r.y + 10, orta=True)
    for i, s in enumerate(alt):
        _yaz(e, f["kucuk"], s, (200, 210, 222), r.centerx, r.y + 34 + i * 16, orta=True)
    return r


def _ok(e, a, b, renk, etiket=None, f=None, iki_yon=False):
    pygame.draw.line(e, renk, a, b, 2)
    ang = math.atan2(b[1] - a[1], b[0] - a[0])
    for uc, yon in ((b, ang),) + (((a, ang + math.pi),) if iki_yon else ()):
        pygame.draw.polygon(e, renk, [uc, (uc[0] - 10 * math.cos(yon - 0.4), uc[1] - 10 * math.sin(yon - 0.4)),
                                      (uc[0] - 10 * math.cos(yon + 0.4), uc[1] - 10 * math.sin(yon + 0.4))])
    if etiket:
        _yaz(e, f["mono_k"], etiket, renk, (a[0] + b[0]) / 2, (a[1] + b[1]) / 2 - 16, orta=True)


def cla_nedir(e, w, h, f, iz, olcum):
    kat = pygame.Surface((w, h), pygame.SRCALPHA)
    kat.fill((10, 14, 20, 238))
    e.blit(kat, (0, 0))
    x0, y = 40, 24
    _yaz(e, f["baslik"], "CLA — Control Law Accelerator", YAZI, x0, y)
    _yaz(e, f["alt"], "TI C2000'deki kontrol yasası yardımcı işlemcisi. Bu projede RTL'den FPGA'ya kendi "
         "tasarımımız.", SOLUK, x0, y + 30)
    cev = olcum["cevrimler"]
    son = cev[-1] if cev else iz.cevrim
    us = son / CLA_MHZ
    ic_hz, dis_hz = olcum["ic_hz"], olcum["dis_hz"]

    # ---------------- blok semasi
    y = 86
    _yaz(e, f["kucuk"], "İŞ BÖLÜMÜ  ·  bu demoda da aynısı", SOLUK, x0, y)
    y += 20
    kest = olcum.get("kestirimli")
    sen = _kutu(e, f, (x0, y + 36, 170, 74), "Sensörler", ["IMU: jiroskop, ivmeölçer" if kest else
                "açı, açısal hız, konum"], (120, 150, 175))
    cla = _kutu(e, f, (x0 + 290, y + 26, 270, 94), "CLA  ·  iç döngü",
                (["sensör füzyonu: IMU'dan açı", "+ açı PD + motorlar"] if kest else ["açı PD + itki + motorlar"]) +
                ["%d Hz, her adım %s" % (ic_hz, _sure(us))], VURGU, f["orta_k"])
    mot = _kutu(e, f, (x0 + 690, y + 36, 170, 74), "Motorlar / PWM", ["itki komutları"], (120, 150, 175))
    cpu = _kutu(e, f, (x0 + 290, y + 166, 270, 80), "CPU  ·  dış döngü", ["konum PID, %d Hz" % dis_hz,
                "+ haberleşme, telemetri"], MOR, f["orta_k"])
    _ok(e, (sen.right + 4, sen.centery), (cla.x - 4, sen.centery), YESIL, "donanım tetiği", f)
    _ok(e, (cla.right + 4, mot.centery), (mot.x - 4, mot.centery), YESIL, "çıktı", f)
    _ok(e, (cla.centerx, cla.bottom + 4), (cla.centerx, cpu.y - 4), SOLUK, None, f, iki_yon=True)
    _yaz(e, f["mono_k"], "mesaj RAM: θ_d, T%s ↓" % (", a" if kest else ""), SOLUK, cla.centerx + 10, cla.bottom + 14)
    notlar = ["• Hızlı ve zaman kritik iş CLA'da:", "  görev donanım tetiğiyle başlar,",
              "  CPU'da kesme (ISR) yok.", "• Yavaş ve karmaşık iş CPU'da;",
              "  ikisi aynı anda çalışır."]
    for i, s in enumerate(notlar):
        _yaz(e, f["kucuk"], s, YAZI, x0 + 600, y + 150 + i * 17)

    # ---------------- paralellik: bir dis dongu periyodu
    y += 262
    tw = 450
    tx = x0 + 110
    _yaz(e, f["kucuk"], "PARALELLİK  ·  bir dış döngü periyodu (%d ms, temsili ölçek)" % round(1000 / dis_hz),
         SOLUK, x0, y)
    y += 22
    n_ic = max(1, ic_hz // dis_hz)
    serit = 20
    for satir, (baslik, ad, tur) in enumerate([("CLA'sız", "CPU", "kesmeli"), ("CLA ile", "CPU", "serbest"),
                                               ("", "CLA", "ic")]):
        yy = y + satir * (serit + 6) + (6 if satir else 0)
        if baslik:
            _yaz(e, f["orta_k"], baslik, YAZI if baslik == "CLA ile" else SOLUK, x0, yy + 1)
        _yaz(e, f["mono_k"], ad, SOLUK, tx - 32, yy + 4)
        pygame.draw.rect(e, (24, 32, 43), (tx, yy, tw, serit), border_radius=4)
        adim = tw / float(n_ic)
        if tur == "kesmeli":
            pygame.draw.rect(e, (90, 80, 140), (tx + 2, yy + 3, tw - 4, serit - 6), border_radius=3)
            pygame.draw.rect(e, (150, 120, 220), (tx + 2, yy + 3, adim * 1.6, serit - 6), border_radius=3)
            for k in range(n_ic):
                pygame.draw.rect(e, KIRMIZI, (tx + k * adim + adim * 0.62, yy + 3, max(4, adim * 0.3), serit - 6),
                                 border_radius=2)
        elif tur == "serbest":
            pygame.draw.rect(e, MOR, (tx + 2, yy + 3, tw - 4, serit - 6), border_radius=3)
            pygame.draw.rect(e, (200, 180, 250), (tx + 2, yy + 3, adim * 1.6, serit - 6), border_radius=3)
            _yaz(e, f["mono_k"], "dış döngü", (16, 22, 30), tx + 6, yy + 4)
        else:
            for k in range(n_ic):
                pygame.draw.rect(e, VURGU, (tx + k * adim + 2, yy + 3, max(4, adim * 0.12), serit - 6),
                                 border_radius=2)
    yy = y + 3 * (serit + 6) + 12
    _yaz(e, f["kucuk"], "CLA'sız: iç döngü %d kez kesmeyle CPU'yu böler (kırmızı)." % n_ic, SOLUK, x0, yy)
    _yaz(e, f["kucuk"], "CLA ile: CPU bölünmez; iç döngü %d kez paralel çekirdekte, her biri %s." % (
        n_ic, _sure(us)), SOLUK, x0, yy + 16)

    # ---------------- neden ic dongu hizli: olcum
    deney = olcum.get("deney")
    gx, gy0, gw, gh = x0 + 600, y - 22, 260, 150
    _yaz(e, f["kucuk"], "NEDEN %d Hz?  ·  ölçüm (dongu_hizi.py)" % ic_hz, SOLUK, gx, gy0)
    if deney:
        r = pygame.Rect(gx, gy0 + 20, gw, gh - 20)
        pygame.draw.rect(e, (24, 32, 43), r, border_radius=8)
        hizlar = deney["hizlar"]
        enb = max(v for g in deney["govdeler"] for v in g["w_max"].values() if v) * 1.1
        ic = pygame.Rect(r.x + 34, r.y + 10, r.w - 44, r.h - 40)
        for k, hz in enumerate(hizlar):
            xx = ic.x + ic.w * k / (len(hizlar) - 1)
            _yaz(e, f["mono_k"], "%d" % hz if hz < 1000 else "%dk" % (hz // 1000), SOLUK, xx, ic.bottom + 4, orta=True)
        for g, renk in zip(deney["govdeler"], (VURGU, TURUNCU)):
            nok = []
            for k, hz in enumerate(hizlar):
                v = g["w_max"].get(str(hz), g["w_max"].get(hz))
                nok.append((ic.x + ic.w * k / (len(hizlar) - 1), ic.bottom - ic.h * v / enb))
            pygame.draw.lines(e, renk, False, nok, 2)
            for p in nok:
                pygame.draw.circle(e, renk, (int(p[0]), int(p[1])), 3)
        _yaz(e, f["mono_k"], "açı bant genişliği ~ iç döngü Hz", SOLUK, ic.x, r.y + 2)
        yeni, eski = deney["govdeler"][0], deney["govdeler"][1]
        w100, w500 = yeni["w_max"]["100"], yeni["w_max"][str(ic_hz)] if str(ic_hz) in yeni["w_max"] else None
        _yaz(e, f["mono_k"], "— 450 g, motor 15 ms (bu demo)", VURGU, gx, r.bottom + 4)
        _yaz(e, f["mono_k"], "— 1 kg, motor 35 ms", TURUNCU, gx, r.bottom + 18)
        if w500:
            _yaz(e, f["kucuk"], "bant genişliği 100 Hz'den %d Hz'e +%%%d" % (
                ic_hz, round(100 * (w500 / w100 - 1))), YAZI, gx, r.bottom + 34)
        db = yeni.get("darbe_ayarli", {})
        d1, d5 = db.get("100"), db.get(str(ic_hz))
        if d1 and d5:
            _yaz(e, f["kucuk"], "darbede tepe açı: 100 Hz %s°, %d Hz %s° (D)" % (
                _sayi(d1["tepe_derece"], 1), ic_hz, _sayi(d5["tepe_derece"], 1)), YAZI, gx, r.bottom + 50)
        _yaz(e, f["kucuk"], "1 kHz'den sonra doyar; 1 kg'da fark yok", SOLUK, gx, r.bottom + 66)
    else:
        _yaz(e, f["kucuk"], "dongu_hizi.py henüz koşulmadı", SOLUK, gx, gy0 + 24)

    # ---------------- bu demoda
    y = yy + 44
    _yaz(e, f["kucuk"], "BU DEMODA KİM NE YAPIYOR", SOLUK, x0, y)
    eslesme = [("Fizik, rüzgâr, motorlar", "PC'deki simülasyon (RK4, 2 kHz)")]
    if kest:
        eslesme.append(("Sensörler: IMU %d Hz, konum %d Hz" % (ic_hz, dis_hz),
                        "PC'de sensor.py (gürültü, sabit hata, gecikme)"))
    eslesme += [
               ("CPU: dış döngü, %d Hz" % dis_hz, "PC'de cpu_dongu.py (konum PID, anti-windup)"),
               ("CLA: %siç döngü, %d Hz" % ("kestirim + " if kest else "", ic_hz),
                "KV260 PL'de bizim RTL'imiz, %d buyruk" % iz.buyruk),
               ("Mesaj RAM, görev tetikleme", "PL'deki köprü (donanım; ARM yalnız bayt taşır)"),
               ("Doğruluk referansı", "golden model: aynı girdiyle bit bit karşılaştırma")]
    eslesme[2 if kest else 1] = ("CPU: dış döngü, %d Hz" % dis_hz,
                                 "PC'de cpu_dongu.py (konum PID%s)" % (", ivme kestirimi" if kest else ", anti-windup"))
    for i, (a, b) in enumerate(eslesme):
        yy = y + 20 + i * 17
        _yaz(e, f["kucuk"], a, YAZI, x0, yy)
        pygame.draw.line(e, VURGU, (x0 + 262, yy + 8), (x0 + 278, yy + 8), 2)
        pygame.draw.polygon(e, VURGU, [(x0 + 282, yy + 8), (x0 + 276, yy + 4), (x0 + 276, yy + 12)])
        _yaz(e, f["kucuk"], b, VURGU, x0 + 290, yy)

    # ---------------- dort olgu
    y += 20 + len(eslesme) * 17 + 12
    ow = (w - 2 * x0 - 3 * 14) / 4.0
    yuk = 100.0 * us * ic_hz / 1e6
    olgular = [(_sure(us), "bir iç döngü adımı", "%d çevrim, %d MHz" % (son, CLA_MHZ)),
               ("0 çevrim", "süre sapması", "dalsız kod, deterministik"),
               (_sayi(iz.ort_dolu, 1), "buyruk aynı anda", "8 kademeli boru hattı"),
               ("%%%s" % _sayi(yuk, 2), "CLA yükü (%d Hz)" % ic_hz, "CPU'ya düşen: 0 kesme")]
    if cev and max(cev) != min(cev):
        olgular[1] = ("%d çevrim" % (max(cev) - min(cev)), "süre sapması", "ölçülen")
    for i, (buyuk, orta, kucuk) in enumerate(olgular):
        r = pygame.Rect(x0 + i * (ow + 14), y, ow, 86)
        pygame.draw.rect(e, (24, 32, 43), r, border_radius=10)
        _yaz(e, f["buyuk"], buyuk, VURGU, r.centerx, r.y + 10, orta=True)
        _yaz(e, f["orta_k"], orta, YAZI, r.centerx, r.y + 46, orta=True)
        _yaz(e, f["kucuk"], kucuk, SOLUK, r.centerx, r.y + 65, orta=True)
    _yaz(e, f["kucuk"], "C: kapat", SOLUK, w - 40, h - 22, sag=True)


if __name__ == "__main__":
    sys.dont_write_bytecode = True
    iz = BoruIzi()
    print("%d buyruk, %d cevrim, ort. %.2f dolu kademe, en cok %d, 8/8 dolu %d cevrim, dur_exe %d, dur_r1 %d"
          % (iz.buyruk, iz.cevrim, iz.ort_dolu, iz.en_dolu, iz.tam_dolu, iz.dur_exe, iz.dur_r1))
    for k in list(range(0, 14)) + [c for c in range(iz.cevrim) if iz.cevrimler[c]["durma"]][:4] + list(range(iz.cevrim - 6, iz.cevrim)):
        c = iz.cevrimler[k]
        print("%3d %-8s %s" % (k + 1, c["durma"] or "", " | ".join(("%03x" % p) if p is not None else " - "
                                                                   for p in c["kademe"])))
