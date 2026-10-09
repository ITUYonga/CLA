# Varsayımlar — TRM'in açıkça söylemediği yerler

Her madde: TRM'in sustuğu (ya da kendi içinde çeliştiği) bir durumda modelin
seçtiği davranış. "(borç)" işaretliler donanımda doğrulanmalı (`02_borclar.md`).

## Kayan nokta

- **Denormal sonuç** +0'a bastırılır, LUF = 1.
- **LUF**, tam sonuç sıfırdan farklı ve |sonuç| < 2⁻¹²⁶ ise kurulur ("yuvarlamadan önce küçüklük"). Yuvarlanmış sonuç MIN_NORMAL olsa bile.
- **Taşma**: RND32=1'de ±∞, RND32=0'da ±MAX (0x7F7FFFFF). LVF eşiği iki modda da en-yakına-yuvarlamanın taşma noktası (borç B4).
- **Sonsuz girdi** sonsuz sonuç verir, LVF kurmaz.
- **NaN sonucu** 0x7FC00000. Aritmetikte NaN girdi "sonsuz" sayılmaz; o kural yalnız karşılaştırma ve min/max için yazılı.
- **∞ × 0 ve ∞ − ∞** NaN verir (kullanıcı kararı).
- **Sıfırın işareti**: tam sıfır sonuçlar +0; alt taşmayla sıfıra yuvarlananlar −0 olabilir (borç B5).
- **Girdi denormalleri**: yazmaçtan tam değer, `#16FHi` sabitinden +0 (borç B2).
- **RND32**, MMACF32'ye de uygulanır (s.718 yalnız MMPYF32/MADDF32/MSUBF32'yi sayıyor).
- **MMACF32**'de MRd == MR3 ise toplama sonucu kazanır.
- **MMAXF32/MMINF32** girdileri MCMPF32 gibi değerlendirir (−0 ve denormal +0, NaN sonsuz). Çıktı dönüşümü (NaN → sonsuz, denormal → +0, −0 → +0) yazma olmasa da uygulanır.
- **MABSF32/MNEGF32** saf işaret biti işlemi: denormal bastırılmaz, NaN yükü korunur.
- **MFRACF32** sıfıra keser; NaN/∞/denormal → +0.
- **MSWAPF** bayrak değiştirmez (UNCF'de de).
- **Kestirim komutları** (proje sözleşmesi, §42):

  | Girdi | MEINVF32 | MEISQRTF32 |
  |---|---|---|
  | ±0 / denormal | ±∞, LVF | +∞, LVF |
  | ±∞ / NaN | +0 | +0 |
  | \|x\| ≥ 2¹²⁶ | +0, LUF | — |
  | negatif | — | \|x\| kullanılır |

  RND32 etkisizdir.

## Dönüşüm ve tamsayı

- **Pozitif taşma (float → tamsayı)**: sonlu değerler sarılır, ±∞ doyurulur (borç 3.19). Negatif → işaretsiz **0** (TRM örnekleri s.623–625).
- **Negatif taşma → işaretli**: sarma (−40000.0 → MF32TOI16 = 0x000063C0).
- **NaN** → 0 (bütün float → tamsayı dönüşümleri). ±∞ → uç değerler. −∞ → işaretsizde 0.
- **Denormal ve −0 girdi** → 0.
- **MI32TOF32 / MUI32TOF32** RND32'ye uyar (s.718 bunları saymıyor; s.630 örneği sıfırlama değerindeki kesmeyle uyumlu).
- **`#SHIFT`** alanı 5 bit, değer − 1 (TRM Tablo 10-7 kendi içinde çelişkili; `#3` TI ile doğrulandı).
- **`#16FHi` yuvasında ondalık tamsayı** ham bittir (`#5` → 0x0005, 5.0 değil).
- **`#16FHi` ondalık kesri** 16 bite kesilerek yazılır (`#0.1` → 0x3DCC). MMOVF32'de en yakına yuvarlanır (TRM hex örnekleriyle uyumlu).

## Bellek ve adresleme

- **Bellek haritası** (Bölüm 10'da yok, cihaz belgesinden):

  | Bölge | Adres | Boyut |
  |---|---|---|
  | CLA → CPU mesaj RAM | 0x1480 | 128 word |
  | CPU → CLA mesaj RAM | 0x1500 | 128 word |
  | L1 veri | 0x8800 | 1K word |
  | L2 veri | 0x8C00 | 1K word |
  | L3 program | 0x9000 | 4K word (s.705 MVECT örneğiyle uyumlu) |
- **Program RAM'e CLA veri erişimi**: okuma 0 döner, yazma yok sayılır (TRM: "cannot occur").
- **Haritada olmayan adres** (çevre birimleri dahil) → hata (kapsam dışı D4).
- **Tek adresli 32-bit erişim** alttaki çift adrese hizalanır; iz, yazma adresini hizalanmış basar.
- **MAR** 16 bittir. Post-increment işaretli ve 16 bitte sarar. Adres, artıştan önceki değerdir.
- **MAR yüklemesi** E'de yapılır. I3 aynı MAR'ı kullanırsa post-increment kazanır, yükleme düşer (s.580). Sıfır artışlı `*MARx` de çakışma sayılır.
- **`MMOV16 mem16, MARx`**: boru hattında MAR D2'de okunur (borç B3).
- **Koşullu yükleme**: koşul E'de, önceki komutun bayraklarıyla değerlendirilir.
- **MMOVZ16**, sıfır olmayan değerde ZF'yi temizler.
- **MSTF yüklemesi** MEALLOW'u değiştirmez (s.657; s.718 aksini söylüyor). Ayrılmış bitler 0'a zorlanır; bit 5–4 hiç kurulmaz.

## Akış kontrolü ve boru hattı

- **Kısıt ihlalleri** (gecikme yuvasında MSTOP/dallanma, MSTOP'un dallanmaya 3 komuttan yakın olması) yakalanmaz; davranış kendiliğinden ortaya çıkar. Lint uyarır (`golden_model/lint.py`).
- **RPC kaydetme/yükleme** dallanmadan en az 4 komut önce yapılmalı (borç B7). MRCNDD'den önce de aynısı geçerli.
- **MSETFLG**: FLAG bit 7 → MSTF bit 9 (RNDF32) (s.686 örneği ve TI).
- **Geçersiz opcode duruşunda** R1/R2'deki komutlar hiç çalışmaz, EXE'deki saklama belleğe inmez.
- **Tek sayılı hedef ya da RPC** getirmeyi aşağı hizalar; ofset 4096 modülünde.
- **R1/W durağı** TRM'deki gibi (K7, §51.3). **FPU K1/K2** zamanlaması K13 (§51). **Görev sınırı** n+2 / n+3 (K6).
- **D2 işi durmada** buyruk D2'den ilerlediği çevrimde yapılır (TRM bu ayrıntıyı yazmıyor; §51.4). Golden ve RTL aynı kuralı uygulamalı.
- **Görev başlama gecikmesi** (tetikten ilk F1'e) modellenmez: görev `run_tasks` / `gorev_basla` ile başlar.
- **Hakem önceliği**: en küçük numaralı hazır görev (s.570).
- **MVECTx**: L3 başından 12-bit word ofseti (s.705). s.570'teki "mutlak 16-bit adres" ifadesiyle çelişiyor; örnekli olan s.705 esas.
- **SOFTRESET / HARDRESET** ve **MPISRCSEL1** yönlendirmesi modellenmez; MMEMCFG ve yürütme yazmaçlarının CPU okuması yoktur.
