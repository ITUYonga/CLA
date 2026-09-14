
from .cla_state import *
from .cla_memory import *
from .float32 import * 
from .ops_float import _sonuclandir , _tam 
from .ops_convert import *

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