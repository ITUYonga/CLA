# -*- coding: utf-8 -*-
"""Komut basina BELLEK / MAR erisim tablosu.

Boru hattinda her asamanin "bu komut icin bende is var mi" sorusunu
`decoded.fields` icini kurcalamadan cevaplayabilmesi icin.

    D2  -> adres uretilecek mi          : adres_uretir(cozum)
    R2  -> bellekten okunacak mi        : okur(cozum)
    W   -> bellege yazilacak mi         : yazar(cozum)
    EXE -> MAR yuklemesi var mi         : mar_yukler(cozum)

Kumelerin anahtari ISA tablosundaki `syntax` dizesi - `DecodedInstruction`
zaten onu tasiyor, yani ek bir esleme gerekmiyor.

DIKKAT - bu liste ELLE bakilarak degil, her komut sahte bir bellekle
calistirilip `read*/write*` cagrilip cagrilmadigi OLCULEREK cikarildi.
`tests/test_erisim.py` ayni olcumu her kosuda tekrarlar; tablo ile gercek
davranis ayrismaya baslarsa test kirilir. Yeni komut baglandiginda once
test kirilir, sonra buraya eklenir - tersi degil.
"""

# ---------------------------------------------------------------------
#  R2'de bellekten okur
# ---------------------------------------------------------------------
OKUR32 = frozenset({
    "MMOV32 MRa, mem32 {, CNDF}",
    "MMOV32 MSTF, mem32",
   
    "MMOVD32 MRa, mem32",
  
    "MI32TOF32 MRa, mem32",
    
    "MUI32TOF32 MRa, mem32",
    "MADDF32 MRd, MRe, MRf ||MMOV32 MRa, mem32",
    "MSUBF32 MRd, MRe, MRf ||MMOV32 MRa, mem32",
    "MMPYF32 MRd, MRe, MRf ||MMOV32 MRa, mem32",
    "MMACF32 MR3, MR2, MRd, MRe, MRf ||MMOV32 MRa, mem32",
})

OKUR16 = frozenset({
   
    "MMOVZ16 MRa, mem16",
    
    "MMOV16 MARx, mem16",
    "MI16TOF32 MRa, mem16",
    
    "MUI16TOF32 MRa, mem16",
   
   
})


# ---------------------------------------------------------------------
#  W'de bellege yazar
# ---------------------------------------------------------------------
YAZAR32 = frozenset({
    "MMOV32 mem32, MRa",
    "MMOV32 mem32, MSTF",

    "MMOVD32 MRa, mem32",                      # hem okur hem yazar
    "MADDF32 MRd, MRe, MRf||MMOV32 mem32, MRa",
    "MSUBF32 MRd, MRe, MRf ||MMOV32 mem32, MRa",
    "MMPYF32 MRd, MRe, MRf ||MMOV32 mem32, MRa",
})

YAZAR16 = frozenset({
  
    "MMOV16 mem16, MRa",
    "MMOV16 mem16, MARx",

})

# ---------------------------------------------------------------------
#  EXE'de MAR0/MAR1 YUKLER  (post-increment degil - o D2'de olur)
#
#  Gecikme icin ozel kod GEREKMEZ: yukleme EXE'de (7. asama), okuma D2'de
#  (4. asama) oldugundan s.580'deki (Ornek 10-2) 3 komutluk golge gecikmesi boru
#  hattinin kendisinden cikar.
# ---------------------------------------------------------------------
MAR_YUKLER = frozenset({
    "MMOVI16 MARx, #16I",
    "MMOV16 MARx, MRa, #16I",
    "MMOV16 MARx, mem16",                      # ayrica bellekten OKUR
})

#  D2'de efektif adres uretilecek komutlar
ADRES_URETIR = OKUR16 | YAZAR16 | OKUR32 | YAZAR32

#  Henuz dagitici.py'de dali olmayan komutlar. Boru hatti bunlari
#  gorurse tabloya degil, BaglanmamisKomutError'a guvenmeli.
BAGLANMAMIS = frozenset()      # 24.09: MEINVF32/MEISQRTF32 baglandi, hepsi dagitildi

DALLANIR = frozenset({
        "MBCNDD 16BitDest {, CNDF}",
    "MCCNDD 16BitDest {, CNDF}",
    "MRCNDD {CNDF}",
})

