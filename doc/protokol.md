# KV260 PC ↔ kart protokolü (sürüm 2)

Tek TCP portu (5001), **çok istemci**: her bağlantı sunucuda ayrı bir thread. Radar GUI'si, MATLAB istemcileri ve CLA GUI'si aynı anda bağlanabilir. C tanımları: `sw/kv260_proto.h`, Python istemcisi: `pc/kv260_link.py`.

## Başlık (değişmedi)

| Alan | Tip | Not |
|---|---|---|
| magic | u16 | 0x5244 |
| type | u8 | aşağıdaki tablo |
| flags | u8 | 0 |
| cpi | u16 | radar: CPI no; diğerleri: sıra no, cevapta aynen döner |
| rsv | u16 | 0 |
| len | u32 | gövde bayt sayısı |

Little-endian, `packed`, float = IEEE-754 tek duyarlık. **Cevap tipi = istek tipi | 0x80.**

Bilinmeyen tip ya da uzunluğu yanlış yeni mesaj artık bağlantıyı kapatmaz: gövde okunup atılır, `T_HATA (0x7F)` döner (`status`, `istek_tipi`). Radarın eski üç mesajında uzunluk hatası eskisi gibi bağlantıyı kapatır.

## Tipler

| Tip | Ad | Gövde (istek) | Cevap gövdesi |
|---|---|---|---|
| 0x01 | CONFIG | radar, değişmedi | 0x81 ACK |
| 0x02 | RUN | radar, 80000 B | 0x82 RESULT |
| 0x03 | PING | yok | 0x83 PONG |
| 0x10 | CLA_INFO | yok | status, kimlik, kontrol, mirun, mifr, miovf, mier, irq_durum, sim_calisiyor (9 × u32) |
| 0x11 | CLA_REGWR | n × {u32 ofset, u32 değer}, 1 ≤ n ≤ 128 | status, n |
| 0x12 | CLA_REGRD | n × u32 ofset | status, n, n × u32 değer |
| 0x13 | CLA_RUN | u32 görev_maske, u32 zaman_aşımı_µs, u32 m2c_n, m2c_n × u32 | status, geçen_µs, irq_durum, miovf, C2M (64 × u32) |
| 0x14 | CLA_RESET | yok | u32 status |
| 0x20 | SIM_CONFIG | `sim_config_t` (212 B) | u32 status |
| 0x21 | SIM_CMD | `sim_cmd_t` (24 B) | u32 status |
| 0x22 | SIM_TELEM | u32 kayıt_iste (0..4) | `sim_telem_t` (180 B) + kayıt_n × `sim_kayit_t` (776 B) |

### CLA alt seviye (0x10–0x14)

Hata ayıklama içindir. **Simülasyon çalışırken CLA'ya yazan mesajlar (REGWR, RUN, RESET) `S_MESGUL` döner**; INFO ve REGRD her zaman çalışır.

- **Ofsetler** CLA penceresine görelidir (0x000–0xFFC, 4'ün katı). Biri bile geçersizse hiçbir yazma yapılmaz, `S_GECERSIZ_OFS` döner. Yazmaç haritası `sw/kv260_proto.h` (`CR_*`) ve `rtl/CLA_AXI_Lite.sv` başlığında.
- **CLA_RUN:** M2C'ye ilk `m2c_n` kelimeyi yazar → IRQ_DURUM'daki maskedeki bitleri temizler → `MIFRC = görev_maske` → `IRQ_DURUM & maske == maske` olana kadar bekler → C2M'nin tamamını okur. MVECT ve MIER önceden REGWR ile kurulmuş olmalı.
- **CLA_RESET:** KONTROL.CLA_SIFIRLA darbesi. Görev yazmaçları ve MVECT sıfırlanır; M2C, IRQ_MASKE korunur. Sunucu ardından drone programının MVECT/MIER değerlerini yeniden yazar ve KIMLIK'i denetler.

### Drone simülasyonu (0x20–0x22)

Fizik kartta (PS) 1 kHz'de koşar; PC yalnız komut gönderir ve telemetri çeker.

**SIM_CMD** (`komut`, `a[3]`, `b[2]`):

| Kod | Ad | Parametre |
|---|---|---|
| 1 | BASLAT | CLA'yı sıfırlar, MVECT/MIER/kazançları yazar, görev 8 ile durumu sıfırlar, döngüyü başlatır |
| 2 | DURDUR | — |
| 3 | SIFIRLA | drone (0,0,0), hedef 0, bozucular kalkar, gözlemci açık; görev 8 C2M durumunu sıfırlar |
| 4 | HEDEF | a = (x, y, z) m, ENU (z yukarı); x, y ±50, z 0..30 |
| 5 | RUZGAR | a = sabit rüzgâr (m/s), ±15 |
| 6 | DARBE | a = kuvvet (N, ±20), b0 = süre (s, ≤ 2) |
| 7 | MOTOR | b0 = motor no (1..4), b1 = verim (0..1) |
| 8 | YUK | b0 = ek kütle kg (0..1); kontrolcü bilmez |
| 9 | GOZLEMCI | b0 = 1 açık / 0 kapalı (görev 4 ileri beslemesi) |

**SIM_CONFIG** yalnız simülasyon dururken kabul edilir. Drone parametreleri (kütle, kol, Ixx/Iyy/Izz, kt, km, motor τ), görev bölenleri (`bolen[0]` = 1) ve 40 kazanç (yerleşim: `doc/cla_drone.md`). Varsayılanlar `sim_varsayilan()` içinde; GUI bu mesajı göndermez.

**SIM_TELEM** cevabı: anlık durum (konum, hız, Euler açıları, açısal hız, hedef, motor komutları, rüzgâr, kestirim (N), motor verimleri, ek kütle, gözlemci, adım başına CLA süresi son/en çok, görev sayaçları, darbe, `sahte`) ve isteğe bağlı en son `kayıt_n` adımın **golden kaydı**.

**Golden kaydı** (`sim_kayit_t`): adım no, görev maskesi, CLA'nın gördüğü M2C (64 kelime), adım öncesi C2M ve adım sonrası C2M. Kayıtlar ardışıktır. Bir adımın sonucu yalnız (maske, M2C, adım öncesi C2M) üçlüsüne bağlıdır; PC aynı girişi `core.py`'de koşturup C2M'nin ilk 33 kelimesini bit bit karşılaştırır (`pc/cla_golden.py`).

## Status kodları

| Kod | Anlam |
|---|---|
| 0 | tamam |
| 1–4 | radar (DMA hatası, DMA zaman aşımı, done zaman aşımı, TX yüklü değil) |
| 5 | CLA zaman aşımı |
| 6 | geçersiz ofset |
| 7 | bilinmeyen tip |
| 8 | meşgul (simülasyon çalışıyor) |
| 9 | simülasyon yok |
| 10 | geçersiz parametre / uzunluk |
| 11 | CLA KIMLIK yanlış (bitstream'de CLA yok ya da adres farklı) |

## Örnek (Python)

```python
from kv260_link import Kart, SK_BASLAT, SK_HEDEF, SK_RUZGAR
k = Kart("192.168.1.50")
print(hex(k.cla_info()["kimlik"]))        # 0x434c4101
k.sim_komut(SK_BASLAT)
k.sim_komut(SK_HEDEF, (3, 2, 2))
k.sim_komut(SK_RUZGAR, (6, 0, 0))
t = k.sim_telem(4)                        # t["poz"], t["kestirim"], t["kayitlar"][...]
```
