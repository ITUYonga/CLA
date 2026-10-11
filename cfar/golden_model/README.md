# Aviation RSP MATLAB - Radar Sinyal İşleme Golden Modeli

Uçak üzerindeki bir radarın uçtan uca sinyal işleme zincirinin (darbe üretimi,
alınan sinyal modeli, eşleştirilmiş filtre, MTI, Doppler işleme, CFAR tespiti ve
son işleme) MATLAB simülasyonu.

Bu kod aynı zamanda **RoC (Radar on Chip) FPGA projesinin golden modelidir**:
FPGA üzerinde gerçeklenen her blok, buradaki floating point karşılığıyla
karşılaştırılarak doğrulanacaktır.

> Kaynak makale: S. Liaquat, N. M. Mahyuddin, I. H. Naqvi, "An End-to-End Modular
> Framework for Radar Signal Processing: A Simulation-Based Tutorial", *IEEE
> Aerospace and Electronic Systems Magazine*, vol. 39, no. 9, pp. 98-118, 2024.
> DOI: 10.1109/MAES.2023.3334689

Bu depo makale gerçeklemesinin üzerine şunları ekler: clutter modeli, CFAR için
son işleme algoritması, Pd/Pfa performans ölçümü (tek senaryo ve Monte Carlo),
uçak ve hedeflerin LLA koordinatlarından geometri (LLA - ECEF - NED - BODY),
açıya bağlı anten kazancı ve bunları doğrulayan deneyler.

**Diğer dokümanlar:**
- `DEVLOG.md`: geliştirme günlüğü, alınan kararlar, devir teslim notları, sıradaki işler.
- `experiments/`: bu dosyadaki sonuçları yeniden üreten scriptler.

## İçindekiler

