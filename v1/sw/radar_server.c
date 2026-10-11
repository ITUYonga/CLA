/* radar_server.c - KV260 PS sunucusu: radar zinciri + CLA + drone simulasyonu
 *
 * TCP 5001 , cok istemci (her baglanti bir thread). Protokol: kv260_proto.h , doc/protokol.md.
 * Radar kismi onceki surumle ayni davranir (CONFIG / RUN / PING) ; MATLAB ve radar GUI degismeden calisir.
 *
 * Derleme (kartta):
 *   gcc -O2 -ffp-contract=off -pthread -o radar_server radar_server.c sim_fizik.c -lm
 * Kartsiz deneme (PC , donanim yerine bellek , CLA yerine cla_ref.c):
 *   gcc -O2 -ffp-contract=off -pthread -DSAHTE_DONANIM -o radar_server_sahte radar_server.c sim_fizik.c cla_ref.c -lm
 *
 * Kilitler: radar_kilit (radar + DMA + DMA tamponu) , cla_kilit (CLA yazmaclari) , sim_kilit (sim_t , kayitlar).
 * Sira her zaman sim_kilit -> cla_kilit.
 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <math.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <pthread.h>
#include <sched.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/socket.h>
#include <time.h>
#include <unistd.h>

#include "kv260_proto.h"
#include "sim_fizik.h"
#include "drone_cla.h"
#ifdef SAHTE_DONANIM
#include "cla_ref.h"
#endif

#define RADAR_PHYS      0xA0000000UL
#define DMA_PHYS        0xB0000000UL
#define MAP_SIZE        0x10000UL
#define UDMABUF_DEV     "/dev/udmabuf0"
#define UDMABUF_PHYS    "/sys/class/u-dma-buf/udmabuf0/phys_addr"

#define NP              20
#define NR              1000
#define NSAMP           (NP * NR)
#define RX_BYTES        (NSAMP * 4)
#define TX_DEPTH        20
#define MAXDET          16

#define R_CTRL          0x00
#define R_STATUS        0x04
#define R_K             0x08
#define R_ALPHA         0x0C
#define R_LOGRATIO      0x10
#define R_MAXGAP        0x14
#define R_COUNT         0x18
#define R_OVERFLOW      0x1C
#define R_LATENCY       0x20
#define R_CPICOUNT      0x24
#define R_IDX           0x40
#define R_TX            0x80

#define ST_DONE         0x1
#define ST_TXLOADED     0x8

#define DMA_CR          0x00
#define DMA_SR          0x04
#define DMA_SA          0x18
#define DMA_SA_MSB      0x1C
#define DMA_LEN         0x28
#define DMA_SR_HALTED   0x00000001U
#define DMA_SR_ERR      0x00000070U
#define DMA_SR_IOC      0x00001000U

#define GOVDE_MAKS      (1u << 20)              /* bilinmeyen tipte atlanabilecek en buyuk govde */
#define CLA_ADIM_ZA_US  200                     /* sim adiminda CLA zaman asimi */
#define KAYIT_HALKA     256

/* ---- radar mesajlari (degismedi) ---- */
typedef struct __attribute__((packed)) {
    uint32_t k;
    int32_t  alpha;
    int32_t  logRatio;
    uint32_t maxGap;
    uint32_t tx[TX_DEPTH];
} config_t;

typedef struct __attribute__((packed)) {
    uint32_t status;
    uint32_t k;
    int32_t  alpha;
    int32_t  logRatio;
    uint32_t maxGap;
} config_ack_t;

typedef struct __attribute__((packed)) {
    uint32_t status;
    uint32_t count;
    uint32_t overflow;
    uint32_t latencyClk;
    uint32_t cpiCount;
    uint32_t rxUs;
    uint32_t idx[MAXDET];
} result_t;

typedef struct __attribute__((packed)) {
    uint32_t status;
    uint32_t cpiCount;
    uint32_t k;
    uint32_t alpha;
} pong_t;

static volatile uint32_t *radar;
static volatile uint32_t *dma;
static volatile uint32_t *rxBuf;
static volatile uint32_t *cla;
static uint64_t rxPhys;
static int cla_ok;                              /* KIMLIK dogru */

static pthread_mutex_t radar_kilit = PTHREAD_MUTEX_INITIALIZER;
static pthread_mutex_t cla_kilit   = PTHREAD_MUTEX_INITIALIZER;
static pthread_mutex_t sim_kilit   = PTHREAD_MUTEX_INITIALIZER;

static inline void     rw(uint32_t off, uint32_t v) { radar[off >> 2] = v; }
static inline uint32_t rr(uint32_t off)             { return radar[off >> 2]; }
static inline void     dw(uint32_t off, uint32_t v) { dma[off >> 2] = v; }
static inline uint32_t dr(uint32_t off)             { return dma[off >> 2]; }
static inline void     cw(uint32_t off, uint32_t v) { cla[off >> 2] = v; }
static inline uint32_t cr(uint32_t off)             { return cla[off >> 2]; }

