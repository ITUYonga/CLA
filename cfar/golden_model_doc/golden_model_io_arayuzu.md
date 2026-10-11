> **Bu doküman eskimiştir.** Güncel sürüm: `golden_model/docs/FPGA_GOLDEN_MODEL_VERI_DOKUMANI.md`.
> Değişenler: `k = 20`, `threshold_factor = 8`, CFAR referans penceresi 30 hücre (15 + 15),
> post-processing kuralı ve menzil indeks konvansiyonu.

# Golden Model Girdi Çıktı Arayüzü

Bu doküman donanım takımı için hazırlandı. Amacı şu, golden model dediğimiz bu MATLAB kodu her blokta hangi veriyi alıyor, hangi veriyi üretiyor, o veri kaç satır kaç sütun, tipi ne, bunları tek tek anlatmak. FPGA'de blokları nasıl tasarlayacağınız size kalmış, biz burada sadece "bu bloğa şu girer, bundan şu çıkar" sözleşmesini net yazıyoruz.

Kod tarafında referans dosya `main_radar_sim.m`. Oradaki üstteki parametre bloğunu değiştirirseniz aşağıdaki sayılar da değişir, o yüzden hangi parametre setiyle bu sayıların çıktığını da yazdım.

## 1. Önce Sabit Sayılar

Bu sayılar senaryodan bağımsız, sistemin temel ayarları. Donanımın da bunları bilmesi lazım çünkü buffer boyutları, döngü sayıları hep buradan geliyor.

| Parametre | Değer | Ne işe yarıyor |
|---|---|---|
| fs | 1.000.000 Hz | örnekleme frekansı |
| fc | 3.000.000.000 Hz | taşıyıcı frekans |
| tau | 20 mikrosaniye | tek darbenin genişliği |
| B | 400.000 Hz | LFM bant genişliği |
| PRI | 1 milisaniye | iki darbe arası süre |
| PRF | 1000 Hz | 1/PRI |
| c | 300.000.000 m/s | ışık hızı |
| lambda | 0.1 m | c/fc |
| N_PRI | 1000 örnek | bir PRI içindeki örnek sayısı, yani menzil ekseni derinliği |
| N_Pulse_Sample | 20 örnek | tek bir TX darbesinin kaç örnekten oluştuğu |
| N_Pulse | 20 | bir işlem bloğunda kaç darbe atıldığı, yavaş zaman ekseni derinliği |
| NFFT | 256 | Doppler FFT boyutu |
| noise_floor | -111 dBm | gürültü tabanı |
| num_ref | 30 | CFAR referans hücre sayısı |
| num_guard | 6 | CFAR koruma hücre sayısı |
| k | 15 | OS CFAR sıralamada kaçıncı elemanın seçildiği |
| threshold_factor | 3.8 | eşiği yükselten çarpan |
| peak_ratio | 0.5 | son işleme aşamasında iki komşu tepe oranı toleransı |
| max_gap | 15 | son işleme aşamasında iki komşu tespit arası izin verilen menzil hücresi farkı |

Önemli bir şeye dikkat çekmek istiyorum. N_Pulse_Sample ve N_Pulse şu an ikisi de 20 çıkıyor ama bunlar aynı şey değil. N_Pulse_Sample, tek bir darbenin içindeki örnek sayısı yani darbenin kendi uzunluğu. N_Pulse ise kaç tane darbe attığımız. Şu anki parametrelerle ikisi tesadüfen aynı sayıya denk geliyor, bu yüzden koda bakarken karıştırmayın, donanımda da bu iki sayıyı ayrı ayrı parametre olarak tutun, tau veya PRI değişirse bu eşitlik bozulur.

## 2. TX Darbesi

Kod: `func_lfm_gen.m`

Girdi olarak bir zaman dizisi ve bir chirp oranı alıyor, çıktı olarak karmaşık sayıdan oluşan bir dalga üretiyor.

Çıktı boyutu 1 satır 20 sütun, karmaşık sayı (gerçek ve sanal kısım var).

