/* cla_ref.c - drone.casm gorevlerinin C karsiligi (yalniz SAHTE_DONANIM derlemesi ve testler icin)
 *
 * Islem sirasi CASM ile birebir ayni; -ffp-contract=off ile derlenince golden modelle bit bit ayni
 * C2M uretir (cla/cla_dongu.py --c-ref ile denetlenir). Kartta CLA bu isi yapar , bu dosya kullanilmaz.
 */
#include "cla_ref.h"
#include "sim_fizik.h"

#include <string.h>

static inline float F(uint32_t u) { float f; memcpy(&f, &u, 4); return f; }
static inline uint32_t U(float f) { uint32_t u; memcpy(&u, &f, 4); return u; }
static inline float kirp(float x, float lim) { x = x < lim ? x : lim; lim = -lim; return x > lim ? x : lim; }
static inline float mn(float a, float b) { return a < b ? a : b; }
static inline float mx(float a, float b) { return a > b ? a : b; }

#define K(i)  F(m[M_KAZANC + (i)])
#define M(i)  F(m[(i)])
#define C(i)  F(c[(i)])
#define W(i, x) (c[(i)] = U(x))

static void gorev1(const uint32_t *m, uint32_t *c)
{
    static const int w_i[3]  = { M_P, M_Q, M_R };
    float d[3];
    for (int a = 0; a < 3; a++) {
        int xy = a < 2;
        float w = M(w_i[a]);
        float e = C(C_WREF_X + a) - w;
        float ki = K(xy ? K_KI_R_XY : K_KI_R_Z) * e;
        float I = kirp(C(C_IR_X + a) + ki, K(K_ILIM_R));
        W(C_IR_X + a, I);
        float u = K(xy ? K_KP_R_XY : K_KP_R_Z) * e;
        u = u + I;
        if (xy) {
            float dw = w - C(C_WP_X + a);
            dw = K(K_KD_R_XY) * dw;
            u = u - dw;
        }
        W(C_WP_X + a, w);
        d[a] = kirp(u, K(K_DLIM));
    }
    float t = C(C_T), x;
    x = t - d[1]; x = x + d[2]; W(C_U1, mx(mn(x, 1.0f), 0.0f));
    x = t + d[1]; x = x + d[2]; W(C_U3, mx(mn(x, 1.0f), 0.0f));
    x = t + d[0]; x = x - d[2]; W(C_U2, mx(mn(x, 1.0f), 0.0f));
    x = t - d[0]; x = x - d[2]; W(C_U4, mx(mn(x, 1.0f), 0.0f));
    c[C_SAY1]++;
}

static void gorev2(const uint32_t *m, uint32_t *c)
{
    float e;
    e = C(C_ROLL_REF) - M(M_ROLL);   W(C_WREF_X, kirp(K(K_KA_XY) * e, K(K_WMAX_XY)));
    e = C(C_PITCH_REF) - M(M_PITCH); W(C_WREF_Y, kirp(K(K_KA_XY) * e, K(K_WMAX_XY)));
    e = K(K_YAW_REF) - M(M_YAW);     W(C_WREF_Z, kirp(K(K_KA_Z) * e, K(K_WMAX_Z)));
    c[C_SAY2]++;
}

static void gorev3(const uint32_t *m, uint32_t *c)
{
    for (int a = 0; a < 3; a++) {
        int xy = a < 2;
        float vr = K(xy ? K_KP_P_XY : K_KP_P_Z) * (M(M_HX + a) - M(M_PX + a));
        vr = kirp(vr, K(xy ? K_VMAX_XY : K_VMAX_Z));
        float ev = vr - M(M_VX + a);
        float dff = M(M_FF) - C(C_FF_ONCE);
        dff = dff * C(C_EH_X + a);
        float I = C(C_IV_X + a) + dff;
        float ki = K(xy ? K_KI_V_XY : K_KI_V_Z) * ev;
        I = kirp(I + ki, K(K_ILIM_V));
        W(C_IV_X + a, I);
        float acc = K(xy ? K_KP_V_XY : K_KP_V_Z) * ev;
        acc = acc + I;
        float ff = M(M_FF) * C(C_EH_X + a);
        W(C_AC_X + a, acc - ff);
    }
    float ax = C(C_AC_X), ay = C(C_AC_Y), cy = M(M_COSY), sy = M(M_SINY);
    float p1 = cy * ax, p2 = sy * ay;
    W(C_PITCH_REF, kirp((p1 + p2) * K(K_INV_G), K(K_ACI_MAX)));
    float r1 = sy * ax, r2 = cy * ay;
    W(C_ROLL_REF, kirp((r1 - r2) * K(K_INV_G), K(K_ACI_MAX)));
    W(C_FF_ONCE, M(M_FF));
    float r = M(M_ROLL), p = M(M_PITCH);
    float rr = r * r, pp = p * p;
    float tilt = rr + pp;
    tilt = 0.5f * tilt;
    tilt = 1.0f + tilt;
    float t = K(K_G) + C(C_AC_Z);
    t = K(K_CT) * t;
    t = t * tilt;
    W(C_T, mn(mx(t, K(K_TMIN)), K(K_TMAX)));
    c[C_SAY3]++;
}

static void gorev4(const uint32_t *m, uint32_t *c)
{
    float A = C(C_T) * K(K_INV_CT);
    float r = M(M_ROLL), p = M(M_PITCH), cy = M(M_COSY), sy = M(M_SINY);
    float am[3], x1, x2;
    x1 = cy * p; x2 = sy * r; am[0] = A * (x1 + x2);
    x1 = sy * p; x2 = cy * r; am[1] = A * (x1 - x2);
    x1 = r * r; x2 = p * p; x1 = x1 + x2; x1 = 0.5f * x1; x1 = 1.0f - x1; x1 = A * x1; am[2] = x1 - K(K_G);
    for (int a = 0; a < 3; a++) {
        float e = M(M_VX + a) - C(C_VH_X + a);
        float s = am[a] + C(C_EH_X + a);
        s = K(K_TS_OBS) * s;
        float vh = C(C_VH_X + a) + s;
        float l1 = K(K_L1) * e;
        W(C_VH_X + a, vh + l1);
        float l2 = K(K_L2) * e;
        W(C_EH_X + a, kirp(C(C_EH_X + a) + l2, K(K_ELIM)));
    }
    c[C_SAY4]++;
}

void cla_ref_calistir(uint32_t maske, const uint32_t m2c[64], uint32_t c2m[64])
{
    if (maske & 0x01) gorev1(m2c, c2m);
    if (maske & 0x02) gorev2(m2c, c2m);
    if (maske & 0x04) gorev3(m2c, c2m);
    if (maske & 0x08) gorev4(m2c, c2m);
    if (maske & 0x80) memset(c2m, 0, C_DURUM_SAYI * 4);
}
