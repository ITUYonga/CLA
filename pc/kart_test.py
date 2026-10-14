# -*- coding: utf-8 -*-
"""kart_test.py - kartta calisan sistemi (bitstream + radar_server) uctan uca test eder.

    python kart_test.py --kart 192.168.1.50

Kartta radar_server calisiyor olmali. Testler:
  1  baglanti      : sunucu cevap veriyor mu , radar canli mi , CLA KIMLIK dogru mu (bitstream'de CLA var mi)
  2  program       : sunucunun derlendigi drone_cla.h ile bu klasordeki drone.casm ayni program mi (CRC)
  3  CLA adim adim : fizik bu bilgisayarda , CLA kartta (FPGA). Her adim ayni girisle golden modelde de
                     kosturulur , C2M bit bit karsilastirilir. Drone 2 m'ye kalkmali.
  4  kart sim      : fizik kartta (PS) 1 kHz , CLA kartta. Senaryo: kalkis , hedef degisimi , ruzgar , darbe.
                     Kayitlar golden'da tekrar kosturulur; zaman asimi / CLA hatasi olmamali , drone hedefe varmali.
Hepsi gecerse "SISTEM TAMAM" yazar ve 0 ile cikar.
"""
import argparse
import os
import re
import sys
import time
import zlib

BURASI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, BURASI)
import kv260_link as kl  # noqa: E402

C_DURUM_SAYI = 33
KIMLIK = 0x434C4101


def bul(adaylar):
    for a in adaylar:
        p = os.path.normpath(os.path.join(BURASI, a))
        if os.path.exists(p):
            return p
    return None


CASM = bul(["../gui/drone.casm", "../cla/drone.casm", "../../cla_program/drone/drone.casm"])
BASLIK = bul(["../sw/drone_cla.h", "../../board/drone_cla.h"])

sonuclar = []


def sonuc(ad, gecti, aciklama=""):
    sonuclar.append((ad, gecti))
    print("  [%s] %s %s" % ("GECTI" if gecti else "KALDI", ad, aciklama))
    sys.stdout.flush()


def baslik(m):
    print("")
    print("=" * 70)
    print(m)
    print("=" * 70)
    sys.stdout.flush()


def golden_yukle():
    if CASM is None:
        print("  drone.casm bulunamadi (../gui , ../cla ya da ../../cla_program/drone)")
        return None
    try:
        from cla_golden import GoldenCla
        return GoldenCla(CASM)
    except Exception as e:
        print("  golden model yuklenemedi: %s" % e)
        print("  (core.py'nin klasorunu CLA_CORE ortam degiskenine yaz)")
        return None


def farkli(a, b):
    return [i for i in range(C_DURUM_SAYI) if a[i] != b[i]]


# ------------------------------------------------------------------ 1
def test_baglanti(k):
    baslik("1) BAGLANTI")
    try:
        p = k.ping()
        sonuc("radar_server cevap veriyor", True, "(ping %s)" % (p,))
    except Exception as e:
        sonuc("radar_server cevap veriyor", False, str(e))
        return False
    try:
        i = k.cla_info()
    except Exception as e:
        sonuc("CLA bilgisi", False, str(e))
        return False
    ok = i["kimlik"] == KIMLIK
    sonuc("CLA KIMLIK 0x%08X" % KIMLIK, ok, "(okunan 0x%08X)%s" % (
        i["kimlik"], "" if ok else " -> bitstream'de CLA yok ya da CLA_ADR yanlis"))
    if i["sim_calisiyor"]:
        k.sim_komut(kl.SK_DURDUR)
        time.sleep(0.05)
        print("  (calisan sim durduruldu)")
    t = k.sim_telem(0)
    if t["sahte"]:
        print("  UYARI: sunucu SAHTE_DONANIM ile derlenmis; CLA yerine C modeli calisiyor , FPGA test EDILMIYOR")
    return ok


