# CLA İz Formatı — v1

**Bu dosya bir sözleşmedir.** Python golden model ve SystemVerilog RTL
aynı satırları basmak zorunda; biri formatı değiştirirse öteki de
değişmeli ve sürüm numarası artmalı. Yol haritasındaki Tuzak 1 tam olarak
buydu: *"format kod yazılmadan sabitlenmeli, yoksa iki taraf farklı basar."*

Karşılaştırmayı `tools/compare_trace.py` yapıyor, üreten taraf
`golden_model/trace.py`. Okuyucu (`trace.oku`) bu belgedeki kuralları
**uygular**: kurala uymayan dosya karşılaştırılmaz (§3.1).

---

## 1. Ne zaman bir satır basılır

**Her çevrimde bir satır.** Komut başına değil, yazma olayı başına değil.

Üç sebep:

1. **RTL tarafı böyle kolay.** Testbench saat kenarında `$fwrite` yapar;
   "komut emekli oldu" kavramını donanımda ayrıca üretmek gerekirdi.
2. **Boru hattında "komut başına" belirsiz.** Bir çevrimde sekiz komut
   sekiz kademede; hangisinin satırı?
3. **Borç 11.3'ü çözüyor.** `MI32TOF32 MRa, mem32` aynı çevrim içinde
   `set_mr`'ı iki kez çağırıyor (ikincisi birincinin üstüne yazıyor).
   Yazma-olayı izinde bu iki satır olurdu ve RTL'de tek satır olurdu.
   Çevrim sonu anlık görüntüsünde **sorun ortadan kalkıyor**: ara değer
   hiç görünmüyor. `ops_convert.py`'ye dokunmaya gerek yok.

Satır, çevrimin **sonundaki** durumu gösterir: o çevrimde yapılan bütün
yazmalar işlenmiş hâli.

## 2. Satır biçimi

Tek satır, alanlar **tek boşlukla** ayrılmış, sabit genişlikte:

```
cycle exe_pc exe_op mpc mr0 mr1 mr2 mr3 mar0 mar1 mstf wr_addr wr_data wr_w
```

| alan | genişlik | taban | anlamı |
|---|---|---|---|
| `cycle` | değişken | **ondalık** | 1'den başlayan, her satırda 1 artan sayaç (§4) |
| `exe_pc` | 3 | onaltılık | o çevrim EXE kademesindeki komutun adresi |
| `exe_op` | 8 | onaltılık | aynı komutun 32-bit kelimesi |
| `mpc` | 3 | onaltılık | çevrim sonunda **MPC yazmacı** (TRM s.717): D2'deki komutun adresi; görev başında MVECTx, MSTOP'tan sonra MSTOP'u gösterir. Getirme adresi ayrı bir iç sayaç, izde yok (§5) |
| `mr0..mr3` | 8 | onaltılık | ham uint32 — float'a çevrilmez |
| `mar0..mar1` | 4 | onaltılık | |
| `mstf` | 8 | onaltılık | bayraklar + RPC (bit 23:12), ayrı sütun yok |
| `wr_addr` | 4 | onaltılık | o çevrimde belleğe **etkili** yazılan adres |
| `wr_data` | 8 | onaltılık | yazılan veri (16-bit yazmada üst yarı 0) |
| `wr_w` | 2 | **ondalık** | `16` ya da `32` |

**Taban karışıklığı olmasın diye:** `cycle` ve `wr_w` ondalık, geri kalan
**hepsi** onaltılık ve `0x` öneki **yok**, küçük harf. (Okuyucu büyük
harfi kabul eder — değer aynıysa harf büyüklüğü ayrışma sayılmasın diye;
`0x` önekini reddeder.)

### Boş alanlar

Bir alan "bu çevrimde yok" ise genişliği kadar `-` basılır:

```
exe_pc  yok -> ---            (EXE'de balon var)
exe_op  yok -> --------
wr_addr yok -> ----           (bu cevrimde yazma yok)
wr_data yok -> --------
wr_w    yok -> --
```

Sıfır basmak **yasak**: "0 adresine 0 yazdı" ile "yazma yok" ayrılamaz
hâle gelir.

### X / Z (RTL'in bilinmeyen değeri)

