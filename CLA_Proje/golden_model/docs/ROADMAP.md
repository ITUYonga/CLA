# CLA Type-0 Golden Model — Yol Haritasi

Kaynak: SPRUI10A, TMS320F2803x TRM, Bolum 10 (s.565-720).
PDF sayfa numarasi = basili sayfa numarasi, ofset yok.

Her faz: bağımsız modül + kendi testi. Sıra önemli, bir önceki faz yeşil olmadan başlama.

## Faz 0 — Komut tablosunu kılavuzdan çıkar
Kilavuzda oku: s.583 (10.6.1 sablon) | s.584-585 (10.6.2 Addressing Modes and Encoding - bu fazin kalbi) | s.586-588 (10.6.3 komut dizini). ~6 sayfa; komut govdelerini (589+) burada okuma.

Dosya: `isa/cla_type0.yaml`, `golden_model/isa_table.py`, `tools/extract_isa.py`
Her komut 32 bit; kılavuz opcode'u LSW/MSW deseni olarak veriyor -> (maske, eşleşme) çifti.
Tuzak: komutu hem Python'a hem Verilog'a ayrı yazarsan ayrışırlar. Tablo tek yerde.
Test: rastgele word en fazla bir komuta uymalı (`test_isa_table.py`).

## Faz 1 — Yazmaçlar ve bellek
Kilavuzda oku: s.566-567 (10.1.1 Features + 10.1.3 Block Diagram) | s.568-569 (10.2.1 CLA Memory + 10.2.2 Memory Bus) | s.571-572 (10.3.1-10.3.3 Arbitration, 'writes are ignored') | s.717-720 (10.7.4.1 MPC + 10.7.4.2 MSTF, Tablo 10-33) | Bolum 10 disi: s.46 Tablo 1-10 ve s.139 Frame 0 tablosu (gercek adresler). ~12 sayfa.

Dosya: `float32.py`, `cla_state.py`, `cla_memory.py`
MR = ham uint32 (Python float tutarsan -0.0 ve NaN payload kaybolur).
Bellek 16-bit word adresli; 32-bit erişimde LSW düşük adreste, çift adres zorunlu.
Tuzaklar: denormal -> +0 | MPC 12 bit, 0xFFF'te sarar | izinsiz yazma sessizce yutulur.
MSTF: LVF=0 LUF=1 NF=2 ZF=3 TF=6 RND32=9 MEALLOW=11 RPC=23-12
Harita: MsgRAM 0x1480 / 0x1500 (128w), L1 0x8800, L2 0x8C00 (1Kw), L3 0x9000 (4Kw)
Test: `test_state_memory.py` — 22 test yeşil.

## Faz 2 — Kod çözücü ve assembler
Kilavuzda oku: s.584-585 (10.6.2, bu kez satir satir) | s.576 (10.4.4 Illegal Opcode Behavior) | s.568 (10.2.1, 32-bit hizali getirme). ~4 sayfa.

Dosya: `decoder.py`, `assembler.py`
MPC komut indeksi; fiziksel adres = 0x9000 + MPC*2.
Tuzak: geçersiz opcode'da CLA D2 fazında durur (breakpoint gibi), exception atıp kaçma.
Test: 100k rastgele word için assemble(disassemble(w)) == w.

## Faz 3 — Matematik komutları
Kilavuzda oku: s.718-720 (MSTF alan aciklamalari - once bunu) | s.589-597 (MABSF32/MADD32/MADDF32) | s.609-613 (MCMP32, MCMPF32) | s.617-618 (MEINVF32, MEISQRTF32) | s.620-632 (donusumler, kaydirmalar) | s.636-641 (MMAXF32, MMINF32) | s.668-678 (MMPYF32, paralel formlari atla) | s.686, 697, 699-703 (MSETFLG, MTESTTF, kalanlar). ~45 sayfa, en uzun okuma.

Dosya: `ops_float.py`, `ops_int.py`, `ops_convert.py`, `ops_estimate.py`
NF/ZF her işlemde yeniden yazılır; LUF/LVF yapışkandır (elle temizlenir).
Tuzak 1: yuvarlama MSTF.RND32'ye bağlı — reset sonrası SIFIRA KESER, Python varsayılanı ise
         en yakın çift. Açıkça seçmezsen son bitte sessiz hata.
