from .cla_state import ClaState
from .float32 import float_to_bits 
from .float32 import bits_to_float 
from .float32 import NEG_INF
from .float32 import POS_INF
from .float32 import MIN_NORMAL
from .float32 import flush_denormal



from fractions import Fraction


def _tam(deger):
    """Operandi TAM (kesirli) degere cevirir - yuvarlama oncesi ara deger icin.

    NEDEN GEREKLI: sifira yuvarlama modunda (RND32=0, reset degeri) double
    ara deger YETMIYOR. Iki float32'nin toplaminin tam sonucu vakalarin
    ~%77'sinde 53 bite sigmiyor; double kendi yuvarlamasini yapinca
    "tam deger bu esigin altinda miydi" bilgisi siliniyor ve _sonuclandir
    sifira kesme karari veremiyor. Olculen hata orani: %31.

    En yakin cifte yuvarlamada (RND32=1) sorun yok - Figueroa teoremi
    ara formatin 2p+2 = 50 bit olmasini istiyor, double'da 53 var. Ama o
    teorem sadece EN YAKINA yuvarlama icin gecerli; YONLU yuvarlama
    sticky bit ister.

    Carpmada da sorun yok: iki 24-bit mantisin carpimi 48 bit, double'a
    tam sigar (50000 denemede sapma yok). Yine de tutarlilik icin ayni
    yoldan gecirmek zarar vermiyor.

    inf ve NaN Fraction'a cevrilemez; onlarda zaten yuvarlama yok, oldugu
    gibi donuyorlar (Fraction + float -> float, inf/NaN dogru yayilir).
    """
    if deger != deger or abs(deger) == float("inf"):
        return deger
    return Fraction(deger)


def _sonuclandir(state:ClaState , hedef:int , tamsayi:float):
    


        
 
    try:
        bits = float_to_bits(tamsayi)
    except OverflowError:
        bits = NEG_INF if tamsayi < 0 else POS_INF
        state.latch_overflow()

    if(tamsayi != 0 and abs(tamsayi) <bits_to_float(MIN_NORMAL)):
        state.latch_underflow()
    
  
    if(state.rnd32 == 0 and abs(bits_to_float(bits)) > abs(tamsayi) ):

        

        bits = bits-1


    # Denormal SONUC +0'a bastirilir. set_mr artik ham 32-bit yazmadir
    # (MR yazmaclari tamsayi da tutar), bu yuzden bastirma burada.
    state.set_mr(hedef , flush_denormal(bits))

    # DIKKAT: burada update_nz YOK.
    # MADDF32 / MSUBF32 / MMPYF32 sadece LUF ve LVF kurar; ZF ve NF'ye
    # dokunmaz (s.594, s.668, s.690 - Flags tablosu "ZF No / NF No").
    # Paralel formlar da bunu dogruluyor: ZF/NF sadece yanina
    # "MMOV32 MRa, mem32" (yukleme) eklenen varyantlarda True; ayni
    # aritmetigin "MMOV32 mem32, MRa" (saklama) varyantinda False.
    # Yani ZF/NF her zaman MMOV32'nin yukleme yarisindan gelir, toplamadan
    # degil. Bayrak gerektiren komutlar (MABSF32, MNEGF32, MCMPF32, MMOV32)
    # update_nz'yi kendileri cagirir.


def maddf32_imm(state:ClaState , * , mra:int , upper_16:int , mrb:int):

    immediate_32_float = bits_to_float(flush_denormal((upper_16 & 0xFFFF) << 16))

    source_value_float = state.get_mr_float(mrb)

    _sonuclandir(state , mra , _tam(immediate_32_float)+_tam(source_value_float))

def maddf32_rrr(state:ClaState , mra:int , mrb:int , mrc:int):
        
        source1_value_float = state.get_mr_float(mrb)

        source2_value_float = state.get_mr_float(mrc)

        _sonuclandir(state , mra , _tam(source1_value_float) + _tam(source2_value_float))


def mabsf32_rr(state, mra, mrb):
    """MABSF32 MRa, MRb  ->  MRa = |MRb|   (s.589)"""
    bits = state.get_mr(mrb) & 0x7FFFFFFF
    state.set_mr(mra, bits)
    state.update_nz(bits)

UNCF = 0b1111          # kosulsuz + bayraklari guncelle (varsayilan)


class AyrilmisKosulError(Exception):
    """Kilavuzda tanimsiz CNDF kodlamasi (0110-1001)."""


def kosul_saglandi(state, cndf=UNCF) -> bool:
    """CNDF kosulunu MSTF bayraklarina gore test eder. Tablo 10-9, s.598."""
    match cndf:
        case 0b0000: return state.zf == 0                     # NEQ
        case 0b0001: return state.zf == 1                     # EQ
        case 0b0010: return state.zf == 0 and state.nf == 0   # GT
        case 0b0011: return state.nf == 0                     # GEQ
        case 0b0100: return state.nf == 1                     # LT
        case 0b0101: return state.zf == 1 or state.nf == 1    # LEQ
        case 0b1010: return state.tf == 1                     # TF
        case 0b1011: return state.tf == 0                     # NTF
        case 0b1100: return state.luf == 1                    # LU
        case 0b1101: return state.lvf == 1                    # LV
        case 0b1110: return True                              # UNC
        case 0b1111: return True                              # UNCF
    raise AyrilmisKosulError("CNDF 0b{:04b} ayrilmis (s.598)".format(cndf))


