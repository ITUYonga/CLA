# Geliştirme Günlüğü ve Devir Teslim Notları

Bu dosya, çalışmaya başka bir bilgisayardan (veya bir süre sonra) devam
edebilmek için yazıldı. Projenin ne olduğunu ve teknik sonuçları `README.md`
anlatıyor, bu dosya **nerede kaldığımızı, hangi kararları neden aldığımızı ve
sırada ne olduğunu** anlatıyor.

Son güncelleme: 2026-09-21.

## 1. Hızlı Başlangıç (yeni bilgisayar)

1. Repoyu al: `git clone https://github.com/canerturk-eng/aviation-rsp-matlab.git`
   (Ana branch: `main`. Aktif iş `feature/flight-scenario` branch'inde:
   `git checkout feature/flight-scenario`.)
2. MATLAB (R2025b ile denendi, R2024b de kurulu) ve toolbox'lar:
   Signal Processing (`chebwin`, `sinc`), Aerospace (`angle2dcm`),
   Mapping (`lla2ecef`).
3. `main_radar_sim.m` dosyasını çalıştır. Sabit tohumla (`rng(1)`) beklenen çıktı:

```
 1       84.7      0.0 dB      yes      45.26       yes
 ...
Pd = 1.00 (1 / 1 illuminated moving targets)
Pfa = 0.00e+00
True Targets (km) :  84.6
Detected targets (km) :   84.6
```

`main_radar_sim.m` bölüm 1'de `rng_seed = 1` var (varsayılan). `[]` yazılırsa sayılar
her seferinde biraz değişir, ama T1 her zaman tespit edilir.

`CANERTURK_SUNUM.pptx` (proje sunumu) repoda **değil**, git'e eklenmedi. Yeni
bilgisayara ayrıca kopyalanmalı (OneDrive vb.).

Yeni bir Claude oturumu açıyorsan hazır başlangıç promptu bölüm 10'da.

## 2. Çalışma Şekli (nasıl ilerliyoruz)

Bunlar açıkça istenen çalışma kuralları:

- **Kontrollü ilerle:** Küçük adım, her adımda çalıştır ve doğrula, sonra
  commit. Büyük işler ayrı branch'te, çalışınca `main`'e `--no-ff` merge.
- **Kod stili:** Öğrenci işi, anlaşılır, basit. Her modülün başında
  `Purpose / inputs / output` açıklaması. Mevcut dosyaların yazım tarzından
  uzaklaşma.
- **Her aşamayı dokümante et:** Yapılan iş `README.md`'de (teknik, sonuçlar),
  karar ve süreç bu dosyada.
- **Dil:** Konuşma ve dokümanlar Türkçe, kod yorumları İngilizce.
- **Ölçmeden iddia etme:** Yanlış çıkan tahminler dokümana da yazıldı
  (örn. post-processing tahmini, `(15, 15)` yorumu).

## 3. Repo ve Branch Durumu

| Branch | Durum |
|---|---|
| `main` | Tüm tamamlanan işler burada. GitHub'a push'landı |
| `fix/os-cfar` | `main`'e merge edildi |
| `fix/monte-carlo` | `main`'e merge edildi |
| `feature/flight-scenario` | **Aktif.** Akan zaman / uçuş senaryosu bunun üzerinde. GitHub'a push'landı |

Commit özeti (eskiden yeniye):

| Commit | İçerik |
|---|---|
| `62fff0e` | İlk commit (Can) |
| `d62f818` | `sin` -> `sinc` düzeltmesi, Gt az/el fonksiyonu tek yerde, README |
| `7b37261` | OS-CFAR pencere düzeltmesi, post-processing "büyüğü tut" düzeltmesi, `func_performance`, çözünürlük deneyi |
| `c3383b6` | `k = 20`, `threshold_factor = 8` (100 tohumluk doğrulama) |
| `2ad7734` | `fix/os-cfar` merge |
| `77c8eb4` | Monte Carlo LLA'da çalışır, `func_score_detections`, `func_os_cfar` vektörleştirme |
| `668dd0d` | LLA çizimi: elevation işareti, eliptik beam konisi, yeşil/kırmızı hedef |
| `74fed09` | `fix/monte-carlo` merge |