Tuzak 2: MEINVF32/MEISQRTF32 ~8 bit tahmindir; `1/x` yazma, ortak LUT dosyasını kullan.
Test: kılavuz örnekleri + köşe durumlar (±0, ±Inf, NaN, denormal, sınır değerler).

## Faz 4 — Adresleme ve paralel komutlar
Kilavuzda oku: s.582 (10.5.3 Parallel Instructions - kisa ama sart) | s.584-585 (10.6.2 adresleme kipleri tarafi) | s.642-667 (MMOV ailesi) | s.615-616 (MEALLOW, MEDIS) | s.595-596, 673-678, 693-694, 633 (paralel form sayfalari) | s.569 (10.2.3 EALLOW). ~35 sayfa.

Dosya: `ops_memory.py`
Tuzak: paralel formda BÜTÜN okumalar bütün yazmalardan önce. Sırayla çalıştırırsan yanlış.
Test: kaynak/hedef çakışan senaryolar (`test_parallel.py`).

## Faz 5 — Pipeline ve dallanma
Kilavuzda oku: s.577 (10.5.1 Pipeline Overview) | s.578-581 (10.5.2 Pipeline Alignment - projenin en yogun 4 sayfasi, iki kez oku) | s.600-608 (MBCNDD, MCCNDD; Tablo 10-10/10-11/10-12) | s.683-685 (MRCNDD) | s.687, 614, 681 (MSTOP, MDEBUGSTOP, MNOP) | s.575 (10.4.3.1 Breakpoint). ~20 sayfa.

Dosya: `pipeline.py`
8 kademe: F1 F2 D1 D2 R1 R2 EXE W. Dal kararı D2'de.
Tuzaklar: dallanmadan önceki 3 komut kararı etkilemez | sonraki 3 komut her hâlükârda çalışır |
MAR yüklemesi EXE'de, post-inc D2'de: 2 komut eski değer, 3. komut MAR kullanamaz, 4.'ten yeni |
yazma-sonrası-okuma koruması YOK | MCCNDD dönüş adresi MSTF.RPC'de, iç içe çağrı yok.
Test: kılavuz Tablo 10-1, 10-2, 10-10, 10-11, 10-12 çevrim çevrim yeniden üretiliyor.

## Faz 6 — Görev hakemliği
Kilavuzda oku: s.570 (10.2.4 Tasks and Interrupt Vectors - once bunu) | s.573-575 (10.4.1 + 10.4.2 Init Sequence) | s.577 (10.4.5 Reset) | s.705 (MVECT1-8) | s.706-708 (MCTL, MMEMCFG, MPISRCSEL1) | s.709-716 (MIFR, MIOVF, MIFRC, MICLR, MICLROVF, MIER, MIRUN) | s.704 (10.7.1 Register Memory Mapping). ~20 sayfa.

Dosya: `task_arbiter.py`, `cla_core.py`
Akış: tetik -> MIFR.x=1 -> MIER maskesi -> öncelik (Task1>...>Task8) -> MVECTx -> MPC,
MIRUN.x=1 -> MSTOP -> MIRUN.x=0 + PIE'ye CLA1_INTx.
Tuzak: görevler iç içe geçmez. Çalışan görev MSTOP'a varmadan hiçbir şey olmaz.
Test: Task3 çalışırken Task1 ve Task5 tetiklenir; sıra 3 -> 1 -> 5 olmalı.

## Faz 7 — Doğrulama hattı ve gerçek uygulama
Kilavuzda oku: s.581-582 (10.5.2.1 ADC Early Interrupt, Tablo 10-3 - iz karsilastirmanin referans ornegi) | s.573-574 (10.4.1-10.4.2) | s.586-703 (10.6.3 tamami; okumak icin degil, kapsam matrisini isaretlemek icin). ~4 sayfa yeni okuma.

Dosya: `docs/trace_format.md`, `trace.py`, `tools/casm2hex.py`, `tools/compare_trace.py`
İz satırı: cycle, MPC, opcode, MR0-3, MAR0-1, MSTF, mem_wr_addr, mem_wr_data
Tuzak 1: format kod yazılmadan sabitlenmeli, yoksa iki taraf farklı basar.
Tuzak 2: bu hat sadece RTL == Python kanıtlar. Modelin kendisi CCS simülatörü veya gerçek
         kartla çapraz kontrol edilmeli.
Test: ADC -> MUI16TOF32 -> Clarke/Park -> PI -> ePWM döngüsünde tek bit fark yok.