def bayrak_guncellenir_mi(cndf=UNCF) -> bool:
    """s.598 dipnot 2: kosullu islemlerde ZF/NF sadece UNCF ile guncellenir."""
    return cndf == UNCF


def mnegf32_rrc(state, mra, mrb, cndf=UNCF):
    """MNEGF32 MRa, MRb {,CNDF}   (s.679)
    kosul dogruysa MRa = -MRb, degilse MRa = MRb"""
    bits = state.get_mr(mrb)
    if kosul_saglandi(state, cndf):
        bits ^= 0x80000000
    state.set_mr(mra, bits)
    if bayrak_guncellenir_mi(cndf):
        state.update_nz(bits)

def msubf32_rrr(state: ClaState, mra: int, mrb: int, mrc: int):

    value_1 = state.get_mr_float(mrb)
    value_2 = state.get_mr_float(mrc)

    _sonuclandir(state , mra, _tam(value_1) - _tam(value_2))


def msubf32_imm(state: ClaState, * , mra: int, upper_16: int, mrb: int):
    """MSUBF32 MRa, #16FHi, MRb  ->  MRa = #16FHi:0 - MRb   (s.691)

    TUZAK: immediate ONCE geliyor. MADDF32/MMPYF32'de sira onemsiz oldugu
    icin kilavuz onlara takma ad veriyor (MRa, MRb, #16FHi da yaziliyor);
    cikarma degismeli olmadigi icin bu formun takma adi YOK.
    """

    immediate_32_float = bits_to_float(flush_denormal((upper_16 & 0xFFFF) << 16))

    source_value_float = state.get_mr_float(mrb)

    _sonuclandir(state , mra , _tam(immediate_32_float) - _tam(source_value_float))


def mmpyf32_rrr(state: ClaState, mra: int, mrb: int, mrc: int):
    """MMPYF32 MRa, MRb, MRc  ->  MRa = MRb * MRc   (s.668)"""

    source1_value_float = state.get_mr_float(mrb)

    source2_value_float = state.get_mr_float(mrc)

    _sonuclandir(state , mra , _tam(source1_value_float) * _tam(source2_value_float))


def mmpyf32_imm(state: ClaState, * , mra: int, upper_16: int, mrb: int):
    """MMPYF32 MRa, #16FHi, MRb  ->  MRa = MRb * #16FHi:0   (s.669)

    Takma ad: MMPYF32 MRa, MRb, #16FHi (carpma degismeli).
    """

    immediate_32_float = bits_to_float(flush_denormal((upper_16 & 0xFFFF) << 16))

    source_value_float = state.get_mr_float(mrb)

    _sonuclandir(state , mra , _tam(immediate_32_float) * _tam(source_value_float))


def mcmpf32_rr(state:ClaState, mra:int, mrb:int):

       value_1 = state.get_mr_float(mra)

       value_1_bits =  state.get_mr(mra)

       value_1_sign = value_1_bits>>31

       value_2 = state.get_mr_float(mrb)

       value_2_bits =  state.get_mr(mrb)

       value_2_sign = value_2_bits>>31

       

       

       if(value_1 != value_1 and value_1_sign  ==  0 ):
           value_1 = float('inf')

       elif(value_1 != value_1 and value_1_sign == 1) :
            value_1 = float('-inf')   

    

       
       if(value_2 != value_2 and value_2_sign ==  0 ):
           value_2 = float('inf')

       elif(value_2 != value_2 and value_2_sign == 1) :
            value_2 = float('-inf')   


       value_1 = bits_to_float(flush_denormal(float_to_bits(value_1)) )
       value_2 = bits_to_float(flush_denormal(float_to_bits(value_2)) )    
      
                      
       state.zf = 1 if value_1 == value_2 else 0
       state.nf = 1 if value_1 <value_2 else 0


def mcmpf32_imm(state:ClaState , * ,  mra: int , imm : int): 

    value_1 = state.get_mr_float(mra) 

    value_1_bits =  state.get_mr(mra) 

    value_1_sign = value_1_bits>>31 

    value_2 = bits_to_float(imm<<16) 

    value_2_sign = imm>>15 

    if(value_1 != value_1 and value_1_sign  ==  0 ): 
        value_1 = float('inf') 

    elif(value_1 != value_1 and value_1_sign == 1) : 
        value_1 = float('-inf') 

    if(value_2 != value_2 and value_2_sign ==  0 ): value_2 = float('inf') 

    elif(value_2 != value_2 and value_2_sign == 1) : value_2 = float('-inf') 

    value_1 = bits_to_float(flush_denormal(float_to_bits(value_1)) ) 

    value_2 = bits_to_float(flush_denormal(float_to_bits(value_2)) ) 
    state.zf = 1 if value_1 == value_2 else 0 

    state.nf = 1 if value_1 <value_2 else 0


