# =====================================================================
#  vivado_olustur.tcl - B yolu: proje + blok tasarim + bitstream, ARAYUZSUZ
# ---------------------------------------------------------------------
#  Calistirma (sanal makinede ya da x86 bir PC'de, uart_kopru klasorunun icinden):
#      vivado -mode batch -source b_yolu/vivado_olustur.tcl
#      vivado -mode batch -source b_yolu/vivado_olustur.tcl -tclargs 8     ;# 8 is parcacigi
#  Cikti (b_yolu/cikti/):
#      kv260_b.bit     PL tasarimi
#      psu_init.tcl    PS'i (saatler, MIO, UART, PL saati/reseti) kuran betik
#      kv260_b.xsa     donanim platformu (bitstream dahil; Vitis isterse)
#      rapor.txt       kaynak kullanimi + zamanlama ozeti
#  Tasarim: Zynq MPSoC (KV260 on ayari) --M_AXI_HPM0_LPD--> SmartConnect --> kopru
#           (kv260_b_sarmal: cla_axi_kopru + cla_ctrl_regs + taklit cekirdek)
#           kopru adresi 0x8000_0000 (aktarici.elf bunu bekler), pl_clk0 100 MHz,
#           PS UART referans saati 100 MHz (aktarici.elf bunu bekler).
# =====================================================================
set BURASI [file dirname [file normalize [info script]]]
set RTL    [file normalize [file join $BURASI .. rtl]]
set PROJE  [file join $BURASI proje]
set CIKTI  [file join $BURASI cikti]
set IS     [expr {[llength $argv] > 0 ? [lindex $argv 0] : 4}]
file mkdir $CIKTI

proc adim {m} { puts "\n==== $m ====" }
proc dur {m} { puts "\nHATA: $m"; exit 1 }

# ---------------------------------------------------------------- kart dosyalari
adim "KV260 kart dosyalari"
set bp [lindex [lsort [get_board_parts -quiet *kv260_som*]] end]
if {$bp eq ""} {
    puts "KV260 kart dosyalari yok; Xilinx kart deposundan kurmayi deniyorum (internet gerekir)..."
    catch {xhub::refresh_catalog [xhub::get_xstores xilinx_board_store]}
    catch {xhub::install [xhub::get_xitems -quiet *kv260_som*]}
    catch {xhub::install [xhub::get_xitems -quiet *kv260_carrier*]}
    set bp [lindex [lsort [get_board_parts -quiet *kv260_som*]] end]
}
if {$bp eq ""} { dur "KV260 kart dosyalari bulunamadi. Vivado > Tools > Vivado Store > Boards > 'Kria KV260' kurun." }
puts "kart: $bp"

# ---------------------------------------------------------------- proje
adim "proje"
create_project kv260_b $PROJE -part xck26-sfvc784-2LV-c -force
set_property board_part $bp [current_project]
set kaynak [list \
    $RTL/cla_kopru_cekirdek.sv $RTL/cla_axi_kopru.sv $RTL/cla_cekirdek_taklidi.sv \
    $RTL/cla_ctrl_regs_yamali.sv $RTL/kv260_b_top.sv $RTL/kv260_b_sarmal.v]
foreach f $kaynak { if {![file exists $f]} { dur "kaynak yok: $f" } }
add_files -norecurse $kaynak
set_property file_type SystemVerilog [get_files *.sv]
update_compile_order -fileset sources_1

# ---------------------------------------------------------------- blok tasarim
adim "blok tasarim"
create_bd_design sistem
set ps [create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e zynq_ultra_ps_e_0]
apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1"} $ps

# yalniz HPM0_LPD acik (FPD ana portlari kapali: saatlerini baglamaya gerek kalmasin)
foreach {ozellik deger} {
    CONFIG.PSU__USE__M_AXI_GP0                  0
    CONFIG.PSU__USE__M_AXI_GP1                  0
    CONFIG.PSU__USE__M_AXI_GP2                  1
    CONFIG.PSU__FPGA_PL0_ENABLE                 1
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ  100
    CONFIG.PSU__NUM_FABRIC_RESETS               1
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__FREQMHZ 100
    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__FREQMHZ 100
} {
    if {[catch {set_property $ozellik $deger $ps} e]} { puts "UYARI: $ozellik ayarlanamadi: $e" }
}
foreach o {PSU__USE__M_AXI_GP2 PSU__FPGA_PL0_ENABLE PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ
           PSU__UART1__PERIPHERAL__ENABLE PSU__UART1__PERIPHERAL__IO PSU__CRL_APB__UART1_REF_CTRL__ACT_FREQMHZ
           PSU__UART0__PERIPHERAL__ENABLE PSU__UART0__PERIPHERAL__IO} {
    puts [format "  %-44s %s" $o [get_property -quiet CONFIG.$o $ps]]
}
if {[get_property CONFIG.PSU__USE__M_AXI_GP2 $ps] != 1} { dur "M_AXI_HPM0_LPD acilamadi" }

