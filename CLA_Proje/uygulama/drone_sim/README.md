# CLA Drone Simülasyonu

2B, gerçek zamanlı, fizik tabanlı drone simülasyonu. Kontrol, C2000'deki gibi ikiye bölünmüş:

| | Nerede | Hız | İş |
|---|---|---|---|
| **Sensörler** | `sensor.py` | IMU 500 Hz, konum 50 Hz | jiroskop + ivmeölçer (gürültü, sabit hata); konum sistemi (20 ms gecikme, gürültü) |
| **Dış döngü** | simülasyonun CPU'su (`cpu_dongu.py`) | 50 Hz | konum PID, anti-windup → θ_d, T_v; ölçülen hızdan ivme kestirimi |
| **İç döngü** | **CLA** (`ic_kestirim.casm`: golden ya da KV260) | 500 Hz | IMU'dan açı kestirimi (tamamlayıcı süzgeç, ivme telafili) + açı PD + motorlar |
| Fizik | PC | 2 kHz RK4 | 450 g yarış sınıfı quad (`fizik.py`) |

CLA görevi 120 buyruk, **her adımda 160 çevrim** (100 MHz'de 1,6 µs). Her iç adımda 8 değer
gider (jiroskop, ivmeölçer x/z, θ_d, T_v, ölçülen ivme x/y, KORU), 4 değer döner (F_L, F_R, T,
kestirilen θ). `--sensor ideal` ile açıyı doğrudan ölçen eski iç döngü (`ic_dongu.casm`, 45 buyruk,
59 çevrim) kullanılır. FPGA tarafı: `../../fpga_kopru/b_yolu/README.md`.

## Çalıştırma

macOS'ta `sim.command`'a çift tıklayın, ya da:

```
.venv/bin/python sim.py                     # golden, 8 kademeli boru hattı (çevrim doğru)
.venv/bin/python sim.py --kontrolcu fpga  --port auto   # iç döngü KV260'taki CLA'da
.venv/bin/python sim.py --kontrolcu ikisi --port auto   # FPGA sürer, golden çıktıyı ve çevrimi bit bit karşılaştırır
.venv/bin/python sim.py --kontrolcu rtl     # kart yok: karttaki RTL'in Verilator simülasyonu sürer, golden karşılaştırır
.venv/bin/python sim.py --kontrolcu sanal   # kart yok: sanal KV260 (pty) + golden
.venv/bin/python sim.py --ic-hz 100         # iç döngü 100 Hz (kazançlar o hıza göre)
.venv/bin/python sim.py --govde eski        # ilk sürümdeki 1 kg, motoru 35 ms'lik gövde
.venv/bin/python sim.py --sensor ideal      # açı doğrudan ölçülür (eski iç döngü, kestirimsiz)
```

**Ağır çekim:** simülasyon zamanı duvar saatinden bağımsız; her iç adım fiziği tam 2 ms
ilerletir. CLA'ya giden yol (USB) adıma yetişemezse simülasyon yavaşlar, sonuç değişmez;
ekranda "AĞIR ÇEKİM ×…" yazar. Sanal KV260'ta ve `rtl` kipinde adım ~1,6 ms (500 Hz'e
yetişiyor); kartta KV260'ın micro-USB'sine (FTDI) ve işletim sisteminin sürücüsüne bağlı, panelde
"UART gidiş-dönüş" olarak görünür. Üst üste 3 UART hatasında simülasyon duraklar.