K2_YAZAR = frozenset({
    # FP sonucu K2'de (W sonunda) yazilan butun bicimler (15)
    "MADDF32 MRa, MRb, MRc",
    "MADDF32 MRa, #16FHi, MRb",
    "MSUBF32 MRa, MRb, MRc",
    "MSUBF32 MRa, #16FHi, MRb",
    "MMPYF32 MRa, MRb, MRc",
    "MMPYF32 MRa, #16FHi, MRb",
    "MMPYF32 MRa, MRb, MRc||MADDF32 MRd, MRe, MRf",
    "MMPYF32 MRa, MRb, MRc ||MSUBF32 MRd, MRe, MRf",
    "MADDF32 MRd, MRe, MRf ||MMOV32 MRa, mem32",
    "MSUBF32 MRd, MRe, MRf ||MMOV32 MRa, mem32",
    "MMPYF32 MRd, MRe, MRf ||MMOV32 MRa, mem32",
    "MMACF32 MR3, MR2, MRd, MRe, MRf ||MMOV32 MRa, mem32",
    "MADDF32 MRd, MRe, MRf||MMOV32 mem32, MRa",
    "MSUBF32 MRd, MRe, MRf ||MMOV32 mem32, MRa",
    "MMPYF32 MRd, MRe, MRf ||MMOV32 mem32, MRa", 
                                    # ayrica bellekten OKUR
})


# ---------------------------------------------------------------------
#  Yardimcilar - cozum None (balon) ise hepsi False doner
# ---------------------------------------------------------------------




def _syntax(cozum):
    if cozum is None:
        return None
    if isinstance(cozum, str):
        return cozum
    return getattr(cozum, "syntax", None)

def dallanir(cozum):
    return _syntax(cozum ) in DALLANIR

def okur16(cozum):
    """R2'de bellekten okuma yapilacak mi."""
    return _syntax(cozum) in OKUR16

def okur32(cozum):
    """R2'de bellekten okuma yapilacak mi."""
    return _syntax(cozum) in OKUR32


def yazar32(cozum):
    """W'de bellege yazma yapilacak mi."""
    return _syntax(cozum) in YAZAR32


def yazar16(cozum):
    """W'de bellege yazma yapilacak mi."""
    return _syntax(cozum) in YAZAR16


def adres_uretir(cozum):
    """D2'de efektif adres uretilecek mi."""
    return _syntax(cozum) in ADRES_URETIR


def mar_yukler(cozum):
    """EXE'de MAR0/MAR1 yuklenecek mi."""
    return _syntax(cozum) in MAR_YUKLER


def baglanmamis(cozum):
    """Komutun dagitici.py'de dali var mi."""
    return _syntax(cozum) in BAGLANMAMIS

def k2_yazar(cozum):
    """Komut K2'de yazmaca yazma yapar mi"""
    return _syntax(cozum) in K2_YAZAR


#  K2'de yazilan MR'ler buyrugun ALANLARINDAN belirlenir (cagri sirasindan degil).
#  Paralel yuklemenin MRa'si ve ZF/NF'si EXE'de kalir; yalniz FP yarisi ertelenir.
#  MMACF32: MR3 (toplama) ve MRd (carpma). MRd == MR3 ise golden sozlukte sonra
#  yazilan toplamayi tutar - ALU'daki "toplayici > carpici" onceligiyle ayni.
def k2_hedefler(cozum):
    """Komutun K2'de (W sonunda) yazdigi MR numaralari; K2 komutu degilse bos."""
    syntax = _syntax(cozum)
    if syntax not in K2_YAZAR:
        return frozenset()
    alan = cozum.fields
    if syntax.startswith("MMACF32"):
        return frozenset({3, alan['d']})
    if "||MADDF32" in syntax or "||MSUBF32" in syntax:
        return frozenset({alan['a'], alan['d']})
    if "MMOV32" in syntax:
        return frozenset({alan['d']})
    return frozenset({alan['a']})



