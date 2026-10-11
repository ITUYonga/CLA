# RoC CFAR

## Genel Bakış

Bu repo, Teknofest kapsamında geliştirilen Radar on Chip (RoC) projesinin donanım tarafını içerir. Projenin amacı, bir radar sinyal işleme zincirini FPGA üzerinde gerçeklemek ve bu sistemi bir uçak maketine yerleştirerek havada gerçek zamanlı hedef tespiti yapabilen çalışır bir prototip ortaya koymaktır.

## Amaç

Radar sinyal işleme adımları (eşleştirilmiş filtre, hareketli hedef göstergesi, pencereleme, Fourier dönüşümü, sabit yanlış alarm oranlı tespit ve son işleme) klasik olarak bir bilgisayarda yazılım olarak koşulur. Bu proje kapsamında aynı zincir bir FPGA üzerinde donanım olarak gerçeklenecek ve bu sayede düşük gecikme, gerçek zamanlı çalışma potansiyeli ve düşük güç tüketimiyle taşınabilir bir radar sistemi elde edilmesi hedeflenmektedir.

## Kapsam

Bu fazda sistem, gerçek bir RF alıcı yerine test amaçlı üretilmiş sinyallerle çalışacaktır. Giriş verisi bir host bilgisayardan sağlanacak ve FPGA üzerindeki işleme zincirinin doğruluğu bu veriler üzerinden doğrulanacaktır. Gerçek bir RF sensöre bağlanma ve canlı veriyle çalışma ayrı bir faz olarak planlanmıştır ve bu reponun mevcut kapsamının dışındadır.

## Golden Model İlişkisi

Projenin doğrulama referansı, bu repoda `golden_model/` klasöründe bulunan (geçmişi korunarak eski `aviation-rsp-matlab` reposundan taşındı) ve tamamen yazılımsal olarak çalışan bir MATLAB simülasyonudur. Bu simülasyon golden model olarak adlandırılır ve floating point aritmetiğiyle çalışan, doğruluğu teyit edilmiş bir radar sinyal işleme zincirini temsil eder. FPGA üzerinde gerçeklenen her blok, golden modeldeki karşılığıyla karşılaştırılarak doğrulanacaktır.

Golden modelin girdi ve çıktı arayüzlerine ilişkin güncel doküman `golden_model/docs/FPGA_GOLDEN_MODEL_VERI_DOKUMANI.md` dosyasıdır. `golden_model_doc` klasöründeki eski arayüz dokümanı eskimiştir (CFAR parametreleri değişti). Referans alınan akademik kaynak da aynı klasörde yer almaktadır.

## Metodoloji

Sistem, FPGA üzerinde işlemci tarafı (PS) ve programlanabilir mantık tarafı (PL) olmak üzere iki bölümden oluşacak şekilde tasarlanmaktadır. Sinyal işleme zincirinin tamamı PL tarafında gerçeklenecek, PS tarafı ise veri aktarımının yönetiminden sorumlu olacaktır.

Mevcut fazda test verisi host bilgisayardan gönderilir, PS tarafındaki bellekte tutulur ve AXI DMA aracılığıyla PL tarafına aktarılır. İşleme zincirinin ürettiği sonuç aynı yolla geri host tarafına iletilir.

Sayısal gösterim için 16 bit sabit noktalı format kullanılması planlanmaktadır. Bu tercih hem donanım kaynak kullanımını verimli kılmak hem de hedeflenen düşük gecikme ve gerçek zamanlı çalışma performansına katkı sağlamak amacıyla yapılmıştır. Sinyal genliğinin geniş bir dinamik aralığa sahip olması nedeniyle, sabit noktalı gösterime geçişte ölçekleme stratejisi ayrı bir tasarım konusu olarak ele alınacaktır.

## Beklenen Çıktılar

Bu çalışmanın sonunda aşağıdaki çıktıların elde edilmesi hedeflenmektedir.

Golden model ile tutarlı çalışan, tespit performansı (Pd ve Pfa değerleri) açısından golden modele yakın sonuçlar üreten bir FPGA gerçeklemesi.

FPGA üzerinde düşük gecikmeli ve gerçek zamanlıya yakın çalışan bir sinyal işleme zinciri.

Golden model çıktıları ile FPGA çıktılarının karşılaştırıldığı bir doğrulama süreci ve buna ait sonuçlar.

Uçak maketine entegre edilebilecek, ileride gerçek bir RF sensörle çalışabilecek şekilde genişletilebilir bir sistem mimarisi.

## Mevcut Durum

Proje şu anda mimari tasarım aşamasındadır. Sinyal işleme zincirinin blok sırası ve PS ile PL arasındaki veri akışı belirlenmiştir. Golden modelin her bir bloğuna ait girdi ve çıktı boyutları çıkarılmış ve dokümante edilmiştir. Sabit yanlış alarm oranlı tespit bloğunun donanıma uygun tasarımı ve sabit noktalı gösterime geçişte kullanılacak ölçekleme stratejisi, üzerinde çalışılmakta olan açık konulardır.
