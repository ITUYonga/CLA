# YONGA Control Law Accelerator (CLA)

**İTÜ YONGA** tarafından **SystemVerilog** ile sıfırdan geliştirilen **Control Law Accelerator (CLA)**; Texas Instruments TMS320F2803x (Type-0 CLA, SPRUI10A Bölüm 10) mimarisini temel alan, **8 aşamalı boru hattına (pipeline)** ve **32-bit IEEE-754 kayan nokta (FP32)** yürütme çekirdeğine sahip bağımsız, deterministik bir gerçek zamanlı kontrol yardımcı işlemcisidir (co-processor).

Bu depo; sentezlenebilir **SystemVerilog RTL** tasarımını, **AMD/Xilinx Kria KV260** (Zynq UltraScale+ MPSoC) için **AXI4-Lite** donanım sarmalayıcısını, çevrim-doğru (cycle-accurate) **Python Golden Model** ve assembler/linter araç zincirini (`core.py`), **431 buyrukluk çok hızlı (multi-rate) kaskad quadrotor uçuş kontrolcüsü + bozucu gözlemcisi** uygulamasını (`drone.casm`) ve gerçek zamanlı **Web Telemetri Arayüzünü (`cla_gui.py`)** içerir.

## Öne Çıkan Özellikler

* **8 Aşamalı Deterministik Boru Hattı (`F1 → F2 → D1 → D2 → R1 → R2 → E → W`):** Buyruk getirme, kombinasyonel çözme, etkin adres/dallanma, bellek okuma, yürütme ve geri yazma aşamalarından oluşur.

* **78 Kodlamalı 32-Bit Özel Komut Seti (ISA):** Standart FP32 aritmetiği (`MADDF32`, `MSUBF32`, `MMPYF32`), paralel **Dual-Issue** buyruklar (`MMACF32 || MMOV32`, `MMPYF32 || MADDF32`, `MMPYF32 || MSUBF32`), LUT tabanlı tek çevrimlik `1/x` (`MEINVF32`) ve `1/√x` (`MEISQRTF32`) kestirimleri, tip dönüşümleri (`MI16TOF32`, `MF32TOI16R` vb.) ve koşullu dallanma (`MBCNDD`, `MCCNDD`, `MRCNDD`) desteği sunar.

* **Olay Güdümlü 8 Bağımsız Görev (`Task 1–8`):** Donanım tetikleri (`hw_task_trig`) veya yazılım (`MIFRC`) ile başlatılan, öncelik hakemli (`cla_gorev_denetci`) 8 görev vektörü (`MVECT1–8`) barındırır.

* **İki Aşamalı Kayan Nokta Birimi (`K1 / K2`) ve Bayrak Yönlendirme (`Görünen MSTF`):** Yüksek saat frekansı için FP32 toplayıcı ve çarpıcı `E` ve `W` aşamalarına bölünmüştür; `W` aşamasındaki taşma/alt-taşma (`LVF/LUF`) bayrakları `görünen MSTF` üzerinden `D2` dal birimine gecikmesiz aktarılır.

<img width="1280" height="863" alt="image" src="https://github.com/user-attachments/assets/4e9b7865-6cb1-40ab-b7b6-ab28ce6ccaea" />


* **4 Yazma Portlu `MR0–MR3` Yazmaç Öbeği:** Dual-Issue buyrukların ve 2 aşamalı FPU sonuçlarının boru hattını durdurmadan aynı çevrimde yazılabilmesi için 4 bağımsız yazma portu (`exe_hedef`, `exe_hedef_2`, `K2 topla`, `K2 çarp`) ve donanımsal öncelik mantığı (`E > topla K2 > çarp K2`) içerir.

* **Çevrim-Doğru Golden Model ve HIL Doğrulaması:** RTL donanımı, Python tabanlı çevrim-doğru referans model (`pc/core.py`) ve C referans modeli (`libsim`) ile her kontrol adımında `C2M` mesaj RAM'i üzerinden **bit-bit (bit-true)** karşılaştırılır.

