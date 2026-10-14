# -*- coding: utf-8 -*-
"""kv260_link.py - kart sunucusuyla (radar_server , TCP 5001) konusan ortak istemci.

Protokol tanimi: sw/kv260_proto.h ve doc/protokol.md. Radar ve CLA GUI'leri ayni anda baglanabilir.

    k = Kart("192.168.1.50")
    k.sim_komut(SK_BASLAT)
    t = k.sim_telem(1)          # sozluk + golden kayitlari
"""
import socket
import struct

MAGIC = 0x5244
HDR = struct.Struct("<HBBHHI")

T_CONFIG, T_RUN, T_PING = 0x01, 0x02, 0x03
T_CLA_INFO, T_CLA_REGWR, T_CLA_REGRD, T_CLA_RUN, T_CLA_RESET = 0x10, 0x11, 0x12, 0x13, 0x14
T_SIM_CONFIG, T_SIM_CMD, T_SIM_TELEM = 0x20, 0x21, 0x22
T_HATA = 0x7F

SK_BASLAT, SK_DURDUR, SK_SIFIRLA, SK_HEDEF, SK_RUZGAR, SK_DARBE, SK_MOTOR, SK_YUK, SK_GOZLEMCI = range(1, 10)

STATUS = {0: "tamam", 1: "DMA hatasi", 2: "DMA zaman asimi", 3: "done zaman asimi", 4: "TX yuklu degil",
          5: "CLA zaman asimi", 6: "gecersiz ofset", 7: "bilinmeyen tip", 8: "mesgul (sim calisiyor)",
          9: "sim yok", 10: "gecersiz parametre", 11: "CLA KIMLIK yanlis (bitstream?)"}

TELEM = struct.Struct("<5I" + "3f3f3f3f3f4f3f3f4f" + "f" + "3I" + "4I" + "3I")
TELEM_ALANLAR = ["status", "calisiyor", "adim", "asim", "cla_hata", "poz", "hiz", "euler", "acisal", "hedef",
                 "motor", "ruzgar", "kestirim", "motor_verim", "ek_kutle", "gozlemci", "cla_us_son",
                 "cla_us_maks", "gorev_say", "darbe_aktif", "sahte", "kayit_n"]
TELEM_BOY = {"poz": 3, "hiz": 3, "euler": 3, "acisal": 3, "hedef": 3, "motor": 4, "ruzgar": 3,
             "kestirim": 3, "motor_verim": 4, "gorev_say": 4}
KAYIT = struct.Struct("<2I64I64I64I")
CLA_INFO = struct.Struct("<9I")


class KartHatasi(Exception):
    pass


class Kart(object):
    def __init__(self, host, port=5001, zaman_asimi=3.0):
        self.sock = socket.create_connection((host, port), timeout=zaman_asimi)
        self.sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
        self.sira = 0

    def kapat(self):
        try:
            self.sock.close()
        except OSError:
            pass

    def _al(self, n):
        b = bytearray()
        while len(b) < n:
            p = self.sock.recv(n - len(b))
            if not p:
                raise ConnectionError("baglanti kapandi")
            b += p
        return bytes(b)

    def xfer(self, tip, govde=b"", cpi=None):
        self.sira = (self.sira + 1) & 0xFFFF
        c = self.sira if cpi is None else cpi
        self.sock.sendall(HDR.pack(MAGIC, tip, 0, c, 0, len(govde)) + govde)
        m, t, _, _, _, ln = HDR.unpack(self._al(HDR.size))
        if m != MAGIC:
            raise ConnectionError("gecersiz magic")
        g = self._al(ln) if ln else b""
        if t == T_HATA:
            st, ist = struct.unpack("<II", g)
            raise KartHatasi("tip 0x%02x: %s" % (ist, STATUS.get(st, st)))
        if t != (tip | 0x80):
            raise ConnectionError("beklenmeyen cevap 0x%02x" % t)
        return g

    @staticmethod
    def _st(st):
        if st:
            raise KartHatasi(STATUS.get(st, str(st)))

    # ---------------------------------------------------------------- CLA alt seviye
    def cla_info(self):
        v = CLA_INFO.unpack(self.xfer(T_CLA_INFO))
        return dict(zip(["status", "kimlik", "kontrol", "mirun", "mifr", "miovf", "mier", "irq_durum",
                         "sim_calisiyor"], v))

    def cla_yaz(self, ciftler):
        g = self.xfer(T_CLA_REGWR, b"".join(struct.pack("<II", o, v & 0xFFFFFFFF) for o, v in ciftler))
        self._st(struct.unpack("<I", g[:4])[0])

    def cla_oku(self, ofsetler):
        g = self.xfer(T_CLA_REGRD, struct.pack("<%dI" % len(ofsetler), *ofsetler))
        st, n = struct.unpack("<II", g[:8])
        self._st(st)
        return list(struct.unpack("<%dI" % n, g[8:8 + 4 * n]))

    def cla_run(self, maske, m2c=(), zaman_asimi_us=0):
        g = self.xfer(T_CLA_RUN, struct.pack("<3I%dI" % len(m2c), maske, zaman_asimi_us, len(m2c), *m2c))
        st, us, irq, ovf = struct.unpack("<4I", g[:16])
        self._st(st)
        return {"us": us, "irq_durum": irq, "miovf": ovf, "c2m": list(struct.unpack("<64I", g[16:16 + 256]))}

    def cla_reset(self):
        self._st(struct.unpack("<I", self.xfer(T_CLA_RESET))[0])

    # ---------------------------------------------------------------- simulasyon
    def sim_komut(self, komut, a=(0, 0, 0), b=(0, 0)):
        self._st(struct.unpack("<I", self.xfer(T_SIM_CMD, struct.pack("<I3f2f", komut, *a, *b)))[0])

    def sim_config(self, kutle, kol, ixx, iyy, izz, kt, km, tau, bolen, kazanc):
        k = list(kazanc) + [0.0] * (40 - len(kazanc))
        g = struct.pack("<8f4II40f", kutle, kol, ixx, iyy, izz, kt, km, tau, *bolen, len(kazanc), *k)
        self._st(struct.unpack("<I", self.xfer(T_SIM_CONFIG, g))[0])

    def sim_telem(self, kayit=0):
        g = self.xfer(T_SIM_TELEM, struct.pack("<I", kayit))
        v = list(TELEM.unpack(g[:TELEM.size]))
        t, i = {}, 0
        for ad in TELEM_ALANLAR:
            n = TELEM_BOY.get(ad, 1)
            t[ad] = v[i] if n == 1 else v[i:i + n]
            i += n
        t["kayitlar"] = []
        for j in range(t["kayit_n"]):
            w = KAYIT.unpack_from(g, TELEM.size + j * KAYIT.size)
            t["kayitlar"].append({"adim": w[0], "maske": w[1], "m2c": list(w[2:66]),
                                  "c2m_once": list(w[66:130]), "c2m_sonra": list(w[130:194])})
        return t

    # ---------------------------------------------------------------- radar
    def ping(self):
        return struct.unpack("<4I", self.xfer(T_PING))
