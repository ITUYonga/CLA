#!/bin/bash
# Execute + Write birim tezgahini derler: $1 = tezgah dosyasi, $2 = cikti klasoru
#   ornek: ./derle_birim.sh tb_kenar.sv obj_kenar
R="$(cd "$(dirname "$0")/../../rtl" && pwd)"
ALU=$(cd "$R/alu" && find . -name "*.sv" | sort | sed "s|^\./|$R/alu/|")
cp "$R/alu/estimate_lut.hex" .
IFS=$'\n'
verilator --binary --timing -Wno-fatal -Wno-lint -Wno-style --top-module ${1%.sv} -o ${1%.sv} -Mdir $2 \
  "$R/kontrol/cla_pkg.sv" "$R/kontrol/cla_decoder.sv" "$R/kontrol/cla_ctrl_gen.sv" $ALU \
  "$R/top/Execute.sv" "$R/top/Write.sv" $1 2>&1 | grep -E "%Error" | head