1. [Hızlı Başlangıç](#1-hızlı-başlangıç)
2. [Depo Yapısı](#2-depo-yapısı)
3. [Sistem Parametreleri](#3-sistem-parametreleri)
4. [Senaryolar](#4-senaryolar)
5. [İşlem Zinciri ve Bloklar](#5-işlem-zinciri-ve-bloklar)
6. [Sinyal Modelleri](#6-sinyal-modelleri)
7. [Anten Modeli](#7-anten-modeli)
8. [Geometri](#8-geometri)
9. [Performans Ölçümü](#9-performans-ölçümü)
10. [Grafikler](#10-grafikler)
11. [FPGA Arayüzü ve Tasarım İlkeleri](#11-fpga-arayüzü-ve-tasarım-ilkeleri)
12. [Deneyler ve Sonuçlar](#12-deneyler-ve-sonuçlar)
13. [Bilinen Sorunlar ve Sınırlar](#13-bilinen-sorunlar-ve-sınırlar)
14. [Yol Haritası: Akan Zamanda Canlı Tespit](#14-yol-haritası-akan-zamanda-canlı-tespit)
15. [Geliştirme Süreci](#15-geliştirme-süreci)
16. [Sözlük](#16-sözlük)

---

## 1. Hızlı Başlangıç

**Gereksinimler:** MATLAB (R2025b ile denendi) ve şu toolbox'lar:

| Toolbox | Kullanılan fonksiyonlar |
|---|---|
| Signal Processing | `chebwin`, `sinc` |
| Aerospace | `angle2dcm` |
| Mapping | `lla2ecef` |

**Çalıştırma:** `main_radar_sim.m` dosyasını açıp çalıştır. Script bölümlere ayrılmıştır:
seçimler (senaryo, tohum, grafikler, Monte Carlo) bölüm 1'de, radar / CFAR parametreleri
bölüm 2-3'te, senaryo verileri bölüm 4'te, işlem zinciri bölüm 7'de (STEP 1-6). Zincire
dokunmadan oynamak için sadece bölüm 1-4 değiştirilir. Rastgelelik gürültü ve clutter'dan
gelir. `rng_seed = 1` (bölüm 1) sonuçları tekrarlanabilir yapar, `[]` yazılırsa sayılar her
çalıştırmada biraz değişir.

**Beklenen çıktı** (`rng_seed = 1`, LLA senaryosu):

```
Menzil(km): 84.7 118.2 84.8 118.8 52.0
Azimuth(deg): 53.5 89.6 53.5 68.7 64.5
Elevation(deg): 0.4 0.5 3.8 0.5 1.3
Radial Velocity: 15.0 -15.0 0.0 10.0 20.0

 No    R (km)    Pattern   Moving   SNR (dB)  Detected
 1       84.7      0.0 dB      yes      45.26       yes
 2      118.2    -48.1 dB      yes      28.60         -
 3       84.8     -0.3 dB       no      44.53         -
 4      118.8    -20.7 dB      yes      25.97         -
 5       52.0    -14.7 dB      yes      28.47         -

Pd = 1.00 (1 / 1 illuminated moving targets)
Pfa = 0.00e+00
True Targets (km) :  84.6
Detected targets (km) :   84.6
```

Bunun yanında 9 figür açılır (bkz. [Grafikler](#10-grafikler)). Tam çalışma süresi
ölçülmedi. CFAR ve CA-CFAR döngüleri ile clutter üretimi MATLAB'da birkaç on saniye
ile bir iki dakika arası sürebilir.

**Diğer çalıştırmalar:**

| Ne | Nasıl |
|---|---|
| Monte Carlo | `main_radar_sim.m` bölüm 1'de `run_monte_carlo = true` yap (bkz. 9.3) |
| FPGA test vektörleri (tek frame) | `main_radar_sim.m` bölüm 1'de `export_vectors = true` yap. Çıktı `vectors/vec_<ad>_nfft<NFFT>/` (bkz. `docs/FPGA_GOLDEN_MODEL_VERI_DOKUMANI.md` 5.1) |
| İki yakın hedef çözünürlük deneyi | `func_resolution_test` (bkz. 12.4) |
| CFAR parametre taraması | `experiments/exp_sweep_cfar_params.m` (bkz. 12.2) |
| CFAR parametre doğrulaması (100 tohum) | `experiments/exp_validate_cfar_params.m` (bkz. 12.3) |

---

## 2. Depo Yapısı

Depo düz bir klasör: her fonksiyon ayrı bir `func_*.m` dosyası, ana script
`main_radar_sim.m`.

```
main_radar_sim.m                Ana script: parametreler, senaryo, zincir, grafikler, performans
README.md                       Bu dosya
DEVLOG.md                       Geliştirme günlüğü ve devir teslim notları
experiments/                    Sonuçları yeniden üreten scriptler

-- Darbe üretimi
func_lfm_gen.m                  LFM (chirp) darbesi
func_param_barker_gen.m         Barker kodlu darbe (2, 3, 5, 7, 11, 13)
func_b_gen.m                    Rastgele +-1 kodlu darbe

-- Alınan sinyal
func_get_received_signal.m      Radar denklemi + Doppler + gürültü ile alınan sinyal
func_clutter_gen.m              Menzile göre sönümlenen clutter
func_calculate_noise.m          Gürültü sabiti (noisefloor / termal / snr modları)

-- Geometri ve anten
func_target_setup.m             Senaryo seçimi: 'simple' veya 'lla'
func_geometry_engine.m          LLA -> menzil, azimuth, elevation
func_lla2ned_custom.m           LLA -> ECEF -> NED
func_bodyangles2ned.m           Beam açıları -> NED vektörü (sadece çizim için)
func_beam_pattern.m             Tek eksen sinc^2 anten deseni (dB)
func_effective_gain.m           Azimuth ve elevation'a bağlı efektif kazanç (doğrusal)
func_antenna_loss.m             ESKİ polyfit modeli (kullanılmıyor, bkz. 13)
func_plot_antenna_loss.m        ESKİ modelin çizimi (kullanılmıyor)

-- Sinyal işleme zinciri
func_window_processing.m        Dolph-Chebyshev pencereleme
func_matched.m                  Eşleştirilmiş filtre
func_mti.m                      3 darbe sönümleyici MTI
func_fft_processing.m           Doppler FFT (sıfır doldurma + fftshift)
func_os_cfar.m                  OS-CFAR (tespit kararında kullanılan)
func_ca_cfar.m                  CA-CFAR (sadece karşılaştırma grafiği için)
func_cfar_post_processing.m     CFAR sonrası gruplama ve yan lob eleme

-- Performans
func_score_detections.m         Pd/Pfa sayım kuralı (ortak)
func_performance.m              Tek senaryo için Pd, Pfa, SNR ve hedef tablosu
func_monte_carlo.m              N deneme için ortalama Pd ve Pfa
func_resolution_test.m          İki yakın hedef çözünürlük deneyi
func_export_vectors.m            FPGA test vektörleri (.mem dosyaları ve manifest.json)

-- Grafik
func_plot_pipeline.m            Zincir grafikleri (7 figür)
func_plot_beam_polar.m          Anten polar deseni
func_plot_lla.m                 Uçak, hedefler ve beam'in 3D görünümü
```

`.gitignore`: `*.asv` (MATLAB otomatik kayıt) ve `*.mat`. Proje sunumu
(`CANERTURK_SUNUM.pptx`) repoda değil.

---

## 3. Sistem Parametreleri

Hepsi `main_radar_sim.m` üst kısmında tanımlı. Değişirse boyutlar ve sonuçlar da değişir.

### 3.1 Radar ve örnekleme

| Parametre | Değer | Açıklama |
|---|---|---|
| `fs` | 1 MHz | Örnekleme frekansı |
| `fc` | 3 GHz | Taşıyıcı frekans |
| `lambda` | 0.1 m | Dalga boyu (c / fc) |
| `c` | 3e8 m/s | Işık hızı |
| `tau` | 20 µs | Darbe genişliği |
| `B` | 400 kHz | LFM bant genişliği |
| `k_lfm` | 2e10 Hz/s | Chirp oranı (B / tau) |
| `PRI` | 1 ms | Darbe tekrar aralığı |
| `PRF` | 1 kHz | 1 / PRI |
| `Pt` | 1 kW | Verici gücü |
| `noise_floor` | -111 dBm | Gürültü tabanı |
| `noise_amp` | ~8.9e-8 | Gürültü sabiti (`sqrt(10^((-111-30)/10))`) |
| `clutter_amp` | 10 x `noise_amp` | Clutter genlik sabiti |

### 3.2 Boyutlar

Donanımda **ayrı parametreler** olarak tutulmalı. İkisi şu an 20 çıkıyor ama aynı şey değil.

| Parametre | Değer | Açıklama |
|---|---|---|
| `N_PRI` | 1000 | Bir PRI'daki örnek sayısı (`fs * PRI`), menzil ekseni derinliği |
| `N_Pulse_Sample` | 20 | Tek bir darbenin örnek sayısı (`fs * tau`) |
| `N_Pulse` | 20 | Bir CPI'daki darbe sayısı, yavaş zaman ekseni derinliği |
| `NFFT` | 256 | Doppler FFT boyutu |

### 3.3 CFAR ve son işleme

| Parametre | Değer | Açıklama |
|---|---|---|
| `num_ref` | 30 | Referans hücre sayısı (yarısı solda, yarısı sağda) |
| `num_guard` | 6 | Koruma hücresi sayısı (yarısı solda, yarısı sağda) |
| `k` | **20** | OS-CFAR'da sıralı referans hücrelerinden kaçıncısının alındığı |
| `threshold_factor` | **8** | Eşiği yükselten çarpan |
| `peak_ratio` | 0.5 | Son işlemede iki komşu tepenin güç oranı toleransı |
| `max_gap` | 15 | Son işlemede iki komşu tespit arası izin verilen menzil hücresi farkı |
| `N_trials` | 50 | Monte Carlo deneme sayısı |

`k = 20` ve `threshold_factor = 8` değerleri deneyle seçildi (bkz. 12.2 ve 12.3).

### 3.4 Türetilmiş büyüklükler

| Büyüklük | Değer | Hesap |
|---|---|---|
| Menzil hücresi | 150 m | `c / (2 fs)` |
| Belirsizlik olmayan menzil | 150 km | `c * PRI / 2` |
| LFM menzil çözünürlüğü (teorik) | 375 m (~2.5 hücre) | `c / (2 B)` |
| CPI süresi | 20 ms | `N_Pulse * PRI` |
| Doppler FFT hücre aralığı | 3.9 Hz = 0.195 m/s | `PRF / NFFT`, hız = `fd * lambda / 2` |
| Doppler çözünürlüğü (18 darbe) | ~55.6 Hz = ~2.8 m/s | `PRF / 18` (pencere daha da genişletir) |
| Belirsizlik olmayan radyal hız | **+-25 m/s** | `+- lambda * PRF / 4` |
| Kör hız | 50 m/s ve katları | `lambda * PRF / 2` (MTI'nın sildiği Doppler) |

**Not:** Belirsizlik olmayan radyal hız aralığı (+-25 m/s) uçak hızlarının çok altında.
Daha yüksek hızlar Doppler ekseninde sarmalanır ve `n * 50 m/s` hızları MTI tarafından
silinir. Uçuş senaryosunda bu önemli (bkz. 14).

---

## 4. Senaryolar

`func_target_setup(mode, params)` iki mod sunar. Mod, `main_radar_sim.m` bölüm 1'deki
`scenario_mode` ile seçilir (`'simple'` ya da `'lla'`, varsayılan `'lla'`). İki mod da
çalışır durumda test edildi.

### 4.1 `'simple'` mod (`p` struct'ı)

Hedefler doğrudan menzil ve hızla verilir, tüm hedefler aynı antenin tam kazancını alır.
Makaledeki senaryo.

| Hedef | Menzil | Hız | RCS |
|---|---|---|---|
| 1 | 45 km | +15 m/s | 10 m² |
| 2 | 55 km | -15 m/s | 10 m² |
| 3 | 70 km | 0 m/s (MTI siler) | 10 m² |
| 4 | 80 km | +10 m/s | 10 m² |
| 5 | 141 km | +20 m/s | 10 m² |

Anten kazancı `p.Gt = 10^(35/10)` (35 dBi, doğrusal).

### 4.2 `'lla'` mod (`q` struct'ı)

Uçak ve hedefler enlem/boylam/irtifa ile verilir. Geometri motoru menzil, azimuth ve
elevation'ı hesaplar, anten deseni her hedefin kazancını belirler.

**Uçak:** LLA `[39.9, 32, 10000 m]`, attitude `[0 0 0]` (roll, pitch, yaw).
`q.ac_vel_ned = [200 0 0]` tanımlı ama **kullanılmıyor** (radyal hız elle veriliyor).

**Anten:** Boresight azimuth `53.5104°`, elevation `0.3797°`. `q.hpbw_az = 6°`,
`q.hpbw_el = 20°`, yan lob tabanı `q.floor_dB = -50 dB`, tepe kazanç `q.Gt = 35 dBi`.

**Hedefler ve bu anten için sonuçlar:**

| Hedef | LLA | Menzil | Azimuth | Elevation | Hız | Desen | Efektif Gt |
|---|---|---|---|---|---|---|---|
| T1 | 40.35, 32.80, 10000 | 84.7 km | 53.5° | 0.4° | +15 m/s | 0.0 dB | 35.0 dBi |
| T2 | 39.90, 33.38, 10000 | 118.2 km | 89.6° | 0.5° | -15 m/s | -48.1 dB | -13.1 dBi |
| T3 | 40.35, 32.80, 5000 | 84.8 km | 53.5° | 3.8° | 0 m/s | -0.3 dB | 34.7 dBi |
| T4 | 40.28, 33.30, 10000 | 118.8 km | 68.7° | 0.5° | +10 m/s | -20.7 dB | 14.3 dBi |
| T5 | 40.10, 32.55, 9000 | 52.0 km | 64.5° | 1.3° | +20 m/s | -14.7 dB | 20.3 dBi |

RCS hepsi 10 m². Radyal hızlar `q.V_radial` ile verilir.

Bu senaryoda **beam sadece T1'i kapsıyor**. T3 beam içinde ama durağan olduğundan MTI onu
siliyor. T2, T4 ve T5 beam dışında. Bu yüzden Pd sadece T1 üzerinden ölçülür (bkz. 9).

---

## 5. İşlem Zinciri ve Bloklar

```
                       LFM darbesi (1x20)
                              |
      +-----------------------+---------------------------+
      |                                                   |
      v                                                   v
 Hedef + gürültü (func_get_received_signal)        Dolph-Chebyshev pencere
 + Clutter (func_clutter_gen)                      (func_window_processing)
      |                                                   |
      v                                                   |
   rx (1000x20 karmaşık)                                  |
      |                                                   |
      +-------------------> Eşleştirilmiş filtre <--------+
                            (func_matched)
                              1000x20
                                 |
                                 v
                            MTI (func_mti)
                              1000x18
                                 |
                                 v
                Doppler öncesi pencere (func_window_processing)
                              1000x18
                                 |
                                 v
                  Doppler FFT (func_fft_processing)
                              1000x256
                                 |
                                 v
                     OS-CFAR (func_os_cfar)
            os_cfar_output ve os_threshold_map (1000x256 gerçek)
                                 |
                                 v
              Son işleme (func_cfar_post_processing)
             detected_idx (değişken uzunluk, 1..1000)
```

Ana zincirin yanında **sadece grafik amaçlı** ek çıktılar da hesaplanır: `matched_fft_output`,
`mti_fft_output` (matched filter ve MTI çıkışlarının FFT'si) ve `ca_threshold_map`
(CA-CFAR eşiği). Tespit kararına girmezler.

### 5.1 Blok özeti

| Blok | Fonksiyon | Girdi | Çıktı |
|---|---|---|---|
| TX darbesi | `func_lfm_gen` | 1x20 zaman dizisi, chirp oranı | 1x20 karmaşık |
| TX pencereleme | `func_window_processing` | 1x20 karmaşık | 1x20 karmaşık |
| RX üretimi | `func_get_received_signal` + `func_clutter_gen` | senaryo parametreleri | 1000x20 karmaşık |
| Eşleştirilmiş filtre | `func_matched` | 1x20 ve 1000x20 karmaşık | 1000x20 karmaşık |
| MTI | `func_mti` | 1000x20 karmaşık | 1000x18 karmaşık |
| Doppler pencere | `func_window_processing` | 1000x18 karmaşık | 1000x18 karmaşık |
| FFT | `func_fft_processing` | 1000x18 karmaşık | 1000x256 karmaşık |
| OS-CFAR | `func_os_cfar` | 1000x256 karmaşık | 1000x256 + 1000x256 gerçek |
| Son işleme | `func_cfar_post_processing` | 1000x256 karmaşık ve gerçek | 1xN gerçek tam sayı (N değişken) |

### 5.2 Darbe üretimi (`func_lfm_gen`)

`exp(j*pi*k_lfm*t^2)`, `t = (0:19)/fs`. Her örnekte genlik 1. Anlık frekans `k_lfm * t`,
yani 0 Hz'den 400 kHz'e giden bir yukarı chirp (merkezlenmemiş, [-200, +200] kHz değil).
Barker (`func_param_barker_gen`) ve rastgele Barker (`func_b_gen`) alternatifleri
`main_radar_sim.m` bölüm 5'te yorum satırı olarak duruyor, bu çalışmalarda test edilmedi.

### 5.3 Eşleştirilmiş filtre (`func_matched`)

Filtre katsayısı: `conj(fliplr(t_pulse))` (windowed darbe). Her darbe sütunuyla ayrı ayrı
`conv(..., 'same')`. Çıktı girdiyle aynı boyutta.

**Gecikme:** `d` örnek gecikmeyle gelen bir hedef, `'same'` konvolüsyonu ve
`func_get_received_signal` içindeki darbe yerleşimi (`d - 8 ... d + 11`) sonucunda matched
filter çıkışında **d+1. hücrede** tepe verir. Menzil = `(hücre - 1) * c / (2 fs)`.

### 5.4 MTI (`func_mti`)

3 darbe sönümleyici: `y[p] = x[p] - 2 x[p+1] + x[p+2]`, hızlı zaman satırı başına yavaş zaman
ekseninde. 20 darbe 18'e iner. **Sıfır Doppler'i (durağan hedef ve clutter) siler**, yavaş
hareket eden hedefleri de zayıflatır. Sarmalanma nedeniyle `n * 50 m/s` hızlı hedefler de silinir.

### 5.5 Doppler öncesi pencereleme (`func_window_processing`)

`chebwin(N, 80)`: 80 dB yan lob bastırmalı Dolph-Chebyshev. Sütun sayısı kadar (TX'de 20,
MTI çıkışında 18) katsayı. Yan lobları sabit seviyede tutar, ana lobu genişletir.

### 5.6 Doppler FFT (`func_fft_processing`)

Yavaş zaman ekseninde `fft(signal, NFFT, 2)`, 18 örnek 256'ya **sıfır doldurulur**, sonra
`fftshift` ile sıfır Doppler ortaya alınır. Sıfır doldurma çözünürlüğü artırmaz, sadece
spektrumu daha sık örnekler. Hız ekseni grafiklerde `linspace(-PRF/2, PRF/2, NFFT) * lambda/2`.

### 5.7 OS-CFAR (`func_os_cfar`)

Girdi önce güce çevrilir: `power = |data|^2`. Her Doppler sütunu için ve her menzil
hücresi `j` (test hücresi, CUT) için:

1. Referans hücreleri: solda `j - g/2 - r/2 ... j - g/2 - 1`, sağda
   `j + g/2 + 1 ... j + g/2 + r/2` (`g = num_guard`, `r = num_ref`, yani 15 + 15 = 30 hücre).
   Koruma hücreleri (`g/2 = 3` hücre her yanda) hesaba katılmaz.
2. Referans güçleri sıralanır, **`k`. en küçük** alınır.
3. Eşik = `sorted(k) * threshold_factor`.
4. `power(j) > eşik` ise `os_cfar_output(j) = power(j)`, yoksa 0.

Çıktılar: `os_cfar_output` (eşiği geçen hücrede gerçek güç, geçmeyende 0; **bayrak matrisi
değil**) ve `os_threshold_map` (her hücre için eşik). İkisi de 1000x256, gerçek.

**Kenar davranışı:** Kenarda referans hücre sayısı azalır ve `k` kırpılır
(`min(k, length)`), bu da kenarda eşiği yükseltir. Hiç referans yoksa hücre atlanır.

**Uygulama notu:** Kod her menzil hücresi için tüm Doppler sütunlarını birlikte işleyecek
şekilde vektörleştirildi (tam boyutta 1.37 s -> 0.06 s). Çıktı eski satır satır
uygulamayla birebir aynı (`isequal`).

`func_ca_cfar` aynı pencerede `mean(ref) * threshold_factor` eşiği verir. Sadece
karşılaştırma grafiği içindir.

### 5.8 Son işleme (`func_cfar_post_processing`)

CFAR çıktısının sadece menzil eksenine indirgendiği ve sonucun değişken uzunlukta olduğu blok.

1. Her menzil hücresi için 256 Doppler hücresinin **en büyüğü** alınır, hem güç hem eşik için:
   `input_max` ve `threshold_max` (1000x1). **Hız bilgisi burada kaybolur.**
2. `input_max > threshold_max` olan ardışık hücreler gruplanır, her grubun en yüksek
   noktası bir aday olur.
3. Komşu aday çiftleri için: aralarındaki mesafe `max_gap` hücreden küçükse ve güç oranı
   `peak_ratio`'dan küçük veya `1/peak_ratio`'dan büyükse ("çok farklı yükseklik") yan lob
   sayılıp **büyük olan** tutulur. Aksi halde (uzak veya benzer güçte) iki ayrı hedef.

Çıktı `detected_idx`: 1 ile 1000 arası **menzil hücresi indeksleri**, uzunluğu senaryoya
göre değişir (0 da olabilir, birkaç da). Donanımda sabit boyutlu buffer ve geçerli sayısı
sinyali olarak tasarlanmalı. `detected_idx` hız bilgisi taşımaz.

---

## 6. Sinyal Modelleri

### 6.1 Alınan sinyal (`func_get_received_signal`)

Her darbe `i` ve her hedef `t` için:

```
d      = round(2 * R(t) / c * fs)                       gecikme (örnek)
fd     = 2 * V(t) * fc / c                              Doppler frekansı
Pr     = Pt * Gt(t)^2 * lambda^2 * rcs(t) / ((4*pi)^3 * R(t)^4)
genlik = sqrt(Pr)
rx(d-8 : d+11, i) += pulse * genlik * exp(j * 2*pi * fd * (i-1) / PRF)
```

- `Gt(t)^2` monostatik radarda gönderme ve alma kazançlarının çarpımıdır (aynı anten). Bu
  yüzden anten deseni **iki yönlü** etki eder.
- Faz sadece Doppler'e bağlı. Menzile bağlı taşıyıcı fazı (`exp(-j*4*pi*R/lambda)`) yok.
- Hedef, `max(idx) > N_PRI` ise sessizce atlanır.
- Gürültü: `noise_amp .* (rand .* exp(j*2*pi*rand))`. **Genlik düzgün dağılımlı**
  (`rand`), Gauss değil, güç `noise_amp^2 / 3`. Bkz. 13.
- `c`, `fc`, `fs`, `PRF` bu fonksiyonun **içinde sabit yazılmış**, `main_radar_sim.m`'deki
  parametrelere bağlı değil.

### 6.2 Clutter (`func_clutter_gen`)

Menzile göre sönümlenen, hafif Doppler yayılımlı basit bir clutter:

- Her menzil hücresi `d` için bağımsız bir karmaşık Gauss genlik (`randn + j randn`) ve
  `clutter_amp * profil(d)`. `profil = 1/sqrt(menzil)`, en büyük değerine normalize.
- Her hücreye rastgele bir hız `V_clutter = 0.5 * randn` (m/s) atanır, Doppler
  `fd = 2 V_clutter / lambda`. Yani clutter **sıfır etrafında** hafif yayılmış.
- Her hücre darbe şeklinde (20 örnek) yayılır.

Bu model, uçağın hareketinden kaynaklanan clutter Doppler kaymasını içermez (bkz. 14).

---

## 7. Anten Modeli

`func_effective_gain(Gt_max_dB, az, el, beam_az, beam_el, hpbw_az, hpbw_el, floor_dB)`
hedefin body-frame açılarına ve antenin baktığı yöne göre doğrusal kazanç döndürür.

**Tek eksen deseni** (`func_beam_pattern`):

```
g(theta)   = sinc^2( L * sin(theta) ),    L = 0.442946 / sin(hpbw / 2)
gain_dB    = max( 10 log10(g), floor_dB )
```

- MATLAB'daki `sinc(x) = sin(pi x)/(pi x)`. `sinc^2(x) = 0.5` `x = 0.442946`'da olduğundan
  desen `theta = hpbw/2`'de tam -3 dB.
- Boresight'ta 0 dB.

**İki eksen:** Azimuth ve elevation desenleri dB olarak toplanır (ayrılabilir çarpım),
`floor_dB` ile alttan kırpılır:

```
Gt_eff = 10 ^ ( (Gt_max_dB + max(L_az + L_el, floor_dB)) / 10 )
```

**Azimuth sarma:** Boresight'tan fark `mod(az - beam_az + 180, 360) - 180` ile
[-180, 180]'e sarılır (170° ve -170° 20° farklıdır, 340° değil).

**Sınırlar:** Arka yarım küre ayrıca bastırılmıyor (sadece polar çizimde). Sinc yan lobları
var, `hpbw_el = 20°` için 30° civarında desen tekrar -14 dB'ye çıkar.

**Eski model:** `func_antenna_loss` (5 nokta polyfit) ve `func_plot_antenna_loss` artık
kullanılmıyor. Bu modelin parametreleri (`q.ang_az`, `q.loss_az`, `q.ang_el`, `q.loss_el`,
`q.x_interval`) `main_radar_sim.m`'den kaldırıldı.

---

## 8. Geometri

Dönüşüm zinciri: **LLA -> ECEF -> NED -> BODY**.

1. `func_lla2ned_custom`: `lla2ecef` ile hedef ve uçak ECEF'e çevrilir, fark vektörü uçağın
   konumundaki yerel NED çerçevesine döndürülür (kuzey, doğu, aşağı).
2. `func_geometry_engine`: NED vektörü `angle2dcm(yaw, pitch, roll)` ile body'ye çevrilir.
   - Menzil = vektörün normu.
   - Azimuth = `atan2d(y, x)` (sağa pozitif).
   - Elevation = `atan2d(z, sqrt(x^2 + y^2))`. **Body z ekseni aşağı baktığı için elevation
     aşağı pozitiftir.** Aynı irtifadaki bir hedef, dünyanın eğriliği yüzünden uçağın
     yatay düzleminin biraz altında kalır (T1: 84.7 km'de ~561 m aşağıda, el = +0.38°).
   - Radyal hız **hesaplanmıyor**, `q.V_radial` elle veriliyor.
3. `func_bodyangles2ned` sadece çizimde kullanılır (beam yönü -> NED vektörü). Yukarı
   pozitif elevation kabul eder, bu yüzden çizim tarafında işaret çevrilir.

---

## 9. Performans Ölçümü

### 9.1 Sayım kuralı (`func_score_detections`)

`func_performance` ve `func_monte_carlo` bu **tek fonksiyonu** kullanır, iki yerde farklı
tanım yoktur.

- **Geçerli hedef:** hareketli (`v ~= 0`, MTI durağanı siler) **ve** beam içinde (efektif
  kazanç boresight'tan en fazla 3 dB düşük).
- **Menzil hücresi:** `round(2 R / c * fs) + 1` (matched filter gecikmesi, bkz. 5.3).
- **İsabet:** geçerli hedefin hücresinin +-5 hücre (`tol = 5`) içinde bir tespit varsa.
- **Pd:** `isabet / geçerli hedef sayısı` (hedefler üzerinden sayılır).
- **Yanlış alarm:** hiçbir geçerli hedefe yakın olmayan tespit. Beam dışı bir hedefin
  menzil hücresine denk gelen tespit de yanlış alarm (clutter) sayılır.
- **Pfa:** `yanlış alarm / 1000` (toplam menzil hücresi).

### 9.2 Tek senaryo (`func_performance`)

Hedef tablosu (her hedef için menzil, desen, hareketli mi, SNR, tespit durumu), Pd, Pfa,
gerçek ve tespit edilen menziller yazdırır. Beam dışı ve durağan hedeflerde tespit durumu
`-` yazar (görülmesi beklenmez).

SNR sütunu FFT çıkışındaki en büyük değerden hesaplanır (clutter ve işlem kazancı dahil),
bu yüzden **gerçek SNR değildir**. Beam dışı hedeflerde bile yüksek çıkar.

### 9.3 Monte Carlo (`func_monte_carlo`)

Aynı zinciri `N_trials` kez çalıştırır. Her denemede clutter ve gürültü yeniden üretilir,
hedefler ve anten kazancı sabit kalır. Ortalama Pd ve Pfa döndürür. `main_radar_sim.m`
bölüm 1'de `run_monte_carlo = true` yapılınca bölüm 9'daki çağrı çalışır:

```matlab
func_monte_carlo(N_trials, num_ref,num_guard,threshold_factor,k,...
                 t_pulse,R,v,rcs,Pt,Gt_eff,Gt_max,noise_amp,clutter_amp,...
                 c,fs,N_PRI,N_Pulse,NFFT,peak_ratio,max_gap)
```

`main_radar_sim.m`'de pencerelenmiş darbe ayrı bir değişkendedir (`t_pulse_win`), `t_pulse`
temiz kalır ve Monte Carlo'ya doğrudan verilir (darbe fonksiyon içinde bir kez
pencerelenir).

---

## 10. Grafikler

`main_radar_sim.m` çalışınca 9 figür açılır:

| Figür | Fonksiyon | Ne gösterir |
|---|---|---|
| Anten deseni | `func_plot_beam_polar` | Azimuth deseninin polar çizimi |
| Alınan sinyal | `func_plot_pipeline` | rx'in 3D görünümü (menzil x darbe x dB) |
| Matched filter çıkışı | `func_plot_pipeline` | Sıkıştırılmış darbe, 3D |
| Matched FFT | `func_plot_pipeline` | Menzil x hız, matched filter çıkışının FFT'si (clutter sıfır hızda yığılır) |
| MTI FFT | `func_plot_pipeline` | MTI sonrası menzil x hız |
| Pencerelenmiş FFT | `func_plot_pipeline` | Doppler öncesi pencereli MTI'nın FFT'si, CFAR girdisi |
| Karşılaştırma | `func_plot_pipeline` | 3 alt grafik: matched, MTI, MTI FFT |
| CFAR çıktısı | `func_plot_pipeline` | Menzil boyunca güç (mavi), OS-CFAR eşiği (kırmızı), marjinli eşik (sarı), CA-CFAR eşiği (mor), tespitler (yeşil kesikli) |
| 3D sahne | `func_plot_lla` | Uçak (yeşil üçgen), hedefler, beam'in yarım güç konisi |

**3D sahne (`func_plot_lla`):** NED eksenleri, uçak orijinde. Tespit edilen hedef **yeşil**,
diğerleri **kırmızı** (lejantla). Beam, yarım güç konturuyla (`hpbw_az` x `hpbw_el`)
**eliptik koni** olarak çizilir: boresight kesikli çizgi, elips halkası ve 8 kenar çizgisi.
Yeşil olma kuralı `func_score_detections`'tan gelir: sadece geçerli (hareketli ve beam içi)
ve tespit edilen hedefler yeşil olabilir. Bu yüzden T3 (durağan) beam içinde olsa da kırmızıdır.
Işın uzunluğu 100 km (`func_bodyangles2ned` içinde sabit), bu sadece çizim ölçeği.

**CFAR grafiğinde dikkat:** Güçlü bir hedefin iki yanında eşiğin yükseldiği "kulaklar"
görülür. Bu OS-CFAR'ın referans penceresine giren hedef enerjisinden kaynaklanan
maskeleme etkisidir (bkz. 12.4).

---

## 11. FPGA Arayüzü ve Tasarım İlkeleri

### 11.1 Blok arayüz sözleşmesi (donanım ekibi için)

Bu, "bu bloğa şu girer, şu çıkar" sözleşmesidir. Bloğun FPGA'de nasıl gerçekleneceği
donanım ekibine aittir. Boyutlar 3.2'deki parametrelerle belirlenir.

| Blok | Girdi (boyut, tip) | Çıktı (boyut, tip) |
|---|---|---|
| TX darbe üretimi | 1x20, karmaşık | 1x20, karmaşık (genlik her zaman 1) |
| TX pencereleme | 1x20, karmaşık | 1x20, karmaşık |
| RX (hedef + gürültü + clutter) | senaryo parametreleri | 1000x20, karmaşık |
| Eşleştirilmiş filtre | 1x20 ve 1000x20, karmaşık | 1000x20, karmaşık |
| MTI | 1000x20, karmaşık | 1000x18, karmaşık |
| Doppler pencereleme | 1000x18, karmaşık | 1000x18, karmaşık |
| FFT | 1000x18, karmaşık | 1000x256, karmaşık |
| CFAR (OS) | 1000x256, karmaşık (içeride güce çevrilir) | 1000x256 + 1000x256, gerçek |
| Son işleme | 1000x256 karmaşık ve 1000x256 gerçek | değişken uzunluk, 1..1000 arası gerçek tam sayı |

Donanımı ilgilendiren noktalar:

- **`N_Pulse_Sample` ve `N_Pulse` ayrı parametre** olarak tutulmalı (ikisi şu an 20 ama
  farklı şeyler).
- **`detected_idx` sabit boyutlu değil.** Donanımda sabit boyutlu buffer (örneğin 16 veya
  32 tespit) ve kaç tanesinin geçerli olduğunu söyleyen ayrı bir sayaç olarak tasarlanmalı.
  Tek taramada birden fazla hedef tespit edilebilir.
- **FFT boyutu:** Golden model 256 kullanıyor. Donanım daha küçük bir boyut (32 veya 64)
  seçerse karşılaştırma bunu hesaba katmalı.
- **`detected_idx` hız bilgisi taşımaz.** Menzil ve hızı birlikte raporlamak için son
  işleme genişletilmelidir.
- **Sayısal gösterim:** Planlanan format 16 bit sabit nokta. Alınan sinyalin genlik aralığı
  çok geniştir (yakın güçlü hedef ile uzak zayıf hedef arasında yüzlerce dB, grafiklerde
  yaklaşık -70 ile -250 dB), ölçekleme stratejisi ayrı bir tasarım konusudur. TX darbesi
  için dinamik aralık sorunu yoktur (I ve Q her zaman -1 ile 1 arasında).
- **Görselleştirme çıktıları:** `matched_fft_output`, `mti_fft_output`, `ca_threshold_map`
  tespit kararına girmez, donanımda üretilmek zorunda değildir.
- **`func_performance` donanımın parçası değil.** Sadece golden modelin kendini sınaması için.
- **Uyarı:** Donanım dokümanına göre pencerelenmiş TX darbesi hem eşleştirilmiş filtre
  katsayısı hem de gerçekte atılan darbedir. Kodda rx pencerelenmemiş darbeyle üretilip
  filtre pencerelenmişle uygulanıyor (bkz. 13).

### 11.2 Golden model neden böyle kuruluyor?

Golden model sadece "doğru cevabı veren" bir kod değil, FPGA gerçeklemesinin **neyi
hedeflediğini** yansıtan bir referanstır. Bu projede iş yükü (bir CPI'da yaklaşık 20 000
örnek: matched filter ~400 bin MAC, 1000 x 256 FFT, 256 000 hücrelik CFAR) modern bir CPU
için zor değildir. Yani FPGA'nın avantajı ham hız değil, aşağıdakilerdir. Golden model
bunları ölçülebilir kılacak şekilde kurgulanır.

| FPGA avantajı | Golden modelde ne demek |
|---|---|
| **Deterministik gecikme** (jitter yok) | Her bloğun gecikmesi örnek/darbe cinsinden bir alt sınır olarak hesaplanır ve dokümante edilir |
| **Akan işleme** (frame bitmeden hesap başlar) | Bloklar akışa uygun tanımlanır: hangi blok kaç örnek/darbe geriye bakıyor? |
| **Düşük güç ve boyut** | Gereksiz hesaplar (görselleştirme çıktıları) tespit zincirinden ayrı tutulur |
| **RF ön yüze doğrudan bağlanma** | Girişin genlik aralığı ve ölçekleme stratejisi baştan düşünülür |
| **Ölçeklenebilirlik** (`fs`, `B`, kanal sayısı) | Tüm boyutlar parametrik kalır |
| **Özel sayı formatı** (16 bit sabit nokta) | Golden model float, FPGA sabit nokta. Karşılaştırma hem blok çıktısı hem Pd/Pfa seviyesinde yapılır |

### 11.3 Gecikme (latency) alt sınırları

Bunlar **teorik alt sınırlardır**, FPGA gerçeklemesinde ölçülmüş değerler değildir.

| Blok | Neye bakıyor | Alt sınır (fs = 1 MHz, PRI = 1 ms) |
|---|---|---|
| Matched filter | 20 örnekli FIR (hızlı zaman) | ~10 örnek = 10 µs |
| MTI | 3 darbe (yavaş zaman) | 2 darbe = 2 ms |
| Doppler FFT | 18 darbenin tamamı | 20 darbe = **20 ms (CPI)** |
| OS-CFAR | Menzil ekseninde +-18 hücre (`guard/2 + ref/2`) | 18 örnek = 18 µs |
| Post-processing | Tüm 1000 menzil hücresi (satır max) | 1 frame |

Toplam gecikmeyi CPI (20 ms) belirler. CFAR ve matched filter'ın eklediği gecikme onun
yanında µs mertebesindedir. Bu yüzden:

- **Latency ölçümü tanımlı olmalı:** "son örnek PL'e girdi -> tespit çıktı" FPGA'nın gerçek
  performansını gösterir. "Host'tan gönder -> host'ta al" DMA/PS yolunu da içerir ve mevcut
  fazda determinizmi bozar.
- **Latency'yi asıl kısaltan şey CPI'dır:** daha az darbe veya kayan (örtüşmeli) CPI. Bu
  integrasyon kazancını ve dolayısıyla hassasiyeti düşürür. Latency ile hassasiyet birbirine
  karşı bir dengedir ve birlikte ölçülmelidir.

### 11.4 Hassasiyet ile ilgili bilinen sınırlar

- **Menzil çözünürlüğü:** Hücre 150 m, LFM çözünürlüğü 375 m. Dolph-Chebyshev penceresi ana
  lobu daha da genişletir (ölçülen etkin sınır ~1.2 km). Bundan yakın iki hedef matched
  filter çıkışında zaten tek tepedir, CFAR ile düzeltilemez. Gerçek çözünürlük için `B` ve
  `fs` artmalı.
- **CFAR maskeleme:** Güçlü hedefin yanındaki (referans penceresi içindeki) zayıf hedef, eşik
  yükseldiği için görülemez. `k` ne kadar büyükse o kadar az kirlenmiş hücre tolere edilir.
- **Kenar davranışı:** FPGA'de pencere doldurma davranışı (sıfırla doldurma, tekrar, atlama)
  ayrıca belirlenmeli, golden modelde şu an tanımsız.
- **Post-processing:** `max_gap` içindeki iki tespitin güç oranı çok farklıysa zayıf olan atılır,
  gerçek zayıf hedef de silinebilir (bkz. 12.3).
- **Doppler bilgisi:** Post-processing hızı kaybeder. Aynı menzilde farklı hızdaki hedefler
  birleşir. 2D CFAR çözümdür (gelecek çalışma).
- **OS-CFAR maliyeti:** Her hücre için 30 referansın sıralanması donanımda pahalıdır.
  Alternatifler (CA / GO / SO-CFAR, kayan pencerede sıralı yapı) golden modelde OS ile aynı
  senaryoda karşılaştırılmalı.

---

## 12. Deneyler ve Sonuçlar

Bu bölüm, kodda yapılan seçimlerin arkasındaki ölçümleri özetler. Yanlış çıkan tahminler de
kasıtlı olarak yazılmıştır.

### 12.1 Düzeltilen hatalar ve etkileri

| Hata | Dosya | Düzeltme | Etki |
|---|---|---|---|
| `sin` yerine `sinc`, sabit 0.443946 | `func_beam_pattern` | `sinc`, 0.442946 | Boresight'ta desen -inf iken 0 dB oldu, -3 dB noktası doğru yere geldi |
| Sağ referans penceresi tek hücre | `func_os_cfar` | `num_ref/2` hücre | Referans kümesi 16 -> 30 hücre. `k=15` medyan oldu, eski ayarlar frame başına ~25 yanlış alarm verdi, parametreler yeniden ayarlandı |
| "Büyüğü tut" yerine hep sonrakini yazma | `func_cfar_post_processing` | Sadece sonraki daha büyükse yaz | Güçlü hedef (T1) eşiğin 14 dB üstündeyken zayıf bir komşu adayla yer değiştirip kayboluyordu. OS-CFAR düzeltilmeden görünmüyordu |
| Pd tespitler üzerinden sayılıyordu | `func_performance` | Hedefler üzerinden, sadece geçerli hedefler | Pd > 1 çıkabilirdi, beam dışı hedefler Pd'yi yapay düşürüyordu |
| Menzil ekseni bir hücre kayık | `func_performance` | `target_idx + 1`, `range_km = (0:N-1)` | 150 m'lik sapma |
| Darbe her denemede yeniden pencereleniyor | `func_monte_carlo` | Döngü dışında bir kez | Pencere 50 kez üst üste uygulanıyordu |
| Monte Carlo'da clutter yok | `func_monte_carlo` | Clutter eklendi | Ana zincirle tutarlı |
| Elevation işareti çizimde ters | `func_plot_lla` | İşaret çevrildi | Beam merkezi T1'i 0.76° ıskalıyordu, şimdi 0.000° |
| `func_lla2ned_custom` her çağrıda matris basıyor | `func_lla2ned_custom` | Noktalı virgül | Konsol kirliliği |

### 12.2 CFAR parametre taraması (`experiments/exp_sweep_cfar_params.m`)

**Soru:** OS-CFAR düzeltildikten sonra `k` ve `threshold_factor` ne olmalı?

**Yöntem:** 'simple' senaryo (4 hareketli hedef hepsi tam kazanç, 1 durağan), 8 tohum, her
birinde clutter ve gürültü yeniden üretilip zincir çalıştırıldı. Her `(k, çarpan)` çifti için
frame başına yanlış alarm ölçüldü. Hızlı eşik hesabı `func_os_cfar` ile karşılaştırıldı (fark 0).

**Frame başına yanlış alarm (RCS = 10 m², Pd tüm ayarlarda 1.00):**

| k \ çarpan | 2 | 3 | 3.8 | 5 | 6.5 |
|---|---|---|---|---|---|
| 15 | 63.1 | 41.4 | 24.1 | 9.6 | 4.5 |
| 20 | 41.1 | 15.5 | 6.5 | 2.4 | 0.8 |
| 24 | 18.1 | 4.6 | 1.4 | 0.4 | 0.2 |
| 27 | 6.9 | 1.1 | 0.2 | 0.0 | 0.0 |

İlk seçim `(24, 6.5)`. **Kısıt:** 8 tohum küçük, yanlış alarm sayıları gürültülüydü (12.3'te
0.2 yerine 0.04 çıktı).

### 12.3 Doğrulama ve karar (`experiments/exp_validate_cfar_params.m`)

**Yöntem:** 100 tohum, 4 hareketli hedef (45, 55, 80, 141 km), iki RCS (10 m² nominal ve 3 m²
sınırda), üç aday çift. %95 Wilson güven aralığı.

| `k`, çarpan | Pd (10 m²) | Pd (3 m²) [%95 GA] | 141 km hedefi (3 m²) | Yanlış alarm / frame (10 m²) |
|---|---|---|---|---|
| 24, 6.5 | 1.000 | 0.84 [0.80, 0.87] | 0.49 | 0.04 |
| **20, 8** | 1.000 | **0.89 [0.85, 0.92]** | **0.62** | 0.12 |
| 15, 15 | 1.000 | 0.79 [0.75, 0.83] | 0.36 | 0.03 |

- Nominal hedeflerde üç çift de 1.000. (8 tohumdaki `(15, 15)` Pd = 0.97 düşüşü gürültüydü.)
- **Sınırdaki hedefte `(15, 15)` gerçek kayıp veriyor** (güven aralığı `(20, 8)` ile çakışmıyor).
- **`(20, 8)`** hem zayıf hedef Pd'sinde hem eşit güçte yakın hedef çözünürlüğünde (12.4) en iyisi.
- Bedeli yanlış alarm: 0.12 / frame (Pfa ~1.2e-4), diğerlerinin 3-4 katı (100 frame'de 12
  yanlış alarm, sayılar küçük). CPI = 20 ms ile 50 frame/s varsayımıyla ~6 yanlış alarm/s.
  Ham hâliyle pilota gösterilemez, ardışık frame veya tarama turlarında tutarlılık (M/N)
  kontrolü gerekir.

**Karar:** `k = 20`, `threshold_factor = 8` (`main_radar_sim.m`'de).

**Kısıtlar:** Kalibrasyon bu simülasyon modeline (Gauss clutter, `rand` kaynaklı gürültü) bağlı,
gerçek RF verisinde yeniden ayarlanmalı. Ara noktalar (`(20, 7)`, `(18, 9)`) denenmedi. FPGA
sıralama maliyeti ölçülmedi.

### 12.4 Menzil çözünürlüğü (`func_resolution_test`)

**Soru:** Dip dibe iki hedef hangi mesafeden itibaren ayrı tespit edilir ve hangi blok sınırlıyor?

**Yöntem:** 'simple' modda aynı hızda (15 m/s) iki hedef, ilki 80 km'de, ikincisi aralarındaki
mesafe değiştirilerek. Her mesafede 20 deneme, clutter ve gürültü yeniden üretilir. Üç aşama
ayrı ölçülür (yüzde, iki hedefi ayrı gören deneme oranı):

1. **Matched filter:** İki tepe var mı, aralarında en az 3 dB çukur var mı? (dalga formu sınırı)
2. **OS-CFAR:** İki hedef de eşiği geçiyor mu? (maskeleme sınırı, 3 hücreden yakında anlamsız)
3. **Post-processing:** İki ayrı tespit kalıyor mu? (`max_gap` ve `peak_ratio` sınırı)

```matlab
rng(1);
fs = 1e6; B = 400e3; tau = 20e-6; t_p = (0:fs*tau-1)/fs;
pulse = func_lfm_gen(B/tau, t_p);
noise_amp = func_calculate_noise('noisefloor',-111);
clutter_amp = 10*noise_amp;
seps = [150 300 450 750 1200 1800 2700 4500];
for pd = [0 10]
    func_resolution_test(seps,pd,20,pulse,80e3,1e3,10^(35/10),noise_amp,clutter_amp,30,6,24,6.5,0.5,15);
end
```

**Sonuç (eşit güç, `k = 24`, `threshold_factor = 6.5`, yani parametre seçiminden ÖNCE):**

| Mesafe | Hücre | Matched filter | OS-CFAR | Post-processing |
|---|---|---|---|---|
| 150 m | 1 | 0 | (anlamsız) | 0 |
| 300 m | 2 | 10 | (anlamsız) | 0 |
| 450 m | 3 | 15 | (anlamsız) | 80 |
| 750 m | 5 | 20 | 100 | 0 |
| 1200 m | 8 | 75 | 35 | 0 |
| 1800 m | 12 | 85 | 30 | 0 |
| 2700 m | 18 | 100 | 100 | 100 |
| 4500 m | 30 | 95 | 100 | 100 |

**İkinci hedef 10 dB zayıf:**

| Mesafe | Hücre | Matched filter | OS-CFAR | Post-processing |
|---|---|---|---|---|
| 750 m | 5 | 35 | 100 | 0 |
| 1200 m | 8 | 75 | 5 | 0 |
| 1800 m | 12 | 95 | 5 | 0 |
| 2700 m | 18 | 95 | 25 | 15 |
| 4500 m | 30 | 95 | 100 | 80 |

**`k` ve çarpan çiftlerinin çözünürlüğe etkisi:**

| `k`, çarpan | Eşit güç: post 1.2 / 1.8 / 2.7 km | 10 dB fark: CFAR 1.2 / 1.8 / 2.7 km | 10 dB fark: post 1.2 / 1.8 / 2.7 km |
|---|---|---|---|
| 24, 6.5 | 0 / 0 / 100 | 0 / 0 / 15 | 0 / 0 / 5 |
| 27, 5 | 0 / 0 / 0 | 0 / 0 / 0 | 0 / 0 / 0 |
| **20, 8** | **100 / 100 / 100** | 35 / 55 / 70 | 0 / 0 / 45 |
| 20, 10 | 100 / 85 / 100 | 20 / 5 / 60 | 0 / 0 / 25 |
| 15, 15 | **100 / 100 / 100** | **85 / 100 / 75** | 0 / 0 / 30 |

**Yorum:**

- **Dalga formu sınırı yaklaşık 1.2 km (8 hücre)**, teorik 375 m'nin ~3 katı (Chebyshev
  penceresi ana lobu genişletir).
- **Eski parametrelerle asıl darboğaz CFAR maskelemesiydi:** iki eşit hedefi ancak 2.7 km'den
  itibaren ayırıyordu. `k`'yı düşürünce (`(20, 8)`, `(15, 15)`) eşit hedefler 1.2 km'den itibaren
  ayrılıyor.
- **10 dB zayıf hedefte hâlâ sınırlı.** `(15, 15)` ile CFAR zayıf hedefi yüzde 75-100 görüyor ama
  post-processing 1.2-1.8 km'de sıfır veriyor: `max_gap = 15` hücre (2.25 km) içinde güç oranı
  `peak_ratio`'dan küçükse zayıf olan yan lob sayılıp atılıyor. 10 dB = oran 0.1, kural
  tasarlandığı gibi çalışıyor ama zayıf gerçek hedefi de siliyor. Yan lob ile gerçek zayıf hedefi
  ayırt etmenin başka bir yolu gerekir (örneğin yan lob seviyesini pencereden hesaplamak).

**Denenen ve işe yaramayan:** Post-processing'de aynı geçiş grubundaki yerel tepeleri (en az
3 dB çukurlu) ayrı aday almak. Her satırda tam olarak aynı sonucu verdi, çünkü CFAR hedefi zaten
kaçırıyordu (darboğaz oradaydı). Kodda bırakılmadı. İlk tahmin (post-processing gruplaması en
büyük kaybı yapıyor) ölçümle doğrulanmadı.

**Kısıtlar:** Tek senaryo, 20 deneme (yüzdeler ~+-15 puan oynar), +-1 hücre eşleştirme toleransı,
3 dB çukur ölçütü. 450 m'de post-processing'in yüzde 80 çıkması (matched filter yüzde 15
iken) açıklanamadı. İki hedefin fazı aynı olduğundan girişim yapısıyla ilgili olabilir,
doğrulanmadı. Hedeflerde menzile bağlı taşıyıcı fazı olmadığı için girişim gerçekçi olmayabilir.

### 12.5 Monte Carlo (LLA senaryosu)

`k = 20`, `threshold_factor = 8`, 1000 deneme, `rng(1)`:

| | Değer |
|---|---|
| Ortalama Pd | 1.00 |
| Ortalama Pfa | 1.66e-4 (yaklaşık 0.17 yanlış alarm / frame) |
| Süre | 105 s |

- LLA senaryosunda sadece T1 geçerli hedef, o yüzden Pd ayırt edici değil, asıl bilgi Pfa'da.
- Pfa, 'simple' senaryoda 100 tohumla ölçülen 0.12'ye yakın (0.17). Fark küçük.
- Pd'yi anlamlı ölçmek için zayıf hedefli veya birden fazla hedefi kapsayan bir LLA senaryosu
  gerekir.

---

## 13. Bilinen Sorunlar ve Sınırlar

**Model:**
- **Gürültü:** `rand` (düzgün genlik) kullanılıyor, Gauss olmalı. Gürültü gücü `noise_amp^2`
  yerine `noise_amp^2 / 3` (yani -111 dBm yerine yaklaşık -115.8 dBm).
- **TX darbesi:** Donanım dokümanına göre pencerelenmiş darbe atılıyor. Kodda rx
  pencerelenmemiş darbeyle üretiliyor, filtre pencerelenmişle uygulanıyor.
- **Taşıyıcı fazı:** Hedef sinyalinde menzile bağlı faz (`exp(-j*4*pi*R/lambda)`) yok, iki
  hedefin girişimi gerçekçi olmayabilir.
- **Clutter:** Basit bir model. Doppler'i sıfır merkezli, uçak hareketinden kaynaklanan
  kayma yok.
- **Radyal hız:** Geometriden hesaplanmıyor, elle veriliyor (`q.V_radial`).

**Kod:**
- `func_get_received_signal`: `c, fc, fs, PRF` sabit yazılmış.
- Hedef `max(idx) > N_PRI` ise sessizce atlanıyor.
- `func_param_barker_gen`: `case default` yazılmış (MATLAB'da `otherwise` olmalı), tanımsız
  bir uzunluk verilirse hata verir.
- `func_ca_cfar` başlığında "CENTER AVERAGE" yazıyor, "cell averaging" olmalı.
- `q.tgt_vel_ned` 3 satır ama 5 hedef var (kullanılmıyor).
- `func_antenna_loss` ve `func_plot_antenna_loss` eski modele ait, kullanılmıyor.

**Ölçüm:**
- SNR (`func_performance`) FFT çıkışındaki en büyük değerden hesaplanıyor (clutter ve işlem
  kazancı dahil), gerçek SNR değil.
- Post-processing eşiği: satırdaki en büyük eşik ile en büyük güç karşılaştırılıyor, tepenin
  olduğu Doppler hücresinin kendi eşiğiyle değil. Bilinçli olabilir, donanımda uygulanacaksa
  netleştirilmeli.
- Post-processing yan lob kuralı 10 dB zayıf ve 2.25 km içindeki gerçek hedefi siler.
- Kalibrasyon (CFAR parametreleri) bu simülasyona bağlı, gerçek RF verisinde yeniden ayarlanmalı.

**Donanım:**
- Kenar hücre davranışı (pencere doldurma) tanımsız.
- OS-CFAR sıralama maliyeti ölçülmedi.
- Sabit noktaya geçiş ve ölçekleme stratejisi henüz yok.

---

## 14. Yol Haritası: Akan Zamanda Canlı Tespit

**Hedef:** Tek frame yerine, sabit hızla düz uçan bir uçağa takılı radarın zamanla ardışık
CPI'lar göndermesi, yerdeki (koordinatları girilen) hedeflerin canlı tespiti.

**Alınan kararlar:**
- **Sabit hızlı düz hat** ile başlanacak, manevra (attitude değişimi) sonradan eklenecek.
- **Yılan (snake / raster) tarama:** F-16'daki mekanik radar gibi. Azimuth sektörün bir
  köşesine gelince elevation bir adım aşağı kayar, azimuth ters yöne süpürür, en alta gelince
  başa döner.
- **Mevcut tek-frame modeli bozulmayacak:** hareketli senaryo ayrı bir mod (case bloğu) olacak.
- **Doppler bu senaryoya göre güncellenecek.**

**Önerilen yapı (henüz kodlanmadı):**
- `func_kinematics`: uçak ve hedefleri zamanla ilerletir, her CPI için menzil, az/el ve
  radyal hızı geometriden hesaplar.
- `func_scan_pattern`: yılan taramada zamana göre `beam_az`, `beam_el` verir.
- `func_flight_sim`: frame (CPI) döngüsü (kinematik -> kazanç -> rx -> zincir -> tespit listesi).
- Sonra: canlı gösterim (menzil-azimuth ekranı), tutarlılık kontrolü (M/N).
- Her CPI'ın giriş (1000x20) ve çıkış (`detected_idx`) verisi dosyaya yazılabilmeli
  (FPGA testbench'i için).

**Doppler ile ilgili sınırlar:** Belirsizlik olmayan radyal hız +-25 m/s, kör hız 50 m/s ve
katları (bkz. 3.4). Uçak hareket ederken yer clutter'ı sıfır Doppler'de değil, `2 * v_ucak *
cos(aci) / lambda` frekansında görünür (200 m/s ve 53° için 2400 Hz, sarmalanınca 400 Hz) ve MTI
bunu silemez. İlk sürümde platform hareketinin ideal telafi edildiği varsayılacak, bu açıkça
dokümante edilecek. PRF'i yükseltmek menzil belirsizliğini kısaltır ve `N_PRI` = 1000 ile donanım
boyut sözleşmesini değiştirir, bu yüzden şimdilik değiştirilmedi.

Açık sorular (elevation beam genişliği, tarama hızı ve bar sayısı, senaryo hedefleri) ve ayrıntılar
`DEVLOG.md`'de.

---

## 15. Geliştirme Süreci

**Branch'ler:** `main` kararlı, tamamlanan işler `--no-ff` merge ile gelir. Aktif iş
`feature/flight-scenario` üzerinde. Ayrıntılı commit geçmişi ve durum `DEVLOG.md`'de.

**Çalışma şekli:**
- Küçük adım, her adımı çalıştırıp doğrula, sonra commit. Büyük işler ayrı branch'te.
- **Kod stili:** Basit ve anlaşılır, her modülün başında `Purpose / inputs / output`
  açıklaması, mevcut yazım tarzına uygun. Kod yorumları İngilizce.
- Her aşama dokümante edilir: teknik sonuçlar bu dosyada, karar ve süreç `DEVLOG.md`'de.
- Sonuçlar ölçülmeden iddia edilmez. Yanlış çıkan tahminler dokümanda düzeltilir.

**Yeniden üretilebilirlik:** Sonuçlar belirli tohumlarla ve tek makinede ölçüldü.
Küçük örneklemli deneylerde (20 deneme) yüzdeler yaklaşık +-15 puan oynayabilir.

---

## 16. Sözlük

| Terim | Anlamı |
|---|---|
| **CPI** | Coherent Processing Interval. Birlikte işlenen darbe grubu (burada 20 darbe = 20 ms) |
| **PRI / PRF** | Darbe tekrar aralığı (1 ms) / frekansı (1 kHz) |
| **Hızlı zaman / yavaş zaman** | Bir PRI içindeki örnek ekseni (menzil) / darbeler arası eksen (Doppler) |
| **Matched filter** | Alınan sinyalin gönderilen darbenin ters çevrilmiş eşleniğiyle konvolüsyonu, SNR'ı artırır |
| **MTI** | Moving Target Indicator. Durağan hedef ve clutter'ı bastıran darbeler arası filtre |
| **CFAR** | Constant False Alarm Rate. Eşiği yerel gürültüye göre adaptif ayarlayan tespit |
| **CA-CFAR / OS-CFAR** | Cell Averaging (ortalama) / Ordered Statistic (sıralı `k`. değer) CFAR |
| **CUT** | Cell Under Test, test edilen hücre |
| **Guard / referans hücresi** | CUT çevresinde hesaba katılmayan / eşiği tahmin etmek için kullanılan hücreler |
| **Maskeleme** | Referans penceresindeki güçlü bir hedefin eşiği yükseltip komşu zayıf hedefi gizlemesi |
| **Pd / Pfa** | Tespit olasılığı / yanlış alarm olasılığı (yanlış alarm sayısı / toplam menzil hücresi) |
| **RCS** | Radar Cross Section, hedefin radar kesit alanı (m²) |
| **HPBW** | Half Power Beam Width, yarım güç (-3 dB) hüzme genişliği |
| **LLA / ECEF / NED / BODY** | Enlem-boylam-irtifa / Dünya merkezli kartezyen / Kuzey-Doğu-Aşağı yerel çerçeve / uçak gövde çerçevesi |
| **Golden model** | FPGA gerçeklemesinin doğrulanacağı referans (floating point) yazılım modeli |
| **RoC** | Radar on Chip, projenin FPGA tarafı |
