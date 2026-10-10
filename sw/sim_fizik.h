/* sim_fizik.h - quadrotor fizigi + CLA mesaj RAM'i yerlesimi
 *
 * Kartta radar_server'in sim thread'i , PC'de kapali dongu testi (ctypes) ayni kodu kullanir.
 * Bagimsiz: libc + libm disinda bir sey istemez , donanima dokunmaz.
 *
 * Eksenler: dunya ENU (x dogu , y kuzey , z yukari) , govde FLU (x ileri , y sol , z yukari).
 * Euler ZYX: R = Rz(yaw) Ry(pitch) Rx(roll). Pozitif pitch burun asagi , +x yonunde ivme.
 * Motorlar ("+" yerlesim): 1 +x , 2 +y , 3 -x , 4 -y. 1 ve 3 saat yonunde (govdeye +z tork).
 */
#ifndef SIM_FIZIK_H
#define SIM_FIZIK_H

#include <stdint.h>

/* ---------------------------------------------------------------- M2C yerlesimi (32 bit kelime indeksi)
 * CLA adresi = 0x1500 + 2 * indeks , AXI ofseti = 0x100 + 4 * indeks
 */
enum {
    M_PX = 0, M_PY, M_PZ, M_VX, M_VY, M_VZ,
    M_ROLL, M_PITCH, M_YAW, M_P, M_Q, M_R,
    M_HX, M_HY, M_HZ, M_COSY, M_SINY, M_FF,             /* M_FF: gozlemci ileri beslemesi 1.0 / 0.0 */
    M_KAZANC = 20,                                       /* 20..59 : sim_config_t.kazanc[0..39] */
    M_SAYI = 64
};

/* kazanc indeksleri (M_KAZANC + K_...) */
enum {
    K_KP_R_XY = 0, K_KI_R_XY, K_KD_R_XY, K_KP_R_Z, K_KI_R_Z, K_ILIM_R, K_DLIM,
    K_KA_XY, K_KA_Z, K_WMAX_XY, K_WMAX_Z,
    K_KP_P_XY, K_KP_P_Z, K_VMAX_XY, K_VMAX_Z, K_KP_V_XY, K_KP_V_Z, K_KI_V_XY, K_KI_V_Z, K_ILIM_V,
    K_ACI_MAX, K_G, K_INV_G, K_CT, K_TMIN, K_TMAX,
    K_L1, K_L2, K_TS_OBS, K_ELIM, K_YAW_REF, K_INV_CT,
    K_SAYI
};

/* ---------------------------------------------------------------- C2M yerlesimi */
enum {
    C_U1 = 0, C_U2, C_U3, C_U4,
    C_WREF_X, C_WREF_Y, C_WREF_Z,                        /* gorev 2 -> 1 */
    C_ROLL_REF, C_PITCH_REF, C_T,                        /* gorev 3 -> 2 , 1 */
    C_IR_X, C_IR_Y, C_IR_Z, C_WP_X, C_WP_Y, C_WP_Z,      /* gorev 1 durumu */
    C_IV_X, C_IV_Y, C_IV_Z, C_AC_X, C_AC_Y, C_AC_Z,      /* gorev 3 durumu , komut ivmesi -> 4 */
    C_VH_X, C_VH_Y, C_VH_Z, C_EH_X, C_EH_Y, C_EH_Z,      /* gorev 4 durumu , kestirim (m/s^2) -> 3 */
    C_SAY1, C_SAY2, C_SAY3, C_SAY4,                      /* gorev calisma sayaclari (uint32) */
    C_FF_ONCE,                                           /* gorev 3: onceki M_FF (gozlemci gecisinde integral kaydirma) */
    C_DURUM_SAYI,                                        /* 0..C_DURUM_SAYI-1 : gorev 8'in sifirladigi , sunucunun okudugu */
    C_SAYI = 64
};

#define SIM_DT          0.001f
#define SIM_GOREV_TUM   0x8Fu                            /* 1-4 ve 8 */

typedef struct {
    /* parametreler (sim_config_t ile ayni anlam) */
    float kutle, kol, ixx, iyy, izz, kt, km, motor_tau;
    float surtunme;                                      /* dogrusal hava surtunmesi N/(m/s) */
    uint32_t bolen[4];
    float kazanc[40];
    uint32_t kazanc_n;

    /* durum */
    float poz[3], hiz[3], euler[3], w[3];
    float itki[4];                                       /* motor itkisi N (gecikmeli) */
    float u[4];                                          /* son CLA komutu 0..1 */
    float hedef[3];
    uint32_t adim;

    /* bozucular */
    float ruzgar[3];
    float darbe[3];
    float darbe_kalan_s;
    float motor_verim[4];
    float ek_kutle;
    int gozlemci;

    /* telemetri icin */
    float kestirim[3];                                   /* m/s^2 , C2M'den */
} sim_t;

void     sim_varsayilan(sim_t *s);                       /* 1.2 kg drone , ayarli kazanclar */
void     sim_sifirla(sim_t *s);                          /* durum ve bozucular , parametreler kalir */
uint32_t sim_gorev_maske(const sim_t *s);                /* bu adimda tetiklenecek gorevler */
void     sim_m2c_doldur(const sim_t *s, uint32_t m2c[M_SAYI]);
void     sim_c2m_al(sim_t *s, const uint32_t c2m[C_SAYI]);
void     sim_adim(sim_t *s);                             /* fizigi SIM_DT ilerletir , adim++ */
int      sim_komut(sim_t *s, uint32_t komut, const float a[3], const float b[2]);  /* SK_* ; 0 ok , -1 gecersiz */
uint32_t sim_boyut(void);                                /* sizeof(sim_t) , ctypes denetimi icin */

#endif