def _karsilastirma_degeri(bits):
    """Ham deseni karsilastirma icin kullanilabilir bir degere cevirir.

    s.611 (MCMPF32 girdileri) ve s.635 / s.643 (MMAXF32/MMINF32 ciktilari)
    ayni donusumu istiyor:

        ustel == 0                    ->  0.0  (+0, -0 ve denormal birlikte)
        ustel == 0xFF ve mantis != 0  ->  isarete gore +inf / -inf  (NaN)
        digerleri                     ->  degerin kendisi

    NEDEN OKUMA TARAFINDA: set_mr artik denormal bastirmiyor (MR yazmaclari
    tamsayi da tutuyor, bkz. model_kararlari.md 1.3.1), yani yazmacta
    denormal desen bulunabilir. Bastirma, degeri kayan nokta olarak
    YORUMLADIGIMIZ yerde yapilir.

    NaN'in isareti sadece bit deseninde gorunur - Python'da float('nan')
    ile gelen iki NaN ayirt edilemez. Bu yuzden fonksiyon degeri degil
    deseni aliyor.
    """
    bits = bits & 0xFFFFFFFF
    ustel = (bits >> 23) & 0xFF
    mantis = bits & 0x7FFFFF

    if ustel == 0xFF and mantis != 0:
        return float("-inf") if bits & 0x80000000 else float("inf")
    if ustel == 0:
        return 0.0
    return bits_to_float(bits)


def _kosullu_sec(state, mra, a, b, b_buyukse_al):
    """MMAXF32 / MMINF32'nin ortak govdesi.

    Bayraklar HER ZAMAN orijinal karsilastirmadan gelir - yazma olsun
    olmasin. Kilavuz s.635: "The ZF and NF flags are configured on the
    result of the operation, not the result stored in the destination
    register."

    Kilavuzun s.643'teki ornegi bunu kanitliyor:
        MR0 = 5.0, MR1 = 4.0
        MMINF32 MR0, MR1   ; MR0 = 4.0,  ZF = 0, NF = 0
    Yazilan deger 4.0 ama bayraklar 5.0 > 4.0 karsilastirmasini gosteriyor.
    Sonuctan hesaplansaydi 4.0 == 4.0 olur, ZF = 1 cikardi.

    Yazilan deger normalize edilmis olani: ciktidaki NaN -> sonsuz ve
    denormal -> +0 donusumu (s.635) tam olarak bu normalizasyon.
    """
    state.zf = 1 if a == b else 0
    state.nf = 1 if a < b else 0

    if b_buyukse_al:
        secilen = b if a < b else a        # MMAXF32
    else:
        secilen = b if a > b else a        # MMINF32

    state.set_mr(mra, float_to_bits(secilen))


def mmaxf32_rr(state: ClaState, mra: int, mrb: int):
    """MMAXF32 MRa, MRb  ->  if (MRa < MRb) MRa = MRb   (s.635)"""

    a = _karsilastirma_degeri(state.get_mr(mra))
    b = _karsilastirma_degeri(state.get_mr(mrb))

    _kosullu_sec(state, mra, a, b, True)


def mmaxf32_imm(state: ClaState, * , mra: int, upper_16: int):
    """MMAXF32 MRa, #16FHi  ->  if (MRa < #16FHi:0) MRa = #16FHi:0   (s.637)"""

    a = _karsilastirma_degeri(state.get_mr(mra))
    b = _karsilastirma_degeri((upper_16 & 0xFFFF) << 16)

    _kosullu_sec(state, mra, a, b, True)


def mminf32_rr(state: ClaState, mra: int, mrb: int):
    """MMINF32 MRa, MRb  ->  if (MRa > MRb) MRa = MRb   (s.643)"""

    a = _karsilastirma_degeri(state.get_mr(mra))
    b = _karsilastirma_degeri(state.get_mr(mrb))

    _kosullu_sec(state, mra, a, b, False)


def mminf32_imm(state: ClaState, * , mra: int, upper_16: int):
    """MMINF32 MRa, #16FHi  ->  if (MRa > #16FHi:0) MRa = #16FHi:0   (s.645)"""

    a = _karsilastirma_degeri(state.get_mr(mra))
    b = _karsilastirma_degeri((upper_16 & 0xFFFF) << 16)

    _kosullu_sec(state, mra, a, b, False)


def mfracf32_rr(state : ClaState , mra : int , mrb : int):

        value = state.get_mr_float(mrb)

        value = bits_to_float(flush_denormal(float_to_bits(value)))


        if(value != value or abs(value) == float('inf') ): 
            fractional_portion = 0
            

        else:
            fractional_portion = value - int(value)

        state.set_mr_float(mra , fractional_portion)




def mswapf_rrc(state:ClaState, mra:int, mrb:int, cndf=UNCF):

        if(kosul_saglandi(state , cndf)):
            temp = state.get_mr(mra)
            state.set_mr(mra , state.get_mr(mrb))
            state.set_mr(mrb , temp)