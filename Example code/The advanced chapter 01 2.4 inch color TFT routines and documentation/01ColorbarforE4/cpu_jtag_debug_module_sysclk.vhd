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

entity cpu_jtag_debug_module_sysclk is 
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
end entity cpu_jtag_debug_module_sysclk;


architecture europa of cpu_jtag_debug_module_sysclk is
  component altera_std_synchronizer is
GENERIC (
      depth : NATURAL
      );
    PORT (
    signal dout : OUT STD_LOGIC;
        signal clk : IN STD_LOGIC;
        signal reset_n : IN STD_LOGIC;
        signal din : IN STD_LOGIC
      );
  end component altera_std_synchronizer;
                signal enable_action_strobe :  STD_LOGIC;
                signal internal_jdo1 :  STD_LOGIC_VECTOR (37 DOWNTO 0);
                signal ir :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal jxuir :  STD_LOGIC;
                signal sync2_udr :  STD_LOGIC;
                signal sync2_uir :  STD_LOGIC;
                signal sync_udr :  STD_LOGIC;
                signal sync_uir :  STD_LOGIC;
                signal unxunused_resetxx2 :  STD_LOGIC;
                signal unxunused_resetxx3 :  STD_LOGIC;
                signal update_jdo_strobe :  STD_LOGIC;
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of jdo : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";
attribute ALTERA_ATTRIBUTE of sync2_udr : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,D103""";
attribute ALTERA_ATTRIBUTE of sync2_uir : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,D103""";

begin

  unxunused_resetxx2 <= std_logic'('1');
  the_altera_std_synchronizer2 : altera_std_synchronizer
    generic map(
      depth => 2
    )
    port map(
            clk => clk,
            din => vs_udr,
            dout => sync_udr,
            reset_n => unxunused_resetxx2
    );

  unxunused_resetxx3 <= std_logic'('1');
  the_altera_std_synchronizer3 : altera_std_synchronizer
    generic map(
      depth => 2
    )
    port map(
            clk => clk,
            din => vs_uir,
            dout => sync_uir,
            reset_n => unxunused_resetxx3
    );

  process (clk)
  begin
    if clk'event and clk = '1' then
      sync2_udr <= sync_udr;
      update_jdo_strobe <= sync_udr AND NOT sync2_udr;
      enable_action_strobe <= update_jdo_strobe;
      sync2_uir <= sync_uir;
      jxuir <= sync_uir AND NOT sync2_uir;
    end if;

  end process;

  take_action_ocimem_a <= ((enable_action_strobe AND to_std_logic(((ir = std_logic_vector'("00"))))) AND NOT internal_jdo1(35)) AND internal_jdo1(34);
  take_no_action_ocimem_a <= ((enable_action_strobe AND to_std_logic(((ir = std_logic_vector'("00"))))) AND NOT internal_jdo1(35)) AND NOT internal_jdo1(34);
  take_action_ocimem_b <= (enable_action_strobe AND to_std_logic(((ir = std_logic_vector'("00"))))) AND internal_jdo1(35);
  take_action_tracemem_a <= ((enable_action_strobe AND to_std_logic(((ir = std_logic_vector'("01"))))) AND NOT internal_jdo1(37)) AND internal_jdo1(36);
  take_no_action_tracemem_a <= ((enable_action_strobe AND to_std_logic(((ir = std_logic_vector'("01"))))) AND NOT internal_jdo1(37)) AND NOT internal_jdo1(36);
  take_action_tracemem_b <= (enable_action_strobe AND to_std_logic(((ir = std_logic_vector'("01"))))) AND internal_jdo1(37);
  take_action_break_a <= ((enable_action_strobe AND to_std_logic(((ir = std_logic_vector'("10"))))) AND NOT internal_jdo1(36)) AND internal_jdo1(37);
  take_no_action_break_a <= ((enable_action_strobe AND to_std_logic(((ir = std_logic_vector'("10"))))) AND NOT internal_jdo1(36)) AND NOT internal_jdo1(37);
  take_action_break_b <= (((enable_action_strobe AND to_std_logic(((ir = std_logic_vector'("10"))))) AND internal_jdo1(36)) AND NOT internal_jdo1(35)) AND internal_jdo1(37);
  take_no_action_break_b <= (((enable_action_strobe AND to_std_logic(((ir = std_logic_vector'("10"))))) AND internal_jdo1(36)) AND NOT internal_jdo1(35)) AND NOT internal_jdo1(37);
  take_action_break_c <= (((enable_action_strobe AND to_std_logic(((ir = std_logic_vector'("10"))))) AND internal_jdo1(36)) AND internal_jdo1(35)) AND internal_jdo1(37);
  take_no_action_break_c <= (((enable_action_strobe AND to_std_logic(((ir = std_logic_vector'("10"))))) AND internal_jdo1(36)) AND internal_jdo1(35)) AND NOT internal_jdo1(37);
  take_action_tracectrl <= (enable_action_strobe AND to_std_logic(((ir = std_logic_vector'("11"))))) AND internal_jdo1(15);
  process (clk)
  begin
    if clk'event and clk = '1' then
      if std_logic'(jxuir) = '1' then 
        ir <= ir_in;
      end if;
      if std_logic'(update_jdo_strobe) = '1' then 
        internal_jdo1 <= sr;
      end if;
    end if;

  end process;

  --vhdl renameroo for output signals
  jdo <= internal_jdo1;

end europa;

