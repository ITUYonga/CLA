# =====================================================================
#  task_arbiter.py - gorev hakemi (TRM 10.2.4, 10.7)
# ---------------------------------------------------------------------
#  cevresel_istek(g): MIFR bitini kurar; zaten kuruluysa MIOVF.
#  sonraki_gorev(): MIFR & MIER icinde en kucuk numarali gorev (oncelik).
#  gorev_basla(): MIRUN kurulur, MIFR biti temizlenir, MPC = MVECTx (s.717).
#  gorev_bitti(): MSTOP D2'deyken - MIRUN temizlenir, PIE'ye kesme.
#  Gercek CLA hakemsiz calismaz; hakemsiz yol yalniz birim testleri icin.
# =====================================================================

from .cla_regs import ClaRegs
from .cla_state import ClaState

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



         



          

           