static uint64_t now_us(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000ULL + ts.tv_nsec / 1000;
}

/* =================================================================== donanim */
#ifndef SAHTE_DONANIM
static void *map_phys(int fd, unsigned long phys, size_t size)
{
    void *p = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, (off_t)phys);
    if (p == MAP_FAILED) {
        fprintf(stderr, "mmap 0x%lx: %s\n", phys, strerror(errno));
        exit(1);
    }
    return p;
}

static void hw_open(void)
{
    int memfd = open("/dev/mem", O_RDWR | O_SYNC);
    if (memfd < 0) {
        perror("/dev/mem (sudo ile calistir)");
        exit(1);
    }
    radar = map_phys(memfd, RADAR_PHYS, MAP_SIZE);
    dma   = map_phys(memfd, DMA_PHYS, MAP_SIZE);
    cla   = map_phys(memfd, CLA_PHYS, CLA_MAP_SIZE);

    FILE *f = fopen(UDMABUF_PHYS, "r");
    if (!f || fscanf(f, "%lx", (unsigned long *)&rxPhys) != 1) {
        fprintf(stderr, "%s okunamadi (u-dma-buf yuklu mu?)\n", UDMABUF_PHYS);
        exit(1);
    }
    fclose(f);
    if (rxPhys + RX_BYTES > 0x100000000ULL)
        fprintf(stderr, "UYARI: DMA tamponu 4 GB ustunde (0x%lx), DMA 32-bit ise ulasamaz\n",
                (unsigned long)rxPhys);

    int bfd = open(UDMABUF_DEV, O_RDWR | O_SYNC);
    if (bfd < 0) {
        perror(UDMABUF_DEV);
        exit(1);
    }
    rxBuf = mmap(NULL, RX_BYTES, PROT_READ | PROT_WRITE, MAP_SHARED, bfd, 0);
    if (rxBuf == MAP_FAILED) {
        perror("udmabuf mmap");
        exit(1);
    }
}
#else
static void hw_open(void)
{
    radar = calloc(MAP_SIZE / 4, 4);
    dma   = calloc(MAP_SIZE / 4, 4);
    cla   = calloc(CLA_MAP_SIZE / 4, 4);
    rxBuf = calloc(NSAMP, 4);
    if (!radar || !dma || !cla || !rxBuf)
        exit(1);
    radar[R_STATUS >> 2] = ST_TXLOADED;
    radar[R_K >> 2] = 20;
    radar[R_ALPHA >> 2] = 3072;
    cla[CR_KIMLIK >> 2] = CLA_KIMLIK_DEGER;
    rxPhys = 0;
}
#endif

/* =================================================================== radar (degismedi) */
static void dma_init(void)
{
    dw(DMA_CR, 0x4);
    for (int i = 0; i < 100000 && (dr(DMA_CR) & 0x4); i++)
        ;
    dw(DMA_CR, 0x1);
}

static uint32_t run_cpi(result_t *r)
{
    uint64_t t0;

    memset(r, 0, sizeof(*r));
#ifdef SAHTE_DONANIM
    return S_OK;                                /* sahte: radar zinciri yok , bos sonuc */
#endif
    if (!(rr(R_STATUS) & ST_TXLOADED))
        return S_TX_NOT_LOADED;

    rw(R_CTRL, 0x2);
    __sync_synchronize();

    if (dr(DMA_SR) & (DMA_SR_HALTED | DMA_SR_ERR))
        dma_init();
    dw(DMA_SR, DMA_SR_IOC);
    dw(DMA_SA, (uint32_t)rxPhys);
    dw(DMA_SA_MSB, (uint32_t)(rxPhys >> 32));
    dw(DMA_LEN, RX_BYTES);

    t0 = now_us();
    for (;;) {
        uint32_t sr = dr(DMA_SR);
        if (sr & DMA_SR_ERR) {
            fprintf(stderr, "DMA hata SR=0x%08x\n", sr);
            dma_init();
            return S_DMA_ERR;
        }
        if (sr & DMA_SR_IOC)
            break;
        if (now_us() - t0 > 100000)
            return S_DMA_TIMEOUT;
    }
    dw(DMA_SR, DMA_SR_IOC);

    t0 = now_us();
    while (!(rr(R_STATUS) & ST_DONE)) {
        if (now_us() - t0 > 1000000)
            return S_DONE_TIMEOUT;
    }

    r->count      = rr(R_COUNT);
    r->overflow   = rr(R_OVERFLOW);
    r->latencyClk = rr(R_LATENCY);
    r->cpiCount   = rr(R_CPICOUNT);
    for (int i = 0; i < MAXDET; i++)
        r->idx[i] = rr(R_IDX + 4 * i);
    rw(R_CTRL, 0x2);
    return S_OK;
}

