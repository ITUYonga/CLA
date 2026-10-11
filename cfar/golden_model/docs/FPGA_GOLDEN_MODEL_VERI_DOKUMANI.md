# Golden Model -> FPGA: Veri ve Arayüz Notları

Bu dokümanda, MATLAB golden modelinden FPGA'ye hangi verinin hangi biçimde sağlanacağını ve
golden modelde son dönemde nelerin değiştiğini anlatıyorum. Amaç, donanım tarafının MATLAB
kodunu baştan okumak zorunda kalmadan çalışmaya başlayabilmesidir.

Doküman bir **öneridir**. Tek frame senaryosu için dışa aktarma kodu yazıldı
(`func_export_vectors.m`, bölüm 5.1) ve `nominal` vektörü üretilip doğrulandı. Format ve
sayısal gösterim kararları donanım tarafının onayını bekliyor. Onay beklenen kararları bölüm 11'de
listeledim. Farklı bir tercih olursa golden modeli ona uyarlarım, bunun tersi çok daha maliyetli
olur.

Golden model artık donanım reposuyla aynı yerde (`golden_model/` klasörü). Vektörler, üretildikleri
golden model commit'ine bağlıdır ve golden model değiştiğinde yeniden üretilmelidir (bölüm 8).

**Donanım reposundaki mevcut durumla uyum (bu dokümanın ilk halinden sonra öğrenildi):**

- Mevcut `golden_model_doc/golden_model_io_arayuzu.md` **eskimiştir**: `k = 15`,
  `threshold_factor = 3.8` ve 16 hücrelik CFAR penceresi geçersizdir. Güncel değerler bu
  dokümandadır (bölüm 2).
- RTL şu an `FFT_POINT = 128` kullanıyor (`rtl/parameter.sv`). Golden modeldeki 256 ile
  farklıdır. Bu farkın sonuçları etkilemediği bölüm 11'de ölçüldü.
- Kart KV260'tır (Zynq UltraScale+, PS + PL). Test verisi host'tan PS belleğine, oradan AXI
  DMA ile PL'e gider (README). Bölüm 9 buna göre yazıldı.
- `matlab/genGold.m` zaten `.mem` üretiyor (`$readmemh`, satır başına bir sayı, iki'nin
  tümleyeni hex). Bölüm 5'teki dosya formatı bu alışkanlığa uyarlandı.

**İçindekiler**

1. Genel yaklaşım
2. Golden modelde değişenler
3. Zincir ve doğrulama noktaları
4. Blokların kesin kuralları
5. Dosya formatı
6. Sayısal gösterim
7. Kabul ölçütleri
8. Test vektörü seti ve sürümleme
9. PC ile FPGA'nin Ethernet ile bağlanması
10. Uçuş senaryosu (yaklaşan değişiklik)
11. Donanım tarafından beklenen kararlar
12. Sonraki işler

---

## 1. Genel yaklaşım

FPGA, golden modelin ürettiği hazır vektörlerle doğrulanır. MATLAB bir **girdi** ve her adım
için **beklenen çıktıyı** üretir. Girdi FPGA'ye verilir, ara çıktılar beklenenlerle
karşılaştırılır.

```
 MATLAB golden model                              FPGA (simülasyon / donanım)
 -------------------                              ---------------------------
 senaryo + rng tohumu
        |
        v
   rx (1000x20)  ----- stimulus dosyası ------->  giriş akışı
        |                                                |
   ara çıkışlar  ----- beklenen (expected) ----->  karşılaştırma  <----- FPGA ara çıkışları
   (matched, mti, fft, threshold, detected_idx)
```

Üç ilke:

1. **Girdi `rx`'tir**, yani ADC'den gelecek olan alınan sinyal. Hedef, clutter ve gürültü
   üretimi FPGA'nin parçası değildir, MATLAB'da kalır.
2. **Her blok ayrı doğrulanır.** Yalnızca uçtaki `detected_idx` yanlışsa hatanın hangi blokta
   olduğu anlaşılamaz. Bu nedenle her blok çıkışını ayrıca sağlıyorum.
3. **Golden model floating point, FPGA sabit noktadır.** İkisi birebir aynı sonucu vermez.
   Bunun için ara bir bit-doğru referans öneriyorum (bölüm 6.2).

---

## 2. Golden modelde değişenler