Bu dalganın genliği her zaman 1, yani her örnekte |I + jQ| = 1. Bu önemli çünkü sabit noktaya çevirirken bu darbe için dinamik aralık kaygınız yok, I ve Q her zaman -1 ile 1 arasında.

Sonra bu darbe `func_window_processing.m` ile pencereleniyor (Dolph Chebyshev pencere), boyut değişmiyor, hala 1 satır 20 sütun karmaşık. Bu pencerelenmiş hali hem eşleştirilmiş filtrenin katsayısı olarak kullanılıyor hem de gerçekte anten üzerinden atılan darbe olarak düşünülüyor.

## 3. RX Sinyali

Kod: `func_get_received_signal.m` içine `func_clutter_gen.m` çıktısı ekleniyor.

Bu iki fonksiyon golden modelin "sahte hedef üretme" kısmı, donanımınıza giren gerçek test verisi burada oluşuyor.

Çıktı boyutu 1000 satır 20 sütun, karmaşık sayı. Satır ekseni menzil örnekleri (N_PRI kadar), sütun ekseni darbe numarası (N_Pulse kadar).

Bu matrise iki şey eklenmiş durumda, hedeflerden gelen yankılar ve gürültü. Sonra ayrıca clutter matrisi (aynı boyutta, 1000x20 karmaşık) üstüne toplanıyor. Yani donanımın göreceği asıl giriş, hedef + gürültü + clutter hepsinin toplamı olan tek bir 1000x20 karmaşık matris.

Genlik aralığı hakkında not, bu matrisin içindeki değerler çok geniş bir aralıkta değişiyor. Yakın ve güçlü hedeflerin genliği ile uzak zayıf hedeflerin genliği arasında büyük fark var, sunumdaki grafiklerde -70dB ile -250dB arası görülüyor. Sabit noktaya geçerken bunu göz önünde bulundurmanız lazım, aşağıda son bölümde tekrar değineceğim.

## 4. Eşleştirilmiş Filtre (Matched Filter) Bloğu

Kod: `func_matched.m`

Girdi iki tane. Birincisi pencerelenmiş TX darbesi, 1x20 karmaşık. İkincisi RX matrisi, 1000x20 karmaşık.

İşlem şu, TX darbesinin zamanda ters çevrilmiş ve konjugesi alınmış hali, RX'in her sütunuyla (yani her darbeyle) ayrı ayrı konvolüsyona giriyor, 'same' modunda, yani çıktı uzunluğu girdiyle aynı kalıyor.

Çıktı boyutu 1000 satır 20 sütun, karmaşık sayı. Girdiyle aynı boyut, sadece içerik değişti.

## 5. MTI Bloğu

Kod: `func_mti.m`

Üç darbe sönümleyici uygulanıyor, denklem şu, x[p] = x[p] - 2x[p+1] + x[p+2].

Girdi eşleştirilmiş filtre çıktısı, 1000x20 karmaşık.

Çıktı 1000 satır 18 sütun, karmaşık sayı. Sütun sayısı 2 azaldı çünkü bu işlem son iki darbeyi referans olarak kullanıyor, kayan pencere mantığında ilerliyor.

## 6. Doppler Öncesi Pencereleme Bloğu

Kod: `func_window_processing.m` (aynı fonksiyon TX tarafında da kullanılmıştı, burada ikinci kez ama farklı eksende çağrılıyor)

Girdi MTI çıktısı, 1000x18 karmaşık.

Dolph Chebyshev pencere katsayıları darbe ekseni boyunca (18 elemanlı) çarpılıyor.

Çıktı boyut değişmeden 1000 satır 18 sütun, karmaşık.

## 7. FFT Bloğu

Kod: `func_fft_processing.m`

Girdi pencerelenmiş sinyal, 1000x18 karmaşık.

Bu blok darbe ekseni boyunca (sütun ekseni) FFT alıyor, FFT boyutu NFFT parametresine göre belirleniyor, şu an 256. 18 örnek 256'ya sıfır doldurularak tamamlanıyor, sonra fftshift ile sıfır frekans ortaya alınıyor.

