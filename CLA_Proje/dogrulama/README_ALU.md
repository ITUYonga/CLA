# ALU teslim paketi

RTL: `../rtl/alu/`, golden model: `../golden_model/`.

Top modül ve kontrol birimi için iki sayfa:

- Kontrol birimi için: ALU kontrol girişleri, buyruk başına değerler, okunan MR maskesi (ALU Kontrol Birimi Rehberi):
  https://claude.ai/artifact/RaqGXr3sRUTaZSuq5aYbUK (yerel kopyası `ALU_kontrol_birimi.html`).
- Top modül için: ALU portları ve ALU'nun boru hattı durumları (ALU Top Modül Rehberi):
  https://claude.ai/artifact/KyZNBHMpQv5zXqZARTXUSu (yerel kopyası `ALU_top_modul.html`).
- Bütün boru hattı kuralları (ALU dışı dahil); şemalar ve "uygulanmazsa" örnekleri (CLA Boru Hattı Kuralları):
  https://claude.ai/artifact/2gSrWkVvfNAcPjBAdbnpwV (yerel kopyası `CLA_boru_hatti_kurallari.html`).

Linkler şu an yalnız sana açık. Takıma sayfaların Share menüsünden paylaşman gerekiyor.

## 1. Vivado: ALU ↔ golden vektör testi (`alu_vivado/`)

| Dosya | Ne |
|---|---|
| `alu_vektor_tb.sv` | Kendini denetleyen testbench (`module alu_vektor_tb`) |
| `alu_vektorler.txt` | 289.648 golden vektörü (`op A B c1 c2 sonuc bayrak maske`, onaltılık) |
| `vektor_uret.py`, `gm_alu.py` | Vektörleri golden'dan yeniden üretir |
| `alu_zamanlama_sarmalayici.sv` | Zamanlama ölçümü için girişleri ve çıkışları yazmaçlı sarmalayıcı |
| `alu_sentez_kontrol.tcl` | Latch, kaynak ve zamanlama raporu (batch). Vivado olmadığı için bu Mac'te denenmedi |

### GUI ile
1. Design sources: `rtl/alu/` altındaki 17 `.sv` ve `rtl/alu/estimate_lut.hex`.
2. Simulation sources: `alu_vektor_tb.sv`, `alu_vektorler.txt` ve yine `estimate_lut.hex`. Top: `alu_vektor_tb`.
3. Run Behavioral Simulation → `run all`. Tcl konsolunda şu satır görünmeli: `ALU_TB SONUC: 289648 vektor, 0 hata -> GECTI`.
4. Run Synthesis → Run Post-Synthesis Functional Simulation (aynı testbench). Yine `0 hata` beklenir.
5. Sentez sonrası Messages'ta `latch` uyarısı olmamalı (bkz. "Açık işler").

### Batch
```
vivado -mode batch -source alu_sentez_kontrol.tcl -tclargs <CLA_Proje_klasoru> <part> <periyot_ns>
```
Örnek part ve periyot: `xc7a35tcpg236-1 20`. Çıktılar `alu_sentez/` altına yazılır. Satırlar:
- `ALU_DENETIM latch sayisi: 0`
- `WNS >= 0`

`alu_sentez_funcsim.v` sentez sonrası netlisttir. `alu_vektor_tb.sv` ile koşulur.

### Vektörleri yeniden üretmek
Python 3.10+ ve PyYAML gerekir.
```
PYTHONDONTWRITEBYTECODE=1 python3.11 vektor_uret.py alu_vektorler.txt
```
Golden'ın yeri `../../golden_model` varsayılır. Başka yerdeyse `CLA_GOLDEN=/yol` verin.

## 2. Golden kabul paketi (`golden_paket/`)
```
PYTHONDONTWRITEBYTECODE=1 python3.11 golden_beklenen.py ornekler/alu_kabul_1.casm -o cikti
```
- Üretilen bellek görüntüleri `$readmemh` ile okunur: `L3/L1/L2/M2C/C2M.hex`. Satır başına 16 bit, alt adres önce.
- Ayrıca `yazmac_baslangic.txt` üretilir.
- Görev sonunda beklenen değerler: `beklenen_L1/L2/C2M.hex` ve `beklenen_yazmac.txt`.
- `golden.trace` çevrim izidir. Golden FPU K1/K2'yi, `dur_exe`, `dur_r1` ve D2 kuralını uyguluyor (05.10, `model_kararlari.md` §51); iz RTL iziyle çevrim çevrim karşılaştırılır:
  ```
  python3.11 ../../golden_model/tools/compare_trace.py cikti/<ad>_golden.trace rtl_<ad>.trace
  ```
- Lint hatası varsa çıkış kodu 1 olur; program kabul testinde kullanılmaz (bilerek deniyorsanız `--zorla`). `S5.2-bayrak` ve `S5.3-mar` yalnız uyarıdır: golden ile RTL aynı sonucu verir ama program bellek durmasına bağlıdır.
- `ornek_cikti/` örnek programın çıktısıdır (`alu_kabul_1`: 122 çevrim).

## 3. Boru hattı test paketi (`golden_paket/boru_hatti_testleri/`)

Her boru hattı kuralı için bir program (23 program) ve beklenen çıktılar (`beklenen/`). Ayrıntı ve tablo: o klasördeki `README.md`. Top modülün RTL simülasyonunda hepsi `compare_trace.py` ile `AYRISMA YOK` vermeli.

## Açık işler (ALU)
- `clasify.sv`: `ozel_durumlar` için varsayılan atama yok.
- `topla_k2.sv`: `ara_deger_top` ve `ara_deger_cik` yalnız bir dalda atanıyor.

Vivado latch uyarısı verirse `always_comb` başına varsayılan atama ekleyin. Sonra vektör testini yeniden koşun.
