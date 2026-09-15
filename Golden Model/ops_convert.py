from .cla_state import ClaState
from .float32 import float_to_bits
from .float32 import bits_to_float
from .float32 import flush_denormal
from . cla_memory import *


def effective_address(state:ClaState , mem , kip , m ) -> int:

        effective_address = mem

        if(kip == 0b0000):
                       effective_address = mem
       
        elif(kip == 0b0001):
       
                      effective_address = state.mar[0]
                      state.mar[0] = (state.mar[0]+m)&0xFFFF
       
        elif(kip == 0b0010):
       
                      effective_address = state.mar[1]
                      state.mar[1] = (state.mar[1]+m)&0xFFFF
       
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
 
       
