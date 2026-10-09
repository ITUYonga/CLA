# CLA Type-0 Golden Model — Notlar

TI TMS320F2803x CLA'nın Python altın modeli (ISS). Referans: SPRUI10A,
Bölüm 10 (s.565–720). Amaç: **RTL == model == TRM**, bit ve çevrim düzeyinde.
Kod: `golden_model/` (bu reponun kökünde).

## Bu klasör

| Dosya | İçerik |
|---|---|
| `01_kapsam_kararlari.md` | Neyin modellendiği, neyin bilerek dışarıda kaldığı. RTL eşdeğerliğini etkileyenler **KRİTİK** işaretli. |
| `02_borclar.md` | Açık borçlar: donanım olmadan kapanamayanlar, denetimde bulunup düzeltilmeyenler, son üç alanın bulguları. |
| `03_varsayimlar.md` | TRM'in açıkça söylemediği yerlerde modelin seçtiği davranışlar. |
| `04_rtl_sartlari.md` | Verilog RTL'in modelle eşdeğer olması için uyması gerekenler. |

Kararların gerekçeli, tarihli kaydı: `docs/model_kararlari.md`
(§1–§51). İz biçimi sözleşmesi: `docs/trace_format.md`.
TRM ekran görüntüleri (çakışma durumları, MPC): `conflicts/`.

## Durum (2026-10-05)

- **FPU K1/K2, interlock, R1/W durması ve D2 kuralı uygulandı** (M1–M5, §50–§51).
  Model ALU RTL'i ve top modül için çevrim çevrim referans. Boru hattı
  regresyon testi: `tests/test_boru_hatti.py`.

## Durum (2026-09-25)

- Test takımı: **1826 passed, 0 xfail** (`tests/` ve `tools/` aynı kökte olmalı; `tests/` bu repoda yok).
- İki yürütme modeli: **boru hattı modeli altın referanstır** (8 kademe, iz
  ondan üretilir). Ardışık model hızlı birim testleri içindir; gecikme yuvası
  yoktur (bkz. 01, K2).
- TRM denetimi (2026-09-25), sekiz alanın hepsi: komut kodlamaları, kayan
  nokta, dönüşüm/tamsayı, bellek/adresleme, dallanma/kontrol (Tablo
  10-10…10-19 çevrim çevrim dahil), boru hattı, hakem ve yazmaçlar,
  araçlar/lint/iz. Bulunan **3 kritik hata düzeltildi**:
  1. Dallanma ofsetinin tabanı dalın kendi adresi (TI cl2000 ile doğrulandı).
  2. İşaretsiz dönüşümlerde negatif girdi → 0 (TRM s.623–625 örnekleri).
  3. MMOVF32/MMOVI32 alt 16 bit sıfırsa tek komut (TRM s.660/663).
  Orta/düşük bulgular `02_borclar.md`'de.

## RTL'e giden dosyalar

| Dosya | Ne | Üreten |
|---|---|---|
| program `.hex` | 16/32-bit komut görüntüsü, LSW alt adreste | `tools/casm2hex.py` |
| `isa/estimate_lut.hex` | MEINVF32/MEISQRTF32 tablosu (768 × 8 bit) | `tools/lut_uret.py` |
| `*.trace` | çevrim başına iz (format v1) | `golden_model/trace.py` |
| karşılaştırma | 0 aynı / 1 ayrışma / 2 karşılaştırılamadı | `tools/compare_trace.py` |
