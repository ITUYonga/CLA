#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""cla_gui.py - KV260 CLA drone kontrol ekrani (tarayici: http://localhost:8081).

    python3 cla_gui.py --board 192.168.1.50:5001     # kart (radar GUI ile ayni anda calisabilir)
    python3 cla_gui.py --model                        # kartsiz: fizik + cla_ref.c (libsim) bu bilgisayarda

Fizik kartta (PS) 1 kHz kosar , bu program telemetriyi ~30 Hz ceker ve komut gonderir.
Golden denetimi: ayri bir baglantidan son adimin kaydini alip core.py ile tekrar kosturur ,
C2M'nin bit bit ayni olup olmadigini sayar (core.py: pc/ , cla/ ya da CLA_CORE).
Yalniz standart kutuphane + ctypes (--model icin libsim).
"""
import argparse
import json
import os
import queue
import random
import threading
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

import kv260_link as kl

BURASI = os.path.dirname(os.path.abspath(__file__))
C_DURUM_SAYI = 33


# ===================================================================== kartsiz arka uc
class ModelArka(object):
    """Kartin sim thread'inin PC karsiligi: sim_fizik.c + cla_ref.c (libsim) , gercek zamanli."""

    name = "MODEL"

    def __init__(self):
        import sim_baglanti as sb
        self.sb = sb
        self.d = sb.Drone()
        self.kilit = threading.Lock()
        self.calisiyor = False
        self.c2m = [0] * 64
        self.kayitlar = []
        self.asim = 0
        sb.cla_ref(self.d.lib, 0x80, self.d.m2c(), self.c2m)
        threading.Thread(target=self._dongu, daemon=True).start()

    def _dongu(self):
        sonraki = time.monotonic()
        while True:
            sonraki += 0.01
            with self.kilit:
                if self.calisiyor:
                    for _ in range(10):
                        self._adim()
            bek = sonraki - time.monotonic()
            if bek > 0:
                time.sleep(bek)
            else:
                self.asim += 1
                sonraki = time.monotonic()

    def _adim(self):
        d, sb = self.d, self.sb
        m, mk = d.m2c(), d.maske()
        once = list(self.c2m)
        sb.cla_ref(d.lib, mk, m, self.c2m)
        self.kayitlar.append({"adim": d.s.adim, "maske": mk, "m2c": m, "c2m_once": once, "c2m_sonra": list(self.c2m)})
        del self.kayitlar[:-4]
        d.c2m_al(self.c2m)
        d.adim()

    def sim_komut(self, k, a=(0, 0, 0), b=(0, 0)):
        with self.kilit:
            if k == kl.SK_BASLAT:
                self.calisiyor = True
            elif k == kl.SK_DURDUR:
                self.calisiyor = False
            elif k == kl.SK_SIFIRLA:
                self.d.komut(k)
                self.sb.cla_ref(self.d.lib, 0x80, self.d.m2c(), self.c2m)
            else:
                self.d.komut(k, a, b)

    def sim_telem(self, n=0):
        with self.kilit:
            s = self.d.s
            return {"status": 0, "calisiyor": int(self.calisiyor), "adim": s.adim, "asim": self.asim, "cla_hata": 0,
                    "poz": list(s.poz), "hiz": list(s.hiz), "euler": list(s.euler), "acisal": list(s.w),
                    "hedef": list(s.hedef), "motor": list(s.u), "ruzgar": list(s.ruzgar),
                    "kestirim": [x * s.kutle for x in s.kestirim], "motor_verim": list(s.motor_verim),
                    "ek_kutle": s.ek_kutle, "gozlemci": s.gozlemci, "cla_us_son": 0, "cla_us_maks": 0,
                    "gorev_say": self.c2m[28:32], "darbe_aktif": int(s.darbe_kalan_s > 0), "sahte": 1,
                    "kayit_n": min(n, len(self.kayitlar)), "kayitlar": [dict(k) for k in self.kayitlar[-n:]] if n else []}

    def kapat(self):
        pass


def kart_ac(adres):
    h, p = adres.split(":") if ":" in adres else (adres, "5001")
    return kl.Kart(h, int(p))