`fix/os-cfar` ve `fix/monte-carlo` branch'leri sadece yerelde (zaten `main`'e merge
edildikleri için geçmişleri `main`'de). Sunum dosyası (`CANERTURK_SUNUM.pptx`)
bilerek push'lanmadı.

## 4. Tamamlanan Aşamalar (özet)

Ayrıntılar ve sayılar `README.md`'de. Burada sadece ne olduğu ve nereye bakılacağı.

1. **Anten kazancı (Gt):** `func_beam_pattern` `sin` yerine `sinc` (ve sabit
   `0.442946`), `func_effective_gain` azimuth ve elevation'a bağlı tek fonksiyon,
   azimuth farkı sarılıyor. Eski polyfit modeli ve `_v2` kaldırıldı.
2. **OS-CFAR:** sağ referans penceresi tek hücreydi, `num_ref/2` hücre oldu.
   Vektörleştirildi (çıktı birebir aynı).
3. **Post-processing:** "büyüğü tut" hatası düzeltildi.
4. **Performans ölçümü:** `func_performance` hedef tablosu + beam içi ve hareketli
   hedefler üzerinden Pd. Sayım kuralı `func_score_detections`'ta (Monte Carlo ile ortak).
5. **CFAR parametreleri:** `k = 20`, `threshold_factor = 8`. Seçim sırası:
   yeni pencerede eski ayar yanlış alarm veriyordu -> tarama -> çözünürlük
   deneyi -> 100 tohumluk doğrulama. Deney scriptleri `experiments/` altında.
6. **Çözünürlük deneyi:** `func_resolution_test`. Dalga formu iki eşit hedefi
   ~1.2 km'den ayırıyor, `(20, 8)` ile sistem de aynı sınıra iniyor.
7. **Monte Carlo (LLA):** çalışıyor, 1000 denemede Pd = 1.00, Pfa = 1.66e-4.
8. **LLA çizimi:** elevation işareti düzeltildi (beam artık hedefi 0° hatayla
   gösteriyor), eliptik koni, tespit edilen hedef yeşil.
9. **`main_radar_sim.m` yeniden düzenlendi:** numaralı bölümler (kullanıcı seçimleri,
   radar / CFAR parametreleri, senaryolar, kurulum, alınan sinyal, zincir STEP 1-6,
   sonuçlar, Monte Carlo). Senaryo (`'simple'` / `'lla'`), tohum, grafikler ve Monte Carlo
   bölüm 1'den seçiliyor. Tek `Gt_dBi` değeri iki senaryoya da dağıtılıyor, pencerelenmiş
   darbe ayrı değişkende (`t_pulse_win`), eski anten modeli parametreleri kaldırıldı.
   `rng(1)` ile `detected_idx`, `rx`, eşik haritası ve FFT çıkışı eski main ile birebir
   aynı (`isequal`).
