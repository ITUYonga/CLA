# RTL şartları — modelle eşdeğer olmak için

Verilog tasarımı bunları uygularsa model izi ile RTL izi satır satır
karşılaştırılabilir (`tools/compare_trace.py`).

1. **Program görüntüsü**: `tools/casm2hex.py` çıktısı; 32-bit komutun LSW'si alt adreste; L3 = 4K word.
2. **Boru hattı**: 8 kademe F1 F2 D1 D2 R1 R2 E W (s.577).
   - D2'de adres üretimi, MAR post-increment ve dallanma kararı.
   - R1 adres, R2 okuma. E'de yazmaç sonuçları ve MAR yüklemesi. W'de bellek yazma.
3. **MPC** = D2'deki komutun adresi (s.717). Getirme adresi ayrı sayaçtır.
4. **Dallanma**:
   - Hedef = dalın kendi adresi + işaretli ofset. Kendine dönen dal 0x0000'dır; TRM'deki 0xFFFE cümlesi yanlış.
   - Karar D2'de, D2'deki bayraklarla (dalın 4 komut öncesine kadar olan komutların etkisi).
   - Her zaman 3 gecikme yuvası vardır.
   - MCCNDD, RPC = pc + 8'i D2'de yazar. MRCNDD'de MPC = RPC.
5. **MAR**: yükleme E'de etkili olur. I3 aynı MAR'ı kullanırsa post-increment kazanır, yükleme düşer.
6. **Bellek çakışması**:
   - Durak yoktur.
   - Aynı çevrimde aynı adrese W (komut n) ve R1 (komut n+3) gelirse okuma **yeni** değeri döndürmeli.
   - FPGA blok RAM'de aynı kenarda aynı adrese yazma + okuma "çakışma"dır; yönlendirme (bypass) gerekir.
   - Test tezgâhı görev sırasında CLA belleğine CPU erişimi üretmemeli.
7. **Görev sınırı** (Tablo 10-19):
   - MSTOP D2'de (n): MIRUN temizlenir, PIE kesmesi gider, arkasındaki 3 komut silinir.
   - n+1 ve n+2 hakem çevrimleridir. Bekleyen görevin ilk F1'i n+3'tedir; eski görevin son W'si de o çevrimdedir.
   - Öncelik en küçük görev numarasındadır.
8. **Geçersiz opcode**: D2'de durur (kesme noktası gibi), PIE kesmesi gider, MIRUN set kalır. R1/R2/E'dekiler tamamlanmaz.
9. **Kayan nokta**:
   - RND32: 0 = sıfıra kes (sıfırlama değeri), 1 = en yakın çift.
   - Denormal sonuç → +0 ve LUF.
   - Taşma: RND32=1'de ±∞ (LVF), RND32=0'da ±MAX (LVF).
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
