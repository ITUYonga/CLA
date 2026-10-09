# B yolu: KV260'ın kendi micro-USB'si üzerinden (USB-TTL gerekmez)

```
 Mac (sim.py)                          KV260
 ┌──────────────┐  micro-USB   ┌──────────────┐ AXI4-Lite ┌──────────────────────────────┐
 │ FpgaKontrolcu├─────────────►│ PS UART1     │  (LPD)    │ cla_axi_kopru (mesaj RAM'leri)│
 │ --port auto  │◄─────────────┤ A53: aktarici├──────────►│  └─ CLA_Top (görev yazmaçları │
 └──────────────┘ 921600 baud  │ (bayt taşır) │0x80000000 │     içinde, program L3'te)    │
                               └──────────────┘           └──────────────────────────────┘
```

ARM yalnızca bayt taşır (`aktarici/aktarici.c`, ~600 bayt, BSP yok). Paket çözme, mesaj
RAM'leri ve görev tetikleme PL'deki köprüde; A yolundakiyle aynı çekirdek
(`rtl/cla_kopru_cekirdek.sv`). Dışarıya pin çıkmadığı için **XDC gerekmez**.

Xilinx'in AXI UART Lite'ı yerine küçük bir AXI-Lite kapı kullanıldı (`rtl/cla_axi_kopru.sv`):
UART Lite 100 MHz'den 921600 baud'u tam bölemiyor, içerideki ikinci UART da gecikme ekliyordu.

## Neler sınandı (kartsız)

