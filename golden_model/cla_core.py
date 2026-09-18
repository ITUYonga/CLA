from .cla_state import ClaState
from .cla_memory import ClaMemory
from .decoder import  decode
from . import dagitici as D
from .dagitici import BaglanmamisKomutError, _mar_indeksi

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


    def __init__(self, state : ClaState, memory : ClaMemory, arbiter=None):
        """arbiter ISTEGE BAGLI.

        Tek gorevli kullanim (mevcut testlerin hepsi) hakem olmadan
        calisir: MSTOP sadece durdurur. Hakem verilirse MSTOP ayrica
        gorev_bitti()'yi cagirir - MIRUN temizlenir, PIE'ye bildirilir.
        """
        self.state = state
        self.memory = memory
        self.arbiter = arbiter
        self.durdu = False

    def getir(self) -> int:
        """Komutu getirir ve MPC'yi ilerletir.

        MPC ONCE ilerliyor: gercek islemcide PC getirme aninda artar ve
        dallanma o artmis degerin uzerine yazar. MBCNDD'nin ofseti de
        "komuttan sonraki konuma gore" tanimli (s.600), yani bu sira
        dallanmalar geldiginde de dogru kalacak.
        """
        mpc = self.state.mpc
        instruction = self.memory.fetch32(mpc)
        self.state.advance_mpc(2)
        return instruction



    def step(self):
        """Tek komut calistirir. MSTOP gorulurse False doner.

        MSTOP artik dagit() icinde bir dal - ham kelime karsilastirmasi
        yapip cozucuyu atlamiyoruz. Boylece hem ISA tablosundaki kodlama
        bagli sayiliyor hem de hakem dogru yerden haber aliyor.
        """
        self.durdu = False
        self.dagit(decode(self.getir()))
        return not self.durdu

    def run(self, max_step = 10000):
        """MSTOP'a kadar calistirir, calisan komut sayisini doner.

        Sinira carparsa SESSIZCE cikmaz - program bitmemis demektir.
        """
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
