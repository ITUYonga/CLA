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
#  (4. asama) oldugundan s.579'daki 3 komutluk golge gecikmesi boru
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
BAGLANMAMIS = frozenset({
    "MBCNDD 16BitDest {, CNDF}",
    "MCCNDD 16BitDest {, CNDF}",
    "MRCNDD {CNDF}",
    "MNOP",
    "MDEBUGSTOP",
    "MEINVF32 MRa, MRb",
    "MEISQRTF32 MRa, MRb",
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
