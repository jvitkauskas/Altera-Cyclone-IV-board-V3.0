--Legal Notice: (C)2007 Altera Corporation. All rights reserved.  Your
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity cpu_jtag_debug_module is 
        generic (
                 SLD_AUTO_INSTANCE_INDEX : STRING := "YES";
                 SLD_NODE_INFO : INTEGER := 286279168
                 );
        port (
              -- inputs:
                 signal MonDReg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal break_readreg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal clrn : IN STD_LOGIC;
                 signal dbrk_hit0_latch : IN STD_LOGIC;
                 signal dbrk_hit1_latch : IN STD_LOGIC;
                 signal dbrk_hit2_latch : IN STD_LOGIC;
                 signal dbrk_hit3_latch : IN STD_LOGIC;
                 signal debugack : IN STD_LOGIC;
                 signal ena : IN STD_LOGIC;
                 signal ir_in : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal jtag_state_sdr : IN STD_LOGIC;
                 signal jtag_state_udr : IN STD_LOGIC;
                 signal monitor_error : IN STD_LOGIC;
                 signal monitor_ready : IN STD_LOGIC;
                 signal raw_tck : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal resetlatch : IN STD_LOGIC;
                 signal rti : IN STD_LOGIC;
                 signal shift : IN STD_LOGIC;
                 signal tdi : IN STD_LOGIC;
                 signal tracemem_on : IN STD_LOGIC;
                 signal tracemem_trcdata : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
                 signal tracemem_tw : IN STD_LOGIC;
                 signal trc_im_addr : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
                 signal trc_on : IN STD_LOGIC;
                 signal trc_wrap : IN STD_LOGIC;
                 signal trigbrktype : IN STD_LOGIC;
                 signal trigger_state_1 : IN STD_LOGIC;
                 signal update : IN STD_LOGIC;
                 signal usr1 : IN STD_LOGIC;

              -- outputs:
                 signal ir_out : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal irq : OUT STD_LOGIC;
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
                 signal take_no_action_tracemem_a : OUT STD_LOGIC;
                 signal tdo : OUT STD_LOGIC
              );
end entity cpu_jtag_debug_module;


architecture europa of cpu_jtag_debug_module is
                signal DRsize :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal dr_update1 :  STD_LOGIC;
                signal dr_update2 :  STD_LOGIC;
                signal in_between_shiftdr_and_updatedr :  STD_LOGIC;
                signal internal_jdo1 :  STD_LOGIC_VECTOR (37 DOWNTO 0);
                signal internal_jrst_n1 :  STD_LOGIC;
                signal ir :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal jxdr :  STD_LOGIC;
                signal sr :  STD_LOGIC_VECTOR (37 DOWNTO 0);
                signal st_shiftdr :  STD_LOGIC;
                signal st_updatedr :  STD_LOGIC;
                signal st_updateir :  STD_LOGIC;
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of DRsize : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,D103,R101""";
attribute ALTERA_ATTRIBUTE of dr_update1 : signal is "SUPPRESS_DA_RULE_INTERNAL=D101";
attribute ALTERA_ATTRIBUTE of in_between_shiftdr_and_updatedr : signal is "SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of ir_out : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,R101""";
attribute ALTERA_ATTRIBUTE of jdo : signal is "SUPPRESS_DA_RULE_INTERNAL=D103";
attribute ALTERA_ATTRIBUTE of sr : signal is "SUPPRESS_DA_RULE_INTERNAL=""D101,D103,R101""";