# ---------------------------------------------------------------------
#  EXE'de OKUNAN MR'ler (M3 interlock, dur_exe)
#
#  Anahtar: syntax. Deger: okunan MR'lerin alan adlari (dagitici.py'deki
#  alan[...] adlariyla ayni). Tamsayi ise sabit MR numarasidir (MMACF32'nin
#  MR3 ve MR2'si kodlamada alan degildir).
#  Kosul tutmasa da okunan sayilir (MMOV32 MRa,MRb ve MSWAPF): donanim
#  kosulu EXE'de cozer, okuma ondan once/onunla birlikte yapilir.
#  Listede olmayan buyruk MR okumaz (bellekten yukleme/donusum, MMOVIZ,
#  MAR yuklemeleri, MSTF tasimalari, MSETFLG, MTESTTF, dallar, MSTOP, MNOP...).
# ---------------------------------------------------------------------
OKUNAN_MR_ALANLARI = {
    # tamsayi ve FP aritmetik, uc yazmacli
    "MADD32 MRa, MRb, MRc":  ("b", "c"),
    "MSUB32 MRa, MRb, MRc":  ("b", "c"),
    "MAND32 MRa, MRb, MRc":  ("b", "c"),
    "MOR32 MRa, MRb, MRc":   ("b", "c"),
    "MXOR32 MRa, MRb, MRc":  ("b", "c"),
    "MADDF32 MRa, MRb, MRc": ("b", "c"),
    "MSUBF32 MRa, MRb, MRc": ("b", "c"),
    "MMPYF32 MRa, MRb, MRc": ("b", "c"),
    # anlikli FP: MRb
    "MADDF32 MRa, #16FHi, MRb": ("b",),
    "MSUBF32 MRa, #16FHi, MRb": ("b",),
    "MMPYF32 MRa, #16FHi, MRb": ("b",),
    # tek kaynakli: MRb
    "MABSF32 MRa, MRb":         ("b",),
    "MNEGF32 MRa, MRb{, CNDF}": ("b",),
    "MEINVF32 MRa, MRb":        ("b",),
    "MEISQRTF32 MRa, MRb":      ("b",),
    "MF32TOI16 MRa, MRb":       ("b",),
    "MF32TOI16R MRa, MRb":      ("b",),
    "MF32TOI32 MRa, MRb":       ("b",),
    "MF32TOUI16 MRa, MRb":      ("b",),
    "MF32TOUI16R MRa, MRb":     ("b",),
    "MF32TOUI32 MRa, MRb":      ("b",),
    "MFRACF32 MRa, MRb":        ("b",),
    "MI16TOF32 MRa, MRb":       ("b",),
    "MI32TOF32 MRa, MRb":       ("b",),
    "MUI16TOF32 MRa, MRb":      ("b",),
    "MUI32TOF32 MRa, MRb":      ("b",),
    "MMOV32 MRa, MRb {, CNDF}": ("b",),
    # iki kaynakli: MRa ve MRb
    "MCMPF32 MRa, MRb":         ("a", "b"),
    "MCMP32 MRa, MRb":          ("a", "b"),
    "MMAXF32 MRa, MRb":         ("a", "b"),
    "MMINF32 MRa, MRb":         ("a", "b"),
    "MSWAPF MRa, MRb {, CNDF}": ("a", "b"),
    # MRa'yi okuyanlar
    "MCMPF32 MRa, #16FHi":      ("a",),
    "MMAXF32 MRa, #16FHi":      ("a",),
    "MMINF32 MRa, #16FHi":      ("a",),
    "MLSL32 MRa, #SHIFT":       ("a",),
    "MLSR32 MRa, #SHIFT":       ("a",),
    "MASR32 MRa, #SHIFT":       ("a",),
    "MMOVXI MRa, #16FLoHex":    ("a",),     # ust 16 bit korunur -> MRa okunur
    "MMOV32 mem32, MRa":        ("a",),     # saklanan deger EXE'de okunur
    "MMOV16 mem16, MRa":        ("a",),
    "MMOV16 MARx, MRa, #16I":   ("A",),     # dagitici'da alan adi 'A'
    # paralel
    "MMPYF32 MRa, MRb, MRc||MADDF32 MRd, MRe, MRf":  ("b", "c", "e", "f"),
    "MMPYF32 MRa, MRb, MRc ||MSUBF32 MRd, MRe, MRf": ("b", "c", "e", "f"),
    "MADDF32 MRd, MRe, MRf ||MMOV32 MRa, mem32":     ("e", "f"),
    "MSUBF32 MRd, MRe, MRf ||MMOV32 MRa, mem32":     ("e", "f"),
    "MMPYF32 MRd, MRe, MRf ||MMOV32 MRa, mem32":     ("e", "f"),
    "MADDF32 MRd, MRe, MRf||MMOV32 mem32, MRa":      ("e", "f", "a"),
    "MSUBF32 MRd, MRe, MRf ||MMOV32 mem32, MRa":     ("e", "f", "a"),
    "MMPYF32 MRd, MRe, MRf ||MMOV32 mem32, MRa":     ("e", "f", "a"),
    "MMACF32 MR3, MR2, MRd, MRe, MRf ||MMOV32 MRa, mem32": (3, 2, "e", "f"),
}


def okunan_mr(cozum):
    """Komutun EXE'de okudugu MR numaralari (frozenset). Balon ya da MR
    okumayan komut icin bos kume."""
    alanlar = OKUNAN_MR_ALANLARI.get(_syntax(cozum))
    if not alanlar:
        return frozenset()
    f = cozum.fields
    return frozenset(a if isinstance(a, int) else f[a] for a in alanlar)


# ---------------------------------------------------------------------
#  M4: R1/W bellek durmasi (dur_r1) icin veri blogu.
#  Adres degil BLOK karsilastirilir (TRM s.571-573, s.577).
#  CPU->CLA mesaj RAM'inde (0x1500-0x157F) durma yok: CLA'nin oraya
#  yazmasi yok sayilir. Program RAM'i (L3) veri yolu degil.
# ---------------------------------------------------------------------
def blok(adres):
    """R1/W durmasinda karsilastirilan veri blogu; durma olmayan adres icin None."""
    if adres is None:
        return None
    if 0x8800 <= adres <= 0x8BFF:
        return "L1"
    if 0x8C00 <= adres <= 0x8FFF:
        return "L2"
    if 0x1480 <= adres <= 0x14FF:
        return "C2M"
    return None


def ayni_blok(yazan_ea, okuyan_ea):
    """W'nin yazdigi ve R1'in okudugu adres ayni durma blogunda mi."""
    b = blok(yazan_ea)
    return b is not None and b == blok(okuyan_ea)