| Ne | Nasıl | Sonuç |
|---|---|---|
| **Köprü + CLA_Top ↔ golden** (drone programları ick, ic, tek) | `cd tb && python3 -B kopru_testi.py 300` (Verilator; aktarıcı gibi davranan AXI yöneticisi, `sim.py`'nin paketleri) | 900 ADIM: çıktılar bit bit ve çevrim sayısı (160 / 59 / 207) golden'la aynı |
| Köprü + taklit çekirdek (CLA'dan önce, eski `uart_kopru` klasöründe) | `tb_kopru.py --yol b` | 51/51 |
| Aktarıcı (A53 çıplak program) | `cd aktarici && python3 qemu_dene.py` (QEMU ZynqMP modeli) | açılış satırı, 4 KB yankı, PL yokken hata satırı |
| Port otomatik bulma | sanal kartla | doğru portu buluyor |

Kartta sınanmadı: Vivado betiği, psu_init/JTAG akışı, gerçek PS UART baud'u.

## Mac + sanal makine düzeni

Apple Silicon'da Vivado x86 emülasyonunda çalışır; arayüz çok yavaştır. Bu yüzden:

- **Vivado yalnız bir kez, arayüzsüz (batch) çalışır** ve bitstream üretir. Sanal makineye
  en az 8 GB RAM ve 4 çekirdek verin. Ekipte x86 Windows/Linux bilgisayar varsa orada
  çalıştırmak daha hızlıdır; komutlar aynı.
- **ARM programı Mac'te derlendi**, `aktarici/aktarici.elf` hazır. Vitis projesi gerekmez.
- **Simülasyon Mac'te** çalışır.

## Adımlar

`CLA_Proje` klasörünü sanal makineyle paylaşın (ya da kopyalayın; betik `../rtl` ve
`../uygulama` altına da bakar). Komutlar `fpga_kopru` klasöründen.

**1. Bitstream (sanal makine, ~20–60 dk):**
```
vivado -mode batch -source b_yolu/vivado_olustur.tcl -tclargs 4
vivado -mode batch -source b_yolu/vivado_olustur.tcl -tclargs 4 ../uygulama/drone_sim/kontrolcu_l3.hex
```
CLA programı bitstream'e gömülür (L3 başlangıç değeri). Varsayılan `ic_kestirim_l3.hex` (ick);
başka mimari için ikinci argüman (`l3_uret.py --mimari ic|tek` çıktısı). Program değişince bitstream yeniden üretilir.
Çıktı `b_yolu/cikti/`: `kv260_b.bit`, `psu_init.tcl`, `kv260_b.xsa`, `rapor.txt` (WNS ≥ 0 olmalı).
KV260 kart dosyaları yoksa betik kurmayı dener (internet gerekir); olmazsa Vivado → Tools →
Vivado Store → Boards → "Kria KV260".

**2. Kartı bağla:** 12 V adaptör + micro-USB. Sanal makinede USB aygıtını ("FTDI Quad
RS232-HS" / "Xilinx KV260") sanal makineye verin.

**3. Yükle (sanal makine, ~1 dk):**
```
xsdb b_yolu/karta_yukle.tcl
```
`xsdb` Vitis ile gelir (`<kurulum>/Vitis/<sürüm>/bin/xsdb`); yoksa `xsct` aynı betiği çalıştırır.
Betik: önyükleme kipini JTAG'a alır → bitstream → `psu_init` (saatler, UART, PL saati/reseti)
→ `aktarici.elf`'i A53'e yükleyip başlatır.

**4. USB'yi Mac'e geri verin** (sanal makinenin USB menüsünden "bağlantıyı kes"). Kart 12 V'tan
beslendiği için aktarıcı çalışmaya devam eder. (Kart sıfırlanırsa 3. adımı tekrarlayın.)

**5. Göz kontrolü:** `screen /dev/cu.usbserial-XXXX 921600` → yükleme sonrası
"CLA aktarici hazir" görünür (çıkış: Ctrl-A, K). Sonraki adımdan önce kapatın.

**6. Kart ↔ golden (Mac):** bitstream'deki programla aynı mimari seçilir: ick (varsayılan) için
`--sensor gercek`, ic için `--sensor ideal`.
```
cd ../uygulama/drone_sim && .venv/bin/python sim.py --kontrolcu ikisi --port auto
```
Drone'u FPGA sürer; aynı girdiler golden'a da gider. Her adımda çıktılar bit bit ve CLA çevrim sayısı
karşılaştırılır (çevrim: ilk getirmeden boru hattı boşalana kadar, golden'la aynı tanım).

## Sorun giderme

| Belirti | Olası neden |
|---|---|
| `sim.py --port auto`: "KV260 bulunamadı" | aktarıcı çalışmıyor (3. adım), USB hâlâ sanal makinede, `screen` portu tutuyor |
| `screen`'de "HATA: PL kopru bulunamadi" | bitstream yüklenmedi ya da adres 0x8000_0000 değil (`rapor.txt`'ten önce Vivado günlüğündeki "adres:" satırı) |
| `screen`'de hiçbir şey yok | aktarıcı başka UART'ta olabilir: `xsdb b_yolu/karta_yukle.tcl uart0` |
| Karakterler bozuk | PS UART referans saati 100 MHz değil (Vivado günlüğünde `UART1_REF_CTRL__ACT_FREQMHZ`) |
| `xsdb`: PSU hedefi yok | JTAG zincirinde kart görünmüyor: USB sanal makinede mi, `targets` çıktısı |
| Gidiş-dönüş > 2 ms | macOS FTDI sürücüsünün gecikmesi; simülasyon ağır çekimde doğru çalışır, ya da `--ic-hz 250` |

## Dosyalar

| Dosya | İçerik |
|---|---|
| `vivado_olustur.tcl` | proje + blok tasarım (Zynq MPSoC, SmartConnect, köprü) + bitstream + xsa, arayüzsüz |
| `karta_yukle.tcl` | xsdb: JTAG önyükleme, bitstream, psu_init, aktarıcıyı başlat |
| `aktarici/` | A53 çıplak aktarıcı: `aktarici.c`, `baslat.S`, `bellek.ld` (OCM), `Makefile`; hazır `aktarici.elf` (UART1), `aktarici_uart0.elf` (yedek); `qemu_dene.py` |
| `../rtl/cla_axi_kopru.sv` | AXI4-Lite kapı (VERI/CEVAP/DURUM/KİMLİK) + cevap FIFO'su + çekirdek |
| `../rtl/kv260_b_top.sv`, `../rtl/kv260_b_sarmal.v` | B üst modülü ve blok tasarım için Verilog sarmal |
| `../rtl/cla_kopru_cekirdek.sv` | paket çözme, mesaj RAM'leri, görev 1'i koşturma (MIRUN + boru hattı boşalması) |
| `../tb/tb_kopru_cla.sv`, `../tb/kopru_testi.py` | köprü + CLA_Top tezgâhı ve golden karşılaştırması |
