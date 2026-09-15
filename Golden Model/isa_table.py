import os

import yaml

_BURASI = os.path.dirname(os.path.abspath(__file__))
VARSAYILAN_YOL = os.path.normpath(
    os.path.join(_BURASI, os.pardir, "isa", "cla_type0.yaml"))

# Kilavuzdaki cozulmemis celiski. MADD32 ve MF32TOUI16R ikisi de MSW 0x7EC0
# ile basiliyor (s.590 ve s.624). Opcode haritasina gore supheli olan MADD32:
# ucuncu yazmac alan tum komutlar 0x7C00-0x7CE0 blogunda ve o blokta tam bir
# bos slot var (0x7CC0), hemen kardesi MSUB32'nin (0x7CE0) yaninda.
# cl2000 ile derlenip dogrulanacak. Bkz. docs/model_kararlari.md
BILINEN_CAKISMALAR = [
    ("MADD32 MRa, MRb, MRc", "MF32TOUI16R MRa, MRb"),
]


class IsaTableError(Exception):
    """Tablo bozuk veya beklenen bicimde degil."""


_onbellek = None


def load_table(path=None, dogrula=True):
    """Komut tablosunu dondurur.

    Kayitlar spesifiklige gore sirali gelir: mask'inda en cok sabit bit olan
    once. Bugun decoder tum eslesmeleri topladigi icin sira sart degil, ama
    tablo buyudugunde ic ice gecen desenlerde dogru olani one alir.

    path verilirse onbellek atlanir (testlerde sahte tablo icin).
    """
    global _onbellek
    if path is None and _onbellek is not None:
        return _onbellek

    hedef = path or VARSAYILAN_YOL
    try:
        with open(hedef, encoding="utf-8") as dosya:
            ham = yaml.safe_load(dosya)
    except FileNotFoundError:
        raise IsaTableError("Komut tablosu bulunamadi: %s" % hedef)

    if not isinstance(ham, dict) or "instructions" not in ham:
        raise IsaTableError("Tabloda 'instructions' anahtari yok: %s" % hedef)

    tablo = ham["instructions"]
    if not tablo:
        raise IsaTableError("Komut tablosu bos: %s" % hedef)

    tablo = sorted(tablo, key=lambda k: -bin(k["mask"]).count("1"))

    if dogrula:
        dogrula_tablo(tablo)

    if path is None:
        _onbellek = tablo
    return tablo


def onbellegi_temizle():
    """Testler tablo dosyasini degistirdiyse kullanilir."""
    global _onbellek
    _onbellek = None


def dogrula_tablo(tablo):
    """Yukleme aninda ucuz degismezleri kontrol eder.

    Amac tabloyu tekrar dogrulamak degil - bunlar tests/test_isa_table.py'de
    ayrica sinaniyor. Buradaki kontrol, bozuk bir tablo ile calismaya
    baslamayi engelleyen bir emniyet kemeri.
    """
    for k in tablo:
        ad = k.get("syntax", "<isimsiz>")

        if len(k["msw"]) != 16 or len(k["lsw"]) != 16:
            raise IsaTableError("%s: desen 16+16 karakter degil" % ad)

        # mask ve match, desenin kendisinden turemis olmali
        desen = k["msw"] + k["lsw"]
        beklenen_mask = 0
        beklenen_match = 0
        for konum, ch in enumerate(desen):
            if ch in "01":
                bit = 31 - konum
                beklenen_mask |= 1 << bit
                if ch == "1":
                    beklenen_match |= 1 << bit
        if k["mask"] != beklenen_mask:
            raise IsaTableError("%s: mask desenle uyusmuyor" % ad)
        if k["match"] != beklenen_match:
            raise IsaTableError("%s: match desenle uyusmuyor" % ad)

        # fields, tam olarak maske disi bitleri kaplamali
        alan_bitleri = set()
        for bitler in (k.get("fields") or {}).values():
            alan_bitleri |= set(bitler)
        serbest = set(b for b in range(32) if not (k["mask"] >> b) & 1)
        if alan_bitleri != serbest:
            raise IsaTableError(
                "%s: fields serbest bitleri kaplamiyor "
                "(eksik %s, fazla %s)"
                % (ad, sorted(serbest - alan_bitleri),
                   sorted(alan_bitleri - serbest)))


def find_collisions(tablo=None):
    """Ic ice gecen desen ciftlerini bulur.

    Iki komut, ortak sabit bitlerinde ayni degeri tasiyorsa ayni word'e
    uyabilir. Donanimda bu imkansizdir - decoder tek cevap uretmek
    zorundadir - yani boyle bir cift ya tabloda hata ya kilavuzda hatadir.

    Donen liste (syntax_a, syntax_b) ciftlerinden olusur.
    """
    if tablo is None:
        tablo = load_table()

    cakismalar = []
    for i in range(len(tablo)):
        for j in range(i + 1, len(tablo)):
            a, b = tablo[i], tablo[j]
            ortak = a["mask"] & b["mask"]
            if (a["match"] & ortak) == (b["match"] & ortak):
                cakismalar.append((a["syntax"], b["syntax"]))
    return cakismalar


def by_mnemonic(mnemonic, tablo=None):
    """Bir mnemonic'in tum kodlama bicimleri.

    Ornek: MMOV16'nin alti ayri formu var (MAR0/MAR1, mem16/MRa ...).
    """
    if tablo is None:
        tablo = load_table()
    return [k for k in tablo if k["mnemonic"] == mnemonic]
