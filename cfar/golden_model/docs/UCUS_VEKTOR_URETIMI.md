# Uçuş Senaryosu: FPGA Test Vektörü Üretme Rehberi

Bu doküman, uçuş (hareketli) senaryosunun MATLAB kodunu kullanarak FPGA için uzun, çok-CPI'lı
bir test vektörü seti üretmenin adımlarını anlatır. Golden model kodunun kendisi
`README.md` bölüm 14'te, vektör dosya formatı `FPGA_GOLDEN_MODEL_VERI_DOKUMANI.md` bölüm 5 ve
10'da, tek-frame vektörlerin genel kurgusu `vectors/FPGA_KURGU_VE_VERI_ICERIGI.md`'de anlatılıyor.
Bu rehber sadece "nasıl çalıştırılır" kısmına odaklanıyor.

## 1. Gereksinimler

- MATLAB (R2025b ile denendi), Signal Processing / Aerospace / Mapping toolbox'ları (README.md
  bölüm 1 ile aynı).
- Bu depo, `feature/flight-scenario` branch'i (uçuş senaryosu kodu `main`'de değil, bu branch'te).

## 2. Hangi dosya ne işe yarıyor

Hepsi `golden_model/flight/` klasöründe (uçuş kodu `golden_model/`'in ana `func_*.m`
dosyalarından bilerek ayrı bir alt klasörde tutuluyor, ama içeride `func_matched`,
`func_os_cfar` gibi ortak zincir fonksiyonlarını `golden_model/`'den çağırıyor —
`main_flight_sim.m` ve `main_export_flight_vectors.m`'in en başında bunun için bir `addpath`
satırı var, ayrıca eklemeye gerek yok).

| Dosya | Rol |
|---|---|
| `flight/func_kinematics.m` | Uçak/hedef geometrisi ve radyal hız, zamanın fonksiyonu olarak |
| `flight/func_scan_pattern.m` | Antenin baktığı yön (yılan/raster tarama), zamanın fonksiyonu olarak |
| `flight/func_flight_sim.m` | CPI döngüsü + sinyal zinciri, **görselleştirme/keşif** amaçlı (vektör yazmaz) |
| `flight/main_flight_sim.m` | `func_flight_sim`'i çağırıp özet ve grafik üreten kısa koşum (varsayılan 250 CPI, ~5 s) |
| `flight/func_export_flight_vectors.m` | Aynı CPI döngüsü, ama her CPI için `.mem` dosyası **yazan** hali |
| `flight/main_export_flight_vectors.m` | Uzun (varsayılan 40 s) koşumu çalıştırıp vektör setini diske yazan script |

**Vektör üretmek için çalıştırılacak dosya `flight/main_export_flight_vectors.m`'dir.**
`flight/main_flight_sim.m` sadece MATLAB içinde grafik/özet görmek içindir, dosya yazmaz.

## 3. Tek-frame vektörlerinden farkı

`func_export_vectors.m` (tek frame, `main_radar_sim.m` üzerinden) her nokta için (T0-T7) tam
vektör yazar, bu blok bazlı doğrulama içindir (bkz. `vec_nominal_nfft128/`). Uçuş senaryosunda
bunu her CPI için tekrarlamak (2000 CPI için ~10 GB) hem gereksiz hem pratik değil, çünkü bloklar
zaten `nominal` setiyle tek tek doğrulandı.

Bu yüzden `func_export_flight_vectors.m` **hafif bir format** kullanır:

- **T0** (matched filter katsayısı) sadece **bir kez**, setin en üstünde yazılır (uçuşta manevra
  yok, katsayı hiç değişmiyor).
- Her `cpi_XXXX/` klasöründe sadece **T1** (`rx`, gerçek FPGA girişi) ve **T7** (beklenen
  tespit) var. T2-T6 (matched/MTI/FFT/CFAR ara çıktıları) burada **yok**.
- Amaç blok doğrulaması değil, **uzun/ardışık akış testi** (Ethernet, zamanlama, çok sayıda
  CPI'da tutarlılık).

## 4. Çalıştırma

1. `feature/flight-scenario` branch'ine geç: `git checkout feature/flight-scenario` (gerekirse
   önce `git pull`).
