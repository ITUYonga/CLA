# RTL şartları — modelle eşdeğer olmak için

Verilog tasarımı bunları uygularsa model izi ile RTL izi satır satır
karşılaştırılabilir (`tools/compare_trace.py`).

1. **Program görüntüsü**: `tools/casm2hex.py` çıktısı; 32-bit komutun LSW'si alt adreste; L3 = 4K word.
2. **Boru hattı**: 8 kademe F1 F2 D1 D2 R1 R2 E W (s.577).
   - D2'de adres üretimi, MAR post-increment ve dallanma kararı.
   - R1 adres, R2 okuma. E'de yazmaç sonuçları ve MAR yüklemesi. W'de bellek yazma.
   - İstisna: FP aritmetiğinin sonucu ve LVF/LUF'u W'nin sonunda yazılır (FPU K1/K2, madde 14).
3. **MPC** = D2'deki komutun adresi (s.717). Getirme adresi ayrı sayaçtır.
4. **Dallanma**:
   - Hedef = dalın kendi adresi + işaretli ofset. Kendine dönen dal 0x0000'dır; TRM'deki 0xFFFE cümlesi yanlış.
   - Karar D2'de, D2'deki bayraklarla (dalın 4 komut öncesine kadar olan komutların etkisi).
   - Her zaman 3 gecikme yuvası vardır.
   - MCCNDD, RPC = pc + 8'i D2'de yazar. MRCNDD'de MPC = RPC.
5. **MAR**: yükleme E'de etkili olur. I3 aynı MAR'ı kullanırsa post-increment kazanır, yükleme düşer. Post-increment D2'de ve koşuldan bağımsız: koşullu yüklemede koşul tutmasa da MAR artar (§51.7).
6. **Bellek çakışması** (26.09, §49; TRM s.571–573, s.577):
   - W'deki komut bir bloğa yazıyor ve R1'deki komut aynı bloktan okuyorsa R1 bir çevrim durur: F1…R1 bekler, R2'ye balon girer. Bloklar L1 (0x8800), L2 (0x8C00), CLA→CPU mesaj RAM'i (0x1480); adres değil blok karşılaştırılır. CPU→CLA mesaj RAM'ine CLA yazması yok sayıldığından orada durma yok.
   - Bu durma yüzünden aynı çevrimde aynı bloğa yazma + okuma olmaz; RAM'de bypass gerekmez. Yazmadan sonraki 1. ve 2. komut eski değeri okur (Tablo 10-1); store→load iletme yolu eklenmez.
   - Test tezgâhı görev sırasında CLA belleğine CPU erişimi üretmemeli.
   - Model uyguluyor (M4, §51.3). Bayrak D2/EXE ilişkisi için madde 14'teki D2 kuralı geçerli.
7. **Görev sınırı** (Tablo 10-19):
   - MSTOP D2'de (n): MIRUN temizlenir, PIE kesmesi gider, arkasındaki 3 komut silinir.
   - n+1 ve n+2 hakem çevrimleridir. Bekleyen görevin ilk F1'i n+3'tedir; eski görevin son W'si de o çevrimdedir.
   - Öncelik en küçük görev numarasındadır.
8. **Geçersiz opcode**: D2'de durur (kesme noktası gibi), PIE kesmesi gider, MIRUN set kalır. R1/R2/E'dekiler tamamlanmaz.
9. **Kayan nokta**:
   - RND32: 0 = sıfıra kes (sıfırlama değeri), 1 = en yakın çift.
   - Girdideki denormal +0 sayılır (FTZ, 26.09; model uyguluyor, §50).
   - Alt taşma (kesin değer < 2^-126): LUF = 1. Sonuç denormale yuvarlanırsa +0; sıfıra yuvarlanırsa işaret korunur (±0); RN'de 2^-126'ya yuvarlanırsa ±MIN_NORMAL.
   - Taşma: RND32=1'de ±∞ (LVF), RND32=0'da ±MAX (LVF). LVF eşiği iki kipte de RN'inki (|x| ≥ 2^128 − 2^103).
   - NaN sonucu **0x7FC00000**; ∞×0 ve ∞−∞ NaN verir.
   - Bayrak kuralları her komutun "Flags" tablosuna göredir: aritmetik yalnız LUF/LVF'yi değiştirir.
10. **Kestirim**:
    - `isa/estimate_lut.hex` (768 × 8 bit, `$readmemh`).
    - Adres: 1/√x için `{1'b0, e[0], f[22:15]}`, 1/x için `{2'b10, f[22:15]}`.
    - Sonuç = işaret | üs << 23 | q << 15. Üs hesabı ve özel durumlar `03_varsayimlar.md`'de.
11. **Dönüşüm**:
    - İşaretsiz hedefe negatif girdi → 0.
    - Pozitif taşma sarılır (varsayım). NaN → 0.
12. **İz** (`docs/trace_format.md` v1):
    - Çevrim 1 = ilk F1.
    - Satır başına EXE'deki komut, MPC, MR0–3, MAR0–1, MSTF ve o çevrimde W'de yapılan yazma.
    - Son görevin izi MSTOP D2 + 3'te biter; test tezgâhında bu, MIRUN temizlendikten sonra 3 çevrim demektir.
    - X/Z ayrışma sayılır.
13. **MSTF bit düzeni**: LVF 0, LUF 1, NF 2, ZF 3, TF 6, RNDF32 9, MEALLOW 11, RPC 23:12 (s.718). MSETFLG'de FLAG bit 7 = RNDF32.
14. **FPU K1/K2** (26.09, §49; model uyguluyor: §51):
    - FP sonucu ve LVF/LUF'u W'nin sonunda yazılır.
    - Bu sonucu okuyan komut EXE'deyse 1 çevrim durur (`dur_exe`: F1…EXE bekler, W'ye balon). Aynı MR'ye yalnız yazma durdurmaz: aynı kenarda EXE yazması kazanır.
    - LVF/LUF okuyucuları (D2'de LV/LU dallar, EXE'de MTESTTF ve CNDF'li komutlar, `MMOV32 mem32, MSTF`) K2'deki bekleyen bayrakları da görür.
    - Aynı çevrimde MR yazma önceliği: EXE > toplayıcı K2 > çarpıcı K2 (MMACF32'de MRd = MR3).
    - D2 işi her komutta bir kez, komut D2'den **ilerlediği** çevrimde (`dur_exe` ve `dur_r1`); MPC her çevrim D2'deki komut, durmada da.
    - İz: `dur_exe` çevriminde EXE'de bekleyen komut basılır (`exe_pc` iki satır aynı); `dur_r1` balonu iki çevrim sonra EXE'de boş satır olarak görünür.
    - Kurallar, şemalar ve "uygulanmazsa" örnekleri: "CLA Boru Hattı Kuralları" sayfası (https://claude.ai/artifact/2gSrWkVvfNAcPjBAdbnpwV); ALU sinyalleri: "ALU Entegrasyon Sözleşmesi" (https://claude.ai/artifact/RaqGXr3sRUTaZSuq5aYbUK). Eski "CLA FPU Boru Hattı" sayfasındaki yazma önceliği (çarpıcı > toplayıcı) yanlış.
    - Kural başına test programları ve beklenen izler: `dogrulama/golden_paket/boru_hatti_testleri/` (23 program).
