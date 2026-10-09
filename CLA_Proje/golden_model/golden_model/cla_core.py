# =====================================================================
#  cla_core.py - CLA cekirdegi: iki yurutme modelinin giris noktasi
# ---------------------------------------------------------------------
#  ClaCore(state, memory, pipeline=None, arbiter=None)
#    pipeline=None -> ARDISIK model: her step() bir komutu bastan sona
#                     calistirir. Gecikme yuvasi YOK (dallanma hemen
#                     etkili). Yalniz birim testleri icin.
#    pipeline=...  -> BORU HATTI modeli: her step() bir saat cevrimi
#                     (8 kademe, s.577). ALTIN REFERANS budur: iz ve RTL
#                     karsilastirmasi bu modelden yapilir.
#  run()       : bir gorevi MSTOP'a kadar kosturur.
#  run_tasks() : hakemle (task_arbiter) bekleyen gorevleri sirayla.
#  Komut anlamlari iki modelde ortak: dagitici.dagit() -> ops_*.py.
#  Getirme sayaci (getir_pc) MPC'den ayri: MPC = yurutulen komut (s.717).
# =====================================================================

from .cla_state import ClaState
from .cla_memory import ClaMemory
from .decoder import  decode
from . import dagitici as D
from .dagitici import BaglanmamisKomutError, _mar_indeksi
from .pipeline import Pipeline

# MSTOP'un kodlamasi: alan yok, 32 bitin tamami sabit (s.687).
MSTOP_WORD = 0x7F800000





class ProgramBitmediError(Exception):
    """run() adim sinirina carpti - MSTOP yok ya da sonsuz dongu."""









class ClaCore:

    def dagit(self, decoded_instruction, state=None, memory=None):
     
     return D.dagit(decoded_instruction,
                   state  if state  is not None else self.state,
                   memory if memory is not None else self.memory,
                   cekirdek=self)


    def __init__(self, state : ClaState, memory : ClaMemory, pipeline:Pipeline = None , arbiter=None ):
        """arbiter ISTEGE BAGLI.

        Tek gorevli kullanim (mevcut testlerin hepsi) hakem olmadan
        calisir: MSTOP sadece durdurur. Hakem verilirse MSTOP ayrica
        gorev_bitti()'yi cagirir - MIRUN temizlenir, PIE'ye bildirilir.
        """
        self.state = state
        self.memory = memory
        self.arbiter = arbiter
        self.durdu = False
        self.pipeline = pipeline
        self.getir_pc = None      # ardisik modelin getirme sayaci (MPC ayri, s.717)

        if pipeline is not None and (pipeline.state is not state
                                 or pipeline.memory is not memory):
            raise ValueError("pipeline baska bir state/memory ile kurulmus")

    def getir(self) -> int:
        """Siradaki komutu getirir (ardisik model).

        Getirme adresi MPC degil, ayri sayac (`self.getir_pc`): TRM s.577 F1
        "program read address", s.717 MPC "points to the instruction in the
        decode 2 (D2) stage". Gorev basinda sayac MVECTx'ten yuklenir - hakem
        onu MPC'ye yazdi (s.717: "The CLA program counter is initialized by
        the appropriate MVECTx register"). Getirilen komut MPC olur: ardisik
        modelde "D2'deki komut" yurutulen komuttur.
        """
        if self.getir_pc is None:
            self.getir_pc = self.state.mpc
        self.state.mpc = self.getir_pc
        instruction = self.memory.fetch32(self.getir_pc)
        self.getir_pc = (self.getir_pc + 2) & 0xFFF
        return instruction



    def step(self):
        """Tek komut calistirir. MSTOP gorulurse False doner.

        MSTOP artik dagit() icinde bir dal - ham kelime karsilastirmasi
        yapip cozucuyu atlamiyoruz. Boylece hem ISA tablosundaki kodlama
        bagli sayiliyor hem de hakem dogru yerden haber aliyor.

        """
        self.durdu = False

        if(self.pipeline is None):
            komut = decode(self.getir())       # MPC = bu komut; gecersizse IllegalOpcodeError
            pc = self.state.mpc
            #  ops_branch ardisik yolda tabani ve donus adresini state.mpc'den
            #  aliyor ("siradaki komut"; s.600: 0xFFFE dalin kendisine). Yurutme
            #  suresince oyle kalsin; sonra hedef getirme sayacina, MPC geri.
            self.state.mpc = self.getir_pc
            self.dagit(komut)
            self.getir_pc = self.state.mpc
            self.state.mpc = pc
            if self.durdu:
                self.getir_pc = None           # MSTOP: sonraki gorev MVECTx'ten
        
        else:
            self.pipeline.update_pipeline(cekirdek= self)

        return not self.durdu

    def run(self, max_step = 10000):

        """MSTOP'a kadar calistirir, calisan komut sayisini doner.
        
                Sinira carparsa SESSIZCE cikmaz - program bitmemis demektir.
                """

        if(self.pipeline is not None):

                self.pipeline.durdu = False

      
        step_cnt = 0
        while step_cnt < max_step:
            cnd = self.step()
            step_cnt += 1
            if not cnd:
                return step_cnt
        raise ProgramBitmediError(
            "program %d adimda bitmedi (MSTOP yok ya da sonsuz dongu)" % max_step)

    def run_tasks(self, max_step=10000, max_task=64):
        """Bekleyen gorev kalmayana kadar sirayla calistirir.

        Her turda hakem en yuksek oncelikli hazir gorevi secer, MPC'yi
        MVECTx'ten yukler; gorev MSTOP'a kadar kosar; MSTOP hakeme haber
        verir ve sira sonrakine gecer. Hakem yoksa anlamsiz.
        """
        if self.arbiter is None:
            raise ValueError("run_tasks icin hakem gerekli")
        kosan = []
        while len(kosan) < max_task:
            if not self.arbiter.gorev_basla(self.state):
                return kosan
            kosan.append((self.arbiter.regs.mirun, self.run(max_step)))
        raise ProgramBitmediError(
            "%d gorevden sonra hala bekleyen var" % max_task)
