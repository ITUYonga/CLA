# -*- coding: utf-8 -*-
# =====================================================================
#  core.py - TI TMS320F2803x CLA (Type-0) golden modeli, TEK DOSYA
# ---------------------------------------------------------------------
#  Referans: SPRUI10A Bolum 10 (s.565-720). Hedef: RTL == model == TRM.
#  Eski golden_model paketinin butun modulleri, sirasiyla:
#
#    float32       IEEE-754 tek duyarlik yardimcilari (denormal -> 0)
#    isa_table     komut tablosu (dosyanin sonunda gomulu: _ISA_KAYITLARI)
#    decoder       32 bit kelime -> komut
#    cla_state     mimari durum: MR0-3, MAR0-1, MPC, MSTF
#    cla_memory    bellek bolgeleri ve erisim kurallari (TRM 10.3)
#    cla_regs      CPU'nun gordugu CLA yazmaclari (MVECTx, MIFR, MIER ...)
#    ops_*         komut anlamlari (kestirim, float, int, donusum, bellek, denetim, paralel, dal)
#    dagitici      cozulmus komut -> ops fonksiyonu
#    erisim        boru hatti icin komut ozellikleri (okur/yazar/K2/okunan MR)
#    pipeline      8 kademeli boru hatti - ALTIN REFERANS
#    task_arbiter  gorev hakemi: oncelik, MIRUN, PIE kesmesi
#    cla_core      iki yurutme modeli: ardisik ve boru hatti
#    disassembler, assembler, lint, casm2hex   arac zinciri
#
#  Kullanim:
#    import core
#    st, mem = core.ClaState(), core.ClaMemory()
#    mem.load_program(core.assemble(open("gorev.casm").read()))
#    cekirdek = core.ClaCore(st, mem, core.Pipeline(st, mem))
#
#  RTL ile cevrim cevrim karsilastirma: test_karsilastirici.py
#  Bu dosya birlestirmeyle uretildi; bolum basliklari eski dosya adlaridir.
# =====================================================================

import struct
from math import isqrt
from fractions import Fraction
import re



# #####################################################################
#  float32.py
# #####################################################################

# =====================================================================
#  float32.py - IEEE-754 tek duyarlik yardimcilari
# ---------------------------------------------------------------------
#  bit <-> float donusumu, ozel desenler (0, inf, NaN, denormal) ve
#  denormal bastirma (+0). Aritmetigin yuvarlamasi ops_float.py'de.
# =====================================================================


POS_ZERO = 0x00000000
NEG_ZERO = 0x80000000
POS_INF    = 0x7F800000      # inf
NEG_INF    = 0xFF800000      # -inf
MIN_NORMAL = 0x00800000      # 1.1754943508222875e-38
MAX_NORMAL = 0x7F7FFFFF      # 3.4028234663852886e+38






def is_negative(bits: int) -> bool:
    """32-bit ham değerin işaret bitini (Bit 31) kontrol eder."""
    return bool((bits & 0xFFFFFFFF) & 0x80000000)


def is_inf(bits: int ) -> bool :
    is_mantis_zero  = not bool(bits & 0x007FFFFF)
    is_exp_one =  bits & 0x7F800000 == 0x7F800000
    return (is_exp_one & is_mantis_zero)

def is_nan(bits:int ) ->bool : 
    is_exp_one =  bits & 0x7F800000 == 0x7F800000
    is_mantis_zero  = not bool(bits & 0x007FFFFF)
    return (is_exp_one & (not is_mantis_zero))


def is_denormal(bits : int) -> bool : 
    is_exp_zero =  not bool(bits & 0x7F800000)
    is_mantis_zero  = not bool(bits & 0x007FFFFF)
    return (is_exp_zero & (not is_mantis_zero))

def flush_denormal(bits : int):
        bits &= 0xFFFFFFFF          # <-- bu satır
        if(is_denormal(bits)):
                bits =  POS_ZERO

        return bits



def bits_to_float(bits: int) -> float:
  """32-bit uint ham veriyi IEEE-754 float32 değerine dönüştürür."""
  packed = struct.pack(">I", bits & 0xFFFFFFFF)  # 32-bit uint (Big-endian)
  return struct.unpack(">f", packed)[0]  # Float32


def f32_repr(bits: int) -> str:
  """32-bit ham değeri '0xXXXXXXXX (değer)' formatında metne dönüştürür."""
  bits = bits & 0xFFFFFFFF
  f_val = bits_to_float(bits)

  # 08X: Başına 0 doldurarak tam 8 haneli büyük harf hex yazar
  return f"0x{bits:08X} ({f_val})"


def is_zero(bits: int ) -> bool:

    return bits&0x7FFFFFFF == 0




def float_to_bits(value: float) -> int:
  """Python float'ı (64-bit) 32-bit float'a daraltır ve ham uint32 değerini döndürür."""
  # 1. '>f': Değeri 32-bit float (4 bayt) olarak paketler (daraltma burada yapılır)
  # 2. '>I': Aynı 4 baytı 32-bit işaretsiz tamsayı olarak geri çözer
  packed = struct.pack('>f', float(value))
  return struct.unpack('>I', packed)[0]


# #####################################################################
#  isa_table.py
# #####################################################################

# =====================================================================
#  isa_table.py - komut tablosunu (isa/cla_type0.yaml) okur ve dogrular
# ---------------------------------------------------------------------
#  Tablo TRM'den tools/extract_isa.py ile uretilir; TRM'in dizgi hatalari
#  orada ELLE_DUZELTME sozlugunde duzeltilir. Yukleme maske cakismalarini
#  denetler (iki kayit ayni kelimeye uymamali).
# =====================================================================



# Komut tablosu (eski isa/cla_type0.yaml) bu dosyanin sonunda: _ISA_KAYITLARI

# COZULDU (21.09, cl2000 6.2.0): TRM s.590 MADD32'yi MF32TOUI16R ile ayni
# MSW 0x7EC0 ile basiyor - dizgi hatasi. TI'nin assembler'i MADD32'yi
# 0x7CC0 kodluyor (ucuncu yazmac alan komutlarin 0x7C00-0x7CE0 blogundaki
# bos slot). Tablo duzeltildi. Bkz. docs/model_kararlari.md §33.2
#  Bilinen (kabul edilmis) opcode cakismalari. cl2000 6.2.0 ile
#  MADD32/MF32TOUI16R celiskisi cozuldugu icin (TRM s.590 dizgi hatasi)
#  liste BOS. Yeni bir cakisma dogarsa test kirilir.
BILINEN_CAKISMALAR = []


class IsaTableError(Exception):
    """Tablo bozuk veya beklenen bicimde degil."""


_onbellek = None


def load_table(path=None, dogrula=True):
    """Komut tablosunu dondurur.

    Kayitlar spesifiklige gore sirali gelir: mask'inda en cok sabit bit olan
    once. Bugun decoder tum eslesmeleri topladigi icin sira sart degil, ama
    tablo buyudugunde ic ice gecen desenlerde dogru olani one alir.

    path verilirse onbellek atlanir (testlerde sahte tablo icin).
    """
    global _onbellek
    if path is None and _onbellek is not None:
        return _onbellek

    if path is None:
        ham = {"instructions": [dict(k) for k in _ISA_KAYITLARI]}
    else:                                   # baska bir tablo dosyasi (yalniz deneme icin)
        import yaml
        try:
            with open(path, encoding="utf-8") as dosya:
                ham = yaml.safe_load(dosya)
        except FileNotFoundError:
            raise IsaTableError("Komut tablosu bulunamadi: %s" % path)
        hedef = path
        if not isinstance(ham, dict) or "instructions" not in ham:
            raise IsaTableError("Tabloda 'instructions' anahtari yok: %s" % hedef)

    tablo = ham["instructions"]
    if not tablo:
        raise IsaTableError("Komut tablosu bos")

    tablo = sorted(tablo, key=lambda k: -bin(k["mask"]).count("1"))

    if dogrula:
        dogrula_tablo(tablo)

    if path is None:
        _onbellek = tablo
    return tablo


def onbellegi_temizle():
    """Testler tablo dosyasini degistirdiyse kullanilir."""
    global _onbellek
    _onbellek = None


def dogrula_tablo(tablo):
    """Yukleme aninda ucuz degismezleri kontrol eder.

    Amac tabloyu tekrar dogrulamak degil - bunlar tests/test_isa_table.py'de
    ayrica sinaniyor. Buradaki kontrol, bozuk bir tablo ile calismaya
    baslamayi engelleyen bir emniyet kemeri.
    """
    for k in tablo:
        ad = k.get("syntax", "<isimsiz>")

        if len(k["msw"]) != 16 or len(k["lsw"]) != 16:
            raise IsaTableError("%s: desen 16+16 karakter degil" % ad)

        # mask ve match, desenin kendisinden turemis olmali
        desen = k["msw"] + k["lsw"]
        beklenen_mask = 0
        beklenen_match = 0
        for konum, ch in enumerate(desen):
            if ch in "01":
                bit = 31 - konum
                beklenen_mask |= 1 << bit
                if ch == "1":
                    beklenen_match |= 1 << bit
        if k["mask"] != beklenen_mask:
            raise IsaTableError("%s: mask desenle uyusmuyor" % ad)
        if k["match"] != beklenen_match:
            raise IsaTableError("%s: match desenle uyusmuyor" % ad)

        # fields, tam olarak maske disi bitleri kaplamali
        alan_bitleri = set()
        for bitler in (k.get("fields") or {}).values():
            alan_bitleri |= set(bitler)
        serbest = set(b for b in range(32) if not (k["mask"] >> b) & 1)
        if alan_bitleri != serbest:
            raise IsaTableError(
                "%s: fields serbest bitleri kaplamiyor "
                "(eksik %s, fazla %s)"
                % (ad, sorted(serbest - alan_bitleri),
                   sorted(alan_bitleri - serbest)))


def find_collisions(tablo=None):
    """Ic ice gecen desen ciftlerini bulur.

    Iki komut, ortak sabit bitlerinde ayni degeri tasiyorsa ayni word'e
    uyabilir. Donanimda bu imkansizdir - decoder tek cevap uretmek
    zorundadir - yani boyle bir cift ya tabloda hata ya kilavuzda hatadir.

    Donen liste (syntax_a, syntax_b) ciftlerinden olusur.
    """
    if tablo is None:
        tablo = load_table()

    cakismalar = []
    for i in range(len(tablo)):
        for j in range(i + 1, len(tablo)):
            a, b = tablo[i], tablo[j]
            ortak = a["mask"] & b["mask"]
            if (a["match"] & ortak) == (b["match"] & ortak):
                cakismalar.append((a["syntax"], b["syntax"]))
    return cakismalar


def by_mnemonic(mnemonic, tablo=None):
    """Bir mnemonic'in tum kodlama bicimleri.

    Ornek: MMOV16'nin alti ayri formu var (MAR0/MAR1, mem16/MRa ...).
    """
    if tablo is None:
        tablo = load_table()
    return [k for k in tablo if k["mnemonic"] == mnemonic]


# #####################################################################
#  decoder.py
# #####################################################################

# =====================================================================
#  decoder.py - 32-bit komut kelimesini cozer
# ---------------------------------------------------------------------
#  Kural: (kelime & mask) == match (isa/cla_type0.yaml). Hicbir kayda
#  uymayan kelime IllegalOpcodeError (TRM s.576), birden fazla uyan
#  AmbiguousOpcodeError. Alan degerleri yaml'daki bit konumlarindan.
# =====================================================================



class IllegalOpcodeError(Exception):
        pass
class AmbiguousOpcodeError(Exception):
        pass
class DecodedInstruction:
        def __init__(self , word , mnemonic , syntax , fields , entry ):
                self.word = word
                self.mnemonic = mnemonic
                self.syntax = syntax
                self.fields = fields
                self.entry = entry



def decode(word)-> DecodedInstruction:
        instructions = load_table()
        decoded_instruction = None
        masks = [k["mask"] for k in instructions]
        matches = [k["match"] for k in instructions]
        match_count = 0
        for i,(mask,match) in enumerate(zip(masks,matches)):
                        if(word&mask == match):
                                if(match_count +1 >= 2):
                                        raise AmbiguousOpcodeError("Bu word ile eslesen birden fazla komut mevcut")

                                match_count += 1             
                                instruction_mnemonic = instructions[i]["mnemonic"]
                                instruction_syntax = instructions[i]["syntax"]
                                instruction_fields = instructions[i]["fields"]
                                
                                
                                field_values = {}
                               
                                for operand , bit_field in instruction_fields.items():
                                        field_value = 0
                                      
                                        for j in bit_field:
                                                holder = word
                                                for k in range(j):
                                                      holder = holder >> 1

                                                field_value = field_value<<1
                                                field_value += holder % 2        
                                                

                                        field_values[operand] = field_value
                                        
                                decoded_instruction = DecodedInstruction(word , instruction_mnemonic,  instruction_syntax, field_values, instructions[i])


        if decoded_instruction is None:
            raise IllegalOpcodeError("Gecersiz Komut")
        return decoded_instruction





        


# #####################################################################
#  cla_state.py
# #####################################################################

# =====================================================================
#  cla_state.py - mimari durum
# ---------------------------------------------------------------------
#  MR0-MR3 : 32 bit, ham bit olarak tutulur (tamsayi komutlari da kullanir);
#            float gorunumu get_mr_float / set_mr_float.
#  MAR0-1  : 16 bit yardimci (adres) yazmaclari.
#  MPC     : 12 bit, D2'deki komutun adresi (s.717).
#  MSTF    : bit duzeni s.718 - LVF 0, LUF 1, NF 2, ZF 3, TF 6, RND32 9,
#            MEALLOW 11, RPC 23:12. LVF/LUF yapiskandir (latch_*).
#  update_nz: s.653'teki kural - NF = bit31, ZF = 1 ve NF = 0 eger us == 0.
# =====================================================================



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


# #####################################################################
#  cla_memory.py
# #####################################################################

# =====================================================================
#  cla_memory.py - CLA'nin gordugu bellek: bes bolge ve erisim kurallari
# ---------------------------------------------------------------------
#  CLA->CPU mesaj RAM 0x1480 (128 word)   CLA okur/yazar, CPU yalniz okur
#  CPU->CLA mesaj RAM 0x1500 (128 word)   CLA yalniz okur (yazma yutulur)
#  L1 veri 0x8800 (1K), L2 veri 0x8C00 (1K), L3 program 0x9000 (4K)
#  Kurallar TRM 10.3 (s.571-573). Adresler 16-bit word adresi; 32-bit
#  erisimde tek adres alttaki cift adrese hizalanir (s.569).
#  Haritada olmayan adres (cevre birimleri dahil) hata verir - kapsam disi.
#  write_log: izin (trace.py) yazma kaynagi; yalniz etkili yazmalar.
# =====================================================================

class MemoryRegion:
    def __init__(self , name , start ,size_word ,read ,write , executable , cpu_read = True , cpu_write = True):
            self.name = name
            self.start = start
            self.size_word = size_word
            self.read = read              # CLA okuma izni
            self.write = write            # CLA yazma izni
            self.cpu_read = cpu_read      # CPU okuma izni
            self.cpu_write = cpu_write    # CPU yazma izni
            self.executable = executable
            self.words = [0]*size_word


class ClaMemory:

   

      def __init__(self):
        # Donanımsal bellek haritası sabit olarak içeride tanımlanır
        self.regions = [
            MemoryRegion(
                "CLAtoCPU_Msg",
                0x001480,
                128,
                read=True,
                write=True,
                executable=False,
                cpu_read=True,
                cpu_write=False,
            ),
            MemoryRegion(
                "CPUtoCLA_Msg",
                0x001500,
                128,
                read=True,
                write=False,
                executable=False,
                cpu_read=True,
                cpu_write=True,
            ),
            MemoryRegion(
                "L1_Data", 0x008800, 1024, read=True, write=True, executable=False,
                cpu_read=False, cpu_write=False
            ),
            MemoryRegion(
                "L2_Data", 0x008C00, 1024, read=True, write=True, executable=False,
                cpu_read=False, cpu_write=False
            ),
            MemoryRegion(
                "L3_Prog", 0x009000, 4096, read=False, write=False, executable=True,
                cpu_read=False, cpu_write=False
            ),
        ]
        self.write_log = []  # İz toplayıcı (Trace Collector)
        self.ignored_writes = 0       # donanimin sessizce yuttugu yazma sayisi
        self.unaligned_accesses = 0   # tek adresli 32-bit erisim sayisi (s.569)

      def _can_read(self, region, who):
                if who == "cla":
                    return region.read
                return region.cpu_read

      def _can_write(self, region, who):
                if who == "cla":
                    return region.write
                return region.cpu_write

      def region_of(self, addr: int):
                # CLAtoCPU Message RAM (128 words)
                if 0x001480 <= addr <= 0x0014FF:
                    return self.regions[0]

                # CPUtoCLA Message RAM (128 words)
                elif 0x001500 <= addr <= 0x00157F:
                    return self.regions[1]

                # L1 Veri RAM (1024 words)
                elif 0x008800 <= addr <= 0x008BFF:
                    return self.regions[2]

                # L2 Veri RAM (1024 words: 0x8C00 - 0x8FFF)
                elif 0x008C00 <= addr <= 0x008FFF:
                    return self.regions[3]

                # L3 Program RAM (4096 words: 0x9000 - 0x9FFF)
                elif 0x009000 <= addr <= 0x009FFF:
                    return self.regions[4]

                # Aradaki boşluklar veya harita dışındaki tüm adresler
                else:
                    raise ValueError(f"Tanımsız veya erişilemez bellek adresi: {hex(addr)}")
                            
            #who = cpu senaryosu ıcın ne yapılması gerektıgıne goz at !
      def read16(self , addr , who = "cla"):
                region = self.region_of(addr)
                if(self._can_read(region, who)):
                      return region.words[addr-region.start]&0xFFFF

                else:
                      return 0


      def write16(self , addr, value, who="cla"):
             value = value&0xFFFF
             region = self.region_of(addr)
             if(self._can_write(region, who)):
                    region.words[addr-region.start] = value
                    self.write_log.append((addr, value & 0xFFFF, 16))
                    return True

             self.ignored_writes += 1
             return False
            
                            
      def read32(self , addr, who="cla"):
                   if(addr % 2 != 0):
                        self.unaligned_accesses += 1
                        addr = addr-1

                   region = self.region_of(addr)
                   if(self._can_read(region, who)):
                         return ( region.words[addr-region.start+1] << 16 | region.words[addr-region.start]) &0xFFFFFFFF

                   else:
                         return 0 
                
                 
      def write32(self , addr, value, who="cla"):

                    if(addr % 2 != 0):
                            self.unaligned_accesses += 1
                            addr = addr-1

                    value = value&0xFFFFFFFF
                    region = self.region_of(addr)
                    if(self._can_write(region, who)):
                          region.words[addr-region.start] = value&0xFFFF
                          region.words[addr-region.start+1 ] = value>>16 & 0xFFFF
                          self.write_log.append((addr, value & 0xFFFFFFFF, 32))
                          return True
      
                    self.ignored_writes += 1
                    return False


      def fetch32(self, mpc):
                
                if mpc % 2 != 0:
                    self.unaligned_accesses += 1
                    mpc = mpc - 1

                
                # Bölgeyi değişkene alıp doğrudan kullanıyoruz
                region = self.regions[4]
                addr = region.start + mpc
                
                if not region.executable:
                    raise PermissionError(
                        f"Tanımsız veya erişilemez bellek adresi: {hex(addr)}"
                    )

                # Sinir kontrolu: Python negatif indekslemede SESSIZCE dizinin
                # sonundan okur. fetch32(-2) hata vermeden L3'un son komutunu
                # dondururdu. MPC 12 bite maskeli oldugu icin bugun erisilemez
                # ama MVECT yuklemesi mpc'ye dogrudan atama yapacak (Faz 6).
                if not 0 <= mpc < region.size_word - 1:
                    raise ValueError(
                        f"MPC L3 disinda: {mpc} (gecerli araligi 0-{region.size_word-2})"
                    )

                MSW = region.words[mpc+1] << 16
                LSW = region.words[mpc ]
                instruction = MSW | LSW
                return instruction

      def load_program(self, words, start_index = 0 ):
              region = self.regions[4]
              if start_index + len(words)*2 > region.size_word:
                     
                     raise ValueError("Program boyutu L3 RAM kapasitesini aşıyor!")
              
              for word in words:
                                       
                     region.words[start_index] = word&0xFFFF
                     region.words[start_index+1] = word>>16&0xFFFF
                     start_index += 2


# #####################################################################
#  cla_regs.py
# #####################################################################

# =====================================================================
#  cla_regs.py - CPU'nun gordugu CLA yazmaclari (TRM 10.7, s.704-720)
# ---------------------------------------------------------------------
#  MVECT1-8: gorev baslangic adresi (L3 icinde 12 bit).
#  MCTL: yalniz IACKE etkili; SOFTRESET/HARDRESET modellenmiyor.
#  MIFR, MIOVF, MIFRC, MICLR, MICLROVF, MIER, MIRUN: bayrak yazmaclari.
#  MPISRCSEL1: saklaniyor; tetik yonlendirmesi modellenmiyor (gorevler
#  yazilimla tetiklenir: task_arbiter.cevresel_istek, MIFRC).
#  cpu_read / cpu_write: yazmac ofsetiyle; her yazmacin kendi kurali.
# =====================================================================
class BaglanmamisKontrol(Exception):
    pass



class ClaRegs:

    def __init__(self ):

        self.reset()

    def reset(self):

        # SOFTRESET/HARDRESET modellenmiyor (kapsam disi, bkz. dosya basi)

        self.mvect = 8*[0X0000] # 0x00 - 0x07
        self.mctl = 0x0000 #0x10
        self.mpisrcse_lo = 0X0000 #0X14
        self.mpisrcse_hi= 0X0000 #0X15
        self.mifr = 0X0000 #0X20
        self.miovf = 0X0000 #0X21
        self.mifrc = 0X0000 #0X22
        self.miclr = 0X0000 #0X23
        self.miclrovf = 0X0000 #0X24
        self.mier = 0X0000 #0X25
        self.mirun = 0X0000 #0X26




    def cpu_read(self, ofset) -> int:

        match ofset:

            case x if 0x00<=x<=0x07:
                return self.mvect[x]


            case 0x10:
                  return self.mctl&0x0004


                  
            case 0x14:
                return self.mpisrcse_lo

            case  0x15:
                return self.mpisrcse_hi

            case 0x20:
                return self.mifr

            case 0x21:
                return self.miovf

            case 0x22:
                return 0

            case 0x23:
                return 0

            case 0x24:
                return 0

            case 0x25:
                return self.mier

            case 0x26:
                return self.mirun
            
            case _:

                raise BaglanmamisKontrol("Anlamsiz kontrol ofseti")







    def cpu_write(self, ofset, deger) -> None  :   # her yazmacin kendi kurali

                        match ofset:

                            case x if 0x00<=x<=0x07:
                                self.mvect[x] = deger & 0x0FFF

                            case 0x10:
                                 #SOFTRESET/HARDRESET simdilik yok sayiliyor
                                 if((deger>>2 )% 2 == 1):
                                      self.mctl = (self.mctl | 0x0004)& 0x00FF

                                 else:
                                      self.mctl = (self.mctl&0xFFFB)& 0x00FF


                            case 0x14 :
                                self.mpisrcse_lo = deger

                            case 0x15:
                                self.mpisrcse_hi = deger
                                  

                            case 0x20:
                                 pass

                            case 0x21:
                                pass

                            case 0x22:

                               
                              

                                if(deger == 0):
                                    
                                     pass

                                else:
                                        self.mifrc = deger&0x00FF
                                        self.mifr = (self.mifr|deger)&0X00FF
                                        self.mifrc = 0 
                                        

                                

                            case 0x23:
                                

                                    if(deger == 0):

                                        pass

                                    else:
                                        self.mifrc = deger&0x00FF
                                        self.mifr = (self.mifr&(deger^0b11111111))&0x00FF
                                        self.mifrc = 0                                

                                     

                            case 0x24:

                            

                                if(deger == 0):

                                     pass

                                else:

                                    self.mifrc = deger&0x00FF                       
                                    self.miovf = (self.miovf&(deger^0b11111111))&0x00FF
                                    self.mifrc = 0 

                            case 0x25:
                                self.mier = deger&0x00FF

                            case 0x26:
                                pass
                            
                            case _:

                                raise BaglanmamisKontrol("Anlamsiz kontrol ofseti")


    # ------------------------------------------------------------------
    #  snapshot - RTL karsilastirmasi ve cok gorevli testler icin
    # ------------------------------------------------------------------
    def snapshot(self) -> dict:
        """Yazmac durumunun kopyasi.  ClaState.snapshot() ile ayni bicim.

        MIFRC / MICLR / MICLROVF BILEREK DISARIDA. Bu uc adresin donanimda
        depolamasi olup olmadigi belirsiz (bkz. model_kararlari 14.6:
        blok diyagram 16-bit kutu ciziyor, alan tablosu "always reads back
        0" diyor). Gozlenebilir degerleri her halukarda 0 oldugu icin
        karsilastirmaya bir sey katmazlar; dahil edilirlerse RTL'de
        karsiligi olmayan uc satir uretip sahte fark cikarabilirler.

        MCTL ham deger olarak duruyor; icindeki tek kalici bit IACKE (2).
        """
        return {
            "mvect":      self.mvect.copy(),
            "mctl":       self.mctl,
            "mpisrcse_lo": self.mpisrcse_lo,
            "mpisrcse_hi": self.mpisrcse_hi,
            "mifr":       self.mifr,
            "miovf":      self.miovf,
            "mier":       self.mier,
            "mirun":      self.mirun,
        }


# #####################################################################
#  ops_estimate.py
# #####################################################################

