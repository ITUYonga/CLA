# Açık borçlar

## A. Donanım (ya da TI aracı) olmadan kapanamayanlar

Model bir seçim yaptı; TI silikonunda doğrulanması gerekiyor.
Numaralar `model_kararlari.md` §11 tablosundaki numaralar.

| # | Konu | Modelin seçimi |
|---|---|---|
| 1.3.2 | Aritmetik girdilerde denormal | Yazmaçtan gelen denormal tam değerle, `#16FHi` sabitindeki denormal +0 olarak kullanılıyor — **iki yol tutarsız** (B2). |
| 3.12 | MNEGF32'de sinyalli NaN'ın işaret biti | Saf işaret biti işlemi. |
| 3.19 | float→tamsayı **pozitif** taşma | Sonlu değerler sarılıyor, ±Inf doyuruluyor. Negatif→işaretsiz 0 (TRM örnekleri, §47.2). |
| 3.20 | float→tamsayı NaN / ±Inf | NaN → 0; ±Inf → uç değerler. |
| 3b.4 | Koşul yanlışken post-increment | **İki model ayrışıyor** (B1). |
| 6.1 | Kestirim tablosunun TI ile eşitliği | Proje tablosu (§42). |
| 10.6 | Tek komut içinde D2 önce, E sonra | Model sırası: D2 E'den önce. |
| 11.1 | Ayrılmış adresleme kipi + yanlış koşul | Ardışık modelde sessiz geçiyor, koşul doğruysa hata. |
| 27.1 | Yazma görünürlüğünde I3/I4 | Tablo 10-1/10-2 ile tutarlı; TRM ara durumu söylemiyor. |
| 42.7 | MMPYF32'de ∞ × 0 | NaN (kullanıcı kararı). TRM s.617 örneğindeki işaret düzeltmesi donanımda ±∞ olabileceğini ima ediyor. |

## B. Denetimde bulunan, düzeltilmeyen (orta)

| # | Bulgu | Not |
|---|---|---|
| B1 | Koşulu yanlış `MMOV32 MRa, *MARx[k]++, CNDF`: boru hattı MAR'ı artırıyor (adres D2'de üretiliyor, s.577), ardışık model artırmıyor. | Boru hattının davranışı TRM'e daha yakın. İz boru hattından geldiği için RTL karşılaştırmasını etkilemez; ardışık modelle karşılaştırmada ayrışır. |
| B2 | Aynı denormal değer sabit (`#16FHi`) ve yazmaç olarak farklı sonuç veriyor (ör. MSUBF32: LUF 0 / 1). | Borç 1.3.2; tek kural seçilmeli. |
| B3 | `MMOV16 *MARx[k]++, MARx` (aynı MAR hem adres hem veri): ardışık model artmış değeri, boru hattı eski değeri saklıyor. | TRM sessiz. |
| B4 | RZ modunda LVF eşiği en-yakına-yuvarlamanın taşma noktası: ±MAX'a kesilen bazı sonuçlarda LVF=1, IEEE-RZ'de 0 olurdu. | §3.3/§3.5 "IEEE ile uyumlu" diyor — bu sınırda değil. |
| B5 | Sıfır sonucun işareti: tam sıfır sonuçlar +0, alt taşmayla sıfıra yuvarlananlar −0 olabiliyor. | Bayraklar etkilenmiyor; bit düzeyinde tek kural gerekli. |
| B6 | MMAXF32/MMINF32 −0'ı +0 yazıyor (TRM'in çıktı listesinde −0 yok). | Donanım "üs 0 → +0" yapıyorsa model doğru. |
| B7 | `MMOV32 MSTF, mem32` MCCNDD'den 1–2 komut önceyse boru hattında RPC'nin üstüne yazıyor; `MMOV32 mem32, MSTF` 1–3 komut önceyse yeni RPC'yi saklıyor. | TRM sessiz; RTL farklı sıralarsa ayrışır. RPC'yi dallanmadan en az 4 komut önce kaydedin/yükleyin. |
| B8 | Kısıt ihlali (ör. paralel komutta MRa == MRd) hata fırlattıktan sonra iki modelin MAR durumu farklı. | Yalnız hata yolunda. |

## C. Denetimde bulunan, düzeltilmeyen (düşük)

- **Assembler:**
  - `*MARx[#n]++` (TRM yazımı), `#sembol` sabitleri, iki noktasız etiketler, ters sıralı paralel çift (`MADDF32 … || MMPYF32 …`), satır sonunda `||`, küçük harfli `*mar0` kabul edilmiyor.
  - `MMOVF32 …, #0x40400000` ve `MMOVI32 …, #3.0` kabul ediliyor; TRM bunlara hata diyor (s.660/663).
  - `#16FLoHex` yuvasında float sabit üst 16 biti alıyor; aralık dışı sabitler 16 bite sessizce kırpılıyor; `#1e40` OverflowError ile çöküyor.
  - Hepsi ya hata veriyor ya kullanıcının açıkça yazdığını kodluyor; derleyici çıktısı `ti_lehce.py` ile sorunsuz.
- **Ardışık model:** doğrudan adreslemede 32-bit okuma iki kez yapılıyor (yalnız `unaligned_accesses` sayacını etkiliyor).
- **`ti_capraz/karsilastir.py`:** listeleme sayfa sonuna denk gelen komutları atlıyor (kodlama.lst 80/82, ornek.lst 51/52). Atlanan üç kelime elle doğrulandı; yeni test `test_TI_derleyici_ciktisi_ile_kelime_kelime_ayni` adrese göre karşılaştırıyor.
- **Belgelerde yanlış sayfa numaraları:**

  | Konu | Doğru sayfa |
  |---|---|
  | Tablo 10-9 | s.586 |
  | MMAXF32 / MMINF32 | s.636–641 |
  | MSWAPF | s.695 |
  | MMOV32 MSTF, mem32 / mem32, MSTF | s.657 / s.652 |
  | MFRACF32 | s.626 |
  | MASR32 / MLSR32 / MLSL32 | s.599 / s.632 / s.631 |
  | MCMP32 | s.609 |
  | MMOVIZ / MMOVXI | s.665 / s.667 |
  | Örnek 10-2 | s.580 |
  | 32-bit hizalama | s.569 |

  Kod içindeki yorum ve docstring'lerde düzeltildi. Hata mesajı dizgilerindeki eski numaralar (ör. `ops_float`'taki "s.598", `lint`'teki "s.579 Ornek 10-2") kod sayıldığı için olduğu gibi bırakıldı.
  `model_kararlari.md` tarih sırasıyla tutulan bir kayıt olduğu için eski bölümleri de olduğu gibi duruyor.

## D. Bu turda denetlenmeyen alanlar

- Hakem ve CLA yazmaçları (TRM 10.7): MVECTx, MCTL, MIFR/MIOVF/MIER/MIRUN, öncelik. Mevcut testler: `test_task_arbiter`, `test_tasks`.
- Araçlar, lint ve iz belgelerinin tutarlılığı. Mevcut testler: `test_araclar`, `test_lint`, `test_trace`.
- Boru hattının tablolar dışındaki ayrıntıları (Tablo 10-1/10-2, MAR kuralları ve 10-10…10-19 denetlendi).