Aşağıdaki tablo, donanım reposundaki eski girdi/çıktı dokümanına
(`golden_model_doc/golden_model_io_arayuzu.md`) göre farkları özetler. Bu doküman eskiyi
geçersiz kılar. Orada `k = 15` ve `threshold_factor = 3.8` yazıyordu.

| # | Değişiklik | FPGA'ye etkisi |
|---|---|---|
| 1 | **OS-CFAR referans penceresi düzeltildi.** Sağ pencere tek hücreydi (toplam 16 referans), şimdi **30** (15 sol + 15 sağ, her yanda 3 koruma hücresi). | Pencere derinliği ve sıralama yapısının boyutu değişti. Eski CFAR gerçeklemesi geçersizdir. |
| 2 | **`k = 20`, `threshold_factor = 8`.** 100 tohumlu doğrulamayla seçildi. Eski ayar yeni pencerede frame başına ~25 yanlış alarm veriyordu. | `k` ve `threshold_factor` ayarlanabilir parametre olmalıdır, sabit yazılmamalıdır. |
| 3 | **Post-processing "büyüğü tut" düzeltmesi.** Eski kod her zaman sonrakini yazıyordu ve güçlü hedef kayboluyordu. Şimdi yalnızca sonraki **daha büyükse** yazılır. | Bölüm 4.4'teki kurala göre gerçeklenmelidir. |
| 4 | **Anten deseni `sinc` ile düzeltildi.** | Algoritma aynı kaldı, ancak `lla` senaryosunda `rx` genlikleri değişti. Eski vektörler geçersizdir. |
| 5 | **Başarım ölçümü hedef bazlı yapıldı.** Hedef, hareketli **ve** beam içindeyse (desen >= -3 dB) "geçerli" sayılır. Tespit, hedef hücresinin **±5 hücresi** içindeyse isabettir. | Sistem seviyesi kabul ölçütü budur (bölüm 7). |
| 6 | **Menzil ekseni kayması düzeltildi.** `d` örnek gecikmeli hedef, matched filter çıkışında **d+1. hücrede** (1 tabanlı) tepe verir. | İndeks konvansiyonu bölüm 4.4'te sabittir. |
| 7 | **Uçuş senaryosu** planlandı (henüz kodlanmadı). | Ardışık CPI'lar gelecektir, bölüm 10. |

**Henüz düzeltilmemiş konular (vektörleri değiştirecek):**

- **TX darbesi çelişkisi.** Eski dokümana göre pencerelenmiş darbe hem atılan darbe hem filtre
  katsayısıdır. Kodda ise `rx` pencerelenmemiş LFM ile üretiliyor, matched filter pencerelenmiş
  darbeyle uygulanıyor. Filtre katsayı ROM'unun **pencerelenmiş** darbe olmasını öneriyorum.
  Çelişki çözüldüğünde `rx` vektörleri değişecektir.
- **Gürültü modeli.** Şu an gürültü genliği düzgün dağılımlıdır (`rand`) ve gücü
  `noise_amp^2/3`'tür. Gauss dağılıma ve doğru güce geçilecektir. Bu da `rx` vektörlerini
  değiştirecektir.
- **CFAR kenar davranışı**, golden modelde bilinçli bir tasarım değil, yalnızca koddaki
  mevcut davranıştır (bölüm 4.2). Donanım farklı bir davranış istiyorsa birlikte karar
  verilmelidir.

Bu değişiklikler nedeniyle vektörleri **sürümlüyorum**. Sürüm karışırsa hatanın FPGA'de mi
yoksa eski vektörde mi olduğunu ayırt etmek zorlaşır.

---

## 3. Zincir ve doğrulama noktaları

Parametreler: `N_PRI = 1000`, `N_Pulse = 20`, `NFFT = 256`. (RTL `FFT_POINT = 128` kullandığı
için donanım karşılaştırması `NFFT = 128` ile üretilen vektörlerle yapılmalıdır. Tabloda
`256` yazan sütun sayıları bu durumda `128` olur. Bkz. bölüm 11, karar 3.)

