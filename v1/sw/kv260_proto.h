/* kv260_proto.h - PC <-> kart TCP protokolu (radar + CLA + drone simulasyonu)
 *
 * Tek port (5001), cok istemci. Her mesaj: hdr_t (12 bayt) + govde (len bayt).
 * Butun alanlar little-endian, yapilar packed, float = IEEE-754 tek duyarlik.
 * Cevap tipi = istek tipi | 0x80. Bilinmeyen tip baglantiyi kapatmaz: T_HATA doner.
 *
 *   0x01-0x0F  radar        (degismedi: CONFIG, RUN, PING)
 *   0x10-0x1F  CLA alt seviye (hata ayiklama, sim calisirken yalniz okuma)
 *   0x20-0x2F  drone simulasyonu
 *   0x7F       T_HATA       (cevap: hata_t)
 */
#ifndef KV260_PROTO_H
#define KV260_PROTO_H

#include <stdint.h>

#define PROTO_MAGIC     0x5244
#define PROTO_PORT      5001
#define PROTO_SURUM     2                       /* 1: yalniz radar */

typedef struct __attribute__((packed)) {
    uint16_t magic;
    uint8_t  type;
    uint8_t  flags;                             /* 0 */
    uint16_t cpi;                               /* radar: CPI no ; digerleri: sira no, cevapta aynen doner */
    uint16_t rsv;
    uint32_t len;
} hdr_t;

/* ------------------------------------------------------------------ tipler */
#define T_CONFIG        0x01                    /* radar , radar_server.c'deki yapilar */
#define T_RUN           0x02
#define T_PING          0x03

#define T_CLA_INFO      0x10
#define T_CLA_REGWR     0x11
#define T_CLA_REGRD     0x12
#define T_CLA_RUN       0x13
#define T_CLA_RESET     0x14

#define T_SIM_CONFIG    0x20
#define T_SIM_CMD       0x21
#define T_SIM_TELEM     0x22

#define T_HATA          0x7F
#define T_CEVAP(t)      ((uint8_t)((t) | 0x80))

/* ------------------------------------------------------------------ status */
#define S_OK            0
#define S_DMA_ERR       1                       /* 1-4 radar */
#define S_DMA_TIMEOUT   2
#define S_DONE_TIMEOUT  3
#define S_TX_NOT_LOADED 4
#define S_CLA_TIMEOUT   5                       /* gorev zaman asiminda bitmedi */
#define S_GECERSIZ_OFS  6                       /* CLA penceresi disi / hizasiz ofset */
#define S_BILINMEYEN    7                       /* bilinmeyen tip */
#define S_MESGUL        8                       /* sim calisiyor: CLA'ya yazma reddedildi */
#define S_SIM_YOK       9                       /* sim yapilandirilmadi */
#define S_GECERSIZ_PRM  10                      /* uzunluk / parametre hatasi */
#define S_KIMLIK        11                      /* CLA KIMLIK yazmaci beklenen degil (yanlis bitstream) */

typedef struct __attribute__((packed)) {
    uint32_t status;
    uint32_t istek_tipi;
} hata_t;

/* ------------------------------------------------------------------ CLA yazmac haritasi (AXI ofseti) */
#define CLA_PHYS        0xA0010000UL
#define CLA_MAP_SIZE    0x1000UL
#define CLA_KIMLIK_DEGER 0x434C4101U

#define CR_MIFR         0x000
#define CR_MIOVF        0x004
#define CR_MICLR        0x008
#define CR_MICLROVF     0x00C
#define CR_MIFRC        0x010
#define CR_MIER         0x014
#define CR_MIRUN        0x018
#define CR_MCTL         0x01C
#define CR_MVECT(n)     (0x020 + 4 * ((n) - 1)) /* n = 1..8 */
#define CR_IRQ_DURUM    0x040                   /* R / W1C */
#define CR_IRQ_MASKE    0x044
#define CR_KONTROL      0x048                   /* bit0 CLA_SIFIRLA */
#define CR_KIMLIK       0x04C
#define CR_M2C          0x100                   /* 64 x 32 bit , paketli */
#define CR_C2M          0x200                   /* 64 x 32 bit , salt okunur */
#define CLA_MSJ_KELIME  64

