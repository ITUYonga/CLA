# =====================================================================
#  dagitici.py - cozulmus komutu ilgili ops_* fonksiyonuna baglar
# ---------------------------------------------------------------------
#  Anahtar: isa/cla_type0.yaml'daki syntax dizgisi; alan adlari yaml'dan.
#  Iki model de bunu kullanir. Boru hatti dallanmalari (MBCNDD/MCCNDD/
#  MRCNDD) ve MSTOP'u D2'de kendisi isler, buraya getirmez.
#  Dali olmayan kodlama BaglanmamisKomutError verir - sessiz no-op yok.
# =====================================================================

from .ops_float import UNCF
from . import ops_convert as C
from . import ops_float as F
from . import ops_int as I
from . import ops_memory as M
from . import ops_control as K
from . import ops_parallel as PR
from . import ops_branch as B
from .decoder import DecodedInstruction
from .isa_table import load_table

class BaglanmamisKomutError(Exception):
    """Kodlama tabloda var ama dagit() icinde bir dali yok."""



_MAR_INDEKS = None

def _mar_indeksi(entry):
    """MARx komutlarinda hedef MAR adlandirilmis bir alan DEGIL.

    Tabloda MAR0 ve MAR1 iki ayri kodlama olarak duruyor ve onlari ayiran
    bit komuta gore degisiyor: MMOVI16'da bit 21, MMOV16 MARx, mem16'da
    bit 22. Bu yuzden bit numarasi elle yazilmiyor - ayni syntax'i
    paylasan iki kodlamanin 'msw' deseni karsilastirilip fark bulunuyor.
    Tek bitte ayrilmiyorlarsa hata veriyor, sessizce yanlis secmiyor."""
    global _MAR_INDEKS
    if _MAR_INDEKS is None:
        gruplar = {}
        for e in load_table():
            if "MARx" in e["syntax"]:
                gruplar.setdefault(e["syntax"], []).append(e)
        _MAR_INDEKS = {}
        for syntax, kodlamalar in gruplar.items():
            if len(kodlamalar) != 2:
                raise ValueError("%s icin 2 kodlama bekleniyordu, %d var"
                                 % (syntax, len(kodlamalar)))
            a, b = kodlamalar
            farkli = [i for i, (x, y) in enumerate(zip(a["msw"], b["msw"]))
                      if x != y]
            if len(farkli) != 1:
                raise ValueError("%s: msw desenleri tek bitte ayrilmiyor (%s)"
                                 % (syntax, farkli))
            i = farkli[0]
            for e in kodlamalar:
                _MAR_INDEKS[e["match"]] = int(e["msw"][i])
    return _MAR_INDEKS[entry["match"]]