Verilog `%h`, bütün bitleri X olan haneyi `x`, bazı bitleri X olanı `X`
basar (Z için `z`/`Z`). Okuyucu bunu **biçim hatası saymaz**: alan tam
genişlikteyse (`xxxxxxxx`, `88X0`) ham metin olarak okunur ve hiçbir
sayıya eşit değildir. Sonuç: reset edilmemiş ya da sürülmeyen bir sinyal
**ilk ayrışma** olarak, çevrimi ve bağlamıyla raporlanır (çıkış 1) ve
rapor satırı "X/Z" notu düşer. `cycle` sütununda X kabul edilmez.

### `wr_*` etkili yazmadır

`wr_*` belleğin **değiştiği** yazmayı gösterir, yazma denemesini değil.
CLA'nın yazamadığı bölgeye yazması (CPU→CLA mesaj RAM'i: *"writes by the
CLA are ignored"*, s.568) izde `wr_*` üretmez. RTL testbench'i yazma
sinyalini bölge çözümünden **sonra** örneklemeli. Bu seçim bilinçli:
RTL'de yazma koruması unutulursa RTL izinde `wr_*` çıkar, modelde çıkmaz
— hata yakalanır. Deneme gösterilseydi iki taraf da basardı ve koruma
hatası görünmezdi. (Test: `test_yok_sayilan_yazma_ize_dusmuyor`.)

### Neden çevrimde tek yazma alanı var

Dayanak **TRM**. Belleğe yazan komut biçimi sekiz tane ve her biri tek
konuma yazar:

| biçim | TRM | yazılan |
|---|---|---|
| `MMOV16 mem16, MARx` / `MMOV16 mem16, MRa` | s.648 / s.649 | 16 bit |
| `MMOV32 mem32, MRa` / `MMOV32 mem32, MSTF` | s.651 / s.652 | 32 bit |
| `MMOVD32 MRa, mem32` | s.658 | `[mem32+2] = [mem32]` — **bir** yazma |
| `MADDF32` / `MMPYF32` / `MSUBF32 … ǁ MMOV32 mem32, MRa` | s.595 / s.677 / s.694 | yalnız `MMOV32` kısmı yazar |

W kademesinde çevrim başına tek komut bulunduğundan çevrim başına en
fazla bir yazma olur; `wr_*` bu yüzden tekil. Bu sekiz biçim modelin
`erisim.YAZAR16 ∪ YAZAR32` kümesiyle birebir aynı
(`test_tek_yazma_alani_TRM_ye_dayaniyor`). İleride bu değişirse **sürüm
artar**, alan çoğaltılmaz.

> Önceki metin "ölçüldü" diyordu. O ölçüm kanıt değildi: modelin boru
> kaydında tek bir `yaz_ea` yuvası var, iki yazma üretmesi yapısal olarak
> imkânsız — ölçüm kendi varsayımını doğruluyordu. `Izci` yine de bir
> çevrimde ikinci yazma görürse **durur** (`IzHatasi`).

## 3. Başlık

Dosya iki yorum satırıyla başlar; yorum satırları `#` ile başlar ve
karşılaştırmada atlanır.

```
#CLATRACE 1
#FIELDS cycle exe_pc exe_op mpc mr0 mr1 mr2 mr3 mar0 mar1 mstf wr_addr wr_data wr_w
```

### 3.1 Okuyucunun reddettikleri

Aşağıdakilerin hepsi `IzHatasi` → `compare_trace` çıkış **2**. Her biri,
okuyucu gevşek olsaydı sessizce yanlış sonuç verecek somut bir testbench
hatasına karşılık geliyor:

| kural | kapattığı sessiz hata |
|---|---|
| `#CLATRACE` ve `#FIELDS` ikisi de var, **ilk veri satırından önce** | başlıksız dosyanın sütunları tahmin edilirdi |
| sürüm okuyucunun sürümü (şu an yalnız 1) | v2 dosyası v1 alanlarıyla okunur, sütunlar kayardı |
| `#FIELDS` listesi yukarıdakiyle **birebir aynı sırada** | `mar1 mar0` sırası değerleri yanlış alana dağıtırdı |
| dosyada tek `#CLATRACE` | `cat a.trace b.trace` iki koşuyu tek koşu sanardı |
| `cycle` 1'den başlar, her satırda +1 | ortadan düşen tek satır sonraki **her** satırı kaydırırdı |
| her satırda 14 alan; sayı, tire ya da tam genişlikte X/Z | `-1`, `0x40e00000`, `40e0000g` |