Çıktı boyutu 1000 satır 256 sütun, karmaşık.

Elle çizdiğiniz diyagramda bu adımdan sonra 64 sütun yazmışsınız, ama golden modelde şu an 256 kullanılıyor. Bunun sebebi Doppler çözünürlüğünü artırmak. Donanımda 256 noktalı FFT mi yoksa daha küçük bir boyut mu (32 veya 64) kullanacağınıza siz karar vereceksiniz, kaynak ve çözünürlük arasında bir denge bu, ama golden modelin şu anki referans çıktısı 256 üzerinden hesaplanıyor, karşılaştırma yaparken bunu göz önünde bulundurun.

Not, bu FFT işlemi kod içinde üç yerde çağrılıyor, eşleştirilmiş filtre çıktısına, MTI çıktısına, ve pencerelenmiş MTI çıktısına. İlk ikisi sadece karşılaştırma grafiği için, asıl tespit zincirine giren sadece üçüncüsü, yani pencerelenmiş olan.

## 8. CFAR Bloğu

Kod: `func_ca_cfar.m` ve `func_os_cfar.m`. Tespit zincirinde asıl kullanılan OS CFAR, CA CFAR sadece karşılaştırma grafiği için hesaplanıyor, tespit kararına girmiyor.

Girdi, bir önceki adımdaki FFT çıktısı, 1000x256 karmaşık.

Bloğun ilk yaptığı iş, karmaşık sayıyı gerçek sayıya çevirmek, genliğin karesini alıyor (power = |data|^2). Yani mantıken CFAR'ın asıl işlediği veri 1000x256 boyutunda gerçek sayı, güç domaininde. Bu abs kare işlemini donanımda CFAR bloğunun içine mi koyarsınız yoksa ayrı bir blok olarak önüne mi koyarsınız, o size kalmış, golden modelde bu adım fonksiyonun ilk satırı.

OS CFAR'ın çıktısı iki tane.

Birincisi os_cfar_output, boyutu 1000x256, gerçek sayı. İçindeki değerler ya o hücrenin güç değeri (eşiği geçtiyse) ya da sıfır (geçmediyse). Yani bu bir 1/0 bayrak matrisi değil, eşiği geçen hücrelerde gerçek güç değerini taşıyor.

İkincisi os_threshold_map, boyutu 1000x256, gerçek sayı. Her hücre için hesaplanmış eşik değerini taşıyor, aynı güç domaininde.

## 9. Son İşleme (Post Processing) Bloğu

Kod: `func_cfar_post_processing.m`

Bu blok en dikkat etmeniz gereken yer, çünkü çıktısının boyutu sabit değil.

Girdi iki tane. FFT çıktısı (1000x256 karmaşık, genlik almak için kullanılıyor) ve os_threshold_map (1000x256 gerçek).

Blok önce her menzil hücresi için, 256 Doppler hücresinin en büyüğünü alıyor. Yani 1000x256 matrisi 1000x1 vektöre indiriyor, hem güç için hem eşik için ayrı ayrı. Bu şu demek, son karar sadece menzil eksenine bakılarak veriliyor, hangi Doppler hücresinde tepe olduğu bilgisi bu noktada kayboluyor. detected_idx içinde hız bilgisi yok, sadece menzil hücre numarası var.

Sonra bu 1000 elemanlık vektör üzerinde eşiği geçen bölgeler bulunuyor, komşu geçişler gruplanıyor, yan lob olabilecek yakın çift tespitler eleniyor.

Çıktı, detected_idx. Bu değişken uzunlukta bir gerçek sayı (tam sayı) dizisi. İçindeki her değer 1 ile 1000 arasında bir menzil hücre indeksi. Kaç elemanlı olacağı senaryoya göre değişir, kodda üst sınır yok. Örnek bir çalıştırmada 4 hedef tespit edilmiş, yani detected_idx 1x4 çıkmış, ama başka bir senaryoda 0 da olabilir 8 de olabilir.

