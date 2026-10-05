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


from .cla_state import *
from .cla_memory import *
from .decoder import * 
from .ops_convert import effective_address
from . import dagitici as D
from . import erisim as E
from .ops_float import kosul_saglandi

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
         if(i in E.k2_hedefler(self._kayit.cozum)):      # FP yarisi: W sonunda (K2)
              self._kayit.k2_hedef_mr[i] =v
         
         else:                                           # paralel yuklemenin MRa'si: EXE
              self._gercek.set_mr(i , v)

    
    
    

    def latch_underflow(self):
          if(E.k2_yazar(self._kayit.cozum)):              # FP: W sonunda (K2)
              self._kayit.latch_underflow = True

          else:
               self._gercek.latch_underflow()             # kestirim vb.: EXE


    def latch_overflow(self):
          if(E.k2_yazar(self._kayit.cozum)):              # FP: W sonunda (K2)
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

                  if(E.adres_uretir(syntax)):

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

                  if(E.dallanir(syntax)):

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
            
           
     

            if(kopya_kayit.gecerli == 1 ):

                            if (E.mar_yukler(kopya_kayit.cozum) and self.d2_mar is not None  and D._mar_indeksi(kopya_kayit.cozum.entry) == self.d2_mar):
                                    
                                return kopya_kayit  


                            D.dagit(kopya_kayit.cozum, sahte_state, sahte_bellek , cekirdek ) 
            
            

   
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

            if(E.yazar16(syntax) ):
                 
                 veri = kayit.yaz_veri
                 ea = kayit.yaz_ea
                 self.memory.write16(ea , veri)

            elif(E.yazar32(syntax) ):
                         
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
                   (E.okunan_mr(kayit_5.cozum) & E.k2_hedefler(kayit_6.cozum))):
                    self.dur_exe = True


            elif((self.pipeline_kaydi[3].gecerli == 1 and  kayit_6.gecerli == 1 )and
                   ((E.yazar16(kayit_6.cozum.syntax) or E.yazar32(kayit_6.cozum.syntax)) and (E.okur16(self.pipeline_kaydi[3].cozum.syntax) or E.okur32(self.pipeline_kaydi[3].cozum.syntax) ))
                   and E.ayni_blok(kayit_6.yaz_ea, self.pipeline_kaydi[3].ea)):     # M4: adres degil blok
                    self.dur_r1 = True
                


            

            


   
    
           
    