# ------------------------------------------------------------------ 2
def test_program(g):
    baslik("2) PROGRAM (drone.casm <-> sunucunun drone_cla.h'si)")
    if g is None:
        sonuc("golden model", False)
        return
    imza = zlib.crc32(b"".join(w.to_bytes(4, "little") for w in g.kelimeler)) & 0xFFFFFFFF
    print("  drone.casm   : %s" % CASM)
    print("  drone_cla.h  : %s" % BASLIK)
    if BASLIK is None:
        sonuc("CRC", False, "drone_cla.h bulunamadi")
        return
    m = re.search(r"DRONE_CLA_CRC\s+0x([0-9A-Fa-f]+)", open(BASLIK).read())
    h = int(m.group(1), 16) if m else None
    sonuc("CRC ayni", h == imza, "(casm 0x%08X , drone_cla.h %s)%s" % (
        imza, "0x%08X" % h if h is not None else "?",
        "" if h == imza else " -> derle.py'yi calistir , sunucuyu ve bitstream'i yenile"))
    print("  Not: kartin drone_cla.h'si bu bilgisayardakiyle ayni olmali (kopyalandi mi?). FPGA'daki programin")
    print("       dogrulugunu 3. ve 4. test gosterir: golden ile bit bit ayni sonuc ancak ayni programla cikar.")


# ------------------------------------------------------------------ CLA teshis (gorev bitmiyorsa)
YAZMAC = [("MIFR", 0x000), ("MIOVF", 0x004), ("MIER", 0x014), ("MIRUN", 0x018), ("MCTL", 0x01C),
          ("MVECT8", 0x03C), ("IRQ_DURUM", 0x040), ("KONTROL", 0x048)]


def yazmac_oku(k):
    v = k.cla_oku([o for _, o in YAZMAC])
    return dict(zip([a for a, _ in YAZMAC], v))


def teshis(k):
    print("")
    print("  ---- CLA TESHIS")
    try:
        k.sim_komut(kl.SK_DURDUR)
        k.cla_reset()
        y = yazmac_oku(k)
        print("  kurulumdan sonra : " + "  ".join("%s=0x%X" % (a, y[a]) for a, _ in YAZMAC))
        if y["KONTROL"] & 1:
            print("  SONUC: KONTROL bit0 = 1 kalmis , CLA resette tutuluyor.")
            return
        if y["MIER"] != 0x8F or y["MVECT8"] != 0x318:
            print("  SONUC: yazmaclara yazilan okunmuyor (MIER 0x8F , MVECT8 0x318 olmaliydi).")
            print("         AXI yazma yolu (WSTRB / adres) ya da kartta eski radar_server/drone_cla.h olabilir.")
            return
        k.cla_yaz([(0x1FC, 0x12345678)])
        m = k.cla_oku([0x1FC])[0]
        print("  M2C yaz/oku      : 0x%08X %s" % (m, "(tamam)" if m == 0x12345678 else "(YANLIS , 0x12345678 olmali)"))
        k.cla_yaz([(0x040, 0xFF), (0x010, 0x80)])          # IRQ_DURUM temizle , MIFRC gorev 8
        time.sleep(0.05)
        y = yazmac_oku(k)
        print("  gorev 8 tetiklendi , 50 ms sonra : " + "  ".join("%s=0x%X" % (a, y[a]) for a, _ in YAZMAC))
        if y["MIRUN"] & 0x80:
            print("  SONUC: gorev 8 BASLADI ama MSTOP'a hic ulasmadi (MIRUN bit7 = 1 kaldi).")
            print("         En olasi sebep: L3 program bellegi BOS , drone_l3.hex bitstream'e girmemis.")
            print("         Vivado'da kontrol et:")
            print("           1. Block design'da cla_wrapper_0'a cift tikla: PROGRAM_HEX = drone_l3.hex olmali (bos degil).")
            print("           2. drone_l3.hex projeye eklenmis olmali (Add Sources -> Add or create design sources).")
            print("           3. Sentez log'unda 'readmem' ya da 'could not open' uyarisi aramak:")
            print("              Reports -> Synthesis -> runme.log icinde 'drone_l3' ara.")
            print("         Duzelttikten sonra bitstream'i yeniden al.")
        elif y["MIFR"] & 0x80:
            print("  SONUC: gorev 8 bayragi kalkti ama CLA gorevi BASLATMADI (MIFR bit7 = 1 , MIRUN = 0).")
            print("         MIER'de bit7 var mi , CLA_Top saati / reseti bagli mi (cla_wrapper aclk , aresetn) bak.")
        elif y["IRQ_DURUM"] & 0x80:
            print("  SONUC: dogrudan tetikleme CALISTI. Sorun sunucunun bekleme dongusunde olabilir; sunucu.log'u gonder.")
        else:
            print("  SONUC: MIFR , MIRUN , IRQ_DURUM hepsi 0: ya MIFRC yazmasi etkisiz ya da gorev bitti ama")
            print("         'bitti' kesmesi (pie_kesme) IRQ_DURUM'a ulasmiyor. Bu ciktiyi bana gonder.")
    except Exception as e:
        print("  teshis yapilamadi: %s" % e)


