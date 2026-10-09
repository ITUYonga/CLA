# CLA Projesi

TI TMS320F2803x CLA (Type-0) çekirdeğinin KV260 FPGA için RTL tasarımı, Python golden modeli ve doğrulama ortamı.

## Klasörler

```
CLA_Proje/
├── rtl/
│   ├── top/            Üst modül ve boru hattı aşamaları (CLA_Top, F1 F2 D1 D2 R1 R2 E W, Gorev_Yazmaclari)
│   ├── alu/            ALU (tamsayı, FPU toplama/çarpma, karşılaştırma, dönüşüm, kestirim) + estimate_lut.hex
│   ├── kontrol/        Kontrol birimi: cla_pkg, cla_decoder, cla_ctrl_gen, cla_gorev_denetci
│   └── yazmac_bellek/  Yazmaçlar ve veri RAM'i: cla_data_ram, cla_mvect_regs, cla_mr/mar/mstf, cla_ctrl_regs
├── golden_model/       Python golden model (ISA tablosu, boru hattı modeli, assembler, lint, iz araçları)
├── dogrulama/
│   ├── cla_top/        CLA_Top ve Execute/Write tezgâhları, golden karşılaştırma betikleri (README içinde)
│   ├── golden_paket/   Kabul paketi üreticisi, 23 boru hattı kural programı ve beklenen çıktılar, alu_kabul_1
│   ├── alu_vivado/     ALU vektör testi (289.648 vektör) ve Vivado sentez/zamanlama betiği
│   └── README_ALU.md   ALU teslim notları
├── fpga_kopru/         KV260 AXI/UART köprüsü (rtl/) ve Vivado blok tasarım betikleri (b_yolu/)
├── uygulama/drone_sim/ CLA üzerinde koşan drone kontrolcüsü ve sanal FPGA simülasyonu
├── belgeler/           Tasarım belgeleri (.docx) ve boru hattı/ALU rehber sayfaları (.html)
└── semalar/            draw.io şemaları ve PNG/PDF çıktıları (üst modül FF'leri, E/W, aşama aşama)
```

## Modül sahipleri

| Bölüm | Sorumlu |
|---|---|
| `rtl/alu/`, `golden_model/`, `rtl/top/Execute.sv`, `rtl/top/Write.sv` | Oğuzhan |
| `rtl/kontrol/` | Ahmet |
| `rtl/yazmac_bellek/` | Arda |
| `rtl/top/` (diğer aşamalar ve CLA_Top) | ekip |

## Üst modül

`rtl/top/CLA_Top.sv`, 8 aşamalı boru hattını (F1 F2 D1 D2 R1 R2 E W), görev denetimini, MAR/MPC'yi ve L1/L2 veri RAM'lerini birleştirir.
Mesaj RAM'leri (M2C, C2M) dışarıda durur; portları `fpga_kopru/rtl/cla_kopru_cekirdek.sv` ile uyumludur.

Vivado projesine eklenecekler:
- `rtl/kontrol/cla_pkg.sv` (önce), `rtl/kontrol/*.sv`
- `rtl/yazmac_bellek/cla_data_ram.sv`, `cla_mvect_regs.sv`
- `rtl/alu/` altındaki bütün `.sv` dosyaları ve **`rtl/alu/estimate_lut.hex`** (kestirme.sv `$readmemh` ile okur)
- `rtl/top/*.sv`

## Doğrulama durumu

Golden model referans alınarak (çevrim çevrim iz + son bellek + son yazmaçlar):

| Test | Sonuç |
|---|---|
| Golden kabul paketi (23 kural programı + alu_kabul_1) | 24/24 aynı |
| Yönlü testler (görev geçişinde dur_exe, 3 görev, geçersiz buyruk) | 12/12 aynı |
| Rastgele programlar (MAR kipleri, dallar, çağrı, dur_r1, 1-3 görev, geçersiz buyruk) | 17.500 program, 0 fark |
| Execute/Write birim testleri | 22.500 vektör, 300 program, 19 kenar kontrolü: 0 hata |
| ALU vektör testi | 289.648 vektör |

Çalıştırma: `dogrulama/cla_top/README.md`.

## Açık işler

- **Golden:** dur_r1 çevriminde `Pipeline.d2_mar` önceki çevrimden kalıyor ve E'deki MAR yüklemesi atlanıyor (RTL TI'a uygun davranıyor). Öneri: `update_pipeline` içinde D2 çağrısından önce `self.d2_mar = None`.
- **ALU:** `clasify.sv` ve `topla_k2.sv` latch uyarıları.
- **FPGA:** `fpga_kopru/rtl/kv260_b_top.sv` içinde `cla_cekirdek_taklidi` ve `cla_ctrl_regs_yamali` yerine `CLA_Top` bağlanacak.