# -*- coding: utf-8 -*-
# MEINVF32 / MEISQRTF32 kestirimleri - PROJE SOZLESMESI.
#
# TRM s.617 / s.618:
#     "generates an estimate of 1/X [1/sqrt(X)] in 32-bit floating-point
#      format accurate to approximately 8 bits ... will not generate a
#      negative zero, DeNorm or NaN value."
#     LUF = 1 alt tasmada, LVF = 1 tasmada; TF, ZF, NF degismez.
#
# TI tablonun icerigini YAYIMLAMIYOR (model_kararlari §6.1). Secenek 1
# secildi: tablo projenin tanimi. Bu dosyadaki FORMUL tek kaynaktir;
# `tools/lut_uret.py` ondan `isa/estimate_lut.hex`'i uretir (duzen asagida),
# RTL onu $readmemh ile okur, `tests/test_estimate.py` dosyanin formulle
# birebir ayni oldugunu denetler. Sonuc "Python == RTL"
# garantisi verir; "Python == TI silikonu" DEGIL.
#
# Newton-Raphson komutun ICINDE YOK: TRM iterasyonlari programa birakiyor
# (s.617 ornegi: MEINVF32 + iki kez MMPYF32/MSUBF32). Komut yalniz tohumu
# uretir.
#
# YONTEM
# ------
# Girdinin kesir alaninin ust 8 biti f[22:15] = i araligi secer:
#
#     m ∈ [1 + i/256, 1 + (i+1)/256)       orta nokta  m_i = (513 + 2i) / 512
#
# Tablo, orta noktadaki degeri 8 kesir bitiyle tutar (1.q, q = 0..255), en
# yakina yuvarlanmis. Sonuc = isaret | us << 23 | q << 15 (alt 15 bit sifir).
#
#     1/x    q = round(2^18 / (513 + 2i)) - 256              (2/m_i ∈ (1, 2))
#            us = 253 - e
#
#     1/√x   indeks = (e & 1) << 8 | i
#            e cift (E = e-127 tek):  q = round(sqrt(2^26/(513+2i))) - 256
#                                     (√2/√m_i ∈ (1, √2])
#            e tek  (E cift):         q = min(round(sqrt(2^27/(513+2i))), 511) - 256
#                                     (2/√m_i; yalniz i = 0 kirpiliyor, 512 -> 511)
#            us = (380 - e) >> 1
#
# Yuvarlamalar tamsayi aritmetigiyle; esitlik (tam .5) durumu yok: payda tek,
# pay 2'nin kuvveti. Olculen en buyuk goreli hata, butun 2^23 mantis:
# 1/x 2^-8.45, 1/√x 2^-8.71 (tek E) / 2^-9.00 (cift E) - "yaklasik 8 bit".
#
# OZEL DURUMLAR (TRM yalniz "-0, denormal, NaN uretmez" diyor; gerisi karar)
# -----------------------------------------------------------------------
#     1/x    e = 0   (±0, denormal = sifir sayilir)  -> ±sonsuz, LVF
#            e = 255 (±sonsuz, NaN)                  -> +0
#            e >= 253 (sonuc normal araligin altinda) -> +0, LUF   (-0 degil)
#     1/√x   isaret yok sayilir (|x|): negatif girdi TRM'de tanimsiz ve NaN
#            uretilemez
#            e = 0                                    -> +sonsuz, LVF
#            e = 255                                  -> +0
#            normal girdide sonuc hep normal: us 63..189, tasma/alt tasma yok


TERS_BOY = 256
KAREKOK_BOY = 512


def _ters_q(i):
    b = 513 + 2 * i
    return (2 * (1 << 18) + b) // (2 * b) - 256           # round(2^18 / b)


