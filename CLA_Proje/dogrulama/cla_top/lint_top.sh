#!/bin/bash
# CLA_Top -Wall lint (butun uyarilar)
R="$(cd "$(dirname "$0")/../../rtl" && pwd)"
ALU=$(cd "$R/alu" && find . -name "*.sv" | sort | sed "s|^\./|$R/alu/|")
IFS=$'\n'
verilator --lint-only -Wall --top-module CLA_Top "$R/kontrol/cla_pkg.sv" "$R/kontrol/cla_decoder.sv" "$R/kontrol/cla_ctrl_gen.sv" \
  "$R/kontrol/cla_gorev_denetci.sv" "$R/yazmac_bellek/cla_data_ram.sv" "$R/yazmac_bellek/cla_mvect_regs.sv" $ALU \
  "$R/top/Execute.sv" "$R/top/Write.sv" "$R/top/Fetch1.sv" "$R/top/Fetch2.sv" "$R/top/Decode1.sv" "$R/top/Decode2.sv" \
  "$R/top/Read1.sv" "$R/top/Read2.sv" "$R/top/Gorev_Yazmaclari.sv" "$R/top/CLA_Top.sv" 2>&1