# ===================================================================== olay dagitici (SSE)
class Hub(object):
    def __init__(self):
        self.kilit = threading.Lock()
        self.alicilar = []

    def abone(self):
        q = queue.Queue(maxsize=200)
        with self.kilit:
            self.alicilar.append(q)
        return q

    def birak(self, q):
        with self.kilit:
            if q in self.alicilar:
                self.alicilar.remove(q)

    def yayinla(self, olay, veri):
        msg = ("event: %s\ndata: %s\n\n" % (olay, json.dumps(veri))).encode()
        with self.kilit:
            for q in self.alicilar:
                try:
                    q.put_nowait(msg)
                except queue.Full:
                    pass


# ===================================================================== motor
class Motor(threading.Thread):
    def __init__(self, ac, hub, isim):
        super().__init__(daemon=True)
        self.ac, self.hub, self.isim = ac, hub, isim
        self.link = None
        self.kilit = threading.Lock()
        self.hata = ""
        self.golden = {"durum": "baslamadi", "n": 0, "fark": 0, "son_adim": 0, "son_fark": None}

    def komut(self, k, a=(0, 0, 0), b=(0, 0)):
        with self.kilit:
            if self.link is None:
                raise ConnectionError("bagli degil")
            self.link.sim_komut(k, a, b)

    def run(self):
        while True:
            try:
                if self.link is None:
                    with self.kilit:
                        self.link = self.ac()
                    self.hata = ""
                with self.kilit:
                    t = self.link.sim_telem(0)
                t.pop("kayitlar", None)
                t["bagli"] = True
                t["kaynak"] = self.isim + (" (SAHTE)" if t["sahte"] and self.isim == "KART" else "")
                t["golden"] = dict(self.golden)
                self.hub.yayinla("telem", t)
                time.sleep(0.033)
            except (OSError, ConnectionError, kl.KartHatasi) as e:
                self.hata = str(e)
                self.hub.yayinla("telem", {"bagli": False, "hata": self.hata, "kaynak": self.isim})
                with self.kilit:
                    if self.link:
                        self.link.kapat()
                    self.link = None
                time.sleep(2)


def golden_dongusu(motor, ac):
    """Ayri baglanti: son kaydi al , core.py ile tekrar kostur , C2M'yi karsilastir."""
    try:
        from cla_golden import GoldenCla
        casm = next((p for p in (os.path.join(BURASI, "..", d, "drone.casm") for d in ("gui", "cla", "../cla_program/drone"))
                     if os.path.exists(p)), os.path.join(BURASI, "..", "cla", "drone.casm"))
        g = GoldenCla(casm)
    except Exception as e:                                  # core.py yoksa GUI yine calisir
        motor.golden["durum"] = "kapali: %s" % e
        return
    motor.golden["durum"] = "calisiyor"
    link = None
    while True:
        try:
            if link is None:
                link = ac()
            t = link.sim_telem(1)
            if not t["calisiyor"] or not t["kayitlar"]:
                time.sleep(0.2)
                continue
            k = t["kayitlar"][0]
            c, _ = g.calistir(k["maske"], k["m2c"], k["c2m_once"])
            fark = sum(1 for i in range(C_DURUM_SAYI) if c[i] != k["c2m_sonra"][i])
            motor.golden["n"] += 1
            motor.golden["fark"] += fark != 0
            motor.golden["son_adim"] = k["adim"]
            motor.golden["son_fark"] = fark
        except (OSError, ConnectionError, kl.KartHatasi):
            if link is not None and link is not motor.link:
                try:
                    link.kapat()
                except Exception:
                    pass
            link = None
            time.sleep(2)