begin

  process (clk)
  begin
    if clk'event and clk = '1' then
      dr_update1 <= st_updatedr;
      dr_update2 <= dr_update1;
      jxdr <= NOT dr_update1 AND dr_update2;
    end if;

  end process;

  take_action_ocimem_a <= ((jxdr AND to_std_logic(((ir = std_logic_vector'("00"))))) AND NOT internal_jdo1(35)) AND internal_jdo1(34);
  take_no_action_ocimem_a <= ((jxdr AND to_std_logic(((ir = std_logic_vector'("00"))))) AND NOT internal_jdo1(35)) AND NOT internal_jdo1(34);
  take_action_ocimem_b <= (jxdr AND to_std_logic(((ir = std_logic_vector'("00"))))) AND internal_jdo1(35);
  take_action_tracemem_a <= ((jxdr AND to_std_logic(((ir = std_logic_vector'("01"))))) AND NOT internal_jdo1(37)) AND internal_jdo1(36);
  take_no_action_tracemem_a <= ((jxdr AND to_std_logic(((ir = std_logic_vector'("01"))))) AND NOT internal_jdo1(37)) AND NOT internal_jdo1(36);
  take_action_tracemem_b <= (jxdr AND to_std_logic(((ir = std_logic_vector'("01"))))) AND internal_jdo1(37);
  take_action_break_a <= ((jxdr AND to_std_logic(((ir = std_logic_vector'("10"))))) AND NOT internal_jdo1(36)) AND internal_jdo1(37);
  take_no_action_break_a <= ((jxdr AND to_std_logic(((ir = std_logic_vector'("10"))))) AND NOT internal_jdo1(36)) AND NOT internal_jdo1(37);
  take_action_break_b <= (((jxdr AND to_std_logic(((ir = std_logic_vector'("10"))))) AND internal_jdo1(36)) AND NOT internal_jdo1(35)) AND internal_jdo1(37);
  take_no_action_break_b <= (((jxdr AND to_std_logic(((ir = std_logic_vector'("10"))))) AND internal_jdo1(36)) AND NOT internal_jdo1(35)) AND NOT internal_jdo1(37);
  take_action_break_c <= (((jxdr AND to_std_logic(((ir = std_logic_vector'("10"))))) AND internal_jdo1(36)) AND internal_jdo1(35)) AND internal_jdo1(37);
  take_no_action_break_c <= (((jxdr AND to_std_logic(((ir = std_logic_vector'("10"))))) AND internal_jdo1(36)) AND internal_jdo1(35)) AND NOT internal_jdo1(37);
  take_action_tracectrl <= (jxdr AND to_std_logic(((ir = std_logic_vector'("11"))))) AND internal_jdo1(15);
  process (raw_tck, internal_jrst_n1)
  begin
    if internal_jrst_n1 = '0' then
      ir_out <= std_logic_vector'("00");
    elsif raw_tck'event and raw_tck = '1' then
      ir_out <= Std_Logic_Vector'(A_ToStdLogicVector(debugack) & A_ToStdLogicVector(monitor_ready));
    end if;

  end process;

  process (raw_tck, internal_jrst_n1)
  begin
    if internal_jrst_n1 = '0' then
      sr <= std_logic_vector'("00000000000000000000000000000000000000");
      DRsize <= std_logic_vector'("000");
    elsif raw_tck'event and raw_tck = '1' then
      if std_logic'(st_updateir) = '1' then 
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
        ir <= ir_in;
      elsif std_logic'((((NOT shift AND NOT usr1) AND ena) AND NOT in_between_shiftdr_and_updatedr)) = '1' then 
        case ir is
            when std_logic_vector'("00") => 
                sr(35) <= debugack;
                sr(34) <= monitor_error;
                sr(33) <= resetlatch;
                sr(32 DOWNTO 1) <= MonDReg;
                sr(0) <= monitor_ready;
            -- when std_logic_vector'("00") 
        
            when std_logic_vector'("01") => 
                sr(35 DOWNTO 0) <= tracemem_trcdata;
                sr(37) <= tracemem_tw;
                sr(36) <= tracemem_on;
            -- when std_logic_vector'("01") 
        
            when std_logic_vector'("10") => 
                sr(37) <= trigger_state_1;
                sr(36) <= dbrk_hit3_latch;
                sr(35) <= dbrk_hit2_latch;
                sr(34) <= dbrk_hit1_latch;
                sr(33) <= dbrk_hit0_latch;
                sr(32 DOWNTO 1) <= break_readreg;
                sr(0) <= trigbrktype;
            -- when std_logic_vector'("10") 
        
            when std_logic_vector'("11") => 
                sr(15 DOWNTO 12) <= std_logic_vector'("000") & (A_TOSTDLOGICVECTOR(std_logic'('0')));
                sr(11 DOWNTO 2) <= std_logic_vector'("000") & (trc_im_addr);
                sr(1) <= trc_wrap;
                sr(0) <= trc_on;
            -- when std_logic_vector'("11") 
        
            when others => 
            -- when others 
        
        end case; -- ir
      elsif std_logic'(((shift AND NOT usr1) AND ena)) = '1' then 
        case DRsize is
            when std_logic_vector'("000") => 
                sr <= Std_Logic_Vector'(A_ToStdLogicVector(tdi) & sr(37 DOWNTO 2) & A_ToStdLogicVector(tdi));
            -- when std_logic_vector'("000") 
        
            when std_logic_vector'("001") => 
                sr <= Std_Logic_Vector'(A_ToStdLogicVector(tdi) & sr(37 DOWNTO 9) & A_ToStdLogicVector(tdi) & sr(7 DOWNTO 1));
            -- when std_logic_vector'("001") 
        
            when std_logic_vector'("010") => 
                sr <= Std_Logic_Vector'(A_ToStdLogicVector(tdi) & sr(37 DOWNTO 17) & A_ToStdLogicVector(tdi) & sr(15 DOWNTO 1));
            -- when std_logic_vector'("010") 
        
            when std_logic_vector'("011") => 
                sr <= Std_Logic_Vector'(A_ToStdLogicVector(tdi) & sr(37 DOWNTO 33) & A_ToStdLogicVector(tdi) & sr(31 DOWNTO 1));
            -- when std_logic_vector'("011") 
        
            when std_logic_vector'("100") => 
                sr <= Std_Logic_Vector'(A_ToStdLogicVector(tdi) & A_ToStdLogicVector(sr(37)) & A_ToStdLogicVector(tdi) & sr(35 DOWNTO 1));
            -- when std_logic_vector'("100") 
        
            when std_logic_vector'("101") => 
                sr <= Std_Logic_Vector'(A_ToStdLogicVector(tdi) & sr(37 DOWNTO 1));
            -- when std_logic_vector'("101") 
        
            when others => 
                sr <= Std_Logic_Vector'(A_ToStdLogicVector(tdi) & sr(37 DOWNTO 2) & A_ToStdLogicVector(tdi));
            -- when others 
        
        end case; -- DRsize
      end if;
    end if;

  end process;

  tdo <= sr(0);
  st_ready_test_idle <= rti;
  process (raw_tck)
  begin
    if raw_tck'event and raw_tck = '1' then
      if std_logic'(st_updatedr) = '1' then 
        internal_jdo1 <= sr;
      end if;
    end if;

  end process;

  process (raw_tck)
  begin
    if raw_tck'event and raw_tck = '1' then
      st_updatedr <= (NOT usr1 AND ena) AND jtag_state_udr;
      st_updateir <= (usr1 AND ena) AND jtag_state_udr;
      st_shiftdr <= (NOT usr1 AND ena) AND jtag_state_sdr;
    end if;

  end process;

  process (raw_tck, internal_jrst_n1)
  begin
    if internal_jrst_n1 = '0' then
      in_between_shiftdr_and_updatedr <= std_logic'('0');
    elsif raw_tck'event and raw_tck = '1' then
      if std_logic'(st_shiftdr) = '1' then 
        in_between_shiftdr_and_updatedr <= std_logic'('1');
      elsif std_logic'(st_updatedr) = '1' then 
        in_between_shiftdr_and_updatedr <= std_logic'('0');
      end if;
    end if;

  end process;

  --vhdl renameroo for output signals
  jdo <= internal_jdo1;
  --vhdl renameroo for output signals
  jrst_n <= internal_jrst_n1;
--synthesis translate_off
    internal_jrst_n1 <= reset_n;
--synthesis translate_on
--synthesis read_comments_as_HDL on
--    internal_jrst_n1 <= clrn;
--synthesis read_comments_as_HDL off

end europa;

