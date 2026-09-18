
from .cla_state import ClaState
from .cla_memory import *
from .ops_float import *
from .ops_convert import effective_address


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
