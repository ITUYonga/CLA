"""CLA_Top kabul: golden paketindeki her program icin RTL izini, son bellegi ve yazmaclari karsilastirir."""
import sys, os, subprocess, glob
P = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "golden_paket")
GK = os.environ.get("CLA_GOLDEN", os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "golden_model"))
PY = os.environ.get("PY", sys.executable)            # golden icin Python 3.10+ ve PyYAML
TB = sys.argv[1] if len(sys.argv) > 1 else "./obj_tb_top/tb_top"
os.makedirs("rtl_cikti", exist_ok=True)

def hex_oku(yol):
    v = []
    for l in open(yol):
        l = l.split("//")[0].strip()
        if not l or l.startswith("@"): continue
        v.append(int(l, 16))
    return v

def yazmac_oku(yol):
    d = {}
    for l in open(yol):
        p = l.split()
        if p: d[p[0]] = " ".join(p[1:]).lower()
    return d

# golden_paket/boru_hatti_testleri/beklenen (23 kural programi) ve golden_paket/ornek_cikti (alu_kabul_1)
onekler = sorted(t[:-len("_golden.trace")] for t in glob.glob(P + "/**/*_golden.trace", recursive=True))
toplam_hata = 0
for on in onekler:
    ad = os.path.basename(on); cik = os.path.join("rtl_cikti", ad)
    r = subprocess.run([TB, "+PROG=" + on, "+CIKTI=" + cik], capture_output=True, text=True)
    if r.returncode != 0 or not os.path.exists(cik + ".trace"):
        print("%-36s TEZGAH HATASI: %s" % (ad, (r.stdout + r.stderr)[-300:])); toplam_hata += 1; continue
    c = subprocess.run([PY, "-B", GK + "/tools/compare_trace.py", on + "_golden.trace", cik + ".trace"],
                       capture_output=True, text=True, env=dict(os.environ, PYTHONDONTWRITEBYTECODE="1"))
    iz = "iz AYNI" if c.returncode == 0 else "iz FARKLI"
    bel = []
    for b in ("L1", "L2", "C2M"):
        if hex_oku(on + "_beklenen_%s.hex" % b) != hex_oku(cik + "_son_%s.hex" % b): bel.append(b)
    gy, ry = yazmac_oku(on + "_beklenen_yazmac.txt"), yazmac_oku(cik + "_son_yazmac.txt")
    yaz = [k for k in gy if gy[k] != ry.get(k)]
    satir = sum(1 for l in open(on + "_golden.trace") if not l.startswith("#"))
    tamam = c.returncode == 0 and not bel and not yaz
    toplam_hata += 0 if tamam else 1
    print("%-36s %4d satir  %-9s  bellek %-8s  yazmac %s" % (ad, satir, iz, "AYNI" if not bel else "FARKLI " + ",".join(bel),
          "AYNI" if not yaz else "FARKLI " + ", ".join("%s golden %s rtl %s" % (k, gy[k], ry.get(k)) for k in yaz)))
    if c.returncode != 0:
        print("    " + "\n    ".join(c.stdout.strip().splitlines()[:14]))
print("program: %d  hatali: %d" % (len(onekler), toplam_hata))
