from .float32 import flush_denormal
from .float32 import bits_to_float
from .float32 import float_to_bits
from .float32 import is_zero


# --- MSTF bit konumlari (SPRUI10A Tablo 10-33, s.717-719) ---
LVF_BIT     = 0     # Latched overflow  - yapiskan
LUF_BIT     = 1     # Latched underflow - yapiskan
NF_BIT      = 2     # Negatif
ZF_BIT      = 3     # Sifir
TF_BIT      = 6     # Test bayragi
RND32_BIT   = 9     # 0 = sifira kes, 1 = en yakin cifte
MEALLOW_BIT = 11    # Korumali yazmaclara yazma izni
RPC_SHIFT   = 12    # RPC alani bit 23-12
RPC_MASK    = 0xFFF





class ClaState:
    def __init__(self):
        # Başlangıçta reset fonksiyonunu çağırarak değişkenleri tanımlıyoruz
        self.reset()

    def reset(self):
           self.mr = [0]*4
           self.mar = [0]*2
           self.mpc = 0x000
           self.mstf = 0x00000000

        

    def get_mr(self,i):
          return self.mr[i]&0xFFFFFFFF


    def set_mr(self,i, bits):
         # DIKKAT: burada flush_denormal YOK - bilerek.
         # MR yazmaclari tamsayi da tutar (MADD32, MAND32, MASR32...).
         # 5 sayisinin bit deseni 0x00000005 ve bu bir denormal desenidir;
         # bastirilsaydi butun kucuk tamsayilar sifirlanirdi. TI'nin kendi
         # MADD32 ornegi (s.590) bunu dogruluyor:
         #     MMOV32 MR0, @_A   ; MR0 = 1 (0x00000001)
         # Denormal bastirma yazmac yazmasinin degil, uc yerin kurali:
         #   - ZF/NF hesabi        -> update_nz  (Tablo 10-33 dipnot 3:
         #                            "...when configuring the ZF and NF flags")
         #   - kayan nokta sonucu  -> _sonuclandir
         #   - MCMPF32 girdileri / MMAXF32,MMINF32 ciktilari -> kendi komutlari
         bits = bits&0xFFFFFFFF
         self.mr[i] =  bits


    def get_mr_float(self ,i):
         return bits_to_float(self.mr[i]&0xFFFFFFFF)

    def set_mr_float(self , i , val):
         bits = float_to_bits(val)
         bits = bits&0xFFFFFFFF
         self.mr[i] =  flush_denormal(bits)

    def get_mar(self , i ) : 
           return self.mar[i]&0xFFFF    
        
    def set_mar(self , i, v): 
          v = v&0xFFFF
          self.mar[i] = v

    def advance_mpc(self , step= 2):
         self.mpc += step
         self.mpc = self.mpc & 0xFFF

    # ---------------- MSTF bit erisimi ----------------

    def _get_bit(self, bit):
        """MSTF'nin tek bir bitini oku."""
        return (self.mstf >> bit) & 1

    def _set_bit(self, bit, value):
        """MSTF'nin tek bir bitini kur veya temizle."""
        if value:
            self.mstf = self.mstf | (1 << bit)
        else:
            # ~ Python'da sonsuz bitli negatif uretir, 32 bite geri maskele
            self.mstf = self.mstf & ~(1 << bit) & 0xFFFFFFFF

    @property
    def nf(self):
        return self._get_bit(NF_BIT)

    @nf.setter
    def nf(self, v):
        self._set_bit(NF_BIT, v)

    @property
    def zf(self):
        return self._get_bit(ZF_BIT)

    @zf.setter
    def zf(self, v):
        self._set_bit(ZF_BIT, v)

    @property
    def lvf(self):
        return self._get_bit(LVF_BIT)

    @lvf.setter
    def lvf(self, v):
        self._set_bit(LVF_BIT, v)

    @property
    def luf(self):
        return self._get_bit(LUF_BIT)

    @luf.setter
    def luf(self, v):
        self._set_bit(LUF_BIT, v)

    # Proje dokumanindaki LUDF adi ile ayni bit
    ludf = luf

    @property
    def tf(self):
        return self._get_bit(TF_BIT)

    @tf.setter
    def tf(self, v):
        self._set_bit(TF_BIT, v)

    @property
    def rnd32(self):
        return self._get_bit(RND32_BIT)

    @rnd32.setter
    def rnd32(self, v):
        self._set_bit(RND32_BIT, v)

    @property
    def meallow(self):
        return self._get_bit(MEALLOW_BIT)

    @meallow.setter
    def meallow(self, v):
        self._set_bit(MEALLOW_BIT, v)

    @property
    def rpc(self):
        return (self.mstf >> RPC_SHIFT) & RPC_MASK

    @rpc.setter
    def rpc(self, value):
        # once alani temizle, sonra yerlestir - yoksa eski deger ile OR'lanir
        self.mstf = self.mstf & ~(RPC_MASK << RPC_SHIFT) & 0xFFFFFFFF
        self.mstf = self.mstf | ((value & RPC_MASK) << RPC_SHIFT)

    # ---------------- bayrak mantigi ----------------

    def update_nz(self , bits) : 
         bits = flush_denormal(bits)
         if(is_zero(bits) ):
            self.mstf = self.mstf|(1<<3) 

         else:
            self.mstf = self.mstf&(~(1<<3)) 

         if(((bits & 0x80000000) != 0) and  (not is_zero(bits))):
                self.mstf = self.mstf|(1<<2) 

         else:
              self.mstf = self.mstf&(~(1<<2)) 

            


    def latch_overflow(self):
          self.mstf = self.mstf|1

    def latch_underflow(self):
          self.mstf = self.mstf|(1<<1)      # DUZELTILDI: eskiden &0 idi, tum MSTF'yi siliyordu

    def clear_latched(self):
          """MSETFLG ve MMOV32 MSTF, mem32 bunlari temizleyebilir."""
          self.lvf = 0
          self.luf = 0

    def snapshot(self) -> dict:
         states = {
               
                    "mr" : self.mr.copy(),
                    "mar" : self.mar.copy() ,
                    "mpc" : self.mpc ,
                    "mstf" : self.mstf                   
               }

         return states