/* ------------------------------------------------------------------ 0x10 CLA_INFO : govde yok */
typedef struct __attribute__((packed)) {
    uint32_t status;
    uint32_t kimlik;
    uint32_t kontrol;
    uint32_t mirun, mifr, miovf, mier;
    uint32_t irq_durum;
    uint32_t sim_calisiyor;                     /* 1 ise CLA'ya yazan mesajlar S_MESGUL doner */
} cla_info_t;

/* ------------------------------------------------------------------ 0x11 CLA_REGWR / 0x12 CLA_REGRD
 * istek : n x cla_yaz_t (REGWR) veya n x uint32 ofset (REGRD) , n = len / boyut , 1 <= n <= 128
 * Ofset 0x000-0xFFF araliginda ve 4'un kati olmali ; aksi halde hicbir sey yapilmaz , S_GECERSIZ_OFS.
 * cevap : status , n , (REGRD) n x uint32 deger
 */
#define CLA_RW_MAKS     128
typedef struct __attribute__((packed)) {
    uint32_t ofset;
    uint32_t deger;
} cla_yaz_t;

typedef struct __attribute__((packed)) {
    uint32_t status;
    uint32_t n;
} cla_rw_cevap_t;                               /* REGRD'de ardindan n x uint32 */

/* ------------------------------------------------------------------ 0x13 CLA_RUN
 * Sunucu sirasiyla: M2C[0..m2c_n-1] yazar , IRQ_DURUM'u temizler , MIFRC = gorev_maske ,
 * IRQ_DURUM & gorev_maske == gorev_maske olana kadar bekler (zaman_asimi_us) , C2M'nin tamamini okur.
 * MVECT ve MIER onceden REGWR ile kurulmus olmali.
 */
typedef struct __attribute__((packed)) {
    uint32_t gorev_maske;                       /* bit i : gorev i+1 */
    uint32_t zaman_asimi_us;                    /* 0 ise 10000 */
    uint32_t m2c_n;                             /* 0..64 */
    uint32_t m2c[CLA_MSJ_KELIME];               /* yalniz ilk m2c_n kelime gonderilir: len = 12 + 4*m2c_n */
} cla_run_t;

typedef struct __attribute__((packed)) {
    uint32_t status;
    uint32_t gecen_us;
    uint32_t irq_durum;
    uint32_t miovf;
    uint32_t c2m[CLA_MSJ_KELIME];
} cla_run_cevap_t;

/* ------------------------------------------------------------------ 0x14 CLA_RESET : govde yok
 * KONTROL = 1 , 1 us , KONTROL = 0. Gorev yazmaclari ve MVECT sifirlanir ; M2C , IRQ_MASKE korunur.
 * cevap : uint32 status (KIMLIK denetimi de yapilir)
 */

/* ================================================================== drone simulasyonu
 * Fizik PS'de 1 kHz kosar. Her adimda: olcum -> M2C , MIFRC (oran gruplari) , bitis bekle ,
 * C2M -> motor komutlari , fizik bir adim.
 *
 * Gorevler (oncelik: dusuk numara once):
 *   1 hiz dongusu + motor karistirici  her adim
 *   2 aci dongusu                      bolen[1] adimda bir
 *   3 konum / irtifa dongusu           bolen[2] adimda bir
 *   4 bozucu gozlemcisi                bolen[3] adimda bir
 *   8 durum sifirlama                  SK_SIFIRLA'da bir kez (C2M CPU'ya salt okunur , sifirlamayi CLA yapar)
 *
 * KURAL (golden tekrar icin): bir adimin sonucu yalniz (M2C , adim oncesi C2M , gorev_maske)'ye baglidir.
 * Kazanclar M2C'de , kalici durum (integraller , gozlemci) C2M'de tutulur ; L1/L2 yalniz gecici.
 */