Donanımda bunu literal olarak "değişken boyutlu dizi" şeklinde tasarlayamazsınız, bunu biliyorsunuzdur zaten ama yine de yazayım, sabit boyutlu bir buffer (örneğin en fazla 16 veya 32 tespit) artı kaç tanesinin geçerli olduğunu söyleyen ayrı bir sayaç sinyali şeklinde tasarlamanız gerekecek. Elle çizdiğiniz diyagramda çıkışı "1x1" olarak göstermişsiniz, bu golden modelin gerçek davranışıyla uyuşmuyor, tek bir tarama sonucunda birden fazla hedef tespit edilebiliyor.

## 10. Performans Fonksiyonu

Kod: `func_performance.m`

Bunu ayrıca belirtiyorum çünkü karıştırılmasın, bu fonksiyon donanımın parçası değil. Sadece golden modelin kendi kendini sınaması için var, gerçek hedef konumlarını (R, v) detected_idx ile karşılaştırıp Pd, Pfa, SNR hesaplıyor ve ekrana yazdırıyor. Donanım tarafında böyle bir blok olmayacak, ama doğrulama yaparken FPGA çıktınızı bu fonksiyonun mantığıyla karşılaştırabilirsiniz.

## 11. Uçtan Uca Özet Tablo

| Blok | Girdi boyutu | Girdi tipi | Çıktı boyutu | Çıktı tipi |
|---|---|---|---|---|
| TX darbe üretimi | 1x20 | karmaşık | 1x20 | karmaşık |
| TX pencereleme | 1x20 | karmaşık | 1x20 | karmaşık |
| RX üretimi (hedef+clutter+gürültü) | çeşitli senaryo parametreleri | gerçek/karmaşık karışık | 1000x20 | karmaşık |
| Eşleştirilmiş filtre | 1x20 ve 1000x20 | karmaşık | 1000x20 | karmaşık |
| MTI | 1000x20 | karmaşık | 1000x18 | karmaşık |
| Doppler pencereleme | 1000x18 | karmaşık | 1000x18 | karmaşık |
| FFT | 1000x18 | karmaşık | 1000x256 | karmaşık |
| CFAR (OS) | 1000x256 | karmaşık (içeride gerçek güce çevriliyor) | 1000x256 + 1000x256 | gerçek (os_cfar_output ve os_threshold_map) |
| Son işleme | 1000x256 ve 1000x256 | karmaşık ve gerçek | değişken uzunluk, elemanlar 1 ile 1000 arası | gerçek tam sayı |

## 12. Donanım Tasarlarken Aklınızda Olsun Dediğim Noktalar

Birincisi, detected_idx sabit boyutlu değil, bunu üstte anlattım, en kritik fark bu.

İkincisi, FFT boyutu golden modelde 256, diyagramınızda 64 geçiyor, bu bir çelişki, hangisini kullanacağınıza karar verip bana söylerseniz golden model tarafında da aynı sayıyla karşılaştırma yapacak şekilde ayarlarım.

Üçüncüsü, RX matrisinin genlik aralığı çok geniş, 16 bit sabit noktaya geçerken hem yakın güçlü hedefi hem uzak zayıf hedefi aynı anda temsil etmek zorlaşabilir, bunu daha önce de konuşmuştuk, CFAR aşamasına geldiğinizde tekrar konuşuruz.

Dördüncüsü, detected_idx sadece menzil bilgisi taşıyor, hız (Doppler) bilgisi taşımıyor. Eğer sonuçta hem menzil hem hız raporlamak isterseniz, bu son işleme algoritmasının hangi Doppler hücresinde tepe bulunduğunu da saklayacak şekilde genişletilmesi gerekir, şu an golden model bunu yapmıyor.

Beşincisi, CA CFAR ve matched/MTI FFT çıktılarının bir kısmı (matched_fft_output, mti_fft_output, ca_threshold_map) sadece görselleştirme amaçlı, tespit kararına hiç girmiyor. Donanımda bunları üretmek zorunda değilsiniz, sadece golden modelle görsel karşılaştırma yapmak isterseniz lazım olur.