### 3.2 `compare_trace.py` çıkış kodları

| kod | anlam |
|---|---|
| 0 | iki iz aynı uzunlukta ve karşılaştırılan her alanda aynı |
| 1 | **yalnızca** gerçek ayrışma (değer ya da uzunluk farkı) |
| 2 | karşılaştırma **yapılamadı**: biçim hatası (§3.1), boş iz, `--gormezden-gel` bütün alanları kapatıyor, okunamayan dosya, aracın kendi istisnası |

"AYRISMA YOK" ancak gerçekten bir şey karşılaştırıldıysa basılır. Bir CI
betiği `kod == 1` diye bakıyorsa aracın çökmesi onu kandıramaz — Python'un
yakalanmamış istisnası normalde 1 döner, araç bunu 2'ye çeviriyor.

## 4. Çevrim 1 nerede başlar, iz nerede biter

`cycle = 1`, MPC yüklendikten **sonraki ilk** çevrimdir — yani ilk `F1`in
koştuğu çevrim. Python tarafında `Pipeline.update_pipeline`'ın ilk
çağrısı; RTL tarafında reset çekildikten ve `MVECTx` yüklendikten
sonraki ilk saat kenarı. Sayaç **satır sayacıdır**: 1'den başlar, her
satırda 1 artar, atlama yoktur (§3.1).

