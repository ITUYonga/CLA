transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib activehdl/xilinx_vip
vlib activehdl/xpm
vlib activehdl/axi_infrastructure_v1_1_0
vlib activehdl/axi_vip_v1_1_22
vlib activehdl/zynq_ultra_ps_e_vip_v1_0_22
vlib activehdl/xil_defaultlib
vlib activehdl/axi_datamover_v5_1_37
vlib activehdl/axi_sg_v4_1_21
vlib activehdl/axi_dma_v7_1_37
vlib activehdl/proc_sys_reset_v5_0_17
vlib activehdl/smartconnect_v1_0
vlib activehdl/axi_register_slice_v2_1_36

vmap xilinx_vip activehdl/xilinx_vip
vmap xpm activehdl/xpm
vmap axi_infrastructure_v1_1_0 activehdl/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_22 activehdl/axi_vip_v1_1_22
vmap zynq_ultra_ps_e_vip_v1_0_22 activehdl/zynq_ultra_ps_e_vip_v1_0_22
vmap xil_defaultlib activehdl/xil_defaultlib
vmap axi_datamover_v5_1_37 activehdl/axi_datamover_v5_1_37
vmap axi_sg_v4_1_21 activehdl/axi_sg_v4_1_21
vmap axi_dma_v7_1_37 activehdl/axi_dma_v7_1_37
vmap proc_sys_reset_v5_0_17 activehdl/proc_sys_reset_v5_0_17
vmap smartconnect_v1_0 activehdl/smartconnect_v1_0
vmap axi_register_slice_v2_1_36 activehdl/axi_register_slice_v2_1_36

vlog -work xilinx_vip  -sv2k12 "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/axi_vip_if.sv" \
"D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/clk_vip_if.sv" \
"D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"D:/programs/Vivado/2025.2/Vivado/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/programs/Vivado/2025.2/Vivado/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"D:/programs/Vivado/2025.2/Vivado/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  \
"D:/programs/Vivado/2025.2/Vivado/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0  -v2k5 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_22  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/b16a/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work zynq_ultra_ps_e_vip_v1_0_22  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl/zynq_ultra_ps_e_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/designv2/ip/designv2_zynq_ultra_ps_e_0_0/sim/designv2_zynq_ultra_ps_e_0_0_vip_wrapper.v" \
"../../../bd/designv2/ip/designv2_radar_wrapper_0_0/sim/designv2_radar_wrapper_0_0.v" \
"../../../bd/designv2/ip/designv2_cla_wrapper_0_0/sim/designv2_cla_wrapper_0_0.v" \

vcom -work axi_datamover_v5_1_37 -93  \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/d44a/hdl/axi_datamover_v5_1_vh_rfs.vhd" \

vcom -work axi_sg_v4_1_21 -93  \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/b193/hdl/axi_sg_v4_1_rfs.vhd" \

vcom -work axi_dma_v7_1_37 -93  \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/7f6a/hdl/axi_dma_v7_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  \
"../../../bd/designv2/ip/designv2_axi_dma_0_0/sim/designv2_axi_dma_0_0.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/sim/bd_4851.v" \