`ikisi` ve `rtl` kiplerinde panelde **golden≠FPGA** sayacı (yeşil 0 = RTL golden'la bit bit aynı)
ve çevrim farkı görünür. Çevrim, kartta köprünün sayacından gelir: ilk getirmeden boru hattı
boşalana kadar, golden'la aynı tanım.

İlk kurulum (yalnız bir kez):

```
python3.11 -m venv --system-site-packages .venv
.venv/bin/pip install pygame-ce pyserial
```

Golden model `../../golden_model/core.py`'den okunur; başka yerdeyse `CLA_GOLDEN=/yol` verin.
`--kontrolcu rtl` için Verilator 5 gerekir (RTL açılışta birkaç saniyede derlenir).

## KV260 ile (CLA FPGA'da)

CLA programı bitstream'e gömülür; simülasyonun seçtiği programla aynı olmalı:

| Simülasyon | CLA programı | Bitstream (`fpga_kopru` klasöründen) |
|---|---|---|
| `sim.py` (varsayılan, `--sensor gercek`) | `ic_kestirim.casm`, 160 çevrim | `vivado -mode batch -source b_yolu/vivado_olustur.tcl -tclargs 4` |
| `sim.py --sensor ideal` | `ic_dongu.casm`, 59 çevrim | `... -tclargs 4 ../uygulama/drone_sim/ic_dongu_l3.hex` |

1. Program değiştiyse L3 dosyasını yeniden üretin: `.venv/bin/python l3_uret.py` (`--mimari ic` ideal sensör için).
2. Bitstream'i üretip karta yükleyin: `../../fpga_kopru/b_yolu/README.md` adım 1–4.
3. Kartı golden'la birlikte sürün: `.venv/bin/python sim.py --kontrolcu ikisi --port auto`.
4. Panelde golden≠FPGA ve çevrim farkı 0 kalıyorsa yalnız kartla uçun: `--kontrolcu fpga --port auto`.

Açılışta `FpgaKontrolcu` karttaki programı denetler (bir ADIM, çevrim sayısı programı belirler).
Yanlış bitstream sessizce yanlış kuvvet üretmez; simülasyon açılmadan hangi programın yüklü olduğunu
ve hangi komutun gerektiğini yazar.

## Kontroller

| Tuş | İş |
|---|---|
| Fare sol (basılı) | hedef |
| Fare sağ | olduğu yerde asılı kal |
| ← → | ortalama rüzgâr −/+ 1 m/s (±15) |
| T | türbülans seviyesi 0–3 |
| G | ani esinti (1−cos, 7 m/s, 2 s) |
| Y | 0,15 kg yük tak/çıkar (kontrolcü bilmez; dış döngü integratörü telafi eder) |
| N | güçlü titreşim: IMU gürültüsü ×3 (`--sensor ideal`'de ölçüme gürültü) |
| O | otomatik rota (sekiz çizer) |
| **I** | iç döngü hızı 100 / 250 / 500 / 1000 Hz; **kazançlar değişmez** (500 Hz için ayarlı) |
| **D** | kola darbe: 0,15 N·m, 60 ms tork vuruşu (EĞİM grafiğinde toparlanmayı izleyin) |
| Tab | sağ panel: UÇUŞ ↔ CLA sayfası |
| C | "CLA nedir?" anlatım ekranı (tıklayınca kapanır) |
| S | sunum modu: otomatik rota; uçuş paneli → CLA paneli → anlatım ekranı (20/30/25 s) |
| F | tam ekran |
| R | sıfırla (CPU'daki integratörler de sıfırlanır) |
| Boşluk | duraklat |
| H | yardımı gizle/göster |

## Sensörler ve açı kestirimi

Gerçek bir drone eğim açısını ölçemez, kestirir. `sensor.py`:

| Sensör | Model |
|---|---|
| jiroskop (500 Hz) | gerçek ω + kalibrasyon kalıntısı sabit hata (σ 0,3°/s, her sıfırlamada yeni) + gürültü (≈0,01 rad/s, titreşim dahil) |
| ivmeölçer (500 Hz) | gövde ekseninde özgül kuvvet (son adımın ivmesi + g; yer teması dahil) + sabit hata (σ 0,05 m/s²) + gürültü (≈0,3 m/s²) |
| konum sistemi (50 Hz) | x, y, vx, vy + gürültü (1 cm, 3 cm/s), bir örnek (20 ms) gecikmeli |

Gürültüler yoğunlukla verilir (örnek başına σ ~ √hız); N tuşu titreşimi 3 katına çıkarır.
Değerler MEMS IMU + titreşim için tipik mertebeler, ölçülmüş değil.

CLA'daki kestirim: `th = tp + K (atan(g_x/g_z) − tp)`, `tp = th + gx·dt`, `K = dt/1,5 s`; burada
`g = f − R(−tp)·a` ivmeölçerden, CPU'nun konum sisteminden kestirdiği **gerçek** ivme çıkarılarak
bulunur. Neden: çok rotorlu bir araçta ivmeölçer manevrada yerçekimini değil itki + sürüklemeyi
ölçer. Ölçümler (otomatik rota, 3 m/s rüzgâr, türbülans 2):

| Kestirimci | normal rota | sert basamaklar (en kötü an) |
|---|---|---|
| telafisiz tamamlayıcı süzgeç (τ 3 s) | 2,2° rms | 21,5° |
| PID'in *istediği* ivmeyle telafi | ıraksıyor (rüzgârda istenen ≠ gerçek ivme) | — |
| **ölçülen ivmeyle telafi (τ 1–2 s, seçilen)** | **0,3–1° rms** | **4–6°** |

Kestirim hatası rota hatasına yansımıyor (dış döngü kapatıyor). EĞİM grafiğinde θ, θ istek ve
θ kestirim birlikte çizilir. `dongu_hizi.py` deneyi ideal sensörle yapıldı.

## Gövde: neden 450 g ve neden 500 Hz

İlk sürümdeki 1 kg'lık gövdenin motor zaman sabiti 35 ms'ydi; bu mekanik sınır iç döngüyü
hızlandırmanın faydasını yok ediyordu. Gövdeyi **fiziksel olarak tutarlı** biçimde küçük
yarış sınıfına ölçekledik (`fizik.py`, `DroneParam`):

| | ilk (1 kg) | şimdi (450 g) |
|---|---|---|
| kütle, kol | 1,0 kg, 0,25 m | 0,45 kg, 0,09 m |
| eylemsizlik | 0,012 kg·m² | 1,3·10⁻³ kg·m² |
| motor + pervane zaman sabiti | 35 ms | 15 ms (hafif pervane, 10–20 ms aralığı) |
| itki / ağırlık | 2,2 | 5,4 |

Bu değerler sınıfa uygun mertebeler, **ölçülmüş değil**. Gövde ekranda büyütülmüş çizilir.

`dongu_hizi.py` iç döngü hızının etkisini ölçer (sonuç `dongu_hizi_sonuc.json`, anlatım ekranında grafik):

| iç döngü | iyi sönümlü en büyük açı bant genişliği (450 g) | darbede tepe açı, adil ayar (450 g) | aynı, 1 kg |
|---|---|---|---|
| 100 Hz | 34,5 rad/s | 8,4° | 1,9° |
| 250 Hz | 43,5 | 6,0° | 1,7° |
| **500 Hz** | **46,9** | **5,3°** | 1,6° |
| 1 kHz | 50,7 | 4,7° | 1,5° |
| 2 kHz | 50,7 | 4,6° | 1,5° |

"Adil ayar": her hız kendi kazancıyla (ω = 0,8·ω_max). Sonuç: küçük gövdede 100 → 500 Hz
bant genişliğini %36 artırıyor, darbe tepesini %37 azaltıyor; 1 kHz'den sonra doyuyor.
1 kg'lık gövdede fark yok (mekanik sınır). Rüzgârdaki konum hatası iki gövdede de iç döngü
hızından bağımsız (dış döngü ve rüzgâr belirliyor). 500 Hz kazancın çoğunu alıyor ve
UART'la gerçek zamanlı çalışabiliyor.

Sınırlar: tek eksen (yunuslama), PD iç döngü, bozucu ve gürültü modelleri varsayım.

## Dosyalar

| Dosya | İçerik |
|---|---|
| `ic_kestirim.casm` | **CLA programı**: açı kestirimi + iç döngü (120 buyruk, 160 çevrim, dalsız; kestirim L1'de) |
| `sensor.py` | Sensör modelleri (IMU, konum sistemi) ve kestirimin float64 aynası |
| `ic_dongu.casm` | İdeal sensörlü iç döngü (45 buyruk, 59 çevrim); `--sensor ideal` |
| `cpu_dongu.py` | Simülasyonun CPU'su: dış döngü (konum PID), iki hızlı zamanlayıcı `Zincir`, iç döngünün float64 aynası |
| `paket.py` | Mesaj RAM sözleşmesi; `ICK` (varsayılan), `IC` (ideal sensör), `TEK` (ilk sürüm) düzenleri, kazanç tablosu |
| `kontrolcu.py` | CLA arka uçları: `GoldenKontrolcu`, `FpgaKontrolcu` (UART; açılışta karttaki programı denetler), `IkiliKontrolcu` (çıktı + çevrim karşılaştırması) |
| `uart_protokol.py` | PC ↔ KV260 paket biçimi (`../../fpga_kopru/rtl/cla_kopru_cekirdek.sv` ile aynı) |
| `sanal_fpga.py` | Kart yokken: pty üzerinde sanal KV260; içinde golden (`sanal`) ya da karttaki RTL'in Verilator simülasyonu (`rtl`) |
| `cla_vitrin.py` | CLA paneli ve "CLA nedir?" ekranı (boru hattı izi golden'dan, ölçüm grafiği json'dan) |
| `dongu_hizi.py` | İç döngü hızı deneyi (bant genişliği, rüzgâr, darbe; iki gövde) |
| `l3_uret.py` | CLA programı → `ic_kestirim_l3.hex` (`--mimari ic` / `tek`: diğerleri), `$readmemh`, lint'ten geçerse |
| `fizik.py` | Düzlemsel quadrotor fiziği (RK4), motor gecikmesi, sürtünme, rüzgâr, darbe torku |
| `sim.py` | Görsel simülasyon (pygame) |
| `test_kontrolcu.py` | Üç CLA programını Python referansına, boru hattı ↔ ardışık modele karşı doğrular; çevrim sabit mi |
| `kontrolcu.casm` | İlk sürüm: bütün kaskad CLA'da, 100 Hz (177 buyruk, 207 çevrim); yedek olarak duruyor |

## CLA vitrini (Tab, C, S)

Sayılar ölçümden gelir, elle yazılmaz:

- **Zaman:** iç döngü görevinin çevrim sayısı (golden'dan; FPGA modunda köprünün donanım
  sayacından), 100 MHz'de süresi (1,6 µs); log ölçekte PC/UART süresi ve 2 ms'lik iç döngü periyoduyla.
- **Determinizm:** her adımın CLA çevrim histogramı (hep 160, sapma 0) ile PC/UART süresi (değişken).
- **Paralellik:** golden boru hattından çıkarılan iz; 8 kademede hangi buyruğun olduğu canlı
  oynar, durmalar kırmızı (35 FPU, 2 bellek). Ortalama 7,4 buyruk aynı anda; boru hattısız 960 çevrim olurdu.
- **Doğrulama:** `ikisi` / `rtl` kipinde canlı golden ↔ FPGA (RTL) farkı; RTL, köprü ve program doğrulama sonuçları.
- **"CLA nedir?":** CPU (dış döngü) / CLA (iç döngü) iş bölümü; bir dış döngü periyodunda
  CLA'sız (iç döngü 10 kez CPU'yu keser) ve CLA'lı zaman çizelgesi; "neden 500 Hz" ölçümü;
  bu demoda kimin ne yaptığı; dört ana sayı.

## İç döngü (CLA'da)

0. Açı kestirimi (yukarıda); aşağıda θ kestirilen açı, ω jiroskop ölçümü.
1. `T = T_v / cos θ` — `cos` polinomla, bölme `MEINVF32` + iki Newton adımı.
2. `ΔF = I/(2L) · (K_p (θ_d − θ) − K_d ω)`, `K_p = ω²`, `K_d = 2·0,8·ω` (ω hıza göre tablodan).
3. `F_R = T/2 + ΔF`, `F_L = T/2 − ΔF`, `[0, F_max]` (`MMINF32`/`MMAXF32`).

## Dış döngü (CPU'da)

Konum PID: `a = K_p·e − K_d·v + K_i·i`, sınırlı. İntegratör yalnız ivme sınıra dayanmamışken
ve drone neredeyse dururken (|v| < 1 m/s) çalışır, girdisi ±1 m'de kırpılır. Sonra
`θ_d = −atan(a_x / (g + a_y))` ve `T_v = m (g + a_y)` mesaj RAM'iyle CLA'ya gider.