| Nokta | İsim | Boyut (MATLAB) | Tip | Açıklama |
|---|---|---|---|---|
| T0 | `tx_pulse_win` | 1x20 | karmaşık | Matched filter katsayısı (pencerelenmiş darbe) |
| T1 | `rx` | 1000x20 | karmaşık | **Giriş** |
| T2 | `matched` | 1000x20 | karmaşık | Matched filter çıkışı |
| T3 | `mti` | 1000x18 | karmaşık | MTI çıkışı |
| T4 | `mti_win` | 1000x18 | karmaşık | Chebyshev pencere çıkışı |
| T5 | `fft` | 1000x256 | karmaşık | Doppler FFT çıkışı (`fftshift`li) |
| T6a | `os_threshold` | 1000x256 | gerçek | OS-CFAR eşik haritası |
| T6b | `os_cfar_out` | 1000x256 | gerçek | Eşiği geçen hücrede güç, geçmeyende 0 (**bayrak değildir**) |
| T7 | `detected_idx` | 1xN (N değişken) | tam sayı | **Son çıktı** |

Grafik amaçlı hesaplanan `matched_fft_output`, `mti_fft_output` ve `ca_threshold_map` tespit
kararına girmez. Bunları sağlamayacağım ve donanımda üretilmeleri gerekmez.

---

## 4. Blokların kesin kuralları

### 4.1 Matched filter, MTI, pencere, FFT

- **Matched filter (T2):** Katsayı `conj(fliplr(h))`, `h` = T0. Her darbe sütunu ayrı
  işlenir, `conv(..., 'same')`. `'same'` nedeniyle çıkış girişle aynı uzunluktadır ve tepe
  **d+1. hücrede** oluşur. Bu bir hücrelik kayma hesaba katılmazsa tüm menzil ekseni kayar.
- **MTI (T3):** `y[p] = x[p] - 2 x[p+1] + x[p+2]`, yavaş zaman ekseninde. 20 darbe 18'e
  iner. Sıfır Doppler'i (durağan hedef ve clutter) siler.
- **Pencere (T4):** `chebwin(18, 80)`, yavaş zaman ekseninde çarpım. Katsayılar sabittir
  (ROM).
