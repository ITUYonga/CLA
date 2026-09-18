from .cla_state import ClaState

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

        