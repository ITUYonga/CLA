# =====================================================================
#  golden_model - TI TMS320F2803x CLA (Type-0) altin modeli (ISS)
# ---------------------------------------------------------------------
#  Referans: SPRUI10A Bolum 10 (s.565-720). Hedef: RTL == model == TRM.
#
#  cla_state.py      mimari durum: MR0-3, MAR0-1, MPC, MSTF
#  cla_memory.py     bellek bolgeleri ve erisim kurallari (TRM 10.3)
#  cla_regs.py       CPU'nun gordugu CLA yazmaclari (MVECTx, MIFR, MIER ...)
#  task_arbiter.py   gorev hakemi: oncelik, MIRUN, PIE kesmesi
#  isa_table.py      komut tablosu (isa/cla_type0.yaml) okuyucu
#  decoder.py        32-bit kelime -> komut
#  dagitici.py       cozulmus komut -> ops_* fonksiyonu
#  ops_*.py          komut anlamlari (float, int, donusum, bellek, dal ...)
#  cla_core.py       iki yurutme modeli: ardisik ve boru hatti
#  pipeline.py       8 kademeli boru hatti - ALTIN REFERANS
#  trace.py          cevrim basina iz (RTL karsilastirmasi)
#  assembler.py, disassembler.py, lint.py   arac zinciri
#
#  Kararlar: docs/model_kararlari.md; ozet: cla_self/golden_model_notlari/
# =====================================================================

from .cla_state import ClaState
from .cla_memory import ClaMemory, MemoryRegion