#!/bin/bash
# CLA_Top tezgahini derler: $1 = tezgah dosyasi, $2 = cikti adi (obj_<ad>/<ad>)
#   ornek: ./derle_top.sh tb_cla_top.sv tb_top
R="$(cd "$(dirname "$0")/../../rtl" && pwd)"
ALU=$(cd "$R/alu" && find . -name "*.sv" | sort | sed "s|^\./|$R/alu/|")
cp "$R/alu/estimate_lut.hex" .                      # kestirme.sv tabloyu calisma klasorunden okur
IFS=$'\n'
verilator --binary --timing -Wno-fatal -Wno-lint -Wno-style --top-module ${1%.sv} -o $2 -Mdir obj_$2 \
  "$R/kontrol/cla_pkg.sv" "$R/kontrol/cla_decoder.sv" "$R/kontrol/cla_ctrl_gen.sv" "$R/kontrol/cla_gorev_denetci.sv" \
  "$R/yazmac_bellek/cla_data_ram.sv" "$R/yazmac_bellek/cla_mvect_regs.sv" $ALU \
  "$R/top/Execute.sv" "$R/top/Write.sv" "$R/top/Fetch1.sv" "$R/top/Fetch2.sv" "$R/top/Decode1.sv" "$R/top/Decode2.sv" \
  "$R/top/Read1.sv" "$R/top/Read2.sv" "$R/top/Gorev_Yazmaclari.sv" "$R/top/CLA_Top.sv" $1 2>&1 | grep -E "%Error" | head
