# =====================================================================
#  karta_yukle.tcl - KV260'a JTAG ile: PS kurulumu + bitstream + aktarici
# ---------------------------------------------------------------------
#  Calistirma (kart micro-USB ile bagli, 12 V takili; uart_kopru klasorunden):
#      xsdb b_yolu/karta_yukle.tcl            (xsdb yoksa: xsct b_yolu/karta_yukle.tcl)
#      xsdb b_yolu/karta_yukle.tcl uart0      (UART1 cevap vermezse yedek aktarici)
#  Gerekenler: b_yolu/cikti/{kv260_b.bit, psu_init.tcl}, b_yolu/aktarici/aktarici.elf
#  Bitince aktarici calisir; PC'de seri port 921600 baud'da "CLA aktarici hazir" yazar.
#  Kart guc kesilene kadar boyle kalir; xsdb'yi kapatmak sorun degil.
# =====================================================================
set BURASI [file dirname [file normalize [info script]]]
set CIKTI  [file join $BURASI cikti]
set elf    [file join $BURASI aktarici [expr {[lsearch $argv uart0] >= 0 ? "aktarici_uart0.elf" : "aktarici.elf"}]]
foreach f [list [file join $CIKTI kv260_b.bit] [file join $CIKTI psu_init.tcl] $elf] {
    if {![file exists $f]} { puts "HATA: dosya yok: $f"; exit 1 }
}

proc adim {m} { puts "==== $m" }

adim "JTAG baglantisi"
connect
after 500
puts [targets]

adim "onyukleme kipi JTAG + sistem reseti"
targets -set -nocase -filter {name =~ "*PSU*"}
mwr 0xff5e0200 0x0100          ;# BOOT_MODE_USER: JTAG (KV260'ta onyukleme anahtari yok)
rst -system
after 2000

adim "bitstream"
targets -set -nocase -filter {name =~ "*PSU*"}
fpga -file [file join $CIKTI kv260_b.bit]

adim "PS kurulumu (psu_init)"
targets -set -nocase -filter {name =~ "*PSU*"}
source [file join $CIKTI psu_init.tcl]
psu_init
after 1000
catch {psu_ps_pl_isolation_removal}
after 500
catch {psu_ps_pl_reset_config}       ;# pl_resetn0 birakilir
catch {psu_protection}

adim "aktarici: [file tail $elf]"
targets -set -nocase -filter {name =~ "*A53*#0"}
rst -processor
dow $elf
con
after 500

puts "\nTAMAM: aktarici calisiyor. Simdi PC'de:"
puts "    ../../uygulama/drone_sim/.venv/bin/python -B kart_testi.py --port auto"
disconnect
exit