static void handle_config(const config_t *c, config_ack_t *a)
{
    rw(R_K,        c->k);
    rw(R_ALPHA,    (uint32_t)c->alpha);
    rw(R_LOGRATIO, (uint32_t)c->logRatio);
    rw(R_MAXGAP,   c->maxGap);
    for (int i = 0; i < TX_DEPTH; i++)
        rw(R_TX + 4 * i, c->tx[i]);
    rw(R_CTRL, 0x1);

    a->status = S_TX_NOT_LOADED;
    for (int i = 0; i < 1000; i++) {
        if (rr(R_STATUS) & ST_TXLOADED) {
            a->status = S_OK;
            break;
        }
    }
    for (int i = 0; i < TX_DEPTH; i++) {
        if (rr(R_TX + 4 * i) != c->tx[i])
            a->status = S_TX_NOT_LOADED;
    }
    a->k        = rr(R_K);
    a->alpha    = (int32_t)rr(R_ALPHA);
    a->logRatio = (int32_t)rr(R_LOGRATIO);
    a->maxGap   = rr(R_MAXGAP);
    printf("CONFIG k=%u alpha=%d ratio=%d gap=%u status=%u\n",
           a->k, a->alpha, a->logRatio, a->maxGap, a->status);
}

/* =================================================================== CLA (cla_kilit tutularak cagrilir) */
static void cla_m2c_yaz(int ilk, int n, const uint32_t *v)
{
    for (int i = 0; i < n; i++)
        cw(CR_M2C + 4 * (ilk + i), v[i]);
}

static void cla_c2m_oku(int n, uint32_t *v)
{
    for (int i = 0; i < n; i++)
        v[i] = cr(CR_C2M + 4 * i);
}

/* maskedeki gorevleri tetikler , hepsinin PIE kesmesi IRQ_DURUM'a dusene kadar bekler */
static uint32_t cla_gorev(uint32_t maske, uint32_t za_us, uint32_t *gecen_us)
{
    uint64_t t0 = now_us();
#ifdef SAHTE_DONANIM
    cla_ref_calistir(maske, (const uint32_t *)&cla[CR_M2C >> 2], (uint32_t *)&cla[CR_C2M >> 2]);
    cla[CR_IRQ_DURUM >> 2] |= maske;
    (void)za_us;
    *gecen_us = (uint32_t)(now_us() - t0);
    return S_OK;
#else
    cw(CR_IRQ_DURUM, maske);                    /* W1C */
    cw(CR_MIFRC, maske);
    for (;;) {
        if ((cr(CR_IRQ_DURUM) & maske) == maske)
            break;
        if (now_us() - t0 > za_us) {
            *gecen_us = (uint32_t)(now_us() - t0);
            return S_CLA_TIMEOUT;
        }
    }
    *gecen_us = (uint32_t)(now_us() - t0);
    return S_OK;
#endif
}

static uint32_t cla_sifirla_ve_kur(void)
{
#ifndef SAHTE_DONANIM
    cw(CR_KONTROL, 1);
    usleep(10);
    cw(CR_KONTROL, 0);
#endif
    if (cr(CR_KIMLIK) != CLA_KIMLIK_DEGER)
        return S_KIMLIK;
    static const uint32_t mvect[8] = { DRONE_MVECT1, DRONE_MVECT2, DRONE_MVECT3, DRONE_MVECT4,
                                       DRONE_MVECT5, DRONE_MVECT6, DRONE_MVECT7, DRONE_MVECT8 };
    for (int i = 0; i < 8; i++)
        cw(CR_MVECT(i + 1), mvect[i]);
    cw(CR_MICLR, 0xFF);
    cw(CR_MICLROVF, 0xFF);
    cw(CR_MIER, DRONE_MIER);
    cw(CR_IRQ_MASKE, 0);                        /* polling ; irq hatti kullanilmiyor */
    cw(CR_IRQ_DURUM, 0xFF);
    return S_OK;
}

/* =================================================================== drone simulasyonu */
static sim_t sim;
static int sim_calisiyor, sim_kazanc_yaz, sim_sifirla_iste;
static uint32_t sim_asim, sim_cla_hata, sim_cla_us_son, sim_cla_us_maks;
static uint32_t c2m_son[CLA_MSJ_KELIME];
static sim_kayit_t kayit[KAYIT_HALKA];
static uint32_t kayit_say;                      /* toplam yazilan */

