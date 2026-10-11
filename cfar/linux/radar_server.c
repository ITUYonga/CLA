#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/socket.h>
#include <time.h>
#include <unistd.h>

#define RADAR_PHYS      0xA0000000UL
#define DMA_PHYS        0xB0000000UL
#define MAP_SIZE        0x10000UL
#define UDMABUF_DEV     "/dev/udmabuf0"
#define UDMABUF_PHYS    "/sys/class/u-dma-buf/udmabuf0/phys_addr"

#define TCP_PORT        5001

#define NP              20
#define NR              1000
#define NSAMP           (NP * NR)
#define RX_BYTES        (NSAMP * 4)
#define TX_DEPTH        20
#define MAXDET          16

#define MAGIC           0x5244
#define T_CONFIG        0x01
#define T_RUN           0x02
#define T_PING          0x03
#define T_CONFIG_ACK    0x81
#define T_RESULT        0x82
#define T_PONG          0x83

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

#define S_OK            0
#define S_DMA_ERR       1
#define S_DMA_TIMEOUT   2
#define S_DONE_TIMEOUT  3
#define S_TX_NOT_LOADED 4

typedef struct __attribute__((packed)) {
    uint16_t magic;
    uint8_t  type;
    uint8_t  flags;
    uint16_t cpi;
    uint16_t rsv;
    uint32_t len;
} hdr_t;

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
static uint64_t rxPhys;

static inline void     rw(uint32_t off, uint32_t v) { radar[off >> 2] = v; }
static inline uint32_t rr(uint32_t off)             { return radar[off >> 2]; }
static inline void     dw(uint32_t off, uint32_t v) { dma[off >> 2] = v; }
static inline uint32_t dr(uint32_t off)             { return dma[off >> 2]; }

static uint64_t now_us(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000ULL + ts.tv_nsec / 1000;
}

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
    hdr_t h = { MAGIC, type, 0, cpi, 0, len };
    if (send(s, &h, sizeof(h), MSG_MORE) != (ssize_t)sizeof(h))
        return -1;
    if (len && send(s, payload, len, 0) != (ssize_t)len)
        return -1;
    return 0;
}

static void serve(int s)
{
    static uint8_t tmp[RX_BYTES];
    hdr_t h;

    for (;;) {
        if (recv_all(s, &h, sizeof(h)) < 0)
            return;
        if (h.magic != MAGIC) {
            fprintf(stderr, "gecersiz magic 0x%x\n", h.magic);
            return;
        }

        switch (h.type) {
        case T_PING: {
            pong_t g = { rr(R_STATUS), rr(R_CPICOUNT), rr(R_K), rr(R_ALPHA) };
            if (h.len != 0 || send_msg(s, T_PONG, h.cpi, &g, sizeof(g)) < 0)
                return;
            break;
        }
        case T_CONFIG: {
            config_t c;
            config_ack_t a;
            if (h.len != sizeof(c) || recv_all(s, &c, sizeof(c)) < 0)
                return;
            handle_config(&c, &a);
            if (send_msg(s, T_CONFIG_ACK, h.cpi, &a, sizeof(a)) < 0)
                return;
            break;
        }
        case T_RUN: {
            result_t r;
            uint64_t t0;
            if (h.len != RX_BYTES || recv_all(s, tmp, RX_BYTES) < 0)
                return;
            t0 = now_us();
            for (int i = 0; i < NSAMP; i++)
                rxBuf[i] = ((uint32_t *)tmp)[i];
            __sync_synchronize();
            r.status = run_cpi(&r);
            r.rxUs   = (uint32_t)(now_us() - t0);
            if (send_msg(s, T_RESULT, h.cpi, &r, sizeof(r)) < 0)
                return;
            printf("CPI %u: status=%u count=%u ovf=%u lat=%u clk sure=%u us idx:",
                   h.cpi, r.status, r.count, r.overflow, r.latencyClk, r.rxUs);
            for (uint32_t i = 0; i < r.count && i < MAXDET; i++)
                printf(" %u", r.idx[i]);
            printf("\n");
            break;
        }
        default:
            fprintf(stderr, "bilinmeyen tip %u\n", h.type);
            return;
        }
    }
}

int main(void)
{
    int ls, one = 1;
    struct sockaddr_in a;

    setvbuf(stdout, NULL, _IOLBF, 0);
    signal(SIGPIPE, SIG_IGN);

    hw_open();
    printf("RADAR=0x%lx DMA=0x%lx buf=0x%lx\n", RADAR_PHYS, DMA_PHYS, (unsigned long)rxPhys);
    printf("k=%u (20 olmali) alpha=%u (3072 olmali) status=0x%x\n",
           rr(R_K), rr(R_ALPHA), rr(R_STATUS));
    dma_init();
    printf("DMA SR=0x%08x\n", dr(DMA_SR));

    ls = socket(AF_INET, SOCK_STREAM, 0);
    setsockopt(ls, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one));
    memset(&a, 0, sizeof(a));
    a.sin_family      = AF_INET;
    a.sin_addr.s_addr = htonl(INADDR_ANY);
    a.sin_port        = htons(TCP_PORT);
    if (bind(ls, (struct sockaddr *)&a, sizeof(a)) < 0 || listen(ls, 1) < 0) {
        perror("bind/listen");
        return 1;
    }
    printf("TCP %d dinleniyor\n", TCP_PORT);

    for (;;) {
        int s = accept(ls, NULL, NULL);
        if (s < 0)
            continue;
        setsockopt(s, IPPROTO_TCP, TCP_NODELAY, &one, sizeof(one));
        printf("istemci baglandi\n");
        serve(s);
        close(s);
        printf("baglanti kapandi\n");
    }
}
