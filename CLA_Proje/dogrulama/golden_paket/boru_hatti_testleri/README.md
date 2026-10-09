# Boru hattı test paketi

Top modülün boru hattı kurallarını (23 program) (FPU K1/K2, `dur_exe`, `dur_r1`, D2 kuralı,
dallar, bellek) tek tek deneyen küçük CASM programları ve golden modelin
beklenen çıktıları. Kurallar ve şekiller: "CLA Boru Hattı Kuralları" sayfası.

## Nasıl kullanılır

1. Programın bellek görüntülerini RTL'e yükleyin: `beklenen/<ad>_L3.hex`
   (ve varsa `_L1.hex`, `_L2.hex`, `_M2C.hex`, `_C2M.hex`). Satır başına
   16 bit, alt adres önce; `$readmemh` ile okunur.
2. MVECT ve MIER'i `beklenen/<ad>_yazmac_baslangic.txt`'ten alın, görevi
   MIFRC ile tetikleyin.
3. RTL test tezgâhı her saat kenarında iz satırı bassın (`docs/trace_format.md`
   v1). Durma satırları için: `dur_exe` çevriminde EXE sütunu **EXE'de bekleyen**
   komut (iki satır aynı), `mpc` = D2'deki komut.
4. Karşılaştırın:
   ```
   python3.11 ../../../golden_model/tools/compare_trace.py beklenen/<ad>_golden.trace rtl_<ad>.trace
   ```
   `AYRISMA YOK` ve çıkış kodu 0 beklenir. Ayrıca son bellek ve yazmaçlar
   `beklenen/<ad>_beklenen_*.hex|txt` ile aynı olmalı.

Beklenen dosyaları yeniden üretmek (golden değişirse):
```
python3.11 ../golden_beklenen.py <ad>.casm -o beklenen
```
`19_yaz_oku_eski_deger` bilerek lint hatası içerir: `--zorla` ile üretilir.
`16` ve `18` lint `S5.2-bayrak` uyarısı verir; bu beklenen.

## Programlar

`dur_exe` sütunu: izde EXE'deki komutun bir sonraki satırda tekrar ettiği
(bekleyen) çevrimler.

| Program | Neyi deniyor | Görev çevrimi | `dur_exe` satırı |
|---|---|---|---|
| `01_k2_sonuc_w_satirinda` | FP sonucu W'nin sonunda yazilir (K2): MMPYF32'nin EXE satirinda MR0 eski, bir sonraki (W) satirda 6.0. | görev 1: 16 | – |
| `02_k2_exe_yazmasi_kazanir` | Ayni cevrimde EXE'nin MR yazmasi K2'yi yener: MR2 = bellekteki 5.0 (3.0 degil). | görev 1: 17 | – |
| `03_k2_mmacf32_toplama_kazanir` | MMACF32'de MRd = MR3: toplayici carpiciyi yener, MR3 = 5.0; MRa (MR2) EXE'de yuklenir. | görev 1: 18 | – |
| `04_k2_paralel_yukleme` | MMPYF32 ‖ MMOV32: yukleme (MR3) EXE'de, carpim (MR0) bir cevrim sonra W'de. | görev 1: 16 | – |
| `05_k2_bekleyen_lvf_dala_gorunur` | Tasan carpim + 3 MNOP + MBCNDD LV: dal ALINIR (bekleyen LVF gorunur). | görev 1: 19 | – |
| `06_k2_msetflg_kazanir` | Tasan carpimdan hemen sonra MSETFLG LVF=0: son LVF = 0 (EXE bayrakta da kazanir). | görev 1: 16 | – |
| `07_k2_kestirim_bayragi_exe` | MEINVF32 kombinasyonel: LVF EXE satirinda kurulur, K2'ye ertelenmez. | görev 1: 15 | – |
| `08_dur_exe_okuyan_bekler` | MMPYF32 MR0 -> MADDF32 MR3, MR0, MR1: 1 cevrim dur_exe (18 cevrim, MR3 = 8.0). | görev 1: 18 | 13 |
| `09_dur_exe_yazan_beklemez` | Yalniz yazan MMOV32 MR0 beklemez; MR3'u okuyan saklama bekler (20 cevrim). | görev 1: 20 | 15 |
| `10_dur_r1_ayni_blok` | L1'e yaz, 3 sonra L1'in BASKA adresinden oku: 1 cevrim dur_r1 (19 cevrim). | görev 1: 19 | – |
| `11_dur_r1_farkli_blok` | L1'e yaz, L2'den oku: durma YOK (18 cevrim). | görev 1: 18 | – |
| `12_dur_r1_zincir` | Ayni bloga art arda 2 saklama + okuma: 2 cevrim zincirleme dur_r1 (20 cevrim). | görev 1: 20 | – |
| `13_dur_r1_mesaj_ram` | CLA->CPU mesaj RAM'ine yaz / CPU->CLA'dan oku: durma yok; CLA->CPU'dan oku: durma var (26 cevrim). | görev 1: 26 | – |
| `14_dur_r1_16_bit` | MMOV16 ile L2'ye yaz, MMOVZ16 ile L2'den oku: 1 cevrim dur_r1 (19 cevrim). | görev 1: 19 | – |
| `15_d2_mar_bir_kez` | dur_r1 sirasinda D2'de *MAR0[2]++: MAR0 bir kez artar (8810 -> 8812), ilerledigi cevrimde. | görev 1: 21 | – |
| `16_d2_dal_bir_kez` | dur_r1 sirasinda D2'de MBCNDD: karar bir kez, 3 gecikme yuvasi calisir. (lint S5.2 uyarisi beklenir) | görev 1: 20 | – |
| `17_dal_3_gecikme_yuvasi` | MBCNDD UNC: arkasindaki 3 komut her zaman calisir, 4.'su atlanir. | görev 1: 15 | – |
| `18_dal_onceki_3_bayrak_yetismez` | Daldan 3 once MCMPF32: dal bu bayragi GORMEZ (eski ZF ile karar). (lint S5.2 uyarisi beklenir) | görev 1: 19 | – |
| `19_yaz_oku_eski_deger` | Yazdiktan 2 komut sonra ayni adresi okumak ESKI degeri verir (Tablo 10-1). --zorla gerekir (lint HATA). | görev 1: 17 | – |
| `20_gorev_sonu_fp` | Gorev 1'in MSTOP'tan hemen onceki FP sonucu gorev 2'de gorunur (K2 tamamlanir). | görev 1: 11 / görev 2: 13 | – |
| `21_mswapf` | MSWAPF iki MR'yi ayni kenarda takas eder (EXE'de iki yazma). | görev 1: 16 | – |
| `22_birikim` | MADDF32 MR0, MR0, MR1: K2 sonucu birikimde dogru. | görev 1: 16 | – |
| `23_kosullu_yukleme_mar_artar` | Koşul tutmayan MMOV32 MR0, *MAR0[2]++, EQ: MR0 yüklenmez ama MAR0 yine artar (8810 → 8812); artış D2'de, koşuldan bağımsız. | görev 1: 19 | – |