/* sim_kilit tutularak: CLA'yi kurar , kazanclari yazar , gorev 8 ile durumu sifirlar */
static uint32_t sim_cla_hazirla(void)
{
    uint32_t m2c[CLA_MSJ_KELIME], us, st;
    pthread_mutex_lock(&cla_kilit);
    st = cla_sifirla_ve_kur();
    if (st == S_OK) {
        sim_m2c_doldur(&sim, m2c);
        cla_m2c_yaz(0, CLA_MSJ_KELIME, m2c);
        st = cla_gorev(DRONE_GOREV_SIFIRLA, 1000, &us);
        cla_c2m_oku(C_DURUM_SAYI, c2m_son);
    }
    pthread_mutex_unlock(&cla_kilit);
    memset(c2m_son + C_DURUM_SAYI, 0, sizeof(c2m_son) - C_DURUM_SAYI * 4);
    sim_kazanc_yaz = sim_sifirla_iste = 0;
    sim_cla_us_maks = 0;
    return st;
}

/* bir 1 ms adimi ; sim_kilit tutularak */
static void sim_bir_adim(void)
{
    uint32_t m2c[CLA_MSJ_KELIME], c2m[CLA_MSJ_KELIME] = { 0 }, us = 0, st, maske;

    if (sim_sifirla_iste) {
        pthread_mutex_lock(&cla_kilit);
        st = cla_gorev(DRONE_GOREV_SIFIRLA, 1000, &us);
        cla_c2m_oku(C_DURUM_SAYI, c2m_son);
        pthread_mutex_unlock(&cla_kilit);
        if (st != S_OK)
            sim_cla_hata++;
        sim_sifirla_iste = 0;
    }

    sim_m2c_doldur(&sim, m2c);
    maske = sim_gorev_maske(&sim);

    pthread_mutex_lock(&cla_kilit);
    if (sim_kazanc_yaz) {
        cla_m2c_yaz(0, CLA_MSJ_KELIME, m2c);
        sim_kazanc_yaz = 0;
    } else {
        cla_m2c_yaz(0, M_KAZANC, m2c);          /* olcumler ; kazanclar M2C'de duruyor */
    }
    st = cla_gorev(maske, CLA_ADIM_ZA_US, &us);
    cla_c2m_oku(C_DURUM_SAYI, c2m);
#ifndef SAHTE_DONANIM
    if (cr(CR_MIOVF)) {
        sim_cla_hata++;
        cw(CR_MICLROVF, 0xFF);
    }
#endif
    pthread_mutex_unlock(&cla_kilit);

    sim_cla_us_son = us;
    if (us > sim_cla_us_maks)
        sim_cla_us_maks = us;
    if (st == S_OK) {
        sim_kayit_t *k = &kayit[kayit_say % KAYIT_HALKA];
        k->adim = sim.adim;
        k->gorev_maske = maske;
        memcpy(k->m2c, m2c, sizeof(m2c));
        memcpy(k->c2m_once, c2m_son, sizeof(c2m_son));
        memcpy(k->c2m_sonra, c2m, sizeof(c2m));
        kayit_say++;
        memcpy(c2m_son, c2m, sizeof(c2m));
        sim_c2m_al(&sim, c2m);
    } else {
        sim_cla_hata++;                         /* motor komutlari bir onceki adimda kalir */
    }
    sim_adim(&sim);
}

static void *sim_thread(void *arg)
{
    (void)arg;
    struct sched_param sp = { .sched_priority = 50 };
    if (pthread_setschedparam(pthread_self(), SCHED_FIFO, &sp) != 0)
        fprintf(stderr, "UYARI: sim thread SCHED_FIFO alamadi (sudo ile calistir) ; zamanlama titreyebilir\n");
    cpu_set_t cs;
    CPU_ZERO(&cs);
    CPU_SET(3, &cs);
    pthread_setaffinity_np(pthread_self(), sizeof(cs), &cs);

    struct timespec hedef;
    clock_gettime(CLOCK_MONOTONIC, &hedef);
    for (;;) {
        hedef.tv_nsec += SIM_DT_US * 1000;
        if (hedef.tv_nsec >= 1000000000L) {
            hedef.tv_nsec -= 1000000000L;
            hedef.tv_sec++;
        }
        clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &hedef, NULL);

        pthread_mutex_lock(&sim_kilit);
        if (sim_calisiyor)
            sim_bir_adim();
        pthread_mutex_unlock(&sim_kilit);

        struct timespec simdi;
        clock_gettime(CLOCK_MONOTONIC, &simdi);
        int64_t gec = (int64_t)(simdi.tv_sec - hedef.tv_sec) * 1000000000LL + (simdi.tv_nsec - hedef.tv_nsec);
        if (gec > SIM_DT_US * 1000LL) {         /* adim 1 ms'yi asti: yakalamaya calisma , yeniden hizala */
            if (sim_calisiyor)
                sim_asim++;
            hedef = simdi;
        }
    }
    return NULL;
}

static int sonlu(const float *v, int n)
{
    for (int i = 0; i < n; i++)
        if (!isfinite(v[i]))
            return 0;
    return 1;
}

