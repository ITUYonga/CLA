from .cla_state import *
from .ops_float import *



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