# ------------------------------------------------------------------ 3
def test_cla_adim(k, g, adim_n):
    baslik("3) CLA ADIM ADIM (fizik bu PC'de , CLA FPGA'da , her adim golden ile karsilastirilir)")
    if g is None:
        sonuc("golden model", False)
        return
    try:
        import sim_baglanti as sb
        d = sb.Drone()
    except Exception as e:
        sonuc("fizik kutuphanesi (libsim)", False, str(e))
        return
    try:
        k.cla_reset()
        r = k.cla_run(0x80, d.m2c())
    except Exception as e:
        sonuc("CLA sifirla + gorev 8", False, str(e))
        if "zaman" in str(e):
            teshis(k)
        return
    c = r["c2m"]
    sonuc("gorev 8 C2M'yi sifirladi", not any(c[:C_DURUM_SAYI]), "(%d us)" % r["us"])
    d.komut(sb.SK_HEDEF, (0, 0, 2))
    fark_adim, ilk, us_maks, t0 = 0, None, 0, time.time()
    for i in range(adim_n):
        m, mk = d.m2c(), d.maske()
        try:
            r = k.cla_run(mk, m)
        except Exception as e:
            sonuc("adim %d" % i, False, str(e))
            return
        us_maks = max(us_maks, r["us"])
        beklenen, _ = g.calistir(mk, m, c)
        f = farkli(r["c2m"], beklenen)
        if f:
            fark_adim += 1
            if ilk is None:
                ilk = (i, mk, f[:6])
        c = r["c2m"]
        d.c2m_al(c)
        d.adim()
        if i % 500 == 0 or i == adim_n - 1:
            s = d.s
            print("  adim %5d  poz %6.2f %6.2f %6.2f  motor %.2f %.2f %.2f %.2f  golden fark %d" % (
                (i,) + tuple(s.poz) + tuple(s.u) + (fark_adim,)))
            sys.stdout.flush()
    sonuc("FPGA CLA = golden (%d adim)" % adim_n, fark_adim == 0,
          "" if fark_adim == 0 else "(%d adim farkli; ilki adim %d maske 0x%x kelimeler %s)" % ((fark_adim,) + ilk))
    z = d.s.poz[2]
    sonuc("drone 2 m'ye kalkti", abs(z - 2.0) < 0.3, "(z = %.2f m)" % z)
    print("  CLA en uzun gorev %d us , sure %.1f s" % (us_maks, time.time() - t0))


# ------------------------------------------------------------------ 4
SENARYO = [(0, kl.SK_HEDEF, (0, 0, 2), (0, 0), "kalkis 2 m"),
           (3000, kl.SK_HEDEF, (2, 1, 2), (0, 0), "hedef (2,1,2)"),
           (5500, kl.SK_RUZGAR, (4, 0, 0), (0, 0), "ruzgar 4 m/s"),
           (7500, kl.SK_DARBE, (0, 6, 0), (0.3, 0), "darbe 6 N"),
           (9000, kl.SK_RUZGAR, (0, 0, 0), (0, 0), "ruzgar kesildi")]


