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

entity sdram_input_efifo_module is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal rd : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal wr : IN STD_LOGIC;
                 signal wr_data : IN STD_LOGIC_VECTOR (40 DOWNTO 0);

              -- outputs:
                 signal almost_empty : OUT STD_LOGIC;
                 signal almost_full : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC;
                 signal rd_data : OUT STD_LOGIC_VECTOR (40 DOWNTO 0)
              );
end entity sdram_input_efifo_module;


architecture europa of sdram_input_efifo_module is
                signal entries :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal entry_0 :  STD_LOGIC_VECTOR (40 DOWNTO 0);
                signal entry_1 :  STD_LOGIC_VECTOR (40 DOWNTO 0);
                signal internal_empty :  STD_LOGIC;
                signal internal_full :  STD_LOGIC;
                signal rd_address :  STD_LOGIC;
                signal rdwr :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal wr_address :  STD_LOGIC;

begin

  rdwr <= Std_Logic_Vector'(A_ToStdLogicVector(rd) & A_ToStdLogicVector(wr));
  internal_full <= to_std_logic(((std_logic_vector'("000000000000000000000000000000") & (entries)) = std_logic_vector'("00000000000000000000000000000010")));
  almost_full <= to_std_logic(((std_logic_vector'("000000000000000000000000000000") & (entries))>=std_logic_vector'("00000000000000000000000000000001")));
  internal_empty <= to_std_logic(((std_logic_vector'("000000000000000000000000000000") & (entries)) = std_logic_vector'("00000000000000000000000000000000")));
  almost_empty <= to_std_logic(((std_logic_vector'("000000000000000000000000000000") & (entries))<=std_logic_vector'("00000000000000000000000000000001")));
  process (entry_0, entry_1, rd_address)
  begin
      case rd_address is -- synthesis parallel_case full_case
          when std_logic'('0') => 
              rd_data <= entry_0;
          -- when std_logic'('0') 
      
          when std_logic'('1') => 
              rd_data <= entry_1;
          -- when std_logic'('1') 
      
          when others => 
          -- when others 
      
      end case; -- rd_address

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      wr_address <= std_logic'('0');
      rd_address <= std_logic'('0');
      entries <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      case rdwr is -- synthesis parallel_case full_case
          when std_logic_vector'("01") => 
              -- Write data
              if std_logic'(NOT(internal_full)) = '1' then 
                entries <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (entries)) + std_logic_vector'("000000000000000000000000000000001")), 2);
                wr_address <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(wr_address))) = std_logic_vector'("00000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(wr_address))) + std_logic_vector'("000000000000000000000000000000001")))));
              end if;
          -- when std_logic_vector'("01") 
      
          when std_logic_vector'("10") => 
              -- Read data
              if std_logic'(NOT(internal_empty)) = '1' then 
                entries <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (entries)) - std_logic_vector'("000000000000000000000000000000001")), 2);
                rd_address <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(rd_address))) = std_logic_vector'("00000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(rd_address))) + std_logic_vector'("000000000000000000000000000000001")))));
              end if;
          -- when std_logic_vector'("10") 
      
          when std_logic_vector'("11") => 
              wr_address <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(wr_address))) = std_logic_vector'("00000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(wr_address))) + std_logic_vector'("000000000000000000000000000000001")))));
              rd_address <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(rd_address))) = std_logic_vector'("00000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(rd_address))) + std_logic_vector'("000000000000000000000000000000001")))));
          -- when std_logic_vector'("11") 
      
          when others => 
          -- when others 
      
      end case; -- rdwr
    end if;

  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      --Write data
      if std_logic'((wr AND NOT(internal_full))) = '1' then 
        case wr_address is -- synthesis parallel_case full_case
            when std_logic'('0') => 
                entry_0 <= wr_data;
            -- when std_logic'('0') 
        
            when std_logic'('1') => 
                entry_1 <= wr_data;
            -- when std_logic'('1') 
        
            when others => 
            -- when others 
        
        end case; -- wr_address
      end if;
    end if;

  end process;

  --vhdl renameroo for output signals
  empty <= internal_empty;
  --vhdl renameroo for output signals
  full <= internal_full;