static uint32_t handle_sim_config(const sim_config_t *c)
{
    float fz[8], kz[40];                        /* packed yapidan hizali kopya */
    memcpy(fz, &c->kutle_kg, sizeof(fz));
    memcpy(kz, c->kazanc, sizeof(kz));
    if (c->kazanc_n > 40 || c->bolen[0] != 1 || !sonlu(fz, 8) || !sonlu(kz, 40))
        return S_GECERSIZ_PRM;
    for (int i = 0; i < 4; i++)
        if (c->bolen[i] < 1 || c->bolen[i] > 1000)
            return S_GECERSIZ_PRM;
    if (c->kutle_kg <= 0 || c->kol_m <= 0 || c->ixx <= 0 || c->iyy <= 0 || c->izz <= 0 || c->kt <= 0 ||
        c->motor_tau_s <= 0)
        return S_GECERSIZ_PRM;
    pthread_mutex_lock(&sim_kilit);
    uint32_t st = S_MESGUL;
    if (!sim_calisiyor) {
        sim.kutle = c->kutle_kg; sim.kol = c->kol_m;
        sim.ixx = c->ixx; sim.iyy = c->iyy; sim.izz = c->izz;
        sim.kt = c->kt; sim.km = c->km; sim.motor_tau = c->motor_tau_s;
        memcpy(sim.bolen, c->bolen, sizeof(sim.bolen));
        memcpy(sim.kazanc, kz, sizeof(sim.kazanc));
        sim.kazanc_n = c->kazanc_n;
        sim_kazanc_yaz = 1;
        st = S_OK;
    }
    pthread_mutex_unlock(&sim_kilit);
    printf("SIM_CONFIG status=%u\n", st);
    return st;
}

static uint32_t handle_sim_cmd(const sim_cmd_t *c)
{
    uint32_t st = S_OK;
    float a[3], b[2];
    memcpy(a, c->a, sizeof(a));
    memcpy(b, c->b, sizeof(b));
    if (!sonlu(a, 3) || !sonlu(b, 2))
        return S_GECERSIZ_PRM;
    pthread_mutex_lock(&sim_kilit);
    switch (c->komut) {
    case SK_BASLAT:
        if (!cla_ok) {
            st = S_KIMLIK;
        } else if (!sim_calisiyor) {
            st = sim_cla_hazirla();
            sim_calisiyor = st == S_OK;
            sim_asim = sim_cla_hata = 0;
        }
        break;
    case SK_DURDUR:
        sim_calisiyor = 0;
        break;
    case SK_SIFIRLA:
        sim_sifirla(&sim);
        sim_sifirla_iste = 1;
        break;
    default:
        if (sim_komut(&sim, c->komut, a, b) != 0)
            st = S_GECERSIZ_PRM;
        break;
    }
    pthread_mutex_unlock(&sim_kilit);
    printf("SIM_CMD %u (%.2f %.2f %.2f | %.2f %.2f) status=%u\n", c->komut, a[0], a[1], a[2], b[0], b[1], st);
    return st;
}

/* telemetri + en son n kayit ; govde cagiranin tamponuna yazilir , boyut doner */
static uint32_t sim_telem_hazirla(uint32_t n, uint8_t *govde)
{
    sim_telem_t t;
    memset(&t, 0, sizeof(t));
    pthread_mutex_lock(&sim_kilit);
    t.status = S_OK;
    t.calisiyor = (uint32_t)sim_calisiyor;
    t.adim = sim.adim;
    t.asim = sim_asim;
    t.cla_hata = sim_cla_hata;
    memcpy(t.poz, sim.poz, sizeof(t.poz));
    memcpy(t.hiz, sim.hiz, sizeof(t.hiz));
    memcpy(t.euler, sim.euler, sizeof(t.euler));
    memcpy(t.acisal, sim.w, sizeof(t.acisal));
    memcpy(t.hedef, sim.hedef, sizeof(t.hedef));
    memcpy(t.motor, sim.u, sizeof(t.motor));
    memcpy(t.ruzgar, sim.ruzgar, sizeof(t.ruzgar));
    for (int i = 0; i < 3; i++)
        t.kestirim[i] = sim.kestirim[i] * sim.kutle;
    memcpy(t.motor_verim, sim.motor_verim, sizeof(t.motor_verim));
    t.ek_kutle = sim.ek_kutle;
    t.gozlemci = (uint32_t)sim.gozlemci;
    t.cla_us_son = sim_cla_us_son;
    t.cla_us_maks = sim_cla_us_maks;
    for (int i = 0; i < 4; i++)
        t.gorev_say[i] = c2m_son[C_SAY1 + i];
    t.darbe_aktif = sim.darbe_kalan_s > 0.0f;
#ifdef SAHTE_DONANIM
    t.sahte = 1;
#endif
    if (n > SIM_KAYIT_MAKS)
        n = SIM_KAYIT_MAKS;
    if (n > kayit_say)
        n = kayit_say;
    if (n > KAYIT_HALKA)
        n = KAYIT_HALKA;
    t.kayit_n = n;
    memcpy(govde, &t, sizeof(t));
    for (uint32_t i = 0; i < n; i++)            /* eskiden yeniye , ardisik */
        memcpy(govde + sizeof(t) + i * sizeof(sim_kayit_t), &kayit[(kayit_say - n + i) % KAYIT_HALKA],
               sizeof(sim_kayit_t));
    pthread_mutex_unlock(&sim_kilit);
    return (uint32_t)(sizeof(t) + n * sizeof(sim_kayit_t));
}

