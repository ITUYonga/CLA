# Kapsam kararları

**KRİTİK** = RTL ile modelin bit/çevrim eşdeğerliğini ya da program
sonuçlarını doğrudan etkiler; RTL tarafı aynısını uygulamak zorunda.
§ numaraları `docs/model_kararlari.md`'ye işaret eder.

## Modellenenler ve nasıl

| # | Karar | Önem | Kaynak |
|---|---|---|---|
| K1 | **TRM esas.** TRM kendi içinde çelişirse hakem TI'nin kendi aracıdır (cl2000 derleyici/assembler çıktısı, `ti_capraz/`). | KRİTİK | §33, §47 |
| K2 | **Boru hattı modeli altın referanstır.** İz ve RTL karşılaştırması yalnız ondan. Ardışık model gecikme yuvası içermez (dallanma hemen etkili, bayrak önceki komuttan); gecikme yuvasına iş koyan programlarda TRM sonucu **vermez** — yalnız birim testleri için. | KRİTİK | §25, §28 |
| K3 | **Hakem her zaman var.** Gerçek CLA hakemsiz çalışmaz; hakemsiz yol yalnız tek görevli birim testleri içindir. | orta | §45 |
| K4 | **Dallanma hedefi = dalın kendi adresi + işaretli ofset.** TRM s.600'deki "0xFFFE MBCNDD'ye döner" cümlesi TRM hatası (sözde kod `MPC += 16BitDest` ve TI'nin 6/6 dallanması aksini gösteriyor). MCCNDD dönüş adresi = pc+8. Karar D2'de, 3 gecikme yuvası. | KRİTİK | §47.1, §32.1 |
| K5 | **MPC = D2'deki komut** (s.717); getirme sayacı ayrı bir iç sayaç. | KRİTİK | §41 |
| K6 | **Görev sınırı Tablo 10-19'a göre.** MSTOP D2'de (n): bekleyen görev varsa eski görev n+2'de biter, yenisinin F1'i n+3 (eski görevin son W'siyle aynı çevrim). Bekleyen yoksa görev son W'den sonra biter. Yalnız MSTOP'tan oluşan görev de n+2'de biter. | KRİTİK | §45, §46 |
| K7 | **R1/W bellek çakışma durağı TRM'deki gibi** (26.09, §49; kod bekliyor: M4). W'deki komut bir bloğa yazıyor, R1'deki komut aynı bloktan okuyorsa R1 bir çevrim durur. Bloklar L1, L2, CLA→CPU mesaj RAM'i. Önceki karar (§43, durak yok) geçersiz. | KRİTİK | §43, §49 |
| K8 | **Kestirim tablosu proje sözleşmesi.** TI tabloyu yayımlamıyor; MEINVF32/MEISQRTF32 `isa/estimate_lut.hex` ile. Garanti Python == RTL; TI silikonuyla eşitlik garanti değil. | KRİTİK | §42 |
| K9 | **NaN tek desen: 0x7FC00000.** Aritmetik sonucu NaN ise bu desen yazılır (ana makineden bağımsız). ∞×0 ve ∞−∞ NaN verir (kullanıcı kararı). Taşıma/işaret komutları NaN yükünü korur. | KRİTİK | §42.7, §46 |
| K10 | **Geçersiz opcode:** boru hattı D2'de donar, PIE kesmesi gider, MIRUN set kalır (s.576). Ardışık model istisna fırlatır (kullanıcı kararı). | orta | §37–§40 |
| K11 | **İz formatı v1** (`trace_format.md`); son görevin izi MSTOP D2 + 3'te biter. | KRİTİK | trace_format §4 |
| K12 | **Yuvarlama** RND32'ye göre (0 = sıfıra kes, sıfırlama değeri; 1 = en yakın çift); denormal sonuç +0 ve LUF. Aritmetik girdideki denormal +0 sayılır (FTZ, 26.09; kod bekliyor: M1). | KRİTİK | §3, §49 |
| K13 | **FPU K1/K2 (26.09):** FP sonucu W'nin sonunda yazılır; hemen okuyan komut 1 çevrim bekler (TRM'den tek sapma). Aynı MR'ye art arda yazma beklemez (EXE yazması kazanır). LVF/LUF okuyucuları bekleyen bayrakları görür. D2 işi her komutta bir kez, `dur_exe = 0` olan ilk çevrimde. Kod bekliyor: M2, M3, M5. | KRİTİK | §49 |

## Bilerek dışarıda bırakılanlar

| # | Kapsam dışı | Etkisi | Kaynak |
|---|---|---|---|
| D1 | Hata ayıklama / kesme noktası modu: MDEBUGSTOP her zaman MNOP (s.575, s.614); tek adım ve Tablo 10-19'un tek adım notları modellenmiyor. | Normal çalışmada fark yok. | §34.1 |
| D2 | MMEMCFG: program ve veri RAM'leri hep CLA'da (PROGE = RAM0E = RAM1E = 1). | Program çalışırken bu bitler değiştirilmemeli. | borç 1.9 |
| D3 | CPU tarafı: CPU erişim öncelikleri, hata ayıklayıcı erişimleri, eşzamanlı CPU erişimi. | Test tezgâhı görev sırasında CLA belleğine CPU erişimi üretmemeli (K7). | §43 |
| D4 | Çevre birimleri (ePWM, ADC sonuç yazmaçları vb.) ve EALLOW koruması: MEALLOW biti saklanıyor ama uygulanmıyor; çevre birimi adresine erişim hata verir. | TRM'in s.615/616 ve s.644 örnekleri yazıldığı gibi çalışmaz. | §1.8, borç 8.1 |
| D5 | MCTL SOFTRESET/HARDRESET ve MPISRCSEL1 tetik yönlendirmesi: yazılabilir ama etkisi yok; görevler yazılımla tetikleniyor (`cevresel_istek`, MIFRC). | Tetikten ilk F1'e gecikme modellenmiyor. | cla_regs.py |
| D6 | Assembler, TI sözdiziminin bir alt kümesi: `*MARx[#n]++`, `#sembol`, iki noktasız etiket, ters sıralı paralel çift kabul edilmiyor (hata verir, yanlış kod üretmez). TI lehçesi `ti_capraz/ti_lehce.py` ile çevrilir. | Yalnız kullanım kolaylığı. | 02 |
| D7 | Ayrılmış kodlamalar (adresleme kipi 0011–1111, CNDF 0110–1001): model Python hatasıyla durur. TRM "reserved" diyor; assembler bunları üretmez. | Test programlarında olmamalı. | §4.3, borç 11.1 |
