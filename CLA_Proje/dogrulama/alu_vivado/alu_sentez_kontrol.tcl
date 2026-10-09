# ALU sentez denetimi (Vivado, proje gerektirmez).
#
#   vivado -mode batch -source alu_sentez_kontrol.tcl -tclargs <CLA_Proje_klasoru> <part> <periyot_ns>
#   ornek: vivado -mode batch -source alu_sentez_kontrol.tcl -tclargs C:/CLA/CLA_Proje xc7a35tcpg236-1 20
#
# Uretilenler (alu_sentez/ altinda):
#   alu_kaynak.rpt            LUT / FF / DSP / LUTRAM kullanimi (ALU tek basina)
#   alu_latch.txt             cikarilan latch listesi (bos olmali)
#   alu_sentez_funcsim.v      sentez sonrasi fonksiyonel netlist (alu_vektor_tb.sv ile kosulur)
#   alu_zamanlama.rpt         zamanlama ozeti (giris/cikis yazmacli sarmalayici ile)
#   alu_en_kotu_yollar.rpt    en kotu 10 yol
# Not: Bu betik bu Mac'te denenemedi (Vivado yok); komutlar standart Vivado Tcl.

set KOK  [lindex $argv 0]
set PART [lindex $argv 1]
set PER  [lindex $argv 2]
set BURASI [file dirname [file normalize [info script]]]
set R "$KOK/rtl/alu"
set K "$R/kayan_nokta birimi"
set DOSYALAR [list \
  "$K/kodlar.sv" "$K/clasify.sv" "$K/pack.sv" \
  "$K/kayan_nokta_carpma/carp_k1.sv" "$K/kayan_nokta_carpma/carp_k2.sv" "$K/kayan_nokta_carpma/fpu_carpma.sv" \
  "$K/kayan_nokta_topla/topla_k1.sv" "$K/kayan_nokta_topla/topla_k2.sv" "$K/kayan_nokta_topla/fpu_toplama.sv" \
  "$R/tamsayi_islem.sv" "$R/karsilastirma.sv" "$R/kestirme.sv" "$R/donusum.sv" \
  "$R/fpu_kestirme.sv" "$R/fpu_karsilastirma.sv" "$R/fpu_donusum.sv" "$R/ALU.sv"]

file mkdir alu_sentez
cd alu_sentez
# kestirme.sv tabloyu goreli yoldan okur: $readmemh("estimate_lut.hex")
file copy -force "$R/estimate_lut.hex" estimate_lut.hex

# --- 1) ALU tek basina: kaynak, latch, sentez sonrasi netlist -------------
read_verilog -sv $DOSYALAR
synth_design -top ALU -part $PART -mode out_of_context
create_clock -name clk -period $PER [get_ports clk]
report_utilization -file alu_kaynak.rpt
set LATCH [all_latches]
set f [open alu_latch.txt w]
foreach x $LATCH { puts $f $x }
close $f
puts "ALU_DENETIM latch sayisi: [llength $LATCH] (0 olmali; liste alu_latch.txt)"
write_verilog -force -mode funcsim alu_sentez_funcsim.v
close_design

# --- 2) zamanlama: butun giris/cikislar yazmacli -------------------------
read_verilog -sv $DOSYALAR
read_verilog -sv "$BURASI/alu_zamanlama_sarmalayici.sv"
synth_design -top ALU_zamanlama -part $PART -mode out_of_context
create_clock -name clk -period $PER [get_ports clk]
report_timing_summary -max_paths 10 -file alu_zamanlama.rpt
report_timing -max_paths 10 -sort_by slack -file alu_en_kotu_yollar.rpt
set WNS [get_property SLACK [get_timing_paths -max_paths 1 -setup]]
puts "ALU_DENETIM periyot $PER ns, en kotu setup slack (WNS) = $WNS ns (>= 0 olmali; sentez tahmini, yerlestirme sonrasi biraz kotulesir)"
