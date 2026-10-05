# ALU ve boru hattı belgeleri

Tarayıcıda açın (çift tık). Sayfalar birbirine bağlantılıdır.

| Sayfa | Kimin için | İçerik |
|---|---|---|
| [`ALU_kontrol_birimi.html`](ALU_kontrol_birimi.html) | Kontrol birimi | ALU'nun 17 kontrol girişinin kodları, 49 ALU buyruğunun tam kontrol değerleri, işlenen yerleşimi, interlock için okunan MR maskesi |
| [`ALU_top_modul.html`](ALU_top_modul.html) | Top modül | ALU portları ve zamanlamaları; ALU'nun boru hattında yarattığı 7 durum (dur_exe, yazma önceliği, bekleyen bayraklar…) şemalarla, uygulanmazsa örnekleri ve RTL taslağı |
| [`CLA_boru_hatti_kurallari.html`](CLA_boru_hatti_kurallari.html) | Top modül | Boru hattının 13 kuralının tamamı (ALU dışı dahil: R1/W durması, D2 kuralı, dallar, bellek, görev sonu) |

Şemalar ve değerler `CLA_GoldenModel`'in (M2–M5 uygulanmış hâli) gerçek çıktısından üretildi.
Kurallar golden'da: `CLA_GoldenModel/docs/model_kararlari.md` §51, `golden_model_notlari/04_rtl_sartlari.md`.