2. MATLAB'da `golden_model/flight/main_export_flight_vectors.m` dosyasını aç.
3. Bölüm 1'deki ayarları gerekirse değiştir:
   - `duration_s`: toplam süre (saniye). Varsayılan 40. Bir CPI 20 ms olduğu için
     `n_cpi = duration_s / 0.02` otomatik hesaplanır (40 s -> 2000 CPI).
   - `rng_seed`: sabit tutulursa (`1`) her çalıştırmada **birebir aynı** vektörler üretilir
     (gürültü ve clutter dahil). `[]` yapılırsa her çalıştırmada farklı çıkar.
   - `export_name`: manifest'e yazılan isim ve klasör adının bir parçası.
4. Uçak/hedef/tarama parametrelerini (bölüm 2-3) değiştirmek istersen `flight/main_flight_sim.m` ile
   **aynı değerleri** kullanmaya dikkat et (karşılaştırılabilirlik için). `radar_cfg.NFFT` burada
   bilerek **128** (RTL `FFT_POINT` ile eşleşsin diye), `main_flight_sim.m`'in varsayılanı olan
   256 değil.
5. Çalıştır (Run). Çıktı konsola özet basar (kaç CPI'da geçerli hedef vardı, Pd, yanlış alarm
   sayısı, doygunluk).

**Süre ve boyut (40 s / 2000 CPI, referans ölçüm):** ~200 saniye (99 ms/CPI) üretim süresi,
~394 MB, 6003 dosya. Süre CPI sayısıyla orantılı büyür (`n_cpi` ikiye katlanırsa süre ve boyut
da ikiye katlanır).

## 5. Çıktı nerede, repoya girer mi

Çıktı `golden_model/vectors/vec_<export_name>_nfft<NFFT>/` klasörüne yazılır (örn.
`vec_flight_40s_nfft128/`). Bu klasör `golden_model/.gitignore`'daki `vectors/*` kuralına
girer, yani **git'e eklenmez** ve GitHub'a gitmez (birkaç yüz MB - GB boyutunda olduğu için
zaten pratik değil). Vektörleri kullanacak kişi bu script'i **kendisi çalıştırıp** üretir; aynı
`rng_seed` ile herkeste birebir aynı sonuç çıkar (`manifest.json` içindeki `repo_commit` alanı
hangi commit'ten üretildiğini kaydeder, farklı commit'lerden üretilen setler karıştırılmamalı).

## 6. Dosya formatını okumak için

- `.mem` dosyaları: satır başına bir sayı, iki'nin tümleyeni işaretli hex, `$readmemh` ile
  doğrudan okunur (`t1_rx_re.mem` / `_im.mem`: gerçek/sanal kısım ayrı, darbe-major sıra).
  Ölçek `FPGA_GOLDEN_MODEL_VERI_DOKUMANI.md` bölüm 5-6 ile aynı (`integer = round(value * 2^31)`,
  16 bit).
- `t7_detected.mem`: `count`, `idx[0..15]` (0 tabanlı, artan), `overflow` — 18 satır, format
  tek-frame vektörleriyle birebir aynı.
- Üst klasördeki `manifest.json`: senaryo, radar/CFAR/tarama parametreleri, format bilgisi ve
  **her CPI için** özet dizileri (`per_cpi.t`, `.beam_az`, `.beam_el`, `.detected_idx0`, ...) —
  hangi CPI'da hangi yöne bakıldığı ve hangi tespitin beklendiği buradan okunur.

## 7. Bilinen sınırlamalar (README.md bölüm 14 ile aynı)

- CPI içinde beam yönü sabit kabul edilir (gerçekte 20 ms'de birkaç derece hareket eder).
- Platform hareketinin clutter Doppler'ine etkisi yok sayılır (ideal telafi varsayımı).
- Manevra yok, uçak sabit hızla düz uçuyor.
- Uçak hızı (200 m/s) belirsizliksiz radyal hız sınırının (±25 m/s) üzerinde, sarmalanma olur;
  bu bilinen ve dokümante edilmiş bir sınırlama, düzeltilmedi.
