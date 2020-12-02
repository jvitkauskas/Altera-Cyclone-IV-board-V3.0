--Legal Notice: (C)2015 Altera Corporation. All rights reserved.  Your
--use of Altera Corporation's design tools, logic functions and other
--software and tools, and its AMPP partner logic functions, and any
--output files any of the foregoing (including device programming or
--simulation files), and any associated documentation or information are
--expressly subject to the terms and conditions of the Altera Program
--License Subscription Agreement or other applicable license agreement,
--including, without limitation, that your use is for the sole purpose
--of programming logic devices manufactured by Altera and sold by Altera
--or its authorized distributors.  Please refer to the applicable
--agreement for further details.


-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity cpu_jtag_debug_module_wrapper is 
        port (
              -- inputs:
                 signal MonDReg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal break_readreg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal dbrk_hit0_latch : IN STD_LOGIC;
                 signal dbrk_hit1_latch : IN STD_LOGIC;
                 signal dbrk_hit2_latch : IN STD_LOGIC;
                 signal dbrk_hit3_latch : IN STD_LOGIC;
                 signal debugack : IN STD_LOGIC;
                 signal monitor_error : IN STD_LOGIC;
                 signal monitor_ready : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal resetlatch : IN STD_LOGIC;
                 signal tracemem_on : IN STD_LOGIC;
                 signal tracemem_trcdata : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
                 signal tracemem_tw : IN STD_LOGIC;
                 signal trc_im_addr : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
                 signal trc_on : IN STD_LOGIC;
                 signal trc_wrap : IN STD_LOGIC;
                 signal trigbrktype : IN STD_LOGIC;
                 signal trigger_state_1 : IN STD_LOGIC;

              -- outputs:
                 signal jdo : OUT STD_LOGIC_VECTOR (37 DOWNTO 0);
                 signal jrst_n : OUT STD_LOGIC;
                 signal st_ready_test_idle : OUT STD_LOGIC;
                 signal take_action_break_a : OUT STD_LOGIC;
                 signal take_action_break_b : OUT STD_LOGIC;
                 signal take_action_break_c : OUT STD_LOGIC;
                 signal take_action_ocimem_a : OUT STD_LOGIC;
                 signal take_action_ocimem_b : OUT STD_LOGIC;
                 signal take_action_tracectrl : OUT STD_LOGIC;
                 signal take_action_tracemem_a : OUT STD_LOGIC;
                 signal take_action_tracemem_b : OUT STD_LOGIC;
                 signal take_no_action_break_a : OUT STD_LOGIC;
                 signal take_no_action_break_b : OUT STD_LOGIC;
                 signal take_no_action_break_c : OUT STD_LOGIC;
                 signal take_no_action_ocimem_a : OUT STD_LOGIC;
                 signal take_no_action_tracemem_a : OUT STD_LOGIC
              );
end entity cpu_jtag_debug_module_wrapper;


architecture europa of cpu_jtag_debug_module_wrapper is
component cpu_jtag_debug_module_tck is 
           port (
                 -- inputs:
                    signal MonDReg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal break_readreg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal dbrk_hit0_latch : IN STD_LOGIC;
                    signal dbrk_hit1_latch : IN STD_LOGIC;
                    signal dbrk_hit2_latch : IN STD_LOGIC;
                    signal dbrk_hit3_latch : IN STD_LOGIC;
                    signal debugack : IN STD_LOGIC;
                    signal ir_in : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal jtag_state_rti : IN STD_LOGIC;
                    signal monitor_error : IN STD_LOGIC;
                    signal monitor_ready : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal resetlatch : IN STD_LOGIC;
                    signal tck : IN STD_LOGIC;
                    signal tdi : IN STD_LOGIC;
                    signal tracemem_on : IN STD_LOGIC;
                    signal tracemem_trcdata : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
                    signal tracemem_tw : IN STD_LOGIC;
                    signal trc_im_addr : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
                    signal trc_on : IN STD_LOGIC;
                    signal trc_wrap : IN STD_LOGIC;
                    signal trigbrktype : IN STD_LOGIC;
                    signal trigger_state_1 : IN STD_LOGIC;
                    signal vs_cdr : IN STD_LOGIC;
                    signal vs_sdr : IN STD_LOGIC;
                    signal vs_uir : IN STD_LOGIC;

                 -- outputs:
                    signal ir_out : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal jrst_n : OUT STD_LOGIC;
                    signal sr : OUT STD_LOGIC_VECTOR (37 DOWNTO 0);
                    signal st_ready_test_idle : OUT STD_LOGIC;
                    signal tdo : OUT STD_LOGIC
                 );
end component cpu_jtag_debug_module_tck;

