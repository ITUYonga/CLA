/* sim_fizik.c - quadrotor fizigi (aciklama: sim_fizik.h) */
#include "sim_fizik.h"

#include <math.h>
#include <string.h>

static inline uint32_t f2u(float f) { uint32_t u; memcpy(&u, &f, 4); return u; }
static inline float    u2f(uint32_t u) { float f; memcpy(&f, &u, 4); return f; }

#define G0 9.81f

void sim_varsayilan(sim_t *s)
{
    memset(s, 0, sizeof(*s));
    s->kutle     = 1.2f;
    s->kol       = 0.25f;
    s->ixx       = 0.012f;
    s->iyy       = 0.012f;
    s->izz       = 0.022f;
    s->kt        = 5.886f;                  /* 4 motor %50'de havada durur */
    s->km        = 0.016f;
    s->motor_tau = 0.02f;
    s->surtunme  = 0.3f;
    s->bolen[0] = 1; s->bolen[1] = 2; s->bolen[2] = 10; s->bolen[3] = 10;

    float *k = s->kazanc;
    k[K_KP_R_XY] = 0.12f;  k[K_KI_R_XY] = 0.0006f; k[K_KD_R_XY] = 0.6f;
    k[K_KP_R_Z]  = 0.3f;   k[K_KI_R_Z]  = 0.0003f; k[K_ILIM_R]  = 0.1f;  k[K_DLIM] = 0.25f;
    k[K_KA_XY]   = 6.0f;   k[K_KA_Z]    = 2.0f;    k[K_WMAX_XY] = 3.0f;  k[K_WMAX_Z] = 1.0f;
    k[K_KP_P_XY] = 1.0f;   k[K_KP_P_Z]  = 1.5f;    k[K_VMAX_XY] = 3.0f;  k[K_VMAX_Z] = 1.5f;
    k[K_KP_V_XY] = 2.5f;   k[K_KP_V_Z]  = 4.0f;
    k[K_KI_V_XY] = 0.005f; k[K_KI_V_Z]  = 0.01f;   k[K_ILIM_V]  = 6.0f;
    k[K_ACI_MAX] = 0.35f;  k[K_G] = G0;            k[K_INV_G] = 1.0f / G0;
    k[K_CT]      = s->kutle / (4.0f * s->kt);
    k[K_TMIN]    = 0.05f;  k[K_TMAX] = 0.95f;
    k[K_L1]      = 0.12f;  k[K_L2]   = 0.36f;      k[K_TS_OBS]  = 0.01f; k[K_ELIM] = 5.0f;
    k[K_YAW_REF] = 0.0f;   k[K_INV_CT] = 1.0f / k[K_CT];
    s->kazanc_n = K_SAYI;

    sim_sifirla(s);
}

void sim_sifirla(sim_t *s)
{
    memset(s->poz, 0, sizeof(s->poz));
    memset(s->hiz, 0, sizeof(s->hiz));
    memset(s->euler, 0, sizeof(s->euler));
    memset(s->w, 0, sizeof(s->w));
    memset(s->itki, 0, sizeof(s->itki));
    memset(s->u, 0, sizeof(s->u));
    memset(s->hedef, 0, sizeof(s->hedef));
    memset(s->ruzgar, 0, sizeof(s->ruzgar));
    memset(s->darbe, 0, sizeof(s->darbe));
    memset(s->kestirim, 0, sizeof(s->kestirim));
    s->darbe_kalan_s = 0.0f;
    for (int i = 0; i < 4; i++)
        s->motor_verim[i] = 1.0f;
    s->ek_kutle = 0.0f;
    s->gozlemci = 1;
    s->adim = 0;
}

uint32_t sim_gorev_maske(const sim_t *s)
{
    uint32_t m = 0;
    for (int i = 0; i < 4; i++)
        if (s->bolen[i] && s->adim % s->bolen[i] == 0)
            m |= 1u << i;
    return m;
}

void sim_m2c_doldur(const sim_t *s, uint32_t m2c[M_SAYI])
{
    float y = s->euler[2];
    float v[M_KAZANC] = {
        s->poz[0], s->poz[1], s->poz[2], s->hiz[0], s->hiz[1], s->hiz[2],
        s->euler[0], s->euler[1], y, s->w[0], s->w[1], s->w[2],
        s->hedef[0], s->hedef[1], s->hedef[2], cosf(y), sinf(y), s->gozlemci ? 1.0f : 0.0f,
        0.0f, 0.0f,
    };
    for (int i = 0; i < M_KAZANC; i++)
        m2c[i] = f2u(v[i]);
    for (int i = 0; i < 40; i++)
        m2c[M_KAZANC + i] = f2u(i < (int)s->kazanc_n ? s->kazanc[i] : 0.0f);
    for (int i = M_KAZANC + 40; i < M_SAYI; i++)
        m2c[i] = 0;
}

static float sinirla(float x, float a, float b) { return x < a ? a : (x > b ? b : x); }

void sim_c2m_al(sim_t *s, const uint32_t c2m[C_SAYI])
{
    for (int i = 0; i < 4; i++) {
        float u = u2f(c2m[C_U1 + i]);
        s->u[i] = isfinite(u) ? sinirla(u, 0.0f, 1.0f) : 0.0f;
    }
    for (int i = 0; i < 3; i++)
        s->kestirim[i] = u2f(c2m[C_EH_X + i]);
}