**İz sonu.** `MSTOP` D2'ye girdiğinde (çevrim *n*; TRM s.687: *MIRUN
flag ... is cleared*) kendisi ve arkasındaki üç komut silinir; önündeki
komutlar boru hattını boşaltmaya devam eder. Tablo 10-19 (s.688): *n+1*
ve *n+2* hakem çevrimleri, *n+3*'te MSTOP'tan önceki son komutun W'si —
bir sonraki görev olsaydı onun ilk F1'i de. **Son görevin izi *n+3*'te
biter**; MSTOP'tan önce komut olmasa da (son satırlar boş). RTL
testbench'i için: MIRUN'un temizlendiği çevrimden sonra 3 çevrim daha.
`MSTOP` hiçbir zaman EXE'ye varmaz, dolayısıyla izde `exe_pc`'si MSTOP
olan satır **yoktur**. (24.09 akşamına kadar kural "R1, R2, EXE boşalınca"
idi: MSTOP'tan önce komut varsa aynı, *n+3*; yoksa *n*.)

**Geçersiz opcode.** TRM s.576: CLA, geçersiz kelime D2'deyken durur,
PIE'ye kesme gider, MIRUN **set kalır**. İz o çevrimde biter. O çevrimde
bütün kademeler son kez ilerler, sonra boru hattı donar: R1, R2, EXE'de
kalanlar ve EXE'deki komutun bekleyen W'si **tamamlanmaz** (EXE'deki bir
saklama belleğe inmez). MIRUN set kaldığı için hakem sonraki görevi
başlatmaz, yani çok görevli iz de burada biter. Ardışık model bunu
modellemez, `IllegalOpcodeError` fırlatır (kullanıcı kararı; ardışık
modelin zaten izi yok). Test: `test_gecersiz_opcode_izi_durma_cevriminde_biter`.

**Çok görev.** Yeni görev yeni bir iz dosyası demek değil — sayaç kaldığı
yerden devam eder (`iz_al_gorevler` tek dosya üretir). Her görevin
başında izci yazma kaydını eşitler: iki görev arasında test tezgâhının
CPU adına yaptığı yazma (ör. mesaj RAM'ine yeni komut) sonraki görevin
ilk çevrimine CLA yazması diye basılmaz. Görev sınırında yeni görevin
ilk satırı *n+3*'tür (önceki görevin son W'siyle aynı satır, §6.5).

## 5. İzde OLMAYANLAR — ve neden

| yok | sebep |
|---|---|
| boru hattı ara kayıtları (F2/D1/D2/R1/R2 içerikleri) | RTL'in iç kayıtlarını dışarı çıkarması gerekirdi; iz o zaman mikromimariye bağlanır ve tasarım değişince anlamsızlaşır |
| ayrı bayrak sütunları (ZF/NF/LUF/LVF/TF/RPC) | hepsi `mstf` içinde; iki yerde tutmak ayrışma riski |
| bellek **okuma** adresleri | okuma mimari durumu değiştirmez; yanlış okuma zaten yanlış `mr` olarak görünür |
| getirilen komut kelimesi (F2) | `exe_op` zaten aynı bilgiyi emekli olan komut için veriyor |
| görev hakemliği ve yapılandırma yazmaçları: `MIFR`, `MIER`, `MIRUN`, `MIOVF`, `MIFRC`, `MICLR`, `MICLROVF`, `MVECT1..8`, `MCTL`, `MPISRCSEL1`, `MMEMCFG` | CPU tarafı ve hakem katmanı; komut akışını değil görev seçimini belirliyor. Görev seçimi yanlışsa iz zaten yanlış `exe_pc` ile ayrışır. Gerekirse v2'de ayrı bir **olay** izi (görev başladı/bitti, PIE) |
| yok sayılan yazma denemeleri | `wr_*` etkili yazmadır (§2) |
| getirme sayacı (F1'in program adres yolu, s.577) | mimari değil, CPU göremez; dallanma yönlendirmesi zaten `mpc` ve `exe_pc` akışında görünür |

## 6. Bilinen hizalama riskleri

RTL ile ilk karşılaştırmada **önce buralara bakılacak**:

1. **MPC anlamı — çözüldü (24.09).** TRM s.717: *"The MPC points to
   the instruction in the decode 2 (D2) stage"*. Model artık bunu
   uyguluyor; F1'in getirme adresi ayrı bir iç sayaç (`Pipeline.getir_pc`,
   s.577: *"the program read address is placed on the CLA program address
   bus"*). RTL testbench'i **MPC yazmacını** basmalı, getirme sayacını
   değil — ikincisi düz akışta 8 word ileride olur ve bu sütun her
   satırda ayrışır.
2. **Yazmanın görünür olduğu çevrim.** Model W kademesinde belleğe
   iniyor (bkz. model_kararlari §27.3, borç 27.1). RTL W+1'de indirirse
   `wr_*` bir satır kayar.
3. **Balon kodlaması.** Model geçersiz kaydı `gecerli=0` ile işaretliyor
   ve `exe_pc`/`exe_op` `-` basıyor. RTL `MNOP` enjekte ediyorsa o
   satırlar `exe_op` sütununda ayrışır.
4. **Görev sonu.** §4'teki kural: son satır R1/R2/EXE'nin boşaldığı
   çevrim. RTL testbench'i MIRUN düştüğü anda (D2) durursa izi 3 satır
   kısa, saat üretmeye devam ederse uzun olur. `compare_trace.py` kısa
   dosya bitince durur ve uzunluk farkını **rapor eder**.
5. **Görev sınırı (çok görevli iz).** TRM Tablo 10-19 (s.688): MSTOP
   D2'deyken (çevrim *n*) bekleyen görev *n+1* ve *n+2*'de hakemlenir,
   yeni görevin ilk komutu **n+3**'te F1'e girer — eski görevin son
   komutunun W'siyle aynı çevrim. **24.09 akşamı düzeltildi** (kullanıcı,
   model_kararlari §45): bekleyen görev varsa eski görev *n+2*'de biter,
   yeni görev *n+3*'te başlar (önce *n+4*). Yalnız MSTOP'tan oluşan görev
   de 25.09'dan beri *n+2*'de bitiyor (model_kararlari §46) —
   `test_tablo_10_19_yalniz_MSTOP_olan_gorev`.
6. **İlk görevde yalnız `MSTOP` içeren görev — çözüldü (24.09).** Boş
   kayıtların `gecerli`si `None`'dı, boşalma denetimi `== 0` arıyordu;
   aynı görev bir kez 5, bir kez 4 çevrim sürüyordu. `BoruKaydi.gecerli = 0`
   ile görev uzunluğu geçmişten bağımsız (k=0,1,2 komut → 4, 8, 9 çevrim;
   `test_bosalma_cevrim_sayisi_kesin_ve_gecmisten_bagimsiz`).
7. **R1/W bellek çakışması — modellenmiyor (karar, 24.09).** Silikonda
   komut *n*'nin W'si ile komut *n+3*'ün R1'i aynı bloğa aynı çevrimde
   düşerse yazma öncelikli, R1 bir çevrim durur (s.571/573/577). Model
   durmuyor ve veriyi R2'de (W'den bir çevrim sonra) okuduğu için YENİ
   değeri alıyor (model_kararlari §43). RTL'in bellek hakemi bu durumda R1'i
   durdurursa o satırdan sonraki her satır 1 kayar; aynı adreste eski
   değeri okursa `mr` ayrışır. RTL == model için: durak yok, aynı adreste
   yazılan değer okumaya yönlendirilir (bypass).

