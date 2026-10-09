# CLA "conflict" durumları — TRM ekran görüntüleri

Kaynak: **SPRUI10A, Bölüm 10 (CLA)** — `Texas Instrument CLA.pdf`, PDF sayfası = basılı sayfa.
Her satır: görüntü → TRM ne diyor → golden modelde / lint'te karşılığı.
(Lint kuralları: `golden_model/lint.py`; model kararları: `docs/model_kararlari.md`.)

## Çakışma ve boru hattı kuralları

| # | TRM | ne diyor | modelde / lint'te |
|---|---|---|---|
| 01 | s.577 | 8 kademe; D2'de adres üretimi, MAR post-increment, dallanma kararı; EXE'de MAR yüklemesi; bellek çakışmasında **R1 ve W durur** | kademeler modelde birebir; R1/W durağı modellenmiyor (kapsam kararı) |
| 02 | s.578 | Yazma-sonrası-okuma: okuma yazmadan önce olur, CLA'da donanım koruması **yok**, kod beklemeli (Tablo 10-1, 10-2) | lint kural B (araya en az 3 komut) |
| 03 | s.579 | Dallanma: I1 bayrağı etkileyen son komut; I2–I4 ve I5–I7 MSTOP/dal olamaz; I5–I7 **her zaman** çalışır (Örnek 10-1) | lint kural A + A' (bayrak uyarısı); boru hattında karar D2'de, 3 gecikme yuvası |
| 04 | s.579 | MSTOP/MDEBUGSTOP dallanmanın 3 komut öncesine/sonrasına konamaz | lint kural A |
| 05 | s.580 | MAR yükleme: I1–I2 eski değer, **I3 kullanamaz** (çakışmada post-increment kazanır, yükleme kaybolur), I4'ten itibaren yeni (Örnek 10-2) | lint kural C; boru hattında `d2_mar` (adım 4) |
| 06 | s.662 | Tablo 10-16: MMOVI16 EXE'deyken I3 D2'de — çakışmanın zamanlaması | ↑ |
| 07 | s.600 | MBCNDD: koşul tablosu (NEQ…UNCF), ofset, 3 komut kısıtı | `kosul_saglandi`; hedef = dal adresi + 2 + ofset |
| 08 | s.602 | Tablo 10-10/10-11: dallanma D2'den sonra balon (R1 sütunu "-") | dal kaydı D2'de geçersiz kılınıyor (adım 2) |
| 09 | s.607 | Tablo 10-12/10-13: MCCNDD; dipnot: RPC, I7'den sonraki komutu gösterir | RPC = pc + 8, D2'de yazılıyor |
| 10 | s.685 | Tablo 10-17/10-18: MRCNDD | getirme sayacı = RPC |
| 11 | s.687 | **MSTOP D2'ye girince** MIRUN temizlenir, PIE'ye kesme gider; dallanma kısıtı | adım 3 |
| 12 | s.688 | Tablo 10-19: MSTOP + arkasındaki 3 komut boşaltılır; önündekiler biter; yeni görev 2 çevrim hakemlenip F1'e girer | adım 3; görev sınırında model 1 çevrim geç (§36.3) |
| 13 | s.576 | Geçersiz opcode: **D2'de durur**, PIE'ye kesme, **MIRUN set kalır**, yalnız reset çıkarır | adım 5 + 5.5 (kalıcı donma) |
| 14 | s.575 | MDEBUGSTOP: kesme noktası kapalıyken **MNOP**; açıkken D2'de durur, boru donar, MPC onu gösterir | adım 1; hata ayıklama modu kapsam dışı |
| 15 | s.571 | CPU↔CLA hakemliği: mesaj RAM'lerinin izinleri ve öncelikleri | izinler modelde (yok sayılan yazma); öncelik/durak yok |
| 16 | s.572–573 | Program RAM, veri RAM (MMEMCFG) öncelikleri; çevre birimi kuralları | ↑ |
| 17 | s.573 | Çevre birimi: *"A CLA write operation has priority over a CLA read operation"* | CLA'nın kendi W'si ile R1'i aynı çevrimde çakışabilir mi — TRM tablo vermiyor (açık) |
| 18 | s.569 | CLA veri okuma/yazma yolları çakışmada **otomatik durur** | R1/W durağı (kapsam kararı) |

## MPC (program sayacı) — getirme sayacı ayrı

| # | TRM | ne diyor | modelde |
|---|---|---|---|
| 20 | s.717 | **MPC, D2'deki komutu gösterir**; görev başında MVECTx; MSTOP'tan sonra MSTOP'ta kalır; CPU yalnız okur | `state.mpc` D2'ye giren komutla yazılıyor (model_kararlari §41) |
| 21 | s.577 | F1: *"program read address is placed on the CLA program address bus"* → getirme adresi MPC değil, ayrı iç sayaç | `Pipeline.getir_pc` |
| 22 | s.600 | "MPC += 16BitDest" ve MPC = D2'deki komut (s.717) → hedef tabanı **dalın kendi adresi**. Aynı sayfadaki "0xFFFE dallanmanın kendisine döndürür" cümlesi TRM hatası: TI cl2000 çıktısındaki 6/6 dallanma "hedef − dal adresi" kodlanmış (ör. 0x72 → 0x8A: 0x0018). | `pc + dest` (25.09'da düzeltildi, model_kararlari §47.1; eskiden `pc + 2 + dest` idi — 80/80 kontrolü etiketli dallanmaları kapsamıyordu) |
| 23 | s.717 | MSTF: RPC bit 23:12, bayraklar | `RPC_SHIFT = 12` |