end europa;



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

entity sdram is 
        port (
              -- inputs:
                 signal az_addr : IN STD_LOGIC_VECTOR (21 DOWNTO 0);
                 signal az_be_n : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal az_cs : IN STD_LOGIC;
                 signal az_data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal az_rd_n : IN STD_LOGIC;
                 signal az_wr_n : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal za_data : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal za_valid : OUT STD_LOGIC;
                 signal za_waitrequest : OUT STD_LOGIC;
                 signal zs_addr : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
                 signal zs_ba : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal zs_cas_n : OUT STD_LOGIC;
                 signal zs_cke : OUT STD_LOGIC;
                 signal zs_cs_n : OUT STD_LOGIC;
                 signal zs_dq : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal zs_dqm : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal zs_ras_n : OUT STD_LOGIC;
                 signal zs_we_n : OUT STD_LOGIC
              );
end entity sdram;


architecture europa of sdram is
component sdram_input_efifo_module is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal rd : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal wr : IN STD_LOGIC;
                    signal wr_data : IN STD_LOGIC_VECTOR (40 DOWNTO 0);

                 -- outputs:
                    signal almost_empty : OUT STD_LOGIC;
                    signal almost_full : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC;
                    signal rd_data : OUT STD_LOGIC_VECTOR (40 DOWNTO 0)
                 );
end component sdram_input_efifo_module;

                signal CODE :  STD_LOGIC_VECTOR (23 DOWNTO 0);
                signal ack_refresh_request :  STD_LOGIC;
                signal active_addr :  STD_LOGIC_VECTOR (21 DOWNTO 0);
                signal active_bank :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal active_cs_n :  STD_LOGIC;
                signal active_data :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal active_dqm :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal active_rnw :  STD_LOGIC;
                signal almost_empty :  STD_LOGIC;
                signal almost_full :  STD_LOGIC;
                signal bank_match :  STD_LOGIC;
                signal cas_addr :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal clk_en :  STD_LOGIC;
                signal cmd_all :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cmd_code :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal cs_n :  STD_LOGIC;
                signal csn_decode :  STD_LOGIC;
                signal csn_match :  STD_LOGIC;
                signal f_addr :  STD_LOGIC_VECTOR (21 DOWNTO 0);
                signal f_bank :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal f_cs_n :  STD_LOGIC;
                signal f_data :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal f_dqm :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal f_empty :  STD_LOGIC;
                signal f_pop :  STD_LOGIC;
                signal f_rnw :  STD_LOGIC;
                signal f_select :  STD_LOGIC;
                signal fifo_read_data :  STD_LOGIC_VECTOR (40 DOWNTO 0);
                signal i_addr :  STD_LOGIC_VECTOR (11 DOWNTO 0);
                signal i_cmd :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal i_count :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal i_next :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal i_refs :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal i_state :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal init_done :  STD_LOGIC;
                signal internal_za_waitrequest :  STD_LOGIC;
                signal m_addr :  STD_LOGIC_VECTOR (11 DOWNTO 0);
                signal m_bank :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal m_cmd :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal m_count :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal m_data :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal m_dqm :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal m_next :  STD_LOGIC_VECTOR (8 DOWNTO 0);
                signal m_state :  STD_LOGIC_VECTOR (8 DOWNTO 0);
                signal module_input :  STD_LOGIC;
                signal module_input1 :  STD_LOGIC_VECTOR (40 DOWNTO 0);
                signal oe :  STD_LOGIC;
                signal pending :  STD_LOGIC;
                signal rd_strobe :  STD_LOGIC;
                signal rd_valid :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal refresh_counter :  STD_LOGIC_VECTOR (12 DOWNTO 0);
                signal refresh_request :  STD_LOGIC;
                signal rnw_match :  STD_LOGIC;
                signal row_match :  STD_LOGIC;
                signal txt_code :  STD_LOGIC_VECTOR (23 DOWNTO 0);
                signal za_cannotrefresh :  STD_LOGIC;
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of m_addr : signal is "FAST_OUTPUT_REGISTER=ON";
attribute ALTERA_ATTRIBUTE of m_bank : signal is "FAST_OUTPUT_REGISTER=ON";
attribute ALTERA_ATTRIBUTE of m_cmd : signal is "FAST_OUTPUT_REGISTER=ON";
attribute ALTERA_ATTRIBUTE of m_data : signal is "FAST_OUTPUT_REGISTER=ON";
attribute ALTERA_ATTRIBUTE of m_dqm : signal is "FAST_OUTPUT_REGISTER=ON";
attribute ALTERA_ATTRIBUTE of za_data : signal is "FAST_INPUT_REGISTER=ON";

