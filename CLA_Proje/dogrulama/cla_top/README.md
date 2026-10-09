# CLA_Top doğrulaması

Bütün testler golden modeli (`../../golden_model`) referans alır. Gerekenler: Verilator 5.x, Python 3.10+ ve PyYAML.
Komutlar bu klasörden çalıştırılır; `PYTHONDONTWRITEBYTECODE=1` önerilir.

## Dosyalar

| Dosya | Ne |
|---|---|
| `tb_cla_top.sv` | CLA_Top tezgâhı: paket dosyalarını yükler, görevleri CPU portundan tetikler, golden iz biçiminde (v1) iz basar, sonda bellek ve yazmaçları döker |
| `derle_top.sh` | CLA_Top tezgâhını derler (`../../rtl` altındaki dosyalar) |
| `paket_kos.py` | `../golden_paket` içindeki 24 programı koşturur, iz/bellek/yazmaç karşılaştırır |
| `yonlu_top.py` | Yönlü testler: görev geçişinde dur_exe, ard arda görevler, geçersiz buyrukta donma |
| `rastgele_top.py` | Rastgele program üretir (lint temiz), golden boru hattında ve RTL'de koşturup karşılaştırır |
| `top_ortak.py` | Ortak: kodlama, golden koşusu, paket dosyaları, karşılaştırma |
| `tb_ew.sv` + `anlam_testi.py` | Execute + Write tek buyruk anlam testi |
| `tb_bh.sv` + `bh_testi.py` | Execute + Write art arda buyruk testi |
| `tb_kenar.sv` | Execute + Write kenar durumları |
| `derle_birim.sh` | Execute + Write tezgâhlarını derler |
| `lint_top.sh` | Bütün tasarım için `verilator --lint-only -Wall` |

## Çalıştırma

```bash
./derle_top.sh tb_cla_top.sv tb_top          # obj_tb_top/tb_top
python3 -B paket_kos.py                       # golden paketi: "program: 24  hatali: 0"
mkdir -p yonlu && python3 -B yonlu_top.py     # "senaryo: 12  hatali: 0"
mkdir -p rastgele && python3 -B rastgele_top.py 500 1   # 500 program, tohum 1

./derle_birim.sh tb_kenar.sv obj_kenar && ./obj_kenar/tb_kenar
./derle_birim.sh tb_ew.sv obj_dir && python3 -B anlam_testi.py uret 2000 && ./obj_dir/tb_ew && python3 -B anlam_testi.py karsilastir
./derle_birim.sh tb_bh.sv obj_bh && python3 -B bh_testi.py uret 300 100 && ./obj_bh/tb_bh && python3 -B bh_testi.py karsilastir
```

Golden başka bir yerdeyse `CLA_GOLDEN=/yol`, başka bir Python kullanılacaksa `PY=/yol/python` verin.
Hatalı rastgele programın dosyalarını saklamak için `SAKLA=1`, golden hatasında programı dökmek için `AYIKLA=1`.

## Bilinen golden farkı

dur_r1 çevriminde E'deki MAR yüklemesi golden'da atlanabiliyor (bayat `d2_mar`); RTL TI kuralına göre yükler.
Program lint'ten yalnız S5.3 uyarısıyla geçer. Ayrıntı: `../../README.md`, "Açık işler".
