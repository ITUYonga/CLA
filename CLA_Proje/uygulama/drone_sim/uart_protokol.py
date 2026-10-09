# -*- coding: utf-8 -*-
"""PC <-> KV260 UART paket bicimi (uart_kopru/rtl/cla_uart_kopru.sv ile ayni).

    istek : A5 | tip | uzunluk | veri[uzunluk] | saglama
    cevap : 5A | tip | uzunluk | veri[uzunluk] | saglama
    saglama = tip ^ uzunluk ^ veri[0] ^ ... ^ veri[n-1]

Kelimeler 16 bit, kucuk uclu (LSB once). 32 bitlik deger iki kelimedir,
alt kelime alt adreste (CLA ile ayni). Ofsetler mesaj RAM'inin basindan
kelime cinsinden: M2C 0x1500 + ofs, C2M 0x1480 + ofs.

    YANKI 00  veri aynen doner
    YAZ   01  ofs, k kelime          -> M2C[ofs..]           cevap bos
    ADIM  02  ofs, n, k kelime       -> M2C'ye yaz, gorev 1  cevap C2M[0..n-1] + cevrim(32)
    OKU   03  ofs, n                 ->                      cevap C2M[ofs..ofs+n-1]
    SIFIRLA 04 (bos)                 -> CLA tarafi 16 cevrim reset            cevap bos
    HATA  7F  (yalniz cevap) kod: 1 saglama, 2 bilinmeyen tip, 3 zaman asimi, 4 uzunluk
"""
import struct

ISTEK, CEVAP = 0xA5, 0x5A
YANKI, YAZ, ADIM, OKU, SIFIRLA, HATA = 0x00, 0x01, 0x02, 0x03, 0x04, 0x7F
HATA_ADLARI = {1: "saglama", 2: "bilinmeyen tip", 3: "zaman asimi", 4: "uzunluk"}
M2C_TABAN, C2M_TABAN = 0x1500, 0x1480
RAM_KELIME = 128
EN_COK_CEVAP = 64           # ADIM/OKU ile en cok 64 kelime


class ProtokolHatasi(Exception):
    pass


def saglama(tip, veri):
    s = tip ^ len(veri)
    for b in veri:
        s ^= b
    return s & 0xFF


def cerceve(tip, veri=b"", bas=ISTEK):
    veri = bytes(veri)
    if len(veri) > 255:
        raise ValueError("veri en cok 255 bayt")
    return bytes([bas, tip, len(veri)]) + veri + bytes([saglama(tip, veri)])


def kelimelere(degerler32):
    """32 bitlik degerler -> 16 bitlik kelimeler (alt once)."""
    k = []
    for v in degerler32:
        k += [v & 0xFFFF, (v >> 16) & 0xFFFF]
    return k


def degerlere(kelimeler16):
    return [kelimeler16[i] | (kelimeler16[i + 1] << 16) for i in range(0, len(kelimeler16) - 1, 2)]


def _paketle(kelimeler16):
    return struct.pack("<%dH" % len(kelimeler16), *kelimeler16)


def yanki_istegi(veri):
    return cerceve(YANKI, veri)


def yaz_istegi(ofs, kelimeler16):
    return cerceve(YAZ, bytes([ofs]) + _paketle(kelimeler16))


def adim_istegi(ofs, n_cevap, kelimeler16):
    return cerceve(ADIM, bytes([ofs, n_cevap]) + _paketle(kelimeler16))


def oku_istegi(ofs, n):
    return cerceve(OKU, bytes([ofs, n]))


def sifirla_istegi():
    return cerceve(SIFIRLA)


def adr_ofs(adr, taban):
    ofs = adr - taban
    if not 0 <= ofs < RAM_KELIME:
        raise ValueError("adres 0x%04X mesaj RAM'inde degil" % adr)
    return ofs


class Cozucu(object):
    """Bayt akisini cevap cercevelerine ayirir. ekle() tamamlanan
    (tip, veri) listesini dondurur; bozuk saglama ProtokolHatasi atar."""

    def __init__(self, bas=CEVAP):
        self.bas, self.tampon = bas, bytearray()

    def ekle(self, baytlar):
        self.tampon += baytlar
        cikan = []
        while True:
            i = self.tampon.find(bytes([self.bas]))
            if i < 0:
                self.tampon.clear()
                return cikan
            del self.tampon[:i]
            if len(self.tampon) < 3 or len(self.tampon) < 4 + self.tampon[2]:
                return cikan
            tip, n = self.tampon[1], self.tampon[2]
            veri, s = bytes(self.tampon[3:3 + n]), self.tampon[3 + n]
            del self.tampon[:4 + n]
            if s != saglama(tip, veri):
                raise ProtokolHatasi("cevap saglamasi tutmadi (tip %02X)" % tip)
            cikan.append((tip, veri))


def cevabi_coz(tip, veri, beklenen_tip):
    """HATA cevabini istisnaya cevirir; YAZ icin None, ADIM icin
    (kelimeler, cevrim), OKU icin kelimeler dondurur."""
    if tip == HATA:
        kod = veri[0] if veri else 0
        raise ProtokolHatasi("FPGA hata kodu %d (%s)" % (kod, HATA_ADLARI.get(kod, "?")))
    if tip != beklenen_tip:
        raise ProtokolHatasi("beklenen tip %02X, gelen %02X" % (beklenen_tip, tip))
    if tip == ADIM:
        k = list(struct.unpack("<%dH" % ((len(veri) - 4) // 2), veri[:-4]))
        return k, struct.unpack("<I", veri[-4:])[0]
    if tip == OKU:
        return list(struct.unpack("<%dH" % (len(veri) // 2), veri))
    if tip == YANKI:
        return veri
    return None