/* =================================================================== ag */
static int recv_all(int s, void *buf, size_t n)
{
    uint8_t *p = buf;
    while (n) {
        ssize_t r = recv(s, p, n, 0);
        if (r <= 0)
            return -1;
        p += r;
        n -= (size_t)r;
    }
    return 0;
}

static int send_msg(int s, uint8_t type, uint16_t cpi, const void *payload, uint32_t len)
{
    hdr_t h = { PROTO_MAGIC, type, 0, cpi, 0, len };
    if (send(s, &h, sizeof(h), len ? MSG_MORE : 0) != (ssize_t)sizeof(h))
        return -1;
    if (len && send(s, payload, len, 0) != (ssize_t)len)
        return -1;
    return 0;
}

static int send_hata(int s, const hdr_t *h, uint32_t status)
{
    hata_t e = { status, h->type };
    return send_msg(s, T_HATA, h->cpi, &e, sizeof(e));
}

static int govde_atla(int s, uint32_t n)
{
    uint8_t b[4096];
    while (n) {
        uint32_t k = n < sizeof(b) ? n : (uint32_t)sizeof(b);
        if (recv_all(s, b, k) < 0)
            return -1;
        n -= k;
    }
    return 0;
}

static int ofset_gecerli(uint32_t o) { return o < CLA_MAP_SIZE && (o & 3) == 0; }

