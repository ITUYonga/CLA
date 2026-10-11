# PC <-> KV260 Ethernet Protokolü (öneri)

Bu doküman, PC'de üretilen `rx` ve TX darbesinin Ethernet ile KV260'ın PS tarafına iletilmesi
ve sonucun PC'ye dönmesi için paket formatını tanımlar. PS tarafında veri PS belleğinde
toplanıp AXI DMA ile PL'e aktarılır (donanım README'si). Üst düzey kurgu ve gerekçeler
`FPGA_GOLDEN_MODEL_VERI_DOKUMANI.md` bölüm 9'dadır. Bu doküman bunun paket seviyesindeki
ayrıntısıdır.

Kod: `ethernet/radar_link.py` (paket biçimi), `ethernet/test_radar_link.py` (birim test).
Durum: **öneri.** PC tarafı yazılıp yerel ağda (loopback) denendi, kart üzerinde denenmedi.

## 1. Taşıma

- **UDP**, IPv4, PC ve kart doğrudan kabloyla, sabit IP (switch yok). TCP kullanılmıyor,
  çünkü yeniden iletim gecikmeyi belirsizleştiriyor ve karttaki yığın ağırlaşıyor.
- Portlar (öneri): kart `5005` (CONFIG ve RX'i dinler), PC `5006` (RESULT'ı dinler).
- Tüm alanlar **little endian** (ARM'de C struct'la doğrudan okunur).
- Veri: I ve Q ayrı `int16`, sırayla `I, Q, I, Q ...` (`.mem` dosyalarındaki 16 bit değerler).

## 2. Başlık (16 bayt, her pakette)

| Alan | Boyut | Anlam |
|---|---|---|
| `magic` | u16 | `0x5241` ('RA') |
| `version` | u8 | 1 |
| `type` | u8 | 1 = CONFIG, 2 = RX, 3 = RESULT |
| `cpi_id` | u32 | CPI sıra numarası (PC verir, kart sonuçta geri yazar) |
| `pri_idx` | u16 | RX: CPI içindeki darbe numarası, 0..19 |
| `seg` | u16 | RX: darbe içindeki paket numarası, 0..3 |
| `count` | u16 | Paketteki örnek (CONFIG, RX) ya da tespit (RESULT) sayısı |
| `flags` | u16 | Aşağıya bak |

## 3. Paketler

**CONFIG (PC -> kart), 116 bayt:** başlık, sonra 20 örnek TX darbesi (`I, Q` int16, **Q2.14**,
1.0 = 16384, pencerelenmiş, yani matched filter katsayısı), sonra 10 adet u16 parametre:
`n_pri, n_pulse, n_pulse_sample, nfft, num_ref, num_guard, k, threshold_factor, max_gap,
peak_ratio_q8` (`peak_ratio * 256`). Her oturumun başında bir kez gönderilir.

**RX (PC -> kart), 1016 bayt:** başlık + 250 örnek (1000 bayt). Bir darbe (PRI) = 1000
örnek = **4 paket** (`seg` 0..3), bir CPI = 20 darbe = **80 paket**. Paketler darbe sırasında
gider (darbe-major, `.mem` dosyalarıyla aynı sıra). `flags`: bit 0 = CPI'ın ilk paketi
(`pri 0, seg 0`), bit 1 = son paketi (`pri 19, seg 3`). 1016 + 28 (IP ve UDP) < 1500, yani
standart MTU'ya sığar, jumbo frame gerekmez.

**RESULT (kart -> PC), 56 bayt:** başlık, sonra `count` (u16), `overflow` (u16),
`idx[16]` (u16, 0 tabanlı menzil hücresi, artan, kalanı 0), `latency_cycles` (u32, PL
sayacı, "son örnek PL'e girdi -> tespit çıktı"). `flags` bit 0 = CPI eksik paketle işlendi,
sonuç geçersiz.

## 4. Akış

```
PC                                       Kart
CONFIG  ------------------------------>  parametreleri ve katsayıyı yükler
RX (cpi 0, 80 paket, arka arkaya) ----->  PS belleğinde toplar -> AXI DMA -> PL
   ... 20 ms sonra cpi 1 ...
                                  <-----  RESULT (cpi 0)
```

- **Zamanlama CPI seviyesinde:** PC bir CPI'ın 80 paketini arka arkaya yollar, sonraki CPI'ı
  20 ms'lik ızgarada gönderir. 1 ms'lik PRI zamanlamasını PC'de tutturmaya çalışmıyoruz
  (jitter). Kartta CPI için çift tampon olması beklenir.
- **Kayıp tespiti:** Kart, bir CPI'ın 80 paketinin (`pri`, `seg`) hepsi geldiğinde işlemeye
  başlar (paketler sırasız gelebilir). `F_LAST` paketi geldiği hâlde **son gelen paketten
  itibaren 5 ms** boyunca yeni paket gelmezse ve hâlâ eksik varsa RESULT'ı `F_INCOMPLETE` ile
  döner, CPI işlenmez. Yeniden iletim yok, PC CPI'ı atlanmış sayar. (Bekleme, `F_LAST`
  paketinden değil son gelen paketten sayılmalıdır. Sırasız gelen bir `F_LAST` paketi başa
  düşerse, ondan sayılan süre yüzünden geride kalan paketler yetişemeden CPI yanlışlıkla
  eksik ilan edilir. Loopback testinde bu hata bulundu.)
- **Veri hızı:** 80 x 1016 bayt / 20 ms ≈ 4 MB/s (~32 Mbit/s).

## 5. Bilinmeyenler (kart tarafı)

Repoda PS yazılımına dair bir şey yok. Şunlar netleşmeli: PS'te Linux mu bare-metal (lwIP) mi,
DMA'nın hangi arabellek düzeniyle kurulduğu (PL'in beklediği sıra `x(:)`, yani darbe-major),
paketlerin sırasız gelmesi durumunda PS'in ne yapacağı. Bu protokol paketleri numaralı
tuttuğu için sırasızlığı tolere edebilir.

## 6. Denemek için

Loopback (kart olmadan, sahte kart ile): `python ethernet/test_loopback.py <vektör klasörü>`
(örneğin `vectors/vec_nominal_nfft128`). Üç senaryoyu dener: normal CPI'lar, kayıp paket,
sırasız paket.

Gerçek karta göndermek için: `python ethernet/send_cpi.py <vektör klasörü> --host <kart IP>
--port 5005 --result-port 5006 --cpis 3`. Kart RESULT'ı `5006` portuna, gönderenin IP'sine
yollar.
