/* cla_ref.h - drone.casm gorevlerinin C karsiligi (SAHTE_DONANIM ve testler) */
#ifndef CLA_REF_H
#define CLA_REF_H

#include <stdint.h>

/* maskedeki gorevleri oncelik sirasiyla (1 , 2 , 3 , 4 , 8) kosturur ; c2m yerinde guncellenir */
void cla_ref_calistir(uint32_t maske, const uint32_t m2c[64], uint32_t c2m[64]);

#endif