vcom -work proc_sys_reset_v5_0_17 -93  \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/9438/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_1/sim/bd_4851_psr_aclk_0.vhd" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/sc_util_v1_0_vl_rfs.sv" \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/0848/hdl/sc_switchboard_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_2/sim/bd_4851_arinsw_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_3/sim/bd_4851_rinsw_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_4/sim/bd_4851_awinsw_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_5/sim/bd_4851_winsw_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_6/sim/bd_4851_binsw_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_7/sim/bd_4851_aroutsw_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_8/sim/bd_4851_routsw_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_9/sim/bd_4851_awoutsw_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_10/sim/bd_4851_woutsw_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_11/sim/bd_4851_boutsw_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/sc_node_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_12/sim/bd_4851_arni_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_13/sim/bd_4851_rni_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_14/sim/bd_4851_awni_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_15/sim/bd_4851_wni_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_16/sim/bd_4851_bni_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/3d9a/hdl/sc_mmu_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_17/sim/bd_4851_s00mmu_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/7785/hdl/sc_transaction_regulator_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_18/sim/bd_4851_s00tr_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/3051/hdl/sc_si_converter_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_19/sim/bd_4851_s00sic_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/852f/hdl/sc_axi2sc_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_20/sim/bd_4851_s00a2s_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_21/sim/bd_4851_sarn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_22/sim/bd_4851_srn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_23/sim/bd_4851_sawn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_24/sim/bd_4851_swn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_25/sim/bd_4851_sbn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_26/sim/bd_4851_s01mmu_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_27/sim/bd_4851_s01tr_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_28/sim/bd_4851_s01sic_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_29/sim/bd_4851_s01a2s_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_30/sim/bd_4851_sarn_1.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_31/sim/bd_4851_srn_1.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_32/sim/bd_4851_sawn_1.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_33/sim/bd_4851_swn_1.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_34/sim/bd_4851_sbn_1.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/fca9/hdl/sc_sc2axi_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_35/sim/bd_4851_m00s2a_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_36/sim/bd_4851_m00arn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_37/sim/bd_4851_m00rn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_38/sim/bd_4851_m00awn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_39/sim/bd_4851_m00wn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_40/sim/bd_4851_m00bn_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/e44a/hdl/sc_exit_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_41/sim/bd_4851_m00e_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_42/sim/bd_4851_m01s2a_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_43/sim/bd_4851_m01arn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_44/sim/bd_4851_m01rn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_45/sim/bd_4851_m01awn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_46/sim/bd_4851_m01wn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_47/sim/bd_4851_m01bn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_48/sim/bd_4851_m01e_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_49/sim/bd_4851_m02s2a_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_50/sim/bd_4851_m02arn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_51/sim/bd_4851_m02rn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_52/sim/bd_4851_m02awn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_53/sim/bd_4851_m02wn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_54/sim/bd_4851_m02bn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_0/bd_0/ip/ip_55/sim/bd_4851_m02e_0.sv" \

vcom -work smartconnect_v1_0 -93  \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/cb42/hdl/sc_ultralite_v1_0_rfs.vhd" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/cb42/hdl/sc_ultralite_v1_0_rfs.sv" \

vlog -work axi_register_slice_v2_1_36  -v2k5 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../systemv2.gen/sources_1/bd/designv2/ipshared/bc4b/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/designv2/ip/designv2_axi_smc_0/sim/designv2_axi_smc_0.sv" \

vcom -work xil_defaultlib -93  \
"../../../bd/designv2/ip/designv2_rst_ps8_0_99M_0/sim/designv2_rst_ps8_0_99M_0.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/designv2/ip/designv2_axi_smc_1_0/bd_0/sim/bd_8255.v" \

vcom -work xil_defaultlib -93  \
"../../../bd/designv2/ip/designv2_axi_smc_1_0/bd_0/ip/ip_1/sim/bd_8255_psr_aclk_0.vhd" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/designv2/ip/designv2_axi_smc_1_0/bd_0/ip/ip_2/sim/bd_8255_s00mmu_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_1_0/bd_0/ip/ip_3/sim/bd_8255_s00tr_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_1_0/bd_0/ip/ip_4/sim/bd_8255_s00sic_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_1_0/bd_0/ip/ip_5/sim/bd_8255_s00a2s_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_1_0/bd_0/ip/ip_6/sim/bd_8255_sarn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_1_0/bd_0/ip/ip_7/sim/bd_8255_srn_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_1_0/bd_0/ip/ip_8/sim/bd_8255_m00s2a_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_1_0/bd_0/ip/ip_9/sim/bd_8255_m00e_0.sv" \
"../../../bd/designv2/ip/designv2_axi_smc_1_0/sim/designv2_axi_smc_1_0.sv" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/ec67/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/a0fe/hdl" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/f0b6/hdl/verilog" "+incdir+../../../../systemv2.gen/sources_1/bd/designv2/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../../../programs/Vivado/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/programs/Vivado/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l zynq_ultra_ps_e_vip_v1_0_22 -l xil_defaultlib -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/designv2/sim/designv2.v" \

vlog -work xil_defaultlib \
"glbl.v"