## Mimari Genel Bakış

### 1. Boru Hattı Aşamaları (8 Kademe)

<img width="1750" height="625" alt="1" src="https://github.com/user-attachments/assets/5f75e260-c3bd-4283-ae21-65f7f6f8e407" />

```
[F1: Fetch1] ──► [F2: Fetch2] ──► [D1: Decode1] ──► [D2: Decode2] ──► [R1: Read1] ──► [R2: Read2] ──► [E: Execute (K1)] ──► [W: Write (K2)]
     │                │                │                 │                │               │                   │                   │
  getir_pc      L3 Program RAM    cla_decoder      Etkin Adres &     L1/L2 & C2M/M2C   Bellek Verisi    ALU, Kestirim,      FP32 K2 Sonucu,
  MVECT / Dal    (2K x 32-bit)   (Kombinasyonel)   Dallanma (MSTF)    Adres & Hazard    Yakala (dout)   Dönüşüm, FP32 K1   MR0-3 & RAM Yazma

```

* **`F1` (`Fetch1.sv` — Getirme Adresi):** 12-bit `getir_pc` yazmacını yönetir. Görev başlangıcında `MVECT[no]`, dallanmada `dal_hedef`, normal akışta `getir_pc + 2` seçilir. Aktif görev yokken (`getir_izin = 0`) boru hattına otomatik balon (bubble) sürer.

* **`F2` (`Fetch2.sv` — Buyruk Okuma):** `4K × 16` (`2K × 32-bit`) boyutundaki `L3 Program BRAM`'den (`PROGRAM_HEX`) 32-bit buyruk kelimesini okur.

* **`D1` (`Decode1.sv` — Buyruk Çözme):** `cla_decoder.sv` modülü ile 32-bit buyruğu tamamen kombinasyonel olarak çözer; buyruk kimliğini (`op_e`) ve operand alanlarını (`alanlar_t`) çıkarır.

* **`D2` (`Decode2.sv` — Kontrol, Adres ve Dallanma):** `cla_ctrl_gen.sv` ile kontrol sinyallerini üretir; doğrudan (`@dir`) veya dolaylı (`*MAR0[#imm]++`, `*MAR1[#imm]++`) etkin adresi hesaplar. `görünen MSTF` bayraklarına göre dallanma kararını verir ve `MSTOP` komutunda görev denetçisini bilgilendirir.

* **`R1` (`Read1.sv` — Bellek Okuma Adresi):** `L1`, `L2` veri BRAM'leri ve `C2M` / `M2C` mesaj RAM'leri için okuma adresini sürer. Tek-portlu BRAM'de `W` aşamasıyla aynı bloğa erişim çakışması varsa `dur_r1` sinyaliyle okumayı 1 çevrim bekletir.

* **`R2` (`Read2.sv` — Bellek Verisi Yakalama):** RAM bloklarından dönen 16/32-bitlik veriyi (`dout`) yakalar ve yürütme aşamasına (`R2/E`) aktarır.

* **`E` (`Execute.sv` — Yürütme ve FPU 1. Aşama):** `MR0–MR3` yazmaçlarını okur. Tamsayı ALU, FP32 karşılaştırma (`MCMPF32`, `MMINF32`, `MMAXF32`), tip dönüşümü (`I16/UI16/I32/UI32 ↔ FP32`) ve LUT tabanlı kestirim (`MEINVF32`, `MEISQRTF32`) işlemlerini tek çevrimde tamamlar; FP32 toplama ve çarpmanın 1. aşamasını (`K1`) başlatır.

* **`W` (`Write.sv` — Geri Yazma ve FPU 2. Aşama):** FP32 toplama ve çarpmanın 2. aşamasını (`K2`) tamamlar; sonuçları `MR0–MR3` yazmaçlarına, veri RAM'lerine ve `MSTF` durum yazmacına yazar.

