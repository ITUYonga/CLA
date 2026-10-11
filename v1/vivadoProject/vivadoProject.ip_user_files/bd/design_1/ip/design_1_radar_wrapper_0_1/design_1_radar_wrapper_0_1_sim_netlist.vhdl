-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
-- Date        : Sun Oct 11 03:51:12 2026
-- Host        : komputer running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               d:/github/CLA/vivado/vivadoProject/vivadoProject.gen/sources_1/bd/design_1/ip/design_1_radar_wrapper_0_1/design_1_radar_wrapper_0_1_sim_netlist.vhdl
-- Design      : design_1_radar_wrapper_0_1
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xck26-sfvc784-2LV-c
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_radar_wrapper_0_1_axiLiteRegsRTL is
  port (
    s_axi_arready : out STD_LOGIC;
    aresetn_0 : out STD_LOGIC;
    timing : out STD_LOGIC;
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    CEA1 : out STD_LOGIC;
    \txValid_o_reg_rep__0_0\ : out STD_LOGIC;
    \txValid_o_reg_rep__1_0\ : out STD_LOGIC;
    CEA2 : out STD_LOGIC;
    \txValid_o_reg_rep__3_0\ : out STD_LOGIC;
    \txValid_o_reg_rep__4_0\ : out STD_LOGIC;
    \txValid_o_reg_rep__5_0\ : out STD_LOGIC;
    \txValid_o_reg_rep__6_0\ : out STD_LOGIC;
    \txValid_o_reg_rep__7_0\ : out STD_LOGIC;
    \txValid_o_reg_rep__8_0\ : out STD_LOGIC;
    \txValid_o_reg_rep__9_0\ : out STD_LOGIC;
    \txValid_o_reg_rep__10_0\ : out STD_LOGIC;
    \txValid_o_reg_rep__11_0\ : out STD_LOGIC;
    \txValid_o_reg_rep__12_0\ : out STD_LOGIC;
    \txValid_o_reg_rep__13_0\ : out STD_LOGIC;
    \txValid_o_reg_rep__14_0\ : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \cfarAlpha_o_reg[15]_0\ : out STD_LOGIC_VECTOR ( 15 downto 0 );
    \ppMaxGap_o_reg[9]_0\ : out STD_LOGIC_VECTOR ( 9 downto 0 );
    hasDet_reg : out STD_LOGIC;
    CO : out STD_LOGIC_VECTOR ( 0 to 0 );
    \ppLogRatio_o_reg[12]_0\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    \ppLogRatio_o_reg[15]_0\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    acLast_reg : out STD_LOGIC_VECTOR ( 0 to 0 );
    hasDet : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 0 to 0 );
    hasDet_reg_0 : out STD_LOGIC;
    s_axil_bvalid_reg_0 : out STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_araddr_6_sp_1 : out STD_LOGIC;
    \cfarK_o_reg[4]_0\ : out STD_LOGIC_VECTOR ( 4 downto 0 );
    irq : out STD_LOGIC;
    txReel_i : out STD_LOGIC_VECTOR ( 15 downto 0 );
    txComplex_i : out STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    \cfarK_o_reg[3]_0\ : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    \txReel_o_reg[15]_0\ : out STD_LOGIC_VECTOR ( 15 downto 0 );
    \txComplex_o_reg[15]_0\ : out STD_LOGIC_VECTOR ( 15 downto 0 );
    aclk : in STD_LOGIC;
    timing_reg_0 : in STD_LOGIC;
    \latencyCnt_reg[31]_0\ : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 7 downto 0 );
    cpiEnd_o : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 7 downto 0 );
    hasDet_reg_1 : in STD_LOGIC;
    hasDet_reg_2 : in STD_LOGIC;
    \detIdx_reg[11][0]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    acLast : in STD_LOGIC;
    \total_reg[0]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    diff : in STD_LOGIC_VECTOR ( 15 downto 0 );
    hasDet_reg_i_5_0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    close0 : in STD_LOGIC_VECTOR ( 9 downto 0 );
    DI : in STD_LOGIC_VECTOR ( 0 to 0 );
    S : in STD_LOGIC_VECTOR ( 0 to 0 );
    hasDet_reg_i_5_1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    hasDet_reg_i_5_2 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    hasDet_reg_3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    hasDet_reg_4 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    ppDone : in STD_LOGIC;
    \s_axil_rdata_reg[4]_0\ : in STD_LOGIC;
    \s_axil_rdata[4]_i_7_0\ : in STD_LOGIC_VECTOR ( 4 downto 0 );
    ppOverflow : in STD_LOGIC;
    ct1Busy : in STD_LOGIC;
    ct2Busy : in STD_LOGIC;
    \s_axil_rdata_reg[0]_0\ : in STD_LOGIC;
    \s_axil_rdata_reg[2]_0\ : in STD_LOGIC;
    \s_axil_rdata_reg[3]_0\ : in STD_LOGIC;
    \s_axil_rdata_reg[8]_0\ : in STD_LOGIC;
    \s_axil_rdata_reg[1]_0\ : in STD_LOGIC;
    \s_axil_rdata_reg[5]_0\ : in STD_LOGIC;
    \s_axil_rdata_reg[6]_0\ : in STD_LOGIC;
    \s_axil_rdata_reg[7]_0\ : in STD_LOGIC;
    \s_axil_rdata_reg[9]_0\ : in STD_LOGIC;
    s_axi_arvalid : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    \s2KEff[3]_i_2\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bready : in STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    cpiStart_o : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of design_1_radar_wrapper_0_1_axiLiteRegsRTL : entity is "axiLiteRegsRTL";
end design_1_radar_wrapper_0_1_axiLiteRegsRTL;

architecture STRUCTURE of design_1_radar_wrapper_0_1_axiLiteRegsRTL is
  signal \^co\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \^q\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \^aresetn_0\ : STD_LOGIC;
  signal awAddrHold : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal awHold : STD_LOGIC;
  signal awHold_i_1_n_0 : STD_LOGIC;
  signal awHold_reg_n_0 : STD_LOGIC;
  signal \cfarAlpha_o[10]_i_1_n_0\ : STD_LOGIC;
  signal \cfarAlpha_o[11]_i_1_n_0\ : STD_LOGIC;
  signal \cfarAlpha_o[12]_i_1_n_0\ : STD_LOGIC;
  signal \cfarAlpha_o[13]_i_1_n_0\ : STD_LOGIC;
  signal \cfarAlpha_o[14]_i_1_n_0\ : STD_LOGIC;
  signal \cfarAlpha_o[15]_i_1_n_0\ : STD_LOGIC;
  signal \cfarAlpha_o[15]_i_2_n_0\ : STD_LOGIC;
  signal \cfarAlpha_o[15]_i_3_n_0\ : STD_LOGIC;
  signal \cfarAlpha_o[5]_i_1_n_0\ : STD_LOGIC;
  signal \cfarAlpha_o[6]_i_1_n_0\ : STD_LOGIC;
  signal \cfarAlpha_o[7]_i_1_n_0\ : STD_LOGIC;
  signal \cfarAlpha_o[8]_i_1_n_0\ : STD_LOGIC;
  signal \cfarAlpha_o[9]_i_1_n_0\ : STD_LOGIC;
  signal \^cfaralpha_o_reg[15]_0\ : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal \cfarK_o[0]_i_1_n_0\ : STD_LOGIC;
  signal \cfarK_o[2]_i_1_n_0\ : STD_LOGIC;
  signal \cfarK_o[3]_i_1_n_0\ : STD_LOGIC;
  signal \cfarK_o[4]_i_1_n_0\ : STD_LOGIC;
  signal \cfarK_o[4]_i_2_n_0\ : STD_LOGIC;
  signal \cfarK_o[4]_i_3_n_0\ : STD_LOGIC;
  signal \^cfark_o_reg[4]_0\ : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal \cpiCount[0]_i_2_n_0\ : STD_LOGIC;
  signal cpiCount_reg : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \cpiCount_reg[0]_i_1_n_0\ : STD_LOGIC;
  signal \cpiCount_reg[0]_i_1_n_1\ : STD_LOGIC;
  signal \cpiCount_reg[0]_i_1_n_10\ : STD_LOGIC;
  signal \cpiCount_reg[0]_i_1_n_11\ : STD_LOGIC;
  signal \cpiCount_reg[0]_i_1_n_12\ : STD_LOGIC;
  signal \cpiCount_reg[0]_i_1_n_13\ : STD_LOGIC;
  signal \cpiCount_reg[0]_i_1_n_14\ : STD_LOGIC;
  signal \cpiCount_reg[0]_i_1_n_15\ : STD_LOGIC;
  signal \cpiCount_reg[0]_i_1_n_2\ : STD_LOGIC;
  signal \cpiCount_reg[0]_i_1_n_3\ : STD_LOGIC;
  signal \cpiCount_reg[0]_i_1_n_4\ : STD_LOGIC;
  signal \cpiCount_reg[0]_i_1_n_5\ : STD_LOGIC;
  signal \cpiCount_reg[0]_i_1_n_6\ : STD_LOGIC;
  signal \cpiCount_reg[0]_i_1_n_7\ : STD_LOGIC;
  signal \cpiCount_reg[0]_i_1_n_8\ : STD_LOGIC;
  signal \cpiCount_reg[0]_i_1_n_9\ : STD_LOGIC;
  signal \cpiCount_reg[16]_i_1_n_0\ : STD_LOGIC;
  signal \cpiCount_reg[16]_i_1_n_1\ : STD_LOGIC;
  signal \cpiCount_reg[16]_i_1_n_10\ : STD_LOGIC;
  signal \cpiCount_reg[16]_i_1_n_11\ : STD_LOGIC;
  signal \cpiCount_reg[16]_i_1_n_12\ : STD_LOGIC;
  signal \cpiCount_reg[16]_i_1_n_13\ : STD_LOGIC;
  signal \cpiCount_reg[16]_i_1_n_14\ : STD_LOGIC;
  signal \cpiCount_reg[16]_i_1_n_15\ : STD_LOGIC;
  signal \cpiCount_reg[16]_i_1_n_2\ : STD_LOGIC;
  signal \cpiCount_reg[16]_i_1_n_3\ : STD_LOGIC;
  signal \cpiCount_reg[16]_i_1_n_4\ : STD_LOGIC;
  signal \cpiCount_reg[16]_i_1_n_5\ : STD_LOGIC;
  signal \cpiCount_reg[16]_i_1_n_6\ : STD_LOGIC;
  signal \cpiCount_reg[16]_i_1_n_7\ : STD_LOGIC;
  signal \cpiCount_reg[16]_i_1_n_8\ : STD_LOGIC;
  signal \cpiCount_reg[16]_i_1_n_9\ : STD_LOGIC;
  signal \cpiCount_reg[24]_i_1_n_1\ : STD_LOGIC;
  signal \cpiCount_reg[24]_i_1_n_10\ : STD_LOGIC;
  signal \cpiCount_reg[24]_i_1_n_11\ : STD_LOGIC;
  signal \cpiCount_reg[24]_i_1_n_12\ : STD_LOGIC;
  signal \cpiCount_reg[24]_i_1_n_13\ : STD_LOGIC;
  signal \cpiCount_reg[24]_i_1_n_14\ : STD_LOGIC;
  signal \cpiCount_reg[24]_i_1_n_15\ : STD_LOGIC;
  signal \cpiCount_reg[24]_i_1_n_2\ : STD_LOGIC;
  signal \cpiCount_reg[24]_i_1_n_3\ : STD_LOGIC;
  signal \cpiCount_reg[24]_i_1_n_4\ : STD_LOGIC;
  signal \cpiCount_reg[24]_i_1_n_5\ : STD_LOGIC;
  signal \cpiCount_reg[24]_i_1_n_6\ : STD_LOGIC;
  signal \cpiCount_reg[24]_i_1_n_7\ : STD_LOGIC;
  signal \cpiCount_reg[24]_i_1_n_8\ : STD_LOGIC;
  signal \cpiCount_reg[24]_i_1_n_9\ : STD_LOGIC;
  signal \cpiCount_reg[8]_i_1_n_0\ : STD_LOGIC;
  signal \cpiCount_reg[8]_i_1_n_1\ : STD_LOGIC;
  signal \cpiCount_reg[8]_i_1_n_10\ : STD_LOGIC;
  signal \cpiCount_reg[8]_i_1_n_11\ : STD_LOGIC;
  signal \cpiCount_reg[8]_i_1_n_12\ : STD_LOGIC;
  signal \cpiCount_reg[8]_i_1_n_13\ : STD_LOGIC;
  signal \cpiCount_reg[8]_i_1_n_14\ : STD_LOGIC;
  signal \cpiCount_reg[8]_i_1_n_15\ : STD_LOGIC;
  signal \cpiCount_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \cpiCount_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \cpiCount_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \cpiCount_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \cpiCount_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \cpiCount_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal \cpiCount_reg[8]_i_1_n_8\ : STD_LOGIC;
  signal \cpiCount_reg[8]_i_1_n_9\ : STD_LOGIC;
  signal doneFlag_i_1_n_0 : STD_LOGIC;
  signal doneFlag_i_2_n_0 : STD_LOGIC;
  signal doneFlag_i_3_n_0 : STD_LOGIC;
  signal doneFlag_i_4_n_0 : STD_LOGIC;
  signal doneFlag_i_5_n_0 : STD_LOGIC;
  signal doneFlag_i_6_n_0 : STD_LOGIC;
  signal \^hasdet\ : STD_LOGIC;
  signal hasDet_i_10_n_0 : STD_LOGIC;
  signal hasDet_i_11_n_0 : STD_LOGIC;
  signal hasDet_i_18_n_0 : STD_LOGIC;
  signal hasDet_i_21_n_0 : STD_LOGIC;
  signal hasDet_i_22_n_0 : STD_LOGIC;
  signal hasDet_i_26_n_0 : STD_LOGIC;
  signal hasDet_i_27_n_0 : STD_LOGIC;
  signal hasDet_i_28_n_0 : STD_LOGIC;
  signal hasDet_i_29_n_0 : STD_LOGIC;
  signal hasDet_i_30_n_0 : STD_LOGIC;
  signal hasDet_i_31_n_0 : STD_LOGIC;
  signal hasDet_i_32_n_0 : STD_LOGIC;
  signal hasDet_i_34_n_0 : STD_LOGIC;
  signal hasDet_i_35_n_0 : STD_LOGIC;
  signal hasDet_i_36_n_0 : STD_LOGIC;
  signal hasDet_i_37_n_0 : STD_LOGIC;
  signal hasDet_i_38_n_0 : STD_LOGIC;
  signal hasDet_i_39_n_0 : STD_LOGIC;
  signal hasDet_i_42_n_0 : STD_LOGIC;
  signal hasDet_i_43_n_0 : STD_LOGIC;
  signal hasDet_i_44_n_0 : STD_LOGIC;
  signal hasDet_i_45_n_0 : STD_LOGIC;
  signal hasDet_i_46_n_0 : STD_LOGIC;
  signal hasDet_i_47_n_0 : STD_LOGIC;
  signal hasDet_i_48_n_0 : STD_LOGIC;
  signal hasDet_i_50_n_0 : STD_LOGIC;
  signal hasDet_i_51_n_0 : STD_LOGIC;
  signal hasDet_i_52_n_0 : STD_LOGIC;
  signal hasDet_i_53_n_0 : STD_LOGIC;
  signal hasDet_i_54_n_0 : STD_LOGIC;
  signal hasDet_i_55_n_0 : STD_LOGIC;
  signal hasDet_i_56_n_0 : STD_LOGIC;
  signal hasDet_i_58_n_0 : STD_LOGIC;
  signal hasDet_i_7_n_0 : STD_LOGIC;
  signal hasDet_i_8_n_0 : STD_LOGIC;
  signal hasDet_i_95_n_0 : STD_LOGIC;
  signal hasDet_i_96_n_0 : STD_LOGIC;
  signal hasDet_i_97_n_0 : STD_LOGIC;
  signal hasDet_i_98_n_0 : STD_LOGIC;
  signal hasDet_i_99_n_0 : STD_LOGIC;
  signal hasDet_i_9_n_0 : STD_LOGIC;
  signal hasDet_reg_i_17_n_0 : STD_LOGIC;
  signal hasDet_reg_i_17_n_1 : STD_LOGIC;
  signal hasDet_reg_i_17_n_2 : STD_LOGIC;
  signal hasDet_reg_i_17_n_3 : STD_LOGIC;
  signal hasDet_reg_i_17_n_4 : STD_LOGIC;
  signal hasDet_reg_i_17_n_5 : STD_LOGIC;
  signal hasDet_reg_i_17_n_6 : STD_LOGIC;
  signal hasDet_reg_i_17_n_7 : STD_LOGIC;
  signal hasDet_reg_i_20_n_0 : STD_LOGIC;
  signal hasDet_reg_i_20_n_1 : STD_LOGIC;
  signal hasDet_reg_i_20_n_2 : STD_LOGIC;
  signal hasDet_reg_i_20_n_3 : STD_LOGIC;
  signal hasDet_reg_i_20_n_4 : STD_LOGIC;
  signal hasDet_reg_i_20_n_5 : STD_LOGIC;
  signal hasDet_reg_i_20_n_6 : STD_LOGIC;
  signal hasDet_reg_i_20_n_7 : STD_LOGIC;
  signal hasDet_reg_i_4_n_4 : STD_LOGIC;
  signal hasDet_reg_i_4_n_5 : STD_LOGIC;
  signal hasDet_reg_i_4_n_6 : STD_LOGIC;
  signal hasDet_reg_i_4_n_7 : STD_LOGIC;
  signal \^irq\ : STD_LOGIC;
  signal latency : STD_LOGIC_VECTOR ( 0 to 0 );
  signal latencyCnt0 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \latencyCnt[0]_i_10_n_0\ : STD_LOGIC;
  signal \latencyCnt[0]_i_11_n_0\ : STD_LOGIC;
  signal \latencyCnt[0]_i_3_n_0\ : STD_LOGIC;
  signal \latencyCnt[0]_i_4_n_0\ : STD_LOGIC;
  signal \latencyCnt[0]_i_5_n_0\ : STD_LOGIC;
  signal \latencyCnt[0]_i_6_n_0\ : STD_LOGIC;
  signal \latencyCnt[0]_i_7_n_0\ : STD_LOGIC;
  signal \latencyCnt[0]_i_8_n_0\ : STD_LOGIC;
  signal \latencyCnt[0]_i_9_n_0\ : STD_LOGIC;
  signal \latencyCnt[16]_i_2_n_0\ : STD_LOGIC;
  signal \latencyCnt[16]_i_3_n_0\ : STD_LOGIC;
  signal \latencyCnt[16]_i_4_n_0\ : STD_LOGIC;
  signal \latencyCnt[16]_i_5_n_0\ : STD_LOGIC;
  signal \latencyCnt[16]_i_6_n_0\ : STD_LOGIC;
  signal \latencyCnt[16]_i_7_n_0\ : STD_LOGIC;
  signal \latencyCnt[16]_i_8_n_0\ : STD_LOGIC;
  signal \latencyCnt[16]_i_9_n_0\ : STD_LOGIC;
  signal \latencyCnt[24]_i_2_n_0\ : STD_LOGIC;
  signal \latencyCnt[24]_i_3_n_0\ : STD_LOGIC;
  signal \latencyCnt[24]_i_4_n_0\ : STD_LOGIC;
  signal \latencyCnt[24]_i_5_n_0\ : STD_LOGIC;
  signal \latencyCnt[24]_i_6_n_0\ : STD_LOGIC;
  signal \latencyCnt[24]_i_7_n_0\ : STD_LOGIC;
  signal \latencyCnt[24]_i_8_n_0\ : STD_LOGIC;
  signal \latencyCnt[24]_i_9_n_0\ : STD_LOGIC;
  signal \latencyCnt[8]_i_2_n_0\ : STD_LOGIC;
  signal \latencyCnt[8]_i_3_n_0\ : STD_LOGIC;
  signal \latencyCnt[8]_i_4_n_0\ : STD_LOGIC;
  signal \latencyCnt[8]_i_5_n_0\ : STD_LOGIC;
  signal \latencyCnt[8]_i_6_n_0\ : STD_LOGIC;
  signal \latencyCnt[8]_i_7_n_0\ : STD_LOGIC;
  signal \latencyCnt[8]_i_8_n_0\ : STD_LOGIC;
  signal \latencyCnt[8]_i_9_n_0\ : STD_LOGIC;
  signal latencyCnt_reg : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \latencyCnt_reg[0]_i_2_n_0\ : STD_LOGIC;
  signal \latencyCnt_reg[0]_i_2_n_1\ : STD_LOGIC;
  signal \latencyCnt_reg[0]_i_2_n_10\ : STD_LOGIC;
  signal \latencyCnt_reg[0]_i_2_n_11\ : STD_LOGIC;
  signal \latencyCnt_reg[0]_i_2_n_12\ : STD_LOGIC;
  signal \latencyCnt_reg[0]_i_2_n_13\ : STD_LOGIC;
  signal \latencyCnt_reg[0]_i_2_n_14\ : STD_LOGIC;
  signal \latencyCnt_reg[0]_i_2_n_15\ : STD_LOGIC;
  signal \latencyCnt_reg[0]_i_2_n_2\ : STD_LOGIC;
  signal \latencyCnt_reg[0]_i_2_n_3\ : STD_LOGIC;
  signal \latencyCnt_reg[0]_i_2_n_4\ : STD_LOGIC;
  signal \latencyCnt_reg[0]_i_2_n_5\ : STD_LOGIC;
  signal \latencyCnt_reg[0]_i_2_n_6\ : STD_LOGIC;
  signal \latencyCnt_reg[0]_i_2_n_7\ : STD_LOGIC;
  signal \latencyCnt_reg[0]_i_2_n_8\ : STD_LOGIC;
  signal \latencyCnt_reg[0]_i_2_n_9\ : STD_LOGIC;
  signal \latencyCnt_reg[16]_i_1_n_0\ : STD_LOGIC;
  signal \latencyCnt_reg[16]_i_1_n_1\ : STD_LOGIC;
  signal \latencyCnt_reg[16]_i_1_n_10\ : STD_LOGIC;
  signal \latencyCnt_reg[16]_i_1_n_11\ : STD_LOGIC;
  signal \latencyCnt_reg[16]_i_1_n_12\ : STD_LOGIC;
  signal \latencyCnt_reg[16]_i_1_n_13\ : STD_LOGIC;
  signal \latencyCnt_reg[16]_i_1_n_14\ : STD_LOGIC;
  signal \latencyCnt_reg[16]_i_1_n_15\ : STD_LOGIC;
  signal \latencyCnt_reg[16]_i_1_n_2\ : STD_LOGIC;
  signal \latencyCnt_reg[16]_i_1_n_3\ : STD_LOGIC;
  signal \latencyCnt_reg[16]_i_1_n_4\ : STD_LOGIC;
  signal \latencyCnt_reg[16]_i_1_n_5\ : STD_LOGIC;
  signal \latencyCnt_reg[16]_i_1_n_6\ : STD_LOGIC;
  signal \latencyCnt_reg[16]_i_1_n_7\ : STD_LOGIC;
  signal \latencyCnt_reg[16]_i_1_n_8\ : STD_LOGIC;
  signal \latencyCnt_reg[16]_i_1_n_9\ : STD_LOGIC;
  signal \latencyCnt_reg[24]_i_1_n_1\ : STD_LOGIC;
  signal \latencyCnt_reg[24]_i_1_n_10\ : STD_LOGIC;
  signal \latencyCnt_reg[24]_i_1_n_11\ : STD_LOGIC;
  signal \latencyCnt_reg[24]_i_1_n_12\ : STD_LOGIC;
  signal \latencyCnt_reg[24]_i_1_n_13\ : STD_LOGIC;
  signal \latencyCnt_reg[24]_i_1_n_14\ : STD_LOGIC;
  signal \latencyCnt_reg[24]_i_1_n_15\ : STD_LOGIC;
  signal \latencyCnt_reg[24]_i_1_n_2\ : STD_LOGIC;
  signal \latencyCnt_reg[24]_i_1_n_3\ : STD_LOGIC;
  signal \latencyCnt_reg[24]_i_1_n_4\ : STD_LOGIC;
  signal \latencyCnt_reg[24]_i_1_n_5\ : STD_LOGIC;
  signal \latencyCnt_reg[24]_i_1_n_6\ : STD_LOGIC;
  signal \latencyCnt_reg[24]_i_1_n_7\ : STD_LOGIC;
  signal \latencyCnt_reg[24]_i_1_n_8\ : STD_LOGIC;
  signal \latencyCnt_reg[24]_i_1_n_9\ : STD_LOGIC;
  signal \latencyCnt_reg[8]_i_1_n_0\ : STD_LOGIC;
  signal \latencyCnt_reg[8]_i_1_n_1\ : STD_LOGIC;
  signal \latencyCnt_reg[8]_i_1_n_10\ : STD_LOGIC;
  signal \latencyCnt_reg[8]_i_1_n_11\ : STD_LOGIC;
  signal \latencyCnt_reg[8]_i_1_n_12\ : STD_LOGIC;
  signal \latencyCnt_reg[8]_i_1_n_13\ : STD_LOGIC;
  signal \latencyCnt_reg[8]_i_1_n_14\ : STD_LOGIC;
  signal \latencyCnt_reg[8]_i_1_n_15\ : STD_LOGIC;
  signal \latencyCnt_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \latencyCnt_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \latencyCnt_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \latencyCnt_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \latencyCnt_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \latencyCnt_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal \latencyCnt_reg[8]_i_1_n_8\ : STD_LOGIC;
  signal \latencyCnt_reg[8]_i_1_n_9\ : STD_LOGIC;
  signal \latency_reg[16]_i_1_n_0\ : STD_LOGIC;
  signal \latency_reg[16]_i_1_n_1\ : STD_LOGIC;
  signal \latency_reg[16]_i_1_n_2\ : STD_LOGIC;
  signal \latency_reg[16]_i_1_n_3\ : STD_LOGIC;
  signal \latency_reg[16]_i_1_n_4\ : STD_LOGIC;
  signal \latency_reg[16]_i_1_n_5\ : STD_LOGIC;
  signal \latency_reg[16]_i_1_n_6\ : STD_LOGIC;
  signal \latency_reg[16]_i_1_n_7\ : STD_LOGIC;
  signal \latency_reg[24]_i_1_n_0\ : STD_LOGIC;
  signal \latency_reg[24]_i_1_n_1\ : STD_LOGIC;
  signal \latency_reg[24]_i_1_n_2\ : STD_LOGIC;
  signal \latency_reg[24]_i_1_n_3\ : STD_LOGIC;
  signal \latency_reg[24]_i_1_n_4\ : STD_LOGIC;
  signal \latency_reg[24]_i_1_n_5\ : STD_LOGIC;
  signal \latency_reg[24]_i_1_n_6\ : STD_LOGIC;
  signal \latency_reg[24]_i_1_n_7\ : STD_LOGIC;
  signal \latency_reg[31]_i_2_n_2\ : STD_LOGIC;
  signal \latency_reg[31]_i_2_n_3\ : STD_LOGIC;
  signal \latency_reg[31]_i_2_n_4\ : STD_LOGIC;
  signal \latency_reg[31]_i_2_n_5\ : STD_LOGIC;
  signal \latency_reg[31]_i_2_n_6\ : STD_LOGIC;
  signal \latency_reg[31]_i_2_n_7\ : STD_LOGIC;
  signal \latency_reg[8]_i_1_n_0\ : STD_LOGIC;
  signal \latency_reg[8]_i_1_n_1\ : STD_LOGIC;
  signal \latency_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \latency_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \latency_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \latency_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \latency_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \latency_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal \latency_reg_n_0_[0]\ : STD_LOGIC;
  signal \latency_reg_n_0_[10]\ : STD_LOGIC;
  signal \latency_reg_n_0_[11]\ : STD_LOGIC;
  signal \latency_reg_n_0_[12]\ : STD_LOGIC;
  signal \latency_reg_n_0_[13]\ : STD_LOGIC;
  signal \latency_reg_n_0_[14]\ : STD_LOGIC;
  signal \latency_reg_n_0_[15]\ : STD_LOGIC;
  signal \latency_reg_n_0_[16]\ : STD_LOGIC;
  signal \latency_reg_n_0_[17]\ : STD_LOGIC;
  signal \latency_reg_n_0_[18]\ : STD_LOGIC;
  signal \latency_reg_n_0_[19]\ : STD_LOGIC;
  signal \latency_reg_n_0_[1]\ : STD_LOGIC;
  signal \latency_reg_n_0_[20]\ : STD_LOGIC;
  signal \latency_reg_n_0_[21]\ : STD_LOGIC;
  signal \latency_reg_n_0_[22]\ : STD_LOGIC;
  signal \latency_reg_n_0_[23]\ : STD_LOGIC;
  signal \latency_reg_n_0_[24]\ : STD_LOGIC;
  signal \latency_reg_n_0_[25]\ : STD_LOGIC;
  signal \latency_reg_n_0_[26]\ : STD_LOGIC;
  signal \latency_reg_n_0_[27]\ : STD_LOGIC;
  signal \latency_reg_n_0_[28]\ : STD_LOGIC;
  signal \latency_reg_n_0_[29]\ : STD_LOGIC;
  signal \latency_reg_n_0_[2]\ : STD_LOGIC;
  signal \latency_reg_n_0_[30]\ : STD_LOGIC;
  signal \latency_reg_n_0_[31]\ : STD_LOGIC;
  signal \latency_reg_n_0_[3]\ : STD_LOGIC;
  signal \latency_reg_n_0_[4]\ : STD_LOGIC;
  signal \latency_reg_n_0_[5]\ : STD_LOGIC;
  signal \latency_reg_n_0_[6]\ : STD_LOGIC;
  signal \latency_reg_n_0_[7]\ : STD_LOGIC;
  signal \latency_reg_n_0_[8]\ : STD_LOGIC;
  signal \latency_reg_n_0_[9]\ : STD_LOGIC;
  signal p_0_in : STD_LOGIC;
  signal \p_0_in__0\ : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal ppLogRatio : STD_LOGIC_VECTOR ( 13 downto 2 );
  signal \ppLogRatio_o[15]_i_1_n_0\ : STD_LOGIC;
  signal \ppLogRatio_o[15]_i_2_n_0\ : STD_LOGIC;
  signal \^pplogratio_o_reg[12]_0\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \^pplogratio_o_reg[15]_0\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \ppMaxGap_o[9]_i_1_n_0\ : STD_LOGIC;
  signal \^ppmaxgap_o_reg[9]_0\ : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal s_axi_araddr_6_sn_1 : STD_LOGIC;
  signal \^s_axi_arready\ : STD_LOGIC;
  signal \^s_axi_rvalid\ : STD_LOGIC;
  signal s_axil_arready0 : STD_LOGIC;
  signal s_axil_bvalid_i_1_n_0 : STD_LOGIC;
  signal \^s_axil_bvalid_reg_0\ : STD_LOGIC;
  signal \s_axil_rdata[0]_i_15_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[0]_i_16_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[0]_i_17_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[0]_i_18_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[0]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[0]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[0]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[0]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[0]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[0]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[0]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[10]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[10]_i_11_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[10]_i_12_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[10]_i_13_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[10]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[10]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[10]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[10]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[10]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[10]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[11]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[11]_i_11_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[11]_i_12_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[11]_i_13_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[11]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[11]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[11]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[11]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[11]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[11]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[12]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[12]_i_11_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[12]_i_12_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[12]_i_13_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[12]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[12]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[12]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[12]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[12]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[12]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[13]_i_11_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[13]_i_12_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[13]_i_13_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[13]_i_14_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[13]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[13]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[13]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[13]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[13]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[13]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[13]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[14]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[14]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[14]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[14]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[14]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[14]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[14]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[14]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[14]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[15]_i_11_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[15]_i_12_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[15]_i_13_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[15]_i_14_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[15]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[15]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[15]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[15]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[15]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[15]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[15]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[16]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[16]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[16]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[16]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[16]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[16]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[16]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[17]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[17]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[17]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[17]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[17]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[17]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[17]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[18]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[18]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[18]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[18]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[18]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[18]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[18]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[19]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[19]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[19]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[19]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[19]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[19]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[19]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[1]_i_14_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[1]_i_15_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[1]_i_16_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[1]_i_17_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[1]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[1]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[1]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[1]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[1]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[1]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[1]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[20]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[20]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[20]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[20]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[20]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[20]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[20]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[20]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[21]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[21]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[21]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[21]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[21]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[21]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[21]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[22]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[22]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[22]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[22]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[22]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[22]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[22]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[22]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[23]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[23]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[23]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[23]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[23]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[23]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[23]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[24]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[24]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[24]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[24]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[24]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[24]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[24]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[25]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[25]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[25]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[25]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[25]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[25]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[25]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[26]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[26]_i_11_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[26]_i_12_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[26]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[26]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[26]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[26]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[26]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[26]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[27]_i_11_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[27]_i_12_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[27]_i_13_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[27]_i_14_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[27]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[27]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[27]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[27]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[27]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[27]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[27]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[28]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[28]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[28]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[28]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[28]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[28]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[28]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[29]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[29]_i_11_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[29]_i_12_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[29]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[29]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[29]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[29]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[29]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[29]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[2]_i_15_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[2]_i_16_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[2]_i_17_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[2]_i_18_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[2]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[2]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[2]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[2]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[2]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[2]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[2]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[30]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[30]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[30]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[30]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[30]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[30]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[30]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[31]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[31]_i_11_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[31]_i_12_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[31]_i_13_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[31]_i_14_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[31]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[31]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[31]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[31]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[31]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[31]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[3]_i_15_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[3]_i_16_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[3]_i_17_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[3]_i_18_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[3]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[3]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[3]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[3]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[3]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[3]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[3]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[4]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[4]_i_13_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[4]_i_14_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[4]_i_19_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[4]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[4]_i_20_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[4]_i_21_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[4]_i_22_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[4]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[4]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[4]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[4]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[5]_i_13_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[5]_i_14_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[5]_i_15_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[5]_i_16_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[5]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[5]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[5]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[5]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[5]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[5]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[6]_i_13_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[6]_i_14_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[6]_i_15_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[6]_i_16_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[6]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[6]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[6]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[6]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[6]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[6]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[7]_i_13_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[7]_i_14_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[7]_i_15_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[7]_i_16_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[7]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[7]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[7]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[7]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[7]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[7]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[8]_i_15_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[8]_i_16_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[8]_i_17_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[8]_i_18_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[8]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[8]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[8]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[8]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[8]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[8]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[9]_i_13_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[9]_i_14_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[9]_i_15_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[9]_i_16_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[9]_i_1_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[9]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[9]_i_3_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[9]_i_4_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[9]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata[9]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[0]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[0]_i_11_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[0]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[10]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[10]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[10]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[11]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[11]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[11]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[12]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[12]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[12]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[13]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[13]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[13]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[14]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[15]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[15]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[15]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[16]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[16]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[16]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[17]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[17]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[17]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[18]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[18]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[18]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[19]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[19]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[19]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[1]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[1]_i_11_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[1]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[21]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[21]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[21]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[23]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[23]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[23]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[24]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[24]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[24]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[25]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[25]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[25]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[26]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[26]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[26]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[27]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[27]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[27]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[28]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[28]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[28]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[29]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[29]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[29]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[2]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[2]_i_11_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[2]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[30]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[30]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[30]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[31]_i_2_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[31]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[31]_i_7_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[3]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[3]_i_11_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[3]_i_8_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[4]_i_11_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[4]_i_12_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[5]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[5]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[5]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[6]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[6]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[6]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[7]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[7]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[7]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[8]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[8]_i_6_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[8]_i_9_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[9]_i_10_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[9]_i_5_n_0\ : STD_LOGIC;
  signal \s_axil_rdata_reg[9]_i_9_n_0\ : STD_LOGIC;
  signal s_axil_rvalid_i_1_n_0 : STD_LOGIC;
  signal \^timing\ : STD_LOGIC;
  signal \^txcomplex_i\ : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal \txComplex_o[0]_i_2_n_0\ : STD_LOGIC;
  signal \txComplex_o[0]_i_5_n_0\ : STD_LOGIC;
  signal \txComplex_o[0]_i_6_n_0\ : STD_LOGIC;
  signal \txComplex_o[0]_i_7_n_0\ : STD_LOGIC;
  signal \txComplex_o[0]_i_8_n_0\ : STD_LOGIC;
  signal \txComplex_o[10]_i_2_n_0\ : STD_LOGIC;
  signal \txComplex_o[10]_i_5_n_0\ : STD_LOGIC;
  signal \txComplex_o[10]_i_6_n_0\ : STD_LOGIC;
  signal \txComplex_o[10]_i_7_n_0\ : STD_LOGIC;
  signal \txComplex_o[10]_i_8_n_0\ : STD_LOGIC;
  signal \txComplex_o[11]_i_2_n_0\ : STD_LOGIC;
  signal \txComplex_o[11]_i_5_n_0\ : STD_LOGIC;
  signal \txComplex_o[11]_i_6_n_0\ : STD_LOGIC;
  signal \txComplex_o[11]_i_7_n_0\ : STD_LOGIC;
  signal \txComplex_o[11]_i_8_n_0\ : STD_LOGIC;
  signal \txComplex_o[12]_i_2_n_0\ : STD_LOGIC;
  signal \txComplex_o[12]_i_5_n_0\ : STD_LOGIC;
  signal \txComplex_o[12]_i_6_n_0\ : STD_LOGIC;
  signal \txComplex_o[12]_i_7_n_0\ : STD_LOGIC;
  signal \txComplex_o[12]_i_8_n_0\ : STD_LOGIC;
  signal \txComplex_o[13]_i_2_n_0\ : STD_LOGIC;
  signal \txComplex_o[13]_i_5_n_0\ : STD_LOGIC;
  signal \txComplex_o[13]_i_6_n_0\ : STD_LOGIC;
  signal \txComplex_o[13]_i_7_n_0\ : STD_LOGIC;
  signal \txComplex_o[13]_i_8_n_0\ : STD_LOGIC;
  signal \txComplex_o[14]_i_2_n_0\ : STD_LOGIC;
  signal \txComplex_o[14]_i_5_n_0\ : STD_LOGIC;
  signal \txComplex_o[14]_i_6_n_0\ : STD_LOGIC;
  signal \txComplex_o[14]_i_7_n_0\ : STD_LOGIC;
  signal \txComplex_o[14]_i_8_n_0\ : STD_LOGIC;
  signal \txComplex_o[15]_i_2_n_0\ : STD_LOGIC;
  signal \txComplex_o[15]_i_5_n_0\ : STD_LOGIC;
  signal \txComplex_o[15]_i_6_n_0\ : STD_LOGIC;
  signal \txComplex_o[15]_i_7_n_0\ : STD_LOGIC;
  signal \txComplex_o[15]_i_8_n_0\ : STD_LOGIC;
  signal \txComplex_o[1]_i_2_n_0\ : STD_LOGIC;
  signal \txComplex_o[1]_i_5_n_0\ : STD_LOGIC;
  signal \txComplex_o[1]_i_6_n_0\ : STD_LOGIC;
  signal \txComplex_o[1]_i_7_n_0\ : STD_LOGIC;
  signal \txComplex_o[1]_i_8_n_0\ : STD_LOGIC;
  signal \txComplex_o[2]_i_2_n_0\ : STD_LOGIC;
  signal \txComplex_o[2]_i_5_n_0\ : STD_LOGIC;
  signal \txComplex_o[2]_i_6_n_0\ : STD_LOGIC;
  signal \txComplex_o[2]_i_7_n_0\ : STD_LOGIC;
  signal \txComplex_o[2]_i_8_n_0\ : STD_LOGIC;
  signal \txComplex_o[3]_i_2_n_0\ : STD_LOGIC;
  signal \txComplex_o[3]_i_5_n_0\ : STD_LOGIC;
  signal \txComplex_o[3]_i_6_n_0\ : STD_LOGIC;
  signal \txComplex_o[3]_i_7_n_0\ : STD_LOGIC;
  signal \txComplex_o[3]_i_8_n_0\ : STD_LOGIC;
  signal \txComplex_o[4]_i_2_n_0\ : STD_LOGIC;
  signal \txComplex_o[4]_i_5_n_0\ : STD_LOGIC;
  signal \txComplex_o[4]_i_6_n_0\ : STD_LOGIC;
  signal \txComplex_o[4]_i_7_n_0\ : STD_LOGIC;
  signal \txComplex_o[4]_i_8_n_0\ : STD_LOGIC;
  signal \txComplex_o[5]_i_2_n_0\ : STD_LOGIC;
  signal \txComplex_o[5]_i_5_n_0\ : STD_LOGIC;
  signal \txComplex_o[5]_i_6_n_0\ : STD_LOGIC;
  signal \txComplex_o[5]_i_7_n_0\ : STD_LOGIC;
  signal \txComplex_o[5]_i_8_n_0\ : STD_LOGIC;
  signal \txComplex_o[6]_i_2_n_0\ : STD_LOGIC;
  signal \txComplex_o[6]_i_5_n_0\ : STD_LOGIC;
  signal \txComplex_o[6]_i_6_n_0\ : STD_LOGIC;
  signal \txComplex_o[6]_i_7_n_0\ : STD_LOGIC;
  signal \txComplex_o[6]_i_8_n_0\ : STD_LOGIC;
  signal \txComplex_o[7]_i_2_n_0\ : STD_LOGIC;
  signal \txComplex_o[7]_i_5_n_0\ : STD_LOGIC;
  signal \txComplex_o[7]_i_6_n_0\ : STD_LOGIC;
  signal \txComplex_o[7]_i_7_n_0\ : STD_LOGIC;
  signal \txComplex_o[7]_i_8_n_0\ : STD_LOGIC;
  signal \txComplex_o[8]_i_2_n_0\ : STD_LOGIC;
  signal \txComplex_o[8]_i_5_n_0\ : STD_LOGIC;
  signal \txComplex_o[8]_i_6_n_0\ : STD_LOGIC;
  signal \txComplex_o[8]_i_7_n_0\ : STD_LOGIC;
  signal \txComplex_o[8]_i_8_n_0\ : STD_LOGIC;
  signal \txComplex_o[9]_i_2_n_0\ : STD_LOGIC;
  signal \txComplex_o[9]_i_5_n_0\ : STD_LOGIC;
  signal \txComplex_o[9]_i_6_n_0\ : STD_LOGIC;
  signal \txComplex_o[9]_i_7_n_0\ : STD_LOGIC;
  signal \txComplex_o[9]_i_8_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[0]_i_3_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[0]_i_4_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[10]_i_3_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[10]_i_4_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[11]_i_3_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[11]_i_4_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[12]_i_3_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[12]_i_4_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[13]_i_3_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[13]_i_4_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[14]_i_3_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[14]_i_4_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[15]_i_3_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[15]_i_4_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[1]_i_3_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[1]_i_4_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[2]_i_3_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[2]_i_4_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[3]_i_3_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[3]_i_4_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[4]_i_3_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[4]_i_4_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[5]_i_3_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[5]_i_4_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[6]_i_3_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[6]_i_4_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[7]_i_3_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[7]_i_4_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[8]_i_3_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[8]_i_4_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[9]_i_3_n_0\ : STD_LOGIC;
  signal \txComplex_o_reg[9]_i_4_n_0\ : STD_LOGIC;
  signal txLoaded_i_1_n_0 : STD_LOGIC;
  signal txLoaded_reg_n_0 : STD_LOGIC;
  signal txLoading5_out : STD_LOGIC;
  signal txLoading_i_1_n_0 : STD_LOGIC;
  signal txLoading_i_3_n_0 : STD_LOGIC;
  signal txLoading_reg_n_0 : STD_LOGIC;
  signal \txPtr[4]_i_1_n_0\ : STD_LOGIC;
  signal txPtr_reg : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal \^txreel_i\ : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal \txReel_o[0]_i_2_n_0\ : STD_LOGIC;
  signal \txReel_o[0]_i_5_n_0\ : STD_LOGIC;
  signal \txReel_o[0]_i_6_n_0\ : STD_LOGIC;
  signal \txReel_o[0]_i_7_n_0\ : STD_LOGIC;
  signal \txReel_o[0]_i_8_n_0\ : STD_LOGIC;
  signal \txReel_o[10]_i_2_n_0\ : STD_LOGIC;
  signal \txReel_o[10]_i_5_n_0\ : STD_LOGIC;
  signal \txReel_o[10]_i_6_n_0\ : STD_LOGIC;
  signal \txReel_o[10]_i_7_n_0\ : STD_LOGIC;
  signal \txReel_o[10]_i_8_n_0\ : STD_LOGIC;
  signal \txReel_o[11]_i_2_n_0\ : STD_LOGIC;
  signal \txReel_o[11]_i_5_n_0\ : STD_LOGIC;
  signal \txReel_o[11]_i_6_n_0\ : STD_LOGIC;
  signal \txReel_o[11]_i_7_n_0\ : STD_LOGIC;
  signal \txReel_o[11]_i_8_n_0\ : STD_LOGIC;
  signal \txReel_o[12]_i_2_n_0\ : STD_LOGIC;
  signal \txReel_o[12]_i_5_n_0\ : STD_LOGIC;
  signal \txReel_o[12]_i_6_n_0\ : STD_LOGIC;
  signal \txReel_o[12]_i_7_n_0\ : STD_LOGIC;
  signal \txReel_o[12]_i_8_n_0\ : STD_LOGIC;
  signal \txReel_o[13]_i_2_n_0\ : STD_LOGIC;
  signal \txReel_o[13]_i_5_n_0\ : STD_LOGIC;
  signal \txReel_o[13]_i_6_n_0\ : STD_LOGIC;
  signal \txReel_o[13]_i_7_n_0\ : STD_LOGIC;
  signal \txReel_o[13]_i_8_n_0\ : STD_LOGIC;
  signal \txReel_o[14]_i_2_n_0\ : STD_LOGIC;
  signal \txReel_o[14]_i_5_n_0\ : STD_LOGIC;
  signal \txReel_o[14]_i_6_n_0\ : STD_LOGIC;
  signal \txReel_o[14]_i_7_n_0\ : STD_LOGIC;
  signal \txReel_o[14]_i_8_n_0\ : STD_LOGIC;
  signal \txReel_o[15]_i_2_n_0\ : STD_LOGIC;
  signal \txReel_o[15]_i_5_n_0\ : STD_LOGIC;
  signal \txReel_o[15]_i_6_n_0\ : STD_LOGIC;
  signal \txReel_o[15]_i_7_n_0\ : STD_LOGIC;
  signal \txReel_o[15]_i_8_n_0\ : STD_LOGIC;
  signal \txReel_o[1]_i_2_n_0\ : STD_LOGIC;
  signal \txReel_o[1]_i_5_n_0\ : STD_LOGIC;
  signal \txReel_o[1]_i_6_n_0\ : STD_LOGIC;
  signal \txReel_o[1]_i_7_n_0\ : STD_LOGIC;
  signal \txReel_o[1]_i_8_n_0\ : STD_LOGIC;
  signal \txReel_o[2]_i_2_n_0\ : STD_LOGIC;
  signal \txReel_o[2]_i_5_n_0\ : STD_LOGIC;
  signal \txReel_o[2]_i_6_n_0\ : STD_LOGIC;
  signal \txReel_o[2]_i_7_n_0\ : STD_LOGIC;
  signal \txReel_o[2]_i_8_n_0\ : STD_LOGIC;
  signal \txReel_o[3]_i_2_n_0\ : STD_LOGIC;
  signal \txReel_o[3]_i_5_n_0\ : STD_LOGIC;
  signal \txReel_o[3]_i_6_n_0\ : STD_LOGIC;
  signal \txReel_o[3]_i_7_n_0\ : STD_LOGIC;
  signal \txReel_o[3]_i_8_n_0\ : STD_LOGIC;
  signal \txReel_o[4]_i_2_n_0\ : STD_LOGIC;
  signal \txReel_o[4]_i_5_n_0\ : STD_LOGIC;
  signal \txReel_o[4]_i_6_n_0\ : STD_LOGIC;
  signal \txReel_o[4]_i_7_n_0\ : STD_LOGIC;
  signal \txReel_o[4]_i_8_n_0\ : STD_LOGIC;
  signal \txReel_o[5]_i_2_n_0\ : STD_LOGIC;
  signal \txReel_o[5]_i_5_n_0\ : STD_LOGIC;
  signal \txReel_o[5]_i_6_n_0\ : STD_LOGIC;
  signal \txReel_o[5]_i_7_n_0\ : STD_LOGIC;
  signal \txReel_o[5]_i_8_n_0\ : STD_LOGIC;
  signal \txReel_o[6]_i_2_n_0\ : STD_LOGIC;
  signal \txReel_o[6]_i_5_n_0\ : STD_LOGIC;
  signal \txReel_o[6]_i_6_n_0\ : STD_LOGIC;
  signal \txReel_o[6]_i_7_n_0\ : STD_LOGIC;
  signal \txReel_o[6]_i_8_n_0\ : STD_LOGIC;
  signal \txReel_o[7]_i_2_n_0\ : STD_LOGIC;
  signal \txReel_o[7]_i_5_n_0\ : STD_LOGIC;
  signal \txReel_o[7]_i_6_n_0\ : STD_LOGIC;
  signal \txReel_o[7]_i_7_n_0\ : STD_LOGIC;
  signal \txReel_o[7]_i_8_n_0\ : STD_LOGIC;
  signal \txReel_o[8]_i_2_n_0\ : STD_LOGIC;
  signal \txReel_o[8]_i_5_n_0\ : STD_LOGIC;
  signal \txReel_o[8]_i_6_n_0\ : STD_LOGIC;
  signal \txReel_o[8]_i_7_n_0\ : STD_LOGIC;
  signal \txReel_o[8]_i_8_n_0\ : STD_LOGIC;
  signal \txReel_o[9]_i_2_n_0\ : STD_LOGIC;
  signal \txReel_o[9]_i_5_n_0\ : STD_LOGIC;
  signal \txReel_o[9]_i_6_n_0\ : STD_LOGIC;
  signal \txReel_o[9]_i_7_n_0\ : STD_LOGIC;
  signal \txReel_o[9]_i_8_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[0]_i_3_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[0]_i_4_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[10]_i_3_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[10]_i_4_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[11]_i_3_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[11]_i_4_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[12]_i_3_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[12]_i_4_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[13]_i_3_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[13]_i_4_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[14]_i_3_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[14]_i_4_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[15]_i_3_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[15]_i_4_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[1]_i_3_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[1]_i_4_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[2]_i_3_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[2]_i_4_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[3]_i_3_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[3]_i_4_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[4]_i_3_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[4]_i_4_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[5]_i_3_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[5]_i_4_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[6]_i_3_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[6]_i_4_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[7]_i_3_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[7]_i_4_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[8]_i_3_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[8]_i_4_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[9]_i_3_n_0\ : STD_LOGIC;
  signal \txReel_o_reg[9]_i_4_n_0\ : STD_LOGIC;
  signal \txReg[0][16]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[0][17]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[0][18]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[0][19]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[0][20]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[0][21]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[0][22]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[0][23]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[0][24]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[0][25]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[0][26]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[0][27]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[0][28]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[0][29]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[0][30]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[0][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[0][31]_i_2_n_0\ : STD_LOGIC;
  signal \txReg[0][31]_i_3_n_0\ : STD_LOGIC;
  signal \txReg[0][31]_i_4_n_0\ : STD_LOGIC;
  signal \txReg[10][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[11][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[12][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[12][31]_i_2_n_0\ : STD_LOGIC;
  signal \txReg[13][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[14][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[15][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[16][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[16][31]_i_2_n_0\ : STD_LOGIC;
  signal \txReg[16][31]_i_3_n_0\ : STD_LOGIC;
  signal \txReg[17][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[18][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[19][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[1][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[1][31]_i_2_n_0\ : STD_LOGIC;
  signal \txReg[2][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[3][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[3][31]_i_2_n_0\ : STD_LOGIC;
  signal \txReg[3][31]_i_3_n_0\ : STD_LOGIC;
  signal \txReg[4][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[4][31]_i_2_n_0\ : STD_LOGIC;
  signal \txReg[5][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[6][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[7][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[8][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg[8][31]_i_2_n_0\ : STD_LOGIC;
  signal \txReg[9][31]_i_1_n_0\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[0][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[10][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[11][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[12][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[13][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[14][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[15][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[16][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[17][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[18][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[19][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[1][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[2][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[3][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[4][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[5][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[6][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[7][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[8][9]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][0]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][10]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][11]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][12]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][13]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][14]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][15]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][16]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][17]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][18]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][19]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][1]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][20]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][21]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][22]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][23]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][24]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][25]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][26]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][27]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][28]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][29]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][2]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][30]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][31]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][3]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][4]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][5]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][6]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][7]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][8]\ : STD_LOGIC;
  signal \txReg_reg_n_0_[9][9]\ : STD_LOGIC;
  signal wDataHold : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal wHold : STD_LOGIC;
  signal wHold_i_1_n_0 : STD_LOGIC;
  signal wHold_reg_n_0 : STD_LOGIC;
  signal wrFire : STD_LOGIC;
  signal \NLW_cpiCount_reg[24]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 to 7 );
  signal NLW_hasDet_reg_i_17_O_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_hasDet_reg_i_20_O_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_hasDet_reg_i_4_CO_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 5 );
  signal NLW_hasDet_reg_i_4_O_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_hasDet_reg_i_5_CO_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 1 );
  signal NLW_hasDet_reg_i_5_O_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_hasDet_reg_i_6_CO_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 1 );
  signal NLW_hasDet_reg_i_6_O_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \NLW_latencyCnt_reg[24]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 to 7 );
  signal \NLW_latency_reg[31]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 6 );
  signal \NLW_latency_reg[31]_i_2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 to 7 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of awHold_i_1 : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \cfarAlpha_o[10]_i_1\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \cfarAlpha_o[11]_i_1\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \cfarAlpha_o[12]_i_1\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \cfarAlpha_o[13]_i_1\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \cfarAlpha_o[14]_i_1\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \cfarAlpha_o[15]_i_2\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \cfarAlpha_o[15]_i_3\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \cfarAlpha_o[5]_i_1\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \cfarAlpha_o[6]_i_1\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \cfarAlpha_o[7]_i_1\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \cfarAlpha_o[8]_i_1\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \cfarAlpha_o[9]_i_1\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \cfarK_o[0]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \cfarK_o[2]_i_1\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of \cfarK_o[3]_i_1\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of \cfarK_o[4]_i_2\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \cfarK_o[4]_i_3\ : label is "soft_lutpair6";
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of \cpiCount_reg[0]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \cpiCount_reg[16]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \cpiCount_reg[24]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \cpiCount_reg[8]_i_1\ : label is 35;
  attribute SOFT_HLUTNM of doneFlag_i_4 : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of hasDet_i_1 : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of hasDet_i_2 : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of hasDet_i_58 : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of hasDet_i_95 : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of hasDet_i_96 : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of hasDet_i_97 : label is "soft_lutpair2";
  attribute COMPARATOR_THRESHOLD : integer;
  attribute COMPARATOR_THRESHOLD of hasDet_reg_i_17 : label is 11;
  attribute COMPARATOR_THRESHOLD of hasDet_reg_i_20 : label is 11;
  attribute COMPARATOR_THRESHOLD of hasDet_reg_i_4 : label is 11;
  attribute COMPARATOR_THRESHOLD of hasDet_reg_i_5 : label is 11;
  attribute COMPARATOR_THRESHOLD of hasDet_reg_i_6 : label is 11;
  attribute ADDER_THRESHOLD of \latencyCnt_reg[0]_i_2\ : label is 35;
  attribute ADDER_THRESHOLD of \latencyCnt_reg[16]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \latencyCnt_reg[24]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \latencyCnt_reg[8]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \latency_reg[16]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \latency_reg[24]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \latency_reg[31]_i_2\ : label is 35;
  attribute ADDER_THRESHOLD of \latency_reg[8]_i_1\ : label is 35;
  attribute SOFT_HLUTNM of ovf_i_2 : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of s_axi_awready_INST_0 : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of s_axi_wready_INST_0 : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \s_axil_rdata[13]_i_2\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \s_axil_rdata[15]_i_2\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \s_axil_rdata[26]_i_2\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \s_axil_rdata[27]_i_3\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \s_axil_rdata[27]_i_4\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \s_axil_rdata[27]_i_6\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \s_axil_rdata[29]_i_8\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \s_axil_rdata[2]_i_3\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \s_axil_rdata[31]_i_3\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \s_axil_rdata[31]_i_8\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \s_axil_rdata[31]_i_9\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \s_axil_rdata[3]_i_3\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \s_axil_rdata[4]_i_3\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \s_axil_rdata[9]_i_8\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \total[0]_i_1\ : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of txLoaded_i_1 : label is "soft_lutpair36";
  attribute SOFT_HLUTNM of txLoading_i_2 : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of txLoading_i_3 : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \txPtr[0]_i_1\ : label is "soft_lutpair36";
  attribute SOFT_HLUTNM of \txPtr[1]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \txPtr[2]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \txPtr[3]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \txReg[0][16]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \txReg[0][17]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \txReg[0][18]_i_1\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \txReg[0][19]_i_1\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \txReg[0][20]_i_1\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \txReg[0][21]_i_1\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \txReg[0][22]_i_1\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \txReg[0][23]_i_1\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \txReg[0][24]_i_1\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \txReg[0][25]_i_1\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \txReg[0][26]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \txReg[0][27]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \txReg[0][28]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \txReg[0][29]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \txReg[0][30]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \txReg[0][31]_i_2\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \txReg[0][31]_i_3\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \txReg[0][31]_i_4\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \txReg[12][31]_i_2\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \txReg[16][31]_i_3\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \txReg[1][31]_i_2\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \txReg[3][31]_i_3\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \txReg[3][31]_i_4\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \txReg[4][31]_i_2\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \txReg[8][31]_i_2\ : label is "soft_lutpair15";
  attribute ORIG_CELL_NAME : string;
  attribute ORIG_CELL_NAME of txValid_o_reg : label is "txValid_o_reg";
  attribute ORIG_CELL_NAME of txValid_o_reg_rep : label is "txValid_o_reg";
  attribute ORIG_CELL_NAME of \txValid_o_reg_rep__0\ : label is "txValid_o_reg";
  attribute ORIG_CELL_NAME of \txValid_o_reg_rep__1\ : label is "txValid_o_reg";
  attribute ORIG_CELL_NAME of \txValid_o_reg_rep__10\ : label is "txValid_o_reg";
  attribute ORIG_CELL_NAME of \txValid_o_reg_rep__11\ : label is "txValid_o_reg";
  attribute ORIG_CELL_NAME of \txValid_o_reg_rep__12\ : label is "txValid_o_reg";
  attribute ORIG_CELL_NAME of \txValid_o_reg_rep__13\ : label is "txValid_o_reg";
  attribute ORIG_CELL_NAME of \txValid_o_reg_rep__14\ : label is "txValid_o_reg";
  attribute ORIG_CELL_NAME of \txValid_o_reg_rep__2\ : label is "txValid_o_reg";
  attribute ORIG_CELL_NAME of \txValid_o_reg_rep__3\ : label is "txValid_o_reg";
  attribute ORIG_CELL_NAME of \txValid_o_reg_rep__4\ : label is "txValid_o_reg";
  attribute ORIG_CELL_NAME of \txValid_o_reg_rep__5\ : label is "txValid_o_reg";
  attribute ORIG_CELL_NAME of \txValid_o_reg_rep__6\ : label is "txValid_o_reg";
  attribute ORIG_CELL_NAME of \txValid_o_reg_rep__7\ : label is "txValid_o_reg";
  attribute ORIG_CELL_NAME of \txValid_o_reg_rep__8\ : label is "txValid_o_reg";
  attribute ORIG_CELL_NAME of \txValid_o_reg_rep__9\ : label is "txValid_o_reg";
  attribute SOFT_HLUTNM of wHold_i_1 : label is "soft_lutpair5";
begin
  CO(0) <= \^co\(0);
  Q(3 downto 0) <= \^q\(3 downto 0);
  aresetn_0 <= \^aresetn_0\;
  \cfarAlpha_o_reg[15]_0\(15 downto 0) <= \^cfaralpha_o_reg[15]_0\(15 downto 0);
  \cfarK_o_reg[4]_0\(4 downto 0) <= \^cfark_o_reg[4]_0\(4 downto 0);
  hasDet <= \^hasdet\;
  irq <= \^irq\;
  \ppLogRatio_o_reg[12]_0\(0) <= \^pplogratio_o_reg[12]_0\(0);
  \ppLogRatio_o_reg[15]_0\(0) <= \^pplogratio_o_reg[15]_0\(0);
  \ppMaxGap_o_reg[9]_0\(9 downto 0) <= \^ppmaxgap_o_reg[9]_0\(9 downto 0);
  s_axi_araddr_6_sp_1 <= s_axi_araddr_6_sn_1;
  s_axi_arready <= \^s_axi_arready\;
  s_axi_rvalid <= \^s_axi_rvalid\;
  s_axil_bvalid_reg_0 <= \^s_axil_bvalid_reg_0\;
  timing <= \^timing\;
  txComplex_i(15 downto 0) <= \^txcomplex_i\(15 downto 0);
  txReel_i(15 downto 0) <= \^txreel_i\(15 downto 0);
\awAddrHold[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"44440004"
    )
        port map (
      I0 => awHold_reg_n_0,
      I1 => s_axi_awvalid,
      I2 => wHold_reg_n_0,
      I3 => s_axi_wvalid,
      I4 => \^s_axil_bvalid_reg_0\,
      O => awHold
    );
\awAddrHold_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => awHold,
      CLR => \^aresetn_0\,
      D => s_axi_awaddr(0),
      Q => awAddrHold(0)
    );
\awAddrHold_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => awHold,
      CLR => \^aresetn_0\,
      D => s_axi_awaddr(1),
      Q => awAddrHold(1)
    );
\awAddrHold_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => awHold,
      CLR => \^aresetn_0\,
      D => s_axi_awaddr(2),
      Q => awAddrHold(2)
    );
\awAddrHold_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => awHold,
      CLR => \^aresetn_0\,
      D => s_axi_awaddr(3),
      Q => awAddrHold(3)
    );
\awAddrHold_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => awHold,
      CLR => \^aresetn_0\,
      D => s_axi_awaddr(4),
      Q => awAddrHold(4)
    );
\awAddrHold_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => awHold,
      CLR => \^aresetn_0\,
      D => s_axi_awaddr(5),
      Q => awAddrHold(5)
    );
\awAddrHold_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => awHold,
      CLR => \^aresetn_0\,
      D => s_axi_awaddr(6),
      Q => awAddrHold(6)
    );
\awAddrHold_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => awHold,
      CLR => \^aresetn_0\,
      D => s_axi_awaddr(7),
      Q => awAddrHold(7)
    );
awHold_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"ABABAB00"
    )
        port map (
      I0 => \^s_axil_bvalid_reg_0\,
      I1 => s_axi_wvalid,
      I2 => wHold_reg_n_0,
      I3 => s_axi_awvalid,
      I4 => awHold_reg_n_0,
      O => awHold_i_1_n_0
    );
awHold_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => awHold_i_1_n_0,
      Q => awHold_reg_n_0
    );
\cfarAlpha_o[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(10),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(10),
      O => \cfarAlpha_o[10]_i_1_n_0\
    );
\cfarAlpha_o[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(11),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(11),
      O => \cfarAlpha_o[11]_i_1_n_0\
    );
\cfarAlpha_o[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(12),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(12),
      O => \cfarAlpha_o[12]_i_1_n_0\
    );
\cfarAlpha_o[13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(13),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(13),
      O => \cfarAlpha_o[13]_i_1_n_0\
    );
\cfarAlpha_o[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(14),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(14),
      O => \cfarAlpha_o[14]_i_1_n_0\
    );
\cfarAlpha_o[15]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00004700"
    )
        port map (
      I0 => awAddrHold(4),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(4),
      I3 => \cfarAlpha_o[15]_i_3_n_0\,
      I4 => doneFlag_i_3_n_0,
      O => \cfarAlpha_o[15]_i_1_n_0\
    );
\cfarAlpha_o[15]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(15),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(15),
      O => \cfarAlpha_o[15]_i_2_n_0\
    );
\cfarAlpha_o[15]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"CCA000A0"
    )
        port map (
      I0 => s_axi_awaddr(3),
      I1 => awAddrHold(3),
      I2 => s_axi_awaddr(2),
      I3 => awHold_reg_n_0,
      I4 => awAddrHold(2),
      O => \cfarAlpha_o[15]_i_3_n_0\
    );
\cfarAlpha_o[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(5),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(5),
      O => \cfarAlpha_o[5]_i_1_n_0\
    );
\cfarAlpha_o[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(6),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(6),
      O => \cfarAlpha_o[6]_i_1_n_0\
    );
\cfarAlpha_o[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(7),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(7),
      O => \cfarAlpha_o[7]_i_1_n_0\
    );
\cfarAlpha_o[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(8),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(8),
      O => \cfarAlpha_o[8]_i_1_n_0\
    );
\cfarAlpha_o[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(9),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(9),
      O => \cfarAlpha_o[9]_i_1_n_0\
    );
\cfarAlpha_o_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \cfarAlpha_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \^cfaralpha_o_reg[15]_0\(0)
    );
\cfarAlpha_o_reg[10]\: unisim.vcomponents.FDPE
     port map (
      C => aclk,
      CE => \cfarAlpha_o[15]_i_1_n_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      PRE => \^aresetn_0\,
      Q => \^cfaralpha_o_reg[15]_0\(10)
    );
\cfarAlpha_o_reg[11]\: unisim.vcomponents.FDPE
     port map (
      C => aclk,
      CE => \cfarAlpha_o[15]_i_1_n_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      PRE => \^aresetn_0\,
      Q => \^cfaralpha_o_reg[15]_0\(11)
    );
\cfarAlpha_o_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \cfarAlpha_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \^cfaralpha_o_reg[15]_0\(12)
    );
\cfarAlpha_o_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \cfarAlpha_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \^cfaralpha_o_reg[15]_0\(13)
    );
\cfarAlpha_o_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \cfarAlpha_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \^cfaralpha_o_reg[15]_0\(14)
    );
\cfarAlpha_o_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \cfarAlpha_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \^cfaralpha_o_reg[15]_0\(15)
    );
\cfarAlpha_o_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \cfarAlpha_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \^cfaralpha_o_reg[15]_0\(1)
    );
\cfarAlpha_o_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \cfarAlpha_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \^cfaralpha_o_reg[15]_0\(2)
    );
\cfarAlpha_o_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \cfarAlpha_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \^cfaralpha_o_reg[15]_0\(3)
    );
\cfarAlpha_o_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \cfarAlpha_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \^cfaralpha_o_reg[15]_0\(4)
    );
\cfarAlpha_o_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \cfarAlpha_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \^cfaralpha_o_reg[15]_0\(5)
    );
\cfarAlpha_o_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \cfarAlpha_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \^cfaralpha_o_reg[15]_0\(6)
    );
\cfarAlpha_o_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \cfarAlpha_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \^cfaralpha_o_reg[15]_0\(7)
    );
\cfarAlpha_o_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \cfarAlpha_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \^cfaralpha_o_reg[15]_0\(8)
    );
\cfarAlpha_o_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \cfarAlpha_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \^cfaralpha_o_reg[15]_0\(9)
    );
\cfarK_o[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(0),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(0),
      O => \cfarK_o[0]_i_1_n_0\
    );
\cfarK_o[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(1),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(1),
      O => p_0_in
    );
\cfarK_o[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(2),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(2),
      O => \cfarK_o[2]_i_1_n_0\
    );
\cfarK_o[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(3),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(3),
      O => \cfarK_o[3]_i_1_n_0\
    );
\cfarK_o[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00004700"
    )
        port map (
      I0 => awAddrHold(4),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(4),
      I3 => \cfarK_o[4]_i_3_n_0\,
      I4 => doneFlag_i_3_n_0,
      O => \cfarK_o[4]_i_1_n_0\
    );
\cfarK_o[4]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(4),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(4),
      O => \cfarK_o[4]_i_2_n_0\
    );
\cfarK_o[4]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"000ACC0A"
    )
        port map (
      I0 => s_axi_awaddr(3),
      I1 => awAddrHold(3),
      I2 => s_axi_awaddr(2),
      I3 => awHold_reg_n_0,
      I4 => awAddrHold(2),
      O => \cfarK_o[4]_i_3_n_0\
    );
\cfarK_o_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \cfarK_o[4]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \^cfark_o_reg[4]_0\(0)
    );
\cfarK_o_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \cfarK_o[4]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \^cfark_o_reg[4]_0\(1)
    );
\cfarK_o_reg[2]\: unisim.vcomponents.FDPE
     port map (
      C => aclk,
      CE => \cfarK_o[4]_i_1_n_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      PRE => \^aresetn_0\,
      Q => \^cfark_o_reg[4]_0\(2)
    );
\cfarK_o_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \cfarK_o[4]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \^cfark_o_reg[4]_0\(3)
    );
\cfarK_o_reg[4]\: unisim.vcomponents.FDPE
     port map (
      C => aclk,
      CE => \cfarK_o[4]_i_1_n_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      PRE => \^aresetn_0\,
      Q => \^cfark_o_reg[4]_0\(4)
    );
\cpiCount[0]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => cpiCount_reg(0),
      O => \cpiCount[0]_i_2_n_0\
    );
\cpiCount_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[0]_i_1_n_15\,
      Q => cpiCount_reg(0)
    );
\cpiCount_reg[0]_i_1\: unisim.vcomponents.CARRY8
     port map (
      CI => '0',
      CI_TOP => '0',
      CO(7) => \cpiCount_reg[0]_i_1_n_0\,
      CO(6) => \cpiCount_reg[0]_i_1_n_1\,
      CO(5) => \cpiCount_reg[0]_i_1_n_2\,
      CO(4) => \cpiCount_reg[0]_i_1_n_3\,
      CO(3) => \cpiCount_reg[0]_i_1_n_4\,
      CO(2) => \cpiCount_reg[0]_i_1_n_5\,
      CO(1) => \cpiCount_reg[0]_i_1_n_6\,
      CO(0) => \cpiCount_reg[0]_i_1_n_7\,
      DI(7 downto 0) => B"00000001",
      O(7) => \cpiCount_reg[0]_i_1_n_8\,
      O(6) => \cpiCount_reg[0]_i_1_n_9\,
      O(5) => \cpiCount_reg[0]_i_1_n_10\,
      O(4) => \cpiCount_reg[0]_i_1_n_11\,
      O(3) => \cpiCount_reg[0]_i_1_n_12\,
      O(2) => \cpiCount_reg[0]_i_1_n_13\,
      O(1) => \cpiCount_reg[0]_i_1_n_14\,
      O(0) => \cpiCount_reg[0]_i_1_n_15\,
      S(7 downto 1) => cpiCount_reg(7 downto 1),
      S(0) => \cpiCount[0]_i_2_n_0\
    );
\cpiCount_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[8]_i_1_n_13\,
      Q => cpiCount_reg(10)
    );
\cpiCount_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[8]_i_1_n_12\,
      Q => cpiCount_reg(11)
    );
\cpiCount_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[8]_i_1_n_11\,
      Q => cpiCount_reg(12)
    );
\cpiCount_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[8]_i_1_n_10\,
      Q => cpiCount_reg(13)
    );
\cpiCount_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[8]_i_1_n_9\,
      Q => cpiCount_reg(14)
    );
\cpiCount_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[8]_i_1_n_8\,
      Q => cpiCount_reg(15)
    );
\cpiCount_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[16]_i_1_n_15\,
      Q => cpiCount_reg(16)
    );
\cpiCount_reg[16]_i_1\: unisim.vcomponents.CARRY8
     port map (
      CI => \cpiCount_reg[8]_i_1_n_0\,
      CI_TOP => '0',
      CO(7) => \cpiCount_reg[16]_i_1_n_0\,
      CO(6) => \cpiCount_reg[16]_i_1_n_1\,
      CO(5) => \cpiCount_reg[16]_i_1_n_2\,
      CO(4) => \cpiCount_reg[16]_i_1_n_3\,
      CO(3) => \cpiCount_reg[16]_i_1_n_4\,
      CO(2) => \cpiCount_reg[16]_i_1_n_5\,
      CO(1) => \cpiCount_reg[16]_i_1_n_6\,
      CO(0) => \cpiCount_reg[16]_i_1_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7) => \cpiCount_reg[16]_i_1_n_8\,
      O(6) => \cpiCount_reg[16]_i_1_n_9\,
      O(5) => \cpiCount_reg[16]_i_1_n_10\,
      O(4) => \cpiCount_reg[16]_i_1_n_11\,
      O(3) => \cpiCount_reg[16]_i_1_n_12\,
      O(2) => \cpiCount_reg[16]_i_1_n_13\,
      O(1) => \cpiCount_reg[16]_i_1_n_14\,
      O(0) => \cpiCount_reg[16]_i_1_n_15\,
      S(7 downto 0) => cpiCount_reg(23 downto 16)
    );
\cpiCount_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[16]_i_1_n_14\,
      Q => cpiCount_reg(17)
    );
\cpiCount_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[16]_i_1_n_13\,
      Q => cpiCount_reg(18)
    );
\cpiCount_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[16]_i_1_n_12\,
      Q => cpiCount_reg(19)
    );
\cpiCount_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[0]_i_1_n_14\,
      Q => cpiCount_reg(1)
    );
\cpiCount_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[16]_i_1_n_11\,
      Q => cpiCount_reg(20)
    );
\cpiCount_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[16]_i_1_n_10\,
      Q => cpiCount_reg(21)
    );
\cpiCount_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[16]_i_1_n_9\,
      Q => cpiCount_reg(22)
    );
\cpiCount_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[16]_i_1_n_8\,
      Q => cpiCount_reg(23)
    );
\cpiCount_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[24]_i_1_n_15\,
      Q => cpiCount_reg(24)
    );
\cpiCount_reg[24]_i_1\: unisim.vcomponents.CARRY8
     port map (
      CI => \cpiCount_reg[16]_i_1_n_0\,
      CI_TOP => '0',
      CO(7) => \NLW_cpiCount_reg[24]_i_1_CO_UNCONNECTED\(7),
      CO(6) => \cpiCount_reg[24]_i_1_n_1\,
      CO(5) => \cpiCount_reg[24]_i_1_n_2\,
      CO(4) => \cpiCount_reg[24]_i_1_n_3\,
      CO(3) => \cpiCount_reg[24]_i_1_n_4\,
      CO(2) => \cpiCount_reg[24]_i_1_n_5\,
      CO(1) => \cpiCount_reg[24]_i_1_n_6\,
      CO(0) => \cpiCount_reg[24]_i_1_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7) => \cpiCount_reg[24]_i_1_n_8\,
      O(6) => \cpiCount_reg[24]_i_1_n_9\,
      O(5) => \cpiCount_reg[24]_i_1_n_10\,
      O(4) => \cpiCount_reg[24]_i_1_n_11\,
      O(3) => \cpiCount_reg[24]_i_1_n_12\,
      O(2) => \cpiCount_reg[24]_i_1_n_13\,
      O(1) => \cpiCount_reg[24]_i_1_n_14\,
      O(0) => \cpiCount_reg[24]_i_1_n_15\,
      S(7 downto 0) => cpiCount_reg(31 downto 24)
    );
\cpiCount_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[24]_i_1_n_14\,
      Q => cpiCount_reg(25)
    );
\cpiCount_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[24]_i_1_n_13\,
      Q => cpiCount_reg(26)
    );
\cpiCount_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[24]_i_1_n_12\,
      Q => cpiCount_reg(27)
    );
\cpiCount_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[24]_i_1_n_11\,
      Q => cpiCount_reg(28)
    );
\cpiCount_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[24]_i_1_n_10\,
      Q => cpiCount_reg(29)
    );
\cpiCount_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[0]_i_1_n_13\,
      Q => cpiCount_reg(2)
    );
\cpiCount_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[24]_i_1_n_9\,
      Q => cpiCount_reg(30)
    );
\cpiCount_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[24]_i_1_n_8\,
      Q => cpiCount_reg(31)
    );
\cpiCount_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[0]_i_1_n_12\,
      Q => cpiCount_reg(3)
    );
\cpiCount_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[0]_i_1_n_11\,
      Q => cpiCount_reg(4)
    );
\cpiCount_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[0]_i_1_n_10\,
      Q => cpiCount_reg(5)
    );
\cpiCount_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[0]_i_1_n_9\,
      Q => cpiCount_reg(6)
    );
\cpiCount_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[0]_i_1_n_8\,
      Q => cpiCount_reg(7)
    );
\cpiCount_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[8]_i_1_n_15\,
      Q => cpiCount_reg(8)
    );
\cpiCount_reg[8]_i_1\: unisim.vcomponents.CARRY8
     port map (
      CI => \cpiCount_reg[0]_i_1_n_0\,
      CI_TOP => '0',
      CO(7) => \cpiCount_reg[8]_i_1_n_0\,
      CO(6) => \cpiCount_reg[8]_i_1_n_1\,
      CO(5) => \cpiCount_reg[8]_i_1_n_2\,
      CO(4) => \cpiCount_reg[8]_i_1_n_3\,
      CO(3) => \cpiCount_reg[8]_i_1_n_4\,
      CO(2) => \cpiCount_reg[8]_i_1_n_5\,
      CO(1) => \cpiCount_reg[8]_i_1_n_6\,
      CO(0) => \cpiCount_reg[8]_i_1_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7) => \cpiCount_reg[8]_i_1_n_8\,
      O(6) => \cpiCount_reg[8]_i_1_n_9\,
      O(5) => \cpiCount_reg[8]_i_1_n_10\,
      O(4) => \cpiCount_reg[8]_i_1_n_11\,
      O(3) => \cpiCount_reg[8]_i_1_n_12\,
      O(2) => \cpiCount_reg[8]_i_1_n_13\,
      O(1) => \cpiCount_reg[8]_i_1_n_14\,
      O(0) => \cpiCount_reg[8]_i_1_n_15\,
      S(7 downto 0) => cpiCount_reg(15 downto 8)
    );
\cpiCount_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => \cpiCount_reg[8]_i_1_n_14\,
      Q => cpiCount_reg(9)
    );
\detIdx[0][9]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000800080008000"
    )
        port map (
      I0 => \^co\(0),
      I1 => hasDet_reg_1,
      I2 => hasDet_reg_2,
      I3 => \detIdx_reg[11][0]\(0),
      I4 => \^pplogratio_o_reg[12]_0\(0),
      I5 => \^pplogratio_o_reg[15]_0\(0),
      O => hasDet_reg
    );
doneFlag_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5555055544440444"
    )
        port map (
      I0 => cpiStart_o,
      I1 => ppDone,
      I2 => doneFlag_i_2_n_0,
      I3 => p_0_in,
      I4 => doneFlag_i_3_n_0,
      I5 => \^irq\,
      O => doneFlag_i_1_n_0
    );
doneFlag_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000440347"
    )
        port map (
      I0 => awAddrHold(2),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(2),
      I3 => awAddrHold(3),
      I4 => s_axi_awaddr(3),
      I5 => \txReg[3][31]_i_3_n_0\,
      O => doneFlag_i_2_n_0
    );
doneFlag_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFE2"
    )
        port map (
      I0 => s_axi_awaddr(7),
      I1 => awHold_reg_n_0,
      I2 => awAddrHold(7),
      I3 => doneFlag_i_4_n_0,
      I4 => doneFlag_i_5_n_0,
      I5 => doneFlag_i_6_n_0,
      O => doneFlag_i_3_n_0
    );
doneFlag_i_4: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => awAddrHold(5),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(5),
      O => doneFlag_i_4_n_0
    );
doneFlag_i_5: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => awAddrHold(6),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(6),
      O => doneFlag_i_5_n_0
    );
doneFlag_i_6: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFDFFFDFFFD55FD"
    )
        port map (
      I0 => wrFire,
      I1 => s_axi_awaddr(1),
      I2 => s_axi_awaddr(0),
      I3 => awHold_reg_n_0,
      I4 => awAddrHold(1),
      I5 => awAddrHold(0),
      O => doneFlag_i_6_n_0
    );
doneFlag_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => doneFlag_i_1_n_0,
      Q => \^irq\
    );
hasDet_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \^hasdet\,
      I1 => acLast,
      O => acLast_reg(0)
    );
hasDet_i_10: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \^ppmaxgap_o_reg[9]_0\(3),
      I1 => close0(3),
      I2 => \^ppmaxgap_o_reg[9]_0\(2),
      I3 => close0(2),
      O => hasDet_i_10_n_0
    );
hasDet_i_11: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \^ppmaxgap_o_reg[9]_0\(1),
      I1 => close0(1),
      I2 => \^ppmaxgap_o_reg[9]_0\(0),
      I3 => close0(0),
      O => hasDet_i_11_n_0
    );
hasDet_i_18: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^q\(3),
      I1 => hasDet_reg_i_5_0(0),
      O => hasDet_i_18_n_0
    );
hasDet_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AA2A2A2A"
    )
        port map (
      I0 => hasDet_reg_2,
      I1 => \^co\(0),
      I2 => hasDet_reg_1,
      I3 => \^pplogratio_o_reg[15]_0\(0),
      I4 => \^pplogratio_o_reg[12]_0\(0),
      O => \^hasdet\
    );
hasDet_i_21: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFFF0001"
    )
        port map (
      I0 => ppLogRatio(12),
      I1 => ppLogRatio(13),
      I2 => hasDet_i_58_n_0,
      I3 => \^q\(2),
      I4 => \^q\(3),
      I5 => hasDet_reg_i_5_0(0),
      O => hasDet_i_21_n_0
    );
hasDet_i_22: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF00010000FFFE"
    )
        port map (
      I0 => ppLogRatio(12),
      I1 => ppLogRatio(13),
      I2 => hasDet_i_58_n_0,
      I3 => \^q\(2),
      I4 => \^q\(3),
      I5 => hasDet_reg_i_5_0(0),
      O => hasDet_i_22_n_0
    );
hasDet_i_26: unisim.vcomponents.LUT4
    generic map(
      INIT => X"50D4"
    )
        port map (
      I0 => ppLogRatio(13),
      I1 => diff(12),
      I2 => diff(13),
      I3 => ppLogRatio(12),
      O => hasDet_i_26_n_0
    );
hasDet_i_27: unisim.vcomponents.LUT4
    generic map(
      INIT => X"50D4"
    )
        port map (
      I0 => ppLogRatio(11),
      I1 => diff(10),
      I2 => diff(11),
      I3 => ppLogRatio(10),
      O => hasDet_i_27_n_0
    );
hasDet_i_28: unisim.vcomponents.LUT4
    generic map(
      INIT => X"50D4"
    )
        port map (
      I0 => ppLogRatio(9),
      I1 => diff(8),
      I2 => diff(9),
      I3 => ppLogRatio(8),
      O => hasDet_i_28_n_0
    );
hasDet_i_29: unisim.vcomponents.LUT4
    generic map(
      INIT => X"50D4"
    )
        port map (
      I0 => ppLogRatio(7),
      I1 => diff(6),
      I2 => diff(7),
      I3 => ppLogRatio(6),
      O => hasDet_i_29_n_0
    );
hasDet_i_30: unisim.vcomponents.LUT4
    generic map(
      INIT => X"50D4"
    )
        port map (
      I0 => ppLogRatio(5),
      I1 => diff(4),
      I2 => diff(5),
      I3 => ppLogRatio(4),
      O => hasDet_i_30_n_0
    );
hasDet_i_31: unisim.vcomponents.LUT4
    generic map(
      INIT => X"50D4"
    )
        port map (
      I0 => ppLogRatio(3),
      I1 => diff(2),
      I2 => diff(3),
      I3 => ppLogRatio(2),
      O => hasDet_i_31_n_0
    );
hasDet_i_32: unisim.vcomponents.LUT4
    generic map(
      INIT => X"50D4"
    )
        port map (
      I0 => \^q\(1),
      I1 => diff(0),
      I2 => diff(1),
      I3 => \^q\(0),
      O => hasDet_i_32_n_0
    );
hasDet_i_34: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8421"
    )
        port map (
      I0 => ppLogRatio(13),
      I1 => ppLogRatio(12),
      I2 => diff(13),
      I3 => diff(12),
      O => hasDet_i_34_n_0
    );
hasDet_i_35: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8421"
    )
        port map (
      I0 => ppLogRatio(11),
      I1 => ppLogRatio(10),
      I2 => diff(11),
      I3 => diff(10),
      O => hasDet_i_35_n_0
    );
hasDet_i_36: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8421"
    )
        port map (
      I0 => ppLogRatio(9),
      I1 => ppLogRatio(8),
      I2 => diff(9),
      I3 => diff(8),
      O => hasDet_i_36_n_0
    );
hasDet_i_37: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8421"
    )
        port map (
      I0 => ppLogRatio(7),
      I1 => ppLogRatio(6),
      I2 => diff(7),
      I3 => diff(6),
      O => hasDet_i_37_n_0
    );
hasDet_i_38: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8421"
    )
        port map (
      I0 => ppLogRatio(5),
      I1 => ppLogRatio(4),
      I2 => diff(5),
      I3 => diff(4),
      O => hasDet_i_38_n_0
    );
hasDet_i_39: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8421"
    )
        port map (
      I0 => ppLogRatio(3),
      I1 => ppLogRatio(2),
      I2 => diff(3),
      I3 => diff(2),
      O => hasDet_i_39_n_0
    );
hasDet_i_42: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11141774"
    )
        port map (
      I0 => diff(15),
      I1 => \^q\(3),
      I2 => hasDet_i_95_n_0,
      I3 => \^q\(2),
      I4 => diff(14),
      O => hasDet_i_42_n_0
    );
hasDet_i_43: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11141774"
    )
        port map (
      I0 => diff(13),
      I1 => ppLogRatio(13),
      I2 => hasDet_i_58_n_0,
      I3 => ppLogRatio(12),
      I4 => diff(12),
      O => hasDet_i_43_n_0
    );
hasDet_i_44: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11141774"
    )
        port map (
      I0 => diff(11),
      I1 => ppLogRatio(11),
      I2 => hasDet_i_96_n_0,
      I3 => ppLogRatio(10),
      I4 => diff(10),
      O => hasDet_i_44_n_0
    );
hasDet_i_45: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11141774"
    )
        port map (
      I0 => diff(9),
      I1 => ppLogRatio(9),
      I2 => hasDet_i_97_n_0,
      I3 => ppLogRatio(8),
      I4 => diff(8),
      O => hasDet_i_45_n_0
    );
hasDet_i_46: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11141774"
    )
        port map (
      I0 => diff(7),
      I1 => ppLogRatio(7),
      I2 => hasDet_i_98_n_0,
      I3 => ppLogRatio(6),
      I4 => diff(6),
      O => hasDet_i_46_n_0
    );
hasDet_i_47: unisim.vcomponents.LUT5
    generic map(
      INIT => X"11141774"
    )
        port map (
      I0 => diff(5),
      I1 => ppLogRatio(5),
      I2 => hasDet_i_99_n_0,
      I3 => ppLogRatio(4),
      I4 => diff(4),
      O => hasDet_i_47_n_0
    );
hasDet_i_48: unisim.vcomponents.LUT6
    generic map(
      INIT => X"1111111411177774"
    )
        port map (
      I0 => diff(3),
      I1 => ppLogRatio(3),
      I2 => \^q\(1),
      I3 => \^q\(0),
      I4 => ppLogRatio(2),
      I5 => diff(2),
      O => hasDet_i_48_n_0
    );
hasDet_i_50: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01686801"
    )
        port map (
      I0 => diff(14),
      I1 => \^q\(2),
      I2 => hasDet_i_95_n_0,
      I3 => diff(15),
      I4 => \^q\(3),
      O => hasDet_i_50_n_0
    );
hasDet_i_51: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01686801"
    )
        port map (
      I0 => diff(12),
      I1 => ppLogRatio(12),
      I2 => hasDet_i_58_n_0,
      I3 => diff(13),
      I4 => ppLogRatio(13),
      O => hasDet_i_51_n_0
    );
hasDet_i_52: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01686801"
    )
        port map (
      I0 => diff(10),
      I1 => ppLogRatio(10),
      I2 => hasDet_i_96_n_0,
      I3 => diff(11),
      I4 => ppLogRatio(11),
      O => hasDet_i_52_n_0
    );
hasDet_i_53: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01686801"
    )
        port map (
      I0 => diff(8),
      I1 => ppLogRatio(8),
      I2 => hasDet_i_97_n_0,
      I3 => diff(9),
      I4 => ppLogRatio(9),
      O => hasDet_i_53_n_0
    );
hasDet_i_54: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01686801"
    )
        port map (
      I0 => diff(6),
      I1 => ppLogRatio(6),
      I2 => hasDet_i_98_n_0,
      I3 => diff(7),
      I4 => ppLogRatio(7),
      O => hasDet_i_54_n_0
    );
hasDet_i_55: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01686801"
    )
        port map (
      I0 => diff(4),
      I1 => ppLogRatio(4),
      I2 => hasDet_i_99_n_0,
      I3 => diff(5),
      I4 => ppLogRatio(5),
      O => hasDet_i_55_n_0
    );
hasDet_i_56: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0001666866680001"
    )
        port map (
      I0 => diff(2),
      I1 => ppLogRatio(2),
      I2 => \^q\(0),
      I3 => \^q\(1),
      I4 => diff(3),
      I5 => ppLogRatio(3),
      O => hasDet_i_56_n_0
    );
hasDet_i_58: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => hasDet_i_96_n_0,
      I1 => ppLogRatio(11),
      I2 => ppLogRatio(10),
      O => hasDet_i_58_n_0
    );
hasDet_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \^ppmaxgap_o_reg[9]_0\(9),
      I1 => close0(9),
      I2 => \^ppmaxgap_o_reg[9]_0\(8),
      I3 => close0(8),
      O => hasDet_i_7_n_0
    );
hasDet_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \^ppmaxgap_o_reg[9]_0\(7),
      I1 => close0(7),
      I2 => \^ppmaxgap_o_reg[9]_0\(6),
      I3 => close0(6),
      O => hasDet_i_8_n_0
    );
hasDet_i_9: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \^ppmaxgap_o_reg[9]_0\(5),
      I1 => close0(5),
      I2 => \^ppmaxgap_o_reg[9]_0\(4),
      I3 => close0(4),
      O => hasDet_i_9_n_0
    );
hasDet_i_95: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => ppLogRatio(10),
      I1 => ppLogRatio(11),
      I2 => hasDet_i_96_n_0,
      I3 => ppLogRatio(13),
      I4 => ppLogRatio(12),
      O => hasDet_i_95_n_0
    );
hasDet_i_96: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => ppLogRatio(6),
      I1 => ppLogRatio(7),
      I2 => hasDet_i_98_n_0,
      I3 => ppLogRatio(9),
      I4 => ppLogRatio(8),
      O => hasDet_i_96_n_0
    );
hasDet_i_97: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => hasDet_i_98_n_0,
      I1 => ppLogRatio(7),
      I2 => ppLogRatio(6),
      O => hasDet_i_97_n_0
    );
hasDet_i_98: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \^q\(0),
      I1 => \^q\(1),
      I2 => ppLogRatio(2),
      I3 => ppLogRatio(3),
      I4 => ppLogRatio(5),
      I5 => ppLogRatio(4),
      O => hasDet_i_98_n_0
    );
hasDet_i_99: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => ppLogRatio(3),
      I1 => ppLogRatio(2),
      I2 => \^q\(1),
      I3 => \^q\(0),
      O => hasDet_i_99_n_0
    );
hasDet_reg_i_17: unisim.vcomponents.CARRY8
     port map (
      CI => '1',
      CI_TOP => '0',
      CO(7) => hasDet_reg_i_17_n_0,
      CO(6) => hasDet_reg_i_17_n_1,
      CO(5) => hasDet_reg_i_17_n_2,
      CO(4) => hasDet_reg_i_17_n_3,
      CO(3) => hasDet_reg_i_17_n_4,
      CO(2) => hasDet_reg_i_17_n_5,
      CO(1) => hasDet_reg_i_17_n_6,
      CO(0) => hasDet_reg_i_17_n_7,
      DI(7) => hasDet_reg_i_5_1(0),
      DI(6) => hasDet_i_26_n_0,
      DI(5) => hasDet_i_27_n_0,
      DI(4) => hasDet_i_28_n_0,
      DI(3) => hasDet_i_29_n_0,
      DI(2) => hasDet_i_30_n_0,
      DI(1) => hasDet_i_31_n_0,
      DI(0) => hasDet_i_32_n_0,
      O(7 downto 0) => NLW_hasDet_reg_i_17_O_UNCONNECTED(7 downto 0),
      S(7) => hasDet_reg_i_5_2(1),
      S(6) => hasDet_i_34_n_0,
      S(5) => hasDet_i_35_n_0,
      S(4) => hasDet_i_36_n_0,
      S(3) => hasDet_i_37_n_0,
      S(2) => hasDet_i_38_n_0,
      S(1) => hasDet_i_39_n_0,
      S(0) => hasDet_reg_i_5_2(0)
    );
hasDet_reg_i_20: unisim.vcomponents.CARRY8
     port map (
      CI => '1',
      CI_TOP => '0',
      CO(7) => hasDet_reg_i_20_n_0,
      CO(6) => hasDet_reg_i_20_n_1,
      CO(5) => hasDet_reg_i_20_n_2,
      CO(4) => hasDet_reg_i_20_n_3,
      CO(3) => hasDet_reg_i_20_n_4,
      CO(2) => hasDet_reg_i_20_n_5,
      CO(1) => hasDet_reg_i_20_n_6,
      CO(0) => hasDet_reg_i_20_n_7,
      DI(7) => hasDet_i_42_n_0,
      DI(6) => hasDet_i_43_n_0,
      DI(5) => hasDet_i_44_n_0,
      DI(4) => hasDet_i_45_n_0,
      DI(3) => hasDet_i_46_n_0,
      DI(2) => hasDet_i_47_n_0,
      DI(1) => hasDet_i_48_n_0,
      DI(0) => DI(0),
      O(7 downto 0) => NLW_hasDet_reg_i_20_O_UNCONNECTED(7 downto 0),
      S(7) => hasDet_i_50_n_0,
      S(6) => hasDet_i_51_n_0,
      S(5) => hasDet_i_52_n_0,
      S(4) => hasDet_i_53_n_0,
      S(3) => hasDet_i_54_n_0,
      S(2) => hasDet_i_55_n_0,
      S(1) => hasDet_i_56_n_0,
      S(0) => S(0)
    );
hasDet_reg_i_4: unisim.vcomponents.CARRY8
     port map (
      CI => '0',
      CI_TOP => '0',
      CO(7 downto 5) => NLW_hasDet_reg_i_4_CO_UNCONNECTED(7 downto 5),
      CO(4) => \^co\(0),
      CO(3) => hasDet_reg_i_4_n_4,
      CO(2) => hasDet_reg_i_4_n_5,
      CO(1) => hasDet_reg_i_4_n_6,
      CO(0) => hasDet_reg_i_4_n_7,
      DI(7 downto 5) => B"000",
      DI(4) => hasDet_i_7_n_0,
      DI(3) => hasDet_i_8_n_0,
      DI(2) => hasDet_i_9_n_0,
      DI(1) => hasDet_i_10_n_0,
      DI(0) => hasDet_i_11_n_0,
      O(7 downto 0) => NLW_hasDet_reg_i_4_O_UNCONNECTED(7 downto 0),
      S(7 downto 5) => B"000",
      S(4 downto 0) => hasDet_reg_4(4 downto 0)
    );
hasDet_reg_i_5: unisim.vcomponents.CARRY8
     port map (
      CI => hasDet_reg_i_17_n_0,
      CI_TOP => '0',
      CO(7 downto 1) => NLW_hasDet_reg_i_5_CO_UNCONNECTED(7 downto 1),
      CO(0) => \^pplogratio_o_reg[15]_0\(0),
      DI(7 downto 1) => B"0000000",
      DI(0) => hasDet_i_18_n_0,
      O(7 downto 0) => NLW_hasDet_reg_i_5_O_UNCONNECTED(7 downto 0),
      S(7 downto 1) => B"0000000",
      S(0) => hasDet_reg_3(0)
    );
hasDet_reg_i_6: unisim.vcomponents.CARRY8
     port map (
      CI => hasDet_reg_i_20_n_0,
      CI_TOP => '0',
      CO(7 downto 1) => NLW_hasDet_reg_i_6_CO_UNCONNECTED(7 downto 1),
      CO(0) => \^pplogratio_o_reg[12]_0\(0),
      DI(7 downto 1) => B"0000000",
      DI(0) => hasDet_i_21_n_0,
      O(7 downto 0) => NLW_hasDet_reg_i_6_O_UNCONNECTED(7 downto 0),
      S(7 downto 1) => B"0000000",
      S(0) => hasDet_i_22_n_0
    );
\latencyCnt[0]_i_10\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(1),
      I1 => cpiEnd_o,
      O => \latencyCnt[0]_i_10_n_0\
    );
\latencyCnt[0]_i_11\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => latencyCnt_reg(0),
      I1 => cpiEnd_o,
      O => \latencyCnt[0]_i_11_n_0\
    );
\latencyCnt[0]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(0),
      I1 => cpiEnd_o,
      O => \latencyCnt[0]_i_3_n_0\
    );
\latencyCnt[0]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(7),
      I1 => cpiEnd_o,
      O => \latencyCnt[0]_i_4_n_0\
    );
\latencyCnt[0]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(6),
      I1 => cpiEnd_o,
      O => \latencyCnt[0]_i_5_n_0\
    );
\latencyCnt[0]_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(5),
      I1 => cpiEnd_o,
      O => \latencyCnt[0]_i_6_n_0\
    );
\latencyCnt[0]_i_7\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(4),
      I1 => cpiEnd_o,
      O => \latencyCnt[0]_i_7_n_0\
    );
\latencyCnt[0]_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(3),
      I1 => cpiEnd_o,
      O => \latencyCnt[0]_i_8_n_0\
    );
\latencyCnt[0]_i_9\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(2),
      I1 => cpiEnd_o,
      O => \latencyCnt[0]_i_9_n_0\
    );
\latencyCnt[16]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(23),
      I1 => cpiEnd_o,
      O => \latencyCnt[16]_i_2_n_0\
    );
\latencyCnt[16]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(22),
      I1 => cpiEnd_o,
      O => \latencyCnt[16]_i_3_n_0\
    );
\latencyCnt[16]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(21),
      I1 => cpiEnd_o,
      O => \latencyCnt[16]_i_4_n_0\
    );
\latencyCnt[16]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(20),
      I1 => cpiEnd_o,
      O => \latencyCnt[16]_i_5_n_0\
    );
\latencyCnt[16]_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(19),
      I1 => cpiEnd_o,
      O => \latencyCnt[16]_i_6_n_0\
    );
\latencyCnt[16]_i_7\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(18),
      I1 => cpiEnd_o,
      O => \latencyCnt[16]_i_7_n_0\
    );
\latencyCnt[16]_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(17),
      I1 => cpiEnd_o,
      O => \latencyCnt[16]_i_8_n_0\
    );
\latencyCnt[16]_i_9\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(16),
      I1 => cpiEnd_o,
      O => \latencyCnt[16]_i_9_n_0\
    );
\latencyCnt[24]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(31),
      I1 => cpiEnd_o,
      O => \latencyCnt[24]_i_2_n_0\
    );
\latencyCnt[24]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(30),
      I1 => cpiEnd_o,
      O => \latencyCnt[24]_i_3_n_0\
    );
\latencyCnt[24]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(29),
      I1 => cpiEnd_o,
      O => \latencyCnt[24]_i_4_n_0\
    );
\latencyCnt[24]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(28),
      I1 => cpiEnd_o,
      O => \latencyCnt[24]_i_5_n_0\
    );
\latencyCnt[24]_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(27),
      I1 => cpiEnd_o,
      O => \latencyCnt[24]_i_6_n_0\
    );
\latencyCnt[24]_i_7\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(26),
      I1 => cpiEnd_o,
      O => \latencyCnt[24]_i_7_n_0\
    );
\latencyCnt[24]_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(25),
      I1 => cpiEnd_o,
      O => \latencyCnt[24]_i_8_n_0\
    );
\latencyCnt[24]_i_9\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(24),
      I1 => cpiEnd_o,
      O => \latencyCnt[24]_i_9_n_0\
    );
\latencyCnt[8]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(15),
      I1 => cpiEnd_o,
      O => \latencyCnt[8]_i_2_n_0\
    );
\latencyCnt[8]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(14),
      I1 => cpiEnd_o,
      O => \latencyCnt[8]_i_3_n_0\
    );
\latencyCnt[8]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(13),
      I1 => cpiEnd_o,
      O => \latencyCnt[8]_i_4_n_0\
    );
\latencyCnt[8]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(12),
      I1 => cpiEnd_o,
      O => \latencyCnt[8]_i_5_n_0\
    );
\latencyCnt[8]_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(11),
      I1 => cpiEnd_o,
      O => \latencyCnt[8]_i_6_n_0\
    );
\latencyCnt[8]_i_7\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(10),
      I1 => cpiEnd_o,
      O => \latencyCnt[8]_i_7_n_0\
    );
\latencyCnt[8]_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(9),
      I1 => cpiEnd_o,
      O => \latencyCnt[8]_i_8_n_0\
    );
\latencyCnt[8]_i_9\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => latencyCnt_reg(8),
      I1 => cpiEnd_o,
      O => \latencyCnt[8]_i_9_n_0\
    );
\latencyCnt_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[0]_i_2_n_15\,
      Q => latencyCnt_reg(0)
    );
\latencyCnt_reg[0]_i_2\: unisim.vcomponents.CARRY8
     port map (
      CI => '0',
      CI_TOP => '0',
      CO(7) => \latencyCnt_reg[0]_i_2_n_0\,
      CO(6) => \latencyCnt_reg[0]_i_2_n_1\,
      CO(5) => \latencyCnt_reg[0]_i_2_n_2\,
      CO(4) => \latencyCnt_reg[0]_i_2_n_3\,
      CO(3) => \latencyCnt_reg[0]_i_2_n_4\,
      CO(2) => \latencyCnt_reg[0]_i_2_n_5\,
      CO(1) => \latencyCnt_reg[0]_i_2_n_6\,
      CO(0) => \latencyCnt_reg[0]_i_2_n_7\,
      DI(7 downto 1) => B"0000000",
      DI(0) => \latencyCnt[0]_i_3_n_0\,
      O(7) => \latencyCnt_reg[0]_i_2_n_8\,
      O(6) => \latencyCnt_reg[0]_i_2_n_9\,
      O(5) => \latencyCnt_reg[0]_i_2_n_10\,
      O(4) => \latencyCnt_reg[0]_i_2_n_11\,
      O(3) => \latencyCnt_reg[0]_i_2_n_12\,
      O(2) => \latencyCnt_reg[0]_i_2_n_13\,
      O(1) => \latencyCnt_reg[0]_i_2_n_14\,
      O(0) => \latencyCnt_reg[0]_i_2_n_15\,
      S(7) => \latencyCnt[0]_i_4_n_0\,
      S(6) => \latencyCnt[0]_i_5_n_0\,
      S(5) => \latencyCnt[0]_i_6_n_0\,
      S(4) => \latencyCnt[0]_i_7_n_0\,
      S(3) => \latencyCnt[0]_i_8_n_0\,
      S(2) => \latencyCnt[0]_i_9_n_0\,
      S(1) => \latencyCnt[0]_i_10_n_0\,
      S(0) => \latencyCnt[0]_i_11_n_0\
    );
\latencyCnt_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[8]_i_1_n_13\,
      Q => latencyCnt_reg(10)
    );
\latencyCnt_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[8]_i_1_n_12\,
      Q => latencyCnt_reg(11)
    );
\latencyCnt_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[8]_i_1_n_11\,
      Q => latencyCnt_reg(12)
    );
\latencyCnt_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[8]_i_1_n_10\,
      Q => latencyCnt_reg(13)
    );
\latencyCnt_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[8]_i_1_n_9\,
      Q => latencyCnt_reg(14)
    );
\latencyCnt_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[8]_i_1_n_8\,
      Q => latencyCnt_reg(15)
    );
\latencyCnt_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[16]_i_1_n_15\,
      Q => latencyCnt_reg(16)
    );
\latencyCnt_reg[16]_i_1\: unisim.vcomponents.CARRY8
     port map (
      CI => \latencyCnt_reg[8]_i_1_n_0\,
      CI_TOP => '0',
      CO(7) => \latencyCnt_reg[16]_i_1_n_0\,
      CO(6) => \latencyCnt_reg[16]_i_1_n_1\,
      CO(5) => \latencyCnt_reg[16]_i_1_n_2\,
      CO(4) => \latencyCnt_reg[16]_i_1_n_3\,
      CO(3) => \latencyCnt_reg[16]_i_1_n_4\,
      CO(2) => \latencyCnt_reg[16]_i_1_n_5\,
      CO(1) => \latencyCnt_reg[16]_i_1_n_6\,
      CO(0) => \latencyCnt_reg[16]_i_1_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7) => \latencyCnt_reg[16]_i_1_n_8\,
      O(6) => \latencyCnt_reg[16]_i_1_n_9\,
      O(5) => \latencyCnt_reg[16]_i_1_n_10\,
      O(4) => \latencyCnt_reg[16]_i_1_n_11\,
      O(3) => \latencyCnt_reg[16]_i_1_n_12\,
      O(2) => \latencyCnt_reg[16]_i_1_n_13\,
      O(1) => \latencyCnt_reg[16]_i_1_n_14\,
      O(0) => \latencyCnt_reg[16]_i_1_n_15\,
      S(7) => \latencyCnt[16]_i_2_n_0\,
      S(6) => \latencyCnt[16]_i_3_n_0\,
      S(5) => \latencyCnt[16]_i_4_n_0\,
      S(4) => \latencyCnt[16]_i_5_n_0\,
      S(3) => \latencyCnt[16]_i_6_n_0\,
      S(2) => \latencyCnt[16]_i_7_n_0\,
      S(1) => \latencyCnt[16]_i_8_n_0\,
      S(0) => \latencyCnt[16]_i_9_n_0\
    );
\latencyCnt_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[16]_i_1_n_14\,
      Q => latencyCnt_reg(17)
    );
\latencyCnt_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[16]_i_1_n_13\,
      Q => latencyCnt_reg(18)
    );
\latencyCnt_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[16]_i_1_n_12\,
      Q => latencyCnt_reg(19)
    );
\latencyCnt_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[0]_i_2_n_14\,
      Q => latencyCnt_reg(1)
    );
\latencyCnt_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[16]_i_1_n_11\,
      Q => latencyCnt_reg(20)
    );
\latencyCnt_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[16]_i_1_n_10\,
      Q => latencyCnt_reg(21)
    );
\latencyCnt_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[16]_i_1_n_9\,
      Q => latencyCnt_reg(22)
    );
\latencyCnt_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[16]_i_1_n_8\,
      Q => latencyCnt_reg(23)
    );
\latencyCnt_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[24]_i_1_n_15\,
      Q => latencyCnt_reg(24)
    );
\latencyCnt_reg[24]_i_1\: unisim.vcomponents.CARRY8
     port map (
      CI => \latencyCnt_reg[16]_i_1_n_0\,
      CI_TOP => '0',
      CO(7) => \NLW_latencyCnt_reg[24]_i_1_CO_UNCONNECTED\(7),
      CO(6) => \latencyCnt_reg[24]_i_1_n_1\,
      CO(5) => \latencyCnt_reg[24]_i_1_n_2\,
      CO(4) => \latencyCnt_reg[24]_i_1_n_3\,
      CO(3) => \latencyCnt_reg[24]_i_1_n_4\,
      CO(2) => \latencyCnt_reg[24]_i_1_n_5\,
      CO(1) => \latencyCnt_reg[24]_i_1_n_6\,
      CO(0) => \latencyCnt_reg[24]_i_1_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7) => \latencyCnt_reg[24]_i_1_n_8\,
      O(6) => \latencyCnt_reg[24]_i_1_n_9\,
      O(5) => \latencyCnt_reg[24]_i_1_n_10\,
      O(4) => \latencyCnt_reg[24]_i_1_n_11\,
      O(3) => \latencyCnt_reg[24]_i_1_n_12\,
      O(2) => \latencyCnt_reg[24]_i_1_n_13\,
      O(1) => \latencyCnt_reg[24]_i_1_n_14\,
      O(0) => \latencyCnt_reg[24]_i_1_n_15\,
      S(7) => \latencyCnt[24]_i_2_n_0\,
      S(6) => \latencyCnt[24]_i_3_n_0\,
      S(5) => \latencyCnt[24]_i_4_n_0\,
      S(4) => \latencyCnt[24]_i_5_n_0\,
      S(3) => \latencyCnt[24]_i_6_n_0\,
      S(2) => \latencyCnt[24]_i_7_n_0\,
      S(1) => \latencyCnt[24]_i_8_n_0\,
      S(0) => \latencyCnt[24]_i_9_n_0\
    );
\latencyCnt_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[24]_i_1_n_14\,
      Q => latencyCnt_reg(25)
    );
\latencyCnt_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[24]_i_1_n_13\,
      Q => latencyCnt_reg(26)
    );
\latencyCnt_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[24]_i_1_n_12\,
      Q => latencyCnt_reg(27)
    );
\latencyCnt_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[24]_i_1_n_11\,
      Q => latencyCnt_reg(28)
    );
\latencyCnt_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[24]_i_1_n_10\,
      Q => latencyCnt_reg(29)
    );
\latencyCnt_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[0]_i_2_n_13\,
      Q => latencyCnt_reg(2)
    );
\latencyCnt_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[24]_i_1_n_9\,
      Q => latencyCnt_reg(30)
    );
\latencyCnt_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[24]_i_1_n_8\,
      Q => latencyCnt_reg(31)
    );
\latencyCnt_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[0]_i_2_n_12\,
      Q => latencyCnt_reg(3)
    );
\latencyCnt_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[0]_i_2_n_11\,
      Q => latencyCnt_reg(4)
    );
\latencyCnt_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[0]_i_2_n_10\,
      Q => latencyCnt_reg(5)
    );
\latencyCnt_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[0]_i_2_n_9\,
      Q => latencyCnt_reg(6)
    );
\latencyCnt_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[0]_i_2_n_8\,
      Q => latencyCnt_reg(7)
    );
\latencyCnt_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[8]_i_1_n_15\,
      Q => latencyCnt_reg(8)
    );
\latencyCnt_reg[8]_i_1\: unisim.vcomponents.CARRY8
     port map (
      CI => \latencyCnt_reg[0]_i_2_n_0\,
      CI_TOP => '0',
      CO(7) => \latencyCnt_reg[8]_i_1_n_0\,
      CO(6) => \latencyCnt_reg[8]_i_1_n_1\,
      CO(5) => \latencyCnt_reg[8]_i_1_n_2\,
      CO(4) => \latencyCnt_reg[8]_i_1_n_3\,
      CO(3) => \latencyCnt_reg[8]_i_1_n_4\,
      CO(2) => \latencyCnt_reg[8]_i_1_n_5\,
      CO(1) => \latencyCnt_reg[8]_i_1_n_6\,
      CO(0) => \latencyCnt_reg[8]_i_1_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7) => \latencyCnt_reg[8]_i_1_n_8\,
      O(6) => \latencyCnt_reg[8]_i_1_n_9\,
      O(5) => \latencyCnt_reg[8]_i_1_n_10\,
      O(4) => \latencyCnt_reg[8]_i_1_n_11\,
      O(3) => \latencyCnt_reg[8]_i_1_n_12\,
      O(2) => \latencyCnt_reg[8]_i_1_n_13\,
      O(1) => \latencyCnt_reg[8]_i_1_n_14\,
      O(0) => \latencyCnt_reg[8]_i_1_n_15\,
      S(7) => \latencyCnt[8]_i_2_n_0\,
      S(6) => \latencyCnt[8]_i_3_n_0\,
      S(5) => \latencyCnt[8]_i_4_n_0\,
      S(4) => \latencyCnt[8]_i_5_n_0\,
      S(3) => \latencyCnt[8]_i_6_n_0\,
      S(2) => \latencyCnt[8]_i_7_n_0\,
      S(1) => \latencyCnt[8]_i_8_n_0\,
      S(0) => \latencyCnt[8]_i_9_n_0\
    );
\latencyCnt_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \latencyCnt_reg[31]_0\,
      CLR => \^aresetn_0\,
      D => \latencyCnt_reg[8]_i_1_n_14\,
      Q => latencyCnt_reg(9)
    );
\latency[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => latencyCnt_reg(0),
      O => latencyCnt0(0)
    );
\latency[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => \^timing\,
      I1 => ppDone,
      I2 => cpiEnd_o,
      O => latency(0)
    );
\latency_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(0),
      Q => \latency_reg_n_0_[0]\
    );
\latency_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(10),
      Q => \latency_reg_n_0_[10]\
    );
\latency_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(11),
      Q => \latency_reg_n_0_[11]\
    );
\latency_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(12),
      Q => \latency_reg_n_0_[12]\
    );
\latency_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(13),
      Q => \latency_reg_n_0_[13]\
    );
\latency_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(14),
      Q => \latency_reg_n_0_[14]\
    );
\latency_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(15),
      Q => \latency_reg_n_0_[15]\
    );
\latency_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(16),
      Q => \latency_reg_n_0_[16]\
    );
\latency_reg[16]_i_1\: unisim.vcomponents.CARRY8
     port map (
      CI => \latency_reg[8]_i_1_n_0\,
      CI_TOP => '0',
      CO(7) => \latency_reg[16]_i_1_n_0\,
      CO(6) => \latency_reg[16]_i_1_n_1\,
      CO(5) => \latency_reg[16]_i_1_n_2\,
      CO(4) => \latency_reg[16]_i_1_n_3\,
      CO(3) => \latency_reg[16]_i_1_n_4\,
      CO(2) => \latency_reg[16]_i_1_n_5\,
      CO(1) => \latency_reg[16]_i_1_n_6\,
      CO(0) => \latency_reg[16]_i_1_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7 downto 0) => latencyCnt0(16 downto 9),
      S(7 downto 0) => latencyCnt_reg(16 downto 9)
    );
\latency_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(17),
      Q => \latency_reg_n_0_[17]\
    );
\latency_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(18),
      Q => \latency_reg_n_0_[18]\
    );
\latency_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(19),
      Q => \latency_reg_n_0_[19]\
    );
\latency_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(1),
      Q => \latency_reg_n_0_[1]\
    );
\latency_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(20),
      Q => \latency_reg_n_0_[20]\
    );
\latency_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(21),
      Q => \latency_reg_n_0_[21]\
    );
\latency_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(22),
      Q => \latency_reg_n_0_[22]\
    );
\latency_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(23),
      Q => \latency_reg_n_0_[23]\
    );
\latency_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(24),
      Q => \latency_reg_n_0_[24]\
    );
\latency_reg[24]_i_1\: unisim.vcomponents.CARRY8
     port map (
      CI => \latency_reg[16]_i_1_n_0\,
      CI_TOP => '0',
      CO(7) => \latency_reg[24]_i_1_n_0\,
      CO(6) => \latency_reg[24]_i_1_n_1\,
      CO(5) => \latency_reg[24]_i_1_n_2\,
      CO(4) => \latency_reg[24]_i_1_n_3\,
      CO(3) => \latency_reg[24]_i_1_n_4\,
      CO(2) => \latency_reg[24]_i_1_n_5\,
      CO(1) => \latency_reg[24]_i_1_n_6\,
      CO(0) => \latency_reg[24]_i_1_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7 downto 0) => latencyCnt0(24 downto 17),
      S(7 downto 0) => latencyCnt_reg(24 downto 17)
    );
\latency_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(25),
      Q => \latency_reg_n_0_[25]\
    );
\latency_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(26),
      Q => \latency_reg_n_0_[26]\
    );
\latency_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(27),
      Q => \latency_reg_n_0_[27]\
    );
\latency_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(28),
      Q => \latency_reg_n_0_[28]\
    );
\latency_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(29),
      Q => \latency_reg_n_0_[29]\
    );
\latency_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(2),
      Q => \latency_reg_n_0_[2]\
    );
\latency_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(30),
      Q => \latency_reg_n_0_[30]\
    );
\latency_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(31),
      Q => \latency_reg_n_0_[31]\
    );
\latency_reg[31]_i_2\: unisim.vcomponents.CARRY8
     port map (
      CI => \latency_reg[24]_i_1_n_0\,
      CI_TOP => '0',
      CO(7 downto 6) => \NLW_latency_reg[31]_i_2_CO_UNCONNECTED\(7 downto 6),
      CO(5) => \latency_reg[31]_i_2_n_2\,
      CO(4) => \latency_reg[31]_i_2_n_3\,
      CO(3) => \latency_reg[31]_i_2_n_4\,
      CO(2) => \latency_reg[31]_i_2_n_5\,
      CO(1) => \latency_reg[31]_i_2_n_6\,
      CO(0) => \latency_reg[31]_i_2_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7) => \NLW_latency_reg[31]_i_2_O_UNCONNECTED\(7),
      O(6 downto 0) => latencyCnt0(31 downto 25),
      S(7) => '0',
      S(6 downto 0) => latencyCnt_reg(31 downto 25)
    );
\latency_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(3),
      Q => \latency_reg_n_0_[3]\
    );
\latency_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(4),
      Q => \latency_reg_n_0_[4]\
    );
\latency_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(5),
      Q => \latency_reg_n_0_[5]\
    );
\latency_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(6),
      Q => \latency_reg_n_0_[6]\
    );
\latency_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(7),
      Q => \latency_reg_n_0_[7]\
    );
\latency_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(8),
      Q => \latency_reg_n_0_[8]\
    );
\latency_reg[8]_i_1\: unisim.vcomponents.CARRY8
     port map (
      CI => latencyCnt_reg(0),
      CI_TOP => '0',
      CO(7) => \latency_reg[8]_i_1_n_0\,
      CO(6) => \latency_reg[8]_i_1_n_1\,
      CO(5) => \latency_reg[8]_i_1_n_2\,
      CO(4) => \latency_reg[8]_i_1_n_3\,
      CO(3) => \latency_reg[8]_i_1_n_4\,
      CO(2) => \latency_reg[8]_i_1_n_5\,
      CO(1) => \latency_reg[8]_i_1_n_6\,
      CO(0) => \latency_reg[8]_i_1_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7 downto 0) => latencyCnt0(8 downto 1),
      S(7 downto 0) => latencyCnt_reg(8 downto 1)
    );
\latency_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => latency(0),
      CLR => \^aresetn_0\,
      D => latencyCnt0(9),
      Q => \latency_reg_n_0_[9]\
    );
ovf_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8FFF"
    )
        port map (
      I0 => \^pplogratio_o_reg[12]_0\(0),
      I1 => \^pplogratio_o_reg[15]_0\(0),
      I2 => hasDet_reg_1,
      I3 => \^co\(0),
      O => hasDet_reg_0
    );
\ppLogRatio_o[15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"02A2"
    )
        port map (
      I0 => \ppLogRatio_o[15]_i_2_n_0\,
      I1 => s_axi_awaddr(2),
      I2 => awHold_reg_n_0,
      I3 => awAddrHold(2),
      O => \ppLogRatio_o[15]_i_1_n_0\
    );
\ppLogRatio_o[15]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000404005004540"
    )
        port map (
      I0 => doneFlag_i_3_n_0,
      I1 => awAddrHold(4),
      I2 => awHold_reg_n_0,
      I3 => s_axi_awaddr(4),
      I4 => awAddrHold(3),
      I5 => s_axi_awaddr(3),
      O => \ppLogRatio_o[15]_i_2_n_0\
    );
\ppLogRatio_o_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \ppLogRatio_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \^q\(0)
    );
\ppLogRatio_o_reg[10]\: unisim.vcomponents.FDPE
     port map (
      C => aclk,
      CE => \ppLogRatio_o[15]_i_1_n_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      PRE => \^aresetn_0\,
      Q => ppLogRatio(10)
    );
\ppLogRatio_o_reg[11]\: unisim.vcomponents.FDPE
     port map (
      C => aclk,
      CE => \ppLogRatio_o[15]_i_1_n_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      PRE => \^aresetn_0\,
      Q => ppLogRatio(11)
    );
\ppLogRatio_o_reg[12]\: unisim.vcomponents.FDPE
     port map (
      C => aclk,
      CE => \ppLogRatio_o[15]_i_1_n_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      PRE => \^aresetn_0\,
      Q => ppLogRatio(12)
    );
\ppLogRatio_o_reg[13]\: unisim.vcomponents.FDPE
     port map (
      C => aclk,
      CE => \ppLogRatio_o[15]_i_1_n_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      PRE => \^aresetn_0\,
      Q => ppLogRatio(13)
    );
\ppLogRatio_o_reg[14]\: unisim.vcomponents.FDPE
     port map (
      C => aclk,
      CE => \ppLogRatio_o[15]_i_1_n_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      PRE => \^aresetn_0\,
      Q => \^q\(2)
    );
\ppLogRatio_o_reg[15]\: unisim.vcomponents.FDPE
     port map (
      C => aclk,
      CE => \ppLogRatio_o[15]_i_1_n_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      PRE => \^aresetn_0\,
      Q => \^q\(3)
    );
\ppLogRatio_o_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \ppLogRatio_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \^q\(1)
    );
\ppLogRatio_o_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \ppLogRatio_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => ppLogRatio(2)
    );
\ppLogRatio_o_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \ppLogRatio_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => ppLogRatio(3)
    );
\ppLogRatio_o_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \ppLogRatio_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => ppLogRatio(4)
    );
\ppLogRatio_o_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \ppLogRatio_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => ppLogRatio(5)
    );
\ppLogRatio_o_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \ppLogRatio_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => ppLogRatio(6)
    );
\ppLogRatio_o_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \ppLogRatio_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => ppLogRatio(7)
    );
\ppLogRatio_o_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \ppLogRatio_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => ppLogRatio(8)
    );
\ppLogRatio_o_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \ppLogRatio_o[15]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => ppLogRatio(9)
    );
\ppMaxGap_o[9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => s_axi_awaddr(2),
      I1 => awHold_reg_n_0,
      I2 => awAddrHold(2),
      I3 => \ppLogRatio_o[15]_i_2_n_0\,
      O => \ppMaxGap_o[9]_i_1_n_0\
    );
\ppMaxGap_o_reg[0]\: unisim.vcomponents.FDPE
     port map (
      C => aclk,
      CE => \ppMaxGap_o[9]_i_1_n_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      PRE => \^aresetn_0\,
      Q => \^ppmaxgap_o_reg[9]_0\(0)
    );
\ppMaxGap_o_reg[1]\: unisim.vcomponents.FDPE
     port map (
      C => aclk,
      CE => \ppMaxGap_o[9]_i_1_n_0\,
      D => p_0_in,
      PRE => \^aresetn_0\,
      Q => \^ppmaxgap_o_reg[9]_0\(1)
    );
\ppMaxGap_o_reg[2]\: unisim.vcomponents.FDPE
     port map (
      C => aclk,
      CE => \ppMaxGap_o[9]_i_1_n_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      PRE => \^aresetn_0\,
      Q => \^ppmaxgap_o_reg[9]_0\(2)
    );
\ppMaxGap_o_reg[3]\: unisim.vcomponents.FDPE
     port map (
      C => aclk,
      CE => \ppMaxGap_o[9]_i_1_n_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      PRE => \^aresetn_0\,
      Q => \^ppmaxgap_o_reg[9]_0\(3)
    );
\ppMaxGap_o_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \ppMaxGap_o[9]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \^ppmaxgap_o_reg[9]_0\(4)
    );
\ppMaxGap_o_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \ppMaxGap_o[9]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \^ppmaxgap_o_reg[9]_0\(5)
    );
\ppMaxGap_o_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \ppMaxGap_o[9]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \^ppmaxgap_o_reg[9]_0\(6)
    );
\ppMaxGap_o_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \ppMaxGap_o[9]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \^ppmaxgap_o_reg[9]_0\(7)
    );
\ppMaxGap_o_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \ppMaxGap_o[9]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \^ppmaxgap_o_reg[9]_0\(8)
    );
\ppMaxGap_o_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \ppMaxGap_o[9]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \^ppmaxgap_o_reg[9]_0\(9)
    );
\s2KEff[3]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4F44"
    )
        port map (
      I0 => \^cfark_o_reg[4]_0\(3),
      I1 => \s2KEff[3]_i_2\(1),
      I2 => \^cfark_o_reg[4]_0\(2),
      I3 => \s2KEff[3]_i_2\(0),
      O => \cfarK_o_reg[3]_0\
    );
s_axi_awready_INST_0: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => awHold_reg_n_0,
      O => s_axi_awready
    );
s_axi_wready_INST_0: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => wHold_reg_n_0,
      O => s_axi_wready
    );
s_axil_arready_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => \^s_axi_arready\,
      I2 => \^s_axi_rvalid\,
      O => s_axil_arready0
    );
s_axil_arready_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => s_axil_arready0,
      Q => \^s_axi_arready\
    );
s_axil_bvalid_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000EEE0FFFFEEE0"
    )
        port map (
      I0 => awHold_reg_n_0,
      I1 => s_axi_awvalid,
      I2 => s_axi_wvalid,
      I3 => wHold_reg_n_0,
      I4 => \^s_axil_bvalid_reg_0\,
      I5 => s_axi_bready,
      O => s_axil_bvalid_i_1_n_0
    );
s_axil_bvalid_i_2: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => aresetn,
      O => \^aresetn_0\
    );
s_axil_bvalid_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => s_axil_bvalid_i_1_n_0,
      Q => \^s_axil_bvalid_reg_0\
    );
\s_axil_rdata[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000AA8AAAAAAAAA"
    )
        port map (
      I0 => \s_axil_rdata[0]_i_2_n_0\,
      I1 => \s_axil_rdata[0]_i_3_n_0\,
      I2 => \s_axil_rdata[15]_i_2_n_0\,
      I3 => \s_axil_rdata[27]_i_4_n_0\,
      I4 => \s_axil_rdata[0]_i_4_n_0\,
      I5 => \s_axil_rdata[27]_i_6_n_0\,
      O => \s_axil_rdata[0]_i_1_n_0\
    );
\s_axil_rdata[0]_i_15\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][0]\,
      I1 => \txReg_reg_n_0_[2][0]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][0]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][0]\,
      O => \s_axil_rdata[0]_i_15_n_0\
    );
\s_axil_rdata[0]_i_16\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][0]\,
      I1 => \txReg_reg_n_0_[6][0]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][0]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][0]\,
      O => \s_axil_rdata[0]_i_16_n_0\
    );
\s_axil_rdata[0]_i_17\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][0]\,
      I1 => \txReg_reg_n_0_[10][0]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][0]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][0]\,
      O => \s_axil_rdata[0]_i_17_n_0\
    );
\s_axil_rdata[0]_i_18\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][0]\,
      I1 => \txReg_reg_n_0_[14][0]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][0]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][0]\,
      O => \s_axil_rdata[0]_i_18_n_0\
    );
\s_axil_rdata[0]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000FBEA"
    )
        port map (
      I0 => \s_axil_rdata[31]_i_3_n_0\,
      I1 => s_axi_araddr(6),
      I2 => \s_axil_rdata[0]_i_5_n_0\,
      I3 => \s_axil_rdata_reg[0]_i_6_n_0\,
      I4 => \s_axil_rdata_reg[0]_0\,
      O => \s_axil_rdata[0]_i_2_n_0\
    );
\s_axil_rdata[0]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FEAEAAAA"
    )
        port map (
      I0 => \s_axil_rdata[0]_i_8_n_0\,
      I1 => \s_axil_rdata[4]_i_7_0\(0),
      I2 => s_axi_araddr(2),
      I3 => ppOverflow,
      I4 => s_axi_araddr(3),
      I5 => \s_axil_rdata[0]_i_9_n_0\,
      O => \s_axil_rdata[0]_i_3_n_0\
    );
\s_axil_rdata[0]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000053555353"
    )
        port map (
      I0 => cpiCount_reg(0),
      I1 => \latency_reg_n_0_[0]\,
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \s_axil_rdata[31]_i_8_n_0\,
      O => \s_axil_rdata[0]_i_4_n_0\
    );
\s_axil_rdata[0]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][0]\,
      I1 => \txReg_reg_n_0_[18][0]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][0]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][0]\,
      O => \s_axil_rdata[0]_i_5_n_0\
    );
\s_axil_rdata[0]_i_8\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BABBBAAA"
    )
        port map (
      I0 => \s_axil_rdata[29]_i_8_n_0\,
      I1 => s_axi_araddr(3),
      I2 => \^ppmaxgap_o_reg[9]_0\(0),
      I3 => s_axi_araddr(2),
      I4 => \^q\(0),
      O => \s_axil_rdata[0]_i_8_n_0\
    );
\s_axil_rdata[0]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"530F53FF00000000"
    )
        port map (
      I0 => \^cfaralpha_o_reg[15]_0\(0),
      I1 => \^cfark_o_reg[4]_0\(0),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => \^irq\,
      I5 => \s_axil_rdata[29]_i_8_n_0\,
      O => \s_axil_rdata[0]_i_9_n_0\
    );
\s_axil_rdata[10]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5F5F4E4F4E4E4E4E"
    )
        port map (
      I0 => \s_axil_rdata[13]_i_2_n_0\,
      I1 => s_axi_araddr(1),
      I2 => \s_axil_rdata[10]_i_2_n_0\,
      I3 => \s_axil_rdata[26]_i_2_n_0\,
      I4 => \s_axil_rdata[10]_i_3_n_0\,
      I5 => \s_axil_rdata[10]_i_4_n_0\,
      O => \s_axil_rdata[10]_i_1_n_0\
    );
\s_axil_rdata[10]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][10]\,
      I1 => \txReg_reg_n_0_[2][10]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][10]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][10]\,
      O => \s_axil_rdata[10]_i_10_n_0\
    );
\s_axil_rdata[10]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][10]\,
      I1 => \txReg_reg_n_0_[6][10]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][10]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][10]\,
      O => \s_axil_rdata[10]_i_11_n_0\
    );
\s_axil_rdata[10]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][10]\,
      I1 => \txReg_reg_n_0_[10][10]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][10]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][10]\,
      O => \s_axil_rdata[10]_i_12_n_0\
    );
\s_axil_rdata[10]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][10]\,
      I1 => \txReg_reg_n_0_[14][10]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][10]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][10]\,
      O => \s_axil_rdata[10]_i_13_n_0\
    );
\s_axil_rdata[10]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5500570055AA57AA"
    )
        port map (
      I0 => s_axi_araddr(7),
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(6),
      I4 => \s_axil_rdata[10]_i_5_n_0\,
      I5 => \s_axil_rdata_reg[10]_i_6_n_0\,
      O => \s_axil_rdata[10]_i_2_n_0\
    );
\s_axil_rdata[10]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F111F1F1F1111111"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(5),
      I2 => \s_axil_rdata[26]_i_2_n_0\,
      I3 => \latency_reg_n_0_[10]\,
      I4 => \s_axil_rdata[31]_i_9_n_0\,
      I5 => cpiCount_reg(10),
      O => \s_axil_rdata[10]_i_3_n_0\
    );
\s_axil_rdata[10]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF88030000"
    )
        port map (
      I0 => \^cfaralpha_o_reg[15]_0\(10),
      I1 => s_axi_araddr(2),
      I2 => \s_axil_rdata[10]_i_2_n_0\,
      I3 => s_axi_araddr(3),
      I4 => \s_axil_rdata[29]_i_8_n_0\,
      I5 => \s_axil_rdata[10]_i_7_n_0\,
      O => \s_axil_rdata[10]_i_4_n_0\
    );
\s_axil_rdata[10]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][10]\,
      I1 => \txReg_reg_n_0_[18][10]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][10]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][10]\,
      O => \s_axil_rdata[10]_i_5_n_0\
    );
\s_axil_rdata[10]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFF0008"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => ppLogRatio(10),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(0),
      I5 => s_axi_araddr(5),
      O => \s_axil_rdata[10]_i_7_n_0\
    );
\s_axil_rdata[11]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"44EF45EF44EE44EE"
    )
        port map (
      I0 => \s_axil_rdata[13]_i_2_n_0\,
      I1 => s_axi_araddr(1),
      I2 => \s_axil_rdata[11]_i_2_n_0\,
      I3 => \s_axil_rdata[11]_i_3_n_0\,
      I4 => \s_axil_rdata[27]_i_3_n_0\,
      I5 => \s_axil_rdata[11]_i_4_n_0\,
      O => \s_axil_rdata[11]_i_1_n_0\
    );
\s_axil_rdata[11]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][11]\,
      I1 => \txReg_reg_n_0_[2][11]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][11]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][11]\,
      O => \s_axil_rdata[11]_i_10_n_0\
    );
\s_axil_rdata[11]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][11]\,
      I1 => \txReg_reg_n_0_[6][11]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][11]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][11]\,
      O => \s_axil_rdata[11]_i_11_n_0\
    );
\s_axil_rdata[11]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][11]\,
      I1 => \txReg_reg_n_0_[10][11]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][11]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][11]\,
      O => \s_axil_rdata[11]_i_12_n_0\
    );
\s_axil_rdata[11]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][11]\,
      I1 => \txReg_reg_n_0_[14][11]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][11]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][11]\,
      O => \s_axil_rdata[11]_i_13_n_0\
    );
\s_axil_rdata[11]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000053555353"
    )
        port map (
      I0 => cpiCount_reg(11),
      I1 => \latency_reg_n_0_[11]\,
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \s_axil_rdata[31]_i_8_n_0\,
      O => \s_axil_rdata[11]_i_2_n_0\
    );
\s_axil_rdata[11]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5500570055AA57AA"
    )
        port map (
      I0 => s_axi_araddr(7),
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(6),
      I4 => \s_axil_rdata[11]_i_5_n_0\,
      I5 => \s_axil_rdata_reg[11]_i_6_n_0\,
      O => \s_axil_rdata[11]_i_3_n_0\
    );
\s_axil_rdata[11]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF88030000"
    )
        port map (
      I0 => \^cfaralpha_o_reg[15]_0\(11),
      I1 => s_axi_araddr(2),
      I2 => \s_axil_rdata[11]_i_3_n_0\,
      I3 => s_axi_araddr(3),
      I4 => \s_axil_rdata[29]_i_8_n_0\,
      I5 => \s_axil_rdata[11]_i_7_n_0\,
      O => \s_axil_rdata[11]_i_4_n_0\
    );
\s_axil_rdata[11]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][11]\,
      I1 => \txReg_reg_n_0_[18][11]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][11]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][11]\,
      O => \s_axil_rdata[11]_i_5_n_0\
    );
\s_axil_rdata[11]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFF0008"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => ppLogRatio(11),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(0),
      I5 => s_axi_araddr(5),
      O => \s_axil_rdata[11]_i_7_n_0\
    );
\s_axil_rdata[12]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"44EF45EF44EE44EE"
    )
        port map (
      I0 => \s_axil_rdata[13]_i_2_n_0\,
      I1 => s_axi_araddr(1),
      I2 => \s_axil_rdata[12]_i_2_n_0\,
      I3 => \s_axil_rdata[12]_i_3_n_0\,
      I4 => \s_axil_rdata[27]_i_3_n_0\,
      I5 => \s_axil_rdata[12]_i_4_n_0\,
      O => \s_axil_rdata[12]_i_1_n_0\
    );
\s_axil_rdata[12]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][12]\,
      I1 => \txReg_reg_n_0_[2][12]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][12]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][12]\,
      O => \s_axil_rdata[12]_i_10_n_0\
    );
\s_axil_rdata[12]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][12]\,
      I1 => \txReg_reg_n_0_[6][12]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][12]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][12]\,
      O => \s_axil_rdata[12]_i_11_n_0\
    );
\s_axil_rdata[12]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][12]\,
      I1 => \txReg_reg_n_0_[10][12]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][12]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][12]\,
      O => \s_axil_rdata[12]_i_12_n_0\
    );
\s_axil_rdata[12]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][12]\,
      I1 => \txReg_reg_n_0_[14][12]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][12]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][12]\,
      O => \s_axil_rdata[12]_i_13_n_0\
    );
\s_axil_rdata[12]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000035333535"
    )
        port map (
      I0 => \latency_reg_n_0_[12]\,
      I1 => cpiCount_reg(12),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \s_axil_rdata[31]_i_8_n_0\,
      O => \s_axil_rdata[12]_i_2_n_0\
    );
\s_axil_rdata[12]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5500570055AA57AA"
    )
        port map (
      I0 => s_axi_araddr(7),
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(6),
      I4 => \s_axil_rdata[12]_i_5_n_0\,
      I5 => \s_axil_rdata_reg[12]_i_6_n_0\,
      O => \s_axil_rdata[12]_i_3_n_0\
    );
\s_axil_rdata[12]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF88030000"
    )
        port map (
      I0 => \^cfaralpha_o_reg[15]_0\(12),
      I1 => s_axi_araddr(2),
      I2 => \s_axil_rdata[12]_i_3_n_0\,
      I3 => s_axi_araddr(3),
      I4 => \s_axil_rdata[29]_i_8_n_0\,
      I5 => \s_axil_rdata[12]_i_7_n_0\,
      O => \s_axil_rdata[12]_i_4_n_0\
    );
\s_axil_rdata[12]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][12]\,
      I1 => \txReg_reg_n_0_[18][12]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][12]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][12]\,
      O => \s_axil_rdata[12]_i_5_n_0\
    );
\s_axil_rdata[12]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFF0008"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => ppLogRatio(12),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(0),
      I5 => s_axi_araddr(5),
      O => \s_axil_rdata[12]_i_7_n_0\
    );
\s_axil_rdata[13]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"44EF45EF44EE44EE"
    )
        port map (
      I0 => \s_axil_rdata[13]_i_2_n_0\,
      I1 => s_axi_araddr(1),
      I2 => \s_axil_rdata[13]_i_3_n_0\,
      I3 => \s_axil_rdata[13]_i_4_n_0\,
      I4 => \s_axil_rdata[27]_i_3_n_0\,
      I5 => \s_axil_rdata[13]_i_5_n_0\,
      O => \s_axil_rdata[13]_i_1_n_0\
    );
\s_axil_rdata[13]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][13]\,
      I1 => \txReg_reg_n_0_[2][13]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][13]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][13]\,
      O => \s_axil_rdata[13]_i_11_n_0\
    );
\s_axil_rdata[13]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][13]\,
      I1 => \txReg_reg_n_0_[6][13]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][13]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][13]\,
      O => \s_axil_rdata[13]_i_12_n_0\
    );
\s_axil_rdata[13]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][13]\,
      I1 => \txReg_reg_n_0_[10][13]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][13]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][13]\,
      O => \s_axil_rdata[13]_i_13_n_0\
    );
\s_axil_rdata[13]_i_14\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][13]\,
      I1 => \txReg_reg_n_0_[14][13]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][13]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][13]\,
      O => \s_axil_rdata[13]_i_14_n_0\
    );
\s_axil_rdata[13]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => s_axi_araddr(6),
      I1 => s_axi_araddr(7),
      O => \s_axil_rdata[13]_i_2_n_0\
    );
\s_axil_rdata[13]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000053555353"
    )
        port map (
      I0 => cpiCount_reg(13),
      I1 => \latency_reg_n_0_[13]\,
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \s_axil_rdata[31]_i_8_n_0\,
      O => \s_axil_rdata[13]_i_3_n_0\
    );
\s_axil_rdata[13]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5500570055AA57AA"
    )
        port map (
      I0 => s_axi_araddr(7),
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(6),
      I4 => \s_axil_rdata[13]_i_6_n_0\,
      I5 => \s_axil_rdata_reg[13]_i_7_n_0\,
      O => \s_axil_rdata[13]_i_4_n_0\
    );
\s_axil_rdata[13]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF88030000"
    )
        port map (
      I0 => \^cfaralpha_o_reg[15]_0\(13),
      I1 => s_axi_araddr(2),
      I2 => \s_axil_rdata[13]_i_4_n_0\,
      I3 => s_axi_araddr(3),
      I4 => \s_axil_rdata[29]_i_8_n_0\,
      I5 => \s_axil_rdata[13]_i_8_n_0\,
      O => \s_axil_rdata[13]_i_5_n_0\
    );
\s_axil_rdata[13]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][13]\,
      I1 => \txReg_reg_n_0_[18][13]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][13]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][13]\,
      O => \s_axil_rdata[13]_i_6_n_0\
    );
\s_axil_rdata[13]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFF0008"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => ppLogRatio(13),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(0),
      I5 => s_axi_araddr(5),
      O => \s_axil_rdata[13]_i_8_n_0\
    );
\s_axil_rdata[14]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4F444F444F444444"
    )
        port map (
      I0 => \s_axil_rdata[31]_i_3_n_0\,
      I1 => \s_axil_rdata_reg[14]_i_2_n_0\,
      I2 => \s_axil_rdata[14]_i_3_n_0\,
      I3 => \s_axil_rdata[27]_i_6_n_0\,
      I4 => \s_axil_rdata[15]_i_2_n_0\,
      I5 => \s_axil_rdata[14]_i_4_n_0\,
      O => \s_axil_rdata[14]_i_1_n_0\
    );
\s_axil_rdata[14]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][14]\,
      I1 => \txReg_reg_n_0_[6][14]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][14]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][14]\,
      O => \s_axil_rdata[14]_i_10_n_0\
    );
\s_axil_rdata[14]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4CCC4CCCCCC0CCCC"
    )
        port map (
      I0 => \^cfaralpha_o_reg[15]_0\(14),
      I1 => \s_axil_rdata[15]_i_2_n_0\,
      I2 => s_axi_araddr(3),
      I3 => s_axi_araddr(2),
      I4 => \^q\(2),
      I5 => \s_axil_rdata[29]_i_8_n_0\,
      O => \s_axil_rdata[14]_i_3_n_0\
    );
\s_axil_rdata[14]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0002000300020000"
    )
        port map (
      I0 => cpiCount_reg(14),
      I1 => s_axi_araddr(0),
      I2 => s_axi_araddr(3),
      I3 => s_axi_araddr(4),
      I4 => s_axi_araddr(2),
      I5 => \latency_reg_n_0_[14]\,
      O => \s_axil_rdata[14]_i_4_n_0\
    );
\s_axil_rdata[14]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAFFCCF0AA00CCF0"
    )
        port map (
      I0 => \s_axil_rdata[14]_i_7_n_0\,
      I1 => \s_axil_rdata[14]_i_8_n_0\,
      I2 => \s_axil_rdata[14]_i_9_n_0\,
      I3 => s_axi_araddr(5),
      I4 => s_axi_araddr(4),
      I5 => \s_axil_rdata[14]_i_10_n_0\,
      O => \s_axil_rdata[14]_i_5_n_0\
    );
\s_axil_rdata[14]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][14]\,
      I1 => \txReg_reg_n_0_[18][14]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][14]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][14]\,
      O => \s_axil_rdata[14]_i_6_n_0\
    );
\s_axil_rdata[14]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][14]\,
      I1 => \txReg_reg_n_0_[14][14]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][14]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][14]\,
      O => \s_axil_rdata[14]_i_7_n_0\
    );
\s_axil_rdata[14]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][14]\,
      I1 => \txReg_reg_n_0_[10][14]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][14]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][14]\,
      O => \s_axil_rdata[14]_i_8_n_0\
    );
\s_axil_rdata[14]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][14]\,
      I1 => \txReg_reg_n_0_[2][14]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][14]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][14]\,
      O => \s_axil_rdata[14]_i_9_n_0\
    );
\s_axil_rdata[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EEEF00FF000000FF"
    )
        port map (
      I0 => \s_axil_rdata[15]_i_2_n_0\,
      I1 => \s_axil_rdata[15]_i_3_n_0\,
      I2 => \s_axil_rdata[26]_i_2_n_0\,
      I3 => \s_axil_rdata[15]_i_4_n_0\,
      I4 => \s_axil_rdata[27]_i_6_n_0\,
      I5 => \s_axil_rdata[15]_i_5_n_0\,
      O => \s_axil_rdata[15]_i_1_n_0\
    );
\s_axil_rdata[15]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][15]\,
      I1 => \txReg_reg_n_0_[2][15]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][15]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][15]\,
      O => \s_axil_rdata[15]_i_11_n_0\
    );
\s_axil_rdata[15]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][15]\,
      I1 => \txReg_reg_n_0_[6][15]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][15]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][15]\,
      O => \s_axil_rdata[15]_i_12_n_0\
    );
\s_axil_rdata[15]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][15]\,
      I1 => \txReg_reg_n_0_[10][15]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][15]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][15]\,
      O => \s_axil_rdata[15]_i_13_n_0\
    );
\s_axil_rdata[15]_i_14\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][15]\,
      I1 => \txReg_reg_n_0_[14][15]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][15]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][15]\,
      O => \s_axil_rdata[15]_i_14_n_0\
    );
\s_axil_rdata[15]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(0),
      O => \s_axil_rdata[15]_i_2_n_0\
    );
\s_axil_rdata[15]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000000000B8"
    )
        port map (
      I0 => cpiCount_reg(15),
      I1 => s_axi_araddr(2),
      I2 => \latency_reg_n_0_[15]\,
      I3 => s_axi_araddr(4),
      I4 => s_axi_araddr(3),
      I5 => s_axi_araddr(0),
      O => \s_axil_rdata[15]_i_3_n_0\
    );
\s_axil_rdata[15]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5500570055AA57AA"
    )
        port map (
      I0 => s_axi_araddr(7),
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(6),
      I4 => \s_axil_rdata[15]_i_6_n_0\,
      I5 => \s_axil_rdata_reg[15]_i_7_n_0\,
      O => \s_axil_rdata[15]_i_4_n_0\
    );
\s_axil_rdata[15]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"D5555555D7555755"
    )
        port map (
      I0 => \s_axil_rdata[15]_i_8_n_0\,
      I1 => s_axi_araddr(2),
      I2 => s_axi_araddr(3),
      I3 => \s_axil_rdata[29]_i_8_n_0\,
      I4 => \^cfaralpha_o_reg[15]_0\(15),
      I5 => \s_axil_rdata[15]_i_4_n_0\,
      O => \s_axil_rdata[15]_i_5_n_0\
    );
\s_axil_rdata[15]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][15]\,
      I1 => \txReg_reg_n_0_[18][15]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][15]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][15]\,
      O => \s_axil_rdata[15]_i_6_n_0\
    );
\s_axil_rdata[15]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0303030303030103"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(0),
      I3 => \^q\(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => \s_axil_rdata[15]_i_8_n_0\
    );
\s_axil_rdata[16]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFCA0F0A"
    )
        port map (
      I0 => \s_axil_rdata_reg[16]_i_2_n_0\,
      I1 => \s_axil_rdata[16]_i_3_n_0\,
      I2 => s_axi_araddr(6),
      I3 => \s_axil_rdata[31]_i_3_n_0\,
      I4 => s_axi_araddr(7),
      I5 => \s_axil_rdata[16]_i_4_n_0\,
      O => \s_axil_rdata[16]_i_1_n_0\
    );
\s_axil_rdata[16]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][16]\,
      I1 => \txReg_reg_n_0_[14][16]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][16]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][16]\,
      O => \s_axil_rdata[16]_i_10_n_0\
    );
\s_axil_rdata[16]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][16]\,
      I1 => \txReg_reg_n_0_[18][16]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][16]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][16]\,
      O => \s_axil_rdata[16]_i_3_n_0\
    );
\s_axil_rdata[16]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000A22AAAAAAAA"
    )
        port map (
      I0 => \s_axil_rdata[27]_i_6_n_0\,
      I1 => cpiCount_reg(16),
      I2 => \latency_reg_n_0_[16]\,
      I3 => \s_axil_rdata[31]_i_9_n_0\,
      I4 => \s_axil_rdata[31]_i_8_n_0\,
      I5 => \s_axil_rdata[31]_i_10_n_0\,
      O => \s_axil_rdata[16]_i_4_n_0\
    );
\s_axil_rdata[16]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][16]\,
      I1 => \txReg_reg_n_0_[2][16]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][16]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][16]\,
      O => \s_axil_rdata[16]_i_7_n_0\
    );
\s_axil_rdata[16]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][16]\,
      I1 => \txReg_reg_n_0_[6][16]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][16]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][16]\,
      O => \s_axil_rdata[16]_i_8_n_0\
    );
\s_axil_rdata[16]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][16]\,
      I1 => \txReg_reg_n_0_[10][16]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][16]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][16]\,
      O => \s_axil_rdata[16]_i_9_n_0\
    );
\s_axil_rdata[17]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00E2FFFF00E200E2"
    )
        port map (
      I0 => \s_axil_rdata_reg[17]_i_2_n_0\,
      I1 => s_axi_araddr(6),
      I2 => \s_axil_rdata[17]_i_3_n_0\,
      I3 => \s_axil_rdata[31]_i_3_n_0\,
      I4 => \s_axil_rdata[17]_i_4_n_0\,
      I5 => \s_axil_rdata[29]_i_5_n_0\,
      O => \s_axil_rdata[17]_i_1_n_0\
    );
\s_axil_rdata[17]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][17]\,
      I1 => \txReg_reg_n_0_[14][17]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][17]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][17]\,
      O => \s_axil_rdata[17]_i_10_n_0\
    );
\s_axil_rdata[17]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][17]\,
      I1 => \txReg_reg_n_0_[18][17]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][17]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][17]\,
      O => \s_axil_rdata[17]_i_3_n_0\
    );
\s_axil_rdata[17]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0E00EEEE0EEEEEEE"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(5),
      I2 => \latency_reg_n_0_[17]\,
      I3 => \s_axil_rdata[31]_i_9_n_0\,
      I4 => \s_axil_rdata[26]_i_2_n_0\,
      I5 => cpiCount_reg(17),
      O => \s_axil_rdata[17]_i_4_n_0\
    );
\s_axil_rdata[17]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][17]\,
      I1 => \txReg_reg_n_0_[2][17]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][17]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][17]\,
      O => \s_axil_rdata[17]_i_7_n_0\
    );
\s_axil_rdata[17]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][17]\,
      I1 => \txReg_reg_n_0_[6][17]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][17]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][17]\,
      O => \s_axil_rdata[17]_i_8_n_0\
    );
\s_axil_rdata[17]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][17]\,
      I1 => \txReg_reg_n_0_[10][17]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][17]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][17]\,
      O => \s_axil_rdata[17]_i_9_n_0\
    );
\s_axil_rdata[18]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFCA0F0A"
    )
        port map (
      I0 => \s_axil_rdata_reg[18]_i_2_n_0\,
      I1 => \s_axil_rdata[18]_i_3_n_0\,
      I2 => s_axi_araddr(6),
      I3 => \s_axil_rdata[31]_i_3_n_0\,
      I4 => s_axi_araddr(7),
      I5 => \s_axil_rdata[18]_i_4_n_0\,
      O => \s_axil_rdata[18]_i_1_n_0\
    );
\s_axil_rdata[18]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][18]\,
      I1 => \txReg_reg_n_0_[14][18]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][18]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][18]\,
      O => \s_axil_rdata[18]_i_10_n_0\
    );
\s_axil_rdata[18]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][18]\,
      I1 => \txReg_reg_n_0_[18][18]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][18]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][18]\,
      O => \s_axil_rdata[18]_i_3_n_0\
    );
\s_axil_rdata[18]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000A22AAAAAAAA"
    )
        port map (
      I0 => \s_axil_rdata[27]_i_6_n_0\,
      I1 => cpiCount_reg(18),
      I2 => \latency_reg_n_0_[18]\,
      I3 => \s_axil_rdata[31]_i_9_n_0\,
      I4 => \s_axil_rdata[31]_i_8_n_0\,
      I5 => \s_axil_rdata[31]_i_10_n_0\,
      O => \s_axil_rdata[18]_i_4_n_0\
    );
\s_axil_rdata[18]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][18]\,
      I1 => \txReg_reg_n_0_[2][18]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][18]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][18]\,
      O => \s_axil_rdata[18]_i_7_n_0\
    );
\s_axil_rdata[18]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][18]\,
      I1 => \txReg_reg_n_0_[6][18]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][18]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][18]\,
      O => \s_axil_rdata[18]_i_8_n_0\
    );
\s_axil_rdata[18]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][18]\,
      I1 => \txReg_reg_n_0_[10][18]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][18]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][18]\,
      O => \s_axil_rdata[18]_i_9_n_0\
    );
\s_axil_rdata[19]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFCA0F0A"
    )
        port map (
      I0 => \s_axil_rdata_reg[19]_i_2_n_0\,
      I1 => \s_axil_rdata[19]_i_3_n_0\,
      I2 => s_axi_araddr(6),
      I3 => \s_axil_rdata[31]_i_3_n_0\,
      I4 => s_axi_araddr(7),
      I5 => \s_axil_rdata[19]_i_4_n_0\,
      O => \s_axil_rdata[19]_i_1_n_0\
    );
\s_axil_rdata[19]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][19]\,
      I1 => \txReg_reg_n_0_[14][19]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][19]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][19]\,
      O => \s_axil_rdata[19]_i_10_n_0\
    );
\s_axil_rdata[19]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][19]\,
      I1 => \txReg_reg_n_0_[18][19]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][19]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][19]\,
      O => \s_axil_rdata[19]_i_3_n_0\
    );
\s_axil_rdata[19]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000A22AAAAAAAA"
    )
        port map (
      I0 => \s_axil_rdata[27]_i_6_n_0\,
      I1 => cpiCount_reg(19),
      I2 => \latency_reg_n_0_[19]\,
      I3 => \s_axil_rdata[31]_i_9_n_0\,
      I4 => \s_axil_rdata[31]_i_8_n_0\,
      I5 => \s_axil_rdata[31]_i_10_n_0\,
      O => \s_axil_rdata[19]_i_4_n_0\
    );
\s_axil_rdata[19]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][19]\,
      I1 => \txReg_reg_n_0_[2][19]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][19]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][19]\,
      O => \s_axil_rdata[19]_i_7_n_0\
    );
\s_axil_rdata[19]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][19]\,
      I1 => \txReg_reg_n_0_[6][19]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][19]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][19]\,
      O => \s_axil_rdata[19]_i_8_n_0\
    );
\s_axil_rdata[19]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][19]\,
      I1 => \txReg_reg_n_0_[10][19]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][19]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][19]\,
      O => \s_axil_rdata[19]_i_9_n_0\
    );
\s_axil_rdata[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"505400FF"
    )
        port map (
      I0 => \s_axil_rdata[1]_i_2_n_0\,
      I1 => \s_axil_rdata[27]_i_4_n_0\,
      I2 => \s_axil_rdata[1]_i_3_n_0\,
      I3 => \s_axil_rdata[1]_i_4_n_0\,
      I4 => \s_axil_rdata[27]_i_6_n_0\,
      O => \s_axil_rdata[1]_i_1_n_0\
    );
\s_axil_rdata[1]_i_14\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][1]\,
      I1 => \txReg_reg_n_0_[2][1]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][1]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][1]\,
      O => \s_axil_rdata[1]_i_14_n_0\
    );
\s_axil_rdata[1]_i_15\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][1]\,
      I1 => \txReg_reg_n_0_[6][1]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][1]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][1]\,
      O => \s_axil_rdata[1]_i_15_n_0\
    );
\s_axil_rdata[1]_i_16\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][1]\,
      I1 => \txReg_reg_n_0_[10][1]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][1]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][1]\,
      O => \s_axil_rdata[1]_i_16_n_0\
    );
\s_axil_rdata[1]_i_17\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][1]\,
      I1 => \txReg_reg_n_0_[14][1]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][1]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][1]\,
      O => \s_axil_rdata[1]_i_17_n_0\
    );
\s_axil_rdata[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000035333535"
    )
        port map (
      I0 => \latency_reg_n_0_[1]\,
      I1 => cpiCount_reg(1),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \s_axil_rdata[31]_i_8_n_0\,
      O => \s_axil_rdata[1]_i_2_n_0\
    );
\s_axil_rdata[1]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFCFDFD"
    )
        port map (
      I0 => \s_axil_rdata[1]_i_5_n_0\,
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(0),
      I3 => \s_axil_rdata[1]_i_6_n_0\,
      I4 => s_axi_araddr(4),
      O => \s_axil_rdata[1]_i_3_n_0\
    );
\s_axil_rdata[1]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"1111050511FF0505"
    )
        port map (
      I0 => \s_axil_rdata[31]_i_3_n_0\,
      I1 => \s_axil_rdata[1]_i_7_n_0\,
      I2 => \s_axil_rdata_reg[1]_i_8_n_0\,
      I3 => \s_axil_rdata_reg[1]_0\,
      I4 => s_axi_araddr(6),
      I5 => s_axi_araddr(7),
      O => \s_axil_rdata[1]_i_4_n_0\
    );
\s_axil_rdata[1]_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"503F5F3F"
    )
        port map (
      I0 => \^cfaralpha_o_reg[15]_0\(1),
      I1 => \^cfark_o_reg[4]_0\(1),
      I2 => s_axi_araddr(3),
      I3 => s_axi_araddr(2),
      I4 => ct1Busy,
      O => \s_axil_rdata[1]_i_5_n_0\
    );
\s_axil_rdata[1]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \s_axil_rdata[4]_i_7_0\(1),
      I1 => s_axi_araddr(3),
      I2 => \^ppmaxgap_o_reg[9]_0\(1),
      I3 => s_axi_araddr(2),
      I4 => \^q\(1),
      O => \s_axil_rdata[1]_i_6_n_0\
    );
\s_axil_rdata[1]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][1]\,
      I1 => \txReg_reg_n_0_[18][1]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][1]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][1]\,
      O => \s_axil_rdata[1]_i_7_n_0\
    );
\s_axil_rdata[20]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4540FFFF45404540"
    )
        port map (
      I0 => \s_axil_rdata[31]_i_3_n_0\,
      I1 => \s_axil_rdata[20]_i_2_n_0\,
      I2 => s_axi_araddr(6),
      I3 => \s_axil_rdata[20]_i_3_n_0\,
      I4 => \s_axil_rdata[20]_i_4_n_0\,
      I5 => \s_axil_rdata[29]_i_5_n_0\,
      O => \s_axil_rdata[20]_i_1_n_0\
    );
\s_axil_rdata[20]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][20]\,
      I1 => \txReg_reg_n_0_[18][20]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][20]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][20]\,
      O => \s_axil_rdata[20]_i_2_n_0\
    );
\s_axil_rdata[20]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AACCF0FFAACCF000"
    )
        port map (
      I0 => \s_axil_rdata[20]_i_5_n_0\,
      I1 => \s_axil_rdata[20]_i_6_n_0\,
      I2 => \s_axil_rdata[20]_i_7_n_0\,
      I3 => s_axi_araddr(4),
      I4 => s_axi_araddr(5),
      I5 => \s_axil_rdata[20]_i_8_n_0\,
      O => \s_axil_rdata[20]_i_3_n_0\
    );
\s_axil_rdata[20]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0E00EEEE0EEEEEEE"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(5),
      I2 => \latency_reg_n_0_[20]\,
      I3 => \s_axil_rdata[31]_i_9_n_0\,
      I4 => \s_axil_rdata[26]_i_2_n_0\,
      I5 => cpiCount_reg(20),
      O => \s_axil_rdata[20]_i_4_n_0\
    );
\s_axil_rdata[20]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][20]\,
      I1 => \txReg_reg_n_0_[14][20]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][20]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][20]\,
      O => \s_axil_rdata[20]_i_5_n_0\
    );
\s_axil_rdata[20]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][20]\,
      I1 => \txReg_reg_n_0_[10][20]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][20]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][20]\,
      O => \s_axil_rdata[20]_i_6_n_0\
    );
\s_axil_rdata[20]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][20]\,
      I1 => \txReg_reg_n_0_[6][20]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][20]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][20]\,
      O => \s_axil_rdata[20]_i_7_n_0\
    );
\s_axil_rdata[20]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][20]\,
      I1 => \txReg_reg_n_0_[2][20]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][20]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][20]\,
      O => \s_axil_rdata[20]_i_8_n_0\
    );
\s_axil_rdata[21]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFCA0F0A"
    )
        port map (
      I0 => \s_axil_rdata_reg[21]_i_2_n_0\,
      I1 => \s_axil_rdata[21]_i_3_n_0\,
      I2 => s_axi_araddr(6),
      I3 => \s_axil_rdata[31]_i_3_n_0\,
      I4 => s_axi_araddr(7),
      I5 => \s_axil_rdata[21]_i_4_n_0\,
      O => \s_axil_rdata[21]_i_1_n_0\
    );
\s_axil_rdata[21]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][21]\,
      I1 => \txReg_reg_n_0_[14][21]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][21]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][21]\,
      O => \s_axil_rdata[21]_i_10_n_0\
    );
\s_axil_rdata[21]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][21]\,
      I1 => \txReg_reg_n_0_[18][21]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][21]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][21]\,
      O => \s_axil_rdata[21]_i_3_n_0\
    );
\s_axil_rdata[21]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000A22AAAAAAAA"
    )
        port map (
      I0 => \s_axil_rdata[27]_i_6_n_0\,
      I1 => cpiCount_reg(21),
      I2 => \latency_reg_n_0_[21]\,
      I3 => \s_axil_rdata[31]_i_9_n_0\,
      I4 => \s_axil_rdata[31]_i_8_n_0\,
      I5 => \s_axil_rdata[31]_i_10_n_0\,
      O => \s_axil_rdata[21]_i_4_n_0\
    );
\s_axil_rdata[21]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][21]\,
      I1 => \txReg_reg_n_0_[2][21]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][21]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][21]\,
      O => \s_axil_rdata[21]_i_7_n_0\
    );
\s_axil_rdata[21]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][21]\,
      I1 => \txReg_reg_n_0_[6][21]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][21]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][21]\,
      O => \s_axil_rdata[21]_i_8_n_0\
    );
\s_axil_rdata[21]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][21]\,
      I1 => \txReg_reg_n_0_[10][21]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][21]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][21]\,
      O => \s_axil_rdata[21]_i_9_n_0\
    );
\s_axil_rdata[22]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4540FFFF45404540"
    )
        port map (
      I0 => \s_axil_rdata[31]_i_3_n_0\,
      I1 => \s_axil_rdata[22]_i_2_n_0\,
      I2 => s_axi_araddr(6),
      I3 => \s_axil_rdata[22]_i_3_n_0\,
      I4 => \s_axil_rdata[22]_i_4_n_0\,
      I5 => \s_axil_rdata[29]_i_5_n_0\,
      O => \s_axil_rdata[22]_i_1_n_0\
    );
\s_axil_rdata[22]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][22]\,
      I1 => \txReg_reg_n_0_[18][22]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][22]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][22]\,
      O => \s_axil_rdata[22]_i_2_n_0\
    );
\s_axil_rdata[22]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAFFCCF0AA00CCF0"
    )
        port map (
      I0 => \s_axil_rdata[22]_i_5_n_0\,
      I1 => \s_axil_rdata[22]_i_6_n_0\,
      I2 => \s_axil_rdata[22]_i_7_n_0\,
      I3 => s_axi_araddr(5),
      I4 => s_axi_araddr(4),
      I5 => \s_axil_rdata[22]_i_8_n_0\,
      O => \s_axil_rdata[22]_i_3_n_0\
    );
\s_axil_rdata[22]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0E00EEEE0EEEEEEE"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(5),
      I2 => \latency_reg_n_0_[22]\,
      I3 => \s_axil_rdata[31]_i_9_n_0\,
      I4 => \s_axil_rdata[26]_i_2_n_0\,
      I5 => cpiCount_reg(22),
      O => \s_axil_rdata[22]_i_4_n_0\
    );
\s_axil_rdata[22]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][22]\,
      I1 => \txReg_reg_n_0_[14][22]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][22]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][22]\,
      O => \s_axil_rdata[22]_i_5_n_0\
    );
\s_axil_rdata[22]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][22]\,
      I1 => \txReg_reg_n_0_[10][22]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][22]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][22]\,
      O => \s_axil_rdata[22]_i_6_n_0\
    );
\s_axil_rdata[22]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][22]\,
      I1 => \txReg_reg_n_0_[2][22]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][22]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][22]\,
      O => \s_axil_rdata[22]_i_7_n_0\
    );
\s_axil_rdata[22]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][22]\,
      I1 => \txReg_reg_n_0_[6][22]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][22]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][22]\,
      O => \s_axil_rdata[22]_i_8_n_0\
    );
\s_axil_rdata[23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFCA0F0A"
    )
        port map (
      I0 => \s_axil_rdata_reg[23]_i_2_n_0\,
      I1 => \s_axil_rdata[23]_i_3_n_0\,
      I2 => s_axi_araddr(6),
      I3 => \s_axil_rdata[31]_i_3_n_0\,
      I4 => s_axi_araddr(7),
      I5 => \s_axil_rdata[23]_i_4_n_0\,
      O => \s_axil_rdata[23]_i_1_n_0\
    );
\s_axil_rdata[23]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][23]\,
      I1 => \txReg_reg_n_0_[14][23]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][23]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][23]\,
      O => \s_axil_rdata[23]_i_10_n_0\
    );
\s_axil_rdata[23]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][23]\,
      I1 => \txReg_reg_n_0_[18][23]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][23]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][23]\,
      O => \s_axil_rdata[23]_i_3_n_0\
    );
\s_axil_rdata[23]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000A22AAAAAAAA"
    )
        port map (
      I0 => \s_axil_rdata[27]_i_6_n_0\,
      I1 => cpiCount_reg(23),
      I2 => \latency_reg_n_0_[23]\,
      I3 => \s_axil_rdata[31]_i_9_n_0\,
      I4 => \s_axil_rdata[31]_i_8_n_0\,
      I5 => \s_axil_rdata[31]_i_10_n_0\,
      O => \s_axil_rdata[23]_i_4_n_0\
    );
\s_axil_rdata[23]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][23]\,
      I1 => \txReg_reg_n_0_[2][23]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][23]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][23]\,
      O => \s_axil_rdata[23]_i_7_n_0\
    );
\s_axil_rdata[23]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][23]\,
      I1 => \txReg_reg_n_0_[6][23]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][23]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][23]\,
      O => \s_axil_rdata[23]_i_8_n_0\
    );
\s_axil_rdata[23]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][23]\,
      I1 => \txReg_reg_n_0_[10][23]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][23]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][23]\,
      O => \s_axil_rdata[23]_i_9_n_0\
    );
\s_axil_rdata[24]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00E2FFFF00E200E2"
    )
        port map (
      I0 => \s_axil_rdata_reg[24]_i_2_n_0\,
      I1 => s_axi_araddr(6),
      I2 => \s_axil_rdata[24]_i_3_n_0\,
      I3 => \s_axil_rdata[31]_i_3_n_0\,
      I4 => \s_axil_rdata[24]_i_4_n_0\,
      I5 => \s_axil_rdata[29]_i_5_n_0\,
      O => \s_axil_rdata[24]_i_1_n_0\
    );
\s_axil_rdata[24]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][24]\,
      I1 => \txReg_reg_n_0_[14][24]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][24]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][24]\,
      O => \s_axil_rdata[24]_i_10_n_0\
    );
\s_axil_rdata[24]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][24]\,
      I1 => \txReg_reg_n_0_[18][24]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][24]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][24]\,
      O => \s_axil_rdata[24]_i_3_n_0\
    );
\s_axil_rdata[24]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000EEEEEE0EEEEEE"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(5),
      I2 => \s_axil_rdata[31]_i_9_n_0\,
      I3 => cpiCount_reg(24),
      I4 => \s_axil_rdata[26]_i_2_n_0\,
      I5 => \latency_reg_n_0_[24]\,
      O => \s_axil_rdata[24]_i_4_n_0\
    );
\s_axil_rdata[24]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][24]\,
      I1 => \txReg_reg_n_0_[2][24]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][24]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][24]\,
      O => \s_axil_rdata[24]_i_7_n_0\
    );
\s_axil_rdata[24]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][24]\,
      I1 => \txReg_reg_n_0_[6][24]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][24]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][24]\,
      O => \s_axil_rdata[24]_i_8_n_0\
    );
\s_axil_rdata[24]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][24]\,
      I1 => \txReg_reg_n_0_[10][24]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][24]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][24]\,
      O => \s_axil_rdata[24]_i_9_n_0\
    );
\s_axil_rdata[25]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFCA0F0A"
    )
        port map (
      I0 => \s_axil_rdata_reg[25]_i_2_n_0\,
      I1 => \s_axil_rdata[25]_i_3_n_0\,
      I2 => s_axi_araddr(6),
      I3 => \s_axil_rdata[31]_i_3_n_0\,
      I4 => s_axi_araddr(7),
      I5 => \s_axil_rdata[25]_i_4_n_0\,
      O => \s_axil_rdata[25]_i_1_n_0\
    );
\s_axil_rdata[25]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][25]\,
      I1 => \txReg_reg_n_0_[14][25]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][25]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][25]\,
      O => \s_axil_rdata[25]_i_10_n_0\
    );
\s_axil_rdata[25]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][25]\,
      I1 => \txReg_reg_n_0_[18][25]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][25]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][25]\,
      O => \s_axil_rdata[25]_i_3_n_0\
    );
\s_axil_rdata[25]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000A22AAAAAAAA"
    )
        port map (
      I0 => \s_axil_rdata[27]_i_6_n_0\,
      I1 => cpiCount_reg(25),
      I2 => \latency_reg_n_0_[25]\,
      I3 => \s_axil_rdata[31]_i_9_n_0\,
      I4 => \s_axil_rdata[31]_i_8_n_0\,
      I5 => \s_axil_rdata[31]_i_10_n_0\,
      O => \s_axil_rdata[25]_i_4_n_0\
    );
\s_axil_rdata[25]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][25]\,
      I1 => \txReg_reg_n_0_[2][25]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][25]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][25]\,
      O => \s_axil_rdata[25]_i_7_n_0\
    );
\s_axil_rdata[25]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][25]\,
      I1 => \txReg_reg_n_0_[6][25]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][25]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][25]\,
      O => \s_axil_rdata[25]_i_8_n_0\
    );
\s_axil_rdata[25]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][25]\,
      I1 => \txReg_reg_n_0_[10][25]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][25]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][25]\,
      O => \s_axil_rdata[25]_i_9_n_0\
    );
\s_axil_rdata[26]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCC0DDD0C0C0FFFF"
    )
        port map (
      I0 => \s_axil_rdata[26]_i_2_n_0\,
      I1 => \s_axil_rdata[26]_i_3_n_0\,
      I2 => \s_axil_rdata[29]_i_5_n_0\,
      I3 => \s_axil_rdata[27]_i_4_n_0\,
      I4 => \s_axil_rdata[26]_i_4_n_0\,
      I5 => \s_axil_rdata[27]_i_6_n_0\,
      O => \s_axil_rdata[26]_i_1_n_0\
    );
\s_axil_rdata[26]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][26]\,
      I1 => \txReg_reg_n_0_[6][26]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][26]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][26]\,
      O => \s_axil_rdata[26]_i_10_n_0\
    );
\s_axil_rdata[26]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][26]\,
      I1 => \txReg_reg_n_0_[10][26]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][26]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][26]\,
      O => \s_axil_rdata[26]_i_11_n_0\
    );
\s_axil_rdata[26]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][26]\,
      I1 => \txReg_reg_n_0_[14][26]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][26]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][26]\,
      O => \s_axil_rdata[26]_i_12_n_0\
    );
\s_axil_rdata[26]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"01"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(3),
      I2 => s_axi_araddr(4),
      O => \s_axil_rdata[26]_i_2_n_0\
    );
\s_axil_rdata[26]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F111F1F1F1111111"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(5),
      I2 => \s_axil_rdata[26]_i_2_n_0\,
      I3 => \latency_reg_n_0_[26]\,
      I4 => \s_axil_rdata[31]_i_9_n_0\,
      I5 => cpiCount_reg(26),
      O => \s_axil_rdata[26]_i_3_n_0\
    );
\s_axil_rdata[26]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5500570055AA57AA"
    )
        port map (
      I0 => s_axi_araddr(7),
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(6),
      I4 => \s_axil_rdata[26]_i_5_n_0\,
      I5 => \s_axil_rdata_reg[26]_i_6_n_0\,
      O => \s_axil_rdata[26]_i_4_n_0\
    );
\s_axil_rdata[26]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][26]\,
      I1 => \txReg_reg_n_0_[18][26]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][26]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][26]\,
      O => \s_axil_rdata[26]_i_5_n_0\
    );
\s_axil_rdata[26]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][26]\,
      I1 => \txReg_reg_n_0_[2][26]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][26]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][26]\,
      O => \s_axil_rdata[26]_i_9_n_0\
    );
\s_axil_rdata[27]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"111055501010FFFF"
    )
        port map (
      I0 => \s_axil_rdata[27]_i_2_n_0\,
      I1 => \s_axil_rdata[27]_i_3_n_0\,
      I2 => \s_axil_rdata[29]_i_5_n_0\,
      I3 => \s_axil_rdata[27]_i_4_n_0\,
      I4 => \s_axil_rdata[27]_i_5_n_0\,
      I5 => \s_axil_rdata[27]_i_6_n_0\,
      O => \s_axil_rdata[27]_i_1_n_0\
    );
\s_axil_rdata[27]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][27]\,
      I1 => \txReg_reg_n_0_[2][27]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][27]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][27]\,
      O => \s_axil_rdata[27]_i_11_n_0\
    );
\s_axil_rdata[27]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][27]\,
      I1 => \txReg_reg_n_0_[6][27]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][27]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][27]\,
      O => \s_axil_rdata[27]_i_12_n_0\
    );
\s_axil_rdata[27]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][27]\,
      I1 => \txReg_reg_n_0_[10][27]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][27]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][27]\,
      O => \s_axil_rdata[27]_i_13_n_0\
    );
\s_axil_rdata[27]_i_14\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][27]\,
      I1 => \txReg_reg_n_0_[14][27]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][27]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][27]\,
      O => \s_axil_rdata[27]_i_14_n_0\
    );
\s_axil_rdata[27]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000053555353"
    )
        port map (
      I0 => cpiCount_reg(27),
      I1 => \latency_reg_n_0_[27]\,
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \s_axil_rdata[31]_i_8_n_0\,
      O => \s_axil_rdata[27]_i_2_n_0\
    );
\s_axil_rdata[27]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFA8"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(4),
      I2 => s_axi_araddr(3),
      I3 => s_axi_araddr(0),
      O => \s_axil_rdata[27]_i_3_n_0\
    );
\s_axil_rdata[27]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000045"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(2),
      I4 => s_axi_araddr(3),
      O => \s_axil_rdata[27]_i_4_n_0\
    );
\s_axil_rdata[27]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5500570055AA57AA"
    )
        port map (
      I0 => s_axi_araddr(7),
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(6),
      I4 => \s_axil_rdata[27]_i_7_n_0\,
      I5 => \s_axil_rdata_reg[27]_i_8_n_0\,
      O => \s_axil_rdata[27]_i_5_n_0\
    );
\s_axil_rdata[27]_i_6\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"01"
    )
        port map (
      I0 => s_axi_araddr(1),
      I1 => s_axi_araddr(7),
      I2 => s_axi_araddr(6),
      O => \s_axil_rdata[27]_i_6_n_0\
    );
\s_axil_rdata[27]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][27]\,
      I1 => \txReg_reg_n_0_[18][27]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][27]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][27]\,
      O => \s_axil_rdata[27]_i_7_n_0\
    );
\s_axil_rdata[28]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFCA0F0A"
    )
        port map (
      I0 => \s_axil_rdata_reg[28]_i_2_n_0\,
      I1 => \s_axil_rdata[28]_i_3_n_0\,
      I2 => s_axi_araddr(6),
      I3 => \s_axil_rdata[31]_i_3_n_0\,
      I4 => s_axi_araddr(7),
      I5 => \s_axil_rdata[28]_i_4_n_0\,
      O => \s_axil_rdata[28]_i_1_n_0\
    );
\s_axil_rdata[28]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][28]\,
      I1 => \txReg_reg_n_0_[14][28]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][28]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][28]\,
      O => \s_axil_rdata[28]_i_10_n_0\
    );
\s_axil_rdata[28]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][28]\,
      I1 => \txReg_reg_n_0_[18][28]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][28]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][28]\,
      O => \s_axil_rdata[28]_i_3_n_0\
    );
\s_axil_rdata[28]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000A22AAAAAAAA"
    )
        port map (
      I0 => \s_axil_rdata[27]_i_6_n_0\,
      I1 => cpiCount_reg(28),
      I2 => \latency_reg_n_0_[28]\,
      I3 => \s_axil_rdata[31]_i_9_n_0\,
      I4 => \s_axil_rdata[31]_i_8_n_0\,
      I5 => \s_axil_rdata[31]_i_10_n_0\,
      O => \s_axil_rdata[28]_i_4_n_0\
    );
\s_axil_rdata[28]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][28]\,
      I1 => \txReg_reg_n_0_[2][28]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][28]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][28]\,
      O => \s_axil_rdata[28]_i_7_n_0\
    );
\s_axil_rdata[28]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][28]\,
      I1 => \txReg_reg_n_0_[6][28]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][28]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][28]\,
      O => \s_axil_rdata[28]_i_8_n_0\
    );
\s_axil_rdata[28]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][28]\,
      I1 => \txReg_reg_n_0_[10][28]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][28]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][28]\,
      O => \s_axil_rdata[28]_i_9_n_0\
    );
\s_axil_rdata[29]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00E2FFFF00E200E2"
    )
        port map (
      I0 => \s_axil_rdata_reg[29]_i_2_n_0\,
      I1 => s_axi_araddr(6),
      I2 => \s_axil_rdata[29]_i_3_n_0\,
      I3 => \s_axil_rdata[31]_i_3_n_0\,
      I4 => \s_axil_rdata[29]_i_4_n_0\,
      I5 => \s_axil_rdata[29]_i_5_n_0\,
      O => \s_axil_rdata[29]_i_1_n_0\
    );
\s_axil_rdata[29]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][29]\,
      I1 => \txReg_reg_n_0_[6][29]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][29]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][29]\,
      O => \s_axil_rdata[29]_i_10_n_0\
    );
\s_axil_rdata[29]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][29]\,
      I1 => \txReg_reg_n_0_[10][29]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][29]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][29]\,
      O => \s_axil_rdata[29]_i_11_n_0\
    );
\s_axil_rdata[29]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][29]\,
      I1 => \txReg_reg_n_0_[14][29]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][29]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][29]\,
      O => \s_axil_rdata[29]_i_12_n_0\
    );
\s_axil_rdata[29]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][29]\,
      I1 => \txReg_reg_n_0_[18][29]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][29]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][29]\,
      O => \s_axil_rdata[29]_i_3_n_0\
    );
\s_axil_rdata[29]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000EEEEEE0EEEEEE"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(5),
      I2 => \s_axil_rdata[31]_i_9_n_0\,
      I3 => cpiCount_reg(29),
      I4 => \s_axil_rdata[26]_i_2_n_0\,
      I5 => \latency_reg_n_0_[29]\,
      O => \s_axil_rdata[29]_i_4_n_0\
    );
\s_axil_rdata[29]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000200AAAAAAAA"
    )
        port map (
      I0 => \s_axil_rdata[27]_i_6_n_0\,
      I1 => s_axi_araddr(3),
      I2 => s_axi_araddr(2),
      I3 => \^q\(3),
      I4 => \s_axil_rdata[29]_i_8_n_0\,
      I5 => \s_axil_rdata[15]_i_2_n_0\,
      O => \s_axil_rdata[29]_i_5_n_0\
    );
\s_axil_rdata[29]_i_8\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"0D"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(0),
      O => \s_axil_rdata[29]_i_8_n_0\
    );
\s_axil_rdata[29]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][29]\,
      I1 => \txReg_reg_n_0_[2][29]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][29]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][29]\,
      O => \s_axil_rdata[29]_i_9_n_0\
    );
\s_axil_rdata[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"505400FF"
    )
        port map (
      I0 => \s_axil_rdata[2]_i_2_n_0\,
      I1 => \s_axil_rdata[27]_i_4_n_0\,
      I2 => \s_axil_rdata[2]_i_3_n_0\,
      I3 => \s_axil_rdata[2]_i_4_n_0\,
      I4 => \s_axil_rdata[27]_i_6_n_0\,
      O => \s_axil_rdata[2]_i_1_n_0\
    );
\s_axil_rdata[2]_i_15\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][2]\,
      I1 => \txReg_reg_n_0_[2][2]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][2]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][2]\,
      O => \s_axil_rdata[2]_i_15_n_0\
    );
\s_axil_rdata[2]_i_16\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][2]\,
      I1 => \txReg_reg_n_0_[6][2]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][2]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][2]\,
      O => \s_axil_rdata[2]_i_16_n_0\
    );
\s_axil_rdata[2]_i_17\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][2]\,
      I1 => \txReg_reg_n_0_[10][2]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][2]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][2]\,
      O => \s_axil_rdata[2]_i_17_n_0\
    );
\s_axil_rdata[2]_i_18\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][2]\,
      I1 => \txReg_reg_n_0_[14][2]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][2]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][2]\,
      O => \s_axil_rdata[2]_i_18_n_0\
    );
\s_axil_rdata[2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000035333535"
    )
        port map (
      I0 => \latency_reg_n_0_[2]\,
      I1 => cpiCount_reg(2),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \s_axil_rdata[31]_i_8_n_0\,
      O => \s_axil_rdata[2]_i_2_n_0\
    );
\s_axil_rdata[2]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFCFDFD"
    )
        port map (
      I0 => \s_axil_rdata[2]_i_5_n_0\,
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(0),
      I3 => \s_axil_rdata[2]_i_6_n_0\,
      I4 => s_axi_araddr(4),
      O => \s_axil_rdata[2]_i_3_n_0\
    );
\s_axil_rdata[2]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF0415"
    )
        port map (
      I0 => \s_axil_rdata[31]_i_3_n_0\,
      I1 => s_axi_araddr(6),
      I2 => \s_axil_rdata[2]_i_7_n_0\,
      I3 => \s_axil_rdata_reg[2]_i_8_n_0\,
      I4 => \s_axil_rdata_reg[2]_0\,
      O => \s_axil_rdata[2]_i_4_n_0\
    );
\s_axil_rdata[2]_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"503F5F3F"
    )
        port map (
      I0 => \^cfaralpha_o_reg[15]_0\(2),
      I1 => \^cfark_o_reg[4]_0\(2),
      I2 => s_axi_araddr(3),
      I3 => s_axi_araddr(2),
      I4 => ct2Busy,
      O => \s_axil_rdata[2]_i_5_n_0\
    );
\s_axil_rdata[2]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \s_axil_rdata[4]_i_7_0\(2),
      I1 => s_axi_araddr(3),
      I2 => \^ppmaxgap_o_reg[9]_0\(2),
      I3 => s_axi_araddr(2),
      I4 => ppLogRatio(2),
      O => \s_axil_rdata[2]_i_6_n_0\
    );
\s_axil_rdata[2]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][2]\,
      I1 => \txReg_reg_n_0_[18][2]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][2]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][2]\,
      O => \s_axil_rdata[2]_i_7_n_0\
    );
\s_axil_rdata[30]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFCA0F0A"
    )
        port map (
      I0 => \s_axil_rdata_reg[30]_i_2_n_0\,
      I1 => \s_axil_rdata[30]_i_3_n_0\,
      I2 => s_axi_araddr(6),
      I3 => \s_axil_rdata[31]_i_3_n_0\,
      I4 => s_axi_araddr(7),
      I5 => \s_axil_rdata[30]_i_4_n_0\,
      O => \s_axil_rdata[30]_i_1_n_0\
    );
\s_axil_rdata[30]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][30]\,
      I1 => \txReg_reg_n_0_[14][30]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][30]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][30]\,
      O => \s_axil_rdata[30]_i_10_n_0\
    );
\s_axil_rdata[30]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][30]\,
      I1 => \txReg_reg_n_0_[18][30]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][30]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][30]\,
      O => \s_axil_rdata[30]_i_3_n_0\
    );
\s_axil_rdata[30]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000A22AAAAAAAA"
    )
        port map (
      I0 => \s_axil_rdata[27]_i_6_n_0\,
      I1 => cpiCount_reg(30),
      I2 => \latency_reg_n_0_[30]\,
      I3 => \s_axil_rdata[31]_i_9_n_0\,
      I4 => \s_axil_rdata[31]_i_8_n_0\,
      I5 => \s_axil_rdata[31]_i_10_n_0\,
      O => \s_axil_rdata[30]_i_4_n_0\
    );
\s_axil_rdata[30]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][30]\,
      I1 => \txReg_reg_n_0_[2][30]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][30]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][30]\,
      O => \s_axil_rdata[30]_i_7_n_0\
    );
\s_axil_rdata[30]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][30]\,
      I1 => \txReg_reg_n_0_[6][30]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][30]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][30]\,
      O => \s_axil_rdata[30]_i_8_n_0\
    );
\s_axil_rdata[30]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][30]\,
      I1 => \txReg_reg_n_0_[10][30]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][30]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][30]\,
      O => \s_axil_rdata[30]_i_9_n_0\
    );
\s_axil_rdata[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FCEE00EE"
    )
        port map (
      I0 => \s_axil_rdata_reg[31]_i_2_n_0\,
      I1 => \s_axil_rdata[31]_i_3_n_0\,
      I2 => \s_axil_rdata[31]_i_4_n_0\,
      I3 => s_axi_araddr(6),
      I4 => s_axi_araddr(7),
      I5 => \s_axil_rdata[31]_i_5_n_0\,
      O => \s_axil_rdata[31]_i_1_n_0\
    );
\s_axil_rdata[31]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFF10FFFFFF11"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(2),
      I2 => \^q\(3),
      I3 => s_axi_araddr(0),
      I4 => s_axi_araddr(5),
      I5 => s_axi_araddr(4),
      O => \s_axil_rdata[31]_i_10_n_0\
    );
\s_axil_rdata[31]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][31]\,
      I1 => \txReg_reg_n_0_[2][31]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][31]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][31]\,
      O => \s_axil_rdata[31]_i_11_n_0\
    );
\s_axil_rdata[31]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][31]\,
      I1 => \txReg_reg_n_0_[6][31]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][31]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][31]\,
      O => \s_axil_rdata[31]_i_12_n_0\
    );
\s_axil_rdata[31]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][31]\,
      I1 => \txReg_reg_n_0_[10][31]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][31]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][31]\,
      O => \s_axil_rdata[31]_i_13_n_0\
    );
\s_axil_rdata[31]_i_14\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][31]\,
      I1 => \txReg_reg_n_0_[14][31]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][31]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][31]\,
      O => \s_axil_rdata[31]_i_14_n_0\
    );
\s_axil_rdata[31]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A8FF"
    )
        port map (
      I0 => s_axi_araddr(6),
      I1 => s_axi_araddr(4),
      I2 => s_axi_araddr(5),
      I3 => s_axi_araddr(7),
      O => \s_axil_rdata[31]_i_3_n_0\
    );
\s_axil_rdata[31]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][31]\,
      I1 => \txReg_reg_n_0_[18][31]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][31]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][31]\,
      O => \s_axil_rdata[31]_i_4_n_0\
    );
\s_axil_rdata[31]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000A0202AAAAAAAA"
    )
        port map (
      I0 => \s_axil_rdata[27]_i_6_n_0\,
      I1 => cpiCount_reg(31),
      I2 => \s_axil_rdata[31]_i_8_n_0\,
      I3 => \latency_reg_n_0_[31]\,
      I4 => \s_axil_rdata[31]_i_9_n_0\,
      I5 => \s_axil_rdata[31]_i_10_n_0\,
      O => \s_axil_rdata[31]_i_5_n_0\
    );
\s_axil_rdata[31]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFD"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(4),
      I2 => s_axi_araddr(3),
      I3 => s_axi_araddr(0),
      O => \s_axil_rdata[31]_i_8_n_0\
    );
\s_axil_rdata[31]_i_9\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"0D"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => s_axi_araddr(3),
      I2 => s_axi_araddr(4),
      O => \s_axil_rdata[31]_i_9_n_0\
    );
\s_axil_rdata[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"505400FF"
    )
        port map (
      I0 => \s_axil_rdata[3]_i_2_n_0\,
      I1 => \s_axil_rdata[27]_i_4_n_0\,
      I2 => \s_axil_rdata[3]_i_3_n_0\,
      I3 => \s_axil_rdata[3]_i_4_n_0\,
      I4 => \s_axil_rdata[27]_i_6_n_0\,
      O => \s_axil_rdata[3]_i_1_n_0\
    );
\s_axil_rdata[3]_i_15\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][3]\,
      I1 => \txReg_reg_n_0_[2][3]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][3]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][3]\,
      O => \s_axil_rdata[3]_i_15_n_0\
    );
\s_axil_rdata[3]_i_16\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][3]\,
      I1 => \txReg_reg_n_0_[6][3]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][3]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][3]\,
      O => \s_axil_rdata[3]_i_16_n_0\
    );
\s_axil_rdata[3]_i_17\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][3]\,
      I1 => \txReg_reg_n_0_[10][3]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][3]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][3]\,
      O => \s_axil_rdata[3]_i_17_n_0\
    );
\s_axil_rdata[3]_i_18\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][3]\,
      I1 => \txReg_reg_n_0_[14][3]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][3]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][3]\,
      O => \s_axil_rdata[3]_i_18_n_0\
    );
\s_axil_rdata[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000035333535"
    )
        port map (
      I0 => \latency_reg_n_0_[3]\,
      I1 => cpiCount_reg(3),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \s_axil_rdata[31]_i_8_n_0\,
      O => \s_axil_rdata[3]_i_2_n_0\
    );
\s_axil_rdata[3]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFCFDFD"
    )
        port map (
      I0 => \s_axil_rdata[3]_i_5_n_0\,
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(0),
      I3 => \s_axil_rdata[3]_i_6_n_0\,
      I4 => s_axi_araddr(4),
      O => \s_axil_rdata[3]_i_3_n_0\
    );
\s_axil_rdata[3]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF0415"
    )
        port map (
      I0 => \s_axil_rdata[31]_i_3_n_0\,
      I1 => s_axi_araddr(6),
      I2 => \s_axil_rdata[3]_i_7_n_0\,
      I3 => \s_axil_rdata_reg[3]_i_8_n_0\,
      I4 => \s_axil_rdata_reg[3]_0\,
      O => \s_axil_rdata[3]_i_4_n_0\
    );
\s_axil_rdata[3]_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"503F5F3F"
    )
        port map (
      I0 => \^cfaralpha_o_reg[15]_0\(3),
      I1 => \^cfark_o_reg[4]_0\(3),
      I2 => s_axi_araddr(3),
      I3 => s_axi_araddr(2),
      I4 => txLoaded_reg_n_0,
      O => \s_axil_rdata[3]_i_5_n_0\
    );
\s_axil_rdata[3]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \s_axil_rdata[4]_i_7_0\(3),
      I1 => s_axi_araddr(3),
      I2 => \^ppmaxgap_o_reg[9]_0\(3),
      I3 => s_axi_araddr(2),
      I4 => ppLogRatio(3),
      O => \s_axil_rdata[3]_i_6_n_0\
    );
\s_axil_rdata[3]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][3]\,
      I1 => \txReg_reg_n_0_[18][3]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][3]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][3]\,
      O => \s_axil_rdata[3]_i_7_n_0\
    );
\s_axil_rdata[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"DDDDD000DDDDDDDD"
    )
        port map (
      I0 => \s_axil_rdata[27]_i_6_n_0\,
      I1 => \s_axil_rdata[4]_i_2_n_0\,
      I2 => s_axi_araddr_6_sn_1,
      I3 => \s_axil_rdata_reg[4]_0\,
      I4 => \s_axil_rdata[4]_i_5_n_0\,
      I5 => \s_axil_rdata[4]_i_6_n_0\,
      O => \s_axil_rdata[4]_i_1_n_0\
    );
\s_axil_rdata[4]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][4]\,
      I1 => \txReg_reg_n_0_[18][4]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][4]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][4]\,
      O => \s_axil_rdata[4]_i_10_n_0\
    );
\s_axil_rdata[4]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FF330F55"
    )
        port map (
      I0 => ppLogRatio(4),
      I1 => \s_axil_rdata[4]_i_7_0\(4),
      I2 => \^ppmaxgap_o_reg[9]_0\(4),
      I3 => s_axi_araddr(2),
      I4 => s_axi_araddr(3),
      I5 => \s_axil_rdata[29]_i_8_n_0\,
      O => \s_axil_rdata[4]_i_13_n_0\
    );
\s_axil_rdata[4]_i_14\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BABAFFBABABABABA"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(4),
      I3 => \^cfark_o_reg[4]_0\(4),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => \s_axil_rdata[4]_i_14_n_0\
    );
\s_axil_rdata[4]_i_19\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][4]\,
      I1 => \txReg_reg_n_0_[2][4]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][4]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][4]\,
      O => \s_axil_rdata[4]_i_19_n_0\
    );
\s_axil_rdata[4]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EEEEE0EEEEE0E0E0"
    )
        port map (
      I0 => \s_axil_rdata[4]_i_7_n_0\,
      I1 => \s_axil_rdata[27]_i_4_n_0\,
      I2 => \s_axil_rdata[31]_i_8_n_0\,
      I3 => \s_axil_rdata[31]_i_9_n_0\,
      I4 => \latency_reg_n_0_[4]\,
      I5 => cpiCount_reg(4),
      O => \s_axil_rdata[4]_i_2_n_0\
    );
\s_axil_rdata[4]_i_20\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][4]\,
      I1 => \txReg_reg_n_0_[6][4]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][4]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][4]\,
      O => \s_axil_rdata[4]_i_20_n_0\
    );
\s_axil_rdata[4]_i_21\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][4]\,
      I1 => \txReg_reg_n_0_[10][4]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][4]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][4]\,
      O => \s_axil_rdata[4]_i_21_n_0\
    );
\s_axil_rdata[4]_i_22\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][4]\,
      I1 => \txReg_reg_n_0_[14][4]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][4]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][4]\,
      O => \s_axil_rdata[4]_i_22_n_0\
    );
\s_axil_rdata[4]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => s_axi_araddr(6),
      I1 => s_axi_araddr(7),
      O => s_axi_araddr_6_sn_1
    );
\s_axil_rdata[4]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000008080888"
    )
        port map (
      I0 => \s_axil_rdata[4]_i_7_n_0\,
      I1 => \s_axil_rdata[27]_i_6_n_0\,
      I2 => s_axi_araddr(5),
      I3 => s_axi_araddr(4),
      I4 => s_axi_araddr(3),
      I5 => s_axi_araddr(0),
      O => \s_axil_rdata[4]_i_5_n_0\
    );
\s_axil_rdata[4]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BABABABFBFBFBABF"
    )
        port map (
      I0 => \s_axil_rdata[31]_i_3_n_0\,
      I1 => \s_axil_rdata[4]_i_10_n_0\,
      I2 => s_axi_araddr(6),
      I3 => \s_axil_rdata_reg[4]_i_11_n_0\,
      I4 => s_axi_araddr(5),
      I5 => \s_axil_rdata_reg[4]_i_12_n_0\,
      O => \s_axil_rdata[4]_i_6_n_0\
    );
\s_axil_rdata[4]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"55554000FFFFFFFF"
    )
        port map (
      I0 => \s_axil_rdata[4]_i_13_n_0\,
      I1 => s_axi_araddr(2),
      I2 => \^cfaralpha_o_reg[15]_0\(4),
      I3 => s_axi_araddr(3),
      I4 => \s_axil_rdata[4]_i_14_n_0\,
      I5 => \s_axil_rdata[15]_i_2_n_0\,
      O => \s_axil_rdata[4]_i_7_n_0\
    );
\s_axil_rdata[5]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"10F0B0F0"
    )
        port map (
      I0 => \s_axil_rdata[15]_i_2_n_0\,
      I1 => \s_axil_rdata[5]_i_2_n_0\,
      I2 => \s_axil_rdata[5]_i_3_n_0\,
      I3 => \s_axil_rdata[27]_i_6_n_0\,
      I4 => \s_axil_rdata[5]_i_4_n_0\,
      O => \s_axil_rdata[5]_i_1_n_0\
    );
\s_axil_rdata[5]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][5]\,
      I1 => \txReg_reg_n_0_[2][5]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][5]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][5]\,
      O => \s_axil_rdata[5]_i_13_n_0\
    );
\s_axil_rdata[5]_i_14\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][5]\,
      I1 => \txReg_reg_n_0_[6][5]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][5]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][5]\,
      O => \s_axil_rdata[5]_i_14_n_0\
    );
\s_axil_rdata[5]_i_15\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][5]\,
      I1 => \txReg_reg_n_0_[10][5]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][5]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][5]\,
      O => \s_axil_rdata[5]_i_15_n_0\
    );
\s_axil_rdata[5]_i_16\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][5]\,
      I1 => \txReg_reg_n_0_[14][5]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][5]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][5]\,
      O => \s_axil_rdata[5]_i_16_n_0\
    );
\s_axil_rdata[5]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0001000000010005"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => cpiCount_reg(5),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \latency_reg_n_0_[5]\,
      O => \s_axil_rdata[5]_i_2_n_0\
    );
\s_axil_rdata[5]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FCFCEEEEFC00EEEE"
    )
        port map (
      I0 => \s_axil_rdata_reg[5]_i_5_n_0\,
      I1 => \s_axil_rdata[31]_i_3_n_0\,
      I2 => \s_axil_rdata[5]_i_6_n_0\,
      I3 => \s_axil_rdata_reg[5]_0\,
      I4 => s_axi_araddr(6),
      I5 => s_axi_araddr(7),
      O => \s_axil_rdata[5]_i_3_n_0\
    );
\s_axil_rdata[5]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7C7FFFFF7C7F0000"
    )
        port map (
      I0 => \^cfaralpha_o_reg[15]_0\(5),
      I1 => s_axi_araddr(3),
      I2 => s_axi_araddr(2),
      I3 => \s_axil_rdata[5]_i_3_n_0\,
      I4 => \s_axil_rdata[29]_i_8_n_0\,
      I5 => \s_axil_rdata[5]_i_8_n_0\,
      O => \s_axil_rdata[5]_i_4_n_0\
    );
\s_axil_rdata[5]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][5]\,
      I1 => \txReg_reg_n_0_[18][5]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][5]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][5]\,
      O => \s_axil_rdata[5]_i_6_n_0\
    );
\s_axil_rdata[5]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"ABFB"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => ppLogRatio(5),
      I2 => s_axi_araddr(2),
      I3 => \^ppmaxgap_o_reg[9]_0\(5),
      O => \s_axil_rdata[5]_i_8_n_0\
    );
\s_axil_rdata[6]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"10F0B0F0"
    )
        port map (
      I0 => \s_axil_rdata[15]_i_2_n_0\,
      I1 => \s_axil_rdata[6]_i_2_n_0\,
      I2 => \s_axil_rdata[6]_i_3_n_0\,
      I3 => \s_axil_rdata[27]_i_6_n_0\,
      I4 => \s_axil_rdata[6]_i_4_n_0\,
      O => \s_axil_rdata[6]_i_1_n_0\
    );
\s_axil_rdata[6]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][6]\,
      I1 => \txReg_reg_n_0_[2][6]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][6]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][6]\,
      O => \s_axil_rdata[6]_i_13_n_0\
    );
\s_axil_rdata[6]_i_14\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][6]\,
      I1 => \txReg_reg_n_0_[6][6]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][6]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][6]\,
      O => \s_axil_rdata[6]_i_14_n_0\
    );
\s_axil_rdata[6]_i_15\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][6]\,
      I1 => \txReg_reg_n_0_[10][6]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][6]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][6]\,
      O => \s_axil_rdata[6]_i_15_n_0\
    );
\s_axil_rdata[6]_i_16\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][6]\,
      I1 => \txReg_reg_n_0_[14][6]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][6]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][6]\,
      O => \s_axil_rdata[6]_i_16_n_0\
    );
\s_axil_rdata[6]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0001000000010005"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => cpiCount_reg(6),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \latency_reg_n_0_[6]\,
      O => \s_axil_rdata[6]_i_2_n_0\
    );
\s_axil_rdata[6]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FCFCEEEEFC00EEEE"
    )
        port map (
      I0 => \s_axil_rdata_reg[6]_i_5_n_0\,
      I1 => \s_axil_rdata[31]_i_3_n_0\,
      I2 => \s_axil_rdata[6]_i_6_n_0\,
      I3 => \s_axil_rdata_reg[6]_0\,
      I4 => s_axi_araddr(6),
      I5 => s_axi_araddr(7),
      O => \s_axil_rdata[6]_i_3_n_0\
    );
\s_axil_rdata[6]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7C7FFFFF7C7F0000"
    )
        port map (
      I0 => \^cfaralpha_o_reg[15]_0\(6),
      I1 => s_axi_araddr(3),
      I2 => s_axi_araddr(2),
      I3 => \s_axil_rdata[6]_i_3_n_0\,
      I4 => \s_axil_rdata[29]_i_8_n_0\,
      I5 => \s_axil_rdata[6]_i_8_n_0\,
      O => \s_axil_rdata[6]_i_4_n_0\
    );
\s_axil_rdata[6]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][6]\,
      I1 => \txReg_reg_n_0_[18][6]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][6]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][6]\,
      O => \s_axil_rdata[6]_i_6_n_0\
    );
\s_axil_rdata[6]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"ABFB"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => ppLogRatio(6),
      I2 => s_axi_araddr(2),
      I3 => \^ppmaxgap_o_reg[9]_0\(6),
      O => \s_axil_rdata[6]_i_8_n_0\
    );
\s_axil_rdata[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"10F0B0F0"
    )
        port map (
      I0 => \s_axil_rdata[15]_i_2_n_0\,
      I1 => \s_axil_rdata[7]_i_2_n_0\,
      I2 => \s_axil_rdata[7]_i_3_n_0\,
      I3 => \s_axil_rdata[27]_i_6_n_0\,
      I4 => \s_axil_rdata[7]_i_4_n_0\,
      O => \s_axil_rdata[7]_i_1_n_0\
    );
\s_axil_rdata[7]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][7]\,
      I1 => \txReg_reg_n_0_[2][7]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][7]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][7]\,
      O => \s_axil_rdata[7]_i_13_n_0\
    );
\s_axil_rdata[7]_i_14\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][7]\,
      I1 => \txReg_reg_n_0_[6][7]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][7]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][7]\,
      O => \s_axil_rdata[7]_i_14_n_0\
    );
\s_axil_rdata[7]_i_15\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][7]\,
      I1 => \txReg_reg_n_0_[10][7]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][7]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][7]\,
      O => \s_axil_rdata[7]_i_15_n_0\
    );
\s_axil_rdata[7]_i_16\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][7]\,
      I1 => \txReg_reg_n_0_[14][7]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][7]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][7]\,
      O => \s_axil_rdata[7]_i_16_n_0\
    );
\s_axil_rdata[7]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0001000000010005"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => cpiCount_reg(7),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \latency_reg_n_0_[7]\,
      O => \s_axil_rdata[7]_i_2_n_0\
    );
\s_axil_rdata[7]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FCFCEEEEFC00EEEE"
    )
        port map (
      I0 => \s_axil_rdata_reg[7]_i_5_n_0\,
      I1 => \s_axil_rdata[31]_i_3_n_0\,
      I2 => \s_axil_rdata[7]_i_6_n_0\,
      I3 => \s_axil_rdata_reg[7]_0\,
      I4 => s_axi_araddr(6),
      I5 => s_axi_araddr(7),
      O => \s_axil_rdata[7]_i_3_n_0\
    );
\s_axil_rdata[7]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7C7FFFFF7C7F0000"
    )
        port map (
      I0 => \^cfaralpha_o_reg[15]_0\(7),
      I1 => s_axi_araddr(3),
      I2 => s_axi_araddr(2),
      I3 => \s_axil_rdata[7]_i_3_n_0\,
      I4 => \s_axil_rdata[29]_i_8_n_0\,
      I5 => \s_axil_rdata[7]_i_8_n_0\,
      O => \s_axil_rdata[7]_i_4_n_0\
    );
\s_axil_rdata[7]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][7]\,
      I1 => \txReg_reg_n_0_[18][7]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][7]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][7]\,
      O => \s_axil_rdata[7]_i_6_n_0\
    );
\s_axil_rdata[7]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"ABFB"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => ppLogRatio(7),
      I2 => s_axi_araddr(2),
      I3 => \^ppmaxgap_o_reg[9]_0\(7),
      O => \s_axil_rdata[7]_i_8_n_0\
    );
\s_axil_rdata[8]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"1110FF00BBBAFF00"
    )
        port map (
      I0 => \s_axil_rdata[15]_i_2_n_0\,
      I1 => \s_axil_rdata[8]_i_2_n_0\,
      I2 => \s_axil_rdata[26]_i_2_n_0\,
      I3 => \s_axil_rdata[8]_i_3_n_0\,
      I4 => \s_axil_rdata[27]_i_6_n_0\,
      I5 => \s_axil_rdata[8]_i_4_n_0\,
      O => \s_axil_rdata[8]_i_1_n_0\
    );
\s_axil_rdata[8]_i_15\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][8]\,
      I1 => \txReg_reg_n_0_[2][8]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][8]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][8]\,
      O => \s_axil_rdata[8]_i_15_n_0\
    );
\s_axil_rdata[8]_i_16\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][8]\,
      I1 => \txReg_reg_n_0_[6][8]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][8]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][8]\,
      O => \s_axil_rdata[8]_i_16_n_0\
    );
\s_axil_rdata[8]_i_17\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][8]\,
      I1 => \txReg_reg_n_0_[10][8]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][8]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][8]\,
      O => \s_axil_rdata[8]_i_17_n_0\
    );
\s_axil_rdata[8]_i_18\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][8]\,
      I1 => \txReg_reg_n_0_[14][8]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][8]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][8]\,
      O => \s_axil_rdata[8]_i_18_n_0\
    );
\s_axil_rdata[8]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0001000000010005"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => cpiCount_reg(8),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \latency_reg_n_0_[8]\,
      O => \s_axil_rdata[8]_i_2_n_0\
    );
\s_axil_rdata[8]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"445044504450FF50"
    )
        port map (
      I0 => \s_axil_rdata[31]_i_3_n_0\,
      I1 => \s_axil_rdata[8]_i_5_n_0\,
      I2 => \s_axil_rdata_reg[8]_i_6_n_0\,
      I3 => s_axi_araddr(6),
      I4 => s_axi_araddr(7),
      I5 => \s_axil_rdata_reg[8]_0\,
      O => \s_axil_rdata[8]_i_3_n_0\
    );
\s_axil_rdata[8]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7C7FFFFF7C7F0000"
    )
        port map (
      I0 => \^cfaralpha_o_reg[15]_0\(8),
      I1 => s_axi_araddr(3),
      I2 => s_axi_araddr(2),
      I3 => \s_axil_rdata[8]_i_3_n_0\,
      I4 => \s_axil_rdata[29]_i_8_n_0\,
      I5 => \s_axil_rdata[8]_i_8_n_0\,
      O => \s_axil_rdata[8]_i_4_n_0\
    );
\s_axil_rdata[8]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][8]\,
      I1 => \txReg_reg_n_0_[18][8]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][8]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][8]\,
      O => \s_axil_rdata[8]_i_5_n_0\
    );
\s_axil_rdata[8]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"ABFB"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => ppLogRatio(8),
      I2 => s_axi_araddr(2),
      I3 => \^ppmaxgap_o_reg[9]_0\(8),
      O => \s_axil_rdata[8]_i_8_n_0\
    );
\s_axil_rdata[9]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"10F0B0F0"
    )
        port map (
      I0 => \s_axil_rdata[15]_i_2_n_0\,
      I1 => \s_axil_rdata[9]_i_2_n_0\,
      I2 => \s_axil_rdata[9]_i_3_n_0\,
      I3 => \s_axil_rdata[27]_i_6_n_0\,
      I4 => \s_axil_rdata[9]_i_4_n_0\,
      O => \s_axil_rdata[9]_i_1_n_0\
    );
\s_axil_rdata[9]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][9]\,
      I1 => \txReg_reg_n_0_[2][9]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[1][9]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[0][9]\,
      O => \s_axil_rdata[9]_i_13_n_0\
    );
\s_axil_rdata[9]_i_14\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][9]\,
      I1 => \txReg_reg_n_0_[6][9]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[5][9]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[4][9]\,
      O => \s_axil_rdata[9]_i_14_n_0\
    );
\s_axil_rdata[9]_i_15\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][9]\,
      I1 => \txReg_reg_n_0_[10][9]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[9][9]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[8][9]\,
      O => \s_axil_rdata[9]_i_15_n_0\
    );
\s_axil_rdata[9]_i_16\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][9]\,
      I1 => \txReg_reg_n_0_[14][9]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[13][9]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[12][9]\,
      O => \s_axil_rdata[9]_i_16_n_0\
    );
\s_axil_rdata[9]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0001000000010005"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => cpiCount_reg(9),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \latency_reg_n_0_[9]\,
      O => \s_axil_rdata[9]_i_2_n_0\
    );
\s_axil_rdata[9]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FCFCEEEEFC00EEEE"
    )
        port map (
      I0 => \s_axil_rdata_reg[9]_i_5_n_0\,
      I1 => \s_axil_rdata[31]_i_3_n_0\,
      I2 => \s_axil_rdata[9]_i_6_n_0\,
      I3 => \s_axil_rdata_reg[9]_0\,
      I4 => s_axi_araddr(6),
      I5 => s_axi_araddr(7),
      O => \s_axil_rdata[9]_i_3_n_0\
    );
\s_axil_rdata[9]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7C7FFFFF7C7F0000"
    )
        port map (
      I0 => \^cfaralpha_o_reg[15]_0\(9),
      I1 => s_axi_araddr(3),
      I2 => s_axi_araddr(2),
      I3 => \s_axil_rdata[9]_i_3_n_0\,
      I4 => \s_axil_rdata[29]_i_8_n_0\,
      I5 => \s_axil_rdata[9]_i_8_n_0\,
      O => \s_axil_rdata[9]_i_4_n_0\
    );
\s_axil_rdata[9]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][9]\,
      I1 => \txReg_reg_n_0_[18][9]\,
      I2 => s_axi_araddr(3),
      I3 => \txReg_reg_n_0_[17][9]\,
      I4 => s_axi_araddr(2),
      I5 => \txReg_reg_n_0_[16][9]\,
      O => \s_axil_rdata[9]_i_6_n_0\
    );
\s_axil_rdata[9]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"ABFB"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => ppLogRatio(9),
      I2 => s_axi_araddr(2),
      I3 => \^ppmaxgap_o_reg[9]_0\(9),
      O => \s_axil_rdata[9]_i_8_n_0\
    );
\s_axil_rdata_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[0]_i_1_n_0\,
      Q => s_axi_rdata(0)
    );
\s_axil_rdata_reg[0]_i_10\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[0]_i_15_n_0\,
      I1 => \s_axil_rdata[0]_i_16_n_0\,
      O => \s_axil_rdata_reg[0]_i_10_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[0]_i_11\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[0]_i_17_n_0\,
      I1 => \s_axil_rdata[0]_i_18_n_0\,
      O => \s_axil_rdata_reg[0]_i_11_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[0]_i_6\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[0]_i_10_n_0\,
      I1 => \s_axil_rdata_reg[0]_i_11_n_0\,
      O => \s_axil_rdata_reg[0]_i_6_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[10]_i_1_n_0\,
      Q => s_axi_rdata(10)
    );
\s_axil_rdata_reg[10]_i_6\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[10]_i_8_n_0\,
      I1 => \s_axil_rdata_reg[10]_i_9_n_0\,
      O => \s_axil_rdata_reg[10]_i_6_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[10]_i_8\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[10]_i_10_n_0\,
      I1 => \s_axil_rdata[10]_i_11_n_0\,
      O => \s_axil_rdata_reg[10]_i_8_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[10]_i_9\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[10]_i_12_n_0\,
      I1 => \s_axil_rdata[10]_i_13_n_0\,
      O => \s_axil_rdata_reg[10]_i_9_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[11]_i_1_n_0\,
      Q => s_axi_rdata(11)
    );
\s_axil_rdata_reg[11]_i_6\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[11]_i_8_n_0\,
      I1 => \s_axil_rdata_reg[11]_i_9_n_0\,
      O => \s_axil_rdata_reg[11]_i_6_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[11]_i_8\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[11]_i_10_n_0\,
      I1 => \s_axil_rdata[11]_i_11_n_0\,
      O => \s_axil_rdata_reg[11]_i_8_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[11]_i_9\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[11]_i_12_n_0\,
      I1 => \s_axil_rdata[11]_i_13_n_0\,
      O => \s_axil_rdata_reg[11]_i_9_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[12]_i_1_n_0\,
      Q => s_axi_rdata(12)
    );
\s_axil_rdata_reg[12]_i_6\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[12]_i_8_n_0\,
      I1 => \s_axil_rdata_reg[12]_i_9_n_0\,
      O => \s_axil_rdata_reg[12]_i_6_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[12]_i_8\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[12]_i_10_n_0\,
      I1 => \s_axil_rdata[12]_i_11_n_0\,
      O => \s_axil_rdata_reg[12]_i_8_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[12]_i_9\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[12]_i_12_n_0\,
      I1 => \s_axil_rdata[12]_i_13_n_0\,
      O => \s_axil_rdata_reg[12]_i_9_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[13]_i_1_n_0\,
      Q => s_axi_rdata(13)
    );
\s_axil_rdata_reg[13]_i_10\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[13]_i_13_n_0\,
      I1 => \s_axil_rdata[13]_i_14_n_0\,
      O => \s_axil_rdata_reg[13]_i_10_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[13]_i_7\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[13]_i_9_n_0\,
      I1 => \s_axil_rdata_reg[13]_i_10_n_0\,
      O => \s_axil_rdata_reg[13]_i_7_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[13]_i_9\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[13]_i_11_n_0\,
      I1 => \s_axil_rdata[13]_i_12_n_0\,
      O => \s_axil_rdata_reg[13]_i_9_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[14]_i_1_n_0\,
      Q => s_axi_rdata(14)
    );
\s_axil_rdata_reg[14]_i_2\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[14]_i_5_n_0\,
      I1 => \s_axil_rdata[14]_i_6_n_0\,
      O => \s_axil_rdata_reg[14]_i_2_n_0\,
      S => s_axi_araddr(6)
    );
\s_axil_rdata_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[15]_i_1_n_0\,
      Q => s_axi_rdata(15)
    );
\s_axil_rdata_reg[15]_i_10\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[15]_i_13_n_0\,
      I1 => \s_axil_rdata[15]_i_14_n_0\,
      O => \s_axil_rdata_reg[15]_i_10_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[15]_i_7\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[15]_i_9_n_0\,
      I1 => \s_axil_rdata_reg[15]_i_10_n_0\,
      O => \s_axil_rdata_reg[15]_i_7_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[15]_i_9\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[15]_i_11_n_0\,
      I1 => \s_axil_rdata[15]_i_12_n_0\,
      O => \s_axil_rdata_reg[15]_i_9_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[16]_i_1_n_0\,
      Q => s_axi_rdata(16)
    );
\s_axil_rdata_reg[16]_i_2\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[16]_i_5_n_0\,
      I1 => \s_axil_rdata_reg[16]_i_6_n_0\,
      O => \s_axil_rdata_reg[16]_i_2_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[16]_i_5\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[16]_i_7_n_0\,
      I1 => \s_axil_rdata[16]_i_8_n_0\,
      O => \s_axil_rdata_reg[16]_i_5_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[16]_i_6\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[16]_i_9_n_0\,
      I1 => \s_axil_rdata[16]_i_10_n_0\,
      O => \s_axil_rdata_reg[16]_i_6_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[17]_i_1_n_0\,
      Q => s_axi_rdata(17)
    );
\s_axil_rdata_reg[17]_i_2\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[17]_i_5_n_0\,
      I1 => \s_axil_rdata_reg[17]_i_6_n_0\,
      O => \s_axil_rdata_reg[17]_i_2_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[17]_i_5\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[17]_i_7_n_0\,
      I1 => \s_axil_rdata[17]_i_8_n_0\,
      O => \s_axil_rdata_reg[17]_i_5_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[17]_i_6\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[17]_i_9_n_0\,
      I1 => \s_axil_rdata[17]_i_10_n_0\,
      O => \s_axil_rdata_reg[17]_i_6_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[18]_i_1_n_0\,
      Q => s_axi_rdata(18)
    );
\s_axil_rdata_reg[18]_i_2\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[18]_i_5_n_0\,
      I1 => \s_axil_rdata_reg[18]_i_6_n_0\,
      O => \s_axil_rdata_reg[18]_i_2_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[18]_i_5\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[18]_i_7_n_0\,
      I1 => \s_axil_rdata[18]_i_8_n_0\,
      O => \s_axil_rdata_reg[18]_i_5_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[18]_i_6\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[18]_i_9_n_0\,
      I1 => \s_axil_rdata[18]_i_10_n_0\,
      O => \s_axil_rdata_reg[18]_i_6_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[19]_i_1_n_0\,
      Q => s_axi_rdata(19)
    );
\s_axil_rdata_reg[19]_i_2\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[19]_i_5_n_0\,
      I1 => \s_axil_rdata_reg[19]_i_6_n_0\,
      O => \s_axil_rdata_reg[19]_i_2_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[19]_i_5\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[19]_i_7_n_0\,
      I1 => \s_axil_rdata[19]_i_8_n_0\,
      O => \s_axil_rdata_reg[19]_i_5_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[19]_i_6\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[19]_i_9_n_0\,
      I1 => \s_axil_rdata[19]_i_10_n_0\,
      O => \s_axil_rdata_reg[19]_i_6_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[1]_i_1_n_0\,
      Q => s_axi_rdata(1)
    );
\s_axil_rdata_reg[1]_i_10\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[1]_i_14_n_0\,
      I1 => \s_axil_rdata[1]_i_15_n_0\,
      O => \s_axil_rdata_reg[1]_i_10_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[1]_i_11\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[1]_i_16_n_0\,
      I1 => \s_axil_rdata[1]_i_17_n_0\,
      O => \s_axil_rdata_reg[1]_i_11_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[1]_i_8\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[1]_i_10_n_0\,
      I1 => \s_axil_rdata_reg[1]_i_11_n_0\,
      O => \s_axil_rdata_reg[1]_i_8_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[20]_i_1_n_0\,
      Q => s_axi_rdata(20)
    );
\s_axil_rdata_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[21]_i_1_n_0\,
      Q => s_axi_rdata(21)
    );
\s_axil_rdata_reg[21]_i_2\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[21]_i_5_n_0\,
      I1 => \s_axil_rdata_reg[21]_i_6_n_0\,
      O => \s_axil_rdata_reg[21]_i_2_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[21]_i_5\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[21]_i_7_n_0\,
      I1 => \s_axil_rdata[21]_i_8_n_0\,
      O => \s_axil_rdata_reg[21]_i_5_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[21]_i_6\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[21]_i_9_n_0\,
      I1 => \s_axil_rdata[21]_i_10_n_0\,
      O => \s_axil_rdata_reg[21]_i_6_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[22]_i_1_n_0\,
      Q => s_axi_rdata(22)
    );
\s_axil_rdata_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[23]_i_1_n_0\,
      Q => s_axi_rdata(23)
    );
\s_axil_rdata_reg[23]_i_2\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[23]_i_5_n_0\,
      I1 => \s_axil_rdata_reg[23]_i_6_n_0\,
      O => \s_axil_rdata_reg[23]_i_2_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[23]_i_5\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[23]_i_7_n_0\,
      I1 => \s_axil_rdata[23]_i_8_n_0\,
      O => \s_axil_rdata_reg[23]_i_5_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[23]_i_6\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[23]_i_9_n_0\,
      I1 => \s_axil_rdata[23]_i_10_n_0\,
      O => \s_axil_rdata_reg[23]_i_6_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[24]_i_1_n_0\,
      Q => s_axi_rdata(24)
    );
\s_axil_rdata_reg[24]_i_2\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[24]_i_5_n_0\,
      I1 => \s_axil_rdata_reg[24]_i_6_n_0\,
      O => \s_axil_rdata_reg[24]_i_2_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[24]_i_5\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[24]_i_7_n_0\,
      I1 => \s_axil_rdata[24]_i_8_n_0\,
      O => \s_axil_rdata_reg[24]_i_5_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[24]_i_6\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[24]_i_9_n_0\,
      I1 => \s_axil_rdata[24]_i_10_n_0\,
      O => \s_axil_rdata_reg[24]_i_6_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[25]_i_1_n_0\,
      Q => s_axi_rdata(25)
    );
\s_axil_rdata_reg[25]_i_2\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[25]_i_5_n_0\,
      I1 => \s_axil_rdata_reg[25]_i_6_n_0\,
      O => \s_axil_rdata_reg[25]_i_2_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[25]_i_5\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[25]_i_7_n_0\,
      I1 => \s_axil_rdata[25]_i_8_n_0\,
      O => \s_axil_rdata_reg[25]_i_5_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[25]_i_6\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[25]_i_9_n_0\,
      I1 => \s_axil_rdata[25]_i_10_n_0\,
      O => \s_axil_rdata_reg[25]_i_6_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[26]_i_1_n_0\,
      Q => s_axi_rdata(26)
    );
\s_axil_rdata_reg[26]_i_6\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[26]_i_7_n_0\,
      I1 => \s_axil_rdata_reg[26]_i_8_n_0\,
      O => \s_axil_rdata_reg[26]_i_6_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[26]_i_7\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[26]_i_9_n_0\,
      I1 => \s_axil_rdata[26]_i_10_n_0\,
      O => \s_axil_rdata_reg[26]_i_7_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[26]_i_8\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[26]_i_11_n_0\,
      I1 => \s_axil_rdata[26]_i_12_n_0\,
      O => \s_axil_rdata_reg[26]_i_8_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[27]_i_1_n_0\,
      Q => s_axi_rdata(27)
    );
\s_axil_rdata_reg[27]_i_10\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[27]_i_13_n_0\,
      I1 => \s_axil_rdata[27]_i_14_n_0\,
      O => \s_axil_rdata_reg[27]_i_10_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[27]_i_8\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[27]_i_9_n_0\,
      I1 => \s_axil_rdata_reg[27]_i_10_n_0\,
      O => \s_axil_rdata_reg[27]_i_8_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[27]_i_9\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[27]_i_11_n_0\,
      I1 => \s_axil_rdata[27]_i_12_n_0\,
      O => \s_axil_rdata_reg[27]_i_9_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[28]_i_1_n_0\,
      Q => s_axi_rdata(28)
    );
\s_axil_rdata_reg[28]_i_2\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[28]_i_5_n_0\,
      I1 => \s_axil_rdata_reg[28]_i_6_n_0\,
      O => \s_axil_rdata_reg[28]_i_2_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[28]_i_5\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[28]_i_7_n_0\,
      I1 => \s_axil_rdata[28]_i_8_n_0\,
      O => \s_axil_rdata_reg[28]_i_5_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[28]_i_6\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[28]_i_9_n_0\,
      I1 => \s_axil_rdata[28]_i_10_n_0\,
      O => \s_axil_rdata_reg[28]_i_6_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[29]_i_1_n_0\,
      Q => s_axi_rdata(29)
    );
\s_axil_rdata_reg[29]_i_2\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[29]_i_6_n_0\,
      I1 => \s_axil_rdata_reg[29]_i_7_n_0\,
      O => \s_axil_rdata_reg[29]_i_2_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[29]_i_6\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[29]_i_9_n_0\,
      I1 => \s_axil_rdata[29]_i_10_n_0\,
      O => \s_axil_rdata_reg[29]_i_6_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[29]_i_7\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[29]_i_11_n_0\,
      I1 => \s_axil_rdata[29]_i_12_n_0\,
      O => \s_axil_rdata_reg[29]_i_7_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[2]_i_1_n_0\,
      Q => s_axi_rdata(2)
    );
\s_axil_rdata_reg[2]_i_10\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[2]_i_15_n_0\,
      I1 => \s_axil_rdata[2]_i_16_n_0\,
      O => \s_axil_rdata_reg[2]_i_10_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[2]_i_11\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[2]_i_17_n_0\,
      I1 => \s_axil_rdata[2]_i_18_n_0\,
      O => \s_axil_rdata_reg[2]_i_11_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[2]_i_8\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[2]_i_10_n_0\,
      I1 => \s_axil_rdata_reg[2]_i_11_n_0\,
      O => \s_axil_rdata_reg[2]_i_8_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[30]_i_1_n_0\,
      Q => s_axi_rdata(30)
    );
\s_axil_rdata_reg[30]_i_2\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[30]_i_5_n_0\,
      I1 => \s_axil_rdata_reg[30]_i_6_n_0\,
      O => \s_axil_rdata_reg[30]_i_2_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[30]_i_5\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[30]_i_7_n_0\,
      I1 => \s_axil_rdata[30]_i_8_n_0\,
      O => \s_axil_rdata_reg[30]_i_5_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[30]_i_6\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[30]_i_9_n_0\,
      I1 => \s_axil_rdata[30]_i_10_n_0\,
      O => \s_axil_rdata_reg[30]_i_6_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[31]_i_1_n_0\,
      Q => s_axi_rdata(31)
    );
\s_axil_rdata_reg[31]_i_2\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[31]_i_6_n_0\,
      I1 => \s_axil_rdata_reg[31]_i_7_n_0\,
      O => \s_axil_rdata_reg[31]_i_2_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[31]_i_6\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[31]_i_11_n_0\,
      I1 => \s_axil_rdata[31]_i_12_n_0\,
      O => \s_axil_rdata_reg[31]_i_6_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[31]_i_7\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[31]_i_13_n_0\,
      I1 => \s_axil_rdata[31]_i_14_n_0\,
      O => \s_axil_rdata_reg[31]_i_7_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[3]_i_1_n_0\,
      Q => s_axi_rdata(3)
    );
\s_axil_rdata_reg[3]_i_10\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[3]_i_15_n_0\,
      I1 => \s_axil_rdata[3]_i_16_n_0\,
      O => \s_axil_rdata_reg[3]_i_10_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[3]_i_11\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[3]_i_17_n_0\,
      I1 => \s_axil_rdata[3]_i_18_n_0\,
      O => \s_axil_rdata_reg[3]_i_11_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[3]_i_8\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[3]_i_10_n_0\,
      I1 => \s_axil_rdata_reg[3]_i_11_n_0\,
      O => \s_axil_rdata_reg[3]_i_8_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[4]_i_1_n_0\,
      Q => s_axi_rdata(4)
    );
\s_axil_rdata_reg[4]_i_11\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[4]_i_19_n_0\,
      I1 => \s_axil_rdata[4]_i_20_n_0\,
      O => \s_axil_rdata_reg[4]_i_11_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[4]_i_12\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[4]_i_21_n_0\,
      I1 => \s_axil_rdata[4]_i_22_n_0\,
      O => \s_axil_rdata_reg[4]_i_12_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[5]_i_1_n_0\,
      Q => s_axi_rdata(5)
    );
\s_axil_rdata_reg[5]_i_10\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[5]_i_15_n_0\,
      I1 => \s_axil_rdata[5]_i_16_n_0\,
      O => \s_axil_rdata_reg[5]_i_10_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[5]_i_5\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[5]_i_9_n_0\,
      I1 => \s_axil_rdata_reg[5]_i_10_n_0\,
      O => \s_axil_rdata_reg[5]_i_5_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[5]_i_9\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[5]_i_13_n_0\,
      I1 => \s_axil_rdata[5]_i_14_n_0\,
      O => \s_axil_rdata_reg[5]_i_9_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[6]_i_1_n_0\,
      Q => s_axi_rdata(6)
    );
\s_axil_rdata_reg[6]_i_10\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[6]_i_15_n_0\,
      I1 => \s_axil_rdata[6]_i_16_n_0\,
      O => \s_axil_rdata_reg[6]_i_10_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[6]_i_5\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[6]_i_9_n_0\,
      I1 => \s_axil_rdata_reg[6]_i_10_n_0\,
      O => \s_axil_rdata_reg[6]_i_5_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[6]_i_9\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[6]_i_13_n_0\,
      I1 => \s_axil_rdata[6]_i_14_n_0\,
      O => \s_axil_rdata_reg[6]_i_9_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[7]_i_1_n_0\,
      Q => s_axi_rdata(7)
    );
\s_axil_rdata_reg[7]_i_10\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[7]_i_15_n_0\,
      I1 => \s_axil_rdata[7]_i_16_n_0\,
      O => \s_axil_rdata_reg[7]_i_10_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[7]_i_5\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[7]_i_9_n_0\,
      I1 => \s_axil_rdata_reg[7]_i_10_n_0\,
      O => \s_axil_rdata_reg[7]_i_5_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[7]_i_9\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[7]_i_13_n_0\,
      I1 => \s_axil_rdata[7]_i_14_n_0\,
      O => \s_axil_rdata_reg[7]_i_9_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[8]_i_1_n_0\,
      Q => s_axi_rdata(8)
    );
\s_axil_rdata_reg[8]_i_10\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[8]_i_17_n_0\,
      I1 => \s_axil_rdata[8]_i_18_n_0\,
      O => \s_axil_rdata_reg[8]_i_10_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[8]_i_6\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[8]_i_9_n_0\,
      I1 => \s_axil_rdata_reg[8]_i_10_n_0\,
      O => \s_axil_rdata_reg[8]_i_6_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[8]_i_9\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[8]_i_15_n_0\,
      I1 => \s_axil_rdata[8]_i_16_n_0\,
      O => \s_axil_rdata_reg[8]_i_9_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => s_axil_arready0,
      CLR => \^aresetn_0\,
      D => \s_axil_rdata[9]_i_1_n_0\,
      Q => s_axi_rdata(9)
    );
\s_axil_rdata_reg[9]_i_10\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[9]_i_15_n_0\,
      I1 => \s_axil_rdata[9]_i_16_n_0\,
      O => \s_axil_rdata_reg[9]_i_10_n_0\,
      S => s_axi_araddr(4)
    );
\s_axil_rdata_reg[9]_i_5\: unisim.vcomponents.MUXF8
     port map (
      I0 => \s_axil_rdata_reg[9]_i_9_n_0\,
      I1 => \s_axil_rdata_reg[9]_i_10_n_0\,
      O => \s_axil_rdata_reg[9]_i_5_n_0\,
      S => s_axi_araddr(5)
    );
\s_axil_rdata_reg[9]_i_9\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axil_rdata[9]_i_13_n_0\,
      I1 => \s_axil_rdata[9]_i_14_n_0\,
      O => \s_axil_rdata_reg[9]_i_9_n_0\,
      S => s_axi_araddr(4)
    );
s_axil_rvalid_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0F44"
    )
        port map (
      I0 => \^s_axi_arready\,
      I1 => s_axi_arvalid,
      I2 => s_axi_rready,
      I3 => \^s_axi_rvalid\,
      O => s_axil_rvalid_i_1_n_0
    );
s_axil_rvalid_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => s_axil_rvalid_i_1_n_0,
      Q => \^s_axi_rvalid\
    );
timing_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => timing_reg_0,
      Q => \^timing\
    );
\total[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \^hasdet\,
      I1 => \total_reg[0]\(0),
      O => D(0)
    );
\txComplex_o[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txComplex_o[0]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txComplex_o_reg[0]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txComplex_o_reg[0]_i_4_n_0\,
      O => \^txcomplex_i\(0)
    );
\txComplex_o[0]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][16]\,
      I1 => \txReg_reg_n_0_[18][16]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][16]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][16]\,
      O => \txComplex_o[0]_i_2_n_0\
    );
\txComplex_o[0]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][16]\,
      I1 => \txReg_reg_n_0_[10][16]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][16]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][16]\,
      O => \txComplex_o[0]_i_5_n_0\
    );
\txComplex_o[0]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][16]\,
      I1 => \txReg_reg_n_0_[14][16]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][16]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][16]\,
      O => \txComplex_o[0]_i_6_n_0\
    );
\txComplex_o[0]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][16]\,
      I1 => \txReg_reg_n_0_[2][16]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][16]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][16]\,
      O => \txComplex_o[0]_i_7_n_0\
    );
\txComplex_o[0]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][16]\,
      I1 => \txReg_reg_n_0_[6][16]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][16]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][16]\,
      O => \txComplex_o[0]_i_8_n_0\
    );
\txComplex_o[10]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txComplex_o[10]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txComplex_o_reg[10]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txComplex_o_reg[10]_i_4_n_0\,
      O => \^txcomplex_i\(10)
    );
\txComplex_o[10]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][26]\,
      I1 => \txReg_reg_n_0_[18][26]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][26]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][26]\,
      O => \txComplex_o[10]_i_2_n_0\
    );
\txComplex_o[10]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][26]\,
      I1 => \txReg_reg_n_0_[10][26]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][26]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][26]\,
      O => \txComplex_o[10]_i_5_n_0\
    );
\txComplex_o[10]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][26]\,
      I1 => \txReg_reg_n_0_[14][26]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][26]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][26]\,
      O => \txComplex_o[10]_i_6_n_0\
    );
\txComplex_o[10]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][26]\,
      I1 => \txReg_reg_n_0_[2][26]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][26]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][26]\,
      O => \txComplex_o[10]_i_7_n_0\
    );
\txComplex_o[10]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][26]\,
      I1 => \txReg_reg_n_0_[6][26]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][26]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][26]\,
      O => \txComplex_o[10]_i_8_n_0\
    );
\txComplex_o[11]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txComplex_o[11]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txComplex_o_reg[11]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txComplex_o_reg[11]_i_4_n_0\,
      O => \^txcomplex_i\(11)
    );
\txComplex_o[11]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][27]\,
      I1 => \txReg_reg_n_0_[18][27]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][27]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][27]\,
      O => \txComplex_o[11]_i_2_n_0\
    );
\txComplex_o[11]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][27]\,
      I1 => \txReg_reg_n_0_[10][27]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][27]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][27]\,
      O => \txComplex_o[11]_i_5_n_0\
    );
\txComplex_o[11]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][27]\,
      I1 => \txReg_reg_n_0_[14][27]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][27]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][27]\,
      O => \txComplex_o[11]_i_6_n_0\
    );
\txComplex_o[11]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][27]\,
      I1 => \txReg_reg_n_0_[2][27]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][27]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][27]\,
      O => \txComplex_o[11]_i_7_n_0\
    );
\txComplex_o[11]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][27]\,
      I1 => \txReg_reg_n_0_[6][27]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][27]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][27]\,
      O => \txComplex_o[11]_i_8_n_0\
    );
\txComplex_o[12]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txComplex_o[12]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txComplex_o_reg[12]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txComplex_o_reg[12]_i_4_n_0\,
      O => \^txcomplex_i\(12)
    );
\txComplex_o[12]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][28]\,
      I1 => \txReg_reg_n_0_[18][28]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][28]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][28]\,
      O => \txComplex_o[12]_i_2_n_0\
    );
\txComplex_o[12]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][28]\,
      I1 => \txReg_reg_n_0_[10][28]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][28]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][28]\,
      O => \txComplex_o[12]_i_5_n_0\
    );
\txComplex_o[12]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][28]\,
      I1 => \txReg_reg_n_0_[14][28]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][28]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][28]\,
      O => \txComplex_o[12]_i_6_n_0\
    );
\txComplex_o[12]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][28]\,
      I1 => \txReg_reg_n_0_[2][28]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][28]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][28]\,
      O => \txComplex_o[12]_i_7_n_0\
    );
\txComplex_o[12]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][28]\,
      I1 => \txReg_reg_n_0_[6][28]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][28]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][28]\,
      O => \txComplex_o[12]_i_8_n_0\
    );
\txComplex_o[13]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txComplex_o[13]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txComplex_o_reg[13]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txComplex_o_reg[13]_i_4_n_0\,
      O => \^txcomplex_i\(13)
    );
\txComplex_o[13]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][29]\,
      I1 => \txReg_reg_n_0_[18][29]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][29]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][29]\,
      O => \txComplex_o[13]_i_2_n_0\
    );
\txComplex_o[13]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][29]\,
      I1 => \txReg_reg_n_0_[10][29]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][29]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][29]\,
      O => \txComplex_o[13]_i_5_n_0\
    );
\txComplex_o[13]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][29]\,
      I1 => \txReg_reg_n_0_[14][29]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][29]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][29]\,
      O => \txComplex_o[13]_i_6_n_0\
    );
\txComplex_o[13]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][29]\,
      I1 => \txReg_reg_n_0_[2][29]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][29]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][29]\,
      O => \txComplex_o[13]_i_7_n_0\
    );
\txComplex_o[13]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][29]\,
      I1 => \txReg_reg_n_0_[6][29]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][29]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][29]\,
      O => \txComplex_o[13]_i_8_n_0\
    );
\txComplex_o[14]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txComplex_o[14]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txComplex_o_reg[14]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txComplex_o_reg[14]_i_4_n_0\,
      O => \^txcomplex_i\(14)
    );
\txComplex_o[14]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][30]\,
      I1 => \txReg_reg_n_0_[18][30]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][30]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][30]\,
      O => \txComplex_o[14]_i_2_n_0\
    );
\txComplex_o[14]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][30]\,
      I1 => \txReg_reg_n_0_[10][30]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][30]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][30]\,
      O => \txComplex_o[14]_i_5_n_0\
    );
\txComplex_o[14]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][30]\,
      I1 => \txReg_reg_n_0_[14][30]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][30]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][30]\,
      O => \txComplex_o[14]_i_6_n_0\
    );
\txComplex_o[14]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][30]\,
      I1 => \txReg_reg_n_0_[2][30]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][30]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][30]\,
      O => \txComplex_o[14]_i_7_n_0\
    );
\txComplex_o[14]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][30]\,
      I1 => \txReg_reg_n_0_[6][30]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][30]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][30]\,
      O => \txComplex_o[14]_i_8_n_0\
    );
\txComplex_o[15]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txComplex_o[15]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txComplex_o_reg[15]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txComplex_o_reg[15]_i_4_n_0\,
      O => \^txcomplex_i\(15)
    );
\txComplex_o[15]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][31]\,
      I1 => \txReg_reg_n_0_[18][31]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][31]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][31]\,
      O => \txComplex_o[15]_i_2_n_0\
    );
\txComplex_o[15]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][31]\,
      I1 => \txReg_reg_n_0_[10][31]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][31]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][31]\,
      O => \txComplex_o[15]_i_5_n_0\
    );
\txComplex_o[15]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][31]\,
      I1 => \txReg_reg_n_0_[14][31]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][31]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][31]\,
      O => \txComplex_o[15]_i_6_n_0\
    );
\txComplex_o[15]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][31]\,
      I1 => \txReg_reg_n_0_[2][31]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][31]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][31]\,
      O => \txComplex_o[15]_i_7_n_0\
    );
\txComplex_o[15]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][31]\,
      I1 => \txReg_reg_n_0_[6][31]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][31]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][31]\,
      O => \txComplex_o[15]_i_8_n_0\
    );
\txComplex_o[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txComplex_o[1]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txComplex_o_reg[1]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txComplex_o_reg[1]_i_4_n_0\,
      O => \^txcomplex_i\(1)
    );
\txComplex_o[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][17]\,
      I1 => \txReg_reg_n_0_[18][17]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][17]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][17]\,
      O => \txComplex_o[1]_i_2_n_0\
    );
\txComplex_o[1]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][17]\,
      I1 => \txReg_reg_n_0_[10][17]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][17]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][17]\,
      O => \txComplex_o[1]_i_5_n_0\
    );
\txComplex_o[1]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][17]\,
      I1 => \txReg_reg_n_0_[14][17]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][17]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][17]\,
      O => \txComplex_o[1]_i_6_n_0\
    );
\txComplex_o[1]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][17]\,
      I1 => \txReg_reg_n_0_[2][17]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][17]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][17]\,
      O => \txComplex_o[1]_i_7_n_0\
    );
\txComplex_o[1]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][17]\,
      I1 => \txReg_reg_n_0_[6][17]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][17]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][17]\,
      O => \txComplex_o[1]_i_8_n_0\
    );
\txComplex_o[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txComplex_o[2]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txComplex_o_reg[2]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txComplex_o_reg[2]_i_4_n_0\,
      O => \^txcomplex_i\(2)
    );
\txComplex_o[2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][18]\,
      I1 => \txReg_reg_n_0_[18][18]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][18]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][18]\,
      O => \txComplex_o[2]_i_2_n_0\
    );
\txComplex_o[2]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][18]\,
      I1 => \txReg_reg_n_0_[10][18]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][18]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][18]\,
      O => \txComplex_o[2]_i_5_n_0\
    );
\txComplex_o[2]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][18]\,
      I1 => \txReg_reg_n_0_[14][18]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][18]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][18]\,
      O => \txComplex_o[2]_i_6_n_0\
    );
\txComplex_o[2]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][18]\,
      I1 => \txReg_reg_n_0_[2][18]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][18]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][18]\,
      O => \txComplex_o[2]_i_7_n_0\
    );
\txComplex_o[2]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][18]\,
      I1 => \txReg_reg_n_0_[6][18]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][18]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][18]\,
      O => \txComplex_o[2]_i_8_n_0\
    );
\txComplex_o[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txComplex_o[3]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txComplex_o_reg[3]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txComplex_o_reg[3]_i_4_n_0\,
      O => \^txcomplex_i\(3)
    );
\txComplex_o[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][19]\,
      I1 => \txReg_reg_n_0_[18][19]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][19]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][19]\,
      O => \txComplex_o[3]_i_2_n_0\
    );
\txComplex_o[3]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][19]\,
      I1 => \txReg_reg_n_0_[10][19]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][19]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][19]\,
      O => \txComplex_o[3]_i_5_n_0\
    );
\txComplex_o[3]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][19]\,
      I1 => \txReg_reg_n_0_[14][19]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][19]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][19]\,
      O => \txComplex_o[3]_i_6_n_0\
    );
\txComplex_o[3]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][19]\,
      I1 => \txReg_reg_n_0_[2][19]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][19]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][19]\,
      O => \txComplex_o[3]_i_7_n_0\
    );
\txComplex_o[3]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][19]\,
      I1 => \txReg_reg_n_0_[6][19]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][19]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][19]\,
      O => \txComplex_o[3]_i_8_n_0\
    );
\txComplex_o[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txComplex_o[4]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txComplex_o_reg[4]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txComplex_o_reg[4]_i_4_n_0\,
      O => \^txcomplex_i\(4)
    );
\txComplex_o[4]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][20]\,
      I1 => \txReg_reg_n_0_[18][20]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][20]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][20]\,
      O => \txComplex_o[4]_i_2_n_0\
    );
\txComplex_o[4]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][20]\,
      I1 => \txReg_reg_n_0_[10][20]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][20]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][20]\,
      O => \txComplex_o[4]_i_5_n_0\
    );
\txComplex_o[4]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][20]\,
      I1 => \txReg_reg_n_0_[14][20]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][20]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][20]\,
      O => \txComplex_o[4]_i_6_n_0\
    );
\txComplex_o[4]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][20]\,
      I1 => \txReg_reg_n_0_[2][20]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][20]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][20]\,
      O => \txComplex_o[4]_i_7_n_0\
    );
\txComplex_o[4]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][20]\,
      I1 => \txReg_reg_n_0_[6][20]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][20]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][20]\,
      O => \txComplex_o[4]_i_8_n_0\
    );
\txComplex_o[5]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txComplex_o[5]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txComplex_o_reg[5]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txComplex_o_reg[5]_i_4_n_0\,
      O => \^txcomplex_i\(5)
    );
\txComplex_o[5]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][21]\,
      I1 => \txReg_reg_n_0_[18][21]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][21]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][21]\,
      O => \txComplex_o[5]_i_2_n_0\
    );
\txComplex_o[5]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][21]\,
      I1 => \txReg_reg_n_0_[10][21]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][21]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][21]\,
      O => \txComplex_o[5]_i_5_n_0\
    );
\txComplex_o[5]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][21]\,
      I1 => \txReg_reg_n_0_[14][21]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][21]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][21]\,
      O => \txComplex_o[5]_i_6_n_0\
    );
\txComplex_o[5]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][21]\,
      I1 => \txReg_reg_n_0_[2][21]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][21]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][21]\,
      O => \txComplex_o[5]_i_7_n_0\
    );
\txComplex_o[5]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][21]\,
      I1 => \txReg_reg_n_0_[6][21]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][21]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][21]\,
      O => \txComplex_o[5]_i_8_n_0\
    );
\txComplex_o[6]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txComplex_o[6]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txComplex_o_reg[6]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txComplex_o_reg[6]_i_4_n_0\,
      O => \^txcomplex_i\(6)
    );
\txComplex_o[6]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][22]\,
      I1 => \txReg_reg_n_0_[18][22]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][22]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][22]\,
      O => \txComplex_o[6]_i_2_n_0\
    );
\txComplex_o[6]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][22]\,
      I1 => \txReg_reg_n_0_[10][22]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][22]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][22]\,
      O => \txComplex_o[6]_i_5_n_0\
    );
\txComplex_o[6]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][22]\,
      I1 => \txReg_reg_n_0_[14][22]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][22]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][22]\,
      O => \txComplex_o[6]_i_6_n_0\
    );
\txComplex_o[6]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][22]\,
      I1 => \txReg_reg_n_0_[2][22]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][22]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][22]\,
      O => \txComplex_o[6]_i_7_n_0\
    );
\txComplex_o[6]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][22]\,
      I1 => \txReg_reg_n_0_[6][22]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][22]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][22]\,
      O => \txComplex_o[6]_i_8_n_0\
    );
\txComplex_o[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txComplex_o[7]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txComplex_o_reg[7]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txComplex_o_reg[7]_i_4_n_0\,
      O => \^txcomplex_i\(7)
    );
\txComplex_o[7]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][23]\,
      I1 => \txReg_reg_n_0_[18][23]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][23]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][23]\,
      O => \txComplex_o[7]_i_2_n_0\
    );
\txComplex_o[7]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][23]\,
      I1 => \txReg_reg_n_0_[10][23]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][23]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][23]\,
      O => \txComplex_o[7]_i_5_n_0\
    );
\txComplex_o[7]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][23]\,
      I1 => \txReg_reg_n_0_[14][23]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][23]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][23]\,
      O => \txComplex_o[7]_i_6_n_0\
    );
\txComplex_o[7]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][23]\,
      I1 => \txReg_reg_n_0_[2][23]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][23]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][23]\,
      O => \txComplex_o[7]_i_7_n_0\
    );
\txComplex_o[7]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][23]\,
      I1 => \txReg_reg_n_0_[6][23]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][23]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][23]\,
      O => \txComplex_o[7]_i_8_n_0\
    );
\txComplex_o[8]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txComplex_o[8]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txComplex_o_reg[8]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txComplex_o_reg[8]_i_4_n_0\,
      O => \^txcomplex_i\(8)
    );
\txComplex_o[8]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][24]\,
      I1 => \txReg_reg_n_0_[18][24]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][24]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][24]\,
      O => \txComplex_o[8]_i_2_n_0\
    );
\txComplex_o[8]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][24]\,
      I1 => \txReg_reg_n_0_[10][24]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][24]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][24]\,
      O => \txComplex_o[8]_i_5_n_0\
    );
\txComplex_o[8]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][24]\,
      I1 => \txReg_reg_n_0_[14][24]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][24]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][24]\,
      O => \txComplex_o[8]_i_6_n_0\
    );
\txComplex_o[8]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][24]\,
      I1 => \txReg_reg_n_0_[2][24]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][24]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][24]\,
      O => \txComplex_o[8]_i_7_n_0\
    );
\txComplex_o[8]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][24]\,
      I1 => \txReg_reg_n_0_[6][24]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][24]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][24]\,
      O => \txComplex_o[8]_i_8_n_0\
    );
\txComplex_o[9]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txComplex_o[9]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txComplex_o_reg[9]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txComplex_o_reg[9]_i_4_n_0\,
      O => \^txcomplex_i\(9)
    );
\txComplex_o[9]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][25]\,
      I1 => \txReg_reg_n_0_[18][25]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][25]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][25]\,
      O => \txComplex_o[9]_i_2_n_0\
    );
\txComplex_o[9]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][25]\,
      I1 => \txReg_reg_n_0_[10][25]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][25]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][25]\,
      O => \txComplex_o[9]_i_5_n_0\
    );
\txComplex_o[9]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][25]\,
      I1 => \txReg_reg_n_0_[14][25]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][25]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][25]\,
      O => \txComplex_o[9]_i_6_n_0\
    );
\txComplex_o[9]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][25]\,
      I1 => \txReg_reg_n_0_[2][25]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][25]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][25]\,
      O => \txComplex_o[9]_i_7_n_0\
    );
\txComplex_o[9]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][25]\,
      I1 => \txReg_reg_n_0_[6][25]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][25]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][25]\,
      O => \txComplex_o[9]_i_8_n_0\
    );
\txComplex_o_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txcomplex_i\(0),
      Q => \txComplex_o_reg[15]_0\(0),
      R => '0'
    );
\txComplex_o_reg[0]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[0]_i_5_n_0\,
      I1 => \txComplex_o[0]_i_6_n_0\,
      O => \txComplex_o_reg[0]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[0]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[0]_i_7_n_0\,
      I1 => \txComplex_o[0]_i_8_n_0\,
      O => \txComplex_o_reg[0]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txcomplex_i\(10),
      Q => \txComplex_o_reg[15]_0\(10),
      R => '0'
    );
\txComplex_o_reg[10]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[10]_i_5_n_0\,
      I1 => \txComplex_o[10]_i_6_n_0\,
      O => \txComplex_o_reg[10]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[10]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[10]_i_7_n_0\,
      I1 => \txComplex_o[10]_i_8_n_0\,
      O => \txComplex_o_reg[10]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txcomplex_i\(11),
      Q => \txComplex_o_reg[15]_0\(11),
      R => '0'
    );
\txComplex_o_reg[11]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[11]_i_5_n_0\,
      I1 => \txComplex_o[11]_i_6_n_0\,
      O => \txComplex_o_reg[11]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[11]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[11]_i_7_n_0\,
      I1 => \txComplex_o[11]_i_8_n_0\,
      O => \txComplex_o_reg[11]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txcomplex_i\(12),
      Q => \txComplex_o_reg[15]_0\(12),
      R => '0'
    );
\txComplex_o_reg[12]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[12]_i_5_n_0\,
      I1 => \txComplex_o[12]_i_6_n_0\,
      O => \txComplex_o_reg[12]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[12]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[12]_i_7_n_0\,
      I1 => \txComplex_o[12]_i_8_n_0\,
      O => \txComplex_o_reg[12]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txcomplex_i\(13),
      Q => \txComplex_o_reg[15]_0\(13),
      R => '0'
    );
\txComplex_o_reg[13]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[13]_i_5_n_0\,
      I1 => \txComplex_o[13]_i_6_n_0\,
      O => \txComplex_o_reg[13]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[13]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[13]_i_7_n_0\,
      I1 => \txComplex_o[13]_i_8_n_0\,
      O => \txComplex_o_reg[13]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txcomplex_i\(14),
      Q => \txComplex_o_reg[15]_0\(14),
      R => '0'
    );
\txComplex_o_reg[14]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[14]_i_5_n_0\,
      I1 => \txComplex_o[14]_i_6_n_0\,
      O => \txComplex_o_reg[14]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[14]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[14]_i_7_n_0\,
      I1 => \txComplex_o[14]_i_8_n_0\,
      O => \txComplex_o_reg[14]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txcomplex_i\(15),
      Q => \txComplex_o_reg[15]_0\(15),
      R => '0'
    );
\txComplex_o_reg[15]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[15]_i_5_n_0\,
      I1 => \txComplex_o[15]_i_6_n_0\,
      O => \txComplex_o_reg[15]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[15]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[15]_i_7_n_0\,
      I1 => \txComplex_o[15]_i_8_n_0\,
      O => \txComplex_o_reg[15]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txcomplex_i\(1),
      Q => \txComplex_o_reg[15]_0\(1),
      R => '0'
    );
\txComplex_o_reg[1]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[1]_i_5_n_0\,
      I1 => \txComplex_o[1]_i_6_n_0\,
      O => \txComplex_o_reg[1]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[1]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[1]_i_7_n_0\,
      I1 => \txComplex_o[1]_i_8_n_0\,
      O => \txComplex_o_reg[1]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txcomplex_i\(2),
      Q => \txComplex_o_reg[15]_0\(2),
      R => '0'
    );
\txComplex_o_reg[2]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[2]_i_5_n_0\,
      I1 => \txComplex_o[2]_i_6_n_0\,
      O => \txComplex_o_reg[2]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[2]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[2]_i_7_n_0\,
      I1 => \txComplex_o[2]_i_8_n_0\,
      O => \txComplex_o_reg[2]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txcomplex_i\(3),
      Q => \txComplex_o_reg[15]_0\(3),
      R => '0'
    );
\txComplex_o_reg[3]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[3]_i_5_n_0\,
      I1 => \txComplex_o[3]_i_6_n_0\,
      O => \txComplex_o_reg[3]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[3]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[3]_i_7_n_0\,
      I1 => \txComplex_o[3]_i_8_n_0\,
      O => \txComplex_o_reg[3]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txcomplex_i\(4),
      Q => \txComplex_o_reg[15]_0\(4),
      R => '0'
    );
\txComplex_o_reg[4]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[4]_i_5_n_0\,
      I1 => \txComplex_o[4]_i_6_n_0\,
      O => \txComplex_o_reg[4]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[4]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[4]_i_7_n_0\,
      I1 => \txComplex_o[4]_i_8_n_0\,
      O => \txComplex_o_reg[4]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txcomplex_i\(5),
      Q => \txComplex_o_reg[15]_0\(5),
      R => '0'
    );
\txComplex_o_reg[5]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[5]_i_5_n_0\,
      I1 => \txComplex_o[5]_i_6_n_0\,
      O => \txComplex_o_reg[5]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[5]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[5]_i_7_n_0\,
      I1 => \txComplex_o[5]_i_8_n_0\,
      O => \txComplex_o_reg[5]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txcomplex_i\(6),
      Q => \txComplex_o_reg[15]_0\(6),
      R => '0'
    );
\txComplex_o_reg[6]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[6]_i_5_n_0\,
      I1 => \txComplex_o[6]_i_6_n_0\,
      O => \txComplex_o_reg[6]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[6]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[6]_i_7_n_0\,
      I1 => \txComplex_o[6]_i_8_n_0\,
      O => \txComplex_o_reg[6]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txcomplex_i\(7),
      Q => \txComplex_o_reg[15]_0\(7),
      R => '0'
    );
\txComplex_o_reg[7]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[7]_i_5_n_0\,
      I1 => \txComplex_o[7]_i_6_n_0\,
      O => \txComplex_o_reg[7]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[7]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[7]_i_7_n_0\,
      I1 => \txComplex_o[7]_i_8_n_0\,
      O => \txComplex_o_reg[7]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txcomplex_i\(8),
      Q => \txComplex_o_reg[15]_0\(8),
      R => '0'
    );
\txComplex_o_reg[8]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[8]_i_5_n_0\,
      I1 => \txComplex_o[8]_i_6_n_0\,
      O => \txComplex_o_reg[8]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[8]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[8]_i_7_n_0\,
      I1 => \txComplex_o[8]_i_8_n_0\,
      O => \txComplex_o_reg[8]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txcomplex_i\(9),
      Q => \txComplex_o_reg[15]_0\(9),
      R => '0'
    );
\txComplex_o_reg[9]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[9]_i_5_n_0\,
      I1 => \txComplex_o[9]_i_6_n_0\,
      O => \txComplex_o_reg[9]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txComplex_o_reg[9]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txComplex_o[9]_i_7_n_0\,
      I1 => \txComplex_o[9]_i_8_n_0\,
      O => \txComplex_o_reg[9]_i_4_n_0\,
      S => txPtr_reg(2)
    );
txLoaded_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => txLoading_reg_n_0,
      I1 => txLoading5_out,
      O => txLoaded_i_1_n_0
    );
txLoaded_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => txLoading_i_1_n_0,
      CLR => \^aresetn_0\,
      D => txLoaded_i_1_n_0,
      Q => txLoaded_reg_n_0
    );
txLoading_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"ABAAAAAAAAAAAAAA"
    )
        port map (
      I0 => txLoading5_out,
      I1 => txPtr_reg(3),
      I2 => txPtr_reg(2),
      I3 => txPtr_reg(4),
      I4 => txLoading_reg_n_0,
      I5 => txLoading_i_3_n_0,
      O => txLoading_i_1_n_0
    );
txLoading_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"45400000"
    )
        port map (
      I0 => doneFlag_i_3_n_0,
      I1 => wDataHold(0),
      I2 => wHold_reg_n_0,
      I3 => s_axi_wdata(0),
      I4 => doneFlag_i_2_n_0,
      O => txLoading5_out
    );
txLoading_i_3: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => txPtr_reg(1),
      I1 => txPtr_reg(0),
      O => txLoading_i_3_n_0
    );
txLoading_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => txLoading_i_1_n_0,
      CLR => \^aresetn_0\,
      D => txLoading5_out,
      Q => txLoading_reg_n_0
    );
\txPtr[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => txPtr_reg(0),
      I1 => txLoading5_out,
      O => \p_0_in__0\(0)
    );
\txPtr[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => txPtr_reg(0),
      I1 => txPtr_reg(1),
      I2 => txLoading5_out,
      O => \p_0_in__0\(1)
    );
\txPtr[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0078"
    )
        port map (
      I0 => txPtr_reg(1),
      I1 => txPtr_reg(0),
      I2 => txPtr_reg(2),
      I3 => txLoading5_out,
      O => \p_0_in__0\(2)
    );
\txPtr[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00007F80"
    )
        port map (
      I0 => txPtr_reg(0),
      I1 => txPtr_reg(1),
      I2 => txPtr_reg(2),
      I3 => txPtr_reg(3),
      I4 => txLoading5_out,
      O => \p_0_in__0\(3)
    );
\txPtr[4]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => txLoading_reg_n_0,
      I1 => txLoading5_out,
      O => \txPtr[4]_i_1_n_0\
    );
\txPtr[4]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000007FFF8000"
    )
        port map (
      I0 => txPtr_reg(3),
      I1 => txPtr_reg(2),
      I2 => txPtr_reg(1),
      I3 => txPtr_reg(0),
      I4 => txPtr_reg(4),
      I5 => txLoading5_out,
      O => \p_0_in__0\(4)
    );
\txPtr_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txPtr[4]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \p_0_in__0\(0),
      Q => txPtr_reg(0)
    );
\txPtr_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txPtr[4]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \p_0_in__0\(1),
      Q => txPtr_reg(1)
    );
\txPtr_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txPtr[4]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \p_0_in__0\(2),
      Q => txPtr_reg(2)
    );
\txPtr_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txPtr[4]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \p_0_in__0\(3),
      Q => txPtr_reg(3)
    );
\txPtr_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txPtr[4]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \p_0_in__0\(4),
      Q => txPtr_reg(4)
    );
\txReel_o[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txReel_o[0]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txReel_o_reg[0]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txReel_o_reg[0]_i_4_n_0\,
      O => \^txreel_i\(0)
    );
\txReel_o[0]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][0]\,
      I1 => \txReg_reg_n_0_[18][0]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][0]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][0]\,
      O => \txReel_o[0]_i_2_n_0\
    );
\txReel_o[0]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][0]\,
      I1 => \txReg_reg_n_0_[10][0]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][0]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][0]\,
      O => \txReel_o[0]_i_5_n_0\
    );
\txReel_o[0]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][0]\,
      I1 => \txReg_reg_n_0_[14][0]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][0]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][0]\,
      O => \txReel_o[0]_i_6_n_0\
    );
\txReel_o[0]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][0]\,
      I1 => \txReg_reg_n_0_[2][0]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][0]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][0]\,
      O => \txReel_o[0]_i_7_n_0\
    );
\txReel_o[0]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][0]\,
      I1 => \txReg_reg_n_0_[6][0]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][0]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][0]\,
      O => \txReel_o[0]_i_8_n_0\
    );
\txReel_o[10]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txReel_o[10]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txReel_o_reg[10]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txReel_o_reg[10]_i_4_n_0\,
      O => \^txreel_i\(10)
    );
\txReel_o[10]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][10]\,
      I1 => \txReg_reg_n_0_[18][10]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][10]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][10]\,
      O => \txReel_o[10]_i_2_n_0\
    );
\txReel_o[10]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][10]\,
      I1 => \txReg_reg_n_0_[10][10]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][10]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][10]\,
      O => \txReel_o[10]_i_5_n_0\
    );
\txReel_o[10]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][10]\,
      I1 => \txReg_reg_n_0_[14][10]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][10]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][10]\,
      O => \txReel_o[10]_i_6_n_0\
    );
\txReel_o[10]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][10]\,
      I1 => \txReg_reg_n_0_[2][10]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][10]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][10]\,
      O => \txReel_o[10]_i_7_n_0\
    );
\txReel_o[10]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][10]\,
      I1 => \txReg_reg_n_0_[6][10]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][10]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][10]\,
      O => \txReel_o[10]_i_8_n_0\
    );
\txReel_o[11]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txReel_o[11]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txReel_o_reg[11]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txReel_o_reg[11]_i_4_n_0\,
      O => \^txreel_i\(11)
    );
\txReel_o[11]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][11]\,
      I1 => \txReg_reg_n_0_[18][11]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][11]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][11]\,
      O => \txReel_o[11]_i_2_n_0\
    );
\txReel_o[11]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][11]\,
      I1 => \txReg_reg_n_0_[10][11]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][11]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][11]\,
      O => \txReel_o[11]_i_5_n_0\
    );
\txReel_o[11]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][11]\,
      I1 => \txReg_reg_n_0_[14][11]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][11]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][11]\,
      O => \txReel_o[11]_i_6_n_0\
    );
\txReel_o[11]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][11]\,
      I1 => \txReg_reg_n_0_[2][11]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][11]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][11]\,
      O => \txReel_o[11]_i_7_n_0\
    );
\txReel_o[11]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][11]\,
      I1 => \txReg_reg_n_0_[6][11]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][11]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][11]\,
      O => \txReel_o[11]_i_8_n_0\
    );
\txReel_o[12]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txReel_o[12]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txReel_o_reg[12]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txReel_o_reg[12]_i_4_n_0\,
      O => \^txreel_i\(12)
    );
\txReel_o[12]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][12]\,
      I1 => \txReg_reg_n_0_[18][12]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][12]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][12]\,
      O => \txReel_o[12]_i_2_n_0\
    );
\txReel_o[12]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][12]\,
      I1 => \txReg_reg_n_0_[10][12]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][12]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][12]\,
      O => \txReel_o[12]_i_5_n_0\
    );
\txReel_o[12]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][12]\,
      I1 => \txReg_reg_n_0_[14][12]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][12]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][12]\,
      O => \txReel_o[12]_i_6_n_0\
    );
\txReel_o[12]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][12]\,
      I1 => \txReg_reg_n_0_[2][12]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][12]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][12]\,
      O => \txReel_o[12]_i_7_n_0\
    );
\txReel_o[12]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][12]\,
      I1 => \txReg_reg_n_0_[6][12]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][12]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][12]\,
      O => \txReel_o[12]_i_8_n_0\
    );
\txReel_o[13]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txReel_o[13]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txReel_o_reg[13]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txReel_o_reg[13]_i_4_n_0\,
      O => \^txreel_i\(13)
    );
\txReel_o[13]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][13]\,
      I1 => \txReg_reg_n_0_[18][13]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][13]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][13]\,
      O => \txReel_o[13]_i_2_n_0\
    );
\txReel_o[13]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][13]\,
      I1 => \txReg_reg_n_0_[10][13]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][13]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][13]\,
      O => \txReel_o[13]_i_5_n_0\
    );
\txReel_o[13]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][13]\,
      I1 => \txReg_reg_n_0_[14][13]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][13]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][13]\,
      O => \txReel_o[13]_i_6_n_0\
    );
\txReel_o[13]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][13]\,
      I1 => \txReg_reg_n_0_[2][13]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][13]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][13]\,
      O => \txReel_o[13]_i_7_n_0\
    );
\txReel_o[13]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][13]\,
      I1 => \txReg_reg_n_0_[6][13]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][13]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][13]\,
      O => \txReel_o[13]_i_8_n_0\
    );
\txReel_o[14]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txReel_o[14]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txReel_o_reg[14]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txReel_o_reg[14]_i_4_n_0\,
      O => \^txreel_i\(14)
    );
\txReel_o[14]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][14]\,
      I1 => \txReg_reg_n_0_[18][14]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][14]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][14]\,
      O => \txReel_o[14]_i_2_n_0\
    );
\txReel_o[14]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][14]\,
      I1 => \txReg_reg_n_0_[10][14]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][14]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][14]\,
      O => \txReel_o[14]_i_5_n_0\
    );
\txReel_o[14]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][14]\,
      I1 => \txReg_reg_n_0_[14][14]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][14]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][14]\,
      O => \txReel_o[14]_i_6_n_0\
    );
\txReel_o[14]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][14]\,
      I1 => \txReg_reg_n_0_[2][14]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][14]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][14]\,
      O => \txReel_o[14]_i_7_n_0\
    );
\txReel_o[14]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][14]\,
      I1 => \txReg_reg_n_0_[6][14]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][14]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][14]\,
      O => \txReel_o[14]_i_8_n_0\
    );
\txReel_o[15]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txReel_o[15]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txReel_o_reg[15]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txReel_o_reg[15]_i_4_n_0\,
      O => \^txreel_i\(15)
    );
\txReel_o[15]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][15]\,
      I1 => \txReg_reg_n_0_[18][15]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][15]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][15]\,
      O => \txReel_o[15]_i_2_n_0\
    );
\txReel_o[15]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][15]\,
      I1 => \txReg_reg_n_0_[10][15]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][15]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][15]\,
      O => \txReel_o[15]_i_5_n_0\
    );
\txReel_o[15]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][15]\,
      I1 => \txReg_reg_n_0_[14][15]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][15]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][15]\,
      O => \txReel_o[15]_i_6_n_0\
    );
\txReel_o[15]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][15]\,
      I1 => \txReg_reg_n_0_[2][15]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][15]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][15]\,
      O => \txReel_o[15]_i_7_n_0\
    );
\txReel_o[15]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][15]\,
      I1 => \txReg_reg_n_0_[6][15]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][15]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][15]\,
      O => \txReel_o[15]_i_8_n_0\
    );
\txReel_o[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txReel_o[1]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txReel_o_reg[1]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txReel_o_reg[1]_i_4_n_0\,
      O => \^txreel_i\(1)
    );
\txReel_o[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][1]\,
      I1 => \txReg_reg_n_0_[18][1]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][1]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][1]\,
      O => \txReel_o[1]_i_2_n_0\
    );
\txReel_o[1]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][1]\,
      I1 => \txReg_reg_n_0_[10][1]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][1]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][1]\,
      O => \txReel_o[1]_i_5_n_0\
    );
\txReel_o[1]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][1]\,
      I1 => \txReg_reg_n_0_[14][1]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][1]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][1]\,
      O => \txReel_o[1]_i_6_n_0\
    );
\txReel_o[1]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][1]\,
      I1 => \txReg_reg_n_0_[2][1]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][1]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][1]\,
      O => \txReel_o[1]_i_7_n_0\
    );
\txReel_o[1]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][1]\,
      I1 => \txReg_reg_n_0_[6][1]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][1]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][1]\,
      O => \txReel_o[1]_i_8_n_0\
    );
\txReel_o[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txReel_o[2]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txReel_o_reg[2]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txReel_o_reg[2]_i_4_n_0\,
      O => \^txreel_i\(2)
    );
\txReel_o[2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][2]\,
      I1 => \txReg_reg_n_0_[18][2]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][2]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][2]\,
      O => \txReel_o[2]_i_2_n_0\
    );
\txReel_o[2]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][2]\,
      I1 => \txReg_reg_n_0_[10][2]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][2]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][2]\,
      O => \txReel_o[2]_i_5_n_0\
    );
\txReel_o[2]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][2]\,
      I1 => \txReg_reg_n_0_[14][2]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][2]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][2]\,
      O => \txReel_o[2]_i_6_n_0\
    );
\txReel_o[2]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][2]\,
      I1 => \txReg_reg_n_0_[2][2]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][2]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][2]\,
      O => \txReel_o[2]_i_7_n_0\
    );
\txReel_o[2]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][2]\,
      I1 => \txReg_reg_n_0_[6][2]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][2]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][2]\,
      O => \txReel_o[2]_i_8_n_0\
    );
\txReel_o[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txReel_o[3]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txReel_o_reg[3]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txReel_o_reg[3]_i_4_n_0\,
      O => \^txreel_i\(3)
    );
\txReel_o[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][3]\,
      I1 => \txReg_reg_n_0_[18][3]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][3]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][3]\,
      O => \txReel_o[3]_i_2_n_0\
    );
\txReel_o[3]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][3]\,
      I1 => \txReg_reg_n_0_[10][3]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][3]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][3]\,
      O => \txReel_o[3]_i_5_n_0\
    );
\txReel_o[3]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][3]\,
      I1 => \txReg_reg_n_0_[14][3]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][3]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][3]\,
      O => \txReel_o[3]_i_6_n_0\
    );
\txReel_o[3]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][3]\,
      I1 => \txReg_reg_n_0_[2][3]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][3]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][3]\,
      O => \txReel_o[3]_i_7_n_0\
    );
\txReel_o[3]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][3]\,
      I1 => \txReg_reg_n_0_[6][3]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][3]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][3]\,
      O => \txReel_o[3]_i_8_n_0\
    );
\txReel_o[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txReel_o[4]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txReel_o_reg[4]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txReel_o_reg[4]_i_4_n_0\,
      O => \^txreel_i\(4)
    );
\txReel_o[4]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][4]\,
      I1 => \txReg_reg_n_0_[18][4]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][4]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][4]\,
      O => \txReel_o[4]_i_2_n_0\
    );
\txReel_o[4]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][4]\,
      I1 => \txReg_reg_n_0_[10][4]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][4]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][4]\,
      O => \txReel_o[4]_i_5_n_0\
    );
\txReel_o[4]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][4]\,
      I1 => \txReg_reg_n_0_[14][4]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][4]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][4]\,
      O => \txReel_o[4]_i_6_n_0\
    );
\txReel_o[4]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][4]\,
      I1 => \txReg_reg_n_0_[2][4]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][4]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][4]\,
      O => \txReel_o[4]_i_7_n_0\
    );
\txReel_o[4]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][4]\,
      I1 => \txReg_reg_n_0_[6][4]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][4]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][4]\,
      O => \txReel_o[4]_i_8_n_0\
    );
\txReel_o[5]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txReel_o[5]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txReel_o_reg[5]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txReel_o_reg[5]_i_4_n_0\,
      O => \^txreel_i\(5)
    );
\txReel_o[5]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][5]\,
      I1 => \txReg_reg_n_0_[18][5]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][5]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][5]\,
      O => \txReel_o[5]_i_2_n_0\
    );
\txReel_o[5]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][5]\,
      I1 => \txReg_reg_n_0_[10][5]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][5]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][5]\,
      O => \txReel_o[5]_i_5_n_0\
    );
\txReel_o[5]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][5]\,
      I1 => \txReg_reg_n_0_[14][5]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][5]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][5]\,
      O => \txReel_o[5]_i_6_n_0\
    );
\txReel_o[5]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][5]\,
      I1 => \txReg_reg_n_0_[2][5]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][5]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][5]\,
      O => \txReel_o[5]_i_7_n_0\
    );
\txReel_o[5]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][5]\,
      I1 => \txReg_reg_n_0_[6][5]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][5]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][5]\,
      O => \txReel_o[5]_i_8_n_0\
    );
\txReel_o[6]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txReel_o[6]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txReel_o_reg[6]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txReel_o_reg[6]_i_4_n_0\,
      O => \^txreel_i\(6)
    );
\txReel_o[6]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][6]\,
      I1 => \txReg_reg_n_0_[18][6]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][6]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][6]\,
      O => \txReel_o[6]_i_2_n_0\
    );
\txReel_o[6]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][6]\,
      I1 => \txReg_reg_n_0_[10][6]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][6]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][6]\,
      O => \txReel_o[6]_i_5_n_0\
    );
\txReel_o[6]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][6]\,
      I1 => \txReg_reg_n_0_[14][6]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][6]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][6]\,
      O => \txReel_o[6]_i_6_n_0\
    );
\txReel_o[6]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][6]\,
      I1 => \txReg_reg_n_0_[2][6]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][6]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][6]\,
      O => \txReel_o[6]_i_7_n_0\
    );
\txReel_o[6]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][6]\,
      I1 => \txReg_reg_n_0_[6][6]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][6]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][6]\,
      O => \txReel_o[6]_i_8_n_0\
    );
\txReel_o[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txReel_o[7]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txReel_o_reg[7]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txReel_o_reg[7]_i_4_n_0\,
      O => \^txreel_i\(7)
    );
\txReel_o[7]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][7]\,
      I1 => \txReg_reg_n_0_[18][7]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][7]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][7]\,
      O => \txReel_o[7]_i_2_n_0\
    );
\txReel_o[7]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][7]\,
      I1 => \txReg_reg_n_0_[10][7]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][7]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][7]\,
      O => \txReel_o[7]_i_5_n_0\
    );
\txReel_o[7]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][7]\,
      I1 => \txReg_reg_n_0_[14][7]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][7]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][7]\,
      O => \txReel_o[7]_i_6_n_0\
    );
\txReel_o[7]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][7]\,
      I1 => \txReg_reg_n_0_[2][7]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][7]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][7]\,
      O => \txReel_o[7]_i_7_n_0\
    );
\txReel_o[7]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][7]\,
      I1 => \txReg_reg_n_0_[6][7]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][7]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][7]\,
      O => \txReel_o[7]_i_8_n_0\
    );
\txReel_o[8]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txReel_o[8]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txReel_o_reg[8]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txReel_o_reg[8]_i_4_n_0\,
      O => \^txreel_i\(8)
    );
\txReel_o[8]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][8]\,
      I1 => \txReg_reg_n_0_[18][8]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][8]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][8]\,
      O => \txReel_o[8]_i_2_n_0\
    );
\txReel_o[8]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][8]\,
      I1 => \txReg_reg_n_0_[10][8]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][8]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][8]\,
      O => \txReel_o[8]_i_5_n_0\
    );
\txReel_o[8]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][8]\,
      I1 => \txReg_reg_n_0_[14][8]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][8]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][8]\,
      O => \txReel_o[8]_i_6_n_0\
    );
\txReel_o[8]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][8]\,
      I1 => \txReg_reg_n_0_[2][8]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][8]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][8]\,
      O => \txReel_o[8]_i_7_n_0\
    );
\txReel_o[8]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][8]\,
      I1 => \txReg_reg_n_0_[6][8]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][8]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][8]\,
      O => \txReel_o[8]_i_8_n_0\
    );
\txReel_o[9]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8BBB888"
    )
        port map (
      I0 => \txReel_o[9]_i_2_n_0\,
      I1 => txPtr_reg(4),
      I2 => \txReel_o_reg[9]_i_3_n_0\,
      I3 => txPtr_reg(3),
      I4 => \txReel_o_reg[9]_i_4_n_0\,
      O => \^txreel_i\(9)
    );
\txReel_o[9]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[19][9]\,
      I1 => \txReg_reg_n_0_[18][9]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[17][9]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[16][9]\,
      O => \txReel_o[9]_i_2_n_0\
    );
\txReel_o[9]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[11][9]\,
      I1 => \txReg_reg_n_0_[10][9]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[9][9]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[8][9]\,
      O => \txReel_o[9]_i_5_n_0\
    );
\txReel_o[9]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[15][9]\,
      I1 => \txReg_reg_n_0_[14][9]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[13][9]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[12][9]\,
      O => \txReel_o[9]_i_6_n_0\
    );
\txReel_o[9]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[3][9]\,
      I1 => \txReg_reg_n_0_[2][9]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[1][9]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[0][9]\,
      O => \txReel_o[9]_i_7_n_0\
    );
\txReel_o[9]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \txReg_reg_n_0_[7][9]\,
      I1 => \txReg_reg_n_0_[6][9]\,
      I2 => txPtr_reg(1),
      I3 => \txReg_reg_n_0_[5][9]\,
      I4 => txPtr_reg(0),
      I5 => \txReg_reg_n_0_[4][9]\,
      O => \txReel_o[9]_i_8_n_0\
    );
\txReel_o_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txreel_i\(0),
      Q => \txReel_o_reg[15]_0\(0),
      R => '0'
    );
\txReel_o_reg[0]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[0]_i_5_n_0\,
      I1 => \txReel_o[0]_i_6_n_0\,
      O => \txReel_o_reg[0]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[0]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[0]_i_7_n_0\,
      I1 => \txReel_o[0]_i_8_n_0\,
      O => \txReel_o_reg[0]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txreel_i\(10),
      Q => \txReel_o_reg[15]_0\(10),
      R => '0'
    );
\txReel_o_reg[10]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[10]_i_5_n_0\,
      I1 => \txReel_o[10]_i_6_n_0\,
      O => \txReel_o_reg[10]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[10]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[10]_i_7_n_0\,
      I1 => \txReel_o[10]_i_8_n_0\,
      O => \txReel_o_reg[10]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txreel_i\(11),
      Q => \txReel_o_reg[15]_0\(11),
      R => '0'
    );
\txReel_o_reg[11]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[11]_i_5_n_0\,
      I1 => \txReel_o[11]_i_6_n_0\,
      O => \txReel_o_reg[11]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[11]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[11]_i_7_n_0\,
      I1 => \txReel_o[11]_i_8_n_0\,
      O => \txReel_o_reg[11]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txreel_i\(12),
      Q => \txReel_o_reg[15]_0\(12),
      R => '0'
    );
\txReel_o_reg[12]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[12]_i_5_n_0\,
      I1 => \txReel_o[12]_i_6_n_0\,
      O => \txReel_o_reg[12]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[12]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[12]_i_7_n_0\,
      I1 => \txReel_o[12]_i_8_n_0\,
      O => \txReel_o_reg[12]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txreel_i\(13),
      Q => \txReel_o_reg[15]_0\(13),
      R => '0'
    );
\txReel_o_reg[13]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[13]_i_5_n_0\,
      I1 => \txReel_o[13]_i_6_n_0\,
      O => \txReel_o_reg[13]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[13]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[13]_i_7_n_0\,
      I1 => \txReel_o[13]_i_8_n_0\,
      O => \txReel_o_reg[13]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txreel_i\(14),
      Q => \txReel_o_reg[15]_0\(14),
      R => '0'
    );
\txReel_o_reg[14]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[14]_i_5_n_0\,
      I1 => \txReel_o[14]_i_6_n_0\,
      O => \txReel_o_reg[14]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[14]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[14]_i_7_n_0\,
      I1 => \txReel_o[14]_i_8_n_0\,
      O => \txReel_o_reg[14]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txreel_i\(15),
      Q => \txReel_o_reg[15]_0\(15),
      R => '0'
    );
\txReel_o_reg[15]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[15]_i_5_n_0\,
      I1 => \txReel_o[15]_i_6_n_0\,
      O => \txReel_o_reg[15]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[15]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[15]_i_7_n_0\,
      I1 => \txReel_o[15]_i_8_n_0\,
      O => \txReel_o_reg[15]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txreel_i\(1),
      Q => \txReel_o_reg[15]_0\(1),
      R => '0'
    );
\txReel_o_reg[1]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[1]_i_5_n_0\,
      I1 => \txReel_o[1]_i_6_n_0\,
      O => \txReel_o_reg[1]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[1]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[1]_i_7_n_0\,
      I1 => \txReel_o[1]_i_8_n_0\,
      O => \txReel_o_reg[1]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txreel_i\(2),
      Q => \txReel_o_reg[15]_0\(2),
      R => '0'
    );
\txReel_o_reg[2]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[2]_i_5_n_0\,
      I1 => \txReel_o[2]_i_6_n_0\,
      O => \txReel_o_reg[2]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[2]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[2]_i_7_n_0\,
      I1 => \txReel_o[2]_i_8_n_0\,
      O => \txReel_o_reg[2]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txreel_i\(3),
      Q => \txReel_o_reg[15]_0\(3),
      R => '0'
    );
\txReel_o_reg[3]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[3]_i_5_n_0\,
      I1 => \txReel_o[3]_i_6_n_0\,
      O => \txReel_o_reg[3]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[3]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[3]_i_7_n_0\,
      I1 => \txReel_o[3]_i_8_n_0\,
      O => \txReel_o_reg[3]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txreel_i\(4),
      Q => \txReel_o_reg[15]_0\(4),
      R => '0'
    );
\txReel_o_reg[4]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[4]_i_5_n_0\,
      I1 => \txReel_o[4]_i_6_n_0\,
      O => \txReel_o_reg[4]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[4]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[4]_i_7_n_0\,
      I1 => \txReel_o[4]_i_8_n_0\,
      O => \txReel_o_reg[4]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txreel_i\(5),
      Q => \txReel_o_reg[15]_0\(5),
      R => '0'
    );
\txReel_o_reg[5]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[5]_i_5_n_0\,
      I1 => \txReel_o[5]_i_6_n_0\,
      O => \txReel_o_reg[5]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[5]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[5]_i_7_n_0\,
      I1 => \txReel_o[5]_i_8_n_0\,
      O => \txReel_o_reg[5]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txreel_i\(6),
      Q => \txReel_o_reg[15]_0\(6),
      R => '0'
    );
\txReel_o_reg[6]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[6]_i_5_n_0\,
      I1 => \txReel_o[6]_i_6_n_0\,
      O => \txReel_o_reg[6]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[6]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[6]_i_7_n_0\,
      I1 => \txReel_o[6]_i_8_n_0\,
      O => \txReel_o_reg[6]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txreel_i\(7),
      Q => \txReel_o_reg[15]_0\(7),
      R => '0'
    );
\txReel_o_reg[7]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[7]_i_5_n_0\,
      I1 => \txReel_o[7]_i_6_n_0\,
      O => \txReel_o_reg[7]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[7]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[7]_i_7_n_0\,
      I1 => \txReel_o[7]_i_8_n_0\,
      O => \txReel_o_reg[7]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txreel_i\(8),
      Q => \txReel_o_reg[15]_0\(8),
      R => '0'
    );
\txReel_o_reg[8]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[8]_i_5_n_0\,
      I1 => \txReel_o[8]_i_6_n_0\,
      O => \txReel_o_reg[8]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[8]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[8]_i_7_n_0\,
      I1 => \txReel_o[8]_i_8_n_0\,
      O => \txReel_o_reg[8]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \^txreel_i\(9),
      Q => \txReel_o_reg[15]_0\(9),
      R => '0'
    );
\txReel_o_reg[9]_i_3\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[9]_i_5_n_0\,
      I1 => \txReel_o[9]_i_6_n_0\,
      O => \txReel_o_reg[9]_i_3_n_0\,
      S => txPtr_reg(2)
    );
\txReel_o_reg[9]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \txReel_o[9]_i_7_n_0\,
      I1 => \txReel_o[9]_i_8_n_0\,
      O => \txReel_o_reg[9]_i_4_n_0\,
      S => txPtr_reg(2)
    );
\txReg[0][16]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(16),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(16),
      O => \txReg[0][16]_i_1_n_0\
    );
\txReg[0][17]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(17),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(17),
      O => \txReg[0][17]_i_1_n_0\
    );
\txReg[0][18]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(18),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(18),
      O => \txReg[0][18]_i_1_n_0\
    );
\txReg[0][19]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(19),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(19),
      O => \txReg[0][19]_i_1_n_0\
    );
\txReg[0][20]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(20),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(20),
      O => \txReg[0][20]_i_1_n_0\
    );
\txReg[0][21]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(21),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(21),
      O => \txReg[0][21]_i_1_n_0\
    );
\txReg[0][22]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(22),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(22),
      O => \txReg[0][22]_i_1_n_0\
    );
\txReg[0][23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(23),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(23),
      O => \txReg[0][23]_i_1_n_0\
    );
\txReg[0][24]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(24),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(24),
      O => \txReg[0][24]_i_1_n_0\
    );
\txReg[0][25]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(25),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(25),
      O => \txReg[0][25]_i_1_n_0\
    );
\txReg[0][26]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(26),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(26),
      O => \txReg[0][26]_i_1_n_0\
    );
\txReg[0][27]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(27),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(27),
      O => \txReg[0][27]_i_1_n_0\
    );
\txReg[0][28]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(28),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(28),
      O => \txReg[0][28]_i_1_n_0\
    );
\txReg[0][29]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(29),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(29),
      O => \txReg[0][29]_i_1_n_0\
    );
\txReg[0][30]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(30),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(30),
      O => \txReg[0][30]_i_1_n_0\
    );
\txReg[0][31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"202A0000"
    )
        port map (
      I0 => \txReg[0][31]_i_3_n_0\,
      I1 => awAddrHold(4),
      I2 => awHold_reg_n_0,
      I3 => s_axi_awaddr(4),
      I4 => \txReg[0][31]_i_4_n_0\,
      O => \txReg[0][31]_i_1_n_0\
    );
\txReg[0][31]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => wDataHold(31),
      I1 => wHold_reg_n_0,
      I2 => s_axi_wdata(31),
      O => \txReg[0][31]_i_2_n_0\
    );
\txReg[0][31]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"02A2"
    )
        port map (
      I0 => \txReg[3][31]_i_2_n_0\,
      I1 => s_axi_awaddr(5),
      I2 => awHold_reg_n_0,
      I3 => awAddrHold(5),
      O => \txReg[0][31]_i_3_n_0\
    );
\txReg[0][31]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00053305"
    )
        port map (
      I0 => s_axi_awaddr(3),
      I1 => awAddrHold(3),
      I2 => s_axi_awaddr(2),
      I3 => awHold_reg_n_0,
      I4 => awAddrHold(2),
      O => \txReg[0][31]_i_4_n_0\
    );
\txReg[10][31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"47000000"
    )
        port map (
      I0 => awAddrHold(4),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(4),
      I3 => \cfarK_o[4]_i_3_n_0\,
      I4 => \txReg[8][31]_i_2_n_0\,
      O => \txReg[10][31]_i_1_n_0\
    );
\txReg[11][31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"202A0000"
    )
        port map (
      I0 => \txReg[8][31]_i_2_n_0\,
      I1 => awAddrHold(4),
      I2 => awHold_reg_n_0,
      I3 => s_axi_awaddr(4),
      I4 => \cfarAlpha_o[15]_i_3_n_0\,
      O => \txReg[11][31]_i_1_n_0\
    );
\txReg[12][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000440347"
    )
        port map (
      I0 => awAddrHold(2),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(2),
      I3 => awAddrHold(3),
      I4 => s_axi_awaddr(3),
      I5 => \txReg[12][31]_i_2_n_0\,
      O => \txReg[12][31]_i_1_n_0\
    );
\txReg[12][31]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1DFF"
    )
        port map (
      I0 => s_axi_awaddr(4),
      I1 => awHold_reg_n_0,
      I2 => awAddrHold(4),
      I3 => \txReg[8][31]_i_2_n_0\,
      O => \txReg[12][31]_i_2_n_0\
    );
\txReg[13][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000047034400"
    )
        port map (
      I0 => awAddrHold(3),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(3),
      I3 => awAddrHold(2),
      I4 => s_axi_awaddr(2),
      I5 => \txReg[12][31]_i_2_n_0\,
      O => \txReg[13][31]_i_1_n_0\
    );
\txReg[14][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000047034400"
    )
        port map (
      I0 => awAddrHold(2),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(2),
      I3 => awAddrHold(3),
      I4 => s_axi_awaddr(3),
      I5 => \txReg[12][31]_i_2_n_0\,
      O => \txReg[14][31]_i_1_n_0\
    );
\txReg[15][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000B8308800"
    )
        port map (
      I0 => awAddrHold(2),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(2),
      I3 => awAddrHold(3),
      I4 => s_axi_awaddr(3),
      I5 => \txReg[12][31]_i_2_n_0\,
      O => \txReg[15][31]_i_1_n_0\
    );
\txReg[16][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000440347"
    )
        port map (
      I0 => awAddrHold(2),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(2),
      I3 => awAddrHold(3),
      I4 => s_axi_awaddr(3),
      I5 => \txReg[16][31]_i_2_n_0\,
      O => \txReg[16][31]_i_1_n_0\
    );
\txReg[16][31]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FDFFFDFDFDFFFFFF"
    )
        port map (
      I0 => \txReg[16][31]_i_3_n_0\,
      I1 => doneFlag_i_4_n_0,
      I2 => \txReg[3][31]_i_3_n_0\,
      I3 => awAddrHold(6),
      I4 => awHold_reg_n_0,
      I5 => s_axi_awaddr(6),
      O => \txReg[16][31]_i_2_n_0\
    );
\txReg[16][31]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A808"
    )
        port map (
      I0 => wrFire,
      I1 => s_axi_awaddr(7),
      I2 => awHold_reg_n_0,
      I3 => awAddrHold(7),
      O => \txReg[16][31]_i_3_n_0\
    );
\txReg[17][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000047034400"
    )
        port map (
      I0 => awAddrHold(3),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(3),
      I3 => awAddrHold(2),
      I4 => s_axi_awaddr(2),
      I5 => \txReg[16][31]_i_2_n_0\,
      O => \txReg[17][31]_i_1_n_0\
    );
\txReg[18][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000047034400"
    )
        port map (
      I0 => awAddrHold(2),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(2),
      I3 => awAddrHold(3),
      I4 => s_axi_awaddr(3),
      I5 => \txReg[16][31]_i_2_n_0\,
      O => \txReg[18][31]_i_1_n_0\
    );
\txReg[19][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000000002A2"
    )
        port map (
      I0 => \cfarAlpha_o[15]_i_3_n_0\,
      I1 => s_axi_awaddr(5),
      I2 => awHold_reg_n_0,
      I3 => awAddrHold(5),
      I4 => \txReg[3][31]_i_3_n_0\,
      I5 => \txReg[16][31]_i_2_n_0\,
      O => \txReg[19][31]_i_1_n_0\
    );
\txReg[1][31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"202A0000"
    )
        port map (
      I0 => \txReg[0][31]_i_3_n_0\,
      I1 => awAddrHold(4),
      I2 => awHold_reg_n_0,
      I3 => s_axi_awaddr(4),
      I4 => \txReg[1][31]_i_2_n_0\,
      O => \txReg[1][31]_i_1_n_0\
    );
\txReg[1][31]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"000ACC0A"
    )
        port map (
      I0 => s_axi_awaddr(2),
      I1 => awAddrHold(2),
      I2 => s_axi_awaddr(3),
      I3 => awHold_reg_n_0,
      I4 => awAddrHold(3),
      O => \txReg[1][31]_i_2_n_0\
    );
\txReg[2][31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"202A0000"
    )
        port map (
      I0 => \txReg[0][31]_i_3_n_0\,
      I1 => awAddrHold(4),
      I2 => awHold_reg_n_0,
      I3 => s_axi_awaddr(4),
      I4 => \cfarK_o[4]_i_3_n_0\,
      O => \txReg[2][31]_i_1_n_0\
    );
\txReg[3][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000088808"
    )
        port map (
      I0 => \txReg[3][31]_i_2_n_0\,
      I1 => \cfarAlpha_o[15]_i_3_n_0\,
      I2 => s_axi_awaddr(5),
      I3 => awHold_reg_n_0,
      I4 => awAddrHold(5),
      I5 => \txReg[3][31]_i_3_n_0\,
      O => \txReg[3][31]_i_1_n_0\
    );
\txReg[3][31]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000C0A0A000C0"
    )
        port map (
      I0 => awAddrHold(7),
      I1 => s_axi_awaddr(7),
      I2 => wrFire,
      I3 => s_axi_awaddr(6),
      I4 => awHold_reg_n_0,
      I5 => awAddrHold(6),
      O => \txReg[3][31]_i_2_n_0\
    );
\txReg[3][31]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => awAddrHold(4),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(4),
      O => \txReg[3][31]_i_3_n_0\
    );
\txReg[3][31]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E0E0E00"
    )
        port map (
      I0 => wHold_reg_n_0,
      I1 => s_axi_wvalid,
      I2 => \^s_axil_bvalid_reg_0\,
      I3 => s_axi_awvalid,
      I4 => awHold_reg_n_0,
      O => wrFire
    );
\txReg[4][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000440347"
    )
        port map (
      I0 => awAddrHold(2),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(2),
      I3 => awAddrHold(3),
      I4 => s_axi_awaddr(3),
      I5 => \txReg[4][31]_i_2_n_0\,
      O => \txReg[4][31]_i_1_n_0\
    );
\txReg[4][31]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"57F7"
    )
        port map (
      I0 => \txReg[0][31]_i_3_n_0\,
      I1 => s_axi_awaddr(4),
      I2 => awHold_reg_n_0,
      I3 => awAddrHold(4),
      O => \txReg[4][31]_i_2_n_0\
    );
\txReg[5][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000047034400"
    )
        port map (
      I0 => awAddrHold(3),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(3),
      I3 => awAddrHold(2),
      I4 => s_axi_awaddr(2),
      I5 => \txReg[4][31]_i_2_n_0\,
      O => \txReg[5][31]_i_1_n_0\
    );
\txReg[6][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000047034400"
    )
        port map (
      I0 => awAddrHold(2),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(2),
      I3 => awAddrHold(3),
      I4 => s_axi_awaddr(3),
      I5 => \txReg[4][31]_i_2_n_0\,
      O => \txReg[6][31]_i_1_n_0\
    );
\txReg[7][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000B8308800"
    )
        port map (
      I0 => awAddrHold(2),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(2),
      I3 => awAddrHold(3),
      I4 => s_axi_awaddr(3),
      I5 => \txReg[4][31]_i_2_n_0\,
      O => \txReg[7][31]_i_1_n_0\
    );
\txReg[8][31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"47000000"
    )
        port map (
      I0 => awAddrHold(4),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(4),
      I3 => \txReg[0][31]_i_4_n_0\,
      I4 => \txReg[8][31]_i_2_n_0\,
      O => \txReg[8][31]_i_1_n_0\
    );
\txReg[8][31]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A808"
    )
        port map (
      I0 => \txReg[3][31]_i_2_n_0\,
      I1 => s_axi_awaddr(5),
      I2 => awHold_reg_n_0,
      I3 => awAddrHold(5),
      O => \txReg[8][31]_i_2_n_0\
    );
\txReg[9][31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"47000000"
    )
        port map (
      I0 => awAddrHold(4),
      I1 => awHold_reg_n_0,
      I2 => s_axi_awaddr(4),
      I3 => \txReg[1][31]_i_2_n_0\,
      I4 => \txReg[8][31]_i_2_n_0\,
      O => \txReg[9][31]_i_1_n_0\
    );
\txReg_reg[0][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][0]\
    );
\txReg_reg[0][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][10]\
    );
\txReg_reg[0][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][11]\
    );
\txReg_reg[0][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][12]\
    );
\txReg_reg[0][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][13]\
    );
\txReg_reg[0][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][14]\
    );
\txReg_reg[0][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[0][15]\
    );
\txReg_reg[0][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][16]\
    );
\txReg_reg[0][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][17]\
    );
\txReg_reg[0][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][18]\
    );
\txReg_reg[0][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][19]\
    );
\txReg_reg[0][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[0][1]\
    );
\txReg_reg[0][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][20]\
    );
\txReg_reg[0][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][21]\
    );
\txReg_reg[0][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][22]\
    );
\txReg_reg[0][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][23]\
    );
\txReg_reg[0][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][24]\
    );
\txReg_reg[0][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][25]\
    );
\txReg_reg[0][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][26]\
    );
\txReg_reg[0][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][27]\
    );
\txReg_reg[0][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][28]\
    );
\txReg_reg[0][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][29]\
    );
\txReg_reg[0][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][2]\
    );
\txReg_reg[0][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][30]\
    );
\txReg_reg[0][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[0][31]\
    );
\txReg_reg[0][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][3]\
    );
\txReg_reg[0][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[0][4]\
    );
\txReg_reg[0][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][5]\
    );
\txReg_reg[0][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][6]\
    );
\txReg_reg[0][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][7]\
    );
\txReg_reg[0][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][8]\
    );
\txReg_reg[0][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[0][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[0][9]\
    );
\txReg_reg[10][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][0]\
    );
\txReg_reg[10][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][10]\
    );
\txReg_reg[10][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][11]\
    );
\txReg_reg[10][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][12]\
    );
\txReg_reg[10][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][13]\
    );
\txReg_reg[10][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][14]\
    );
\txReg_reg[10][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[10][15]\
    );
\txReg_reg[10][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][16]\
    );
\txReg_reg[10][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][17]\
    );
\txReg_reg[10][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][18]\
    );
\txReg_reg[10][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][19]\
    );
\txReg_reg[10][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[10][1]\
    );
\txReg_reg[10][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][20]\
    );
\txReg_reg[10][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][21]\
    );
\txReg_reg[10][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][22]\
    );
\txReg_reg[10][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][23]\
    );
\txReg_reg[10][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][24]\
    );
\txReg_reg[10][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][25]\
    );
\txReg_reg[10][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][26]\
    );
\txReg_reg[10][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][27]\
    );
\txReg_reg[10][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][28]\
    );
\txReg_reg[10][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][29]\
    );
\txReg_reg[10][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][2]\
    );
\txReg_reg[10][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][30]\
    );
\txReg_reg[10][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[10][31]\
    );
\txReg_reg[10][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][3]\
    );
\txReg_reg[10][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[10][4]\
    );
\txReg_reg[10][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][5]\
    );
\txReg_reg[10][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][6]\
    );
\txReg_reg[10][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][7]\
    );
\txReg_reg[10][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][8]\
    );
\txReg_reg[10][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[10][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[10][9]\
    );
\txReg_reg[11][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][0]\
    );
\txReg_reg[11][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][10]\
    );
\txReg_reg[11][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][11]\
    );
\txReg_reg[11][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][12]\
    );
\txReg_reg[11][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][13]\
    );
\txReg_reg[11][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][14]\
    );
\txReg_reg[11][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[11][15]\
    );
\txReg_reg[11][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][16]\
    );
\txReg_reg[11][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][17]\
    );
\txReg_reg[11][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][18]\
    );
\txReg_reg[11][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][19]\
    );
\txReg_reg[11][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[11][1]\
    );
\txReg_reg[11][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][20]\
    );
\txReg_reg[11][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][21]\
    );
\txReg_reg[11][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][22]\
    );
\txReg_reg[11][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][23]\
    );
\txReg_reg[11][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][24]\
    );
\txReg_reg[11][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][25]\
    );
\txReg_reg[11][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][26]\
    );
\txReg_reg[11][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][27]\
    );
\txReg_reg[11][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][28]\
    );
\txReg_reg[11][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][29]\
    );
\txReg_reg[11][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][2]\
    );
\txReg_reg[11][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][30]\
    );
\txReg_reg[11][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[11][31]\
    );
\txReg_reg[11][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][3]\
    );
\txReg_reg[11][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[11][4]\
    );
\txReg_reg[11][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][5]\
    );
\txReg_reg[11][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][6]\
    );
\txReg_reg[11][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][7]\
    );
\txReg_reg[11][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][8]\
    );
\txReg_reg[11][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[11][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[11][9]\
    );
\txReg_reg[12][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][0]\
    );
\txReg_reg[12][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][10]\
    );
\txReg_reg[12][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][11]\
    );
\txReg_reg[12][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][12]\
    );
\txReg_reg[12][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][13]\
    );
\txReg_reg[12][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][14]\
    );
\txReg_reg[12][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[12][15]\
    );
\txReg_reg[12][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][16]\
    );
\txReg_reg[12][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][17]\
    );
\txReg_reg[12][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][18]\
    );
\txReg_reg[12][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][19]\
    );
\txReg_reg[12][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[12][1]\
    );
\txReg_reg[12][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][20]\
    );
\txReg_reg[12][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][21]\
    );
\txReg_reg[12][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][22]\
    );
\txReg_reg[12][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][23]\
    );
\txReg_reg[12][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][24]\
    );
\txReg_reg[12][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][25]\
    );
\txReg_reg[12][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][26]\
    );
\txReg_reg[12][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][27]\
    );
\txReg_reg[12][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][28]\
    );
\txReg_reg[12][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][29]\
    );
\txReg_reg[12][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][2]\
    );
\txReg_reg[12][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][30]\
    );
\txReg_reg[12][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[12][31]\
    );
\txReg_reg[12][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][3]\
    );
\txReg_reg[12][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[12][4]\
    );
\txReg_reg[12][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][5]\
    );
\txReg_reg[12][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][6]\
    );
\txReg_reg[12][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][7]\
    );
\txReg_reg[12][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][8]\
    );
\txReg_reg[12][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[12][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[12][9]\
    );
\txReg_reg[13][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][0]\
    );
\txReg_reg[13][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][10]\
    );
\txReg_reg[13][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][11]\
    );
\txReg_reg[13][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][12]\
    );
\txReg_reg[13][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][13]\
    );
\txReg_reg[13][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][14]\
    );
\txReg_reg[13][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[13][15]\
    );
\txReg_reg[13][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][16]\
    );
\txReg_reg[13][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][17]\
    );
\txReg_reg[13][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][18]\
    );
\txReg_reg[13][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][19]\
    );
\txReg_reg[13][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[13][1]\
    );
\txReg_reg[13][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][20]\
    );
\txReg_reg[13][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][21]\
    );
\txReg_reg[13][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][22]\
    );
\txReg_reg[13][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][23]\
    );
\txReg_reg[13][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][24]\
    );
\txReg_reg[13][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][25]\
    );
\txReg_reg[13][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][26]\
    );
\txReg_reg[13][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][27]\
    );
\txReg_reg[13][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][28]\
    );
\txReg_reg[13][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][29]\
    );
\txReg_reg[13][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][2]\
    );
\txReg_reg[13][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][30]\
    );
\txReg_reg[13][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[13][31]\
    );
\txReg_reg[13][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][3]\
    );
\txReg_reg[13][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[13][4]\
    );
\txReg_reg[13][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][5]\
    );
\txReg_reg[13][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][6]\
    );
\txReg_reg[13][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][7]\
    );
\txReg_reg[13][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][8]\
    );
\txReg_reg[13][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[13][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[13][9]\
    );
\txReg_reg[14][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][0]\
    );
\txReg_reg[14][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][10]\
    );
\txReg_reg[14][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][11]\
    );
\txReg_reg[14][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][12]\
    );
\txReg_reg[14][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][13]\
    );
\txReg_reg[14][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][14]\
    );
\txReg_reg[14][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[14][15]\
    );
\txReg_reg[14][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][16]\
    );
\txReg_reg[14][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][17]\
    );
\txReg_reg[14][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][18]\
    );
\txReg_reg[14][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][19]\
    );
\txReg_reg[14][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[14][1]\
    );
\txReg_reg[14][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][20]\
    );
\txReg_reg[14][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][21]\
    );
\txReg_reg[14][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][22]\
    );
\txReg_reg[14][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][23]\
    );
\txReg_reg[14][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][24]\
    );
\txReg_reg[14][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][25]\
    );
\txReg_reg[14][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][26]\
    );
\txReg_reg[14][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][27]\
    );
\txReg_reg[14][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][28]\
    );
\txReg_reg[14][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][29]\
    );
\txReg_reg[14][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][2]\
    );
\txReg_reg[14][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][30]\
    );
\txReg_reg[14][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[14][31]\
    );
\txReg_reg[14][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][3]\
    );
\txReg_reg[14][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[14][4]\
    );
\txReg_reg[14][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][5]\
    );
\txReg_reg[14][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][6]\
    );
\txReg_reg[14][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][7]\
    );
\txReg_reg[14][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][8]\
    );
\txReg_reg[14][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[14][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[14][9]\
    );
\txReg_reg[15][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][0]\
    );
\txReg_reg[15][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][10]\
    );
\txReg_reg[15][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][11]\
    );
\txReg_reg[15][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][12]\
    );
\txReg_reg[15][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][13]\
    );
\txReg_reg[15][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][14]\
    );
\txReg_reg[15][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[15][15]\
    );
\txReg_reg[15][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][16]\
    );
\txReg_reg[15][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][17]\
    );
\txReg_reg[15][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][18]\
    );
\txReg_reg[15][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][19]\
    );
\txReg_reg[15][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[15][1]\
    );
\txReg_reg[15][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][20]\
    );
\txReg_reg[15][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][21]\
    );
\txReg_reg[15][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][22]\
    );
\txReg_reg[15][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][23]\
    );
\txReg_reg[15][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][24]\
    );
\txReg_reg[15][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][25]\
    );
\txReg_reg[15][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][26]\
    );
\txReg_reg[15][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][27]\
    );
\txReg_reg[15][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][28]\
    );
\txReg_reg[15][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][29]\
    );
\txReg_reg[15][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][2]\
    );
\txReg_reg[15][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][30]\
    );
\txReg_reg[15][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[15][31]\
    );
\txReg_reg[15][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][3]\
    );
\txReg_reg[15][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[15][4]\
    );
\txReg_reg[15][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][5]\
    );
\txReg_reg[15][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][6]\
    );
\txReg_reg[15][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][7]\
    );
\txReg_reg[15][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][8]\
    );
\txReg_reg[15][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[15][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[15][9]\
    );
\txReg_reg[16][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][0]\
    );
\txReg_reg[16][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][10]\
    );
\txReg_reg[16][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][11]\
    );
\txReg_reg[16][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][12]\
    );
\txReg_reg[16][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][13]\
    );
\txReg_reg[16][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][14]\
    );
\txReg_reg[16][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[16][15]\
    );
\txReg_reg[16][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][16]\
    );
\txReg_reg[16][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][17]\
    );
\txReg_reg[16][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][18]\
    );
\txReg_reg[16][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][19]\
    );
\txReg_reg[16][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[16][1]\
    );
\txReg_reg[16][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][20]\
    );
\txReg_reg[16][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][21]\
    );
\txReg_reg[16][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][22]\
    );
\txReg_reg[16][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][23]\
    );
\txReg_reg[16][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][24]\
    );
\txReg_reg[16][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][25]\
    );
\txReg_reg[16][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][26]\
    );
\txReg_reg[16][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][27]\
    );
\txReg_reg[16][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][28]\
    );
\txReg_reg[16][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][29]\
    );
\txReg_reg[16][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][2]\
    );
\txReg_reg[16][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][30]\
    );
\txReg_reg[16][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[16][31]\
    );
\txReg_reg[16][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][3]\
    );
\txReg_reg[16][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[16][4]\
    );
\txReg_reg[16][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][5]\
    );
\txReg_reg[16][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][6]\
    );
\txReg_reg[16][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][7]\
    );
\txReg_reg[16][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][8]\
    );
\txReg_reg[16][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[16][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[16][9]\
    );
\txReg_reg[17][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][0]\
    );
\txReg_reg[17][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][10]\
    );
\txReg_reg[17][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][11]\
    );
\txReg_reg[17][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][12]\
    );
\txReg_reg[17][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][13]\
    );
\txReg_reg[17][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][14]\
    );
\txReg_reg[17][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[17][15]\
    );
\txReg_reg[17][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][16]\
    );
\txReg_reg[17][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][17]\
    );
\txReg_reg[17][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][18]\
    );
\txReg_reg[17][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][19]\
    );
\txReg_reg[17][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[17][1]\
    );
\txReg_reg[17][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][20]\
    );
\txReg_reg[17][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][21]\
    );
\txReg_reg[17][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][22]\
    );
\txReg_reg[17][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][23]\
    );
\txReg_reg[17][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][24]\
    );
\txReg_reg[17][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][25]\
    );
\txReg_reg[17][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][26]\
    );
\txReg_reg[17][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][27]\
    );
\txReg_reg[17][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][28]\
    );
\txReg_reg[17][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][29]\
    );
\txReg_reg[17][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][2]\
    );
\txReg_reg[17][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][30]\
    );
\txReg_reg[17][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[17][31]\
    );
\txReg_reg[17][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][3]\
    );
\txReg_reg[17][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[17][4]\
    );
\txReg_reg[17][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][5]\
    );
\txReg_reg[17][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][6]\
    );
\txReg_reg[17][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][7]\
    );
\txReg_reg[17][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][8]\
    );
\txReg_reg[17][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[17][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[17][9]\
    );
\txReg_reg[18][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][0]\
    );
\txReg_reg[18][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][10]\
    );
\txReg_reg[18][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][11]\
    );
\txReg_reg[18][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][12]\
    );
\txReg_reg[18][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][13]\
    );
\txReg_reg[18][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][14]\
    );
\txReg_reg[18][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[18][15]\
    );
\txReg_reg[18][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][16]\
    );
\txReg_reg[18][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][17]\
    );
\txReg_reg[18][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][18]\
    );
\txReg_reg[18][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][19]\
    );
\txReg_reg[18][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[18][1]\
    );
\txReg_reg[18][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][20]\
    );
\txReg_reg[18][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][21]\
    );
\txReg_reg[18][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][22]\
    );
\txReg_reg[18][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][23]\
    );
\txReg_reg[18][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][24]\
    );
\txReg_reg[18][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][25]\
    );
\txReg_reg[18][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][26]\
    );
\txReg_reg[18][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][27]\
    );
\txReg_reg[18][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][28]\
    );
\txReg_reg[18][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][29]\
    );
\txReg_reg[18][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][2]\
    );
\txReg_reg[18][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][30]\
    );
\txReg_reg[18][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[18][31]\
    );
\txReg_reg[18][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][3]\
    );
\txReg_reg[18][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[18][4]\
    );
\txReg_reg[18][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][5]\
    );
\txReg_reg[18][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][6]\
    );
\txReg_reg[18][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][7]\
    );
\txReg_reg[18][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][8]\
    );
\txReg_reg[18][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[18][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[18][9]\
    );
\txReg_reg[19][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][0]\
    );
\txReg_reg[19][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][10]\
    );
\txReg_reg[19][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][11]\
    );
\txReg_reg[19][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][12]\
    );
\txReg_reg[19][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][13]\
    );
\txReg_reg[19][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][14]\
    );
\txReg_reg[19][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[19][15]\
    );
\txReg_reg[19][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][16]\
    );
\txReg_reg[19][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][17]\
    );
\txReg_reg[19][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][18]\
    );
\txReg_reg[19][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][19]\
    );
\txReg_reg[19][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[19][1]\
    );
\txReg_reg[19][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][20]\
    );
\txReg_reg[19][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][21]\
    );
\txReg_reg[19][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][22]\
    );
\txReg_reg[19][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][23]\
    );
\txReg_reg[19][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][24]\
    );
\txReg_reg[19][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][25]\
    );
\txReg_reg[19][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][26]\
    );
\txReg_reg[19][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][27]\
    );
\txReg_reg[19][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][28]\
    );
\txReg_reg[19][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][29]\
    );
\txReg_reg[19][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][2]\
    );
\txReg_reg[19][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][30]\
    );
\txReg_reg[19][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[19][31]\
    );
\txReg_reg[19][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][3]\
    );
\txReg_reg[19][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[19][4]\
    );
\txReg_reg[19][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][5]\
    );
\txReg_reg[19][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][6]\
    );
\txReg_reg[19][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][7]\
    );
\txReg_reg[19][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][8]\
    );
\txReg_reg[19][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[19][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[19][9]\
    );
\txReg_reg[1][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][0]\
    );
\txReg_reg[1][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][10]\
    );
\txReg_reg[1][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][11]\
    );
\txReg_reg[1][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][12]\
    );
\txReg_reg[1][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][13]\
    );
\txReg_reg[1][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][14]\
    );
\txReg_reg[1][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[1][15]\
    );
\txReg_reg[1][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][16]\
    );
\txReg_reg[1][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][17]\
    );
\txReg_reg[1][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][18]\
    );
\txReg_reg[1][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][19]\
    );
\txReg_reg[1][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[1][1]\
    );
\txReg_reg[1][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][20]\
    );
\txReg_reg[1][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][21]\
    );
\txReg_reg[1][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][22]\
    );
\txReg_reg[1][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][23]\
    );
\txReg_reg[1][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][24]\
    );
\txReg_reg[1][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][25]\
    );
\txReg_reg[1][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][26]\
    );
\txReg_reg[1][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][27]\
    );
\txReg_reg[1][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][28]\
    );
\txReg_reg[1][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][29]\
    );
\txReg_reg[1][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][2]\
    );
\txReg_reg[1][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][30]\
    );
\txReg_reg[1][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[1][31]\
    );
\txReg_reg[1][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][3]\
    );
\txReg_reg[1][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[1][4]\
    );
\txReg_reg[1][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][5]\
    );
\txReg_reg[1][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][6]\
    );
\txReg_reg[1][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][7]\
    );
\txReg_reg[1][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][8]\
    );
\txReg_reg[1][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[1][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[1][9]\
    );
\txReg_reg[2][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][0]\
    );
\txReg_reg[2][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][10]\
    );
\txReg_reg[2][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][11]\
    );
\txReg_reg[2][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][12]\
    );
\txReg_reg[2][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][13]\
    );
\txReg_reg[2][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][14]\
    );
\txReg_reg[2][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[2][15]\
    );
\txReg_reg[2][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][16]\
    );
\txReg_reg[2][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][17]\
    );
\txReg_reg[2][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][18]\
    );
\txReg_reg[2][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][19]\
    );
\txReg_reg[2][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[2][1]\
    );
\txReg_reg[2][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][20]\
    );
\txReg_reg[2][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][21]\
    );
\txReg_reg[2][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][22]\
    );
\txReg_reg[2][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][23]\
    );
\txReg_reg[2][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][24]\
    );
\txReg_reg[2][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][25]\
    );
\txReg_reg[2][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][26]\
    );
\txReg_reg[2][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][27]\
    );
\txReg_reg[2][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][28]\
    );
\txReg_reg[2][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][29]\
    );
\txReg_reg[2][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][2]\
    );
\txReg_reg[2][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][30]\
    );
\txReg_reg[2][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[2][31]\
    );
\txReg_reg[2][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][3]\
    );
\txReg_reg[2][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[2][4]\
    );
\txReg_reg[2][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][5]\
    );
\txReg_reg[2][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][6]\
    );
\txReg_reg[2][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][7]\
    );
\txReg_reg[2][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][8]\
    );
\txReg_reg[2][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[2][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[2][9]\
    );
\txReg_reg[3][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][0]\
    );
\txReg_reg[3][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][10]\
    );
\txReg_reg[3][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][11]\
    );
\txReg_reg[3][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][12]\
    );
\txReg_reg[3][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][13]\
    );
\txReg_reg[3][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][14]\
    );
\txReg_reg[3][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[3][15]\
    );
\txReg_reg[3][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][16]\
    );
\txReg_reg[3][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][17]\
    );
\txReg_reg[3][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][18]\
    );
\txReg_reg[3][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][19]\
    );
\txReg_reg[3][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[3][1]\
    );
\txReg_reg[3][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][20]\
    );
\txReg_reg[3][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][21]\
    );
\txReg_reg[3][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][22]\
    );
\txReg_reg[3][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][23]\
    );
\txReg_reg[3][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][24]\
    );
\txReg_reg[3][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][25]\
    );
\txReg_reg[3][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][26]\
    );
\txReg_reg[3][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][27]\
    );
\txReg_reg[3][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][28]\
    );
\txReg_reg[3][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][29]\
    );
\txReg_reg[3][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][2]\
    );
\txReg_reg[3][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][30]\
    );
\txReg_reg[3][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[3][31]\
    );
\txReg_reg[3][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][3]\
    );
\txReg_reg[3][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[3][4]\
    );
\txReg_reg[3][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][5]\
    );
\txReg_reg[3][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][6]\
    );
\txReg_reg[3][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][7]\
    );
\txReg_reg[3][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][8]\
    );
\txReg_reg[3][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[3][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[3][9]\
    );
\txReg_reg[4][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][0]\
    );
\txReg_reg[4][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][10]\
    );
\txReg_reg[4][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][11]\
    );
\txReg_reg[4][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][12]\
    );
\txReg_reg[4][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][13]\
    );
\txReg_reg[4][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][14]\
    );
\txReg_reg[4][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[4][15]\
    );
\txReg_reg[4][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][16]\
    );
\txReg_reg[4][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][17]\
    );
\txReg_reg[4][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][18]\
    );
\txReg_reg[4][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][19]\
    );
\txReg_reg[4][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[4][1]\
    );
\txReg_reg[4][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][20]\
    );
\txReg_reg[4][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][21]\
    );
\txReg_reg[4][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][22]\
    );
\txReg_reg[4][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][23]\
    );
\txReg_reg[4][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][24]\
    );
\txReg_reg[4][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][25]\
    );
\txReg_reg[4][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][26]\
    );
\txReg_reg[4][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][27]\
    );
\txReg_reg[4][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][28]\
    );
\txReg_reg[4][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][29]\
    );
\txReg_reg[4][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][2]\
    );
\txReg_reg[4][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][30]\
    );
\txReg_reg[4][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[4][31]\
    );
\txReg_reg[4][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][3]\
    );
\txReg_reg[4][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[4][4]\
    );
\txReg_reg[4][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][5]\
    );
\txReg_reg[4][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][6]\
    );
\txReg_reg[4][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][7]\
    );
\txReg_reg[4][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][8]\
    );
\txReg_reg[4][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[4][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[4][9]\
    );
\txReg_reg[5][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][0]\
    );
\txReg_reg[5][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][10]\
    );
\txReg_reg[5][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][11]\
    );
\txReg_reg[5][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][12]\
    );
\txReg_reg[5][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][13]\
    );
\txReg_reg[5][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][14]\
    );
\txReg_reg[5][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[5][15]\
    );
\txReg_reg[5][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][16]\
    );
\txReg_reg[5][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][17]\
    );
\txReg_reg[5][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][18]\
    );
\txReg_reg[5][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][19]\
    );
\txReg_reg[5][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[5][1]\
    );
\txReg_reg[5][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][20]\
    );
\txReg_reg[5][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][21]\
    );
\txReg_reg[5][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][22]\
    );
\txReg_reg[5][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][23]\
    );
\txReg_reg[5][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][24]\
    );
\txReg_reg[5][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][25]\
    );
\txReg_reg[5][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][26]\
    );
\txReg_reg[5][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][27]\
    );
\txReg_reg[5][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][28]\
    );
\txReg_reg[5][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][29]\
    );
\txReg_reg[5][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][2]\
    );
\txReg_reg[5][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][30]\
    );
\txReg_reg[5][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[5][31]\
    );
\txReg_reg[5][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][3]\
    );
\txReg_reg[5][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[5][4]\
    );
\txReg_reg[5][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][5]\
    );
\txReg_reg[5][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][6]\
    );
\txReg_reg[5][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][7]\
    );
\txReg_reg[5][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][8]\
    );
\txReg_reg[5][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[5][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[5][9]\
    );
\txReg_reg[6][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][0]\
    );
\txReg_reg[6][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][10]\
    );
\txReg_reg[6][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][11]\
    );
\txReg_reg[6][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][12]\
    );
\txReg_reg[6][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][13]\
    );
\txReg_reg[6][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][14]\
    );
\txReg_reg[6][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[6][15]\
    );
\txReg_reg[6][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][16]\
    );
\txReg_reg[6][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][17]\
    );
\txReg_reg[6][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][18]\
    );
\txReg_reg[6][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][19]\
    );
\txReg_reg[6][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[6][1]\
    );
\txReg_reg[6][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][20]\
    );
\txReg_reg[6][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][21]\
    );
\txReg_reg[6][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][22]\
    );
\txReg_reg[6][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][23]\
    );
\txReg_reg[6][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][24]\
    );
\txReg_reg[6][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][25]\
    );
\txReg_reg[6][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][26]\
    );
\txReg_reg[6][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][27]\
    );
\txReg_reg[6][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][28]\
    );
\txReg_reg[6][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][29]\
    );
\txReg_reg[6][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][2]\
    );
\txReg_reg[6][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][30]\
    );
\txReg_reg[6][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[6][31]\
    );
\txReg_reg[6][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][3]\
    );
\txReg_reg[6][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[6][4]\
    );
\txReg_reg[6][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][5]\
    );
\txReg_reg[6][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][6]\
    );
\txReg_reg[6][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][7]\
    );
\txReg_reg[6][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][8]\
    );
\txReg_reg[6][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[6][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[6][9]\
    );
\txReg_reg[7][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][0]\
    );
\txReg_reg[7][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][10]\
    );
\txReg_reg[7][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][11]\
    );
\txReg_reg[7][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][12]\
    );
\txReg_reg[7][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][13]\
    );
\txReg_reg[7][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][14]\
    );
\txReg_reg[7][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[7][15]\
    );
\txReg_reg[7][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][16]\
    );
\txReg_reg[7][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][17]\
    );
\txReg_reg[7][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][18]\
    );
\txReg_reg[7][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][19]\
    );
\txReg_reg[7][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[7][1]\
    );
\txReg_reg[7][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][20]\
    );
\txReg_reg[7][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][21]\
    );
\txReg_reg[7][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][22]\
    );
\txReg_reg[7][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][23]\
    );
\txReg_reg[7][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][24]\
    );
\txReg_reg[7][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][25]\
    );
\txReg_reg[7][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][26]\
    );
\txReg_reg[7][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][27]\
    );
\txReg_reg[7][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][28]\
    );
\txReg_reg[7][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][29]\
    );
\txReg_reg[7][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][2]\
    );
\txReg_reg[7][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][30]\
    );
\txReg_reg[7][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[7][31]\
    );
\txReg_reg[7][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][3]\
    );
\txReg_reg[7][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[7][4]\
    );
\txReg_reg[7][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][5]\
    );
\txReg_reg[7][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][6]\
    );
\txReg_reg[7][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][7]\
    );
\txReg_reg[7][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][8]\
    );
\txReg_reg[7][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[7][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[7][9]\
    );
\txReg_reg[8][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][0]\
    );
\txReg_reg[8][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][10]\
    );
\txReg_reg[8][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][11]\
    );
\txReg_reg[8][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][12]\
    );
\txReg_reg[8][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][13]\
    );
\txReg_reg[8][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][14]\
    );
\txReg_reg[8][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[8][15]\
    );
\txReg_reg[8][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][16]\
    );
\txReg_reg[8][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][17]\
    );
\txReg_reg[8][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][18]\
    );
\txReg_reg[8][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][19]\
    );
\txReg_reg[8][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[8][1]\
    );
\txReg_reg[8][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][20]\
    );
\txReg_reg[8][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][21]\
    );
\txReg_reg[8][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][22]\
    );
\txReg_reg[8][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][23]\
    );
\txReg_reg[8][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][24]\
    );
\txReg_reg[8][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][25]\
    );
\txReg_reg[8][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][26]\
    );
\txReg_reg[8][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][27]\
    );
\txReg_reg[8][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][28]\
    );
\txReg_reg[8][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][29]\
    );
\txReg_reg[8][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][2]\
    );
\txReg_reg[8][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][30]\
    );
\txReg_reg[8][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[8][31]\
    );
\txReg_reg[8][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][3]\
    );
\txReg_reg[8][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[8][4]\
    );
\txReg_reg[8][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][5]\
    );
\txReg_reg[8][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][6]\
    );
\txReg_reg[8][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][7]\
    );
\txReg_reg[8][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][8]\
    );
\txReg_reg[8][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[8][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[8][9]\
    );
\txReg_reg[9][0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[0]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][0]\
    );
\txReg_reg[9][10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[10]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][10]\
    );
\txReg_reg[9][11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[11]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][11]\
    );
\txReg_reg[9][12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[12]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][12]\
    );
\txReg_reg[9][13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[13]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][13]\
    );
\txReg_reg[9][14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[14]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][14]\
    );
\txReg_reg[9][15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[15]_i_2_n_0\,
      Q => \txReg_reg_n_0_[9][15]\
    );
\txReg_reg[9][16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][16]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][16]\
    );
\txReg_reg[9][17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][17]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][17]\
    );
\txReg_reg[9][18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][18]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][18]\
    );
\txReg_reg[9][19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][19]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][19]\
    );
\txReg_reg[9][1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => p_0_in,
      Q => \txReg_reg_n_0_[9][1]\
    );
\txReg_reg[9][20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][20]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][20]\
    );
\txReg_reg[9][21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][21]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][21]\
    );
\txReg_reg[9][22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][22]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][22]\
    );
\txReg_reg[9][23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][23]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][23]\
    );
\txReg_reg[9][24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][24]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][24]\
    );
\txReg_reg[9][25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][25]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][25]\
    );
\txReg_reg[9][26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][26]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][26]\
    );
\txReg_reg[9][27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][27]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][27]\
    );
\txReg_reg[9][28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][28]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][28]\
    );
\txReg_reg[9][29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][29]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][29]\
    );
\txReg_reg[9][2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[2]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][2]\
    );
\txReg_reg[9][30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][30]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][30]\
    );
\txReg_reg[9][31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \txReg[0][31]_i_2_n_0\,
      Q => \txReg_reg_n_0_[9][31]\
    );
\txReg_reg[9][3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[3]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][3]\
    );
\txReg_reg[9][4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarK_o[4]_i_2_n_0\,
      Q => \txReg_reg_n_0_[9][4]\
    );
\txReg_reg[9][5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[5]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][5]\
    );
\txReg_reg[9][6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[6]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][6]\
    );
\txReg_reg[9][7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[7]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][7]\
    );
\txReg_reg[9][8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[8]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][8]\
    );
\txReg_reg[9][9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => \txReg[9][31]_i_1_n_0\,
      CLR => \^aresetn_0\,
      D => \cfarAlpha_o[9]_i_1_n_0\,
      Q => \txReg_reg_n_0_[9][9]\
    );
txValid_o_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => txLoading_reg_n_0,
      Q => E(0)
    );
txValid_o_reg_rep: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => txLoading_reg_n_0,
      Q => CEA1
    );
\txValid_o_reg_rep__0\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => txLoading_reg_n_0,
      Q => \txValid_o_reg_rep__0_0\
    );
\txValid_o_reg_rep__1\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => txLoading_reg_n_0,
      Q => \txValid_o_reg_rep__1_0\
    );
\txValid_o_reg_rep__10\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => txLoading_reg_n_0,
      Q => \txValid_o_reg_rep__10_0\
    );
\txValid_o_reg_rep__11\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => txLoading_reg_n_0,
      Q => \txValid_o_reg_rep__11_0\
    );
\txValid_o_reg_rep__12\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => txLoading_reg_n_0,
      Q => \txValid_o_reg_rep__12_0\
    );
\txValid_o_reg_rep__13\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => txLoading_reg_n_0,
      Q => \txValid_o_reg_rep__13_0\
    );
\txValid_o_reg_rep__14\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => txLoading_reg_n_0,
      Q => \txValid_o_reg_rep__14_0\
    );
\txValid_o_reg_rep__2\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => txLoading_reg_n_0,
      Q => CEA2
    );
\txValid_o_reg_rep__3\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => txLoading_reg_n_0,
      Q => \txValid_o_reg_rep__3_0\
    );
\txValid_o_reg_rep__4\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => txLoading_reg_n_0,
      Q => \txValid_o_reg_rep__4_0\
    );
\txValid_o_reg_rep__5\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => txLoading_reg_n_0,
      Q => \txValid_o_reg_rep__5_0\
    );
\txValid_o_reg_rep__6\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => txLoading_reg_n_0,
      Q => \txValid_o_reg_rep__6_0\
    );
\txValid_o_reg_rep__7\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => txLoading_reg_n_0,
      Q => \txValid_o_reg_rep__7_0\
    );
\txValid_o_reg_rep__8\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => txLoading_reg_n_0,
      Q => \txValid_o_reg_rep__8_0\
    );
\txValid_o_reg_rep__9\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => txLoading_reg_n_0,
      Q => \txValid_o_reg_rep__9_0\
    );
\wDataHold[31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000F100"
    )
        port map (
      I0 => awHold_reg_n_0,
      I1 => s_axi_awvalid,
      I2 => \^s_axil_bvalid_reg_0\,
      I3 => s_axi_wvalid,
      I4 => wHold_reg_n_0,
      O => wHold
    );
\wDataHold_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(0),
      Q => wDataHold(0)
    );
\wDataHold_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(10),
      Q => wDataHold(10)
    );
\wDataHold_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(11),
      Q => wDataHold(11)
    );
\wDataHold_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(12),
      Q => wDataHold(12)
    );
\wDataHold_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(13),
      Q => wDataHold(13)
    );
\wDataHold_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(14),
      Q => wDataHold(14)
    );
\wDataHold_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(15),
      Q => wDataHold(15)
    );
\wDataHold_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(16),
      Q => wDataHold(16)
    );
\wDataHold_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(17),
      Q => wDataHold(17)
    );
\wDataHold_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(18),
      Q => wDataHold(18)
    );
\wDataHold_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(19),
      Q => wDataHold(19)
    );
\wDataHold_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(1),
      Q => wDataHold(1)
    );
\wDataHold_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(20),
      Q => wDataHold(20)
    );
\wDataHold_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(21),
      Q => wDataHold(21)
    );
\wDataHold_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(22),
      Q => wDataHold(22)
    );
\wDataHold_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(23),
      Q => wDataHold(23)
    );
\wDataHold_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(24),
      Q => wDataHold(24)
    );
\wDataHold_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(25),
      Q => wDataHold(25)
    );
\wDataHold_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(26),
      Q => wDataHold(26)
    );
\wDataHold_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(27),
      Q => wDataHold(27)
    );
\wDataHold_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(28),
      Q => wDataHold(28)
    );
\wDataHold_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(29),
      Q => wDataHold(29)
    );
\wDataHold_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(2),
      Q => wDataHold(2)
    );
\wDataHold_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(30),
      Q => wDataHold(30)
    );
\wDataHold_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(31),
      Q => wDataHold(31)
    );
\wDataHold_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(3),
      Q => wDataHold(3)
    );
\wDataHold_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(4),
      Q => wDataHold(4)
    );
\wDataHold_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(5),
      Q => wDataHold(5)
    );
\wDataHold_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(6),
      Q => wDataHold(6)
    );
\wDataHold_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(7),
      Q => wDataHold(7)
    );
\wDataHold_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(8),
      Q => wDataHold(8)
    );
\wDataHold_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => wHold,
      CLR => \^aresetn_0\,
      D => s_axi_wdata(9),
      Q => wDataHold(9)
    );
wHold_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F1F1F100"
    )
        port map (
      I0 => awHold_reg_n_0,
      I1 => s_axi_awvalid,
      I2 => \^s_axil_bvalid_reg_0\,
      I3 => wHold_reg_n_0,
      I4 => s_axi_wvalid,
      O => wHold_i_1_n_0
    );
wHold_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \^aresetn_0\,
      D => wHold_i_1_n_0,
      Q => wHold_reg_n_0
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_radar_wrapper_0_1_butterflyUnit is
  port (
    O : out STD_LOGIC_VECTOR ( 4 downto 0 );
    \fftComplex_reg[19]\ : out STD_LOGIC_VECTOR ( 4 downto 0 );
    muxComplex : out STD_LOGIC_VECTOR ( 20 downto 0 );
    muxReel : out STD_LOGIC_VECTOR ( 20 downto 0 );
    D : out STD_LOGIC_VECTOR ( 31 downto 0 );
    fifoOutReel : in STD_LOGIC_VECTOR ( 18 downto 0 );
    S : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[63][15]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DI : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gRam.mem_reg[0][20]\ : in STD_LOGIC_VECTOR ( 4 downto 0 );
    fifoOutComplex_0 : in STD_LOGIC_VECTOR ( 18 downto 0 );
    \gRam.mem_reg[63][28]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[63][36]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][41]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gRam.mem_reg[0][41]_0\ : in STD_LOGIC_VECTOR ( 4 downto 0 );
    DSP_A_B_DATA_INST : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_0 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    DSP_A_B_DATA_INST_2 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    DSP_A_B_DATA_INST_3 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_4 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_5 : in STD_LOGIC_VECTOR ( 0 to 0 );
    DSP_A_B_DATA_INST_6 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    \out\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    fftComplex : in STD_LOGIC_VECTOR ( 15 downto 0 );
    fftReel : in STD_LOGIC_VECTOR ( 15 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of design_1_radar_wrapper_0_1_butterflyUnit : entity is "butterflyUnit";
end design_1_radar_wrapper_0_1_butterflyUnit;

architecture STRUCTURE of design_1_radar_wrapper_0_1_butterflyUnit is
  signal \dataComplexDif_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_0 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_1 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_2 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_3 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_4 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_5 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_6 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_7 : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_0 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_1 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_2 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_3 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_4 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_5 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_6 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_7 : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataReelDif_o0_carry_n_0 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_1 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_2 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_3 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_4 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_5 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_6 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_7 : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataReelSum_o0_carry_n_0 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_1 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_2 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_3 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_4 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_5 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_6 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_7 : STD_LOGIC;
  signal difComplex : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal difReel : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal \NLW_dataComplexDif_o0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 4 );
  signal \NLW_dataComplexDif_o0_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 5 );
  signal \NLW_dataComplexSum_o0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 4 );
  signal \NLW_dataComplexSum_o0_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 5 );
  signal \NLW_dataReelDif_o0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 4 );
  signal \NLW_dataReelDif_o0_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 5 );
  signal \NLW_dataReelSum_o0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 4 );
  signal \NLW_dataReelSum_o0_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 5 );
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of dataComplexDif_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexDif_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexDif_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of dataComplexSum_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexSum_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexSum_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of dataReelDif_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataReelDif_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelDif_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of dataReelSum_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataReelSum_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelSum_o0_carry__1\ : label is 35;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \gRam.mem[63][0]_i_1\ : label is "soft_lutpair188";
  attribute SOFT_HLUTNM of \gRam.mem[63][10]_i_1\ : label is "soft_lutpair183";
  attribute SOFT_HLUTNM of \gRam.mem[63][11]_i_1\ : label is "soft_lutpair183";
  attribute SOFT_HLUTNM of \gRam.mem[63][12]_i_1\ : label is "soft_lutpair182";
  attribute SOFT_HLUTNM of \gRam.mem[63][13]_i_1\ : label is "soft_lutpair182";
  attribute SOFT_HLUTNM of \gRam.mem[63][14]_i_1\ : label is "soft_lutpair181";
  attribute SOFT_HLUTNM of \gRam.mem[63][15]_i_1\ : label is "soft_lutpair181";
  attribute SOFT_HLUTNM of \gRam.mem[63][1]_i_1\ : label is "soft_lutpair188";
  attribute SOFT_HLUTNM of \gRam.mem[63][21]_i_1\ : label is "soft_lutpair180";
  attribute SOFT_HLUTNM of \gRam.mem[63][22]_i_1\ : label is "soft_lutpair180";
  attribute SOFT_HLUTNM of \gRam.mem[63][23]_i_1\ : label is "soft_lutpair179";
  attribute SOFT_HLUTNM of \gRam.mem[63][24]_i_1\ : label is "soft_lutpair179";
  attribute SOFT_HLUTNM of \gRam.mem[63][25]_i_1\ : label is "soft_lutpair178";
  attribute SOFT_HLUTNM of \gRam.mem[63][26]_i_1\ : label is "soft_lutpair178";
  attribute SOFT_HLUTNM of \gRam.mem[63][27]_i_1\ : label is "soft_lutpair177";
  attribute SOFT_HLUTNM of \gRam.mem[63][28]_i_1\ : label is "soft_lutpair177";
  attribute SOFT_HLUTNM of \gRam.mem[63][29]_i_1\ : label is "soft_lutpair176";
  attribute SOFT_HLUTNM of \gRam.mem[63][2]_i_1\ : label is "soft_lutpair187";
  attribute SOFT_HLUTNM of \gRam.mem[63][30]_i_1\ : label is "soft_lutpair176";
  attribute SOFT_HLUTNM of \gRam.mem[63][31]_i_1\ : label is "soft_lutpair175";
  attribute SOFT_HLUTNM of \gRam.mem[63][32]_i_1\ : label is "soft_lutpair175";
  attribute SOFT_HLUTNM of \gRam.mem[63][33]_i_1\ : label is "soft_lutpair174";
  attribute SOFT_HLUTNM of \gRam.mem[63][34]_i_1\ : label is "soft_lutpair174";
  attribute SOFT_HLUTNM of \gRam.mem[63][35]_i_1\ : label is "soft_lutpair173";
  attribute SOFT_HLUTNM of \gRam.mem[63][36]_i_1\ : label is "soft_lutpair173";
  attribute SOFT_HLUTNM of \gRam.mem[63][3]_i_1\ : label is "soft_lutpair187";
  attribute SOFT_HLUTNM of \gRam.mem[63][4]_i_1\ : label is "soft_lutpair186";
  attribute SOFT_HLUTNM of \gRam.mem[63][5]_i_1\ : label is "soft_lutpair186";
  attribute SOFT_HLUTNM of \gRam.mem[63][6]_i_1\ : label is "soft_lutpair185";
  attribute SOFT_HLUTNM of \gRam.mem[63][7]_i_1\ : label is "soft_lutpair185";
  attribute SOFT_HLUTNM of \gRam.mem[63][8]_i_1\ : label is "soft_lutpair184";
  attribute SOFT_HLUTNM of \gRam.mem[63][9]_i_1\ : label is "soft_lutpair184";
begin
dataComplexDif_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '1',
      CI_TOP => '0',
      CO(7) => dataComplexDif_o0_carry_n_0,
      CO(6) => dataComplexDif_o0_carry_n_1,
      CO(5) => dataComplexDif_o0_carry_n_2,
      CO(4) => dataComplexDif_o0_carry_n_3,
      CO(3) => dataComplexDif_o0_carry_n_4,
      CO(2) => dataComplexDif_o0_carry_n_5,
      CO(1) => dataComplexDif_o0_carry_n_6,
      CO(0) => dataComplexDif_o0_carry_n_7,
      DI(7 downto 0) => fifoOutComplex_0(7 downto 0),
      O(7 downto 0) => difComplex(7 downto 0),
      S(7 downto 0) => \gRam.mem_reg[63][28]\(7 downto 0)
    );
\dataComplexDif_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataComplexDif_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataComplexDif_o0_carry__0_n_0\,
      CO(6) => \dataComplexDif_o0_carry__0_n_1\,
      CO(5) => \dataComplexDif_o0_carry__0_n_2\,
      CO(4) => \dataComplexDif_o0_carry__0_n_3\,
      CO(3) => \dataComplexDif_o0_carry__0_n_4\,
      CO(2) => \dataComplexDif_o0_carry__0_n_5\,
      CO(1) => \dataComplexDif_o0_carry__0_n_6\,
      CO(0) => \dataComplexDif_o0_carry__0_n_7\,
      DI(7 downto 0) => fifoOutComplex_0(15 downto 8),
      O(7 downto 0) => difComplex(15 downto 8),
      S(7 downto 0) => \gRam.mem_reg[63][36]\(7 downto 0)
    );
\dataComplexDif_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexDif_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7 downto 4) => \NLW_dataComplexDif_o0_carry__1_CO_UNCONNECTED\(7 downto 4),
      CO(3) => \dataComplexDif_o0_carry__1_n_4\,
      CO(2) => \dataComplexDif_o0_carry__1_n_5\,
      CO(1) => \dataComplexDif_o0_carry__1_n_6\,
      CO(0) => \dataComplexDif_o0_carry__1_n_7\,
      DI(7 downto 4) => B"0000",
      DI(3) => \gRam.mem_reg[0][41]\(0),
      DI(2 downto 0) => fifoOutComplex_0(18 downto 16),
      O(7 downto 5) => \NLW_dataComplexDif_o0_carry__1_O_UNCONNECTED\(7 downto 5),
      O(4 downto 0) => \fftComplex_reg[19]\(4 downto 0),
      S(7 downto 5) => B"000",
      S(4 downto 0) => \gRam.mem_reg[0][41]_0\(4 downto 0)
    );
dataComplexSum_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '0',
      CI_TOP => '0',
      CO(7) => dataComplexSum_o0_carry_n_0,
      CO(6) => dataComplexSum_o0_carry_n_1,
      CO(5) => dataComplexSum_o0_carry_n_2,
      CO(4) => dataComplexSum_o0_carry_n_3,
      CO(3) => dataComplexSum_o0_carry_n_4,
      CO(2) => dataComplexSum_o0_carry_n_5,
      CO(1) => dataComplexSum_o0_carry_n_6,
      CO(0) => dataComplexSum_o0_carry_n_7,
      DI(7 downto 0) => fifoOutComplex_0(7 downto 0),
      O(7 downto 0) => muxComplex(7 downto 0),
      S(7 downto 0) => DSP_A_B_DATA_INST(7 downto 0)
    );
\dataComplexSum_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataComplexSum_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataComplexSum_o0_carry__0_n_0\,
      CO(6) => \dataComplexSum_o0_carry__0_n_1\,
      CO(5) => \dataComplexSum_o0_carry__0_n_2\,
      CO(4) => \dataComplexSum_o0_carry__0_n_3\,
      CO(3) => \dataComplexSum_o0_carry__0_n_4\,
      CO(2) => \dataComplexSum_o0_carry__0_n_5\,
      CO(1) => \dataComplexSum_o0_carry__0_n_6\,
      CO(0) => \dataComplexSum_o0_carry__0_n_7\,
      DI(7 downto 0) => fifoOutComplex_0(15 downto 8),
      O(7 downto 0) => muxComplex(15 downto 8),
      S(7 downto 0) => DSP_A_B_DATA_INST_0(7 downto 0)
    );
\dataComplexSum_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexSum_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7 downto 4) => \NLW_dataComplexSum_o0_carry__1_CO_UNCONNECTED\(7 downto 4),
      CO(3) => \dataComplexSum_o0_carry__1_n_4\,
      CO(2) => \dataComplexSum_o0_carry__1_n_5\,
      CO(1) => \dataComplexSum_o0_carry__1_n_6\,
      CO(0) => \dataComplexSum_o0_carry__1_n_7\,
      DI(7 downto 4) => B"0000",
      DI(3) => DSP_A_B_DATA_INST_1(0),
      DI(2 downto 0) => fifoOutComplex_0(18 downto 16),
      O(7 downto 5) => \NLW_dataComplexSum_o0_carry__1_O_UNCONNECTED\(7 downto 5),
      O(4 downto 0) => muxComplex(20 downto 16),
      S(7 downto 5) => B"000",
      S(4 downto 0) => DSP_A_B_DATA_INST_2(4 downto 0)
    );
dataReelDif_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '1',
      CI_TOP => '0',
      CO(7) => dataReelDif_o0_carry_n_0,
      CO(6) => dataReelDif_o0_carry_n_1,
      CO(5) => dataReelDif_o0_carry_n_2,
      CO(4) => dataReelDif_o0_carry_n_3,
      CO(3) => dataReelDif_o0_carry_n_4,
      CO(2) => dataReelDif_o0_carry_n_5,
      CO(1) => dataReelDif_o0_carry_n_6,
      CO(0) => dataReelDif_o0_carry_n_7,
      DI(7 downto 0) => fifoOutReel(7 downto 0),
      O(7 downto 0) => difReel(7 downto 0),
      S(7 downto 0) => S(7 downto 0)
    );
\dataReelDif_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataReelDif_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataReelDif_o0_carry__0_n_0\,
      CO(6) => \dataReelDif_o0_carry__0_n_1\,
      CO(5) => \dataReelDif_o0_carry__0_n_2\,
      CO(4) => \dataReelDif_o0_carry__0_n_3\,
      CO(3) => \dataReelDif_o0_carry__0_n_4\,
      CO(2) => \dataReelDif_o0_carry__0_n_5\,
      CO(1) => \dataReelDif_o0_carry__0_n_6\,
      CO(0) => \dataReelDif_o0_carry__0_n_7\,
      DI(7 downto 0) => fifoOutReel(15 downto 8),
      O(7 downto 0) => difReel(15 downto 8),
      S(7 downto 0) => \gRam.mem_reg[63][15]\(7 downto 0)
    );
\dataReelDif_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelDif_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7 downto 4) => \NLW_dataReelDif_o0_carry__1_CO_UNCONNECTED\(7 downto 4),
      CO(3) => \dataReelDif_o0_carry__1_n_4\,
      CO(2) => \dataReelDif_o0_carry__1_n_5\,
      CO(1) => \dataReelDif_o0_carry__1_n_6\,
      CO(0) => \dataReelDif_o0_carry__1_n_7\,
      DI(7 downto 4) => B"0000",
      DI(3) => DI(0),
      DI(2 downto 0) => fifoOutReel(18 downto 16),
      O(7 downto 5) => \NLW_dataReelDif_o0_carry__1_O_UNCONNECTED\(7 downto 5),
      O(4 downto 0) => O(4 downto 0),
      S(7 downto 5) => B"000",
      S(4 downto 0) => \gRam.mem_reg[0][20]\(4 downto 0)
    );
dataReelSum_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '0',
      CI_TOP => '0',
      CO(7) => dataReelSum_o0_carry_n_0,
      CO(6) => dataReelSum_o0_carry_n_1,
      CO(5) => dataReelSum_o0_carry_n_2,
      CO(4) => dataReelSum_o0_carry_n_3,
      CO(3) => dataReelSum_o0_carry_n_4,
      CO(2) => dataReelSum_o0_carry_n_5,
      CO(1) => dataReelSum_o0_carry_n_6,
      CO(0) => dataReelSum_o0_carry_n_7,
      DI(7 downto 0) => fifoOutReel(7 downto 0),
      O(7 downto 0) => muxReel(7 downto 0),
      S(7 downto 0) => DSP_A_B_DATA_INST_3(7 downto 0)
    );
\dataReelSum_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataReelSum_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataReelSum_o0_carry__0_n_0\,
      CO(6) => \dataReelSum_o0_carry__0_n_1\,
      CO(5) => \dataReelSum_o0_carry__0_n_2\,
      CO(4) => \dataReelSum_o0_carry__0_n_3\,
      CO(3) => \dataReelSum_o0_carry__0_n_4\,
      CO(2) => \dataReelSum_o0_carry__0_n_5\,
      CO(1) => \dataReelSum_o0_carry__0_n_6\,
      CO(0) => \dataReelSum_o0_carry__0_n_7\,
      DI(7 downto 0) => fifoOutReel(15 downto 8),
      O(7 downto 0) => muxReel(15 downto 8),
      S(7 downto 0) => DSP_A_B_DATA_INST_4(7 downto 0)
    );
\dataReelSum_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelSum_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7 downto 4) => \NLW_dataReelSum_o0_carry__1_CO_UNCONNECTED\(7 downto 4),
      CO(3) => \dataReelSum_o0_carry__1_n_4\,
      CO(2) => \dataReelSum_o0_carry__1_n_5\,
      CO(1) => \dataReelSum_o0_carry__1_n_6\,
      CO(0) => \dataReelSum_o0_carry__1_n_7\,
      DI(7 downto 4) => B"0000",
      DI(3) => DSP_A_B_DATA_INST_5(0),
      DI(2 downto 0) => fifoOutReel(18 downto 16),
      O(7 downto 5) => \NLW_dataReelSum_o0_carry__1_O_UNCONNECTED\(7 downto 5),
      O(4 downto 0) => muxReel(20 downto 16),
      S(7 downto 5) => B"000",
      S(4 downto 0) => DSP_A_B_DATA_INST_6(4 downto 0)
    );
\gRam.mem[63][0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difReel(0),
      I1 => \out\(0),
      I2 => fftReel(0),
      O => D(0)
    );
\gRam.mem[63][10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difReel(10),
      I1 => \out\(0),
      I2 => fftReel(10),
      O => D(10)
    );
\gRam.mem[63][11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difReel(11),
      I1 => \out\(0),
      I2 => fftReel(11),
      O => D(11)
    );
\gRam.mem[63][12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difReel(12),
      I1 => \out\(0),
      I2 => fftReel(12),
      O => D(12)
    );
\gRam.mem[63][13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difReel(13),
      I1 => \out\(0),
      I2 => fftReel(13),
      O => D(13)
    );
\gRam.mem[63][14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difReel(14),
      I1 => \out\(0),
      I2 => fftReel(14),
      O => D(14)
    );
\gRam.mem[63][15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difReel(15),
      I1 => \out\(0),
      I2 => fftReel(15),
      O => D(15)
    );
\gRam.mem[63][1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difReel(1),
      I1 => \out\(0),
      I2 => fftReel(1),
      O => D(1)
    );
\gRam.mem[63][21]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difComplex(0),
      I1 => \out\(0),
      I2 => fftComplex(0),
      O => D(16)
    );
\gRam.mem[63][22]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difComplex(1),
      I1 => \out\(0),
      I2 => fftComplex(1),
      O => D(17)
    );
\gRam.mem[63][23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difComplex(2),
      I1 => \out\(0),
      I2 => fftComplex(2),
      O => D(18)
    );
\gRam.mem[63][24]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difComplex(3),
      I1 => \out\(0),
      I2 => fftComplex(3),
      O => D(19)
    );
\gRam.mem[63][25]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difComplex(4),
      I1 => \out\(0),
      I2 => fftComplex(4),
      O => D(20)
    );
\gRam.mem[63][26]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difComplex(5),
      I1 => \out\(0),
      I2 => fftComplex(5),
      O => D(21)
    );
\gRam.mem[63][27]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difComplex(6),
      I1 => \out\(0),
      I2 => fftComplex(6),
      O => D(22)
    );
\gRam.mem[63][28]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difComplex(7),
      I1 => \out\(0),
      I2 => fftComplex(7),
      O => D(23)
    );
\gRam.mem[63][29]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difComplex(8),
      I1 => \out\(0),
      I2 => fftComplex(8),
      O => D(24)
    );
\gRam.mem[63][2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difReel(2),
      I1 => \out\(0),
      I2 => fftReel(2),
      O => D(2)
    );
\gRam.mem[63][30]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difComplex(9),
      I1 => \out\(0),
      I2 => fftComplex(9),
      O => D(25)
    );
\gRam.mem[63][31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difComplex(10),
      I1 => \out\(0),
      I2 => fftComplex(10),
      O => D(26)
    );
\gRam.mem[63][32]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difComplex(11),
      I1 => \out\(0),
      I2 => fftComplex(11),
      O => D(27)
    );
\gRam.mem[63][33]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difComplex(12),
      I1 => \out\(0),
      I2 => fftComplex(12),
      O => D(28)
    );
\gRam.mem[63][34]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difComplex(13),
      I1 => \out\(0),
      I2 => fftComplex(13),
      O => D(29)
    );
\gRam.mem[63][35]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difComplex(14),
      I1 => \out\(0),
      I2 => fftComplex(14),
      O => D(30)
    );
\gRam.mem[63][36]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difComplex(15),
      I1 => \out\(0),
      I2 => fftComplex(15),
      O => D(31)
    );
\gRam.mem[63][3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difReel(3),
      I1 => \out\(0),
      I2 => fftReel(3),
      O => D(3)
    );
\gRam.mem[63][4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difReel(4),
      I1 => \out\(0),
      I2 => fftReel(4),
      O => D(4)
    );
\gRam.mem[63][5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difReel(5),
      I1 => \out\(0),
      I2 => fftReel(5),
      O => D(5)
    );
\gRam.mem[63][6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difReel(6),
      I1 => \out\(0),
      I2 => fftReel(6),
      O => D(6)
    );
\gRam.mem[63][7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difReel(7),
      I1 => \out\(0),
      I2 => fftReel(7),
      O => D(7)
    );
\gRam.mem[63][8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difReel(8),
      I1 => \out\(0),
      I2 => fftReel(8),
      O => D(8)
    );
\gRam.mem[63][9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => difReel(9),
      I1 => \out\(0),
      I2 => fftReel(9),
      O => D(9)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \design_1_radar_wrapper_0_1_butterflyUnit__parameterized0\ is
  port (
    O : out STD_LOGIC_VECTOR ( 5 downto 0 );
    complexOut_o1_i_1 : out STD_LOGIC_VECTOR ( 5 downto 0 );
    A : out STD_LOGIC_VECTOR ( 21 downto 0 );
    \cnt_reg[5]\ : out STD_LOGIC_VECTOR ( 21 downto 0 );
    D : out STD_LOGIC_VECTOR ( 31 downto 0 );
    DI : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[31][15]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[31][15]_0\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][21]\ : in STD_LOGIC_VECTOR ( 4 downto 0 );
    \gRam.mem_reg[0][21]_0\ : in STD_LOGIC_VECTOR ( 5 downto 0 );
    fifoOutComplex_0 : in STD_LOGIC_VECTOR ( 19 downto 0 );
    \gRam.mem_reg[31][29]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[31][37]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][43]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gRam.mem_reg[0][43]_0\ : in STD_LOGIC_VECTOR ( 5 downto 0 );
    DSP_A_B_DATA_INST : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_0 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    DSP_A_B_DATA_INST_2 : in STD_LOGIC_VECTOR ( 5 downto 0 );
    DSP_A_B_DATA_INST_3 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_4 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_5 : in STD_LOGIC_VECTOR ( 0 to 0 );
    DSP_A_B_DATA_INST_6 : in STD_LOGIC_VECTOR ( 5 downto 0 );
    \gRam.mem_reg[31][15]_1\ : in STD_LOGIC_VECTOR ( 15 downto 0 );
    \gRam.mem_reg[31][8]\ : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gRam.mem_reg[31][37]_0\ : in STD_LOGIC_VECTOR ( 15 downto 0 );
    OPMODE : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \design_1_radar_wrapper_0_1_butterflyUnit__parameterized0\ : entity is "butterflyUnit";
end \design_1_radar_wrapper_0_1_butterflyUnit__parameterized0\;

architecture STRUCTURE of \design_1_radar_wrapper_0_1_butterflyUnit__parameterized0\ is
  signal \dataComplexDif_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_0 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_1 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_2 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_3 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_4 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_5 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_6 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_7 : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_0 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_1 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_2 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_3 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_4 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_5 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_6 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_7 : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataReelDif_o0_carry_n_0 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_1 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_2 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_3 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_4 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_5 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_6 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_7 : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataReelSum_o0_carry_n_0 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_1 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_2 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_3 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_4 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_5 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_6 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_7 : STD_LOGIC;
  signal difComplex : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal difReel : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal \NLW_dataComplexDif_o0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 5 );
  signal \NLW_dataComplexDif_o0_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 6 );
  signal \NLW_dataComplexSum_o0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 5 );
  signal \NLW_dataComplexSum_o0_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 6 );
  signal \NLW_dataReelDif_o0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 5 );
  signal \NLW_dataReelDif_o0_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 6 );
  signal \NLW_dataReelSum_o0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 5 );
  signal \NLW_dataReelSum_o0_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 6 );
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of dataComplexDif_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexDif_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexDif_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of dataComplexSum_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexSum_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexSum_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of dataReelDif_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataReelDif_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelDif_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of dataReelSum_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataReelSum_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelSum_o0_carry__1\ : label is 35;
begin
dataComplexDif_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '1',
      CI_TOP => '0',
      CO(7) => dataComplexDif_o0_carry_n_0,
      CO(6) => dataComplexDif_o0_carry_n_1,
      CO(5) => dataComplexDif_o0_carry_n_2,
      CO(4) => dataComplexDif_o0_carry_n_3,
      CO(3) => dataComplexDif_o0_carry_n_4,
      CO(2) => dataComplexDif_o0_carry_n_5,
      CO(1) => dataComplexDif_o0_carry_n_6,
      CO(0) => dataComplexDif_o0_carry_n_7,
      DI(7 downto 0) => fifoOutComplex_0(7 downto 0),
      O(7 downto 0) => difComplex(7 downto 0),
      S(7 downto 0) => \gRam.mem_reg[31][29]\(7 downto 0)
    );
\dataComplexDif_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataComplexDif_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataComplexDif_o0_carry__0_n_0\,
      CO(6) => \dataComplexDif_o0_carry__0_n_1\,
      CO(5) => \dataComplexDif_o0_carry__0_n_2\,
      CO(4) => \dataComplexDif_o0_carry__0_n_3\,
      CO(3) => \dataComplexDif_o0_carry__0_n_4\,
      CO(2) => \dataComplexDif_o0_carry__0_n_5\,
      CO(1) => \dataComplexDif_o0_carry__0_n_6\,
      CO(0) => \dataComplexDif_o0_carry__0_n_7\,
      DI(7 downto 0) => fifoOutComplex_0(15 downto 8),
      O(7 downto 0) => difComplex(15 downto 8),
      S(7 downto 0) => \gRam.mem_reg[31][37]\(7 downto 0)
    );
\dataComplexDif_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexDif_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7 downto 5) => \NLW_dataComplexDif_o0_carry__1_CO_UNCONNECTED\(7 downto 5),
      CO(4) => \dataComplexDif_o0_carry__1_n_3\,
      CO(3) => \dataComplexDif_o0_carry__1_n_4\,
      CO(2) => \dataComplexDif_o0_carry__1_n_5\,
      CO(1) => \dataComplexDif_o0_carry__1_n_6\,
      CO(0) => \dataComplexDif_o0_carry__1_n_7\,
      DI(7 downto 5) => B"000",
      DI(4) => \gRam.mem_reg[0][43]\(0),
      DI(3 downto 0) => fifoOutComplex_0(19 downto 16),
      O(7 downto 6) => \NLW_dataComplexDif_o0_carry__1_O_UNCONNECTED\(7 downto 6),
      O(5 downto 0) => complexOut_o1_i_1(5 downto 0),
      S(7 downto 6) => B"00",
      S(5 downto 0) => \gRam.mem_reg[0][43]_0\(5 downto 0)
    );
dataComplexSum_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '0',
      CI_TOP => '0',
      CO(7) => dataComplexSum_o0_carry_n_0,
      CO(6) => dataComplexSum_o0_carry_n_1,
      CO(5) => dataComplexSum_o0_carry_n_2,
      CO(4) => dataComplexSum_o0_carry_n_3,
      CO(3) => dataComplexSum_o0_carry_n_4,
      CO(2) => dataComplexSum_o0_carry_n_5,
      CO(1) => dataComplexSum_o0_carry_n_6,
      CO(0) => dataComplexSum_o0_carry_n_7,
      DI(7 downto 0) => fifoOutComplex_0(7 downto 0),
      O(7 downto 0) => A(7 downto 0),
      S(7 downto 0) => DSP_A_B_DATA_INST(7 downto 0)
    );
\dataComplexSum_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataComplexSum_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataComplexSum_o0_carry__0_n_0\,
      CO(6) => \dataComplexSum_o0_carry__0_n_1\,
      CO(5) => \dataComplexSum_o0_carry__0_n_2\,
      CO(4) => \dataComplexSum_o0_carry__0_n_3\,
      CO(3) => \dataComplexSum_o0_carry__0_n_4\,
      CO(2) => \dataComplexSum_o0_carry__0_n_5\,
      CO(1) => \dataComplexSum_o0_carry__0_n_6\,
      CO(0) => \dataComplexSum_o0_carry__0_n_7\,
      DI(7 downto 0) => fifoOutComplex_0(15 downto 8),
      O(7 downto 0) => A(15 downto 8),
      S(7 downto 0) => DSP_A_B_DATA_INST_0(7 downto 0)
    );
\dataComplexSum_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexSum_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7 downto 5) => \NLW_dataComplexSum_o0_carry__1_CO_UNCONNECTED\(7 downto 5),
      CO(4) => \dataComplexSum_o0_carry__1_n_3\,
      CO(3) => \dataComplexSum_o0_carry__1_n_4\,
      CO(2) => \dataComplexSum_o0_carry__1_n_5\,
      CO(1) => \dataComplexSum_o0_carry__1_n_6\,
      CO(0) => \dataComplexSum_o0_carry__1_n_7\,
      DI(7 downto 5) => B"000",
      DI(4) => DSP_A_B_DATA_INST_1(0),
      DI(3 downto 0) => fifoOutComplex_0(19 downto 16),
      O(7 downto 6) => \NLW_dataComplexSum_o0_carry__1_O_UNCONNECTED\(7 downto 6),
      O(5 downto 0) => A(21 downto 16),
      S(7 downto 6) => B"00",
      S(5 downto 0) => DSP_A_B_DATA_INST_2(5 downto 0)
    );
dataReelDif_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '1',
      CI_TOP => '0',
      CO(7) => dataReelDif_o0_carry_n_0,
      CO(6) => dataReelDif_o0_carry_n_1,
      CO(5) => dataReelDif_o0_carry_n_2,
      CO(4) => dataReelDif_o0_carry_n_3,
      CO(3) => dataReelDif_o0_carry_n_4,
      CO(2) => dataReelDif_o0_carry_n_5,
      CO(1) => dataReelDif_o0_carry_n_6,
      CO(0) => dataReelDif_o0_carry_n_7,
      DI(7 downto 0) => DI(7 downto 0),
      O(7 downto 0) => difReel(7 downto 0),
      S(7 downto 0) => S(7 downto 0)
    );
\dataReelDif_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataReelDif_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataReelDif_o0_carry__0_n_0\,
      CO(6) => \dataReelDif_o0_carry__0_n_1\,
      CO(5) => \dataReelDif_o0_carry__0_n_2\,
      CO(4) => \dataReelDif_o0_carry__0_n_3\,
      CO(3) => \dataReelDif_o0_carry__0_n_4\,
      CO(2) => \dataReelDif_o0_carry__0_n_5\,
      CO(1) => \dataReelDif_o0_carry__0_n_6\,
      CO(0) => \dataReelDif_o0_carry__0_n_7\,
      DI(7 downto 0) => \gRam.mem_reg[31][15]\(7 downto 0),
      O(7 downto 0) => difReel(15 downto 8),
      S(7 downto 0) => \gRam.mem_reg[31][15]_0\(7 downto 0)
    );
\dataReelDif_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelDif_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7 downto 5) => \NLW_dataReelDif_o0_carry__1_CO_UNCONNECTED\(7 downto 5),
      CO(4) => \dataReelDif_o0_carry__1_n_3\,
      CO(3) => \dataReelDif_o0_carry__1_n_4\,
      CO(2) => \dataReelDif_o0_carry__1_n_5\,
      CO(1) => \dataReelDif_o0_carry__1_n_6\,
      CO(0) => \dataReelDif_o0_carry__1_n_7\,
      DI(7 downto 5) => B"000",
      DI(4 downto 0) => \gRam.mem_reg[0][21]\(4 downto 0),
      O(7 downto 6) => \NLW_dataReelDif_o0_carry__1_O_UNCONNECTED\(7 downto 6),
      O(5 downto 0) => O(5 downto 0),
      S(7 downto 6) => B"00",
      S(5 downto 0) => \gRam.mem_reg[0][21]_0\(5 downto 0)
    );
dataReelSum_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '0',
      CI_TOP => '0',
      CO(7) => dataReelSum_o0_carry_n_0,
      CO(6) => dataReelSum_o0_carry_n_1,
      CO(5) => dataReelSum_o0_carry_n_2,
      CO(4) => dataReelSum_o0_carry_n_3,
      CO(3) => dataReelSum_o0_carry_n_4,
      CO(2) => dataReelSum_o0_carry_n_5,
      CO(1) => dataReelSum_o0_carry_n_6,
      CO(0) => dataReelSum_o0_carry_n_7,
      DI(7 downto 0) => DI(7 downto 0),
      O(7 downto 0) => \cnt_reg[5]\(7 downto 0),
      S(7 downto 0) => DSP_A_B_DATA_INST_3(7 downto 0)
    );
\dataReelSum_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataReelSum_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataReelSum_o0_carry__0_n_0\,
      CO(6) => \dataReelSum_o0_carry__0_n_1\,
      CO(5) => \dataReelSum_o0_carry__0_n_2\,
      CO(4) => \dataReelSum_o0_carry__0_n_3\,
      CO(3) => \dataReelSum_o0_carry__0_n_4\,
      CO(2) => \dataReelSum_o0_carry__0_n_5\,
      CO(1) => \dataReelSum_o0_carry__0_n_6\,
      CO(0) => \dataReelSum_o0_carry__0_n_7\,
      DI(7 downto 0) => \gRam.mem_reg[31][15]\(7 downto 0),
      O(7 downto 0) => \cnt_reg[5]\(15 downto 8),
      S(7 downto 0) => DSP_A_B_DATA_INST_4(7 downto 0)
    );
\dataReelSum_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelSum_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7 downto 5) => \NLW_dataReelSum_o0_carry__1_CO_UNCONNECTED\(7 downto 5),
      CO(4) => \dataReelSum_o0_carry__1_n_3\,
      CO(3) => \dataReelSum_o0_carry__1_n_4\,
      CO(2) => \dataReelSum_o0_carry__1_n_5\,
      CO(1) => \dataReelSum_o0_carry__1_n_6\,
      CO(0) => \dataReelSum_o0_carry__1_n_7\,
      DI(7 downto 5) => B"000",
      DI(4) => DSP_A_B_DATA_INST_5(0),
      DI(3 downto 0) => \gRam.mem_reg[0][21]\(3 downto 0),
      O(7 downto 6) => \NLW_dataReelSum_o0_carry__1_O_UNCONNECTED\(7 downto 6),
      O(5 downto 0) => \cnt_reg[5]\(21 downto 16),
      S(7 downto 6) => B"00",
      S(5 downto 0) => DSP_A_B_DATA_INST_6(5 downto 0)
    );
\gRam.mem[31][0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(0),
      I1 => \gRam.mem_reg[31][15]_1\(0),
      I2 => \gRam.mem_reg[31][8]\,
      I3 => Q(0),
      O => D(0)
    );
\gRam.mem[31][10]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(10),
      I1 => \gRam.mem_reg[31][15]_1\(10),
      I2 => \gRam.mem_reg[31][8]\,
      I3 => Q(0),
      O => D(10)
    );
\gRam.mem[31][11]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(11),
      I1 => \gRam.mem_reg[31][15]_1\(11),
      I2 => \gRam.mem_reg[31][8]\,
      I3 => Q(0),
      O => D(11)
    );
\gRam.mem[31][12]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(12),
      I1 => \gRam.mem_reg[31][15]_1\(12),
      I2 => \gRam.mem_reg[31][8]\,
      I3 => Q(0),
      O => D(12)
    );
\gRam.mem[31][13]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(13),
      I1 => \gRam.mem_reg[31][15]_1\(13),
      I2 => \gRam.mem_reg[31][8]\,
      I3 => Q(0),
      O => D(13)
    );
\gRam.mem[31][14]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(14),
      I1 => \gRam.mem_reg[31][15]_1\(14),
      I2 => \gRam.mem_reg[31][8]\,
      I3 => Q(0),
      O => D(14)
    );
\gRam.mem[31][15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(15),
      I1 => \gRam.mem_reg[31][15]_1\(15),
      I2 => \gRam.mem_reg[31][8]\,
      I3 => Q(0),
      O => D(15)
    );
\gRam.mem[31][1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(1),
      I1 => \gRam.mem_reg[31][15]_1\(1),
      I2 => \gRam.mem_reg[31][8]\,
      I3 => Q(0),
      O => D(1)
    );
\gRam.mem[31][22]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(0),
      I1 => \gRam.mem_reg[31][37]_0\(0),
      I2 => OPMODE(0),
      I3 => Q(0),
      O => D(16)
    );
\gRam.mem[31][23]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(1),
      I1 => \gRam.mem_reg[31][37]_0\(1),
      I2 => OPMODE(0),
      I3 => Q(0),
      O => D(17)
    );
\gRam.mem[31][24]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(2),
      I1 => \gRam.mem_reg[31][37]_0\(2),
      I2 => OPMODE(0),
      I3 => Q(0),
      O => D(18)
    );
\gRam.mem[31][25]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(3),
      I1 => \gRam.mem_reg[31][37]_0\(3),
      I2 => OPMODE(0),
      I3 => Q(0),
      O => D(19)
    );
\gRam.mem[31][26]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(4),
      I1 => \gRam.mem_reg[31][37]_0\(4),
      I2 => OPMODE(0),
      I3 => Q(0),
      O => D(20)
    );
\gRam.mem[31][27]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(5),
      I1 => \gRam.mem_reg[31][37]_0\(5),
      I2 => OPMODE(0),
      I3 => Q(0),
      O => D(21)
    );
\gRam.mem[31][28]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(6),
      I1 => \gRam.mem_reg[31][37]_0\(6),
      I2 => OPMODE(0),
      I3 => Q(0),
      O => D(22)
    );
\gRam.mem[31][29]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(7),
      I1 => \gRam.mem_reg[31][37]_0\(7),
      I2 => OPMODE(0),
      I3 => Q(0),
      O => D(23)
    );
\gRam.mem[31][2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(2),
      I1 => \gRam.mem_reg[31][15]_1\(2),
      I2 => \gRam.mem_reg[31][8]\,
      I3 => Q(0),
      O => D(2)
    );
\gRam.mem[31][30]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(8),
      I1 => \gRam.mem_reg[31][37]_0\(8),
      I2 => OPMODE(0),
      I3 => Q(0),
      O => D(24)
    );
\gRam.mem[31][31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(9),
      I1 => \gRam.mem_reg[31][37]_0\(9),
      I2 => OPMODE(0),
      I3 => Q(0),
      O => D(25)
    );
\gRam.mem[31][32]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(10),
      I1 => \gRam.mem_reg[31][37]_0\(10),
      I2 => OPMODE(0),
      I3 => Q(0),
      O => D(26)
    );
\gRam.mem[31][33]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(11),
      I1 => \gRam.mem_reg[31][37]_0\(11),
      I2 => OPMODE(0),
      I3 => Q(0),
      O => D(27)
    );
\gRam.mem[31][34]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(12),
      I1 => \gRam.mem_reg[31][37]_0\(12),
      I2 => OPMODE(0),
      I3 => Q(0),
      O => D(28)
    );
\gRam.mem[31][35]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(13),
      I1 => \gRam.mem_reg[31][37]_0\(13),
      I2 => OPMODE(0),
      I3 => Q(0),
      O => D(29)
    );
\gRam.mem[31][36]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(14),
      I1 => \gRam.mem_reg[31][37]_0\(14),
      I2 => OPMODE(0),
      I3 => Q(0),
      O => D(30)
    );
\gRam.mem[31][37]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(15),
      I1 => \gRam.mem_reg[31][37]_0\(15),
      I2 => OPMODE(0),
      I3 => Q(0),
      O => D(31)
    );
\gRam.mem[31][3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(3),
      I1 => \gRam.mem_reg[31][15]_1\(3),
      I2 => \gRam.mem_reg[31][8]\,
      I3 => Q(0),
      O => D(3)
    );
\gRam.mem[31][4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(4),
      I1 => \gRam.mem_reg[31][15]_1\(4),
      I2 => \gRam.mem_reg[31][8]\,
      I3 => Q(0),
      O => D(4)
    );
\gRam.mem[31][5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(5),
      I1 => \gRam.mem_reg[31][15]_1\(5),
      I2 => \gRam.mem_reg[31][8]\,
      I3 => Q(0),
      O => D(5)
    );
\gRam.mem[31][6]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(6),
      I1 => \gRam.mem_reg[31][15]_1\(6),
      I2 => \gRam.mem_reg[31][8]\,
      I3 => Q(0),
      O => D(6)
    );
\gRam.mem[31][7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(7),
      I1 => \gRam.mem_reg[31][15]_1\(7),
      I2 => \gRam.mem_reg[31][8]\,
      I3 => Q(0),
      O => D(7)
    );
\gRam.mem[31][8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(8),
      I1 => \gRam.mem_reg[31][15]_1\(8),
      I2 => \gRam.mem_reg[31][8]\,
      I3 => Q(0),
      O => D(8)
    );
\gRam.mem[31][9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(9),
      I1 => \gRam.mem_reg[31][15]_1\(9),
      I2 => \gRam.mem_reg[31][8]\,
      I3 => Q(0),
      O => D(9)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \design_1_radar_wrapper_0_1_butterflyUnit__parameterized1\ is
  port (
    O : out STD_LOGIC_VECTOR ( 6 downto 0 );
    \complexOut_o1_i_1__0\ : out STD_LOGIC_VECTOR ( 6 downto 0 );
    A : out STD_LOGIC_VECTOR ( 22 downto 0 );
    \cnt_reg[4]\ : out STD_LOGIC_VECTOR ( 22 downto 0 );
    D : out STD_LOGIC_VECTOR ( 31 downto 0 );
    DI : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[15][15]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[15][15]_0\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][22]\ : in STD_LOGIC_VECTOR ( 5 downto 0 );
    \gRam.mem_reg[0][22]_0\ : in STD_LOGIC_VECTOR ( 6 downto 0 );
    fifoOutComplex_0 : in STD_LOGIC_VECTOR ( 20 downto 0 );
    \gRam.mem_reg[15][30]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[15][38]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][45]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gRam.mem_reg[0][45]_0\ : in STD_LOGIC_VECTOR ( 6 downto 0 );
    DSP_A_B_DATA_INST : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_0 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    DSP_A_B_DATA_INST_2 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    DSP_A_B_DATA_INST_3 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_4 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_5 : in STD_LOGIC_VECTOR ( 0 to 0 );
    DSP_A_B_DATA_INST_6 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    \gRam.mem_reg[15][15]_1\ : in STD_LOGIC_VECTOR ( 15 downto 0 );
    \gRam.mem_reg[15][8]\ : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gRam.mem_reg[15][38]_0\ : in STD_LOGIC_VECTOR ( 15 downto 0 );
    \gRam.mem_reg[15][38]_1\ : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \design_1_radar_wrapper_0_1_butterflyUnit__parameterized1\ : entity is "butterflyUnit";
end \design_1_radar_wrapper_0_1_butterflyUnit__parameterized1\;

architecture STRUCTURE of \design_1_radar_wrapper_0_1_butterflyUnit__parameterized1\ is
  signal \dataComplexDif_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_0 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_1 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_2 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_3 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_4 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_5 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_6 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_7 : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_0 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_1 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_2 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_3 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_4 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_5 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_6 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_7 : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataReelDif_o0_carry_n_0 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_1 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_2 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_3 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_4 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_5 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_6 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_7 : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataReelSum_o0_carry_n_0 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_1 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_2 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_3 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_4 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_5 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_6 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_7 : STD_LOGIC;
  signal difComplex : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal difReel : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal \NLW_dataComplexDif_o0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 6 );
  signal \NLW_dataComplexDif_o0_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 to 7 );
  signal \NLW_dataComplexSum_o0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 6 );
  signal \NLW_dataComplexSum_o0_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 to 7 );
  signal \NLW_dataReelDif_o0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 6 );
  signal \NLW_dataReelDif_o0_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 to 7 );
  signal \NLW_dataReelSum_o0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 6 );
  signal \NLW_dataReelSum_o0_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 to 7 );
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of dataComplexDif_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexDif_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexDif_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of dataComplexSum_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexSum_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexSum_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of dataReelDif_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataReelDif_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelDif_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of dataReelSum_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataReelSum_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelSum_o0_carry__1\ : label is 35;
begin
dataComplexDif_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '1',
      CI_TOP => '0',
      CO(7) => dataComplexDif_o0_carry_n_0,
      CO(6) => dataComplexDif_o0_carry_n_1,
      CO(5) => dataComplexDif_o0_carry_n_2,
      CO(4) => dataComplexDif_o0_carry_n_3,
      CO(3) => dataComplexDif_o0_carry_n_4,
      CO(2) => dataComplexDif_o0_carry_n_5,
      CO(1) => dataComplexDif_o0_carry_n_6,
      CO(0) => dataComplexDif_o0_carry_n_7,
      DI(7 downto 0) => fifoOutComplex_0(7 downto 0),
      O(7 downto 0) => difComplex(7 downto 0),
      S(7 downto 0) => \gRam.mem_reg[15][30]\(7 downto 0)
    );
\dataComplexDif_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataComplexDif_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataComplexDif_o0_carry__0_n_0\,
      CO(6) => \dataComplexDif_o0_carry__0_n_1\,
      CO(5) => \dataComplexDif_o0_carry__0_n_2\,
      CO(4) => \dataComplexDif_o0_carry__0_n_3\,
      CO(3) => \dataComplexDif_o0_carry__0_n_4\,
      CO(2) => \dataComplexDif_o0_carry__0_n_5\,
      CO(1) => \dataComplexDif_o0_carry__0_n_6\,
      CO(0) => \dataComplexDif_o0_carry__0_n_7\,
      DI(7 downto 0) => fifoOutComplex_0(15 downto 8),
      O(7 downto 0) => difComplex(15 downto 8),
      S(7 downto 0) => \gRam.mem_reg[15][38]\(7 downto 0)
    );
\dataComplexDif_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexDif_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7 downto 6) => \NLW_dataComplexDif_o0_carry__1_CO_UNCONNECTED\(7 downto 6),
      CO(5) => \dataComplexDif_o0_carry__1_n_2\,
      CO(4) => \dataComplexDif_o0_carry__1_n_3\,
      CO(3) => \dataComplexDif_o0_carry__1_n_4\,
      CO(2) => \dataComplexDif_o0_carry__1_n_5\,
      CO(1) => \dataComplexDif_o0_carry__1_n_6\,
      CO(0) => \dataComplexDif_o0_carry__1_n_7\,
      DI(7 downto 6) => B"00",
      DI(5) => \gRam.mem_reg[0][45]\(0),
      DI(4 downto 0) => fifoOutComplex_0(20 downto 16),
      O(7) => \NLW_dataComplexDif_o0_carry__1_O_UNCONNECTED\(7),
      O(6 downto 0) => \complexOut_o1_i_1__0\(6 downto 0),
      S(7) => '0',
      S(6 downto 0) => \gRam.mem_reg[0][45]_0\(6 downto 0)
    );
dataComplexSum_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '0',
      CI_TOP => '0',
      CO(7) => dataComplexSum_o0_carry_n_0,
      CO(6) => dataComplexSum_o0_carry_n_1,
      CO(5) => dataComplexSum_o0_carry_n_2,
      CO(4) => dataComplexSum_o0_carry_n_3,
      CO(3) => dataComplexSum_o0_carry_n_4,
      CO(2) => dataComplexSum_o0_carry_n_5,
      CO(1) => dataComplexSum_o0_carry_n_6,
      CO(0) => dataComplexSum_o0_carry_n_7,
      DI(7 downto 0) => fifoOutComplex_0(7 downto 0),
      O(7 downto 0) => A(7 downto 0),
      S(7 downto 0) => DSP_A_B_DATA_INST(7 downto 0)
    );
\dataComplexSum_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataComplexSum_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataComplexSum_o0_carry__0_n_0\,
      CO(6) => \dataComplexSum_o0_carry__0_n_1\,
      CO(5) => \dataComplexSum_o0_carry__0_n_2\,
      CO(4) => \dataComplexSum_o0_carry__0_n_3\,
      CO(3) => \dataComplexSum_o0_carry__0_n_4\,
      CO(2) => \dataComplexSum_o0_carry__0_n_5\,
      CO(1) => \dataComplexSum_o0_carry__0_n_6\,
      CO(0) => \dataComplexSum_o0_carry__0_n_7\,
      DI(7 downto 0) => fifoOutComplex_0(15 downto 8),
      O(7 downto 0) => A(15 downto 8),
      S(7 downto 0) => DSP_A_B_DATA_INST_0(7 downto 0)
    );
\dataComplexSum_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexSum_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7 downto 6) => \NLW_dataComplexSum_o0_carry__1_CO_UNCONNECTED\(7 downto 6),
      CO(5) => \dataComplexSum_o0_carry__1_n_2\,
      CO(4) => \dataComplexSum_o0_carry__1_n_3\,
      CO(3) => \dataComplexSum_o0_carry__1_n_4\,
      CO(2) => \dataComplexSum_o0_carry__1_n_5\,
      CO(1) => \dataComplexSum_o0_carry__1_n_6\,
      CO(0) => \dataComplexSum_o0_carry__1_n_7\,
      DI(7 downto 6) => B"00",
      DI(5) => DSP_A_B_DATA_INST_1(0),
      DI(4 downto 0) => fifoOutComplex_0(20 downto 16),
      O(7) => \NLW_dataComplexSum_o0_carry__1_O_UNCONNECTED\(7),
      O(6 downto 0) => A(22 downto 16),
      S(7) => '0',
      S(6 downto 0) => DSP_A_B_DATA_INST_2(6 downto 0)
    );
dataReelDif_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '1',
      CI_TOP => '0',
      CO(7) => dataReelDif_o0_carry_n_0,
      CO(6) => dataReelDif_o0_carry_n_1,
      CO(5) => dataReelDif_o0_carry_n_2,
      CO(4) => dataReelDif_o0_carry_n_3,
      CO(3) => dataReelDif_o0_carry_n_4,
      CO(2) => dataReelDif_o0_carry_n_5,
      CO(1) => dataReelDif_o0_carry_n_6,
      CO(0) => dataReelDif_o0_carry_n_7,
      DI(7 downto 0) => DI(7 downto 0),
      O(7 downto 0) => difReel(7 downto 0),
      S(7 downto 0) => S(7 downto 0)
    );
\dataReelDif_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataReelDif_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataReelDif_o0_carry__0_n_0\,
      CO(6) => \dataReelDif_o0_carry__0_n_1\,
      CO(5) => \dataReelDif_o0_carry__0_n_2\,
      CO(4) => \dataReelDif_o0_carry__0_n_3\,
      CO(3) => \dataReelDif_o0_carry__0_n_4\,
      CO(2) => \dataReelDif_o0_carry__0_n_5\,
      CO(1) => \dataReelDif_o0_carry__0_n_6\,
      CO(0) => \dataReelDif_o0_carry__0_n_7\,
      DI(7 downto 0) => \gRam.mem_reg[15][15]\(7 downto 0),
      O(7 downto 0) => difReel(15 downto 8),
      S(7 downto 0) => \gRam.mem_reg[15][15]_0\(7 downto 0)
    );
\dataReelDif_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelDif_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7 downto 6) => \NLW_dataReelDif_o0_carry__1_CO_UNCONNECTED\(7 downto 6),
      CO(5) => \dataReelDif_o0_carry__1_n_2\,
      CO(4) => \dataReelDif_o0_carry__1_n_3\,
      CO(3) => \dataReelDif_o0_carry__1_n_4\,
      CO(2) => \dataReelDif_o0_carry__1_n_5\,
      CO(1) => \dataReelDif_o0_carry__1_n_6\,
      CO(0) => \dataReelDif_o0_carry__1_n_7\,
      DI(7 downto 6) => B"00",
      DI(5 downto 0) => \gRam.mem_reg[0][22]\(5 downto 0),
      O(7) => \NLW_dataReelDif_o0_carry__1_O_UNCONNECTED\(7),
      O(6 downto 0) => O(6 downto 0),
      S(7) => '0',
      S(6 downto 0) => \gRam.mem_reg[0][22]_0\(6 downto 0)
    );
dataReelSum_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '0',
      CI_TOP => '0',
      CO(7) => dataReelSum_o0_carry_n_0,
      CO(6) => dataReelSum_o0_carry_n_1,
      CO(5) => dataReelSum_o0_carry_n_2,
      CO(4) => dataReelSum_o0_carry_n_3,
      CO(3) => dataReelSum_o0_carry_n_4,
      CO(2) => dataReelSum_o0_carry_n_5,
      CO(1) => dataReelSum_o0_carry_n_6,
      CO(0) => dataReelSum_o0_carry_n_7,
      DI(7 downto 0) => DI(7 downto 0),
      O(7 downto 0) => \cnt_reg[4]\(7 downto 0),
      S(7 downto 0) => DSP_A_B_DATA_INST_3(7 downto 0)
    );
\dataReelSum_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataReelSum_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataReelSum_o0_carry__0_n_0\,
      CO(6) => \dataReelSum_o0_carry__0_n_1\,
      CO(5) => \dataReelSum_o0_carry__0_n_2\,
      CO(4) => \dataReelSum_o0_carry__0_n_3\,
      CO(3) => \dataReelSum_o0_carry__0_n_4\,
      CO(2) => \dataReelSum_o0_carry__0_n_5\,
      CO(1) => \dataReelSum_o0_carry__0_n_6\,
      CO(0) => \dataReelSum_o0_carry__0_n_7\,
      DI(7 downto 0) => \gRam.mem_reg[15][15]\(7 downto 0),
      O(7 downto 0) => \cnt_reg[4]\(15 downto 8),
      S(7 downto 0) => DSP_A_B_DATA_INST_4(7 downto 0)
    );
\dataReelSum_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelSum_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7 downto 6) => \NLW_dataReelSum_o0_carry__1_CO_UNCONNECTED\(7 downto 6),
      CO(5) => \dataReelSum_o0_carry__1_n_2\,
      CO(4) => \dataReelSum_o0_carry__1_n_3\,
      CO(3) => \dataReelSum_o0_carry__1_n_4\,
      CO(2) => \dataReelSum_o0_carry__1_n_5\,
      CO(1) => \dataReelSum_o0_carry__1_n_6\,
      CO(0) => \dataReelSum_o0_carry__1_n_7\,
      DI(7 downto 6) => B"00",
      DI(5) => DSP_A_B_DATA_INST_5(0),
      DI(4 downto 0) => \gRam.mem_reg[0][22]\(4 downto 0),
      O(7) => \NLW_dataReelSum_o0_carry__1_O_UNCONNECTED\(7),
      O(6 downto 0) => \cnt_reg[4]\(22 downto 16),
      S(7) => '0',
      S(6 downto 0) => DSP_A_B_DATA_INST_6(6 downto 0)
    );
\gRam.mem[15][0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(0),
      I1 => \gRam.mem_reg[15][15]_1\(0),
      I2 => \gRam.mem_reg[15][8]\,
      I3 => Q(0),
      O => D(0)
    );
\gRam.mem[15][10]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(10),
      I1 => \gRam.mem_reg[15][15]_1\(10),
      I2 => \gRam.mem_reg[15][8]\,
      I3 => Q(0),
      O => D(10)
    );
\gRam.mem[15][11]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(11),
      I1 => \gRam.mem_reg[15][15]_1\(11),
      I2 => \gRam.mem_reg[15][8]\,
      I3 => Q(0),
      O => D(11)
    );
\gRam.mem[15][12]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(12),
      I1 => \gRam.mem_reg[15][15]_1\(12),
      I2 => \gRam.mem_reg[15][8]\,
      I3 => Q(0),
      O => D(12)
    );
\gRam.mem[15][13]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(13),
      I1 => \gRam.mem_reg[15][15]_1\(13),
      I2 => \gRam.mem_reg[15][8]\,
      I3 => Q(0),
      O => D(13)
    );
\gRam.mem[15][14]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(14),
      I1 => \gRam.mem_reg[15][15]_1\(14),
      I2 => \gRam.mem_reg[15][8]\,
      I3 => Q(0),
      O => D(14)
    );
\gRam.mem[15][15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(15),
      I1 => \gRam.mem_reg[15][15]_1\(15),
      I2 => \gRam.mem_reg[15][8]\,
      I3 => Q(0),
      O => D(15)
    );
\gRam.mem[15][1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(1),
      I1 => \gRam.mem_reg[15][15]_1\(1),
      I2 => \gRam.mem_reg[15][8]\,
      I3 => Q(0),
      O => D(1)
    );
\gRam.mem[15][23]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(0),
      I1 => \gRam.mem_reg[15][38]_0\(0),
      I2 => \gRam.mem_reg[15][38]_1\(0),
      I3 => Q(0),
      O => D(16)
    );
\gRam.mem[15][24]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(1),
      I1 => \gRam.mem_reg[15][38]_0\(1),
      I2 => \gRam.mem_reg[15][38]_1\(0),
      I3 => Q(0),
      O => D(17)
    );
\gRam.mem[15][25]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(2),
      I1 => \gRam.mem_reg[15][38]_0\(2),
      I2 => \gRam.mem_reg[15][38]_1\(0),
      I3 => Q(0),
      O => D(18)
    );
\gRam.mem[15][26]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(3),
      I1 => \gRam.mem_reg[15][38]_0\(3),
      I2 => \gRam.mem_reg[15][38]_1\(0),
      I3 => Q(0),
      O => D(19)
    );
\gRam.mem[15][27]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(4),
      I1 => \gRam.mem_reg[15][38]_0\(4),
      I2 => \gRam.mem_reg[15][38]_1\(0),
      I3 => Q(0),
      O => D(20)
    );
\gRam.mem[15][28]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(5),
      I1 => \gRam.mem_reg[15][38]_0\(5),
      I2 => \gRam.mem_reg[15][38]_1\(0),
      I3 => Q(0),
      O => D(21)
    );
\gRam.mem[15][29]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(6),
      I1 => \gRam.mem_reg[15][38]_0\(6),
      I2 => \gRam.mem_reg[15][38]_1\(0),
      I3 => Q(0),
      O => D(22)
    );
\gRam.mem[15][2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(2),
      I1 => \gRam.mem_reg[15][15]_1\(2),
      I2 => \gRam.mem_reg[15][8]\,
      I3 => Q(0),
      O => D(2)
    );
\gRam.mem[15][30]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(7),
      I1 => \gRam.mem_reg[15][38]_0\(7),
      I2 => \gRam.mem_reg[15][38]_1\(0),
      I3 => Q(0),
      O => D(23)
    );
\gRam.mem[15][31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(8),
      I1 => \gRam.mem_reg[15][38]_0\(8),
      I2 => \gRam.mem_reg[15][38]_1\(0),
      I3 => Q(0),
      O => D(24)
    );
\gRam.mem[15][32]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(9),
      I1 => \gRam.mem_reg[15][38]_0\(9),
      I2 => \gRam.mem_reg[15][38]_1\(0),
      I3 => Q(0),
      O => D(25)
    );
\gRam.mem[15][33]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(10),
      I1 => \gRam.mem_reg[15][38]_0\(10),
      I2 => \gRam.mem_reg[15][38]_1\(0),
      I3 => Q(0),
      O => D(26)
    );
\gRam.mem[15][34]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(11),
      I1 => \gRam.mem_reg[15][38]_0\(11),
      I2 => \gRam.mem_reg[15][38]_1\(0),
      I3 => Q(0),
      O => D(27)
    );
\gRam.mem[15][35]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(12),
      I1 => \gRam.mem_reg[15][38]_0\(12),
      I2 => \gRam.mem_reg[15][38]_1\(0),
      I3 => Q(0),
      O => D(28)
    );
\gRam.mem[15][36]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(13),
      I1 => \gRam.mem_reg[15][38]_0\(13),
      I2 => \gRam.mem_reg[15][38]_1\(0),
      I3 => Q(0),
      O => D(29)
    );
\gRam.mem[15][37]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(14),
      I1 => \gRam.mem_reg[15][38]_0\(14),
      I2 => \gRam.mem_reg[15][38]_1\(0),
      I3 => Q(0),
      O => D(30)
    );
\gRam.mem[15][38]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(15),
      I1 => \gRam.mem_reg[15][38]_0\(15),
      I2 => \gRam.mem_reg[15][38]_1\(0),
      I3 => Q(0),
      O => D(31)
    );
\gRam.mem[15][3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(3),
      I1 => \gRam.mem_reg[15][15]_1\(3),
      I2 => \gRam.mem_reg[15][8]\,
      I3 => Q(0),
      O => D(3)
    );
\gRam.mem[15][4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(4),
      I1 => \gRam.mem_reg[15][15]_1\(4),
      I2 => \gRam.mem_reg[15][8]\,
      I3 => Q(0),
      O => D(4)
    );
\gRam.mem[15][5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(5),
      I1 => \gRam.mem_reg[15][15]_1\(5),
      I2 => \gRam.mem_reg[15][8]\,
      I3 => Q(0),
      O => D(5)
    );
\gRam.mem[15][6]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(6),
      I1 => \gRam.mem_reg[15][15]_1\(6),
      I2 => \gRam.mem_reg[15][8]\,
      I3 => Q(0),
      O => D(6)
    );
\gRam.mem[15][7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(7),
      I1 => \gRam.mem_reg[15][15]_1\(7),
      I2 => \gRam.mem_reg[15][8]\,
      I3 => Q(0),
      O => D(7)
    );
\gRam.mem[15][8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(8),
      I1 => \gRam.mem_reg[15][15]_1\(8),
      I2 => \gRam.mem_reg[15][8]\,
      I3 => Q(0),
      O => D(8)
    );
\gRam.mem[15][9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(9),
      I1 => \gRam.mem_reg[15][15]_1\(9),
      I2 => \gRam.mem_reg[15][8]\,
      I3 => Q(0),
      O => D(9)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \design_1_radar_wrapper_0_1_butterflyUnit__parameterized2\ is
  port (
    O : out STD_LOGIC_VECTOR ( 7 downto 0 );
    \complexOut_o1_i_1__5\ : out STD_LOGIC_VECTOR ( 7 downto 0 );
    A : out STD_LOGIC_VECTOR ( 23 downto 0 );
    \cnt_reg[3]\ : out STD_LOGIC_VECTOR ( 23 downto 0 );
    D : out STD_LOGIC_VECTOR ( 31 downto 0 );
    DI : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[7][15]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[7][15]_0\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][23]\ : in STD_LOGIC_VECTOR ( 6 downto 0 );
    \gRam.mem_reg[0][23]_0\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    fifoOutComplex_0 : in STD_LOGIC_VECTOR ( 21 downto 0 );
    \gRam.mem_reg[7][31]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[7][39]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][47]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gRam.mem_reg[0][47]_0\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_0 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    DSP_A_B_DATA_INST_2 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_3 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_4 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_5 : in STD_LOGIC_VECTOR ( 0 to 0 );
    DSP_A_B_DATA_INST_6 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[7][15]_1\ : in STD_LOGIC_VECTOR ( 15 downto 0 );
    \gRam.mem_reg[7][0]\ : in STD_LOGIC;
    ctrl : in STD_LOGIC;
    \gRam.mem_reg[7][39]_0\ : in STD_LOGIC_VECTOR ( 15 downto 0 );
    \gRam.mem_reg[7][24]\ : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \design_1_radar_wrapper_0_1_butterflyUnit__parameterized2\ : entity is "butterflyUnit";
end \design_1_radar_wrapper_0_1_butterflyUnit__parameterized2\;

architecture STRUCTURE of \design_1_radar_wrapper_0_1_butterflyUnit__parameterized2\ is
  signal \dataComplexDif_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_1\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_0 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_1 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_2 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_3 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_4 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_5 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_6 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_7 : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_1\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_0 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_1 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_2 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_3 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_4 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_5 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_6 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_7 : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_1\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataReelDif_o0_carry_n_0 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_1 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_2 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_3 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_4 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_5 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_6 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_7 : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_1\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataReelSum_o0_carry_n_0 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_1 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_2 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_3 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_4 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_5 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_6 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_7 : STD_LOGIC;
  signal difComplex : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal difReel : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal \NLW_dataComplexDif_o0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 to 7 );
  signal \NLW_dataComplexSum_o0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 to 7 );
  signal \NLW_dataReelDif_o0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 to 7 );
  signal \NLW_dataReelSum_o0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 to 7 );
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of dataComplexDif_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexDif_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexDif_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of dataComplexSum_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexSum_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexSum_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of dataReelDif_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataReelDif_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelDif_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of dataReelSum_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataReelSum_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelSum_o0_carry__1\ : label is 35;
begin
dataComplexDif_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '1',
      CI_TOP => '0',
      CO(7) => dataComplexDif_o0_carry_n_0,
      CO(6) => dataComplexDif_o0_carry_n_1,
      CO(5) => dataComplexDif_o0_carry_n_2,
      CO(4) => dataComplexDif_o0_carry_n_3,
      CO(3) => dataComplexDif_o0_carry_n_4,
      CO(2) => dataComplexDif_o0_carry_n_5,
      CO(1) => dataComplexDif_o0_carry_n_6,
      CO(0) => dataComplexDif_o0_carry_n_7,
      DI(7 downto 0) => fifoOutComplex_0(7 downto 0),
      O(7 downto 0) => difComplex(7 downto 0),
      S(7 downto 0) => \gRam.mem_reg[7][31]\(7 downto 0)
    );
\dataComplexDif_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataComplexDif_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataComplexDif_o0_carry__0_n_0\,
      CO(6) => \dataComplexDif_o0_carry__0_n_1\,
      CO(5) => \dataComplexDif_o0_carry__0_n_2\,
      CO(4) => \dataComplexDif_o0_carry__0_n_3\,
      CO(3) => \dataComplexDif_o0_carry__0_n_4\,
      CO(2) => \dataComplexDif_o0_carry__0_n_5\,
      CO(1) => \dataComplexDif_o0_carry__0_n_6\,
      CO(0) => \dataComplexDif_o0_carry__0_n_7\,
      DI(7 downto 0) => fifoOutComplex_0(15 downto 8),
      O(7 downto 0) => difComplex(15 downto 8),
      S(7 downto 0) => \gRam.mem_reg[7][39]\(7 downto 0)
    );
\dataComplexDif_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexDif_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \NLW_dataComplexDif_o0_carry__1_CO_UNCONNECTED\(7),
      CO(6) => \dataComplexDif_o0_carry__1_n_1\,
      CO(5) => \dataComplexDif_o0_carry__1_n_2\,
      CO(4) => \dataComplexDif_o0_carry__1_n_3\,
      CO(3) => \dataComplexDif_o0_carry__1_n_4\,
      CO(2) => \dataComplexDif_o0_carry__1_n_5\,
      CO(1) => \dataComplexDif_o0_carry__1_n_6\,
      CO(0) => \dataComplexDif_o0_carry__1_n_7\,
      DI(7) => '0',
      DI(6) => \gRam.mem_reg[0][47]\(0),
      DI(5 downto 0) => fifoOutComplex_0(21 downto 16),
      O(7 downto 0) => \complexOut_o1_i_1__5\(7 downto 0),
      S(7 downto 0) => \gRam.mem_reg[0][47]_0\(7 downto 0)
    );
dataComplexSum_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '0',
      CI_TOP => '0',
      CO(7) => dataComplexSum_o0_carry_n_0,
      CO(6) => dataComplexSum_o0_carry_n_1,
      CO(5) => dataComplexSum_o0_carry_n_2,
      CO(4) => dataComplexSum_o0_carry_n_3,
      CO(3) => dataComplexSum_o0_carry_n_4,
      CO(2) => dataComplexSum_o0_carry_n_5,
      CO(1) => dataComplexSum_o0_carry_n_6,
      CO(0) => dataComplexSum_o0_carry_n_7,
      DI(7 downto 0) => fifoOutComplex_0(7 downto 0),
      O(7 downto 0) => A(7 downto 0),
      S(7 downto 0) => DSP_A_B_DATA_INST(7 downto 0)
    );
\dataComplexSum_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataComplexSum_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataComplexSum_o0_carry__0_n_0\,
      CO(6) => \dataComplexSum_o0_carry__0_n_1\,
      CO(5) => \dataComplexSum_o0_carry__0_n_2\,
      CO(4) => \dataComplexSum_o0_carry__0_n_3\,
      CO(3) => \dataComplexSum_o0_carry__0_n_4\,
      CO(2) => \dataComplexSum_o0_carry__0_n_5\,
      CO(1) => \dataComplexSum_o0_carry__0_n_6\,
      CO(0) => \dataComplexSum_o0_carry__0_n_7\,
      DI(7 downto 0) => fifoOutComplex_0(15 downto 8),
      O(7 downto 0) => A(15 downto 8),
      S(7 downto 0) => DSP_A_B_DATA_INST_0(7 downto 0)
    );
\dataComplexSum_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexSum_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \NLW_dataComplexSum_o0_carry__1_CO_UNCONNECTED\(7),
      CO(6) => \dataComplexSum_o0_carry__1_n_1\,
      CO(5) => \dataComplexSum_o0_carry__1_n_2\,
      CO(4) => \dataComplexSum_o0_carry__1_n_3\,
      CO(3) => \dataComplexSum_o0_carry__1_n_4\,
      CO(2) => \dataComplexSum_o0_carry__1_n_5\,
      CO(1) => \dataComplexSum_o0_carry__1_n_6\,
      CO(0) => \dataComplexSum_o0_carry__1_n_7\,
      DI(7) => '0',
      DI(6) => DSP_A_B_DATA_INST_1(0),
      DI(5 downto 0) => fifoOutComplex_0(21 downto 16),
      O(7 downto 0) => A(23 downto 16),
      S(7 downto 0) => DSP_A_B_DATA_INST_2(7 downto 0)
    );
dataReelDif_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '1',
      CI_TOP => '0',
      CO(7) => dataReelDif_o0_carry_n_0,
      CO(6) => dataReelDif_o0_carry_n_1,
      CO(5) => dataReelDif_o0_carry_n_2,
      CO(4) => dataReelDif_o0_carry_n_3,
      CO(3) => dataReelDif_o0_carry_n_4,
      CO(2) => dataReelDif_o0_carry_n_5,
      CO(1) => dataReelDif_o0_carry_n_6,
      CO(0) => dataReelDif_o0_carry_n_7,
      DI(7 downto 0) => DI(7 downto 0),
      O(7 downto 0) => difReel(7 downto 0),
      S(7 downto 0) => S(7 downto 0)
    );
\dataReelDif_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataReelDif_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataReelDif_o0_carry__0_n_0\,
      CO(6) => \dataReelDif_o0_carry__0_n_1\,
      CO(5) => \dataReelDif_o0_carry__0_n_2\,
      CO(4) => \dataReelDif_o0_carry__0_n_3\,
      CO(3) => \dataReelDif_o0_carry__0_n_4\,
      CO(2) => \dataReelDif_o0_carry__0_n_5\,
      CO(1) => \dataReelDif_o0_carry__0_n_6\,
      CO(0) => \dataReelDif_o0_carry__0_n_7\,
      DI(7 downto 0) => \gRam.mem_reg[7][15]\(7 downto 0),
      O(7 downto 0) => difReel(15 downto 8),
      S(7 downto 0) => \gRam.mem_reg[7][15]_0\(7 downto 0)
    );
\dataReelDif_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelDif_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \NLW_dataReelDif_o0_carry__1_CO_UNCONNECTED\(7),
      CO(6) => \dataReelDif_o0_carry__1_n_1\,
      CO(5) => \dataReelDif_o0_carry__1_n_2\,
      CO(4) => \dataReelDif_o0_carry__1_n_3\,
      CO(3) => \dataReelDif_o0_carry__1_n_4\,
      CO(2) => \dataReelDif_o0_carry__1_n_5\,
      CO(1) => \dataReelDif_o0_carry__1_n_6\,
      CO(0) => \dataReelDif_o0_carry__1_n_7\,
      DI(7) => '0',
      DI(6 downto 0) => \gRam.mem_reg[0][23]\(6 downto 0),
      O(7 downto 0) => O(7 downto 0),
      S(7 downto 0) => \gRam.mem_reg[0][23]_0\(7 downto 0)
    );
dataReelSum_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '0',
      CI_TOP => '0',
      CO(7) => dataReelSum_o0_carry_n_0,
      CO(6) => dataReelSum_o0_carry_n_1,
      CO(5) => dataReelSum_o0_carry_n_2,
      CO(4) => dataReelSum_o0_carry_n_3,
      CO(3) => dataReelSum_o0_carry_n_4,
      CO(2) => dataReelSum_o0_carry_n_5,
      CO(1) => dataReelSum_o0_carry_n_6,
      CO(0) => dataReelSum_o0_carry_n_7,
      DI(7 downto 0) => DI(7 downto 0),
      O(7 downto 0) => \cnt_reg[3]\(7 downto 0),
      S(7 downto 0) => DSP_A_B_DATA_INST_3(7 downto 0)
    );
\dataReelSum_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataReelSum_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataReelSum_o0_carry__0_n_0\,
      CO(6) => \dataReelSum_o0_carry__0_n_1\,
      CO(5) => \dataReelSum_o0_carry__0_n_2\,
      CO(4) => \dataReelSum_o0_carry__0_n_3\,
      CO(3) => \dataReelSum_o0_carry__0_n_4\,
      CO(2) => \dataReelSum_o0_carry__0_n_5\,
      CO(1) => \dataReelSum_o0_carry__0_n_6\,
      CO(0) => \dataReelSum_o0_carry__0_n_7\,
      DI(7 downto 0) => \gRam.mem_reg[7][15]\(7 downto 0),
      O(7 downto 0) => \cnt_reg[3]\(15 downto 8),
      S(7 downto 0) => DSP_A_B_DATA_INST_4(7 downto 0)
    );
\dataReelSum_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelSum_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \NLW_dataReelSum_o0_carry__1_CO_UNCONNECTED\(7),
      CO(6) => \dataReelSum_o0_carry__1_n_1\,
      CO(5) => \dataReelSum_o0_carry__1_n_2\,
      CO(4) => \dataReelSum_o0_carry__1_n_3\,
      CO(3) => \dataReelSum_o0_carry__1_n_4\,
      CO(2) => \dataReelSum_o0_carry__1_n_5\,
      CO(1) => \dataReelSum_o0_carry__1_n_6\,
      CO(0) => \dataReelSum_o0_carry__1_n_7\,
      DI(7) => '0',
      DI(6) => DSP_A_B_DATA_INST_5(0),
      DI(5 downto 0) => \gRam.mem_reg[0][23]\(5 downto 0),
      O(7 downto 0) => \cnt_reg[3]\(23 downto 16),
      S(7 downto 0) => DSP_A_B_DATA_INST_6(7 downto 0)
    );
\gRam.mem[7][0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(0),
      I1 => \gRam.mem_reg[7][15]_1\(0),
      I2 => \gRam.mem_reg[7][0]\,
      I3 => ctrl,
      O => D(0)
    );
\gRam.mem[7][10]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(10),
      I1 => \gRam.mem_reg[7][15]_1\(10),
      I2 => \gRam.mem_reg[7][0]\,
      I3 => ctrl,
      O => D(10)
    );
\gRam.mem[7][11]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(11),
      I1 => \gRam.mem_reg[7][15]_1\(11),
      I2 => \gRam.mem_reg[7][0]\,
      I3 => ctrl,
      O => D(11)
    );
\gRam.mem[7][12]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(12),
      I1 => \gRam.mem_reg[7][15]_1\(12),
      I2 => \gRam.mem_reg[7][0]\,
      I3 => ctrl,
      O => D(12)
    );
\gRam.mem[7][13]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(13),
      I1 => \gRam.mem_reg[7][15]_1\(13),
      I2 => \gRam.mem_reg[7][0]\,
      I3 => ctrl,
      O => D(13)
    );
\gRam.mem[7][14]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(14),
      I1 => \gRam.mem_reg[7][15]_1\(14),
      I2 => \gRam.mem_reg[7][0]\,
      I3 => ctrl,
      O => D(14)
    );
\gRam.mem[7][15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(15),
      I1 => \gRam.mem_reg[7][15]_1\(15),
      I2 => \gRam.mem_reg[7][0]\,
      I3 => ctrl,
      O => D(15)
    );
\gRam.mem[7][1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(1),
      I1 => \gRam.mem_reg[7][15]_1\(1),
      I2 => \gRam.mem_reg[7][0]\,
      I3 => ctrl,
      O => D(1)
    );
\gRam.mem[7][24]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(0),
      I1 => \gRam.mem_reg[7][39]_0\(0),
      I2 => \gRam.mem_reg[7][24]\,
      I3 => ctrl,
      O => D(16)
    );
\gRam.mem[7][25]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(1),
      I1 => \gRam.mem_reg[7][39]_0\(1),
      I2 => \gRam.mem_reg[7][24]\,
      I3 => ctrl,
      O => D(17)
    );
\gRam.mem[7][26]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(2),
      I1 => \gRam.mem_reg[7][39]_0\(2),
      I2 => \gRam.mem_reg[7][24]\,
      I3 => ctrl,
      O => D(18)
    );
\gRam.mem[7][27]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(3),
      I1 => \gRam.mem_reg[7][39]_0\(3),
      I2 => \gRam.mem_reg[7][24]\,
      I3 => ctrl,
      O => D(19)
    );
\gRam.mem[7][28]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(4),
      I1 => \gRam.mem_reg[7][39]_0\(4),
      I2 => \gRam.mem_reg[7][24]\,
      I3 => ctrl,
      O => D(20)
    );
\gRam.mem[7][29]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(5),
      I1 => \gRam.mem_reg[7][39]_0\(5),
      I2 => \gRam.mem_reg[7][24]\,
      I3 => ctrl,
      O => D(21)
    );
\gRam.mem[7][2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(2),
      I1 => \gRam.mem_reg[7][15]_1\(2),
      I2 => \gRam.mem_reg[7][0]\,
      I3 => ctrl,
      O => D(2)
    );
\gRam.mem[7][30]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(6),
      I1 => \gRam.mem_reg[7][39]_0\(6),
      I2 => \gRam.mem_reg[7][24]\,
      I3 => ctrl,
      O => D(22)
    );
\gRam.mem[7][31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(7),
      I1 => \gRam.mem_reg[7][39]_0\(7),
      I2 => \gRam.mem_reg[7][24]\,
      I3 => ctrl,
      O => D(23)
    );
\gRam.mem[7][32]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(8),
      I1 => \gRam.mem_reg[7][39]_0\(8),
      I2 => \gRam.mem_reg[7][24]\,
      I3 => ctrl,
      O => D(24)
    );
\gRam.mem[7][33]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(9),
      I1 => \gRam.mem_reg[7][39]_0\(9),
      I2 => \gRam.mem_reg[7][24]\,
      I3 => ctrl,
      O => D(25)
    );
\gRam.mem[7][34]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(10),
      I1 => \gRam.mem_reg[7][39]_0\(10),
      I2 => \gRam.mem_reg[7][24]\,
      I3 => ctrl,
      O => D(26)
    );
\gRam.mem[7][35]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(11),
      I1 => \gRam.mem_reg[7][39]_0\(11),
      I2 => \gRam.mem_reg[7][24]\,
      I3 => ctrl,
      O => D(27)
    );
\gRam.mem[7][36]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(12),
      I1 => \gRam.mem_reg[7][39]_0\(12),
      I2 => \gRam.mem_reg[7][24]\,
      I3 => ctrl,
      O => D(28)
    );
\gRam.mem[7][37]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(13),
      I1 => \gRam.mem_reg[7][39]_0\(13),
      I2 => \gRam.mem_reg[7][24]\,
      I3 => ctrl,
      O => D(29)
    );
\gRam.mem[7][38]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(14),
      I1 => \gRam.mem_reg[7][39]_0\(14),
      I2 => \gRam.mem_reg[7][24]\,
      I3 => ctrl,
      O => D(30)
    );
\gRam.mem[7][39]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(15),
      I1 => \gRam.mem_reg[7][39]_0\(15),
      I2 => \gRam.mem_reg[7][24]\,
      I3 => ctrl,
      O => D(31)
    );
\gRam.mem[7][3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(3),
      I1 => \gRam.mem_reg[7][15]_1\(3),
      I2 => \gRam.mem_reg[7][0]\,
      I3 => ctrl,
      O => D(3)
    );
\gRam.mem[7][4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(4),
      I1 => \gRam.mem_reg[7][15]_1\(4),
      I2 => \gRam.mem_reg[7][0]\,
      I3 => ctrl,
      O => D(4)
    );
\gRam.mem[7][5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(5),
      I1 => \gRam.mem_reg[7][15]_1\(5),
      I2 => \gRam.mem_reg[7][0]\,
      I3 => ctrl,
      O => D(5)
    );
\gRam.mem[7][6]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(6),
      I1 => \gRam.mem_reg[7][15]_1\(6),
      I2 => \gRam.mem_reg[7][0]\,
      I3 => ctrl,
      O => D(6)
    );
\gRam.mem[7][7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(7),
      I1 => \gRam.mem_reg[7][15]_1\(7),
      I2 => \gRam.mem_reg[7][0]\,
      I3 => ctrl,
      O => D(7)
    );
\gRam.mem[7][8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(8),
      I1 => \gRam.mem_reg[7][15]_1\(8),
      I2 => \gRam.mem_reg[7][0]\,
      I3 => ctrl,
      O => D(8)
    );
\gRam.mem[7][9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(9),
      I1 => \gRam.mem_reg[7][15]_1\(9),
      I2 => \gRam.mem_reg[7][0]\,
      I3 => ctrl,
      O => D(9)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \design_1_radar_wrapper_0_1_butterflyUnit__parameterized3\ is
  port (
    A : out STD_LOGIC_VECTOR ( 24 downto 0 );
    \gRam.mem_reg[0][24]_i_2\ : out STD_LOGIC_VECTOR ( 24 downto 0 );
    D : out STD_LOGIC_VECTOR ( 49 downto 0 );
    DI : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][15]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][15]_0\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][23]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][23]_0\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][24]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    fifoOutComplex : in STD_LOGIC_VECTOR ( 22 downto 0 );
    \gRam.mem_reg[0][32]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][40]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][48]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gRam.mem_reg[0][48]_0\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][49]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    DSP_A_B_DATA_INST : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_0 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_1 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    DSP_A_B_DATA_INST_3 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_4 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_5 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_6 : in STD_LOGIC_VECTOR ( 0 to 0 );
    Q : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gRam.mem_reg[0][48]_1\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gRam.mem_reg[0][48]_2\ : in STD_LOGIC_VECTOR ( 23 downto 0 );
    \gRam.mem_reg[0][8]\ : in STD_LOGIC;
    \gRam.mem_reg[0][23]_1\ : in STD_LOGIC_VECTOR ( 23 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \design_1_radar_wrapper_0_1_butterflyUnit__parameterized3\ : entity is "butterflyUnit";
end \design_1_radar_wrapper_0_1_butterflyUnit__parameterized3\;

architecture STRUCTURE of \design_1_radar_wrapper_0_1_butterflyUnit__parameterized3\ is
  signal \dataComplexDif_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_0\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_1\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_0 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_1 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_2 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_3 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_4 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_5 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_6 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_7 : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_i_1__4_n_0\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_0\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_1\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_0 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_1 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_2 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_3 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_4 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_5 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_6 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_7 : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_0\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_1\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataReelDif_o0_carry_n_0 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_1 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_2 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_3 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_4 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_5 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_6 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_7 : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_i_1__4_n_0\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_0\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_1\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_7\ : STD_LOGIC;
  signal dataReelSum_o0_carry_n_0 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_1 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_2 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_3 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_4 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_5 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_6 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_7 : STD_LOGIC;
  signal difComplex : STD_LOGIC_VECTOR ( 24 downto 0 );
  signal difReel : STD_LOGIC_VECTOR ( 24 downto 0 );
  signal \NLW_dataComplexDif_o0_carry__2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \NLW_dataComplexDif_o0_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 1 );
  signal \NLW_dataComplexSum_o0_carry__2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \NLW_dataComplexSum_o0_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 1 );
  signal \NLW_dataReelDif_o0_carry__2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \NLW_dataReelDif_o0_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 1 );
  signal \NLW_dataReelSum_o0_carry__2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \NLW_dataReelSum_o0_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 1 );
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of dataComplexDif_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexDif_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexDif_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexDif_o0_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of dataComplexSum_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexSum_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexSum_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexSum_o0_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of dataReelDif_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataReelDif_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelDif_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelDif_o0_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of dataReelSum_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataReelSum_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelSum_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelSum_o0_carry__2\ : label is 35;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \gRam.mem[0][23]_i_1\ : label is "soft_lutpair367";
  attribute SOFT_HLUTNM of \gRam.mem[0][24]_i_1\ : label is "soft_lutpair367";
  attribute SOFT_HLUTNM of \gRam.mem[0][48]_i_1\ : label is "soft_lutpair368";
  attribute SOFT_HLUTNM of \gRam.mem[0][49]_i_2\ : label is "soft_lutpair368";
begin
dataComplexDif_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '1',
      CI_TOP => '0',
      CO(7) => dataComplexDif_o0_carry_n_0,
      CO(6) => dataComplexDif_o0_carry_n_1,
      CO(5) => dataComplexDif_o0_carry_n_2,
      CO(4) => dataComplexDif_o0_carry_n_3,
      CO(3) => dataComplexDif_o0_carry_n_4,
      CO(2) => dataComplexDif_o0_carry_n_5,
      CO(1) => dataComplexDif_o0_carry_n_6,
      CO(0) => dataComplexDif_o0_carry_n_7,
      DI(7 downto 0) => fifoOutComplex(7 downto 0),
      O(7 downto 0) => difComplex(7 downto 0),
      S(7 downto 0) => \gRam.mem_reg[0][32]\(7 downto 0)
    );
\dataComplexDif_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataComplexDif_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataComplexDif_o0_carry__0_n_0\,
      CO(6) => \dataComplexDif_o0_carry__0_n_1\,
      CO(5) => \dataComplexDif_o0_carry__0_n_2\,
      CO(4) => \dataComplexDif_o0_carry__0_n_3\,
      CO(3) => \dataComplexDif_o0_carry__0_n_4\,
      CO(2) => \dataComplexDif_o0_carry__0_n_5\,
      CO(1) => \dataComplexDif_o0_carry__0_n_6\,
      CO(0) => \dataComplexDif_o0_carry__0_n_7\,
      DI(7 downto 0) => fifoOutComplex(15 downto 8),
      O(7 downto 0) => difComplex(15 downto 8),
      S(7 downto 0) => \gRam.mem_reg[0][40]\(7 downto 0)
    );
\dataComplexDif_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexDif_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \dataComplexDif_o0_carry__1_n_0\,
      CO(6) => \dataComplexDif_o0_carry__1_n_1\,
      CO(5) => \dataComplexDif_o0_carry__1_n_2\,
      CO(4) => \dataComplexDif_o0_carry__1_n_3\,
      CO(3) => \dataComplexDif_o0_carry__1_n_4\,
      CO(2) => \dataComplexDif_o0_carry__1_n_5\,
      CO(1) => \dataComplexDif_o0_carry__1_n_6\,
      CO(0) => \dataComplexDif_o0_carry__1_n_7\,
      DI(7) => \gRam.mem_reg[0][48]\(0),
      DI(6 downto 0) => fifoOutComplex(22 downto 16),
      O(7 downto 0) => difComplex(23 downto 16),
      S(7 downto 0) => \gRam.mem_reg[0][48]_0\(7 downto 0)
    );
\dataComplexDif_o0_carry__2\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexDif_o0_carry__1_n_0\,
      CI_TOP => '0',
      CO(7 downto 0) => \NLW_dataComplexDif_o0_carry__2_CO_UNCONNECTED\(7 downto 0),
      DI(7 downto 0) => B"00000000",
      O(7 downto 1) => \NLW_dataComplexDif_o0_carry__2_O_UNCONNECTED\(7 downto 1),
      O(0) => difComplex(24),
      S(7 downto 1) => B"0000000",
      S(0) => \gRam.mem_reg[0][49]\(0)
    );
dataComplexSum_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '0',
      CI_TOP => '0',
      CO(7) => dataComplexSum_o0_carry_n_0,
      CO(6) => dataComplexSum_o0_carry_n_1,
      CO(5) => dataComplexSum_o0_carry_n_2,
      CO(4) => dataComplexSum_o0_carry_n_3,
      CO(3) => dataComplexSum_o0_carry_n_4,
      CO(2) => dataComplexSum_o0_carry_n_5,
      CO(1) => dataComplexSum_o0_carry_n_6,
      CO(0) => dataComplexSum_o0_carry_n_7,
      DI(7 downto 0) => fifoOutComplex(7 downto 0),
      O(7 downto 0) => A(7 downto 0),
      S(7 downto 0) => DSP_A_B_DATA_INST(7 downto 0)
    );
\dataComplexSum_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataComplexSum_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataComplexSum_o0_carry__0_n_0\,
      CO(6) => \dataComplexSum_o0_carry__0_n_1\,
      CO(5) => \dataComplexSum_o0_carry__0_n_2\,
      CO(4) => \dataComplexSum_o0_carry__0_n_3\,
      CO(3) => \dataComplexSum_o0_carry__0_n_4\,
      CO(2) => \dataComplexSum_o0_carry__0_n_5\,
      CO(1) => \dataComplexSum_o0_carry__0_n_6\,
      CO(0) => \dataComplexSum_o0_carry__0_n_7\,
      DI(7 downto 0) => fifoOutComplex(15 downto 8),
      O(7 downto 0) => A(15 downto 8),
      S(7 downto 0) => DSP_A_B_DATA_INST_0(7 downto 0)
    );
\dataComplexSum_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexSum_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \dataComplexSum_o0_carry__1_n_0\,
      CO(6) => \dataComplexSum_o0_carry__1_n_1\,
      CO(5) => \dataComplexSum_o0_carry__1_n_2\,
      CO(4) => \dataComplexSum_o0_carry__1_n_3\,
      CO(3) => \dataComplexSum_o0_carry__1_n_4\,
      CO(2) => \dataComplexSum_o0_carry__1_n_5\,
      CO(1) => \dataComplexSum_o0_carry__1_n_6\,
      CO(0) => \dataComplexSum_o0_carry__1_n_7\,
      DI(7) => \dataComplexSum_o0_carry__1_i_1__4_n_0\,
      DI(6 downto 0) => fifoOutComplex(22 downto 16),
      O(7 downto 0) => A(23 downto 16),
      S(7 downto 0) => DSP_A_B_DATA_INST_1(7 downto 0)
    );
\dataComplexSum_o0_carry__1_i_1__4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => Q(0),
      I1 => \gRam.mem_reg[0][48]_1\(0),
      I2 => \gRam.mem_reg[0][48]_2\(23),
      O => \dataComplexSum_o0_carry__1_i_1__4_n_0\
    );
\dataComplexSum_o0_carry__2\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexSum_o0_carry__1_n_0\,
      CI_TOP => '0',
      CO(7 downto 0) => \NLW_dataComplexSum_o0_carry__2_CO_UNCONNECTED\(7 downto 0),
      DI(7 downto 0) => B"00000000",
      O(7 downto 1) => \NLW_dataComplexSum_o0_carry__2_O_UNCONNECTED\(7 downto 1),
      O(0) => A(24),
      S(7 downto 1) => B"0000000",
      S(0) => DSP_A_B_DATA_INST_2(0)
    );
dataReelDif_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '1',
      CI_TOP => '0',
      CO(7) => dataReelDif_o0_carry_n_0,
      CO(6) => dataReelDif_o0_carry_n_1,
      CO(5) => dataReelDif_o0_carry_n_2,
      CO(4) => dataReelDif_o0_carry_n_3,
      CO(3) => dataReelDif_o0_carry_n_4,
      CO(2) => dataReelDif_o0_carry_n_5,
      CO(1) => dataReelDif_o0_carry_n_6,
      CO(0) => dataReelDif_o0_carry_n_7,
      DI(7 downto 0) => DI(7 downto 0),
      O(7 downto 0) => difReel(7 downto 0),
      S(7 downto 0) => S(7 downto 0)
    );
\dataReelDif_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataReelDif_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataReelDif_o0_carry__0_n_0\,
      CO(6) => \dataReelDif_o0_carry__0_n_1\,
      CO(5) => \dataReelDif_o0_carry__0_n_2\,
      CO(4) => \dataReelDif_o0_carry__0_n_3\,
      CO(3) => \dataReelDif_o0_carry__0_n_4\,
      CO(2) => \dataReelDif_o0_carry__0_n_5\,
      CO(1) => \dataReelDif_o0_carry__0_n_6\,
      CO(0) => \dataReelDif_o0_carry__0_n_7\,
      DI(7 downto 0) => \gRam.mem_reg[0][15]\(7 downto 0),
      O(7 downto 0) => difReel(15 downto 8),
      S(7 downto 0) => \gRam.mem_reg[0][15]_0\(7 downto 0)
    );
\dataReelDif_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelDif_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \dataReelDif_o0_carry__1_n_0\,
      CO(6) => \dataReelDif_o0_carry__1_n_1\,
      CO(5) => \dataReelDif_o0_carry__1_n_2\,
      CO(4) => \dataReelDif_o0_carry__1_n_3\,
      CO(3) => \dataReelDif_o0_carry__1_n_4\,
      CO(2) => \dataReelDif_o0_carry__1_n_5\,
      CO(1) => \dataReelDif_o0_carry__1_n_6\,
      CO(0) => \dataReelDif_o0_carry__1_n_7\,
      DI(7 downto 0) => \gRam.mem_reg[0][23]\(7 downto 0),
      O(7 downto 0) => difReel(23 downto 16),
      S(7 downto 0) => \gRam.mem_reg[0][23]_0\(7 downto 0)
    );
\dataReelDif_o0_carry__2\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelDif_o0_carry__1_n_0\,
      CI_TOP => '0',
      CO(7 downto 0) => \NLW_dataReelDif_o0_carry__2_CO_UNCONNECTED\(7 downto 0),
      DI(7 downto 0) => B"00000000",
      O(7 downto 1) => \NLW_dataReelDif_o0_carry__2_O_UNCONNECTED\(7 downto 1),
      O(0) => difReel(24),
      S(7 downto 1) => B"0000000",
      S(0) => \gRam.mem_reg[0][24]\(0)
    );
dataReelSum_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '0',
      CI_TOP => '0',
      CO(7) => dataReelSum_o0_carry_n_0,
      CO(6) => dataReelSum_o0_carry_n_1,
      CO(5) => dataReelSum_o0_carry_n_2,
      CO(4) => dataReelSum_o0_carry_n_3,
      CO(3) => dataReelSum_o0_carry_n_4,
      CO(2) => dataReelSum_o0_carry_n_5,
      CO(1) => dataReelSum_o0_carry_n_6,
      CO(0) => dataReelSum_o0_carry_n_7,
      DI(7 downto 0) => DI(7 downto 0),
      O(7 downto 0) => \gRam.mem_reg[0][24]_i_2\(7 downto 0),
      S(7 downto 0) => DSP_A_B_DATA_INST_3(7 downto 0)
    );
\dataReelSum_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataReelSum_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataReelSum_o0_carry__0_n_0\,
      CO(6) => \dataReelSum_o0_carry__0_n_1\,
      CO(5) => \dataReelSum_o0_carry__0_n_2\,
      CO(4) => \dataReelSum_o0_carry__0_n_3\,
      CO(3) => \dataReelSum_o0_carry__0_n_4\,
      CO(2) => \dataReelSum_o0_carry__0_n_5\,
      CO(1) => \dataReelSum_o0_carry__0_n_6\,
      CO(0) => \dataReelSum_o0_carry__0_n_7\,
      DI(7 downto 0) => \gRam.mem_reg[0][15]\(7 downto 0),
      O(7 downto 0) => \gRam.mem_reg[0][24]_i_2\(15 downto 8),
      S(7 downto 0) => DSP_A_B_DATA_INST_4(7 downto 0)
    );
\dataReelSum_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelSum_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \dataReelSum_o0_carry__1_n_0\,
      CO(6) => \dataReelSum_o0_carry__1_n_1\,
      CO(5) => \dataReelSum_o0_carry__1_n_2\,
      CO(4) => \dataReelSum_o0_carry__1_n_3\,
      CO(3) => \dataReelSum_o0_carry__1_n_4\,
      CO(2) => \dataReelSum_o0_carry__1_n_5\,
      CO(1) => \dataReelSum_o0_carry__1_n_6\,
      CO(0) => \dataReelSum_o0_carry__1_n_7\,
      DI(7) => \dataReelSum_o0_carry__1_i_1__4_n_0\,
      DI(6 downto 0) => \gRam.mem_reg[0][23]\(6 downto 0),
      O(7 downto 0) => \gRam.mem_reg[0][24]_i_2\(23 downto 16),
      S(7 downto 0) => DSP_A_B_DATA_INST_5(7 downto 0)
    );
\dataReelSum_o0_carry__1_i_1__4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => Q(0),
      I1 => \gRam.mem_reg[0][8]\,
      I2 => \gRam.mem_reg[0][23]_1\(23),
      O => \dataReelSum_o0_carry__1_i_1__4_n_0\
    );
\dataReelSum_o0_carry__2\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelSum_o0_carry__1_n_0\,
      CI_TOP => '0',
      CO(7 downto 0) => \NLW_dataReelSum_o0_carry__2_CO_UNCONNECTED\(7 downto 0),
      DI(7 downto 0) => B"00000000",
      O(7 downto 1) => \NLW_dataReelSum_o0_carry__2_O_UNCONNECTED\(7 downto 1),
      O(0) => \gRam.mem_reg[0][24]_i_2\(24),
      S(7 downto 1) => B"0000000",
      S(0) => DSP_A_B_DATA_INST_6(0)
    );
\gRam.mem[0][0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(0),
      I1 => \gRam.mem_reg[0][23]_1\(0),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(0)
    );
\gRam.mem[0][10]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(10),
      I1 => \gRam.mem_reg[0][23]_1\(10),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(10)
    );
\gRam.mem[0][11]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(11),
      I1 => \gRam.mem_reg[0][23]_1\(11),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(11)
    );
\gRam.mem[0][12]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(12),
      I1 => \gRam.mem_reg[0][23]_1\(12),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(12)
    );
\gRam.mem[0][13]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(13),
      I1 => \gRam.mem_reg[0][23]_1\(13),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(13)
    );
\gRam.mem[0][14]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(14),
      I1 => \gRam.mem_reg[0][23]_1\(14),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(14)
    );
\gRam.mem[0][15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(15),
      I1 => \gRam.mem_reg[0][23]_1\(15),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(15)
    );
\gRam.mem[0][16]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(16),
      I1 => \gRam.mem_reg[0][23]_1\(16),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(16)
    );
\gRam.mem[0][17]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(17),
      I1 => \gRam.mem_reg[0][23]_1\(17),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(17)
    );
\gRam.mem[0][18]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(18),
      I1 => \gRam.mem_reg[0][23]_1\(18),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(18)
    );
\gRam.mem[0][19]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(19),
      I1 => \gRam.mem_reg[0][23]_1\(19),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(19)
    );
\gRam.mem[0][1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(1),
      I1 => \gRam.mem_reg[0][23]_1\(1),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(1)
    );
\gRam.mem[0][20]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(20),
      I1 => \gRam.mem_reg[0][23]_1\(20),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(20)
    );
\gRam.mem[0][21]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(21),
      I1 => \gRam.mem_reg[0][23]_1\(21),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(21)
    );
\gRam.mem[0][22]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(22),
      I1 => \gRam.mem_reg[0][23]_1\(22),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(22)
    );
\gRam.mem[0][23]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(23),
      I1 => \gRam.mem_reg[0][23]_1\(23),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(23)
    );
\gRam.mem[0][24]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(24),
      I1 => \gRam.mem_reg[0][23]_1\(23),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(24)
    );
\gRam.mem[0][25]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(0),
      I1 => \gRam.mem_reg[0][48]_2\(0),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(25)
    );
\gRam.mem[0][26]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(1),
      I1 => \gRam.mem_reg[0][48]_2\(1),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(26)
    );
\gRam.mem[0][27]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(2),
      I1 => \gRam.mem_reg[0][48]_2\(2),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(27)
    );
\gRam.mem[0][28]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(3),
      I1 => \gRam.mem_reg[0][48]_2\(3),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(28)
    );
\gRam.mem[0][29]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(4),
      I1 => \gRam.mem_reg[0][48]_2\(4),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(29)
    );
\gRam.mem[0][2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(2),
      I1 => \gRam.mem_reg[0][23]_1\(2),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(2)
    );
\gRam.mem[0][30]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(5),
      I1 => \gRam.mem_reg[0][48]_2\(5),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(30)
    );
\gRam.mem[0][31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(6),
      I1 => \gRam.mem_reg[0][48]_2\(6),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(31)
    );
\gRam.mem[0][32]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(7),
      I1 => \gRam.mem_reg[0][48]_2\(7),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(32)
    );
\gRam.mem[0][33]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(8),
      I1 => \gRam.mem_reg[0][48]_2\(8),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(33)
    );
\gRam.mem[0][34]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(9),
      I1 => \gRam.mem_reg[0][48]_2\(9),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(34)
    );
\gRam.mem[0][35]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(10),
      I1 => \gRam.mem_reg[0][48]_2\(10),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(35)
    );
\gRam.mem[0][36]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(11),
      I1 => \gRam.mem_reg[0][48]_2\(11),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(36)
    );
\gRam.mem[0][37]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(12),
      I1 => \gRam.mem_reg[0][48]_2\(12),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(37)
    );
\gRam.mem[0][38]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(13),
      I1 => \gRam.mem_reg[0][48]_2\(13),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(38)
    );
\gRam.mem[0][39]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(14),
      I1 => \gRam.mem_reg[0][48]_2\(14),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(39)
    );
\gRam.mem[0][3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(3),
      I1 => \gRam.mem_reg[0][23]_1\(3),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(3)
    );
\gRam.mem[0][40]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(15),
      I1 => \gRam.mem_reg[0][48]_2\(15),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(40)
    );
\gRam.mem[0][41]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(16),
      I1 => \gRam.mem_reg[0][48]_2\(16),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(41)
    );
\gRam.mem[0][42]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(17),
      I1 => \gRam.mem_reg[0][48]_2\(17),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(42)
    );
\gRam.mem[0][43]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(18),
      I1 => \gRam.mem_reg[0][48]_2\(18),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(43)
    );
\gRam.mem[0][44]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(19),
      I1 => \gRam.mem_reg[0][48]_2\(19),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(44)
    );
\gRam.mem[0][45]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(20),
      I1 => \gRam.mem_reg[0][48]_2\(20),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(45)
    );
\gRam.mem[0][46]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(21),
      I1 => \gRam.mem_reg[0][48]_2\(21),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(46)
    );
\gRam.mem[0][47]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(22),
      I1 => \gRam.mem_reg[0][48]_2\(22),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(47)
    );
\gRam.mem[0][48]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(23),
      I1 => \gRam.mem_reg[0][48]_2\(23),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(48)
    );
\gRam.mem[0][49]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(24),
      I1 => \gRam.mem_reg[0][48]_2\(23),
      I2 => \gRam.mem_reg[0][48]_1\(0),
      I3 => Q(0),
      O => D(49)
    );
\gRam.mem[0][4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(4),
      I1 => \gRam.mem_reg[0][23]_1\(4),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(4)
    );
\gRam.mem[0][5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(5),
      I1 => \gRam.mem_reg[0][23]_1\(5),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(5)
    );
\gRam.mem[0][6]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(6),
      I1 => \gRam.mem_reg[0][23]_1\(6),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(6)
    );
\gRam.mem[0][7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(7),
      I1 => \gRam.mem_reg[0][23]_1\(7),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(7)
    );
\gRam.mem[0][8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(8),
      I1 => \gRam.mem_reg[0][23]_1\(8),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(8)
    );
\gRam.mem[0][9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(9),
      I1 => \gRam.mem_reg[0][23]_1\(9),
      I2 => \gRam.mem_reg[0][8]\,
      I3 => Q(0),
      O => D(9)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \design_1_radar_wrapper_0_1_butterflyUnit__parameterized4\ is
  port (
    O : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \complexOut_o1__0_i_1\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    A : out STD_LOGIC_VECTOR ( 25 downto 0 );
    \cnt_reg[1]\ : out STD_LOGIC_VECTOR ( 25 downto 0 );
    D : out STD_LOGIC_VECTOR ( 47 downto 0 );
    DI : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][15]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][15]_0\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][23]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][23]_0\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[1][25]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gRam.mem_reg[1][25]_0\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \gRam.mem_reg[0][33]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][33]_0\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][41]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][41]_0\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][49]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[0][49]_0\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gRam.mem_reg[1][51]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gRam.mem_reg[1][51]_0\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    fifoOutComplex : in STD_LOGIC_VECTOR ( 23 downto 0 );
    DSP_A_B_DATA_INST : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_0 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_1 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    DSP_A_B_DATA_INST_3 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    DSP_A_B_DATA_INST_4 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_5 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_6 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_7 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_8 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_9 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_10 : in STD_LOGIC_VECTOR ( 0 to 0 );
    DSP_A_B_DATA_INST_11 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \gRam.mem_reg[0][23]_1\ : in STD_LOGIC_VECTOR ( 23 downto 0 );
    \gRam.mem_reg[0][0]\ : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gRam.mem_reg[0][49]_1\ : in STD_LOGIC_VECTOR ( 23 downto 0 );
    \gRam.mem_reg[0][49]_2\ : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \design_1_radar_wrapper_0_1_butterflyUnit__parameterized4\ : entity is "butterflyUnit";
end \design_1_radar_wrapper_0_1_butterflyUnit__parameterized4\;

architecture STRUCTURE of \design_1_radar_wrapper_0_1_butterflyUnit__parameterized4\ is
  signal \dataComplexDif_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_0\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_1\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_7\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__2_n_7\ : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_0 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_1 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_2 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_3 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_4 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_5 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_6 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_7 : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_0\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_1\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_7\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__2_n_7\ : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_0 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_1 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_2 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_3 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_4 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_5 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_6 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_7 : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_0\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_1\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_7\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__2_n_7\ : STD_LOGIC;
  signal dataReelDif_o0_carry_n_0 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_1 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_2 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_3 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_4 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_5 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_6 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_7 : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_0\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_1\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_7\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__2_n_7\ : STD_LOGIC;
  signal dataReelSum_o0_carry_n_0 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_1 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_2 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_3 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_4 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_5 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_6 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_7 : STD_LOGIC;
  signal difComplex : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal difReel : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal \NLW_dataComplexDif_o0_carry__2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 1 );
  signal \NLW_dataComplexDif_o0_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 2 );
  signal \NLW_dataComplexSum_o0_carry__2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 1 );
  signal \NLW_dataComplexSum_o0_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 2 );
  signal \NLW_dataReelDif_o0_carry__2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 1 );
  signal \NLW_dataReelDif_o0_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 2 );
  signal \NLW_dataReelSum_o0_carry__2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 1 );
  signal \NLW_dataReelSum_o0_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 2 );
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of dataComplexDif_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexDif_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexDif_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexDif_o0_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of dataComplexSum_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexSum_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexSum_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexSum_o0_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of dataReelDif_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataReelDif_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelDif_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelDif_o0_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of dataReelSum_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataReelSum_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelSum_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelSum_o0_carry__2\ : label is 35;
begin
dataComplexDif_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '1',
      CI_TOP => '0',
      CO(7) => dataComplexDif_o0_carry_n_0,
      CO(6) => dataComplexDif_o0_carry_n_1,
      CO(5) => dataComplexDif_o0_carry_n_2,
      CO(4) => dataComplexDif_o0_carry_n_3,
      CO(3) => dataComplexDif_o0_carry_n_4,
      CO(2) => dataComplexDif_o0_carry_n_5,
      CO(1) => dataComplexDif_o0_carry_n_6,
      CO(0) => dataComplexDif_o0_carry_n_7,
      DI(7 downto 0) => \gRam.mem_reg[0][33]\(7 downto 0),
      O(7 downto 0) => difComplex(7 downto 0),
      S(7 downto 0) => \gRam.mem_reg[0][33]_0\(7 downto 0)
    );
\dataComplexDif_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataComplexDif_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataComplexDif_o0_carry__0_n_0\,
      CO(6) => \dataComplexDif_o0_carry__0_n_1\,
      CO(5) => \dataComplexDif_o0_carry__0_n_2\,
      CO(4) => \dataComplexDif_o0_carry__0_n_3\,
      CO(3) => \dataComplexDif_o0_carry__0_n_4\,
      CO(2) => \dataComplexDif_o0_carry__0_n_5\,
      CO(1) => \dataComplexDif_o0_carry__0_n_6\,
      CO(0) => \dataComplexDif_o0_carry__0_n_7\,
      DI(7 downto 0) => \gRam.mem_reg[0][41]\(7 downto 0),
      O(7 downto 0) => difComplex(15 downto 8),
      S(7 downto 0) => \gRam.mem_reg[0][41]_0\(7 downto 0)
    );
\dataComplexDif_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexDif_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \dataComplexDif_o0_carry__1_n_0\,
      CO(6) => \dataComplexDif_o0_carry__1_n_1\,
      CO(5) => \dataComplexDif_o0_carry__1_n_2\,
      CO(4) => \dataComplexDif_o0_carry__1_n_3\,
      CO(3) => \dataComplexDif_o0_carry__1_n_4\,
      CO(2) => \dataComplexDif_o0_carry__1_n_5\,
      CO(1) => \dataComplexDif_o0_carry__1_n_6\,
      CO(0) => \dataComplexDif_o0_carry__1_n_7\,
      DI(7 downto 0) => \gRam.mem_reg[0][49]\(7 downto 0),
      O(7 downto 0) => difComplex(23 downto 16),
      S(7 downto 0) => \gRam.mem_reg[0][49]_0\(7 downto 0)
    );
\dataComplexDif_o0_carry__2\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexDif_o0_carry__1_n_0\,
      CI_TOP => '0',
      CO(7 downto 1) => \NLW_dataComplexDif_o0_carry__2_CO_UNCONNECTED\(7 downto 1),
      CO(0) => \dataComplexDif_o0_carry__2_n_7\,
      DI(7 downto 1) => B"0000000",
      DI(0) => \gRam.mem_reg[1][51]\(0),
      O(7 downto 2) => \NLW_dataComplexDif_o0_carry__2_O_UNCONNECTED\(7 downto 2),
      O(1 downto 0) => \complexOut_o1__0_i_1\(1 downto 0),
      S(7 downto 2) => B"000000",
      S(1 downto 0) => \gRam.mem_reg[1][51]_0\(1 downto 0)
    );
dataComplexSum_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '0',
      CI_TOP => '0',
      CO(7) => dataComplexSum_o0_carry_n_0,
      CO(6) => dataComplexSum_o0_carry_n_1,
      CO(5) => dataComplexSum_o0_carry_n_2,
      CO(4) => dataComplexSum_o0_carry_n_3,
      CO(3) => dataComplexSum_o0_carry_n_4,
      CO(2) => dataComplexSum_o0_carry_n_5,
      CO(1) => dataComplexSum_o0_carry_n_6,
      CO(0) => dataComplexSum_o0_carry_n_7,
      DI(7 downto 0) => fifoOutComplex(7 downto 0),
      O(7 downto 0) => A(7 downto 0),
      S(7 downto 0) => DSP_A_B_DATA_INST(7 downto 0)
    );
\dataComplexSum_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataComplexSum_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataComplexSum_o0_carry__0_n_0\,
      CO(6) => \dataComplexSum_o0_carry__0_n_1\,
      CO(5) => \dataComplexSum_o0_carry__0_n_2\,
      CO(4) => \dataComplexSum_o0_carry__0_n_3\,
      CO(3) => \dataComplexSum_o0_carry__0_n_4\,
      CO(2) => \dataComplexSum_o0_carry__0_n_5\,
      CO(1) => \dataComplexSum_o0_carry__0_n_6\,
      CO(0) => \dataComplexSum_o0_carry__0_n_7\,
      DI(7 downto 0) => fifoOutComplex(15 downto 8),
      O(7 downto 0) => A(15 downto 8),
      S(7 downto 0) => DSP_A_B_DATA_INST_0(7 downto 0)
    );
\dataComplexSum_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexSum_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \dataComplexSum_o0_carry__1_n_0\,
      CO(6) => \dataComplexSum_o0_carry__1_n_1\,
      CO(5) => \dataComplexSum_o0_carry__1_n_2\,
      CO(4) => \dataComplexSum_o0_carry__1_n_3\,
      CO(3) => \dataComplexSum_o0_carry__1_n_4\,
      CO(2) => \dataComplexSum_o0_carry__1_n_5\,
      CO(1) => \dataComplexSum_o0_carry__1_n_6\,
      CO(0) => \dataComplexSum_o0_carry__1_n_7\,
      DI(7 downto 0) => fifoOutComplex(23 downto 16),
      O(7 downto 0) => A(23 downto 16),
      S(7 downto 0) => DSP_A_B_DATA_INST_1(7 downto 0)
    );
\dataComplexSum_o0_carry__2\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexSum_o0_carry__1_n_0\,
      CI_TOP => '0',
      CO(7 downto 1) => \NLW_dataComplexSum_o0_carry__2_CO_UNCONNECTED\(7 downto 1),
      CO(0) => \dataComplexSum_o0_carry__2_n_7\,
      DI(7 downto 1) => B"0000000",
      DI(0) => DSP_A_B_DATA_INST_2(0),
      O(7 downto 2) => \NLW_dataComplexSum_o0_carry__2_O_UNCONNECTED\(7 downto 2),
      O(1 downto 0) => A(25 downto 24),
      S(7 downto 2) => B"000000",
      S(1 downto 0) => DSP_A_B_DATA_INST_3(1 downto 0)
    );
dataReelDif_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '1',
      CI_TOP => '0',
      CO(7) => dataReelDif_o0_carry_n_0,
      CO(6) => dataReelDif_o0_carry_n_1,
      CO(5) => dataReelDif_o0_carry_n_2,
      CO(4) => dataReelDif_o0_carry_n_3,
      CO(3) => dataReelDif_o0_carry_n_4,
      CO(2) => dataReelDif_o0_carry_n_5,
      CO(1) => dataReelDif_o0_carry_n_6,
      CO(0) => dataReelDif_o0_carry_n_7,
      DI(7 downto 0) => DI(7 downto 0),
      O(7 downto 0) => difReel(7 downto 0),
      S(7 downto 0) => S(7 downto 0)
    );
\dataReelDif_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataReelDif_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataReelDif_o0_carry__0_n_0\,
      CO(6) => \dataReelDif_o0_carry__0_n_1\,
      CO(5) => \dataReelDif_o0_carry__0_n_2\,
      CO(4) => \dataReelDif_o0_carry__0_n_3\,
      CO(3) => \dataReelDif_o0_carry__0_n_4\,
      CO(2) => \dataReelDif_o0_carry__0_n_5\,
      CO(1) => \dataReelDif_o0_carry__0_n_6\,
      CO(0) => \dataReelDif_o0_carry__0_n_7\,
      DI(7 downto 0) => \gRam.mem_reg[0][15]\(7 downto 0),
      O(7 downto 0) => difReel(15 downto 8),
      S(7 downto 0) => \gRam.mem_reg[0][15]_0\(7 downto 0)
    );
\dataReelDif_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelDif_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \dataReelDif_o0_carry__1_n_0\,
      CO(6) => \dataReelDif_o0_carry__1_n_1\,
      CO(5) => \dataReelDif_o0_carry__1_n_2\,
      CO(4) => \dataReelDif_o0_carry__1_n_3\,
      CO(3) => \dataReelDif_o0_carry__1_n_4\,
      CO(2) => \dataReelDif_o0_carry__1_n_5\,
      CO(1) => \dataReelDif_o0_carry__1_n_6\,
      CO(0) => \dataReelDif_o0_carry__1_n_7\,
      DI(7 downto 0) => \gRam.mem_reg[0][23]\(7 downto 0),
      O(7 downto 0) => difReel(23 downto 16),
      S(7 downto 0) => \gRam.mem_reg[0][23]_0\(7 downto 0)
    );
\dataReelDif_o0_carry__2\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelDif_o0_carry__1_n_0\,
      CI_TOP => '0',
      CO(7 downto 1) => \NLW_dataReelDif_o0_carry__2_CO_UNCONNECTED\(7 downto 1),
      CO(0) => \dataReelDif_o0_carry__2_n_7\,
      DI(7 downto 1) => B"0000000",
      DI(0) => \gRam.mem_reg[1][25]\(0),
      O(7 downto 2) => \NLW_dataReelDif_o0_carry__2_O_UNCONNECTED\(7 downto 2),
      O(1 downto 0) => O(1 downto 0),
      S(7 downto 2) => B"000000",
      S(1 downto 0) => \gRam.mem_reg[1][25]_0\(1 downto 0)
    );
dataReelSum_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '0',
      CI_TOP => '0',
      CO(7) => dataReelSum_o0_carry_n_0,
      CO(6) => dataReelSum_o0_carry_n_1,
      CO(5) => dataReelSum_o0_carry_n_2,
      CO(4) => dataReelSum_o0_carry_n_3,
      CO(3) => dataReelSum_o0_carry_n_4,
      CO(2) => dataReelSum_o0_carry_n_5,
      CO(1) => dataReelSum_o0_carry_n_6,
      CO(0) => dataReelSum_o0_carry_n_7,
      DI(7 downto 0) => DSP_A_B_DATA_INST_4(7 downto 0),
      O(7 downto 0) => \cnt_reg[1]\(7 downto 0),
      S(7 downto 0) => DSP_A_B_DATA_INST_5(7 downto 0)
    );
\dataReelSum_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataReelSum_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataReelSum_o0_carry__0_n_0\,
      CO(6) => \dataReelSum_o0_carry__0_n_1\,
      CO(5) => \dataReelSum_o0_carry__0_n_2\,
      CO(4) => \dataReelSum_o0_carry__0_n_3\,
      CO(3) => \dataReelSum_o0_carry__0_n_4\,
      CO(2) => \dataReelSum_o0_carry__0_n_5\,
      CO(1) => \dataReelSum_o0_carry__0_n_6\,
      CO(0) => \dataReelSum_o0_carry__0_n_7\,
      DI(7 downto 0) => DSP_A_B_DATA_INST_6(7 downto 0),
      O(7 downto 0) => \cnt_reg[1]\(15 downto 8),
      S(7 downto 0) => DSP_A_B_DATA_INST_7(7 downto 0)
    );
\dataReelSum_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelSum_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \dataReelSum_o0_carry__1_n_0\,
      CO(6) => \dataReelSum_o0_carry__1_n_1\,
      CO(5) => \dataReelSum_o0_carry__1_n_2\,
      CO(4) => \dataReelSum_o0_carry__1_n_3\,
      CO(3) => \dataReelSum_o0_carry__1_n_4\,
      CO(2) => \dataReelSum_o0_carry__1_n_5\,
      CO(1) => \dataReelSum_o0_carry__1_n_6\,
      CO(0) => \dataReelSum_o0_carry__1_n_7\,
      DI(7 downto 0) => DSP_A_B_DATA_INST_8(7 downto 0),
      O(7 downto 0) => \cnt_reg[1]\(23 downto 16),
      S(7 downto 0) => DSP_A_B_DATA_INST_9(7 downto 0)
    );
\dataReelSum_o0_carry__2\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelSum_o0_carry__1_n_0\,
      CI_TOP => '0',
      CO(7 downto 1) => \NLW_dataReelSum_o0_carry__2_CO_UNCONNECTED\(7 downto 1),
      CO(0) => \dataReelSum_o0_carry__2_n_7\,
      DI(7 downto 1) => B"0000000",
      DI(0) => DSP_A_B_DATA_INST_10(0),
      O(7 downto 2) => \NLW_dataReelSum_o0_carry__2_O_UNCONNECTED\(7 downto 2),
      O(1 downto 0) => \cnt_reg[1]\(25 downto 24),
      S(7 downto 2) => B"000000",
      S(1 downto 0) => DSP_A_B_DATA_INST_11(1 downto 0)
    );
\gRam.mem[0][0]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(0),
      I1 => \gRam.mem_reg[0][23]_1\(0),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(0)
    );
\gRam.mem[0][10]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(10),
      I1 => \gRam.mem_reg[0][23]_1\(10),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(10)
    );
\gRam.mem[0][11]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(11),
      I1 => \gRam.mem_reg[0][23]_1\(11),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(11)
    );
\gRam.mem[0][12]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(12),
      I1 => \gRam.mem_reg[0][23]_1\(12),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(12)
    );
\gRam.mem[0][13]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(13),
      I1 => \gRam.mem_reg[0][23]_1\(13),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(13)
    );
\gRam.mem[0][14]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(14),
      I1 => \gRam.mem_reg[0][23]_1\(14),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(14)
    );
\gRam.mem[0][15]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(15),
      I1 => \gRam.mem_reg[0][23]_1\(15),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(15)
    );
\gRam.mem[0][16]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(16),
      I1 => \gRam.mem_reg[0][23]_1\(16),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(16)
    );
\gRam.mem[0][17]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(17),
      I1 => \gRam.mem_reg[0][23]_1\(17),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(17)
    );
\gRam.mem[0][18]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(18),
      I1 => \gRam.mem_reg[0][23]_1\(18),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(18)
    );
\gRam.mem[0][19]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(19),
      I1 => \gRam.mem_reg[0][23]_1\(19),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(19)
    );
\gRam.mem[0][1]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(1),
      I1 => \gRam.mem_reg[0][23]_1\(1),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(1)
    );
\gRam.mem[0][20]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(20),
      I1 => \gRam.mem_reg[0][23]_1\(20),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(20)
    );
\gRam.mem[0][21]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(21),
      I1 => \gRam.mem_reg[0][23]_1\(21),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(21)
    );
\gRam.mem[0][22]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(22),
      I1 => \gRam.mem_reg[0][23]_1\(22),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(22)
    );
\gRam.mem[0][23]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(23),
      I1 => \gRam.mem_reg[0][23]_1\(23),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(23)
    );
\gRam.mem[0][26]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(0),
      I1 => \gRam.mem_reg[0][49]_1\(0),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(24)
    );
\gRam.mem[0][27]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(1),
      I1 => \gRam.mem_reg[0][49]_1\(1),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(25)
    );
\gRam.mem[0][28]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(2),
      I1 => \gRam.mem_reg[0][49]_1\(2),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(26)
    );
\gRam.mem[0][29]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(3),
      I1 => \gRam.mem_reg[0][49]_1\(3),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(27)
    );
\gRam.mem[0][2]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(2),
      I1 => \gRam.mem_reg[0][23]_1\(2),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(2)
    );
\gRam.mem[0][30]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(4),
      I1 => \gRam.mem_reg[0][49]_1\(4),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(28)
    );
\gRam.mem[0][31]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(5),
      I1 => \gRam.mem_reg[0][49]_1\(5),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(29)
    );
\gRam.mem[0][32]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(6),
      I1 => \gRam.mem_reg[0][49]_1\(6),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(30)
    );
\gRam.mem[0][33]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(7),
      I1 => \gRam.mem_reg[0][49]_1\(7),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(31)
    );
\gRam.mem[0][34]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(8),
      I1 => \gRam.mem_reg[0][49]_1\(8),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(32)
    );
\gRam.mem[0][35]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(9),
      I1 => \gRam.mem_reg[0][49]_1\(9),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(33)
    );
\gRam.mem[0][36]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(10),
      I1 => \gRam.mem_reg[0][49]_1\(10),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(34)
    );
\gRam.mem[0][37]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(11),
      I1 => \gRam.mem_reg[0][49]_1\(11),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(35)
    );
\gRam.mem[0][38]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(12),
      I1 => \gRam.mem_reg[0][49]_1\(12),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(36)
    );
\gRam.mem[0][39]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(13),
      I1 => \gRam.mem_reg[0][49]_1\(13),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(37)
    );
\gRam.mem[0][3]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(3),
      I1 => \gRam.mem_reg[0][23]_1\(3),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(3)
    );
\gRam.mem[0][40]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(14),
      I1 => \gRam.mem_reg[0][49]_1\(14),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(38)
    );
\gRam.mem[0][41]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(15),
      I1 => \gRam.mem_reg[0][49]_1\(15),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(39)
    );
\gRam.mem[0][42]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(16),
      I1 => \gRam.mem_reg[0][49]_1\(16),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(40)
    );
\gRam.mem[0][43]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(17),
      I1 => \gRam.mem_reg[0][49]_1\(17),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(41)
    );
\gRam.mem[0][44]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(18),
      I1 => \gRam.mem_reg[0][49]_1\(18),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(42)
    );
\gRam.mem[0][45]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(19),
      I1 => \gRam.mem_reg[0][49]_1\(19),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(43)
    );
\gRam.mem[0][46]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(20),
      I1 => \gRam.mem_reg[0][49]_1\(20),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(44)
    );
\gRam.mem[0][47]_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(21),
      I1 => \gRam.mem_reg[0][49]_1\(21),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(45)
    );
\gRam.mem[0][48]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(22),
      I1 => \gRam.mem_reg[0][49]_1\(22),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(46)
    );
\gRam.mem[0][49]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difComplex(23),
      I1 => \gRam.mem_reg[0][49]_1\(23),
      I2 => \gRam.mem_reg[0][49]_2\(0),
      I3 => Q(0),
      O => D(47)
    );
\gRam.mem[0][4]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(4),
      I1 => \gRam.mem_reg[0][23]_1\(4),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(4)
    );
\gRam.mem[0][5]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(5),
      I1 => \gRam.mem_reg[0][23]_1\(5),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(5)
    );
\gRam.mem[0][6]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(6),
      I1 => \gRam.mem_reg[0][23]_1\(6),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(6)
    );
\gRam.mem[0][7]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(7),
      I1 => \gRam.mem_reg[0][23]_1\(7),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(7)
    );
\gRam.mem[0][8]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(8),
      I1 => \gRam.mem_reg[0][23]_1\(8),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(8)
    );
\gRam.mem[0][9]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAC0"
    )
        port map (
      I0 => difReel(9),
      I1 => \gRam.mem_reg[0][23]_1\(9),
      I2 => \gRam.mem_reg[0][0]\,
      I3 => Q(0),
      O => D(9)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \design_1_radar_wrapper_0_1_butterflyUnit__parameterized5\ is
  port (
    O : out STD_LOGIC_VECTOR ( 2 downto 0 );
    \gSingle.data_o_reg[52]\ : out STD_LOGIC_VECTOR ( 2 downto 0 );
    muxComplex : out STD_LOGIC_VECTOR ( 26 downto 0 );
    muxReel : out STD_LOGIC_VECTOR ( 26 downto 0 );
    D : out STD_LOGIC_VECTOR ( 47 downto 0 );
    Q : in STD_LOGIC_VECTOR ( 51 downto 0 );
    S : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gSingle.data_o_reg[15]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gSingle.data_o_reg[23]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gSingle.data_o_reg[26]\ : in STD_LOGIC_VECTOR ( 2 downto 0 );
    \gSingle.data_o_reg[34]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gSingle.data_o_reg[42]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gSingle.data_o_reg[50]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \gSingle.data_o_reg[53]\ : in STD_LOGIC_VECTOR ( 2 downto 0 );
    DSP_A_B_DATA_INST : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_0 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_1 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_2 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    DSP_A_B_DATA_INST_3 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_4 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_5 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    DSP_A_B_DATA_INST_6 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    cnt : in STD_LOGIC_VECTOR ( 0 to 0 );
    P : in STD_LOGIC_VECTOR ( 23 downto 0 );
    \gSingle.data_o_reg[0]\ : in STD_LOGIC;
    \gSingle.data_o_reg[50]_0\ : in STD_LOGIC_VECTOR ( 23 downto 0 );
    \gSingle.data_o_reg[50]_1\ : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \design_1_radar_wrapper_0_1_butterflyUnit__parameterized5\ : entity is "butterflyUnit";
end \design_1_radar_wrapper_0_1_butterflyUnit__parameterized5\;

architecture STRUCTURE of \design_1_radar_wrapper_0_1_butterflyUnit__parameterized5\ is
  signal \dataComplexDif_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_0\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_1\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__1_n_7\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__2_n_6\ : STD_LOGIC;
  signal \dataComplexDif_o0_carry__2_n_7\ : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_0 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_1 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_2 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_3 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_4 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_5 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_6 : STD_LOGIC;
  signal dataComplexDif_o0_carry_n_7 : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_0\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_1\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__1_n_7\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__2_n_6\ : STD_LOGIC;
  signal \dataComplexSum_o0_carry__2_n_7\ : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_0 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_1 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_2 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_3 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_4 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_5 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_6 : STD_LOGIC;
  signal dataComplexSum_o0_carry_n_7 : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_0\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_1\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__1_n_7\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__2_n_6\ : STD_LOGIC;
  signal \dataReelDif_o0_carry__2_n_7\ : STD_LOGIC;
  signal dataReelDif_o0_carry_n_0 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_1 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_2 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_3 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_4 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_5 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_6 : STD_LOGIC;
  signal dataReelDif_o0_carry_n_7 : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_0\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_1\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_2\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_3\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_4\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_5\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_6\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__0_n_7\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_0\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_1\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_2\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_3\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_4\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_5\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_6\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__1_n_7\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__2_n_6\ : STD_LOGIC;
  signal \dataReelSum_o0_carry__2_n_7\ : STD_LOGIC;
  signal dataReelSum_o0_carry_n_0 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_1 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_2 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_3 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_4 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_5 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_6 : STD_LOGIC;
  signal dataReelSum_o0_carry_n_7 : STD_LOGIC;
  signal difComplex : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal difReel : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal \NLW_dataComplexDif_o0_carry__2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 2 );
  signal \NLW_dataComplexDif_o0_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 3 );
  signal \NLW_dataComplexSum_o0_carry__2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 2 );
  signal \NLW_dataComplexSum_o0_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 3 );
  signal \NLW_dataReelDif_o0_carry__2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 2 );
  signal \NLW_dataReelDif_o0_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 3 );
  signal \NLW_dataReelSum_o0_carry__2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 2 );
  signal \NLW_dataReelSum_o0_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 3 );
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of dataComplexDif_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexDif_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexDif_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexDif_o0_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of dataComplexSum_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexSum_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexSum_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \dataComplexSum_o0_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of dataReelDif_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataReelDif_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelDif_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelDif_o0_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of dataReelSum_o0_carry : label is 35;
  attribute ADDER_THRESHOLD of \dataReelSum_o0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelSum_o0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \dataReelSum_o0_carry__2\ : label is 35;
begin
dataComplexDif_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '1',
      CI_TOP => '0',
      CO(7) => dataComplexDif_o0_carry_n_0,
      CO(6) => dataComplexDif_o0_carry_n_1,
      CO(5) => dataComplexDif_o0_carry_n_2,
      CO(4) => dataComplexDif_o0_carry_n_3,
      CO(3) => dataComplexDif_o0_carry_n_4,
      CO(2) => dataComplexDif_o0_carry_n_5,
      CO(1) => dataComplexDif_o0_carry_n_6,
      CO(0) => dataComplexDif_o0_carry_n_7,
      DI(7 downto 0) => Q(33 downto 26),
      O(7 downto 0) => difComplex(7 downto 0),
      S(7 downto 0) => \gSingle.data_o_reg[34]\(7 downto 0)
    );
\dataComplexDif_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataComplexDif_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataComplexDif_o0_carry__0_n_0\,
      CO(6) => \dataComplexDif_o0_carry__0_n_1\,
      CO(5) => \dataComplexDif_o0_carry__0_n_2\,
      CO(4) => \dataComplexDif_o0_carry__0_n_3\,
      CO(3) => \dataComplexDif_o0_carry__0_n_4\,
      CO(2) => \dataComplexDif_o0_carry__0_n_5\,
      CO(1) => \dataComplexDif_o0_carry__0_n_6\,
      CO(0) => \dataComplexDif_o0_carry__0_n_7\,
      DI(7 downto 0) => Q(41 downto 34),
      O(7 downto 0) => difComplex(15 downto 8),
      S(7 downto 0) => \gSingle.data_o_reg[42]\(7 downto 0)
    );
\dataComplexDif_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexDif_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \dataComplexDif_o0_carry__1_n_0\,
      CO(6) => \dataComplexDif_o0_carry__1_n_1\,
      CO(5) => \dataComplexDif_o0_carry__1_n_2\,
      CO(4) => \dataComplexDif_o0_carry__1_n_3\,
      CO(3) => \dataComplexDif_o0_carry__1_n_4\,
      CO(2) => \dataComplexDif_o0_carry__1_n_5\,
      CO(1) => \dataComplexDif_o0_carry__1_n_6\,
      CO(0) => \dataComplexDif_o0_carry__1_n_7\,
      DI(7 downto 0) => Q(49 downto 42),
      O(7 downto 0) => difComplex(23 downto 16),
      S(7 downto 0) => \gSingle.data_o_reg[50]\(7 downto 0)
    );
\dataComplexDif_o0_carry__2\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexDif_o0_carry__1_n_0\,
      CI_TOP => '0',
      CO(7 downto 2) => \NLW_dataComplexDif_o0_carry__2_CO_UNCONNECTED\(7 downto 2),
      CO(1) => \dataComplexDif_o0_carry__2_n_6\,
      CO(0) => \dataComplexDif_o0_carry__2_n_7\,
      DI(7 downto 2) => B"000000",
      DI(1 downto 0) => Q(51 downto 50),
      O(7 downto 3) => \NLW_dataComplexDif_o0_carry__2_O_UNCONNECTED\(7 downto 3),
      O(2 downto 0) => \gSingle.data_o_reg[52]\(2 downto 0),
      S(7 downto 3) => B"00000",
      S(2 downto 0) => \gSingle.data_o_reg[53]\(2 downto 0)
    );
dataComplexSum_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '0',
      CI_TOP => '0',
      CO(7) => dataComplexSum_o0_carry_n_0,
      CO(6) => dataComplexSum_o0_carry_n_1,
      CO(5) => dataComplexSum_o0_carry_n_2,
      CO(4) => dataComplexSum_o0_carry_n_3,
      CO(3) => dataComplexSum_o0_carry_n_4,
      CO(2) => dataComplexSum_o0_carry_n_5,
      CO(1) => dataComplexSum_o0_carry_n_6,
      CO(0) => dataComplexSum_o0_carry_n_7,
      DI(7 downto 0) => Q(33 downto 26),
      O(7 downto 0) => muxComplex(7 downto 0),
      S(7 downto 0) => DSP_A_B_DATA_INST(7 downto 0)
    );
\dataComplexSum_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataComplexSum_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataComplexSum_o0_carry__0_n_0\,
      CO(6) => \dataComplexSum_o0_carry__0_n_1\,
      CO(5) => \dataComplexSum_o0_carry__0_n_2\,
      CO(4) => \dataComplexSum_o0_carry__0_n_3\,
      CO(3) => \dataComplexSum_o0_carry__0_n_4\,
      CO(2) => \dataComplexSum_o0_carry__0_n_5\,
      CO(1) => \dataComplexSum_o0_carry__0_n_6\,
      CO(0) => \dataComplexSum_o0_carry__0_n_7\,
      DI(7 downto 0) => Q(41 downto 34),
      O(7 downto 0) => muxComplex(15 downto 8),
      S(7 downto 0) => DSP_A_B_DATA_INST_0(7 downto 0)
    );
\dataComplexSum_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexSum_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \dataComplexSum_o0_carry__1_n_0\,
      CO(6) => \dataComplexSum_o0_carry__1_n_1\,
      CO(5) => \dataComplexSum_o0_carry__1_n_2\,
      CO(4) => \dataComplexSum_o0_carry__1_n_3\,
      CO(3) => \dataComplexSum_o0_carry__1_n_4\,
      CO(2) => \dataComplexSum_o0_carry__1_n_5\,
      CO(1) => \dataComplexSum_o0_carry__1_n_6\,
      CO(0) => \dataComplexSum_o0_carry__1_n_7\,
      DI(7 downto 0) => Q(49 downto 42),
      O(7 downto 0) => muxComplex(23 downto 16),
      S(7 downto 0) => DSP_A_B_DATA_INST_1(7 downto 0)
    );
\dataComplexSum_o0_carry__2\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataComplexSum_o0_carry__1_n_0\,
      CI_TOP => '0',
      CO(7 downto 2) => \NLW_dataComplexSum_o0_carry__2_CO_UNCONNECTED\(7 downto 2),
      CO(1) => \dataComplexSum_o0_carry__2_n_6\,
      CO(0) => \dataComplexSum_o0_carry__2_n_7\,
      DI(7 downto 2) => B"000000",
      DI(1 downto 0) => Q(51 downto 50),
      O(7 downto 3) => \NLW_dataComplexSum_o0_carry__2_O_UNCONNECTED\(7 downto 3),
      O(2 downto 0) => muxComplex(26 downto 24),
      S(7 downto 3) => B"00000",
      S(2 downto 0) => DSP_A_B_DATA_INST_2(2 downto 0)
    );
dataReelDif_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '1',
      CI_TOP => '0',
      CO(7) => dataReelDif_o0_carry_n_0,
      CO(6) => dataReelDif_o0_carry_n_1,
      CO(5) => dataReelDif_o0_carry_n_2,
      CO(4) => dataReelDif_o0_carry_n_3,
      CO(3) => dataReelDif_o0_carry_n_4,
      CO(2) => dataReelDif_o0_carry_n_5,
      CO(1) => dataReelDif_o0_carry_n_6,
      CO(0) => dataReelDif_o0_carry_n_7,
      DI(7 downto 0) => Q(7 downto 0),
      O(7 downto 0) => difReel(7 downto 0),
      S(7 downto 0) => S(7 downto 0)
    );
\dataReelDif_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataReelDif_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataReelDif_o0_carry__0_n_0\,
      CO(6) => \dataReelDif_o0_carry__0_n_1\,
      CO(5) => \dataReelDif_o0_carry__0_n_2\,
      CO(4) => \dataReelDif_o0_carry__0_n_3\,
      CO(3) => \dataReelDif_o0_carry__0_n_4\,
      CO(2) => \dataReelDif_o0_carry__0_n_5\,
      CO(1) => \dataReelDif_o0_carry__0_n_6\,
      CO(0) => \dataReelDif_o0_carry__0_n_7\,
      DI(7 downto 0) => Q(15 downto 8),
      O(7 downto 0) => difReel(15 downto 8),
      S(7 downto 0) => \gSingle.data_o_reg[15]\(7 downto 0)
    );
\dataReelDif_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelDif_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \dataReelDif_o0_carry__1_n_0\,
      CO(6) => \dataReelDif_o0_carry__1_n_1\,
      CO(5) => \dataReelDif_o0_carry__1_n_2\,
      CO(4) => \dataReelDif_o0_carry__1_n_3\,
      CO(3) => \dataReelDif_o0_carry__1_n_4\,
      CO(2) => \dataReelDif_o0_carry__1_n_5\,
      CO(1) => \dataReelDif_o0_carry__1_n_6\,
      CO(0) => \dataReelDif_o0_carry__1_n_7\,
      DI(7 downto 0) => Q(23 downto 16),
      O(7 downto 0) => difReel(23 downto 16),
      S(7 downto 0) => \gSingle.data_o_reg[23]\(7 downto 0)
    );
\dataReelDif_o0_carry__2\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelDif_o0_carry__1_n_0\,
      CI_TOP => '0',
      CO(7 downto 2) => \NLW_dataReelDif_o0_carry__2_CO_UNCONNECTED\(7 downto 2),
      CO(1) => \dataReelDif_o0_carry__2_n_6\,
      CO(0) => \dataReelDif_o0_carry__2_n_7\,
      DI(7 downto 2) => B"000000",
      DI(1 downto 0) => Q(25 downto 24),
      O(7 downto 3) => \NLW_dataReelDif_o0_carry__2_O_UNCONNECTED\(7 downto 3),
      O(2 downto 0) => O(2 downto 0),
      S(7 downto 3) => B"00000",
      S(2 downto 0) => \gSingle.data_o_reg[26]\(2 downto 0)
    );
dataReelSum_o0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '0',
      CI_TOP => '0',
      CO(7) => dataReelSum_o0_carry_n_0,
      CO(6) => dataReelSum_o0_carry_n_1,
      CO(5) => dataReelSum_o0_carry_n_2,
      CO(4) => dataReelSum_o0_carry_n_3,
      CO(3) => dataReelSum_o0_carry_n_4,
      CO(2) => dataReelSum_o0_carry_n_5,
      CO(1) => dataReelSum_o0_carry_n_6,
      CO(0) => dataReelSum_o0_carry_n_7,
      DI(7 downto 0) => Q(7 downto 0),
      O(7 downto 0) => muxReel(7 downto 0),
      S(7 downto 0) => DSP_A_B_DATA_INST_3(7 downto 0)
    );
\dataReelSum_o0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => dataReelSum_o0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \dataReelSum_o0_carry__0_n_0\,
      CO(6) => \dataReelSum_o0_carry__0_n_1\,
      CO(5) => \dataReelSum_o0_carry__0_n_2\,
      CO(4) => \dataReelSum_o0_carry__0_n_3\,
      CO(3) => \dataReelSum_o0_carry__0_n_4\,
      CO(2) => \dataReelSum_o0_carry__0_n_5\,
      CO(1) => \dataReelSum_o0_carry__0_n_6\,
      CO(0) => \dataReelSum_o0_carry__0_n_7\,
      DI(7 downto 0) => Q(15 downto 8),
      O(7 downto 0) => muxReel(15 downto 8),
      S(7 downto 0) => DSP_A_B_DATA_INST_4(7 downto 0)
    );
\dataReelSum_o0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelSum_o0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \dataReelSum_o0_carry__1_n_0\,
      CO(6) => \dataReelSum_o0_carry__1_n_1\,
      CO(5) => \dataReelSum_o0_carry__1_n_2\,
      CO(4) => \dataReelSum_o0_carry__1_n_3\,
      CO(3) => \dataReelSum_o0_carry__1_n_4\,
      CO(2) => \dataReelSum_o0_carry__1_n_5\,
      CO(1) => \dataReelSum_o0_carry__1_n_6\,
      CO(0) => \dataReelSum_o0_carry__1_n_7\,
      DI(7 downto 0) => Q(23 downto 16),
      O(7 downto 0) => muxReel(23 downto 16),
      S(7 downto 0) => DSP_A_B_DATA_INST_5(7 downto 0)
    );
\dataReelSum_o0_carry__2\: unisim.vcomponents.CARRY8
     port map (
      CI => \dataReelSum_o0_carry__1_n_0\,
      CI_TOP => '0',
      CO(7 downto 2) => \NLW_dataReelSum_o0_carry__2_CO_UNCONNECTED\(7 downto 2),
      CO(1) => \dataReelSum_o0_carry__2_n_6\,
      CO(0) => \dataReelSum_o0_carry__2_n_7\,
      DI(7 downto 2) => B"000000",
      DI(1 downto 0) => Q(25 downto 24),
      O(7 downto 3) => \NLW_dataReelSum_o0_carry__2_O_UNCONNECTED\(7 downto 3),
      O(2 downto 0) => muxReel(26 downto 24),
      S(7 downto 3) => B"00000",
      S(2 downto 0) => DSP_A_B_DATA_INST_6(2 downto 0)
    );
\gSingle.data_o[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(0),
      I1 => cnt(0),
      I2 => P(0),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(0)
    );
\gSingle.data_o[10]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(10),
      I1 => cnt(0),
      I2 => P(10),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(10)
    );
\gSingle.data_o[11]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(11),
      I1 => cnt(0),
      I2 => P(11),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(11)
    );
\gSingle.data_o[12]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(12),
      I1 => cnt(0),
      I2 => P(12),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(12)
    );
\gSingle.data_o[13]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(13),
      I1 => cnt(0),
      I2 => P(13),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(13)
    );
\gSingle.data_o[14]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(14),
      I1 => cnt(0),
      I2 => P(14),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(14)
    );
\gSingle.data_o[15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(15),
      I1 => cnt(0),
      I2 => P(15),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(15)
    );
\gSingle.data_o[16]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(16),
      I1 => cnt(0),
      I2 => P(16),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(16)
    );
\gSingle.data_o[17]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(17),
      I1 => cnt(0),
      I2 => P(17),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(17)
    );
\gSingle.data_o[18]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(18),
      I1 => cnt(0),
      I2 => P(18),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(18)
    );
\gSingle.data_o[19]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(19),
      I1 => cnt(0),
      I2 => P(19),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(19)
    );
\gSingle.data_o[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(1),
      I1 => cnt(0),
      I2 => P(1),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(1)
    );
\gSingle.data_o[20]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(20),
      I1 => cnt(0),
      I2 => P(20),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(20)
    );
\gSingle.data_o[21]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(21),
      I1 => cnt(0),
      I2 => P(21),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(21)
    );
\gSingle.data_o[22]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(22),
      I1 => cnt(0),
      I2 => P(22),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(22)
    );
\gSingle.data_o[23]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(23),
      I1 => cnt(0),
      I2 => P(23),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(23)
    );
\gSingle.data_o[27]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(0),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(0),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(24)
    );
\gSingle.data_o[28]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(1),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(1),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(25)
    );
\gSingle.data_o[29]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(2),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(2),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(26)
    );
\gSingle.data_o[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(2),
      I1 => cnt(0),
      I2 => P(2),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(2)
    );
\gSingle.data_o[30]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(3),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(3),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(27)
    );
\gSingle.data_o[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(4),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(4),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(28)
    );
\gSingle.data_o[32]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(5),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(5),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(29)
    );
\gSingle.data_o[33]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(6),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(6),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(30)
    );
\gSingle.data_o[34]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(7),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(7),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(31)
    );
\gSingle.data_o[35]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(8),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(8),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(32)
    );
\gSingle.data_o[36]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(9),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(9),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(33)
    );
\gSingle.data_o[37]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(10),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(10),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(34)
    );
\gSingle.data_o[38]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(11),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(11),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(35)
    );
\gSingle.data_o[39]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(12),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(12),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(36)
    );
\gSingle.data_o[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(3),
      I1 => cnt(0),
      I2 => P(3),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(3)
    );
\gSingle.data_o[40]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(13),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(13),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(37)
    );
\gSingle.data_o[41]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(14),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(14),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(38)
    );
\gSingle.data_o[42]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(15),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(15),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(39)
    );
\gSingle.data_o[43]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(16),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(16),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(40)
    );
\gSingle.data_o[44]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(17),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(17),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(41)
    );
\gSingle.data_o[45]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(18),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(18),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(42)
    );
\gSingle.data_o[46]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(19),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(19),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(43)
    );
\gSingle.data_o[47]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(20),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(20),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(44)
    );
\gSingle.data_o[48]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(21),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(21),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(45)
    );
\gSingle.data_o[49]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(22),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(22),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(46)
    );
\gSingle.data_o[4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(4),
      I1 => cnt(0),
      I2 => P(4),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(4)
    );
\gSingle.data_o[50]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difComplex(23),
      I1 => cnt(0),
      I2 => \gSingle.data_o_reg[50]_0\(23),
      I3 => \gSingle.data_o_reg[50]_1\(0),
      O => D(47)
    );
\gSingle.data_o[5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(5),
      I1 => cnt(0),
      I2 => P(5),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(5)
    );
\gSingle.data_o[6]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(6),
      I1 => cnt(0),
      I2 => P(6),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(6)
    );
\gSingle.data_o[7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(7),
      I1 => cnt(0),
      I2 => P(7),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(7)
    );
\gSingle.data_o[8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(8),
      I1 => cnt(0),
      I2 => P(8),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(8)
    );
\gSingle.data_o[9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => difReel(9),
      I1 => cnt(0),
      I2 => P(9),
      I3 => \gSingle.data_o_reg[0]\,
      O => D(9)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_radar_wrapper_0_1_complexMulRTL is
  port (
    P : out STD_LOGIC_VECTOR ( 20 downto 0 );
    fftEn_reg : out STD_LOGIC_VECTOR ( 20 downto 0 );
    S : out STD_LOGIC_VECTOR ( 1 downto 0 );
    complexOut_o1_i_1 : out STD_LOGIC_VECTOR ( 1 downto 0 );
    DI : out STD_LOGIC_VECTOR ( 0 to 0 );
    \gRam.mem_reg[31][21]_i_2\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    \cnt_reg[6]\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    \cnt_reg[6]_0\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    D : in STD_LOGIC_VECTOR ( 0 to 0 );
    aclk : in STD_LOGIC;
    muxComplex : in STD_LOGIC_VECTOR ( 20 downto 0 );
    Q : in STD_LOGIC_VECTOR ( 0 to 0 );
    muxReel : in STD_LOGIC_VECTOR ( 20 downto 0 );
    OPMODE : in STD_LOGIC_VECTOR ( 0 to 0 );
    \dataReelDif_o0_carry__1\ : in STD_LOGIC;
    \dataReelDif_o0_carry__1_0\ : in STD_LOGIC;
    \dataReelDif_o0_carry__1_1\ : in STD_LOGIC;
    fifoOutComplex : in STD_LOGIC_VECTOR ( 0 to 0 );
    \fifoOutComplex__0\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    reelOut_o1_0 : in STD_LOGIC;
    fftComplex : in STD_LOGIC_VECTOR ( 0 to 0 );
    fftReel : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of design_1_radar_wrapper_0_1_complexMulRTL : entity is "complexMulRTL";
end design_1_radar_wrapper_0_1_complexMulRTL;

architecture STRUCTURE of design_1_radar_wrapper_0_1_complexMulRTL is
  signal \^p\ : STD_LOGIC_VECTOR ( 20 downto 0 );
  signal ac : STD_LOGIC_VECTOR ( 36 downto 0 );
  signal ac0_n_100 : STD_LOGIC;
  signal ac0_n_101 : STD_LOGIC;
  signal ac0_n_102 : STD_LOGIC;
  signal ac0_n_103 : STD_LOGIC;
  signal ac0_n_104 : STD_LOGIC;
  signal ac0_n_105 : STD_LOGIC;
  signal ac0_n_67 : STD_LOGIC;
  signal ac0_n_68 : STD_LOGIC;
  signal ac0_n_69 : STD_LOGIC;
  signal ac0_n_70 : STD_LOGIC;
  signal ac0_n_71 : STD_LOGIC;
  signal ac0_n_72 : STD_LOGIC;
  signal ac0_n_73 : STD_LOGIC;
  signal ac0_n_74 : STD_LOGIC;
  signal ac0_n_75 : STD_LOGIC;
  signal ac0_n_76 : STD_LOGIC;
  signal ac0_n_77 : STD_LOGIC;
  signal ac0_n_78 : STD_LOGIC;
  signal ac0_n_79 : STD_LOGIC;
  signal ac0_n_80 : STD_LOGIC;
  signal ac0_n_81 : STD_LOGIC;
  signal ac0_n_82 : STD_LOGIC;
  signal ac0_n_83 : STD_LOGIC;
  signal ac0_n_84 : STD_LOGIC;
  signal ac0_n_85 : STD_LOGIC;
  signal ac0_n_86 : STD_LOGIC;
  signal ac0_n_87 : STD_LOGIC;
  signal ac0_n_88 : STD_LOGIC;
  signal ac0_n_89 : STD_LOGIC;
  signal ac0_n_90 : STD_LOGIC;
  signal ac0_n_91 : STD_LOGIC;
  signal ac0_n_92 : STD_LOGIC;
  signal ac0_n_93 : STD_LOGIC;
  signal ac0_n_94 : STD_LOGIC;
  signal ac0_n_95 : STD_LOGIC;
  signal ac0_n_96 : STD_LOGIC;
  signal ac0_n_97 : STD_LOGIC;
  signal ac0_n_98 : STD_LOGIC;
  signal ac0_n_99 : STD_LOGIC;
  signal ad0_n_100 : STD_LOGIC;
  signal ad0_n_101 : STD_LOGIC;
  signal ad0_n_102 : STD_LOGIC;
  signal ad0_n_103 : STD_LOGIC;
  signal ad0_n_104 : STD_LOGIC;
  signal ad0_n_105 : STD_LOGIC;
  signal ad0_n_67 : STD_LOGIC;
  signal ad0_n_68 : STD_LOGIC;
  signal ad0_n_69 : STD_LOGIC;
  signal ad0_n_70 : STD_LOGIC;
  signal ad0_n_71 : STD_LOGIC;
  signal ad0_n_72 : STD_LOGIC;
  signal ad0_n_73 : STD_LOGIC;
  signal ad0_n_74 : STD_LOGIC;
  signal ad0_n_75 : STD_LOGIC;
  signal ad0_n_76 : STD_LOGIC;
  signal ad0_n_77 : STD_LOGIC;
  signal ad0_n_78 : STD_LOGIC;
  signal ad0_n_79 : STD_LOGIC;
  signal ad0_n_80 : STD_LOGIC;
  signal ad0_n_81 : STD_LOGIC;
  signal ad0_n_82 : STD_LOGIC;
  signal ad0_n_83 : STD_LOGIC;
  signal ad0_n_84 : STD_LOGIC;
  signal ad0_n_85 : STD_LOGIC;
  signal ad0_n_86 : STD_LOGIC;
  signal ad0_n_87 : STD_LOGIC;
  signal ad0_n_88 : STD_LOGIC;
  signal ad0_n_89 : STD_LOGIC;
  signal ad0_n_90 : STD_LOGIC;
  signal ad0_n_91 : STD_LOGIC;
  signal ad0_n_92 : STD_LOGIC;
  signal ad0_n_93 : STD_LOGIC;
  signal ad0_n_94 : STD_LOGIC;
  signal ad0_n_95 : STD_LOGIC;
  signal ad0_n_96 : STD_LOGIC;
  signal ad0_n_97 : STD_LOGIC;
  signal ad0_n_98 : STD_LOGIC;
  signal ad0_n_99 : STD_LOGIC;
  signal bc0_n_100 : STD_LOGIC;
  signal bc0_n_101 : STD_LOGIC;
  signal bc0_n_102 : STD_LOGIC;
  signal bc0_n_103 : STD_LOGIC;
  signal bc0_n_104 : STD_LOGIC;
  signal bc0_n_105 : STD_LOGIC;
  signal bc0_n_67 : STD_LOGIC;
  signal bc0_n_68 : STD_LOGIC;
  signal bc0_n_69 : STD_LOGIC;
  signal bc0_n_70 : STD_LOGIC;
  signal bc0_n_71 : STD_LOGIC;
  signal bc0_n_72 : STD_LOGIC;
  signal bc0_n_73 : STD_LOGIC;
  signal bc0_n_74 : STD_LOGIC;
  signal bc0_n_75 : STD_LOGIC;
  signal bc0_n_76 : STD_LOGIC;
  signal bc0_n_77 : STD_LOGIC;
  signal bc0_n_78 : STD_LOGIC;
  signal bc0_n_79 : STD_LOGIC;
  signal bc0_n_80 : STD_LOGIC;
  signal bc0_n_81 : STD_LOGIC;
  signal bc0_n_82 : STD_LOGIC;
  signal bc0_n_83 : STD_LOGIC;
  signal bc0_n_84 : STD_LOGIC;
  signal bc0_n_85 : STD_LOGIC;
  signal bc0_n_86 : STD_LOGIC;
  signal bc0_n_87 : STD_LOGIC;
  signal bc0_n_88 : STD_LOGIC;
  signal bc0_n_89 : STD_LOGIC;
  signal bc0_n_90 : STD_LOGIC;
  signal bc0_n_91 : STD_LOGIC;
  signal bc0_n_92 : STD_LOGIC;
  signal bc0_n_93 : STD_LOGIC;
  signal bc0_n_94 : STD_LOGIC;
  signal bc0_n_95 : STD_LOGIC;
  signal bc0_n_96 : STD_LOGIC;
  signal bc0_n_97 : STD_LOGIC;
  signal bc0_n_98 : STD_LOGIC;
  signal bc0_n_99 : STD_LOGIC;
  signal bd : STD_LOGIC_VECTOR ( 36 downto 0 );
  signal bd0_n_100 : STD_LOGIC;
  signal bd0_n_101 : STD_LOGIC;
  signal bd0_n_102 : STD_LOGIC;
  signal bd0_n_103 : STD_LOGIC;
  signal bd0_n_104 : STD_LOGIC;
  signal bd0_n_105 : STD_LOGIC;
  signal bd0_n_67 : STD_LOGIC;
  signal bd0_n_68 : STD_LOGIC;
  signal bd0_n_69 : STD_LOGIC;
  signal bd0_n_70 : STD_LOGIC;
  signal bd0_n_71 : STD_LOGIC;
  signal bd0_n_72 : STD_LOGIC;
  signal bd0_n_73 : STD_LOGIC;
  signal bd0_n_74 : STD_LOGIC;
  signal bd0_n_75 : STD_LOGIC;
  signal bd0_n_76 : STD_LOGIC;
  signal bd0_n_77 : STD_LOGIC;
  signal bd0_n_78 : STD_LOGIC;
  signal bd0_n_79 : STD_LOGIC;
  signal bd0_n_80 : STD_LOGIC;
  signal bd0_n_81 : STD_LOGIC;
  signal bd0_n_82 : STD_LOGIC;
  signal bd0_n_83 : STD_LOGIC;
  signal bd0_n_84 : STD_LOGIC;
  signal bd0_n_85 : STD_LOGIC;
  signal bd0_n_86 : STD_LOGIC;
  signal bd0_n_87 : STD_LOGIC;
  signal bd0_n_88 : STD_LOGIC;
  signal bd0_n_89 : STD_LOGIC;
  signal bd0_n_90 : STD_LOGIC;
  signal bd0_n_91 : STD_LOGIC;
  signal bd0_n_92 : STD_LOGIC;
  signal bd0_n_93 : STD_LOGIC;
  signal bd0_n_94 : STD_LOGIC;
  signal bd0_n_95 : STD_LOGIC;
  signal bd0_n_96 : STD_LOGIC;
  signal bd0_n_97 : STD_LOGIC;
  signal bd0_n_98 : STD_LOGIC;
  signal bd0_n_99 : STD_LOGIC;
  signal \complexOut_o1__0_n_100\ : STD_LOGIC;
  signal \complexOut_o1__0_n_101\ : STD_LOGIC;
  signal \complexOut_o1__0_n_102\ : STD_LOGIC;
  signal \complexOut_o1__0_n_103\ : STD_LOGIC;
  signal \complexOut_o1__0_n_104\ : STD_LOGIC;
  signal \complexOut_o1__0_n_105\ : STD_LOGIC;
  signal \complexOut_o1__0_n_90\ : STD_LOGIC;
  signal \complexOut_o1__0_n_91\ : STD_LOGIC;
  signal \complexOut_o1__0_n_92\ : STD_LOGIC;
  signal \complexOut_o1__0_n_93\ : STD_LOGIC;
  signal \complexOut_o1__0_n_94\ : STD_LOGIC;
  signal \complexOut_o1__0_n_95\ : STD_LOGIC;
  signal \complexOut_o1__0_n_96\ : STD_LOGIC;
  signal \complexOut_o1__0_n_97\ : STD_LOGIC;
  signal \complexOut_o1__0_n_98\ : STD_LOGIC;
  signal \complexOut_o1__0_n_99\ : STD_LOGIC;
  signal complexOut_o1_n_100 : STD_LOGIC;
  signal complexOut_o1_n_101 : STD_LOGIC;
  signal complexOut_o1_n_102 : STD_LOGIC;
  signal complexOut_o1_n_103 : STD_LOGIC;
  signal complexOut_o1_n_104 : STD_LOGIC;
  signal complexOut_o1_n_105 : STD_LOGIC;
  signal complexOut_o1_n_66 : STD_LOGIC;
  signal complexOut_o1_n_67 : STD_LOGIC;
  signal complexOut_o1_n_68 : STD_LOGIC;
  signal complexOut_o1_n_69 : STD_LOGIC;
  signal complexOut_o1_n_70 : STD_LOGIC;
  signal complexOut_o1_n_71 : STD_LOGIC;
  signal complexOut_o1_n_72 : STD_LOGIC;
  signal complexOut_o1_n_73 : STD_LOGIC;
  signal complexOut_o1_n_74 : STD_LOGIC;
  signal complexOut_o1_n_75 : STD_LOGIC;
  signal complexOut_o1_n_76 : STD_LOGIC;
  signal complexOut_o1_n_77 : STD_LOGIC;
  signal complexOut_o1_n_78 : STD_LOGIC;
  signal complexOut_o1_n_79 : STD_LOGIC;
  signal complexOut_o1_n_80 : STD_LOGIC;
  signal complexOut_o1_n_81 : STD_LOGIC;
  signal complexOut_o1_n_82 : STD_LOGIC;
  signal complexOut_o1_n_83 : STD_LOGIC;
  signal complexOut_o1_n_84 : STD_LOGIC;
  signal complexOut_o1_n_85 : STD_LOGIC;
  signal complexOut_o1_n_86 : STD_LOGIC;
  signal complexOut_o1_n_87 : STD_LOGIC;
  signal complexOut_o1_n_88 : STD_LOGIC;
  signal complexOut_o1_n_89 : STD_LOGIC;
  signal complexOut_o1_n_90 : STD_LOGIC;
  signal complexOut_o1_n_91 : STD_LOGIC;
  signal complexOut_o1_n_92 : STD_LOGIC;
  signal complexOut_o1_n_93 : STD_LOGIC;
  signal complexOut_o1_n_94 : STD_LOGIC;
  signal complexOut_o1_n_95 : STD_LOGIC;
  signal complexOut_o1_n_96 : STD_LOGIC;
  signal complexOut_o1_n_97 : STD_LOGIC;
  signal complexOut_o1_n_98 : STD_LOGIC;
  signal complexOut_o1_n_99 : STD_LOGIC;
  signal \^fften_reg\ : STD_LOGIC_VECTOR ( 20 downto 0 );
  signal \reelOut_o1__0_n_100\ : STD_LOGIC;
  signal \reelOut_o1__0_n_101\ : STD_LOGIC;
  signal \reelOut_o1__0_n_102\ : STD_LOGIC;
  signal \reelOut_o1__0_n_103\ : STD_LOGIC;
  signal \reelOut_o1__0_n_104\ : STD_LOGIC;
  signal \reelOut_o1__0_n_105\ : STD_LOGIC;
  signal \reelOut_o1__0_n_90\ : STD_LOGIC;
  signal \reelOut_o1__0_n_91\ : STD_LOGIC;
  signal \reelOut_o1__0_n_92\ : STD_LOGIC;
  signal \reelOut_o1__0_n_93\ : STD_LOGIC;
  signal \reelOut_o1__0_n_94\ : STD_LOGIC;
  signal \reelOut_o1__0_n_95\ : STD_LOGIC;
  signal \reelOut_o1__0_n_96\ : STD_LOGIC;
  signal \reelOut_o1__0_n_97\ : STD_LOGIC;
  signal \reelOut_o1__0_n_98\ : STD_LOGIC;
  signal \reelOut_o1__0_n_99\ : STD_LOGIC;
  signal reelOut_o1_n_106 : STD_LOGIC;
  signal reelOut_o1_n_107 : STD_LOGIC;
  signal reelOut_o1_n_108 : STD_LOGIC;
  signal reelOut_o1_n_109 : STD_LOGIC;
  signal reelOut_o1_n_110 : STD_LOGIC;
  signal reelOut_o1_n_111 : STD_LOGIC;
  signal reelOut_o1_n_112 : STD_LOGIC;
  signal reelOut_o1_n_113 : STD_LOGIC;
  signal reelOut_o1_n_114 : STD_LOGIC;
  signal reelOut_o1_n_115 : STD_LOGIC;
  signal reelOut_o1_n_116 : STD_LOGIC;
  signal reelOut_o1_n_117 : STD_LOGIC;
  signal reelOut_o1_n_118 : STD_LOGIC;
  signal reelOut_o1_n_119 : STD_LOGIC;
  signal reelOut_o1_n_120 : STD_LOGIC;
  signal reelOut_o1_n_121 : STD_LOGIC;
  signal reelOut_o1_n_122 : STD_LOGIC;
  signal reelOut_o1_n_123 : STD_LOGIC;
  signal reelOut_o1_n_124 : STD_LOGIC;
  signal reelOut_o1_n_125 : STD_LOGIC;
  signal reelOut_o1_n_126 : STD_LOGIC;
  signal reelOut_o1_n_127 : STD_LOGIC;
  signal reelOut_o1_n_128 : STD_LOGIC;
  signal reelOut_o1_n_129 : STD_LOGIC;
  signal reelOut_o1_n_130 : STD_LOGIC;
  signal reelOut_o1_n_131 : STD_LOGIC;
  signal reelOut_o1_n_132 : STD_LOGIC;
  signal reelOut_o1_n_133 : STD_LOGIC;
  signal reelOut_o1_n_134 : STD_LOGIC;
  signal reelOut_o1_n_135 : STD_LOGIC;
  signal reelOut_o1_n_136 : STD_LOGIC;
  signal reelOut_o1_n_137 : STD_LOGIC;
  signal reelOut_o1_n_138 : STD_LOGIC;
  signal reelOut_o1_n_139 : STD_LOGIC;
  signal reelOut_o1_n_140 : STD_LOGIC;
  signal reelOut_o1_n_141 : STD_LOGIC;
  signal reelOut_o1_n_142 : STD_LOGIC;
  signal reelOut_o1_n_143 : STD_LOGIC;
  signal reelOut_o1_n_144 : STD_LOGIC;
  signal reelOut_o1_n_145 : STD_LOGIC;
  signal reelOut_o1_n_146 : STD_LOGIC;
  signal reelOut_o1_n_147 : STD_LOGIC;
  signal reelOut_o1_n_148 : STD_LOGIC;
  signal reelOut_o1_n_149 : STD_LOGIC;
  signal reelOut_o1_n_150 : STD_LOGIC;
  signal reelOut_o1_n_151 : STD_LOGIC;
  signal reelOut_o1_n_152 : STD_LOGIC;
  signal reelOut_o1_n_153 : STD_LOGIC;
  signal NLW_ac0_CARRYCASCOUT_UNCONNECTED : STD_LOGIC;
  signal NLW_ac0_MULTSIGNOUT_UNCONNECTED : STD_LOGIC;
  signal NLW_ac0_OVERFLOW_UNCONNECTED : STD_LOGIC;
  signal NLW_ac0_PATTERNBDETECT_UNCONNECTED : STD_LOGIC;
  signal NLW_ac0_PATTERNDETECT_UNCONNECTED : STD_LOGIC;
  signal NLW_ac0_UNDERFLOW_UNCONNECTED : STD_LOGIC;
  signal NLW_ac0_ACOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal NLW_ac0_BCOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal NLW_ac0_CARRYOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_ac0_P_UNCONNECTED : STD_LOGIC_VECTOR ( 47 downto 39 );
  signal NLW_ac0_PCOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal NLW_ac0_XOROUT_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_ad0_CARRYCASCOUT_UNCONNECTED : STD_LOGIC;
  signal NLW_ad0_MULTSIGNOUT_UNCONNECTED : STD_LOGIC;
  signal NLW_ad0_OVERFLOW_UNCONNECTED : STD_LOGIC;
  signal NLW_ad0_PATTERNBDETECT_UNCONNECTED : STD_LOGIC;
  signal NLW_ad0_PATTERNDETECT_UNCONNECTED : STD_LOGIC;
  signal NLW_ad0_UNDERFLOW_UNCONNECTED : STD_LOGIC;
  signal NLW_ad0_ACOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal NLW_ad0_BCOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal NLW_ad0_CARRYOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_ad0_P_UNCONNECTED : STD_LOGIC_VECTOR ( 47 downto 39 );
  signal NLW_ad0_PCOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal NLW_ad0_XOROUT_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bc0_CARRYCASCOUT_UNCONNECTED : STD_LOGIC;
  signal NLW_bc0_MULTSIGNOUT_UNCONNECTED : STD_LOGIC;
  signal NLW_bc0_OVERFLOW_UNCONNECTED : STD_LOGIC;
  signal NLW_bc0_PATTERNBDETECT_UNCONNECTED : STD_LOGIC;
  signal NLW_bc0_PATTERNDETECT_UNCONNECTED : STD_LOGIC;
  signal NLW_bc0_UNDERFLOW_UNCONNECTED : STD_LOGIC;
  signal NLW_bc0_ACOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal NLW_bc0_BCOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal NLW_bc0_CARRYOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bc0_P_UNCONNECTED : STD_LOGIC_VECTOR ( 47 downto 39 );
  signal NLW_bc0_PCOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal NLW_bc0_XOROUT_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_bd0_CARRYCASCOUT_UNCONNECTED : STD_LOGIC;
  signal NLW_bd0_MULTSIGNOUT_UNCONNECTED : STD_LOGIC;
  signal NLW_bd0_OVERFLOW_UNCONNECTED : STD_LOGIC;
  signal NLW_bd0_PATTERNBDETECT_UNCONNECTED : STD_LOGIC;
  signal NLW_bd0_PATTERNDETECT_UNCONNECTED : STD_LOGIC;
  signal NLW_bd0_UNDERFLOW_UNCONNECTED : STD_LOGIC;
  signal NLW_bd0_ACOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal NLW_bd0_BCOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal NLW_bd0_CARRYOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_bd0_P_UNCONNECTED : STD_LOGIC_VECTOR ( 47 downto 39 );
  signal NLW_bd0_PCOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal NLW_bd0_XOROUT_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_complexOut_o1_CARRYCASCOUT_UNCONNECTED : STD_LOGIC;
  signal NLW_complexOut_o1_MULTSIGNOUT_UNCONNECTED : STD_LOGIC;
  signal NLW_complexOut_o1_OVERFLOW_UNCONNECTED : STD_LOGIC;
  signal NLW_complexOut_o1_PATTERNBDETECT_UNCONNECTED : STD_LOGIC;
  signal NLW_complexOut_o1_PATTERNDETECT_UNCONNECTED : STD_LOGIC;
  signal NLW_complexOut_o1_UNDERFLOW_UNCONNECTED : STD_LOGIC;
  signal NLW_complexOut_o1_ACOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal NLW_complexOut_o1_BCOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal NLW_complexOut_o1_CARRYOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_complexOut_o1_P_UNCONNECTED : STD_LOGIC_VECTOR ( 47 downto 40 );
  signal NLW_complexOut_o1_PCOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal NLW_complexOut_o1_XOROUT_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \NLW_complexOut_o1__0_CARRYCASCOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_complexOut_o1__0_MULTSIGNOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_complexOut_o1__0_OVERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_complexOut_o1__0_PATTERNBDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_complexOut_o1__0_PATTERNDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_complexOut_o1__0_UNDERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_complexOut_o1__0_ACOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal \NLW_complexOut_o1__0_BCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal \NLW_complexOut_o1__0_CARRYOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_complexOut_o1__0_P_UNCONNECTED\ : STD_LOGIC_VECTOR ( 47 downto 37 );
  signal \NLW_complexOut_o1__0_PCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal \NLW_complexOut_o1__0_XOROUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_reelOut_o1_CARRYCASCOUT_UNCONNECTED : STD_LOGIC;
  signal NLW_reelOut_o1_MULTSIGNOUT_UNCONNECTED : STD_LOGIC;
  signal NLW_reelOut_o1_OVERFLOW_UNCONNECTED : STD_LOGIC;
  signal NLW_reelOut_o1_PATTERNBDETECT_UNCONNECTED : STD_LOGIC;
  signal NLW_reelOut_o1_PATTERNDETECT_UNCONNECTED : STD_LOGIC;
  signal NLW_reelOut_o1_UNDERFLOW_UNCONNECTED : STD_LOGIC;
  signal NLW_reelOut_o1_ACOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal NLW_reelOut_o1_BCOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal NLW_reelOut_o1_CARRYOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_reelOut_o1_P_UNCONNECTED : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal NLW_reelOut_o1_XOROUT_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \NLW_reelOut_o1__0_CARRYCASCOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_reelOut_o1__0_MULTSIGNOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_reelOut_o1__0_OVERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_reelOut_o1__0_PATTERNBDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_reelOut_o1__0_PATTERNDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_reelOut_o1__0_UNDERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_reelOut_o1__0_ACOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal \NLW_reelOut_o1__0_BCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal \NLW_reelOut_o1__0_CARRYOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_reelOut_o1__0_P_UNCONNECTED\ : STD_LOGIC_VECTOR ( 47 downto 37 );
  signal \NLW_reelOut_o1__0_PCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal \NLW_reelOut_o1__0_XOROUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  attribute KEEP_HIERARCHY : string;
  attribute KEEP_HIERARCHY of ac0 : label is "YES";
  attribute METHODOLOGY_DRC_VIOS : string;
  attribute METHODOLOGY_DRC_VIOS of ac0 : label is "{SYNTH-12 {cell *THIS*}}";
  attribute KEEP_HIERARCHY of ad0 : label is "YES";
  attribute METHODOLOGY_DRC_VIOS of ad0 : label is "{SYNTH-12 {cell *THIS*}}";
  attribute KEEP_HIERARCHY of bc0 : label is "YES";
  attribute METHODOLOGY_DRC_VIOS of bc0 : label is "{SYNTH-12 {cell *THIS*}}";
  attribute KEEP_HIERARCHY of bd0 : label is "YES";
  attribute METHODOLOGY_DRC_VIOS of bd0 : label is "{SYNTH-12 {cell *THIS*}}";
  attribute KEEP_HIERARCHY of complexOut_o1 : label is "YES";
  attribute METHODOLOGY_DRC_VIOS of complexOut_o1 : label is "{SYNTH-13 {cell *THIS*}}";
  attribute KEEP_HIERARCHY of \complexOut_o1__0\ : label is "YES";
  attribute METHODOLOGY_DRC_VIOS of \complexOut_o1__0\ : label is "{SYNTH-12 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of reelOut_o1 : label is "{SYNTH-13 {cell *THIS*}}";
  attribute KEEP_HIERARCHY of \reelOut_o1__0\ : label is "YES";
  attribute METHODOLOGY_DRC_VIOS of \reelOut_o1__0\ : label is "{SYNTH-12 {cell *THIS*}}";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_1\ : label is "soft_lutpair197";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_10\ : label is "soft_lutpair193";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_11\ : label is "soft_lutpair192";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_12\ : label is "soft_lutpair192";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_13\ : label is "soft_lutpair191";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_14\ : label is "soft_lutpair191";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_15\ : label is "soft_lutpair190";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_16\ : label is "soft_lutpair190";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_17\ : label is "soft_lutpair189";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_18\ : label is "soft_lutpair189";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_19\ : label is "soft_lutpair207";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_2\ : label is "soft_lutpair197";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_20\ : label is "soft_lutpair206";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_21\ : label is "soft_lutpair206";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_22\ : label is "soft_lutpair205";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_23\ : label is "soft_lutpair205";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_24\ : label is "soft_lutpair204";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_25\ : label is "soft_lutpair204";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_26\ : label is "soft_lutpair203";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_27\ : label is "soft_lutpair203";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_28\ : label is "soft_lutpair202";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_29\ : label is "soft_lutpair202";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_3\ : label is "soft_lutpair196";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_30\ : label is "soft_lutpair201";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_31\ : label is "soft_lutpair201";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_32\ : label is "soft_lutpair200";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_33\ : label is "soft_lutpair200";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_34\ : label is "soft_lutpair199";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_35\ : label is "soft_lutpair199";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_36\ : label is "soft_lutpair198";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_37\ : label is "soft_lutpair198";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_4\ : label is "soft_lutpair196";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_5\ : label is "soft_lutpair195";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_6\ : label is "soft_lutpair195";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_7\ : label is "soft_lutpair194";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_8\ : label is "soft_lutpair194";
  attribute SOFT_HLUTNM of \reelOut_o1__0_i_9\ : label is "soft_lutpair193";
  attribute SOFT_HLUTNM of reelOut_o1_i_1 : label is "soft_lutpair216";
  attribute SOFT_HLUTNM of reelOut_o1_i_10 : label is "soft_lutpair211";
  attribute SOFT_HLUTNM of reelOut_o1_i_11 : label is "soft_lutpair211";
  attribute SOFT_HLUTNM of reelOut_o1_i_12 : label is "soft_lutpair210";
  attribute SOFT_HLUTNM of reelOut_o1_i_13 : label is "soft_lutpair210";
  attribute SOFT_HLUTNM of reelOut_o1_i_14 : label is "soft_lutpair209";
  attribute SOFT_HLUTNM of reelOut_o1_i_15 : label is "soft_lutpair209";
  attribute SOFT_HLUTNM of reelOut_o1_i_16 : label is "soft_lutpair208";
  attribute SOFT_HLUTNM of reelOut_o1_i_17 : label is "soft_lutpair208";
  attribute SOFT_HLUTNM of reelOut_o1_i_18 : label is "soft_lutpair207";
  attribute SOFT_HLUTNM of reelOut_o1_i_19 : label is "soft_lutpair225";
  attribute SOFT_HLUTNM of reelOut_o1_i_2 : label is "soft_lutpair215";
  attribute SOFT_HLUTNM of reelOut_o1_i_20 : label is "soft_lutpair225";
  attribute SOFT_HLUTNM of reelOut_o1_i_21 : label is "soft_lutpair224";
  attribute SOFT_HLUTNM of reelOut_o1_i_22 : label is "soft_lutpair224";
  attribute SOFT_HLUTNM of reelOut_o1_i_23 : label is "soft_lutpair223";
  attribute SOFT_HLUTNM of reelOut_o1_i_24 : label is "soft_lutpair223";
  attribute SOFT_HLUTNM of reelOut_o1_i_25 : label is "soft_lutpair222";
  attribute SOFT_HLUTNM of reelOut_o1_i_26 : label is "soft_lutpair222";
  attribute SOFT_HLUTNM of reelOut_o1_i_27 : label is "soft_lutpair221";
  attribute SOFT_HLUTNM of reelOut_o1_i_28 : label is "soft_lutpair221";
  attribute SOFT_HLUTNM of reelOut_o1_i_29 : label is "soft_lutpair220";
  attribute SOFT_HLUTNM of reelOut_o1_i_3 : label is "soft_lutpair215";
  attribute SOFT_HLUTNM of reelOut_o1_i_30 : label is "soft_lutpair220";
  attribute SOFT_HLUTNM of reelOut_o1_i_31 : label is "soft_lutpair219";
  attribute SOFT_HLUTNM of reelOut_o1_i_32 : label is "soft_lutpair219";
  attribute SOFT_HLUTNM of reelOut_o1_i_33 : label is "soft_lutpair218";
  attribute SOFT_HLUTNM of reelOut_o1_i_34 : label is "soft_lutpair218";
  attribute SOFT_HLUTNM of reelOut_o1_i_35 : label is "soft_lutpair217";
  attribute SOFT_HLUTNM of reelOut_o1_i_36 : label is "soft_lutpair217";
  attribute SOFT_HLUTNM of reelOut_o1_i_37 : label is "soft_lutpair216";
  attribute SOFT_HLUTNM of reelOut_o1_i_4 : label is "soft_lutpair214";
  attribute SOFT_HLUTNM of reelOut_o1_i_5 : label is "soft_lutpair214";
  attribute SOFT_HLUTNM of reelOut_o1_i_6 : label is "soft_lutpair213";
  attribute SOFT_HLUTNM of reelOut_o1_i_7 : label is "soft_lutpair213";
  attribute SOFT_HLUTNM of reelOut_o1_i_8 : label is "soft_lutpair212";
  attribute SOFT_HLUTNM of reelOut_o1_i_9 : label is "soft_lutpair212";
begin
  P(20 downto 0) <= \^p\(20 downto 0);
  fftEn_reg(20 downto 0) <= \^fften_reg\(20 downto 0);
ac0: unisim.vcomponents.DSP48E2
    generic map(
      ACASCREG => 0,
      ADREG => 1,
      ALUMODEREG => 0,
      AMULTSEL => "A",
      AREG => 0,
      AUTORESET_PATDET => "NO_RESET",
      AUTORESET_PRIORITY => "RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 0,
      BMULTSEL => "B",
      BREG => 0,
      B_INPUT => "DIRECT",
      CARRYINREG => 0,
      CARRYINSELREG => 0,
      CREG => 1,
      DREG => 1,
      INMODEREG => 0,
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 0,
      PATTERN => X"000000000000",
      PREADDINSEL => "A",
      PREG => 1,
      RND => X"000000000000",
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_MULT => "MULTIPLY",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48",
      USE_WIDEXOR => "FALSE",
      XORSIMD => "XOR24_48_96"
    )
        port map (
      A(29) => muxReel(20),
      A(28) => muxReel(20),
      A(27) => muxReel(20),
      A(26) => muxReel(20),
      A(25) => muxReel(20),
      A(24) => muxReel(20),
      A(23) => muxReel(20),
      A(22) => muxReel(20),
      A(21) => muxReel(20),
      A(20 downto 0) => muxReel(20 downto 0),
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29 downto 0) => NLW_ac0_ACOUT_UNCONNECTED(29 downto 0),
      ALUMODE(3 downto 0) => B"0000",
      B(17) => '0',
      B(16) => Q(0),
      B(15 downto 0) => B"0000000000000000",
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => NLW_ac0_BCOUT_UNCONNECTED(17 downto 0),
      C(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      CARRYCASCIN => '0',
      CARRYCASCOUT => NLW_ac0_CARRYCASCOUT_UNCONNECTED,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => NLW_ac0_CARRYOUT_UNCONNECTED(3 downto 0),
      CEA1 => '0',
      CEA2 => '0',
      CEAD => '0',
      CEALUMODE => '0',
      CEB1 => '0',
      CEB2 => '0',
      CEC => '0',
      CECARRYIN => '0',
      CECTRL => '0',
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => D(0),
      CLK => aclk,
      D(26 downto 0) => B"000000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => NLW_ac0_MULTSIGNOUT_UNCONNECTED,
      OPMODE(8 downto 0) => B"000000101",
      OVERFLOW => NLW_ac0_OVERFLOW_UNCONNECTED,
      P(47 downto 39) => NLW_ac0_P_UNCONNECTED(47 downto 39),
      P(38) => ac0_n_67,
      P(37) => ac0_n_68,
      P(36) => ac0_n_69,
      P(35) => ac0_n_70,
      P(34) => ac0_n_71,
      P(33) => ac0_n_72,
      P(32) => ac0_n_73,
      P(31) => ac0_n_74,
      P(30) => ac0_n_75,
      P(29) => ac0_n_76,
      P(28) => ac0_n_77,
      P(27) => ac0_n_78,
      P(26) => ac0_n_79,
      P(25) => ac0_n_80,
      P(24) => ac0_n_81,
      P(23) => ac0_n_82,
      P(22) => ac0_n_83,
      P(21) => ac0_n_84,
      P(20) => ac0_n_85,
      P(19) => ac0_n_86,
      P(18) => ac0_n_87,
      P(17) => ac0_n_88,
      P(16) => ac0_n_89,
      P(15) => ac0_n_90,
      P(14) => ac0_n_91,
      P(13) => ac0_n_92,
      P(12) => ac0_n_93,
      P(11) => ac0_n_94,
      P(10) => ac0_n_95,
      P(9) => ac0_n_96,
      P(8) => ac0_n_97,
      P(7) => ac0_n_98,
      P(6) => ac0_n_99,
      P(5) => ac0_n_100,
      P(4) => ac0_n_101,
      P(3) => ac0_n_102,
      P(2) => ac0_n_103,
      P(1) => ac0_n_104,
      P(0) => ac0_n_105,
      PATTERNBDETECT => NLW_ac0_PATTERNBDETECT_UNCONNECTED,
      PATTERNDETECT => NLW_ac0_PATTERNDETECT_UNCONNECTED,
      PCIN(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      PCOUT(47 downto 0) => NLW_ac0_PCOUT_UNCONNECTED(47 downto 0),
      RSTA => '0',
      RSTALLCARRYIN => '0',
      RSTALUMODE => '0',
      RSTB => '0',
      RSTC => '0',
      RSTCTRL => '0',
      RSTD => '0',
      RSTINMODE => '0',
      RSTM => '0',
      RSTP => '0',
      UNDERFLOW => NLW_ac0_UNDERFLOW_UNCONNECTED,
      XOROUT(7 downto 0) => NLW_ac0_XOROUT_UNCONNECTED(7 downto 0)
    );
ad0: unisim.vcomponents.DSP48E2
    generic map(
      ACASCREG => 0,
      ADREG => 1,
      ALUMODEREG => 0,
      AMULTSEL => "A",
      AREG => 0,
      AUTORESET_PATDET => "NO_RESET",
      AUTORESET_PRIORITY => "RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 0,
      BMULTSEL => "B",
      BREG => 0,
      B_INPUT => "DIRECT",
      CARRYINREG => 0,
      CARRYINSELREG => 0,
      CREG => 1,
      DREG => 1,
      INMODEREG => 0,
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 0,
      PATTERN => X"000000000000",
      PREADDINSEL => "A",
      PREG => 1,
      RND => X"000000000000",
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_MULT => "MULTIPLY",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48",
      USE_WIDEXOR => "FALSE",
      XORSIMD => "XOR24_48_96"
    )
        port map (
      A(29) => muxReel(20),
      A(28) => muxReel(20),
      A(27) => muxReel(20),
      A(26) => muxReel(20),
      A(25) => muxReel(20),
      A(24) => muxReel(20),
      A(23) => muxReel(20),
      A(22) => muxReel(20),
      A(21) => muxReel(20),
      A(20 downto 0) => muxReel(20 downto 0),
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29 downto 0) => NLW_ad0_ACOUT_UNCONNECTED(29 downto 0),
      ALUMODE(3 downto 0) => B"0000",
      B(17 downto 0) => B"000000000000000000",
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => NLW_ad0_BCOUT_UNCONNECTED(17 downto 0),
      C(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      CARRYCASCIN => '0',
      CARRYCASCOUT => NLW_ad0_CARRYCASCOUT_UNCONNECTED,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => NLW_ad0_CARRYOUT_UNCONNECTED(3 downto 0),
      CEA1 => '0',
      CEA2 => '0',
      CEAD => '0',
      CEALUMODE => '0',
      CEB1 => '0',
      CEB2 => '0',
      CEC => '0',
      CECARRYIN => '0',
      CECTRL => '0',
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => D(0),
      CLK => aclk,
      D(26 downto 0) => B"000000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => NLW_ad0_MULTSIGNOUT_UNCONNECTED,
      OPMODE(8 downto 0) => B"000000101",
      OVERFLOW => NLW_ad0_OVERFLOW_UNCONNECTED,
      P(47 downto 39) => NLW_ad0_P_UNCONNECTED(47 downto 39),
      P(38) => ad0_n_67,
      P(37) => ad0_n_68,
      P(36) => ad0_n_69,
      P(35) => ad0_n_70,
      P(34) => ad0_n_71,
      P(33) => ad0_n_72,
      P(32) => ad0_n_73,
      P(31) => ad0_n_74,
      P(30) => ad0_n_75,
      P(29) => ad0_n_76,
      P(28) => ad0_n_77,
      P(27) => ad0_n_78,
      P(26) => ad0_n_79,
      P(25) => ad0_n_80,
      P(24) => ad0_n_81,
      P(23) => ad0_n_82,
      P(22) => ad0_n_83,
      P(21) => ad0_n_84,
      P(20) => ad0_n_85,
      P(19) => ad0_n_86,
      P(18) => ad0_n_87,
      P(17) => ad0_n_88,
      P(16) => ad0_n_89,
      P(15) => ad0_n_90,
      P(14) => ad0_n_91,
      P(13) => ad0_n_92,
      P(12) => ad0_n_93,
      P(11) => ad0_n_94,
      P(10) => ad0_n_95,
      P(9) => ad0_n_96,
      P(8) => ad0_n_97,
      P(7) => ad0_n_98,
      P(6) => ad0_n_99,
      P(5) => ad0_n_100,
      P(4) => ad0_n_101,
      P(3) => ad0_n_102,
      P(2) => ad0_n_103,
      P(1) => ad0_n_104,
      P(0) => ad0_n_105,
      PATTERNBDETECT => NLW_ad0_PATTERNBDETECT_UNCONNECTED,
      PATTERNDETECT => NLW_ad0_PATTERNDETECT_UNCONNECTED,
      PCIN(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      PCOUT(47 downto 0) => NLW_ad0_PCOUT_UNCONNECTED(47 downto 0),
      RSTA => '0',
      RSTALLCARRYIN => '0',
      RSTALUMODE => '0',
      RSTB => '0',
      RSTC => '0',
      RSTCTRL => '0',
      RSTD => '0',
      RSTINMODE => '0',
      RSTM => '0',
      RSTP => '0',
      UNDERFLOW => NLW_ad0_UNDERFLOW_UNCONNECTED,
      XOROUT(7 downto 0) => NLW_ad0_XOROUT_UNCONNECTED(7 downto 0)
    );
bc0: unisim.vcomponents.DSP48E2
    generic map(
      ACASCREG => 0,
      ADREG => 1,
      ALUMODEREG => 0,
      AMULTSEL => "A",
      AREG => 0,
      AUTORESET_PATDET => "NO_RESET",
      AUTORESET_PRIORITY => "RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 0,
      BMULTSEL => "B",
      BREG => 0,
      B_INPUT => "DIRECT",
      CARRYINREG => 0,
      CARRYINSELREG => 0,
      CREG => 1,
      DREG => 1,
      INMODEREG => 0,
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 0,
      PATTERN => X"000000000000",
      PREADDINSEL => "A",
      PREG => 1,
      RND => X"000000000000",
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_MULT => "MULTIPLY",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48",
      USE_WIDEXOR => "FALSE",
      XORSIMD => "XOR24_48_96"
    )
        port map (
      A(29) => muxComplex(20),
      A(28) => muxComplex(20),
      A(27) => muxComplex(20),
      A(26) => muxComplex(20),
      A(25) => muxComplex(20),
      A(24) => muxComplex(20),
      A(23) => muxComplex(20),
      A(22) => muxComplex(20),
      A(21) => muxComplex(20),
      A(20 downto 0) => muxComplex(20 downto 0),
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29 downto 0) => NLW_bc0_ACOUT_UNCONNECTED(29 downto 0),
      ALUMODE(3 downto 0) => B"0000",
      B(17) => '0',
      B(16) => Q(0),
      B(15 downto 0) => B"0000000000000000",
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => NLW_bc0_BCOUT_UNCONNECTED(17 downto 0),
      C(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      CARRYCASCIN => '0',
      CARRYCASCOUT => NLW_bc0_CARRYCASCOUT_UNCONNECTED,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => NLW_bc0_CARRYOUT_UNCONNECTED(3 downto 0),
      CEA1 => '0',
      CEA2 => '0',
      CEAD => '0',
      CEALUMODE => '0',
      CEB1 => '0',
      CEB2 => '0',
      CEC => '0',
      CECARRYIN => '0',
      CECTRL => '0',
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => D(0),
      CLK => aclk,
      D(26 downto 0) => B"000000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => NLW_bc0_MULTSIGNOUT_UNCONNECTED,
      OPMODE(8 downto 0) => B"000000101",
      OVERFLOW => NLW_bc0_OVERFLOW_UNCONNECTED,
      P(47 downto 39) => NLW_bc0_P_UNCONNECTED(47 downto 39),
      P(38) => bc0_n_67,
      P(37) => bc0_n_68,
      P(36) => bc0_n_69,
      P(35) => bc0_n_70,
      P(34) => bc0_n_71,
      P(33) => bc0_n_72,
      P(32) => bc0_n_73,
      P(31) => bc0_n_74,
      P(30) => bc0_n_75,
      P(29) => bc0_n_76,
      P(28) => bc0_n_77,
      P(27) => bc0_n_78,
      P(26) => bc0_n_79,
      P(25) => bc0_n_80,
      P(24) => bc0_n_81,
      P(23) => bc0_n_82,
      P(22) => bc0_n_83,
      P(21) => bc0_n_84,
      P(20) => bc0_n_85,
      P(19) => bc0_n_86,
      P(18) => bc0_n_87,
      P(17) => bc0_n_88,
      P(16) => bc0_n_89,
      P(15) => bc0_n_90,
      P(14) => bc0_n_91,
      P(13) => bc0_n_92,
      P(12) => bc0_n_93,
      P(11) => bc0_n_94,
      P(10) => bc0_n_95,
      P(9) => bc0_n_96,
      P(8) => bc0_n_97,
      P(7) => bc0_n_98,
      P(6) => bc0_n_99,
      P(5) => bc0_n_100,
      P(4) => bc0_n_101,
      P(3) => bc0_n_102,
      P(2) => bc0_n_103,
      P(1) => bc0_n_104,
      P(0) => bc0_n_105,
      PATTERNBDETECT => NLW_bc0_PATTERNBDETECT_UNCONNECTED,
      PATTERNDETECT => NLW_bc0_PATTERNDETECT_UNCONNECTED,
      PCIN(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      PCOUT(47 downto 0) => NLW_bc0_PCOUT_UNCONNECTED(47 downto 0),
      RSTA => '0',
      RSTALLCARRYIN => '0',
      RSTALUMODE => '0',
      RSTB => '0',
      RSTC => '0',
      RSTCTRL => '0',
      RSTD => '0',
      RSTINMODE => '0',
      RSTM => '0',
      RSTP => '0',
      UNDERFLOW => NLW_bc0_UNDERFLOW_UNCONNECTED,
      XOROUT(7 downto 0) => NLW_bc0_XOROUT_UNCONNECTED(7 downto 0)
    );
bd0: unisim.vcomponents.DSP48E2
    generic map(
      ACASCREG => 0,
      ADREG => 1,
      ALUMODEREG => 0,
      AMULTSEL => "A",
      AREG => 0,
      AUTORESET_PATDET => "NO_RESET",
      AUTORESET_PRIORITY => "RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 0,
      BMULTSEL => "B",
      BREG => 0,
      B_INPUT => "DIRECT",
      CARRYINREG => 0,
      CARRYINSELREG => 0,
      CREG => 1,
      DREG => 1,
      INMODEREG => 0,
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 0,
      PATTERN => X"000000000000",
      PREADDINSEL => "A",
      PREG => 1,
      RND => X"000000000000",
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_MULT => "MULTIPLY",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48",
      USE_WIDEXOR => "FALSE",
      XORSIMD => "XOR24_48_96"
    )
        port map (
      A(29) => muxComplex(20),
      A(28) => muxComplex(20),
      A(27) => muxComplex(20),
      A(26) => muxComplex(20),
      A(25) => muxComplex(20),
      A(24) => muxComplex(20),
      A(23) => muxComplex(20),
      A(22) => muxComplex(20),
      A(21) => muxComplex(20),
      A(20 downto 0) => muxComplex(20 downto 0),
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29 downto 0) => NLW_bd0_ACOUT_UNCONNECTED(29 downto 0),
      ALUMODE(3 downto 0) => B"0000",
      B(17 downto 0) => B"000000000000000000",
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => NLW_bd0_BCOUT_UNCONNECTED(17 downto 0),
      C(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      CARRYCASCIN => '0',
      CARRYCASCOUT => NLW_bd0_CARRYCASCOUT_UNCONNECTED,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => NLW_bd0_CARRYOUT_UNCONNECTED(3 downto 0),
      CEA1 => '0',
      CEA2 => '0',
      CEAD => '0',
      CEALUMODE => '0',
      CEB1 => '0',
      CEB2 => '0',
      CEC => '0',
      CECARRYIN => '0',
      CECTRL => '0',
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => D(0),
      CLK => aclk,
      D(26 downto 0) => B"000000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => NLW_bd0_MULTSIGNOUT_UNCONNECTED,
      OPMODE(8 downto 0) => B"000000101",
      OVERFLOW => NLW_bd0_OVERFLOW_UNCONNECTED,
      P(47 downto 39) => NLW_bd0_P_UNCONNECTED(47 downto 39),
      P(38) => bd0_n_67,
      P(37) => bd0_n_68,
      P(36) => bd0_n_69,
      P(35) => bd0_n_70,
      P(34) => bd0_n_71,
      P(33) => bd0_n_72,
      P(32) => bd0_n_73,
      P(31) => bd0_n_74,
      P(30) => bd0_n_75,
      P(29) => bd0_n_76,
      P(28) => bd0_n_77,
      P(27) => bd0_n_78,
      P(26) => bd0_n_79,
      P(25) => bd0_n_80,
      P(24) => bd0_n_81,
      P(23) => bd0_n_82,
      P(22) => bd0_n_83,
      P(21) => bd0_n_84,
      P(20) => bd0_n_85,
      P(19) => bd0_n_86,
      P(18) => bd0_n_87,
      P(17) => bd0_n_88,
      P(16) => bd0_n_89,
      P(15) => bd0_n_90,
      P(14) => bd0_n_91,
      P(13) => bd0_n_92,
      P(12) => bd0_n_93,
      P(11) => bd0_n_94,
      P(10) => bd0_n_95,
      P(9) => bd0_n_96,
      P(8) => bd0_n_97,
      P(7) => bd0_n_98,
      P(6) => bd0_n_99,
      P(5) => bd0_n_100,
      P(4) => bd0_n_101,
      P(3) => bd0_n_102,
      P(2) => bd0_n_103,
      P(1) => bd0_n_104,
      P(0) => bd0_n_105,
      PATTERNBDETECT => NLW_bd0_PATTERNBDETECT_UNCONNECTED,
      PATTERNDETECT => NLW_bd0_PATTERNDETECT_UNCONNECTED,
      PCIN(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      PCOUT(47 downto 0) => NLW_bd0_PCOUT_UNCONNECTED(47 downto 0),
      RSTA => '0',
      RSTALLCARRYIN => '0',
      RSTALUMODE => '0',
      RSTB => '0',
      RSTC => '0',
      RSTCTRL => '0',
      RSTD => '0',
      RSTINMODE => '0',
      RSTM => '0',
      RSTP => '0',
      UNDERFLOW => NLW_bd0_UNDERFLOW_UNCONNECTED,
      XOROUT(7 downto 0) => NLW_bd0_XOROUT_UNCONNECTED(7 downto 0)
    );
complexOut_o1: unisim.vcomponents.DSP48E2
    generic map(
      ACASCREG => 0,
      ADREG => 1,
      ALUMODEREG => 0,
      AMULTSEL => "A",
      AREG => 0,
      AUTORESET_PATDET => "NO_RESET",
      AUTORESET_PRIORITY => "RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 0,
      BMULTSEL => "B",
      BREG => 0,
      B_INPUT => "DIRECT",
      CARRYINREG => 0,
      CARRYINSELREG => 0,
      CREG => 0,
      DREG => 1,
      INMODEREG => 0,
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 0,
      PATTERN => X"000000000000",
      PREADDINSEL => "A",
      PREG => 0,
      RND => X"000000000000",
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_MULT => "NONE",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48",
      USE_WIDEXOR => "FALSE",
      XORSIMD => "XOR24_48_96"
    )
        port map (
      A(29 downto 0) => B"000000000000000000000000000000",
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29 downto 0) => NLW_complexOut_o1_ACOUT_UNCONNECTED(29 downto 0),
      ALUMODE(3 downto 0) => B"0000",
      B(17 downto 0) => B"001000000000000000",
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => NLW_complexOut_o1_BCOUT_UNCONNECTED(17 downto 0),
      C(47) => ad0_n_67,
      C(46) => ad0_n_67,
      C(45) => ad0_n_67,
      C(44) => ad0_n_67,
      C(43) => ad0_n_67,
      C(42) => ad0_n_67,
      C(41) => ad0_n_67,
      C(40) => ad0_n_67,
      C(39) => ad0_n_67,
      C(38) => ad0_n_67,
      C(37) => ad0_n_68,
      C(36) => ad0_n_69,
      C(35) => ad0_n_70,
      C(34) => ad0_n_71,
      C(33) => ad0_n_72,
      C(32) => ad0_n_73,
      C(31) => ad0_n_74,
      C(30) => ad0_n_75,
      C(29) => ad0_n_76,
      C(28) => ad0_n_77,
      C(27) => ad0_n_78,
      C(26) => ad0_n_79,
      C(25) => ad0_n_80,
      C(24) => ad0_n_81,
      C(23) => ad0_n_82,
      C(22) => ad0_n_83,
      C(21) => ad0_n_84,
      C(20) => ad0_n_85,
      C(19) => ad0_n_86,
      C(18) => ad0_n_87,
      C(17) => ad0_n_88,
      C(16) => ad0_n_89,
      C(15) => ad0_n_90,
      C(14) => ad0_n_91,
      C(13) => ad0_n_92,
      C(12) => ad0_n_93,
      C(11) => ad0_n_94,
      C(10) => ad0_n_95,
      C(9) => ad0_n_96,
      C(8) => ad0_n_97,
      C(7) => ad0_n_98,
      C(6) => ad0_n_99,
      C(5) => ad0_n_100,
      C(4) => ad0_n_101,
      C(3) => ad0_n_102,
      C(2) => ad0_n_103,
      C(1) => ad0_n_104,
      C(0) => ad0_n_105,
      CARRYCASCIN => '0',
      CARRYCASCOUT => NLW_complexOut_o1_CARRYCASCOUT_UNCONNECTED,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => NLW_complexOut_o1_CARRYOUT_UNCONNECTED(3 downto 0),
      CEA1 => '0',
      CEA2 => '0',
      CEAD => '0',
      CEALUMODE => '0',
      CEB1 => '0',
      CEB2 => '0',
      CEC => '0',
      CECARRYIN => '0',
      CECTRL => '0',
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => '0',
      CLK => '0',
      D(26 downto 0) => B"000000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => NLW_complexOut_o1_MULTSIGNOUT_UNCONNECTED,
      OPMODE(8 downto 6) => B"000",
      OPMODE(5) => OPMODE(0),
      OPMODE(4) => OPMODE(0),
      OPMODE(3 downto 0) => B"0011",
      OVERFLOW => NLW_complexOut_o1_OVERFLOW_UNCONNECTED,
      P(47 downto 40) => NLW_complexOut_o1_P_UNCONNECTED(47 downto 40),
      P(39) => complexOut_o1_n_66,
      P(38) => complexOut_o1_n_67,
      P(37) => complexOut_o1_n_68,
      P(36) => complexOut_o1_n_69,
      P(35) => complexOut_o1_n_70,
      P(34) => complexOut_o1_n_71,
      P(33) => complexOut_o1_n_72,
      P(32) => complexOut_o1_n_73,
      P(31) => complexOut_o1_n_74,
      P(30) => complexOut_o1_n_75,
      P(29) => complexOut_o1_n_76,
      P(28) => complexOut_o1_n_77,
      P(27) => complexOut_o1_n_78,
      P(26) => complexOut_o1_n_79,
      P(25) => complexOut_o1_n_80,
      P(24) => complexOut_o1_n_81,
      P(23) => complexOut_o1_n_82,
      P(22) => complexOut_o1_n_83,
      P(21) => complexOut_o1_n_84,
      P(20) => complexOut_o1_n_85,
      P(19) => complexOut_o1_n_86,
      P(18) => complexOut_o1_n_87,
      P(17) => complexOut_o1_n_88,
      P(16) => complexOut_o1_n_89,
      P(15) => complexOut_o1_n_90,
      P(14) => complexOut_o1_n_91,
      P(13) => complexOut_o1_n_92,
      P(12) => complexOut_o1_n_93,
      P(11) => complexOut_o1_n_94,
      P(10) => complexOut_o1_n_95,
      P(9) => complexOut_o1_n_96,
      P(8) => complexOut_o1_n_97,
      P(7) => complexOut_o1_n_98,
      P(6) => complexOut_o1_n_99,
      P(5) => complexOut_o1_n_100,
      P(4) => complexOut_o1_n_101,
      P(3) => complexOut_o1_n_102,
      P(2) => complexOut_o1_n_103,
      P(1) => complexOut_o1_n_104,
      P(0) => complexOut_o1_n_105,
      PATTERNBDETECT => NLW_complexOut_o1_PATTERNBDETECT_UNCONNECTED,
      PATTERNDETECT => NLW_complexOut_o1_PATTERNDETECT_UNCONNECTED,
      PCIN(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      PCOUT(47 downto 0) => NLW_complexOut_o1_PCOUT_UNCONNECTED(47 downto 0),
      RSTA => '0',
      RSTALLCARRYIN => '0',
      RSTALUMODE => '0',
      RSTB => '0',
      RSTC => '0',
      RSTCTRL => '0',
      RSTD => '0',
      RSTINMODE => '0',
      RSTM => '0',
      RSTP => '0',
      UNDERFLOW => NLW_complexOut_o1_UNDERFLOW_UNCONNECTED,
      XOROUT(7 downto 0) => NLW_complexOut_o1_XOROUT_UNCONNECTED(7 downto 0)
    );
\complexOut_o1__0\: unisim.vcomponents.DSP48E2
    generic map(
      ACASCREG => 0,
      ADREG => 1,
      ALUMODEREG => 0,
      AMULTSEL => "A",
      AREG => 0,
      AUTORESET_PATDET => "NO_RESET",
      AUTORESET_PRIORITY => "RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 0,
      BMULTSEL => "B",
      BREG => 0,
      B_INPUT => "DIRECT",
      CARRYINREG => 0,
      CARRYINSELREG => 0,
      CREG => 0,
      DREG => 1,
      INMODEREG => 0,
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 0,
      PATTERN => X"000000000000",
      PREADDINSEL => "A",
      PREG => 1,
      RND => X"000000000000",
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_MULT => "NONE",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48",
      USE_WIDEXOR => "FALSE",
      XORSIMD => "XOR24_48_96"
    )
        port map (
      A(29) => complexOut_o1_n_69,
      A(28) => complexOut_o1_n_69,
      A(27) => complexOut_o1_n_69,
      A(26) => complexOut_o1_n_69,
      A(25) => complexOut_o1_n_69,
      A(24) => complexOut_o1_n_69,
      A(23) => complexOut_o1_n_69,
      A(22) => complexOut_o1_n_69,
      A(21) => complexOut_o1_n_69,
      A(20) => complexOut_o1_n_69,
      A(19) => complexOut_o1_n_69,
      A(18) => complexOut_o1_n_69,
      A(17) => complexOut_o1_n_70,
      A(16) => complexOut_o1_n_71,
      A(15) => complexOut_o1_n_72,
      A(14) => complexOut_o1_n_73,
      A(13) => complexOut_o1_n_74,
      A(12) => complexOut_o1_n_75,
      A(11) => complexOut_o1_n_76,
      A(10) => complexOut_o1_n_77,
      A(9) => complexOut_o1_n_78,
      A(8) => complexOut_o1_n_79,
      A(7) => complexOut_o1_n_80,
      A(6) => complexOut_o1_n_81,
      A(5) => complexOut_o1_n_82,
      A(4) => complexOut_o1_n_83,
      A(3) => complexOut_o1_n_84,
      A(2) => complexOut_o1_n_85,
      A(1) => complexOut_o1_n_86,
      A(0) => complexOut_o1_n_87,
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29 downto 0) => \NLW_complexOut_o1__0_ACOUT_UNCONNECTED\(29 downto 0),
      ALUMODE(3 downto 0) => B"0000",
      B(17) => complexOut_o1_n_88,
      B(16) => complexOut_o1_n_89,
      B(15) => complexOut_o1_n_90,
      B(14) => complexOut_o1_n_91,
      B(13) => complexOut_o1_n_92,
      B(12) => complexOut_o1_n_93,
      B(11) => complexOut_o1_n_94,
      B(10) => complexOut_o1_n_95,
      B(9) => complexOut_o1_n_96,
      B(8) => complexOut_o1_n_97,
      B(7) => complexOut_o1_n_98,
      B(6) => complexOut_o1_n_99,
      B(5) => complexOut_o1_n_100,
      B(4) => complexOut_o1_n_101,
      B(3) => complexOut_o1_n_102,
      B(2) => complexOut_o1_n_103,
      B(1) => complexOut_o1_n_104,
      B(0) => complexOut_o1_n_105,
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => \NLW_complexOut_o1__0_BCOUT_UNCONNECTED\(17 downto 0),
      C(47) => bc0_n_69,
      C(46) => bc0_n_69,
      C(45) => bc0_n_69,
      C(44) => bc0_n_69,
      C(43) => bc0_n_69,
      C(42) => bc0_n_69,
      C(41) => bc0_n_69,
      C(40) => bc0_n_69,
      C(39) => bc0_n_69,
      C(38) => bc0_n_69,
      C(37) => bc0_n_69,
      C(36) => bc0_n_69,
      C(35) => bc0_n_70,
      C(34) => bc0_n_71,
      C(33) => bc0_n_72,
      C(32) => bc0_n_73,
      C(31) => bc0_n_74,
      C(30) => bc0_n_75,
      C(29) => bc0_n_76,
      C(28) => bc0_n_77,
      C(27) => bc0_n_78,
      C(26) => bc0_n_79,
      C(25) => bc0_n_80,
      C(24) => bc0_n_81,
      C(23) => bc0_n_82,
      C(22) => bc0_n_83,
      C(21) => bc0_n_84,
      C(20) => bc0_n_85,
      C(19) => bc0_n_86,
      C(18) => bc0_n_87,
      C(17) => bc0_n_88,
      C(16) => bc0_n_89,
      C(15) => bc0_n_90,
      C(14) => bc0_n_91,
      C(13) => bc0_n_92,
      C(12) => bc0_n_93,
      C(11) => bc0_n_94,
      C(10) => bc0_n_95,
      C(9) => bc0_n_96,
      C(8) => bc0_n_97,
      C(7) => bc0_n_98,
      C(6) => bc0_n_99,
      C(5) => bc0_n_100,
      C(4) => bc0_n_101,
      C(3) => bc0_n_102,
      C(2) => bc0_n_103,
      C(1) => bc0_n_104,
      C(0) => bc0_n_105,
      CARRYCASCIN => '0',
      CARRYCASCOUT => \NLW_complexOut_o1__0_CARRYCASCOUT_UNCONNECTED\,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => \NLW_complexOut_o1__0_CARRYOUT_UNCONNECTED\(3 downto 0),
      CEA1 => '0',
      CEA2 => '0',
      CEAD => '0',
      CEALUMODE => '0',
      CEB1 => '0',
      CEB2 => '0',
      CEC => '0',
      CECARRYIN => '0',
      CECTRL => '0',
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => D(0),
      CLK => aclk,
      D(26 downto 0) => B"000000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => \NLW_complexOut_o1__0_MULTSIGNOUT_UNCONNECTED\,
      OPMODE(8 downto 6) => B"000",
      OPMODE(5) => OPMODE(0),
      OPMODE(4) => OPMODE(0),
      OPMODE(3 downto 0) => B"0011",
      OVERFLOW => \NLW_complexOut_o1__0_OVERFLOW_UNCONNECTED\,
      P(47 downto 37) => \NLW_complexOut_o1__0_P_UNCONNECTED\(47 downto 37),
      P(36 downto 16) => \^fften_reg\(20 downto 0),
      P(15) => \complexOut_o1__0_n_90\,
      P(14) => \complexOut_o1__0_n_91\,
      P(13) => \complexOut_o1__0_n_92\,
      P(12) => \complexOut_o1__0_n_93\,
      P(11) => \complexOut_o1__0_n_94\,
      P(10) => \complexOut_o1__0_n_95\,
      P(9) => \complexOut_o1__0_n_96\,
      P(8) => \complexOut_o1__0_n_97\,
      P(7) => \complexOut_o1__0_n_98\,
      P(6) => \complexOut_o1__0_n_99\,
      P(5) => \complexOut_o1__0_n_100\,
      P(4) => \complexOut_o1__0_n_101\,
      P(3) => \complexOut_o1__0_n_102\,
      P(2) => \complexOut_o1__0_n_103\,
      P(1) => \complexOut_o1__0_n_104\,
      P(0) => \complexOut_o1__0_n_105\,
      PATTERNBDETECT => \NLW_complexOut_o1__0_PATTERNBDETECT_UNCONNECTED\,
      PATTERNDETECT => \NLW_complexOut_o1__0_PATTERNDETECT_UNCONNECTED\,
      PCIN(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      PCOUT(47 downto 0) => \NLW_complexOut_o1__0_PCOUT_UNCONNECTED\(47 downto 0),
      RSTA => '0',
      RSTALLCARRYIN => '0',
      RSTALUMODE => '0',
      RSTB => '0',
      RSTC => '0',
      RSTCTRL => '0',
      RSTD => '0',
      RSTINMODE => '0',
      RSTM => '0',
      RSTP => '0',
      UNDERFLOW => \NLW_complexOut_o1__0_UNDERFLOW_UNCONNECTED\,
      XOROUT(7 downto 0) => \NLW_complexOut_o1__0_XOROUT_UNCONNECTED\(7 downto 0)
    );
\dataComplexDif_o0_carry__1_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => OPMODE(0),
      I1 => \^fften_reg\(20),
      O => DI(0)
    );
\dataComplexDif_o0_carry__1_i_6__3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"87"
    )
        port map (
      I0 => OPMODE(0),
      I1 => \^fften_reg\(20),
      I2 => \fifoOutComplex__0\(0),
      O => complexOut_o1_i_1(1)
    );
\dataComplexDif_o0_carry__1_i_7__2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"87"
    )
        port map (
      I0 => OPMODE(0),
      I1 => \^fften_reg\(20),
      I2 => fifoOutComplex(0),
      O => complexOut_o1_i_1(0)
    );
\dataComplexSum_o0_carry__1_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => Q(0),
      I1 => fftComplex(0),
      O => \cnt_reg[6]\(0)
    );
\dataReelDif_o0_carry__1_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => \dataReelDif_o0_carry__1\,
      I1 => \^p\(20),
      O => \gRam.mem_reg[31][21]_i_2\(0)
    );
\dataReelDif_o0_carry__1_i_6__3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"87"
    )
        port map (
      I0 => \dataReelDif_o0_carry__1\,
      I1 => \^p\(20),
      I2 => \dataReelDif_o0_carry__1_1\,
      O => S(1)
    );
\dataReelDif_o0_carry__1_i_7__2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"87"
    )
        port map (
      I0 => \dataReelDif_o0_carry__1\,
      I1 => \^p\(20),
      I2 => \dataReelDif_o0_carry__1_0\,
      O => S(0)
    );
\dataReelSum_o0_carry__1_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => Q(0),
      I1 => fftReel(0),
      O => \cnt_reg[6]_0\(0)
    );
reelOut_o1: unisim.vcomponents.DSP48E2
    generic map(
      ACASCREG => 0,
      ADREG => 1,
      ALUMODEREG => 0,
      AMULTSEL => "A",
      AREG => 0,
      AUTORESET_PATDET => "NO_RESET",
      AUTORESET_PRIORITY => "RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 0,
      BMULTSEL => "B",
      BREG => 0,
      B_INPUT => "DIRECT",
      CARRYINREG => 0,
      CARRYINSELREG => 0,
      CREG => 0,
      DREG => 1,
      INMODEREG => 0,
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 0,
      PATTERN => X"000000000000",
      PREADDINSEL => "A",
      PREG => 0,
      RND => X"000000000000",
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_MULT => "NONE",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48",
      USE_WIDEXOR => "FALSE",
      XORSIMD => "XOR24_48_96"
    )
        port map (
      A(29) => ac(36),
      A(28) => ac(36),
      A(27) => ac(36),
      A(26) => ac(36),
      A(25) => ac(36),
      A(24) => ac(36),
      A(23) => ac(36),
      A(22) => ac(36),
      A(21) => ac(36),
      A(20) => ac(36),
      A(19) => ac(36),
      A(18 downto 0) => ac(36 downto 18),
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29 downto 0) => NLW_reelOut_o1_ACOUT_UNCONNECTED(29 downto 0),
      ALUMODE(3 downto 0) => B"0000",
      B(17 downto 0) => ac(17 downto 0),
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => NLW_reelOut_o1_BCOUT_UNCONNECTED(17 downto 0),
      C(47 downto 0) => B"000000000000000000000000000000001000000000000000",
      CARRYCASCIN => '0',
      CARRYCASCOUT => NLW_reelOut_o1_CARRYCASCOUT_UNCONNECTED,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => NLW_reelOut_o1_CARRYOUT_UNCONNECTED(3 downto 0),
      CEA1 => '0',
      CEA2 => '0',
      CEAD => '0',
      CEALUMODE => '0',
      CEB1 => '0',
      CEB2 => '0',
      CEC => '0',
      CECARRYIN => '0',
      CECTRL => '0',
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => '0',
      CLK => '0',
      D(26 downto 0) => B"000000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => NLW_reelOut_o1_MULTSIGNOUT_UNCONNECTED,
      OPMODE(8 downto 0) => B"000110011",
      OVERFLOW => NLW_reelOut_o1_OVERFLOW_UNCONNECTED,
      P(47 downto 0) => NLW_reelOut_o1_P_UNCONNECTED(47 downto 0),
      PATTERNBDETECT => NLW_reelOut_o1_PATTERNBDETECT_UNCONNECTED,
      PATTERNDETECT => NLW_reelOut_o1_PATTERNDETECT_UNCONNECTED,
      PCIN(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      PCOUT(47) => reelOut_o1_n_106,
      PCOUT(46) => reelOut_o1_n_107,
      PCOUT(45) => reelOut_o1_n_108,
      PCOUT(44) => reelOut_o1_n_109,
      PCOUT(43) => reelOut_o1_n_110,
      PCOUT(42) => reelOut_o1_n_111,
      PCOUT(41) => reelOut_o1_n_112,
      PCOUT(40) => reelOut_o1_n_113,
      PCOUT(39) => reelOut_o1_n_114,
      PCOUT(38) => reelOut_o1_n_115,
      PCOUT(37) => reelOut_o1_n_116,
      PCOUT(36) => reelOut_o1_n_117,
      PCOUT(35) => reelOut_o1_n_118,
      PCOUT(34) => reelOut_o1_n_119,
      PCOUT(33) => reelOut_o1_n_120,
      PCOUT(32) => reelOut_o1_n_121,
      PCOUT(31) => reelOut_o1_n_122,
      PCOUT(30) => reelOut_o1_n_123,
      PCOUT(29) => reelOut_o1_n_124,
      PCOUT(28) => reelOut_o1_n_125,
      PCOUT(27) => reelOut_o1_n_126,
      PCOUT(26) => reelOut_o1_n_127,
      PCOUT(25) => reelOut_o1_n_128,
      PCOUT(24) => reelOut_o1_n_129,
      PCOUT(23) => reelOut_o1_n_130,
      PCOUT(22) => reelOut_o1_n_131,
      PCOUT(21) => reelOut_o1_n_132,
      PCOUT(20) => reelOut_o1_n_133,
      PCOUT(19) => reelOut_o1_n_134,
      PCOUT(18) => reelOut_o1_n_135,
      PCOUT(17) => reelOut_o1_n_136,
      PCOUT(16) => reelOut_o1_n_137,
      PCOUT(15) => reelOut_o1_n_138,
      PCOUT(14) => reelOut_o1_n_139,
      PCOUT(13) => reelOut_o1_n_140,
      PCOUT(12) => reelOut_o1_n_141,
      PCOUT(11) => reelOut_o1_n_142,
      PCOUT(10) => reelOut_o1_n_143,
      PCOUT(9) => reelOut_o1_n_144,
      PCOUT(8) => reelOut_o1_n_145,
      PCOUT(7) => reelOut_o1_n_146,
      PCOUT(6) => reelOut_o1_n_147,
      PCOUT(5) => reelOut_o1_n_148,
      PCOUT(4) => reelOut_o1_n_149,
      PCOUT(3) => reelOut_o1_n_150,
      PCOUT(2) => reelOut_o1_n_151,
      PCOUT(1) => reelOut_o1_n_152,
      PCOUT(0) => reelOut_o1_n_153,
      RSTA => '0',
      RSTALLCARRYIN => '0',
      RSTALUMODE => '0',
      RSTB => '0',
      RSTC => '0',
      RSTCTRL => '0',
      RSTD => '0',
      RSTINMODE => '0',
      RSTM => '0',
      RSTP => '0',
      UNDERFLOW => NLW_reelOut_o1_UNDERFLOW_UNCONNECTED,
      XOROUT(7 downto 0) => NLW_reelOut_o1_XOROUT_UNCONNECTED(7 downto 0)
    );
\reelOut_o1__0\: unisim.vcomponents.DSP48E2
    generic map(
      ACASCREG => 0,
      ADREG => 1,
      ALUMODEREG => 0,
      AMULTSEL => "A",
      AREG => 0,
      AUTORESET_PATDET => "NO_RESET",
      AUTORESET_PRIORITY => "RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 0,
      BMULTSEL => "B",
      BREG => 0,
      B_INPUT => "DIRECT",
      CARRYINREG => 0,
      CARRYINSELREG => 0,
      CREG => 1,
      DREG => 1,
      INMODEREG => 0,
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 0,
      PATTERN => X"000000000000",
      PREADDINSEL => "A",
      PREG => 1,
      RND => X"000000000000",
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_MULT => "NONE",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48",
      USE_WIDEXOR => "FALSE",
      XORSIMD => "XOR24_48_96"
    )
        port map (
      A(29) => bd(36),
      A(28) => bd(36),
      A(27) => bd(36),
      A(26) => bd(36),
      A(25) => bd(36),
      A(24) => bd(36),
      A(23) => bd(36),
      A(22) => bd(36),
      A(21) => bd(36),
      A(20) => bd(36),
      A(19) => bd(36),
      A(18 downto 0) => bd(36 downto 18),
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29 downto 0) => \NLW_reelOut_o1__0_ACOUT_UNCONNECTED\(29 downto 0),
      ALUMODE(3 downto 0) => B"0011",
      B(17 downto 0) => bd(17 downto 0),
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => \NLW_reelOut_o1__0_BCOUT_UNCONNECTED\(17 downto 0),
      C(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      CARRYCASCIN => '0',
      CARRYCASCOUT => \NLW_reelOut_o1__0_CARRYCASCOUT_UNCONNECTED\,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => \NLW_reelOut_o1__0_CARRYOUT_UNCONNECTED\(3 downto 0),
      CEA1 => '0',
      CEA2 => '0',
      CEAD => '0',
      CEALUMODE => '0',
      CEB1 => '0',
      CEB2 => '0',
      CEC => '0',
      CECARRYIN => '0',
      CECTRL => '0',
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => D(0),
      CLK => aclk,
      D(26 downto 0) => B"000000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => \NLW_reelOut_o1__0_MULTSIGNOUT_UNCONNECTED\,
      OPMODE(8 downto 0) => B"000010011",
      OVERFLOW => \NLW_reelOut_o1__0_OVERFLOW_UNCONNECTED\,
      P(47 downto 37) => \NLW_reelOut_o1__0_P_UNCONNECTED\(47 downto 37),
      P(36 downto 16) => \^p\(20 downto 0),
      P(15) => \reelOut_o1__0_n_90\,
      P(14) => \reelOut_o1__0_n_91\,
      P(13) => \reelOut_o1__0_n_92\,
      P(12) => \reelOut_o1__0_n_93\,
      P(11) => \reelOut_o1__0_n_94\,
      P(10) => \reelOut_o1__0_n_95\,
      P(9) => \reelOut_o1__0_n_96\,
      P(8) => \reelOut_o1__0_n_97\,
      P(7) => \reelOut_o1__0_n_98\,
      P(6) => \reelOut_o1__0_n_99\,
      P(5) => \reelOut_o1__0_n_100\,
      P(4) => \reelOut_o1__0_n_101\,
      P(3) => \reelOut_o1__0_n_102\,
      P(2) => \reelOut_o1__0_n_103\,
      P(1) => \reelOut_o1__0_n_104\,
      P(0) => \reelOut_o1__0_n_105\,
      PATTERNBDETECT => \NLW_reelOut_o1__0_PATTERNBDETECT_UNCONNECTED\,
      PATTERNDETECT => \NLW_reelOut_o1__0_PATTERNDETECT_UNCONNECTED\,
      PCIN(47) => reelOut_o1_n_106,
      PCIN(46) => reelOut_o1_n_107,
      PCIN(45) => reelOut_o1_n_108,
      PCIN(44) => reelOut_o1_n_109,
      PCIN(43) => reelOut_o1_n_110,
      PCIN(42) => reelOut_o1_n_111,
      PCIN(41) => reelOut_o1_n_112,
      PCIN(40) => reelOut_o1_n_113,
      PCIN(39) => reelOut_o1_n_114,
      PCIN(38) => reelOut_o1_n_115,
      PCIN(37) => reelOut_o1_n_116,
      PCIN(36) => reelOut_o1_n_117,
      PCIN(35) => reelOut_o1_n_118,
      PCIN(34) => reelOut_o1_n_119,
      PCIN(33) => reelOut_o1_n_120,
      PCIN(32) => reelOut_o1_n_121,
      PCIN(31) => reelOut_o1_n_122,
      PCIN(30) => reelOut_o1_n_123,
      PCIN(29) => reelOut_o1_n_124,
      PCIN(28) => reelOut_o1_n_125,
      PCIN(27) => reelOut_o1_n_126,
      PCIN(26) => reelOut_o1_n_127,
      PCIN(25) => reelOut_o1_n_128,
      PCIN(24) => reelOut_o1_n_129,
      PCIN(23) => reelOut_o1_n_130,
      PCIN(22) => reelOut_o1_n_131,
      PCIN(21) => reelOut_o1_n_132,
      PCIN(20) => reelOut_o1_n_133,
      PCIN(19) => reelOut_o1_n_134,
      PCIN(18) => reelOut_o1_n_135,
      PCIN(17) => reelOut_o1_n_136,
      PCIN(16) => reelOut_o1_n_137,
      PCIN(15) => reelOut_o1_n_138,
      PCIN(14) => reelOut_o1_n_139,
      PCIN(13) => reelOut_o1_n_140,
      PCIN(12) => reelOut_o1_n_141,
      PCIN(11) => reelOut_o1_n_142,
      PCIN(10) => reelOut_o1_n_143,
      PCIN(9) => reelOut_o1_n_144,
      PCIN(8) => reelOut_o1_n_145,
      PCIN(7) => reelOut_o1_n_146,
      PCIN(6) => reelOut_o1_n_147,
      PCIN(5) => reelOut_o1_n_148,
      PCIN(4) => reelOut_o1_n_149,
      PCIN(3) => reelOut_o1_n_150,
      PCIN(2) => reelOut_o1_n_151,
      PCIN(1) => reelOut_o1_n_152,
      PCIN(0) => reelOut_o1_n_153,
      PCOUT(47 downto 0) => \NLW_reelOut_o1__0_PCOUT_UNCONNECTED\(47 downto 0),
      RSTA => '0',
      RSTALLCARRYIN => '0',
      RSTALUMODE => '0',
      RSTB => '0',
      RSTC => '0',
      RSTCTRL => '0',
      RSTD => '0',
      RSTINMODE => '0',
      RSTM => '0',
      RSTP => '0',
      UNDERFLOW => \NLW_reelOut_o1__0_UNDERFLOW_UNCONNECTED\,
      XOROUT(7 downto 0) => \NLW_reelOut_o1__0_XOROUT_UNCONNECTED\(7 downto 0)
    );
\reelOut_o1__0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => bd0_n_88,
      I1 => reelOut_o1_0,
      O => bd(17)
    );
\reelOut_o1__0_i_10\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => bd0_n_97,
      I1 => reelOut_o1_0,
      O => bd(8)
    );
\reelOut_o1__0_i_11\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => bd0_n_98,
      I1 => reelOut_o1_0,
      O => bd(7)
    );
\reelOut_o1__0_i_12\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => bd0_n_99,
      I1 => reelOut_o1_0,
      O => bd(6)
    );
\reelOut_o1__0_i_13\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => bd0_n_100,
      I1 => reelOut_o1_0,
      O => bd(5)