component cpu_jtag_debug_module_sysclk is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal ir_in : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal sr : IN STD_LOGIC_VECTOR (37 DOWNTO 0);
                    signal vs_udr : IN STD_LOGIC;
                    signal vs_uir : IN STD_LOGIC;

                 -- outputs:
                    signal jdo : OUT STD_LOGIC_VECTOR (37 DOWNTO 0);
                    signal take_action_break_a : OUT STD_LOGIC;
                    signal take_action_break_b : OUT STD_LOGIC;
                    signal take_action_break_c : OUT STD_LOGIC;
                    signal take_action_ocimem_a : OUT STD_LOGIC;
                    signal take_action_ocimem_b : OUT STD_LOGIC;
                    signal take_action_tracectrl : OUT STD_LOGIC;
                    signal take_action_tracemem_a : OUT STD_LOGIC;
                    signal take_action_tracemem_b : OUT STD_LOGIC;
                    signal take_no_action_break_a : OUT STD_LOGIC;
                    signal take_no_action_break_b : OUT STD_LOGIC;
                    signal take_no_action_break_c : OUT STD_LOGIC;
                    signal take_no_action_ocimem_a : OUT STD_LOGIC;
                    signal take_no_action_tracemem_a : OUT STD_LOGIC
                 );
end component cpu_jtag_debug_module_sysclk;

--synthesis read_comments_as_HDL on
--  component sld_virtual_jtag_basic is
--GENERIC (
--      sld_auto_instance_index : STRING;
--        sld_instance_index : NATURAL;
--        sld_ir_width : NATURAL;
--        sld_mfg_id : NATURAL;
--        sld_sim_action : STRING;
--        sld_sim_n_scan : NATURAL;
--        sld_sim_total_length : NATURAL;
--        sld_type_id : NATURAL;
--        sld_version : NATURAL
--      );
--    PORT (
--    signal virtual_state_udr : OUT STD_LOGIC;
--        signal ir_in : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
--        signal tdi : OUT STD_LOGIC;
--        signal virtual_state_sdr : OUT STD_LOGIC;
--        signal jtag_state_rti : OUT STD_LOGIC;
--        signal tck : OUT STD_LOGIC;
--        signal virtual_state_cdr : OUT STD_LOGIC;
--        signal virtual_state_uir : OUT STD_LOGIC;
--        signal ir_out : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--        signal tdo : IN STD_LOGIC
--      );
--  end component sld_virtual_jtag_basic;
--synthesis read_comments_as_HDL off
                signal internal_jdo :  STD_LOGIC_VECTOR (37 DOWNTO 0);
                signal internal_jrst_n :  STD_LOGIC;
                signal internal_st_ready_test_idle :  STD_LOGIC;
                signal internal_take_action_break_a :  STD_LOGIC;
                signal internal_take_action_break_b :  STD_LOGIC;
                signal internal_take_action_break_c :  STD_LOGIC;
                signal internal_take_action_ocimem_a :  STD_LOGIC;
                signal internal_take_action_ocimem_b :  STD_LOGIC;
                signal internal_take_action_tracectrl :  STD_LOGIC;
                signal internal_take_action_tracemem_a :  STD_LOGIC;
                signal internal_take_action_tracemem_b :  STD_LOGIC;
                signal internal_take_no_action_break_a :  STD_LOGIC;
                signal internal_take_no_action_break_b :  STD_LOGIC;
                signal internal_take_no_action_break_c :  STD_LOGIC;
                signal internal_take_no_action_ocimem_a :  STD_LOGIC;
                signal internal_take_no_action_tracemem_a :  STD_LOGIC;
                signal sr :  STD_LOGIC_VECTOR (37 DOWNTO 0);
                signal vji_cdr :  STD_LOGIC;
                signal vji_ir_in :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal vji_ir_out :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal vji_rti :  STD_LOGIC;
                signal vji_sdr :  STD_LOGIC;
                signal vji_tck :  STD_LOGIC;
                signal vji_tdi :  STD_LOGIC;
                signal vji_tdo :  STD_LOGIC;
                signal vji_udr :  STD_LOGIC;
                signal vji_uir :  STD_LOGIC;