def _karekok_q(indeks):
    i = indeks & 0xFF
    tek_E = (indeks >> 8) == 0                             # e cift -> E tek
    A = (1 << 26) if tek_E else (1 << 27)
    b = 513 + 2 * i
    k = (isqrt(4 * A // b) + 1) // 2                       # round(sqrt(A / b))
    return min(k, 511) - 256


TERS_LUT = tuple(_ters_q(i) for i in range(TERS_BOY))
KAREKOK_LUT = tuple(_karekok_q(i) for i in range(KAREKOK_BOY))


def ters_kestirim(bits):
    """MEINVF32 cekirdegi: ham 32 bit -> (sonuc_bitleri, luf, lvf)."""
    isaret = bits & 0x80000000
    e = (bits >> 23) & 0xFF
    if e == 0xFF:
        return 0x00000000, False, False
    if e == 0:
        return isaret | 0x7F800000, False, True
    us = 253 - e
    if us <= 0:
        return 0x00000000, True, False
    return isaret | (us << 23) | (TERS_LUT[(bits >> 15) & 0xFF] << 15), False, False


def karekok_ters_kestirim(bits):
    """MEISQRTF32 cekirdegi: ham 32 bit -> (sonuc_bitleri, luf, lvf)."""
    e = (bits >> 23) & 0xFF
    if e == 0xFF:
        return 0x00000000, False, False
    if e == 0:
        return 0x7F800000, False, True
    us = (380 - e) >> 1
    indeks = ((e & 1) << 8) | ((bits >> 15) & 0xFF)
    return (us << 23) | (KAREKOK_LUT[indeks] << 15), False, False


# ---------------------------------------------------------------------
#  isa/estimate_lut.hex  -  RTL'in okudugu TEK dosya (768 x 8 bit)
#
#      0x000-0x0FF  1/sqrt, e cift  (E tek)    adres = {1'b0, e[0], f[22:15]}
#      0x100-0x1FF  1/sqrt, e tek   (E cift)
#      0x200-0x2FF  1/x                         adres = {2'b10, f[22:15]}
#
#  Iki komutun adresi de bit birlestirmesi - RTL'de toplayici gerekmiyor.
#  Satir basina bir giris, 2 onaltilik hane, yorumsuz ($readmemh).
# ---------------------------------------------------------------------
LUT_DOSYASI = "estimate_lut.hex"
KAREKOK_TABAN = 0x000
TERS_TABAN = 0x200


def lut_satirlari():
    """Dosyanin satirlari, adres sirasiyla."""
    return ["%02x" % q for q in KAREKOK_LUT + TERS_LUT]


# #####################################################################
#  ops_float.py
# #####################################################################

# =====================================================================
#  ops_float.py - kayan noktali aritmetik, karsilastirma, min/max
# ---------------------------------------------------------------------
#  Sonuc TAM (kesirli) ara degerden _sonuclandir ile kurulur:
#    RND32 = 0 sifira kes (sifirlama degeri), 1 en yakin cift (s.718)
#    tasma -> LVF (RND32=1'de +-inf, 0'da +-MAX), alt tasma -> LUF
#    denormal sonuc +0; NaN sonuc tek desen 0x7FC00000 (NAN_KANONIK)
#  Aritmetik yalniz LUF/LVF'yi degistirir; ZF/NF paralel MMOV32'den gelir.
#  Kosul kodlari (Tablo 10-9, s.586): kosul_saglandi, bayrak_guncellenir_mi.
#  MEINVF32/MEISQRTF32 kestirimi: ops_estimate.py (proje tablosu).
# =====================================================================


# TRM aritmetik komutlarin NaN ciktisinin bit desenini tanimlamiyor.
# Python'un urettigi NaN'in isareti ana makineye bagli (x86 0xFFC00000,
# ARM 0x7FC00000) - bit-exact iz icin tek desen: pozitif sessiz NaN.
NAN_KANONIK = 0x7FC00000





def _tam(deger):
    """Operandi TAM (kesirli) degere cevirir - yuvarlama oncesi ara deger icin.

    NEDEN GEREKLI: sifira yuvarlama modunda (RND32=0, reset degeri) double
    ara deger YETMIYOR. Iki float32'nin toplaminin tam sonucu vakalarin
    ~%77'sinde 53 bite sigmiyor; double kendi yuvarlamasini yapinca
    "tam deger bu esigin altinda miydi" bilgisi siliniyor ve _sonuclandir
    sifira kesme karari veremiyor. Olculen hata orani: %31.

    En yakin cifte yuvarlamada (RND32=1) sorun yok - Figueroa teoremi
    ara formatin 2p+2 = 50 bit olmasini istiyor, double'da 53 var. Ama o
    teorem sadece EN YAKINA yuvarlama icin gecerli; YONLU yuvarlama
    sticky bit ister.

    Carpmada da sorun yok: iki 24-bit mantisin carpimi 48 bit, double'a
    tam sigar (50000 denemede sapma yok). Yine de tutarlilik icin ayni
    yoldan gecirmek zarar vermiyor.

    inf ve NaN Fraction'a cevrilemez; onlarda zaten yuvarlama yok, oldugu
    gibi donuyorlar (Fraction + float -> float, inf/NaN dogru yayilir).
    """
    if deger != deger or abs(deger) == float("inf"):
        return deger
    if deger != 0 and abs(deger) < 2.0 ** -126:     # M1 (FTZ, K12): denormal girdi +0 sayilir
        return Fraction(0)
    return Fraction(deger)


def _sonuclandir(state:ClaState , hedef:int , tamsayi:float):
    


        
 
    try:
        bits = float_to_bits(tamsayi)
    except OverflowError:
        bits = NEG_INF if tamsayi < 0 else POS_INF
        state.latch_overflow()

    if is_nan(bits):
        bits = NAN_KANONIK          # tek desen (yukarida); LUF/LVF degismez

    if(tamsayi != 0 and abs(tamsayi) <bits_to_float(MIN_NORMAL)):
        state.latch_underflow()
    
  
    if(state.rnd32 == 0 and abs(bits_to_float(bits)) > abs(tamsayi) ):

        

        bits = bits-1


    # Denormal SONUC +0'a bastirilir. set_mr artik ham 32-bit yazmadir
    # (MR yazmaclari tamsayi da tutar), bu yuzden bastirma burada.
    state.set_mr(hedef , flush_denormal(bits))

    # DIKKAT: burada update_nz YOK.
    # MADDF32 / MSUBF32 / MMPYF32 sadece LUF ve LVF kurar; ZF ve NF'ye
    # dokunmaz (s.594, s.668, s.690 - Flags tablosu "ZF No / NF No").
    # Paralel formlar da bunu dogruluyor: ZF/NF sadece yanina
    # "MMOV32 MRa, mem32" (yukleme) eklenen varyantlarda True; ayni
    # aritmetigin "MMOV32 mem32, MRa" (saklama) varyantinda False.
    # Yani ZF/NF her zaman MMOV32'nin yukleme yarisindan gelir, toplamadan
    # degil. Bayrak gerektiren komutlar (MABSF32, MNEGF32, MCMPF32, MMOV32)
    # update_nz'yi kendileri cagirir.


def minvf32(state:ClaState , mra , mrb):
        """MEINVF32 MRa, MRb - 1/x KESTIRIMI (s.617).

        Komut yalniz ~8 bitlik TOHUMU uretir; Newton-Raphson iterasyonlari
        (Ye = Ye*(2.0 - Ye*X), iki kez) PROGRAMIN isi - TRM ornegi bunu
        MMPYF32/MSUBF32 ile yapiyor. Tablo ve ozel durumlar ops_estimate.py
        (proje sozlesmesi, model_kararlari §6.1). Sonuc bitleri tablodan
        dogrudan kuruluyor: RND32 etkisiz, _sonuclandir kullanilmiyor.
        TF/ZF/NF degismez; yalniz LUF/LVF (yapiskan).
        """
        sonuc, luf, lvf = ters_kestirim(state.get_mr(mrb))   # ham bitler
        state.set_mr(mra, sonuc)
        if luf:
            state.latch_underflow()
        if lvf:
            state.latch_overflow()


def misqrtf32(state:ClaState , mra , mrb):
        """MEISQRTF32 MRa, MRb - 1/sqrt(x) KESTIRIMI (s.618).

        minvf32 ile ayni duzen; iterasyon Ye = Ye*(1.5 - Ye*Ye*X/2.0)
        programda. Negatif girdide |x| kullanilir (TRM tanimsiz, NaN
        uretilemez) - ops_estimate.py.
        """
        sonuc, luf, lvf = karekok_ters_kestirim(state.get_mr(mrb))
        state.set_mr(mra, sonuc)
        if luf:
            state.latch_underflow()
        if lvf:
            state.latch_overflow()


def maddf32_imm(state:ClaState , * , mra:int , upper_16:int , mrb:int):

    immediate_32_float = bits_to_float(flush_denormal((upper_16 & 0xFFFF) << 16))

    source_value_float = state.get_mr_float(mrb)

    _sonuclandir(state , mra , _tam(immediate_32_float)+_tam(source_value_float))

def maddf32_rrr(state:ClaState , mra:int , mrb:int , mrc:int):
        
        source1_value_float = state.get_mr_float(mrb)

        source2_value_float = state.get_mr_float(mrc)

        _sonuclandir(state , mra , _tam(source1_value_float) + _tam(source2_value_float))


def mabsf32_rr(state, mra, mrb):
    """MABSF32 MRa, MRb  ->  MRa = |MRb|   (s.589)"""
    bits = state.get_mr(mrb) & 0x7FFFFFFF
    state.set_mr(mra, bits)
    state.update_nz(bits)

UNCF = 0b1111          # kosulsuz + bayraklari guncelle (varsayilan)


class AyrilmisKosulError(Exception):
    """Kilavuzda tanimsiz CNDF kodlamasi (0110-1001)."""


def kosul_saglandi(state, cndf=UNCF) -> bool:
    """CNDF kosulunu MSTF bayraklarina gore test eder. Tablo 10-9, s.586."""
    match cndf:
        case 0b0000: return state.zf == 0                     # NEQ
        case 0b0001: return state.zf == 1                     # EQ
        case 0b0010: return state.zf == 0 and state.nf == 0   # GT
        case 0b0011: return state.nf == 0                     # GEQ
        case 0b0100: return state.nf == 1                     # LT
        case 0b0101: return state.zf == 1 or state.nf == 1    # LEQ
        case 0b1010: return state.tf == 1                     # TF
        case 0b1011: return state.tf == 0                     # NTF
        case 0b1100: return state.luf == 1                    # LU
        case 0b1101: return state.lvf == 1                    # LV
        case 0b1110: return True                              # UNC
        case 0b1111: return True                              # UNCF
    raise AyrilmisKosulError("CNDF 0b{:04b} ayrilmis (s.598)".format(cndf))


def bayrak_guncellenir_mi(cndf=UNCF) -> bool:
    """Tablo 10-9 dipnot 2 (s.586): kosullu islemlerde ZF/NF sadece UNCF ile guncellenir."""
    return cndf == UNCF


def mnegf32_rrc(state, mra, mrb, cndf=UNCF):
    """MNEGF32 MRa, MRb {,CNDF}   (s.679)
    kosul dogruysa MRa = -MRb, degilse MRa = MRb"""
    bits = state.get_mr(mrb)
    if kosul_saglandi(state, cndf):
        bits ^= 0x80000000
    state.set_mr(mra, bits)
    if bayrak_guncellenir_mi(cndf):
        state.update_nz(bits)

def msubf32_rrr(state: ClaState, mra: int, mrb: int, mrc: int):

    value_1 = state.get_mr_float(mrb)
    value_2 = state.get_mr_float(mrc)

    _sonuclandir(state , mra, _tam(value_1) - _tam(value_2))


def msubf32_imm(state: ClaState, * , mra: int, upper_16: int, mrb: int):
    """MSUBF32 MRa, #16FHi, MRb  ->  MRa = #16FHi:0 - MRb   (s.691)

    TUZAK: immediate ONCE geliyor. MADDF32/MMPYF32'de sira onemsiz oldugu
    icin kilavuz onlara takma ad veriyor (MRa, MRb, #16FHi da yaziliyor);
    cikarma degismeli olmadigi icin bu formun takma adi YOK.
    """

    immediate_32_float = bits_to_float(flush_denormal((upper_16 & 0xFFFF) << 16))

    source_value_float = state.get_mr_float(mrb)

    _sonuclandir(state , mra , _tam(immediate_32_float) - _tam(source_value_float))


def mmpyf32_rrr(state: ClaState, mra: int, mrb: int, mrc: int):
    """MMPYF32 MRa, MRb, MRc  ->  MRa = MRb * MRc   (s.668)"""

    source1_value_float = state.get_mr_float(mrb)

    source2_value_float = state.get_mr_float(mrc)

    _sonuclandir(state , mra , _tam(source1_value_float) * _tam(source2_value_float))


def mmpyf32_imm(state: ClaState, * , mra: int, upper_16: int, mrb: int):
    """MMPYF32 MRa, #16FHi, MRb  ->  MRa = MRb * #16FHi:0   (s.669)

    Takma ad: MMPYF32 MRa, MRb, #16FHi (carpma degismeli).
    """

    immediate_32_float = bits_to_float(flush_denormal((upper_16 & 0xFFFF) << 16))

    source_value_float = state.get_mr_float(mrb)

    _sonuclandir(state , mra , _tam(immediate_32_float) * _tam(source_value_float))


def mcmpf32_rr(state:ClaState, mra:int, mrb:int):

       value_1 = state.get_mr_float(mra)

       value_1_bits =  state.get_mr(mra)

       value_1_sign = value_1_bits>>31

       value_2 = state.get_mr_float(mrb)

       value_2_bits =  state.get_mr(mrb)

       value_2_sign = value_2_bits>>31

       

       

       if(value_1 != value_1 and value_1_sign  ==  0 ):
           value_1 = float('inf')

       elif(value_1 != value_1 and value_1_sign == 1) :
            value_1 = float('-inf')   

    

       
       if(value_2 != value_2 and value_2_sign ==  0 ):
           value_2 = float('inf')

       elif(value_2 != value_2 and value_2_sign == 1) :
            value_2 = float('-inf')   


       value_1 = bits_to_float(flush_denormal(float_to_bits(value_1)) )
       value_2 = bits_to_float(flush_denormal(float_to_bits(value_2)) )    
      
                      
       state.zf = 1 if value_1 == value_2 else 0
       state.nf = 1 if value_1 <value_2 else 0


def mcmpf32_imm(state:ClaState , * ,  mra: int , imm : int): 

    value_1 = state.get_mr_float(mra) 

    value_1_bits =  state.get_mr(mra) 

    value_1_sign = value_1_bits>>31 

    value_2 = bits_to_float(imm<<16) 

    value_2_sign = imm>>15 

    if(value_1 != value_1 and value_1_sign  ==  0 ): 
        value_1 = float('inf') 

    elif(value_1 != value_1 and value_1_sign == 1) : 
        value_1 = float('-inf') 

    if(value_2 != value_2 and value_2_sign ==  0 ): value_2 = float('inf') 

    elif(value_2 != value_2 and value_2_sign == 1) : value_2 = float('-inf') 

    value_1 = bits_to_float(flush_denormal(float_to_bits(value_1)) ) 

    value_2 = bits_to_float(flush_denormal(float_to_bits(value_2)) ) 
    state.zf = 1 if value_1 == value_2 else 0 

    state.nf = 1 if value_1 <value_2 else 0


def _karsilastirma_degeri(bits):
    """Ham deseni karsilastirma icin kullanilabilir bir degere cevirir.

    s.611 (MCMPF32 girdileri) ve s.636 / s.639 (MMAXF32/MMINF32 ciktilari)
    ayni donusumu istiyor:

        ustel == 0                    ->  0.0  (+0, -0 ve denormal birlikte)
        ustel == 0xFF ve mantis != 0  ->  isarete gore +inf / -inf  (NaN)
        digerleri                     ->  degerin kendisi

    NEDEN OKUMA TARAFINDA: set_mr artik denormal bastirmiyor (MR yazmaclari
    tamsayi da tutuyor, bkz. model_kararlari.md 1.3.1), yani yazmacta
    denormal desen bulunabilir. Bastirma, degeri kayan nokta olarak
    YORUMLADIGIMIZ yerde yapilir.

    NaN'in isareti sadece bit deseninde gorunur - Python'da float('nan')
    ile gelen iki NaN ayirt edilemez. Bu yuzden fonksiyon degeri degil
    deseni aliyor.
    """
    bits = bits & 0xFFFFFFFF
    ustel = (bits >> 23) & 0xFF
    mantis = bits & 0x7FFFFF

    if ustel == 0xFF and mantis != 0:
        return float("-inf") if bits & 0x80000000 else float("inf")
    if ustel == 0:
        return 0.0
    return bits_to_float(bits)


def _kosullu_sec(state, mra, a, b, b_buyukse_al):
    """MMAXF32 / MMINF32'nin ortak govdesi.

    Bayraklar HER ZAMAN orijinal karsilastirmadan gelir - yazma olsun
    olmasin. Kilavuz s.636: "The ZF and NF flags are configured on the
    result of the operation, not the result stored in the destination
    register."

    Kilavuzun s.639'daki ornegi bunu kanitliyor:
        MR0 = 5.0, MR1 = 4.0
        MMINF32 MR0, MR1   ; MR0 = 4.0,  ZF = 0, NF = 0
    Yazilan deger 4.0 ama bayraklar 5.0 > 4.0 karsilastirmasini gosteriyor.
    Sonuctan hesaplansaydi 4.0 == 4.0 olur, ZF = 1 cikardi.

    Yazilan deger normalize edilmis olani: ciktidaki NaN -> sonsuz ve
    denormal -> +0 donusumu (s.636) tam olarak bu normalizasyon.
    """
    state.zf = 1 if a == b else 0
    state.nf = 1 if a < b else 0

    if b_buyukse_al:
        secilen = b if a < b else a        # MMAXF32
    else:
        secilen = b if a > b else a        # MMINF32

    state.set_mr(mra, float_to_bits(secilen))


def mmaxf32_rr(state: ClaState, mra: int, mrb: int):
    """MMAXF32 MRa, MRb  ->  if (MRa < MRb) MRa = MRb   (s.636)"""

    a = _karsilastirma_degeri(state.get_mr(mra))
    b = _karsilastirma_degeri(state.get_mr(mrb))

    _kosullu_sec(state, mra, a, b, True)


def mmaxf32_imm(state: ClaState, * , mra: int, upper_16: int):
    """MMAXF32 MRa, #16FHi  ->  if (MRa < #16FHi:0) MRa = #16FHi:0   (s.638)"""

    a = _karsilastirma_degeri(state.get_mr(mra))
    b = _karsilastirma_degeri((upper_16 & 0xFFFF) << 16)

    _kosullu_sec(state, mra, a, b, True)


def mminf32_rr(state: ClaState, mra: int, mrb: int):
    """MMINF32 MRa, MRb  ->  if (MRa > MRb) MRa = MRb   (s.639)"""

    a = _karsilastirma_degeri(state.get_mr(mra))
    b = _karsilastirma_degeri(state.get_mr(mrb))

    _kosullu_sec(state, mra, a, b, False)


def mminf32_imm(state: ClaState, * , mra: int, upper_16: int):
    """MMINF32 MRa, #16FHi  ->  if (MRa > #16FHi:0) MRa = #16FHi:0   (s.641)"""

    a = _karsilastirma_degeri(state.get_mr(mra))
    b = _karsilastirma_degeri((upper_16 & 0xFFFF) << 16)

    _kosullu_sec(state, mra, a, b, False)


def mfracf32_rr(state : ClaState , mra : int , mrb : int):

        value = state.get_mr_float(mrb)

        value = bits_to_float(flush_denormal(float_to_bits(value)))


        if(value != value or abs(value) == float('inf') ): 
            fractional_portion = 0
            

        else:
            fractional_portion = value - int(value)

        state.set_mr_float(mra , fractional_portion)




def mswapf_rrc(state:ClaState, mra:int, mrb:int, cndf=UNCF):

        if(kosul_saglandi(state , cndf)):
            temp = state.get_mr(mra)
            state.set_mr(mra , state.get_mr(mrb))
            state.set_mr(mrb , temp)


# #####################################################################
#  ops_int.py
# #####################################################################

# =====================================================================
#  ops_int.py - 32-bit tamsayi, mantik ve kaydirma
# ---------------------------------------------------------------------
#  MADD32 MSUB32 MAND32 MOR32 MXOR32 MLSL32 MLSR32 MASR32 MCMP32.
#  Bayrak: NF = sonucun bit 31'i, ZF = sonuc 0 ise; tasma bayragi yok.
#  Kaydirma miktari kodlamada deger - 1 (dagitici +1 ekler, Tablo 10-7).
# =====================================================================


def sonuclandir(state:ClaState , hedef:int , tamsayi:int):

        state.zf = 1 if tamsayi == 0 else 0
        state.nf = 1 if tamsayi>>31 == 1 else 0

        state.set_mr(hedef , tamsayi)




def madd32_rrr(state:ClaState, mra:int, mrb:int, mrc:int):
        int_value1 = state.get_mr(mrb)
        int_value2 = state.get_mr(mrc)
        sonuc = (int_value1 + int_value2)&0xFFFFFFFF

        sonuclandir(state , mra , sonuc)


def msub32_rrr(state:ClaState, mra:int, mrb:int, mrc:int):
        int_value1 = state.get_mr(mrb)
        int_value2 = state.get_mr(mrc)
        sonuc = (int_value1 - int_value2)&0xFFFFFFFF

        sonuclandir(state , mra , sonuc)

def mand32_rrr(state:ClaState, mra:int, mrb:int, mrc:int):
                int_value1 = state.get_mr(mrb)
                int_value2 = state.get_mr(mrc)
                sonuc = (int_value1 & int_value2)&0xFFFFFFFF
        
                sonuclandir(state , mra , sonuc)

def mor32_rrr(state:ClaState, mra:int, mrb:int, mrc:int): 

                    int_value1 = state.get_mr(mrb)

                    int_value2 = state.get_mr(mrc)

                    sonuc = (int_value1 | int_value2)&0xFFFFFFFF
                
                    sonuclandir(state , mra , sonuc)

def mxor32_rrr(state:ClaState, mra:int, mrb:int, mrc:int):  

                            int_value1 = state.get_mr(mrb)
        
                            int_value2 = state.get_mr(mrc)
        
                            sonuc = (int_value1 ^ int_value2)&0xFFFFFFFF
                        
                            sonuclandir(state , mra , sonuc)               

def mlsl32_ri(state:ClaState, mra:int , shift:int):

        

        reg_value = state.get_mr(mra)

        sonuc = (reg_value << shift) & 0xFFFFFFFF
        sonuclandir(state , mra , sonuc)

def mlsr32_ri(state:ClaState, mra:int , shift:int):

        

        reg_value = state.get_mr(mra)

        sonuc = (reg_value >> shift) & 0xFFFFFFFF
        sonuclandir(state , mra , sonuc)

def masr32_ri(state:ClaState, mra:int , shift:int):

        

        reg_value = state.get_mr(mra)
        signed_reg_value  = reg_value - 0x100000000 if reg_value & 0x80000000 else reg_value
        sonuc = (signed_reg_value >> shift) & 0xFFFFFFFF
        sonuclandir(state , mra , sonuc)

def mcmp32_rr(state:ClaState, mra:int, mrb:int):

              
                int_value1 = state.get_mr(mra)
                int_value2 = state.get_mr(mrb)
                sonuc = (int_value1 - int_value2)&0xFFFFFFFF
              
                state.zf = 1 if sonuc == 0 else 0
                state.nf = 1 if sonuc>>31 == 1 else 0

        


# #####################################################################
#  ops_convert.py
# #####################################################################

# =====================================================================
#  ops_convert.py - tip donusumleri ve adres hesabi
# ---------------------------------------------------------------------
#  MF32TOx / MxTOF32 (s.620-630, s.699-702), 16-bit MAR islemleri ve
#  effective_address: dogrudan @adres, *MARx, *MARx[#n]++ (s.584-585);
#  post-increment isaretli ve 16 bitte sarar.
#  Float -> tamsayi: sifira kesme; 'R' surumleri en yakin cifte.
#  Isaretsiz hedefe negatif girdi -> 0 (s.623-625 ornekleri).
#  Pozitif tasma: sarma (TRM sessiz, varsayim). NaN -> 0.
# =====================================================================



def effective_address(state:ClaState , mem , kip , m ) -> int:

        effective_address = mem

        if(kip == 0b0000):
                       
                       effective_address = mem
       
        elif(kip == 0b0001):
                           
                           effective_address = state.get_mar(0)
                           state.set_mar(0, (effective_address + m) & 0xFFFF)
        elif(kip == 0b0010):
                           
                           effective_address = state.get_mar(1)
                           state.set_mar(1, (effective_address + m) & 0xFFFF)
                        
        else: 
       
                       raise ValueError("Gecersiz adresleme kipi")

        return effective_address

def mi16tof32_rr(state: ClaState, mra : int, mrb :int):

        value = state.get_mr(mrb)

        value_l16 = value&0x0000FFFF

        signed_value_l16  =  value_l16 - 0x10000 if  value_l16 & 0x8000 else  value_l16

        bits = float_to_bits(signed_value_l16)

        state.set_mr(mra ,  bits)

def mui16tof32_rr(state: ClaState, mra : int, mrb :int):



        value = state.get_mr(mrb)
        
        value_l16 = value&0x0000FFFF
        
        bits = float_to_bits(value_l16)
        
        state.set_mr(mra ,  bits)


def mi32tof32_rr(state: ClaState, mra : int, mrb :int):

        value = state.get_mr(mrb)
        
        
        
        signed_value  =  value - 0x100000000 if  value & 0x80000000 else  value
        
        bits = float_to_bits(signed_value)
        
        

        

        if(state.rnd32 == 0  and  abs(bits_to_float(bits)) > abs(signed_value)):
                bits -= 1

        state.set_mr(mra ,  bits)

def mui32tof32_rr(state: ClaState, mra : int, mrb :int):

        value = state.get_mr(mrb)
        
        
        bits = float_to_bits(value)
        
    
        if(state.rnd32 == 0  and  abs(bits_to_float(bits)) > abs(value)):
                bits -= 1

        state.set_mr(mra ,  bits)


def mf32toi16_rr(state:ClaState, mra:int, mrb:int): 

        value = state.get_mr_float(mrb)

        if(value == float('inf') ):
                value_int = 0x00007FFF

        elif(value == float('-inf')):
                value_int = 0xFFFF8000

                
        elif(value != value ):
                value_int = 0x00000000

        else:

            value_int = int(value) & 0xFFFF
            sign_bit = value_int>>15
            
            if(sign_bit == 1):
                    value_int = value_int | 0xFFFF0000

            else:
                    value_int = value_int & 0x0000FFFF

        state.set_mr(mra ,  value_int)

def mf32toi16r_rr(state:ClaState, mra:int, mrb:int):

        value = state.get_mr_float(mrb)

        if(value == float('inf') ):
                value_int = 0x00007FFF

        elif(value == float('-inf')):
                value_int = 0xFFFF8000

                
        elif(value != value ):
                value_int = 0x00000000

        else:

            value_int = round(value) & 0xFFFF
            sign_bit = value_int>>15
            
            if(sign_bit == 1):
                    value_int = value_int | 0xFFFF0000

            else:
                    value_int = value_int & 0x0000FFFF

        state.set_mr(mra ,  value_int)


def mf32toui16_rr(state:ClaState, mra:int, mrb:int):
        """MF32TOUI16 MRa, MRb  ->  isaretsiz 16 bit, sifira kes   (s.623)

        mf32toi16_rr'den tek farki son adim: ust yari sifir kalir,
        isaret uzatilmaz. Ozel degerler de isaretsiz araliga gore:
        +Inf hedefin en buyugu (0xFFFF), -Inf en kucugu (0).
        """

        value = state.get_mr_float(mrb)

        if(value == float('inf') ):
                value_int = 0x0000FFFF

        elif(value == float('-inf')):
                value_int = 0x00000000


        elif(value != value ):
                value_int = 0x00000000

        elif(value < 0):              # s.623/624/625 ornekleri: negatif -> 0
                value_int = 0x00000000

        else:

            value_int = int(value) & 0xFFFF

        state.set_mr(mra ,  value_int)


def mf32toui16r_rr(state:ClaState, mra:int, mrb:int):
        """MF32TOUI16R MRa, MRb  ->  isaretsiz 16 bit, en yakin cifte   (s.624)"""

        value = state.get_mr_float(mrb)

        if(value == float('inf') ):
                value_int = 0x0000FFFF

        elif(value == float('-inf')):
                value_int = 0x00000000


        elif(value != value ):
                value_int = 0x00000000

        elif(value < 0):              # s.623/624/625 ornekleri: negatif -> 0
                value_int = 0x00000000

        else:

            value_int = round(value) & 0xFFFF

        state.set_mr(mra ,  value_int)


def mf32toi32_rr(state:ClaState, mra:int, mrb:int):
        """MF32TOI32 MRa, MRb  ->  isaretli 32 bit, sifira kes   (s.622)

        Sonuc zaten 32 bit oldugu icin isaret uzatma adimi YOK; maske de
        0xFFFFFFFF. Python'da negatif sayinin 32-bit maskesi zaten iki'ye
        tumleyen karsiligidir.
        """

        value = state.get_mr_float(mrb)

        if(value == float('inf') ):
                value_int = 0x7FFFFFFF

        elif(value == float('-inf')):
                value_int = 0x80000000


        elif(value != value ):
                value_int = 0x00000000

        else:

            value_int = int(value) & 0xFFFFFFFF

        state.set_mr(mra ,  value_int)


def mf32toui32_rr(state:ClaState, mra:int, mrb:int):
        """MF32TOUI32 MRa, MRb  ->  isaretsiz 32 bit, sifira kes   (s.625)"""

        value = state.get_mr_float(mrb)

        if(value == float('inf') ):
                value_int = 0xFFFFFFFF

        elif(value == float('-inf')):
                value_int = 0x00000000


        elif(value != value ):
                value_int = 0x00000000

        elif(value < 0):              # s.623/624/625 ornekleri: negatif -> 0
                value_int = 0x00000000

        else:

            value_int = int(value) & 0xFFFFFFFF

        state.set_mr(mra ,  value_int)


def mi16tof32_ri(state: ClaState, mra : int, memory :ClaMemory , mem16 , kip:int , m:int):


        address = effective_address(state , mem16, kip , m )


        value = memory.read16(address)
        signed_value  =  value - 0x10000 if  value & 0x8000 else  value
               
        bits = float_to_bits(signed_value)
               
        state.set_mr(mra ,  bits)

def mui16tof32_ri(state: ClaState, mra : int, memory :ClaMemory , mem16 , kip:int , m:int):


        address = effective_address(state , mem16, kip , m )


        value = memory.read16(address)
        
               
        bits = float_to_bits(value)
               
        state.set_mr(mra ,  bits)




               
def mi32tof32_ri(state: ClaState, mra : int, memory:ClaMemory , mem32 :int , kip , m ):

        address = effective_address(state , mem32, kip , m )


        value = memory.read32(address)
        signed_value  =  value - 0x100000000 if  value & 0x80000000 else  value
               
        bits = float_to_bits(signed_value)
               
        state.set_mr(mra ,  bits)
        

        if(state.rnd32 == 0  and  abs(bits_to_float(bits)) > abs(signed_value)):
                bits -= 1

        state.set_mr(mra ,  bits)

def mui32tof32_ri(state: ClaState, mra : int, memory:ClaMemory , mem32 :int , kip , m ):

        address = effective_address(state , mem32, kip , m )


        value = memory.read32(address)
       
               
        bits = float_to_bits(value)
               
        state.set_mr(mra ,  bits)
        

        if(state.rnd32 == 0  and  abs(bits_to_float(bits)) > abs(value)):
                bits -= 1

        state.set_mr(mra ,  bits)

def mmovi16_0(state:ClaState , imm16 ):

       imm16 = imm16&0xFFFF
       
       state.mar[0] = imm16


def mmovi16_1(state:ClaState , imm16 ):

        imm16 = imm16&0xFFFF
       
        state.mar[1] = imm16


def mmov16_0(state:ClaState , mra , imm16):

       state.mar[0] = ((state.get_mr(mra)&0X0000FFFF) + imm16)&0xFFFF

def mmov16_1(state:ClaState , mra , imm16):

       state.mar[1] = ((state.get_mr(mra)&0X0000FFFF) + imm16)&0xFFFF

def mmov16_mar_mem_0(state:ClaState , mem16 , memory:ClaMemory , kip , m ):

       address = effective_address(state , mem16 , kip , m)

       value_16 = memory.read16(address)

       state.mar[0] = value_16&0xFFFF

def mmov16_mar_mem_1(state:ClaState , mem16 , memory:ClaMemory , kip , m):

        address = effective_address(state , mem16 , kip , m)

        value_16 = memory.read16(address)

        state.mar[1] = value_16&0xFFFF

def mmov16_mem_mar_0(state:ClaState , mem16 , memory:ClaMemory , kip , m):

        address = effective_address(state , mem16 , kip , m)

        value_16 = state.get_mar(0)

        memory.write16(address , value_16)

def mmov16_mem_mar_1(state:ClaState , mem16 , memory:ClaMemory , kip , m):

        address = effective_address(state , mem16 , kip , m)

        value_16 = state.get_mar(1)

        memory.write16(address , value_16)


def mmov16_mem_mra(state:ClaState , mem16 ,mra, memory:ClaMemory , kip , m ):

        address = effective_address(state , mem16 , kip , m)

        value = state.get_mr(mra)&0X0000FFFF

        memory.write16(address , value)


def mmovz16(state:ClaState , mem16 ,mra, memory:ClaMemory , kip , m ):

        address = effective_address(state , mem16 , kip , m)
       

        value = memory.read16(address)&0x0000FFFF
        
        state.set_mr(mra , value)
       
       
              
        state.zf = 1 if value == 0 else 0
        state.nf = 1 if value>>31 == 1 else 0
 
       


# #####################################################################
#  ops_memory.py
# #####################################################################

# =====================================================================
#  ops_memory.py - MMOV32 / MMOVD32 / MMOVIZ / MMOVXI ve MSTF tasima
# ---------------------------------------------------------------------
#  Yukleme (s.653) NF/ZF'yi update_nz kuraliyla kurar; kosul yanlissa
#  ardisik modelde okuma ve post-increment yapilmaz (borc 3b.4).
#  MMOVD32 (s.658): MRa = [mem32] ve [mem32+2] = [mem32].
#  MMOV32 MSTF, mem32 (s.657): bayraklar ve RPC yuklenir, MEALLOW
#  degismez; ayrilmis bitler 0.
# =====================================================================




def mmoviz_ri(state : ClaState, mra:int, upper_16:int): 

        state.set_mr(mra , upper_16<<16)

def mmovxi_ri(state:ClaState, mra:int, lower_16:int):

        state.set_mr(mra , (state.get_mr(mra))&0xFFFF0000|lower_16&0x0000FFFF)

def mmov32_yukle(state:ClaState, memory:ClaMemory, mra:int, kip:int, m:int , cndf=UNCF):

        cnd = kosul_saglandi(state , cndf)

        if(cnd and  kip == 0b0000 ):
                state.set_mr(mra , memory.read32(m) )
                value = memory.read32(m)
                if(cndf == UNCF):
                                     state.update_nz(value)

        elif(cnd and kip == 0b0001):
                effective_address = (state.get_mar(0))
                state.set_mar(0 , (effective_address+m)&0XFFFF) 
                value = memory.read32(effective_address)
                state.set_mr(mra , value)

                if(cndf == UNCF):
                     state.update_nz(value)

        elif(cnd and kip == 0b0010):

                effective_address = (state.get_mar(1))
                state.set_mar(1 , (effective_address+m)&0XFFFF) 
                value = memory.read32(effective_address)
                state.set_mr(mra , value)

                if(cndf == UNCF):
                                     state.update_nz(value)
                        

        elif(cnd):
                raise ValueError("Gecersiz adresleme kipi")

def mmov32_sakla(state:ClaState , memory:ClaMemory , mra:int ,  kip:int , m:int):

        value = state.get_mr(mra)
        if(kip == 0b0000):

           
            memory.write32(m, value)

        elif(kip == 0b0001):
                effective_address = state.get_mar(0)
                memory.write32(effective_address , value)
                state.set_mar(0 , effective_address + m)

        elif(kip == 0b0010):
                effective_address = state.get_mar(1)
                memory.write32(effective_address , value)
                state.set_mar(1 , effective_address + m)

        else: 
                raise ValueError("Gecersiz adresleme kipi")


def mmov32_rr(state:ClaState , mra , mrb , cndf = UNCF):

        value = state.get_mr(mrb)

        if(kosul_saglandi(state , cndf)):

                state.set_mr(mra , value)

                if(cndf == UNCF):

                 state.update_nz(value)

def mmov32_mem_mstf(state:ClaState , mem32 , memory:ClaMemory , kip , m):

        address = effective_address(state , mem32 , kip , m)

        memory.write32(address , state.mstf)

def mmov32_mstf_mem(state:ClaState , mem32 , memory:ClaMemory , kip , m):

        MEALLOW = (state.mstf>>11)%2

        address = effective_address(state , mem32 , kip , m )

        value = memory.read32(address)

        state.mstf = value&0x00FFFA4F

        state._set_bit(11 , MEALLOW)

def mmovd32(state:ClaState , mra , mem32 , memory:ClaMemory , kip , m):

                address = effective_address(state , mem32 , kip , m)

                value = memory.read32(address)
                state.set_mr(mra , value)
                memory.write32(address+2 , value)

                state.update_nz(value)


# #####################################################################
#  ops_control.py
# #####################################################################

# =====================================================================
#  ops_control.py - MEALLOW, MEDIS, MTESTTF, MSETFLG
# ---------------------------------------------------------------------
#  s.615, s.616, s.697, s.686. MSETFLG'de FLAG bit 7 -> MSTF bit 9 (RND32).
#  MEALLOW biti saklanir ama korumali yazmac modellenmedigi icin
#  uygulanmaz (kapsam disi).
# =====================================================================




MASKE_BAYRAK = {7: 9, 6: 6, 3: 3, 2: 2, 1: 1, 0: 0}



def meallow(state:ClaState):
    state.meallow = 1


def medis(state:ClaState):
    state.meallow = 0


def mtesttf(state:ClaState , cndf):

    if(kosul_saglandi(state , cndf)):
        state.tf = 1

    else : 
        state.tf = 0


def msetflg(state:ClaState , FLAG:int , VALUE:int):



    for i,j in MASKE_BAYRAK.items():
        if((FLAG>>i) % 2 == 1):
            state._set_bit(j , (VALUE>>i)%2)


# #####################################################################
#  ops_parallel.py
# #####################################################################

# =====================================================================
#  ops_parallel.py - paralel komutlar (s.582)
# ---------------------------------------------------------------------
#  Aritmetik || MMOV32 (yukle/sakla), MMPYF32 || MADDF32/MSUBF32,
#  MMACF32 || MMOV32. Butun kaynaklar YAZMADAN ONCE okunur; saklama
#  MRa'nin eski degerini yazar. ZF/NF yalniz yukleme yarisindan;
#  LUF/LVF iki yarinin OR'u. MRa == MRd gibi kisit ihlalleri hata verir.
# =====================================================================



def msubf32_rrr_mmov32_ri(state:ClaState , mrd:int , mre:int , mrf:int , mra:int , mem32:int , kip:int , m:int , memory:ClaMemory):

    if(mrd == mra):
        raise ValueError("Bir yazmaca ayni anda birden fazla kaynaktan yazma yapilamaz")
       
    e = state.get_mr_float(mre)
    f = state.get_mr_float(mrf)
    
    address = effective_address(state , mem32 , kip , m)
    value = memory.read32(address)

    _sonuclandir(state , mrd, _tam(e) - _tam(f))
    state.update_nz(value)

    state.set_mr(mra ,value )


def maddf32_rrr_mmov32_ri(state:ClaState , mrd:int , mre:int , mrf:int , mra:int , mem32:int , kip:int , m:int , memory:ClaMemory):

    if(mrd == mra):
        raise ValueError("Bir yazmaca ayni anda birden fazla kaynaktan yazma yapilamaz")
       
    e = state.get_mr_float(mre)
    f = state.get_mr_float(mrf)
    
    address = effective_address(state , mem32 , kip , m)
    value = memory.read32(address)

    _sonuclandir(state , mrd, _tam(e) + _tam(f))
    state.update_nz(value)

    state.set_mr(mra ,value )

def maddf32_rrr_mmov32_ir(state:ClaState , mrd:int , mre:int , mrf:int , mra:int , mem32:int , kip:int , m:int , memory:ClaMemory):

    
       
    e = state.get_mr_float(mre)
    f = state.get_mr_float(mrf)
    
    address = effective_address(state , mem32 , kip , m)
    value = state.get_mr(mra)

    _sonuclandir(state , mrd, _tam(e) + _tam(f))
    memory.write32(address , value)


def mmpyf_32_rrr_mmov32_ri(state:ClaState , mrd:int , mre:int , mrf:int , mra:int , mem32:int , kip:int , m:int , memory:ClaMemory):

    if(mrd == mra):
        raise ValueError("Bir yazmaca ayni anda birden fazla kaynaktan yazma yapilamaz")
       
    e = state.get_mr_float(mre)
    f = state.get_mr_float(mrf)
    
    address = effective_address(state , mem32 , kip , m)
    value = memory.read32(address)

    _sonuclandir(state , mrd, _tam(e) * _tam(f))
    state.update_nz(value)

    state.set_mr(mra ,value )



def mmpyf32_rrr_mmov32_ir(state:ClaState , mrd:int , mre:int , mrf:int , mra:int , mem32:int , kip:int , m:int , memory:ClaMemory):

    
       
    e = state.get_mr_float(mre)
    f = state.get_mr_float(mrf)
    
    address = effective_address(state , mem32 , kip , m)
    value = state.get_mr(mra)

    _sonuclandir(state , mrd, _tam(e) * _tam(f))
    memory.write32(address , value)
    


    
def msubf32_rrr_mmov32_ir(state:ClaState , mrd:int , mre:int , mrf:int , mra:int , mem32:int , kip:int , m:int , memory:ClaMemory):

    
       
    e = state.get_mr_float(mre)
    f = state.get_mr_float(mrf)
    
    address = effective_address(state , mem32 , kip , m)
    value = state.get_mr(mra)

    _sonuclandir(state , mrd, _tam(e) - _tam(f))
    memory.write32(address , value)


def mmpyf32_rrr_maddf32_rrr(state:ClaState , mra , mrb, mrc , mrd , mre , mrf):

    if(mrd == mra):
            raise ValueError("Bir yazmaca ayni anda birden fazla kaynaktan yazma yapilamaz")
           

    b = state.get_mr_float(mrb)

    c = state.get_mr_float(mrc)

    e = state.get_mr_float(mre)

    f = state.get_mr_float(mrf)


    _sonuclandir(state , mrd , _tam(e) + _tam(f))

    _sonuclandir(state , mra, _tam(b) * _tam(c))


def mmpyf32_rrr_msubf32_rrr(state:ClaState , mra , mrb, mrc , mrd , mre , mrf):

    if(mrd == mra):
            raise ValueError("Bir yazmaca ayni anda birden fazla kaynaktan yazma yapilamaz")
           

    b = state.get_mr_float(mrb)

    c = state.get_mr_float(mrc)

    e = state.get_mr_float(mre)

    f = state.get_mr_float(mrf)


    _sonuclandir(state , mrd , _tam(e) - _tam(f))

    _sonuclandir(state , mra , _tam(b) * _tam(c))

def mmacf32_rrrrr_mmov32_ri(state:ClaState , mr3 , mr2, mrd , mre , mrf , mra , mem32 , memory:ClaMemory , m , kip):

    if(mr3 == mra or mrd == mra ):   
                    
                    raise ValueError("Bir yazmaca ayni anda birden fazla kaynaktan yazma yapilamaz")

    mr3_value = state.get_mr_float(mr3)
    mr2_value = state.get_mr_float(mr2)

    e = state.get_mr_float(mre)
    f = state.get_mr_float(mrf)
    
    address = effective_address(state , mem32 , kip , m)

    value = memory.read32(address)

    _sonuclandir(state , mrd , _tam(e) * _tam(f))
    _sonuclandir(state , mr3 , _tam(mr3_value) + _tam(mr2_value))

    state.set_mr(mra ,value )

    state.update_nz(value)


# #####################################################################
#  ops_branch.py
# #####################################################################

# =====================================================================
#  ops_branch.py - MBCNDD / MCCNDD / MRCNDD / MNOP / MDEBUGSTOP
# ---------------------------------------------------------------------
#  TRM s.600, s.605, s.683, s.681, s.614. YALNIZ ARDISIK model kullanir;
#  boru hatti dallanma kararini ve hedefi D2'de kendisi verir
#  (pipeline.d2), 3 gecikme yuvasiyla (s.579).
#  Hedef = dalin KENDI adresi + isaretli ofset (model_kararlari §47.1).
#  MDEBUGSTOP kesme noktalari kapaliyken MNOP'tur (s.614).
# =====================================================================



def mnop():
    pass



def mdebugstop(cekirdek = None):
        pass        
    


def mbcndd(bit_dst16, CNDF, state, pc=None):
    if kosul_saglandi(state, CNDF):
        # taban = dalin kendi adresi (s.600 'MPC += 16BitDest', §47). Ardisik
        # modelde dagit sirasinda state.mpc sonraki komutu gosteriyor -> -2.
        taban = (state.mpc - 2) if pc is None else pc
        state.mpc = (taban + bit_dst16) & 0xFFF

def mccndd(bit_dst16, CNDF, state: ClaState, pc=None):
    """MCCNDD - Call Conditional Delayed (s.605).

        if (CNDF == TRUE) { RPC = return address; MPC += 16BitDest; }

    Iki baglamda da calisir, ayrimi `pc` yapar:

    pc is None  -> ARDISIK model (ClaCore). getir() MPC'yi zaten komuttan
                   sonraki konuma ilerletmis; gecikme yuvasi KAVRAMI YOK,
                   bu yuzden donus adresi dogrudan o konumdur.

    pc verilmis -> BORU HATTI. MCCNDD'den sonraki UC komut gecikme yuvasi
                   olarak her halukarda calisir (s.579), dolayisiyla donus
                   adresi pc+8 olmalidir - pc+6 secilseydi ucuncu yuva her
                   cagride IKI KEZ calisirdi.
                   NOT: boru hatti bu fonksiyonu cagirmiyor; karari ve
                   RPC yazmasini D2'de kendisi yapiyor (s.652). Buradaki dal
                   referans/regresyon icin duruyor.

    KAPANDI (model_kararlari §32.1): s.606 ve Tablo 10-13 dipnotu
    donus adresini I8 = pc+8 olarak veriyor.
    bkz. model_kararlari.md
    """
    if not kosul_saglandi(state, CNDF):
        return False

    if pc is None:                       # ardisik model
        state.rpc = state.mpc & 0xFFF
        state.mpc = (state.mpc - 2 + bit_dst16) & 0xFFF     # taban = dalin adresi (§47)
    else:                                # boru hatti semantigi
        state.rpc = (pc + 8) & 0xFFF
        state.mpc = (pc + bit_dst16) & 0xFFF
    return True


def mrcndd(CNDF, state: ClaState, pc=None):
    """MRCNDD - Return Conditional Delayed (s.683).

        if (CNDF == TRUE) MPC = RPC;

    ISA sozdizimi "MRCNDD {CNDF}" - ofset alani YOK, tek alan cndf.
    Hedef PC'ye gore bir ofset degil, dogrudan RPC. Bu yuzden `pc`
    parametresi sadece mbcndd/mccndd ile imza birligi icin duruyor,
    KULLANILMIYOR.

    ARDISIK model: mccndd'nin yazdigi RPC (MCCNDD'den sonraki konum)
    dogrudan MPC'ye kopyalanir; gecikme yuvasi kavrami yok.

    BORU HATTI bu fonksiyonu CAGIRMIYOR: hem karar hem MPC yazmasi D2'de
    yapiliyor (MBCNDD/MCCNDD ile ayni asama, 3 gecikme yuvasi icin -
    s.579). Buradaki dal ardisik model ve iki modelin regresyon
    karsilastirmasi icin var.
    """
    if not kosul_saglandi(state, CNDF):
        return False
    state.mpc = state.rpc & 0xFFF
    return True


# #####################################################################
#  dagitici.py
# #####################################################################

# =====================================================================
#  dagitici.py - cozulmus komutu ilgili ops_* fonksiyonuna baglar
# ---------------------------------------------------------------------
#  Anahtar: isa/cla_type0.yaml'daki syntax dizgisi; alan adlari yaml'dan.
#  Iki model de bunu kullanir. Boru hatti dallanmalari (MBCNDD/MCCNDD/
#  MRCNDD) ve MSTOP'u D2'de kendisi isler, buraya getirmez.
#  Dali olmayan kodlama BaglanmamisKomutError verir - sessiz no-op yok.
# =====================================================================


class BaglanmamisKomutError(Exception):
    """Kodlama tabloda var ama dagit() icinde bir dali yok."""



_MAR_INDEKS = None

def _mar_indeksi(entry):
    """MARx komutlarinda hedef MAR adlandirilmis bir alan DEGIL.

    Tabloda MAR0 ve MAR1 iki ayri kodlama olarak duruyor ve onlari ayiran
    bit komuta gore degisiyor: MMOVI16'da bit 21, MMOV16 MARx, mem16'da
    bit 22. Bu yuzden bit numarasi elle yazilmiyor - ayni syntax'i
    paylasan iki kodlamanin 'msw' deseni karsilastirilip fark bulunuyor.
    Tek bitte ayrilmiyorlarsa hata veriyor, sessizce yanlis secmiyor."""
    global _MAR_INDEKS
    if _MAR_INDEKS is None:
        gruplar = {}
        for e in load_table():
            if "MARx" in e["syntax"]:
                gruplar.setdefault(e["syntax"], []).append(e)
        _MAR_INDEKS = {}
        for syntax, kodlamalar in gruplar.items():
            if len(kodlamalar) != 2:
                raise ValueError("%s icin 2 kodlama bekleniyordu, %d var"
                                 % (syntax, len(kodlamalar)))
            a, b = kodlamalar
            farkli = [i for i, (x, y) in enumerate(zip(a["msw"], b["msw"]))
                      if x != y]
            if len(farkli) != 1:
                raise ValueError("%s: msw desenleri tek bitte ayrilmiyor (%s)"
                                 % (syntax, farkli))
            i = farkli[0]
            for e in kodlamalar:
                _MAR_INDEKS[e["match"]] = int(e["msw"][i])
    return _MAR_INDEKS[entry["match"]]



def dagit(decoded_instruction : DecodedInstruction , state = None , memory = None , cekirdek = None , pc = None , dal_alindi = None ):
        """Cozulmus komudu ilgili ops_* fonksiyonuna baglar.

        TUZAK 1: #SHIFT alaninda kodlama 0 -> 1 bit kaydirma (Tablo 10-7),
                 o yuzden +1.
        TUZAK 2: CNDF alani cozulmus komutta yoksa varsayilan UNCF
                 (Tablo 10-9 dipnot 2, s.586) - NEQ degil.
        """
        st, mem = state, memory
        alan   = decoded_instruction.fields
        syntax = decoded_instruction.syntax

        if syntax == "MABSF32 MRa, MRb":
            mabsf32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MADD32 MRa, MRb, MRc":
            madd32_rrr(st, mra=alan['a'], mrb=alan['b'], mrc=alan['c'])

        elif syntax == "MADDF32 MRa, #16FHi, MRb":
            maddf32_imm(st, mra=alan['a'], upper_16=alan['I'], mrb=alan['b'])

        elif syntax == "MADDF32 MRa, MRb, MRc":
            maddf32_rrr(st, mra=alan['a'], mrb=alan['b'], mrc=alan['c'])

        elif syntax == "MAND32 MRa, MRb, MRc":
            mand32_rrr(st, mra=alan['a'], mrb=alan['b'], mrc=alan['c'])

        elif syntax == "MASR32 MRa, #SHIFT":
            masr32_ri(st, mra=alan['a'], shift=alan['shift'] + 1)

        elif syntax == "MCMP32 MRa, MRb":
            mcmp32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MCMPF32 MRa, #16FHi":
            mcmpf32_imm(st, mra=alan['a'], imm=alan['I'])

        elif syntax == "MCMPF32 MRa, MRb":
            mcmpf32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MF32TOI16 MRa, MRb":
            mf32toi16_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MF32TOI16R MRa, MRb":
            mf32toi16r_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MF32TOI32 MRa, MRb":
            mf32toi32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MF32TOUI16 MRa, MRb":
            mf32toui16_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MF32TOUI16R MRa, MRb":
            mf32toui16r_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MF32TOUI32 MRa, MRb":
            mf32toui32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MFRACF32 MRa, MRb":
            mfracf32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MI16TOF32 MRa, MRb":
            mi16tof32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MI32TOF32 MRa, MRb":
            mi32tof32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MLSL32 MRa, #SHIFT":
            mlsl32_ri(st, mra=alan['a'], shift=alan['shift'] + 1)

        elif syntax == "MLSR32 MRa, #SHIFT":
            mlsr32_ri(st, mra=alan['a'], shift=alan['shift'] + 1)

        elif syntax == "MMAXF32 MRa, #16FHi":
            mmaxf32_imm(st, mra=alan['a'], upper_16=alan['I'])

        elif syntax == "MMAXF32 MRa, MRb":
            mmaxf32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MMINF32 MRa, #16FHi":
            mminf32_imm(st, mra=alan['a'], upper_16=alan['I'])

        elif syntax == "MMINF32 MRa, MRb":
            mminf32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MMPYF32 MRa, #16FHi, MRb":
            mmpyf32_imm(st, mra=alan['a'], upper_16=alan['I'], mrb=alan['b'])

        elif syntax == "MEINVF32 MRa, MRb":
            minvf32(st , mra = alan['a'] , mrb = alan['b'])

        elif syntax == "MEISQRTF32 MRa, MRb":
            misqrtf32(st , mra = alan['a'] , mrb = alan['b'])

        elif syntax == "MMPYF32 MRa, MRb, MRc":
            mmpyf32_rrr(st, mra=alan['a'], mrb=alan['b'], mrc=alan['c'])

        elif syntax == "MNEGF32 MRa, MRb{, CNDF}":
            mnegf32_rrc(st, mra=alan['a'], mrb=alan['b'], cndf=alan.get('cndf', UNCF))

        elif syntax == "MOR32 MRa, MRb, MRc":
            mor32_rrr(st, mra=alan['a'], mrb=alan['b'], mrc=alan['c'])

        elif syntax == "MSUB32 MRa, MRb, MRc":
            msub32_rrr(st, mra=alan['a'], mrb=alan['b'], mrc=alan['c'])

        elif syntax == "MSUBF32 MRa, #16FHi, MRb":
            msubf32_imm(st, mra=alan['a'], upper_16=alan['I'], mrb=alan['b'])

        elif syntax == "MSUBF32 MRa, MRb, MRc":
            msubf32_rrr(st, mra=alan['a'], mrb=alan['b'], mrc=alan['c'])

        elif syntax == "MSWAPF MRa, MRb {, CNDF}":
            mswapf_rrc(st, mra=alan['a'], mrb=alan['b'], cndf=alan.get('CNDF', UNCF))

        elif syntax == "MUI16TOF32 MRa, MRb":
            mui16tof32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MUI32TOF32 MRa, MRb":
            mui32tof32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MXOR32 MRa, MRb, MRc":
            mxor32_rrr(st, mra=alan['a'], mrb=alan['b'], mrc=alan['c'])

        # --- bellek komutlari: bunlar memory de aliyor (digerleri almiyor) ---
        elif syntax == "MMOVIZ MRa, #16FHi":
            mmoviz_ri(st, mra=alan['a'], upper_16=alan['I'])

        elif syntax == "MMOVXI MRa, #16FLoHex":
            mmovxi_ri(st, mra=alan['a'], lower_16=alan['I'])

        elif syntax == "MMOV32 MRa, mem32 {, CNDF}":
            mmov32_yukle(st, mem,
                mra=alan['a'],
                kip=alan['addr'],
                m=alan['m'],
                cndf=alan.get('cndf', UNCF))

        elif syntax == "MMOV32 MRa, MRb {, CNDF}":
            # Bayraklar YALNIZ UNCF'te guncellenir (s.655). Diger her
            # kosulda tasima olsa bile "No flags modified".
            mmov32_rr(st, mra=alan['a'], mrb=alan['b'],
                cndf=alan.get('cndf', UNCF))

        elif syntax == "MMOV32 mem32, MRa":
            mmov32_sakla(st, mem,
                mra=alan['a'],
                kip=alan['addr'],
                m=alan['m'])

        # --- bellekten okuyup tamsayi->float32 ceviren komutlar ---
        # Dordu de MSTF'e DOKUNMAZ (s.628, 629, 699, 701: "does not affect
        # any flags"). MMOV32 MRa, mem32'den ayrildiklari nokta bu; o UNCF
        # kipinde ZF/NF guncelliyor.
        # Kodlamada tek 16-bit alan var: 'm'. Dogrudan kipte (addr=0000) o
        # alan adres, dolayli kipte (0001/0010) MARx'e eklenecek offset.
        # Bu yuzden mem16/mem32 ve m parametrelerine ayni alan gidiyor.
        elif syntax == "MI16TOF32 MRa, mem16":
            mi16tof32_ri(st, mra=alan['a'], memory=mem,
                mem16=alan['m'], kip=alan['addr'], m=alan['m'])

        elif syntax == "MUI16TOF32 MRa, mem16":
            mui16tof32_ri(st, mra=alan['a'], memory=mem,
                mem16=alan['m'], kip=alan['addr'], m=alan['m'])

        elif syntax == "MI32TOF32 MRa, mem32":
            mi32tof32_ri(st, mra=alan['a'], memory=mem,
                mem32=alan['m'], kip=alan['addr'], m=alan['m'])

        elif syntax == "MUI32TOF32 MRa, mem32":
            mui32tof32_ri(st, mra=alan['a'], memory=mem,
                mem32=alan['m'], kip=alan['addr'], m=alan['m'])

        # --- paralel formlar ---
        # Kural: TUM kaynaklar okunur, SONRA hedefler yazilir. MRa ile MRd
        # cakisirsa aritmetik ESKI degeri gormeli.
        # Bayrak boluşumu: LUF/LVF aritmetikten, ZF/NF ise yukleme yapan
        # MMOV32 yarisindan gelir (TRM: "The MMOV32 Instruction will set
        # the NF and ZF flags"). Saklama varyantlarinda ZF/NF hic kurulmaz.
        # TI kisiti: MRa, MRd ile ayni olamaz -> ops_parallel ValueError verir.
        elif syntax == "MADDF32 MRd, MRe, MRf ||MMOV32 MRa, mem32":
            maddf32_rrr_mmov32_ri(st,
                mrd=alan['d'], mre=alan['e'], mrf=alan['f'],
                mra=alan['a'], mem32=alan['m'],
                kip=alan['addr'], m=alan['m'], memory=mem)

        # SAKLAMA varyantinda ZF/NF KURULMAZ ve MRd==MRa kisiti YOKTUR:
        # iki hedef farkli turde (yazmac / bellek), cakisma olamaz.
        # "MADDF32 MR0,.. || MMOV32 @X, MR0" yasal ve anlamli - ESKI MR0
        # saklanir, toplam MR0'a yazilir.
        elif syntax == "MADDF32 MRd, MRe, MRf||MMOV32 mem32, MRa":
            maddf32_rrr_mmov32_ir(st,
                mrd=alan['d'], mre=alan['e'], mrf=alan['f'],
                mra=alan['a'], mem32=alan['m'],
                kip=alan['addr'], m=alan['m'], memory=mem)

        # Iki aritmetikli formlar: ZF/NF'ye HIC dokunulmaz (bellekten
        # yukleme yok). LUF/LVF ikisinden de mandallanir.
        elif syntax == "MMPYF32 MRa, MRb, MRc||MADDF32 MRd, MRe, MRf":
            mmpyf32_rrr_maddf32_rrr(st,
                mra=alan['a'], mrb=alan['b'], mrc=alan['c'],
                mrd=alan['d'], mre=alan['e'], mrf=alan['f'])

        elif syntax == "MMPYF32 MRa, MRb, MRc ||MSUBF32 MRd, MRe, MRf":
            mmpyf32_rrr_msubf32_rrr(st,
                mra=alan['a'], mrb=alan['b'], mrc=alan['c'],
                mrd=alan['d'], mre=alan['e'], mrf=alan['f'])

        # MMACF32: MR3 ve MR2 kodlamada alan DEGIL, sabit yazmaclar.
        # MR2 ayni komutta hem birikim kaynagi hem carpim hedefi olabilir
        # (TI'nin FIR deyimi, d=2) - oku-sonra-yaz bu yuzden zorunlu.
        # Kisit cift: MRa ne MR3 ne de MRd olabilir.
        elif syntax == "MMACF32 MR3, MR2, MRd, MRe, MRf ||MMOV32 MRa, mem32":
            mmacf32_rrrrr_mmov32_ri(st, mr3=3, mr2=2,
                mrd=alan['d'], mre=alan['e'], mrf=alan['f'],
                mra=alan['a'], mem32=alan['m'], memory=mem,
                m=alan['m'], kip=alan['addr'])

        elif syntax == "MMPYF32 MRd, MRe, MRf ||MMOV32 MRa, mem32":
            mmpyf_32_rrr_mmov32_ri(st,
                mrd=alan['d'], mre=alan['e'], mrf=alan['f'],
                mra=alan['a'], mem32=alan['m'],
                kip=alan['addr'], m=alan['m'], memory=mem)

        elif syntax == "MMPYF32 MRd, MRe, MRf ||MMOV32 mem32, MRa":
            mmpyf32_rrr_mmov32_ir(st,
                mrd=alan['d'], mre=alan['e'], mrf=alan['f'],
                mra=alan['a'], mem32=alan['m'],
                kip=alan['addr'], m=alan['m'], memory=mem)

        elif syntax == "MSUBF32 MRd, MRe, MRf ||MMOV32 mem32, MRa":
            msubf32_rrr_mmov32_ir(st,
                mrd=alan['d'], mre=alan['e'], mrf=alan['f'],
                mra=alan['a'], mem32=alan['m'],
                kip=alan['addr'], m=alan['m'], memory=mem)

        elif syntax == "MSUBF32 MRd, MRe, MRf ||MMOV32 MRa, mem32":
            msubf32_rrr_mmov32_ri(st,
                mrd=alan['d'], mre=alan['e'], mrf=alan['f'],
                mra=alan['a'], mem32=alan['m'],
                kip=alan['addr'], m=alan['m'], memory=mem)

        elif syntax == "MMOVD32 MRa, mem32":
            # s.658: MRa = [mem32] VE [mem32+2] = [mem32].
            # Yukleme komutu ama ayni zamanda bellege yaziyor; +2 ETKIN
            # adrese gore (son artirmadan onceki adres).
            # Bayraklar MMOV32 kuraliyla ama KOSULSUZ - CNDF alani yok.
            mmovd32(st, mra=alan['a'], mem32=alan['m'],
                memory=mem, kip=alan['addr'], m=alan['m'])

        elif syntax == "MMOV32 MSTF, mem32":
            # s.657: "Loading the status register will overwrite all flags
            # and the RPC field. The MEALLOW field is not affected."
            # Ayrilmis bitler (4,5,7,8,10,31-24) Tablo 10-33'e gore hep 0;
            # maske ops_memory'de tek yerde.
            mmov32_mstf_mem(st, mem32=alan['m'], memory=mem,
                kip=alan['addr'], m=alan['m'])

        elif syntax == "MMOV32 mem32, MSTF":
            mmov32_mem_mstf(st, mem32=alan['m'], memory=mem,
                kip=alan['addr'], m=alan['m'])

        # --- MAR ve 16-bit tasima (Grup 4) ---
        # MAR0/MAR1 secimi 'alan' icinde degil, kodlamanin kendisinde;
        # _mar_indeksi onu tablodan turetiyor.
        #
        # DIKKAT: bu komutlarin hepsinin TRM sayfasinda 3 komutluk bir
        # boru hatti gecikmesi anlatiliyor (MAR yuklemesi E fazinda, son
        # artirma D2'de). Model su an gecikmesiz calisiyor; o is
        # pipeline.py'ye ait. Ayrintisi model_kararlari.md 10.5'te.
        elif syntax == "MMOVI16 MARx, #16I":
            x = _mar_indeksi(decoded_instruction.entry)
            (mmovi16_0 if x == 0 else mmovi16_1)(st, imm16=alan['I'])

        elif syntax == "MMOV16 MARx, MRa, #16I":
            x = _mar_indeksi(decoded_instruction.entry)
            (mmov16_0 if x == 0 else mmov16_1)(
                st, mra=alan['A'], imm16=alan['I'])

        elif syntax == "MMOV16 MARx, mem16":
            x = _mar_indeksi(decoded_instruction.entry)
            (mmov16_mar_mem_0 if x == 0 else mmov16_mar_mem_1)(
                st, mem16=alan['m'], memory=mem,
                kip=alan['addr'], m=alan['m'])

        elif syntax == "MMOV16 mem16, MARx":
            x = _mar_indeksi(decoded_instruction.entry)
            (mmov16_mem_mar_0 if x == 0 else mmov16_mem_mar_1)(
                st, mem16=alan['m'], memory=mem,
                kip=alan['addr'], m=alan['m'])

        elif syntax == "MMOV16 mem16, MRa":
            mmov16_mem_mra(st, mem16=alan['m'], mra=alan['a'],
                memory=mem, kip=alan['addr'], m=alan['m'])

        elif syntax == "MMOVZ16 MRa, mem16":
            mmovz16(st, mem16=alan['m'], mra=alan['a'],
                memory=mem, kip=alan['addr'], m=alan['m'])

        # --- gorev sonu ---
        # MSTOP komut setinin parcasi; ayrica gorev hakemligini tetikler.
        # Tespit CEKIRDEGIN isi - hakem komut kelimesini gormez, sadece
        # "gorev bitti" haberini alir. Ileride MDEBUGSTOP ve SOFTRESET de
        # ayni haberi verecek.
        elif syntax == "MSTOP":
         if cekirdek is not None:                  # ardisik model
            cekirdek.durdu = True
            if cekirdek.arbiter is not None:
                cekirdek.arbiter.gorev_bitti()

        # --- bayrak / koruma komutlari: yalniz MSTF'e dokunurlar ---
        elif syntax == "MEALLOW":
            meallow(st)

        elif syntax == "MEDIS":
            medis(st)

        elif syntax == "MTESTTF CNDF":
            mtesttf(st, cndf=alan['cndf'])

        elif syntax == "MSETFLG FLAG, VALUE":
            # DIKKAT: F/V maskesinin bit duzeni MSTF ile AYNI DEGIL.
            # RND32 maskede 7'de, MSTF'te 9'da (s.686 ornegi). Esleme
            # ops_control.MASKE_BAYRAK icinde, tek yerde.
            msetflg(st, FLAG=alan['F'], VALUE=alan['V'])


        #Branch komutlari

        elif syntax == "MNOP":
            mnop()


        elif syntax == "MDEBUGSTOP":
            mdebugstop(cekirdek)

        # MBCNDD: kosul DOGRUysa MPC += isaretli 16BitDest (s.600).
        # Taban dalin KENDI adresi (MPC = D2'deki komut, s.717; TI cl2000
        # ciktisiyla ayni - model_kararlari §47.1). Bu dal yalniz ardisik
        # model icin; boru hatti dallanmayi D2'de kendisi isler.
        elif syntax == "MBCNDD 16BitDest {, CNDF}":
            mbcndd(alan['dest'], alan.get('cndf', UNCF), st , pc)


        elif syntax == "MCCNDD 16BitDest {, CNDF}":
            mccndd(alan['dest'], alan.get('cndf', UNCF), st, pc)

        # MRCNDD: hedef RPC, ofset alani yok (s.683). Boru hatti bu dala
        # ugramaz - D2'de kendisi hallediyor; bu dal ardisik model icin.
        elif syntax == "MRCNDD {CNDF}":
            mrcndd(alan.get('cndf', UNCF), st)



        else:
            raise BaglanmamisKomutError(
                "%s bir ops_* fonksiyonuna baglanmamis" % syntax)

        

        


# #####################################################################
#  erisim.py
# #####################################################################

# -*- coding: utf-8 -*-
# Komut basina BELLEK / MAR erisim tablosu.
#
# Boru hattinda her asamanin "bu komut icin bende is var mi" sorusunu
# `decoded.fields` icini kurcalamadan cevaplayabilmesi icin.
#
#     D2  -> adres uretilecek mi          : adres_uretir(cozum)
#     R2  -> bellekten okunacak mi        : okur(cozum)
#     W   -> bellege yazilacak mi         : yazar(cozum)
#     EXE -> MAR yuklemesi var mi         : mar_yukler(cozum)
#
# Kumelerin anahtari ISA tablosundaki `syntax` dizesi - `DecodedInstruction`
# zaten onu tasiyor, yani ek bir esleme gerekmiyor.
#
# DIKKAT - bu liste ELLE bakilarak degil, her komut sahte bir bellekle
# calistirilip `read*/write*` cagrilip cagrilmadigi OLCULEREK cikarildi.
# `tests/test_erisim.py` ayni olcumu her kosuda tekrarlar; tablo ile gercek
# davranis ayrismaya baslarsa test kirilir. Yeni komut baglandiginda once
# test kirilir, sonra buraya eklenir - tersi degil.

# ---------------------------------------------------------------------
#  R2'de bellekten okur
# ---------------------------------------------------------------------
OKUR32 = frozenset({
    "MMOV32 MRa, mem32 {, CNDF}",
    "MMOV32 MSTF, mem32",
   
    "MMOVD32 MRa, mem32",
  
    "MI32TOF32 MRa, mem32",
    
    "MUI32TOF32 MRa, mem32",
    "MADDF32 MRd, MRe, MRf ||MMOV32 MRa, mem32",
    "MSUBF32 MRd, MRe, MRf ||MMOV32 MRa, mem32",
    "MMPYF32 MRd, MRe, MRf ||MMOV32 MRa, mem32",
    "MMACF32 MR3, MR2, MRd, MRe, MRf ||MMOV32 MRa, mem32",
})

OKUR16 = frozenset({
   
    "MMOVZ16 MRa, mem16",
    
    "MMOV16 MARx, mem16",
    "MI16TOF32 MRa, mem16",
    
    "MUI16TOF32 MRa, mem16",
   
   
})


# ---------------------------------------------------------------------
#  W'de bellege yazar
# ---------------------------------------------------------------------
YAZAR32 = frozenset({
    "MMOV32 mem32, MRa",
    "MMOV32 mem32, MSTF",

    "MMOVD32 MRa, mem32",                      # hem okur hem yazar
    "MADDF32 MRd, MRe, MRf||MMOV32 mem32, MRa",
    "MSUBF32 MRd, MRe, MRf ||MMOV32 mem32, MRa",
    "MMPYF32 MRd, MRe, MRf ||MMOV32 mem32, MRa",
})

YAZAR16 = frozenset({
  
    "MMOV16 mem16, MRa",
    "MMOV16 mem16, MARx",

})

# ---------------------------------------------------------------------
#  EXE'de MAR0/MAR1 YUKLER  (post-increment degil - o D2'de olur)
#
#  Gecikme icin ozel kod GEREKMEZ: yukleme EXE'de (7. asama), okuma D2'de
#  (4. asama) oldugundan s.580'deki (Ornek 10-2) 3 komutluk golge gecikmesi boru
#  hattinin kendisinden cikar.
# ---------------------------------------------------------------------
MAR_YUKLER = frozenset({
    "MMOVI16 MARx, #16I",
    "MMOV16 MARx, MRa, #16I",
    "MMOV16 MARx, mem16",                      # ayrica bellekten OKUR
})

#  D2'de efektif adres uretilecek komutlar
ADRES_URETIR = OKUR16 | YAZAR16 | OKUR32 | YAZAR32

#  Henuz dagitici.py'de dali olmayan komutlar. Boru hatti bunlari
#  gorurse tabloya degil, BaglanmamisKomutError'a guvenmeli.
BAGLANMAMIS = frozenset()      # 24.09: MEINVF32/MEISQRTF32 baglandi, hepsi dagitildi

DALLANIR = frozenset({
        "MBCNDD 16BitDest {, CNDF}",
    "MCCNDD 16BitDest {, CNDF}",
    "MRCNDD {CNDF}",
})

K2_YAZAR = frozenset({
    # FP sonucu K2'de (W sonunda) yazilan butun bicimler (15)
    "MADDF32 MRa, MRb, MRc",
    "MADDF32 MRa, #16FHi, MRb",
    "MSUBF32 MRa, MRb, MRc",
    "MSUBF32 MRa, #16FHi, MRb",
    "MMPYF32 MRa, MRb, MRc",
    "MMPYF32 MRa, #16FHi, MRb",
    "MMPYF32 MRa, MRb, MRc||MADDF32 MRd, MRe, MRf",
    "MMPYF32 MRa, MRb, MRc ||MSUBF32 MRd, MRe, MRf",
    "MADDF32 MRd, MRe, MRf ||MMOV32 MRa, mem32",
    "MSUBF32 MRd, MRe, MRf ||MMOV32 MRa, mem32",
    "MMPYF32 MRd, MRe, MRf ||MMOV32 MRa, mem32",
    "MMACF32 MR3, MR2, MRd, MRe, MRf ||MMOV32 MRa, mem32",
    "MADDF32 MRd, MRe, MRf||MMOV32 mem32, MRa",
    "MSUBF32 MRd, MRe, MRf ||MMOV32 mem32, MRa",
    "MMPYF32 MRd, MRe, MRf ||MMOV32 mem32, MRa", 
                                    # ayrica bellekten OKUR
})


# ---------------------------------------------------------------------
#  Yardimcilar - cozum None (balon) ise hepsi False doner
# ---------------------------------------------------------------------




def _syntax(cozum):
    if cozum is None:
        return None
    if isinstance(cozum, str):
        return cozum
    return getattr(cozum, "syntax", None)

def dallanir(cozum):
    return _syntax(cozum ) in DALLANIR

def okur16(cozum):
    """R2'de bellekten okuma yapilacak mi."""
    return _syntax(cozum) in OKUR16

def okur32(cozum):
    """R2'de bellekten okuma yapilacak mi."""
    return _syntax(cozum) in OKUR32


def yazar32(cozum):
    """W'de bellege yazma yapilacak mi."""
    return _syntax(cozum) in YAZAR32


def yazar16(cozum):
    """W'de bellege yazma yapilacak mi."""
    return _syntax(cozum) in YAZAR16


def adres_uretir(cozum):
    """D2'de efektif adres uretilecek mi."""
    return _syntax(cozum) in ADRES_URETIR


def mar_yukler(cozum):
    """EXE'de MAR0/MAR1 yuklenecek mi."""
    return _syntax(cozum) in MAR_YUKLER


def baglanmamis(cozum):
    """Komutun dagitici.py'de dali var mi."""
    return _syntax(cozum) in BAGLANMAMIS

def k2_yazar(cozum):
    """Komut K2'de yazmaca yazma yapar mi"""
    return _syntax(cozum) in K2_YAZAR


#  K2'de yazilan MR'ler buyrugun ALANLARINDAN belirlenir (cagri sirasindan degil).
#  Paralel yuklemenin MRa'si ve ZF/NF'si EXE'de kalir; yalniz FP yarisi ertelenir.
#  MMACF32: MR3 (toplama) ve MRd (carpma). MRd == MR3 ise golden sozlukte sonra
#  yazilan toplamayi tutar - ALU'daki "toplayici > carpici" onceligiyle ayni.
def k2_hedefler(cozum):
    """Komutun K2'de (W sonunda) yazdigi MR numaralari; K2 komutu degilse bos."""
    syntax = _syntax(cozum)
    if syntax not in K2_YAZAR:
        return frozenset()
    alan = cozum.fields
    if syntax.startswith("MMACF32"):
        return frozenset({3, alan['d']})
    if "||MADDF32" in syntax or "||MSUBF32" in syntax:
        return frozenset({alan['a'], alan['d']})
    if "MMOV32" in syntax:
        return frozenset({alan['d']})
    return frozenset({alan['a']})



# ---------------------------------------------------------------------
#  EXE'de OKUNAN MR'ler (M3 interlock, dur_exe)
#
#  Anahtar: syntax. Deger: okunan MR'lerin alan adlari (dagitici.py'deki
#  alan[...] adlariyla ayni). Tamsayi ise sabit MR numarasidir (MMACF32'nin
#  MR3 ve MR2'si kodlamada alan degildir).
#  Kosul tutmasa da okunan sayilir (MMOV32 MRa,MRb ve MSWAPF): donanim
#  kosulu EXE'de cozer, okuma ondan once/onunla birlikte yapilir.
#  Listede olmayan buyruk MR okumaz (bellekten yukleme/donusum, MMOVIZ,
#  MAR yuklemeleri, MSTF tasimalari, MSETFLG, MTESTTF, dallar, MSTOP, MNOP...).
# ---------------------------------------------------------------------
OKUNAN_MR_ALANLARI = {
    # tamsayi ve FP aritmetik, uc yazmacli
    "MADD32 MRa, MRb, MRc":  ("b", "c"),
    "MSUB32 MRa, MRb, MRc":  ("b", "c"),
    "MAND32 MRa, MRb, MRc":  ("b", "c"),
    "MOR32 MRa, MRb, MRc":   ("b", "c"),
    "MXOR32 MRa, MRb, MRc":  ("b", "c"),
    "MADDF32 MRa, MRb, MRc": ("b", "c"),
    "MSUBF32 MRa, MRb, MRc": ("b", "c"),
    "MMPYF32 MRa, MRb, MRc": ("b", "c"),
    # anlikli FP: MRb
    "MADDF32 MRa, #16FHi, MRb": ("b",),
    "MSUBF32 MRa, #16FHi, MRb": ("b",),
    "MMPYF32 MRa, #16FHi, MRb": ("b",),
    # tek kaynakli: MRb
    "MABSF32 MRa, MRb":         ("b",),
    "MNEGF32 MRa, MRb{, CNDF}": ("b",),
    "MEINVF32 MRa, MRb":        ("b",),
    "MEISQRTF32 MRa, MRb":      ("b",),
    "MF32TOI16 MRa, MRb":       ("b",),
    "MF32TOI16R MRa, MRb":      ("b",),
    "MF32TOI32 MRa, MRb":       ("b",),
    "MF32TOUI16 MRa, MRb":      ("b",),
    "MF32TOUI16R MRa, MRb":     ("b",),
    "MF32TOUI32 MRa, MRb":      ("b",),
    "MFRACF32 MRa, MRb":        ("b",),
    "MI16TOF32 MRa, MRb":       ("b",),
    "MI32TOF32 MRa, MRb":       ("b",),
    "MUI16TOF32 MRa, MRb":      ("b",),
    "MUI32TOF32 MRa, MRb":      ("b",),
    "MMOV32 MRa, MRb {, CNDF}": ("b",),
    # iki kaynakli: MRa ve MRb
    "MCMPF32 MRa, MRb":         ("a", "b"),
    "MCMP32 MRa, MRb":          ("a", "b"),
    "MMAXF32 MRa, MRb":         ("a", "b"),
    "MMINF32 MRa, MRb":         ("a", "b"),
    "MSWAPF MRa, MRb {, CNDF}": ("a", "b"),
    # MRa'yi okuyanlar
    "MCMPF32 MRa, #16FHi":      ("a",),
    "MMAXF32 MRa, #16FHi":      ("a",),
    "MMINF32 MRa, #16FHi":      ("a",),
    "MLSL32 MRa, #SHIFT":       ("a",),
    "MLSR32 MRa, #SHIFT":       ("a",),
    "MASR32 MRa, #SHIFT":       ("a",),
    "MMOVXI MRa, #16FLoHex":    ("a",),     # ust 16 bit korunur -> MRa okunur
    "MMOV32 mem32, MRa":        ("a",),     # saklanan deger EXE'de okunur
    "MMOV16 mem16, MRa":        ("a",),
    "MMOV16 MARx, MRa, #16I":   ("A",),     # dagitici'da alan adi 'A'
    # paralel
    "MMPYF32 MRa, MRb, MRc||MADDF32 MRd, MRe, MRf":  ("b", "c", "e", "f"),
    "MMPYF32 MRa, MRb, MRc ||MSUBF32 MRd, MRe, MRf": ("b", "c", "e", "f"),
    "MADDF32 MRd, MRe, MRf ||MMOV32 MRa, mem32":     ("e", "f"),
    "MSUBF32 MRd, MRe, MRf ||MMOV32 MRa, mem32":     ("e", "f"),
    "MMPYF32 MRd, MRe, MRf ||MMOV32 MRa, mem32":     ("e", "f"),
    "MADDF32 MRd, MRe, MRf||MMOV32 mem32, MRa":      ("e", "f", "a"),
    "MSUBF32 MRd, MRe, MRf ||MMOV32 mem32, MRa":     ("e", "f", "a"),
    "MMPYF32 MRd, MRe, MRf ||MMOV32 mem32, MRa":     ("e", "f", "a"),
    "MMACF32 MR3, MR2, MRd, MRe, MRf ||MMOV32 MRa, mem32": (3, 2, "e", "f"),
}


def okunan_mr(cozum):
    """Komutun EXE'de okudugu MR numaralari (frozenset). Balon ya da MR
    okumayan komut icin bos kume."""
    alanlar = OKUNAN_MR_ALANLARI.get(_syntax(cozum))
    if not alanlar:
        return frozenset()
    f = cozum.fields
    return frozenset(a if isinstance(a, int) else f[a] for a in alanlar)


# ---------------------------------------------------------------------
#  M4: R1/W bellek durmasi (dur_r1) icin veri blogu.
#  Adres degil BLOK karsilastirilir (TRM s.571-573, s.577).
#  CPU->CLA mesaj RAM'inde (0x1500-0x157F) durma yok: CLA'nin oraya
#  yazmasi yok sayilir. Program RAM'i (L3) veri yolu degil.
# ---------------------------------------------------------------------
def blok(adres):
    """R1/W durmasinda karsilastirilan veri blogu; durma olmayan adres icin None."""
    if adres is None:
        return None
    if 0x8800 <= adres <= 0x8BFF:
        return "L1"
    if 0x8C00 <= adres <= 0x8FFF:
        return "L2"
    if 0x1480 <= adres <= 0x14FF:
        return "C2M"
    return None


def ayni_blok(yazan_ea, okuyan_ea):
    """W'nin yazdigi ve R1'in okudugu adres ayni durma blogunda mi."""
    b = blok(yazan_ea)
    return b is not None and b == blok(okuyan_ea)


# #####################################################################
#  pipeline.py
# #####################################################################

# =====================================================================
#  pipeline.py - 8 kademeli boru hatti (TRM 10.5, s.577-582)
# ---------------------------------------------------------------------
#  ALTIN REFERANS: iz (trace.py) ve RTL karsilastirmasi bu modelden.
#
#  F1  getirme adresi: ic sayac getir_pc (MPC degil)
#  F2  komut kelimesini L3'ten oku
#  D1  coz; gecersiz kelime isaretlenir
#  D2  MPC = bu komut (s.717); adres uretimi + MAR post-increment;
#      dallanma karari ve hedef (taban = dalin adresi, §47.1); MSTOP;
#      gecersiz opcode'da donma, PIE, MIRUN set kalir (s.576)
#  R1  okuma adresi (modelde islem yok)
#  R2  bellekten okuma
#  E   yurutme: dagitici.dagit -> ops_*; yazmac sonuclari, MAR yuklemesi
#      (sonraki 3. komut ayni MAR'i kullanirsa yukleme duser, s.580)
#  W   bellege yazma
#
#  update_pipeline() = bir saat cevrimi. Gorev sonu (Tablo 10-19): MSTOP
#  D2'de (n); bekleyen gorev varsa MSTOP'un balonu R2'deyken (n+2) biter,
#  yeni gorev n+3'te baslar; yoksa R1/R2/E bosalinca (son W'den sonra).
#
#  FPU K1/K2 ve durmalar (model_kararlari §49, §51; uygulandi 05.10.2026):
#  M2  FP sonucu (MR) ve LVF/LUF'u W'nin SONUNDA yazilir: EXE'de kayda
#      ertelenir (k2_hedef_mr, latch_*), cevrimin BASINDA k2_uygula() ile
#      islenir. Boylece ayni cevrimde EXE'nin yazmasi kazanir (MR ve bayrak)
#      ve D2/EXE bekleyen LVF/LUF'u gorur.
#  M3  dur_exe: EXE'deki komut, W'deki FP komutunun K2'de yazacagi bir MR'yi
#      okuyorsa 1 cevrim bekler (erisim.okunan_mr & erisim.k2_hedefler).
#      F1..EXE yerinde kalir, W'ye balon girer.
#  M4  dur_r1: W'deki komut bir bloga yaziyor, R1'deki komut ayni bloktan
#      okuyorsa (erisim.ayni_blok; L1, L2, CLA->CPU mesaj RAM'i) R1 1 cevrim
#      bekler: F1..R1 yerinde kalir, R2'ye balon girer, R2/EXE/W ilerler.
#      Zincirlenir. dur_exe ile ayni cevrime duserse dur_exe baskin.
#  M5  D2 isi (adres, MAR artisi, dal karari, RPC, MSTOP) her komutta bir kez,
#      komut D2'den ILERLEDIGI cevrimde yapilir: durma cevriminde d2()
#      cagrilmaz. Durmada MPC = D2'de bekleyen komut.
#  Kararlar cevrimin sonunda, siradaki cevrim icin verilir (self.dur_exe,
#  self.dur_r1); durma cevrimi bayragi kullanip sifirlar.
# =====================================================================



class BoruBellek:
    """ops fonksiyonu bunu gercek ClaMemory sanir."""

    def __init__(self, kayit):
        self.kayit = kayit

    def read32(self, adres, who="cla"):
        return self.kayit.okunan                  # R2'de zaten okundu

    def read16(self, adres, who="cla"):
        return self.kayit.okunan

    def write32(self, adres, deger, who="cla"):
        self.kayit.yaz_ea = adres                 # uygulanmaz, W yapacak
        self.kayit.yaz_veri = deger

    def write16(self, adres, deger, who="cla"):
        self.kayit.yaz_ea = adres
        self.kayit.yaz_veri = deger


class BoruState:
    """MR / bayrak -> gercek state.  MAR post-inc -> D2'de bitti, tekrarlama."""

    def __init__(self, gercek, kayit):
        object.__setattr__(self, "_gercek", gercek)
        object.__setattr__(self, "_kayit", kayit)

    def get_mar(self, i):
        return self._kayit.mar_before[i]                 # post-inc ONCESI deger

    def set_mar(self, i, v):
        pass                                      # D2'de yapildi

    def __getattr__(self, ad):
        return getattr(self._gercek, ad)

    def __setattr__(self, ad, v):
        setattr(self._gercek, ad, v)

    def set_mr(self , i , v):
         if(i in k2_hedefler(self._kayit.cozum)):      # FP yarisi: W sonunda (K2)
              self._kayit.k2_hedef_mr[i] =v
         
         else:                                           # paralel yuklemenin MRa'si: EXE
              self._gercek.set_mr(i , v)

    
    
    

    def latch_underflow(self):
          if(k2_yazar(self._kayit.cozum)):              # FP: W sonunda (K2)
              self._kayit.latch_underflow = True

          else:
               self._gercek.latch_underflow()             # kestirim vb.: EXE


    def latch_overflow(self):
          if(k2_yazar(self._kayit.cozum)):              # FP: W sonunda (K2)
              self._kayit.latch_overflow = True

          else:
               self._gercek.latch_overflow()              # kestirim vb.: EXE
            
         
         
              
              


class BoruKaydi:

      def __init__(self):
            self.gecerli = 0
            self.pc = None
            self.ham = None
            self.cozum = None
            self.ea = None
            self.mar_no = None
            self.okunan = None
            self.yaz_ea = None
            self.yaz_veri = None
            self.dal_alindi = None
            self.dal_hedef = None
            self.duraksadi = None
            self.mar_before = [None , None]
            self.d2_mar = None
            self.mstop = False        # MSTOP'un balonu: gorev sinirini sayar (Tablo 10-19)
            self.k2_hedef_mr = {}     # M2: W sonunda yazilacak FP sonuclari {MR: deger}
            self.latch_overflow = None    # M2: W sonunda kurulacak LVF
            self.latch_underflow = None   # M2: W sonunda kurulacak LUF
           


class Pipeline:

    def __init__(self , state:ClaState , memory:ClaMemory):
        self.pipeline_kaydi = [BoruKaydi() for _ in range(7)]
        self.state = state
        self.memory = memory
        self.durdu = False
        self.donduruldu = False
        self.getir_pc = None      # getirme sayaci (TRM s.577 F1). MPC ayri: D2'deki komut (s.717)
        self.dur_exe = False      # M3: siradaki cevrim EXE durmasi
        self.dur_r1 = False       # M4: siradaki cevrim R1/W durmasi
        self.exe_bekledi = False  # bu cevrim dur_exe idi (iz: EXE'de bekleyen komut basilir)

    def f1(self ) ->BoruKaydi:

        if not self.durdu:

            kayit = BoruKaydi()


            if self.getir_pc is None:           # gorev basi: MVECTx (state.mpc) -> getirme sayaci
                self.getir_pc = self.state.mpc
            kayit.pc = self.getir_pc

            kayit.gecerli = 1 # F1'e giren kayit gecerli; dallanma/MSTOP sonradan gecersiz yapar
           
            self.getir_pc = (self.getir_pc + 2) & 0xFFF
            
            return  kayit

        gecersiz_kayit = BoruKaydi()
        gecersiz_kayit.gecerli = 0
        return gecersiz_kayit

    def f2(self )->BoruKaydi:

            kopya_kayit = self.pipeline_kaydi[0]

            if(kopya_kayit.gecerli == 1):

                instr = self.memory.fetch32(kopya_kayit.pc)

                kopya_kayit.ham = instr
                return kopya_kayit

            

            gecersiz_kayit = BoruKaydi()
            gecersiz_kayit.gecerli = 0
            return gecersiz_kayit

    def d1(self )->BoruKaydi:

        kopya_kayit = self.pipeline_kaydi[1]

        if(kopya_kayit.gecerli == 1):

            instr = kopya_kayit.ham


            try:
                 decoded_instr = decode(instr)
                 kopya_kayit.cozum = decoded_instr

            except IllegalOpcodeError as i:

             
                 kopya_kayit.duraksadi = True

            



            return  kopya_kayit

        gecersiz_kayit = BoruKaydi()
        gecersiz_kayit.gecerli = 0
        return gecersiz_kayit
            
        

    def d2(self , cekirdek = None)->BoruKaydi:
            

            kopya_kayit = self.pipeline_kaydi[2]
            self.d2_mar = None


            if(kopya_kayit.gecerli == 1):

                  self.state.mpc = kopya_kayit.pc     # MPC = D2'deki komut (TRM s.717)
                  if(kopya_kayit.duraksadi == True):
                    self.donduruldu = True
                    kopya_kayit.gecerli = 0
                    if cekirdek is not None:
                        cekirdek.durdu = True
                        if cekirdek.arbiter is not None:
                            cekirdek.arbiter.pie_kesmeleri.append(cekirdek.arbiter.regs.mirun)
                    return kopya_kayit 


                  
                  decoded_instr:DecodedInstruction = kopya_kayit.cozum
                  syntax = decoded_instr.syntax

                  if(syntax == "MSTOP" ):
                         
                    self.durdu = True
                    self.getir_pc = None        # sonraki gorev MVECTx'ten yuklesin
                    kopya_kayit.mstop = True    # R1 (n+1), R2 (n+2): hakem cevrimleri
                    if cekirdek is not None:                  # cekirdek varsa hakeme haber ver
           
                        if cekirdek.arbiter is not None:
                            cekirdek.arbiter.gorev_bitti()

                  if(adres_uretir(syntax)):

                        m = decoded_instr.fields['m']
                        kip = decoded_instr.fields['addr']
                        mem = m
                        kopya_kayit.mar_before[0] = self.state.mar[0]
                        kopya_kayit.mar_before[1] = self.state.mar[1]
                        if(kip == 0b0001):           
                               
                             kopya_kayit.mar_no = 0
                             self.d2_mar = 0
                            
                        elif(kip == 0b0010):
                             
                             kopya_kayit.mar_no = 1
                             self.d2_mar = 1
                                             
                        kopya_kayit.ea = effective_address(self.state , mem ,kip, m)

                  if(dallanir(syntax)):

                        if(syntax == "MBCNDD 16BitDest {, CNDF}"):
                        
                          cndf = decoded_instr.fields['cndf']
                          dest = decoded_instr.fields['dest']
                          kopya_kayit.dal_alindi = kosul_saglandi(self.state , cndf)
                          if(kopya_kayit.dal_alindi):
                                self.getir_pc = (kopya_kayit.pc + dest) & 0xFFF    # taban = dalin adresi (§47)

                        elif(syntax == "MCCNDD 16BitDest {, CNDF}"):

                             cndf = decoded_instr.fields['cndf']
                             dest = decoded_instr.fields['dest']

                             kopya_kayit.dal_alindi = kosul_saglandi(self.state , cndf)

                             if(kopya_kayit.dal_alindi):
                                taban = self.state.mpc if kopya_kayit.pc is None else kopya_kayit.pc
                                self.getir_pc = (taban + dest) & 0xFFF
                                self.state.rpc = (kopya_kayit.pc+8 ) & 0XFFF


                             



                        elif(syntax == "MRCNDD {CNDF}"):

                             cndf = decoded_instr.fields['cndf']

                             kopya_kayit.dal_alindi = kosul_saglandi(self.state , cndf)

                             if(kopya_kayit.dal_alindi):

                               
                                self.getir_pc = self.state.rpc & 0XFFF
                        kopya_kayit.gecerli = 0

                        


            return  kopya_kayit

    def r1(self )->BoruKaydi:

            kopya_kayit = self.pipeline_kaydi[3]
            
            if(kopya_kayit.gecerli == 1):
                pass


                      
           

            return  kopya_kayit

    def r2(self)->BoruKaydi:

           kopya_kayit = self.pipeline_kaydi[4]
           
        
           if(kopya_kayit.gecerli == 1):



                  
                  syntax = kopya_kayit.cozum.syntax
                  if(okur16(syntax)):
                       okunan = self.memory.read16(kopya_kayit.ea)
                       kopya_kayit.okunan = okunan
                  elif(okur32(syntax)):
                                         
                        okunan = self.memory.read32(kopya_kayit.ea)
                        kopya_kayit.okunan = okunan

           return  kopya_kayit


    def exe(self , cekirdek = None)->BoruKaydi:
            
            kopya_kayit = self.pipeline_kaydi[5]
            sahte_state = BoruState(self.state , kopya_kayit)
            sahte_bellek = BoruBellek(kopya_kayit)
            
           
     

            if(kopya_kayit.gecerli == 1 ):

                            if (mar_yukler(kopya_kayit.cozum) and self.d2_mar is not None  and _mar_indeksi(kopya_kayit.cozum.entry) == self.d2_mar):
                                    
                                return kopya_kayit  


                            dagit(kopya_kayit.cozum, sahte_state, sahte_bellek , cekirdek ) 
            
            

   
            return  kopya_kayit

    def k2_uygula(self):
        """W'deki FP buyrugunun K2 yazmasi (M2). Cevrimin EN BASINDA cagrilir:
        ayni cevrimde EXE'deki buyruk sonra yazdigi icin MR'de ve bayrakta kazanir;
        D2 ve EXE bekleyen LVF/LUF'u gorur. Bellek yazmasi write()'ta, sonda kalir."""

        kayit = self.pipeline_kaydi[6]

        if(kayit.gecerli == 1):

            for i,v in kayit.k2_hedef_mr.items():
                 self.state.set_mr(i , v)

            if(kayit.latch_overflow):
                self.state.latch_overflow()

            if(kayit.latch_underflow):
                 self.state.latch_underflow()

    def write(self , cekirdek = None):

        kayit = self.pipeline_kaydi[6]
        
        if(kayit.gecerli == 1):

            syntax = kayit.cozum.syntax

            if(yazar16(syntax) ):
                 
                 veri = kayit.yaz_veri
                 ea = kayit.yaz_ea
                 self.memory.write16(ea , veri)

            elif(yazar32(syntax) ):
                         
                veri = kayit.yaz_veri
                ea = kayit.yaz_ea
                self.memory.write32(ea , veri)
     


    def update_pipeline(self , cekirdek = None ):
            
            kayit_0 = BoruKaydi()
            kayit_1 = BoruKaydi()
            kayit_2 = BoruKaydi()
            kayit_3 = BoruKaydi()
            kayit_4 = BoruKaydi()
            kayit_5 = BoruKaydi()
            kayit_6 = BoruKaydi()



            if self.donduruldu:

                if cekirdek is not None:

                    cekirdek.durdu = True

                return
            
     
            self.exe_bekledi = self.dur_exe # iz: dur_exe cevriminde EXE'de bekleyen komut basilir
            self.k2_uygula()                # M2: K2 yazmasi cevrimin basinda; dur_exe cevriminde de
                                            # (W'deki FP buyrugu durmadan bagimsiz biter)
            if(self.dur_exe or self.dur_r1):       # durmada D2 calismaz; MPC = D2'de bekleyen buyruk (s.717)
                if(self.pipeline_kaydi[2].gecerli == 1):
                    self.state.mpc = self.pipeline_kaydi[2].pc

            if(not self.dur_exe and not self.dur_r1) :

                kayit_0 = self.f1()
                kayit_1 = self.f2()
                kayit_2 = self.d1()
                kayit_3 = self.d2(cekirdek)
                kayit_4 = self.r1()

            if(not self.dur_exe):

                kayit_5 = self.r2()
                kayit_6 = self.exe(cekirdek) 

           
        
            self.write(cekirdek)
         


            if self.durdu == 1 and not self.dur_exe and not self.dur_r1:      # dur_exe cevriminde boru hatti bos degil
                    
                kayit_3.gecerli = 0
                kayit_2.gecerli = 0
                kayit_1.gecerli = 0
                kayit_0.gecerli = 0
                

                    
                if(cekirdek is not None and kayit_4.gecerli == 0 and kayit_5.gecerli == 0 and kayit_5.mstop and cekirdek.arbiter is not None and cekirdek.arbiter.sonraki_gorev() != None):
                        cekirdek.durdu = True

                elif(cekirdek is not None and kayit_4.gecerli == 0 and kayit_5.gecerli == 0 and kayit_6.gecerli == 0 and (cekirdek.arbiter is None or cekirdek.arbiter.sonraki_gorev() == None)):
                        cekirdek.durdu = True

            if(not self.dur_exe and not self.dur_r1):

                self.pipeline_kaydi[0] = kayit_0
                self.pipeline_kaydi[1] = kayit_1
                self.pipeline_kaydi[2] = kayit_2
                self.pipeline_kaydi[3] = kayit_3
                self.pipeline_kaydi[4] = kayit_4

            if(not self.dur_exe):
                self.pipeline_kaydi[5] = kayit_5
                self.pipeline_kaydi[6] = kayit_6

                # M3: siradaki cevrimin dur_exe karari. kayit_5 simdi EXE'ye, kayit_6 W'ye
                # (K2) gecti: EXE'deki buyruk K2'nin yazacagi bir MR'yi okuyorsa 1 cevrim bekler.

            
            if(self.dur_exe):
                # dur_exe cevrimi: F1..EXE yerinde kaldi; W'deki buyruk bitti -> W'ye balon
                self.pipeline_kaydi[6] = BoruKaydi()
                self.dur_exe = False

            if(self.dur_r1):
                self.pipeline_kaydi[4]= BoruKaydi()
                self.dur_r1 = False
                 
                


            if(kayit_5.gecerli == 1 and kayit_6.gecerli == 1 and
                   (okunan_mr(kayit_5.cozum) & k2_hedefler(kayit_6.cozum))):
                    self.dur_exe = True


            elif((self.pipeline_kaydi[3].gecerli == 1 and  kayit_6.gecerli == 1 )and
                   ((yazar16(kayit_6.cozum.syntax) or yazar32(kayit_6.cozum.syntax)) and (okur16(self.pipeline_kaydi[3].cozum.syntax) or okur32(self.pipeline_kaydi[3].cozum.syntax) ))
                   and ayni_blok(kayit_6.yaz_ea, self.pipeline_kaydi[3].ea)):     # M4: adres degil blok
                    self.dur_r1 = True
                


            

            


   
    
           
    


# #####################################################################
#  task_arbiter.py
# #####################################################################

# =====================================================================
#  task_arbiter.py - gorev hakemi (TRM 10.2.4, 10.7)
# ---------------------------------------------------------------------
#  cevresel_istek(g): MIFR bitini kurar; zaten kuruluysa MIOVF.
#  sonraki_gorev(): MIFR & MIER icinde en kucuk numarali gorev (oncelik).
#  gorev_basla(): MIRUN kurulur, MIFR biti temizlenir, MPC = MVECTx (s.717).
#  gorev_bitti(): MSTOP D2'deyken - MIRUN temizlenir, PIE'ye kesme.
#  Gercek CLA hakemsiz calismaz; hakemsiz yol yalniz birim testleri icin.
# =====================================================================


class AyrilmisBit(Exception):
     pass


class TaskArbiter:

    def __init__(self , regs:ClaRegs):

        self.regs = regs
        self.pie_kesmeleri = []


    def cevresel_istek(self , gorev:int):

        if(not 1<=gorev<=8):
             raise AyrilmisBit("gecersiz gorev numarasi")

        gorev = gorev-1

        mask = (0x0001)<<gorev

       
        mifr_bit = (self.regs.mifr>>gorev)%2

        
        if(mifr_bit == 1):
                self.regs.miovf = self.regs.miovf|(mask&0XFFFF)
        else:
                self.regs.mifr = self.regs.mifr|(mask&0XFFFF)



    def iack(self, mask: int):

          if((self.regs.mctl>>2) % 2 == 1):
                self.regs.mifr =(self.regs.mifr |mask ) & 0x00FF


    def sonraki_gorev(self) -> int|None :

          aktif_gorevler = (self.regs.mifr & self.regs.mier)& 0x00FF

          
          i = 0
          while(aktif_gorevler >> i != 0):

                if((aktif_gorevler>>i) % 2 == 1):
                      break

                i+=1     

          oncelikli_gorev = i
          if(aktif_gorevler >> i != 0 ):  
              return oncelikli_gorev

          else:
               return None

    def gorev_basla(self , state:ClaState):

        if(self.regs.mirun == 0):
          oncelikli_gorev = self.sonraki_gorev()

          if(oncelikli_gorev != None):

            mask = (0x0001)<<oncelikli_gorev


            self.regs.mirun = self.regs.mirun | (mask & 0XFFFF)
            self.regs.mifr = self.regs.mifr & (mask ^ 0xFFFF)
            # TRM s.717: "The CLA program counter is initialized by the appropriate
            # MVECTx register". Getirme sayaci ilk getirmede buradan yuklenir.
            state.mpc  = self.regs.mvect[oncelikli_gorev] & 0X0FFF
            return True

        return False  


    def gorev_bitti(self ):
         
         biten = self.regs.mirun

         self.regs.mirun = 0x0000
        
         self.pie_kesmeleri.append(biten) 



         



          

           


# #####################################################################
#  cla_core.py
# #####################################################################

# =====================================================================
#  cla_core.py - CLA cekirdegi: iki yurutme modelinin giris noktasi
# ---------------------------------------------------------------------
#  ClaCore(state, memory, pipeline=None, arbiter=None)
#    pipeline=None -> ARDISIK model: her step() bir komutu bastan sona
#                     calistirir. Gecikme yuvasi YOK (dallanma hemen
#                     etkili). Yalniz birim testleri icin.
#    pipeline=...  -> BORU HATTI modeli: her step() bir saat cevrimi
#                     (8 kademe, s.577). ALTIN REFERANS budur: iz ve RTL
#                     karsilastirmasi bu modelden yapilir.
#  run()       : bir gorevi MSTOP'a kadar kosturur.
#  run_tasks() : hakemle (task_arbiter) bekleyen gorevleri sirayla.
#  Komut anlamlari iki modelde ortak: dagitici.dagit() -> ops_*.py.
#  Getirme sayaci (getir_pc) MPC'den ayri: MPC = yurutulen komut (s.717).
# =====================================================================


# MSTOP'un kodlamasi: alan yok, 32 bitin tamami sabit (s.687).
MSTOP_WORD = 0x7F800000





class ProgramBitmediError(Exception):
    """run() adim sinirina carpti - MSTOP yok ya da sonsuz dongu."""









class ClaCore:

    def dagit(self, decoded_instruction, state=None, memory=None):
     
     return dagit(decoded_instruction,
                   state  if state  is not None else self.state,
                   memory if memory is not None else self.memory,
                   cekirdek=self)


    def __init__(self, state : ClaState, memory : ClaMemory, pipeline:Pipeline = None , arbiter=None ):
        """arbiter ISTEGE BAGLI.

        Tek gorevli kullanim (mevcut testlerin hepsi) hakem olmadan
        calisir: MSTOP sadece durdurur. Hakem verilirse MSTOP ayrica
        gorev_bitti()'yi cagirir - MIRUN temizlenir, PIE'ye bildirilir.
        """
        self.state = state
        self.memory = memory
        self.arbiter = arbiter
        self.durdu = False
        self.pipeline = pipeline
        self.getir_pc = None      # ardisik modelin getirme sayaci (MPC ayri, s.717)

        if pipeline is not None and (pipeline.state is not state
                                 or pipeline.memory is not memory):
            raise ValueError("pipeline baska bir state/memory ile kurulmus")

    def getir(self) -> int:
        """Siradaki komutu getirir (ardisik model).

        Getirme adresi MPC degil, ayri sayac (`self.getir_pc`): TRM s.577 F1
        "program read address", s.717 MPC "points to the instruction in the
        decode 2 (D2) stage". Gorev basinda sayac MVECTx'ten yuklenir - hakem
        onu MPC'ye yazdi (s.717: "The CLA program counter is initialized by
        the appropriate MVECTx register"). Getirilen komut MPC olur: ardisik
        modelde "D2'deki komut" yurutulen komuttur.
        """
        if self.getir_pc is None:
            self.getir_pc = self.state.mpc
        self.state.mpc = self.getir_pc
        instruction = self.memory.fetch32(self.getir_pc)
        self.getir_pc = (self.getir_pc + 2) & 0xFFF
        return instruction



    def step(self):
        """Tek komut calistirir. MSTOP gorulurse False doner.

        MSTOP artik dagit() icinde bir dal - ham kelime karsilastirmasi
        yapip cozucuyu atlamiyoruz. Boylece hem ISA tablosundaki kodlama
        bagli sayiliyor hem de hakem dogru yerden haber aliyor.

        """
        self.durdu = False

        if(self.pipeline is None):
            komut = decode(self.getir())       # MPC = bu komut; gecersizse IllegalOpcodeError
            pc = self.state.mpc
            #  ops_branch ardisik yolda tabani ve donus adresini state.mpc'den
            #  aliyor ("siradaki komut"; s.600: 0xFFFE dalin kendisine). Yurutme
            #  suresince oyle kalsin; sonra hedef getirme sayacina, MPC geri.
            self.state.mpc = self.getir_pc
            self.dagit(komut)
            self.getir_pc = self.state.mpc
            self.state.mpc = pc
            if self.durdu:
                self.getir_pc = None           # MSTOP: sonraki gorev MVECTx'ten
        
        else:
            self.pipeline.update_pipeline(cekirdek= self)

        return not self.durdu

    def run(self, max_step = 10000):

        """MSTOP'a kadar calistirir, calisan komut sayisini doner.
        
                Sinira carparsa SESSIZCE cikmaz - program bitmemis demektir.
                """

        if(self.pipeline is not None):

                self.pipeline.durdu = False

      
        step_cnt = 0
        while step_cnt < max_step:
            cnd = self.step()
            step_cnt += 1
            if not cnd:
                return step_cnt
        raise ProgramBitmediError(
            "program %d adimda bitmedi (MSTOP yok ya da sonsuz dongu)" % max_step)

    def run_tasks(self, max_step=10000, max_task=64):
        """Bekleyen gorev kalmayana kadar sirayla calistirir.

        Her turda hakem en yuksek oncelikli hazir gorevi secer, MPC'yi
        MVECTx'ten yukler; gorev MSTOP'a kadar kosar; MSTOP hakeme haber
        verir ve sira sonrakine gecer. Hakem yoksa anlamsiz.
        """
        if self.arbiter is None:
            raise ValueError("run_tasks icin hakem gerekli")
        kosan = []
        while len(kosan) < max_task:
            if not self.arbiter.gorev_basla(self.state):
                return kosan
            kosan.append((self.arbiter.regs.mirun, self.run(max_step)))
        raise ProgramBitmediError(
            "%d gorevden sonra hala bekleyen var" % max_task)


# #####################################################################
#  disassembler.py
# #####################################################################

# Cozulmus komutu okunabilir metne cevirir.
#
# Neden ayri dosya: decoder.py word -> yapi donusumunu yapiyor, burasi
# yapi -> metin. Ikisi bagimsiz test edilebiliyor ve assembler'in
# round-trip testi (assemble(disassemble(w)) == w) buradan besleniyor.
#
# Neden 80 dalli if/else yok: tablodaki 'syntax' alani zaten bir sablon.
# "MADDF32 MRa, MRb, MRc" icindeki MRa/MRb/MRc yer tutucularini cozulmus
# operand degerleriyle degistirmek yetiyor. Yeni bir komut tabloya
# eklendiginde bu dosyaya dokunmak gerekmez.



# Tablo 10-9, s.586. Listelenmeyen degerler ayrilmis.
CNDF_ADLARI = {
    0b0000: "NEQ",   # ZF == 0
    0b0001: "EQ",    # ZF == 1
    0b0010: "GT",    # ZF == 0 AND NF == 0
    0b0011: "GEQ",   # NF == 0
    0b0100: "LT",    # NF == 1
    0b0101: "LEQ",   # ZF == 1 OR NF == 1
    0b1010: "TF",    # TF == 1
    0b1011: "NTF",   # TF == 0
    0b1100: "LU",    # LUF == 1
    0b1101: "LV",    # LVF == 1
    0b1110: "UNC",   # kosulsuz
    0b1111: "UNCF",  # kosulsuz, bayrak degistirmez
}

# Tablo 10-6, s.584
ADRESLEME_DOGRUDAN = 0b0000
ADRESLEME_MAR0 = 0b0001
ADRESLEME_MAR1 = 0b0010


def _isaretli(deger, genislik=16):
    """Ham biti isaretli tam sayiya cevirir (0xFFFE -> -2)."""
    ust = 1 << (genislik - 1)
    return deger - (1 << genislik) if deger & ust else deger


def _mar_adi(kayit):
    """MARx'in MAR0 mi MAR1 mi oldugunu bulur.

    Sozdizimi ikisini ayirt etmiyor; ayrim sabit bitte. Iki kaynak var:
      1. Kilavuzun opcode satirindaki not ("opcode of MMOVI16 MAR0, #16I")
      2. Not yoksa: ayni sozdizimine sahip kayitlar arasinda match'i
         kucuk olan MAR0 (secim biti 0), buyuk olan MAR1
    """
    not_ = kayit.get("note")
    if not_:
        bulunan = re.search(r"MAR([01])", not_)
        if bulunan:
            return "MAR" + bulunan.group(1)

    kardesler = sorted(k["match"] for k in load_table()
                       if k["syntax"] == kayit["syntax"])
    return "MAR0" if kayit["match"] == kardesler[0] else "MAR1"


def _bellek(kayit, alanlar):
    """mem16 / mem32 yer tutucusunu adresleme kipine gore yazar.

    TUZAK: 'm' alani kipe gore iki farkli sey (s.584 Tablo 10-6).
    Dogrudan kipte 16-bit adres, dolayli kipte ISARETLI artis miktari.
    """
    kip = alanlar.get("addr")
    m = alanlar.get("m", 0)
    if kip == ADRESLEME_DOGRUDAN:
        return "@0x%04X" % m
    if kip == ADRESLEME_MAR0:
        return "*MAR0[%d]++" % _isaretli(m)
    if kip == ADRESLEME_MAR1:
        return "*MAR1[%d]++" % _isaretli(m)
    return "*<ayrilmis kip 0x%X>" % (kip if kip is not None else 0)


def _kosul(alanlar):
    ham = alanlar.get("cndf", alanlar.get("CNDF"))
    if ham is None:
        return None
    return CNDF_ADLARI.get(ham, "CNDF=0x%X" % ham)


def disassemble(hedef):
    """32-bit word ya da DecodedInstruction -> metin.

    Ornek: 0x7C200036 -> "MADDF32 MR2, MR1, MR3"
    """
    d = decode(hedef) if isinstance(hedef, int) else hedef
    kayit, alanlar = d.entry, d.fields
    metin = d.syntax

    # Kosul once: "{, CNDF}" ve "{CNDF}" kaliplarini temizle ki sonraki
    # degistirmeler suslu parantez artigiyla ugrasmasin.
    kosul = _kosul(alanlar)
    kalip = re.search(r"\s*\{\s*(,?)\s*CNDF\s*\}", metin)
    if kalip:
        # "{, CNDF}" virgullu, "{CNDF}" virgulsuz - yazim ikisinde farkli
        ayirac = ", " if kalip.group(1) else " "
        ek = (ayirac + kosul) if kosul else ""
        metin = metin[:kalip.start()] + ek + metin[kalip.end():]
    elif "CNDF" in metin and kosul:
        metin = metin.replace("CNDF", kosul)

    # Bellek operandlari (adresleme kipini kullanir)
    if "mem32" in metin or "mem16" in metin:
        yazim = _bellek(kayit, alanlar)
        metin = metin.replace("mem32", yazim).replace("mem16", yazim)

    # MARx -> MAR0 / MAR1
    if "MARx" in metin:
        metin = metin.replace("MARx", _mar_adi(kayit))

    # Immediate'ler. Uzun jetonlar once, kisa olan uzunun icinde gecmesin.
    imm = alanlar.get("I")
    if imm is not None:
        for jeton in ("#16FHiHex", "#16FLoHex", "#32FHex", "#16FHi", "#16I"):
            metin = metin.replace(jeton, "#0x%04X" % imm)

    if "#SHIFT" in metin and "shift" in alanlar:
        # Tablo 10-7: kodlama 0 -> 1 bit kaydirma
        metin = metin.replace("#SHIFT", "#%d" % (alanlar["shift"] + 1))

    if "16BitDest" in metin and "dest" in alanlar:
        metin = metin.replace("16BitDest", "%d" % _isaretli(alanlar["dest"]))

    # MSETFLG FLAG, VALUE
    if "FLAG" in metin and "F" in alanlar:
        metin = metin.replace("FLAG", "0x%02X" % alanlar["F"])
    if "VALUE" in metin and "V" in alanlar:
        metin = metin.replace("VALUE", "0x%02X" % alanlar["V"])

    # Yazmaclar en son: MRa..MRf. Uzun eslesme sorunu yok, hepsi 3 karakter.
    for harf in "abcdef":
        if "MR" + harf in metin and harf in alanlar:
            metin = metin.replace("MR" + harf, "MR%d" % alanlar[harf])

    # MMOV16 MARx, MRa, #16I icindeki MRa alani 'A' olarak kodlanmis
    if "MRa" in metin and "A" in alanlar:
        metin = metin.replace("MRa", "MR%d" % alanlar["A"])

    return metin


# #####################################################################
#  assembler.py
# #####################################################################

# CLA assembly metnini 32-bit komut word'lerine cevirir.
#
# Tasarim: disassembler gibi tabloya dayali. Komut adlarina gore dallanma yok;
# tablodaki 'syntax' alani hem yer tutucu listesi hem de form secme olcutu.
#
# Iki gecis:
#   1. Etiketleri ve adreslerini topla (ileri dallanma icin sart)
#   2. Her satiri kodla
#
# MPC word ofseti oldugu icin her komut MPC'yi 2 artirir (s.717).



KOSUL_KODLARI = {ad: kod for kod, ad in CNDF_ADLARI.items()}

# Tablo 10-9 dipnot 2 (s.586): "This is the default operation if no CNDF field is specified."
# UNCF ayrica kosullu islemlerde ZF/NF'yi guncelleyen TEK kosuldur; diger
# kosullar (UNC dahil) bayraklara dokunmaz. Yani kosul yazilmamis bir komudu
# NEQ (0000) diye kodlamak hem yanlis kosul hem yanlis bayrak davranisi verir.
# UNCF = 0b1111 (ops_float'ta tanimli)

# s.660 ve s.663: kendi opcode'u olmayan, assembler'in iki komuda actigi
# yazimlar. TUZAK: bunlar IKI komut yer kaplar, gecis 1'de boyle sayilmali.
SAHTE_KOMUTLAR = {"MMOVF32", "MMOVI32"}

# ---------------------------------------------------------------------
#  MSETFLG'nin adli sozdizimi:  MSETFLG RND32=0, TF=0, NF=1
#
#  Manuel (s.686) assembler'in bu formu kabul ettigini soyluyor. Elle
#  maske hesaplamak, RND32'nin maskede 7'de MSTF'te 9'da olmasi yuzunden
#  tam da hata yapilacak yer - o yuzden cevrimi assembler yapiyor.
#
#  NOT: buradaki bit numaralari MSTF'in DEGIL, FLAG/VALUE maskesinin
#  numaralari. Esleme ops_control.MASKE_BAYRAK ile ayni kaynaktan.
# ---------------------------------------------------------------------
MSETFLG_MASKE = {"RND32": 7, "RNDF32": 7,   # TI iki yazimi da kullaniyor
                 "TF": 6, "ZF": 3, "NF": 2, "LUF": 1, "LVF": 0}


def _msetflg_adli(jetonlar, satir_no):
    """['RND32=0', 'TF=0', 'NF=1'] -> ['#0xC4', '#0x04'] ; adli form
    degilse None doner."""
    if not jetonlar or not all("=" in j for j in jetonlar):
        return None
    flag = deger = 0
    for j in jetonlar:
        ad, _, v = j.partition("=")
        ad = ad.strip().upper()
        v = v.strip()
        if ad not in MSETFLG_MASKE:
            raise AssemblerError(
                "satir %d: MSETFLG'de bilinmeyen bayrak: %s" % (satir_no, ad))
        if v not in ("0", "1"):
            raise AssemblerError(
                "satir %d: MSETFLG %s icin deger 0 ya da 1 olmali: %s"
                % (satir_no, ad, v))
        bit = MSETFLG_MASKE[ad]
        if (flag >> bit) & 1:
            raise AssemblerError(
                "satir %d: MSETFLG'de %s iki kez verilmis" % (satir_no, ad))
        flag |= 1 << bit
        if v == "1":
            deger |= 1 << bit
    return ["#0x%02X" % flag, "#0x%02X" % deger]


class AssemblerError(Exception):
    """Kaynak metinde hata. Mesaj satir numarasini tasir."""


# =====================================================================
#  Operand ayristirma
# =====================================================================

REG = "REG"
MAR = "MAR"
MEM = "MEM"
IMM = "IMM"
COND = "COND"
DEST = "DEST"
LIT = "LIT"
NUM = "NUM"      # ciplak sayi: IMM veya DEST yuvasina uyabilir


def _sayi(metin):
    metin = metin.strip()
    try:
        if metin.lower().startswith(("0x", "-0x", "+0x")):
            return int(metin, 16)
        return int(metin, 10)
    except ValueError:
        return None


def operand_coz(jeton):
    """Bir operand jetonunu (tip, deger) ciftine cevirir."""
    j = jeton.strip()

    m = re.fullmatch(r"MR([0-3])", j, re.I)
    if m:
        return REG, int(m.group(1))

    m = re.fullmatch(r"MAR([01])", j, re.I)
    if m:
        return MAR, int(m.group(1))

    if j.upper() == "MSTF":
        return LIT, "MSTF"

    # *MAR0[2]++  /  *MAR1[-2]++  /  *MAR0   (s.584: [0]++ varsayilan)
    m = re.fullmatch(r"\*MAR([01])(?:\[(-?(?:0x)?[0-9A-Fa-f]+)\])?(?:\+\+)?", j)
    if m:
        kip = ADRESLEME_MAR0 if m.group(1) == "0" else ADRESLEME_MAR1
        artis = 0 if m.group(2) is None else _sayi(m.group(2))
        if artis is None:
            return None
        return MEM, (kip, artis & 0xFFFF)

    # @0x8800  /  @_VarA
    if j.startswith("@"):
        deger = _sayi(j[1:])
        if deger is None:
            return MEM, (ADRESLEME_DOGRUDAN, j[1:])   # sembol, sonra cozulur
        return MEM, (ADRESLEME_DOGRUDAN, deger & 0xFFFF)

    if j.startswith("#"):
        govde = j[1:]
        deger = _sayi(govde)
        if deger is not None:
            return IMM, deger
        try:
            # s.591: #16FHi hem hex hem float kabul ediyor. Float verilirse
            # float32'nin UST 16 biti alinir, alt 16 bit sifir varsayilir.
            ham = struct.unpack("<I", struct.pack("<f", float(govde)))[0]
            return IMM, (ham >> 16) & 0xFFFF
        except ValueError:
            return None

    if j == "||":
        return LIT, "||"

    if j.upper() in KOSUL_KODLARI:
        return COND, KOSUL_KODLARI[j.upper()]

    # Ciplak sayi hem dallanma hedefi hem immediate olabilir; hangisi oldugu
    # yuvadan anlasilir, o yuzden NUM olarak isaretlenip ikisine de uyar.
    deger = _sayi(j)
    if deger is not None:
        return NUM, deger
    if re.fullmatch(r"[A-Za-z_][A-Za-z_0-9]*", j):
        return DEST, j          # etiket, gecis 2'de cozulur
    return None


# =====================================================================
#  Sozdizimi sablonundan yuva listesi
# =====================================================================

IMM_JETONLARI = ("#16FHiHex", "#16FLoHex", "#32FHex", "#16FHi", "#32F", "#16I")


def _devam_satirlarini_birlestir(satirlar):
    """'||' ile baslayan satiri bir oncekine ekler.

    TI listelerinde paralel komutlar iki satira yayiliyor (s.594):

        MMPYF32 MR1,MR1,MR0 ; Multiply M1*X1
        || MMOV32 MR0,@B1   ; and in parallel load MR0 with B1

    Iki satir TEK bir 32-bit kelime uretir, o yuzden birlestirilmeleri
    gerekiyor - yoksa ikinci satir basli basina bir komut sanilir.

    Birlestirme satir SAYISINI korur (birlesen satirin yerine bos satir
    konur) ki hata mesajlarindaki satir numaralari kaynakla ortussun.
    """
    cikti = []
    for no, ham in enumerate(satirlar, 1):
        govde = ham.split(";", 1)[0].strip()
        if not govde.startswith("||"):
            cikti.append(ham)
            continue
        # Geriye dogru yalnizca BOS / yorum satirlari atlanir.
        # Araya ETIKET girerse birlestirmek sessizce anlam degistirirdi:
        # etiket birlesen komutu degil, ondan SONRAKI komutu gostermeye
        # baslardi. O yuzden hata veriyoruz.
        k = len(cikti) - 1
        while k >= 0:
            etiket, mnemonic, _ = satir_coz(cikti[k])
            if mnemonic:
                break
            if etiket:
                raise AssemblerError(
                    "satir %d: '||' ile komut arasina '%s:' etiketi girmis; "
                    "etiket birlesen komutu degil sonrakini gosterirdi"
                    % (no, etiket))
            k -= 1
        if k < 0:
            raise AssemblerError(
                "satir %d: '||' ile baslayan satirin oncesinde komut yok" % no)
        cikti[k] = cikti[k].split(";", 1)[0].rstrip() + " " + govde
        cikti.append("")               # satir numaralari kaysin diye
    return cikti


def _yuvalar(syntax):
    """'MMOV32 MRa, mem32 {, CNDF}' -> yuva listesi.

    Kosullu ek varsa iki varyant doner: kosulsuz ve kosullu.
    """
    govde = syntax.split(None, 1)[1] if " " in syntax else ""
    kosullu = bool(re.search(r"\{\s*,?\s*CNDF\s*\}", govde))
    govde = re.sub(r"\s*\{\s*,?\s*CNDF\s*\}", "", govde)
    govde = govde.replace("||", " || ")

    temel = [p.strip() for p in re.split(r"[,\s]+", govde) if p.strip()]
    if kosullu:
        return [temel, temel + ["CNDF"]]
    return [temel]


def _yuva_tipi(yuva):
    if re.fullmatch(r"MR[a-f]", yuva):
        return REG
    if yuva == "MARx":
        return MAR
    if yuva in ("mem16", "mem32"):
        return MEM
    if yuva in IMM_JETONLARI or yuva == "#SHIFT":
        return IMM
    if yuva == "CNDF":
        return COND
    if yuva == "16BitDest":
        return DEST
    if yuva in ("FLAG", "VALUE"):
        return IMM
    return LIT


def _alan_adi(kayit, adaylar):
    for ad in adaylar:
        if ad in (kayit.get("fields") or {}):
            return ad
    return None


# =====================================================================
#  Form secme ve kodlama
# =====================================================================

def _uyar_mi(yuva, tip, deger, kayit):
    beklenen = _yuva_tipi(yuva)
    if beklenen == LIT:
        if tip == REG:                       # MMACF32'deki sabit MR3, MR2
            return yuva.upper() == "MR%d" % deger
        return tip in (LIT, DEST) and str(deger).upper() == yuva.upper()
    if tip == NUM and beklenen in (IMM, DEST):
        return True
    if beklenen != tip:
        return False
    if beklenen == MAR:
        return _mar_numarasi(kayit) == deger
    return True


def _mar_numarasi(kayit):
    """MARx yuvasi olan kayitlarda hangi MAR oldugunu bulur (bkz. disassembler)."""
    not_ = kayit.get("note")
    if not_:
        m = re.search(r"MAR([01])", not_)
        if m:
            return int(m.group(1))
    kardesler = sorted(k["match"] for k in load_table()
                       if k["syntax"] == kayit["syntax"])
    return 0 if kayit["match"] == kardesler[0] else 1


def _form_bul(mnemonic, cozulmus):
    """Mnemonic + operand tipleri -> tablo kaydi ve eslesen yuva listesi.

    Takma adlar da gecerli yazilistir (s.591: "This instruction can also be
    written as MADDF32 MRa, MRb, #16FHi"). Ayni opcode, farkli operand
    SIRASI - o yuzden yuva listesi takma adin kendi sozdiziminden uretilir.
    """
    adaylar = []
    for kayit in load_table():
        if kayit["mnemonic"] != mnemonic:
            continue
        yazilislar = [kayit["syntax"]] + list(kayit.get("aliases") or [])
        for sozdizimi in yazilislar:
            for yuva_listesi in _yuvalar(sozdizimi):
                if len(yuva_listesi) != len(cozulmus):
                    continue
                if all(_uyar_mi(y, t, d, kayit)
                       for y, (t, d) in zip(yuva_listesi, cozulmus)):
                    adaylar.append((kayit, yuva_listesi))
    return adaylar


def _bitleri_yerlestir(word, bitler, deger):
    for sira, bit in enumerate(bitler):
        if (deger >> (len(bitler) - 1 - sira)) & 1:
            word |= 1 << bit
    return word


def _kodla(kayit, yuvalar, cozulmus, mpc, etiketler, satir_no, semboller=None):
    word = kayit["match"]
    alanlar = kayit.get("fields") or {}
    semboller = semboller or {}

    # Kosul yuvasi kullanilmadiysa alan sifir kalirdi (NEQ). Varsayilan UNCF.
    kosul_alani = _alan_adi(kayit, ["cndf", "CNDF"])
    if kosul_alani and not any(_yuva_tipi(y) == COND for y in yuvalar):
        word = _bitleri_yerlestir(word, alanlar[kosul_alani], UNCF)

    for yuva, (tip, deger) in zip(yuvalar, cozulmus):
        beklenen = _yuva_tipi(yuva)

        if beklenen == LIT or beklenen == MAR:
            continue                                  # sabit bitte, alan yok

        if beklenen == REG:
            ad = _alan_adi(kayit, [yuva[-1], yuva[-1].upper()])
            word = _bitleri_yerlestir(word, alanlar[ad], deger)

        elif beklenen == MEM:
            kip, m = deger
            if isinstance(m, str):
                if m not in semboller:
                    raise AssemblerError(
                        "satir %d: tanimsiz veri sembolu: %s "
                        "(assemble(kaynak, semboller={...}) ile verin)"
                        % (satir_no, m))
                m = semboller[m] & 0xFFFF
            word = _bitleri_yerlestir(word, alanlar["addr"], kip)
            word = _bitleri_yerlestir(word, alanlar["m"], m)

        elif beklenen == COND:
            ad = _alan_adi(kayit, ["cndf", "CNDF"])
            word = _bitleri_yerlestir(word, alanlar[ad], deger)

        elif beklenen == IMM:
            if yuva == "#SHIFT":
                if not 1 <= deger <= 32:
                    raise AssemblerError(
                        "satir %d: kaydirma 1-32 araliginda olmali" % satir_no)
                word = _bitleri_yerlestir(word, alanlar["shift"], deger - 1)
            elif yuva == "FLAG":
                word = _bitleri_yerlestir(word, alanlar["F"], deger)
            elif yuva == "VALUE":
                word = _bitleri_yerlestir(word, alanlar["V"], deger)
            else:
                word = _bitleri_yerlestir(word, alanlar["I"], deger & 0xFFFF)

        elif beklenen == DEST:
            if isinstance(deger, str) and deger in etiketler or (
                    isinstance(deger, str) and not _sayi(deger)):
                if deger not in etiketler:
                    raise AssemblerError(
                        "satir %d: tanimsiz etiket: %s" % (satir_no, deger))
                # Taban dalin KENDI adresi: s.600 'MPC += 16BitDest' ve MPC =
                # D2'deki komut (s.717). TI cl2000 ciktisi da boyle (ti_capraz,
                # 6/6 dal). s.600'deki '0xFFFE' cumlesi TRM hatasi (§47).
                deger = etiketler[deger] - mpc
            word = _bitleri_yerlestir(word, alanlar["dest"], deger & 0xFFFF)

    return word


# =====================================================================
#  Satir ayristirma
# =====================================================================

def satir_coz(satir):
    """Ham satir -> (etiket, mnemonic, operand jetonlari).

    Bos satir veya sadece yorum ise (etiket, None, []) doner.
    """
    metin = satir.split(";", 1)[0].strip()
    if not metin:
        return None, None, []

    etiket = None
    m = re.match(r"^([A-Za-z_][A-Za-z_0-9]*)\s*:\s*(.*)$", metin)
    if m:
        etiket, metin = m.group(1), m.group(2).strip()
    if not metin:
        return etiket, None, []

    parcalar = metin.split(None, 1)
    mnemonic = parcalar[0].upper()
    kalan = parcalar[1] if len(parcalar) > 1 else ""
    kalan = kalan.replace("||", " || ")
    jetonlar = [p.strip() for p in re.split(r",|\s+", kalan) if p.strip()]
    return etiket, mnemonic, jetonlar


def _sahte_ac(mnemonic, jetonlar, satir_no):
    """MMOVF32 / MMOVI32 -> MMOVIZ + MMOVXI (s.660, s.663).

    Alt 16 bit sifirsa yalniz MMOVIZ (TRM: "the assembler will convert
    ... into only MMOVIZ instruction"). Donen liste 1 ya da 2 komut.
    """
    if len(jetonlar) != 2:
        raise AssemblerError("satir %d: %s iki operand bekler" % (satir_no, mnemonic))
    hedef, imm = jetonlar
    govde = imm.lstrip("#")
    deger = _sayi(govde)
    if deger is None:
        try:
            deger = struct.unpack("<I", struct.pack("<f", float(govde)))[0]
        except ValueError:
            raise AssemblerError("satir %d: gecersiz immediate: %s" % (satir_no, imm))
    ust, alt = (deger >> 16) & 0xFFFF, deger & 0xFFFF
    if alt == 0:        # s.660/s.663: alt 16 bit sifirsa assembler yalniz MMOVIZ uretir
        return [("MMOVIZ", [hedef, "#0x%04X" % ust])]
    return [("MMOVIZ", [hedef, "#0x%04X" % ust]),
            ("MMOVXI", [hedef, "#0x%04X" % alt])]


# =====================================================================
#  Ana giris
# =====================================================================

def assemble(kaynak, semboller=None):
    """Assembly metnini 32-bit word listesine cevirir.

    semboller: veri sembolu -> 16-bit adres eslemesi.
        {"_ruzgar": 0x8800, "_cikti": 0x8802}
    Kaynakta @_ruzgar yazildiginda bu sozlukten cozulur.

    NEDEN AYRI: etiketler (gecis 1'de toplanan dallanma hedefleri) PROGRAM
    adresidir ve MPC word ofsetidir. Veri sembolleri VERI adresidir ve
    16-bit mutlak adrestir. Ikisi ayri ad alani - ayni sozlukte tutulursa
    bir dallanma hedefi yanlislikla veri adresi gibi cozulebilir.
    """
    semboller = semboller or {}
    satirlar = _devam_satirlarini_birlestir(kaynak.splitlines())

    # --- gecis 1: etiketler ---
    etiketler = {}
    mpc = 0
    for no, satir in enumerate(satirlar, 1):
        etiket, mnemonic, jetonlar = satir_coz(satir)
        if etiket:
            if etiket in etiketler:
                raise AssemblerError("satir %d: etiket tekrar tanimlanmis: %s"
                                     % (no, etiket))
            etiketler[etiket] = mpc
        if mnemonic is None:
            continue
        mpc += 2 * len(_sahte_ac(mnemonic, jetonlar, no)) if mnemonic in SAHTE_KOMUTLAR else 2

    # --- gecis 2: kodlama ---
    wordler = []
    mpc = 0
    for no, satir in enumerate(satirlar, 1):
        _, mnemonic, jetonlar = satir_coz(satir)
        if mnemonic is None:
            continue

        if mnemonic in SAHTE_KOMUTLAR:
            parcalar = _sahte_ac(mnemonic, jetonlar, no)
        elif mnemonic == "MSETFLG":
            adli = _msetflg_adli(jetonlar, no)
            parcalar = [(mnemonic, adli if adli else jetonlar)]
        else:
            parcalar = [(mnemonic, jetonlar)]

        for alt_mnemonic, alt_jetonlar in parcalar:
            cozulmus = []
            for j in alt_jetonlar:
                c = operand_coz(j)
                if c is None:
                    raise AssemblerError(
                        "satir %d: anlasilmayan operand: %s" % (no, j))
                cozulmus.append(c)

            adaylar = _form_bul(alt_mnemonic, cozulmus)
            if not adaylar:
                raise AssemblerError(
                    "satir %d: %s icin uyan form yok (%d operand)"
                    % (no, alt_mnemonic, len(cozulmus)))
            if len(adaylar) > 1:
                raise AssemblerError(
                    "satir %d: %s birden fazla forma uyuyor: %s"
                    % (no, alt_mnemonic, [k["syntax"] for k, _ in adaylar]))

            kayit, yuvalar = adaylar[0]
            wordler.append(
                _kodla(kayit, yuvalar, cozulmus, mpc, etiketler, no, semboller))
            mpc += 2

    return wordler


# #####################################################################
#  lint.py
# #####################################################################

# -*- coding: utf-8 -*-
# CASM denetleyicisi - donanimin KORUMADIGI seyleri derleme zamaninda yakalar.
#
# CLA'nin boru hattinda uc yerde "kod dikkat etmek zorunda" durumu var; ucunde
# de donanim kilitlemesi YOK, yani model de RTL de sessizce yanlis sonuc verir.
# Kilavuzun kendi ifadesiyle (s.578):
#
#     "The CLA does not have this protection mechanism.
#      Instead the code must wait to perform the read."
#
# Denetlenen uc kural:
#
#   A) GECIKME YUVASI (s.579)
#      Dallanmadan onceki 3 ve sonraki 3 konumda MSTOP/MDEBUGSTOP/dal/cagri/
#      donus bulunamaz. Ayrica onceki 3 komutun kurdugu bayraklar o dallanmaya
#      YETISMEZ (karar D2'de verilir) - bu sessiz bir tuzak, uyari veriliyor.
#
#   B) YAZMA-SONRASI-OKUMA (s.578, Tablo 10-1/10-2)
#      Bir adrese yazdiktan sonra ayni adresten okumak icin araya EN AZ 3
#      komut girmeli (TRM Tablo 10-2: I1 yazar, I5 okur).
#
#   C) MAR GOLGE GECIKMESI (s.580, Ornek 10-2)
#      MARx yuklemesinden sonraki 2 komut eski degeri gorur, 3. komut MARx'i
#      hic kullanamaz, 4.'ten itibaren yeni deger.
#
# MESAFE SECIMI - bilincli
# ------------------------
# B kuralinda model I4'u guvenli sayiyor, TRM Tablo 10-2 I5'i gosteriyor;
# aradaki bosluk borc 27.1 (model_kararlari.md). Denetleyici **TRM'in
# mesafesini** kullaniyor: cozulmemis bir borca dayanip "temiz" dememeli.
# Model gevsek kalabilir - o donanimi taklit ediyor; lint siki olmali - o
# programciyi koruyor.
#
# KULLANIM
# --------
#     from golden_model.lint import denetle
#     for b in denetle(kaynak, semboller):
#         print(b)
#
#     python3 tools/casm_lint.py gorev.casm


DURDURUCU = frozenset({"MSTOP", "MDEBUGSTOP"})
YASAK_YUVA = DURDURUCU | DALLANIR          # dal yuvalarinda bulunamayacaklar

YUVA_SAYISI = 3          # dallanma: onceki 3 / sonraki 3   (s.579)
YAZ_OKU_ARA = 3          # yazma ile okuma arasina girmesi gereken komut
MAR_GOLGE = 3            # yuklemeden sonra MAR'in guvenilmez oldugu komut

HATA, UYARI, COZULEMEDI = "hata", "uyari", "cozulemedi"


class Bulgu(object):
    def __init__(self, kural, agirlik, indeks, mesaj, kaynak_satir=None):
        self.kural = kural
        self.agirlik = agirlik
        self.indeks = indeks                 # komut sirasi (0'dan)
        self.pc = 2 * indeks
        self.mesaj = mesaj
        self.kaynak_satir = kaynak_satir

    def __repr__(self):
        return "<%s %s pc=0x%03x %s>" % (self.agirlik, self.kural,
                                         self.pc, self.mesaj)

    def __str__(self):
        s = "%-11s %-10s komut %-4d (pc 0x%03x)  %s" % (
            self.agirlik.upper(), self.kural, self.indeks, self.pc, self.mesaj)
        if self.kaynak_satir:
            s += "\n                                          | %s" % self.kaynak_satir
        return s


# ---------------------------------------------------------------------
#  kaynak <-> komut eslemesi
# ---------------------------------------------------------------------
def kaynak_haritasi(kaynak):
    """Komut indeksi -> kaynak satiri metni.

    SAHTE_KOMUTLAR (MMOVF32/MMOVI32) bir ya da iki komuta aciliyor
    (alt 16 bit sifirsa tek MMOVIZ, s.660); bire bir
    esleme yapilamaz, o yuzden sayarak yuruyoruz.
    """
    harita = {}
    k = 0
    for satir in _devam_satirlarini_birlestir(kaynak.splitlines()):
        _, mnemonic, jetonlar = satir_coz(satir)
        if mnemonic is None:
            continue
        adet = len(_sahte_ac(mnemonic, jetonlar, 0)) if mnemonic in SAHTE_KOMUTLAR else 1
        for _ in range(adet):
            harita[k] = satir.strip()
            k += 1
    return harita


class _Komut(object):
    """Denetim icin gereken ozet - her sey `decode`dan turetiliyor."""

    __slots__ = ("syntax", "mnemonic", "yazar", "okur", "dolayli",
                 "yazar_mi", "okur_mi", "mar_kullanir", "mar_yukler",
                 "bayrak_degistirir")

    def __init__(self, word):
        d = decode(word)
        self.syntax = d.syntax
        self.mnemonic = d.mnemonic
        kip = d.fields.get("addr")
        m = d.fields.get("m")
        erisir = (okur16(self.syntax) or okur32(self.syntax)
                  or yazar16(self.syntax) or yazar32(self.syntax))
        self.dolayli = erisir and kip in (0b0001, 0b0010)
        adres = None if (self.dolayli or not erisir) else m
        self.yazar_mi = yazar16(self.syntax) or yazar32(self.syntax)
        self.okur_mi = okur16(self.syntax) or okur32(self.syntax)
        self.yazar = adres if self.yazar_mi else None
        self.okur = adres if self.okur_mi else None
        self.mar_kullanir = ({0b0001: 0, 0b0010: 1}.get(kip)
                             if erisir else None)
        self.mar_yukler = (_mar_indeksi(d.entry)
                           if mar_yukler(self.syntax) else None)
        self.bayrak_degistirir = any(d.entry.get("flags", {}).values())


# ---------------------------------------------------------------------
#  kurallar
# ---------------------------------------------------------------------
def _kural_a_gecikme_yuvalari(k, bulgu):
    n = len(k)
    for i, komut in enumerate(k):
        if komut.syntax not in DALLANIR:
            continue
        for j in range(max(0, i - YUVA_SAYISI), i):
            if k[j].syntax in YASAK_YUVA:
                bulgu(j, HATA, "S5.2-yuva",
                      "%s dallanmadan %d komut once (komut %d); bu 3 konumda "
                      "durdurucu/dallanma yasak (s.579)"
                      % (k[j].mnemonic, i - j, i))
            elif k[j].bayrak_degistirir:
                bulgu(j, UYARI, "S5.2-bayrak",
                      "%s bayrak degistiriyor ama komut %d'deki dallanmaya "
                      "YETISMEZ (karar D2'de)" % (k[j].mnemonic, i))
        for j in range(i + 1, i + 1 + YUVA_SAYISI):
            if j >= n:
                bulgu(i, HATA, "S5.2-yuva",
                      "gecikme yuvasi program sonuna tasti: dallanmadan sonra "
                      "%d komut var, %d gerekiyor (s.579)"
                      % (n - 1 - i, YUVA_SAYISI))
                break
            if k[j].syntax in YASAK_YUVA:
                bulgu(j, HATA, "S5.2-yuva",
                      "%s gecikme yuvasinda (komut %d'deki dallanmadan %d "
                      "sonra); bu konumlarda yasak (s.579)"
                      % (k[j].mnemonic, i, j - i))


def _kural_b_yazma_sonrasi_okuma(k, bulgu):
    """Her (yazan i, okuyan j) cifti icin j-i <= YAZ_OKU_ARA ise bak.

    Ikisi de dogrudan adresli ise adres karsilastirilir; biri bile dolayli
    ise guvenlik ISPATLANAMAZ - sessiz gecmek yerine COZULEMEDI basiyoruz.
    Statik denetleyicinin en tehlikeli hatasi "bir sey bulamadim"i
    "temiz"le karistirmaktir.
    """
    n = len(k)
    for i, yazan in enumerate(k):
        if not yazan.yazar_mi:
            continue
        for j in range(i + 1, min(i + 1 + YAZ_OKU_ARA, n)):
            okuyan = k[j]
            if not okuyan.okur_mi:
                continue
            if yazan.dolayli or okuyan.dolayli:
                bulgu(j, COZULEMEDI, "S5.4-yaz-oku",
                      "komut %d yaziyor, %d komut sonra okuma var; en az "
                      "biri dolayli adresli, cakisma statik olarak "
                      "bilinemiyor" % (i, j - i))
            elif yazan.yazar == okuyan.okur:
                bulgu(j, HATA, "S5.4-yaz-oku",
                      "0x%04X komut %d'de yazildi, %d komut sonra okunuyor; "
                      "araya en az %d komut girmeli - donanimda koruma YOK, "
                      "BAYAT deger okunur (s.578)"
                      % (yazan.yazar, i, j - i, YAZ_OKU_ARA))


def _kural_c_mar_golgesi(k, bulgu):
    n = len(k)
    for i, komut in enumerate(k):
        x = komut.mar_yukler
        if x is None:
            continue
        for j in range(i + 1, min(i + 1 + MAR_GOLGE, n)):
            if k[j].mar_kullanir != x:
                continue
            mesafe = j - i
            if mesafe == MAR_GOLGE:
                bulgu(j, HATA, "S5.3-mar",
                      "MAR%d komut %d'de yuklendi; %d komut sonra MAR%d HIC "
                      "kullanilamaz (cakismada post-increment kazanir, "
                      "s.579 Ornek 10-2)" % (x, i, mesafe, x))
            else:
                bulgu(j, UYARI, "S5.3-mar",
                      "MAR%d komut %d'de yuklendi; %d komut sonra ESKI deger "
                      "gorulur (kasitli olabilir, s.579 Ornek 10-2)"
                      % (x, i, mesafe))


KURALLAR = (_kural_a_gecikme_yuvalari,
            _kural_b_yazma_sonrasi_okuma,
            _kural_c_mar_golgesi)


# ---------------------------------------------------------------------
def denetle(kaynak, semboller=None, wordler=None):
    """Kaynagi denetler, Bulgu listesi doner (komut sirasina gore).

    `wordler` verilirse yeniden derlenmez - ayni kaynagi iki kez
    derlemekten kacinmak isteyen cagiranlar icin.
    """
    if wordler is None:
        wordler = assemble(kaynak, semboller=semboller)
    komutlar = [_Komut(w) for w in wordler]
    harita = kaynak_haritasi(kaynak)

    bulgular = []

    def bulgu(indeks, agirlik, kural, mesaj):
        bulgular.append(Bulgu(kural, agirlik, indeks, mesaj,
                              harita.get(indeks)))

    for kural in KURALLAR:
        kural(komutlar, bulgu)

    bulgular.sort(key=lambda b: (b.indeks, b.kural))
    return bulgular


def hatalar(bulgular):
    return [b for b in bulgular if b.agirlik == HATA]


# #####################################################################
#  casm2hex.py
# #####################################################################

def _l3_word():
    """L3 kapasitesi (16-bit word), modelin kendi tanimindan."""
    for bolge in ClaMemory().regions:
        if bolge.name == "L3_Prog":
            return bolge.size_word
    raise RuntimeError("ClaMemory'de 'L3_Prog' bolgesi yok - casm2hex "
                       "L3 sinirini bilemez")


L3_WORD = _l3_word()


class Casm2HexHatasi(Exception):
    pass


def sembolleri_coz(cift_listesi):
    """['_ruzgar=0x8800', ...] -> {'_ruzgar': 0x8800}"""
    semboller = {}
    for cift in cift_listesi or []:
        if "=" not in cift:
            raise Casm2HexHatasi("sembol 'ad=adres' biciminde olmali: %r" % cift)
        ad, adres = cift.split("=", 1)
        try:
            semboller[ad.strip()] = int(adres, 0)
        except ValueError:
            raise Casm2HexHatasi("sembol adresi sayi degil: %r" % cift)
    return semboller


def hex_satirlari(wordler, genislik=16, doldur=None, yorum=False):
    """32-bit komut listesini hex satirlarina cevirir.

    `doldur` 16-bit word cinsinden (genislikten bagimsiz) - bkz. modul notu.
    """
    if genislik not in (16, 32):
        raise Casm2HexHatasi("genislik 16 ya da 32 olmali, %r verildi" % genislik)
    program_word = 2 * len(wordler)
    if program_word > L3_WORD:
        raise Casm2HexHatasi(
            "program %d komut = %d word; L3 %d word (%d komut). Model de "
            "bu programi yuklemez (ClaMemory.load_program)."
            % (len(wordler), program_word, L3_WORD, L3_WORD // 2))

    satirlar = []
    for i, w in enumerate(wordler):
        if genislik == 32:
            metin = "%08x" % (w & 0xFFFFFFFF)
            if yorum:
                metin += "   // %03x  %s" % (2 * i, _hex_yorumu(w))
            satirlar.append(metin)
        else:
            lsw, msw = w & 0xFFFF, (w >> 16) & 0xFFFF
            if yorum:
                satirlar.append("%04x   // %03x  %s" % (lsw, 2 * i, _hex_yorumu(w)))
                satirlar.append("%04x   // %03x" % (msw, 2 * i + 1))
            else:
                satirlar.append("%04x" % lsw)
                satirlar.append("%04x" % msw)

    if doldur is not None:
        if doldur < program_word:
            raise Casm2HexHatasi(
                "program %d word, --doldur %d bundan kucuk"
                % (program_word, doldur))
        if doldur > L3_WORD:
            raise Casm2HexHatasi(
                "--doldur %d, L3 %d word - L3'ten buyuk bellek goruntusu "
                "anlamsiz (MPC 12 bit)" % (doldur, L3_WORD))
        if genislik == 32 and doldur % 2:
            raise Casm2HexHatasi(
                "--genislik 32 ile --doldur cift olmali (satir = 2 word); "
                "%d verildi" % doldur)
        hedef = doldur if genislik == 16 else doldur // 2
        bos = "%0*x" % (genislik // 4, 0)
        satirlar += [bos] * (hedef - len(satirlar))
    return satirlar


def _hex_yorumu(word):
    """Yoruma yazilacak insan okunur karsilik; cozulemezse '?'."""
    try:
        return disassemble(word)
    except Exception:
        return "?"


def cevir(kaynak_metin, genislik=16, doldur=None, yorum=False, semboller=None):
    wordler = assemble(kaynak_metin, semboller=semboller)
    return hex_satirlari(wordler, genislik, doldur, yorum), wordler


# #####################################################################
#  komut tablosu (TRM'den tools/extract_isa.py ile uretilmisti)
# #####################################################################

_ISA_KAYITLARI = [{'syntax': 'MABSF32 MRa, MRb',
  'mnemonic': 'MABSF32',
  'page': 589,
  'lsw': '000000000000bbaa',
  'msw': '0111111000100000',
  'mask': 4294967280,
  'match': 2116026368,
  'fields': {'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MADD32 MRa, MRb, MRc',
  'mnemonic': 'MADD32',
  'page': 590,
  'lsw': '0000000000ccbbaa',
  'msw': '0111110011000000',
  'mask': 4294967232,
  'match': 2092957696,
  'fields': {'a': [1, 0], 'b': [3, 2], 'c': [5, 4]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MADDF32 MRa, #16FHi, MRb',
  'mnemonic': 'MADDF32',
  'aliases': ['MADDF32 MRa, MRb, #16FHi'],
  'page': 591,
  'lsw': 'IIIIIIIIIIIIIIII',
  'msw': '011101111100bbaa',
  'mask': 4293918720,
  'match': 2009071616,
  'fields': {'I': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 'a': [17, 16], 'b': [19, 18]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': True, 'LVF': True},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MADDF32 MRa, MRb, MRc',
  'mnemonic': 'MADDF32',
  'page': 594,
  'lsw': '0000000000ccbbaa',
  'msw': '0111110000100000',
  'mask': 4294967232,
  'match': 2082471936,
  'fields': {'a': [1, 0], 'b': [3, 2], 'c': [5, 4]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': True, 'LVF': True},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MADDF32 MRd, MRe, MRf||MMOV32 mem32, MRa',
  'mnemonic': 'MADDF32',
  'page': 595,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '0101ffeeddaaaddr',
  'mask': 4026531840,
  'match': 1342177280,
  'fields': {'a': [21, 20],
             'addr': [19, 18, 17, 16],
             'd': [23, 22],
             'e': [25, 24],
             'f': [27, 26],
             'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': True, 'LVF': True},
  'pipeline': 'Both MADDF32 and MMOV32 complete in a single cycle.'},
 {'syntax': 'MADDF32 MRd, MRe, MRf ||MMOV32 MRa, mem32',
  'mnemonic': 'MADDF32',
  'page': 596,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '0001ffeeddaaaddr',
  'mask': 4026531840,
  'match': 268435456,
  'fields': {'a': [21, 20],
             'addr': [19, 18, 17, 16],
             'd': [23, 22],
             'e': [25, 24],
             'f': [27, 26],
             'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': True, 'LVF': True},
  'pipeline': 'The MADDF32 and the MMOV32 both complete in a single cycle.'},
 {'syntax': 'MAND32 MRa, MRb, MRc',
  'mnemonic': 'MAND32',
  'page': 598,
  'lsw': '0000000000ccbbaa',
  'msw': '0111110001100000',
  'mask': 4294967232,
  'match': 2086666240,
  'fields': {'a': [1, 0], 'b': [3, 2], 'c': [5, 4]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MASR32 MRa, #SHIFT',
  'mnemonic': 'MASR32',
  'page': 599,
  'lsw': '000000000shiftaa',
  'msw': '0111101101000000',
  'mask': 4294967168,
  'match': 2067791872,
  'fields': {'a': [1, 0], 'shift': [6, 5, 4, 3, 2]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MBCNDD 16BitDest {, CNDF}',
  'mnemonic': 'MBCNDD',
  'page': 600,
  'lsw': 'destdestdestdest',
  'msw': '011110011000cndf',
  'mask': 4293918720,
  'match': 2038431744,
  'fields': {'cndf': [19, 18, 17, 16], 'dest': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'number of cycles for a branch taken may not be the same as for a branch not taken.'},
 {'syntax': 'MCCNDD 16BitDest {, CNDF}',
  'mnemonic': 'MCCNDD',
  'page': 605,
  'lsw': 'destdestdestdest',
  'msw': '011110011001cndf',
  'mask': 4293918720,
  'match': 2039480320,
  'fields': {'cndf': [19, 18, 17, 16], 'dest': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'The MCCNDD instruction by itself is a single-cycle instruction. As shown in Table 10-12,'},
 {'syntax': 'MCMP32 MRa, MRb',
  'mnemonic': 'MCMP32',
  'page': 609,
  'lsw': '000000000000bbaa',
  'msw': '0111111100100000',
  'mask': 4294967280,
  'match': 2132803584,
  'fields': {'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MCMPF32 MRa, MRb',
  'mnemonic': 'MCMPF32',
  'page': 611,
  'lsw': '000000000000bbaa',
  'msw': '0111110100000000',
  'mask': 4294967280,
  'match': 2097152000,
  'fields': {'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MCMPF32 MRa, #16FHi',
  'mnemonic': 'MCMPF32',
  'page': 612,
  'lsw': 'IIIIIIIIIIIIIIII',
  'msw': '01111000110000aa',
  'mask': 4294705152,
  'match': 2025848832,
  'fields': {'I': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 'a': [17, 16]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'Example 1'},
 {'syntax': 'MDEBUGSTOP',
  'mnemonic': 'MDEBUGSTOP',
  'page': 614,
  'lsw': '0000000000000000',
  'msw': '0111111101100000',
  'mask': 4294967295,
  'match': 2136997888,
  'fields': {},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MEALLOW',
  'mnemonic': 'MEALLOW',
  'page': 615,
  'lsw': '0000000000000000',
  'msw': '0111111110010000',
  'mask': 4294967295,
  'match': 2140143616,
  'fields': {},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MEDIS',
  'mnemonic': 'MEDIS',
  'page': 616,
  'lsw': '0000000000000000',
  'msw': '0111111110110000',
  'mask': 4294967295,
  'match': 2142240768,
  'fields': {},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MEINVF32 MRa, MRb',
  'mnemonic': 'MEINVF32',
  'page': 617,
  'lsw': '000000000000bbaa',
  'msw': '0111111100000000',
  'mask': 4294967280,
  'match': 2130706432,
  'fields': {'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': True, 'LVF': True},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MEISQRTF32 MRa, MRb',
  'mnemonic': 'MEISQRTF32',
  'page': 618,
  'lsw': '000000000000bbaa',
  'msw': '0111111001000000',
  'mask': 4294967280,
  'match': 2118123520,
  'fields': {'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': True, 'LVF': True},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MF32TOI16 MRa, MRb',
  'mnemonic': 'MF32TOI16',
  'page': 620,
  'lsw': '000000000000bbaa',
  'msw': '0111110111100000',
  'mask': 4294967280,
  'match': 2111832064,
  'fields': {'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MF32TOI16R MRa, MRb',
  'mnemonic': 'MF32TOI16R',
  'page': 621,
  'lsw': '000000000000bbaa',
  'msw': '0111111001100000',
  'mask': 4294967280,
  'match': 2120220672,
  'fields': {'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MF32TOI32 MRa, MRb',
  'mnemonic': 'MF32TOI32',
  'page': 622,
  'lsw': '000000000000bbaa',
  'msw': '0111110101100000',
  'mask': 4294967280,
  'match': 2103443456,
  'fields': {'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MF32TOUI16 MRa, MRb',
  'mnemonic': 'MF32TOUI16',
  'page': 623,
  'lsw': '000000000000bbaa',
  'msw': '0111111010100000',
  'mask': 4294967280,
  'match': 2124414976,
  'fields': {'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MF32TOUI16R MRa, MRb',
  'mnemonic': 'MF32TOUI16R',
  'page': 624,
  'lsw': '000000000000bbaa',
  'msw': '0111111011000000',
  'mask': 4294967280,
  'match': 2126512128,
  'fields': {'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MF32TOUI32 MRa, MRb',
  'mnemonic': 'MF32TOUI32',
  'page': 625,
  'lsw': '000000000000bbaa',
  'msw': '0111110110100000',
  'mask': 4294967280,
  'match': 2107637760,
  'fields': {'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MFRACF32 MRa, MRb',
  'mnemonic': 'MFRACF32',
  'page': 626,
  'lsw': '000000000000bbaa',
  'msw': '0111111000000000',
  'mask': 4294967280,
  'match': 2113929216,
  'fields': {'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MI16TOF32 MRa, MRb',
  'mnemonic': 'MI16TOF32',
  'page': 627,
  'lsw': '000000000000bbaa',
  'msw': '0111111010000000',
  'mask': 4294967280,
  'match': 2122317824,
  'fields': {'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MI16TOF32 MRa, mem16',
  'mnemonic': 'MI16TOF32',
  'page': 628,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '0111010100aaaddr',
  'mask': 4290772992,
  'match': 1962934272,
  'fields': {'a': [21, 20], 'addr': [19, 18, 17, 16], 'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This instruction does not affect any flags:'},
 {'syntax': 'MI32TOF32 MRa, mem32',
  'mnemonic': 'MI32TOF32',
  'page': 629,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '0111010001aaaddr',
  'mask': 4290772992,
  'match': 1950351360,
  'fields': {'a': [21, 20], 'addr': [19, 18, 17, 16], 'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MI32TOF32 MRa, MRb',
  'mnemonic': 'MI32TOF32',
  'page': 630,
  'lsw': '000000000000bbaa',
  'msw': '0111110110000000',
  'mask': 4294967280,
  'match': 2105540608,
  'fields': {'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MLSL32 MRa, #SHIFT',
  'mnemonic': 'MLSL32',
  'page': 631,
  'lsw': '000000000shiftaa',
  'msw': '0111101111000000',
  'mask': 4294967168,
  'match': 2076180480,
  'fields': {'a': [1, 0], 'shift': [6, 5, 4, 3, 2]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MLSR32 MRa, #SHIFT',
  'mnemonic': 'MLSR32',
  'page': 632,
  'lsw': '000000000shiftaa',
  'msw': '0111101110000000',
  'mask': 4294967168,
  'match': 2071986176,
  'fields': {'a': [1, 0], 'shift': [6, 5, 4, 3, 2]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMACF32 MR3, MR2, MRd, MRe, MRf ||MMOV32 MRa, mem32',
  'mnemonic': 'MMACF32',
  'page': 633,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '0011ffeeddaaaddr',
  'mask': 4026531840,
  'match': 805306368,
  'fields': {'a': [21, 20],
             'addr': [19, 18, 17, 16],
             'd': [23, 22],
             'e': [25, 24],
             'f': [27, 26],
             'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': True, 'LVF': True},
  'pipeline': 'MMACF32 and MMOV32 complete in a single cycle.'},
 {'syntax': 'MMAXF32 MRa, MRb',
  'mnemonic': 'MMAXF32',
  'page': 636,
  'lsw': '000000000000bbaa',
  'msw': '0111110100100000',
  'mask': 4294967280,
  'match': 2099249152,
  'fields': {'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMAXF32 MRa, #16FHi',
  'mnemonic': 'MMAXF32',
  'page': 638,
  'lsw': 'IIIIIIIIIIIIIIII',
  'msw': '01111001000000aa',
  'mask': 4294705152,
  'match': 2030043136,
  'fields': {'I': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 'a': [17, 16]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMINF32 MRa, MRb',
  'mnemonic': 'MMINF32',
  'page': 639,
  'lsw': '000000000000bbaa',
  'msw': '0111110101000000',
  'mask': 4294967280,
  'match': 2101346304,
  'fields': {'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMINF32 MRa, #16FHi',
  'mnemonic': 'MMINF32',
  'page': 641,
  'lsw': 'IIIIIIIIIIIIIIII',
  'msw': '01111001010000aa',
  'mask': 4294705152,
  'match': 2034237440,
  'fields': {'I': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 'a': [17, 16]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMOV16 MARx, MRa, #16I',
  'mnemonic': 'MMOV16',
  'page': 642,
  'note': 'MMOV16 MAR0, MRa, #16I',
  'lsw': 'IIIIIIIIIIIIIIII',
  'msw': '01111111110100AA',
  'mask': 4294705152,
  'match': 2144337920,
  'fields': {'A': [17, 16], 'I': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This instruction does not modify flags in the MSTF register:'},
 {'syntax': 'MMOV16 MARx, MRa, #16I',
  'mnemonic': 'MMOV16',
  'page': 642,
  'note': 'MMOV16 MAR1, MRa, #16I',
  'lsw': 'IIIIIIIIIIIIIIII',
  'msw': '01111111111100AA',
  'mask': 4294705152,
  'match': 2146435072,
  'fields': {'A': [17, 16], 'I': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This instruction does not modify flags in the MSTF register:'},
 {'syntax': 'MMOV16 MARx, mem16',
  'mnemonic': 'MMOV16',
  'page': 645,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '011101100000addr',
  'mask': 4293918720,
  'match': 1979711488,
  'fields': {'addr': [19, 18, 17, 16], 'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'No flags MSTF flags are affected.'},
 {'syntax': 'MMOV16 MARx, mem16',
  'mnemonic': 'MMOV16',
  'page': 645,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '011101100100addr',
  'mask': 4293918720,
  'match': 1983905792,
  'fields': {'addr': [19, 18, 17, 16], 'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'No flags MSTF flags are affected.'},
 {'syntax': 'MMOV16 mem16, MARx',
  'mnemonic': 'MMOV16',
  'page': 648,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '011101101000addr',
  'mask': 4293918720,
  'match': 1988100096,
  'fields': {'addr': [19, 18, 17, 16], 'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMOV16 mem16, MARx',
  'mnemonic': 'MMOV16',
  'page': 648,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '011101101100addr',
  'mask': 4293918720,
  'match': 1992294400,
  'fields': {'addr': [19, 18, 17, 16], 'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMOV16 mem16, MRa',
  'mnemonic': 'MMOV16',
  'page': 649,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '0111010111aaaddr',
  'mask': 4290772992,
  'match': 1975517184,
  'fields': {'a': [21, 20], 'addr': [19, 18, 17, 16], 'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMOV32 mem32, MRa',
  'mnemonic': 'MMOV32',
  'page': 651,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '0111010011aaaddr',
  'mask': 4290772992,
  'match': 1958739968,
  'fields': {'a': [21, 20], 'addr': [19, 18, 17, 16], 'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMOV32 mem32, MSTF',
  'mnemonic': 'MMOV32',
  'page': 652,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '011101110100addr',
  'mask': 4293918720,
  'match': 2000683008,
  'fields': {'addr': [19, 18, 17, 16], 'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMOV32 MRa, mem32 {, CNDF}',
  'mnemonic': 'MMOV32',
  'page': 653,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '011100cndfaaaddr',
  'mask': 4227858432,
  'match': 1879048192,
  'fields': {'a': [21, 20],
             'addr': [19, 18, 17, 16],
             'cndf': [25, 24, 23, 22],
             'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMOV32 MRa, MRb {, CNDF}',
  'mnemonic': 'MMOV32',
  'page': 655,
  'lsw': '00000000cndfbbaa',
  'msw': '0111101011000000',
  'mask': 4294967040,
  'match': 2059403264,
  'fields': {'a': [1, 0], 'b': [3, 2], 'cndf': [7, 6, 5, 4]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMOV32 MSTF, mem32',
  'mnemonic': 'MMOV32',
  'page': 657,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '011101110000addr',
  'mask': 4293918720,
  'match': 1996488704,
  'fields': {'addr': [19, 18, 17, 16], 'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': True, 'ZF': True, 'NF': True, 'LUF': True, 'LVF': True},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMOVD32 MRa, mem32',
  'mnemonic': 'MMOVD32',
  'page': 658,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '0111010000aaaddr',
  'mask': 4290772992,
  'match': 1946157056,
  'fields': {'a': [21, 20], 'addr': [19, 18, 17, 16], 'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMOVI16 MARx, #16I',
  'mnemonic': 'MMOVI16',
  'page': 661,
  'note': 'MMOVI16 MAR0, #16I',
  'lsw': 'IIIIIIIIIIIIIIII',
  'msw': '0111111111000000',
  'mask': 4294901760,
  'match': 2143289344,
  'fields': {'I': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This instruction does not modify flags in the MSTF register:'},
 {'syntax': 'MMOVI16 MARx, #16I',
  'mnemonic': 'MMOVI16',
  'page': 661,
  'note': 'MMOVI16 MAR1, #16I',
  'lsw': 'IIIIIIIIIIIIIIII',
  'msw': '0111111111100000',
  'mask': 4294901760,
  'match': 2145386496,
  'fields': {'I': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This instruction does not modify flags in the MSTF register:'},
 {'syntax': 'MMOVIZ MRa, #16FHi',
  'mnemonic': 'MMOVIZ',
  'page': 665,
  'lsw': 'IIIIIIIIIIIIIIII',
  'msw': '01111000010000aa',
  'mask': 4294705152,
  'match': 2017460224,
  'fields': {'I': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 'a': [17, 16]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMOVZ16 MRa, mem16',
  'mnemonic': 'MMOVZ16',
  'page': 666,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '0111010110aaaddr',
  'mask': 4290772992,
  'match': 1971322880,
  'fields': {'a': [21, 20], 'addr': [19, 18, 17, 16], 'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMOVXI MRa, #16FLoHex',
  'mnemonic': 'MMOVXI',
  'page': 667,
  'lsw': 'IIIIIIIIIIIIIIII',
  'msw': '01111000100000aa',
  'mask': 4294705152,
  'match': 2021654528,
  'fields': {'I': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 'a': [17, 16]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMPYF32 MRa, MRb, MRc',
  'mnemonic': 'MMPYF32',
  'page': 668,
  'lsw': '0000000000ccbbaa',
  'msw': '0111110000000000',
  'mask': 4294967232,
  'match': 2080374784,
  'fields': {'a': [1, 0], 'b': [3, 2], 'c': [5, 4]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': True, 'LVF': True},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMPYF32 MRa, #16FHi, MRb',
  'mnemonic': 'MMPYF32',
  'aliases': ['MMPYF32 MRa, MRb, #16FHi'],
  'page': 669,
  'lsw': 'IIIIIIIIIIIIIIII',
  'msw': '011101111000bbaa',
  'mask': 4293918720,
  'match': 2004877312,
  'fields': {'I': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 'a': [17, 16], 'b': [19, 18]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': True, 'LVF': True},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MMPYF32 MRa, MRb, MRc||MADDF32 MRd, MRe, MRf',
  'mnemonic': 'MMPYF32',
  'page': 673,
  'lsw': '0000ffeeddccbbaa',
  'msw': '0111101000000000',
  'mask': 4294963200,
  'match': 2046820352,
  'fields': {'a': [1, 0], 'b': [3, 2], 'c': [5, 4], 'd': [7, 6], 'e': [9, 8], 'f': [11, 10]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': True, 'LVF': True},
  'pipeline': 'Both MMPYF32 and MADDF32 complete in a single cycle.'},
 {'syntax': 'MMPYF32 MRd, MRe, MRf ||MMOV32 MRa, mem32',
  'mnemonic': 'MMPYF32',
  'page': 675,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '0000ffeeddaaaddr',
  'mask': 4026531840,
  'match': 0,
  'fields': {'a': [21, 20],
             'addr': [19, 18, 17, 16],
             'd': [23, 22],
             'e': [25, 24],
             'f': [27, 26],
             'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': True, 'LVF': True},
  'pipeline': 'Both MMPYF32 and MMOV32 complete in a single cycle.'},
 {'syntax': 'MMPYF32 MRd, MRe, MRf ||MMOV32 mem32, MRa',
  'mnemonic': 'MMPYF32',
  'page': 677,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '0100ffeeddaaaddr',
  'mask': 4026531840,
  'match': 1073741824,
  'fields': {'a': [21, 20],
             'addr': [19, 18, 17, 16],
             'd': [23, 22],
             'e': [25, 24],
             'f': [27, 26],
             'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': True, 'LVF': True},
  'pipeline': 'MMPYF32 and MMOV32 both complete in a single cycle.'},
 {'syntax': 'MMPYF32 MRa, MRb, MRc ||MSUBF32 MRd, MRe, MRf',
  'mnemonic': 'MMPYF32',
  'page': 678,
  'lsw': '0000ffeeddccbbaa',
  'msw': '0111101001000000',
  'mask': 4294963200,
  'match': 2051014656,
  'fields': {'a': [1, 0], 'b': [3, 2], 'c': [5, 4], 'd': [7, 6], 'e': [9, 8], 'f': [11, 10]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': True, 'LVF': True},
  'pipeline': 'MMPYF32 and MSUBF32 both complete in a single cycle.'},
 {'syntax': 'MNEGF32 MRa, MRb{, CNDF}',
  'mnemonic': 'MNEGF32',
  'page': 679,
  'lsw': '00000000cndfbbaa',
  'msw': '0111101010000000',
  'mask': 4294967040,
  'match': 2055208960,
  'fields': {'a': [1, 0], 'b': [3, 2], 'cndf': [7, 6, 5, 4]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MNOP',
  'mnemonic': 'MNOP',
  'page': 681,
  'lsw': '0000000000000000',
  'msw': '0111111110100000',
  'mask': 4294967295,
  'match': 2141192192,
  'fields': {},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MOR32 MRa, MRb, MRc',
  'mnemonic': 'MOR32',
  'page': 682,
  'lsw': '0000000000ccbbaa',
  'msw': '0111110010000000',
  'mask': 4294967232,
  'match': 2088763392,
  'fields': {'a': [1, 0], 'b': [3, 2], 'c': [5, 4]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MRCNDD {CNDF}',
  'mnemonic': 'MRCNDD',
  'page': 683,
  'lsw': '0000000000000000',
  'msw': '011110011010cndf',
  'mask': 4293984255,
  'match': 2040528896,
  'fields': {'cndf': [19, 18, 17, 16]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'number of cycles for a return taken may not be the same as for a return not taken.'},
 {'syntax': 'MSETFLG FLAG, VALUE',
  'mnemonic': 'MSETFLG',
  'page': 686,
  'lsw': 'FFFFFFFFVVVVVVVV',
  'msw': '0111100111000000',
  'mask': 4294901760,
  'match': 2042626048,
  'fields': {'F': [15, 14, 13, 12, 11, 10, 9, 8], 'V': [7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': True, 'ZF': True, 'NF': True, 'LUF': True, 'LVF': True},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MSTOP',
  'mnemonic': 'MSTOP',
  'page': 687,
  'lsw': '0000000000000000',
  'msw': '0111111110000000',
  'mask': 4294967295,
  'match': 2139095040,
  'fields': {},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction. Table 10-19 shows the pipeline behavior of the MSTOP'},
 {'syntax': 'MSUB32 MRa, MRb, MRc',
  'mnemonic': 'MSUB32',
  'page': 689,
  'lsw': '0000000000ccbbaa',
  'msw': '0111110011100000',
  'mask': 4294967232,
  'match': 2095054848,
  'fields': {'a': [1, 0], 'b': [3, 2], 'c': [5, 4]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MSUBF32 MRa, MRb, MRc',
  'mnemonic': 'MSUBF32',
  'page': 690,
  'lsw': '0000000000ccbbaa',
  'msw': '0111110001000000',
  'mask': 4294967232,
  'match': 2084569088,
  'fields': {'a': [1, 0], 'b': [3, 2], 'c': [5, 4]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': True, 'LVF': True},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MSUBF32 MRa, #16FHi, MRb',
  'mnemonic': 'MSUBF32',
  'page': 691,
  'lsw': 'IIIIIIIIIIIIIIII',
  'msw': '011110000000bbaa',
  'mask': 4293918720,
  'match': 2013265920,
  'fields': {'I': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 'a': [17, 16], 'b': [19, 18]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': True, 'LVF': True},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MSUBF32 MRd, MRe, MRf ||MMOV32 MRa, mem32',
  'mnemonic': 'MSUBF32',
  'page': 693,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '0010ffeeddaaaddr',
  'mask': 4026531840,
  'match': 536870912,
  'fields': {'a': [21, 20],
             'addr': [19, 18, 17, 16],
             'd': [23, 22],
             'e': [25, 24],
             'f': [27, 26],
             'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': True, 'LVF': True},
  'pipeline': 'Both MSUBF32 and MMOV32 complete in a single cycle.'},
 {'syntax': 'MSUBF32 MRd, MRe, MRf ||MMOV32 mem32, MRa',
  'mnemonic': 'MSUBF32',
  'page': 694,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '0110ffeeddaaaddr',
  'mask': 4026531840,
  'match': 1610612736,
  'fields': {'a': [21, 20],
             'addr': [19, 18, 17, 16],
             'd': [23, 22],
             'e': [25, 24],
             'f': [27, 26],
             'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': True, 'LVF': True},
  'pipeline': 'Both MSUBF32 and MMOV32 complete in a single cycle.'},
 {'syntax': 'MSWAPF MRa, MRb {, CNDF}',
  'mnemonic': 'MSWAPF',
  'page': 695,
  'lsw': '00000000CNDFbbaa',
  'msw': '0111101100000000',
  'mask': 4294967040,
  'match': 2063597568,
  'fields': {'CNDF': [7, 6, 5, 4], 'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MTESTTF CNDF',
  'mnemonic': 'MTESTTF',
  'page': 697,
  'lsw': '000000000000cndf',
  'msw': '0111111101000000',
  'mask': 4294967280,
  'match': 2134900736,
  'fields': {'cndf': [3, 2, 1, 0]},
  'flags': {'TF': True, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MUI16TOF32 MRa, mem16',
  'mnemonic': 'MUI16TOF32',
  'page': 699,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '0111010101aaaddr',
  'mask': 4290772992,
  'match': 1967128576,
  'fields': {'a': [21, 20], 'addr': [19, 18, 17, 16], 'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MUI16TOF32 MRa, MRb',
  'mnemonic': 'MUI16TOF32',
  'page': 700,
  'lsw': '000000000000bbaa',
  'msw': '0111111011100000',
  'mask': 4294967280,
  'match': 2128609280,
  'fields': {'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MUI32TOF32 MRa, mem32',
  'mnemonic': 'MUI32TOF32',
  'page': 701,
  'lsw': 'mmmmmmmmmmmmmmmm',
  'msw': '0111010010aaaddr',
  'mask': 4290772992,
  'match': 1954545664,
  'fields': {'a': [21, 20], 'addr': [19, 18, 17, 16], 'm': [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MUI32TOF32 MRa, MRb',
  'mnemonic': 'MUI32TOF32',
  'page': 702,
  'lsw': '000000000000bbaa',
  'msw': '0111110111000000',
  'mask': 4294967280,
  'match': 2109734912,
  'fields': {'a': [1, 0], 'b': [3, 2]},
  'flags': {'TF': False, 'ZF': False, 'NF': False, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'},
 {'syntax': 'MXOR32 MRa, MRb, MRc',
  'mnemonic': 'MXOR32',
  'page': 703,
  'lsw': '0000000000ccbbaa',
  'msw': '0111110010100000',
  'mask': 4294967232,
  'match': 2090860544,
  'fields': {'a': [1, 0], 'b': [3, 2], 'c': [5, 4]},
  'flags': {'TF': False, 'ZF': True, 'NF': True, 'LUF': False, 'LVF': False},
  'pipeline': 'This is a single-cycle instruction.'}]
