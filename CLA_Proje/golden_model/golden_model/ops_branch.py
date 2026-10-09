# =====================================================================
#  ops_branch.py - MBCNDD / MCCNDD / MRCNDD / MNOP / MDEBUGSTOP
# ---------------------------------------------------------------------
#  TRM s.600, s.605, s.683, s.681, s.614. YALNIZ ARDISIK model kullanir;
#  boru hatti dallanma kararini ve hedefi D2'de kendisi verir
#  (pipeline.d2), 3 gecikme yuvasiyla (s.579).
#  Hedef = dalin KENDI adresi + isaretli ofset (model_kararlari §47.1).
#  MDEBUGSTOP kesme noktalari kapaliyken MNOP'tur (s.614).
# =====================================================================

from .ops_float import kosul_saglandi
from .cla_state import ClaState , RPC_SHIFT


def mnop():
    pass



def mdebugstop(cekirdek = None):
        pass        
    


def mbcndd(bit_dst16, CNDF, state, pc=None):
    if kosul_saglandi(state, CNDF):
        # taban = dalin kendi adresi (s.600 'MPC += 16BitDest', §47). Ardisik
        # modelde dagit sirasinda state.mpc sonraki komutu gosteriyor -> -2.
        taban = (state.mpc - 2) if pc is None else pc
        state.mpc = (taban + bit_dst16) & 0xFFF

def mccndd(bit_dst16, CNDF, state: ClaState, pc=None):
    """MCCNDD - Call Conditional Delayed (s.605).

        if (CNDF == TRUE) { RPC = return address; MPC += 16BitDest; }

    Iki baglamda da calisir, ayrimi `pc` yapar:

    pc is None  -> ARDISIK model (ClaCore). getir() MPC'yi zaten komuttan
                   sonraki konuma ilerletmis; gecikme yuvasi KAVRAMI YOK,
                   bu yuzden donus adresi dogrudan o konumdur.

    pc verilmis -> BORU HATTI. MCCNDD'den sonraki UC komut gecikme yuvasi
                   olarak her halukarda calisir (s.579), dolayisiyla donus
                   adresi pc+8 olmalidir - pc+6 secilseydi ucuncu yuva her
                   cagride IKI KEZ calisirdi.
                   NOT: boru hatti bu fonksiyonu cagirmiyor; karari ve
                   RPC yazmasini D2'de kendisi yapiyor (s.652). Buradaki dal
                   referans/regresyon icin duruyor.

    KAPANDI (model_kararlari §32.1): s.606 ve Tablo 10-13 dipnotu
    donus adresini I8 = pc+8 olarak veriyor.
    bkz. model_kararlari.md
    """
    if not kosul_saglandi(state, CNDF):
        return False

    if pc is None:                       # ardisik model
        state.rpc = state.mpc & 0xFFF
        state.mpc = (state.mpc - 2 + bit_dst16) & 0xFFF     # taban = dalin adresi (§47)
    else:                                # boru hatti semantigi
        state.rpc = (pc + 8) & 0xFFF
        state.mpc = (pc + bit_dst16) & 0xFFF
    return True


def mrcndd(CNDF, state: ClaState, pc=None):
    """MRCNDD - Return Conditional Delayed (s.683).

        if (CNDF == TRUE) MPC = RPC;

    ISA sozdizimi "MRCNDD {CNDF}" - ofset alani YOK, tek alan cndf.
    Hedef PC'ye gore bir ofset degil, dogrudan RPC. Bu yuzden `pc`
    parametresi sadece mbcndd/mccndd ile imza birligi icin duruyor,
    KULLANILMIYOR.

    ARDISIK model: mccndd'nin yazdigi RPC (MCCNDD'den sonraki konum)
    dogrudan MPC'ye kopyalanir; gecikme yuvasi kavrami yok.

    BORU HATTI bu fonksiyonu CAGIRMIYOR: hem karar hem MPC yazmasi D2'de
    yapiliyor (MBCNDD/MCCNDD ile ayni asama, 3 gecikme yuvasi icin -
    s.579). Buradaki dal ardisik model ve iki modelin regresyon
    karsilastirmasi icin var.
    """
    if not kosul_saglandi(state, CNDF):
        return False
    state.mpc = state.rpc & 0xFFF
    return True