/* bir mesaj ; -1 baglantiyi kapat */
static int mesaj(int s, const hdr_t *h, uint8_t *tmp)
{
    switch (h->type) {
    case T_PING: {
        if (h->len != 0)
            return -1;
        pthread_mutex_lock(&radar_kilit);
        pong_t g = { rr(R_STATUS), rr(R_CPICOUNT), rr(R_K), rr(R_ALPHA) };
        pthread_mutex_unlock(&radar_kilit);
        return send_msg(s, T_CEVAP(T_PING), h->cpi, &g, sizeof(g));
    }
    case T_CONFIG: {
        config_t c;
        config_ack_t a;
        if (h->len != sizeof(c) || recv_all(s, &c, sizeof(c)) < 0)
            return -1;
        pthread_mutex_lock(&radar_kilit);
        handle_config(&c, &a);
        pthread_mutex_unlock(&radar_kilit);
        return send_msg(s, T_CEVAP(T_CONFIG), h->cpi, &a, sizeof(a));
    }
    case T_RUN: {
        result_t r;
        if (h->len != RX_BYTES || recv_all(s, tmp, RX_BYTES) < 0)
            return -1;
        pthread_mutex_lock(&radar_kilit);
        uint64_t t0 = now_us();
        for (int i = 0; i < NSAMP; i++)
            rxBuf[i] = ((uint32_t *)tmp)[i];
        __sync_synchronize();
        r.status = run_cpi(&r);
        r.rxUs   = (uint32_t)(now_us() - t0);
        pthread_mutex_unlock(&radar_kilit);
        if (send_msg(s, T_CEVAP(T_RUN), h->cpi, &r, sizeof(r)) < 0)
            return -1;
        printf("CPI %u: status=%u count=%u ovf=%u lat=%u clk sure=%u us idx:",
               h->cpi, r.status, r.count, r.overflow, r.latencyClk, r.rxUs);
        for (uint32_t i = 0; i < r.count && i < MAXDET; i++)
            printf(" %u", r.idx[i]);
        printf("\n");
        return 0;
    }

    case T_CLA_INFO: {
        if (h->len != 0)
            return -1;
        cla_info_t ci;
        pthread_mutex_lock(&cla_kilit);
        ci.kimlik = cr(CR_KIMLIK);
        ci.kontrol = cr(CR_KONTROL);
        ci.mirun = cr(CR_MIRUN);
        ci.mifr = cr(CR_MIFR);
        ci.miovf = cr(CR_MIOVF);
        ci.mier = cr(CR_MIER);
        ci.irq_durum = cr(CR_IRQ_DURUM);
        pthread_mutex_unlock(&cla_kilit);
        ci.status = ci.kimlik == CLA_KIMLIK_DEGER ? S_OK : S_KIMLIK;
        pthread_mutex_lock(&sim_kilit);
        ci.sim_calisiyor = (uint32_t)sim_calisiyor;
        pthread_mutex_unlock(&sim_kilit);
        return send_msg(s, T_CEVAP(T_CLA_INFO), h->cpi, &ci, sizeof(ci));
    }
    case T_CLA_REGWR:
    case T_CLA_REGRD: {
        uint32_t boy = h->type == T_CLA_REGWR ? sizeof(cla_yaz_t) : 4;
        uint32_t n = h->len / boy;
        if (h->len % boy || n < 1 || n > CLA_RW_MAKS) {
            if (h->len > GOVDE_MAKS || govde_atla(s, h->len) < 0)
                return -1;
            return send_hata(s, h, S_GECERSIZ_PRM);
        }
        if (recv_all(s, tmp, h->len) < 0)
            return -1;
        uint32_t *g = (uint32_t *)tmp;
        uint32_t cev[2 + CLA_RW_MAKS];
        cev[0] = S_OK;
        cev[1] = n;
        for (uint32_t i = 0; i < n; i++)
            if (!ofset_gecerli(h->type == T_CLA_REGWR ? g[2 * i] : g[i]))
                cev[0] = S_GECERSIZ_OFS;
        int yaz = h->type == T_CLA_REGWR;
        if (cev[0] == S_OK && yaz) {
            pthread_mutex_lock(&sim_kilit);
            if (sim_calisiyor)
                cev[0] = S_MESGUL;
            pthread_mutex_unlock(&sim_kilit);
        }
        if (cev[0] == S_OK) {
            pthread_mutex_lock(&cla_kilit);
            for (uint32_t i = 0; i < n; i++) {
                if (yaz)
                    cw(g[2 * i], g[2 * i + 1]);
                else
                    cev[2 + i] = cr(g[i]);
            }
            pthread_mutex_unlock(&cla_kilit);
        }
        uint32_t clen = 8 + (!yaz && cev[0] == S_OK ? 4 * n : 0);
        return send_msg(s, h->type | 0x80, h->cpi, cev, clen);
    }
    case T_CLA_RUN: {
        cla_run_t q;
        cla_run_cevap_t a;
        memset(&q, 0, sizeof(q));
        memset(&a, 0, sizeof(a));
        if (h->len < 12 || h->len > sizeof(q)) {
            if (h->len > GOVDE_MAKS || govde_atla(s, h->len) < 0)
                return -1;
            return send_hata(s, h, S_GECERSIZ_PRM);
        }
        if (recv_all(s, &q, h->len) < 0)
            return -1;
        if (q.m2c_n > CLA_MSJ_KELIME || h->len != 12 + 4 * q.m2c_n || q.gorev_maske == 0 || q.gorev_maske > 0xFF) {
            a.status = S_GECERSIZ_PRM;
        } else {
            uint32_t za = q.zaman_asimi_us ? q.zaman_asimi_us : 10000;
            if (za > 1000000)
                za = 1000000;
            pthread_mutex_lock(&sim_kilit);
            int mesgul = sim_calisiyor;
            pthread_mutex_unlock(&sim_kilit);
            if (mesgul) {
                a.status = S_MESGUL;
            } else {
                uint32_t m2c[CLA_MSJ_KELIME], c2m[CLA_MSJ_KELIME], us = 0;
                memcpy(m2c, q.m2c, sizeof(m2c));
                pthread_mutex_lock(&cla_kilit);
                cla_m2c_yaz(0, (int)q.m2c_n, m2c);
                a.status = cla_gorev(q.gorev_maske, za, &us);
                a.irq_durum = cr(CR_IRQ_DURUM);
                a.miovf = cr(CR_MIOVF);
                cla_c2m_oku(CLA_MSJ_KELIME, c2m);
                pthread_mutex_unlock(&cla_kilit);
                a.gecen_us = us;
                memcpy(a.c2m, c2m, sizeof(c2m));
            }
        }
        return send_msg(s, T_CEVAP(T_CLA_RUN), h->cpi, &a, sizeof(a));
    }
    case T_CLA_RESET: {
        if (h->len != 0)
            return -1;
        uint32_t st;
        pthread_mutex_lock(&sim_kilit);
        if (sim_calisiyor) {
            st = S_MESGUL;
        } else {
            pthread_mutex_lock(&cla_kilit);
            st = cla_sifirla_ve_kur();
            pthread_mutex_unlock(&cla_kilit);
        }
        pthread_mutex_unlock(&sim_kilit);
        return send_msg(s, T_CEVAP(T_CLA_RESET), h->cpi, &st, sizeof(st));
    }

    case T_SIM_CONFIG: {
        sim_config_t c;
        if (h->len != sizeof(c)) {
            if (h->len > GOVDE_MAKS || govde_atla(s, h->len) < 0)
                return -1;
            return send_hata(s, h, S_GECERSIZ_PRM);
        }
        if (recv_all(s, &c, sizeof(c)) < 0)
            return -1;
        uint32_t st = handle_sim_config(&c);
        return send_msg(s, T_CEVAP(T_SIM_CONFIG), h->cpi, &st, sizeof(st));
    }
    case T_SIM_CMD: {
        sim_cmd_t c;
        if (h->len != sizeof(c)) {
            if (h->len > GOVDE_MAKS || govde_atla(s, h->len) < 0)
                return -1;
            return send_hata(s, h, S_GECERSIZ_PRM);
        }
        if (recv_all(s, &c, sizeof(c)) < 0)
            return -1;
        uint32_t st = handle_sim_cmd(&c);
        return send_msg(s, T_CEVAP(T_SIM_CMD), h->cpi, &st, sizeof(st));
    }
    case T_SIM_TELEM: {
        uint32_t n;
        if (h->len != 4 || recv_all(s, &n, 4) < 0)
            return -1;
        uint32_t boy = sim_telem_hazirla(n, tmp);
        return send_msg(s, T_CEVAP(T_SIM_TELEM), h->cpi, tmp, boy);
    }

    default:
        fprintf(stderr, "bilinmeyen tip 0x%02x (%u bayt)\n", h->type, h->len);
        if (h->len > GOVDE_MAKS || govde_atla(s, h->len) < 0)
            return -1;
        return send_hata(s, h, S_BILINMEYEN);
    }
}