begin

  --Change the sld_virtual_jtag_basic's defparams to
  --switch between a regular Nios II or an internally embedded Nios II.
  --For a regular Nios II, sld_mfg_id = 70, sld_type_id = 34.
  --For an internally embedded Nios II, slf_mfg_id = 110, sld_type_id = 135.
  --the_cpu_jtag_debug_module_tck, which is an e_instance
  the_cpu_jtag_debug_module_tck : cpu_jtag_debug_module_tck
    port map(
      ir_out => vji_ir_out,
      jrst_n => internal_jrst_n,
      sr => sr,
      st_ready_test_idle => internal_st_ready_test_idle,
      tdo => vji_tdo,
      MonDReg => MonDReg,
      break_readreg => break_readreg,
      dbrk_hit0_latch => dbrk_hit0_latch,
      dbrk_hit1_latch => dbrk_hit1_latch,
      dbrk_hit2_latch => dbrk_hit2_latch,
      dbrk_hit3_latch => dbrk_hit3_latch,
      debugack => debugack,
      ir_in => vji_ir_in,
      jtag_state_rti => vji_rti,
      monitor_error => monitor_error,
      monitor_ready => monitor_ready,
      reset_n => reset_n,
      resetlatch => resetlatch,
      tck => vji_tck,
      tdi => vji_tdi,
      tracemem_on => tracemem_on,
      tracemem_trcdata => tracemem_trcdata,
      tracemem_tw => tracemem_tw,
      trc_im_addr => trc_im_addr,
      trc_on => trc_on,
      trc_wrap => trc_wrap,
      trigbrktype => trigbrktype,
      trigger_state_1 => trigger_state_1,
      vs_cdr => vji_cdr,
      vs_sdr => vji_sdr,
      vs_uir => vji_uir
    );


  --the_cpu_jtag_debug_module_sysclk, which is an e_instance
  the_cpu_jtag_debug_module_sysclk : cpu_jtag_debug_module_sysclk
    port map(
      jdo => internal_jdo,
      take_action_break_a => internal_take_action_break_a,
      take_action_break_b => internal_take_action_break_b,
      take_action_break_c => internal_take_action_break_c,
      take_action_ocimem_a => internal_take_action_ocimem_a,
      take_action_ocimem_b => internal_take_action_ocimem_b,
      take_action_tracectrl => internal_take_action_tracectrl,
      take_action_tracemem_a => internal_take_action_tracemem_a,
      take_action_tracemem_b => internal_take_action_tracemem_b,
      take_no_action_break_a => internal_take_no_action_break_a,
      take_no_action_break_b => internal_take_no_action_break_b,
      take_no_action_break_c => internal_take_no_action_break_c,
      take_no_action_ocimem_a => internal_take_no_action_ocimem_a,
      take_no_action_tracemem_a => internal_take_no_action_tracemem_a,
      clk => clk,
      ir_in => vji_ir_in,
      sr => sr,
      vs_udr => vji_udr,
      vs_uir => vji_uir
    );


  --vhdl renameroo for output signals
  jdo <= internal_jdo;
  --vhdl renameroo for output signals
  jrst_n <= internal_jrst_n;
  --vhdl renameroo for output signals
  st_ready_test_idle <= internal_st_ready_test_idle;
  --vhdl renameroo for output signals
  take_action_break_a <= internal_take_action_break_a;
  --vhdl renameroo for output signals
  take_action_break_b <= internal_take_action_break_b;
  --vhdl renameroo for output signals
  take_action_break_c <= internal_take_action_break_c;
  --vhdl renameroo for output signals
  take_action_ocimem_a <= internal_take_action_ocimem_a;
  --vhdl renameroo for output signals
  take_action_ocimem_b <= internal_take_action_ocimem_b;
  --vhdl renameroo for output signals
  take_action_tracectrl <= internal_take_action_tracectrl;
  --vhdl renameroo for output signals
  take_action_tracemem_a <= internal_take_action_tracemem_a;
  --vhdl renameroo for output signals
  take_action_tracemem_b <= internal_take_action_tracemem_b;
  --vhdl renameroo for output signals
  take_no_action_break_a <= internal_take_no_action_break_a;
  --vhdl renameroo for output signals
  take_no_action_break_b <= internal_take_no_action_break_b;
  --vhdl renameroo for output signals
  take_no_action_break_c <= internal_take_no_action_break_c;
  --vhdl renameroo for output signals
  take_no_action_ocimem_a <= internal_take_no_action_ocimem_a;
  --vhdl renameroo for output signals
  take_no_action_tracemem_a <= internal_take_no_action_tracemem_a;
--synthesis translate_off
    vji_tck <= std_logic'('0');
    vji_tdi <= std_logic'('0');
    vji_sdr <= std_logic'('0');
    vji_cdr <= std_logic'('0');
    vji_rti <= std_logic'('0');
    vji_uir <= std_logic'('0');
    vji_udr <= std_logic'('0');
    vji_ir_in <= std_logic_vector'("00");
--synthesis translate_on
--synthesis read_comments_as_HDL on
--    cpu_jtag_debug_module_phy : sld_virtual_jtag_basic
--      generic map(
--        sld_auto_instance_index => "YES",
--        sld_instance_index => 0,
--        sld_ir_width => 2,
--        sld_mfg_id => 70,
--        sld_sim_action => "",
--        sld_sim_n_scan => 0,
--        sld_sim_total_length => 0,
--        sld_type_id => 34,
--        sld_version => 3
--      )
--      port map(
--                ir_in => vji_ir_in,
--                ir_out => vji_ir_out,
--                jtag_state_rti => vji_rti,
--                tck => vji_tck,
--                tdi => vji_tdi,
--                tdo => vji_tdo,
--                virtual_state_cdr => vji_cdr,
--                virtual_state_sdr => vji_sdr,
--                virtual_state_udr => vji_udr,
--                virtual_state_uir => vji_uir
--      );
--
--synthesis read_comments_as_HDL off

end europa;