10. **Donanım reposuyla birleştirme:** Golden model `RoC-CFAR` reposuna `golden_model/`
    klasörü olarak, geçmişi koruyarak taşındı. Sunum dosyası geçmişten temizlendi.
    `NFFT = 128` (RTL `FFT_POINT`) ile 200 denemelik Monte Carlo: Pd = 1.00, Pfa = 1.55e-4
    (256'da 1.50e-4), fark gürültü düzeyinde. Donanım veri dokümanı `docs/` altında.

## 5. Aktif İş: Akan Zaman / Uçuş Senaryosu

Hedef: gerçekte havada giden bir uçağa takılı radar, yerdeki (koordinatları
girilen) hedefleri zamana yayılmış CPI'larla görsün ve canlı tespit etsin.

### 5.1 Alınan kararlar

- **Sabit hızlı düz hat** ile başla. Manevra (attitude değişimi) sonradan
  eklenecek bir özellik olarak.
- **Tarama: yılan (snake / raster) deseni**, F-16'daki mekanik radar gibi.
  Azimuth, sektörün bir köşesine (ekranın kenarına) gelince elevation bir
  adım (bar) aşağı kayar, azimuth ters yöne süpürür. Sonra en alta gelince başa
  döner. (GUI'si daha sonra çizilecek.)
- **Mevcut tek-frame modeli bozulmayacak.** Hareketli senaryo ayrı bir mod
  (case bloğu) olarak kurulacak.
- **Doppler bu senaryoya göre güncellenecek.**

### 5.2 Önerilen yapı (henüz kodlanmadı)

- Main'de senaryo modu seçimi (`single_frame` / `flight`). Mevcut akış
  `single_frame` altında aynen kalır.
- `flight` modunun mantığı ayrı fonksiyonlarda, main küçük kalır:
  - `func_kinematics`: uçak ve hedef konumlarını zamanla ilerletir, her CPI için
    menzil, az/el ve **radyal hızı geometriden** hesaplar.
  - `func_scan_pattern`: yılan taramada zamana göre `beam_az`, `beam_el` verir.
  - `func_flight_sim`: frame (CPI) döngüsü. Her CPI: kinematik -> `Gt_eff` ->
    rx -> mevcut zincir -> tespit listesi (zaman, menzil, beam yönü).
- Her CPI'ın giriş matrisi (1000x20) ve çıkışı (`detected_idx`) dosyaya
  yazılabilir olmalı (FPGA testbench'i için).
- Sonra: canlı gösterim (menzil-azimuth ekranı), tarama turlarında M/N
  tutarlılık kontrolü (yanlış alarm 0.17/frame'i bastırmak için).

### 5.3 Doppler ile ilgili bilinen sınırlar (`flight` modunda ele alınacak)

Mevcut parametreler (PRF = 1 kHz, lambda = 0.1 m) bir yer radarı için:

- **Belirsizlik olmayan radyal hız aralığı: +-25 m/s** (`+- lambda * PRF / 4`).
  Fizik gereği daha yüksek hızlar sarmalanır. (Sohbette bir ara bunu "+-50 m/s"
  demiştik, yanlıştı: 50 m/s aralığın toplam genişliği, yani kör hız.) Simülasyonda hedef fazı `exp(j*2*pi*fd*t)` olduğu için bu sarmalanma
  kendiliğinden oluyor, ek kod gerekmiyor.
- **Kör hızlar:** MTI sadece sıfır Doppler'i siliyor. Sarmalanma sonucu
  `n * 50 m/s` (n = 0, 1, 2, ...) hızındaki hedefler de silinir. Senaryodaki
  hedef hızları bunlardan uzak seçilmeli.
- **Clutter Doppler'i:** Uçak hareket ederken yer clutter'ı sıfırda değil,
  `2 * v_ucak * cos(aci) / lambda` frekansında görünür (200 m/s ve 53° için
  2400 Hz, sarmalanınca 400 Hz). MTI bunu silemez. Mevcut `func_clutter_gen`
  sıfır merkezli Doppler kullanıyor. İlk sürümde platform hareketi
  **ideal olarak telafi edilmiş** varsayılacak (clutter sıfırda kalır), bu varsayım
  açıkça dokümante edilecek. Gerçek clutter Doppler kaymasını modellemek ayrı,
  sonraki bir özellik.
- PRF'i yükseltmek menzil belirsizliğini kısaltır (`c / (2 * PRF)`) ve `N_PRI`
  = 1000 ile donanım dokümanındaki boyut sözleşmesini değiştirir. Bu yüzden
  PRF şimdilik değiştirilmedi.

### 5.4 Açık sorular / karar bekleyen

- **Elevation beam genişliği:** Şu an `hpbw_el = 20°` (yelpaze şekilli ışın). Yılan
  taramada elevation adımı yarım güç genişliğine göre seçilir. 20° ile 1-2 bar
  yeterli olur, tarama anlamsızlaşır. Kurşun kalem ışın (örneğin 6° x 6°) daha
  gerçekçi olur ama `Gt_eff` ve hangi hedeflerin beam içinde kaldığı değişir
  (örneğin T3 dışarı çıkar). Karar bekliyor.
- **Tarama hızı ve bar sayısı:** Sektör genişliği, azimuth hızı (deg/s),
  elevation adımı, bar sayısı. Mekanik anten sürekli döndüğü için beam CPI
  boyunca hareket eder (20 ms'de birkaç derece). Bir hedef beam geçişi başına
  birkaç ardışık CPI'da görülür (`hpbw / (hız * CPI)`), yani M/N sadece tarama
  turları arasında değil, bir geçişin içinde de yapılabilir.
- **Doppler sınırı yaklaşımı** (bölüm 5.3): İlk sürümde ideal telafi + kör
  hızlardan kaçınma önerildi. Onay bekliyor.
- **Senaryo:** hangi hedef konumları/hızları, uçak hızı ve yönü.

## 6. Bilinen Sorunlar / Yapılacaklar (uçuş işinden bağımsız)

- Gürültü: `rand` (düzgün) yerine Gauss kullanılmalı, gürültü gücü
  `noise_amp^2` olmalı (şu an `noise_amp^2 / 3`).
- TX darbesi: dokümana göre pencerelenmiş darbe atılıyor, kodda rx pencerelenmemiş
  darbeyle üretiliyor (Golden Model Girdi/Çıktı dokümanıyla çelişiyor).
- `func_get_received_signal`: `c, fc, fs, PRF` sabit yazılmış.
- Post-processing eşik karşılaştırması: satırdaki en büyük eşik ile en büyük güç.
- SNR hesabı (`func_performance`) clutter ve işlem kazancını içeriyor, gerçek SNR değil.
- Post-processing yan lob kuralı (10 dB zayıf ve 2.25 km içinde gerçek hedefi siler).
  Chebyshev pencere yan lob seviyesine bağlanabilir.
- Hedef sinyalinde menzile bağlı taşıyıcı fazı yok (`exp(-j*4*pi*R/lambda)`).
- FPGA sıralama maliyeti, kenar hücre davranışı (pencere doldurma) tanımsız.
- Kalibrasyon bu simülasyon modeline (Gauss clutter) bağlı, gerçek RF verisinde
  yeniden ayarlanacak.

## 7. Yeniden Üretilebilirlik

- `experiments/exp_sweep_cfar_params.m`: 8 tohumluk (k, çarpan) taraması.
- `experiments/exp_validate_cfar_params.m`: 100 tohumluk doğrulama, Wilson %95 GA.
- `func_resolution_test`: çağrı örneği `README.md`'de.
- `func_monte_carlo`: `main_radar_sim.m` bölüm 1'de `run_monte_carlo = true` ile çalışır
  (temiz `t_pulse` verilir, pencerelenmiş darbe `t_pulse_win` ayrı tutuluyor).
- Sonuçlar tek makinede ve belirli tohumlarla ölçüldü. Rakamlar 20 denemelik
  çözünürlük deneyinde yaklaşık ±15 puan oynayabilir.

## 8. Vektör Dışa Aktarma (`func_export_vectors`): Aşama Günlüğü

Branch: `feature/export-vectors`. Amaç: tek frame (hareketsiz, uçuş olmayan) senaryo için
FPGA test vektörlerini üretmek. Spesifikasyon `docs/FPGA_GOLDEN_MODEL_VERI_DOKUMANI.md`
(bölüm 3-6). Her aşama küçük tutulur, doğrulanır ve ayrı commit'lenir.

**Kararlar (aşama 0):**

- Kapsam: sadece tek frame. CPI dizisi uçuş senaryosu bitince eklenecek.
- `NFFT = 128` (RTL `FFT_POINT`) ile üretilir.
- Giriş `rx`, `2^31` ölçeğiyle 16 bit'e nicemlenir. **Beklenen çıktılar bu nicemlenmiş `rx`
  üzerinden** hesaplanır, böylece FPGA ile vektör arasındaki fark yalnızca aritmetikten gelir.
  Float girişteki tespit de manifest'e yazılır (fark çıkarsa görülsün).
- Beklenen değerler float zincirin çıktısının aynı ölçekle tamsayıya yuvarlanmış halidir.
  Bu **bit-doğru değildir** (Seviye A, bkz. veri dokümanı 6.2). Bit-doğru model (Seviye B)
  donanım kelime uzunlukları netleşince yazılacak.
- Dosya biçimi: karmaşık veri `_re.mem` / `_im.mem`, satır başına bir sayı, iki'nin tümleyeni
  hex (`matlab/genGold.m` alışkanlığı).
- Kelime uzunlukları (rx 16, matched 18, mti 20, mti_win 20, fft 24, güç 40) **varsayımdır**,
  RTL'de yalnızca ilk üçü tanımlı (`XLEN_IN`, `XLEN_CONV`, `XLEN_MTI`). Taşma sayısı
  manifest'e yazılır.

**Aşamalar:** (her aşama bitince aşağıya sonuçlarıyla eklenir)

**Aşama 1: giriş nicemleme ve yazma altyapısı (T0, T1).** `func_export_vectors.m` yazıldı:
`quant_int` (yuvarla + doyur), `write_mem` (W bit iki'nin tümleyeni hex, satır başına bir
sayı), `write_complex` (`_re.mem` / `_im.mem`). Doğrulama: dosyalar geri okunup ayrı bir
formülle (`round(rx*2^31)`, doyurma) karşılaştırıldı.
Sonuç: `rx` 20 000 satır, birebir eşit (`isequal`), negatif sayılar doğru (9906 / 9906),
taşma 0, en büyük gerçel bileşen 12 345 (16 bit sınırı 32 767). T0: 1.0 = 16384, Q2.14
yuvarlama hatası en fazla 0.64 LSB.

**Aşama 2: beklenen çıktılar (T2-T7).** Zincir nicemlenmiş `rx` üzerinde çalışıyor
(`run_chain`, main'in STEP 2-6'sıyla aynı), sonuçlar aynı ölçekle tamsayıya yuvarlanıp
yazılıyor. Güç yolu (eşik ve CFAR çıkışı) `2^62` ölçeğinde, 40 bit. Sıralama: T1-T4 darbe-major
(`x(:)`), T5-T6 menzil-major (`x.'(:)`). T7: `count`, `idx0(1..16)` (0 tabanlı, artan),
`overflow` (18 satır). Float girişteki tespit de hesaplanıyor.
Doğrulama: dosyalardan geri okunup golden fonksiyonlarla baştan hesaplandı (`NFFT = 128`),
T2, T3, T4, T5, T6a, T6b hepsi `isequal`. T7: `count = 1`, `idx0 = 564`, beklenenle aynı.
Nicemlenmiş ve float girişte tespit aynı (hücre 565). Taşma her noktada 0.
Ölçülen tepe bit sayıları (işaret dahil, `nominal`): rx 15, matched 17, mti 14, mti_win 14,
fft 17, eşik 30, CFAR çıkışı 32. Varsayılan genişlikler (18, 20, 20, 24, 40) bunları
karşılıyor. Bu tek senaryo, MTI'ın kazancı en kötü durumda 4 kat olabilir (+2 bit), RTL'deki
`XLEN_MTI = 20` bunu kapsıyor. Toplam dosya boyutu 5.5 MB.

**Aşama 3: `manifest.json`.** Senaryo adı, repo commit'i ve "commit'siz değişiklik var mı"
bayrağı (tarih yok), tohum, tüm parametreler, format (ölçekler, bit genişlikleri, sıralama,
T7 kelimeleri, indeks tabanı), taşma sayıları, beklenen tespit (nicemlenmiş ve float girişte,
0 tabanlı, metre cinsinden menzil) ve hedef tablosu (menzil, hız, RCS, hücre, desen, geçerli
mi, tespit edildi mi). Listeler tek elemanlı olsa da JSON dizisi olarak yazılıyor
(`as_list`, `jsonencode` tek elemanı sayıya çeviriyordu).
Bulunan hata: manifest yazan `fprintf` satırında kaçış yanlış yazılmıştı (satır sonu
karakteri gerçek satır sonu olmuştu), MATLAB "not terminated" verdi, düzeltildi.
Doğrulama: `nominal` için manifest `jsondecode` ile okundu, beklenen tespit 564 (84.6 km),
nicemlenmiş ve float giriş aynı, hedef tablosu 5 hedef.

**Aşama 4: main entegrasyonu ve `nominal` üretimi.** `main_radar_sim.m` bölüm 1'e
`export_vectors` (varsayılan `false`), `export_name`, `export_NFFT = 128` eklendi, bölüm 10
`func_export_vectors`'u çağırıyor. Çıktı `vectors/vec_<ad>_nfft<NFFT>/`, klasör
`.gitignore`'da (her üretim 5.3 MB, yeniden üretilebilir). Grafikler `NFFT` ile, vektörler
`export_NFFT` ile çalışıyor, birbirini etkilemiyor. `export_vectors = false` iken main
öncekiyle aynı (dışa aktarma bölümü en sonda).
Doğrulama (gerçek çıktı klasörü, sadece dosyalardan geri okunarak): T2-T6b `isequal`,
T7 `count = 1`, `idx0 = 564`, manifest `NFFT = 128`, taşma 0. Hedef tablosu: T1 hücre 564
(geçerli, tespit edildi), T2-T5 beam dışı ya da durağan (geçersiz).

**Aşama 5: dokümanlar.** Veri dokümanına `5.1 Nasıl üretilir` (ölçekler, T7 düzeni, doğrulama
sonuçları, ölçülen bit sayıları), `nominal` durumu ve manifest alan adları (`repo_commit`)
eklendi. `README.md` "Diğer çalıştırmalar" tablosuna ve dosya listesine eklendi.

**Kalanlar / sonraki adımlar:**

- Bölüm 8'deki diğer vektör setleri (`noise_only`, `mc_100`, `impulse`, `tone_slow`,
  `static_target`, `blind_speed`, `edge_cells`, `two_close`, `saturation`) için senaryo
  girişleri (özellikle doğrudan `rx` verilen sentetik testler) henüz yok.
- Bit genişlikleri (matched 18, mti 20, mti_win 20, fft 24, güç 40) varsayım, RTL'de yalnızca
  `XLEN_IN`, `XLEN_CONV`, `XLEN_MTI` tanımlı. Donanım tarafı netleştirince güncellenmeli.
- Seviye B (bit-doğru model) donanım kelime uzunlukları ve yuvarlama/doyma kararları gelince.
- Vektörler `vectors/` altında ve git'e girmiyor. İstenirse `nominal` seti repoya
  eklenebilir (5.3 MB).


## 9. Ethernet Bağlantısı (PC -> KV260 PS -> PL): Aşama Günlüğü

Branch: `feature/ethernet-link` (`feature/export-vectors` üzerine). Amaç: PC'de üretilen `rx`
ve TX darbesini Ethernet ile karta iletmek, sonucu geri almak. Kart tarafı (PS yazılımı)
repoda yok, o yüzden önce protokol ve PC tarafı yazılıp yerel ağda (loopback) deneniyor.
Paket biçimi: `docs/ETHERNET_PROTOKOLU.md`. Kod: `ethernet/`.

**Aşama 1: paket formatı.** `radar_link.py` (CONFIG, RX, RESULT paketleri, 16 bayt başlık,
little endian). Bir PRI 4 pakete bölünüyor (250 örnek), bir CPI 80 paket, paket 1016 bayt
(MTU'ya sığar). `test_radar_link.py` ağsız birim testi: boyutlar, gidiş-dönüş, 16 bit sınırları
(-32768, 32767), bayraklar (ilk/son paket), RESULT taşması (16'dan fazla tespit), bozuk paket
reddi. Hepsi geçti.

**Aşama 2: gönderici, sahte kart, loopback testi.** `vectors_io.py` (`.mem` ve manifest
okuma), `send_cpi.py` (CONFIG bir kez, sonra 20 ms ızgarasında CPI başına 80 paket, RESULT
alma), `mock_board.py` (KV260 PS tarafının yerine geçer: paketleri toplar, RESULT döner,
radar işlemi yapmaz, `nominal`'in beklenen tespitini döner), `test_loopback.py`.
Doğrulama (UDP, 127.0.0.1, `nominal` vektörü, 3 kez tekrarlandı, hepsi geçti):
1. 5/5 CPI doğru, örnekler değişmeden ulaştı (referansla birebir), RESULT `idx0 = [564]`,
   CONFIG doğru alındı.
2. Bir paket kaybı: o CPI `INCOMPLETE`, diğerleri etkilenmedi.
3. Paketler rastgele sırada: CPI yine tamamlandı.
Bulunan hata (tasarım): eksik CPI kuralı "`F_LAST` paketinden sonra 5 ms" idi. Sırasız gelen
`F_LAST` paketi başa düşünce süre ondan sayıldı ve geride kalan paketler yetişemeden CPI
yanlışlıkla eksik ilan edildi (test 3 düştü). Kural "son gelen paketten itibaren 5 ms"e
çevrildi, protokol dokümanına da yazıldı.
Sınır: Bu test aynı bilgisayarda, kayıpsız ve gecikmesiz ağda. Gerçek kablo, kart ve PS
yığını hiç denenmedi. "Send start error 0.00 ms" PC'nin 20 ms ızgarasını tutabildiğini
gösterir, kartın CPI'ları yetiştirip yetiştirmediği hakkında bir şey söylemez.

## 10. Yeni Claude Oturumu İçin Başlangıç Promptu

Yeni bir Claude Code oturumu bu konuşmayı hatırlamaz (hafıza dosyaları makineye
özeldir). Aşağıdaki metni oturumun ilk mesajı olarak yapıştır. Prompt güncel kalsın
diye kararlar değiştikçe bu bölüm de güncellenmeli.

````text
Bu repo (aviation-rsp-matlab), RoC (Radar on Chip) FPGA projesinin MATLAB golden modeli.
Uçak üzerindeki bir radarın sinyal işleme zincirini simüle ediyor. Önce DEVLOG.md'yi, sonra
README.md'yi baştan sona oku, kaldığımız yeri oradan anla. Aktif branch
feature/flight-scenario (git checkout feature/flight-scenario, sonra git pull).

ÇALIŞMA KURALLARI
- Kontrollü ilerle: küçük adım, her adımı çalıştırıp doğrula, sonra commit. Büyük işler ayrı
  branch'te, çalışınca main'e --no-ff merge.
- Commit ve push'u sadece ben isteyince yap. Commit mesajlarının sonuna Co-Authored-By
  satırını ekle.
- Kod stili: öğrenci işi gibi basit ve anlaşılır, mevcut dosyaların yazım tarzından uzaklaşma.
  Her modülün başında Purpose / inputs / output açıklaması olsun. Kod yorumları İngilizce,
  konuşma ve dokümanlar Türkçe.
- Her aşamayı README.md'ye (teknik) ve DEVLOG.md'ye (karar ve süreç) dokümante et.
- Ölçmeden iddia etme. Yanlış çıkan tahmini dokümanda düzelt, gizleme.
- Mevcut tek-frame senaryosunu (main_radar_sim.m, 'simple' ve 'lla' modları) bozma.
- Sunum dosyasını (CANERTURK_SUNUM.pptx) git'e ekleme.

ORTAM
- MATLAB'ı komut satırından çalıştırabiliyorsun: matlab -batch "..." (figürleri gizlemek için
  önce set(0,'DefaultFigureVisible','off')). Yolunu 'where matlab' ile bul.
- Doğrulama: main_radar_sim'i çalıştır (rng_seed = 1 varsayılan). Beklenen çıktı DEVLOG bölüm 1'de.
  Pd = 1.00, Pfa = 0, tek tespit 84.6 km.

ŞU ANKİ İŞ: akan zaman / uçuş senaryosu (DEVLOG bölüm 5)
Alınan kararlar: sabit hızlı düz hat ile başla (manevra sonra); tarama yılan (snake / raster)
deseni, F-16 mekanik radarı gibi (azimuth sektörün köşesine gelince elevation bir bar aşağı,
sonra ters yöne süpür); hareketli senaryo ayrı bir mod olsun ki mevcut akış bozulmasın;
Doppler bu senaryoya göre güncellensin. Önerilen yapı: func_kinematics, func_scan_pattern,
func_flight_sim (frame/CPI döngüsü), sonra canlı gösterim ve M/N tutarlılık.

DİKKAT (bunları unutma)
- Belirsizlik olmayan radyal hız +-25 m/s (lambda*PRF/4), kör hız 50 m/s ve katları. Senaryo
  hızlarını buna göre seç. PRF'i değiştirme (N_PRI = 1000 ve donanım boyut sözleşmesi bozulur).
- Elevation aşağı pozitif (body z aşağı). func_bodyangles2ned yukarı pozitif kabul eder.
- Clutter Doppler'i sıfır merkezli, ilk sürümde platform hareketinin ideal telafi edildiğini
  varsay ve bunu dokümante et.

KARAR BEKLEYEN (koda başlamadan bana sor)
1. hpbw_el şu an 20 derece (yelpaze ışın). Yılan taramanın anlamlı olması için kurşun kalem
   ışına (örneğin 6 x 6 derece) geçelim mi? Geçersek hangi hedeflerin beam içinde kaldığı değişir.
2. Doppler için "ideal telafi + kör hızlardan kaçınma" yaklaşımı onaylı mı?
3. Tarama parametreleri: sektör genişliği, azimuth hızı (deg/s), elevation adımı, bar sayısı.
4. Senaryo: uçak hızı ve yönü, hedef konumları ve hızları.

İlk adım olarak: DEVLOG ve README'yi oku, main_radar_sim'i (rng_seed = 1) çalıştırıp beklenen çıktıyı
doğrula, sonra yukarıdaki karar bekleyenleri bana sor. Cevaplarımdan önce kod yazma.
````