def dagit(decoded_instruction : DecodedInstruction , state = None , memory = None , cekirdek = None , pc = None , dal_alindi = None ):
        """Cozulmus komudu ilgili ops_* fonksiyonuna baglar.

        TUZAK 1: #SHIFT alaninda kodlama 0 -> 1 bit kaydirma (Tablo 10-7),
                 o yuzden +1.
        TUZAK 2: CNDF alani cozulmus komutta yoksa varsayilan UNCF
                 (Tablo 10-9 dipnot 2, s.586) - NEQ degil.
        """
        st, mem = state, memory
        alan   = decoded_instruction.fields
        syntax = decoded_instruction.syntax

        if syntax == "MABSF32 MRa, MRb":
            F.mabsf32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MADD32 MRa, MRb, MRc":
            I.madd32_rrr(st, mra=alan['a'], mrb=alan['b'], mrc=alan['c'])

        elif syntax == "MADDF32 MRa, #16FHi, MRb":
            F.maddf32_imm(st, mra=alan['a'], upper_16=alan['I'], mrb=alan['b'])

        elif syntax == "MADDF32 MRa, MRb, MRc":
            F.maddf32_rrr(st, mra=alan['a'], mrb=alan['b'], mrc=alan['c'])

        elif syntax == "MAND32 MRa, MRb, MRc":
            I.mand32_rrr(st, mra=alan['a'], mrb=alan['b'], mrc=alan['c'])

        elif syntax == "MASR32 MRa, #SHIFT":
            I.masr32_ri(st, mra=alan['a'], shift=alan['shift'] + 1)

        elif syntax == "MCMP32 MRa, MRb":
            I.mcmp32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MCMPF32 MRa, #16FHi":
            F.mcmpf32_imm(st, mra=alan['a'], imm=alan['I'])

        elif syntax == "MCMPF32 MRa, MRb":
            F.mcmpf32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MF32TOI16 MRa, MRb":
            C.mf32toi16_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MF32TOI16R MRa, MRb":
            C.mf32toi16r_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MF32TOI32 MRa, MRb":
            C.mf32toi32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MF32TOUI16 MRa, MRb":
            C.mf32toui16_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MF32TOUI16R MRa, MRb":
            C.mf32toui16r_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MF32TOUI32 MRa, MRb":
            C.mf32toui32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MFRACF32 MRa, MRb":
            F.mfracf32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MI16TOF32 MRa, MRb":
            C.mi16tof32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MI32TOF32 MRa, MRb":
            C.mi32tof32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MLSL32 MRa, #SHIFT":
            I.mlsl32_ri(st, mra=alan['a'], shift=alan['shift'] + 1)

        elif syntax == "MLSR32 MRa, #SHIFT":
            I.mlsr32_ri(st, mra=alan['a'], shift=alan['shift'] + 1)

        elif syntax == "MMAXF32 MRa, #16FHi":
            F.mmaxf32_imm(st, mra=alan['a'], upper_16=alan['I'])

        elif syntax == "MMAXF32 MRa, MRb":
            F.mmaxf32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MMINF32 MRa, #16FHi":
            F.mminf32_imm(st, mra=alan['a'], upper_16=alan['I'])

        elif syntax == "MMINF32 MRa, MRb":
            F.mminf32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MMPYF32 MRa, #16FHi, MRb":
            F.mmpyf32_imm(st, mra=alan['a'], upper_16=alan['I'], mrb=alan['b'])

        elif syntax == "MEINVF32 MRa, MRb":
            F.minvf32(st , mra = alan['a'] , mrb = alan['b'])

        elif syntax == "MEISQRTF32 MRa, MRb":
            F.misqrtf32(st , mra = alan['a'] , mrb = alan['b'])

        elif syntax == "MMPYF32 MRa, MRb, MRc":
            F.mmpyf32_rrr(st, mra=alan['a'], mrb=alan['b'], mrc=alan['c'])

        elif syntax == "MNEGF32 MRa, MRb{, CNDF}":
            F.mnegf32_rrc(st, mra=alan['a'], mrb=alan['b'], cndf=alan.get('cndf', UNCF))

        elif syntax == "MOR32 MRa, MRb, MRc":
            I.mor32_rrr(st, mra=alan['a'], mrb=alan['b'], mrc=alan['c'])

        elif syntax == "MSUB32 MRa, MRb, MRc":
            I.msub32_rrr(st, mra=alan['a'], mrb=alan['b'], mrc=alan['c'])

        elif syntax == "MSUBF32 MRa, #16FHi, MRb":
            F.msubf32_imm(st, mra=alan['a'], upper_16=alan['I'], mrb=alan['b'])

        elif syntax == "MSUBF32 MRa, MRb, MRc":
            F.msubf32_rrr(st, mra=alan['a'], mrb=alan['b'], mrc=alan['c'])

        elif syntax == "MSWAPF MRa, MRb {, CNDF}":
            F.mswapf_rrc(st, mra=alan['a'], mrb=alan['b'], cndf=alan.get('CNDF', UNCF))

        elif syntax == "MUI16TOF32 MRa, MRb":
            C.mui16tof32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MUI32TOF32 MRa, MRb":
            C.mui32tof32_rr(st, mra=alan['a'], mrb=alan['b'])

        elif syntax == "MXOR32 MRa, MRb, MRc":
            I.mxor32_rrr(st, mra=alan['a'], mrb=alan['b'], mrc=alan['c'])

        # --- bellek komutlari: bunlar memory de aliyor (digerleri almiyor) ---
        elif syntax == "MMOVIZ MRa, #16FHi":
            M.mmoviz_ri(st, mra=alan['a'], upper_16=alan['I'])

        elif syntax == "MMOVXI MRa, #16FLoHex":
            M.mmovxi_ri(st, mra=alan['a'], lower_16=alan['I'])

        elif syntax == "MMOV32 MRa, mem32 {, CNDF}":
            M.mmov32_yukle(st, mem,
                mra=alan['a'],
                kip=alan['addr'],
                m=alan['m'],
                cndf=alan.get('cndf', UNCF))

        elif syntax == "MMOV32 MRa, MRb {, CNDF}":
            # Bayraklar YALNIZ UNCF'te guncellenir (s.655). Diger her
            # kosulda tasima olsa bile "No flags modified".
            M.mmov32_rr(st, mra=alan['a'], mrb=alan['b'],
                cndf=alan.get('cndf', UNCF))

        elif syntax == "MMOV32 mem32, MRa":
            M.mmov32_sakla(st, mem,
                mra=alan['a'],
                kip=alan['addr'],
                m=alan['m'])

        # --- bellekten okuyup tamsayi->float32 ceviren komutlar ---
        # Dordu de MSTF'e DOKUNMAZ (s.628, 629, 699, 701: "does not affect
        # any flags"). MMOV32 MRa, mem32'den ayrildiklari nokta bu; o UNCF
        # kipinde ZF/NF guncelliyor.
        # Kodlamada tek 16-bit alan var: 'm'. Dogrudan kipte (addr=0000) o
        # alan adres, dolayli kipte (0001/0010) MARx'e eklenecek offset.
        # Bu yuzden mem16/mem32 ve m parametrelerine ayni alan gidiyor.
        elif syntax == "MI16TOF32 MRa, mem16":
            C.mi16tof32_ri(st, mra=alan['a'], memory=mem,
                mem16=alan['m'], kip=alan['addr'], m=alan['m'])

        elif syntax == "MUI16TOF32 MRa, mem16":
            C.mui16tof32_ri(st, mra=alan['a'], memory=mem,
                mem16=alan['m'], kip=alan['addr'], m=alan['m'])

        elif syntax == "MI32TOF32 MRa, mem32":
            C.mi32tof32_ri(st, mra=alan['a'], memory=mem,
                mem32=alan['m'], kip=alan['addr'], m=alan['m'])

        elif syntax == "MUI32TOF32 MRa, mem32":
            C.mui32tof32_ri(st, mra=alan['a'], memory=mem,
                mem32=alan['m'], kip=alan['addr'], m=alan['m'])

        # --- paralel formlar ---
        # Kural: TUM kaynaklar okunur, SONRA hedefler yazilir. MRa ile MRd
        # cakisirsa aritmetik ESKI degeri gormeli.
        # Bayrak boluşumu: LUF/LVF aritmetikten, ZF/NF ise yukleme yapan
        # MMOV32 yarisindan gelir (TRM: "The MMOV32 Instruction will set
        # the NF and ZF flags"). Saklama varyantlarinda ZF/NF hic kurulmaz.
        # TI kisiti: MRa, MRd ile ayni olamaz -> ops_parallel ValueError verir.
        elif syntax == "MADDF32 MRd, MRe, MRf ||MMOV32 MRa, mem32":
            PR.maddf32_rrr_mmov32_ri(st,
                mrd=alan['d'], mre=alan['e'], mrf=alan['f'],
                mra=alan['a'], mem32=alan['m'],
                kip=alan['addr'], m=alan['m'], memory=mem)

        # SAKLAMA varyantinda ZF/NF KURULMAZ ve MRd==MRa kisiti YOKTUR:
        # iki hedef farkli turde (yazmac / bellek), cakisma olamaz.
        # "MADDF32 MR0,.. || MMOV32 @X, MR0" yasal ve anlamli - ESKI MR0
        # saklanir, toplam MR0'a yazilir.
        elif syntax == "MADDF32 MRd, MRe, MRf||MMOV32 mem32, MRa":
            PR.maddf32_rrr_mmov32_ir(st,
                mrd=alan['d'], mre=alan['e'], mrf=alan['f'],
                mra=alan['a'], mem32=alan['m'],
                kip=alan['addr'], m=alan['m'], memory=mem)

        # Iki aritmetikli formlar: ZF/NF'ye HIC dokunulmaz (bellekten
        # yukleme yok). LUF/LVF ikisinden de mandallanir.
        elif syntax == "MMPYF32 MRa, MRb, MRc||MADDF32 MRd, MRe, MRf":
            PR.mmpyf32_rrr_maddf32_rrr(st,
                mra=alan['a'], mrb=alan['b'], mrc=alan['c'],
                mrd=alan['d'], mre=alan['e'], mrf=alan['f'])

        elif syntax == "MMPYF32 MRa, MRb, MRc ||MSUBF32 MRd, MRe, MRf":
            PR.mmpyf32_rrr_msubf32_rrr(st,
                mra=alan['a'], mrb=alan['b'], mrc=alan['c'],
                mrd=alan['d'], mre=alan['e'], mrf=alan['f'])

        # MMACF32: MR3 ve MR2 kodlamada alan DEGIL, sabit yazmaclar.
        # MR2 ayni komutta hem birikim kaynagi hem carpim hedefi olabilir
        # (TI'nin FIR deyimi, d=2) - oku-sonra-yaz bu yuzden zorunlu.
        # Kisit cift: MRa ne MR3 ne de MRd olabilir.
        elif syntax == "MMACF32 MR3, MR2, MRd, MRe, MRf ||MMOV32 MRa, mem32":
            PR.mmacf32_rrrrr_mmov32_ri(st, mr3=3, mr2=2,
                mrd=alan['d'], mre=alan['e'], mrf=alan['f'],
                mra=alan['a'], mem32=alan['m'], memory=mem,
                m=alan['m'], kip=alan['addr'])

        elif syntax == "MMPYF32 MRd, MRe, MRf ||MMOV32 MRa, mem32":
            PR.mmpyf_32_rrr_mmov32_ri(st,
                mrd=alan['d'], mre=alan['e'], mrf=alan['f'],
                mra=alan['a'], mem32=alan['m'],
                kip=alan['addr'], m=alan['m'], memory=mem)

        elif syntax == "MMPYF32 MRd, MRe, MRf ||MMOV32 mem32, MRa":
            PR.mmpyf32_rrr_mmov32_ir(st,
                mrd=alan['d'], mre=alan['e'], mrf=alan['f'],
                mra=alan['a'], mem32=alan['m'],
                kip=alan['addr'], m=alan['m'], memory=mem)

        elif syntax == "MSUBF32 MRd, MRe, MRf ||MMOV32 mem32, MRa":
            PR.msubf32_rrr_mmov32_ir(st,
                mrd=alan['d'], mre=alan['e'], mrf=alan['f'],
                mra=alan['a'], mem32=alan['m'],
                kip=alan['addr'], m=alan['m'], memory=mem)

        elif syntax == "MSUBF32 MRd, MRe, MRf ||MMOV32 MRa, mem32":
            PR.msubf32_rrr_mmov32_ri(st,
                mrd=alan['d'], mre=alan['e'], mrf=alan['f'],
                mra=alan['a'], mem32=alan['m'],
                kip=alan['addr'], m=alan['m'], memory=mem)

        elif syntax == "MMOVD32 MRa, mem32":
            # s.658: MRa = [mem32] VE [mem32+2] = [mem32].
            # Yukleme komutu ama ayni zamanda bellege yaziyor; +2 ETKIN
            # adrese gore (son artirmadan onceki adres).
            # Bayraklar MMOV32 kuraliyla ama KOSULSUZ - CNDF alani yok.
            M.mmovd32(st, mra=alan['a'], mem32=alan['m'],
                memory=mem, kip=alan['addr'], m=alan['m'])

        elif syntax == "MMOV32 MSTF, mem32":
            # s.657: "Loading the status register will overwrite all flags
            # and the RPC field. The MEALLOW field is not affected."
            # Ayrilmis bitler (4,5,7,8,10,31-24) Tablo 10-33'e gore hep 0;
            # maske ops_memory'de tek yerde.
            M.mmov32_mstf_mem(st, mem32=alan['m'], memory=mem,
                kip=alan['addr'], m=alan['m'])

        elif syntax == "MMOV32 mem32, MSTF":
            M.mmov32_mem_mstf(st, mem32=alan['m'], memory=mem,
                kip=alan['addr'], m=alan['m'])

        # --- MAR ve 16-bit tasima (Grup 4) ---
        # MAR0/MAR1 secimi 'alan' icinde degil, kodlamanin kendisinde;
        # _mar_indeksi onu tablodan turetiyor.
        #
        # DIKKAT: bu komutlarin hepsinin TRM sayfasinda 3 komutluk bir
        # boru hatti gecikmesi anlatiliyor (MAR yuklemesi E fazinda, son
        # artirma D2'de). Model su an gecikmesiz calisiyor; o is
        # pipeline.py'ye ait. Ayrintisi model_kararlari.md 10.5'te.
        elif syntax == "MMOVI16 MARx, #16I":
            x = _mar_indeksi(decoded_instruction.entry)
            (C.mmovi16_0 if x == 0 else C.mmovi16_1)(st, imm16=alan['I'])

        elif syntax == "MMOV16 MARx, MRa, #16I":
            x = _mar_indeksi(decoded_instruction.entry)
            (C.mmov16_0 if x == 0 else C.mmov16_1)(
                st, mra=alan['A'], imm16=alan['I'])

        elif syntax == "MMOV16 MARx, mem16":
            x = _mar_indeksi(decoded_instruction.entry)
            (C.mmov16_mar_mem_0 if x == 0 else C.mmov16_mar_mem_1)(
                st, mem16=alan['m'], memory=mem,
                kip=alan['addr'], m=alan['m'])

        elif syntax == "MMOV16 mem16, MARx":
            x = _mar_indeksi(decoded_instruction.entry)
            (C.mmov16_mem_mar_0 if x == 0 else C.mmov16_mem_mar_1)(
                st, mem16=alan['m'], memory=mem,
                kip=alan['addr'], m=alan['m'])

        elif syntax == "MMOV16 mem16, MRa":
            C.mmov16_mem_mra(st, mem16=alan['m'], mra=alan['a'],
                memory=mem, kip=alan['addr'], m=alan['m'])

        elif syntax == "MMOVZ16 MRa, mem16":
            C.mmovz16(st, mem16=alan['m'], mra=alan['a'],
                memory=mem, kip=alan['addr'], m=alan['m'])

        # --- gorev sonu ---
        # MSTOP komut setinin parcasi; ayrica gorev hakemligini tetikler.
        # Tespit CEKIRDEGIN isi - hakem komut kelimesini gormez, sadece
        # "gorev bitti" haberini alir. Ileride MDEBUGSTOP ve SOFTRESET de
        # ayni haberi verecek.
        elif syntax == "MSTOP":
         if cekirdek is not None:                  # ardisik model
            cekirdek.durdu = True
            if cekirdek.arbiter is not None:
                cekirdek.arbiter.gorev_bitti()

        # --- bayrak / koruma komutlari: yalniz MSTF'e dokunurlar ---
        elif syntax == "MEALLOW":
            K.meallow(st)

        elif syntax == "MEDIS":
            K.medis(st)

        elif syntax == "MTESTTF CNDF":
            K.mtesttf(st, cndf=alan['cndf'])

        elif syntax == "MSETFLG FLAG, VALUE":
            # DIKKAT: F/V maskesinin bit duzeni MSTF ile AYNI DEGIL.
            # RND32 maskede 7'de, MSTF'te 9'da (s.686 ornegi). Esleme
            # ops_control.MASKE_BAYRAK icinde, tek yerde.
            K.msetflg(st, FLAG=alan['F'], VALUE=alan['V'])


        #Branch komutlari

        elif syntax == "MNOP":
            B.mnop()


        elif syntax == "MDEBUGSTOP":
            B.mdebugstop(cekirdek)

        # MBCNDD: kosul DOGRUysa MPC += isaretli 16BitDest (s.600).
        # Taban dalin KENDI adresi (MPC = D2'deki komut, s.717; TI cl2000
        # ciktisiyla ayni - model_kararlari §47.1). Bu dal yalniz ardisik
        # model icin; boru hatti dallanmayi D2'de kendisi isler.
        elif syntax == "MBCNDD 16BitDest {, CNDF}":
            B.mbcndd(alan['dest'], alan.get('cndf', UNCF), st , pc)


        elif syntax == "MCCNDD 16BitDest {, CNDF}":
            B.mccndd(alan['dest'], alan.get('cndf', UNCF), st, pc)

        # MRCNDD: hedef RPC, ofset alani yok (s.683). Boru hatti bu dala
        # ugramaz - D2'de kendisi hallediyor; bu dal ardisik model icin.
        elif syntax == "MRCNDD {CNDF}":
            B.mrcndd(alan.get('cndf', UNCF), st)



        else:
            raise BaglanmamisKomutError(
                "%s bir ops_* fonksiyonuna baglanmamis" % syntax)

        

        