begin

  clk_en <= std_logic'('1');
  --s1, which is an e_avalon_slave
  (zs_cs_n, zs_ras_n, zs_cas_n, zs_we_n) <= m_cmd;
  zs_addr <= m_addr;
  zs_cke <= clk_en;
  zs_dq <= A_WE_StdLogicVector((std_logic'(oe) = '1'), m_data, A_REP(std_logic'('Z'), 16));
  zs_dqm <= m_dqm;
  zs_ba <= m_bank;
  f_select <= f_pop AND pending;
  f_cs_n <= std_logic'('0');
  cs_n <= A_WE_StdLogic((std_logic'(f_select) = '1'), f_cs_n, active_cs_n);
  csn_decode <= cs_n;
  (f_rnw, f_addr(21), f_addr(20), f_addr(19), f_addr(18), f_addr(17), f_addr(16), f_addr(15), f_addr(14), f_addr(13), f_addr(12), f_addr(11), f_addr(10), f_addr(9), f_addr(8), f_addr(7), f_addr(6), f_addr(5), f_addr(4), f_addr(3), f_addr(2), f_addr(1), f_addr(0), f_dqm(1), f_dqm(0), f_data(15), f_data(14), f_data(13), f_data(12), f_data(11), f_data(10), f_data(9), f_data(8), f_data(7), f_data(6), f_data(5), f_data(4), f_data(3), f_data(2), f_data(1), f_data(0)) <= fifo_read_data;
  --the_sdram_input_efifo_module, which is an e_instance
  the_sdram_input_efifo_module : sdram_input_efifo_module
    port map(
      almost_empty => almost_empty,
      almost_full => almost_full,
      empty => f_empty,
      full => internal_za_waitrequest,
      rd_data => fifo_read_data,
      clk => clk,
      rd => f_select,
      reset_n => reset_n,
      wr => module_input,
      wr_data => module_input1
    );

  module_input <= ((NOT az_wr_n OR NOT az_rd_n)) AND NOT(internal_za_waitrequest);
  module_input1 <= Std_Logic_Vector'(A_ToStdLogicVector(az_wr_n) & az_addr & A_WE_StdLogicVector((std_logic'(az_wr_n) = '1'), std_logic_vector'("00"), az_be_n) & az_data);

  f_bank <= Std_Logic_Vector'(A_ToStdLogicVector(f_addr(21)) & A_ToStdLogicVector(f_addr(8)));
  -- Refresh/init counter.
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      refresh_counter <= std_logic_vector'("1001110001000");
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("0000000000000000000") & (refresh_counter)) = std_logic_vector'("00000000000000000000000000000000") then 
        refresh_counter <= std_logic_vector'("0001100001101");
      else
        refresh_counter <= A_EXT (((std_logic_vector'("0") & (refresh_counter)) - (std_logic_vector'("0000000000000") & (A_TOSTDLOGICVECTOR(std_logic'('1'))))), 13);
      end if;
    end if;

  end process;

  -- Refresh request signal.
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      refresh_request <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if true then 
        refresh_request <= (((to_std_logic((((std_logic_vector'("0000000000000000000") & (refresh_counter)) = std_logic_vector'("00000000000000000000000000000000")))) OR refresh_request)) AND NOT ack_refresh_request) AND init_done;
      end if;
    end if;

  end process;

  -- Generate an Interrupt if two ref_reqs occur before one ack_refresh_request
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      za_cannotrefresh <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if true then 
        za_cannotrefresh <= to_std_logic((((std_logic_vector'("0000000000000000000") & (refresh_counter)) = std_logic_vector'("00000000000000000000000000000000")))) AND refresh_request;
      end if;
    end if;

  end process;

  -- Initialization-done flag.
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      init_done <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if true then 
        init_done <= init_done OR to_std_logic(((i_state = std_logic_vector'("101"))));
      end if;
    end if;

  end process;

  -- **** Init FSM ****
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      i_state <= std_logic_vector'("000");
      i_next <= std_logic_vector'("000");
      i_cmd <= std_logic_vector'("1111");
      i_addr <= A_REP(std_logic'('1'), 12);
      i_count <= A_REP(std_logic'('0'), 3);
    elsif clk'event and clk = '1' then
      i_addr <= A_REP(std_logic'('1'), 12);
      case i_state is -- synthesis parallel_case full_case
          when std_logic_vector'("000") => 
              i_cmd <= std_logic_vector'("1111");
              i_refs <= std_logic_vector'("000");
              --Wait for refresh count-down after reset
              if (std_logic_vector'("0000000000000000000") & (refresh_counter)) = std_logic_vector'("00000000000000000000000000000000") then 
                i_state <= std_logic_vector'("001");
              end if;
          -- when std_logic_vector'("000") 
      
          when std_logic_vector'("001") => 
              i_state <= std_logic_vector'("011");
              i_cmd <= Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & std_logic_vector'("010"));
              i_count <= std_logic_vector'("000");
              i_next <= std_logic_vector'("010");
          -- when std_logic_vector'("001") 
      
          when std_logic_vector'("010") => 
              i_cmd <= Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & std_logic_vector'("001"));
              i_refs <= A_EXT (((std_logic_vector'("0") & (i_refs)) + (std_logic_vector'("000") & (A_TOSTDLOGICVECTOR(std_logic'('1'))))), 3);
              i_state <= std_logic_vector'("011");
              i_count <= std_logic_vector'("011");
              -- Count up init_refresh_commands
              if i_refs = std_logic_vector'("001") then 
                i_next <= std_logic_vector'("111");
              else
                i_next <= std_logic_vector'("010");
              end if;
          -- when std_logic_vector'("010") 
      
          when std_logic_vector'("011") => 
              i_cmd <= Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & std_logic_vector'("111"));
              --WAIT til safe to Proceed...
              if (std_logic_vector'("00000000000000000000000000000") & (i_count))>std_logic_vector'("00000000000000000000000000000001") then 
                i_count <= A_EXT (((std_logic_vector'("0") & (i_count)) - (std_logic_vector'("000") & (A_TOSTDLOGICVECTOR(std_logic'('1'))))), 3);
              else
                i_state <= i_next;
              end if;
          -- when std_logic_vector'("011") 
      
          when std_logic_vector'("101") => 
              i_state <= std_logic_vector'("101");
          -- when std_logic_vector'("101") 
      
          when std_logic_vector'("111") => 
              i_state <= std_logic_vector'("011");
              i_cmd <= Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & std_logic_vector'("000"));
              i_addr <= A_REP(std_logic'('0'), 2) & A_ToStdLogicVector(std_logic'('0')) & std_logic_vector'("00") & std_logic_vector'("010") & std_logic_vector'("0000");
              i_count <= std_logic_vector'("100");
              i_next <= std_logic_vector'("101");
          -- when std_logic_vector'("111") 
      
          when others => 
              i_state <= std_logic_vector'("000");
          -- when others 
      
      end case; -- i_state
    end if;

  end process;

  active_bank <= Std_Logic_Vector'(A_ToStdLogicVector(active_addr(21)) & A_ToStdLogicVector(active_addr(8)));
  csn_match <= to_std_logic((std_logic'(active_cs_n) = std_logic'(f_cs_n)));
  rnw_match <= to_std_logic((std_logic'(active_rnw) = std_logic'(f_rnw)));
  bank_match <= to_std_logic((active_bank = f_bank));
  row_match <= to_std_logic((active_addr(20 DOWNTO 9) = f_addr(20 DOWNTO 9)));
  pending <= (((csn_match AND rnw_match) AND bank_match) AND row_match) AND NOT(f_empty);
  cas_addr <= A_EXT (A_WE_StdLogicVector((std_logic'(f_select) = '1'), (A_REP(std_logic'('0'), 4) & f_addr(7 DOWNTO 0)), (A_REP(std_logic'('0'), 4) & active_addr(7 DOWNTO 0))), 8);
  -- **** Main FSM ****
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      m_state <= std_logic_vector'("000000001");
      m_next <= std_logic_vector'("000000001");
      m_cmd <= std_logic_vector'("1111");
      m_bank <= std_logic_vector'("00");
      m_addr <= std_logic_vector'("000000000000");
      m_data <= std_logic_vector'("0000000000000000");
      m_dqm <= std_logic_vector'("00");
      m_count <= std_logic_vector'("000");
      ack_refresh_request <= std_logic'('0');
      f_pop <= std_logic'('0');
      oe <= std_logic'('0');
    elsif clk'event and clk = '1' then
      f_pop <= std_logic'('0');
      oe <= std_logic'('0');
      case m_state is -- synthesis parallel_case full_case
          when std_logic_vector'("000000001") => 
              --Wait for init-fsm to be done...
              if std_logic'(init_done) = '1' then 
                --Hold bus if another cycle ended to arf.
                if std_logic'(refresh_request) = '1' then 
                  m_cmd <= Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & std_logic_vector'("111"));
                else
                  m_cmd <= std_logic_vector'("1111");
                end if;
                ack_refresh_request <= std_logic'('0');
                --Wait for a read/write request.
                if std_logic'(refresh_request) = '1' then 
                  m_state <= std_logic_vector'("001000000");
                  m_next <= std_logic_vector'("010000000");
                  m_count <= std_logic_vector'("000");
                  active_cs_n <= std_logic'('1');
                elsif std_logic'(NOT(f_empty)) = '1' then 
                  f_pop <= std_logic'('1');
                  active_cs_n <= f_cs_n;
                  active_rnw <= f_rnw;
                  active_addr <= f_addr;
                  active_data <= f_data;
                  active_dqm <= f_dqm;
                  m_state <= std_logic_vector'("000000010");
                end if;
              else
                m_addr <= i_addr;
                m_state <= std_logic_vector'("000000001");
                m_next <= std_logic_vector'("000000001");
                m_cmd <= i_cmd;
              end if;
          -- when std_logic_vector'("000000001") 
      
          when std_logic_vector'("000000010") => 
              m_state <= std_logic_vector'("000000100");
              m_cmd <= Std_Logic_Vector'(A_ToStdLogicVector(csn_decode) & std_logic_vector'("011"));
              m_bank <= active_bank;
              m_addr <= active_addr(20 DOWNTO 9);
              m_data <= active_data;
              m_dqm <= active_dqm;
              m_count <= std_logic_vector'("001");
              m_next <= A_WE_StdLogicVector((std_logic'(active_rnw) = '1'), std_logic_vector'("000001000"), std_logic_vector'("000010000"));
          -- when std_logic_vector'("000000010") 
      
          when std_logic_vector'("000000100") => 
              -- precharge all if arf, else precharge csn_decode
              if m_next = std_logic_vector'("010000000") then 
                m_cmd <= Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & std_logic_vector'("111"));
              else
                m_cmd <= Std_Logic_Vector'(A_ToStdLogicVector(csn_decode) & std_logic_vector'("111"));
              end if;
              --Count down til safe to Proceed...
              if (std_logic_vector'("00000000000000000000000000000") & (m_count))>std_logic_vector'("00000000000000000000000000000001") then 
                m_count <= A_EXT (((std_logic_vector'("0") & (m_count)) - (std_logic_vector'("000") & (A_TOSTDLOGICVECTOR(std_logic'('1'))))), 3);
              else
                m_state <= m_next;
              end if;
          -- when std_logic_vector'("000000100") 
      
          when std_logic_vector'("000001000") => 
              m_cmd <= Std_Logic_Vector'(A_ToStdLogicVector(csn_decode) & std_logic_vector'("101"));
              m_bank <= A_WE_StdLogicVector((std_logic'(f_select) = '1'), f_bank, active_bank);
              m_dqm <= A_WE_StdLogicVector((std_logic'(f_select) = '1'), f_dqm, active_dqm);
              m_addr <= std_logic_vector'("0000") & (cas_addr);
              --Do we have a transaction pending?
              if std_logic'(pending) = '1' then 
                --if we need to ARF, bail, else spin
                if std_logic'(refresh_request) = '1' then 
                  m_state <= std_logic_vector'("000000100");
                  m_next <= std_logic_vector'("000000001");
                  m_count <= std_logic_vector'("001");
                else
                  f_pop <= std_logic'('1');
                  active_cs_n <= f_cs_n;
                  active_rnw <= f_rnw;
                  active_addr <= f_addr;
                  active_data <= f_data;
                  active_dqm <= f_dqm;
                end if;
              else
                --correctly end RD spin cycle if fifo mt
                if std_logic'((NOT pending AND f_pop)) = '1' then 
                  m_cmd <= Std_Logic_Vector'(A_ToStdLogicVector(csn_decode) & std_logic_vector'("111"));
                end if;
                m_state <= std_logic_vector'("100000000");
              end if;
          -- when std_logic_vector'("000001000") 
      
          when std_logic_vector'("000010000") => 
              m_cmd <= Std_Logic_Vector'(A_ToStdLogicVector(csn_decode) & std_logic_vector'("100"));
              oe <= std_logic'('1');
              m_data <= A_WE_StdLogicVector((std_logic'(f_select) = '1'), f_data, active_data);
              m_dqm <= A_WE_StdLogicVector((std_logic'(f_select) = '1'), f_dqm, active_dqm);
              m_bank <= A_WE_StdLogicVector((std_logic'(f_select) = '1'), f_bank, active_bank);
              m_addr <= std_logic_vector'("0000") & (cas_addr);
              --Do we have a transaction pending?
              if std_logic'(pending) = '1' then 
                --if we need to ARF, bail, else spin
                if std_logic'(refresh_request) = '1' then 
                  m_state <= std_logic_vector'("000000100");
                  m_next <= std_logic_vector'("000000001");
                  m_count <= std_logic_vector'("001");
                else
                  f_pop <= std_logic'('1');
                  active_cs_n <= f_cs_n;
                  active_rnw <= f_rnw;
                  active_addr <= f_addr;
                  active_data <= f_data;
                  active_dqm <= f_dqm;
                end if;
              else
                --correctly end WR spin cycle if fifo empty
                if std_logic'((NOT pending AND f_pop)) = '1' then 
                  m_cmd <= Std_Logic_Vector'(A_ToStdLogicVector(csn_decode) & std_logic_vector'("111"));
                  oe <= std_logic'('0');
                end if;
                m_state <= std_logic_vector'("100000000");
              end if;
          -- when std_logic_vector'("000010000") 
      
          when std_logic_vector'("000100000") => 
              m_cmd <= Std_Logic_Vector'(A_ToStdLogicVector(csn_decode) & std_logic_vector'("111"));
              --Count down til safe to Proceed...
              if (std_logic_vector'("00000000000000000000000000000") & (m_count))>std_logic_vector'("00000000000000000000000000000001") then 
                m_count <= A_EXT (((std_logic_vector'("0") & (m_count)) - (std_logic_vector'("000") & (A_TOSTDLOGICVECTOR(std_logic'('1'))))), 3);
              else
                m_state <= std_logic_vector'("001000000");
                m_count <= std_logic_vector'("000");
              end if;
          -- when std_logic_vector'("000100000") 
      
          when std_logic_vector'("001000000") => 
              m_state <= std_logic_vector'("000000100");
              m_addr <= A_REP(std_logic'('1'), 12);
              -- precharge all if arf, else precharge csn_decode
              if std_logic'(refresh_request) = '1' then 
                m_cmd <= Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & std_logic_vector'("010"));
              else
                m_cmd <= Std_Logic_Vector'(A_ToStdLogicVector(csn_decode) & std_logic_vector'("010"));
              end if;
          -- when std_logic_vector'("001000000") 
      
          when std_logic_vector'("010000000") => 
              ack_refresh_request <= std_logic'('1');
              m_state <= std_logic_vector'("000000100");
              m_cmd <= Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & std_logic_vector'("001"));
              m_count <= std_logic_vector'("011");
              m_next <= std_logic_vector'("000000001");
          -- when std_logic_vector'("010000000") 
      
          when std_logic_vector'("100000000") => 
              m_cmd <= Std_Logic_Vector'(A_ToStdLogicVector(csn_decode) & std_logic_vector'("111"));
              --if we need to ARF, bail, else spin
              if std_logic'(refresh_request) = '1' then 
                m_state <= std_logic_vector'("000000001");
              --wait for fifo to have contents
              elsif std_logic'(NOT(f_empty)) = '1' then 
                --Are we 'pending' yet?
                if std_logic'((((csn_match AND rnw_match) AND bank_match) AND row_match)) = '1' then 
                  m_state <= A_WE_StdLogicVector((std_logic'(f_rnw) = '1'), std_logic_vector'("000001000"), std_logic_vector'("000010000"));
                  f_pop <= std_logic'('1');
                  active_cs_n <= f_cs_n;
                  active_rnw <= f_rnw;
                  active_addr <= f_addr;
                  active_data <= f_data;
                  active_dqm <= f_dqm;
                else
                  m_state <= std_logic_vector'("001000000");
                  m_next <= std_logic_vector'("000000001");
                  m_count <= std_logic_vector'("000");
                end if;
              end if;
          -- when std_logic_vector'("100000000") 
      
          when others => 
              m_state <= m_state;
              m_cmd <= std_logic_vector'("1111");
              f_pop <= std_logic'('0');
              oe <= std_logic'('0');
          -- when others 
      
      end case; -- m_state
    end if;

  end process;

  rd_strobe <= to_std_logic((m_cmd(2 DOWNTO 0) = std_logic_vector'("101")));
  --Track RD Req's based on cas_latency w/shift reg
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      rd_valid <= A_REP(std_logic'('0'), 2);
    elsif clk'event and clk = '1' then
      rd_valid <= (A_SLL(rd_valid,std_logic_vector'("00000000000000000000000000000001"))) OR Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(rd_strobe));
    end if;

  end process;

  -- Register dq data.
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      za_data <= std_logic_vector'("0000000000000000");
    elsif clk'event and clk = '1' then
      za_data <= zs_dq;
    end if;

  end process;

  -- Delay za_valid to match registered data.
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      za_valid <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if true then 
        za_valid <= rd_valid(1);
      end if;
    end if;

  end process;

  cmd_code <= m_cmd(2 DOWNTO 0);
  cmd_all <= m_cmd;
  --vhdl renameroo for output signals
  za_waitrequest <= internal_za_waitrequest;
--synthesis translate_off
    txt_code <= A_WE_StdLogicVector(((cmd_code = std_logic_vector'("000"))), std_logic_vector'("010011000100110101010010"), A_WE_StdLogicVector(((cmd_code = std_logic_vector'("001"))), std_logic_vector'("010000010101001001000110"), A_WE_StdLogicVector(((cmd_code = std_logic_vector'("010"))), std_logic_vector'("010100000101001001000101"), A_WE_StdLogicVector(((cmd_code = std_logic_vector'("011"))), std_logic_vector'("010000010100001101010100"), A_WE_StdLogicVector(((cmd_code = std_logic_vector'("100"))), std_logic_vector'("001000000101011101010010"), A_WE_StdLogicVector(((cmd_code = std_logic_vector'("101"))), std_logic_vector'("001000000101001001000100"), A_WE_StdLogicVector(((cmd_code = std_logic_vector'("110"))), std_logic_vector'("010000100101001101010100"), A_WE_StdLogicVector(((cmd_code = std_logic_vector'("111"))), std_logic_vector'("010011100100111101010000"), std_logic_vector'("010000100100000101000100")))))))));
    CODE <= A_WE_StdLogicVector((std_logic'(and_reduce(((cmd_all OR std_logic_vector'("0111"))))) = '1'), std_logic_vector'("010010010100111001001000"), txt_code);
--synthesis translate_on

end europa;