# ===================================================================== HTTP
def isleyici(motor, hub):
    class H(BaseHTTPRequestHandler):
        def log_message(self, *a):
            pass

        def _json(self, obj, kod=200):
            b = json.dumps(obj).encode()
            self.send_response(kod)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(b)))
            self.end_headers()
            self.wfile.write(b)

        def do_GET(self):
            if self.path in ("/", "/index.html"):
                with open(os.path.join(BURASI, "cla_gui.html"), "rb") as f:
                    b = f.read()
                self.send_response(200)
                self.send_header("Content-Type", "text/html; charset=utf-8")
                self.send_header("Content-Length", str(len(b)))
                self.end_headers()
                self.wfile.write(b)
            elif self.path == "/events":
                self.send_response(200)
                self.send_header("Content-Type", "text/event-stream")
                self.send_header("Cache-Control", "no-cache")
                self.end_headers()
                q = hub.abone()
                try:
                    while True:
                        try:
                            m = q.get(timeout=10)
                        except queue.Empty:
                            m = b": ping\n\n"
                        self.wfile.write(m)
                        self.wfile.flush()
                except (BrokenPipeError, ConnectionResetError, OSError):
                    pass
                finally:
                    hub.birak(q)
            else:
                self.send_error(404)

        def do_POST(self):
            if self.path != "/cmd":
                self.send_error(404)
                return
            try:
                c = json.loads(self.rfile.read(int(self.headers.get("Content-Length", 0))) or b"{}")
                op = c.get("op")
                f = lambda k, v=0.0: float(c.get(k, v))            # noqa: E731
                if op == "baslat":
                    motor.komut(kl.SK_BASLAT)
                elif op == "durdur":
                    motor.komut(kl.SK_DURDUR)
                elif op == "sifirla":
                    motor.komut(kl.SK_SIFIRLA)
                    motor.golden.update({"n": 0, "fark": 0})
                elif op == "hedef":
                    motor.komut(kl.SK_HEDEF, (f("x"), f("y"), f("z")))
                elif op == "ruzgar":
                    motor.komut(kl.SK_RUZGAR, (f("x"), f("y"), f("z")))
                elif op == "darbe":
                    aci = random.uniform(0, 6.283) if c.get("rastgele") else f("aci")
                    import math
                    motor.komut(kl.SK_DARBE, (f("kuvvet", 8) * math.cos(aci), f("kuvvet", 8) * math.sin(aci), 0),
                                (f("sure", 0.3), 0))
                elif op == "motor":
                    motor.komut(kl.SK_MOTOR, b=(f("no", 1), f("verim", 1)))
                elif op == "yuk":
                    motor.komut(kl.SK_YUK, b=(f("kg"), 0))
                elif op == "gozlemci":
                    motor.komut(kl.SK_GOZLEMCI, b=(1.0 if c.get("acik") else 0.0, 0))
                else:
                    return self._json({"hata": "bilinmeyen op"}, 400)
                self._json({"tamam": True})
            except (ValueError, TypeError) as e:
                self._json({"hata": str(e)}, 400)
            except (OSError, ConnectionError, kl.KartHatasi) as e:
                self._json({"hata": str(e)}, 503)

    return H


def main():
    ap = argparse.ArgumentParser(description="KV260 CLA drone ekrani")
    ap.add_argument("--board", default="192.168.137.92:5001", help="radar_server adresi (ip:port)")
    ap.add_argument("--model", action="store_true", help="kart yerine bu bilgisayarda fizik + cla_ref")
    ap.add_argument("--http", type=int, default=8081, help="web portu")
    ap.add_argument("--golden-yok", action="store_true", help="golden denetimini kapat")
    a = ap.parse_args()

    hub = Hub()
    if a.model:
        arka = ModelArka()
        ac, isim = (lambda: arka), "MODEL"
    else:
        ac, isim = (lambda: kart_ac(a.board)), "KART"
    motor = Motor(ac, hub, isim)
    motor.start()
    if not a.golden_yok:
        threading.Thread(target=golden_dongusu, args=(motor, ac), daemon=True).start()
    else:
        motor.golden["durum"] = "kapali (--golden-yok)"
    srv = ThreadingHTTPServer(("0.0.0.0", a.http), isleyici(motor, hub))
    srv.daemon_threads = True
    print("CLA drone ekrani: http://localhost:%d  (%s)" % (a.http, isim if a.model else a.board), flush=True)
    srv.serve_forever()


if __name__ == "__main__":
    main()
