# golden_model/cla_regs.py   (yeni dosya: davranisli yazmaclar)
class BaglanmamisKontrol(Exception):
    pass



class ClaRegs:

    def __init__(self ):

        self.reset()

    def reset(self):

        #SOFTRESET/HARDRESET SIMDILIK BEKLESIN 

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
