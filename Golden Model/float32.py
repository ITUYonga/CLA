
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

import struct


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


import struct


def float_to_bits(value: float) -> int:
  """Python float'ı (64-bit) 32-bit float'a daraltır ve ham uint32 değerini döndürür."""
  # 1. '>f': Değeri 32-bit float (4 bayt) olarak paketler (daraltma burada yapılır)
  # 2. '>I': Aynı 4 baytı 32-bit işaretsiz tamsayı olarak geri çözer
  packed = struct.pack('>f', float(value))
  return struct.unpack('>I', packed)[0]



