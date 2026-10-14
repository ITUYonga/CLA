# CLA: drone uçuş kontrolcüsü (KV260)

Radar zinciriyle aynı FPGA'da, ondan tamamen bağımsız ikinci bir birim. CLA (TI F2803x CLA Type-0 uyumlu çekirdek), PS'de koşan bir quadrotor modelinin uçuş kontrolcüsüdür ve onu rüzgâr, darbe, motor verim kaybı ve ek yük gibi bozuculara karşı hedef noktada tutar. PC'deki CLA GUI'si hedefi klavyeyle verir, bozucuları uygular ve sonuçları gösterir.

```
PC ── TCP 5001 ── PS (Ubuntu, radar_server)
                    ├─ radar thread'leri ── HPM0 ── radar_wrapper (0xA000_0000) + AXI DMA
                    └─ sim thread (1 kHz) ── HPM0 ── cla_wrapper   (0xA001_0000)
                         fizik (sim_fizik.c) ⇄ M2C / C2M ⇄ CLA görevleri 1-4, 8
```

## Dosyalar

| Klasör | Dosya | İçerik |
|---|---|---|
| `rtl/` | `cla_wrapper.v` | BD için Verilog-2001 kabuğu (`CLA_AXI_Lite`'ı sarar) |
| | `CLA_AXI_Lite.sv` | AXI4-Lite slave: görev yazmaçları, MVECT, IRQ, KONTROL, KIMLIK, mesaj RAM'leri |
| | `cla_mesaj_ram.sv` | M2C / C2M: CLA portu `cla_data_ram` ile aynı, yanında AXI portu |
| `tb/` | `tb_CLA_AXI_Lite.sv` | AXI testbench'i (751 denetim) |
| `cla/` | `drone_uret.py` → `drone.casm` | CLA programı (CASM) üreteci ve çıktısı |
| | `derle.py` → `drone_l3.hex`, `../sw/drone_cla.h` | L3 görüntüsü (bitstream) ve sunucunun MVECT başlığı |
| | `cla_dongu.py` | Kapalı döngü: fizik + golden CLA (kart gerekmez) |
| `sw/` | `radar_server.c` | PS sunucusu: radar + CLA + simülasyon, çok istemci |
| | `sim_fizik.c/.h` | Quadrotor fiziği, M2C/C2M yerleşimi (kart ve PC aynı kod) |
| | `kv260_proto.h` | Protokol (bkz. `protokol.md`) |
| | `cla_ref.c/.h` | Görevlerin C karşılığı; yalnız `SAHTE_DONANIM` ve testler |
| `pc/` | `cla_gui.py`, `cla_gui.html` | CLA GUI (port 8081) |
| | `kv260_link.py` | Ortak protokol istemcisi |
| | `cla_golden.py` | `core.py` üzerinde adım koşturma |
| | `sim_baglanti.py` | `libsim` ctypes bağlantısı, yerleşim sabitleri |

`core.py` ve `test_karsilastirici.py` (CLA golden modeli) bu pakette yok. `cla/` klasörüne kopyalanır ya da `CLA_CORE` ortam değişkeniyle yolu verilir.

## Görevler

TI CLA'da görev 1 en yüksek önceliklidir. Aynı adımda tetiklenen görevler 1 → 2 → 3 → 4 sırasıyla koşar. Yavaş döngülerin çıktısını hızlı döngüler bir adım sonra kullanır.

| Görev | İş | Tetik |
|---|---|---|
| 1 | Açısal hız döngüsü (PI + ölçümden D), motor karıştırıcı | her adım (1 kHz) |
| 2 | Açı döngüsü (P) → açısal hız referansı | 2 adımda bir (500 Hz) |
| 3 | Konum (P) → hız (PI) → ivme → açı ve itki referansı | 10 adımda bir (100 Hz) |
| 4 | Bozucu gözlemcisi: dış ivme kestirimi, görev 3'e ileri besleme | 10 adımda bir (100 Hz) |
| 8 | C2M durumunu sıfırla | BASLAT / SIFIRLA |

Golden modelde adım süreleri (görev başlatma dahil): yalnız görev 1 **123 çevrim**, 1+2 **166**, 1+2+3+4 **476 çevrim ≈ 4,8 µs** (100 MHz), yani 1 ms'lik bütçenin %0,5'i. Program 431 komuttur (L3'ün %21'i).

**Kural:** bir adımın sonucu yalnız (görev maskesi, M2C, adım öncesi C2M) üçlüsüne bağlıdır. Kazançlar M2C'de, kalıcı durum (integraller, gözlemci) C2M'de tutulur; L1 yalnız görev içi geçicidir. Golden tekrarı bu kural sayesinde tek bir kayıttan yapılabilir. C2M CPU'ya salt okunur olduğu için sıfırlamayı CLA yapar (görev 8).

### Algoritma

Eksenler: dünya ENU (x doğu, y kuzey, z yukarı), gövde FLU, Euler ZYX. Pozitif pitch burun aşağı ve +x yönünde ivme demektir. Motorlar "+" yerleşimde: 1 +x, 2 +y, 3 −x, 4 −y; 1 ve 3 saat yönünde döner.

- **Görev 1:** `e = ω_ref − ω`, `I = kırp(I + ki·e)`, `δ = kırp(kp·e + I − kd·(ω − ω_önce))` (yaw'da D yok). Karıştırıcı: `u1 = t − δy + δz`, `u2 = t + δx − δz`, `u3 = t + δy + δz`, `u4 = t − δx − δz`, her biri [0, 1].
- **Görev 2:** `ω_ref = kırp(ka · (açı_ref − açı))`; yaw referansı sabit (`K_YAW_REF`).
- **Görev 3:** her eksende `v_ref = kırp(kp_p·(h − p))`, `ev = v_ref − v`, `I = kırp(I + Δff·ê + ki·ev)`, `a = kv·ev + I − ff·ê`. Ardından `pitch_ref = (cosψ·ax + sinψ·ay)/g`, `roll_ref = (sinψ·ax − cosψ·ay)/g`, `t = [tmin, tmax](ct·(g + az)·(1 + (φ² + θ²)/2))`. `Δff·ê` terimi gözlemci açılıp kapanırken integrali kaydırır, geçiş darbesiz olur.
- **Görev 4:** model ivmesi ölçülen açı ve komut itkisinden hesaplanır: `A = t/ct`, `am = A·(cosψ·θ + sinψ·φ, sinψ·θ − cosψ·φ, 1 − (φ² + θ²)/2) − (0, 0, g)`. Her eksende `e = v − v̂`, `v̂ += Ts·(am + ê) + l1·e`, `ê = kırp(ê + l2·e)`. ê dış ivmedir (m/s²); telemetride kütleyle çarpılıp N olarak gösterilir.

`cosψ` ve `sinψ` ölçüm olarak M2C'de gelir; CLA'da trigonometri yoktur.

### M2C yerleşimi (32 bit kelime; CLA adresi 0x1500 + 2i, AXI 0x100 + 4i)

| i | Alan | i | Alan |
|---|---|---|---|
| 0–2 | konum x, y, z | 12–14 | hedef x, y, z |
| 3–5 | hız | 15, 16 | cos ψ, sin ψ |
| 6–8 | roll, pitch, yaw | 17 | ff (gözlemci 1.0 / 0.0) |
| 9–11 | p, q, r | 20–51 | kazançlar (aşağıda) |

Sunucu her adımda 0–19'u, BASLAT ve SIM_CONFIG'ten sonra 64 kelimenin tamamını yazar.

### Kazançlar (M2C 20 + k)

| k | Ad | Varsayılan | k | Ad | Varsayılan |
|---|---|---|---|---|---|
| 0 | kp_r_xy | 0.12 | 16 | kp_v_z | 4.0 |
| 1 | ki_r_xy (adım başına) | 0.0006 | 17 | ki_v_xy (10 ms başına) | 0.005 |
| 2 | kd_r_xy (adım başına fark) | 0.6 | 18 | ki_v_z | 0.01 |
| 3 | kp_r_z | 0.3 | 19 | ilim_v (m/s²) | 6.0 |
| 4 | ki_r_z | 0.0003 | 20 | açı_max (rad) | 0.35 |
| 5 | ilim_r | 0.1 | 21, 22 | g, 1/g | 9.81 |
| 6 | dlim | 0.25 | 23 | ct = m / (4·kt) | 0.051 |
| 7 | ka_xy (1/s) | 6.0 | 24, 25 | tmin, tmax | 0.05, 0.95 |
| 8 | ka_z | 2.0 | 26 | l1 | 0.12 |
| 9 | wmax_xy (rad/s) | 3.0 | 27 | l2 | 0.36 |
| 10 | wmax_z | 1.0 | 28 | Ts gözlemci (s) | 0.01 |
| 11 | kp_p_xy (1/s) | 1.0 | 29 | elim (m/s²) | 5.0 |
| 12 | kp_p_z | 1.5 | 30 | yaw_ref | 0 |
| 13 | vmax_xy (m/s) | 3.0 | 31 | 1/ct | 19.62 |
| 14 | vmax_z | 1.5 | | | |
| 15 | kp_v_xy | 2.5 | | | |

Drone: 1,2 kg, kol 0,25 m, Ixx = Iyy = 0,012, Izz = 0,022 kg·m², kt = 5,886 N (dört motor %50'de asılı kalır), km = 0,016, motor τ = 20 ms, hava sürtünmesi 0,3 N/(m/s) (rüzgâr bu terimle etki eder).

### C2M yerleşimi

| i | Alan | i | Alan |
|---|---|---|---|
| 0–3 | u1..u4 (motor komutu) | 16–18 | hız integrali (görev 3) |
| 4–6 | ω_ref (görev 2 → 1) | 19–21 | komut ivmesi (görev 3) |
| 7–9 | roll_ref, pitch_ref, t (görev 3 → 2, 1) | 22–24 | v̂ (görev 4) |
| 10–12 | hız döngüsü integrali | 25–27 | ê (görev 4 → 3) |
| 13–15 | ω_önce (D terimi) | 28–31 | görev 1–4 sayaçları (u32) |
| | | 32 | önceki ff (görev 3) |

## Doğrulama

| Ne | Nasıl | Sonuç |
|---|---|---|
| AXI wrapper | `tb_CLA_AXI_Lite.sv`, Verilator; CLA_Top yerine görev yazmaçlı model; bilerek sokulan 9 hatanın 8'i yakalandı | 751 denetim, 0 hata |
| CASM ↔ golden | `drone.casm`, `core.py` lint (gecikme yuvası, yaz-oku, MAR gölgesi) | temiz |
| CASM ↔ `cla_ref.c` | `cla_dongu.py 10500 --c-ref` (kalkış, hedef, rüzgâr, darbe, motor %70, +0,3 kg, gözlemci kapat/aç) | 10500 adım bit bit aynı |
| Sunucu | `SAHTE_DONANIM` derlemesi, iki istemci (radar RUN + sim), hata yolları | geçti |
| Kart kaydı → golden | sunucunun `sim_kayit_t` kayıtları `core.py`'de tekrar | 24/24 aynı (sahte); GUI'de sürekli sayılır |

Kapalı döngü davranışı (gözlemci açık): 2 m kalkış yaklaşık 2 s sürer; (3, 2) m'ye geçişte drone 2 s'de hedefe varır, yaklaşık 0,2 m aşar ve 4 s'de 0,05 m'nin altına iner. 6 m/s rüzgâr açıldığında hata en çok 0,22 m olur ve 1 s'de toparlanır. Gözlemci kapalıyken aynı rüzgâr değişiminde hata 0,74 m'ye çıkar ve toparlanması saniyeler sürer. Kestirim, uygulanan rüzgâr kuvvetini (6 m/s × 0,3 = 1,8 N) 1,80 N olarak bulur.

**Kartta henüz doğrulanmadı:** sentez ve timing, gerçek CLA_Top ile AXI testbench'i, kartta 1 kHz zamanlama. Gerçek `cla_gorev_denetci`'nin `pie_kesme`'yi görev başına bit olarak verdiği varsayıldı (golden modelde PIE değeri MIRUN'dur). Değilse IRQ_DURUM beklemesi zaman aşımına düşer.

## Kurulum

### 1. Bitstream (Vivado 2025.2)

1. CLA RTL'ini (`cla_pkg.sv`, boru hattı, ALU/FPU, `estimate_lut.hex` dahil) ve `rtl/` altındaki üç dosyayı projeye ekle. `cla/drone_l3.hex` dosyasını da ekle.
2. **Önce CLA'yı tek başına sentezle** (out-of-context, 100 MHz). WNS < 0 ise CLA'yı ayrı ve daha yavaş bir `pl_clk1`'e al; SmartConnect saat dönüşümünü yapar. Kaynak raporuna bak: radar BRAM'in %58'ini kullanıyor.
3. BD: *Add Module* → `cla_wrapper`. Parametre `PROGRAM_HEX` = `drone_l3.hex` (tam yol ya da proje kaynağı).
4. Bağlantılar:
   - `s_axi_aclk` = `pl_clk0`, `s_axi_aresetn` = `peripheral_aresetn`.
   - `S_AXI`: HPM0 SmartConnect'ine yeni bir master portu ekle.
   - `irq`: xlconcat ile `pl_ps_irq0[1]`'e (sunucu polling yapıyor; bağlamak isteğe bağlı).
5. Address Editor: `cla_wrapper` → **0xA001_0000**, 4K.
6. Bitstream → `bootgen ... radar.bit.bin` (radar adımlarıyla aynı). dtso değişmez; CLA'ya `/dev/mem` ile erişiliyor.

CLA programı değişirse: `python3 cla/drone_uret.py && python3 cla/derle.py` çalıştırılır, ardından bitstream ve sunucu birlikte yeniden üretilir. Sunucu açılışta program CRC'sini yazar.

### 2. Kart

```bash
cd ~/radar      # sw/ altındaki dosyalar buraya
gcc -O2 -ffp-contract=off -pthread -o radar_server radar_server.c sim_fizik.c -lm
sudo ./radar_server
#   RADAR=0xa0000000 DMA=0xb0000000 CLA=0xa0010000 ...
#   CLA KIMLIK=0x434c4101 (tamam) , program 431 komut crc 0x276c7ccb
#   TCP 5001 dinleniyor (cok istemci)
```

`setup.sh` içindeki derleme satırı yukarıdakiyle değiştirilir (`-pthread`, `sim_fizik.c`, `-lm`). Sim thread'i SCHED_FIFO ve CPU 3 ister; `sudo` olmadan da çalışır ama titrer. GUI'deki "aşım" sayacı 1 ms'yi aşan adımları gösterir.

### 3. PC

```bash
cd pc
gcc -O2 -ffp-contract=off -shared -fPIC -o libsim.so ../sw/sim_fizik.c ../sw/cla_ref.c -lm   # yalnız --model için
python3 cla_gui.py --board <kart-ip>:5001      # http://localhost:8081
python3 cla_gui.py --model                     # kartsız
```

Radar GUI'si (8080) aynı anda çalışabilir. Golden sayacı için `core.py`'nin `cla/` klasöründe ya da `CLA_CORE` ile gösterilen yerde olması gerekir; yoksa GUI çalışır, sayaç "kapalı" görünür.

**Kartsız uçtan uca deneme (PC'de sunucu):**

```bash
gcc -O2 -ffp-contract=off -pthread -DSAHTE_DONANIM -o radar_server_sahte sw/radar_server.c sw/sim_fizik.c sw/cla_ref.c -lm
./radar_server_sahte 5001 &   python3 pc/cla_gui.py --board 127.0.0.1:5001
```

### GUI kullanımı

| Tuş / kontrol | İş |
|---|---|
| ← → ↑ ↓ (Shift: 2 m) | hedefi yatayda 1 m kaydır |
| W / S | irtifa ±0,5 m |
| Boşluk / Darbe | rastgele yönde 8 N, 0,3 s |
| G / Gözlemci düğmesi | görev 4 ileri beslemesini aç/kapat (grafikte mavi bölge) |
| R / Sıfırla | drone, hedef ve bozucuları sıfırla |
| Kaydırıcılar | rüzgâr x/y, ek yük, motor 1 verimi |

Üstten görünümde mavi ok uygulanan rüzgârı, kırmızı ok CLA'nın kestirdiği dış kuvveti gösterir. İkisinin örtüşmesi gözlemcinin doğru çalıştığını gösterir.

## Açık konular

- Sentez, timing ve kaynak (madde 1.2); kartta ilk açılış.
- Gerçek CLA_Top ile `tb_CLA_AXI_Lite.sv` (testbench `GOREV_TESTI=1` ile görev 1'i de dener).
- PL saati 90,9 MHz (radar dokümanı 6.4). CLA için yalnız zamanlamayı etkiler; davranış ve golden karşılaştırması değişmez.
- İsteğe bağlı: ölçüm gürültüsü ve sensör gecikmesi (`sim_m2c_doldur`), yaw hedefi, kesmeye geçiş (UIO).