static void *istemci(void *arg)
{
    int s = (int)(intptr_t)arg, one = 1;
    hdr_t h;
    uint8_t *tmp = malloc(RX_BYTES);            /* RUN govdesi ; telemetri cevabi da buraya sigar */

    setsockopt(s, IPPROTO_TCP, TCP_NODELAY, &one, sizeof(one));
    setsockopt(s, SOL_SOCKET, SO_KEEPALIVE, &one, sizeof(one));
    printf("istemci baglandi (fd %d)\n", s);
    while (tmp && recv_all(s, &h, sizeof(h)) == 0) {
        if (h.magic != PROTO_MAGIC) {
            fprintf(stderr, "gecersiz magic 0x%x\n", h.magic);
            break;
        }
        if (mesaj(s, &h, tmp) < 0)
            break;
    }
    free(tmp);
    close(s);
    printf("baglanti kapandi (fd %d)\n", s);
    return NULL;
}

int main(int argc, char **argv)
{
    int ls, one = 1, port = PROTO_PORT;
    struct sockaddr_in a;
    pthread_t th;

    if (argc > 1)
        port = atoi(argv[1]);
    setvbuf(stdout, NULL, _IOLBF, 0);
    signal(SIGPIPE, SIG_IGN);

    hw_open();
#ifdef SAHTE_DONANIM
    printf("SAHTE_DONANIM: radar bos sonuc doner , CLA yerine cla_ref.c\n");
#endif
    printf("RADAR=0x%lx DMA=0x%lx CLA=0x%lx buf=0x%lx\n", RADAR_PHYS, DMA_PHYS, CLA_PHYS, (unsigned long)rxPhys);
    printf("k=%u (20 olmali) alpha=%u (3072 olmali) status=0x%x\n", rr(R_K), rr(R_ALPHA), rr(R_STATUS));
    uint32_t kimlik = cr(CR_KIMLIK);
    cla_ok = kimlik == CLA_KIMLIK_DEGER;
    printf("CLA KIMLIK=0x%08x (%s) , program %d komut crc 0x%08x\n", kimlik,
           cla_ok ? "tamam" : "YANLIS: bitstream'de CLA yok ya da adres farkli", DRONE_CLA_KOMUT, DRONE_CLA_CRC);
#ifndef SAHTE_DONANIM
    dma_init();
    printf("DMA SR=0x%08x\n", dr(DMA_SR));
#endif
    sim_varsayilan(&sim);
    if (pthread_create(&th, NULL, sim_thread, NULL) != 0) {
        perror("sim thread");
        return 1;
    }

    ls = socket(AF_INET, SOCK_STREAM, 0);
    setsockopt(ls, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one));
    memset(&a, 0, sizeof(a));
    a.sin_family      = AF_INET;
    a.sin_addr.s_addr = htonl(INADDR_ANY);
    a.sin_port        = htons((uint16_t)port);
    if (bind(ls, (struct sockaddr *)&a, sizeof(a)) < 0 || listen(ls, 8) < 0) {
        perror("bind/listen");
        return 1;
    }
    printf("TCP %d dinleniyor (cok istemci)\n", port);

    for (;;) {
        int s = accept(ls, NULL, NULL);
        if (s < 0)
            continue;
        if (pthread_create(&th, NULL, istemci, (void *)(intptr_t)s) != 0) {
            close(s);
            continue;
        }
        pthread_detach(th);
    }
}