set kopru [create_bd_cell -type module -reference kv260_b_sarmal kopru]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config [list \
    Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} \
    Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_LPD} Slave {/kopru/s_axi} \
    ddr_seg {Auto} intc_ip {New AXI SmartConnect} master_apm {0}] [get_bd_intf_pins kopru/s_axi]

# otomasyon saat/reset baglamadiysa elle bagla
if {[llength [get_bd_nets -quiet -of_objects [get_bd_pins kopru/clk]]] == 0} {
    connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins kopru/clk]
}
if {[llength [get_bd_nets -quiet -of_objects [get_bd_pins kopru/rst_n]]] == 0} {
    set rs [lindex [get_bd_cells -quiet -filter {VLNV =~ "*proc_sys_reset*"}] 0]
    if {$rs ne ""} {
        connect_bd_net [get_bd_pins $rs/peripheral_aresetn] [get_bd_pins kopru/rst_n]
    } else {
        connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins kopru/rst_n]
    }
}

# adres: 0x8000_0000, 4 KB (aktarici.c: KOPRU_TABAN)
assign_bd_address
set bulundu 0
foreach seg [get_bd_addr_segs -of_objects [get_bd_addr_spaces zynq_ultra_ps_e_0/Data]] {
    if {[string match -nocase "*kopru*" $seg]} {
        set_property range 4K $seg
        set_property offset 0x80000000 $seg
        puts "adres: $seg -> [get_property offset $seg] ([get_property range $seg])"
        set bulundu 1
    }
}
if {!$bulundu} { dur "kopru adres parcasi bulunamadi" }
validate_bd_design
save_bd_design

set sarmal [make_wrapper -files [get_files sistem.bd] -top]
add_files -norecurse $sarmal
set_property top sistem_wrapper [current_fileset]
update_compile_order -fileset sources_1

# ---------------------------------------------------------------- sentez + yerlesim + bitstream
adim "sentez, yerlesim, bitstream ($IS is parcacigi) - sanal makinede uzun surebilir"
launch_runs impl_1 -to_step write_bitstream -jobs $IS
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {
    dur "yerlesim/bitstream bitmedi: [get_property STATUS [get_runs impl_1]] (proje/kv260_b.runs/*/runme.log)"
}

# ---------------------------------------------------------------- ciktilar
adim "ciktilar"
open_run impl_1
set wns [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]
set f [open [file join $CIKTI rapor.txt] w]
puts $f "WNS (setup) = $wns ns"
puts $f [report_utilization -return_string]
close $f
puts "zamanlama: WNS = $wns ns"
if {$wns < 0} { puts "UYARI: zamanlama karsilanmadi (WNS < 0)!" }

set bit [lindex [glob -nocomplain [file join $PROJE kv260_b.runs impl_1 *.bit]] 0]
if {$bit eq ""} { dur "bitstream bulunamadi" }
file copy -force $bit [file join $CIKTI kv260_b.bit]
set psu [lindex [concat \
    [glob -nocomplain [file join $PROJE kv260_b.gen sources_1 bd sistem ip * psu_init.tcl]] \
    [glob -nocomplain [file join $PROJE kv260_b.srcs sources_1 bd sistem ip * psu_init.tcl]]] 0]
if {$psu eq ""} { dur "psu_init.tcl bulunamadi" }
file copy -force $psu [file join $CIKTI psu_init.tcl]
write_hw_platform -fixed -include_bit -force -file [file join $CIKTI kv260_b.xsa]

puts "\nTAMAM. b_yolu/cikti/: kv260_b.bit, psu_init.tcl, kv260_b.xsa, rapor.txt"
puts "Siradaki adim: xsdb b_yolu/karta_yukle.tcl"