#define SIM_DT_US       1000
#define SIM_KAYIT_MAKS  4

/* 0x20 SIM_CONFIG : cevap uint32 status. Sim duruyorken gonderilir (calisirken S_MESGUL). */
typedef struct __attribute__((packed)) {
    float    kutle_kg;                          /* govde */
    float    kol_m;                             /* merkez - motor */
    float    ixx, iyy, izz;                     /* kg m^2 */
    float    kt;                                /* itki katsayisi: F = kt * u , u 0..1 */
    float    km;                                /* tork / itki orani (yaw) */
    float    motor_tau_s;                       /* motor birinci derece gecikme */
    uint32_t bolen[4];                          /* gorev 1..4 tetik boleni , bolen[0] = 1 */
    uint32_t kazanc_n;                          /* 0..40 */
    float    kazanc[40];                        /* M2C kazanc alanina aynen yazilir (yerlesim: doc/protokol.md) */
} sim_config_t;

/* 0x21 SIM_CMD : cevap uint32 status */
#define SK_BASLAT       1
#define SK_DURDUR       2
#define SK_SIFIRLA      3                       /* drone (0,0,0) , bozucular kalkar , gorev 8 C2M durumunu sifirlar */
#define SK_HEDEF        4                       /* a = (x , y , z) m , NED degil ENU : z yukari */
#define SK_RUZGAR       5                       /* a = sabit ruzgar hizi (vx , vy , vz) m/s */
#define SK_DARBE        6                       /* a = kuvvet (fx , fy , fz) N , b0 = sure s */
#define SK_MOTOR        7                       /* b0 = motor no (1..4) , b1 = verim (0..1) */
#define SK_YUK          8                       /* b0 = ek kutle kg */
#define SK_GOZLEMCI     9                       /* b0 = 0 kapali , 1 acik (gorev 4 ileri beslemesi) */

typedef struct __attribute__((packed)) {
    uint32_t komut;
    float    a[3];
    float    b[2];
} sim_cmd_t;

/* 0x22 SIM_TELEM
 * istek : uint32 kayit_iste (0..4) - en son adimlarin golden kayitlari
 * cevap : sim_telem_t + kayit_n x sim_kayit_t
 */
typedef struct __attribute__((packed)) {
    uint32_t status;
    uint32_t calisiyor;
    uint32_t adim;                              /* 1 adim = 1 ms */
    uint32_t asim;                              /* 1 ms'yi asan adim sayisi */
    uint32_t cla_hata;                          /* zaman asimi / MIOVF sayisi */
    float    poz[3], hiz[3];                    /* m , m/s (ENU) */
    float    euler[3], acisal[3];               /* rad , rad/s : roll pitch yaw */
    float    hedef[3];
    float    motor[4];                          /* CLA cikisi 0..1 */
    float    ruzgar[3];                         /* uygulanan */
    float    kestirim[3];                       /* gorev 4'un kestirdigi dis kuvvet , N */
    float    motor_verim[4];
    float    ek_kutle;
    uint32_t gozlemci;
    uint32_t cla_us_son, cla_us_maks;           /* adim basina CLA bekleme suresi (MIFRC -> IRQ_DURUM) */
    uint32_t gorev_say[4];                      /* C2M sayaclari: gorev 1-4 kac kez kostu */
    uint32_t darbe_aktif;
    uint32_t sahte;                             /* 1: sunucu SAHTE_DONANIM ile derlenmis (CLA yerine cla_ref.c) */
    uint32_t kayit_n;
} sim_telem_t;

typedef struct __attribute__((packed)) {
    uint32_t adim;
    uint32_t gorev_maske;
    uint32_t m2c[CLA_MSJ_KELIME];               /* adimda CLA'nin gordugu M2C */
    uint32_t c2m_once[CLA_MSJ_KELIME];          /* adim oncesi C2M (kalici durum) */
    uint32_t c2m_sonra[CLA_MSJ_KELIME];         /* adim sonrasi C2M */
} sim_kayit_t;

#endif