def test_kart_sim(k, g, sure_adim):
    baslik("4) KART SIM (fizik PS'de 1 kHz , CLA FPGA'da , kayitlar golden ile karsilastirilir)")
    try:
        k.sim_komut(kl.SK_DURDUR)
        k.sim_komut(kl.SK_SIFIRLA)
        k.sim_komut(kl.SK_GOZLEMCI, (0, 0, 0), (1, 0))
        k.sim_komut(SENARYO[0][1], SENARYO[0][2], SENARYO[0][3])
        k.sim_komut(kl.SK_BASLAT)
    except Exception as e:
        sonuc("sim baslat", False, str(e))
        return
    print("  %s" % SENARYO[0][4])
    sira, n, fark, son_adim, t = 1, 0, 0, -1, None
    t0 = son_yaz = time.time()
    while True:
        t = k.sim_telem(1 if g else 0)
        if sira < len(SENARYO) and t["adim"] >= SENARYO[sira][0]:
            _, kom, a, b, ad = SENARYO[sira]
            k.sim_komut(kom, a, b)
            print("  adim %5d  %s" % (t["adim"], ad))
            sira += 1
        if g and t["kayitlar"] and t["kayitlar"][0]["adim"] != son_adim:
            kk = t["kayitlar"][0]
            son_adim = kk["adim"]
            c, _ = g.calistir(kk["maske"], kk["m2c"], kk["c2m_once"])
            n += 1
            fark += bool(farkli(kk["c2m_sonra"], c))
        if time.time() - son_yaz > 2:
            son_yaz = time.time()
            print("  adim %5d  poz %6.2f %6.2f %6.2f  golden %d/%d farkli" % ((t["adim"],) + tuple(t["poz"]) + (fark, n)))
            sys.stdout.flush()
        if t["adim"] >= sure_adim or not t["calisiyor"] or time.time() - t0 > sure_adim / 1000.0 + 20:
            break
        time.sleep(0.03)
    k.sim_komut(kl.SK_DURDUR)
    hata = sum((a - b) ** 2 for a, b in zip(t["poz"], t["hedef"])) ** 0.5
    print("  son: adim %d  poz %.2f %.2f %.2f  hedef %.2f %.2f %.2f  kestirim %.2f %.2f %.2f N" % (
        (t["adim"],) + tuple(t["poz"]) + tuple(t["hedef"]) + tuple(t["kestirim"])))
    print("  gorev sayaclari %s , CLA son %d us / en uzun %d us" % (t["gorev_say"], t["cla_us_son"], t["cla_us_maks"]))
    sonuc("sim sonuna kadar kostu", t["adim"] >= sure_adim, "(%d adim)" % t["adim"])
    sonuc("CLA hatasi yok (zaman asimi / MIOVF)", t["cla_hata"] == 0, "(%d)" % t["cla_hata"])
    sonuc("1 ms'yi asan adim az", t["asim"] <= max(10, t["adim"] // 100), "(%d)" % t["asim"])
    gs = t["gorev_say"]
    oran_ok = gs[0] > 0 and abs(gs[1] * 2 - gs[0]) <= 4 and abs(gs[2] * 10 - gs[0]) <= 20 and abs(gs[3] * 10 - gs[0]) <= 20
    sonuc("gorev oranlari 1 : 1/2 : 1/10 : 1/10", oran_ok, "(%s)" % gs)
    if g:
        sonuc("kayitlar golden ile ayni", n > 0 and fark == 0, "(%d kayit , %d farkli)" % (n, fark))
    sonuc("drone hedefte (< 0.5 m)", hata < 0.5, "(hata %.2f m)" % hata)


def main():
    ap = argparse.ArgumentParser(description="KV260 sistem testi")
    ap.add_argument("--kart", default="192.168.137.92", help="kart IP'si (ip ya da ip:port)")
    ap.add_argument("--adim", type=int, default=2500, help="3. testin adim sayisi")
    ap.add_argument("--sim", type=int, default=12000, help="4. testin adim sayisi (1 adim = 1 ms)")
    a = ap.parse_args()
    host, _, port = a.kart.partition(":")
    print("kart: %s:%s" % (host, port or 5001))
    try:
        k = kl.Kart(host, int(port or 5001), zaman_asimi=5.0)
    except Exception as e:
        print("")
        print("BAGLANILAMADI: %s" % e)
        print("Kartta sunucu calisiyor mu?  ssh ubuntu@%s  ->  cd ~/projects/claCFAR ; sudo ./radar_server" % host)
        return 2
    try:
        if test_baglanti(k):
            g = golden_yukle()
            test_program(g)
            test_cla_adim(k, g, a.adim)
            test_kart_sim(k, g, a.sim)
    except KeyboardInterrupt:
        print("durduruldu")
    except Exception as e:
        sonuc("beklenmeyen hata", False, "%s: %s" % (type(e).__name__, e))
    finally:
        try:
            k.sim_komut(kl.SK_DURDUR)
        except Exception:
            pass
        k.kapat()
    baslik("SONUC")
    for ad, ok in sonuclar:
        print("  %-6s %s" % ("GECTI" if ok else "KALDI", ad))
    hepsi = bool(sonuclar) and all(ok for _, ok in sonuclar)
    print("")
    print("SISTEM TAMAM" if hepsi else "SISTEMDE SORUN VAR (KALDI satirlarina bak)")
    return 0 if hepsi else 1


if __name__ == "__main__":
    sys.exit(main())