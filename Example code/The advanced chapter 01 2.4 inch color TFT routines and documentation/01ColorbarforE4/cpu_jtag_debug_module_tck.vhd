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

entity cpu_jtag_debug_module_tck is 
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
end entity cpu_jtag_debug_module_tck;


architecture europa of cpu_jtag_debug_module_tck is
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
                signal DRsize :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal debugack_sync :  STD_LOGIC;
                signal internal_jrst_n1 :  STD_LOGIC;
                signal internal_sr :  STD_LOGIC_VECTOR (37 DOWNTO 0);
                signal monitor_ready_sync :  STD_LOGIC;
                signal unxcomplemented_resetxx0 :  STD_LOGIC;
                signal unxcomplemented_resetxx1 :  STD_LOGIC;
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of DRSize : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,D103,R101""";
attribute ALTERA_ATTRIBUTE of sr : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,D103,R101""";

begin

  process (tck)
  begin
    if tck'event and tck = '1' then
      if std_logic'(vs_cdr) = '1' then 
        case ir_in is
            when std_logic_vector'("00") => 
                internal_sr(35) <= debugack_sync;
                internal_sr(34) <= monitor_error;
                internal_sr(33) <= resetlatch;
                internal_sr(32 DOWNTO 1) <= MonDReg;
                internal_sr(0) <= monitor_ready_sync;
            -- when std_logic_vector'("00") 
        
            when std_logic_vector'("01") => 
                internal_sr(35 DOWNTO 0) <= tracemem_trcdata;
                internal_sr(37) <= tracemem_tw;
                internal_sr(36) <= tracemem_on;
            -- when std_logic_vector'("01") 
        
            when std_logic_vector'("10") => 
                internal_sr(37) <= trigger_state_1;
                internal_sr(36) <= dbrk_hit3_latch;
                internal_sr(35) <= dbrk_hit2_latch;
                internal_sr(34) <= dbrk_hit1_latch;
                internal_sr(33) <= dbrk_hit0_latch;
                internal_sr(32 DOWNTO 1) <= break_readreg;
                internal_sr(0) <= trigbrktype;
            -- when std_logic_vector'("10") 
        
            when std_logic_vector'("11") => 
                internal_sr(15 DOWNTO 12) <= std_logic_vector'("000") & (A_TOSTDLOGICVECTOR(std_logic'('0')));
                internal_sr(11 DOWNTO 2) <= std_logic_vector'("000") & (trc_im_addr);
                internal_sr(1) <= trc_wrap;
                internal_sr(0) <= trc_on;
            -- when std_logic_vector'("11") 
        
            when others => 
            -- when others 
        
        end case; -- ir_in
      end if;
      if std_logic'(vs_sdr) = '1' then 
        case DRsize is
            when std_logic_vector'("000") => 
                internal_sr <= Std_Logic_Vector'(A_ToStdLogicVector(tdi) & internal_sr(37 DOWNTO 2) & A_ToStdLogicVector(tdi));
            -- when std_logic_vector'("000") 
        
            when std_logic_vector'("001") => 
                internal_sr <= Std_Logic_Vector'(A_ToStdLogicVector(tdi) & internal_sr(37 DOWNTO 9) & A_ToStdLogicVector(tdi) & internal_sr(7 DOWNTO 1));
            -- when std_logic_vector'("001") 
        
            when std_logic_vector'("010") => 
                internal_sr <= Std_Logic_Vector'(A_ToStdLogicVector(tdi) & internal_sr(37 DOWNTO 17) & A_ToStdLogicVector(tdi) & internal_sr(15 DOWNTO 1));
            -- when std_logic_vector'("010") 
        
            when std_logic_vector'("011") => 
                internal_sr <= Std_Logic_Vector'(A_ToStdLogicVector(tdi) & internal_sr(37 DOWNTO 33) & A_ToStdLogicVector(tdi) & internal_sr(31 DOWNTO 1));
            -- when std_logic_vector'("011") 
        
            when std_logic_vector'("100") => 
                internal_sr <= Std_Logic_Vector'(A_ToStdLogicVector(tdi) & A_ToStdLogicVector(internal_sr(37)) & A_ToStdLogicVector(tdi) & internal_sr(35 DOWNTO 1));
            -- when std_logic_vector'("100") 
        
            when std_logic_vector'("101") => 
                internal_sr <= Std_Logic_Vector'(A_ToStdLogicVector(tdi) & internal_sr(37 DOWNTO 1));
            -- when std_logic_vector'("101") 
        
            when others => 
                internal_sr <= Std_Logic_Vector'(A_ToStdLogicVector(tdi) & internal_sr(37 DOWNTO 2) & A_ToStdLogicVector(tdi));
            -- when others 
        
        end case; -- DRsize
      end if;
      if std_logic'(vs_uir) = '1' then 
        case ir_in is
            when std_logic_vector'("00") => 
                DRsize <= std_logic_vector'("100");
            -- when std_logic_vector'("00") 
        
            when std_logic_vector'("01") => 
                DRsize <= std_logic_vector'("101");
            -- when std_logic_vector'("01") 
        
            when std_logic_vector'("10") => 
                DRsize <= std_logic_vector'("101");
            -- when std_logic_vector'("10") 
        
            when std_logic_vector'("11") => 
                DRsize <= std_logic_vector'("010");
            -- when std_logic_vector'("11") 
        
            when others => 
            -- when others 
        
        end case; -- ir_in
      end if;
    end if;

  end process;

  tdo <= internal_sr(0);
  st_ready_test_idle <= jtag_state_rti;
  unxcomplemented_resetxx0 <= internal_jrst_n1;
  the_altera_std_synchronizer : altera_std_synchronizer
    generic map(
      depth => 2
    )
    port map(
            clk => tck,
            din => debugack,
            dout => debugack_sync,
            reset_n => unxcomplemented_resetxx0
    );

  unxcomplemented_resetxx1 <= internal_jrst_n1;
  the_altera_std_synchronizer1 : altera_std_synchronizer
    generic map(
      depth => 2
    )
    port map(
            clk => tck,
            din => monitor_ready,
            dout => monitor_ready_sync,
            reset_n => unxcomplemented_resetxx1
    );

  process (tck, internal_jrst_n1)
  begin
    if internal_jrst_n1 = '0' then
      ir_out <= std_logic_vector'("00");
    elsif tck'event and tck = '1' then
      ir_out <= Std_Logic_Vector'(A_ToStdLogicVector(debugack_sync) & A_ToStdLogicVector(monitor_ready_sync));
    end if;

  end process;

  --vhdl renameroo for output signals
  jrst_n <= internal_jrst_n1;
  --vhdl renameroo for output signals
  sr <= internal_sr;
--synthesis translate_off
    internal_jrst_n1 <= reset_n;
--synthesis translate_on
--synthesis read_comments_as_HDL on
--    internal_jrst_n1 <= std_logic'('1');
--synthesis read_comments_as_HDL off

end europa;