### 2. CLA Bellek Haritası (16-Bit Kelime Adresli)

<img width="576" height="494" alt="0" src="https://github.com/user-attachments/assets/2fa04507-40d7-4113-ba2e-274b39571f42" />

* **`C2M Message RAM` (`0x1480`, `128 × 16-bit` / `64 × 32-bit`):** CLA → CPU mesaj belleği. CLA okur ve yazar, CPU okur; kalıcı kontrol durumları ve hesaplanan motor komutları burada tutulur.

* **`M2C Message RAM` (`0x1500`, `128 × 16-bit` / `64 × 32-bit`):** CPU → CLA mesaj belleği. CPU okur ve yazar, CLA okur; sensör ölçümleri, hedef referansları ve kontrol kazançları buradan alınır.

* **`L1 Data RAM` (`0x8800`, `1024 × 16-bit` / `2 KB`):** Görev içi geçici değişkenler için birinci yerel veri BRAM bloğu.

* **`L2 Data RAM` (`0x8C00`, `1024 × 16-bit` / `2 KB`):** İkinci yerel veri BRAM bloğu.

* **`L3 Program RAM` (`0x0000`, `4096 × 16-bit` / `2048 × 32-bit`):** 12-bit `MPC` / `getir_pc` ile adreslenen buyruk belleği (`drone_l3.hex`).

### 3. AXI4-Lite Kayıt Haritası (`CLA_AXI_Lite.sv`)

KV260 Zynq UltraScale+ PS (`HPM0`) üzerinden önerilen `0xA001_0000` taban adresinde 4 KB'lık bir AXI4-Lite alanı olarak haritalanır:

* **`0x000 – 0x01C` (`MIFR`, `MIOVF`, `MICLR`, `MICLROVF`, `MIFRC`, `MIER`, `MIRUN`, `MCTL` — R/W):** Görev kontrol ve durum yazmaçları (`ofset = reg_no * 4`). `MCTL` bit 0: `HARDRESET`, bit 1: `SOFTRESET`.

* **`0x020 – 0x03C` (`MVECT1 – MVECT8` — RW):** Görev 1–8 başlangıç PC adresleri (12-bit kelime adresi).

* **`0x040` (`IRQ_DURUM` — R/W1C):** Bit `i`, Görev `i+1`'in tamamlandığını (`pie_kesme[i]` yükselen kenarı) gösterir; `1` yazılarak temizlenir.

* **`0x044` (`IRQ_MASKE` — RW):** PS kesme maskesi (`irq = |(IRQ_DURUM & IRQ_MASKE)`).