## 7. Örnek

Gerçek çıktı (`MMOVIZ MR0,#7.0` / `MMOV32 @0x8900,MR0` / `MSTOP`):

```
#CLATRACE 1
#FIELDS cycle exe_pc exe_op mpc mr0 mr1 mr2 mr3 mar0 mar1 mstf wr_addr wr_data wr_w
...
4 --- -------- 000 00000000 00000000 00000000 00000000 8800 8802 00000000 ---- -------- --
5 --- -------- 002 00000000 00000000 00000000 00000000 8800 8802 00000000 ---- -------- --
6 --- -------- 004 00000000 00000000 00000000 00000000 8800 8802 00000000 ---- -------- --
7 000 784040e0 004 40e00000 00000000 00000000 00000000 8800 8802 00000000 ---- -------- --
8 002 74c08900 004 40e00000 00000000 00000000 00000000 8800 8802 00000000 ---- -------- --
9 --- -------- 004 40e00000 00000000 00000000 00000000 8800 8802 00000000 8900 40e00000 32
```

Okuma notları:

* **`mpc` = D2'deki komut.** Çevrim 1-3'te D2 boş, MPC görev başında
  yüklenen MVECT'i (000) gösterir; ilk komut D2'ye 4'te girer (000),
  sonra 002; MSTOP (004) 6'da D2'de ve boşalma boyunca orada kalır
  (s.717). 24.09'dan önce bu sütun getirme işaretçisini basıyordu
  (002, 004, … 00c).
* **Son satırda `exe_pc` boş.** MSTOP D2'de silindi, EXE'ye hiç varmadı
  (§4). İz, saklama komutunun W'si bitince (çevrim 9) duruyor.
* **`wr_*` saklama komutunun `exe_pc`'siyle AYNI satırda değil.** Çevrim
  8'de saklama komutu EXE'de ama `wr_addr` boş; yazma çevrim 9'da iniyor.
  Sebebi kademe sırası: W, EXE'den bir çevrim sonra. Yani bir satırdaki
  `wr_*` alanları **bir önceki satırın** komutuna aittir. Bu, §6.2'deki
  "RTL W+1'de indirirse bir satır kayar" riskiyle karıştırılmamalı:
  buradaki bir satırlık mesafe **normal ve beklenen**, oradaki kayma ise
  ikinci bir satırlık fazladan gecikme olurdu.

## 8. Sürüm geçmişi

| sürüm | tarih | değişiklik |
|---|---|---|
| 1 | — | ilk sabitleme — çevrim başına satır, tek yazma alanı |
| 1 | 24.09 (4) | §4 iz sonu: son görev her zaman *n+3* (MSTOP'tan önce komut yoksa da); görev sınırı Tablo 10-19'a çekildi (§6.5). Format aynı. |
| 1 | 24.09 (3) | §6.7 eklendi: R1/W çakışması modellenmiyor (model_kararlari §43). Format aynı. |
| 1 | 24.09 (2) | **`mpc` sütununun anlamı TRM'e çekildi** (D2'deki komut, s.717); sütunlar ve genişlikler aynı. RTL henüz yok, eski iz saklanmıyor → sürüm artırılmadı. |
| 1 | 24.09 | **format aynı**, okuyucu sıkılaştı (§3.1), X/Z kuralı, `wr_*` etkili yazma tanımı, iz sonu MSTOP-D2 davranışına göre yeniden yazıldı (§4), §6.1/6.5/6.6 eklendi. Satır biçimi değişmediği için sürüm artmadı. |