void sim_adim(sim_t *s)
{
    const float dt = SIM_DT;
    float m = s->kutle + s->ek_kutle;

    /* motorlar: birinci derece gecikme , verim */
    for (int i = 0; i < 4; i++) {
        float hedef = s->kt * s->u[i] * s->motor_verim[i];
        s->itki[i] += (hedef - s->itki[i]) * dt / s->motor_tau;
    }
    float F = s->itki[0] + s->itki[1] + s->itki[2] + s->itki[3];
    float tx = s->kol * (s->itki[1] - s->itki[3]);
    float ty = s->kol * (s->itki[2] - s->itki[0]);
    float tz = s->km * (s->itki[0] + s->itki[2] - s->itki[1] - s->itki[3]);

    /* donme: I w' = t - w x I w */
    float p = s->w[0], q = s->w[1], r = s->w[2];
    float pd = (tx - (s->izz - s->iyy) * q * r) / s->ixx;
    float qd = (ty - (s->ixx - s->izz) * p * r) / s->iyy;
    float rd = (tz - (s->iyy - s->ixx) * p * q) / s->izz;
    s->w[0] += pd * dt;
    s->w[1] += qd * dt;
    s->w[2] += rd * dt;
    p = s->w[0]; q = s->w[1]; r = s->w[2];

    float sr = sinf(s->euler[0]), cr = cosf(s->euler[0]);
    float sp = sinf(s->euler[1]), cp = cosf(s->euler[1]);
    float sy = sinf(s->euler[2]), cy = cosf(s->euler[2]);
    s->euler[0] += (p + (q * sr + r * cr) * sp / cp) * dt;
    s->euler[1] += (q * cr - r * sr) * dt;
    s->euler[2] += ((q * sr + r * cr) / cp) * dt;
    if (s->euler[2] > (float)M_PI)  s->euler[2] -= 2.0f * (float)M_PI;
    if (s->euler[2] < -(float)M_PI) s->euler[2] += 2.0f * (float)M_PI;

    /* oteleme: itki govde +z , yercekimi , hava surtunmesi (ruzgara gore) , darbe */
    float bx = cy * sp * cr + sy * sr;
    float by = sy * sp * cr - cy * sr;
    float bz = cp * cr;
    float f[3] = { F * bx, F * by, F * bz - m * G0 };
    for (int i = 0; i < 3; i++)
        f[i] += -s->surtunme * (s->hiz[i] - s->ruzgar[i]);
    if (s->darbe_kalan_s > 0.0f) {
        for (int i = 0; i < 3; i++)
            f[i] += s->darbe[i];
        s->darbe_kalan_s -= dt;
    }
    for (int i = 0; i < 3; i++) {
        s->hiz[i] += f[i] / m * dt;
        s->poz[i] += s->hiz[i] * dt;
    }

    /* zemin: z >= 0 ; yerdeyken asagi hareket ve devrilme yok */
    if (s->poz[2] <= 0.0f) {
        s->poz[2] = 0.0f;
        if (s->hiz[2] < 0.0f) {
            s->hiz[0] = s->hiz[1] = s->hiz[2] = 0.0f;
            s->w[0] = s->w[1] = s->w[2] = 0.0f;
            s->euler[0] = s->euler[1] = 0.0f;
        }
    }
    s->adim++;
}

/* SK_* kodlari kv260_proto.h ile ayni ; BASLAT / DURDUR sunucunun isi */
int sim_komut(sim_t *s, uint32_t komut, const float a[3], const float b[2])
{
    switch (komut) {
    case 3:                                             /* SK_SIFIRLA */
        sim_sifirla(s);
        return 0;
    case 4:                                             /* SK_HEDEF */
        s->hedef[0] = sinirla(a[0], -50.0f, 50.0f);
        s->hedef[1] = sinirla(a[1], -50.0f, 50.0f);
        s->hedef[2] = sinirla(a[2], 0.0f, 30.0f);
        return 0;
    case 5:                                             /* SK_RUZGAR */
        for (int i = 0; i < 3; i++)
            s->ruzgar[i] = sinirla(a[i], -15.0f, 15.0f);
        return 0;
    case 6:                                             /* SK_DARBE */
        for (int i = 0; i < 3; i++)
            s->darbe[i] = sinirla(a[i], -20.0f, 20.0f);
        s->darbe_kalan_s = sinirla(b[0], 0.0f, 2.0f);
        return 0;
    case 7: {                                           /* SK_MOTOR */
        int n = (int)b[0];
        if (n < 1 || n > 4)
            return -1;
        s->motor_verim[n - 1] = sinirla(b[1], 0.0f, 1.0f);
        return 0;
    }
    case 8:                                             /* SK_YUK */
        s->ek_kutle = sinirla(b[0], 0.0f, 1.0f);
        return 0;
    case 9:                                             /* SK_GOZLEMCI */
        s->gozlemci = b[0] != 0.0f;
        return 0;
    default:
        return -1;
    }
}

uint32_t sim_boyut(void) { return (uint32_t)sizeof(sim_t); }
