
from .cla_state import *
from .cla_memory import *
from .decoder import * 
from .ops_convert import effective_address
from . import dagitici as D
from . import erisim as E

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


class BoruKaydi:

      def __init__(self):
            self.gecerli = None
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



class Pipeline:

    def __init__(self , state:ClaState , memory:ClaMemory):
        self.pipeline_kaydi = [BoruKaydi() for _ in range(7)]
        self.state = state
        self.memory = memory
        self.durdu = False


    def f1(self ) ->BoruKaydi:

        if not self.durdu:

            kayit = BoruKaydi()

            kayit.pc = self.state.mpc

            kayit.gecerli = 1 #SİMDİLİK HEP GECERLİ FAKAT İLERDE BU DEGİSECEK
           
            self.state.advance_mpc()
            
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


            decoded_instr = decode(instr)

            kopya_kayit.cozum = decoded_instr

            if(decoded_instr.syntax == "MSTOP"):
                         
                         self.durdu = True

            return  kopya_kayit

        gecersiz_kayit = BoruKaydi()
        gecersiz_kayit.gecerli = 0
        return gecersiz_kayit
            
        

    def d2(self )->BoruKaydi:
            

            kopya_kayit = self.pipeline_kaydi[2]

            decoded_instr:DecodedInstruction = kopya_kayit.cozum


            if(kopya_kayit.gecerli == 1):
                  syntax = decoded_instr.syntax
                  if(E.adres_uretir(syntax)):

                        m = decoded_instr.fields['m']
                        kip = decoded_instr.fields['addr']
                        mem = m
                        kopya_kayit.mar_before[0] = self.state.mar[0]
                        kopya_kayit.mar_before[1] = self.state.mar[1]
                        if(kip == 0b0001):           
                               
                             kopya_kayit.mar_no = 0
                            
                        elif(kip == 0b0010):
                             
                             kopya_kayit.mar_no = 1
                                             
                        kopya_kayit.ea = effective_address(self.state , mem ,kip, m)


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
                  if(E.okur16(syntax)):
                       okunan = self.memory.read16(kopya_kayit.ea)
                       kopya_kayit.okunan = okunan
                  elif(E.okur32(syntax)):
                                         
                        okunan = self.memory.read32(kopya_kayit.ea)
                        kopya_kayit.okunan = okunan

           return  kopya_kayit


    def exe(self , cekirdek = None)->BoruKaydi:
            
            kopya_kayit = self.pipeline_kaydi[5]
            sahte_state = BoruState(self.state , kopya_kayit)
            sahte_bellek = BoruBellek(kopya_kayit)
            
            if(kopya_kayit.gecerli == 1):
                    D.dagit(kopya_kayit.cozum, sahte_state, sahte_bellek , cekirdek)


            return  kopya_kayit

    def write(self):

        kayit = self.pipeline_kaydi[6]
        
        if(kayit.gecerli == 1):

            syntax = kayit.cozum.syntax

            if(E.yazar16(syntax) ):
                 
                 veri = kayit.yaz_veri
                 ea = kayit.yaz_ea
                 self.memory.write16(ea , veri)

            elif(E.yazar32(syntax) ):
                         
                veri = kayit.yaz_veri
                ea = kayit.yaz_ea
                self.memory.write32(ea , veri)
     


    def update_pipeline(self , cekirdek = None):

        kayit_0 = self.f1()
        kayit_1 = self.f2()
        kayit_2 = self.d1()

       
        if self.durdu == 1 :
             kayit_1.gecerli = 0
             kayit_0.gecerli = 0

        kayit_3 = self.d2()
        kayit_4 = self.r1()
        kayit_5 = self.r2()
        kayit_6 = self.exe(cekirdek)
        self.write()

        self.pipeline_kaydi[0] = kayit_0
        self.pipeline_kaydi[1] = kayit_1
        self.pipeline_kaydi[2] = kayit_2
        self.pipeline_kaydi[3] = kayit_3
        self.pipeline_kaydi[4] = kayit_4
        self.pipeline_kaydi[5] = kayit_5
        self.pipeline_kaydi[6] = kayit_6
        

        


   
    
           
    