* **`0x048` (`KONTROL` — RW):** Bit 0 (`CLA_SIFIRLA`) `1` iken `CLA_Top` çekirdeğini resette tutar (AXI arayüzü ve Message RAM'ler etkilenmez).

* **`0x04C` (`KIMLIK` — R):** Sabit donanım kimliği (`0x434C_4101` — `"CLA"` + sürüm `01`).

* **`0x100 – 0x1FC` (`M2C[0..63]` — RW):** CPU → CLA mesaj RAM'i (64 adet 32-bit kelime).

* **`0x200 – 0x2FC` (`C2M[0..63]` — R):** CLA → CPU mesaj RAM'i (64 adet 32-bit kelime).

## Örnek Uygulama: Çok Hızlı (Multi-Rate) Quadrotor Uçuş Kontrolcüsü (`drone.casm`)

Depoda CLA'nın gerçek zamanlı yeteneklerini doğrulamak üzere 6-DOF quadrotor fiziğiyle çalışan, **431 buyrukluk** (`CRC32 = 0x276C7CCB`) çok katmanlı bir uçuş kontrolcüsü yer alır (`gui/drone_uret.py` tarafından üretilir):

* **Görev 1 (`MVECT1 = 0x000` — 1 kHz / Her Adımda):** Açısal hız döngüsü (`p, q, r` için PI + ölçümden türev D kontrolü) ve 4 motor karıştırıcısı (`u1..u4 ∈ [0, 1]`).

* **Görev 2 (`MVECT2 = 0x0CE` — 500 Hz / 2 Adımda Bir):** Roll, Pitch ve Yaw açıları için oransal (P) kontrol ve açısal hız referansı (`wref_x, wref_y, wref_z`) üretimi.

* **Görev 3 (`MVECT3 = 0x118` — 100 Hz / 10 Adımda Bir):** 3 eksende konum (P) → hız (PI + anti-windup) → ivme → küçük açı ve yaw rotasyonuyla `pitch_ref`, `roll_ref` ve toplam itki (`t`) hesabı.

* **Görev 4 (`MVECT4 = 0x24E` — 100 Hz / 10 Adımda Bir):** Hız tabanlı **Bozucu Gözlemcisi (Disturbance Observer)**. Komut itkisi ve ölçülen açılardan beklenen model ivmesini (`amx, amy, amz`) hesaplar; hız hatası üzerinden dış rüzgar ve darbe ivmelerini (`eh_x, eh_y, eh_z`) kestirerek Görev 3'e ileri besleme (feedforward) sağlar.

* **Görev 8 (`MVECT8 = 0x318` — Başlangıç / Sıfırlama):** `C2M` belleğindeki 33 kalıcı kontrol durumu kelimesini sıfırlar.

## Klasör Yapısı

```
CLA-main/
├── gui/
│   ├── drone_uret.py      # Sembol tablolarından drone.casm uçuş kontrolcüsünü üretir
│   ├── derle.py           # drone.casm'ı derler, lint eder -> drone_l3.hex ve sw/drone_cla.h üretir
│   ├── drone.casm         # 431 buyrukluk CLA assembly uçuş kontrol programı
│   ├── drone_l3.hex       # L3 Program BRAM başlangıç dosyası (4096 x 16-bit)
│   └── cla_dongu.py       # Kart gerektirmeden kapalı döngü Golden Model + C referans simülasyonu
├── mem/
│   ├── drone_l3.hex       # Sentez için L3 program belleği imajı
│   └── estimate_lut.hex   # MEINVF32 (1/x) ve MEISQRTF32 (1/√x) için 1024x8-bit LUT
├── pc/
│   ├── core.py            # TI Type-0 CLA Golden Model, 8 kademeli boru hattı, Assembler & Linter
│   ├── cla_golden.py      # GoldenCla sarmalayıcısı (adım adım görev koşturma)
│   ├── sim_baglanti.py    # 6-DOF drone fiziği (libsim.dll / libsim.so) ctypes arayüzü
│   ├── kv260_link.py      # KV260 radar_server (TCP 5001) istemci protokolü
│   ├── kart_test.py       # KV260 donanımını Golden Model ile bit-bit doğrulayan uçtan uca test
│   ├── cla_gui.py         # Gerçek zamanlı Web Telemetri sunucusu (http://localhost:8081)
│   └── cla_gui.html       # 3B/telemetri kontrol paneli arayüzü
├── rtl/cla/
│   ├── cla_wrapper.v      # Vivado Block Design uyumlu Verilog-2001 AXI4-Lite üst kabuğu
│   ├── CLA_AXI_Lite.sv    # AXI4-Lite slave arayüzü ve mesaj RAM entegrasyonu
│   ├── cla_mesaj_ram.sv   # C2M ve M2C çift erişimli köprü bellekleri
│   ├── top/               # CLA_Top.sv ve 8 boru hattı aşaması (Fetch1..Write, Gorev_Yazmaclari)
│   ├── kontrol/           # cla_pkg.sv, cla_decoder.sv, cla_ctrl_gen.sv, cla_gorev_denetci.sv
│   ├── yazmac_bellek/     # MR0-3, MAR0-1, MSTF, MVECT1-8, kontrol yazmaçları ve veri RAM'i
│   └── alu/               # ALU.sv, 2 aşamalı FP32 toplayıcı/çarpıcı, kestirim, dönüşüm, karşılaştırma
├── sw/
│   └── drone_cla.h        # derle.py tarafından üretilen MVECT, MIER ve CRC32 C başlık dosyası
└── sistem_test.bat        # Windows üzerinde derleme + KV260 donanım testini tek tıkla koşturur

```

## Kurulum ve Kullanım

### 1. CLA Assembly Programını Üretme ve Derleme

`drone_uret.py` kontrol algoritmasını `.casm` formatında üretir; `derle.py` ise kodu statik boru hattı kurallarına göre denetler (lint), makine koduna çevirir ve hem FPGA BRAM imajını (`drone_l3.hex`) hem de C başlık dosyasını (`sw/drone_cla.h`) günceller:

```
cd gui
python3 drone_uret.py
python3 derle.py

```

### 2. Kartsız (PC Üzerinde) Kapalı Döngü Golden Model Simülasyonu

KV260 kartı olmadan, 6-DOF drone fiziğini Python Golden Model (`core.py`) üzerinde koşturmak ve C referans modeliyle (`--c-ref`) her adımda `C2M` belleğini bit-bit karşılaştırmak için:

```
cd gui
python3 cla_dongu.py 10000 --c-ref

```

Bu senaryo sırasıyla kalkış, hedef değişimi, `6 m/s` yan rüzgar, dış darbe, tek motorda `%30` verim kaybı, `0.3 kg` ek yük ve bozucu gözlemcisini kapatıp açma testlerini yürütür.

### 3. Gerçek Zamanlı Web Telemetri Arayüzü (`cla_gui.py`)

Tarayıcı üzerinden (`http://localhost:8081`) drone durumunu, motor komutlarını, rüzgar/darbe bozucularını ve Golden Model bit-true doğrulama sayaçlarını canlı izlemek için:

```
cd pc
# Kartsız simülasyon modu (PC üzerinde fizik + referans model):
python3 cla_gui.py --model

# KV260 FPGA donanım modu (kartta radar_server çalışırken):
python3 cla_gui.py --board 192.168.137.92:5001

```

### 4. Kria KV260 Üzerinde Uçtan Uca Donanım Testi (`kart_test.py`)

KV260 kartında bitstream yüklü ve `radar_server` çalışır durumdayken, aşağıdaki komut (veya Windows'ta doğrudan `sistem_test.bat`) 4 aşamalı doğrulamayı gerçekleştirir:

1. **Bağlantı ve Donanım Kimliği:** AXI4-Lite üzerinden `KIMLIK` yazmacının `0x434C4101` döndüğünü doğrular.

2. **Program Bütünlüğü:** Sunucudaki `DRONE_CLA_CRC` değeri ile yerel `drone.casm` programının CRC32 imzasını karşılaştırır.

3. **Adım Adım FPGA vs. Golden Model:** Fizik motorunu PC'de, kontrol görevlerini KV260 üzerindeki FPGA CLA çekirdeğinde koşturur; her adımda aynı girişi Python Golden Model'e verip `C2M` çıkışlarının **bit-bit (bit-true)** aynı olduğunu doğrular.

4. **Kart Üzerinde 1 kHz Uçuş Simülasyonu:** 12 saniyelik rüzgar ve darbe senaryosunu doğrudan kart üzerinde koşturup zamanlama ve hedefe varış kriterlerini test eder.

```
cd pc
python3 kart_test.py --kart 192.168.137.92

```

## Ekip

* **Mustafa Taha Aydemir**

* **Safa Oğuzhan Dişbudak**

* **Arda Yalçınöz**

* **Ahmet Kargı**

**İTÜ YONGA** — *Sürekli Üretmek, Ürettikçe Gelişmek.*