- **FFT (T5):** 18 örnek sıfırla doldurulup 256 noktalı FFT uygulanır, ardından `fftshift`.
  Doppler bin 1 = -PRF/2, bin `NFFT/2 + 1` = 0 Hz (256'da bin 129, 128'de bin 65).
  **Dikkat:** FPGA FFT'sinin doğal çıkışı kaydırılmamıştır. Mevcut SDF/DIF FFT çıkışı ayrıca
  **bit-reversed** sıradadır (`genGold.m`'deki `bitrev` seçeneği). Karşılaştırmadan önce
  ikisi de aynı sıraya getirilmelidir.

### 4.2 OS-CFAR (T6)

`power = |x|^2`. Her menzil hücresi `j` ve her Doppler sütunu için:

1. Referans hücreleri: sol `j-3-15 ... j-3-1`, sağ `j+3+1 ... j+3+15`. Ortadaki 3+3 koruma
   hücresi ve test hücresi dahil değildir.
2. Referans güçleri sıralanır ve **`k`. en küçük** değer alınır.
3. `eşik = sorted(k) * threshold_factor`.
4. `power(j) > eşik` ise çıkış = `power(j)`, değilse 0.

**Kenar davranışı (koddaki mevcut hali):** Pencere kenarda taştığında taşan hücreler
**atılır**, referans sayısı azalır ve `k = min(k, kalan)` olur (kenarda eşik yükselir). Hiç
referans kalmazsa hücre atlanır (eşik 0, çıkış 0). Sıfırla doldurma **yapılmaz**.

**Sıralama maliyeti:** Her hücre için 30 değerin sıralanması donanımda pahalıdır. Kayan
pencerede sıralı yapı gibi yöntemler kullanılabilir, algoritma serbesttir, ancak **sonuç aynı**
olmalıdır (k. en küçük değer bir tanımdır). CA, GO, SO gibi başka CFAR türleri farklı sonuç
verir ve bu vektörlerle doğrulanamaz.

### 4.3 Gecikme alt sınırları

Bunlar teorik alt sınırlardır, ölçülmüş değerler değildir.

| Blok | Neye bakıyor | Alt sınır |
|---|---|---|
| Matched filter | 20 örnekli FIR | ~10 µs |
| MTI | 3 darbe | 2 ms |
| Doppler FFT | 18 darbenin tamamı | **20 ms (CPI)** |
| OS-CFAR | Menzilde ±18 hücre | 18 µs |
| Post-processing | 1000 hücrenin tamamı | 1 frame |

Toplam gecikmeyi CPI (20 ms) belirler, diğer bloklar µs mertebesinde kalır.

### 4.4 Son işleme ve `detected_idx` (T7)

1. Her menzil hücresi için 256 Doppler'in **en büyük gücü** (`input_max`) ve **en büyük
   eşiği** (`threshold_max`) alınır. Eşik, aynı Doppler sütununun değil, satırdaki en büyük
   eşiktir. Bunun bilinçli bir tercih olup olmadığı belirsizdir, ancak golden model bu şekilde
   çalıştığı için aynen uygulanmalıdır.
2. `input_max > threshold_max` olan ardışık hücreler gruplanır, her grubun en yüksek noktası
   aday olur.
3. Komşu iki aday için: aralarındaki mesafe `max_gap = 15` hücreden küçükse ve güç oranı
   `peak_ratio = 0.5`'ten küçük ya da 2'den büyükse **büyük olan** tutulur (sonraki daha
   büyükse öncekinin yerine yazılır). Aksi halde ikisi ayrı hedeftir.

**Çıktı formatı (öneri):**

| Alan | Açıklama |
|---|---|
| `count` | Geçerli tespit sayısı, 0..`MAXDET` |
| `idx[0..MAXDET-1]` | **0 tabanlı** menzil hücresi, **artan** sırada. Geçersiz girişler 0 |
| `overflow` | `count` > `MAXDET` ise 1 |

- İndeksi **0 tabanlı** yazıyorum: `idx0 = idx_matlab - 1`, menzil = `idx0 * 150 m`. Bu,
  MATLAB'daki `(hücre-1) * c/(2 fs)` formülüyle tutarlıdır ve taban karışıklığını önler.
- `MAXDET` için 16 öneriyorum. Golden model frame başına ortalama ~0.17 yanlış alarm
  verdiği için 16 yeterlidir.

---

## 5. Dosya formatı

Her test vektörü bir klasördür:

```
vec_<isim>_<sürüm>/
  manifest.json          senaryo, parametreler, ölçek, golden commit, beklenen sonuç
  t0_tx_pulse_win_re.mem / _im.mem
  t1_rx_re.mem / _im.mem
  t2_matched_re.mem / _im.mem
  t3_mti_re.mem / _im.mem
  t4_mti_win_re.mem / _im.mem
  t5_fft_re.mem / _im.mem
  t6a_os_threshold.mem
  t6b_os_cfar_out.mem
  t7_detected.mem        18 satır: count, idx[0..15] (0 tabanlı, artan, kalanı 0), overflow
```

T0 (filtre katsayısı) Q2.14 yazılır (1.0 = 16384, 16 bit). Diğer noktalar `2^31` ölçeğiyle
tamsayıya yuvarlanır, güç değerleri (T6a, T6b) `2^62` ölçeğiyle. Her noktanın bit genişliği
`manifest.json > format > bit_width` içindedir.

### 5.1 Nasıl üretilir

`main_radar_sim.m` bölüm 1'de `export_vectors = true` yapılır (varsayılan `false`), sonra
çalıştırılır. Çıktı `golden_model/vectors/vec_<ad>_nfft<NFFT>/` klasörüne yazılır. Bu klasör
`.gitignore`'dadır (her set ~5.3 MB ve yeniden üretilebilir). Vektörler `export_NFFT`
(varsayılan 128, RTL `FFT_POINT`) ile üretilir, grafikler main'in `NFFT`'ini kullanır.

Beklenen çıktılar, **nicemlenmiş** `rx` üzerinden hesaplanır (FPGA'nin gerçekte gördüğü
giriş). Yani FPGA ile vektör arasındaki fark yalnızca blok aritmetiğinden gelir. Değerler
float sonucun tamsayıya yuvarlanmış halidir, **bit-doğru değildir** (bölüm 6.2, Seviye A).
`manifest.json` float girişteki tespiti de içerir (`nominal` için ikisi aynı, hücre 564).

Geçerlilik: `nominal` için T2, T3, T4, T5, T6a, T6b ve T7 dosyalardan geri okunup golden
fonksiyonlarla baştan hesaplanarak karşılaştırıldı, hepsi birebir eşit. Ölçülen tepe bit
sayıları (işaret dahil): rx 15, matched 17, mti 14, mti_win 14, fft 17, eşik 30, CFAR çıkışı
32. Hiçbir noktada taşma yok.
- **Karmaşık veri:** Gerçek ve sanal kısım **ayrı dosyalarda** (`*_re.mem`, `*_im.mem`), satır
  başına bir örnek, iki'nin tümleyeni işaretli hex. Bu, `matlab/genGold.m`'deki mevcut
  alışkanlıkla aynıdır ve `$readmemh` ile doğrudan okunur. Kelime uzunluğu her nokta için
  `manifest.json`'da yazılır (bölüm 6).
- **Gerçek veri (T6a, T6b):** Tek dosya, satır başına bir örnek, aynı biçim.

**Dosya sırası (yanlış olursa karşılaştırma tutmaz):**

| Nokta | Sıra | MATLAB karşılığı |
|---|---|---|
| T0 | örnek 0..19 | `x(:)` |
| T1 (rx) | **darbe-major:** darbe 1'in 1000 örneği, sonra darbe 2, ... (PRI PRI akış) | `rx(:)` |
| T2, T3, T4 | T1 ile aynı | `x(:)` |
| T5, T6a, T6b | **menzil-major:** hücre 0'ın 256 Doppler bini, sonra hücre 1, ... | `x.'` sonra `(:)` |

T5 ve sonrasını menzil-major seçtim, çünkü Doppler FFT'si tüm darbeler geldikten sonra menzil
hücresi bazında yapılır (corner turn sonrası). Donanım farklı bir sırada üretiyorsa çeviri
karşılaştırıcıda yapılmalı, dosya sırası sabit kalmalıdır.

---

## 6. Sayısal gösterim

### 6.1 Ölçülen genlikler

Ölçüm koşulu: `rng(1)`, `lla` senaryosu, tek frame, commit `ff96fba`. Değerler, gerçel ve
sanal bileşenin büyüğüdür (`max(|Re|,|Im|)`). Tek tohum ve tek senaryodur, dolayısıyla
**kesin sınır değil, yön gösterici** değerlerdir.

| Nokta | max | rms (`|x|`) |
|---|---|---|
| T1 `rx` | 7.14e-6 | 6.3e-7 |
| T2 `matched` | 2.38e-5 | 2.4e-6 |
| T3 `mti` | 2.54e-6 | 3.4e-7 |
| T4 `mti_win` | 2.28e-6 | 1.9e-7 |
| T5 `fft` | 1.62e-5 | 8.0e-7 |
| `noise_amp` | 8.9e-8 | |

Çıkarımlar:

- **`rx`, gürültüden çok clutter tarafından domine ediliyor.** Clutter rms'i ~6.3e-7, gürültü
  genliği ~8.9e-8'dir (7 kat düşük). En zayıf hedef (`simple` senaryo T5, 141 km) ~3.6e-8
  genliktedir: gürültü tabanının altında, clutter'ın 17 kat altında. Bu hedefi görünür kılan
  Doppler entegrasyonu ve MTI'dır, ham genlikte görünmez.
- **Girişte sabit ölçek yeterli görünüyor.** Tam ölçek `2^-16 = 1.53e-5` seçilirse (ölçek
  `2^31`, yani bir kaydırma): `rx` max ≈ 15 300 sayım (%47 doluluk, ~6.7 dB boşluk),
  `noise_amp` ≈ 191 sayım, en zayıf hedef ≈ 77 sayım. Yani 1 sayımın altına düşen bir bileşen
  yoktur.
- **Aşamalarda genlik büyüyor.** Bu ölçekle `matched` max ≈ 51 200 (16 bit'i **aşar**, ~1.5
  bit büyüme), `fft` max ≈ 34 700 (sınırda). Ara kayıtların 16 bit'ten geniş olması ya da ara
  kaydırma uygulanması gerekir.
- **CFAR güç yolu geniştir.** `|x|^2` en fazla 2.7e-10, sıfırdan büyük en küçüğü 9.6e-20'dir
  (yaklaşık **100 dB** aralık). `2^31` ölçeğinde güç ölçeği `2^62` olur, en büyük ≈ 1.2e9
  (~2^30), en küçük ≈ 0.44. Bu yol **~32 bit** gerektirir (ya da logaritmik/kırpılmış bir
  gösterim).

### 6.2 İki seviyeli referans

- **Seviye A (mevcut):** Floating point golden model. Algoritma referansıdır.
- **Seviye B (yapılacak):** MATLAB'da donanımın kelime uzunluklarıyla **bit-doğru** model
  (yuvarlama, doyma ve kaydırmalar dahil). FPGA, B ile **birebir** eşleşmelidir. B ile A
  arasındaki fark (SQNR, Pd/Pfa) bir kez ölçülüp dokümante edilir.

**RTL'deki mevcut kelime uzunlukları** (`rtl/parameter.sv`): giriş `XLEN_IN = 16`, matched filter
çıkışı `XLEN_CONV = 18`, MTI çıkışı `XLEN_MTI = 20` (18 + 2 bit büyüme), sonuç `RESULT = 32`.
Bunlar yukarıdaki ölçümlerle uyumludur: matched filter çıkışı 16 bit'i aşar, ~1.5-2 bit büyüme
öngörülür.

Seviye B için donanım tarafından şunlar gerekir: her aşamanın giriş/çıkış kelime uzunluğu,
akümülatör genişliği, yuvarlama türü (kırpma / en yakına yuvarlama), doyma politikası, pencere
ve FFT katsayı hassasiyeti. Bunlar gelmeden Seviye B yazılamaz.

---

## 7. Kabul ölçütleri

| Karşılaştırma | Ölçüt |
|---|---|
| FPGA vs Seviye B | **Bit-doğru** eşitlik, T2..T7 |
| Seviye B vs A | Ara noktalarda SQNR, tespit seviyesinde Pd/Pfa farkı |
| Sistem | Geçerli (hareketli ve beam içi) hedefin **±5 hücresi** içinde tespit varsa isabet. Hiçbir geçerli hedefe ±5 hücreden yakın olmayan tespit yanlış alarmdır |

Referans başarım (float, `lla`, 1000 deneme): **Pd = 1.00, Pfa = 1.66e-4**. FPGA'nin bu
değerlerin altına düşmemesi beklenir.

---

## 8. Test vektörü seti ve sürümleme

| İsim | Amaç |
|---|---|
| `nominal` | **Üretildi ve doğrulandı.** `lla` senaryosu, `rng(1)`, `NFFT = 128`. Beklenen: tek tespit, hücre **564** (0 tabanlı; MATLAB'da 565, 84.6 km) |
| `noise_only` | Hedefsiz, gürültü + clutter. Yanlış alarm sayımı |
| `mc_100` | 100 farklı tohum. Pd/Pfa istatistiği |
| `impulse` | `rx`'te tek örnek. Matched filter ve gecikme (d+1) kontrolü |
| `tone_slow` | Sabit Doppler'li sinüs. FFT ve pencere kontrolü |
| `static_target` | Hızı sıfır hedef. MTI silmeli, tespit olmamalı |
| `blind_speed` | 50 m/s'lik hedef. MTI silmeli (kör hız) |
| `edge_cells` | Hedef hücresi ~1-20 ve ~980-1000. CFAR kenar davranışı |
| `two_close` | `max_gap` içinde iki hedef, güç oranı > 2 ve < 2. Post-processing |
| `saturation` | Girişi tam ölçeğe yaklaştıran güçlü hedef. Taşma/doyma |

**Sürümleme:** `manifest.json` içinde `repo_commit` (ve o commit'ten sonra kod değişti mi:
`repo_has_uncommitted_changes`), `rng_seed`, `scale_shift`, tüm parametreler (`fs, fc, PRI, tau, B, N_PRI, N_Pulse, NFFT, num_ref, num_guard, k,
threshold_factor, peak_ratio, max_gap`) ve **beklenen sonuç** (`detected_idx`, hedef tablosu)
bulunur. Gürültü modeli gibi bir değişiklikte yeni sürüm üretilir, eski sürümle
karıştırılmaz.

---

## 9. PC ile FPGA'nin Ethernet ile bağlanması

Hedef, PC'de çalışan simülasyon verisini Ethernet kablosuyla FPGA'ye iletmek ve çıktıyı PC
ekranında göstermektir.

### 9.1 Kısıt: MATLAB gerçek zamanlı üretim yapamıyor

Bir CPI için `rx` üretimi ve işleme zinciri ~69 ms, clutter üretimi ~43 ms sürüyor, toplam
**~110 ms** (tek bilgisayarda ölçtüm). CPI 20 ms olduğundan MATLAB gerçek zamanın **5-6 kat
gerisindedir**. Bu nedenle "MATLAB canlı üretsin, FPGA canlı işlesin" kurgusu mümkün değildir.

### 9.2 Kurgu: önceden üret, gerçek hızda ilet (replay)

```
 PC                                                       FPGA kartı
 ----------------------------------                       ------------------------
 MATLAB: senaryo -> CPI dizisi (rx)   (çevrimdışı)
        |  dosya
        v
 Streamer (CPI'ları 20 ms aralıkla)  --- UDP, 1 GbE --->  Ethernet -> CPI tamponu (çift)
                                                                 |
                                                                 v
                                                          işlem zinciri (T1 -> T7)
                                                                 |
 Ekran (menzil-azimuth, hedefler)   <--- UDP (detected) ---  detected_idx + sayaçlar
 + beklenen sonuçla canlı karşılaştırma
```

### 9.3 Kararlar ve gerekçeleri

1. **Üretim ve iletim ayrıdır.** MATLAB uçuş senaryosunu çevrimdışı CPI'lara dönüştürür
   (bölüm 5'teki dosyalarla aynı biçimde). Streamer bunları gerçek hızda gönderir. Senaryonun
   canlı değiştirilmesi istenirse ileride daha hızlı bir üretici (C++/Python) gerekir, bu ayrı
   bir iştir.
2. **"Gerçek zamanlı" tanımı.** FPGA işlemesi deterministiktir (CPI = 20 ms). Ethernet hattı
   hard real-time değildir. Latency'yi **FPGA içinde** ölçmeyi öneriyorum ("son örnek girdi ->
   tespit çıktı", donanım sayacıyla). "PC'den gönder -> PC'de al" süresi ayrı bir sayı olarak
   raporlanır, ikisi karıştırılmaz.
3. **Zamanlama CPI seviyesinde yapılır.** PC'de 1 ms'lik PRI aralığını tutturmak jitter'lıdır.
   Bunun yerine 80 KB'lık CPI tek seferde gönderilir ve FPGA'de çift tampon kullanılır. 20
   ms'lik aralık PC için kolayca sağlanır.
4. **Veri hızı düşüktür.** Giriş: 1000 örnek x 4 B x 1000 PRI/s = **4 MB/s (32 Mbit/s)**.
   Çıkış (`detected_idx`) bunun yanında ihmal edilebilir. 100 Mbit hat bile yeterlidir, 1 GbE
   ise rahattır.
5. **Ara noktalar sürekli geri gönderilmez.** FFT çıkışı (T5) CPI başına 1 MB'dır, gerçek
   hızda ~400 Mbit/s eder. T2..T6 yalnızca **istek üzerine tek CPI** için geri okunur. Bu,
   bölüm 5'teki test vektörü akışının dosya yerine Ethernet üzerinden yapılmış halidir.
6. **Protokol: UDP + özel başlık.** Başlık: `magic, cpi_id, pri_idx, seq, flags`. TCP'nin
   yeniden iletimi FPGA'de ağırdır ve gecikmeyi belirsizleştirir. Doğrudan kablo (switch yok)
   ve sabit IP ile kayıp beklenmez, yine de `seq` ile kayıp yakalanır: eksik CPI atılır ve
   işaretlenir. Standart MTU'da (1500 B) bir PRI (4000 B) 3 pakete bölünür, jumbo frame ile
   tek pakete sığar.
7. **Ekran PC tarafındadır.** `beam_az/el`, hedef koordinatları ve zaman PC'de zaten
   mevcuttur. FPGA yalnızca `cpi_id`, `detected_idx` ve sayaçları döndürür, PC bunları
   `cpi_id` ile eşleyip çizer. Ek olarak dönen tespit, dosyadaki beklenen `detected_idx` ile
   canlı karşılaştırılıp pass/fail gösterilebilir.

### 9.4 Kart: KV260 (Zynq UltraScale+, PS + PL)

Donanım README'sine göre zincirin tamamı PL'de, veri aktarımı PS'te yönetilir. Test verisi
host'tan gelir, PS belleğinde tutulur ve AXI DMA ile PL'e aktarılır, sonuç aynı yolla geri
döner. Bu durumda:

- Ethernet PS'te sonlanır (lwIP ya da Linux üzerinde UDP soketi), CPI tamponu PS belleğinde
  tutulur ve AXI DMA ile PL akışına verilir. Bu, bölüm 9.3'teki "CPI'ı tek seferde gönder"
  kararıyla uyumludur.
- PS/DMA yolu gecikmeye jitter ekler. Bu yüzden latency PL içinden ölçülmelidir (karar 2).
- KV260 1 GbE'ye sahiptir, veri hızı (4 MB/s) için fazlasıyla yeterlidir.

---

## 10. Uçuş senaryosu (yaklaşan değişiklik)

Golden modelin sıradaki işi: sabit hızlı düz hatta uçan bir uçağa takılı radarın, yılan
(raster) taramayla yerdeki hedefleri **ardışık CPI'larla** görmesi. Bu durum veriye şunları
ekler:

- **Frame yerine CPI dizisi.** Her CPI 20 darbedir (20 ms), `rx` (1000x20). Vektör klasöründe
  `cpi_0000/`, `cpi_0001/`, ... alt klasörleri bulunur, her birinde bölüm 5'teki dosyalar yer
  alır.
- **Yan bilgi (metadata).** CPI zamanı, `beam_az`, `beam_el`. FPGA algoritması buna bağlı
  değildir, yalnızca tespiti beam yönüyle eşlemek için gereklidir.
- **Doppler sınırları.** PRF = 1 kHz ve `lambda = 0.1 m` için belirsizliksiz radyal hız
  **±25 m/s**, kör hız **50 m/s ve katlarıdır**. Uçak hızı bunun çok üzerindedir, sarmalanma
  olacaktır. İlk sürümde platform hareketinin ideal telafi edildiğini varsayacağım (clutter
  sıfır Doppler'de kalır). Bu varsayım gerçekte sağlanmazsa MTI clutter'ı silemez ve mimari
  etkilenir. Birlikte takip edilmesi gereken bir risktir.
- **`N_PRI = 1000` ve PRF sabit kalacaktır**, boyut sözleşmesi bozulmasın diye.
- **M/N tutarlılık** (CPI'lar arası birleştirme) FPGA'nin dışında, izleme katmanında
  yapılacaktır. FPGA tarafı yine tek CPI içinde `detected_idx` üretir.

---

## 11. Donanım tarafından beklenen kararlar

| # | Karar | Şu anki varsayımım |
|---|---|---|
| 1 | Giriş kelime uzunluğu ve ölçek | 16 bit I/Q, `scale = 2^31` |
| 2 | Ara aşama kelime uzunlukları (matched, MTI, FFT, CFAR gücü) | Belirlenmedi. Ölçümler: matched ~+1.5 bit, güç yolu ~32 bit |
| 3 | Doppler FFT boyutu | RTL **128** kullanıyor. Golden modelde `NFFT = 128` ile denedim: 200 deneme, `lla`, `rng` sabit değil, Pd = 1.00 ve Pfa = 1.55e-4 (NFFT = 256'da 1.50e-4), fark gürültü düzeyinde. Tek geçerli hedefli senaryoda ve tek tohum kümesinde ölçüldü, kesin değil. Karşılaştırma vektörleri `NFFT = 128` ile üretilmelidir. |
| 4 | CFAR kenar davranışı | Taşan hücreler atılır, `k` kırpılır (bölüm 4.2) |
| 5 | `MAXDET` | 16 |
| 6 | Dosya formatı ve sıralama | Bölüm 5 |
| 7 | Yuvarlama ve doyma politikası | Belirlenmedi |
| 8 | Latency ölçüm tanımı | "Son örnek PL'e girdi -> tespit çıktı". Alt sınır: CPI = 20 ms |
| 9 | Tespitle birlikte Doppler (hız) bilgisi de verilsin mi? | Hayır, yalnızca menzil |
| 10 | Kart türü ve Ethernet hızı | KV260 (README), 1 GbE. Ethernet PS'te sonlanır |
| 11 | Öncelik: demo mu, ölçüm mü? | İkisi de aynı kurguyla yapılabilir, öncelik sırası değişir |

---

## 12. Sonraki işler (golden model tarafı)

1. ~~`func_export_vectors.m`~~ Yazıldı (tek frame, bölüm 5.1).
2. Bölüm 8'deki geri kalan vektör setinin üretimi (`nominal` hazır, diğerleri için senaryo
   girişleri gerekiyor: hedefsiz, tek darbe, sinüs, kör hız, kenar hücreleri, iki yakın hedef,
   doyma).
3. Bölüm 11'deki kararlar geldiğinde **Seviye B** (bit-doğru) model.
4. Gürültü modelinin Gauss'a çevrilmesi ve TX çelişkisinin çözülmesi. Ardından vektör
   sürümünün yükseltilmesi.
5. Uçuş senaryosu tamamlandığında CPI dizisi vektörleri.
6. Ethernet için PC tarafı streamer ve paket formatı (bölüm 9), kart türü belli olunca.

Algoritma detayları, parametreler ve deneyler için golden model reposunda `README.md`
(özellikle bölüm 3, 5, 11, 12) ve `DEVLOG.md` bulunmaktadır.
