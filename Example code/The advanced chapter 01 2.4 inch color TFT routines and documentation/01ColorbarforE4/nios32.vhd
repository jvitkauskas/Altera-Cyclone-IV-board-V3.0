--megafunction wizard: %Altera SOPC Builder%
--GENERATION: STANDARD
--VERSION: WM1.0


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

library std;
use std.textio.all;

entity ads_busy_s1_arbitrator is 
        port (
              -- inputs:
                 signal ads_busy_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                 signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                 signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read : IN STD_LOGIC;
                 signal pipeline_bridge_m1_write : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal ads_busy_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ads_busy_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ads_busy_s1_reset_n : OUT STD_LOGIC;
                 signal d1_ads_busy_s1_end_xfer : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_granted_ads_busy_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ads_busy_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ads_busy_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ads_busy_s1 : OUT STD_LOGIC
              );
end entity ads_busy_s1_arbitrator;


architecture europa of ads_busy_s1_arbitrator is
                signal ads_busy_s1_allgrants :  STD_LOGIC;
                signal ads_busy_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal ads_busy_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal ads_busy_s1_any_continuerequest :  STD_LOGIC;
                signal ads_busy_s1_arb_counter_enable :  STD_LOGIC;
                signal ads_busy_s1_arb_share_counter :  STD_LOGIC;
                signal ads_busy_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal ads_busy_s1_arb_share_set_values :  STD_LOGIC;
                signal ads_busy_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal ads_busy_s1_begins_xfer :  STD_LOGIC;
                signal ads_busy_s1_end_xfer :  STD_LOGIC;
                signal ads_busy_s1_firsttransfer :  STD_LOGIC;
                signal ads_busy_s1_grant_vector :  STD_LOGIC;
                signal ads_busy_s1_in_a_read_cycle :  STD_LOGIC;
                signal ads_busy_s1_in_a_write_cycle :  STD_LOGIC;
                signal ads_busy_s1_master_qreq_vector :  STD_LOGIC;
                signal ads_busy_s1_non_bursting_master_requests :  STD_LOGIC;
                signal ads_busy_s1_reg_firsttransfer :  STD_LOGIC;
                signal ads_busy_s1_slavearbiterlockenable :  STD_LOGIC;
                signal ads_busy_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal ads_busy_s1_unreg_firsttransfer :  STD_LOGIC;
                signal ads_busy_s1_waits_for_read :  STD_LOGIC;
                signal ads_busy_s1_waits_for_write :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_ads_busy_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_granted_ads_busy_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_qualified_request_ads_busy_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_requests_ads_busy_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock2 :  STD_LOGIC;
                signal pipeline_bridge_m1_continuerequest :  STD_LOGIC;
                signal pipeline_bridge_m1_saved_grant_ads_busy_s1 :  STD_LOGIC;
                signal shifted_address_to_ads_busy_s1_from_pipeline_bridge_m1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal wait_for_ads_busy_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT ads_busy_s1_end_xfer;
    end if;

  end process;

  ads_busy_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_pipeline_bridge_m1_qualified_request_ads_busy_s1);
  --assign ads_busy_s1_readdata_from_sa = ads_busy_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  ads_busy_s1_readdata_from_sa <= ads_busy_s1_readdata;
  internal_pipeline_bridge_m1_requests_ads_busy_s1 <= ((to_std_logic(((Std_Logic_Vector'(pipeline_bridge_m1_address_to_slave(7 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("11010000")))) AND pipeline_bridge_m1_chipselect)) AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --ads_busy_s1_arb_share_counter set values, which is an e_mux
  ads_busy_s1_arb_share_set_values <= std_logic'('1');
  --ads_busy_s1_non_bursting_master_requests mux, which is an e_mux
  ads_busy_s1_non_bursting_master_requests <= internal_pipeline_bridge_m1_requests_ads_busy_s1;
  --ads_busy_s1_any_bursting_master_saved_grant mux, which is an e_mux
  ads_busy_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --ads_busy_s1_arb_share_counter_next_value assignment, which is an e_assign
  ads_busy_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(ads_busy_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ads_busy_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(ads_busy_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ads_busy_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --ads_busy_s1_allgrants all slave grants, which is an e_mux
  ads_busy_s1_allgrants <= ads_busy_s1_grant_vector;
  --ads_busy_s1_end_xfer assignment, which is an e_assign
  ads_busy_s1_end_xfer <= NOT ((ads_busy_s1_waits_for_read OR ads_busy_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_ads_busy_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_ads_busy_s1 <= ads_busy_s1_end_xfer AND (((NOT ads_busy_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --ads_busy_s1_arb_share_counter arbitration counter enable, which is an e_assign
  ads_busy_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_ads_busy_s1 AND ads_busy_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_ads_busy_s1 AND NOT ads_busy_s1_non_bursting_master_requests));
  --ads_busy_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ads_busy_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(ads_busy_s1_arb_counter_enable) = '1' then 
        ads_busy_s1_arb_share_counter <= ads_busy_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --ads_busy_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ads_busy_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((ads_busy_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_ads_busy_s1)) OR ((end_xfer_arb_share_counter_term_ads_busy_s1 AND NOT ads_busy_s1_non_bursting_master_requests)))) = '1' then 
        ads_busy_s1_slavearbiterlockenable <= ads_busy_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pipeline_bridge/m1 ads_busy/s1 arbiterlock, which is an e_assign
  pipeline_bridge_m1_arbiterlock <= ads_busy_s1_slavearbiterlockenable AND pipeline_bridge_m1_continuerequest;
  --ads_busy_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  ads_busy_s1_slavearbiterlockenable2 <= ads_busy_s1_arb_share_counter_next_value;
  --pipeline_bridge/m1 ads_busy/s1 arbiterlock2, which is an e_assign
  pipeline_bridge_m1_arbiterlock2 <= ads_busy_s1_slavearbiterlockenable2 AND pipeline_bridge_m1_continuerequest;
  --ads_busy_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  ads_busy_s1_any_continuerequest <= std_logic'('1');
  --pipeline_bridge_m1_continuerequest continued request, which is an e_assign
  pipeline_bridge_m1_continuerequest <= std_logic'('1');
  internal_pipeline_bridge_m1_qualified_request_ads_busy_s1 <= internal_pipeline_bridge_m1_requests_ads_busy_s1 AND NOT ((((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))))));
  --local readdatavalid pipeline_bridge_m1_read_data_valid_ads_busy_s1, which is an e_mux
  pipeline_bridge_m1_read_data_valid_ads_busy_s1 <= (internal_pipeline_bridge_m1_granted_ads_busy_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect))) AND NOT ads_busy_s1_waits_for_read;
  --master is always granted when requested
  internal_pipeline_bridge_m1_granted_ads_busy_s1 <= internal_pipeline_bridge_m1_qualified_request_ads_busy_s1;
  --pipeline_bridge/m1 saved-grant ads_busy/s1, which is an e_assign
  pipeline_bridge_m1_saved_grant_ads_busy_s1 <= internal_pipeline_bridge_m1_requests_ads_busy_s1;
  --allow new arb cycle for ads_busy/s1, which is an e_assign
  ads_busy_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  ads_busy_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  ads_busy_s1_master_qreq_vector <= std_logic'('1');
  --ads_busy_s1_reset_n assignment, which is an e_assign
  ads_busy_s1_reset_n <= reset_n;
  --ads_busy_s1_firsttransfer first transaction, which is an e_assign
  ads_busy_s1_firsttransfer <= A_WE_StdLogic((std_logic'(ads_busy_s1_begins_xfer) = '1'), ads_busy_s1_unreg_firsttransfer, ads_busy_s1_reg_firsttransfer);
  --ads_busy_s1_unreg_firsttransfer first transaction, which is an e_assign
  ads_busy_s1_unreg_firsttransfer <= NOT ((ads_busy_s1_slavearbiterlockenable AND ads_busy_s1_any_continuerequest));
  --ads_busy_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ads_busy_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(ads_busy_s1_begins_xfer) = '1' then 
        ads_busy_s1_reg_firsttransfer <= ads_busy_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --ads_busy_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  ads_busy_s1_beginbursttransfer_internal <= ads_busy_s1_begins_xfer;
  shifted_address_to_ads_busy_s1_from_pipeline_bridge_m1 <= pipeline_bridge_m1_address_to_slave;
  --ads_busy_s1_address mux, which is an e_mux
  ads_busy_s1_address <= A_EXT (A_SRL(shifted_address_to_ads_busy_s1_from_pipeline_bridge_m1,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_ads_busy_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_ads_busy_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_ads_busy_s1_end_xfer <= ads_busy_s1_end_xfer;
    end if;

  end process;

  --ads_busy_s1_waits_for_read in a cycle, which is an e_mux
  ads_busy_s1_waits_for_read <= ads_busy_s1_in_a_read_cycle AND ads_busy_s1_begins_xfer;
  --ads_busy_s1_in_a_read_cycle assignment, which is an e_assign
  ads_busy_s1_in_a_read_cycle <= internal_pipeline_bridge_m1_granted_ads_busy_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= ads_busy_s1_in_a_read_cycle;
  --ads_busy_s1_waits_for_write in a cycle, which is an e_mux
  ads_busy_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ads_busy_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --ads_busy_s1_in_a_write_cycle assignment, which is an e_assign
  ads_busy_s1_in_a_write_cycle <= internal_pipeline_bridge_m1_granted_ads_busy_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect));
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= ads_busy_s1_in_a_write_cycle;
  wait_for_ads_busy_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  pipeline_bridge_m1_granted_ads_busy_s1 <= internal_pipeline_bridge_m1_granted_ads_busy_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_qualified_request_ads_busy_s1 <= internal_pipeline_bridge_m1_qualified_request_ads_busy_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_requests_ads_busy_s1 <= internal_pipeline_bridge_m1_requests_ads_busy_s1;
--synthesis translate_off
    --ads_busy/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --pipeline_bridge/m1 non-zero burstcount assertion, which is an e_process
    process (clk)
    VARIABLE write_line : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((internal_pipeline_bridge_m1_requests_ads_busy_s1 AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_burstcount))) = std_logic_vector'("00000000000000000000000000000000"))))) AND enable_nonzero_assertions)) = '1' then 
          write(write_line, now);
          write(write_line, string'(": "));
          write(write_line, string'("pipeline_bridge/m1 drove 0 on its 'burstcount' port while accessing slave ads_busy/s1"));
          write(output, write_line.all);
          deallocate (write_line);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

library std;
use std.textio.all;

entity ads_clk_s1_arbitrator is 
        port (
              -- inputs:
                 signal ads_clk_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                 signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                 signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read : IN STD_LOGIC;
                 signal pipeline_bridge_m1_write : IN STD_LOGIC;
                 signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal ads_clk_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ads_clk_s1_chipselect : OUT STD_LOGIC;
                 signal ads_clk_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ads_clk_s1_reset_n : OUT STD_LOGIC;
                 signal ads_clk_s1_write_n : OUT STD_LOGIC;
                 signal ads_clk_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_ads_clk_s1_end_xfer : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_granted_ads_clk_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ads_clk_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ads_clk_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ads_clk_s1 : OUT STD_LOGIC
              );
end entity ads_clk_s1_arbitrator;


architecture europa of ads_clk_s1_arbitrator is
                signal ads_clk_s1_allgrants :  STD_LOGIC;
                signal ads_clk_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal ads_clk_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal ads_clk_s1_any_continuerequest :  STD_LOGIC;
                signal ads_clk_s1_arb_counter_enable :  STD_LOGIC;
                signal ads_clk_s1_arb_share_counter :  STD_LOGIC;
                signal ads_clk_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal ads_clk_s1_arb_share_set_values :  STD_LOGIC;
                signal ads_clk_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal ads_clk_s1_begins_xfer :  STD_LOGIC;
                signal ads_clk_s1_end_xfer :  STD_LOGIC;
                signal ads_clk_s1_firsttransfer :  STD_LOGIC;
                signal ads_clk_s1_grant_vector :  STD_LOGIC;
                signal ads_clk_s1_in_a_read_cycle :  STD_LOGIC;
                signal ads_clk_s1_in_a_write_cycle :  STD_LOGIC;
                signal ads_clk_s1_master_qreq_vector :  STD_LOGIC;
                signal ads_clk_s1_non_bursting_master_requests :  STD_LOGIC;
                signal ads_clk_s1_reg_firsttransfer :  STD_LOGIC;
                signal ads_clk_s1_slavearbiterlockenable :  STD_LOGIC;
                signal ads_clk_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal ads_clk_s1_unreg_firsttransfer :  STD_LOGIC;
                signal ads_clk_s1_waits_for_read :  STD_LOGIC;
                signal ads_clk_s1_waits_for_write :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_ads_clk_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_granted_ads_clk_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_qualified_request_ads_clk_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_requests_ads_clk_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock2 :  STD_LOGIC;
                signal pipeline_bridge_m1_continuerequest :  STD_LOGIC;
                signal pipeline_bridge_m1_saved_grant_ads_clk_s1 :  STD_LOGIC;
                signal shifted_address_to_ads_clk_s1_from_pipeline_bridge_m1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal wait_for_ads_clk_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT ads_clk_s1_end_xfer;
    end if;

  end process;

  ads_clk_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_pipeline_bridge_m1_qualified_request_ads_clk_s1);
  --assign ads_clk_s1_readdata_from_sa = ads_clk_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  ads_clk_s1_readdata_from_sa <= ads_clk_s1_readdata;
  internal_pipeline_bridge_m1_requests_ads_clk_s1 <= to_std_logic(((Std_Logic_Vector'(pipeline_bridge_m1_address_to_slave(7 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("10010000")))) AND pipeline_bridge_m1_chipselect;
  --ads_clk_s1_arb_share_counter set values, which is an e_mux
  ads_clk_s1_arb_share_set_values <= std_logic'('1');
  --ads_clk_s1_non_bursting_master_requests mux, which is an e_mux
  ads_clk_s1_non_bursting_master_requests <= internal_pipeline_bridge_m1_requests_ads_clk_s1;
  --ads_clk_s1_any_bursting_master_saved_grant mux, which is an e_mux
  ads_clk_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --ads_clk_s1_arb_share_counter_next_value assignment, which is an e_assign
  ads_clk_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(ads_clk_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ads_clk_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(ads_clk_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ads_clk_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --ads_clk_s1_allgrants all slave grants, which is an e_mux
  ads_clk_s1_allgrants <= ads_clk_s1_grant_vector;
  --ads_clk_s1_end_xfer assignment, which is an e_assign
  ads_clk_s1_end_xfer <= NOT ((ads_clk_s1_waits_for_read OR ads_clk_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_ads_clk_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_ads_clk_s1 <= ads_clk_s1_end_xfer AND (((NOT ads_clk_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --ads_clk_s1_arb_share_counter arbitration counter enable, which is an e_assign
  ads_clk_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_ads_clk_s1 AND ads_clk_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_ads_clk_s1 AND NOT ads_clk_s1_non_bursting_master_requests));
  --ads_clk_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ads_clk_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(ads_clk_s1_arb_counter_enable) = '1' then 
        ads_clk_s1_arb_share_counter <= ads_clk_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --ads_clk_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ads_clk_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((ads_clk_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_ads_clk_s1)) OR ((end_xfer_arb_share_counter_term_ads_clk_s1 AND NOT ads_clk_s1_non_bursting_master_requests)))) = '1' then 
        ads_clk_s1_slavearbiterlockenable <= ads_clk_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pipeline_bridge/m1 ads_clk/s1 arbiterlock, which is an e_assign
  pipeline_bridge_m1_arbiterlock <= ads_clk_s1_slavearbiterlockenable AND pipeline_bridge_m1_continuerequest;
  --ads_clk_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  ads_clk_s1_slavearbiterlockenable2 <= ads_clk_s1_arb_share_counter_next_value;
  --pipeline_bridge/m1 ads_clk/s1 arbiterlock2, which is an e_assign
  pipeline_bridge_m1_arbiterlock2 <= ads_clk_s1_slavearbiterlockenable2 AND pipeline_bridge_m1_continuerequest;
  --ads_clk_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  ads_clk_s1_any_continuerequest <= std_logic'('1');
  --pipeline_bridge_m1_continuerequest continued request, which is an e_assign
  pipeline_bridge_m1_continuerequest <= std_logic'('1');
  internal_pipeline_bridge_m1_qualified_request_ads_clk_s1 <= internal_pipeline_bridge_m1_requests_ads_clk_s1 AND NOT ((((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))))));
  --local readdatavalid pipeline_bridge_m1_read_data_valid_ads_clk_s1, which is an e_mux
  pipeline_bridge_m1_read_data_valid_ads_clk_s1 <= (internal_pipeline_bridge_m1_granted_ads_clk_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect))) AND NOT ads_clk_s1_waits_for_read;
  --ads_clk_s1_writedata mux, which is an e_mux
  ads_clk_s1_writedata <= pipeline_bridge_m1_writedata;
  --master is always granted when requested
  internal_pipeline_bridge_m1_granted_ads_clk_s1 <= internal_pipeline_bridge_m1_qualified_request_ads_clk_s1;
  --pipeline_bridge/m1 saved-grant ads_clk/s1, which is an e_assign
  pipeline_bridge_m1_saved_grant_ads_clk_s1 <= internal_pipeline_bridge_m1_requests_ads_clk_s1;
  --allow new arb cycle for ads_clk/s1, which is an e_assign
  ads_clk_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  ads_clk_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  ads_clk_s1_master_qreq_vector <= std_logic'('1');
  --ads_clk_s1_reset_n assignment, which is an e_assign
  ads_clk_s1_reset_n <= reset_n;
  ads_clk_s1_chipselect <= internal_pipeline_bridge_m1_granted_ads_clk_s1;
  --ads_clk_s1_firsttransfer first transaction, which is an e_assign
  ads_clk_s1_firsttransfer <= A_WE_StdLogic((std_logic'(ads_clk_s1_begins_xfer) = '1'), ads_clk_s1_unreg_firsttransfer, ads_clk_s1_reg_firsttransfer);
  --ads_clk_s1_unreg_firsttransfer first transaction, which is an e_assign
  ads_clk_s1_unreg_firsttransfer <= NOT ((ads_clk_s1_slavearbiterlockenable AND ads_clk_s1_any_continuerequest));
  --ads_clk_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ads_clk_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(ads_clk_s1_begins_xfer) = '1' then 
        ads_clk_s1_reg_firsttransfer <= ads_clk_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --ads_clk_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  ads_clk_s1_beginbursttransfer_internal <= ads_clk_s1_begins_xfer;
  --~ads_clk_s1_write_n assignment, which is an e_mux
  ads_clk_s1_write_n <= NOT ((internal_pipeline_bridge_m1_granted_ads_clk_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect))));
  shifted_address_to_ads_clk_s1_from_pipeline_bridge_m1 <= pipeline_bridge_m1_address_to_slave;
  --ads_clk_s1_address mux, which is an e_mux
  ads_clk_s1_address <= A_EXT (A_SRL(shifted_address_to_ads_clk_s1_from_pipeline_bridge_m1,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_ads_clk_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_ads_clk_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_ads_clk_s1_end_xfer <= ads_clk_s1_end_xfer;
    end if;

  end process;

  --ads_clk_s1_waits_for_read in a cycle, which is an e_mux
  ads_clk_s1_waits_for_read <= ads_clk_s1_in_a_read_cycle AND ads_clk_s1_begins_xfer;
  --ads_clk_s1_in_a_read_cycle assignment, which is an e_assign
  ads_clk_s1_in_a_read_cycle <= internal_pipeline_bridge_m1_granted_ads_clk_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= ads_clk_s1_in_a_read_cycle;
  --ads_clk_s1_waits_for_write in a cycle, which is an e_mux
  ads_clk_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ads_clk_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --ads_clk_s1_in_a_write_cycle assignment, which is an e_assign
  ads_clk_s1_in_a_write_cycle <= internal_pipeline_bridge_m1_granted_ads_clk_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect));
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= ads_clk_s1_in_a_write_cycle;
  wait_for_ads_clk_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  pipeline_bridge_m1_granted_ads_clk_s1 <= internal_pipeline_bridge_m1_granted_ads_clk_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_qualified_request_ads_clk_s1 <= internal_pipeline_bridge_m1_qualified_request_ads_clk_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_requests_ads_clk_s1 <= internal_pipeline_bridge_m1_requests_ads_clk_s1;
--synthesis translate_off
    --ads_clk/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --pipeline_bridge/m1 non-zero burstcount assertion, which is an e_process
    process (clk)
    VARIABLE write_line1 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((internal_pipeline_bridge_m1_requests_ads_clk_s1 AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_burstcount))) = std_logic_vector'("00000000000000000000000000000000"))))) AND enable_nonzero_assertions)) = '1' then 
          write(write_line1, now);
          write(write_line1, string'(": "));
          write(write_line1, string'("pipeline_bridge/m1 drove 0 on its 'burstcount' port while accessing slave ads_clk/s1"));
          write(output, write_line1.all);
          deallocate (write_line1);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

library std;
use std.textio.all;

entity ads_din_s1_arbitrator is 
        port (
              -- inputs:
                 signal ads_din_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                 signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                 signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read : IN STD_LOGIC;
                 signal pipeline_bridge_m1_write : IN STD_LOGIC;
                 signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal ads_din_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ads_din_s1_chipselect : OUT STD_LOGIC;
                 signal ads_din_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ads_din_s1_reset_n : OUT STD_LOGIC;
                 signal ads_din_s1_write_n : OUT STD_LOGIC;
                 signal ads_din_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_ads_din_s1_end_xfer : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_granted_ads_din_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ads_din_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ads_din_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ads_din_s1 : OUT STD_LOGIC
              );
end entity ads_din_s1_arbitrator;


architecture europa of ads_din_s1_arbitrator is
                signal ads_din_s1_allgrants :  STD_LOGIC;
                signal ads_din_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal ads_din_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal ads_din_s1_any_continuerequest :  STD_LOGIC;
                signal ads_din_s1_arb_counter_enable :  STD_LOGIC;
                signal ads_din_s1_arb_share_counter :  STD_LOGIC;
                signal ads_din_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal ads_din_s1_arb_share_set_values :  STD_LOGIC;
                signal ads_din_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal ads_din_s1_begins_xfer :  STD_LOGIC;
                signal ads_din_s1_end_xfer :  STD_LOGIC;
                signal ads_din_s1_firsttransfer :  STD_LOGIC;
                signal ads_din_s1_grant_vector :  STD_LOGIC;
                signal ads_din_s1_in_a_read_cycle :  STD_LOGIC;
                signal ads_din_s1_in_a_write_cycle :  STD_LOGIC;
                signal ads_din_s1_master_qreq_vector :  STD_LOGIC;
                signal ads_din_s1_non_bursting_master_requests :  STD_LOGIC;
                signal ads_din_s1_reg_firsttransfer :  STD_LOGIC;
                signal ads_din_s1_slavearbiterlockenable :  STD_LOGIC;
                signal ads_din_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal ads_din_s1_unreg_firsttransfer :  STD_LOGIC;
                signal ads_din_s1_waits_for_read :  STD_LOGIC;
                signal ads_din_s1_waits_for_write :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_ads_din_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_granted_ads_din_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_qualified_request_ads_din_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_requests_ads_din_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock2 :  STD_LOGIC;
                signal pipeline_bridge_m1_continuerequest :  STD_LOGIC;
                signal pipeline_bridge_m1_saved_grant_ads_din_s1 :  STD_LOGIC;
                signal shifted_address_to_ads_din_s1_from_pipeline_bridge_m1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal wait_for_ads_din_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT ads_din_s1_end_xfer;
    end if;

  end process;

  ads_din_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_pipeline_bridge_m1_qualified_request_ads_din_s1);
  --assign ads_din_s1_readdata_from_sa = ads_din_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  ads_din_s1_readdata_from_sa <= ads_din_s1_readdata;
  internal_pipeline_bridge_m1_requests_ads_din_s1 <= to_std_logic(((Std_Logic_Vector'(pipeline_bridge_m1_address_to_slave(7 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("01110000")))) AND pipeline_bridge_m1_chipselect;
  --ads_din_s1_arb_share_counter set values, which is an e_mux
  ads_din_s1_arb_share_set_values <= std_logic'('1');
  --ads_din_s1_non_bursting_master_requests mux, which is an e_mux
  ads_din_s1_non_bursting_master_requests <= internal_pipeline_bridge_m1_requests_ads_din_s1;
  --ads_din_s1_any_bursting_master_saved_grant mux, which is an e_mux
  ads_din_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --ads_din_s1_arb_share_counter_next_value assignment, which is an e_assign
  ads_din_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(ads_din_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ads_din_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(ads_din_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ads_din_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --ads_din_s1_allgrants all slave grants, which is an e_mux
  ads_din_s1_allgrants <= ads_din_s1_grant_vector;
  --ads_din_s1_end_xfer assignment, which is an e_assign
  ads_din_s1_end_xfer <= NOT ((ads_din_s1_waits_for_read OR ads_din_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_ads_din_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_ads_din_s1 <= ads_din_s1_end_xfer AND (((NOT ads_din_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --ads_din_s1_arb_share_counter arbitration counter enable, which is an e_assign
  ads_din_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_ads_din_s1 AND ads_din_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_ads_din_s1 AND NOT ads_din_s1_non_bursting_master_requests));
  --ads_din_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ads_din_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(ads_din_s1_arb_counter_enable) = '1' then 
        ads_din_s1_arb_share_counter <= ads_din_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --ads_din_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ads_din_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((ads_din_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_ads_din_s1)) OR ((end_xfer_arb_share_counter_term_ads_din_s1 AND NOT ads_din_s1_non_bursting_master_requests)))) = '1' then 
        ads_din_s1_slavearbiterlockenable <= ads_din_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pipeline_bridge/m1 ads_din/s1 arbiterlock, which is an e_assign
  pipeline_bridge_m1_arbiterlock <= ads_din_s1_slavearbiterlockenable AND pipeline_bridge_m1_continuerequest;
  --ads_din_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  ads_din_s1_slavearbiterlockenable2 <= ads_din_s1_arb_share_counter_next_value;
  --pipeline_bridge/m1 ads_din/s1 arbiterlock2, which is an e_assign
  pipeline_bridge_m1_arbiterlock2 <= ads_din_s1_slavearbiterlockenable2 AND pipeline_bridge_m1_continuerequest;
  --ads_din_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  ads_din_s1_any_continuerequest <= std_logic'('1');
  --pipeline_bridge_m1_continuerequest continued request, which is an e_assign
  pipeline_bridge_m1_continuerequest <= std_logic'('1');
  internal_pipeline_bridge_m1_qualified_request_ads_din_s1 <= internal_pipeline_bridge_m1_requests_ads_din_s1 AND NOT ((((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))))));
  --local readdatavalid pipeline_bridge_m1_read_data_valid_ads_din_s1, which is an e_mux
  pipeline_bridge_m1_read_data_valid_ads_din_s1 <= (internal_pipeline_bridge_m1_granted_ads_din_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect))) AND NOT ads_din_s1_waits_for_read;
  --ads_din_s1_writedata mux, which is an e_mux
  ads_din_s1_writedata <= pipeline_bridge_m1_writedata;
  --master is always granted when requested
  internal_pipeline_bridge_m1_granted_ads_din_s1 <= internal_pipeline_bridge_m1_qualified_request_ads_din_s1;
  --pipeline_bridge/m1 saved-grant ads_din/s1, which is an e_assign
  pipeline_bridge_m1_saved_grant_ads_din_s1 <= internal_pipeline_bridge_m1_requests_ads_din_s1;
  --allow new arb cycle for ads_din/s1, which is an e_assign
  ads_din_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  ads_din_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  ads_din_s1_master_qreq_vector <= std_logic'('1');
  --ads_din_s1_reset_n assignment, which is an e_assign
  ads_din_s1_reset_n <= reset_n;
  ads_din_s1_chipselect <= internal_pipeline_bridge_m1_granted_ads_din_s1;
  --ads_din_s1_firsttransfer first transaction, which is an e_assign
  ads_din_s1_firsttransfer <= A_WE_StdLogic((std_logic'(ads_din_s1_begins_xfer) = '1'), ads_din_s1_unreg_firsttransfer, ads_din_s1_reg_firsttransfer);
  --ads_din_s1_unreg_firsttransfer first transaction, which is an e_assign
  ads_din_s1_unreg_firsttransfer <= NOT ((ads_din_s1_slavearbiterlockenable AND ads_din_s1_any_continuerequest));
  --ads_din_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ads_din_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(ads_din_s1_begins_xfer) = '1' then 
        ads_din_s1_reg_firsttransfer <= ads_din_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --ads_din_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  ads_din_s1_beginbursttransfer_internal <= ads_din_s1_begins_xfer;
  --~ads_din_s1_write_n assignment, which is an e_mux
  ads_din_s1_write_n <= NOT ((internal_pipeline_bridge_m1_granted_ads_din_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect))));
  shifted_address_to_ads_din_s1_from_pipeline_bridge_m1 <= pipeline_bridge_m1_address_to_slave;
  --ads_din_s1_address mux, which is an e_mux
  ads_din_s1_address <= A_EXT (A_SRL(shifted_address_to_ads_din_s1_from_pipeline_bridge_m1,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_ads_din_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_ads_din_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_ads_din_s1_end_xfer <= ads_din_s1_end_xfer;
    end if;

  end process;

  --ads_din_s1_waits_for_read in a cycle, which is an e_mux
  ads_din_s1_waits_for_read <= ads_din_s1_in_a_read_cycle AND ads_din_s1_begins_xfer;
  --ads_din_s1_in_a_read_cycle assignment, which is an e_assign
  ads_din_s1_in_a_read_cycle <= internal_pipeline_bridge_m1_granted_ads_din_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= ads_din_s1_in_a_read_cycle;
  --ads_din_s1_waits_for_write in a cycle, which is an e_mux
  ads_din_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ads_din_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --ads_din_s1_in_a_write_cycle assignment, which is an e_assign
  ads_din_s1_in_a_write_cycle <= internal_pipeline_bridge_m1_granted_ads_din_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect));
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= ads_din_s1_in_a_write_cycle;
  wait_for_ads_din_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  pipeline_bridge_m1_granted_ads_din_s1 <= internal_pipeline_bridge_m1_granted_ads_din_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_qualified_request_ads_din_s1 <= internal_pipeline_bridge_m1_qualified_request_ads_din_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_requests_ads_din_s1 <= internal_pipeline_bridge_m1_requests_ads_din_s1;
--synthesis translate_off
    --ads_din/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --pipeline_bridge/m1 non-zero burstcount assertion, which is an e_process
    process (clk)
    VARIABLE write_line2 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((internal_pipeline_bridge_m1_requests_ads_din_s1 AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_burstcount))) = std_logic_vector'("00000000000000000000000000000000"))))) AND enable_nonzero_assertions)) = '1' then 
          write(write_line2, now);
          write(write_line2, string'(": "));
          write(write_line2, string'("pipeline_bridge/m1 drove 0 on its 'burstcount' port while accessing slave ads_din/s1"));
          write(output, write_line2.all);
          deallocate (write_line2);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

library std;
use std.textio.all;

entity ads_dout_s1_arbitrator is 
        port (
              -- inputs:
                 signal ads_dout_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                 signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                 signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read : IN STD_LOGIC;
                 signal pipeline_bridge_m1_write : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal ads_dout_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ads_dout_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ads_dout_s1_reset_n : OUT STD_LOGIC;
                 signal d1_ads_dout_s1_end_xfer : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_granted_ads_dout_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ads_dout_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ads_dout_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ads_dout_s1 : OUT STD_LOGIC
              );
end entity ads_dout_s1_arbitrator;


architecture europa of ads_dout_s1_arbitrator is
                signal ads_dout_s1_allgrants :  STD_LOGIC;
                signal ads_dout_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal ads_dout_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal ads_dout_s1_any_continuerequest :  STD_LOGIC;
                signal ads_dout_s1_arb_counter_enable :  STD_LOGIC;
                signal ads_dout_s1_arb_share_counter :  STD_LOGIC;
                signal ads_dout_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal ads_dout_s1_arb_share_set_values :  STD_LOGIC;
                signal ads_dout_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal ads_dout_s1_begins_xfer :  STD_LOGIC;
                signal ads_dout_s1_end_xfer :  STD_LOGIC;
                signal ads_dout_s1_firsttransfer :  STD_LOGIC;
                signal ads_dout_s1_grant_vector :  STD_LOGIC;
                signal ads_dout_s1_in_a_read_cycle :  STD_LOGIC;
                signal ads_dout_s1_in_a_write_cycle :  STD_LOGIC;
                signal ads_dout_s1_master_qreq_vector :  STD_LOGIC;
                signal ads_dout_s1_non_bursting_master_requests :  STD_LOGIC;
                signal ads_dout_s1_reg_firsttransfer :  STD_LOGIC;
                signal ads_dout_s1_slavearbiterlockenable :  STD_LOGIC;
                signal ads_dout_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal ads_dout_s1_unreg_firsttransfer :  STD_LOGIC;
                signal ads_dout_s1_waits_for_read :  STD_LOGIC;
                signal ads_dout_s1_waits_for_write :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_ads_dout_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_granted_ads_dout_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_qualified_request_ads_dout_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_requests_ads_dout_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock2 :  STD_LOGIC;
                signal pipeline_bridge_m1_continuerequest :  STD_LOGIC;
                signal pipeline_bridge_m1_saved_grant_ads_dout_s1 :  STD_LOGIC;
                signal shifted_address_to_ads_dout_s1_from_pipeline_bridge_m1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal wait_for_ads_dout_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT ads_dout_s1_end_xfer;
    end if;

  end process;

  ads_dout_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_pipeline_bridge_m1_qualified_request_ads_dout_s1);
  --assign ads_dout_s1_readdata_from_sa = ads_dout_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  ads_dout_s1_readdata_from_sa <= ads_dout_s1_readdata;
  internal_pipeline_bridge_m1_requests_ads_dout_s1 <= ((to_std_logic(((Std_Logic_Vector'(pipeline_bridge_m1_address_to_slave(7 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("10000000")))) AND pipeline_bridge_m1_chipselect)) AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --ads_dout_s1_arb_share_counter set values, which is an e_mux
  ads_dout_s1_arb_share_set_values <= std_logic'('1');
  --ads_dout_s1_non_bursting_master_requests mux, which is an e_mux
  ads_dout_s1_non_bursting_master_requests <= internal_pipeline_bridge_m1_requests_ads_dout_s1;
  --ads_dout_s1_any_bursting_master_saved_grant mux, which is an e_mux
  ads_dout_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --ads_dout_s1_arb_share_counter_next_value assignment, which is an e_assign
  ads_dout_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(ads_dout_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ads_dout_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(ads_dout_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ads_dout_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --ads_dout_s1_allgrants all slave grants, which is an e_mux
  ads_dout_s1_allgrants <= ads_dout_s1_grant_vector;
  --ads_dout_s1_end_xfer assignment, which is an e_assign
  ads_dout_s1_end_xfer <= NOT ((ads_dout_s1_waits_for_read OR ads_dout_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_ads_dout_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_ads_dout_s1 <= ads_dout_s1_end_xfer AND (((NOT ads_dout_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --ads_dout_s1_arb_share_counter arbitration counter enable, which is an e_assign
  ads_dout_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_ads_dout_s1 AND ads_dout_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_ads_dout_s1 AND NOT ads_dout_s1_non_bursting_master_requests));
  --ads_dout_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ads_dout_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(ads_dout_s1_arb_counter_enable) = '1' then 
        ads_dout_s1_arb_share_counter <= ads_dout_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --ads_dout_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ads_dout_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((ads_dout_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_ads_dout_s1)) OR ((end_xfer_arb_share_counter_term_ads_dout_s1 AND NOT ads_dout_s1_non_bursting_master_requests)))) = '1' then 
        ads_dout_s1_slavearbiterlockenable <= ads_dout_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pipeline_bridge/m1 ads_dout/s1 arbiterlock, which is an e_assign
  pipeline_bridge_m1_arbiterlock <= ads_dout_s1_slavearbiterlockenable AND pipeline_bridge_m1_continuerequest;
  --ads_dout_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  ads_dout_s1_slavearbiterlockenable2 <= ads_dout_s1_arb_share_counter_next_value;
  --pipeline_bridge/m1 ads_dout/s1 arbiterlock2, which is an e_assign
  pipeline_bridge_m1_arbiterlock2 <= ads_dout_s1_slavearbiterlockenable2 AND pipeline_bridge_m1_continuerequest;
  --ads_dout_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  ads_dout_s1_any_continuerequest <= std_logic'('1');
  --pipeline_bridge_m1_continuerequest continued request, which is an e_assign
  pipeline_bridge_m1_continuerequest <= std_logic'('1');
  internal_pipeline_bridge_m1_qualified_request_ads_dout_s1 <= internal_pipeline_bridge_m1_requests_ads_dout_s1 AND NOT ((((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))))));
  --local readdatavalid pipeline_bridge_m1_read_data_valid_ads_dout_s1, which is an e_mux
  pipeline_bridge_m1_read_data_valid_ads_dout_s1 <= (internal_pipeline_bridge_m1_granted_ads_dout_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect))) AND NOT ads_dout_s1_waits_for_read;
  --master is always granted when requested
  internal_pipeline_bridge_m1_granted_ads_dout_s1 <= internal_pipeline_bridge_m1_qualified_request_ads_dout_s1;
  --pipeline_bridge/m1 saved-grant ads_dout/s1, which is an e_assign
  pipeline_bridge_m1_saved_grant_ads_dout_s1 <= internal_pipeline_bridge_m1_requests_ads_dout_s1;
  --allow new arb cycle for ads_dout/s1, which is an e_assign
  ads_dout_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  ads_dout_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  ads_dout_s1_master_qreq_vector <= std_logic'('1');
  --ads_dout_s1_reset_n assignment, which is an e_assign
  ads_dout_s1_reset_n <= reset_n;
  --ads_dout_s1_firsttransfer first transaction, which is an e_assign
  ads_dout_s1_firsttransfer <= A_WE_StdLogic((std_logic'(ads_dout_s1_begins_xfer) = '1'), ads_dout_s1_unreg_firsttransfer, ads_dout_s1_reg_firsttransfer);
  --ads_dout_s1_unreg_firsttransfer first transaction, which is an e_assign
  ads_dout_s1_unreg_firsttransfer <= NOT ((ads_dout_s1_slavearbiterlockenable AND ads_dout_s1_any_continuerequest));
  --ads_dout_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ads_dout_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(ads_dout_s1_begins_xfer) = '1' then 
        ads_dout_s1_reg_firsttransfer <= ads_dout_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --ads_dout_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  ads_dout_s1_beginbursttransfer_internal <= ads_dout_s1_begins_xfer;
  shifted_address_to_ads_dout_s1_from_pipeline_bridge_m1 <= pipeline_bridge_m1_address_to_slave;
  --ads_dout_s1_address mux, which is an e_mux
  ads_dout_s1_address <= A_EXT (A_SRL(shifted_address_to_ads_dout_s1_from_pipeline_bridge_m1,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_ads_dout_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_ads_dout_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_ads_dout_s1_end_xfer <= ads_dout_s1_end_xfer;
    end if;

  end process;

  --ads_dout_s1_waits_for_read in a cycle, which is an e_mux
  ads_dout_s1_waits_for_read <= ads_dout_s1_in_a_read_cycle AND ads_dout_s1_begins_xfer;
  --ads_dout_s1_in_a_read_cycle assignment, which is an e_assign
  ads_dout_s1_in_a_read_cycle <= internal_pipeline_bridge_m1_granted_ads_dout_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= ads_dout_s1_in_a_read_cycle;
  --ads_dout_s1_waits_for_write in a cycle, which is an e_mux
  ads_dout_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ads_dout_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --ads_dout_s1_in_a_write_cycle assignment, which is an e_assign
  ads_dout_s1_in_a_write_cycle <= internal_pipeline_bridge_m1_granted_ads_dout_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect));
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= ads_dout_s1_in_a_write_cycle;
  wait_for_ads_dout_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  pipeline_bridge_m1_granted_ads_dout_s1 <= internal_pipeline_bridge_m1_granted_ads_dout_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_qualified_request_ads_dout_s1 <= internal_pipeline_bridge_m1_qualified_request_ads_dout_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_requests_ads_dout_s1 <= internal_pipeline_bridge_m1_requests_ads_dout_s1;
--synthesis translate_off
    --ads_dout/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --pipeline_bridge/m1 non-zero burstcount assertion, which is an e_process
    process (clk)
    VARIABLE write_line3 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((internal_pipeline_bridge_m1_requests_ads_dout_s1 AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_burstcount))) = std_logic_vector'("00000000000000000000000000000000"))))) AND enable_nonzero_assertions)) = '1' then 
          write(write_line3, now);
          write(write_line3, string'(": "));
          write(write_line3, string'("pipeline_bridge/m1 drove 0 on its 'burstcount' port while accessing slave ads_dout/s1"));
          write(output, write_line3.all);
          deallocate (write_line3);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

library std;
use std.textio.all;

entity ads_ncs_s1_arbitrator is 
        port (
              -- inputs:
                 signal ads_ncs_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                 signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                 signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read : IN STD_LOGIC;
                 signal pipeline_bridge_m1_write : IN STD_LOGIC;
                 signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal ads_ncs_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ads_ncs_s1_chipselect : OUT STD_LOGIC;
                 signal ads_ncs_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ads_ncs_s1_reset_n : OUT STD_LOGIC;
                 signal ads_ncs_s1_write_n : OUT STD_LOGIC;
                 signal ads_ncs_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_ads_ncs_s1_end_xfer : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_granted_ads_ncs_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ads_ncs_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ads_ncs_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ads_ncs_s1 : OUT STD_LOGIC
              );
end entity ads_ncs_s1_arbitrator;


architecture europa of ads_ncs_s1_arbitrator is
                signal ads_ncs_s1_allgrants :  STD_LOGIC;
                signal ads_ncs_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal ads_ncs_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal ads_ncs_s1_any_continuerequest :  STD_LOGIC;
                signal ads_ncs_s1_arb_counter_enable :  STD_LOGIC;
                signal ads_ncs_s1_arb_share_counter :  STD_LOGIC;
                signal ads_ncs_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal ads_ncs_s1_arb_share_set_values :  STD_LOGIC;
                signal ads_ncs_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal ads_ncs_s1_begins_xfer :  STD_LOGIC;
                signal ads_ncs_s1_end_xfer :  STD_LOGIC;
                signal ads_ncs_s1_firsttransfer :  STD_LOGIC;
                signal ads_ncs_s1_grant_vector :  STD_LOGIC;
                signal ads_ncs_s1_in_a_read_cycle :  STD_LOGIC;
                signal ads_ncs_s1_in_a_write_cycle :  STD_LOGIC;
                signal ads_ncs_s1_master_qreq_vector :  STD_LOGIC;
                signal ads_ncs_s1_non_bursting_master_requests :  STD_LOGIC;
                signal ads_ncs_s1_reg_firsttransfer :  STD_LOGIC;
                signal ads_ncs_s1_slavearbiterlockenable :  STD_LOGIC;
                signal ads_ncs_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal ads_ncs_s1_unreg_firsttransfer :  STD_LOGIC;
                signal ads_ncs_s1_waits_for_read :  STD_LOGIC;
                signal ads_ncs_s1_waits_for_write :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_ads_ncs_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_granted_ads_ncs_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_qualified_request_ads_ncs_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_requests_ads_ncs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock2 :  STD_LOGIC;
                signal pipeline_bridge_m1_continuerequest :  STD_LOGIC;
                signal pipeline_bridge_m1_saved_grant_ads_ncs_s1 :  STD_LOGIC;
                signal shifted_address_to_ads_ncs_s1_from_pipeline_bridge_m1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal wait_for_ads_ncs_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT ads_ncs_s1_end_xfer;
    end if;

  end process;

  ads_ncs_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_pipeline_bridge_m1_qualified_request_ads_ncs_s1);
  --assign ads_ncs_s1_readdata_from_sa = ads_ncs_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  ads_ncs_s1_readdata_from_sa <= ads_ncs_s1_readdata;
  internal_pipeline_bridge_m1_requests_ads_ncs_s1 <= to_std_logic(((Std_Logic_Vector'(pipeline_bridge_m1_address_to_slave(7 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("01100000")))) AND pipeline_bridge_m1_chipselect;
  --ads_ncs_s1_arb_share_counter set values, which is an e_mux
  ads_ncs_s1_arb_share_set_values <= std_logic'('1');
  --ads_ncs_s1_non_bursting_master_requests mux, which is an e_mux
  ads_ncs_s1_non_bursting_master_requests <= internal_pipeline_bridge_m1_requests_ads_ncs_s1;
  --ads_ncs_s1_any_bursting_master_saved_grant mux, which is an e_mux
  ads_ncs_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --ads_ncs_s1_arb_share_counter_next_value assignment, which is an e_assign
  ads_ncs_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(ads_ncs_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ads_ncs_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(ads_ncs_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ads_ncs_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --ads_ncs_s1_allgrants all slave grants, which is an e_mux
  ads_ncs_s1_allgrants <= ads_ncs_s1_grant_vector;
  --ads_ncs_s1_end_xfer assignment, which is an e_assign
  ads_ncs_s1_end_xfer <= NOT ((ads_ncs_s1_waits_for_read OR ads_ncs_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_ads_ncs_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_ads_ncs_s1 <= ads_ncs_s1_end_xfer AND (((NOT ads_ncs_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --ads_ncs_s1_arb_share_counter arbitration counter enable, which is an e_assign
  ads_ncs_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_ads_ncs_s1 AND ads_ncs_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_ads_ncs_s1 AND NOT ads_ncs_s1_non_bursting_master_requests));
  --ads_ncs_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ads_ncs_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(ads_ncs_s1_arb_counter_enable) = '1' then 
        ads_ncs_s1_arb_share_counter <= ads_ncs_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --ads_ncs_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ads_ncs_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((ads_ncs_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_ads_ncs_s1)) OR ((end_xfer_arb_share_counter_term_ads_ncs_s1 AND NOT ads_ncs_s1_non_bursting_master_requests)))) = '1' then 
        ads_ncs_s1_slavearbiterlockenable <= ads_ncs_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pipeline_bridge/m1 ads_ncs/s1 arbiterlock, which is an e_assign
  pipeline_bridge_m1_arbiterlock <= ads_ncs_s1_slavearbiterlockenable AND pipeline_bridge_m1_continuerequest;
  --ads_ncs_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  ads_ncs_s1_slavearbiterlockenable2 <= ads_ncs_s1_arb_share_counter_next_value;
  --pipeline_bridge/m1 ads_ncs/s1 arbiterlock2, which is an e_assign
  pipeline_bridge_m1_arbiterlock2 <= ads_ncs_s1_slavearbiterlockenable2 AND pipeline_bridge_m1_continuerequest;
  --ads_ncs_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  ads_ncs_s1_any_continuerequest <= std_logic'('1');
  --pipeline_bridge_m1_continuerequest continued request, which is an e_assign
  pipeline_bridge_m1_continuerequest <= std_logic'('1');
  internal_pipeline_bridge_m1_qualified_request_ads_ncs_s1 <= internal_pipeline_bridge_m1_requests_ads_ncs_s1 AND NOT ((((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))))));
  --local readdatavalid pipeline_bridge_m1_read_data_valid_ads_ncs_s1, which is an e_mux
  pipeline_bridge_m1_read_data_valid_ads_ncs_s1 <= (internal_pipeline_bridge_m1_granted_ads_ncs_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect))) AND NOT ads_ncs_s1_waits_for_read;
  --ads_ncs_s1_writedata mux, which is an e_mux
  ads_ncs_s1_writedata <= pipeline_bridge_m1_writedata;
  --master is always granted when requested
  internal_pipeline_bridge_m1_granted_ads_ncs_s1 <= internal_pipeline_bridge_m1_qualified_request_ads_ncs_s1;
  --pipeline_bridge/m1 saved-grant ads_ncs/s1, which is an e_assign
  pipeline_bridge_m1_saved_grant_ads_ncs_s1 <= internal_pipeline_bridge_m1_requests_ads_ncs_s1;
  --allow new arb cycle for ads_ncs/s1, which is an e_assign
  ads_ncs_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  ads_ncs_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  ads_ncs_s1_master_qreq_vector <= std_logic'('1');
  --ads_ncs_s1_reset_n assignment, which is an e_assign
  ads_ncs_s1_reset_n <= reset_n;
  ads_ncs_s1_chipselect <= internal_pipeline_bridge_m1_granted_ads_ncs_s1;
  --ads_ncs_s1_firsttransfer first transaction, which is an e_assign
  ads_ncs_s1_firsttransfer <= A_WE_StdLogic((std_logic'(ads_ncs_s1_begins_xfer) = '1'), ads_ncs_s1_unreg_firsttransfer, ads_ncs_s1_reg_firsttransfer);
  --ads_ncs_s1_unreg_firsttransfer first transaction, which is an e_assign
  ads_ncs_s1_unreg_firsttransfer <= NOT ((ads_ncs_s1_slavearbiterlockenable AND ads_ncs_s1_any_continuerequest));
  --ads_ncs_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ads_ncs_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(ads_ncs_s1_begins_xfer) = '1' then 
        ads_ncs_s1_reg_firsttransfer <= ads_ncs_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --ads_ncs_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  ads_ncs_s1_beginbursttransfer_internal <= ads_ncs_s1_begins_xfer;
  --~ads_ncs_s1_write_n assignment, which is an e_mux
  ads_ncs_s1_write_n <= NOT ((internal_pipeline_bridge_m1_granted_ads_ncs_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect))));
  shifted_address_to_ads_ncs_s1_from_pipeline_bridge_m1 <= pipeline_bridge_m1_address_to_slave;
  --ads_ncs_s1_address mux, which is an e_mux
  ads_ncs_s1_address <= A_EXT (A_SRL(shifted_address_to_ads_ncs_s1_from_pipeline_bridge_m1,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_ads_ncs_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_ads_ncs_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_ads_ncs_s1_end_xfer <= ads_ncs_s1_end_xfer;
    end if;

  end process;

  --ads_ncs_s1_waits_for_read in a cycle, which is an e_mux
  ads_ncs_s1_waits_for_read <= ads_ncs_s1_in_a_read_cycle AND ads_ncs_s1_begins_xfer;
  --ads_ncs_s1_in_a_read_cycle assignment, which is an e_assign
  ads_ncs_s1_in_a_read_cycle <= internal_pipeline_bridge_m1_granted_ads_ncs_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= ads_ncs_s1_in_a_read_cycle;
  --ads_ncs_s1_waits_for_write in a cycle, which is an e_mux
  ads_ncs_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ads_ncs_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --ads_ncs_s1_in_a_write_cycle assignment, which is an e_assign
  ads_ncs_s1_in_a_write_cycle <= internal_pipeline_bridge_m1_granted_ads_ncs_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect));
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= ads_ncs_s1_in_a_write_cycle;
  wait_for_ads_ncs_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  pipeline_bridge_m1_granted_ads_ncs_s1 <= internal_pipeline_bridge_m1_granted_ads_ncs_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_qualified_request_ads_ncs_s1 <= internal_pipeline_bridge_m1_qualified_request_ads_ncs_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_requests_ads_ncs_s1 <= internal_pipeline_bridge_m1_requests_ads_ncs_s1;
--synthesis translate_off
    --ads_ncs/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --pipeline_bridge/m1 non-zero burstcount assertion, which is an e_process
    process (clk)
    VARIABLE write_line4 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((internal_pipeline_bridge_m1_requests_ads_ncs_s1 AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_burstcount))) = std_logic_vector'("00000000000000000000000000000000"))))) AND enable_nonzero_assertions)) = '1' then 
          write(write_line4, now);
          write(write_line4, string'(": "));
          write(write_line4, string'("pipeline_bridge/m1 drove 0 on its 'burstcount' port while accessing slave ads_ncs/s1"));
          write(output, write_line4.all);
          deallocate (write_line4);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

library std;
use std.textio.all;

entity ads_nirq_s1_arbitrator is 
        port (
              -- inputs:
                 signal ads_nirq_s1_irq : IN STD_LOGIC;
                 signal ads_nirq_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                 signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                 signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read : IN STD_LOGIC;
                 signal pipeline_bridge_m1_write : IN STD_LOGIC;
                 signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal ads_nirq_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ads_nirq_s1_chipselect : OUT STD_LOGIC;
                 signal ads_nirq_s1_irq_from_sa : OUT STD_LOGIC;
                 signal ads_nirq_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ads_nirq_s1_reset_n : OUT STD_LOGIC;
                 signal ads_nirq_s1_write_n : OUT STD_LOGIC;
                 signal ads_nirq_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_ads_nirq_s1_end_xfer : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_granted_ads_nirq_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ads_nirq_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ads_nirq_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ads_nirq_s1 : OUT STD_LOGIC
              );
end entity ads_nirq_s1_arbitrator;


architecture europa of ads_nirq_s1_arbitrator is
                signal ads_nirq_s1_allgrants :  STD_LOGIC;
                signal ads_nirq_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal ads_nirq_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal ads_nirq_s1_any_continuerequest :  STD_LOGIC;
                signal ads_nirq_s1_arb_counter_enable :  STD_LOGIC;
                signal ads_nirq_s1_arb_share_counter :  STD_LOGIC;
                signal ads_nirq_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal ads_nirq_s1_arb_share_set_values :  STD_LOGIC;
                signal ads_nirq_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal ads_nirq_s1_begins_xfer :  STD_LOGIC;
                signal ads_nirq_s1_end_xfer :  STD_LOGIC;
                signal ads_nirq_s1_firsttransfer :  STD_LOGIC;
                signal ads_nirq_s1_grant_vector :  STD_LOGIC;
                signal ads_nirq_s1_in_a_read_cycle :  STD_LOGIC;
                signal ads_nirq_s1_in_a_write_cycle :  STD_LOGIC;
                signal ads_nirq_s1_master_qreq_vector :  STD_LOGIC;
                signal ads_nirq_s1_non_bursting_master_requests :  STD_LOGIC;
                signal ads_nirq_s1_reg_firsttransfer :  STD_LOGIC;
                signal ads_nirq_s1_slavearbiterlockenable :  STD_LOGIC;
                signal ads_nirq_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal ads_nirq_s1_unreg_firsttransfer :  STD_LOGIC;
                signal ads_nirq_s1_waits_for_read :  STD_LOGIC;
                signal ads_nirq_s1_waits_for_write :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_ads_nirq_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_granted_ads_nirq_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_qualified_request_ads_nirq_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_requests_ads_nirq_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock2 :  STD_LOGIC;
                signal pipeline_bridge_m1_continuerequest :  STD_LOGIC;
                signal pipeline_bridge_m1_saved_grant_ads_nirq_s1 :  STD_LOGIC;
                signal shifted_address_to_ads_nirq_s1_from_pipeline_bridge_m1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal wait_for_ads_nirq_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT ads_nirq_s1_end_xfer;
    end if;

  end process;

  ads_nirq_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_pipeline_bridge_m1_qualified_request_ads_nirq_s1);
  --assign ads_nirq_s1_readdata_from_sa = ads_nirq_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  ads_nirq_s1_readdata_from_sa <= ads_nirq_s1_readdata;
  internal_pipeline_bridge_m1_requests_ads_nirq_s1 <= to_std_logic(((Std_Logic_Vector'(pipeline_bridge_m1_address_to_slave(7 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("10100000")))) AND pipeline_bridge_m1_chipselect;
  --ads_nirq_s1_arb_share_counter set values, which is an e_mux
  ads_nirq_s1_arb_share_set_values <= std_logic'('1');
  --ads_nirq_s1_non_bursting_master_requests mux, which is an e_mux
  ads_nirq_s1_non_bursting_master_requests <= internal_pipeline_bridge_m1_requests_ads_nirq_s1;
  --ads_nirq_s1_any_bursting_master_saved_grant mux, which is an e_mux
  ads_nirq_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --ads_nirq_s1_arb_share_counter_next_value assignment, which is an e_assign
  ads_nirq_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(ads_nirq_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ads_nirq_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(ads_nirq_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ads_nirq_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --ads_nirq_s1_allgrants all slave grants, which is an e_mux
  ads_nirq_s1_allgrants <= ads_nirq_s1_grant_vector;
  --ads_nirq_s1_end_xfer assignment, which is an e_assign
  ads_nirq_s1_end_xfer <= NOT ((ads_nirq_s1_waits_for_read OR ads_nirq_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_ads_nirq_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_ads_nirq_s1 <= ads_nirq_s1_end_xfer AND (((NOT ads_nirq_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --ads_nirq_s1_arb_share_counter arbitration counter enable, which is an e_assign
  ads_nirq_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_ads_nirq_s1 AND ads_nirq_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_ads_nirq_s1 AND NOT ads_nirq_s1_non_bursting_master_requests));
  --ads_nirq_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ads_nirq_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(ads_nirq_s1_arb_counter_enable) = '1' then 
        ads_nirq_s1_arb_share_counter <= ads_nirq_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --ads_nirq_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ads_nirq_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((ads_nirq_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_ads_nirq_s1)) OR ((end_xfer_arb_share_counter_term_ads_nirq_s1 AND NOT ads_nirq_s1_non_bursting_master_requests)))) = '1' then 
        ads_nirq_s1_slavearbiterlockenable <= ads_nirq_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pipeline_bridge/m1 ads_nirq/s1 arbiterlock, which is an e_assign
  pipeline_bridge_m1_arbiterlock <= ads_nirq_s1_slavearbiterlockenable AND pipeline_bridge_m1_continuerequest;
  --ads_nirq_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  ads_nirq_s1_slavearbiterlockenable2 <= ads_nirq_s1_arb_share_counter_next_value;
  --pipeline_bridge/m1 ads_nirq/s1 arbiterlock2, which is an e_assign
  pipeline_bridge_m1_arbiterlock2 <= ads_nirq_s1_slavearbiterlockenable2 AND pipeline_bridge_m1_continuerequest;
  --ads_nirq_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  ads_nirq_s1_any_continuerequest <= std_logic'('1');
  --pipeline_bridge_m1_continuerequest continued request, which is an e_assign
  pipeline_bridge_m1_continuerequest <= std_logic'('1');
  internal_pipeline_bridge_m1_qualified_request_ads_nirq_s1 <= internal_pipeline_bridge_m1_requests_ads_nirq_s1 AND NOT ((((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))))));
  --local readdatavalid pipeline_bridge_m1_read_data_valid_ads_nirq_s1, which is an e_mux
  pipeline_bridge_m1_read_data_valid_ads_nirq_s1 <= (internal_pipeline_bridge_m1_granted_ads_nirq_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect))) AND NOT ads_nirq_s1_waits_for_read;
  --ads_nirq_s1_writedata mux, which is an e_mux
  ads_nirq_s1_writedata <= pipeline_bridge_m1_writedata;
  --master is always granted when requested
  internal_pipeline_bridge_m1_granted_ads_nirq_s1 <= internal_pipeline_bridge_m1_qualified_request_ads_nirq_s1;
  --pipeline_bridge/m1 saved-grant ads_nirq/s1, which is an e_assign
  pipeline_bridge_m1_saved_grant_ads_nirq_s1 <= internal_pipeline_bridge_m1_requests_ads_nirq_s1;
  --allow new arb cycle for ads_nirq/s1, which is an e_assign
  ads_nirq_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  ads_nirq_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  ads_nirq_s1_master_qreq_vector <= std_logic'('1');
  --ads_nirq_s1_reset_n assignment, which is an e_assign
  ads_nirq_s1_reset_n <= reset_n;
  ads_nirq_s1_chipselect <= internal_pipeline_bridge_m1_granted_ads_nirq_s1;
  --ads_nirq_s1_firsttransfer first transaction, which is an e_assign
  ads_nirq_s1_firsttransfer <= A_WE_StdLogic((std_logic'(ads_nirq_s1_begins_xfer) = '1'), ads_nirq_s1_unreg_firsttransfer, ads_nirq_s1_reg_firsttransfer);
  --ads_nirq_s1_unreg_firsttransfer first transaction, which is an e_assign
  ads_nirq_s1_unreg_firsttransfer <= NOT ((ads_nirq_s1_slavearbiterlockenable AND ads_nirq_s1_any_continuerequest));
  --ads_nirq_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ads_nirq_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(ads_nirq_s1_begins_xfer) = '1' then 
        ads_nirq_s1_reg_firsttransfer <= ads_nirq_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --ads_nirq_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  ads_nirq_s1_beginbursttransfer_internal <= ads_nirq_s1_begins_xfer;
  --~ads_nirq_s1_write_n assignment, which is an e_mux
  ads_nirq_s1_write_n <= NOT ((internal_pipeline_bridge_m1_granted_ads_nirq_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect))));
  shifted_address_to_ads_nirq_s1_from_pipeline_bridge_m1 <= pipeline_bridge_m1_address_to_slave;
  --ads_nirq_s1_address mux, which is an e_mux
  ads_nirq_s1_address <= A_EXT (A_SRL(shifted_address_to_ads_nirq_s1_from_pipeline_bridge_m1,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_ads_nirq_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_ads_nirq_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_ads_nirq_s1_end_xfer <= ads_nirq_s1_end_xfer;
    end if;

  end process;

  --ads_nirq_s1_waits_for_read in a cycle, which is an e_mux
  ads_nirq_s1_waits_for_read <= ads_nirq_s1_in_a_read_cycle AND ads_nirq_s1_begins_xfer;
  --ads_nirq_s1_in_a_read_cycle assignment, which is an e_assign
  ads_nirq_s1_in_a_read_cycle <= internal_pipeline_bridge_m1_granted_ads_nirq_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= ads_nirq_s1_in_a_read_cycle;
  --ads_nirq_s1_waits_for_write in a cycle, which is an e_mux
  ads_nirq_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ads_nirq_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --ads_nirq_s1_in_a_write_cycle assignment, which is an e_assign
  ads_nirq_s1_in_a_write_cycle <= internal_pipeline_bridge_m1_granted_ads_nirq_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect));
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= ads_nirq_s1_in_a_write_cycle;
  wait_for_ads_nirq_s1_counter <= std_logic'('0');
  --assign ads_nirq_s1_irq_from_sa = ads_nirq_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  ads_nirq_s1_irq_from_sa <= ads_nirq_s1_irq;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_granted_ads_nirq_s1 <= internal_pipeline_bridge_m1_granted_ads_nirq_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_qualified_request_ads_nirq_s1 <= internal_pipeline_bridge_m1_qualified_request_ads_nirq_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_requests_ads_nirq_s1 <= internal_pipeline_bridge_m1_requests_ads_nirq_s1;
--synthesis translate_off
    --ads_nirq/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --pipeline_bridge/m1 non-zero burstcount assertion, which is an e_process
    process (clk)
    VARIABLE write_line5 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((internal_pipeline_bridge_m1_requests_ads_nirq_s1 AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_burstcount))) = std_logic_vector'("00000000000000000000000000000000"))))) AND enable_nonzero_assertions)) = '1' then 
          write(write_line5, now);
          write(write_line5, string'(": "));
          write(write_line5, string'("pipeline_bridge/m1 drove 0 on its 'burstcount' port while accessing slave ads_nirq/s1"));
          write(output, write_line5.all);
          deallocate (write_line5);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

library std;
use std.textio.all;

entity cpu_jtag_debug_module_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_data_master_debugaccess : IN STD_LOGIC;
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_instruction_master_latency_counter : IN STD_LOGIC;
                 signal cpu_instruction_master_read : IN STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register : IN STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_sdram_s1_shift_register : IN STD_LOGIC;
                 signal cpu_jtag_debug_module_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_jtag_debug_module_resetrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_data_master_requests_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_instruction_master_granted_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_instruction_master_requests_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_address : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                 signal cpu_jtag_debug_module_begintransfer : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_jtag_debug_module_chipselect : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_debugaccess : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_jtag_debug_module_reset_n : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_resetrequest_from_sa : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_write : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_cpu_jtag_debug_module_end_xfer : OUT STD_LOGIC
              );
end entity cpu_jtag_debug_module_arbitrator;


architecture europa of cpu_jtag_debug_module_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_instruction_master_continuerequest :  STD_LOGIC;
                signal cpu_instruction_master_saved_grant_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_jtag_debug_module_allgrants :  STD_LOGIC;
                signal cpu_jtag_debug_module_allow_new_arb_cycle :  STD_LOGIC;
                signal cpu_jtag_debug_module_any_bursting_master_saved_grant :  STD_LOGIC;
                signal cpu_jtag_debug_module_any_continuerequest :  STD_LOGIC;
                signal cpu_jtag_debug_module_arb_addend :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_arb_counter_enable :  STD_LOGIC;
                signal cpu_jtag_debug_module_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_arb_winner :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_arbitration_holdoff_internal :  STD_LOGIC;
                signal cpu_jtag_debug_module_beginbursttransfer_internal :  STD_LOGIC;
                signal cpu_jtag_debug_module_begins_xfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_chosen_master_double_vector :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_jtag_debug_module_chosen_master_rot_left :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_end_xfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_firsttransfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_grant_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_in_a_read_cycle :  STD_LOGIC;
                signal cpu_jtag_debug_module_in_a_write_cycle :  STD_LOGIC;
                signal cpu_jtag_debug_module_master_qreq_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_non_bursting_master_requests :  STD_LOGIC;
                signal cpu_jtag_debug_module_reg_firsttransfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_saved_chosen_master_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_slavearbiterlockenable :  STD_LOGIC;
                signal cpu_jtag_debug_module_slavearbiterlockenable2 :  STD_LOGIC;
                signal cpu_jtag_debug_module_unreg_firsttransfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_waits_for_read :  STD_LOGIC;
                signal cpu_jtag_debug_module_waits_for_write :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_cpu_jtag_debug_module :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_data_master_requests_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_instruction_master_granted_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_instruction_master_requests_cpu_jtag_debug_module :  STD_LOGIC;
                signal last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module :  STD_LOGIC;
                signal last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module :  STD_LOGIC;
                signal shifted_address_to_cpu_jtag_debug_module_from_cpu_data_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal shifted_address_to_cpu_jtag_debug_module_from_cpu_instruction_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal wait_for_cpu_jtag_debug_module_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT cpu_jtag_debug_module_end_xfer;
    end if;

  end process;

  cpu_jtag_debug_module_begins_xfer <= NOT d1_reasons_to_wait AND ((internal_cpu_data_master_qualified_request_cpu_jtag_debug_module OR internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module));
  --assign cpu_jtag_debug_module_readdata_from_sa = cpu_jtag_debug_module_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  cpu_jtag_debug_module_readdata_from_sa <= cpu_jtag_debug_module_readdata;
  internal_cpu_data_master_requests_cpu_jtag_debug_module <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(25 DOWNTO 11) & std_logic_vector'("00000000000")) = std_logic_vector'("00000000000001000000000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --cpu_jtag_debug_module_arb_share_counter set values, which is an e_mux
  cpu_jtag_debug_module_arb_share_set_values <= std_logic_vector'("01");
  --cpu_jtag_debug_module_non_bursting_master_requests mux, which is an e_mux
  cpu_jtag_debug_module_non_bursting_master_requests <= ((internal_cpu_data_master_requests_cpu_jtag_debug_module OR internal_cpu_instruction_master_requests_cpu_jtag_debug_module) OR internal_cpu_data_master_requests_cpu_jtag_debug_module) OR internal_cpu_instruction_master_requests_cpu_jtag_debug_module;
  --cpu_jtag_debug_module_any_bursting_master_saved_grant mux, which is an e_mux
  cpu_jtag_debug_module_any_bursting_master_saved_grant <= std_logic'('0');
  --cpu_jtag_debug_module_arb_share_counter_next_value assignment, which is an e_assign
  cpu_jtag_debug_module_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(cpu_jtag_debug_module_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (cpu_jtag_debug_module_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(cpu_jtag_debug_module_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (cpu_jtag_debug_module_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --cpu_jtag_debug_module_allgrants all slave grants, which is an e_mux
  cpu_jtag_debug_module_allgrants <= (((or_reduce(cpu_jtag_debug_module_grant_vector)) OR (or_reduce(cpu_jtag_debug_module_grant_vector))) OR (or_reduce(cpu_jtag_debug_module_grant_vector))) OR (or_reduce(cpu_jtag_debug_module_grant_vector));
  --cpu_jtag_debug_module_end_xfer assignment, which is an e_assign
  cpu_jtag_debug_module_end_xfer <= NOT ((cpu_jtag_debug_module_waits_for_read OR cpu_jtag_debug_module_waits_for_write));
  --end_xfer_arb_share_counter_term_cpu_jtag_debug_module arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_cpu_jtag_debug_module <= cpu_jtag_debug_module_end_xfer AND (((NOT cpu_jtag_debug_module_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --cpu_jtag_debug_module_arb_share_counter arbitration counter enable, which is an e_assign
  cpu_jtag_debug_module_arb_counter_enable <= ((end_xfer_arb_share_counter_term_cpu_jtag_debug_module AND cpu_jtag_debug_module_allgrants)) OR ((end_xfer_arb_share_counter_term_cpu_jtag_debug_module AND NOT cpu_jtag_debug_module_non_bursting_master_requests));
  --cpu_jtag_debug_module_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_jtag_debug_module_arb_counter_enable) = '1' then 
        cpu_jtag_debug_module_arb_share_counter <= cpu_jtag_debug_module_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu_jtag_debug_module_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((or_reduce(cpu_jtag_debug_module_master_qreq_vector) AND end_xfer_arb_share_counter_term_cpu_jtag_debug_module)) OR ((end_xfer_arb_share_counter_term_cpu_jtag_debug_module AND NOT cpu_jtag_debug_module_non_bursting_master_requests)))) = '1' then 
        cpu_jtag_debug_module_slavearbiterlockenable <= or_reduce(cpu_jtag_debug_module_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu/data_master cpu/jtag_debug_module arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= cpu_jtag_debug_module_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --cpu_jtag_debug_module_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  cpu_jtag_debug_module_slavearbiterlockenable2 <= or_reduce(cpu_jtag_debug_module_arb_share_counter_next_value);
  --cpu/data_master cpu/jtag_debug_module arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= cpu_jtag_debug_module_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --cpu/instruction_master cpu/jtag_debug_module arbiterlock, which is an e_assign
  cpu_instruction_master_arbiterlock <= cpu_jtag_debug_module_slavearbiterlockenable AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master cpu/jtag_debug_module arbiterlock2, which is an e_assign
  cpu_instruction_master_arbiterlock2 <= cpu_jtag_debug_module_slavearbiterlockenable2 AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master granted cpu/jtag_debug_module last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_instruction_master_saved_grant_cpu_jtag_debug_module) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((cpu_jtag_debug_module_arbitration_holdoff_internal OR NOT internal_cpu_instruction_master_requests_cpu_jtag_debug_module))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module))))));
    end if;

  end process;

  --cpu_instruction_master_continuerequest continued request, which is an e_mux
  cpu_instruction_master_continuerequest <= last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module AND internal_cpu_instruction_master_requests_cpu_jtag_debug_module;
  --cpu_jtag_debug_module_any_continuerequest at least one master continues requesting, which is an e_mux
  cpu_jtag_debug_module_any_continuerequest <= cpu_instruction_master_continuerequest OR cpu_data_master_continuerequest;
  internal_cpu_data_master_qualified_request_cpu_jtag_debug_module <= internal_cpu_data_master_requests_cpu_jtag_debug_module AND NOT (((((NOT cpu_data_master_waitrequest) AND cpu_data_master_write)) OR cpu_instruction_master_arbiterlock));
  --cpu_jtag_debug_module_writedata mux, which is an e_mux
  cpu_jtag_debug_module_writedata <= cpu_data_master_writedata;
  internal_cpu_instruction_master_requests_cpu_jtag_debug_module <= ((to_std_logic(((Std_Logic_Vector'(cpu_instruction_master_address_to_slave(25 DOWNTO 11) & std_logic_vector'("00000000000")) = std_logic_vector'("00000000000001000000000000")))) AND (cpu_instruction_master_read))) AND cpu_instruction_master_read;
  --cpu/data_master granted cpu/jtag_debug_module last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_data_master_saved_grant_cpu_jtag_debug_module) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((cpu_jtag_debug_module_arbitration_holdoff_internal OR NOT internal_cpu_data_master_requests_cpu_jtag_debug_module))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module))))));
    end if;

  end process;

  --cpu_data_master_continuerequest continued request, which is an e_mux
  cpu_data_master_continuerequest <= last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module AND internal_cpu_data_master_requests_cpu_jtag_debug_module;
  internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module <= internal_cpu_instruction_master_requests_cpu_jtag_debug_module AND NOT ((((cpu_instruction_master_read AND (((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000")))) OR (cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register)) OR (cpu_instruction_master_read_data_valid_sdram_s1_shift_register))))) OR cpu_data_master_arbiterlock));
  --local readdatavalid cpu_instruction_master_read_data_valid_cpu_jtag_debug_module, which is an e_mux
  cpu_instruction_master_read_data_valid_cpu_jtag_debug_module <= (internal_cpu_instruction_master_granted_cpu_jtag_debug_module AND cpu_instruction_master_read) AND NOT cpu_jtag_debug_module_waits_for_read;
  --allow new arb cycle for cpu/jtag_debug_module, which is an e_assign
  cpu_jtag_debug_module_allow_new_arb_cycle <= NOT cpu_data_master_arbiterlock AND NOT cpu_instruction_master_arbiterlock;
  --cpu/instruction_master assignment into master qualified-requests vector for cpu/jtag_debug_module, which is an e_assign
  cpu_jtag_debug_module_master_qreq_vector(0) <= internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module;
  --cpu/instruction_master grant cpu/jtag_debug_module, which is an e_assign
  internal_cpu_instruction_master_granted_cpu_jtag_debug_module <= cpu_jtag_debug_module_grant_vector(0);
  --cpu/instruction_master saved-grant cpu/jtag_debug_module, which is an e_assign
  cpu_instruction_master_saved_grant_cpu_jtag_debug_module <= cpu_jtag_debug_module_arb_winner(0) AND internal_cpu_instruction_master_requests_cpu_jtag_debug_module;
  --cpu/data_master assignment into master qualified-requests vector for cpu/jtag_debug_module, which is an e_assign
  cpu_jtag_debug_module_master_qreq_vector(1) <= internal_cpu_data_master_qualified_request_cpu_jtag_debug_module;
  --cpu/data_master grant cpu/jtag_debug_module, which is an e_assign
  internal_cpu_data_master_granted_cpu_jtag_debug_module <= cpu_jtag_debug_module_grant_vector(1);
  --cpu/data_master saved-grant cpu/jtag_debug_module, which is an e_assign
  cpu_data_master_saved_grant_cpu_jtag_debug_module <= cpu_jtag_debug_module_arb_winner(1) AND internal_cpu_data_master_requests_cpu_jtag_debug_module;
  --cpu/jtag_debug_module chosen-master double-vector, which is an e_assign
  cpu_jtag_debug_module_chosen_master_double_vector <= A_EXT (((std_logic_vector'("0") & ((cpu_jtag_debug_module_master_qreq_vector & cpu_jtag_debug_module_master_qreq_vector))) AND (((std_logic_vector'("0") & (Std_Logic_Vector'(NOT cpu_jtag_debug_module_master_qreq_vector & NOT cpu_jtag_debug_module_master_qreq_vector))) + (std_logic_vector'("000") & (cpu_jtag_debug_module_arb_addend))))), 4);
  --stable onehot encoding of arb winner
  cpu_jtag_debug_module_arb_winner <= A_WE_StdLogicVector((std_logic'(((cpu_jtag_debug_module_allow_new_arb_cycle AND or_reduce(cpu_jtag_debug_module_grant_vector)))) = '1'), cpu_jtag_debug_module_grant_vector, cpu_jtag_debug_module_saved_chosen_master_vector);
  --saved cpu_jtag_debug_module_grant_vector, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_saved_chosen_master_vector <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_jtag_debug_module_allow_new_arb_cycle) = '1' then 
        cpu_jtag_debug_module_saved_chosen_master_vector <= A_WE_StdLogicVector((std_logic'(or_reduce(cpu_jtag_debug_module_grant_vector)) = '1'), cpu_jtag_debug_module_grant_vector, cpu_jtag_debug_module_saved_chosen_master_vector);
      end if;
    end if;

  end process;

  --onehot encoding of chosen master
  cpu_jtag_debug_module_grant_vector <= Std_Logic_Vector'(A_ToStdLogicVector(((cpu_jtag_debug_module_chosen_master_double_vector(1) OR cpu_jtag_debug_module_chosen_master_double_vector(3)))) & A_ToStdLogicVector(((cpu_jtag_debug_module_chosen_master_double_vector(0) OR cpu_jtag_debug_module_chosen_master_double_vector(2)))));
  --cpu/jtag_debug_module chosen master rotated left, which is an e_assign
  cpu_jtag_debug_module_chosen_master_rot_left <= A_EXT (A_WE_StdLogicVector((((A_SLL(cpu_jtag_debug_module_arb_winner,std_logic_vector'("00000000000000000000000000000001")))) /= std_logic_vector'("00")), (std_logic_vector'("000000000000000000000000000000") & ((A_SLL(cpu_jtag_debug_module_arb_winner,std_logic_vector'("00000000000000000000000000000001"))))), std_logic_vector'("00000000000000000000000000000001")), 2);
  --cpu/jtag_debug_module's addend for next-master-grant
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_arb_addend <= std_logic_vector'("01");
    elsif clk'event and clk = '1' then
      if std_logic'(or_reduce(cpu_jtag_debug_module_grant_vector)) = '1' then 
        cpu_jtag_debug_module_arb_addend <= A_WE_StdLogicVector((std_logic'(cpu_jtag_debug_module_end_xfer) = '1'), cpu_jtag_debug_module_chosen_master_rot_left, cpu_jtag_debug_module_grant_vector);
      end if;
    end if;

  end process;

  cpu_jtag_debug_module_begintransfer <= cpu_jtag_debug_module_begins_xfer;
  --cpu_jtag_debug_module_reset_n assignment, which is an e_assign
  cpu_jtag_debug_module_reset_n <= reset_n;
  --assign cpu_jtag_debug_module_resetrequest_from_sa = cpu_jtag_debug_module_resetrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  cpu_jtag_debug_module_resetrequest_from_sa <= cpu_jtag_debug_module_resetrequest;
  cpu_jtag_debug_module_chipselect <= internal_cpu_data_master_granted_cpu_jtag_debug_module OR internal_cpu_instruction_master_granted_cpu_jtag_debug_module;
  --cpu_jtag_debug_module_firsttransfer first transaction, which is an e_assign
  cpu_jtag_debug_module_firsttransfer <= A_WE_StdLogic((std_logic'(cpu_jtag_debug_module_begins_xfer) = '1'), cpu_jtag_debug_module_unreg_firsttransfer, cpu_jtag_debug_module_reg_firsttransfer);
  --cpu_jtag_debug_module_unreg_firsttransfer first transaction, which is an e_assign
  cpu_jtag_debug_module_unreg_firsttransfer <= NOT ((cpu_jtag_debug_module_slavearbiterlockenable AND cpu_jtag_debug_module_any_continuerequest));
  --cpu_jtag_debug_module_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_jtag_debug_module_begins_xfer) = '1' then 
        cpu_jtag_debug_module_reg_firsttransfer <= cpu_jtag_debug_module_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --cpu_jtag_debug_module_beginbursttransfer_internal begin burst transfer, which is an e_assign
  cpu_jtag_debug_module_beginbursttransfer_internal <= cpu_jtag_debug_module_begins_xfer;
  --cpu_jtag_debug_module_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  cpu_jtag_debug_module_arbitration_holdoff_internal <= cpu_jtag_debug_module_begins_xfer AND cpu_jtag_debug_module_firsttransfer;
  --cpu_jtag_debug_module_write assignment, which is an e_mux
  cpu_jtag_debug_module_write <= internal_cpu_data_master_granted_cpu_jtag_debug_module AND cpu_data_master_write;
  shifted_address_to_cpu_jtag_debug_module_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --cpu_jtag_debug_module_address mux, which is an e_mux
  cpu_jtag_debug_module_address <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_cpu_jtag_debug_module)) = '1'), (A_SRL(shifted_address_to_cpu_jtag_debug_module_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010"))), (A_SRL(shifted_address_to_cpu_jtag_debug_module_from_cpu_instruction_master,std_logic_vector'("00000000000000000000000000000010")))), 9);
  shifted_address_to_cpu_jtag_debug_module_from_cpu_instruction_master <= cpu_instruction_master_address_to_slave;
  --d1_cpu_jtag_debug_module_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_cpu_jtag_debug_module_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_cpu_jtag_debug_module_end_xfer <= cpu_jtag_debug_module_end_xfer;
    end if;

  end process;

  --cpu_jtag_debug_module_waits_for_read in a cycle, which is an e_mux
  cpu_jtag_debug_module_waits_for_read <= cpu_jtag_debug_module_in_a_read_cycle AND cpu_jtag_debug_module_begins_xfer;
  --cpu_jtag_debug_module_in_a_read_cycle assignment, which is an e_assign
  cpu_jtag_debug_module_in_a_read_cycle <= ((internal_cpu_data_master_granted_cpu_jtag_debug_module AND cpu_data_master_read)) OR ((internal_cpu_instruction_master_granted_cpu_jtag_debug_module AND cpu_instruction_master_read));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= cpu_jtag_debug_module_in_a_read_cycle;
  --cpu_jtag_debug_module_waits_for_write in a cycle, which is an e_mux
  cpu_jtag_debug_module_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_jtag_debug_module_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --cpu_jtag_debug_module_in_a_write_cycle assignment, which is an e_assign
  cpu_jtag_debug_module_in_a_write_cycle <= internal_cpu_data_master_granted_cpu_jtag_debug_module AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= cpu_jtag_debug_module_in_a_write_cycle;
  wait_for_cpu_jtag_debug_module_counter <= std_logic'('0');
  --cpu_jtag_debug_module_byteenable byte enable port mux, which is an e_mux
  cpu_jtag_debug_module_byteenable <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_cpu_jtag_debug_module)) = '1'), (std_logic_vector'("0000000000000000000000000000") & (cpu_data_master_byteenable)), -SIGNED(std_logic_vector'("00000000000000000000000000000001"))), 4);
  --debugaccess mux, which is an e_mux
  cpu_jtag_debug_module_debugaccess <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_cpu_jtag_debug_module)) = '1'), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_debugaccess))), std_logic_vector'("00000000000000000000000000000000")));
  --vhdl renameroo for output signals
  cpu_data_master_granted_cpu_jtag_debug_module <= internal_cpu_data_master_granted_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_cpu_jtag_debug_module <= internal_cpu_data_master_qualified_request_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_data_master_requests_cpu_jtag_debug_module <= internal_cpu_data_master_requests_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_instruction_master_granted_cpu_jtag_debug_module <= internal_cpu_instruction_master_granted_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_instruction_master_qualified_request_cpu_jtag_debug_module <= internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_instruction_master_requests_cpu_jtag_debug_module <= internal_cpu_instruction_master_requests_cpu_jtag_debug_module;
--synthesis translate_off
    --cpu/jtag_debug_module enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line6 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_data_master_granted_cpu_jtag_debug_module))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_instruction_master_granted_cpu_jtag_debug_module))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line6, now);
          write(write_line6, string'(": "));
          write(write_line6, string'("> 1 of grant signals are active simultaneously"));
          write(output, write_line6.all);
          deallocate (write_line6);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --saved_grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line7 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_data_master_saved_grant_cpu_jtag_debug_module))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_saved_grant_cpu_jtag_debug_module))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line7, now);
          write(write_line7, string'(": "));
          write(write_line7, string'("> 1 of saved_grant signals are active simultaneously"));
          write(output, write_line7.all);
          deallocate (write_line7);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

entity cpu_data_master_arbitrator is 
        port (
              -- inputs:
                 signal ads_nirq_s1_irq_from_sa : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_data_master_byteenable_sdram_s1 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_data_master_granted_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_data_master_granted_epcs_flash_controller_epcs_control_port : IN STD_LOGIC;
                 signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_pipeline_bridge_s1 : IN STD_LOGIC;
                 signal cpu_data_master_granted_sdram_s1 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_pipeline_bridge_s1 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_sdram_s1 : IN STD_LOGIC;
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_epcs_flash_controller_epcs_control_port : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_pipeline_bridge_s1 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_pipeline_bridge_s1_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_sdram_s1 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_sdram_s1_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_requests_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_data_master_requests_epcs_flash_controller_epcs_control_port : IN STD_LOGIC;
                 signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_pipeline_bridge_s1 : IN STD_LOGIC;
                 signal cpu_data_master_requests_sdram_s1 : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_cpu_jtag_debug_module_end_xfer : IN STD_LOGIC;
                 signal d1_epcs_flash_controller_epcs_control_port_end_xfer : IN STD_LOGIC;
                 signal d1_jtag_uart_avalon_jtag_slave_end_xfer : IN STD_LOGIC;
                 signal d1_pipeline_bridge_s1_end_xfer : IN STD_LOGIC;
                 signal d1_sdram_s1_end_xfer : IN STD_LOGIC;
                 signal epcs_flash_controller_epcs_control_port_irq_from_sa : IN STD_LOGIC;
                 signal epcs_flash_controller_epcs_control_port_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_avalon_jtag_slave_irq_from_sa : IN STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal pipeline_bridge_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_s1_waitrequest_from_sa : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sdram_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sdram_s1_waitrequest_from_sa : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_address_to_slave : OUT STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_data_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_data_master_dbs_write_16 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal cpu_data_master_irq : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_data_master_no_byte_enables_and_last_term : OUT STD_LOGIC;
                 signal cpu_data_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_data_master_waitrequest : OUT STD_LOGIC
              );
end entity cpu_data_master_arbitrator;


architecture europa of cpu_data_master_arbitrator is
                signal cpu_data_master_dbs_increment :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_data_master_run :  STD_LOGIC;
                signal dbs_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal dbs_count_enable :  STD_LOGIC;
                signal dbs_counter_overflow :  STD_LOGIC;
                signal internal_cpu_data_master_address_to_slave :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal internal_cpu_data_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_cpu_data_master_no_byte_enables_and_last_term :  STD_LOGIC;
                signal internal_cpu_data_master_waitrequest :  STD_LOGIC;
                signal last_dbs_term_and_run :  STD_LOGIC;
                signal next_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p1_dbs_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal p1_registered_cpu_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal pre_dbs_count_enable :  STD_LOGIC;
                signal r_1 :  STD_LOGIC;
                signal r_2 :  STD_LOGIC;
                signal r_3 :  STD_LOGIC;
                signal registered_cpu_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

  --r_1 master_run cascaded wait assignment, which is an e_assign
  r_1 <= Vector_To_Std_Logic((((((((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_data_master_requests_cpu_jtag_debug_module)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_granted_cpu_jtag_debug_module OR NOT cpu_data_master_qualified_request_cpu_jtag_debug_module)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port OR NOT cpu_data_master_requests_epcs_flash_controller_epcs_control_port)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_granted_epcs_flash_controller_epcs_control_port OR NOT cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))));
  --cascaded wait assignment, which is an e_assign
  cpu_data_master_run <= (r_1 AND r_2) AND r_3;
  --r_2 master_run cascaded wait assignment, which is an e_assign
  r_2 <= Vector_To_Std_Logic(((((((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave OR NOT cpu_data_master_requests_jtag_uart_avalon_jtag_slave)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT jtag_uart_avalon_jtag_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT jtag_uart_avalon_jtag_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_pipeline_bridge_s1 OR cpu_data_master_read_data_valid_pipeline_bridge_s1) OR NOT cpu_data_master_requests_pipeline_bridge_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_granted_pipeline_bridge_s1 OR NOT cpu_data_master_qualified_request_pipeline_bridge_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_pipeline_bridge_s1 OR NOT cpu_data_master_read) OR ((cpu_data_master_read_data_valid_pipeline_bridge_s1 AND cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_pipeline_bridge_s1 OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT pipeline_bridge_s1_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))));
  --r_3 master_run cascaded wait assignment, which is an e_assign
  r_3 <= Vector_To_Std_Logic(((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((((cpu_data_master_qualified_request_sdram_s1 OR ((cpu_data_master_read_data_valid_sdram_s1 AND internal_cpu_data_master_dbs_address(1)))) OR (((cpu_data_master_write AND NOT(or_reduce(cpu_data_master_byteenable_sdram_s1))) AND internal_cpu_data_master_dbs_address(1)))) OR NOT cpu_data_master_requests_sdram_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_granted_sdram_s1 OR NOT cpu_data_master_qualified_request_sdram_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_sdram_s1 OR NOT cpu_data_master_read) OR (((cpu_data_master_read_data_valid_sdram_s1 AND (internal_cpu_data_master_dbs_address(1))) AND cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_sdram_s1 OR NOT cpu_data_master_write)))) OR ((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT sdram_s1_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_data_master_dbs_address(1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))));
  --irq assign, which is an e_assign
  cpu_data_master_irq <= Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(ads_nirq_s1_irq_from_sa) & A_ToStdLogicVector(epcs_flash_controller_epcs_control_port_irq_from_sa) & A_ToStdLogicVector(jtag_uart_avalon_jtag_slave_irq_from_sa));
  --optimize select-logic by passing only those address bits which matter.
  internal_cpu_data_master_address_to_slave <= Std_Logic_Vector'(cpu_data_master_address(25 DOWNTO 24) & A_ToStdLogicVector(std_logic'('0')) & cpu_data_master_address(22 DOWNTO 0));
  --cpu/data_master readdata mux, which is an e_mux
  cpu_data_master_readdata <= (((((A_REP(NOT cpu_data_master_requests_cpu_jtag_debug_module, 32) OR cpu_jtag_debug_module_readdata_from_sa)) AND ((A_REP(NOT cpu_data_master_requests_epcs_flash_controller_epcs_control_port, 32) OR epcs_flash_controller_epcs_control_port_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_jtag_uart_avalon_jtag_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_pipeline_bridge_s1, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_sdram_s1, 32) OR registered_cpu_data_master_readdata));
  --actual waitrequest port, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_data_master_waitrequest <= Vector_To_Std_Logic(NOT std_logic_vector'("00000000000000000000000000000000"));
    elsif clk'event and clk = '1' then
      internal_cpu_data_master_waitrequest <= Vector_To_Std_Logic(NOT (A_WE_StdLogicVector((std_logic'((NOT ((cpu_data_master_read OR cpu_data_master_write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_run AND internal_cpu_data_master_waitrequest))))))));
    end if;

  end process;

  --unpredictable registered wait state incoming data, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      registered_cpu_data_master_readdata <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      registered_cpu_data_master_readdata <= p1_registered_cpu_data_master_readdata;
    end if;

  end process;

  --registered readdata mux, which is an e_mux
  p1_registered_cpu_data_master_readdata <= (((A_REP(NOT cpu_data_master_requests_jtag_uart_avalon_jtag_slave, 32) OR jtag_uart_avalon_jtag_slave_readdata_from_sa)) AND ((A_REP(NOT cpu_data_master_requests_pipeline_bridge_s1, 32) OR pipeline_bridge_s1_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_sdram_s1, 32) OR Std_Logic_Vector'(sdram_s1_readdata_from_sa(15 DOWNTO 0) & dbs_16_reg_segment_0)));
  --no_byte_enables_and_last_term, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_data_master_no_byte_enables_and_last_term <= std_logic'('0');
    elsif clk'event and clk = '1' then
      internal_cpu_data_master_no_byte_enables_and_last_term <= last_dbs_term_and_run;
    end if;

  end process;

  --compute the last dbs term, which is an e_mux
  last_dbs_term_and_run <= (to_std_logic(((internal_cpu_data_master_dbs_address = std_logic_vector'("10")))) AND cpu_data_master_write) AND NOT(or_reduce(cpu_data_master_byteenable_sdram_s1));
  --pre dbs count enable, which is an e_mux
  pre_dbs_count_enable <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((((((NOT internal_cpu_data_master_no_byte_enables_and_last_term) AND cpu_data_master_requests_sdram_s1) AND cpu_data_master_write) AND NOT(or_reduce(cpu_data_master_byteenable_sdram_s1)))) OR cpu_data_master_read_data_valid_sdram_s1)))) OR (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_data_master_granted_sdram_s1 AND cpu_data_master_write)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT sdram_s1_waitrequest_from_sa)))))));
  --input to dbs-16 stored 0, which is an e_mux
  p1_dbs_16_reg_segment_0 <= sdram_s1_readdata_from_sa;
  --dbs register for dbs-16 segment 0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dbs_16_reg_segment_0 <= std_logic_vector'("0000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((dbs_count_enable AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_data_master_dbs_address(1))))) = std_logic_vector'("00000000000000000000000000000000")))))) = '1' then 
        dbs_16_reg_segment_0 <= p1_dbs_16_reg_segment_0;
      end if;
    end if;

  end process;

  --mux write dbs 1, which is an e_mux
  cpu_data_master_dbs_write_16 <= A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_dbs_address(1))) = '1'), cpu_data_master_writedata(31 DOWNTO 16), cpu_data_master_writedata(15 DOWNTO 0));
  --dbs count increment, which is an e_mux
  cpu_data_master_dbs_increment <= A_EXT (A_WE_StdLogicVector((std_logic'((cpu_data_master_requests_sdram_s1)) = '1'), std_logic_vector'("00000000000000000000000000000010"), std_logic_vector'("00000000000000000000000000000000")), 2);
  --dbs counter overflow, which is an e_assign
  dbs_counter_overflow <= internal_cpu_data_master_dbs_address(1) AND NOT((next_dbs_address(1)));
  --next master address, which is an e_assign
  next_dbs_address <= A_EXT (((std_logic_vector'("0") & (internal_cpu_data_master_dbs_address)) + (std_logic_vector'("0") & (cpu_data_master_dbs_increment))), 2);
  --dbs count enable, which is an e_mux
  dbs_count_enable <= pre_dbs_count_enable AND (NOT ((cpu_data_master_requests_sdram_s1 AND NOT internal_cpu_data_master_waitrequest)));
  --dbs counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_data_master_dbs_address <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(dbs_count_enable) = '1' then 
        internal_cpu_data_master_dbs_address <= next_dbs_address;
      end if;
    end if;

  end process;

  --vhdl renameroo for output signals
  cpu_data_master_address_to_slave <= internal_cpu_data_master_address_to_slave;
  --vhdl renameroo for output signals
  cpu_data_master_dbs_address <= internal_cpu_data_master_dbs_address;
  --vhdl renameroo for output signals
  cpu_data_master_no_byte_enables_and_last_term <= internal_cpu_data_master_no_byte_enables_and_last_term;
  --vhdl renameroo for output signals
  cpu_data_master_waitrequest <= internal_cpu_data_master_waitrequest;

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

library std;
use std.textio.all;

entity cpu_instruction_master_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_instruction_master_address : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_instruction_master_granted_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port : IN STD_LOGIC;
                 signal cpu_instruction_master_granted_pipeline_bridge_s1 : IN STD_LOGIC;
                 signal cpu_instruction_master_granted_sdram_s1 : IN STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port : IN STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_pipeline_bridge_s1 : IN STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_sdram_s1 : IN STD_LOGIC;
                 signal cpu_instruction_master_read : IN STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port : IN STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_pipeline_bridge_s1 : IN STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register : IN STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_sdram_s1 : IN STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_sdram_s1_shift_register : IN STD_LOGIC;
                 signal cpu_instruction_master_requests_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port : IN STD_LOGIC;
                 signal cpu_instruction_master_requests_pipeline_bridge_s1 : IN STD_LOGIC;
                 signal cpu_instruction_master_requests_sdram_s1 : IN STD_LOGIC;
                 signal cpu_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_cpu_jtag_debug_module_end_xfer : IN STD_LOGIC;
                 signal d1_epcs_flash_controller_epcs_control_port_end_xfer : IN STD_LOGIC;
                 signal d1_pipeline_bridge_s1_end_xfer : IN STD_LOGIC;
                 signal d1_sdram_s1_end_xfer : IN STD_LOGIC;
                 signal epcs_flash_controller_epcs_control_port_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_s1_waitrequest_from_sa : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sdram_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sdram_s1_waitrequest_from_sa : IN STD_LOGIC;

              -- outputs:
                 signal cpu_instruction_master_address_to_slave : OUT STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_instruction_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_instruction_master_latency_counter : OUT STD_LOGIC;
                 signal cpu_instruction_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_instruction_master_readdatavalid : OUT STD_LOGIC;
                 signal cpu_instruction_master_waitrequest : OUT STD_LOGIC
              );
end entity cpu_instruction_master_arbitrator;


architecture europa of cpu_instruction_master_arbitrator is
                signal active_and_waiting_last_time :  STD_LOGIC;
                signal cpu_instruction_master_address_last_time :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal cpu_instruction_master_dbs_increment :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_instruction_master_dbs_rdv_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_instruction_master_dbs_rdv_counter_inc :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_instruction_master_is_granted_some_slave :  STD_LOGIC;
                signal cpu_instruction_master_next_dbs_rdv_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_instruction_master_read_but_no_slave_selected :  STD_LOGIC;
                signal cpu_instruction_master_read_last_time :  STD_LOGIC;
                signal cpu_instruction_master_run :  STD_LOGIC;
                signal dbs_count_enable :  STD_LOGIC;
                signal dbs_counter_overflow :  STD_LOGIC;
                signal dbs_latent_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal dbs_rdv_count_enable :  STD_LOGIC;
                signal dbs_rdv_counter_overflow :  STD_LOGIC;
                signal internal_cpu_instruction_master_address_to_slave :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal internal_cpu_instruction_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_cpu_instruction_master_latency_counter :  STD_LOGIC;
                signal internal_cpu_instruction_master_waitrequest :  STD_LOGIC;
                signal latency_load_value :  STD_LOGIC;
                signal next_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p1_cpu_instruction_master_latency_counter :  STD_LOGIC;
                signal p1_dbs_latent_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal pre_dbs_count_enable :  STD_LOGIC;
                signal pre_flush_cpu_instruction_master_readdatavalid :  STD_LOGIC;
                signal r_1 :  STD_LOGIC;
                signal r_2 :  STD_LOGIC;
                signal r_3 :  STD_LOGIC;

begin

  --r_1 master_run cascaded wait assignment, which is an e_assign
  r_1 <= Vector_To_Std_Logic((((((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_instruction_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_instruction_master_requests_cpu_jtag_debug_module)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_instruction_master_granted_cpu_jtag_debug_module OR NOT cpu_instruction_master_qualified_request_cpu_jtag_debug_module)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_instruction_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_instruction_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_cpu_jtag_debug_module_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_read)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port OR NOT cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port OR NOT cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port OR NOT (cpu_instruction_master_read))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_epcs_flash_controller_epcs_control_port_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_instruction_master_read))))))))));
  --cascaded wait assignment, which is an e_assign
  cpu_instruction_master_run <= (r_1 AND r_2) AND r_3;
  --r_2 master_run cascaded wait assignment, which is an e_assign
  r_2 <= Vector_To_Std_Logic((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_instruction_master_qualified_request_pipeline_bridge_s1 OR NOT cpu_instruction_master_requests_pipeline_bridge_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_instruction_master_granted_pipeline_bridge_s1 OR NOT cpu_instruction_master_qualified_request_pipeline_bridge_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_instruction_master_qualified_request_pipeline_bridge_s1 OR NOT cpu_instruction_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT pipeline_bridge_s1_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_read)))))))));
  --r_3 master_run cascaded wait assignment, which is an e_assign
  r_3 <= Vector_To_Std_Logic((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_instruction_master_qualified_request_sdram_s1 OR NOT cpu_instruction_master_requests_sdram_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_instruction_master_granted_sdram_s1 OR NOT cpu_instruction_master_qualified_request_sdram_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_instruction_master_qualified_request_sdram_s1 OR NOT cpu_instruction_master_read)))) OR ((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT sdram_s1_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_instruction_master_dbs_address(1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_read)))))))));
  --optimize select-logic by passing only those address bits which matter.
  internal_cpu_instruction_master_address_to_slave <= Std_Logic_Vector'(cpu_instruction_master_address(25 DOWNTO 24) & A_ToStdLogicVector(std_logic'('0')) & cpu_instruction_master_address(22 DOWNTO 0));
  --cpu_instruction_master_read_but_no_slave_selected assignment, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_instruction_master_read_but_no_slave_selected <= std_logic'('0');
    elsif clk'event and clk = '1' then
      cpu_instruction_master_read_but_no_slave_selected <= (cpu_instruction_master_read AND cpu_instruction_master_run) AND NOT cpu_instruction_master_is_granted_some_slave;
    end if;

  end process;

  --some slave is getting selected, which is an e_mux
  cpu_instruction_master_is_granted_some_slave <= ((cpu_instruction_master_granted_cpu_jtag_debug_module OR cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port) OR cpu_instruction_master_granted_pipeline_bridge_s1) OR cpu_instruction_master_granted_sdram_s1;
  --latent slave read data valids which may be flushed, which is an e_mux
  pre_flush_cpu_instruction_master_readdatavalid <= cpu_instruction_master_read_data_valid_pipeline_bridge_s1 OR ((cpu_instruction_master_read_data_valid_sdram_s1 AND dbs_rdv_counter_overflow));
  --latent slave read data valid which is not flushed, which is an e_mux
  cpu_instruction_master_readdatavalid <= ((((((((cpu_instruction_master_read_but_no_slave_selected OR pre_flush_cpu_instruction_master_readdatavalid) OR cpu_instruction_master_read_data_valid_cpu_jtag_debug_module) OR cpu_instruction_master_read_but_no_slave_selected) OR pre_flush_cpu_instruction_master_readdatavalid) OR cpu_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port) OR cpu_instruction_master_read_but_no_slave_selected) OR pre_flush_cpu_instruction_master_readdatavalid) OR cpu_instruction_master_read_but_no_slave_selected) OR pre_flush_cpu_instruction_master_readdatavalid;
  --cpu/instruction_master readdata mux, which is an e_mux
  cpu_instruction_master_readdata <= ((((A_REP(NOT ((cpu_instruction_master_qualified_request_cpu_jtag_debug_module AND cpu_instruction_master_read)) , 32) OR cpu_jtag_debug_module_readdata_from_sa)) AND ((A_REP(NOT ((cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port AND cpu_instruction_master_read)) , 32) OR epcs_flash_controller_epcs_control_port_readdata_from_sa))) AND ((A_REP(NOT cpu_instruction_master_read_data_valid_pipeline_bridge_s1, 32) OR pipeline_bridge_s1_readdata_from_sa))) AND ((A_REP(NOT cpu_instruction_master_read_data_valid_sdram_s1, 32) OR Std_Logic_Vector'(sdram_s1_readdata_from_sa(15 DOWNTO 0) & dbs_latent_16_reg_segment_0)));
  --actual waitrequest port, which is an e_assign
  internal_cpu_instruction_master_waitrequest <= NOT cpu_instruction_master_run;
  --latent max counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_instruction_master_latency_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      internal_cpu_instruction_master_latency_counter <= p1_cpu_instruction_master_latency_counter;
    end if;

  end process;

  --latency counter load mux, which is an e_mux
  p1_cpu_instruction_master_latency_counter <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(((cpu_instruction_master_run AND cpu_instruction_master_read))) = '1'), (std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(latency_load_value))), A_WE_StdLogicVector((std_logic'((internal_cpu_instruction_master_latency_counter)) = '1'), ((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(internal_cpu_instruction_master_latency_counter))) - std_logic_vector'("000000000000000000000000000000001")), std_logic_vector'("000000000000000000000000000000000"))));
  --read latency load values, which is an e_mux
  latency_load_value <= std_logic'('0');
  --input to latent dbs-16 stored 0, which is an e_mux
  p1_dbs_latent_16_reg_segment_0 <= sdram_s1_readdata_from_sa;
  --dbs register for latent dbs-16 segment 0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dbs_latent_16_reg_segment_0 <= std_logic_vector'("0000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((dbs_rdv_count_enable AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_instruction_master_dbs_rdv_counter(1))))) = std_logic_vector'("00000000000000000000000000000000")))))) = '1' then 
        dbs_latent_16_reg_segment_0 <= p1_dbs_latent_16_reg_segment_0;
      end if;
    end if;

  end process;

  --dbs count increment, which is an e_mux
  cpu_instruction_master_dbs_increment <= A_EXT (A_WE_StdLogicVector((std_logic'((cpu_instruction_master_requests_sdram_s1)) = '1'), std_logic_vector'("00000000000000000000000000000010"), std_logic_vector'("00000000000000000000000000000000")), 2);
  --dbs counter overflow, which is an e_assign
  dbs_counter_overflow <= internal_cpu_instruction_master_dbs_address(1) AND NOT((next_dbs_address(1)));
  --next master address, which is an e_assign
  next_dbs_address <= A_EXT (((std_logic_vector'("0") & (internal_cpu_instruction_master_dbs_address)) + (std_logic_vector'("0") & (cpu_instruction_master_dbs_increment))), 2);
  --dbs count enable, which is an e_mux
  dbs_count_enable <= pre_dbs_count_enable;
  --dbs counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_instruction_master_dbs_address <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(dbs_count_enable) = '1' then 
        internal_cpu_instruction_master_dbs_address <= next_dbs_address;
      end if;
    end if;

  end process;

  --p1 dbs rdv counter, which is an e_assign
  cpu_instruction_master_next_dbs_rdv_counter <= A_EXT (((std_logic_vector'("0") & (cpu_instruction_master_dbs_rdv_counter)) + (std_logic_vector'("0") & (cpu_instruction_master_dbs_rdv_counter_inc))), 2);
  --cpu_instruction_master_rdv_inc_mux, which is an e_mux
  cpu_instruction_master_dbs_rdv_counter_inc <= std_logic_vector'("10");
  --master any slave rdv, which is an e_mux
  dbs_rdv_count_enable <= cpu_instruction_master_read_data_valid_sdram_s1;
  --dbs rdv counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_instruction_master_dbs_rdv_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(dbs_rdv_count_enable) = '1' then 
        cpu_instruction_master_dbs_rdv_counter <= cpu_instruction_master_next_dbs_rdv_counter;
      end if;
    end if;

  end process;

  --dbs rdv counter overflow, which is an e_assign
  dbs_rdv_counter_overflow <= cpu_instruction_master_dbs_rdv_counter(1) AND NOT cpu_instruction_master_next_dbs_rdv_counter(1);
  --pre dbs count enable, which is an e_mux
  pre_dbs_count_enable <= Vector_To_Std_Logic(((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_instruction_master_granted_sdram_s1 AND cpu_instruction_master_read)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT sdram_s1_waitrequest_from_sa)))));
  --vhdl renameroo for output signals
  cpu_instruction_master_address_to_slave <= internal_cpu_instruction_master_address_to_slave;
  --vhdl renameroo for output signals
  cpu_instruction_master_dbs_address <= internal_cpu_instruction_master_dbs_address;
  --vhdl renameroo for output signals
  cpu_instruction_master_latency_counter <= internal_cpu_instruction_master_latency_counter;
  --vhdl renameroo for output signals
  cpu_instruction_master_waitrequest <= internal_cpu_instruction_master_waitrequest;
--synthesis translate_off
    --cpu_instruction_master_address check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_instruction_master_address_last_time <= std_logic_vector'("00000000000000000000000000");
      elsif clk'event and clk = '1' then
        cpu_instruction_master_address_last_time <= cpu_instruction_master_address;
      end if;

    end process;

    --cpu/instruction_master waited last time, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        active_and_waiting_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        active_and_waiting_last_time <= internal_cpu_instruction_master_waitrequest AND (cpu_instruction_master_read);
      end if;

    end process;

    --cpu_instruction_master_address matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line8 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((cpu_instruction_master_address /= cpu_instruction_master_address_last_time))))) = '1' then 
          write(write_line8, now);
          write(write_line8, string'(": "));
          write(write_line8, string'("cpu_instruction_master_address did not heed wait!!!"));
          write(output, write_line8.all);
          deallocate (write_line8);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --cpu_instruction_master_read check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_instruction_master_read_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        cpu_instruction_master_read_last_time <= cpu_instruction_master_read;
      end if;

    end process;

    --cpu_instruction_master_read matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line9 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((std_logic'(cpu_instruction_master_read) /= std_logic'(cpu_instruction_master_read_last_time)))))) = '1' then 
          write(write_line9, now);
          write(write_line9, string'(": "));
          write(write_line9, string'("cpu_instruction_master_read did not heed wait!!!"));
          write(output, write_line9.all);
          deallocate (write_line9);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

library std;
use std.textio.all;

entity epcs_flash_controller_epcs_control_port_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_instruction_master_latency_counter : IN STD_LOGIC;
                 signal cpu_instruction_master_read : IN STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register : IN STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_sdram_s1_shift_register : IN STD_LOGIC;
                 signal epcs_flash_controller_epcs_control_port_dataavailable : IN STD_LOGIC;
                 signal epcs_flash_controller_epcs_control_port_endofpacket : IN STD_LOGIC;
                 signal epcs_flash_controller_epcs_control_port_irq : IN STD_LOGIC;
                 signal epcs_flash_controller_epcs_control_port_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal epcs_flash_controller_epcs_control_port_readyfordata : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_epcs_flash_controller_epcs_control_port : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_epcs_flash_controller_epcs_control_port : OUT STD_LOGIC;
                 signal cpu_data_master_requests_epcs_flash_controller_epcs_control_port : OUT STD_LOGIC;
                 signal cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port : OUT STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port : OUT STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port : OUT STD_LOGIC;
                 signal cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port : OUT STD_LOGIC;
                 signal d1_epcs_flash_controller_epcs_control_port_end_xfer : OUT STD_LOGIC;
                 signal epcs_flash_controller_epcs_control_port_address : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                 signal epcs_flash_controller_epcs_control_port_chipselect : OUT STD_LOGIC;
                 signal epcs_flash_controller_epcs_control_port_dataavailable_from_sa : OUT STD_LOGIC;
                 signal epcs_flash_controller_epcs_control_port_endofpacket_from_sa : OUT STD_LOGIC;
                 signal epcs_flash_controller_epcs_control_port_irq_from_sa : OUT STD_LOGIC;
                 signal epcs_flash_controller_epcs_control_port_read_n : OUT STD_LOGIC;
                 signal epcs_flash_controller_epcs_control_port_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal epcs_flash_controller_epcs_control_port_readyfordata_from_sa : OUT STD_LOGIC;
                 signal epcs_flash_controller_epcs_control_port_reset_n : OUT STD_LOGIC;
                 signal epcs_flash_controller_epcs_control_port_write_n : OUT STD_LOGIC;
                 signal epcs_flash_controller_epcs_control_port_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity epcs_flash_controller_epcs_control_port_arbitrator;


architecture europa of epcs_flash_controller_epcs_control_port_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_instruction_master_continuerequest :  STD_LOGIC;
                signal cpu_instruction_master_saved_grant_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_allgrants :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_allow_new_arb_cycle :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_any_bursting_master_saved_grant :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_any_continuerequest :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_arb_addend :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal epcs_flash_controller_epcs_control_port_arb_counter_enable :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal epcs_flash_controller_epcs_control_port_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal epcs_flash_controller_epcs_control_port_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal epcs_flash_controller_epcs_control_port_arb_winner :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal epcs_flash_controller_epcs_control_port_arbitration_holdoff_internal :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_beginbursttransfer_internal :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_begins_xfer :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_chosen_master_double_vector :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal epcs_flash_controller_epcs_control_port_chosen_master_rot_left :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal epcs_flash_controller_epcs_control_port_end_xfer :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_firsttransfer :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_grant_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal epcs_flash_controller_epcs_control_port_in_a_read_cycle :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_in_a_write_cycle :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_master_qreq_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal epcs_flash_controller_epcs_control_port_non_bursting_master_requests :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_reg_firsttransfer :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_saved_chosen_master_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal epcs_flash_controller_epcs_control_port_slavearbiterlockenable :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_slavearbiterlockenable2 :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_unreg_firsttransfer :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_waits_for_read :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_waits_for_write :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal internal_cpu_data_master_requests_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal internal_cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal internal_cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal internal_cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal last_cycle_cpu_data_master_granted_slave_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal last_cycle_cpu_instruction_master_granted_slave_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal shifted_address_to_epcs_flash_controller_epcs_control_port_from_cpu_data_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal shifted_address_to_epcs_flash_controller_epcs_control_port_from_cpu_instruction_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal wait_for_epcs_flash_controller_epcs_control_port_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT epcs_flash_controller_epcs_control_port_end_xfer;
    end if;

  end process;

  epcs_flash_controller_epcs_control_port_begins_xfer <= NOT d1_reasons_to_wait AND ((internal_cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port OR internal_cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port));
  --assign epcs_flash_controller_epcs_control_port_readdata_from_sa = epcs_flash_controller_epcs_control_port_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  epcs_flash_controller_epcs_control_port_readdata_from_sa <= epcs_flash_controller_epcs_control_port_readdata;
  internal_cpu_data_master_requests_epcs_flash_controller_epcs_control_port <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(25 DOWNTO 11) & std_logic_vector'("00000000000")) = std_logic_vector'("00000000000000000000000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign epcs_flash_controller_epcs_control_port_dataavailable_from_sa = epcs_flash_controller_epcs_control_port_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  epcs_flash_controller_epcs_control_port_dataavailable_from_sa <= epcs_flash_controller_epcs_control_port_dataavailable;
  --assign epcs_flash_controller_epcs_control_port_readyfordata_from_sa = epcs_flash_controller_epcs_control_port_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  epcs_flash_controller_epcs_control_port_readyfordata_from_sa <= epcs_flash_controller_epcs_control_port_readyfordata;
  --epcs_flash_controller_epcs_control_port_arb_share_counter set values, which is an e_mux
  epcs_flash_controller_epcs_control_port_arb_share_set_values <= std_logic_vector'("01");
  --epcs_flash_controller_epcs_control_port_non_bursting_master_requests mux, which is an e_mux
  epcs_flash_controller_epcs_control_port_non_bursting_master_requests <= ((internal_cpu_data_master_requests_epcs_flash_controller_epcs_control_port OR internal_cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port) OR internal_cpu_data_master_requests_epcs_flash_controller_epcs_control_port) OR internal_cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port;
  --epcs_flash_controller_epcs_control_port_any_bursting_master_saved_grant mux, which is an e_mux
  epcs_flash_controller_epcs_control_port_any_bursting_master_saved_grant <= std_logic'('0');
  --epcs_flash_controller_epcs_control_port_arb_share_counter_next_value assignment, which is an e_assign
  epcs_flash_controller_epcs_control_port_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(epcs_flash_controller_epcs_control_port_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (epcs_flash_controller_epcs_control_port_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(epcs_flash_controller_epcs_control_port_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (epcs_flash_controller_epcs_control_port_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --epcs_flash_controller_epcs_control_port_allgrants all slave grants, which is an e_mux
  epcs_flash_controller_epcs_control_port_allgrants <= (((or_reduce(epcs_flash_controller_epcs_control_port_grant_vector)) OR (or_reduce(epcs_flash_controller_epcs_control_port_grant_vector))) OR (or_reduce(epcs_flash_controller_epcs_control_port_grant_vector))) OR (or_reduce(epcs_flash_controller_epcs_control_port_grant_vector));
  --epcs_flash_controller_epcs_control_port_end_xfer assignment, which is an e_assign
  epcs_flash_controller_epcs_control_port_end_xfer <= NOT ((epcs_flash_controller_epcs_control_port_waits_for_read OR epcs_flash_controller_epcs_control_port_waits_for_write));
  --end_xfer_arb_share_counter_term_epcs_flash_controller_epcs_control_port arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_epcs_flash_controller_epcs_control_port <= epcs_flash_controller_epcs_control_port_end_xfer AND (((NOT epcs_flash_controller_epcs_control_port_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --epcs_flash_controller_epcs_control_port_arb_share_counter arbitration counter enable, which is an e_assign
  epcs_flash_controller_epcs_control_port_arb_counter_enable <= ((end_xfer_arb_share_counter_term_epcs_flash_controller_epcs_control_port AND epcs_flash_controller_epcs_control_port_allgrants)) OR ((end_xfer_arb_share_counter_term_epcs_flash_controller_epcs_control_port AND NOT epcs_flash_controller_epcs_control_port_non_bursting_master_requests));
  --epcs_flash_controller_epcs_control_port_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      epcs_flash_controller_epcs_control_port_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(epcs_flash_controller_epcs_control_port_arb_counter_enable) = '1' then 
        epcs_flash_controller_epcs_control_port_arb_share_counter <= epcs_flash_controller_epcs_control_port_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --epcs_flash_controller_epcs_control_port_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      epcs_flash_controller_epcs_control_port_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((or_reduce(epcs_flash_controller_epcs_control_port_master_qreq_vector) AND end_xfer_arb_share_counter_term_epcs_flash_controller_epcs_control_port)) OR ((end_xfer_arb_share_counter_term_epcs_flash_controller_epcs_control_port AND NOT epcs_flash_controller_epcs_control_port_non_bursting_master_requests)))) = '1' then 
        epcs_flash_controller_epcs_control_port_slavearbiterlockenable <= or_reduce(epcs_flash_controller_epcs_control_port_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu/data_master epcs_flash_controller/epcs_control_port arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= epcs_flash_controller_epcs_control_port_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --epcs_flash_controller_epcs_control_port_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  epcs_flash_controller_epcs_control_port_slavearbiterlockenable2 <= or_reduce(epcs_flash_controller_epcs_control_port_arb_share_counter_next_value);
  --cpu/data_master epcs_flash_controller/epcs_control_port arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= epcs_flash_controller_epcs_control_port_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --cpu/instruction_master epcs_flash_controller/epcs_control_port arbiterlock, which is an e_assign
  cpu_instruction_master_arbiterlock <= epcs_flash_controller_epcs_control_port_slavearbiterlockenable AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master epcs_flash_controller/epcs_control_port arbiterlock2, which is an e_assign
  cpu_instruction_master_arbiterlock2 <= epcs_flash_controller_epcs_control_port_slavearbiterlockenable2 AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master granted epcs_flash_controller/epcs_control_port last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_instruction_master_granted_slave_epcs_flash_controller_epcs_control_port <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_instruction_master_granted_slave_epcs_flash_controller_epcs_control_port <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_instruction_master_saved_grant_epcs_flash_controller_epcs_control_port) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((epcs_flash_controller_epcs_control_port_arbitration_holdoff_internal OR NOT internal_cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_instruction_master_granted_slave_epcs_flash_controller_epcs_control_port))))));
    end if;

  end process;

  --cpu_instruction_master_continuerequest continued request, which is an e_mux
  cpu_instruction_master_continuerequest <= last_cycle_cpu_instruction_master_granted_slave_epcs_flash_controller_epcs_control_port AND internal_cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port;
  --epcs_flash_controller_epcs_control_port_any_continuerequest at least one master continues requesting, which is an e_mux
  epcs_flash_controller_epcs_control_port_any_continuerequest <= cpu_instruction_master_continuerequest OR cpu_data_master_continuerequest;
  internal_cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port <= internal_cpu_data_master_requests_epcs_flash_controller_epcs_control_port AND NOT (cpu_instruction_master_arbiterlock);
  --epcs_flash_controller_epcs_control_port_writedata mux, which is an e_mux
  epcs_flash_controller_epcs_control_port_writedata <= cpu_data_master_writedata;
  --assign epcs_flash_controller_epcs_control_port_endofpacket_from_sa = epcs_flash_controller_epcs_control_port_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  epcs_flash_controller_epcs_control_port_endofpacket_from_sa <= epcs_flash_controller_epcs_control_port_endofpacket;
  internal_cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port <= ((to_std_logic(((Std_Logic_Vector'(cpu_instruction_master_address_to_slave(25 DOWNTO 11) & std_logic_vector'("00000000000")) = std_logic_vector'("00000000000000000000000000")))) AND (cpu_instruction_master_read))) AND cpu_instruction_master_read;
  --cpu/data_master granted epcs_flash_controller/epcs_control_port last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_data_master_granted_slave_epcs_flash_controller_epcs_control_port <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_data_master_granted_slave_epcs_flash_controller_epcs_control_port <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_data_master_saved_grant_epcs_flash_controller_epcs_control_port) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((epcs_flash_controller_epcs_control_port_arbitration_holdoff_internal OR NOT internal_cpu_data_master_requests_epcs_flash_controller_epcs_control_port))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_data_master_granted_slave_epcs_flash_controller_epcs_control_port))))));
    end if;

  end process;

  --cpu_data_master_continuerequest continued request, which is an e_mux
  cpu_data_master_continuerequest <= last_cycle_cpu_data_master_granted_slave_epcs_flash_controller_epcs_control_port AND internal_cpu_data_master_requests_epcs_flash_controller_epcs_control_port;
  internal_cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port <= internal_cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port AND NOT ((((cpu_instruction_master_read AND (((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000")))) OR (cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register)) OR (cpu_instruction_master_read_data_valid_sdram_s1_shift_register))))) OR cpu_data_master_arbiterlock));
  --local readdatavalid cpu_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port, which is an e_mux
  cpu_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port <= (internal_cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port AND cpu_instruction_master_read) AND NOT epcs_flash_controller_epcs_control_port_waits_for_read;
  --allow new arb cycle for epcs_flash_controller/epcs_control_port, which is an e_assign
  epcs_flash_controller_epcs_control_port_allow_new_arb_cycle <= NOT cpu_data_master_arbiterlock AND NOT cpu_instruction_master_arbiterlock;
  --cpu/instruction_master assignment into master qualified-requests vector for epcs_flash_controller/epcs_control_port, which is an e_assign
  epcs_flash_controller_epcs_control_port_master_qreq_vector(0) <= internal_cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port;
  --cpu/instruction_master grant epcs_flash_controller/epcs_control_port, which is an e_assign
  internal_cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port <= epcs_flash_controller_epcs_control_port_grant_vector(0);
  --cpu/instruction_master saved-grant epcs_flash_controller/epcs_control_port, which is an e_assign
  cpu_instruction_master_saved_grant_epcs_flash_controller_epcs_control_port <= epcs_flash_controller_epcs_control_port_arb_winner(0) AND internal_cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port;
  --cpu/data_master assignment into master qualified-requests vector for epcs_flash_controller/epcs_control_port, which is an e_assign
  epcs_flash_controller_epcs_control_port_master_qreq_vector(1) <= internal_cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port;
  --cpu/data_master grant epcs_flash_controller/epcs_control_port, which is an e_assign
  internal_cpu_data_master_granted_epcs_flash_controller_epcs_control_port <= epcs_flash_controller_epcs_control_port_grant_vector(1);
  --cpu/data_master saved-grant epcs_flash_controller/epcs_control_port, which is an e_assign
  cpu_data_master_saved_grant_epcs_flash_controller_epcs_control_port <= epcs_flash_controller_epcs_control_port_arb_winner(1) AND internal_cpu_data_master_requests_epcs_flash_controller_epcs_control_port;
  --epcs_flash_controller/epcs_control_port chosen-master double-vector, which is an e_assign
  epcs_flash_controller_epcs_control_port_chosen_master_double_vector <= A_EXT (((std_logic_vector'("0") & ((epcs_flash_controller_epcs_control_port_master_qreq_vector & epcs_flash_controller_epcs_control_port_master_qreq_vector))) AND (((std_logic_vector'("0") & (Std_Logic_Vector'(NOT epcs_flash_controller_epcs_control_port_master_qreq_vector & NOT epcs_flash_controller_epcs_control_port_master_qreq_vector))) + (std_logic_vector'("000") & (epcs_flash_controller_epcs_control_port_arb_addend))))), 4);
  --stable onehot encoding of arb winner
  epcs_flash_controller_epcs_control_port_arb_winner <= A_WE_StdLogicVector((std_logic'(((epcs_flash_controller_epcs_control_port_allow_new_arb_cycle AND or_reduce(epcs_flash_controller_epcs_control_port_grant_vector)))) = '1'), epcs_flash_controller_epcs_control_port_grant_vector, epcs_flash_controller_epcs_control_port_saved_chosen_master_vector);
  --saved epcs_flash_controller_epcs_control_port_grant_vector, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      epcs_flash_controller_epcs_control_port_saved_chosen_master_vector <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(epcs_flash_controller_epcs_control_port_allow_new_arb_cycle) = '1' then 
        epcs_flash_controller_epcs_control_port_saved_chosen_master_vector <= A_WE_StdLogicVector((std_logic'(or_reduce(epcs_flash_controller_epcs_control_port_grant_vector)) = '1'), epcs_flash_controller_epcs_control_port_grant_vector, epcs_flash_controller_epcs_control_port_saved_chosen_master_vector);
      end if;
    end if;

  end process;

  --onehot encoding of chosen master
  epcs_flash_controller_epcs_control_port_grant_vector <= Std_Logic_Vector'(A_ToStdLogicVector(((epcs_flash_controller_epcs_control_port_chosen_master_double_vector(1) OR epcs_flash_controller_epcs_control_port_chosen_master_double_vector(3)))) & A_ToStdLogicVector(((epcs_flash_controller_epcs_control_port_chosen_master_double_vector(0) OR epcs_flash_controller_epcs_control_port_chosen_master_double_vector(2)))));
  --epcs_flash_controller/epcs_control_port chosen master rotated left, which is an e_assign
  epcs_flash_controller_epcs_control_port_chosen_master_rot_left <= A_EXT (A_WE_StdLogicVector((((A_SLL(epcs_flash_controller_epcs_control_port_arb_winner,std_logic_vector'("00000000000000000000000000000001")))) /= std_logic_vector'("00")), (std_logic_vector'("000000000000000000000000000000") & ((A_SLL(epcs_flash_controller_epcs_control_port_arb_winner,std_logic_vector'("00000000000000000000000000000001"))))), std_logic_vector'("00000000000000000000000000000001")), 2);
  --epcs_flash_controller/epcs_control_port's addend for next-master-grant
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      epcs_flash_controller_epcs_control_port_arb_addend <= std_logic_vector'("01");
    elsif clk'event and clk = '1' then
      if std_logic'(or_reduce(epcs_flash_controller_epcs_control_port_grant_vector)) = '1' then 
        epcs_flash_controller_epcs_control_port_arb_addend <= A_WE_StdLogicVector((std_logic'(epcs_flash_controller_epcs_control_port_end_xfer) = '1'), epcs_flash_controller_epcs_control_port_chosen_master_rot_left, epcs_flash_controller_epcs_control_port_grant_vector);
      end if;
    end if;

  end process;

  --epcs_flash_controller_epcs_control_port_reset_n assignment, which is an e_assign
  epcs_flash_controller_epcs_control_port_reset_n <= reset_n;
  epcs_flash_controller_epcs_control_port_chipselect <= internal_cpu_data_master_granted_epcs_flash_controller_epcs_control_port OR internal_cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port;
  --epcs_flash_controller_epcs_control_port_firsttransfer first transaction, which is an e_assign
  epcs_flash_controller_epcs_control_port_firsttransfer <= A_WE_StdLogic((std_logic'(epcs_flash_controller_epcs_control_port_begins_xfer) = '1'), epcs_flash_controller_epcs_control_port_unreg_firsttransfer, epcs_flash_controller_epcs_control_port_reg_firsttransfer);
  --epcs_flash_controller_epcs_control_port_unreg_firsttransfer first transaction, which is an e_assign
  epcs_flash_controller_epcs_control_port_unreg_firsttransfer <= NOT ((epcs_flash_controller_epcs_control_port_slavearbiterlockenable AND epcs_flash_controller_epcs_control_port_any_continuerequest));
  --epcs_flash_controller_epcs_control_port_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      epcs_flash_controller_epcs_control_port_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(epcs_flash_controller_epcs_control_port_begins_xfer) = '1' then 
        epcs_flash_controller_epcs_control_port_reg_firsttransfer <= epcs_flash_controller_epcs_control_port_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --epcs_flash_controller_epcs_control_port_beginbursttransfer_internal begin burst transfer, which is an e_assign
  epcs_flash_controller_epcs_control_port_beginbursttransfer_internal <= epcs_flash_controller_epcs_control_port_begins_xfer;
  --epcs_flash_controller_epcs_control_port_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  epcs_flash_controller_epcs_control_port_arbitration_holdoff_internal <= epcs_flash_controller_epcs_control_port_begins_xfer AND epcs_flash_controller_epcs_control_port_firsttransfer;
  --~epcs_flash_controller_epcs_control_port_read_n assignment, which is an e_mux
  epcs_flash_controller_epcs_control_port_read_n <= NOT ((((internal_cpu_data_master_granted_epcs_flash_controller_epcs_control_port AND cpu_data_master_read)) OR ((internal_cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port AND cpu_instruction_master_read))));
  --~epcs_flash_controller_epcs_control_port_write_n assignment, which is an e_mux
  epcs_flash_controller_epcs_control_port_write_n <= NOT ((internal_cpu_data_master_granted_epcs_flash_controller_epcs_control_port AND cpu_data_master_write));
  shifted_address_to_epcs_flash_controller_epcs_control_port_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --epcs_flash_controller_epcs_control_port_address mux, which is an e_mux
  epcs_flash_controller_epcs_control_port_address <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_epcs_flash_controller_epcs_control_port)) = '1'), (A_SRL(shifted_address_to_epcs_flash_controller_epcs_control_port_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010"))), (A_SRL(shifted_address_to_epcs_flash_controller_epcs_control_port_from_cpu_instruction_master,std_logic_vector'("00000000000000000000000000000010")))), 9);
  shifted_address_to_epcs_flash_controller_epcs_control_port_from_cpu_instruction_master <= cpu_instruction_master_address_to_slave;
  --d1_epcs_flash_controller_epcs_control_port_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_epcs_flash_controller_epcs_control_port_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_epcs_flash_controller_epcs_control_port_end_xfer <= epcs_flash_controller_epcs_control_port_end_xfer;
    end if;

  end process;

  --epcs_flash_controller_epcs_control_port_waits_for_read in a cycle, which is an e_mux
  epcs_flash_controller_epcs_control_port_waits_for_read <= epcs_flash_controller_epcs_control_port_in_a_read_cycle AND epcs_flash_controller_epcs_control_port_begins_xfer;
  --epcs_flash_controller_epcs_control_port_in_a_read_cycle assignment, which is an e_assign
  epcs_flash_controller_epcs_control_port_in_a_read_cycle <= ((internal_cpu_data_master_granted_epcs_flash_controller_epcs_control_port AND cpu_data_master_read)) OR ((internal_cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port AND cpu_instruction_master_read));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= epcs_flash_controller_epcs_control_port_in_a_read_cycle;
  --epcs_flash_controller_epcs_control_port_waits_for_write in a cycle, which is an e_mux
  epcs_flash_controller_epcs_control_port_waits_for_write <= epcs_flash_controller_epcs_control_port_in_a_write_cycle AND epcs_flash_controller_epcs_control_port_begins_xfer;
  --epcs_flash_controller_epcs_control_port_in_a_write_cycle assignment, which is an e_assign
  epcs_flash_controller_epcs_control_port_in_a_write_cycle <= internal_cpu_data_master_granted_epcs_flash_controller_epcs_control_port AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= epcs_flash_controller_epcs_control_port_in_a_write_cycle;
  wait_for_epcs_flash_controller_epcs_control_port_counter <= std_logic'('0');
  --assign epcs_flash_controller_epcs_control_port_irq_from_sa = epcs_flash_controller_epcs_control_port_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  epcs_flash_controller_epcs_control_port_irq_from_sa <= epcs_flash_controller_epcs_control_port_irq;
  --vhdl renameroo for output signals
  cpu_data_master_granted_epcs_flash_controller_epcs_control_port <= internal_cpu_data_master_granted_epcs_flash_controller_epcs_control_port;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port <= internal_cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port;
  --vhdl renameroo for output signals
  cpu_data_master_requests_epcs_flash_controller_epcs_control_port <= internal_cpu_data_master_requests_epcs_flash_controller_epcs_control_port;
  --vhdl renameroo for output signals
  cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port <= internal_cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port;
  --vhdl renameroo for output signals
  cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port <= internal_cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port;
  --vhdl renameroo for output signals
  cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port <= internal_cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port;
--synthesis translate_off
    --epcs_flash_controller/epcs_control_port enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line10 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_data_master_granted_epcs_flash_controller_epcs_control_port))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line10, now);
          write(write_line10, string'(": "));
          write(write_line10, string'("> 1 of grant signals are active simultaneously"));
          write(output, write_line10.all);
          deallocate (write_line10);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --saved_grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line11 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_data_master_saved_grant_epcs_flash_controller_epcs_control_port))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_saved_grant_epcs_flash_controller_epcs_control_port))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line11, now);
          write(write_line11, string'(": "));
          write(write_line11, string'("> 1 of saved_grant signals are active simultaneously"));
          write(output, write_line11.all);
          deallocate (write_line11);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

library std;
use std.textio.all;

entity ili_db_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal ili_db_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                 signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                 signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read : IN STD_LOGIC;
                 signal pipeline_bridge_m1_write : IN STD_LOGIC;
                 signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal d1_ili_db_s1_end_xfer : OUT STD_LOGIC;
                 signal ili_db_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ili_db_s1_chipselect : OUT STD_LOGIC;
                 signal ili_db_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ili_db_s1_reset_n : OUT STD_LOGIC;
                 signal ili_db_s1_write_n : OUT STD_LOGIC;
                 signal ili_db_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_m1_granted_ili_db_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ili_db_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ili_db_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ili_db_s1 : OUT STD_LOGIC
              );
end entity ili_db_s1_arbitrator;


architecture europa of ili_db_s1_arbitrator is
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_ili_db_s1 :  STD_LOGIC;
                signal ili_db_s1_allgrants :  STD_LOGIC;
                signal ili_db_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal ili_db_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal ili_db_s1_any_continuerequest :  STD_LOGIC;
                signal ili_db_s1_arb_counter_enable :  STD_LOGIC;
                signal ili_db_s1_arb_share_counter :  STD_LOGIC;
                signal ili_db_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal ili_db_s1_arb_share_set_values :  STD_LOGIC;
                signal ili_db_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal ili_db_s1_begins_xfer :  STD_LOGIC;
                signal ili_db_s1_end_xfer :  STD_LOGIC;
                signal ili_db_s1_firsttransfer :  STD_LOGIC;
                signal ili_db_s1_grant_vector :  STD_LOGIC;
                signal ili_db_s1_in_a_read_cycle :  STD_LOGIC;
                signal ili_db_s1_in_a_write_cycle :  STD_LOGIC;
                signal ili_db_s1_master_qreq_vector :  STD_LOGIC;
                signal ili_db_s1_non_bursting_master_requests :  STD_LOGIC;
                signal ili_db_s1_reg_firsttransfer :  STD_LOGIC;
                signal ili_db_s1_slavearbiterlockenable :  STD_LOGIC;
                signal ili_db_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal ili_db_s1_unreg_firsttransfer :  STD_LOGIC;
                signal ili_db_s1_waits_for_read :  STD_LOGIC;
                signal ili_db_s1_waits_for_write :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_granted_ili_db_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_qualified_request_ili_db_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_requests_ili_db_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock2 :  STD_LOGIC;
                signal pipeline_bridge_m1_continuerequest :  STD_LOGIC;
                signal pipeline_bridge_m1_saved_grant_ili_db_s1 :  STD_LOGIC;
                signal shifted_address_to_ili_db_s1_from_pipeline_bridge_m1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal wait_for_ili_db_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT ili_db_s1_end_xfer;
    end if;

  end process;

  ili_db_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_pipeline_bridge_m1_qualified_request_ili_db_s1);
  --assign ili_db_s1_readdata_from_sa = ili_db_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  ili_db_s1_readdata_from_sa <= ili_db_s1_readdata;
  internal_pipeline_bridge_m1_requests_ili_db_s1 <= to_std_logic(((Std_Logic_Vector'(pipeline_bridge_m1_address_to_slave(7 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("00000000")))) AND pipeline_bridge_m1_chipselect;
  --ili_db_s1_arb_share_counter set values, which is an e_mux
  ili_db_s1_arb_share_set_values <= std_logic'('1');
  --ili_db_s1_non_bursting_master_requests mux, which is an e_mux
  ili_db_s1_non_bursting_master_requests <= internal_pipeline_bridge_m1_requests_ili_db_s1;
  --ili_db_s1_any_bursting_master_saved_grant mux, which is an e_mux
  ili_db_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --ili_db_s1_arb_share_counter_next_value assignment, which is an e_assign
  ili_db_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(ili_db_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ili_db_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(ili_db_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ili_db_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --ili_db_s1_allgrants all slave grants, which is an e_mux
  ili_db_s1_allgrants <= ili_db_s1_grant_vector;
  --ili_db_s1_end_xfer assignment, which is an e_assign
  ili_db_s1_end_xfer <= NOT ((ili_db_s1_waits_for_read OR ili_db_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_ili_db_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_ili_db_s1 <= ili_db_s1_end_xfer AND (((NOT ili_db_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --ili_db_s1_arb_share_counter arbitration counter enable, which is an e_assign
  ili_db_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_ili_db_s1 AND ili_db_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_ili_db_s1 AND NOT ili_db_s1_non_bursting_master_requests));
  --ili_db_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ili_db_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(ili_db_s1_arb_counter_enable) = '1' then 
        ili_db_s1_arb_share_counter <= ili_db_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --ili_db_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ili_db_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((ili_db_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_ili_db_s1)) OR ((end_xfer_arb_share_counter_term_ili_db_s1 AND NOT ili_db_s1_non_bursting_master_requests)))) = '1' then 
        ili_db_s1_slavearbiterlockenable <= ili_db_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pipeline_bridge/m1 ili_db/s1 arbiterlock, which is an e_assign
  pipeline_bridge_m1_arbiterlock <= ili_db_s1_slavearbiterlockenable AND pipeline_bridge_m1_continuerequest;
  --ili_db_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  ili_db_s1_slavearbiterlockenable2 <= ili_db_s1_arb_share_counter_next_value;
  --pipeline_bridge/m1 ili_db/s1 arbiterlock2, which is an e_assign
  pipeline_bridge_m1_arbiterlock2 <= ili_db_s1_slavearbiterlockenable2 AND pipeline_bridge_m1_continuerequest;
  --ili_db_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  ili_db_s1_any_continuerequest <= std_logic'('1');
  --pipeline_bridge_m1_continuerequest continued request, which is an e_assign
  pipeline_bridge_m1_continuerequest <= std_logic'('1');
  internal_pipeline_bridge_m1_qualified_request_ili_db_s1 <= internal_pipeline_bridge_m1_requests_ili_db_s1 AND NOT ((((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))))));
  --local readdatavalid pipeline_bridge_m1_read_data_valid_ili_db_s1, which is an e_mux
  pipeline_bridge_m1_read_data_valid_ili_db_s1 <= (internal_pipeline_bridge_m1_granted_ili_db_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect))) AND NOT ili_db_s1_waits_for_read;
  --ili_db_s1_writedata mux, which is an e_mux
  ili_db_s1_writedata <= pipeline_bridge_m1_writedata;
  --master is always granted when requested
  internal_pipeline_bridge_m1_granted_ili_db_s1 <= internal_pipeline_bridge_m1_qualified_request_ili_db_s1;
  --pipeline_bridge/m1 saved-grant ili_db/s1, which is an e_assign
  pipeline_bridge_m1_saved_grant_ili_db_s1 <= internal_pipeline_bridge_m1_requests_ili_db_s1;
  --allow new arb cycle for ili_db/s1, which is an e_assign
  ili_db_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  ili_db_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  ili_db_s1_master_qreq_vector <= std_logic'('1');
  --ili_db_s1_reset_n assignment, which is an e_assign
  ili_db_s1_reset_n <= reset_n;
  ili_db_s1_chipselect <= internal_pipeline_bridge_m1_granted_ili_db_s1;
  --ili_db_s1_firsttransfer first transaction, which is an e_assign
  ili_db_s1_firsttransfer <= A_WE_StdLogic((std_logic'(ili_db_s1_begins_xfer) = '1'), ili_db_s1_unreg_firsttransfer, ili_db_s1_reg_firsttransfer);
  --ili_db_s1_unreg_firsttransfer first transaction, which is an e_assign
  ili_db_s1_unreg_firsttransfer <= NOT ((ili_db_s1_slavearbiterlockenable AND ili_db_s1_any_continuerequest));
  --ili_db_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ili_db_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(ili_db_s1_begins_xfer) = '1' then 
        ili_db_s1_reg_firsttransfer <= ili_db_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --ili_db_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  ili_db_s1_beginbursttransfer_internal <= ili_db_s1_begins_xfer;
  --~ili_db_s1_write_n assignment, which is an e_mux
  ili_db_s1_write_n <= NOT ((internal_pipeline_bridge_m1_granted_ili_db_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect))));
  shifted_address_to_ili_db_s1_from_pipeline_bridge_m1 <= pipeline_bridge_m1_address_to_slave;
  --ili_db_s1_address mux, which is an e_mux
  ili_db_s1_address <= A_EXT (A_SRL(shifted_address_to_ili_db_s1_from_pipeline_bridge_m1,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_ili_db_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_ili_db_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_ili_db_s1_end_xfer <= ili_db_s1_end_xfer;
    end if;

  end process;

  --ili_db_s1_waits_for_read in a cycle, which is an e_mux
  ili_db_s1_waits_for_read <= ili_db_s1_in_a_read_cycle AND ili_db_s1_begins_xfer;
  --ili_db_s1_in_a_read_cycle assignment, which is an e_assign
  ili_db_s1_in_a_read_cycle <= internal_pipeline_bridge_m1_granted_ili_db_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= ili_db_s1_in_a_read_cycle;
  --ili_db_s1_waits_for_write in a cycle, which is an e_mux
  ili_db_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ili_db_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --ili_db_s1_in_a_write_cycle assignment, which is an e_assign
  ili_db_s1_in_a_write_cycle <= internal_pipeline_bridge_m1_granted_ili_db_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect));
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= ili_db_s1_in_a_write_cycle;
  wait_for_ili_db_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  pipeline_bridge_m1_granted_ili_db_s1 <= internal_pipeline_bridge_m1_granted_ili_db_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_qualified_request_ili_db_s1 <= internal_pipeline_bridge_m1_qualified_request_ili_db_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_requests_ili_db_s1 <= internal_pipeline_bridge_m1_requests_ili_db_s1;
--synthesis translate_off
    --ili_db/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --pipeline_bridge/m1 non-zero burstcount assertion, which is an e_process
    process (clk)
    VARIABLE write_line12 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((internal_pipeline_bridge_m1_requests_ili_db_s1 AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_burstcount))) = std_logic_vector'("00000000000000000000000000000000"))))) AND enable_nonzero_assertions)) = '1' then 
          write(write_line12, now);
          write(write_line12, string'(": "));
          write(write_line12, string'("pipeline_bridge/m1 drove 0 on its 'burstcount' port while accessing slave ili_db/s1"));
          write(output, write_line12.all);
          deallocate (write_line12);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

library std;
use std.textio.all;

entity ili_ncs_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal ili_ncs_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                 signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                 signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read : IN STD_LOGIC;
                 signal pipeline_bridge_m1_write : IN STD_LOGIC;
                 signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal d1_ili_ncs_s1_end_xfer : OUT STD_LOGIC;
                 signal ili_ncs_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ili_ncs_s1_chipselect : OUT STD_LOGIC;
                 signal ili_ncs_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ili_ncs_s1_reset_n : OUT STD_LOGIC;
                 signal ili_ncs_s1_write_n : OUT STD_LOGIC;
                 signal ili_ncs_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_m1_granted_ili_ncs_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ili_ncs_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ili_ncs_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ili_ncs_s1 : OUT STD_LOGIC
              );
end entity ili_ncs_s1_arbitrator;


architecture europa of ili_ncs_s1_arbitrator is
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_ili_ncs_s1 :  STD_LOGIC;
                signal ili_ncs_s1_allgrants :  STD_LOGIC;
                signal ili_ncs_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal ili_ncs_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal ili_ncs_s1_any_continuerequest :  STD_LOGIC;
                signal ili_ncs_s1_arb_counter_enable :  STD_LOGIC;
                signal ili_ncs_s1_arb_share_counter :  STD_LOGIC;
                signal ili_ncs_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal ili_ncs_s1_arb_share_set_values :  STD_LOGIC;
                signal ili_ncs_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal ili_ncs_s1_begins_xfer :  STD_LOGIC;
                signal ili_ncs_s1_end_xfer :  STD_LOGIC;
                signal ili_ncs_s1_firsttransfer :  STD_LOGIC;
                signal ili_ncs_s1_grant_vector :  STD_LOGIC;
                signal ili_ncs_s1_in_a_read_cycle :  STD_LOGIC;
                signal ili_ncs_s1_in_a_write_cycle :  STD_LOGIC;
                signal ili_ncs_s1_master_qreq_vector :  STD_LOGIC;
                signal ili_ncs_s1_non_bursting_master_requests :  STD_LOGIC;
                signal ili_ncs_s1_reg_firsttransfer :  STD_LOGIC;
                signal ili_ncs_s1_slavearbiterlockenable :  STD_LOGIC;
                signal ili_ncs_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal ili_ncs_s1_unreg_firsttransfer :  STD_LOGIC;
                signal ili_ncs_s1_waits_for_read :  STD_LOGIC;
                signal ili_ncs_s1_waits_for_write :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_granted_ili_ncs_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_qualified_request_ili_ncs_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_requests_ili_ncs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock2 :  STD_LOGIC;
                signal pipeline_bridge_m1_continuerequest :  STD_LOGIC;
                signal pipeline_bridge_m1_saved_grant_ili_ncs_s1 :  STD_LOGIC;
                signal shifted_address_to_ili_ncs_s1_from_pipeline_bridge_m1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal wait_for_ili_ncs_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT ili_ncs_s1_end_xfer;
    end if;

  end process;

  ili_ncs_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_pipeline_bridge_m1_qualified_request_ili_ncs_s1);
  --assign ili_ncs_s1_readdata_from_sa = ili_ncs_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  ili_ncs_s1_readdata_from_sa <= ili_ncs_s1_readdata;
  internal_pipeline_bridge_m1_requests_ili_ncs_s1 <= to_std_logic(((Std_Logic_Vector'(pipeline_bridge_m1_address_to_slave(7 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("11100000")))) AND pipeline_bridge_m1_chipselect;
  --ili_ncs_s1_arb_share_counter set values, which is an e_mux
  ili_ncs_s1_arb_share_set_values <= std_logic'('1');
  --ili_ncs_s1_non_bursting_master_requests mux, which is an e_mux
  ili_ncs_s1_non_bursting_master_requests <= internal_pipeline_bridge_m1_requests_ili_ncs_s1;
  --ili_ncs_s1_any_bursting_master_saved_grant mux, which is an e_mux
  ili_ncs_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --ili_ncs_s1_arb_share_counter_next_value assignment, which is an e_assign
  ili_ncs_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(ili_ncs_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ili_ncs_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(ili_ncs_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ili_ncs_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --ili_ncs_s1_allgrants all slave grants, which is an e_mux
  ili_ncs_s1_allgrants <= ili_ncs_s1_grant_vector;
  --ili_ncs_s1_end_xfer assignment, which is an e_assign
  ili_ncs_s1_end_xfer <= NOT ((ili_ncs_s1_waits_for_read OR ili_ncs_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_ili_ncs_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_ili_ncs_s1 <= ili_ncs_s1_end_xfer AND (((NOT ili_ncs_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --ili_ncs_s1_arb_share_counter arbitration counter enable, which is an e_assign
  ili_ncs_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_ili_ncs_s1 AND ili_ncs_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_ili_ncs_s1 AND NOT ili_ncs_s1_non_bursting_master_requests));
  --ili_ncs_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ili_ncs_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(ili_ncs_s1_arb_counter_enable) = '1' then 
        ili_ncs_s1_arb_share_counter <= ili_ncs_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --ili_ncs_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ili_ncs_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((ili_ncs_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_ili_ncs_s1)) OR ((end_xfer_arb_share_counter_term_ili_ncs_s1 AND NOT ili_ncs_s1_non_bursting_master_requests)))) = '1' then 
        ili_ncs_s1_slavearbiterlockenable <= ili_ncs_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pipeline_bridge/m1 ili_ncs/s1 arbiterlock, which is an e_assign
  pipeline_bridge_m1_arbiterlock <= ili_ncs_s1_slavearbiterlockenable AND pipeline_bridge_m1_continuerequest;
  --ili_ncs_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  ili_ncs_s1_slavearbiterlockenable2 <= ili_ncs_s1_arb_share_counter_next_value;
  --pipeline_bridge/m1 ili_ncs/s1 arbiterlock2, which is an e_assign
  pipeline_bridge_m1_arbiterlock2 <= ili_ncs_s1_slavearbiterlockenable2 AND pipeline_bridge_m1_continuerequest;
  --ili_ncs_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  ili_ncs_s1_any_continuerequest <= std_logic'('1');
  --pipeline_bridge_m1_continuerequest continued request, which is an e_assign
  pipeline_bridge_m1_continuerequest <= std_logic'('1');
  internal_pipeline_bridge_m1_qualified_request_ili_ncs_s1 <= internal_pipeline_bridge_m1_requests_ili_ncs_s1 AND NOT ((((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))))));
  --local readdatavalid pipeline_bridge_m1_read_data_valid_ili_ncs_s1, which is an e_mux
  pipeline_bridge_m1_read_data_valid_ili_ncs_s1 <= (internal_pipeline_bridge_m1_granted_ili_ncs_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect))) AND NOT ili_ncs_s1_waits_for_read;
  --ili_ncs_s1_writedata mux, which is an e_mux
  ili_ncs_s1_writedata <= pipeline_bridge_m1_writedata;
  --master is always granted when requested
  internal_pipeline_bridge_m1_granted_ili_ncs_s1 <= internal_pipeline_bridge_m1_qualified_request_ili_ncs_s1;
  --pipeline_bridge/m1 saved-grant ili_ncs/s1, which is an e_assign
  pipeline_bridge_m1_saved_grant_ili_ncs_s1 <= internal_pipeline_bridge_m1_requests_ili_ncs_s1;
  --allow new arb cycle for ili_ncs/s1, which is an e_assign
  ili_ncs_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  ili_ncs_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  ili_ncs_s1_master_qreq_vector <= std_logic'('1');
  --ili_ncs_s1_reset_n assignment, which is an e_assign
  ili_ncs_s1_reset_n <= reset_n;
  ili_ncs_s1_chipselect <= internal_pipeline_bridge_m1_granted_ili_ncs_s1;
  --ili_ncs_s1_firsttransfer first transaction, which is an e_assign
  ili_ncs_s1_firsttransfer <= A_WE_StdLogic((std_logic'(ili_ncs_s1_begins_xfer) = '1'), ili_ncs_s1_unreg_firsttransfer, ili_ncs_s1_reg_firsttransfer);
  --ili_ncs_s1_unreg_firsttransfer first transaction, which is an e_assign
  ili_ncs_s1_unreg_firsttransfer <= NOT ((ili_ncs_s1_slavearbiterlockenable AND ili_ncs_s1_any_continuerequest));
  --ili_ncs_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ili_ncs_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(ili_ncs_s1_begins_xfer) = '1' then 
        ili_ncs_s1_reg_firsttransfer <= ili_ncs_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --ili_ncs_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  ili_ncs_s1_beginbursttransfer_internal <= ili_ncs_s1_begins_xfer;
  --~ili_ncs_s1_write_n assignment, which is an e_mux
  ili_ncs_s1_write_n <= NOT ((internal_pipeline_bridge_m1_granted_ili_ncs_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect))));
  shifted_address_to_ili_ncs_s1_from_pipeline_bridge_m1 <= pipeline_bridge_m1_address_to_slave;
  --ili_ncs_s1_address mux, which is an e_mux
  ili_ncs_s1_address <= A_EXT (A_SRL(shifted_address_to_ili_ncs_s1_from_pipeline_bridge_m1,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_ili_ncs_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_ili_ncs_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_ili_ncs_s1_end_xfer <= ili_ncs_s1_end_xfer;
    end if;

  end process;

  --ili_ncs_s1_waits_for_read in a cycle, which is an e_mux
  ili_ncs_s1_waits_for_read <= ili_ncs_s1_in_a_read_cycle AND ili_ncs_s1_begins_xfer;
  --ili_ncs_s1_in_a_read_cycle assignment, which is an e_assign
  ili_ncs_s1_in_a_read_cycle <= internal_pipeline_bridge_m1_granted_ili_ncs_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= ili_ncs_s1_in_a_read_cycle;
  --ili_ncs_s1_waits_for_write in a cycle, which is an e_mux
  ili_ncs_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ili_ncs_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --ili_ncs_s1_in_a_write_cycle assignment, which is an e_assign
  ili_ncs_s1_in_a_write_cycle <= internal_pipeline_bridge_m1_granted_ili_ncs_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect));
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= ili_ncs_s1_in_a_write_cycle;
  wait_for_ili_ncs_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  pipeline_bridge_m1_granted_ili_ncs_s1 <= internal_pipeline_bridge_m1_granted_ili_ncs_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_qualified_request_ili_ncs_s1 <= internal_pipeline_bridge_m1_qualified_request_ili_ncs_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_requests_ili_ncs_s1 <= internal_pipeline_bridge_m1_requests_ili_ncs_s1;
--synthesis translate_off
    --ili_ncs/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --pipeline_bridge/m1 non-zero burstcount assertion, which is an e_process
    process (clk)
    VARIABLE write_line13 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((internal_pipeline_bridge_m1_requests_ili_ncs_s1 AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_burstcount))) = std_logic_vector'("00000000000000000000000000000000"))))) AND enable_nonzero_assertions)) = '1' then 
          write(write_line13, now);
          write(write_line13, string'(": "));
          write(write_line13, string'("pipeline_bridge/m1 drove 0 on its 'burstcount' port while accessing slave ili_ncs/s1"));
          write(output, write_line13.all);
          deallocate (write_line13);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

library std;
use std.textio.all;

entity ili_nrd_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal ili_nrd_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                 signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                 signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read : IN STD_LOGIC;
                 signal pipeline_bridge_m1_write : IN STD_LOGIC;
                 signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal d1_ili_nrd_s1_end_xfer : OUT STD_LOGIC;
                 signal ili_nrd_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ili_nrd_s1_chipselect : OUT STD_LOGIC;
                 signal ili_nrd_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ili_nrd_s1_reset_n : OUT STD_LOGIC;
                 signal ili_nrd_s1_write_n : OUT STD_LOGIC;
                 signal ili_nrd_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_m1_granted_ili_nrd_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ili_nrd_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ili_nrd_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ili_nrd_s1 : OUT STD_LOGIC
              );
end entity ili_nrd_s1_arbitrator;


architecture europa of ili_nrd_s1_arbitrator is
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_ili_nrd_s1 :  STD_LOGIC;
                signal ili_nrd_s1_allgrants :  STD_LOGIC;
                signal ili_nrd_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal ili_nrd_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal ili_nrd_s1_any_continuerequest :  STD_LOGIC;
                signal ili_nrd_s1_arb_counter_enable :  STD_LOGIC;
                signal ili_nrd_s1_arb_share_counter :  STD_LOGIC;
                signal ili_nrd_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal ili_nrd_s1_arb_share_set_values :  STD_LOGIC;
                signal ili_nrd_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal ili_nrd_s1_begins_xfer :  STD_LOGIC;
                signal ili_nrd_s1_end_xfer :  STD_LOGIC;
                signal ili_nrd_s1_firsttransfer :  STD_LOGIC;
                signal ili_nrd_s1_grant_vector :  STD_LOGIC;
                signal ili_nrd_s1_in_a_read_cycle :  STD_LOGIC;
                signal ili_nrd_s1_in_a_write_cycle :  STD_LOGIC;
                signal ili_nrd_s1_master_qreq_vector :  STD_LOGIC;
                signal ili_nrd_s1_non_bursting_master_requests :  STD_LOGIC;
                signal ili_nrd_s1_reg_firsttransfer :  STD_LOGIC;
                signal ili_nrd_s1_slavearbiterlockenable :  STD_LOGIC;
                signal ili_nrd_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal ili_nrd_s1_unreg_firsttransfer :  STD_LOGIC;
                signal ili_nrd_s1_waits_for_read :  STD_LOGIC;
                signal ili_nrd_s1_waits_for_write :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_granted_ili_nrd_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_qualified_request_ili_nrd_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_requests_ili_nrd_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock2 :  STD_LOGIC;
                signal pipeline_bridge_m1_continuerequest :  STD_LOGIC;
                signal pipeline_bridge_m1_saved_grant_ili_nrd_s1 :  STD_LOGIC;
                signal shifted_address_to_ili_nrd_s1_from_pipeline_bridge_m1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal wait_for_ili_nrd_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT ili_nrd_s1_end_xfer;
    end if;

  end process;

  ili_nrd_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_pipeline_bridge_m1_qualified_request_ili_nrd_s1);
  --assign ili_nrd_s1_readdata_from_sa = ili_nrd_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  ili_nrd_s1_readdata_from_sa <= ili_nrd_s1_readdata;
  internal_pipeline_bridge_m1_requests_ili_nrd_s1 <= to_std_logic(((Std_Logic_Vector'(pipeline_bridge_m1_address_to_slave(7 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("10110000")))) AND pipeline_bridge_m1_chipselect;
  --ili_nrd_s1_arb_share_counter set values, which is an e_mux
  ili_nrd_s1_arb_share_set_values <= std_logic'('1');
  --ili_nrd_s1_non_bursting_master_requests mux, which is an e_mux
  ili_nrd_s1_non_bursting_master_requests <= internal_pipeline_bridge_m1_requests_ili_nrd_s1;
  --ili_nrd_s1_any_bursting_master_saved_grant mux, which is an e_mux
  ili_nrd_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --ili_nrd_s1_arb_share_counter_next_value assignment, which is an e_assign
  ili_nrd_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(ili_nrd_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ili_nrd_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(ili_nrd_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ili_nrd_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --ili_nrd_s1_allgrants all slave grants, which is an e_mux
  ili_nrd_s1_allgrants <= ili_nrd_s1_grant_vector;
  --ili_nrd_s1_end_xfer assignment, which is an e_assign
  ili_nrd_s1_end_xfer <= NOT ((ili_nrd_s1_waits_for_read OR ili_nrd_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_ili_nrd_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_ili_nrd_s1 <= ili_nrd_s1_end_xfer AND (((NOT ili_nrd_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --ili_nrd_s1_arb_share_counter arbitration counter enable, which is an e_assign
  ili_nrd_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_ili_nrd_s1 AND ili_nrd_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_ili_nrd_s1 AND NOT ili_nrd_s1_non_bursting_master_requests));
  --ili_nrd_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ili_nrd_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(ili_nrd_s1_arb_counter_enable) = '1' then 
        ili_nrd_s1_arb_share_counter <= ili_nrd_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --ili_nrd_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ili_nrd_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((ili_nrd_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_ili_nrd_s1)) OR ((end_xfer_arb_share_counter_term_ili_nrd_s1 AND NOT ili_nrd_s1_non_bursting_master_requests)))) = '1' then 
        ili_nrd_s1_slavearbiterlockenable <= ili_nrd_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pipeline_bridge/m1 ili_nrd/s1 arbiterlock, which is an e_assign
  pipeline_bridge_m1_arbiterlock <= ili_nrd_s1_slavearbiterlockenable AND pipeline_bridge_m1_continuerequest;
  --ili_nrd_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  ili_nrd_s1_slavearbiterlockenable2 <= ili_nrd_s1_arb_share_counter_next_value;
  --pipeline_bridge/m1 ili_nrd/s1 arbiterlock2, which is an e_assign
  pipeline_bridge_m1_arbiterlock2 <= ili_nrd_s1_slavearbiterlockenable2 AND pipeline_bridge_m1_continuerequest;
  --ili_nrd_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  ili_nrd_s1_any_continuerequest <= std_logic'('1');
  --pipeline_bridge_m1_continuerequest continued request, which is an e_assign
  pipeline_bridge_m1_continuerequest <= std_logic'('1');
  internal_pipeline_bridge_m1_qualified_request_ili_nrd_s1 <= internal_pipeline_bridge_m1_requests_ili_nrd_s1 AND NOT ((((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))))));
  --local readdatavalid pipeline_bridge_m1_read_data_valid_ili_nrd_s1, which is an e_mux
  pipeline_bridge_m1_read_data_valid_ili_nrd_s1 <= (internal_pipeline_bridge_m1_granted_ili_nrd_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect))) AND NOT ili_nrd_s1_waits_for_read;
  --ili_nrd_s1_writedata mux, which is an e_mux
  ili_nrd_s1_writedata <= pipeline_bridge_m1_writedata;
  --master is always granted when requested
  internal_pipeline_bridge_m1_granted_ili_nrd_s1 <= internal_pipeline_bridge_m1_qualified_request_ili_nrd_s1;
  --pipeline_bridge/m1 saved-grant ili_nrd/s1, which is an e_assign
  pipeline_bridge_m1_saved_grant_ili_nrd_s1 <= internal_pipeline_bridge_m1_requests_ili_nrd_s1;
  --allow new arb cycle for ili_nrd/s1, which is an e_assign
  ili_nrd_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  ili_nrd_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  ili_nrd_s1_master_qreq_vector <= std_logic'('1');
  --ili_nrd_s1_reset_n assignment, which is an e_assign
  ili_nrd_s1_reset_n <= reset_n;
  ili_nrd_s1_chipselect <= internal_pipeline_bridge_m1_granted_ili_nrd_s1;
  --ili_nrd_s1_firsttransfer first transaction, which is an e_assign
  ili_nrd_s1_firsttransfer <= A_WE_StdLogic((std_logic'(ili_nrd_s1_begins_xfer) = '1'), ili_nrd_s1_unreg_firsttransfer, ili_nrd_s1_reg_firsttransfer);
  --ili_nrd_s1_unreg_firsttransfer first transaction, which is an e_assign
  ili_nrd_s1_unreg_firsttransfer <= NOT ((ili_nrd_s1_slavearbiterlockenable AND ili_nrd_s1_any_continuerequest));
  --ili_nrd_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ili_nrd_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(ili_nrd_s1_begins_xfer) = '1' then 
        ili_nrd_s1_reg_firsttransfer <= ili_nrd_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --ili_nrd_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  ili_nrd_s1_beginbursttransfer_internal <= ili_nrd_s1_begins_xfer;
  --~ili_nrd_s1_write_n assignment, which is an e_mux
  ili_nrd_s1_write_n <= NOT ((internal_pipeline_bridge_m1_granted_ili_nrd_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect))));
  shifted_address_to_ili_nrd_s1_from_pipeline_bridge_m1 <= pipeline_bridge_m1_address_to_slave;
  --ili_nrd_s1_address mux, which is an e_mux
  ili_nrd_s1_address <= A_EXT (A_SRL(shifted_address_to_ili_nrd_s1_from_pipeline_bridge_m1,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_ili_nrd_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_ili_nrd_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_ili_nrd_s1_end_xfer <= ili_nrd_s1_end_xfer;
    end if;

  end process;

  --ili_nrd_s1_waits_for_read in a cycle, which is an e_mux
  ili_nrd_s1_waits_for_read <= ili_nrd_s1_in_a_read_cycle AND ili_nrd_s1_begins_xfer;
  --ili_nrd_s1_in_a_read_cycle assignment, which is an e_assign
  ili_nrd_s1_in_a_read_cycle <= internal_pipeline_bridge_m1_granted_ili_nrd_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= ili_nrd_s1_in_a_read_cycle;
  --ili_nrd_s1_waits_for_write in a cycle, which is an e_mux
  ili_nrd_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ili_nrd_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --ili_nrd_s1_in_a_write_cycle assignment, which is an e_assign
  ili_nrd_s1_in_a_write_cycle <= internal_pipeline_bridge_m1_granted_ili_nrd_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect));
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= ili_nrd_s1_in_a_write_cycle;
  wait_for_ili_nrd_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  pipeline_bridge_m1_granted_ili_nrd_s1 <= internal_pipeline_bridge_m1_granted_ili_nrd_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_qualified_request_ili_nrd_s1 <= internal_pipeline_bridge_m1_qualified_request_ili_nrd_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_requests_ili_nrd_s1 <= internal_pipeline_bridge_m1_requests_ili_nrd_s1;
--synthesis translate_off
    --ili_nrd/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --pipeline_bridge/m1 non-zero burstcount assertion, which is an e_process
    process (clk)
    VARIABLE write_line14 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((internal_pipeline_bridge_m1_requests_ili_nrd_s1 AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_burstcount))) = std_logic_vector'("00000000000000000000000000000000"))))) AND enable_nonzero_assertions)) = '1' then 
          write(write_line14, now);
          write(write_line14, string'(": "));
          write(write_line14, string'("pipeline_bridge/m1 drove 0 on its 'burstcount' port while accessing slave ili_nrd/s1"));
          write(output, write_line14.all);
          deallocate (write_line14);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

library std;
use std.textio.all;

entity ili_nrst_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal ili_nrst_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                 signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                 signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read : IN STD_LOGIC;
                 signal pipeline_bridge_m1_write : IN STD_LOGIC;
                 signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal d1_ili_nrst_s1_end_xfer : OUT STD_LOGIC;
                 signal ili_nrst_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ili_nrst_s1_chipselect : OUT STD_LOGIC;
                 signal ili_nrst_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ili_nrst_s1_reset_n : OUT STD_LOGIC;
                 signal ili_nrst_s1_write_n : OUT STD_LOGIC;
                 signal ili_nrst_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_m1_granted_ili_nrst_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ili_nrst_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ili_nrst_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ili_nrst_s1 : OUT STD_LOGIC
              );
end entity ili_nrst_s1_arbitrator;


architecture europa of ili_nrst_s1_arbitrator is
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_ili_nrst_s1 :  STD_LOGIC;
                signal ili_nrst_s1_allgrants :  STD_LOGIC;
                signal ili_nrst_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal ili_nrst_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal ili_nrst_s1_any_continuerequest :  STD_LOGIC;
                signal ili_nrst_s1_arb_counter_enable :  STD_LOGIC;
                signal ili_nrst_s1_arb_share_counter :  STD_LOGIC;
                signal ili_nrst_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal ili_nrst_s1_arb_share_set_values :  STD_LOGIC;
                signal ili_nrst_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal ili_nrst_s1_begins_xfer :  STD_LOGIC;
                signal ili_nrst_s1_end_xfer :  STD_LOGIC;
                signal ili_nrst_s1_firsttransfer :  STD_LOGIC;
                signal ili_nrst_s1_grant_vector :  STD_LOGIC;
                signal ili_nrst_s1_in_a_read_cycle :  STD_LOGIC;
                signal ili_nrst_s1_in_a_write_cycle :  STD_LOGIC;
                signal ili_nrst_s1_master_qreq_vector :  STD_LOGIC;
                signal ili_nrst_s1_non_bursting_master_requests :  STD_LOGIC;
                signal ili_nrst_s1_reg_firsttransfer :  STD_LOGIC;
                signal ili_nrst_s1_slavearbiterlockenable :  STD_LOGIC;
                signal ili_nrst_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal ili_nrst_s1_unreg_firsttransfer :  STD_LOGIC;
                signal ili_nrst_s1_waits_for_read :  STD_LOGIC;
                signal ili_nrst_s1_waits_for_write :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_granted_ili_nrst_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_qualified_request_ili_nrst_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_requests_ili_nrst_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock2 :  STD_LOGIC;
                signal pipeline_bridge_m1_continuerequest :  STD_LOGIC;
                signal pipeline_bridge_m1_saved_grant_ili_nrst_s1 :  STD_LOGIC;
                signal shifted_address_to_ili_nrst_s1_from_pipeline_bridge_m1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal wait_for_ili_nrst_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT ili_nrst_s1_end_xfer;
    end if;

  end process;

  ili_nrst_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_pipeline_bridge_m1_qualified_request_ili_nrst_s1);
  --assign ili_nrst_s1_readdata_from_sa = ili_nrst_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  ili_nrst_s1_readdata_from_sa <= ili_nrst_s1_readdata;
  internal_pipeline_bridge_m1_requests_ili_nrst_s1 <= to_std_logic(((Std_Logic_Vector'(pipeline_bridge_m1_address_to_slave(7 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("00010000")))) AND pipeline_bridge_m1_chipselect;
  --ili_nrst_s1_arb_share_counter set values, which is an e_mux
  ili_nrst_s1_arb_share_set_values <= std_logic'('1');
  --ili_nrst_s1_non_bursting_master_requests mux, which is an e_mux
  ili_nrst_s1_non_bursting_master_requests <= internal_pipeline_bridge_m1_requests_ili_nrst_s1;
  --ili_nrst_s1_any_bursting_master_saved_grant mux, which is an e_mux
  ili_nrst_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --ili_nrst_s1_arb_share_counter_next_value assignment, which is an e_assign
  ili_nrst_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(ili_nrst_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ili_nrst_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(ili_nrst_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ili_nrst_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --ili_nrst_s1_allgrants all slave grants, which is an e_mux
  ili_nrst_s1_allgrants <= ili_nrst_s1_grant_vector;
  --ili_nrst_s1_end_xfer assignment, which is an e_assign
  ili_nrst_s1_end_xfer <= NOT ((ili_nrst_s1_waits_for_read OR ili_nrst_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_ili_nrst_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_ili_nrst_s1 <= ili_nrst_s1_end_xfer AND (((NOT ili_nrst_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --ili_nrst_s1_arb_share_counter arbitration counter enable, which is an e_assign
  ili_nrst_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_ili_nrst_s1 AND ili_nrst_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_ili_nrst_s1 AND NOT ili_nrst_s1_non_bursting_master_requests));
  --ili_nrst_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ili_nrst_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(ili_nrst_s1_arb_counter_enable) = '1' then 
        ili_nrst_s1_arb_share_counter <= ili_nrst_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --ili_nrst_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ili_nrst_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((ili_nrst_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_ili_nrst_s1)) OR ((end_xfer_arb_share_counter_term_ili_nrst_s1 AND NOT ili_nrst_s1_non_bursting_master_requests)))) = '1' then 
        ili_nrst_s1_slavearbiterlockenable <= ili_nrst_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pipeline_bridge/m1 ili_nrst/s1 arbiterlock, which is an e_assign
  pipeline_bridge_m1_arbiterlock <= ili_nrst_s1_slavearbiterlockenable AND pipeline_bridge_m1_continuerequest;
  --ili_nrst_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  ili_nrst_s1_slavearbiterlockenable2 <= ili_nrst_s1_arb_share_counter_next_value;
  --pipeline_bridge/m1 ili_nrst/s1 arbiterlock2, which is an e_assign
  pipeline_bridge_m1_arbiterlock2 <= ili_nrst_s1_slavearbiterlockenable2 AND pipeline_bridge_m1_continuerequest;
  --ili_nrst_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  ili_nrst_s1_any_continuerequest <= std_logic'('1');
  --pipeline_bridge_m1_continuerequest continued request, which is an e_assign
  pipeline_bridge_m1_continuerequest <= std_logic'('1');
  internal_pipeline_bridge_m1_qualified_request_ili_nrst_s1 <= internal_pipeline_bridge_m1_requests_ili_nrst_s1 AND NOT ((((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))))));
  --local readdatavalid pipeline_bridge_m1_read_data_valid_ili_nrst_s1, which is an e_mux
  pipeline_bridge_m1_read_data_valid_ili_nrst_s1 <= (internal_pipeline_bridge_m1_granted_ili_nrst_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect))) AND NOT ili_nrst_s1_waits_for_read;
  --ili_nrst_s1_writedata mux, which is an e_mux
  ili_nrst_s1_writedata <= pipeline_bridge_m1_writedata;
  --master is always granted when requested
  internal_pipeline_bridge_m1_granted_ili_nrst_s1 <= internal_pipeline_bridge_m1_qualified_request_ili_nrst_s1;
  --pipeline_bridge/m1 saved-grant ili_nrst/s1, which is an e_assign
  pipeline_bridge_m1_saved_grant_ili_nrst_s1 <= internal_pipeline_bridge_m1_requests_ili_nrst_s1;
  --allow new arb cycle for ili_nrst/s1, which is an e_assign
  ili_nrst_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  ili_nrst_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  ili_nrst_s1_master_qreq_vector <= std_logic'('1');
  --ili_nrst_s1_reset_n assignment, which is an e_assign
  ili_nrst_s1_reset_n <= reset_n;
  ili_nrst_s1_chipselect <= internal_pipeline_bridge_m1_granted_ili_nrst_s1;
  --ili_nrst_s1_firsttransfer first transaction, which is an e_assign
  ili_nrst_s1_firsttransfer <= A_WE_StdLogic((std_logic'(ili_nrst_s1_begins_xfer) = '1'), ili_nrst_s1_unreg_firsttransfer, ili_nrst_s1_reg_firsttransfer);
  --ili_nrst_s1_unreg_firsttransfer first transaction, which is an e_assign
  ili_nrst_s1_unreg_firsttransfer <= NOT ((ili_nrst_s1_slavearbiterlockenable AND ili_nrst_s1_any_continuerequest));
  --ili_nrst_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ili_nrst_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(ili_nrst_s1_begins_xfer) = '1' then 
        ili_nrst_s1_reg_firsttransfer <= ili_nrst_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --ili_nrst_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  ili_nrst_s1_beginbursttransfer_internal <= ili_nrst_s1_begins_xfer;
  --~ili_nrst_s1_write_n assignment, which is an e_mux
  ili_nrst_s1_write_n <= NOT ((internal_pipeline_bridge_m1_granted_ili_nrst_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect))));
  shifted_address_to_ili_nrst_s1_from_pipeline_bridge_m1 <= pipeline_bridge_m1_address_to_slave;
  --ili_nrst_s1_address mux, which is an e_mux
  ili_nrst_s1_address <= A_EXT (A_SRL(shifted_address_to_ili_nrst_s1_from_pipeline_bridge_m1,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_ili_nrst_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_ili_nrst_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_ili_nrst_s1_end_xfer <= ili_nrst_s1_end_xfer;
    end if;

  end process;

  --ili_nrst_s1_waits_for_read in a cycle, which is an e_mux
  ili_nrst_s1_waits_for_read <= ili_nrst_s1_in_a_read_cycle AND ili_nrst_s1_begins_xfer;
  --ili_nrst_s1_in_a_read_cycle assignment, which is an e_assign
  ili_nrst_s1_in_a_read_cycle <= internal_pipeline_bridge_m1_granted_ili_nrst_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= ili_nrst_s1_in_a_read_cycle;
  --ili_nrst_s1_waits_for_write in a cycle, which is an e_mux
  ili_nrst_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ili_nrst_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --ili_nrst_s1_in_a_write_cycle assignment, which is an e_assign
  ili_nrst_s1_in_a_write_cycle <= internal_pipeline_bridge_m1_granted_ili_nrst_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect));
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= ili_nrst_s1_in_a_write_cycle;
  wait_for_ili_nrst_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  pipeline_bridge_m1_granted_ili_nrst_s1 <= internal_pipeline_bridge_m1_granted_ili_nrst_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_qualified_request_ili_nrst_s1 <= internal_pipeline_bridge_m1_qualified_request_ili_nrst_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_requests_ili_nrst_s1 <= internal_pipeline_bridge_m1_requests_ili_nrst_s1;
--synthesis translate_off
    --ili_nrst/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --pipeline_bridge/m1 non-zero burstcount assertion, which is an e_process
    process (clk)
    VARIABLE write_line15 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((internal_pipeline_bridge_m1_requests_ili_nrst_s1 AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_burstcount))) = std_logic_vector'("00000000000000000000000000000000"))))) AND enable_nonzero_assertions)) = '1' then 
          write(write_line15, now);
          write(write_line15, string'(": "));
          write(write_line15, string'("pipeline_bridge/m1 drove 0 on its 'burstcount' port while accessing slave ili_nrst/s1"));
          write(output, write_line15.all);
          deallocate (write_line15);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

library std;
use std.textio.all;

entity ili_nwr_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal ili_nwr_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                 signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                 signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read : IN STD_LOGIC;
                 signal pipeline_bridge_m1_write : IN STD_LOGIC;
                 signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal d1_ili_nwr_s1_end_xfer : OUT STD_LOGIC;
                 signal ili_nwr_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ili_nwr_s1_chipselect : OUT STD_LOGIC;
                 signal ili_nwr_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ili_nwr_s1_reset_n : OUT STD_LOGIC;
                 signal ili_nwr_s1_write_n : OUT STD_LOGIC;
                 signal ili_nwr_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_m1_granted_ili_nwr_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ili_nwr_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ili_nwr_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ili_nwr_s1 : OUT STD_LOGIC
              );
end entity ili_nwr_s1_arbitrator;


architecture europa of ili_nwr_s1_arbitrator is
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_ili_nwr_s1 :  STD_LOGIC;
                signal ili_nwr_s1_allgrants :  STD_LOGIC;
                signal ili_nwr_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal ili_nwr_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal ili_nwr_s1_any_continuerequest :  STD_LOGIC;
                signal ili_nwr_s1_arb_counter_enable :  STD_LOGIC;
                signal ili_nwr_s1_arb_share_counter :  STD_LOGIC;
                signal ili_nwr_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal ili_nwr_s1_arb_share_set_values :  STD_LOGIC;
                signal ili_nwr_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal ili_nwr_s1_begins_xfer :  STD_LOGIC;
                signal ili_nwr_s1_end_xfer :  STD_LOGIC;
                signal ili_nwr_s1_firsttransfer :  STD_LOGIC;
                signal ili_nwr_s1_grant_vector :  STD_LOGIC;
                signal ili_nwr_s1_in_a_read_cycle :  STD_LOGIC;
                signal ili_nwr_s1_in_a_write_cycle :  STD_LOGIC;
                signal ili_nwr_s1_master_qreq_vector :  STD_LOGIC;
                signal ili_nwr_s1_non_bursting_master_requests :  STD_LOGIC;
                signal ili_nwr_s1_reg_firsttransfer :  STD_LOGIC;
                signal ili_nwr_s1_slavearbiterlockenable :  STD_LOGIC;
                signal ili_nwr_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal ili_nwr_s1_unreg_firsttransfer :  STD_LOGIC;
                signal ili_nwr_s1_waits_for_read :  STD_LOGIC;
                signal ili_nwr_s1_waits_for_write :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_granted_ili_nwr_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_qualified_request_ili_nwr_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_requests_ili_nwr_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock2 :  STD_LOGIC;
                signal pipeline_bridge_m1_continuerequest :  STD_LOGIC;
                signal pipeline_bridge_m1_saved_grant_ili_nwr_s1 :  STD_LOGIC;
                signal shifted_address_to_ili_nwr_s1_from_pipeline_bridge_m1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal wait_for_ili_nwr_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT ili_nwr_s1_end_xfer;
    end if;

  end process;

  ili_nwr_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_pipeline_bridge_m1_qualified_request_ili_nwr_s1);
  --assign ili_nwr_s1_readdata_from_sa = ili_nwr_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  ili_nwr_s1_readdata_from_sa <= ili_nwr_s1_readdata;
  internal_pipeline_bridge_m1_requests_ili_nwr_s1 <= to_std_logic(((Std_Logic_Vector'(pipeline_bridge_m1_address_to_slave(7 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("11110000")))) AND pipeline_bridge_m1_chipselect;
  --ili_nwr_s1_arb_share_counter set values, which is an e_mux
  ili_nwr_s1_arb_share_set_values <= std_logic'('1');
  --ili_nwr_s1_non_bursting_master_requests mux, which is an e_mux
  ili_nwr_s1_non_bursting_master_requests <= internal_pipeline_bridge_m1_requests_ili_nwr_s1;
  --ili_nwr_s1_any_bursting_master_saved_grant mux, which is an e_mux
  ili_nwr_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --ili_nwr_s1_arb_share_counter_next_value assignment, which is an e_assign
  ili_nwr_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(ili_nwr_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ili_nwr_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(ili_nwr_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ili_nwr_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --ili_nwr_s1_allgrants all slave grants, which is an e_mux
  ili_nwr_s1_allgrants <= ili_nwr_s1_grant_vector;
  --ili_nwr_s1_end_xfer assignment, which is an e_assign
  ili_nwr_s1_end_xfer <= NOT ((ili_nwr_s1_waits_for_read OR ili_nwr_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_ili_nwr_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_ili_nwr_s1 <= ili_nwr_s1_end_xfer AND (((NOT ili_nwr_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --ili_nwr_s1_arb_share_counter arbitration counter enable, which is an e_assign
  ili_nwr_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_ili_nwr_s1 AND ili_nwr_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_ili_nwr_s1 AND NOT ili_nwr_s1_non_bursting_master_requests));
  --ili_nwr_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ili_nwr_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(ili_nwr_s1_arb_counter_enable) = '1' then 
        ili_nwr_s1_arb_share_counter <= ili_nwr_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --ili_nwr_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ili_nwr_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((ili_nwr_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_ili_nwr_s1)) OR ((end_xfer_arb_share_counter_term_ili_nwr_s1 AND NOT ili_nwr_s1_non_bursting_master_requests)))) = '1' then 
        ili_nwr_s1_slavearbiterlockenable <= ili_nwr_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pipeline_bridge/m1 ili_nwr/s1 arbiterlock, which is an e_assign
  pipeline_bridge_m1_arbiterlock <= ili_nwr_s1_slavearbiterlockenable AND pipeline_bridge_m1_continuerequest;
  --ili_nwr_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  ili_nwr_s1_slavearbiterlockenable2 <= ili_nwr_s1_arb_share_counter_next_value;
  --pipeline_bridge/m1 ili_nwr/s1 arbiterlock2, which is an e_assign
  pipeline_bridge_m1_arbiterlock2 <= ili_nwr_s1_slavearbiterlockenable2 AND pipeline_bridge_m1_continuerequest;
  --ili_nwr_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  ili_nwr_s1_any_continuerequest <= std_logic'('1');
  --pipeline_bridge_m1_continuerequest continued request, which is an e_assign
  pipeline_bridge_m1_continuerequest <= std_logic'('1');
  internal_pipeline_bridge_m1_qualified_request_ili_nwr_s1 <= internal_pipeline_bridge_m1_requests_ili_nwr_s1 AND NOT ((((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))))));
  --local readdatavalid pipeline_bridge_m1_read_data_valid_ili_nwr_s1, which is an e_mux
  pipeline_bridge_m1_read_data_valid_ili_nwr_s1 <= (internal_pipeline_bridge_m1_granted_ili_nwr_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect))) AND NOT ili_nwr_s1_waits_for_read;
  --ili_nwr_s1_writedata mux, which is an e_mux
  ili_nwr_s1_writedata <= pipeline_bridge_m1_writedata;
  --master is always granted when requested
  internal_pipeline_bridge_m1_granted_ili_nwr_s1 <= internal_pipeline_bridge_m1_qualified_request_ili_nwr_s1;
  --pipeline_bridge/m1 saved-grant ili_nwr/s1, which is an e_assign
  pipeline_bridge_m1_saved_grant_ili_nwr_s1 <= internal_pipeline_bridge_m1_requests_ili_nwr_s1;
  --allow new arb cycle for ili_nwr/s1, which is an e_assign
  ili_nwr_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  ili_nwr_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  ili_nwr_s1_master_qreq_vector <= std_logic'('1');
  --ili_nwr_s1_reset_n assignment, which is an e_assign
  ili_nwr_s1_reset_n <= reset_n;
  ili_nwr_s1_chipselect <= internal_pipeline_bridge_m1_granted_ili_nwr_s1;
  --ili_nwr_s1_firsttransfer first transaction, which is an e_assign
  ili_nwr_s1_firsttransfer <= A_WE_StdLogic((std_logic'(ili_nwr_s1_begins_xfer) = '1'), ili_nwr_s1_unreg_firsttransfer, ili_nwr_s1_reg_firsttransfer);
  --ili_nwr_s1_unreg_firsttransfer first transaction, which is an e_assign
  ili_nwr_s1_unreg_firsttransfer <= NOT ((ili_nwr_s1_slavearbiterlockenable AND ili_nwr_s1_any_continuerequest));
  --ili_nwr_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ili_nwr_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(ili_nwr_s1_begins_xfer) = '1' then 
        ili_nwr_s1_reg_firsttransfer <= ili_nwr_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --ili_nwr_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  ili_nwr_s1_beginbursttransfer_internal <= ili_nwr_s1_begins_xfer;
  --~ili_nwr_s1_write_n assignment, which is an e_mux
  ili_nwr_s1_write_n <= NOT ((internal_pipeline_bridge_m1_granted_ili_nwr_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect))));
  shifted_address_to_ili_nwr_s1_from_pipeline_bridge_m1 <= pipeline_bridge_m1_address_to_slave;
  --ili_nwr_s1_address mux, which is an e_mux
  ili_nwr_s1_address <= A_EXT (A_SRL(shifted_address_to_ili_nwr_s1_from_pipeline_bridge_m1,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_ili_nwr_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_ili_nwr_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_ili_nwr_s1_end_xfer <= ili_nwr_s1_end_xfer;
    end if;

  end process;

  --ili_nwr_s1_waits_for_read in a cycle, which is an e_mux
  ili_nwr_s1_waits_for_read <= ili_nwr_s1_in_a_read_cycle AND ili_nwr_s1_begins_xfer;
  --ili_nwr_s1_in_a_read_cycle assignment, which is an e_assign
  ili_nwr_s1_in_a_read_cycle <= internal_pipeline_bridge_m1_granted_ili_nwr_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= ili_nwr_s1_in_a_read_cycle;
  --ili_nwr_s1_waits_for_write in a cycle, which is an e_mux
  ili_nwr_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ili_nwr_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --ili_nwr_s1_in_a_write_cycle assignment, which is an e_assign
  ili_nwr_s1_in_a_write_cycle <= internal_pipeline_bridge_m1_granted_ili_nwr_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect));
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= ili_nwr_s1_in_a_write_cycle;
  wait_for_ili_nwr_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  pipeline_bridge_m1_granted_ili_nwr_s1 <= internal_pipeline_bridge_m1_granted_ili_nwr_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_qualified_request_ili_nwr_s1 <= internal_pipeline_bridge_m1_qualified_request_ili_nwr_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_requests_ili_nwr_s1 <= internal_pipeline_bridge_m1_requests_ili_nwr_s1;
--synthesis translate_off
    --ili_nwr/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --pipeline_bridge/m1 non-zero burstcount assertion, which is an e_process
    process (clk)
    VARIABLE write_line16 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((internal_pipeline_bridge_m1_requests_ili_nwr_s1 AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_burstcount))) = std_logic_vector'("00000000000000000000000000000000"))))) AND enable_nonzero_assertions)) = '1' then 
          write(write_line16, now);
          write(write_line16, string'(": "));
          write(write_line16, string'("pipeline_bridge/m1 drove 0 on its 'burstcount' port while accessing slave ili_nwr/s1"));
          write(output, write_line16.all);
          deallocate (write_line16);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

library std;
use std.textio.all;

entity ili_rs_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal ili_rs_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                 signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                 signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read : IN STD_LOGIC;
                 signal pipeline_bridge_m1_write : IN STD_LOGIC;
                 signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal d1_ili_rs_s1_end_xfer : OUT STD_LOGIC;
                 signal ili_rs_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal ili_rs_s1_chipselect : OUT STD_LOGIC;
                 signal ili_rs_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ili_rs_s1_reset_n : OUT STD_LOGIC;
                 signal ili_rs_s1_write_n : OUT STD_LOGIC;
                 signal ili_rs_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_m1_granted_ili_rs_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ili_rs_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ili_rs_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ili_rs_s1 : OUT STD_LOGIC
              );
end entity ili_rs_s1_arbitrator;


architecture europa of ili_rs_s1_arbitrator is
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_ili_rs_s1 :  STD_LOGIC;
                signal ili_rs_s1_allgrants :  STD_LOGIC;
                signal ili_rs_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal ili_rs_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal ili_rs_s1_any_continuerequest :  STD_LOGIC;
                signal ili_rs_s1_arb_counter_enable :  STD_LOGIC;
                signal ili_rs_s1_arb_share_counter :  STD_LOGIC;
                signal ili_rs_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal ili_rs_s1_arb_share_set_values :  STD_LOGIC;
                signal ili_rs_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal ili_rs_s1_begins_xfer :  STD_LOGIC;
                signal ili_rs_s1_end_xfer :  STD_LOGIC;
                signal ili_rs_s1_firsttransfer :  STD_LOGIC;
                signal ili_rs_s1_grant_vector :  STD_LOGIC;
                signal ili_rs_s1_in_a_read_cycle :  STD_LOGIC;
                signal ili_rs_s1_in_a_write_cycle :  STD_LOGIC;
                signal ili_rs_s1_master_qreq_vector :  STD_LOGIC;
                signal ili_rs_s1_non_bursting_master_requests :  STD_LOGIC;
                signal ili_rs_s1_reg_firsttransfer :  STD_LOGIC;
                signal ili_rs_s1_slavearbiterlockenable :  STD_LOGIC;
                signal ili_rs_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal ili_rs_s1_unreg_firsttransfer :  STD_LOGIC;
                signal ili_rs_s1_waits_for_read :  STD_LOGIC;
                signal ili_rs_s1_waits_for_write :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_granted_ili_rs_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_qualified_request_ili_rs_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_requests_ili_rs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock2 :  STD_LOGIC;
                signal pipeline_bridge_m1_continuerequest :  STD_LOGIC;
                signal pipeline_bridge_m1_saved_grant_ili_rs_s1 :  STD_LOGIC;
                signal shifted_address_to_ili_rs_s1_from_pipeline_bridge_m1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal wait_for_ili_rs_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT ili_rs_s1_end_xfer;
    end if;

  end process;

  ili_rs_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_pipeline_bridge_m1_qualified_request_ili_rs_s1);
  --assign ili_rs_s1_readdata_from_sa = ili_rs_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  ili_rs_s1_readdata_from_sa <= ili_rs_s1_readdata;
  internal_pipeline_bridge_m1_requests_ili_rs_s1 <= to_std_logic(((Std_Logic_Vector'(pipeline_bridge_m1_address_to_slave(7 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("11000000")))) AND pipeline_bridge_m1_chipselect;
  --ili_rs_s1_arb_share_counter set values, which is an e_mux
  ili_rs_s1_arb_share_set_values <= std_logic'('1');
  --ili_rs_s1_non_bursting_master_requests mux, which is an e_mux
  ili_rs_s1_non_bursting_master_requests <= internal_pipeline_bridge_m1_requests_ili_rs_s1;
  --ili_rs_s1_any_bursting_master_saved_grant mux, which is an e_mux
  ili_rs_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --ili_rs_s1_arb_share_counter_next_value assignment, which is an e_assign
  ili_rs_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(ili_rs_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ili_rs_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(ili_rs_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ili_rs_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --ili_rs_s1_allgrants all slave grants, which is an e_mux
  ili_rs_s1_allgrants <= ili_rs_s1_grant_vector;
  --ili_rs_s1_end_xfer assignment, which is an e_assign
  ili_rs_s1_end_xfer <= NOT ((ili_rs_s1_waits_for_read OR ili_rs_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_ili_rs_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_ili_rs_s1 <= ili_rs_s1_end_xfer AND (((NOT ili_rs_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --ili_rs_s1_arb_share_counter arbitration counter enable, which is an e_assign
  ili_rs_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_ili_rs_s1 AND ili_rs_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_ili_rs_s1 AND NOT ili_rs_s1_non_bursting_master_requests));
  --ili_rs_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ili_rs_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(ili_rs_s1_arb_counter_enable) = '1' then 
        ili_rs_s1_arb_share_counter <= ili_rs_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --ili_rs_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ili_rs_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((ili_rs_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_ili_rs_s1)) OR ((end_xfer_arb_share_counter_term_ili_rs_s1 AND NOT ili_rs_s1_non_bursting_master_requests)))) = '1' then 
        ili_rs_s1_slavearbiterlockenable <= ili_rs_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pipeline_bridge/m1 ili_rs/s1 arbiterlock, which is an e_assign
  pipeline_bridge_m1_arbiterlock <= ili_rs_s1_slavearbiterlockenable AND pipeline_bridge_m1_continuerequest;
  --ili_rs_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  ili_rs_s1_slavearbiterlockenable2 <= ili_rs_s1_arb_share_counter_next_value;
  --pipeline_bridge/m1 ili_rs/s1 arbiterlock2, which is an e_assign
  pipeline_bridge_m1_arbiterlock2 <= ili_rs_s1_slavearbiterlockenable2 AND pipeline_bridge_m1_continuerequest;
  --ili_rs_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  ili_rs_s1_any_continuerequest <= std_logic'('1');
  --pipeline_bridge_m1_continuerequest continued request, which is an e_assign
  pipeline_bridge_m1_continuerequest <= std_logic'('1');
  internal_pipeline_bridge_m1_qualified_request_ili_rs_s1 <= internal_pipeline_bridge_m1_requests_ili_rs_s1 AND NOT ((((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))))));
  --local readdatavalid pipeline_bridge_m1_read_data_valid_ili_rs_s1, which is an e_mux
  pipeline_bridge_m1_read_data_valid_ili_rs_s1 <= (internal_pipeline_bridge_m1_granted_ili_rs_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect))) AND NOT ili_rs_s1_waits_for_read;
  --ili_rs_s1_writedata mux, which is an e_mux
  ili_rs_s1_writedata <= pipeline_bridge_m1_writedata;
  --master is always granted when requested
  internal_pipeline_bridge_m1_granted_ili_rs_s1 <= internal_pipeline_bridge_m1_qualified_request_ili_rs_s1;
  --pipeline_bridge/m1 saved-grant ili_rs/s1, which is an e_assign
  pipeline_bridge_m1_saved_grant_ili_rs_s1 <= internal_pipeline_bridge_m1_requests_ili_rs_s1;
  --allow new arb cycle for ili_rs/s1, which is an e_assign
  ili_rs_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  ili_rs_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  ili_rs_s1_master_qreq_vector <= std_logic'('1');
  --ili_rs_s1_reset_n assignment, which is an e_assign
  ili_rs_s1_reset_n <= reset_n;
  ili_rs_s1_chipselect <= internal_pipeline_bridge_m1_granted_ili_rs_s1;
  --ili_rs_s1_firsttransfer first transaction, which is an e_assign
  ili_rs_s1_firsttransfer <= A_WE_StdLogic((std_logic'(ili_rs_s1_begins_xfer) = '1'), ili_rs_s1_unreg_firsttransfer, ili_rs_s1_reg_firsttransfer);
  --ili_rs_s1_unreg_firsttransfer first transaction, which is an e_assign
  ili_rs_s1_unreg_firsttransfer <= NOT ((ili_rs_s1_slavearbiterlockenable AND ili_rs_s1_any_continuerequest));
  --ili_rs_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ili_rs_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(ili_rs_s1_begins_xfer) = '1' then 
        ili_rs_s1_reg_firsttransfer <= ili_rs_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --ili_rs_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  ili_rs_s1_beginbursttransfer_internal <= ili_rs_s1_begins_xfer;
  --~ili_rs_s1_write_n assignment, which is an e_mux
  ili_rs_s1_write_n <= NOT ((internal_pipeline_bridge_m1_granted_ili_rs_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect))));
  shifted_address_to_ili_rs_s1_from_pipeline_bridge_m1 <= pipeline_bridge_m1_address_to_slave;
  --ili_rs_s1_address mux, which is an e_mux
  ili_rs_s1_address <= A_EXT (A_SRL(shifted_address_to_ili_rs_s1_from_pipeline_bridge_m1,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_ili_rs_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_ili_rs_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_ili_rs_s1_end_xfer <= ili_rs_s1_end_xfer;
    end if;

  end process;

  --ili_rs_s1_waits_for_read in a cycle, which is an e_mux
  ili_rs_s1_waits_for_read <= ili_rs_s1_in_a_read_cycle AND ili_rs_s1_begins_xfer;
  --ili_rs_s1_in_a_read_cycle assignment, which is an e_assign
  ili_rs_s1_in_a_read_cycle <= internal_pipeline_bridge_m1_granted_ili_rs_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= ili_rs_s1_in_a_read_cycle;
  --ili_rs_s1_waits_for_write in a cycle, which is an e_mux
  ili_rs_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ili_rs_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --ili_rs_s1_in_a_write_cycle assignment, which is an e_assign
  ili_rs_s1_in_a_write_cycle <= internal_pipeline_bridge_m1_granted_ili_rs_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect));
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= ili_rs_s1_in_a_write_cycle;
  wait_for_ili_rs_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  pipeline_bridge_m1_granted_ili_rs_s1 <= internal_pipeline_bridge_m1_granted_ili_rs_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_qualified_request_ili_rs_s1 <= internal_pipeline_bridge_m1_qualified_request_ili_rs_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_requests_ili_rs_s1 <= internal_pipeline_bridge_m1_requests_ili_rs_s1;
--synthesis translate_off
    --ili_rs/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --pipeline_bridge/m1 non-zero burstcount assertion, which is an e_process
    process (clk)
    VARIABLE write_line17 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((internal_pipeline_bridge_m1_requests_ili_rs_s1 AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_burstcount))) = std_logic_vector'("00000000000000000000000000000000"))))) AND enable_nonzero_assertions)) = '1' then 
          write(write_line17, now);
          write(write_line17, string'(": "));
          write(write_line17, string'("pipeline_bridge/m1 drove 0 on its 'burstcount' port while accessing slave ili_rs/s1"));
          write(output, write_line17.all);
          deallocate (write_line17);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

entity jtag_uart_avalon_jtag_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_avalon_jtag_slave_dataavailable : IN STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_irq : IN STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_avalon_jtag_slave_readyfordata : IN STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                 signal d1_jtag_uart_avalon_jtag_slave_end_xfer : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_address : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_chipselect : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_dataavailable_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_irq_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_read_n : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_avalon_jtag_slave_readyfordata_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_reset_n : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_write_n : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity jtag_uart_avalon_jtag_slave_arbitrator;


architecture europa of jtag_uart_avalon_jtag_slave_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_allgrants :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_any_continuerequest :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_arb_counter_enable :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal jtag_uart_avalon_jtag_slave_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal jtag_uart_avalon_jtag_slave_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal jtag_uart_avalon_jtag_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_begins_xfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_end_xfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_firsttransfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_grant_vector :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_in_a_read_cycle :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_in_a_write_cycle :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_master_qreq_vector :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_non_bursting_master_requests :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_reg_firsttransfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_slavearbiterlockenable :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_unreg_firsttransfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_waits_for_read :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_jtag_uart_avalon_jtag_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal wait_for_jtag_uart_avalon_jtag_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT jtag_uart_avalon_jtag_slave_end_xfer;
    end if;

  end process;

  jtag_uart_avalon_jtag_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave);
  --assign jtag_uart_avalon_jtag_slave_readdata_from_sa = jtag_uart_avalon_jtag_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_avalon_jtag_slave_readdata_from_sa <= jtag_uart_avalon_jtag_slave_readdata;
  internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(25 DOWNTO 3) & std_logic_vector'("000")) = std_logic_vector'("00000000000001100000000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign jtag_uart_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_avalon_jtag_slave_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_avalon_jtag_slave_dataavailable_from_sa <= jtag_uart_avalon_jtag_slave_dataavailable;
  --assign jtag_uart_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_avalon_jtag_slave_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_avalon_jtag_slave_readyfordata_from_sa <= jtag_uart_avalon_jtag_slave_readyfordata;
  --assign jtag_uart_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_avalon_jtag_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa <= jtag_uart_avalon_jtag_slave_waitrequest;
  --jtag_uart_avalon_jtag_slave_arb_share_counter set values, which is an e_mux
  jtag_uart_avalon_jtag_slave_arb_share_set_values <= std_logic_vector'("01");
  --jtag_uart_avalon_jtag_slave_non_bursting_master_requests mux, which is an e_mux
  jtag_uart_avalon_jtag_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave;
  --jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant mux, which is an e_mux
  jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --jtag_uart_avalon_jtag_slave_arb_share_counter_next_value assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(jtag_uart_avalon_jtag_slave_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (jtag_uart_avalon_jtag_slave_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(jtag_uart_avalon_jtag_slave_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (jtag_uart_avalon_jtag_slave_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --jtag_uart_avalon_jtag_slave_allgrants all slave grants, which is an e_mux
  jtag_uart_avalon_jtag_slave_allgrants <= jtag_uart_avalon_jtag_slave_grant_vector;
  --jtag_uart_avalon_jtag_slave_end_xfer assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_end_xfer <= NOT ((jtag_uart_avalon_jtag_slave_waits_for_read OR jtag_uart_avalon_jtag_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave <= jtag_uart_avalon_jtag_slave_end_xfer AND (((NOT jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --jtag_uart_avalon_jtag_slave_arb_share_counter arbitration counter enable, which is an e_assign
  jtag_uart_avalon_jtag_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave AND jtag_uart_avalon_jtag_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave AND NOT jtag_uart_avalon_jtag_slave_non_bursting_master_requests));
  --jtag_uart_avalon_jtag_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_avalon_jtag_slave_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(jtag_uart_avalon_jtag_slave_arb_counter_enable) = '1' then 
        jtag_uart_avalon_jtag_slave_arb_share_counter <= jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --jtag_uart_avalon_jtag_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_avalon_jtag_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((jtag_uart_avalon_jtag_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave)) OR ((end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave AND NOT jtag_uart_avalon_jtag_slave_non_bursting_master_requests)))) = '1' then 
        jtag_uart_avalon_jtag_slave_slavearbiterlockenable <= or_reduce(jtag_uart_avalon_jtag_slave_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu/data_master jtag_uart/avalon_jtag_slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= jtag_uart_avalon_jtag_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 <= or_reduce(jtag_uart_avalon_jtag_slave_arb_share_counter_next_value);
  --cpu/data_master jtag_uart/avalon_jtag_slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --jtag_uart_avalon_jtag_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  jtag_uart_avalon_jtag_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave AND NOT ((((cpu_data_master_read AND (NOT cpu_data_master_waitrequest))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --jtag_uart_avalon_jtag_slave_writedata mux, which is an e_mux
  jtag_uart_avalon_jtag_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  --cpu/data_master saved-grant jtag_uart/avalon_jtag_slave, which is an e_assign
  cpu_data_master_saved_grant_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave;
  --allow new arb cycle for jtag_uart/avalon_jtag_slave, which is an e_assign
  jtag_uart_avalon_jtag_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  jtag_uart_avalon_jtag_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  jtag_uart_avalon_jtag_slave_master_qreq_vector <= std_logic'('1');
  --jtag_uart_avalon_jtag_slave_reset_n assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_reset_n <= reset_n;
  jtag_uart_avalon_jtag_slave_chipselect <= internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave;
  --jtag_uart_avalon_jtag_slave_firsttransfer first transaction, which is an e_assign
  jtag_uart_avalon_jtag_slave_firsttransfer <= A_WE_StdLogic((std_logic'(jtag_uart_avalon_jtag_slave_begins_xfer) = '1'), jtag_uart_avalon_jtag_slave_unreg_firsttransfer, jtag_uart_avalon_jtag_slave_reg_firsttransfer);
  --jtag_uart_avalon_jtag_slave_unreg_firsttransfer first transaction, which is an e_assign
  jtag_uart_avalon_jtag_slave_unreg_firsttransfer <= NOT ((jtag_uart_avalon_jtag_slave_slavearbiterlockenable AND jtag_uart_avalon_jtag_slave_any_continuerequest));
  --jtag_uart_avalon_jtag_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_avalon_jtag_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(jtag_uart_avalon_jtag_slave_begins_xfer) = '1' then 
        jtag_uart_avalon_jtag_slave_reg_firsttransfer <= jtag_uart_avalon_jtag_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --jtag_uart_avalon_jtag_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  jtag_uart_avalon_jtag_slave_beginbursttransfer_internal <= jtag_uart_avalon_jtag_slave_begins_xfer;
  --~jtag_uart_avalon_jtag_slave_read_n assignment, which is an e_mux
  jtag_uart_avalon_jtag_slave_read_n <= NOT ((internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave AND cpu_data_master_read));
  --~jtag_uart_avalon_jtag_slave_write_n assignment, which is an e_mux
  jtag_uart_avalon_jtag_slave_write_n <= NOT ((internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave AND cpu_data_master_write));
  shifted_address_to_jtag_uart_avalon_jtag_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --jtag_uart_avalon_jtag_slave_address mux, which is an e_mux
  jtag_uart_avalon_jtag_slave_address <= Vector_To_Std_Logic(A_SRL(shifted_address_to_jtag_uart_avalon_jtag_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")));
  --d1_jtag_uart_avalon_jtag_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_jtag_uart_avalon_jtag_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_jtag_uart_avalon_jtag_slave_end_xfer <= jtag_uart_avalon_jtag_slave_end_xfer;
    end if;

  end process;

  --jtag_uart_avalon_jtag_slave_waits_for_read in a cycle, which is an e_mux
  jtag_uart_avalon_jtag_slave_waits_for_read <= jtag_uart_avalon_jtag_slave_in_a_read_cycle AND internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  --jtag_uart_avalon_jtag_slave_in_a_read_cycle assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_in_a_read_cycle <= internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= jtag_uart_avalon_jtag_slave_in_a_read_cycle;
  --jtag_uart_avalon_jtag_slave_waits_for_write in a cycle, which is an e_mux
  jtag_uart_avalon_jtag_slave_waits_for_write <= jtag_uart_avalon_jtag_slave_in_a_write_cycle AND internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  --jtag_uart_avalon_jtag_slave_in_a_write_cycle assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_in_a_write_cycle <= internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= jtag_uart_avalon_jtag_slave_in_a_write_cycle;
  wait_for_jtag_uart_avalon_jtag_slave_counter <= std_logic'('0');
  --assign jtag_uart_avalon_jtag_slave_irq_from_sa = jtag_uart_avalon_jtag_slave_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_avalon_jtag_slave_irq_from_sa <= jtag_uart_avalon_jtag_slave_irq;
  --vhdl renameroo for output signals
  cpu_data_master_granted_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  --vhdl renameroo for output signals
  cpu_data_master_requests_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave;
  --vhdl renameroo for output signals
  jtag_uart_avalon_jtag_slave_waitrequest_from_sa <= internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
--synthesis translate_off
    --jtag_uart/avalon_jtag_slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

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

entity rdv_fifo_for_cpu_data_master_to_pipeline_bridge_s1_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_pipeline_bridge_s1_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_pipeline_bridge_s1_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal full_2 :  STD_LOGIC;
                signal full_3 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal p1_full_1 :  STD_LOGIC;
                signal p1_stage_1 :  STD_LOGIC;
                signal p2_full_2 :  STD_LOGIC;
                signal p2_stage_2 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal stage_1 :  STD_LOGIC;
                signal stage_2 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (2 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_2;
  empty <= NOT(full_0);
  full_3 <= std_logic'('0');
  --data_2, which is an e_mux
  p2_stage_2 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_3 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_2, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_2))))) = '1' then 
        if std_logic'(((sync_reset AND full_2) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_3))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_2 <= std_logic'('0');
        else
          stage_2 <= p2_stage_2;
        end if;
      end if;
    end if;

  end process;

  --control_2, which is an e_mux
  p2_full_2 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_2, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_2 <= std_logic'('0');
        else
          full_2 <= p2_full_2;
        end if;
      end if;
    end if;

  end process;

  --data_1, which is an e_mux
  p1_stage_1 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_2 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_2);
  --data_reg_1, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_1))))) = '1' then 
        if std_logic'(((sync_reset AND full_1) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_2))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_1 <= std_logic'('0');
        else
          stage_1 <= p1_stage_1;
        end if;
      end if;
    end if;

  end process;

  --control_1, which is an e_mux
  p1_full_1 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_0, full_2);
  --control_reg_1, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_1 <= std_logic'('0');
        else
          full_1 <= p1_full_1;
        end if;
      end if;
    end if;

  end process;

  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_1);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1)))));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 3);
  one_count_minus_one <= A_EXT (((std_logic_vector'("000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 3);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("00000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("00") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 3);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


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

entity rdv_fifo_for_cpu_instruction_master_to_pipeline_bridge_s1_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_instruction_master_to_pipeline_bridge_s1_module;


architecture europa of rdv_fifo_for_cpu_instruction_master_to_pipeline_bridge_s1_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal full_2 :  STD_LOGIC;
                signal full_3 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal p1_full_1 :  STD_LOGIC;
                signal p1_stage_1 :  STD_LOGIC;
                signal p2_full_2 :  STD_LOGIC;
                signal p2_stage_2 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal stage_1 :  STD_LOGIC;
                signal stage_2 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (2 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_2;
  empty <= NOT(full_0);
  full_3 <= std_logic'('0');
  --data_2, which is an e_mux
  p2_stage_2 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_3 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_2, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_2))))) = '1' then 
        if std_logic'(((sync_reset AND full_2) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_3))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_2 <= std_logic'('0');
        else
          stage_2 <= p2_stage_2;
        end if;
      end if;
    end if;

  end process;

  --control_2, which is an e_mux
  p2_full_2 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_2, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_2 <= std_logic'('0');
        else
          full_2 <= p2_full_2;
        end if;
      end if;
    end if;

  end process;

  --data_1, which is an e_mux
  p1_stage_1 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_2 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_2);
  --data_reg_1, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_1))))) = '1' then 
        if std_logic'(((sync_reset AND full_1) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_2))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_1 <= std_logic'('0');
        else
          stage_1 <= p1_stage_1;
        end if;
      end if;
    end if;

  end process;

  --control_1, which is an e_mux
  p1_full_1 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_0, full_2);
  --control_reg_1, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_1 <= std_logic'('0');
        else
          full_1 <= p1_full_1;
        end if;
      end if;
    end if;

  end process;

  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_1);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1)))));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 3);
  one_count_minus_one <= A_EXT (((std_logic_vector'("000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 3);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("00000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("00") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 3);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


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

library std;
use std.textio.all;

entity pipeline_bridge_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_data_master_debugaccess : IN STD_LOGIC;
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_instruction_master_latency_counter : IN STD_LOGIC;
                 signal cpu_instruction_master_read : IN STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_sdram_s1_shift_register : IN STD_LOGIC;
                 signal pipeline_bridge_s1_endofpacket : IN STD_LOGIC;
                 signal pipeline_bridge_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_s1_readdatavalid : IN STD_LOGIC;
                 signal pipeline_bridge_s1_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_pipeline_bridge_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_pipeline_bridge_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_pipeline_bridge_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_pipeline_bridge_s1_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_pipeline_bridge_s1 : OUT STD_LOGIC;
                 signal cpu_instruction_master_granted_pipeline_bridge_s1 : OUT STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_pipeline_bridge_s1 : OUT STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_pipeline_bridge_s1 : OUT STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register : OUT STD_LOGIC;
                 signal cpu_instruction_master_requests_pipeline_bridge_s1 : OUT STD_LOGIC;
                 signal d1_pipeline_bridge_s1_end_xfer : OUT STD_LOGIC;
                 signal pipeline_bridge_s1_address : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
                 signal pipeline_bridge_s1_arbiterlock : OUT STD_LOGIC;
                 signal pipeline_bridge_s1_arbiterlock2 : OUT STD_LOGIC;
                 signal pipeline_bridge_s1_burstcount : OUT STD_LOGIC;
                 signal pipeline_bridge_s1_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal pipeline_bridge_s1_chipselect : OUT STD_LOGIC;
                 signal pipeline_bridge_s1_debugaccess : OUT STD_LOGIC;
                 signal pipeline_bridge_s1_endofpacket_from_sa : OUT STD_LOGIC;
                 signal pipeline_bridge_s1_nativeaddress : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
                 signal pipeline_bridge_s1_read : OUT STD_LOGIC;
                 signal pipeline_bridge_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_s1_reset_n : OUT STD_LOGIC;
                 signal pipeline_bridge_s1_waitrequest_from_sa : OUT STD_LOGIC;
                 signal pipeline_bridge_s1_write : OUT STD_LOGIC;
                 signal pipeline_bridge_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity pipeline_bridge_s1_arbitrator;


architecture europa of pipeline_bridge_s1_arbitrator is
component rdv_fifo_for_cpu_data_master_to_pipeline_bridge_s1_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_pipeline_bridge_s1_module;

component rdv_fifo_for_cpu_instruction_master_to_pipeline_bridge_s1_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_instruction_master_to_pipeline_bridge_s1_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_pipeline_bridge_s1 :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_pipeline_bridge_s1 :  STD_LOGIC;
                signal cpu_data_master_saved_grant_pipeline_bridge_s1 :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_instruction_master_continuerequest :  STD_LOGIC;
                signal cpu_instruction_master_rdv_fifo_empty_pipeline_bridge_s1 :  STD_LOGIC;
                signal cpu_instruction_master_rdv_fifo_output_from_pipeline_bridge_s1 :  STD_LOGIC;
                signal cpu_instruction_master_saved_grant_pipeline_bridge_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_pipeline_bridge_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_pipeline_bridge_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_pipeline_bridge_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_pipeline_bridge_s1_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_pipeline_bridge_s1 :  STD_LOGIC;
                signal internal_cpu_instruction_master_granted_pipeline_bridge_s1 :  STD_LOGIC;
                signal internal_cpu_instruction_master_qualified_request_pipeline_bridge_s1 :  STD_LOGIC;
                signal internal_cpu_instruction_master_requests_pipeline_bridge_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_s1_waitrequest_from_sa :  STD_LOGIC;
                signal last_cycle_cpu_data_master_granted_slave_pipeline_bridge_s1 :  STD_LOGIC;
                signal last_cycle_cpu_instruction_master_granted_slave_pipeline_bridge_s1 :  STD_LOGIC;
                signal module_input :  STD_LOGIC;
                signal module_input1 :  STD_LOGIC;
                signal module_input2 :  STD_LOGIC;
                signal module_input3 :  STD_LOGIC;
                signal module_input4 :  STD_LOGIC;
                signal module_input5 :  STD_LOGIC;
                signal pipeline_bridge_s1_allgrants :  STD_LOGIC;
                signal pipeline_bridge_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal pipeline_bridge_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal pipeline_bridge_s1_any_continuerequest :  STD_LOGIC;
                signal pipeline_bridge_s1_arb_addend :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal pipeline_bridge_s1_arb_counter_enable :  STD_LOGIC;
                signal pipeline_bridge_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal pipeline_bridge_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal pipeline_bridge_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal pipeline_bridge_s1_arb_winner :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal pipeline_bridge_s1_arbitration_holdoff_internal :  STD_LOGIC;
                signal pipeline_bridge_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal pipeline_bridge_s1_begins_xfer :  STD_LOGIC;
                signal pipeline_bridge_s1_chosen_master_double_vector :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal pipeline_bridge_s1_chosen_master_rot_left :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal pipeline_bridge_s1_end_xfer :  STD_LOGIC;
                signal pipeline_bridge_s1_firsttransfer :  STD_LOGIC;
                signal pipeline_bridge_s1_grant_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal pipeline_bridge_s1_in_a_read_cycle :  STD_LOGIC;
                signal pipeline_bridge_s1_in_a_write_cycle :  STD_LOGIC;
                signal pipeline_bridge_s1_master_qreq_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal pipeline_bridge_s1_move_on_to_next_transaction :  STD_LOGIC;
                signal pipeline_bridge_s1_non_bursting_master_requests :  STD_LOGIC;
                signal pipeline_bridge_s1_readdatavalid_from_sa :  STD_LOGIC;
                signal pipeline_bridge_s1_reg_firsttransfer :  STD_LOGIC;
                signal pipeline_bridge_s1_saved_chosen_master_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal pipeline_bridge_s1_slavearbiterlockenable :  STD_LOGIC;
                signal pipeline_bridge_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal pipeline_bridge_s1_unreg_firsttransfer :  STD_LOGIC;
                signal pipeline_bridge_s1_waits_for_read :  STD_LOGIC;
                signal pipeline_bridge_s1_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_pipeline_bridge_s1_from_cpu_data_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal shifted_address_to_pipeline_bridge_s1_from_cpu_instruction_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal wait_for_pipeline_bridge_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT pipeline_bridge_s1_end_xfer;
    end if;

  end process;

  pipeline_bridge_s1_begins_xfer <= NOT d1_reasons_to_wait AND ((internal_cpu_data_master_qualified_request_pipeline_bridge_s1 OR internal_cpu_instruction_master_qualified_request_pipeline_bridge_s1));
  --assign pipeline_bridge_s1_readdatavalid_from_sa = pipeline_bridge_s1_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  pipeline_bridge_s1_readdatavalid_from_sa <= pipeline_bridge_s1_readdatavalid;
  --assign pipeline_bridge_s1_readdata_from_sa = pipeline_bridge_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  pipeline_bridge_s1_readdata_from_sa <= pipeline_bridge_s1_readdata;
  internal_cpu_data_master_requests_pipeline_bridge_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(25 DOWNTO 8) & std_logic_vector'("00000000")) = std_logic_vector'("10000000000000000000000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign pipeline_bridge_s1_waitrequest_from_sa = pipeline_bridge_s1_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_pipeline_bridge_s1_waitrequest_from_sa <= pipeline_bridge_s1_waitrequest;
  --pipeline_bridge_s1_arb_share_counter set values, which is an e_mux
  pipeline_bridge_s1_arb_share_set_values <= std_logic_vector'("01");
  --pipeline_bridge_s1_non_bursting_master_requests mux, which is an e_mux
  pipeline_bridge_s1_non_bursting_master_requests <= ((((internal_cpu_data_master_requests_pipeline_bridge_s1 OR internal_cpu_instruction_master_requests_pipeline_bridge_s1) OR internal_cpu_data_master_requests_pipeline_bridge_s1) OR internal_cpu_instruction_master_requests_pipeline_bridge_s1) OR internal_cpu_data_master_requests_pipeline_bridge_s1) OR internal_cpu_instruction_master_requests_pipeline_bridge_s1;
  --pipeline_bridge_s1_any_bursting_master_saved_grant mux, which is an e_mux
  pipeline_bridge_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --pipeline_bridge_s1_arb_share_counter_next_value assignment, which is an e_assign
  pipeline_bridge_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(pipeline_bridge_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (pipeline_bridge_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(pipeline_bridge_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (pipeline_bridge_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --pipeline_bridge_s1_allgrants all slave grants, which is an e_mux
  pipeline_bridge_s1_allgrants <= (((((or_reduce(pipeline_bridge_s1_grant_vector)) OR (or_reduce(pipeline_bridge_s1_grant_vector))) OR (or_reduce(pipeline_bridge_s1_grant_vector))) OR (or_reduce(pipeline_bridge_s1_grant_vector))) OR (or_reduce(pipeline_bridge_s1_grant_vector))) OR (or_reduce(pipeline_bridge_s1_grant_vector));
  --pipeline_bridge_s1_end_xfer assignment, which is an e_assign
  pipeline_bridge_s1_end_xfer <= NOT ((pipeline_bridge_s1_waits_for_read OR pipeline_bridge_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_pipeline_bridge_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_pipeline_bridge_s1 <= pipeline_bridge_s1_end_xfer AND (((NOT pipeline_bridge_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --pipeline_bridge_s1_arb_share_counter arbitration counter enable, which is an e_assign
  pipeline_bridge_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_pipeline_bridge_s1 AND pipeline_bridge_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_pipeline_bridge_s1 AND NOT pipeline_bridge_s1_non_bursting_master_requests));
  --pipeline_bridge_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      pipeline_bridge_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(pipeline_bridge_s1_arb_counter_enable) = '1' then 
        pipeline_bridge_s1_arb_share_counter <= pipeline_bridge_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pipeline_bridge_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      pipeline_bridge_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((or_reduce(pipeline_bridge_s1_master_qreq_vector) AND end_xfer_arb_share_counter_term_pipeline_bridge_s1)) OR ((end_xfer_arb_share_counter_term_pipeline_bridge_s1 AND NOT pipeline_bridge_s1_non_bursting_master_requests)))) = '1' then 
        pipeline_bridge_s1_slavearbiterlockenable <= or_reduce(pipeline_bridge_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu/data_master pipeline_bridge/s1 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= pipeline_bridge_s1_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --pipeline_bridge_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  pipeline_bridge_s1_slavearbiterlockenable2 <= or_reduce(pipeline_bridge_s1_arb_share_counter_next_value);
  --cpu/data_master pipeline_bridge/s1 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= pipeline_bridge_s1_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --cpu/instruction_master pipeline_bridge/s1 arbiterlock, which is an e_assign
  cpu_instruction_master_arbiterlock <= pipeline_bridge_s1_slavearbiterlockenable AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master pipeline_bridge/s1 arbiterlock2, which is an e_assign
  cpu_instruction_master_arbiterlock2 <= pipeline_bridge_s1_slavearbiterlockenable2 AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master granted pipeline_bridge/s1 last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_instruction_master_granted_slave_pipeline_bridge_s1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_instruction_master_granted_slave_pipeline_bridge_s1 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_instruction_master_saved_grant_pipeline_bridge_s1) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((pipeline_bridge_s1_arbitration_holdoff_internal OR NOT internal_cpu_instruction_master_requests_pipeline_bridge_s1))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_instruction_master_granted_slave_pipeline_bridge_s1))))));
    end if;

  end process;

  --cpu_instruction_master_continuerequest continued request, which is an e_mux
  cpu_instruction_master_continuerequest <= last_cycle_cpu_instruction_master_granted_slave_pipeline_bridge_s1 AND internal_cpu_instruction_master_requests_pipeline_bridge_s1;
  --pipeline_bridge_s1_any_continuerequest at least one master continues requesting, which is an e_mux
  pipeline_bridge_s1_any_continuerequest <= cpu_instruction_master_continuerequest OR cpu_data_master_continuerequest;
  internal_cpu_data_master_qualified_request_pipeline_bridge_s1 <= internal_cpu_data_master_requests_pipeline_bridge_s1 AND NOT (((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_pipeline_bridge_s1_shift_register))))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))) OR cpu_instruction_master_arbiterlock));
  --unique name for pipeline_bridge_s1_move_on_to_next_transaction, which is an e_assign
  pipeline_bridge_s1_move_on_to_next_transaction <= pipeline_bridge_s1_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_pipeline_bridge_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_pipeline_bridge_s1 : rdv_fifo_for_cpu_data_master_to_pipeline_bridge_s1_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_pipeline_bridge_s1,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_pipeline_bridge_s1,
      full => open,
      clear_fifo => module_input,
      clk => clk,
      data_in => internal_cpu_data_master_granted_pipeline_bridge_s1,
      read => pipeline_bridge_s1_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input1,
      write => module_input2
    );

  module_input <= std_logic'('0');
  module_input1 <= std_logic'('0');
  module_input2 <= in_a_read_cycle AND NOT pipeline_bridge_s1_waits_for_read;

  internal_cpu_data_master_read_data_valid_pipeline_bridge_s1_shift_register <= NOT cpu_data_master_rdv_fifo_empty_pipeline_bridge_s1;
  --local readdatavalid cpu_data_master_read_data_valid_pipeline_bridge_s1, which is an e_mux
  cpu_data_master_read_data_valid_pipeline_bridge_s1 <= ((pipeline_bridge_s1_readdatavalid_from_sa AND cpu_data_master_rdv_fifo_output_from_pipeline_bridge_s1)) AND NOT cpu_data_master_rdv_fifo_empty_pipeline_bridge_s1;
  --pipeline_bridge_s1_writedata mux, which is an e_mux
  pipeline_bridge_s1_writedata <= cpu_data_master_writedata;
  --assign pipeline_bridge_s1_endofpacket_from_sa = pipeline_bridge_s1_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  pipeline_bridge_s1_endofpacket_from_sa <= pipeline_bridge_s1_endofpacket;
  internal_cpu_instruction_master_requests_pipeline_bridge_s1 <= ((to_std_logic(((Std_Logic_Vector'(cpu_instruction_master_address_to_slave(25 DOWNTO 8) & std_logic_vector'("00000000")) = std_logic_vector'("10000000000000000000000000")))) AND (cpu_instruction_master_read))) AND cpu_instruction_master_read;
  --cpu/data_master granted pipeline_bridge/s1 last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_data_master_granted_slave_pipeline_bridge_s1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_data_master_granted_slave_pipeline_bridge_s1 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_data_master_saved_grant_pipeline_bridge_s1) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((pipeline_bridge_s1_arbitration_holdoff_internal OR NOT internal_cpu_data_master_requests_pipeline_bridge_s1))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_data_master_granted_slave_pipeline_bridge_s1))))));
    end if;

  end process;

  --cpu_data_master_continuerequest continued request, which is an e_mux
  cpu_data_master_continuerequest <= last_cycle_cpu_data_master_granted_slave_pipeline_bridge_s1 AND internal_cpu_data_master_requests_pipeline_bridge_s1;
  internal_cpu_instruction_master_qualified_request_pipeline_bridge_s1 <= internal_cpu_instruction_master_requests_pipeline_bridge_s1 AND NOT ((((cpu_instruction_master_read AND ((to_std_logic(((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))) OR ((std_logic_vector'("00000000000000000000000000000001")<(std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_latency_counter))))))) OR (cpu_instruction_master_read_data_valid_sdram_s1_shift_register))))) OR cpu_data_master_arbiterlock));
  --rdv_fifo_for_cpu_instruction_master_to_pipeline_bridge_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_instruction_master_to_pipeline_bridge_s1 : rdv_fifo_for_cpu_instruction_master_to_pipeline_bridge_s1_module
    port map(
      data_out => cpu_instruction_master_rdv_fifo_output_from_pipeline_bridge_s1,
      empty => open,
      fifo_contains_ones_n => cpu_instruction_master_rdv_fifo_empty_pipeline_bridge_s1,
      full => open,
      clear_fifo => module_input3,
      clk => clk,
      data_in => internal_cpu_instruction_master_granted_pipeline_bridge_s1,
      read => pipeline_bridge_s1_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input4,
      write => module_input5
    );

  module_input3 <= std_logic'('0');
  module_input4 <= std_logic'('0');
  module_input5 <= in_a_read_cycle AND NOT pipeline_bridge_s1_waits_for_read;

  cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register <= NOT cpu_instruction_master_rdv_fifo_empty_pipeline_bridge_s1;
  --local readdatavalid cpu_instruction_master_read_data_valid_pipeline_bridge_s1, which is an e_mux
  cpu_instruction_master_read_data_valid_pipeline_bridge_s1 <= ((pipeline_bridge_s1_readdatavalid_from_sa AND cpu_instruction_master_rdv_fifo_output_from_pipeline_bridge_s1)) AND NOT cpu_instruction_master_rdv_fifo_empty_pipeline_bridge_s1;
  --allow new arb cycle for pipeline_bridge/s1, which is an e_assign
  pipeline_bridge_s1_allow_new_arb_cycle <= NOT cpu_data_master_arbiterlock AND NOT cpu_instruction_master_arbiterlock;
  --cpu/instruction_master assignment into master qualified-requests vector for pipeline_bridge/s1, which is an e_assign
  pipeline_bridge_s1_master_qreq_vector(0) <= internal_cpu_instruction_master_qualified_request_pipeline_bridge_s1;
  --cpu/instruction_master grant pipeline_bridge/s1, which is an e_assign
  internal_cpu_instruction_master_granted_pipeline_bridge_s1 <= pipeline_bridge_s1_grant_vector(0);
  --cpu/instruction_master saved-grant pipeline_bridge/s1, which is an e_assign
  cpu_instruction_master_saved_grant_pipeline_bridge_s1 <= pipeline_bridge_s1_arb_winner(0) AND internal_cpu_instruction_master_requests_pipeline_bridge_s1;
  --cpu/data_master assignment into master qualified-requests vector for pipeline_bridge/s1, which is an e_assign
  pipeline_bridge_s1_master_qreq_vector(1) <= internal_cpu_data_master_qualified_request_pipeline_bridge_s1;
  --cpu/data_master grant pipeline_bridge/s1, which is an e_assign
  internal_cpu_data_master_granted_pipeline_bridge_s1 <= pipeline_bridge_s1_grant_vector(1);
  --cpu/data_master saved-grant pipeline_bridge/s1, which is an e_assign
  cpu_data_master_saved_grant_pipeline_bridge_s1 <= pipeline_bridge_s1_arb_winner(1) AND internal_cpu_data_master_requests_pipeline_bridge_s1;
  --pipeline_bridge/s1 chosen-master double-vector, which is an e_assign
  pipeline_bridge_s1_chosen_master_double_vector <= A_EXT (((std_logic_vector'("0") & ((pipeline_bridge_s1_master_qreq_vector & pipeline_bridge_s1_master_qreq_vector))) AND (((std_logic_vector'("0") & (Std_Logic_Vector'(NOT pipeline_bridge_s1_master_qreq_vector & NOT pipeline_bridge_s1_master_qreq_vector))) + (std_logic_vector'("000") & (pipeline_bridge_s1_arb_addend))))), 4);
  --stable onehot encoding of arb winner
  pipeline_bridge_s1_arb_winner <= A_WE_StdLogicVector((std_logic'(((pipeline_bridge_s1_allow_new_arb_cycle AND or_reduce(pipeline_bridge_s1_grant_vector)))) = '1'), pipeline_bridge_s1_grant_vector, pipeline_bridge_s1_saved_chosen_master_vector);
  --saved pipeline_bridge_s1_grant_vector, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      pipeline_bridge_s1_saved_chosen_master_vector <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(pipeline_bridge_s1_allow_new_arb_cycle) = '1' then 
        pipeline_bridge_s1_saved_chosen_master_vector <= A_WE_StdLogicVector((std_logic'(or_reduce(pipeline_bridge_s1_grant_vector)) = '1'), pipeline_bridge_s1_grant_vector, pipeline_bridge_s1_saved_chosen_master_vector);
      end if;
    end if;

  end process;

  --onehot encoding of chosen master
  pipeline_bridge_s1_grant_vector <= Std_Logic_Vector'(A_ToStdLogicVector(((pipeline_bridge_s1_chosen_master_double_vector(1) OR pipeline_bridge_s1_chosen_master_double_vector(3)))) & A_ToStdLogicVector(((pipeline_bridge_s1_chosen_master_double_vector(0) OR pipeline_bridge_s1_chosen_master_double_vector(2)))));
  --pipeline_bridge/s1 chosen master rotated left, which is an e_assign
  pipeline_bridge_s1_chosen_master_rot_left <= A_EXT (A_WE_StdLogicVector((((A_SLL(pipeline_bridge_s1_arb_winner,std_logic_vector'("00000000000000000000000000000001")))) /= std_logic_vector'("00")), (std_logic_vector'("000000000000000000000000000000") & ((A_SLL(pipeline_bridge_s1_arb_winner,std_logic_vector'("00000000000000000000000000000001"))))), std_logic_vector'("00000000000000000000000000000001")), 2);
  --pipeline_bridge/s1's addend for next-master-grant
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      pipeline_bridge_s1_arb_addend <= std_logic_vector'("01");
    elsif clk'event and clk = '1' then
      if std_logic'(or_reduce(pipeline_bridge_s1_grant_vector)) = '1' then 
        pipeline_bridge_s1_arb_addend <= A_WE_StdLogicVector((std_logic'(pipeline_bridge_s1_end_xfer) = '1'), pipeline_bridge_s1_chosen_master_rot_left, pipeline_bridge_s1_grant_vector);
      end if;
    end if;

  end process;

  --pipeline_bridge_s1_reset_n assignment, which is an e_assign
  pipeline_bridge_s1_reset_n <= reset_n;
  pipeline_bridge_s1_chipselect <= internal_cpu_data_master_granted_pipeline_bridge_s1 OR internal_cpu_instruction_master_granted_pipeline_bridge_s1;
  --pipeline_bridge_s1_firsttransfer first transaction, which is an e_assign
  pipeline_bridge_s1_firsttransfer <= A_WE_StdLogic((std_logic'(pipeline_bridge_s1_begins_xfer) = '1'), pipeline_bridge_s1_unreg_firsttransfer, pipeline_bridge_s1_reg_firsttransfer);
  --pipeline_bridge_s1_unreg_firsttransfer first transaction, which is an e_assign
  pipeline_bridge_s1_unreg_firsttransfer <= NOT ((pipeline_bridge_s1_slavearbiterlockenable AND pipeline_bridge_s1_any_continuerequest));
  --pipeline_bridge_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      pipeline_bridge_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(pipeline_bridge_s1_begins_xfer) = '1' then 
        pipeline_bridge_s1_reg_firsttransfer <= pipeline_bridge_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --pipeline_bridge_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  pipeline_bridge_s1_beginbursttransfer_internal <= pipeline_bridge_s1_begins_xfer;
  --pipeline_bridge_s1_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  pipeline_bridge_s1_arbitration_holdoff_internal <= pipeline_bridge_s1_begins_xfer AND pipeline_bridge_s1_firsttransfer;
  --pipeline_bridge_s1_read assignment, which is an e_mux
  pipeline_bridge_s1_read <= ((internal_cpu_data_master_granted_pipeline_bridge_s1 AND cpu_data_master_read)) OR ((internal_cpu_instruction_master_granted_pipeline_bridge_s1 AND cpu_instruction_master_read));
  --pipeline_bridge_s1_write assignment, which is an e_mux
  pipeline_bridge_s1_write <= internal_cpu_data_master_granted_pipeline_bridge_s1 AND cpu_data_master_write;
  shifted_address_to_pipeline_bridge_s1_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --pipeline_bridge_s1_address mux, which is an e_mux
  pipeline_bridge_s1_address <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_pipeline_bridge_s1)) = '1'), (A_SRL(shifted_address_to_pipeline_bridge_s1_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010"))), (A_SRL(shifted_address_to_pipeline_bridge_s1_from_cpu_instruction_master,std_logic_vector'("00000000000000000000000000000010")))), 6);
  shifted_address_to_pipeline_bridge_s1_from_cpu_instruction_master <= cpu_instruction_master_address_to_slave;
  --slaveid pipeline_bridge_s1_nativeaddress nativeaddress mux, which is an e_mux
  pipeline_bridge_s1_nativeaddress <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_pipeline_bridge_s1)) = '1'), (A_SRL(cpu_data_master_address_to_slave,std_logic_vector'("00000000000000000000000000000010"))), (A_SRL(cpu_instruction_master_address_to_slave,std_logic_vector'("00000000000000000000000000000010")))), 6);
  --d1_pipeline_bridge_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_pipeline_bridge_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_pipeline_bridge_s1_end_xfer <= pipeline_bridge_s1_end_xfer;
    end if;

  end process;

  --pipeline_bridge_s1_waits_for_read in a cycle, which is an e_mux
  pipeline_bridge_s1_waits_for_read <= pipeline_bridge_s1_in_a_read_cycle AND internal_pipeline_bridge_s1_waitrequest_from_sa;
  --pipeline_bridge_s1_in_a_read_cycle assignment, which is an e_assign
  pipeline_bridge_s1_in_a_read_cycle <= ((internal_cpu_data_master_granted_pipeline_bridge_s1 AND cpu_data_master_read)) OR ((internal_cpu_instruction_master_granted_pipeline_bridge_s1 AND cpu_instruction_master_read));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= pipeline_bridge_s1_in_a_read_cycle;
  --pipeline_bridge_s1_waits_for_write in a cycle, which is an e_mux
  pipeline_bridge_s1_waits_for_write <= pipeline_bridge_s1_in_a_write_cycle AND internal_pipeline_bridge_s1_waitrequest_from_sa;
  --pipeline_bridge_s1_in_a_write_cycle assignment, which is an e_assign
  pipeline_bridge_s1_in_a_write_cycle <= internal_cpu_data_master_granted_pipeline_bridge_s1 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= pipeline_bridge_s1_in_a_write_cycle;
  wait_for_pipeline_bridge_s1_counter <= std_logic'('0');
  --pipeline_bridge_s1_byteenable byte enable port mux, which is an e_mux
  pipeline_bridge_s1_byteenable <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_pipeline_bridge_s1)) = '1'), (std_logic_vector'("0000000000000000000000000000") & (cpu_data_master_byteenable)), -SIGNED(std_logic_vector'("00000000000000000000000000000001"))), 4);
  --burstcount mux, which is an e_mux
  pipeline_bridge_s1_burstcount <= std_logic'('1');
  --pipeline_bridge/s1 arbiterlock assigned from _handle_arbiterlock, which is an e_mux
  pipeline_bridge_s1_arbiterlock <= A_WE_StdLogic((std_logic'((cpu_data_master_arbiterlock)) = '1'), cpu_data_master_arbiterlock, cpu_instruction_master_arbiterlock);
  --pipeline_bridge/s1 arbiterlock2 assigned from _handle_arbiterlock2, which is an e_mux
  pipeline_bridge_s1_arbiterlock2 <= A_WE_StdLogic((std_logic'((cpu_data_master_arbiterlock2)) = '1'), cpu_data_master_arbiterlock2, cpu_instruction_master_arbiterlock2);
  --debugaccess mux, which is an e_mux
  pipeline_bridge_s1_debugaccess <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_pipeline_bridge_s1)) = '1'), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_debugaccess))), std_logic_vector'("00000000000000000000000000000000")));
  --vhdl renameroo for output signals
  cpu_data_master_granted_pipeline_bridge_s1 <= internal_cpu_data_master_granted_pipeline_bridge_s1;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_pipeline_bridge_s1 <= internal_cpu_data_master_qualified_request_pipeline_bridge_s1;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_pipeline_bridge_s1_shift_register <= internal_cpu_data_master_read_data_valid_pipeline_bridge_s1_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_pipeline_bridge_s1 <= internal_cpu_data_master_requests_pipeline_bridge_s1;
  --vhdl renameroo for output signals
  cpu_instruction_master_granted_pipeline_bridge_s1 <= internal_cpu_instruction_master_granted_pipeline_bridge_s1;
  --vhdl renameroo for output signals
  cpu_instruction_master_qualified_request_pipeline_bridge_s1 <= internal_cpu_instruction_master_qualified_request_pipeline_bridge_s1;
  --vhdl renameroo for output signals
  cpu_instruction_master_requests_pipeline_bridge_s1 <= internal_cpu_instruction_master_requests_pipeline_bridge_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_s1_waitrequest_from_sa <= internal_pipeline_bridge_s1_waitrequest_from_sa;
--synthesis translate_off
    --pipeline_bridge/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line18 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_data_master_granted_pipeline_bridge_s1))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_instruction_master_granted_pipeline_bridge_s1))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line18, now);
          write(write_line18, string'(": "));
          write(write_line18, string'("> 1 of grant signals are active simultaneously"));
          write(output, write_line18.all);
          deallocate (write_line18);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --saved_grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line19 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_data_master_saved_grant_pipeline_bridge_s1))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_saved_grant_pipeline_bridge_s1))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line19, now);
          write(write_line19, string'(": "));
          write(write_line19, string'("> 1 of saved_grant signals are active simultaneously"));
          write(output, write_line19.all);
          deallocate (write_line19);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

library std;
use std.textio.all;

entity pipeline_bridge_m1_arbitrator is 
        port (
              -- inputs:
                 signal ads_busy_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ads_clk_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ads_din_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ads_dout_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ads_ncs_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ads_nirq_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal d1_ads_busy_s1_end_xfer : IN STD_LOGIC;
                 signal d1_ads_clk_s1_end_xfer : IN STD_LOGIC;
                 signal d1_ads_din_s1_end_xfer : IN STD_LOGIC;
                 signal d1_ads_dout_s1_end_xfer : IN STD_LOGIC;
                 signal d1_ads_ncs_s1_end_xfer : IN STD_LOGIC;
                 signal d1_ads_nirq_s1_end_xfer : IN STD_LOGIC;
                 signal d1_ili_db_s1_end_xfer : IN STD_LOGIC;
                 signal d1_ili_ncs_s1_end_xfer : IN STD_LOGIC;
                 signal d1_ili_nrd_s1_end_xfer : IN STD_LOGIC;
                 signal d1_ili_nrst_s1_end_xfer : IN STD_LOGIC;
                 signal d1_ili_nwr_s1_end_xfer : IN STD_LOGIC;
                 signal d1_ili_rs_s1_end_xfer : IN STD_LOGIC;
                 signal d1_sd_clk_s1_end_xfer : IN STD_LOGIC;
                 signal d1_sd_din_s1_end_xfer : IN STD_LOGIC;
                 signal d1_sd_dout_s1_end_xfer : IN STD_LOGIC;
                 signal d1_sd_ncs_s1_end_xfer : IN STD_LOGIC;
                 signal ili_db_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ili_ncs_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ili_nrd_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ili_nrst_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ili_nwr_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ili_rs_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_m1_address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                 signal pipeline_bridge_m1_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                 signal pipeline_bridge_m1_granted_ads_busy_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_granted_ads_clk_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_granted_ads_din_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_granted_ads_dout_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_granted_ads_ncs_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_granted_ads_nirq_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_granted_ili_db_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_granted_ili_ncs_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_granted_ili_nrd_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_granted_ili_nrst_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_granted_ili_nwr_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_granted_ili_rs_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_granted_sd_clk_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_granted_sd_din_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_granted_sd_dout_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_granted_sd_ncs_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ads_busy_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ads_clk_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ads_din_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ads_dout_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ads_ncs_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ads_nirq_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ili_db_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ili_ncs_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ili_nrd_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ili_nrst_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ili_nwr_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_ili_rs_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_sd_clk_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_sd_din_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_sd_dout_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_sd_ncs_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ads_busy_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ads_clk_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ads_din_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ads_dout_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ads_ncs_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ads_nirq_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ili_db_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ili_ncs_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ili_nrd_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ili_nrst_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ili_nwr_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_ili_rs_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_sd_clk_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_sd_din_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_sd_dout_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_sd_ncs_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ads_busy_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ads_clk_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ads_din_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ads_dout_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ads_ncs_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ads_nirq_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ili_db_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ili_ncs_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ili_nrd_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ili_nrst_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ili_nwr_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_requests_ili_rs_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_requests_sd_clk_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_requests_sd_din_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_requests_sd_dout_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_requests_sd_ncs_s1 : IN STD_LOGIC;
                 signal pipeline_bridge_m1_write : IN STD_LOGIC;
                 signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal sd_clk_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal sd_din_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal sd_dout_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal sd_ncs_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal pipeline_bridge_m1_address_to_slave : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal pipeline_bridge_m1_latency_counter : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pipeline_bridge_m1_readdatavalid : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_waitrequest : OUT STD_LOGIC
              );
end entity pipeline_bridge_m1_arbitrator;


architecture europa of pipeline_bridge_m1_arbitrator is
                signal active_and_waiting_last_time :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_address_to_slave :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal internal_pipeline_bridge_m1_latency_counter :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_waitrequest :  STD_LOGIC;
                signal latency_load_value :  STD_LOGIC;
                signal p1_pipeline_bridge_m1_latency_counter :  STD_LOGIC;
                signal pipeline_bridge_m1_address_last_time :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal pipeline_bridge_m1_burstcount_last_time :  STD_LOGIC;
                signal pipeline_bridge_m1_byteenable_last_time :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal pipeline_bridge_m1_chipselect_last_time :  STD_LOGIC;
                signal pipeline_bridge_m1_is_granted_some_slave :  STD_LOGIC;
                signal pipeline_bridge_m1_read_but_no_slave_selected :  STD_LOGIC;
                signal pipeline_bridge_m1_read_last_time :  STD_LOGIC;
                signal pipeline_bridge_m1_run :  STD_LOGIC;
                signal pipeline_bridge_m1_write_last_time :  STD_LOGIC;
                signal pipeline_bridge_m1_writedata_last_time :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal pre_flush_pipeline_bridge_m1_readdatavalid :  STD_LOGIC;
                signal r_0 :  STD_LOGIC;
                signal r_1 :  STD_LOGIC;
                signal r_2 :  STD_LOGIC;
                signal r_3 :  STD_LOGIC;

begin

  --r_0 master_run cascaded wait assignment, which is an e_assign
  r_0 <= Vector_To_Std_Logic((((((((((((((((((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_qualified_request_ads_busy_s1 OR NOT pipeline_bridge_m1_requests_ads_busy_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ads_busy_s1 OR NOT ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_ads_busy_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ads_busy_s1 OR NOT ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_qualified_request_ads_clk_s1 OR NOT pipeline_bridge_m1_requests_ads_clk_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ads_clk_s1 OR NOT ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_ads_clk_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ads_clk_s1 OR NOT ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_qualified_request_ads_din_s1 OR NOT pipeline_bridge_m1_requests_ads_din_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ads_din_s1 OR NOT ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_ads_din_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ads_din_s1 OR NOT ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_qualified_request_ads_dout_s1 OR NOT pipeline_bridge_m1_requests_ads_dout_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ads_dout_s1 OR NOT ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_ads_dout_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ads_dout_s1 OR NOT ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_qualified_request_ads_ncs_s1 OR NOT pipeline_bridge_m1_requests_ads_ncs_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ads_ncs_s1 OR NOT ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_ads_ncs_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ads_ncs_s1 OR NOT ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))))))));
  --cascaded wait assignment, which is an e_assign
  pipeline_bridge_m1_run <= ((r_0 AND r_1) AND r_2) AND r_3;
  --r_1 master_run cascaded wait assignment, which is an e_assign
  r_1 <= Vector_To_Std_Logic((((((((((((((((((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_qualified_request_ads_nirq_s1 OR NOT pipeline_bridge_m1_requests_ads_nirq_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ads_nirq_s1 OR NOT ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_ads_nirq_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ads_nirq_s1 OR NOT ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_qualified_request_ili_db_s1 OR NOT pipeline_bridge_m1_requests_ili_db_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ili_db_s1 OR NOT ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_ili_db_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ili_db_s1 OR NOT ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_qualified_request_ili_ncs_s1 OR NOT pipeline_bridge_m1_requests_ili_ncs_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ili_ncs_s1 OR NOT ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_ili_ncs_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ili_ncs_s1 OR NOT ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_qualified_request_ili_nrd_s1 OR NOT pipeline_bridge_m1_requests_ili_nrd_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ili_nrd_s1 OR NOT ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_ili_nrd_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ili_nrd_s1 OR NOT ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_qualified_request_ili_nrst_s1 OR NOT pipeline_bridge_m1_requests_ili_nrst_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ili_nrst_s1 OR NOT ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_ili_nrst_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ili_nrst_s1 OR NOT ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))))))));
  --r_2 master_run cascaded wait assignment, which is an e_assign
  r_2 <= Vector_To_Std_Logic((((((((((((((((((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_qualified_request_ili_nwr_s1 OR NOT pipeline_bridge_m1_requests_ili_nwr_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ili_nwr_s1 OR NOT ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_ili_nwr_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ili_nwr_s1 OR NOT ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_qualified_request_ili_rs_s1 OR NOT pipeline_bridge_m1_requests_ili_rs_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ili_rs_s1 OR NOT ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_ili_rs_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_ili_rs_s1 OR NOT ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_qualified_request_sd_clk_s1 OR NOT pipeline_bridge_m1_requests_sd_clk_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_sd_clk_s1 OR NOT ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_sd_clk_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_sd_clk_s1 OR NOT ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_qualified_request_sd_din_s1 OR NOT pipeline_bridge_m1_requests_sd_din_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_sd_din_s1 OR NOT ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_sd_din_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_sd_din_s1 OR NOT ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_qualified_request_sd_dout_s1 OR NOT pipeline_bridge_m1_requests_sd_dout_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_sd_dout_s1 OR NOT ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_sd_dout_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_sd_dout_s1 OR NOT ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))))))));
  --r_3 master_run cascaded wait assignment, which is an e_assign
  r_3 <= Vector_To_Std_Logic((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_qualified_request_sd_ncs_s1 OR NOT pipeline_bridge_m1_requests_sd_ncs_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_sd_ncs_s1 OR NOT ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_sd_ncs_s1_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT pipeline_bridge_m1_qualified_request_sd_ncs_s1 OR NOT ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))))))))));
  --optimize select-logic by passing only those address bits which matter.
  internal_pipeline_bridge_m1_address_to_slave <= pipeline_bridge_m1_address(7 DOWNTO 0);
  --pipeline_bridge_m1_read_but_no_slave_selected assignment, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      pipeline_bridge_m1_read_but_no_slave_selected <= std_logic'('0');
    elsif clk'event and clk = '1' then
      pipeline_bridge_m1_read_but_no_slave_selected <= (((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)) AND pipeline_bridge_m1_run) AND NOT pipeline_bridge_m1_is_granted_some_slave;
    end if;

  end process;

  --some slave is getting selected, which is an e_mux
  pipeline_bridge_m1_is_granted_some_slave <= ((((((((((((((pipeline_bridge_m1_granted_ads_busy_s1 OR pipeline_bridge_m1_granted_ads_clk_s1) OR pipeline_bridge_m1_granted_ads_din_s1) OR pipeline_bridge_m1_granted_ads_dout_s1) OR pipeline_bridge_m1_granted_ads_ncs_s1) OR pipeline_bridge_m1_granted_ads_nirq_s1) OR pipeline_bridge_m1_granted_ili_db_s1) OR pipeline_bridge_m1_granted_ili_ncs_s1) OR pipeline_bridge_m1_granted_ili_nrd_s1) OR pipeline_bridge_m1_granted_ili_nrst_s1) OR pipeline_bridge_m1_granted_ili_nwr_s1) OR pipeline_bridge_m1_granted_ili_rs_s1) OR pipeline_bridge_m1_granted_sd_clk_s1) OR pipeline_bridge_m1_granted_sd_din_s1) OR pipeline_bridge_m1_granted_sd_dout_s1) OR pipeline_bridge_m1_granted_sd_ncs_s1;
  --latent slave read data valids which may be flushed, which is an e_mux
  pre_flush_pipeline_bridge_m1_readdatavalid <= std_logic'('0');
  --latent slave read data valid which is not flushed, which is an e_mux
  pipeline_bridge_m1_readdatavalid <= ((((((((((((((((((((((((((((((((((((((((((((((pipeline_bridge_m1_read_but_no_slave_selected OR pre_flush_pipeline_bridge_m1_readdatavalid) OR pipeline_bridge_m1_read_data_valid_ads_busy_s1) OR pipeline_bridge_m1_read_but_no_slave_selected) OR pre_flush_pipeline_bridge_m1_readdatavalid) OR pipeline_bridge_m1_read_data_valid_ads_clk_s1) OR pipeline_bridge_m1_read_but_no_slave_selected) OR pre_flush_pipeline_bridge_m1_readdatavalid) OR pipeline_bridge_m1_read_data_valid_ads_din_s1) OR pipeline_bridge_m1_read_but_no_slave_selected) OR pre_flush_pipeline_bridge_m1_readdatavalid) OR pipeline_bridge_m1_read_data_valid_ads_dout_s1) OR pipeline_bridge_m1_read_but_no_slave_selected) OR pre_flush_pipeline_bridge_m1_readdatavalid) OR pipeline_bridge_m1_read_data_valid_ads_ncs_s1) OR pipeline_bridge_m1_read_but_no_slave_selected) OR pre_flush_pipeline_bridge_m1_readdatavalid) OR pipeline_bridge_m1_read_data_valid_ads_nirq_s1) OR pipeline_bridge_m1_read_but_no_slave_selected) OR pre_flush_pipeline_bridge_m1_readdatavalid) OR pipeline_bridge_m1_read_data_valid_ili_db_s1) OR pipeline_bridge_m1_read_but_no_slave_selected) OR pre_flush_pipeline_bridge_m1_readdatavalid) OR pipeline_bridge_m1_read_data_valid_ili_ncs_s1) OR pipeline_bridge_m1_read_but_no_slave_selected) OR pre_flush_pipeline_bridge_m1_readdatavalid) OR pipeline_bridge_m1_read_data_valid_ili_nrd_s1) OR pipeline_bridge_m1_read_but_no_slave_selected) OR pre_flush_pipeline_bridge_m1_readdatavalid) OR pipeline_bridge_m1_read_data_valid_ili_nrst_s1) OR pipeline_bridge_m1_read_but_no_slave_selected) OR pre_flush_pipeline_bridge_m1_readdatavalid) OR pipeline_bridge_m1_read_data_valid_ili_nwr_s1) OR pipeline_bridge_m1_read_but_no_slave_selected) OR pre_flush_pipeline_bridge_m1_readdatavalid) OR pipeline_bridge_m1_read_data_valid_ili_rs_s1) OR pipeline_bridge_m1_read_but_no_slave_selected) OR pre_flush_pipeline_bridge_m1_readdatavalid) OR pipeline_bridge_m1_read_data_valid_sd_clk_s1) OR pipeline_bridge_m1_read_but_no_slave_selected) OR pre_flush_pipeline_bridge_m1_readdatavalid) OR pipeline_bridge_m1_read_data_valid_sd_din_s1) OR pipeline_bridge_m1_read_but_no_slave_selected) OR pre_flush_pipeline_bridge_m1_readdatavalid) OR pipeline_bridge_m1_read_data_valid_sd_dout_s1) OR pipeline_bridge_m1_read_but_no_slave_selected) OR pre_flush_pipeline_bridge_m1_readdatavalid) OR pipeline_bridge_m1_read_data_valid_sd_ncs_s1;
  --pipeline_bridge/m1 readdata mux, which is an e_mux
  pipeline_bridge_m1_readdata <= ((((((((((((((((A_REP(NOT ((pipeline_bridge_m1_qualified_request_ads_busy_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))) , 32) OR ads_busy_s1_readdata_from_sa)) AND ((A_REP(NOT ((pipeline_bridge_m1_qualified_request_ads_clk_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))) , 32) OR ads_clk_s1_readdata_from_sa))) AND ((A_REP(NOT ((pipeline_bridge_m1_qualified_request_ads_din_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))) , 32) OR ads_din_s1_readdata_from_sa))) AND ((A_REP(NOT ((pipeline_bridge_m1_qualified_request_ads_dout_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))) , 32) OR ads_dout_s1_readdata_from_sa))) AND ((A_REP(NOT ((pipeline_bridge_m1_qualified_request_ads_ncs_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))) , 32) OR ads_ncs_s1_readdata_from_sa))) AND ((A_REP(NOT ((pipeline_bridge_m1_qualified_request_ads_nirq_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))) , 32) OR ads_nirq_s1_readdata_from_sa))) AND ((A_REP(NOT ((pipeline_bridge_m1_qualified_request_ili_db_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))) , 32) OR ili_db_s1_readdata_from_sa))) AND ((A_REP(NOT ((pipeline_bridge_m1_qualified_request_ili_ncs_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))) , 32) OR ili_ncs_s1_readdata_from_sa))) AND ((A_REP(NOT ((pipeline_bridge_m1_qualified_request_ili_nrd_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))) , 32) OR ili_nrd_s1_readdata_from_sa))) AND ((A_REP(NOT ((pipeline_bridge_m1_qualified_request_ili_nrst_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))) , 32) OR ili_nrst_s1_readdata_from_sa))) AND ((A_REP(NOT ((pipeline_bridge_m1_qualified_request_ili_nwr_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))) , 32) OR ili_nwr_s1_readdata_from_sa))) AND ((A_REP(NOT ((pipeline_bridge_m1_qualified_request_ili_rs_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))) , 32) OR ili_rs_s1_readdata_from_sa))) AND ((A_REP(NOT ((pipeline_bridge_m1_qualified_request_sd_clk_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))) , 32) OR sd_clk_s1_readdata_from_sa))) AND ((A_REP(NOT ((pipeline_bridge_m1_qualified_request_sd_din_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))) , 32) OR sd_din_s1_readdata_from_sa))) AND ((A_REP(NOT ((pipeline_bridge_m1_qualified_request_sd_dout_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))) , 32) OR sd_dout_s1_readdata_from_sa))) AND ((A_REP(NOT ((pipeline_bridge_m1_qualified_request_sd_ncs_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)))) , 32) OR sd_ncs_s1_readdata_from_sa));
  --actual waitrequest port, which is an e_assign
  internal_pipeline_bridge_m1_waitrequest <= NOT pipeline_bridge_m1_run;
  --latent max counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_pipeline_bridge_m1_latency_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      internal_pipeline_bridge_m1_latency_counter <= p1_pipeline_bridge_m1_latency_counter;
    end if;

  end process;

  --latency counter load mux, which is an e_mux
  p1_pipeline_bridge_m1_latency_counter <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(((pipeline_bridge_m1_run AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect))))) = '1'), (std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(latency_load_value))), A_WE_StdLogicVector((std_logic'((internal_pipeline_bridge_m1_latency_counter)) = '1'), ((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(internal_pipeline_bridge_m1_latency_counter))) - std_logic_vector'("000000000000000000000000000000001")), std_logic_vector'("000000000000000000000000000000000"))));
  --read latency load values, which is an e_mux
  latency_load_value <= std_logic'('0');
  --vhdl renameroo for output signals
  pipeline_bridge_m1_address_to_slave <= internal_pipeline_bridge_m1_address_to_slave;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_latency_counter <= internal_pipeline_bridge_m1_latency_counter;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_waitrequest <= internal_pipeline_bridge_m1_waitrequest;
--synthesis translate_off
    --pipeline_bridge_m1_address check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        pipeline_bridge_m1_address_last_time <= std_logic_vector'("00000000");
      elsif clk'event and clk = '1' then
        pipeline_bridge_m1_address_last_time <= pipeline_bridge_m1_address;
      end if;

    end process;

    --pipeline_bridge/m1 waited last time, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        active_and_waiting_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        active_and_waiting_last_time <= internal_pipeline_bridge_m1_waitrequest AND pipeline_bridge_m1_chipselect;
      end if;

    end process;

    --pipeline_bridge_m1_address matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line20 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((pipeline_bridge_m1_address /= pipeline_bridge_m1_address_last_time))))) = '1' then 
          write(write_line20, now);
          write(write_line20, string'(": "));
          write(write_line20, string'("pipeline_bridge_m1_address did not heed wait!!!"));
          write(output, write_line20.all);
          deallocate (write_line20);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --pipeline_bridge_m1_chipselect check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        pipeline_bridge_m1_chipselect_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        pipeline_bridge_m1_chipselect_last_time <= pipeline_bridge_m1_chipselect;
      end if;

    end process;

    --pipeline_bridge_m1_chipselect matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line21 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((std_logic'(pipeline_bridge_m1_chipselect) /= std_logic'(pipeline_bridge_m1_chipselect_last_time)))))) = '1' then 
          write(write_line21, now);
          write(write_line21, string'(": "));
          write(write_line21, string'("pipeline_bridge_m1_chipselect did not heed wait!!!"));
          write(output, write_line21.all);
          deallocate (write_line21);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --pipeline_bridge_m1_burstcount check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        pipeline_bridge_m1_burstcount_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        pipeline_bridge_m1_burstcount_last_time <= pipeline_bridge_m1_burstcount;
      end if;

    end process;

    --pipeline_bridge_m1_burstcount matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line22 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((std_logic'(pipeline_bridge_m1_burstcount) /= std_logic'(pipeline_bridge_m1_burstcount_last_time)))))) = '1' then 
          write(write_line22, now);
          write(write_line22, string'(": "));
          write(write_line22, string'("pipeline_bridge_m1_burstcount did not heed wait!!!"));
          write(output, write_line22.all);
          deallocate (write_line22);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --pipeline_bridge_m1_byteenable check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        pipeline_bridge_m1_byteenable_last_time <= std_logic_vector'("0000");
      elsif clk'event and clk = '1' then
        pipeline_bridge_m1_byteenable_last_time <= pipeline_bridge_m1_byteenable;
      end if;

    end process;

    --pipeline_bridge_m1_byteenable matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line23 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((pipeline_bridge_m1_byteenable /= pipeline_bridge_m1_byteenable_last_time))))) = '1' then 
          write(write_line23, now);
          write(write_line23, string'(": "));
          write(write_line23, string'("pipeline_bridge_m1_byteenable did not heed wait!!!"));
          write(output, write_line23.all);
          deallocate (write_line23);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --pipeline_bridge_m1_read check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        pipeline_bridge_m1_read_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        pipeline_bridge_m1_read_last_time <= pipeline_bridge_m1_read;
      end if;

    end process;

    --pipeline_bridge_m1_read matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line24 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((std_logic'(pipeline_bridge_m1_read) /= std_logic'(pipeline_bridge_m1_read_last_time)))))) = '1' then 
          write(write_line24, now);
          write(write_line24, string'(": "));
          write(write_line24, string'("pipeline_bridge_m1_read did not heed wait!!!"));
          write(output, write_line24.all);
          deallocate (write_line24);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --pipeline_bridge_m1_write check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        pipeline_bridge_m1_write_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        pipeline_bridge_m1_write_last_time <= pipeline_bridge_m1_write;
      end if;

    end process;

    --pipeline_bridge_m1_write matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line25 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((std_logic'(pipeline_bridge_m1_write) /= std_logic'(pipeline_bridge_m1_write_last_time)))))) = '1' then 
          write(write_line25, now);
          write(write_line25, string'(": "));
          write(write_line25, string'("pipeline_bridge_m1_write did not heed wait!!!"));
          write(output, write_line25.all);
          deallocate (write_line25);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --pipeline_bridge_m1_writedata check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        pipeline_bridge_m1_writedata_last_time <= std_logic_vector'("00000000000000000000000000000000");
      elsif clk'event and clk = '1' then
        pipeline_bridge_m1_writedata_last_time <= pipeline_bridge_m1_writedata;
      end if;

    end process;

    --pipeline_bridge_m1_writedata matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line26 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((active_and_waiting_last_time AND to_std_logic(((pipeline_bridge_m1_writedata /= pipeline_bridge_m1_writedata_last_time)))) AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect)))) = '1' then 
          write(write_line26, now);
          write(write_line26, string'(": "));
          write(write_line26, string'("pipeline_bridge_m1_writedata did not heed wait!!!"));
          write(output, write_line26.all);
          deallocate (write_line26);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

entity pipeline_bridge_bridge_arbitrator is 
end entity pipeline_bridge_bridge_arbitrator;


architecture europa of pipeline_bridge_bridge_arbitrator is

begin


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

library std;
use std.textio.all;

entity sd_clk_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                 signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                 signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read : IN STD_LOGIC;
                 signal pipeline_bridge_m1_write : IN STD_LOGIC;
                 signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal sd_clk_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal d1_sd_clk_s1_end_xfer : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_granted_sd_clk_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_sd_clk_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_sd_clk_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_requests_sd_clk_s1 : OUT STD_LOGIC;
                 signal sd_clk_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal sd_clk_s1_chipselect : OUT STD_LOGIC;
                 signal sd_clk_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal sd_clk_s1_reset_n : OUT STD_LOGIC;
                 signal sd_clk_s1_write_n : OUT STD_LOGIC;
                 signal sd_clk_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity sd_clk_s1_arbitrator;


architecture europa of sd_clk_s1_arbitrator is
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_sd_clk_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_granted_sd_clk_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_qualified_request_sd_clk_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_requests_sd_clk_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock2 :  STD_LOGIC;
                signal pipeline_bridge_m1_continuerequest :  STD_LOGIC;
                signal pipeline_bridge_m1_saved_grant_sd_clk_s1 :  STD_LOGIC;
                signal sd_clk_s1_allgrants :  STD_LOGIC;
                signal sd_clk_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal sd_clk_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal sd_clk_s1_any_continuerequest :  STD_LOGIC;
                signal sd_clk_s1_arb_counter_enable :  STD_LOGIC;
                signal sd_clk_s1_arb_share_counter :  STD_LOGIC;
                signal sd_clk_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal sd_clk_s1_arb_share_set_values :  STD_LOGIC;
                signal sd_clk_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal sd_clk_s1_begins_xfer :  STD_LOGIC;
                signal sd_clk_s1_end_xfer :  STD_LOGIC;
                signal sd_clk_s1_firsttransfer :  STD_LOGIC;
                signal sd_clk_s1_grant_vector :  STD_LOGIC;
                signal sd_clk_s1_in_a_read_cycle :  STD_LOGIC;
                signal sd_clk_s1_in_a_write_cycle :  STD_LOGIC;
                signal sd_clk_s1_master_qreq_vector :  STD_LOGIC;
                signal sd_clk_s1_non_bursting_master_requests :  STD_LOGIC;
                signal sd_clk_s1_reg_firsttransfer :  STD_LOGIC;
                signal sd_clk_s1_slavearbiterlockenable :  STD_LOGIC;
                signal sd_clk_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal sd_clk_s1_unreg_firsttransfer :  STD_LOGIC;
                signal sd_clk_s1_waits_for_read :  STD_LOGIC;
                signal sd_clk_s1_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_sd_clk_s1_from_pipeline_bridge_m1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal wait_for_sd_clk_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT sd_clk_s1_end_xfer;
    end if;

  end process;

  sd_clk_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_pipeline_bridge_m1_qualified_request_sd_clk_s1);
  --assign sd_clk_s1_readdata_from_sa = sd_clk_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  sd_clk_s1_readdata_from_sa <= sd_clk_s1_readdata;
  internal_pipeline_bridge_m1_requests_sd_clk_s1 <= to_std_logic(((Std_Logic_Vector'(pipeline_bridge_m1_address_to_slave(7 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("01000000")))) AND pipeline_bridge_m1_chipselect;
  --sd_clk_s1_arb_share_counter set values, which is an e_mux
  sd_clk_s1_arb_share_set_values <= std_logic'('1');
  --sd_clk_s1_non_bursting_master_requests mux, which is an e_mux
  sd_clk_s1_non_bursting_master_requests <= internal_pipeline_bridge_m1_requests_sd_clk_s1;
  --sd_clk_s1_any_bursting_master_saved_grant mux, which is an e_mux
  sd_clk_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --sd_clk_s1_arb_share_counter_next_value assignment, which is an e_assign
  sd_clk_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(sd_clk_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sd_clk_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(sd_clk_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sd_clk_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --sd_clk_s1_allgrants all slave grants, which is an e_mux
  sd_clk_s1_allgrants <= sd_clk_s1_grant_vector;
  --sd_clk_s1_end_xfer assignment, which is an e_assign
  sd_clk_s1_end_xfer <= NOT ((sd_clk_s1_waits_for_read OR sd_clk_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_sd_clk_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_sd_clk_s1 <= sd_clk_s1_end_xfer AND (((NOT sd_clk_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --sd_clk_s1_arb_share_counter arbitration counter enable, which is an e_assign
  sd_clk_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_sd_clk_s1 AND sd_clk_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_sd_clk_s1 AND NOT sd_clk_s1_non_bursting_master_requests));
  --sd_clk_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sd_clk_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(sd_clk_s1_arb_counter_enable) = '1' then 
        sd_clk_s1_arb_share_counter <= sd_clk_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --sd_clk_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sd_clk_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((sd_clk_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_sd_clk_s1)) OR ((end_xfer_arb_share_counter_term_sd_clk_s1 AND NOT sd_clk_s1_non_bursting_master_requests)))) = '1' then 
        sd_clk_s1_slavearbiterlockenable <= sd_clk_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pipeline_bridge/m1 sd_clk/s1 arbiterlock, which is an e_assign
  pipeline_bridge_m1_arbiterlock <= sd_clk_s1_slavearbiterlockenable AND pipeline_bridge_m1_continuerequest;
  --sd_clk_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  sd_clk_s1_slavearbiterlockenable2 <= sd_clk_s1_arb_share_counter_next_value;
  --pipeline_bridge/m1 sd_clk/s1 arbiterlock2, which is an e_assign
  pipeline_bridge_m1_arbiterlock2 <= sd_clk_s1_slavearbiterlockenable2 AND pipeline_bridge_m1_continuerequest;
  --sd_clk_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  sd_clk_s1_any_continuerequest <= std_logic'('1');
  --pipeline_bridge_m1_continuerequest continued request, which is an e_assign
  pipeline_bridge_m1_continuerequest <= std_logic'('1');
  internal_pipeline_bridge_m1_qualified_request_sd_clk_s1 <= internal_pipeline_bridge_m1_requests_sd_clk_s1 AND NOT ((((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))))));
  --local readdatavalid pipeline_bridge_m1_read_data_valid_sd_clk_s1, which is an e_mux
  pipeline_bridge_m1_read_data_valid_sd_clk_s1 <= (internal_pipeline_bridge_m1_granted_sd_clk_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect))) AND NOT sd_clk_s1_waits_for_read;
  --sd_clk_s1_writedata mux, which is an e_mux
  sd_clk_s1_writedata <= pipeline_bridge_m1_writedata;
  --master is always granted when requested
  internal_pipeline_bridge_m1_granted_sd_clk_s1 <= internal_pipeline_bridge_m1_qualified_request_sd_clk_s1;
  --pipeline_bridge/m1 saved-grant sd_clk/s1, which is an e_assign
  pipeline_bridge_m1_saved_grant_sd_clk_s1 <= internal_pipeline_bridge_m1_requests_sd_clk_s1;
  --allow new arb cycle for sd_clk/s1, which is an e_assign
  sd_clk_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  sd_clk_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  sd_clk_s1_master_qreq_vector <= std_logic'('1');
  --sd_clk_s1_reset_n assignment, which is an e_assign
  sd_clk_s1_reset_n <= reset_n;
  sd_clk_s1_chipselect <= internal_pipeline_bridge_m1_granted_sd_clk_s1;
  --sd_clk_s1_firsttransfer first transaction, which is an e_assign
  sd_clk_s1_firsttransfer <= A_WE_StdLogic((std_logic'(sd_clk_s1_begins_xfer) = '1'), sd_clk_s1_unreg_firsttransfer, sd_clk_s1_reg_firsttransfer);
  --sd_clk_s1_unreg_firsttransfer first transaction, which is an e_assign
  sd_clk_s1_unreg_firsttransfer <= NOT ((sd_clk_s1_slavearbiterlockenable AND sd_clk_s1_any_continuerequest));
  --sd_clk_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sd_clk_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(sd_clk_s1_begins_xfer) = '1' then 
        sd_clk_s1_reg_firsttransfer <= sd_clk_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --sd_clk_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  sd_clk_s1_beginbursttransfer_internal <= sd_clk_s1_begins_xfer;
  --~sd_clk_s1_write_n assignment, which is an e_mux
  sd_clk_s1_write_n <= NOT ((internal_pipeline_bridge_m1_granted_sd_clk_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect))));
  shifted_address_to_sd_clk_s1_from_pipeline_bridge_m1 <= pipeline_bridge_m1_address_to_slave;
  --sd_clk_s1_address mux, which is an e_mux
  sd_clk_s1_address <= A_EXT (A_SRL(shifted_address_to_sd_clk_s1_from_pipeline_bridge_m1,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_sd_clk_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_sd_clk_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_sd_clk_s1_end_xfer <= sd_clk_s1_end_xfer;
    end if;

  end process;

  --sd_clk_s1_waits_for_read in a cycle, which is an e_mux
  sd_clk_s1_waits_for_read <= sd_clk_s1_in_a_read_cycle AND sd_clk_s1_begins_xfer;
  --sd_clk_s1_in_a_read_cycle assignment, which is an e_assign
  sd_clk_s1_in_a_read_cycle <= internal_pipeline_bridge_m1_granted_sd_clk_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= sd_clk_s1_in_a_read_cycle;
  --sd_clk_s1_waits_for_write in a cycle, which is an e_mux
  sd_clk_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sd_clk_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --sd_clk_s1_in_a_write_cycle assignment, which is an e_assign
  sd_clk_s1_in_a_write_cycle <= internal_pipeline_bridge_m1_granted_sd_clk_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect));
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= sd_clk_s1_in_a_write_cycle;
  wait_for_sd_clk_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  pipeline_bridge_m1_granted_sd_clk_s1 <= internal_pipeline_bridge_m1_granted_sd_clk_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_qualified_request_sd_clk_s1 <= internal_pipeline_bridge_m1_qualified_request_sd_clk_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_requests_sd_clk_s1 <= internal_pipeline_bridge_m1_requests_sd_clk_s1;
--synthesis translate_off
    --sd_clk/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --pipeline_bridge/m1 non-zero burstcount assertion, which is an e_process
    process (clk)
    VARIABLE write_line27 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((internal_pipeline_bridge_m1_requests_sd_clk_s1 AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_burstcount))) = std_logic_vector'("00000000000000000000000000000000"))))) AND enable_nonzero_assertions)) = '1' then 
          write(write_line27, now);
          write(write_line27, string'(": "));
          write(write_line27, string'("pipeline_bridge/m1 drove 0 on its 'burstcount' port while accessing slave sd_clk/s1"));
          write(output, write_line27.all);
          deallocate (write_line27);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

library std;
use std.textio.all;

entity sd_din_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                 signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                 signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read : IN STD_LOGIC;
                 signal pipeline_bridge_m1_write : IN STD_LOGIC;
                 signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal sd_din_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal d1_sd_din_s1_end_xfer : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_granted_sd_din_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_sd_din_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_sd_din_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_requests_sd_din_s1 : OUT STD_LOGIC;
                 signal sd_din_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal sd_din_s1_chipselect : OUT STD_LOGIC;
                 signal sd_din_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal sd_din_s1_reset_n : OUT STD_LOGIC;
                 signal sd_din_s1_write_n : OUT STD_LOGIC;
                 signal sd_din_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity sd_din_s1_arbitrator;


architecture europa of sd_din_s1_arbitrator is
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_sd_din_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_granted_sd_din_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_qualified_request_sd_din_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_requests_sd_din_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock2 :  STD_LOGIC;
                signal pipeline_bridge_m1_continuerequest :  STD_LOGIC;
                signal pipeline_bridge_m1_saved_grant_sd_din_s1 :  STD_LOGIC;
                signal sd_din_s1_allgrants :  STD_LOGIC;
                signal sd_din_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal sd_din_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal sd_din_s1_any_continuerequest :  STD_LOGIC;
                signal sd_din_s1_arb_counter_enable :  STD_LOGIC;
                signal sd_din_s1_arb_share_counter :  STD_LOGIC;
                signal sd_din_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal sd_din_s1_arb_share_set_values :  STD_LOGIC;
                signal sd_din_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal sd_din_s1_begins_xfer :  STD_LOGIC;
                signal sd_din_s1_end_xfer :  STD_LOGIC;
                signal sd_din_s1_firsttransfer :  STD_LOGIC;
                signal sd_din_s1_grant_vector :  STD_LOGIC;
                signal sd_din_s1_in_a_read_cycle :  STD_LOGIC;
                signal sd_din_s1_in_a_write_cycle :  STD_LOGIC;
                signal sd_din_s1_master_qreq_vector :  STD_LOGIC;
                signal sd_din_s1_non_bursting_master_requests :  STD_LOGIC;
                signal sd_din_s1_reg_firsttransfer :  STD_LOGIC;
                signal sd_din_s1_slavearbiterlockenable :  STD_LOGIC;
                signal sd_din_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal sd_din_s1_unreg_firsttransfer :  STD_LOGIC;
                signal sd_din_s1_waits_for_read :  STD_LOGIC;
                signal sd_din_s1_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_sd_din_s1_from_pipeline_bridge_m1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal wait_for_sd_din_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT sd_din_s1_end_xfer;
    end if;

  end process;

  sd_din_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_pipeline_bridge_m1_qualified_request_sd_din_s1);
  --assign sd_din_s1_readdata_from_sa = sd_din_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  sd_din_s1_readdata_from_sa <= sd_din_s1_readdata;
  internal_pipeline_bridge_m1_requests_sd_din_s1 <= to_std_logic(((Std_Logic_Vector'(pipeline_bridge_m1_address_to_slave(7 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("00110000")))) AND pipeline_bridge_m1_chipselect;
  --sd_din_s1_arb_share_counter set values, which is an e_mux
  sd_din_s1_arb_share_set_values <= std_logic'('1');
  --sd_din_s1_non_bursting_master_requests mux, which is an e_mux
  sd_din_s1_non_bursting_master_requests <= internal_pipeline_bridge_m1_requests_sd_din_s1;
  --sd_din_s1_any_bursting_master_saved_grant mux, which is an e_mux
  sd_din_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --sd_din_s1_arb_share_counter_next_value assignment, which is an e_assign
  sd_din_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(sd_din_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sd_din_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(sd_din_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sd_din_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --sd_din_s1_allgrants all slave grants, which is an e_mux
  sd_din_s1_allgrants <= sd_din_s1_grant_vector;
  --sd_din_s1_end_xfer assignment, which is an e_assign
  sd_din_s1_end_xfer <= NOT ((sd_din_s1_waits_for_read OR sd_din_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_sd_din_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_sd_din_s1 <= sd_din_s1_end_xfer AND (((NOT sd_din_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --sd_din_s1_arb_share_counter arbitration counter enable, which is an e_assign
  sd_din_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_sd_din_s1 AND sd_din_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_sd_din_s1 AND NOT sd_din_s1_non_bursting_master_requests));
  --sd_din_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sd_din_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(sd_din_s1_arb_counter_enable) = '1' then 
        sd_din_s1_arb_share_counter <= sd_din_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --sd_din_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sd_din_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((sd_din_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_sd_din_s1)) OR ((end_xfer_arb_share_counter_term_sd_din_s1 AND NOT sd_din_s1_non_bursting_master_requests)))) = '1' then 
        sd_din_s1_slavearbiterlockenable <= sd_din_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pipeline_bridge/m1 sd_din/s1 arbiterlock, which is an e_assign
  pipeline_bridge_m1_arbiterlock <= sd_din_s1_slavearbiterlockenable AND pipeline_bridge_m1_continuerequest;
  --sd_din_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  sd_din_s1_slavearbiterlockenable2 <= sd_din_s1_arb_share_counter_next_value;
  --pipeline_bridge/m1 sd_din/s1 arbiterlock2, which is an e_assign
  pipeline_bridge_m1_arbiterlock2 <= sd_din_s1_slavearbiterlockenable2 AND pipeline_bridge_m1_continuerequest;
  --sd_din_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  sd_din_s1_any_continuerequest <= std_logic'('1');
  --pipeline_bridge_m1_continuerequest continued request, which is an e_assign
  pipeline_bridge_m1_continuerequest <= std_logic'('1');
  internal_pipeline_bridge_m1_qualified_request_sd_din_s1 <= internal_pipeline_bridge_m1_requests_sd_din_s1 AND NOT ((((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))))));
  --local readdatavalid pipeline_bridge_m1_read_data_valid_sd_din_s1, which is an e_mux
  pipeline_bridge_m1_read_data_valid_sd_din_s1 <= (internal_pipeline_bridge_m1_granted_sd_din_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect))) AND NOT sd_din_s1_waits_for_read;
  --sd_din_s1_writedata mux, which is an e_mux
  sd_din_s1_writedata <= pipeline_bridge_m1_writedata;
  --master is always granted when requested
  internal_pipeline_bridge_m1_granted_sd_din_s1 <= internal_pipeline_bridge_m1_qualified_request_sd_din_s1;
  --pipeline_bridge/m1 saved-grant sd_din/s1, which is an e_assign
  pipeline_bridge_m1_saved_grant_sd_din_s1 <= internal_pipeline_bridge_m1_requests_sd_din_s1;
  --allow new arb cycle for sd_din/s1, which is an e_assign
  sd_din_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  sd_din_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  sd_din_s1_master_qreq_vector <= std_logic'('1');
  --sd_din_s1_reset_n assignment, which is an e_assign
  sd_din_s1_reset_n <= reset_n;
  sd_din_s1_chipselect <= internal_pipeline_bridge_m1_granted_sd_din_s1;
  --sd_din_s1_firsttransfer first transaction, which is an e_assign
  sd_din_s1_firsttransfer <= A_WE_StdLogic((std_logic'(sd_din_s1_begins_xfer) = '1'), sd_din_s1_unreg_firsttransfer, sd_din_s1_reg_firsttransfer);
  --sd_din_s1_unreg_firsttransfer first transaction, which is an e_assign
  sd_din_s1_unreg_firsttransfer <= NOT ((sd_din_s1_slavearbiterlockenable AND sd_din_s1_any_continuerequest));
  --sd_din_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sd_din_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(sd_din_s1_begins_xfer) = '1' then 
        sd_din_s1_reg_firsttransfer <= sd_din_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --sd_din_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  sd_din_s1_beginbursttransfer_internal <= sd_din_s1_begins_xfer;
  --~sd_din_s1_write_n assignment, which is an e_mux
  sd_din_s1_write_n <= NOT ((internal_pipeline_bridge_m1_granted_sd_din_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect))));
  shifted_address_to_sd_din_s1_from_pipeline_bridge_m1 <= pipeline_bridge_m1_address_to_slave;
  --sd_din_s1_address mux, which is an e_mux
  sd_din_s1_address <= A_EXT (A_SRL(shifted_address_to_sd_din_s1_from_pipeline_bridge_m1,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_sd_din_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_sd_din_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_sd_din_s1_end_xfer <= sd_din_s1_end_xfer;
    end if;

  end process;

  --sd_din_s1_waits_for_read in a cycle, which is an e_mux
  sd_din_s1_waits_for_read <= sd_din_s1_in_a_read_cycle AND sd_din_s1_begins_xfer;
  --sd_din_s1_in_a_read_cycle assignment, which is an e_assign
  sd_din_s1_in_a_read_cycle <= internal_pipeline_bridge_m1_granted_sd_din_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= sd_din_s1_in_a_read_cycle;
  --sd_din_s1_waits_for_write in a cycle, which is an e_mux
  sd_din_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sd_din_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --sd_din_s1_in_a_write_cycle assignment, which is an e_assign
  sd_din_s1_in_a_write_cycle <= internal_pipeline_bridge_m1_granted_sd_din_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect));
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= sd_din_s1_in_a_write_cycle;
  wait_for_sd_din_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  pipeline_bridge_m1_granted_sd_din_s1 <= internal_pipeline_bridge_m1_granted_sd_din_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_qualified_request_sd_din_s1 <= internal_pipeline_bridge_m1_qualified_request_sd_din_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_requests_sd_din_s1 <= internal_pipeline_bridge_m1_requests_sd_din_s1;
--synthesis translate_off
    --sd_din/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --pipeline_bridge/m1 non-zero burstcount assertion, which is an e_process
    process (clk)
    VARIABLE write_line28 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((internal_pipeline_bridge_m1_requests_sd_din_s1 AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_burstcount))) = std_logic_vector'("00000000000000000000000000000000"))))) AND enable_nonzero_assertions)) = '1' then 
          write(write_line28, now);
          write(write_line28, string'(": "));
          write(write_line28, string'("pipeline_bridge/m1 drove 0 on its 'burstcount' port while accessing slave sd_din/s1"));
          write(output, write_line28.all);
          deallocate (write_line28);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

library std;
use std.textio.all;

entity sd_dout_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                 signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                 signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read : IN STD_LOGIC;
                 signal pipeline_bridge_m1_write : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sd_dout_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal d1_sd_dout_s1_end_xfer : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_granted_sd_dout_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_sd_dout_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_sd_dout_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_requests_sd_dout_s1 : OUT STD_LOGIC;
                 signal sd_dout_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal sd_dout_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal sd_dout_s1_reset_n : OUT STD_LOGIC
              );
end entity sd_dout_s1_arbitrator;


architecture europa of sd_dout_s1_arbitrator is
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_sd_dout_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_granted_sd_dout_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_qualified_request_sd_dout_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_requests_sd_dout_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock2 :  STD_LOGIC;
                signal pipeline_bridge_m1_continuerequest :  STD_LOGIC;
                signal pipeline_bridge_m1_saved_grant_sd_dout_s1 :  STD_LOGIC;
                signal sd_dout_s1_allgrants :  STD_LOGIC;
                signal sd_dout_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal sd_dout_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal sd_dout_s1_any_continuerequest :  STD_LOGIC;
                signal sd_dout_s1_arb_counter_enable :  STD_LOGIC;
                signal sd_dout_s1_arb_share_counter :  STD_LOGIC;
                signal sd_dout_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal sd_dout_s1_arb_share_set_values :  STD_LOGIC;
                signal sd_dout_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal sd_dout_s1_begins_xfer :  STD_LOGIC;
                signal sd_dout_s1_end_xfer :  STD_LOGIC;
                signal sd_dout_s1_firsttransfer :  STD_LOGIC;
                signal sd_dout_s1_grant_vector :  STD_LOGIC;
                signal sd_dout_s1_in_a_read_cycle :  STD_LOGIC;
                signal sd_dout_s1_in_a_write_cycle :  STD_LOGIC;
                signal sd_dout_s1_master_qreq_vector :  STD_LOGIC;
                signal sd_dout_s1_non_bursting_master_requests :  STD_LOGIC;
                signal sd_dout_s1_reg_firsttransfer :  STD_LOGIC;
                signal sd_dout_s1_slavearbiterlockenable :  STD_LOGIC;
                signal sd_dout_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal sd_dout_s1_unreg_firsttransfer :  STD_LOGIC;
                signal sd_dout_s1_waits_for_read :  STD_LOGIC;
                signal sd_dout_s1_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_sd_dout_s1_from_pipeline_bridge_m1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal wait_for_sd_dout_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT sd_dout_s1_end_xfer;
    end if;

  end process;

  sd_dout_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_pipeline_bridge_m1_qualified_request_sd_dout_s1);
  --assign sd_dout_s1_readdata_from_sa = sd_dout_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  sd_dout_s1_readdata_from_sa <= sd_dout_s1_readdata;
  internal_pipeline_bridge_m1_requests_sd_dout_s1 <= ((to_std_logic(((Std_Logic_Vector'(pipeline_bridge_m1_address_to_slave(7 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("00100000")))) AND pipeline_bridge_m1_chipselect)) AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --sd_dout_s1_arb_share_counter set values, which is an e_mux
  sd_dout_s1_arb_share_set_values <= std_logic'('1');
  --sd_dout_s1_non_bursting_master_requests mux, which is an e_mux
  sd_dout_s1_non_bursting_master_requests <= internal_pipeline_bridge_m1_requests_sd_dout_s1;
  --sd_dout_s1_any_bursting_master_saved_grant mux, which is an e_mux
  sd_dout_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --sd_dout_s1_arb_share_counter_next_value assignment, which is an e_assign
  sd_dout_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(sd_dout_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sd_dout_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(sd_dout_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sd_dout_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --sd_dout_s1_allgrants all slave grants, which is an e_mux
  sd_dout_s1_allgrants <= sd_dout_s1_grant_vector;
  --sd_dout_s1_end_xfer assignment, which is an e_assign
  sd_dout_s1_end_xfer <= NOT ((sd_dout_s1_waits_for_read OR sd_dout_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_sd_dout_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_sd_dout_s1 <= sd_dout_s1_end_xfer AND (((NOT sd_dout_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --sd_dout_s1_arb_share_counter arbitration counter enable, which is an e_assign
  sd_dout_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_sd_dout_s1 AND sd_dout_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_sd_dout_s1 AND NOT sd_dout_s1_non_bursting_master_requests));
  --sd_dout_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sd_dout_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(sd_dout_s1_arb_counter_enable) = '1' then 
        sd_dout_s1_arb_share_counter <= sd_dout_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --sd_dout_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sd_dout_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((sd_dout_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_sd_dout_s1)) OR ((end_xfer_arb_share_counter_term_sd_dout_s1 AND NOT sd_dout_s1_non_bursting_master_requests)))) = '1' then 
        sd_dout_s1_slavearbiterlockenable <= sd_dout_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pipeline_bridge/m1 sd_dout/s1 arbiterlock, which is an e_assign
  pipeline_bridge_m1_arbiterlock <= sd_dout_s1_slavearbiterlockenable AND pipeline_bridge_m1_continuerequest;
  --sd_dout_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  sd_dout_s1_slavearbiterlockenable2 <= sd_dout_s1_arb_share_counter_next_value;
  --pipeline_bridge/m1 sd_dout/s1 arbiterlock2, which is an e_assign
  pipeline_bridge_m1_arbiterlock2 <= sd_dout_s1_slavearbiterlockenable2 AND pipeline_bridge_m1_continuerequest;
  --sd_dout_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  sd_dout_s1_any_continuerequest <= std_logic'('1');
  --pipeline_bridge_m1_continuerequest continued request, which is an e_assign
  pipeline_bridge_m1_continuerequest <= std_logic'('1');
  internal_pipeline_bridge_m1_qualified_request_sd_dout_s1 <= internal_pipeline_bridge_m1_requests_sd_dout_s1 AND NOT ((((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))))));
  --local readdatavalid pipeline_bridge_m1_read_data_valid_sd_dout_s1, which is an e_mux
  pipeline_bridge_m1_read_data_valid_sd_dout_s1 <= (internal_pipeline_bridge_m1_granted_sd_dout_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect))) AND NOT sd_dout_s1_waits_for_read;
  --master is always granted when requested
  internal_pipeline_bridge_m1_granted_sd_dout_s1 <= internal_pipeline_bridge_m1_qualified_request_sd_dout_s1;
  --pipeline_bridge/m1 saved-grant sd_dout/s1, which is an e_assign
  pipeline_bridge_m1_saved_grant_sd_dout_s1 <= internal_pipeline_bridge_m1_requests_sd_dout_s1;
  --allow new arb cycle for sd_dout/s1, which is an e_assign
  sd_dout_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  sd_dout_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  sd_dout_s1_master_qreq_vector <= std_logic'('1');
  --sd_dout_s1_reset_n assignment, which is an e_assign
  sd_dout_s1_reset_n <= reset_n;
  --sd_dout_s1_firsttransfer first transaction, which is an e_assign
  sd_dout_s1_firsttransfer <= A_WE_StdLogic((std_logic'(sd_dout_s1_begins_xfer) = '1'), sd_dout_s1_unreg_firsttransfer, sd_dout_s1_reg_firsttransfer);
  --sd_dout_s1_unreg_firsttransfer first transaction, which is an e_assign
  sd_dout_s1_unreg_firsttransfer <= NOT ((sd_dout_s1_slavearbiterlockenable AND sd_dout_s1_any_continuerequest));
  --sd_dout_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sd_dout_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(sd_dout_s1_begins_xfer) = '1' then 
        sd_dout_s1_reg_firsttransfer <= sd_dout_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --sd_dout_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  sd_dout_s1_beginbursttransfer_internal <= sd_dout_s1_begins_xfer;
  shifted_address_to_sd_dout_s1_from_pipeline_bridge_m1 <= pipeline_bridge_m1_address_to_slave;
  --sd_dout_s1_address mux, which is an e_mux
  sd_dout_s1_address <= A_EXT (A_SRL(shifted_address_to_sd_dout_s1_from_pipeline_bridge_m1,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_sd_dout_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_sd_dout_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_sd_dout_s1_end_xfer <= sd_dout_s1_end_xfer;
    end if;

  end process;

  --sd_dout_s1_waits_for_read in a cycle, which is an e_mux
  sd_dout_s1_waits_for_read <= sd_dout_s1_in_a_read_cycle AND sd_dout_s1_begins_xfer;
  --sd_dout_s1_in_a_read_cycle assignment, which is an e_assign
  sd_dout_s1_in_a_read_cycle <= internal_pipeline_bridge_m1_granted_sd_dout_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= sd_dout_s1_in_a_read_cycle;
  --sd_dout_s1_waits_for_write in a cycle, which is an e_mux
  sd_dout_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sd_dout_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --sd_dout_s1_in_a_write_cycle assignment, which is an e_assign
  sd_dout_s1_in_a_write_cycle <= internal_pipeline_bridge_m1_granted_sd_dout_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect));
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= sd_dout_s1_in_a_write_cycle;
  wait_for_sd_dout_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  pipeline_bridge_m1_granted_sd_dout_s1 <= internal_pipeline_bridge_m1_granted_sd_dout_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_qualified_request_sd_dout_s1 <= internal_pipeline_bridge_m1_qualified_request_sd_dout_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_requests_sd_dout_s1 <= internal_pipeline_bridge_m1_requests_sd_dout_s1;
--synthesis translate_off
    --sd_dout/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --pipeline_bridge/m1 non-zero burstcount assertion, which is an e_process
    process (clk)
    VARIABLE write_line29 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((internal_pipeline_bridge_m1_requests_sd_dout_s1 AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_burstcount))) = std_logic_vector'("00000000000000000000000000000000"))))) AND enable_nonzero_assertions)) = '1' then 
          write(write_line29, now);
          write(write_line29, string'(": "));
          write(write_line29, string'("pipeline_bridge/m1 drove 0 on its 'burstcount' port while accessing slave sd_dout/s1"));
          write(output, write_line29.all);
          deallocate (write_line29);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

library std;
use std.textio.all;

entity sd_ncs_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                 signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                 signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                 signal pipeline_bridge_m1_read : IN STD_LOGIC;
                 signal pipeline_bridge_m1_write : IN STD_LOGIC;
                 signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal sd_ncs_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal d1_sd_ncs_s1_end_xfer : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_granted_sd_ncs_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_qualified_request_sd_ncs_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_read_data_valid_sd_ncs_s1 : OUT STD_LOGIC;
                 signal pipeline_bridge_m1_requests_sd_ncs_s1 : OUT STD_LOGIC;
                 signal sd_ncs_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal sd_ncs_s1_chipselect : OUT STD_LOGIC;
                 signal sd_ncs_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal sd_ncs_s1_reset_n : OUT STD_LOGIC;
                 signal sd_ncs_s1_write_n : OUT STD_LOGIC;
                 signal sd_ncs_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity sd_ncs_s1_arbitrator;


architecture europa of sd_ncs_s1_arbitrator is
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_sd_ncs_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_granted_sd_ncs_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_qualified_request_sd_ncs_s1 :  STD_LOGIC;
                signal internal_pipeline_bridge_m1_requests_sd_ncs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock :  STD_LOGIC;
                signal pipeline_bridge_m1_arbiterlock2 :  STD_LOGIC;
                signal pipeline_bridge_m1_continuerequest :  STD_LOGIC;
                signal pipeline_bridge_m1_saved_grant_sd_ncs_s1 :  STD_LOGIC;
                signal sd_ncs_s1_allgrants :  STD_LOGIC;
                signal sd_ncs_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal sd_ncs_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal sd_ncs_s1_any_continuerequest :  STD_LOGIC;
                signal sd_ncs_s1_arb_counter_enable :  STD_LOGIC;
                signal sd_ncs_s1_arb_share_counter :  STD_LOGIC;
                signal sd_ncs_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal sd_ncs_s1_arb_share_set_values :  STD_LOGIC;
                signal sd_ncs_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal sd_ncs_s1_begins_xfer :  STD_LOGIC;
                signal sd_ncs_s1_end_xfer :  STD_LOGIC;
                signal sd_ncs_s1_firsttransfer :  STD_LOGIC;
                signal sd_ncs_s1_grant_vector :  STD_LOGIC;
                signal sd_ncs_s1_in_a_read_cycle :  STD_LOGIC;
                signal sd_ncs_s1_in_a_write_cycle :  STD_LOGIC;
                signal sd_ncs_s1_master_qreq_vector :  STD_LOGIC;
                signal sd_ncs_s1_non_bursting_master_requests :  STD_LOGIC;
                signal sd_ncs_s1_reg_firsttransfer :  STD_LOGIC;
                signal sd_ncs_s1_slavearbiterlockenable :  STD_LOGIC;
                signal sd_ncs_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal sd_ncs_s1_unreg_firsttransfer :  STD_LOGIC;
                signal sd_ncs_s1_waits_for_read :  STD_LOGIC;
                signal sd_ncs_s1_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_sd_ncs_s1_from_pipeline_bridge_m1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal wait_for_sd_ncs_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT sd_ncs_s1_end_xfer;
    end if;

  end process;

  sd_ncs_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_pipeline_bridge_m1_qualified_request_sd_ncs_s1);
  --assign sd_ncs_s1_readdata_from_sa = sd_ncs_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  sd_ncs_s1_readdata_from_sa <= sd_ncs_s1_readdata;
  internal_pipeline_bridge_m1_requests_sd_ncs_s1 <= to_std_logic(((Std_Logic_Vector'(pipeline_bridge_m1_address_to_slave(7 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("01010000")))) AND pipeline_bridge_m1_chipselect;
  --sd_ncs_s1_arb_share_counter set values, which is an e_mux
  sd_ncs_s1_arb_share_set_values <= std_logic'('1');
  --sd_ncs_s1_non_bursting_master_requests mux, which is an e_mux
  sd_ncs_s1_non_bursting_master_requests <= internal_pipeline_bridge_m1_requests_sd_ncs_s1;
  --sd_ncs_s1_any_bursting_master_saved_grant mux, which is an e_mux
  sd_ncs_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --sd_ncs_s1_arb_share_counter_next_value assignment, which is an e_assign
  sd_ncs_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(sd_ncs_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sd_ncs_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(sd_ncs_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sd_ncs_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --sd_ncs_s1_allgrants all slave grants, which is an e_mux
  sd_ncs_s1_allgrants <= sd_ncs_s1_grant_vector;
  --sd_ncs_s1_end_xfer assignment, which is an e_assign
  sd_ncs_s1_end_xfer <= NOT ((sd_ncs_s1_waits_for_read OR sd_ncs_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_sd_ncs_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_sd_ncs_s1 <= sd_ncs_s1_end_xfer AND (((NOT sd_ncs_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --sd_ncs_s1_arb_share_counter arbitration counter enable, which is an e_assign
  sd_ncs_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_sd_ncs_s1 AND sd_ncs_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_sd_ncs_s1 AND NOT sd_ncs_s1_non_bursting_master_requests));
  --sd_ncs_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sd_ncs_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(sd_ncs_s1_arb_counter_enable) = '1' then 
        sd_ncs_s1_arb_share_counter <= sd_ncs_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --sd_ncs_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sd_ncs_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((sd_ncs_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_sd_ncs_s1)) OR ((end_xfer_arb_share_counter_term_sd_ncs_s1 AND NOT sd_ncs_s1_non_bursting_master_requests)))) = '1' then 
        sd_ncs_s1_slavearbiterlockenable <= sd_ncs_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pipeline_bridge/m1 sd_ncs/s1 arbiterlock, which is an e_assign
  pipeline_bridge_m1_arbiterlock <= sd_ncs_s1_slavearbiterlockenable AND pipeline_bridge_m1_continuerequest;
  --sd_ncs_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  sd_ncs_s1_slavearbiterlockenable2 <= sd_ncs_s1_arb_share_counter_next_value;
  --pipeline_bridge/m1 sd_ncs/s1 arbiterlock2, which is an e_assign
  pipeline_bridge_m1_arbiterlock2 <= sd_ncs_s1_slavearbiterlockenable2 AND pipeline_bridge_m1_continuerequest;
  --sd_ncs_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  sd_ncs_s1_any_continuerequest <= std_logic'('1');
  --pipeline_bridge_m1_continuerequest continued request, which is an e_assign
  pipeline_bridge_m1_continuerequest <= std_logic'('1');
  internal_pipeline_bridge_m1_qualified_request_sd_ncs_s1 <= internal_pipeline_bridge_m1_requests_sd_ncs_s1 AND NOT ((((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect)) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))))));
  --local readdatavalid pipeline_bridge_m1_read_data_valid_sd_ncs_s1, which is an e_mux
  pipeline_bridge_m1_read_data_valid_sd_ncs_s1 <= (internal_pipeline_bridge_m1_granted_sd_ncs_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect))) AND NOT sd_ncs_s1_waits_for_read;
  --sd_ncs_s1_writedata mux, which is an e_mux
  sd_ncs_s1_writedata <= pipeline_bridge_m1_writedata;
  --master is always granted when requested
  internal_pipeline_bridge_m1_granted_sd_ncs_s1 <= internal_pipeline_bridge_m1_qualified_request_sd_ncs_s1;
  --pipeline_bridge/m1 saved-grant sd_ncs/s1, which is an e_assign
  pipeline_bridge_m1_saved_grant_sd_ncs_s1 <= internal_pipeline_bridge_m1_requests_sd_ncs_s1;
  --allow new arb cycle for sd_ncs/s1, which is an e_assign
  sd_ncs_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  sd_ncs_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  sd_ncs_s1_master_qreq_vector <= std_logic'('1');
  --sd_ncs_s1_reset_n assignment, which is an e_assign
  sd_ncs_s1_reset_n <= reset_n;
  sd_ncs_s1_chipselect <= internal_pipeline_bridge_m1_granted_sd_ncs_s1;
  --sd_ncs_s1_firsttransfer first transaction, which is an e_assign
  sd_ncs_s1_firsttransfer <= A_WE_StdLogic((std_logic'(sd_ncs_s1_begins_xfer) = '1'), sd_ncs_s1_unreg_firsttransfer, sd_ncs_s1_reg_firsttransfer);
  --sd_ncs_s1_unreg_firsttransfer first transaction, which is an e_assign
  sd_ncs_s1_unreg_firsttransfer <= NOT ((sd_ncs_s1_slavearbiterlockenable AND sd_ncs_s1_any_continuerequest));
  --sd_ncs_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sd_ncs_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(sd_ncs_s1_begins_xfer) = '1' then 
        sd_ncs_s1_reg_firsttransfer <= sd_ncs_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --sd_ncs_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  sd_ncs_s1_beginbursttransfer_internal <= sd_ncs_s1_begins_xfer;
  --~sd_ncs_s1_write_n assignment, which is an e_mux
  sd_ncs_s1_write_n <= NOT ((internal_pipeline_bridge_m1_granted_sd_ncs_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect))));
  shifted_address_to_sd_ncs_s1_from_pipeline_bridge_m1 <= pipeline_bridge_m1_address_to_slave;
  --sd_ncs_s1_address mux, which is an e_mux
  sd_ncs_s1_address <= A_EXT (A_SRL(shifted_address_to_sd_ncs_s1_from_pipeline_bridge_m1,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_sd_ncs_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_sd_ncs_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_sd_ncs_s1_end_xfer <= sd_ncs_s1_end_xfer;
    end if;

  end process;

  --sd_ncs_s1_waits_for_read in a cycle, which is an e_mux
  sd_ncs_s1_waits_for_read <= sd_ncs_s1_in_a_read_cycle AND sd_ncs_s1_begins_xfer;
  --sd_ncs_s1_in_a_read_cycle assignment, which is an e_assign
  sd_ncs_s1_in_a_read_cycle <= internal_pipeline_bridge_m1_granted_sd_ncs_s1 AND ((pipeline_bridge_m1_read AND pipeline_bridge_m1_chipselect));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= sd_ncs_s1_in_a_read_cycle;
  --sd_ncs_s1_waits_for_write in a cycle, which is an e_mux
  sd_ncs_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sd_ncs_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --sd_ncs_s1_in_a_write_cycle assignment, which is an e_assign
  sd_ncs_s1_in_a_write_cycle <= internal_pipeline_bridge_m1_granted_sd_ncs_s1 AND ((pipeline_bridge_m1_write AND pipeline_bridge_m1_chipselect));
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= sd_ncs_s1_in_a_write_cycle;
  wait_for_sd_ncs_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  pipeline_bridge_m1_granted_sd_ncs_s1 <= internal_pipeline_bridge_m1_granted_sd_ncs_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_qualified_request_sd_ncs_s1 <= internal_pipeline_bridge_m1_qualified_request_sd_ncs_s1;
  --vhdl renameroo for output signals
  pipeline_bridge_m1_requests_sd_ncs_s1 <= internal_pipeline_bridge_m1_requests_sd_ncs_s1;
--synthesis translate_off
    --sd_ncs/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --pipeline_bridge/m1 non-zero burstcount assertion, which is an e_process
    process (clk)
    VARIABLE write_line30 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((internal_pipeline_bridge_m1_requests_sd_ncs_s1 AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pipeline_bridge_m1_burstcount))) = std_logic_vector'("00000000000000000000000000000000"))))) AND enable_nonzero_assertions)) = '1' then 
          write(write_line30, now);
          write(write_line30, string'(": "));
          write(write_line30, string'("pipeline_bridge/m1 drove 0 on its 'burstcount' port while accessing slave sd_ncs/s1"));
          write(output, write_line30.all);
          deallocate (write_line30);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

entity rdv_fifo_for_cpu_data_master_to_sdram_s1_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_sdram_s1_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_sdram_s1_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal full_2 :  STD_LOGIC;
                signal full_3 :  STD_LOGIC;
                signal full_4 :  STD_LOGIC;
                signal full_5 :  STD_LOGIC;
                signal full_6 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal p1_full_1 :  STD_LOGIC;
                signal p1_stage_1 :  STD_LOGIC;
                signal p2_full_2 :  STD_LOGIC;
                signal p2_stage_2 :  STD_LOGIC;
                signal p3_full_3 :  STD_LOGIC;
                signal p3_stage_3 :  STD_LOGIC;
                signal p4_full_4 :  STD_LOGIC;
                signal p4_stage_4 :  STD_LOGIC;
                signal p5_full_5 :  STD_LOGIC;
                signal p5_stage_5 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal stage_1 :  STD_LOGIC;
                signal stage_2 :  STD_LOGIC;
                signal stage_3 :  STD_LOGIC;
                signal stage_4 :  STD_LOGIC;
                signal stage_5 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (3 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_5;
  empty <= NOT(full_0);
  full_6 <= std_logic'('0');
  --data_5, which is an e_mux
  p5_stage_5 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_6 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_5, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_5 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_5))))) = '1' then 
        if std_logic'(((sync_reset AND full_5) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_6))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_5 <= std_logic'('0');
        else
          stage_5 <= p5_stage_5;
        end if;
      end if;
    end if;

  end process;

  --control_5, which is an e_mux
  p5_full_5 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_4))), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_5, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_5 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_5 <= std_logic'('0');
        else
          full_5 <= p5_full_5;
        end if;
      end if;
    end if;

  end process;

  --data_4, which is an e_mux
  p4_stage_4 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_5 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_5);
  --data_reg_4, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_4 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_4))))) = '1' then 
        if std_logic'(((sync_reset AND full_4) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_5))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_4 <= std_logic'('0');
        else
          stage_4 <= p4_stage_4;
        end if;
      end if;
    end if;

  end process;

  --control_4, which is an e_mux
  p4_full_4 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_3, full_5);
  --control_reg_4, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_4 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_4 <= std_logic'('0');
        else
          full_4 <= p4_full_4;
        end if;
      end if;
    end if;

  end process;

  --data_3, which is an e_mux
  p3_stage_3 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_4 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_4);
  --data_reg_3, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_3 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_3))))) = '1' then 
        if std_logic'(((sync_reset AND full_3) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_4))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_3 <= std_logic'('0');
        else
          stage_3 <= p3_stage_3;
        end if;
      end if;
    end if;

  end process;

  --control_3, which is an e_mux
  p3_full_3 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_2, full_4);
  --control_reg_3, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_3 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_3 <= std_logic'('0');
        else
          full_3 <= p3_full_3;
        end if;
      end if;
    end if;

  end process;

  --data_2, which is an e_mux
  p2_stage_2 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_3 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_3);
  --data_reg_2, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_2))))) = '1' then 
        if std_logic'(((sync_reset AND full_2) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_3))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_2 <= std_logic'('0');
        else
          stage_2 <= p2_stage_2;
        end if;
      end if;
    end if;

  end process;

  --control_2, which is an e_mux
  p2_full_2 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_1, full_3);
  --control_reg_2, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_2 <= std_logic'('0');
        else
          full_2 <= p2_full_2;
        end if;
      end if;
    end if;

  end process;

  --data_1, which is an e_mux
  p1_stage_1 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_2 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_2);
  --data_reg_1, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_1))))) = '1' then 
        if std_logic'(((sync_reset AND full_1) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_2))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_1 <= std_logic'('0');
        else
          stage_1 <= p1_stage_1;
        end if;
      end if;
    end if;

  end process;

  --control_1, which is an e_mux
  p1_full_1 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_0, full_2);
  --control_reg_1, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_1 <= std_logic'('0');
        else
          full_1 <= p1_full_1;
        end if;
      end if;
    end if;

  end process;

  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_1);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1)))));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("00000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 4);
  one_count_minus_one <= A_EXT (((std_logic_vector'("00000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 4);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("000") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 4);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("0000");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


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

entity rdv_fifo_for_cpu_instruction_master_to_sdram_s1_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_instruction_master_to_sdram_s1_module;


architecture europa of rdv_fifo_for_cpu_instruction_master_to_sdram_s1_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal full_2 :  STD_LOGIC;
                signal full_3 :  STD_LOGIC;
                signal full_4 :  STD_LOGIC;
                signal full_5 :  STD_LOGIC;
                signal full_6 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal p1_full_1 :  STD_LOGIC;
                signal p1_stage_1 :  STD_LOGIC;
                signal p2_full_2 :  STD_LOGIC;
                signal p2_stage_2 :  STD_LOGIC;
                signal p3_full_3 :  STD_LOGIC;
                signal p3_stage_3 :  STD_LOGIC;
                signal p4_full_4 :  STD_LOGIC;
                signal p4_stage_4 :  STD_LOGIC;
                signal p5_full_5 :  STD_LOGIC;
                signal p5_stage_5 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal stage_1 :  STD_LOGIC;
                signal stage_2 :  STD_LOGIC;
                signal stage_3 :  STD_LOGIC;
                signal stage_4 :  STD_LOGIC;
                signal stage_5 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (3 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_5;
  empty <= NOT(full_0);
  full_6 <= std_logic'('0');
  --data_5, which is an e_mux
  p5_stage_5 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_6 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_5, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_5 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_5))))) = '1' then 
        if std_logic'(((sync_reset AND full_5) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_6))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_5 <= std_logic'('0');
        else
          stage_5 <= p5_stage_5;
        end if;
      end if;
    end if;

  end process;

  --control_5, which is an e_mux
  p5_full_5 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_4))), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_5, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_5 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_5 <= std_logic'('0');
        else
          full_5 <= p5_full_5;
        end if;
      end if;
    end if;

  end process;

  --data_4, which is an e_mux
  p4_stage_4 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_5 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_5);
  --data_reg_4, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_4 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_4))))) = '1' then 
        if std_logic'(((sync_reset AND full_4) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_5))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_4 <= std_logic'('0');
        else
          stage_4 <= p4_stage_4;
        end if;
      end if;
    end if;

  end process;

  --control_4, which is an e_mux
  p4_full_4 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_3, full_5);
  --control_reg_4, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_4 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_4 <= std_logic'('0');
        else
          full_4 <= p4_full_4;
        end if;
      end if;
    end if;

  end process;

  --data_3, which is an e_mux
  p3_stage_3 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_4 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_4);
  --data_reg_3, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_3 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_3))))) = '1' then 
        if std_logic'(((sync_reset AND full_3) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_4))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_3 <= std_logic'('0');
        else
          stage_3 <= p3_stage_3;
        end if;
      end if;
    end if;

  end process;

  --control_3, which is an e_mux
  p3_full_3 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_2, full_4);
  --control_reg_3, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_3 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_3 <= std_logic'('0');
        else
          full_3 <= p3_full_3;
        end if;
      end if;
    end if;

  end process;

  --data_2, which is an e_mux
  p2_stage_2 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_3 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_3);
  --data_reg_2, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_2))))) = '1' then 
        if std_logic'(((sync_reset AND full_2) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_3))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_2 <= std_logic'('0');
        else
          stage_2 <= p2_stage_2;
        end if;
      end if;
    end if;

  end process;

  --control_2, which is an e_mux
  p2_full_2 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_1, full_3);
  --control_reg_2, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_2 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_2 <= std_logic'('0');
        else
          full_2 <= p2_full_2;
        end if;
      end if;
    end if;

  end process;

  --data_1, which is an e_mux
  p1_stage_1 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_2 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_2);
  --data_reg_1, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_1))))) = '1' then 
        if std_logic'(((sync_reset AND full_1) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_2))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_1 <= std_logic'('0');
        else
          stage_1 <= p1_stage_1;
        end if;
      end if;
    end if;

  end process;

  --control_1, which is an e_mux
  p1_full_1 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), full_0, full_2);
  --control_reg_1, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(clear_fifo) = '1' then 
          full_1 <= std_logic'('0');
        else
          full_1 <= p1_full_1;
        end if;
      end if;
    end if;

  end process;

  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, stage_1);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1)))));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("00000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 4);
  one_count_minus_one <= A_EXT (((std_logic_vector'("00000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 4);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("000") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 4);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("0000");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


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

library std;
use std.textio.all;

entity sdram_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_data_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_data_master_dbs_write_16 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal cpu_data_master_no_byte_enables_and_last_term : IN STD_LOGIC;
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal cpu_instruction_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_instruction_master_latency_counter : IN STD_LOGIC;
                 signal cpu_instruction_master_read : IN STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sdram_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sdram_s1_readdatavalid : IN STD_LOGIC;
                 signal sdram_s1_waitrequest : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_byteenable_sdram_s1 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_data_master_granted_sdram_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_sdram_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_sdram_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_sdram_s1_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_sdram_s1 : OUT STD_LOGIC;
                 signal cpu_instruction_master_granted_sdram_s1 : OUT STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_sdram_s1 : OUT STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_sdram_s1 : OUT STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_sdram_s1_shift_register : OUT STD_LOGIC;
                 signal cpu_instruction_master_requests_sdram_s1 : OUT STD_LOGIC;
                 signal d1_sdram_s1_end_xfer : OUT STD_LOGIC;
                 signal sdram_s1_address : OUT STD_LOGIC_VECTOR (21 DOWNTO 0);
                 signal sdram_s1_byteenable_n : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal sdram_s1_chipselect : OUT STD_LOGIC;
                 signal sdram_s1_read_n : OUT STD_LOGIC;
                 signal sdram_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sdram_s1_reset_n : OUT STD_LOGIC;
                 signal sdram_s1_waitrequest_from_sa : OUT STD_LOGIC;
                 signal sdram_s1_write_n : OUT STD_LOGIC;
                 signal sdram_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
              );
end entity sdram_s1_arbitrator;


architecture europa of sdram_s1_arbitrator is
component rdv_fifo_for_cpu_data_master_to_sdram_s1_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_sdram_s1_module;

component rdv_fifo_for_cpu_instruction_master_to_sdram_s1_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_instruction_master_to_sdram_s1_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_byteenable_sdram_s1_segment_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_data_master_byteenable_sdram_s1_segment_1 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_sdram_s1 :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_sdram_s1 :  STD_LOGIC;
                signal cpu_data_master_saved_grant_sdram_s1 :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_instruction_master_continuerequest :  STD_LOGIC;
                signal cpu_instruction_master_rdv_fifo_empty_sdram_s1 :  STD_LOGIC;
                signal cpu_instruction_master_rdv_fifo_output_from_sdram_s1 :  STD_LOGIC;
                signal cpu_instruction_master_saved_grant_sdram_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_sdram_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_byteenable_sdram_s1 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_cpu_data_master_granted_sdram_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_sdram_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_sdram_s1_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_sdram_s1 :  STD_LOGIC;
                signal internal_cpu_instruction_master_granted_sdram_s1 :  STD_LOGIC;
                signal internal_cpu_instruction_master_qualified_request_sdram_s1 :  STD_LOGIC;
                signal internal_cpu_instruction_master_requests_sdram_s1 :  STD_LOGIC;
                signal internal_sdram_s1_waitrequest_from_sa :  STD_LOGIC;
                signal last_cycle_cpu_data_master_granted_slave_sdram_s1 :  STD_LOGIC;
                signal last_cycle_cpu_instruction_master_granted_slave_sdram_s1 :  STD_LOGIC;
                signal module_input10 :  STD_LOGIC;
                signal module_input11 :  STD_LOGIC;
                signal module_input6 :  STD_LOGIC;
                signal module_input7 :  STD_LOGIC;
                signal module_input8 :  STD_LOGIC;
                signal module_input9 :  STD_LOGIC;
                signal sdram_s1_allgrants :  STD_LOGIC;
                signal sdram_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal sdram_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal sdram_s1_any_continuerequest :  STD_LOGIC;
                signal sdram_s1_arb_addend :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_s1_arb_counter_enable :  STD_LOGIC;
                signal sdram_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_s1_arb_winner :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_s1_arbitration_holdoff_internal :  STD_LOGIC;
                signal sdram_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal sdram_s1_begins_xfer :  STD_LOGIC;
                signal sdram_s1_chosen_master_double_vector :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal sdram_s1_chosen_master_rot_left :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_s1_end_xfer :  STD_LOGIC;
                signal sdram_s1_firsttransfer :  STD_LOGIC;
                signal sdram_s1_grant_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_s1_in_a_read_cycle :  STD_LOGIC;
                signal sdram_s1_in_a_write_cycle :  STD_LOGIC;
                signal sdram_s1_master_qreq_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_s1_move_on_to_next_transaction :  STD_LOGIC;
                signal sdram_s1_non_bursting_master_requests :  STD_LOGIC;
                signal sdram_s1_readdatavalid_from_sa :  STD_LOGIC;
                signal sdram_s1_reg_firsttransfer :  STD_LOGIC;
                signal sdram_s1_saved_chosen_master_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_s1_slavearbiterlockenable :  STD_LOGIC;
                signal sdram_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal sdram_s1_unreg_firsttransfer :  STD_LOGIC;
                signal sdram_s1_waits_for_read :  STD_LOGIC;
                signal sdram_s1_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_sdram_s1_from_cpu_data_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal shifted_address_to_sdram_s1_from_cpu_instruction_master :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal wait_for_sdram_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT sdram_s1_end_xfer;
    end if;

  end process;

  sdram_s1_begins_xfer <= NOT d1_reasons_to_wait AND ((internal_cpu_data_master_qualified_request_sdram_s1 OR internal_cpu_instruction_master_qualified_request_sdram_s1));
  --assign sdram_s1_readdatavalid_from_sa = sdram_s1_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  sdram_s1_readdatavalid_from_sa <= sdram_s1_readdatavalid;
  --assign sdram_s1_readdata_from_sa = sdram_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  sdram_s1_readdata_from_sa <= sdram_s1_readdata;
  internal_cpu_data_master_requests_sdram_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(25 DOWNTO 23) & std_logic_vector'("00000000000000000000000")) = std_logic_vector'("11000000000000000000000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign sdram_s1_waitrequest_from_sa = sdram_s1_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_sdram_s1_waitrequest_from_sa <= sdram_s1_waitrequest;
  --sdram_s1_arb_share_counter set values, which is an e_mux
  sdram_s1_arb_share_set_values <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_sdram_s1)) = '1'), std_logic_vector'("00000000000000000000000000000010"), A_WE_StdLogicVector((std_logic'((internal_cpu_instruction_master_granted_sdram_s1)) = '1'), std_logic_vector'("00000000000000000000000000000010"), A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_sdram_s1)) = '1'), std_logic_vector'("00000000000000000000000000000010"), A_WE_StdLogicVector((std_logic'((internal_cpu_instruction_master_granted_sdram_s1)) = '1'), std_logic_vector'("00000000000000000000000000000010"), std_logic_vector'("00000000000000000000000000000001"))))), 2);
  --sdram_s1_non_bursting_master_requests mux, which is an e_mux
  sdram_s1_non_bursting_master_requests <= ((internal_cpu_data_master_requests_sdram_s1 OR internal_cpu_instruction_master_requests_sdram_s1) OR internal_cpu_data_master_requests_sdram_s1) OR internal_cpu_instruction_master_requests_sdram_s1;
  --sdram_s1_any_bursting_master_saved_grant mux, which is an e_mux
  sdram_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --sdram_s1_arb_share_counter_next_value assignment, which is an e_assign
  sdram_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(sdram_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (sdram_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(sdram_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (sdram_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --sdram_s1_allgrants all slave grants, which is an e_mux
  sdram_s1_allgrants <= (((or_reduce(sdram_s1_grant_vector)) OR (or_reduce(sdram_s1_grant_vector))) OR (or_reduce(sdram_s1_grant_vector))) OR (or_reduce(sdram_s1_grant_vector));
  --sdram_s1_end_xfer assignment, which is an e_assign
  sdram_s1_end_xfer <= NOT ((sdram_s1_waits_for_read OR sdram_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_sdram_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_sdram_s1 <= sdram_s1_end_xfer AND (((NOT sdram_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --sdram_s1_arb_share_counter arbitration counter enable, which is an e_assign
  sdram_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_sdram_s1 AND sdram_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_sdram_s1 AND NOT sdram_s1_non_bursting_master_requests));
  --sdram_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sdram_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(sdram_s1_arb_counter_enable) = '1' then 
        sdram_s1_arb_share_counter <= sdram_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --sdram_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sdram_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((or_reduce(sdram_s1_master_qreq_vector) AND end_xfer_arb_share_counter_term_sdram_s1)) OR ((end_xfer_arb_share_counter_term_sdram_s1 AND NOT sdram_s1_non_bursting_master_requests)))) = '1' then 
        sdram_s1_slavearbiterlockenable <= or_reduce(sdram_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu/data_master sdram/s1 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= sdram_s1_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --sdram_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  sdram_s1_slavearbiterlockenable2 <= or_reduce(sdram_s1_arb_share_counter_next_value);
  --cpu/data_master sdram/s1 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= sdram_s1_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --cpu/instruction_master sdram/s1 arbiterlock, which is an e_assign
  cpu_instruction_master_arbiterlock <= sdram_s1_slavearbiterlockenable AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master sdram/s1 arbiterlock2, which is an e_assign
  cpu_instruction_master_arbiterlock2 <= sdram_s1_slavearbiterlockenable2 AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master granted sdram/s1 last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_instruction_master_granted_slave_sdram_s1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_instruction_master_granted_slave_sdram_s1 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_instruction_master_saved_grant_sdram_s1) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((sdram_s1_arbitration_holdoff_internal OR NOT internal_cpu_instruction_master_requests_sdram_s1))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_instruction_master_granted_slave_sdram_s1))))));
    end if;

  end process;

  --cpu_instruction_master_continuerequest continued request, which is an e_mux
  cpu_instruction_master_continuerequest <= last_cycle_cpu_instruction_master_granted_slave_sdram_s1 AND internal_cpu_instruction_master_requests_sdram_s1;
  --sdram_s1_any_continuerequest at least one master continues requesting, which is an e_mux
  sdram_s1_any_continuerequest <= cpu_instruction_master_continuerequest OR cpu_data_master_continuerequest;
  internal_cpu_data_master_qualified_request_sdram_s1 <= internal_cpu_data_master_requests_sdram_s1 AND NOT (((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_sdram_s1_shift_register))))) OR (((((NOT cpu_data_master_waitrequest OR cpu_data_master_no_byte_enables_and_last_term) OR NOT(or_reduce(internal_cpu_data_master_byteenable_sdram_s1)))) AND cpu_data_master_write))) OR cpu_instruction_master_arbiterlock));
  --unique name for sdram_s1_move_on_to_next_transaction, which is an e_assign
  sdram_s1_move_on_to_next_transaction <= sdram_s1_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_sdram_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_sdram_s1 : rdv_fifo_for_cpu_data_master_to_sdram_s1_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_sdram_s1,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_sdram_s1,
      full => open,
      clear_fifo => module_input6,
      clk => clk,
      data_in => internal_cpu_data_master_granted_sdram_s1,
      read => sdram_s1_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input7,
      write => module_input8
    );

  module_input6 <= std_logic'('0');
  module_input7 <= std_logic'('0');
  module_input8 <= in_a_read_cycle AND NOT sdram_s1_waits_for_read;

  internal_cpu_data_master_read_data_valid_sdram_s1_shift_register <= NOT cpu_data_master_rdv_fifo_empty_sdram_s1;
  --local readdatavalid cpu_data_master_read_data_valid_sdram_s1, which is an e_mux
  cpu_data_master_read_data_valid_sdram_s1 <= ((sdram_s1_readdatavalid_from_sa AND cpu_data_master_rdv_fifo_output_from_sdram_s1)) AND NOT cpu_data_master_rdv_fifo_empty_sdram_s1;
  --sdram_s1_writedata mux, which is an e_mux
  sdram_s1_writedata <= cpu_data_master_dbs_write_16;
  internal_cpu_instruction_master_requests_sdram_s1 <= ((to_std_logic(((Std_Logic_Vector'(cpu_instruction_master_address_to_slave(25 DOWNTO 23) & std_logic_vector'("00000000000000000000000")) = std_logic_vector'("11000000000000000000000000")))) AND (cpu_instruction_master_read))) AND cpu_instruction_master_read;
  --cpu/data_master granted sdram/s1 last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_data_master_granted_slave_sdram_s1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_data_master_granted_slave_sdram_s1 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_data_master_saved_grant_sdram_s1) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((sdram_s1_arbitration_holdoff_internal OR NOT internal_cpu_data_master_requests_sdram_s1))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_data_master_granted_slave_sdram_s1))))));
    end if;

  end process;

  --cpu_data_master_continuerequest continued request, which is an e_mux
  cpu_data_master_continuerequest <= last_cycle_cpu_data_master_granted_slave_sdram_s1 AND internal_cpu_data_master_requests_sdram_s1;
  internal_cpu_instruction_master_qualified_request_sdram_s1 <= internal_cpu_instruction_master_requests_sdram_s1 AND NOT ((((cpu_instruction_master_read AND ((to_std_logic(((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000"))) OR ((std_logic_vector'("00000000000000000000000000000001")<(std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_latency_counter))))))) OR (cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register))))) OR cpu_data_master_arbiterlock));
  --rdv_fifo_for_cpu_instruction_master_to_sdram_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_instruction_master_to_sdram_s1 : rdv_fifo_for_cpu_instruction_master_to_sdram_s1_module
    port map(
      data_out => cpu_instruction_master_rdv_fifo_output_from_sdram_s1,
      empty => open,
      fifo_contains_ones_n => cpu_instruction_master_rdv_fifo_empty_sdram_s1,
      full => open,
      clear_fifo => module_input9,
      clk => clk,
      data_in => internal_cpu_instruction_master_granted_sdram_s1,
      read => sdram_s1_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input10,
      write => module_input11
    );

  module_input9 <= std_logic'('0');
  module_input10 <= std_logic'('0');
  module_input11 <= in_a_read_cycle AND NOT sdram_s1_waits_for_read;

  cpu_instruction_master_read_data_valid_sdram_s1_shift_register <= NOT cpu_instruction_master_rdv_fifo_empty_sdram_s1;
  --local readdatavalid cpu_instruction_master_read_data_valid_sdram_s1, which is an e_mux
  cpu_instruction_master_read_data_valid_sdram_s1 <= ((sdram_s1_readdatavalid_from_sa AND cpu_instruction_master_rdv_fifo_output_from_sdram_s1)) AND NOT cpu_instruction_master_rdv_fifo_empty_sdram_s1;
  --allow new arb cycle for sdram/s1, which is an e_assign
  sdram_s1_allow_new_arb_cycle <= NOT cpu_data_master_arbiterlock AND NOT cpu_instruction_master_arbiterlock;
  --cpu/instruction_master assignment into master qualified-requests vector for sdram/s1, which is an e_assign
  sdram_s1_master_qreq_vector(0) <= internal_cpu_instruction_master_qualified_request_sdram_s1;
  --cpu/instruction_master grant sdram/s1, which is an e_assign
  internal_cpu_instruction_master_granted_sdram_s1 <= sdram_s1_grant_vector(0);
  --cpu/instruction_master saved-grant sdram/s1, which is an e_assign
  cpu_instruction_master_saved_grant_sdram_s1 <= sdram_s1_arb_winner(0) AND internal_cpu_instruction_master_requests_sdram_s1;
  --cpu/data_master assignment into master qualified-requests vector for sdram/s1, which is an e_assign
  sdram_s1_master_qreq_vector(1) <= internal_cpu_data_master_qualified_request_sdram_s1;
  --cpu/data_master grant sdram/s1, which is an e_assign
  internal_cpu_data_master_granted_sdram_s1 <= sdram_s1_grant_vector(1);
  --cpu/data_master saved-grant sdram/s1, which is an e_assign
  cpu_data_master_saved_grant_sdram_s1 <= sdram_s1_arb_winner(1) AND internal_cpu_data_master_requests_sdram_s1;
  --sdram/s1 chosen-master double-vector, which is an e_assign
  sdram_s1_chosen_master_double_vector <= A_EXT (((std_logic_vector'("0") & ((sdram_s1_master_qreq_vector & sdram_s1_master_qreq_vector))) AND (((std_logic_vector'("0") & (Std_Logic_Vector'(NOT sdram_s1_master_qreq_vector & NOT sdram_s1_master_qreq_vector))) + (std_logic_vector'("000") & (sdram_s1_arb_addend))))), 4);
  --stable onehot encoding of arb winner
  sdram_s1_arb_winner <= A_WE_StdLogicVector((std_logic'(((sdram_s1_allow_new_arb_cycle AND or_reduce(sdram_s1_grant_vector)))) = '1'), sdram_s1_grant_vector, sdram_s1_saved_chosen_master_vector);
  --saved sdram_s1_grant_vector, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sdram_s1_saved_chosen_master_vector <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(sdram_s1_allow_new_arb_cycle) = '1' then 
        sdram_s1_saved_chosen_master_vector <= A_WE_StdLogicVector((std_logic'(or_reduce(sdram_s1_grant_vector)) = '1'), sdram_s1_grant_vector, sdram_s1_saved_chosen_master_vector);
      end if;
    end if;

  end process;

  --onehot encoding of chosen master
  sdram_s1_grant_vector <= Std_Logic_Vector'(A_ToStdLogicVector(((sdram_s1_chosen_master_double_vector(1) OR sdram_s1_chosen_master_double_vector(3)))) & A_ToStdLogicVector(((sdram_s1_chosen_master_double_vector(0) OR sdram_s1_chosen_master_double_vector(2)))));
  --sdram/s1 chosen master rotated left, which is an e_assign
  sdram_s1_chosen_master_rot_left <= A_EXT (A_WE_StdLogicVector((((A_SLL(sdram_s1_arb_winner,std_logic_vector'("00000000000000000000000000000001")))) /= std_logic_vector'("00")), (std_logic_vector'("000000000000000000000000000000") & ((A_SLL(sdram_s1_arb_winner,std_logic_vector'("00000000000000000000000000000001"))))), std_logic_vector'("00000000000000000000000000000001")), 2);
  --sdram/s1's addend for next-master-grant
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sdram_s1_arb_addend <= std_logic_vector'("01");
    elsif clk'event and clk = '1' then
      if std_logic'(or_reduce(sdram_s1_grant_vector)) = '1' then 
        sdram_s1_arb_addend <= A_WE_StdLogicVector((std_logic'(sdram_s1_end_xfer) = '1'), sdram_s1_chosen_master_rot_left, sdram_s1_grant_vector);
      end if;
    end if;

  end process;

  --sdram_s1_reset_n assignment, which is an e_assign
  sdram_s1_reset_n <= reset_n;
  sdram_s1_chipselect <= internal_cpu_data_master_granted_sdram_s1 OR internal_cpu_instruction_master_granted_sdram_s1;
  --sdram_s1_firsttransfer first transaction, which is an e_assign
  sdram_s1_firsttransfer <= A_WE_StdLogic((std_logic'(sdram_s1_begins_xfer) = '1'), sdram_s1_unreg_firsttransfer, sdram_s1_reg_firsttransfer);
  --sdram_s1_unreg_firsttransfer first transaction, which is an e_assign
  sdram_s1_unreg_firsttransfer <= NOT ((sdram_s1_slavearbiterlockenable AND sdram_s1_any_continuerequest));
  --sdram_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sdram_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(sdram_s1_begins_xfer) = '1' then 
        sdram_s1_reg_firsttransfer <= sdram_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --sdram_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  sdram_s1_beginbursttransfer_internal <= sdram_s1_begins_xfer;
  --sdram_s1_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  sdram_s1_arbitration_holdoff_internal <= sdram_s1_begins_xfer AND sdram_s1_firsttransfer;
  --~sdram_s1_read_n assignment, which is an e_mux
  sdram_s1_read_n <= NOT ((((internal_cpu_data_master_granted_sdram_s1 AND cpu_data_master_read)) OR ((internal_cpu_instruction_master_granted_sdram_s1 AND cpu_instruction_master_read))));
  --~sdram_s1_write_n assignment, which is an e_mux
  sdram_s1_write_n <= NOT ((internal_cpu_data_master_granted_sdram_s1 AND cpu_data_master_write));
  shifted_address_to_sdram_s1_from_cpu_data_master <= A_EXT (Std_Logic_Vector'(A_SRL(cpu_data_master_address_to_slave,std_logic_vector'("00000000000000000000000000000010")) & A_ToStdLogicVector(cpu_data_master_dbs_address(1)) & A_ToStdLogicVector(std_logic'('0'))), 26);
  --sdram_s1_address mux, which is an e_mux
  sdram_s1_address <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_sdram_s1)) = '1'), (A_SRL(shifted_address_to_sdram_s1_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000001"))), (A_SRL(shifted_address_to_sdram_s1_from_cpu_instruction_master,std_logic_vector'("00000000000000000000000000000001")))), 22);
  shifted_address_to_sdram_s1_from_cpu_instruction_master <= A_EXT (Std_Logic_Vector'(A_SRL(cpu_instruction_master_address_to_slave,std_logic_vector'("00000000000000000000000000000010")) & A_ToStdLogicVector(cpu_instruction_master_dbs_address(1)) & A_ToStdLogicVector(std_logic'('0'))), 26);
  --d1_sdram_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_sdram_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_sdram_s1_end_xfer <= sdram_s1_end_xfer;
    end if;

  end process;

  --sdram_s1_waits_for_read in a cycle, which is an e_mux
  sdram_s1_waits_for_read <= sdram_s1_in_a_read_cycle AND internal_sdram_s1_waitrequest_from_sa;
  --sdram_s1_in_a_read_cycle assignment, which is an e_assign
  sdram_s1_in_a_read_cycle <= ((internal_cpu_data_master_granted_sdram_s1 AND cpu_data_master_read)) OR ((internal_cpu_instruction_master_granted_sdram_s1 AND cpu_instruction_master_read));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= sdram_s1_in_a_read_cycle;
  --sdram_s1_waits_for_write in a cycle, which is an e_mux
  sdram_s1_waits_for_write <= sdram_s1_in_a_write_cycle AND internal_sdram_s1_waitrequest_from_sa;
  --sdram_s1_in_a_write_cycle assignment, which is an e_assign
  sdram_s1_in_a_write_cycle <= internal_cpu_data_master_granted_sdram_s1 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= sdram_s1_in_a_write_cycle;
  wait_for_sdram_s1_counter <= std_logic'('0');
  --~sdram_s1_byteenable_n byte enable port mux, which is an e_mux
  sdram_s1_byteenable_n <= A_EXT (NOT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_sdram_s1)) = '1'), (std_logic_vector'("000000000000000000000000000000") & (internal_cpu_data_master_byteenable_sdram_s1)), -SIGNED(std_logic_vector'("00000000000000000000000000000001")))), 2);
  (cpu_data_master_byteenable_sdram_s1_segment_1(1), cpu_data_master_byteenable_sdram_s1_segment_1(0), cpu_data_master_byteenable_sdram_s1_segment_0(1), cpu_data_master_byteenable_sdram_s1_segment_0(0)) <= cpu_data_master_byteenable;
  internal_cpu_data_master_byteenable_sdram_s1 <= A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_dbs_address(1)))) = std_logic_vector'("00000000000000000000000000000000"))), cpu_data_master_byteenable_sdram_s1_segment_0, cpu_data_master_byteenable_sdram_s1_segment_1);
  --vhdl renameroo for output signals
  cpu_data_master_byteenable_sdram_s1 <= internal_cpu_data_master_byteenable_sdram_s1;
  --vhdl renameroo for output signals
  cpu_data_master_granted_sdram_s1 <= internal_cpu_data_master_granted_sdram_s1;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_sdram_s1 <= internal_cpu_data_master_qualified_request_sdram_s1;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_sdram_s1_shift_register <= internal_cpu_data_master_read_data_valid_sdram_s1_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_sdram_s1 <= internal_cpu_data_master_requests_sdram_s1;
  --vhdl renameroo for output signals
  cpu_instruction_master_granted_sdram_s1 <= internal_cpu_instruction_master_granted_sdram_s1;
  --vhdl renameroo for output signals
  cpu_instruction_master_qualified_request_sdram_s1 <= internal_cpu_instruction_master_qualified_request_sdram_s1;
  --vhdl renameroo for output signals
  cpu_instruction_master_requests_sdram_s1 <= internal_cpu_instruction_master_requests_sdram_s1;
  --vhdl renameroo for output signals
  sdram_s1_waitrequest_from_sa <= internal_sdram_s1_waitrequest_from_sa;
--synthesis translate_off
    --sdram/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line31 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_data_master_granted_sdram_s1))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_instruction_master_granted_sdram_s1))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line31, now);
          write(write_line31, string'(": "));
          write(write_line31, string'("> 1 of grant signals are active simultaneously"));
          write(output, write_line31.all);
          deallocate (write_line31);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --saved_grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line32 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_data_master_saved_grant_sdram_s1))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_saved_grant_sdram_s1))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line32, now);
          write(write_line32, string'(": "));
          write(write_line32, string'("> 1 of saved_grant signals are active simultaneously"));
          write(output, write_line32.all);
          deallocate (write_line32);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

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

entity nios32_reset_clk_domain_synch_module is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC
              );
end entity nios32_reset_clk_domain_synch_module;


architecture europa of nios32_reset_clk_domain_synch_module is
                signal data_in_d1 :  STD_LOGIC;
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of data_in_d1 : signal is "{-from ""*""} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of data_out : signal is "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101";

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      data_in_d1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      data_in_d1 <= data_in;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      data_out <= std_logic'('0');
    elsif clk'event and clk = '1' then
      data_out <= data_in_d1;
    end if;

  end process;


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

entity nios32 is 
        port (
              -- 1) global signals:
                 signal clk : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- the_ads_busy
                 signal in_port_to_the_ads_busy : IN STD_LOGIC;

              -- the_ads_clk
                 signal out_port_from_the_ads_clk : OUT STD_LOGIC;

              -- the_ads_din
                 signal out_port_from_the_ads_din : OUT STD_LOGIC;

              -- the_ads_dout
                 signal in_port_to_the_ads_dout : IN STD_LOGIC;

              -- the_ads_ncs
                 signal out_port_from_the_ads_ncs : OUT STD_LOGIC;

              -- the_ads_nirq
                 signal in_port_to_the_ads_nirq : IN STD_LOGIC;

              -- the_epcs_flash_controller
                 signal data0_to_the_epcs_flash_controller : IN STD_LOGIC;
                 signal dclk_from_the_epcs_flash_controller : OUT STD_LOGIC;
                 signal sce_from_the_epcs_flash_controller : OUT STD_LOGIC;
                 signal sdo_from_the_epcs_flash_controller : OUT STD_LOGIC;

              -- the_ili_db
                 signal bidir_port_to_and_from_the_ili_db : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);

              -- the_ili_ncs
                 signal out_port_from_the_ili_ncs : OUT STD_LOGIC;

              -- the_ili_nrd
                 signal out_port_from_the_ili_nrd : OUT STD_LOGIC;

              -- the_ili_nrst
                 signal out_port_from_the_ili_nrst : OUT STD_LOGIC;

              -- the_ili_nwr
                 signal out_port_from_the_ili_nwr : OUT STD_LOGIC;

              -- the_ili_rs
                 signal out_port_from_the_ili_rs : OUT STD_LOGIC;

              -- the_sd_clk
                 signal out_port_from_the_sd_clk : OUT STD_LOGIC;

              -- the_sd_din
                 signal out_port_from_the_sd_din : OUT STD_LOGIC;

              -- the_sd_dout
                 signal in_port_to_the_sd_dout : IN STD_LOGIC;

              -- the_sd_ncs
                 signal out_port_from_the_sd_ncs : OUT STD_LOGIC;

              -- the_sdram
                 signal zs_addr_from_the_sdram : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
                 signal zs_ba_from_the_sdram : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal zs_cas_n_from_the_sdram : OUT STD_LOGIC;
                 signal zs_cke_from_the_sdram : OUT STD_LOGIC;
                 signal zs_cs_n_from_the_sdram : OUT STD_LOGIC;
                 signal zs_dq_to_and_from_the_sdram : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal zs_dqm_from_the_sdram : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal zs_ras_n_from_the_sdram : OUT STD_LOGIC;
                 signal zs_we_n_from_the_sdram : OUT STD_LOGIC
              );
end entity nios32;


architecture europa of nios32 is
component ads_busy_s1_arbitrator is 
           port (
                 -- inputs:
                    signal ads_busy_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                    signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                    signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read : IN STD_LOGIC;
                    signal pipeline_bridge_m1_write : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal ads_busy_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal ads_busy_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ads_busy_s1_reset_n : OUT STD_LOGIC;
                    signal d1_ads_busy_s1_end_xfer : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_granted_ads_busy_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ads_busy_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ads_busy_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ads_busy_s1 : OUT STD_LOGIC
                 );
end component ads_busy_s1_arbitrator;

component ads_busy is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal in_port : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component ads_busy;

component ads_clk_s1_arbitrator is 
           port (
                 -- inputs:
                    signal ads_clk_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                    signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                    signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read : IN STD_LOGIC;
                    signal pipeline_bridge_m1_write : IN STD_LOGIC;
                    signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal ads_clk_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal ads_clk_s1_chipselect : OUT STD_LOGIC;
                    signal ads_clk_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ads_clk_s1_reset_n : OUT STD_LOGIC;
                    signal ads_clk_s1_write_n : OUT STD_LOGIC;
                    signal ads_clk_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_ads_clk_s1_end_xfer : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_granted_ads_clk_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ads_clk_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ads_clk_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ads_clk_s1 : OUT STD_LOGIC
                 );
end component ads_clk_s1_arbitrator;

component ads_clk is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component ads_clk;

component ads_din_s1_arbitrator is 
           port (
                 -- inputs:
                    signal ads_din_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                    signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                    signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read : IN STD_LOGIC;
                    signal pipeline_bridge_m1_write : IN STD_LOGIC;
                    signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal ads_din_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal ads_din_s1_chipselect : OUT STD_LOGIC;
                    signal ads_din_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ads_din_s1_reset_n : OUT STD_LOGIC;
                    signal ads_din_s1_write_n : OUT STD_LOGIC;
                    signal ads_din_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_ads_din_s1_end_xfer : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_granted_ads_din_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ads_din_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ads_din_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ads_din_s1 : OUT STD_LOGIC
                 );
end component ads_din_s1_arbitrator;

component ads_din is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component ads_din;

component ads_dout_s1_arbitrator is 
           port (
                 -- inputs:
                    signal ads_dout_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                    signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                    signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read : IN STD_LOGIC;
                    signal pipeline_bridge_m1_write : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal ads_dout_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal ads_dout_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ads_dout_s1_reset_n : OUT STD_LOGIC;
                    signal d1_ads_dout_s1_end_xfer : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_granted_ads_dout_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ads_dout_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ads_dout_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ads_dout_s1 : OUT STD_LOGIC
                 );
end component ads_dout_s1_arbitrator;

component ads_dout is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal in_port : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component ads_dout;

component ads_ncs_s1_arbitrator is 
           port (
                 -- inputs:
                    signal ads_ncs_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                    signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                    signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read : IN STD_LOGIC;
                    signal pipeline_bridge_m1_write : IN STD_LOGIC;
                    signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal ads_ncs_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal ads_ncs_s1_chipselect : OUT STD_LOGIC;
                    signal ads_ncs_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ads_ncs_s1_reset_n : OUT STD_LOGIC;
                    signal ads_ncs_s1_write_n : OUT STD_LOGIC;
                    signal ads_ncs_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_ads_ncs_s1_end_xfer : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_granted_ads_ncs_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ads_ncs_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ads_ncs_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ads_ncs_s1 : OUT STD_LOGIC
                 );
end component ads_ncs_s1_arbitrator;

component ads_ncs is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component ads_ncs;

component ads_nirq_s1_arbitrator is 
           port (
                 -- inputs:
                    signal ads_nirq_s1_irq : IN STD_LOGIC;
                    signal ads_nirq_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                    signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                    signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read : IN STD_LOGIC;
                    signal pipeline_bridge_m1_write : IN STD_LOGIC;
                    signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal ads_nirq_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal ads_nirq_s1_chipselect : OUT STD_LOGIC;
                    signal ads_nirq_s1_irq_from_sa : OUT STD_LOGIC;
                    signal ads_nirq_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ads_nirq_s1_reset_n : OUT STD_LOGIC;
                    signal ads_nirq_s1_write_n : OUT STD_LOGIC;
                    signal ads_nirq_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_ads_nirq_s1_end_xfer : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_granted_ads_nirq_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ads_nirq_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ads_nirq_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ads_nirq_s1 : OUT STD_LOGIC
                 );
end component ads_nirq_s1_arbitrator;

component ads_nirq is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal in_port : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal irq : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component ads_nirq;

component cpu_jtag_debug_module_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_data_master_debugaccess : IN STD_LOGIC;
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_instruction_master_latency_counter : IN STD_LOGIC;
                    signal cpu_instruction_master_read : IN STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register : IN STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_sdram_s1_shift_register : IN STD_LOGIC;
                    signal cpu_jtag_debug_module_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_jtag_debug_module_resetrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_data_master_requests_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_instruction_master_granted_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_instruction_master_requests_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_address : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal cpu_jtag_debug_module_begintransfer : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_jtag_debug_module_chipselect : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_debugaccess : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_jtag_debug_module_reset_n : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_resetrequest_from_sa : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_write : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_cpu_jtag_debug_module_end_xfer : OUT STD_LOGIC
                 );
end component cpu_jtag_debug_module_arbitrator;

component cpu_data_master_arbitrator is 
           port (
                 -- inputs:
                    signal ads_nirq_s1_irq_from_sa : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_data_master_byteenable_sdram_s1 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_data_master_granted_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_data_master_granted_epcs_flash_controller_epcs_control_port : IN STD_LOGIC;
                    signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_pipeline_bridge_s1 : IN STD_LOGIC;
                    signal cpu_data_master_granted_sdram_s1 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_pipeline_bridge_s1 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_sdram_s1 : IN STD_LOGIC;
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_epcs_flash_controller_epcs_control_port : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_pipeline_bridge_s1 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_pipeline_bridge_s1_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_sdram_s1 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_sdram_s1_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_requests_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_data_master_requests_epcs_flash_controller_epcs_control_port : IN STD_LOGIC;
                    signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_pipeline_bridge_s1 : IN STD_LOGIC;
                    signal cpu_data_master_requests_sdram_s1 : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_cpu_jtag_debug_module_end_xfer : IN STD_LOGIC;
                    signal d1_epcs_flash_controller_epcs_control_port_end_xfer : IN STD_LOGIC;
                    signal d1_jtag_uart_avalon_jtag_slave_end_xfer : IN STD_LOGIC;
                    signal d1_pipeline_bridge_s1_end_xfer : IN STD_LOGIC;
                    signal d1_sdram_s1_end_xfer : IN STD_LOGIC;
                    signal epcs_flash_controller_epcs_control_port_irq_from_sa : IN STD_LOGIC;
                    signal epcs_flash_controller_epcs_control_port_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_avalon_jtag_slave_irq_from_sa : IN STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal pipeline_bridge_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_s1_waitrequest_from_sa : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sdram_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sdram_s1_waitrequest_from_sa : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_address_to_slave : OUT STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_data_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_data_master_dbs_write_16 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal cpu_data_master_irq : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_data_master_no_byte_enables_and_last_term : OUT STD_LOGIC;
                    signal cpu_data_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_data_master_waitrequest : OUT STD_LOGIC
                 );
end component cpu_data_master_arbitrator;

component cpu_instruction_master_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_instruction_master_address : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_instruction_master_granted_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port : IN STD_LOGIC;
                    signal cpu_instruction_master_granted_pipeline_bridge_s1 : IN STD_LOGIC;
                    signal cpu_instruction_master_granted_sdram_s1 : IN STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port : IN STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_pipeline_bridge_s1 : IN STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_sdram_s1 : IN STD_LOGIC;
                    signal cpu_instruction_master_read : IN STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port : IN STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_pipeline_bridge_s1 : IN STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register : IN STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_sdram_s1 : IN STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_sdram_s1_shift_register : IN STD_LOGIC;
                    signal cpu_instruction_master_requests_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port : IN STD_LOGIC;
                    signal cpu_instruction_master_requests_pipeline_bridge_s1 : IN STD_LOGIC;
                    signal cpu_instruction_master_requests_sdram_s1 : IN STD_LOGIC;
                    signal cpu_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_cpu_jtag_debug_module_end_xfer : IN STD_LOGIC;
                    signal d1_epcs_flash_controller_epcs_control_port_end_xfer : IN STD_LOGIC;
                    signal d1_pipeline_bridge_s1_end_xfer : IN STD_LOGIC;
                    signal d1_sdram_s1_end_xfer : IN STD_LOGIC;
                    signal epcs_flash_controller_epcs_control_port_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_s1_waitrequest_from_sa : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sdram_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sdram_s1_waitrequest_from_sa : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_instruction_master_address_to_slave : OUT STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_instruction_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_instruction_master_latency_counter : OUT STD_LOGIC;
                    signal cpu_instruction_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_instruction_master_readdatavalid : OUT STD_LOGIC;
                    signal cpu_instruction_master_waitrequest : OUT STD_LOGIC
                 );
end component cpu_instruction_master_arbitrator;

component cpu is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal d_irq : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d_waitrequest : IN STD_LOGIC;
                    signal i_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal i_readdatavalid : IN STD_LOGIC;
                    signal i_waitrequest : IN STD_LOGIC;
                    signal jtag_debug_module_address : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal jtag_debug_module_begintransfer : IN STD_LOGIC;
                    signal jtag_debug_module_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal jtag_debug_module_debugaccess : IN STD_LOGIC;
                    signal jtag_debug_module_select : IN STD_LOGIC;
                    signal jtag_debug_module_write : IN STD_LOGIC;
                    signal jtag_debug_module_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal d_address : OUT STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal d_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal d_read : OUT STD_LOGIC;
                    signal d_write : OUT STD_LOGIC;
                    signal d_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal i_address : OUT STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal i_read : OUT STD_LOGIC;
                    signal jtag_debug_module_debugaccess_to_roms : OUT STD_LOGIC;
                    signal jtag_debug_module_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_debug_module_resetrequest : OUT STD_LOGIC
                 );
end component cpu;

component epcs_flash_controller_epcs_control_port_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_instruction_master_latency_counter : IN STD_LOGIC;
                    signal cpu_instruction_master_read : IN STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register : IN STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_sdram_s1_shift_register : IN STD_LOGIC;
                    signal epcs_flash_controller_epcs_control_port_dataavailable : IN STD_LOGIC;
                    signal epcs_flash_controller_epcs_control_port_endofpacket : IN STD_LOGIC;
                    signal epcs_flash_controller_epcs_control_port_irq : IN STD_LOGIC;
                    signal epcs_flash_controller_epcs_control_port_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal epcs_flash_controller_epcs_control_port_readyfordata : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_epcs_flash_controller_epcs_control_port : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_epcs_flash_controller_epcs_control_port : OUT STD_LOGIC;
                    signal cpu_data_master_requests_epcs_flash_controller_epcs_control_port : OUT STD_LOGIC;
                    signal cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port : OUT STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port : OUT STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port : OUT STD_LOGIC;
                    signal cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port : OUT STD_LOGIC;
                    signal d1_epcs_flash_controller_epcs_control_port_end_xfer : OUT STD_LOGIC;
                    signal epcs_flash_controller_epcs_control_port_address : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal epcs_flash_controller_epcs_control_port_chipselect : OUT STD_LOGIC;
                    signal epcs_flash_controller_epcs_control_port_dataavailable_from_sa : OUT STD_LOGIC;
                    signal epcs_flash_controller_epcs_control_port_endofpacket_from_sa : OUT STD_LOGIC;
                    signal epcs_flash_controller_epcs_control_port_irq_from_sa : OUT STD_LOGIC;
                    signal epcs_flash_controller_epcs_control_port_read_n : OUT STD_LOGIC;
                    signal epcs_flash_controller_epcs_control_port_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal epcs_flash_controller_epcs_control_port_readyfordata_from_sa : OUT STD_LOGIC;
                    signal epcs_flash_controller_epcs_control_port_reset_n : OUT STD_LOGIC;
                    signal epcs_flash_controller_epcs_control_port_write_n : OUT STD_LOGIC;
                    signal epcs_flash_controller_epcs_control_port_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component epcs_flash_controller_epcs_control_port_arbitrator;

component epcs_flash_controller is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data0 : IN STD_LOGIC;
                    signal read_n : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal dataavailable : OUT STD_LOGIC;
                    signal dclk : OUT STD_LOGIC;
                    signal endofpacket : OUT STD_LOGIC;
                    signal irq : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal readyfordata : OUT STD_LOGIC;
                    signal sce : OUT STD_LOGIC;
                    signal sdo : OUT STD_LOGIC
                 );
end component epcs_flash_controller;

component ili_db_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal ili_db_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                    signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                    signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read : IN STD_LOGIC;
                    signal pipeline_bridge_m1_write : IN STD_LOGIC;
                    signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal d1_ili_db_s1_end_xfer : OUT STD_LOGIC;
                    signal ili_db_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal ili_db_s1_chipselect : OUT STD_LOGIC;
                    signal ili_db_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ili_db_s1_reset_n : OUT STD_LOGIC;
                    signal ili_db_s1_write_n : OUT STD_LOGIC;
                    signal ili_db_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_m1_granted_ili_db_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ili_db_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ili_db_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ili_db_s1 : OUT STD_LOGIC
                 );
end component ili_db_s1_arbitrator;

component ili_db is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal bidir_port : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component ili_db;

component ili_ncs_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal ili_ncs_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                    signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                    signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read : IN STD_LOGIC;
                    signal pipeline_bridge_m1_write : IN STD_LOGIC;
                    signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal d1_ili_ncs_s1_end_xfer : OUT STD_LOGIC;
                    signal ili_ncs_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal ili_ncs_s1_chipselect : OUT STD_LOGIC;
                    signal ili_ncs_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ili_ncs_s1_reset_n : OUT STD_LOGIC;
                    signal ili_ncs_s1_write_n : OUT STD_LOGIC;
                    signal ili_ncs_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_m1_granted_ili_ncs_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ili_ncs_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ili_ncs_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ili_ncs_s1 : OUT STD_LOGIC
                 );
end component ili_ncs_s1_arbitrator;

component ili_ncs is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component ili_ncs;

component ili_nrd_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal ili_nrd_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                    signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                    signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read : IN STD_LOGIC;
                    signal pipeline_bridge_m1_write : IN STD_LOGIC;
                    signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal d1_ili_nrd_s1_end_xfer : OUT STD_LOGIC;
                    signal ili_nrd_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal ili_nrd_s1_chipselect : OUT STD_LOGIC;
                    signal ili_nrd_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ili_nrd_s1_reset_n : OUT STD_LOGIC;
                    signal ili_nrd_s1_write_n : OUT STD_LOGIC;
                    signal ili_nrd_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_m1_granted_ili_nrd_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ili_nrd_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ili_nrd_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ili_nrd_s1 : OUT STD_LOGIC
                 );
end component ili_nrd_s1_arbitrator;

component ili_nrd is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component ili_nrd;

component ili_nrst_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal ili_nrst_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                    signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                    signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read : IN STD_LOGIC;
                    signal pipeline_bridge_m1_write : IN STD_LOGIC;
                    signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal d1_ili_nrst_s1_end_xfer : OUT STD_LOGIC;
                    signal ili_nrst_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal ili_nrst_s1_chipselect : OUT STD_LOGIC;
                    signal ili_nrst_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ili_nrst_s1_reset_n : OUT STD_LOGIC;
                    signal ili_nrst_s1_write_n : OUT STD_LOGIC;
                    signal ili_nrst_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_m1_granted_ili_nrst_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ili_nrst_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ili_nrst_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ili_nrst_s1 : OUT STD_LOGIC
                 );
end component ili_nrst_s1_arbitrator;

component ili_nrst is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component ili_nrst;

component ili_nwr_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal ili_nwr_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                    signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                    signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read : IN STD_LOGIC;
                    signal pipeline_bridge_m1_write : IN STD_LOGIC;
                    signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal d1_ili_nwr_s1_end_xfer : OUT STD_LOGIC;
                    signal ili_nwr_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal ili_nwr_s1_chipselect : OUT STD_LOGIC;
                    signal ili_nwr_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ili_nwr_s1_reset_n : OUT STD_LOGIC;
                    signal ili_nwr_s1_write_n : OUT STD_LOGIC;
                    signal ili_nwr_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_m1_granted_ili_nwr_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ili_nwr_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ili_nwr_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ili_nwr_s1 : OUT STD_LOGIC
                 );
end component ili_nwr_s1_arbitrator;

component ili_nwr is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component ili_nwr;

component ili_rs_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal ili_rs_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                    signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                    signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read : IN STD_LOGIC;
                    signal pipeline_bridge_m1_write : IN STD_LOGIC;
                    signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal d1_ili_rs_s1_end_xfer : OUT STD_LOGIC;
                    signal ili_rs_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal ili_rs_s1_chipselect : OUT STD_LOGIC;
                    signal ili_rs_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ili_rs_s1_reset_n : OUT STD_LOGIC;
                    signal ili_rs_s1_write_n : OUT STD_LOGIC;
                    signal ili_rs_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_m1_granted_ili_rs_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ili_rs_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ili_rs_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ili_rs_s1 : OUT STD_LOGIC
                 );
end component ili_rs_s1_arbitrator;

component ili_rs is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component ili_rs;

component jtag_uart_avalon_jtag_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_avalon_jtag_slave_dataavailable : IN STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_irq : IN STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_avalon_jtag_slave_readyfordata : IN STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                    signal d1_jtag_uart_avalon_jtag_slave_end_xfer : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_address : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_chipselect : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_dataavailable_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_irq_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_read_n : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_avalon_jtag_slave_readyfordata_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_reset_n : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_write_n : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component jtag_uart_avalon_jtag_slave_arbitrator;

component jtag_uart is 
           port (
                 -- inputs:
                    signal av_address : IN STD_LOGIC;
                    signal av_chipselect : IN STD_LOGIC;
                    signal av_read_n : IN STD_LOGIC;
                    signal av_write_n : IN STD_LOGIC;
                    signal av_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal rst_n : IN STD_LOGIC;

                 -- outputs:
                    signal av_irq : OUT STD_LOGIC;
                    signal av_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal av_waitrequest : OUT STD_LOGIC;
                    signal dataavailable : OUT STD_LOGIC;
                    signal readyfordata : OUT STD_LOGIC
                 );
end component jtag_uart;

component pipeline_bridge_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_data_master_debugaccess : IN STD_LOGIC;
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_instruction_master_latency_counter : IN STD_LOGIC;
                    signal cpu_instruction_master_read : IN STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_sdram_s1_shift_register : IN STD_LOGIC;
                    signal pipeline_bridge_s1_endofpacket : IN STD_LOGIC;
                    signal pipeline_bridge_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_s1_readdatavalid : IN STD_LOGIC;
                    signal pipeline_bridge_s1_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_pipeline_bridge_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_pipeline_bridge_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_pipeline_bridge_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_pipeline_bridge_s1_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_pipeline_bridge_s1 : OUT STD_LOGIC;
                    signal cpu_instruction_master_granted_pipeline_bridge_s1 : OUT STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_pipeline_bridge_s1 : OUT STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_pipeline_bridge_s1 : OUT STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register : OUT STD_LOGIC;
                    signal cpu_instruction_master_requests_pipeline_bridge_s1 : OUT STD_LOGIC;
                    signal d1_pipeline_bridge_s1_end_xfer : OUT STD_LOGIC;
                    signal pipeline_bridge_s1_address : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
                    signal pipeline_bridge_s1_arbiterlock : OUT STD_LOGIC;
                    signal pipeline_bridge_s1_arbiterlock2 : OUT STD_LOGIC;
                    signal pipeline_bridge_s1_burstcount : OUT STD_LOGIC;
                    signal pipeline_bridge_s1_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal pipeline_bridge_s1_chipselect : OUT STD_LOGIC;
                    signal pipeline_bridge_s1_debugaccess : OUT STD_LOGIC;
                    signal pipeline_bridge_s1_endofpacket_from_sa : OUT STD_LOGIC;
                    signal pipeline_bridge_s1_nativeaddress : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
                    signal pipeline_bridge_s1_read : OUT STD_LOGIC;
                    signal pipeline_bridge_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_s1_reset_n : OUT STD_LOGIC;
                    signal pipeline_bridge_s1_waitrequest_from_sa : OUT STD_LOGIC;
                    signal pipeline_bridge_s1_write : OUT STD_LOGIC;
                    signal pipeline_bridge_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component pipeline_bridge_s1_arbitrator;

component pipeline_bridge_m1_arbitrator is 
           port (
                 -- inputs:
                    signal ads_busy_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ads_clk_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ads_din_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ads_dout_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ads_ncs_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ads_nirq_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal d1_ads_busy_s1_end_xfer : IN STD_LOGIC;
                    signal d1_ads_clk_s1_end_xfer : IN STD_LOGIC;
                    signal d1_ads_din_s1_end_xfer : IN STD_LOGIC;
                    signal d1_ads_dout_s1_end_xfer : IN STD_LOGIC;
                    signal d1_ads_ncs_s1_end_xfer : IN STD_LOGIC;
                    signal d1_ads_nirq_s1_end_xfer : IN STD_LOGIC;
                    signal d1_ili_db_s1_end_xfer : IN STD_LOGIC;
                    signal d1_ili_ncs_s1_end_xfer : IN STD_LOGIC;
                    signal d1_ili_nrd_s1_end_xfer : IN STD_LOGIC;
                    signal d1_ili_nrst_s1_end_xfer : IN STD_LOGIC;
                    signal d1_ili_nwr_s1_end_xfer : IN STD_LOGIC;
                    signal d1_ili_rs_s1_end_xfer : IN STD_LOGIC;
                    signal d1_sd_clk_s1_end_xfer : IN STD_LOGIC;
                    signal d1_sd_din_s1_end_xfer : IN STD_LOGIC;
                    signal d1_sd_dout_s1_end_xfer : IN STD_LOGIC;
                    signal d1_sd_ncs_s1_end_xfer : IN STD_LOGIC;
                    signal ili_db_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ili_ncs_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ili_nrd_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ili_nrst_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ili_nwr_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ili_rs_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_m1_address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                    signal pipeline_bridge_m1_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                    signal pipeline_bridge_m1_granted_ads_busy_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_granted_ads_clk_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_granted_ads_din_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_granted_ads_dout_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_granted_ads_ncs_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_granted_ads_nirq_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_granted_ili_db_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_granted_ili_ncs_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_granted_ili_nrd_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_granted_ili_nrst_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_granted_ili_nwr_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_granted_ili_rs_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_granted_sd_clk_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_granted_sd_din_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_granted_sd_dout_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_granted_sd_ncs_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ads_busy_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ads_clk_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ads_din_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ads_dout_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ads_ncs_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ads_nirq_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ili_db_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ili_ncs_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ili_nrd_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ili_nrst_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ili_nwr_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_ili_rs_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_sd_clk_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_sd_din_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_sd_dout_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_sd_ncs_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ads_busy_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ads_clk_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ads_din_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ads_dout_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ads_ncs_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ads_nirq_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ili_db_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ili_ncs_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ili_nrd_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ili_nrst_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ili_nwr_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_ili_rs_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_sd_clk_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_sd_din_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_sd_dout_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_sd_ncs_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ads_busy_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ads_clk_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ads_din_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ads_dout_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ads_ncs_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ads_nirq_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ili_db_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ili_ncs_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ili_nrd_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ili_nrst_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ili_nwr_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_requests_ili_rs_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_requests_sd_clk_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_requests_sd_din_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_requests_sd_dout_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_requests_sd_ncs_s1 : IN STD_LOGIC;
                    signal pipeline_bridge_m1_write : IN STD_LOGIC;
                    signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal sd_clk_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal sd_din_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal sd_dout_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal sd_ncs_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal pipeline_bridge_m1_address_to_slave : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal pipeline_bridge_m1_latency_counter : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pipeline_bridge_m1_readdatavalid : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_waitrequest : OUT STD_LOGIC
                 );
end component pipeline_bridge_m1_arbitrator;

component pipeline_bridge is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal m1_endofpacket : IN STD_LOGIC;
                    signal m1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal m1_readdatavalid : IN STD_LOGIC;
                    signal m1_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal s1_address : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
                    signal s1_arbiterlock : IN STD_LOGIC;
                    signal s1_arbiterlock2 : IN STD_LOGIC;
                    signal s1_burstcount : IN STD_LOGIC;
                    signal s1_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s1_chipselect : IN STD_LOGIC;
                    signal s1_debugaccess : IN STD_LOGIC;
                    signal s1_nativeaddress : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
                    signal s1_read : IN STD_LOGIC;
                    signal s1_write : IN STD_LOGIC;
                    signal s1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal m1_address : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal m1_burstcount : OUT STD_LOGIC;
                    signal m1_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal m1_chipselect : OUT STD_LOGIC;
                    signal m1_debugaccess : OUT STD_LOGIC;
                    signal m1_read : OUT STD_LOGIC;
                    signal m1_write : OUT STD_LOGIC;
                    signal m1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s1_endofpacket : OUT STD_LOGIC;
                    signal s1_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s1_readdatavalid : OUT STD_LOGIC;
                    signal s1_waitrequest : OUT STD_LOGIC
                 );
end component pipeline_bridge;

component pipeline_bridge_bridge_arbitrator is 
end component pipeline_bridge_bridge_arbitrator;

component sd_clk_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                    signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                    signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read : IN STD_LOGIC;
                    signal pipeline_bridge_m1_write : IN STD_LOGIC;
                    signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal sd_clk_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal d1_sd_clk_s1_end_xfer : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_granted_sd_clk_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_sd_clk_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_sd_clk_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_requests_sd_clk_s1 : OUT STD_LOGIC;
                    signal sd_clk_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal sd_clk_s1_chipselect : OUT STD_LOGIC;
                    signal sd_clk_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal sd_clk_s1_reset_n : OUT STD_LOGIC;
                    signal sd_clk_s1_write_n : OUT STD_LOGIC;
                    signal sd_clk_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component sd_clk_s1_arbitrator;

component sd_clk is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component sd_clk;

component sd_din_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                    signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                    signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read : IN STD_LOGIC;
                    signal pipeline_bridge_m1_write : IN STD_LOGIC;
                    signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal sd_din_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal d1_sd_din_s1_end_xfer : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_granted_sd_din_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_sd_din_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_sd_din_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_requests_sd_din_s1 : OUT STD_LOGIC;
                    signal sd_din_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal sd_din_s1_chipselect : OUT STD_LOGIC;
                    signal sd_din_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal sd_din_s1_reset_n : OUT STD_LOGIC;
                    signal sd_din_s1_write_n : OUT STD_LOGIC;
                    signal sd_din_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component sd_din_s1_arbitrator;

component sd_din is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component sd_din;

component sd_dout_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                    signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                    signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read : IN STD_LOGIC;
                    signal pipeline_bridge_m1_write : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sd_dout_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal d1_sd_dout_s1_end_xfer : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_granted_sd_dout_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_sd_dout_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_sd_dout_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_requests_sd_dout_s1 : OUT STD_LOGIC;
                    signal sd_dout_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal sd_dout_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal sd_dout_s1_reset_n : OUT STD_LOGIC
                 );
end component sd_dout_s1_arbitrator;

component sd_dout is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal in_port : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component sd_dout;

component sd_ncs_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal pipeline_bridge_m1_address_to_slave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal pipeline_bridge_m1_burstcount : IN STD_LOGIC;
                    signal pipeline_bridge_m1_chipselect : IN STD_LOGIC;
                    signal pipeline_bridge_m1_latency_counter : IN STD_LOGIC;
                    signal pipeline_bridge_m1_read : IN STD_LOGIC;
                    signal pipeline_bridge_m1_write : IN STD_LOGIC;
                    signal pipeline_bridge_m1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal sd_ncs_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal d1_sd_ncs_s1_end_xfer : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_granted_sd_ncs_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_qualified_request_sd_ncs_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_read_data_valid_sd_ncs_s1 : OUT STD_LOGIC;
                    signal pipeline_bridge_m1_requests_sd_ncs_s1 : OUT STD_LOGIC;
                    signal sd_ncs_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal sd_ncs_s1_chipselect : OUT STD_LOGIC;
                    signal sd_ncs_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal sd_ncs_s1_reset_n : OUT STD_LOGIC;
                    signal sd_ncs_s1_write_n : OUT STD_LOGIC;
                    signal sd_ncs_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component sd_ncs_s1_arbitrator;

component sd_ncs is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component sd_ncs;

component sdram_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_data_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_data_master_dbs_write_16 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal cpu_data_master_no_byte_enables_and_last_term : IN STD_LOGIC;
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal cpu_instruction_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_instruction_master_latency_counter : IN STD_LOGIC;
                    signal cpu_instruction_master_read : IN STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sdram_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sdram_s1_readdatavalid : IN STD_LOGIC;
                    signal sdram_s1_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_byteenable_sdram_s1 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_data_master_granted_sdram_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_sdram_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_sdram_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_sdram_s1_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_sdram_s1 : OUT STD_LOGIC;
                    signal cpu_instruction_master_granted_sdram_s1 : OUT STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_sdram_s1 : OUT STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_sdram_s1 : OUT STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_sdram_s1_shift_register : OUT STD_LOGIC;
                    signal cpu_instruction_master_requests_sdram_s1 : OUT STD_LOGIC;
                    signal d1_sdram_s1_end_xfer : OUT STD_LOGIC;
                    signal sdram_s1_address : OUT STD_LOGIC_VECTOR (21 DOWNTO 0);
                    signal sdram_s1_byteenable_n : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal sdram_s1_chipselect : OUT STD_LOGIC;
                    signal sdram_s1_read_n : OUT STD_LOGIC;
                    signal sdram_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sdram_s1_reset_n : OUT STD_LOGIC;
                    signal sdram_s1_waitrequest_from_sa : OUT STD_LOGIC;
                    signal sdram_s1_write_n : OUT STD_LOGIC;
                    signal sdram_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component sdram_s1_arbitrator;

component sdram is 
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
end component sdram;

component nios32_reset_clk_domain_synch_module is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC
                 );
end component nios32_reset_clk_domain_synch_module;

                signal ads_busy_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal ads_busy_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ads_busy_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ads_busy_s1_reset_n :  STD_LOGIC;
                signal ads_clk_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal ads_clk_s1_chipselect :  STD_LOGIC;
                signal ads_clk_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ads_clk_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ads_clk_s1_reset_n :  STD_LOGIC;
                signal ads_clk_s1_write_n :  STD_LOGIC;
                signal ads_clk_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ads_din_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal ads_din_s1_chipselect :  STD_LOGIC;
                signal ads_din_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ads_din_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ads_din_s1_reset_n :  STD_LOGIC;
                signal ads_din_s1_write_n :  STD_LOGIC;
                signal ads_din_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ads_dout_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal ads_dout_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ads_dout_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ads_dout_s1_reset_n :  STD_LOGIC;
                signal ads_ncs_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal ads_ncs_s1_chipselect :  STD_LOGIC;
                signal ads_ncs_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ads_ncs_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ads_ncs_s1_reset_n :  STD_LOGIC;
                signal ads_ncs_s1_write_n :  STD_LOGIC;
                signal ads_ncs_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ads_nirq_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal ads_nirq_s1_chipselect :  STD_LOGIC;
                signal ads_nirq_s1_irq :  STD_LOGIC;
                signal ads_nirq_s1_irq_from_sa :  STD_LOGIC;
                signal ads_nirq_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ads_nirq_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ads_nirq_s1_reset_n :  STD_LOGIC;
                signal ads_nirq_s1_write_n :  STD_LOGIC;
                signal ads_nirq_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal clk_reset_n :  STD_LOGIC;
                signal cpu_data_master_address :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal cpu_data_master_address_to_slave :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal cpu_data_master_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_data_master_byteenable_sdram_s1 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_data_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_data_master_dbs_write_16 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal cpu_data_master_debugaccess :  STD_LOGIC;
                signal cpu_data_master_granted_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_data_master_granted_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_data_master_granted_pipeline_bridge_s1 :  STD_LOGIC;
                signal cpu_data_master_granted_sdram_s1 :  STD_LOGIC;
                signal cpu_data_master_irq :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_data_master_no_byte_enables_and_last_term :  STD_LOGIC;
                signal cpu_data_master_qualified_request_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_pipeline_bridge_s1 :  STD_LOGIC;
                signal cpu_data_master_qualified_request_sdram_s1 :  STD_LOGIC;
                signal cpu_data_master_read :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_pipeline_bridge_s1 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_pipeline_bridge_s1_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_sdram_s1 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_sdram_s1_shift_register :  STD_LOGIC;
                signal cpu_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_data_master_requests_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_data_master_requests_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_data_master_requests_pipeline_bridge_s1 :  STD_LOGIC;
                signal cpu_data_master_requests_sdram_s1 :  STD_LOGIC;
                signal cpu_data_master_waitrequest :  STD_LOGIC;
                signal cpu_data_master_write :  STD_LOGIC;
                signal cpu_data_master_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_instruction_master_address :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal cpu_instruction_master_address_to_slave :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal cpu_instruction_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_instruction_master_granted_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal cpu_instruction_master_granted_pipeline_bridge_s1 :  STD_LOGIC;
                signal cpu_instruction_master_granted_sdram_s1 :  STD_LOGIC;
                signal cpu_instruction_master_latency_counter :  STD_LOGIC;
                signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal cpu_instruction_master_qualified_request_pipeline_bridge_s1 :  STD_LOGIC;
                signal cpu_instruction_master_qualified_request_sdram_s1 :  STD_LOGIC;
                signal cpu_instruction_master_read :  STD_LOGIC;
                signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal cpu_instruction_master_read_data_valid_pipeline_bridge_s1 :  STD_LOGIC;
                signal cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register :  STD_LOGIC;
                signal cpu_instruction_master_read_data_valid_sdram_s1 :  STD_LOGIC;
                signal cpu_instruction_master_read_data_valid_sdram_s1_shift_register :  STD_LOGIC;
                signal cpu_instruction_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_instruction_master_readdatavalid :  STD_LOGIC;
                signal cpu_instruction_master_requests_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port :  STD_LOGIC;
                signal cpu_instruction_master_requests_pipeline_bridge_s1 :  STD_LOGIC;
                signal cpu_instruction_master_requests_sdram_s1 :  STD_LOGIC;
                signal cpu_instruction_master_waitrequest :  STD_LOGIC;
                signal cpu_jtag_debug_module_address :  STD_LOGIC_VECTOR (8 DOWNTO 0);
                signal cpu_jtag_debug_module_begintransfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_jtag_debug_module_chipselect :  STD_LOGIC;
                signal cpu_jtag_debug_module_debugaccess :  STD_LOGIC;
                signal cpu_jtag_debug_module_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_jtag_debug_module_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_jtag_debug_module_reset_n :  STD_LOGIC;
                signal cpu_jtag_debug_module_resetrequest :  STD_LOGIC;
                signal cpu_jtag_debug_module_resetrequest_from_sa :  STD_LOGIC;
                signal cpu_jtag_debug_module_write :  STD_LOGIC;
                signal cpu_jtag_debug_module_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal d1_ads_busy_s1_end_xfer :  STD_LOGIC;
                signal d1_ads_clk_s1_end_xfer :  STD_LOGIC;
                signal d1_ads_din_s1_end_xfer :  STD_LOGIC;
                signal d1_ads_dout_s1_end_xfer :  STD_LOGIC;
                signal d1_ads_ncs_s1_end_xfer :  STD_LOGIC;
                signal d1_ads_nirq_s1_end_xfer :  STD_LOGIC;
                signal d1_cpu_jtag_debug_module_end_xfer :  STD_LOGIC;
                signal d1_epcs_flash_controller_epcs_control_port_end_xfer :  STD_LOGIC;
                signal d1_ili_db_s1_end_xfer :  STD_LOGIC;
                signal d1_ili_ncs_s1_end_xfer :  STD_LOGIC;
                signal d1_ili_nrd_s1_end_xfer :  STD_LOGIC;
                signal d1_ili_nrst_s1_end_xfer :  STD_LOGIC;
                signal d1_ili_nwr_s1_end_xfer :  STD_LOGIC;
                signal d1_ili_rs_s1_end_xfer :  STD_LOGIC;
                signal d1_jtag_uart_avalon_jtag_slave_end_xfer :  STD_LOGIC;
                signal d1_pipeline_bridge_s1_end_xfer :  STD_LOGIC;
                signal d1_sd_clk_s1_end_xfer :  STD_LOGIC;
                signal d1_sd_din_s1_end_xfer :  STD_LOGIC;
                signal d1_sd_dout_s1_end_xfer :  STD_LOGIC;
                signal d1_sd_ncs_s1_end_xfer :  STD_LOGIC;
                signal d1_sdram_s1_end_xfer :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_address :  STD_LOGIC_VECTOR (8 DOWNTO 0);
                signal epcs_flash_controller_epcs_control_port_chipselect :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_dataavailable :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_dataavailable_from_sa :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_endofpacket :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_endofpacket_from_sa :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_irq :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_irq_from_sa :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_read_n :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal epcs_flash_controller_epcs_control_port_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal epcs_flash_controller_epcs_control_port_readyfordata :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_readyfordata_from_sa :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_reset_n :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_write_n :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ili_db_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal ili_db_s1_chipselect :  STD_LOGIC;
                signal ili_db_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ili_db_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ili_db_s1_reset_n :  STD_LOGIC;
                signal ili_db_s1_write_n :  STD_LOGIC;
                signal ili_db_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ili_ncs_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal ili_ncs_s1_chipselect :  STD_LOGIC;
                signal ili_ncs_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ili_ncs_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ili_ncs_s1_reset_n :  STD_LOGIC;
                signal ili_ncs_s1_write_n :  STD_LOGIC;
                signal ili_ncs_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ili_nrd_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal ili_nrd_s1_chipselect :  STD_LOGIC;
                signal ili_nrd_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ili_nrd_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ili_nrd_s1_reset_n :  STD_LOGIC;
                signal ili_nrd_s1_write_n :  STD_LOGIC;
                signal ili_nrd_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ili_nrst_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal ili_nrst_s1_chipselect :  STD_LOGIC;
                signal ili_nrst_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ili_nrst_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ili_nrst_s1_reset_n :  STD_LOGIC;
                signal ili_nrst_s1_write_n :  STD_LOGIC;
                signal ili_nrst_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ili_nwr_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal ili_nwr_s1_chipselect :  STD_LOGIC;
                signal ili_nwr_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ili_nwr_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ili_nwr_s1_reset_n :  STD_LOGIC;
                signal ili_nwr_s1_write_n :  STD_LOGIC;
                signal ili_nwr_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ili_rs_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal ili_rs_s1_chipselect :  STD_LOGIC;
                signal ili_rs_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ili_rs_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal ili_rs_s1_reset_n :  STD_LOGIC;
                signal ili_rs_s1_write_n :  STD_LOGIC;
                signal ili_rs_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_dclk_from_the_epcs_flash_controller :  STD_LOGIC;
                signal internal_out_port_from_the_ads_clk :  STD_LOGIC;
                signal internal_out_port_from_the_ads_din :  STD_LOGIC;
                signal internal_out_port_from_the_ads_ncs :  STD_LOGIC;
                signal internal_out_port_from_the_ili_ncs :  STD_LOGIC;
                signal internal_out_port_from_the_ili_nrd :  STD_LOGIC;
                signal internal_out_port_from_the_ili_nrst :  STD_LOGIC;
                signal internal_out_port_from_the_ili_nwr :  STD_LOGIC;
                signal internal_out_port_from_the_ili_rs :  STD_LOGIC;
                signal internal_out_port_from_the_sd_clk :  STD_LOGIC;
                signal internal_out_port_from_the_sd_din :  STD_LOGIC;
                signal internal_out_port_from_the_sd_ncs :  STD_LOGIC;
                signal internal_sce_from_the_epcs_flash_controller :  STD_LOGIC;
                signal internal_sdo_from_the_epcs_flash_controller :  STD_LOGIC;
                signal internal_zs_addr_from_the_sdram :  STD_LOGIC_VECTOR (11 DOWNTO 0);
                signal internal_zs_ba_from_the_sdram :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_zs_cas_n_from_the_sdram :  STD_LOGIC;
                signal internal_zs_cke_from_the_sdram :  STD_LOGIC;
                signal internal_zs_cs_n_from_the_sdram :  STD_LOGIC;
                signal internal_zs_dqm_from_the_sdram :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_zs_ras_n_from_the_sdram :  STD_LOGIC;
                signal internal_zs_we_n_from_the_sdram :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_address :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_chipselect :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_dataavailable :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_dataavailable_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_irq :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_irq_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_read_n :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal jtag_uart_avalon_jtag_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal jtag_uart_avalon_jtag_slave_readyfordata :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_readyfordata_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_reset_n :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_waitrequest :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_write_n :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal module_input12 :  STD_LOGIC;
                signal pipeline_bridge_m1_address :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal pipeline_bridge_m1_address_to_slave :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal pipeline_bridge_m1_burstcount :  STD_LOGIC;
                signal pipeline_bridge_m1_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal pipeline_bridge_m1_chipselect :  STD_LOGIC;
                signal pipeline_bridge_m1_debugaccess :  STD_LOGIC;
                signal pipeline_bridge_m1_endofpacket :  STD_LOGIC;
                signal pipeline_bridge_m1_granted_ads_busy_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_granted_ads_clk_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_granted_ads_din_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_granted_ads_dout_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_granted_ads_ncs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_granted_ads_nirq_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_granted_ili_db_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_granted_ili_ncs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_granted_ili_nrd_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_granted_ili_nrst_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_granted_ili_nwr_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_granted_ili_rs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_granted_sd_clk_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_granted_sd_din_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_granted_sd_dout_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_granted_sd_ncs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_latency_counter :  STD_LOGIC;
                signal pipeline_bridge_m1_qualified_request_ads_busy_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_qualified_request_ads_clk_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_qualified_request_ads_din_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_qualified_request_ads_dout_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_qualified_request_ads_ncs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_qualified_request_ads_nirq_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_qualified_request_ili_db_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_qualified_request_ili_ncs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_qualified_request_ili_nrd_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_qualified_request_ili_nrst_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_qualified_request_ili_nwr_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_qualified_request_ili_rs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_qualified_request_sd_clk_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_qualified_request_sd_din_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_qualified_request_sd_dout_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_qualified_request_sd_ncs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_read :  STD_LOGIC;
                signal pipeline_bridge_m1_read_data_valid_ads_busy_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_read_data_valid_ads_clk_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_read_data_valid_ads_din_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_read_data_valid_ads_dout_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_read_data_valid_ads_ncs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_read_data_valid_ads_nirq_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_read_data_valid_ili_db_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_read_data_valid_ili_ncs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_read_data_valid_ili_nrd_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_read_data_valid_ili_nrst_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_read_data_valid_ili_nwr_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_read_data_valid_ili_rs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_read_data_valid_sd_clk_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_read_data_valid_sd_din_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_read_data_valid_sd_dout_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_read_data_valid_sd_ncs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal pipeline_bridge_m1_readdatavalid :  STD_LOGIC;
                signal pipeline_bridge_m1_requests_ads_busy_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_requests_ads_clk_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_requests_ads_din_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_requests_ads_dout_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_requests_ads_ncs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_requests_ads_nirq_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_requests_ili_db_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_requests_ili_ncs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_requests_ili_nrd_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_requests_ili_nrst_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_requests_ili_nwr_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_requests_ili_rs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_requests_sd_clk_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_requests_sd_din_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_requests_sd_dout_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_requests_sd_ncs_s1 :  STD_LOGIC;
                signal pipeline_bridge_m1_waitrequest :  STD_LOGIC;
                signal pipeline_bridge_m1_write :  STD_LOGIC;
                signal pipeline_bridge_m1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal pipeline_bridge_s1_address :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal pipeline_bridge_s1_arbiterlock :  STD_LOGIC;
                signal pipeline_bridge_s1_arbiterlock2 :  STD_LOGIC;
                signal pipeline_bridge_s1_burstcount :  STD_LOGIC;
                signal pipeline_bridge_s1_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal pipeline_bridge_s1_chipselect :  STD_LOGIC;
                signal pipeline_bridge_s1_debugaccess :  STD_LOGIC;
                signal pipeline_bridge_s1_endofpacket :  STD_LOGIC;
                signal pipeline_bridge_s1_endofpacket_from_sa :  STD_LOGIC;
                signal pipeline_bridge_s1_nativeaddress :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal pipeline_bridge_s1_read :  STD_LOGIC;
                signal pipeline_bridge_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal pipeline_bridge_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal pipeline_bridge_s1_readdatavalid :  STD_LOGIC;
                signal pipeline_bridge_s1_reset_n :  STD_LOGIC;
                signal pipeline_bridge_s1_waitrequest :  STD_LOGIC;
                signal pipeline_bridge_s1_waitrequest_from_sa :  STD_LOGIC;
                signal pipeline_bridge_s1_write :  STD_LOGIC;
                signal pipeline_bridge_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal reset_n_sources :  STD_LOGIC;
                signal sd_clk_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sd_clk_s1_chipselect :  STD_LOGIC;
                signal sd_clk_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal sd_clk_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal sd_clk_s1_reset_n :  STD_LOGIC;
                signal sd_clk_s1_write_n :  STD_LOGIC;
                signal sd_clk_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal sd_din_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sd_din_s1_chipselect :  STD_LOGIC;
                signal sd_din_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal sd_din_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal sd_din_s1_reset_n :  STD_LOGIC;
                signal sd_din_s1_write_n :  STD_LOGIC;
                signal sd_din_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal sd_dout_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sd_dout_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal sd_dout_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal sd_dout_s1_reset_n :  STD_LOGIC;
                signal sd_ncs_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sd_ncs_s1_chipselect :  STD_LOGIC;
                signal sd_ncs_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal sd_ncs_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal sd_ncs_s1_reset_n :  STD_LOGIC;
                signal sd_ncs_s1_write_n :  STD_LOGIC;
                signal sd_ncs_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal sdram_s1_address :  STD_LOGIC_VECTOR (21 DOWNTO 0);
                signal sdram_s1_byteenable_n :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sdram_s1_chipselect :  STD_LOGIC;
                signal sdram_s1_read_n :  STD_LOGIC;
                signal sdram_s1_readdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sdram_s1_readdata_from_sa :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sdram_s1_readdatavalid :  STD_LOGIC;
                signal sdram_s1_reset_n :  STD_LOGIC;
                signal sdram_s1_waitrequest :  STD_LOGIC;
                signal sdram_s1_waitrequest_from_sa :  STD_LOGIC;
                signal sdram_s1_write_n :  STD_LOGIC;
                signal sdram_s1_writedata :  STD_LOGIC_VECTOR (15 DOWNTO 0);

begin

  --the_ads_busy_s1, which is an e_instance
  the_ads_busy_s1 : ads_busy_s1_arbitrator
    port map(
      ads_busy_s1_address => ads_busy_s1_address,
      ads_busy_s1_readdata_from_sa => ads_busy_s1_readdata_from_sa,
      ads_busy_s1_reset_n => ads_busy_s1_reset_n,
      d1_ads_busy_s1_end_xfer => d1_ads_busy_s1_end_xfer,
      pipeline_bridge_m1_granted_ads_busy_s1 => pipeline_bridge_m1_granted_ads_busy_s1,
      pipeline_bridge_m1_qualified_request_ads_busy_s1 => pipeline_bridge_m1_qualified_request_ads_busy_s1,
      pipeline_bridge_m1_read_data_valid_ads_busy_s1 => pipeline_bridge_m1_read_data_valid_ads_busy_s1,
      pipeline_bridge_m1_requests_ads_busy_s1 => pipeline_bridge_m1_requests_ads_busy_s1,
      ads_busy_s1_readdata => ads_busy_s1_readdata,
      clk => clk,
      pipeline_bridge_m1_address_to_slave => pipeline_bridge_m1_address_to_slave,
      pipeline_bridge_m1_burstcount => pipeline_bridge_m1_burstcount,
      pipeline_bridge_m1_chipselect => pipeline_bridge_m1_chipselect,
      pipeline_bridge_m1_latency_counter => pipeline_bridge_m1_latency_counter,
      pipeline_bridge_m1_read => pipeline_bridge_m1_read,
      pipeline_bridge_m1_write => pipeline_bridge_m1_write,
      reset_n => clk_reset_n
    );


  --the_ads_busy, which is an e_ptf_instance
  the_ads_busy : ads_busy
    port map(
      readdata => ads_busy_s1_readdata,
      address => ads_busy_s1_address,
      clk => clk,
      in_port => in_port_to_the_ads_busy,
      reset_n => ads_busy_s1_reset_n
    );


  --the_ads_clk_s1, which is an e_instance
  the_ads_clk_s1 : ads_clk_s1_arbitrator
    port map(
      ads_clk_s1_address => ads_clk_s1_address,
      ads_clk_s1_chipselect => ads_clk_s1_chipselect,
      ads_clk_s1_readdata_from_sa => ads_clk_s1_readdata_from_sa,
      ads_clk_s1_reset_n => ads_clk_s1_reset_n,
      ads_clk_s1_write_n => ads_clk_s1_write_n,
      ads_clk_s1_writedata => ads_clk_s1_writedata,
      d1_ads_clk_s1_end_xfer => d1_ads_clk_s1_end_xfer,
      pipeline_bridge_m1_granted_ads_clk_s1 => pipeline_bridge_m1_granted_ads_clk_s1,
      pipeline_bridge_m1_qualified_request_ads_clk_s1 => pipeline_bridge_m1_qualified_request_ads_clk_s1,
      pipeline_bridge_m1_read_data_valid_ads_clk_s1 => pipeline_bridge_m1_read_data_valid_ads_clk_s1,
      pipeline_bridge_m1_requests_ads_clk_s1 => pipeline_bridge_m1_requests_ads_clk_s1,
      ads_clk_s1_readdata => ads_clk_s1_readdata,
      clk => clk,
      pipeline_bridge_m1_address_to_slave => pipeline_bridge_m1_address_to_slave,
      pipeline_bridge_m1_burstcount => pipeline_bridge_m1_burstcount,
      pipeline_bridge_m1_chipselect => pipeline_bridge_m1_chipselect,
      pipeline_bridge_m1_latency_counter => pipeline_bridge_m1_latency_counter,
      pipeline_bridge_m1_read => pipeline_bridge_m1_read,
      pipeline_bridge_m1_write => pipeline_bridge_m1_write,
      pipeline_bridge_m1_writedata => pipeline_bridge_m1_writedata,
      reset_n => clk_reset_n
    );


  --the_ads_clk, which is an e_ptf_instance
  the_ads_clk : ads_clk
    port map(
      out_port => internal_out_port_from_the_ads_clk,
      readdata => ads_clk_s1_readdata,
      address => ads_clk_s1_address,
      chipselect => ads_clk_s1_chipselect,
      clk => clk,
      reset_n => ads_clk_s1_reset_n,
      write_n => ads_clk_s1_write_n,
      writedata => ads_clk_s1_writedata
    );


  --the_ads_din_s1, which is an e_instance
  the_ads_din_s1 : ads_din_s1_arbitrator
    port map(
      ads_din_s1_address => ads_din_s1_address,
      ads_din_s1_chipselect => ads_din_s1_chipselect,
      ads_din_s1_readdata_from_sa => ads_din_s1_readdata_from_sa,
      ads_din_s1_reset_n => ads_din_s1_reset_n,
      ads_din_s1_write_n => ads_din_s1_write_n,
      ads_din_s1_writedata => ads_din_s1_writedata,
      d1_ads_din_s1_end_xfer => d1_ads_din_s1_end_xfer,
      pipeline_bridge_m1_granted_ads_din_s1 => pipeline_bridge_m1_granted_ads_din_s1,
      pipeline_bridge_m1_qualified_request_ads_din_s1 => pipeline_bridge_m1_qualified_request_ads_din_s1,
      pipeline_bridge_m1_read_data_valid_ads_din_s1 => pipeline_bridge_m1_read_data_valid_ads_din_s1,
      pipeline_bridge_m1_requests_ads_din_s1 => pipeline_bridge_m1_requests_ads_din_s1,
      ads_din_s1_readdata => ads_din_s1_readdata,
      clk => clk,
      pipeline_bridge_m1_address_to_slave => pipeline_bridge_m1_address_to_slave,
      pipeline_bridge_m1_burstcount => pipeline_bridge_m1_burstcount,
      pipeline_bridge_m1_chipselect => pipeline_bridge_m1_chipselect,
      pipeline_bridge_m1_latency_counter => pipeline_bridge_m1_latency_counter,
      pipeline_bridge_m1_read => pipeline_bridge_m1_read,
      pipeline_bridge_m1_write => pipeline_bridge_m1_write,
      pipeline_bridge_m1_writedata => pipeline_bridge_m1_writedata,
      reset_n => clk_reset_n
    );


  --the_ads_din, which is an e_ptf_instance
  the_ads_din : ads_din
    port map(
      out_port => internal_out_port_from_the_ads_din,
      readdata => ads_din_s1_readdata,
      address => ads_din_s1_address,
      chipselect => ads_din_s1_chipselect,
      clk => clk,
      reset_n => ads_din_s1_reset_n,
      write_n => ads_din_s1_write_n,
      writedata => ads_din_s1_writedata
    );


  --the_ads_dout_s1, which is an e_instance
  the_ads_dout_s1 : ads_dout_s1_arbitrator
    port map(
      ads_dout_s1_address => ads_dout_s1_address,
      ads_dout_s1_readdata_from_sa => ads_dout_s1_readdata_from_sa,
      ads_dout_s1_reset_n => ads_dout_s1_reset_n,
      d1_ads_dout_s1_end_xfer => d1_ads_dout_s1_end_xfer,
      pipeline_bridge_m1_granted_ads_dout_s1 => pipeline_bridge_m1_granted_ads_dout_s1,
      pipeline_bridge_m1_qualified_request_ads_dout_s1 => pipeline_bridge_m1_qualified_request_ads_dout_s1,
      pipeline_bridge_m1_read_data_valid_ads_dout_s1 => pipeline_bridge_m1_read_data_valid_ads_dout_s1,
      pipeline_bridge_m1_requests_ads_dout_s1 => pipeline_bridge_m1_requests_ads_dout_s1,
      ads_dout_s1_readdata => ads_dout_s1_readdata,
      clk => clk,
      pipeline_bridge_m1_address_to_slave => pipeline_bridge_m1_address_to_slave,
      pipeline_bridge_m1_burstcount => pipeline_bridge_m1_burstcount,
      pipeline_bridge_m1_chipselect => pipeline_bridge_m1_chipselect,
      pipeline_bridge_m1_latency_counter => pipeline_bridge_m1_latency_counter,
      pipeline_bridge_m1_read => pipeline_bridge_m1_read,
      pipeline_bridge_m1_write => pipeline_bridge_m1_write,
      reset_n => clk_reset_n
    );


  --the_ads_dout, which is an e_ptf_instance
  the_ads_dout : ads_dout
    port map(
      readdata => ads_dout_s1_readdata,
      address => ads_dout_s1_address,
      clk => clk,
      in_port => in_port_to_the_ads_dout,
      reset_n => ads_dout_s1_reset_n
    );


  --the_ads_ncs_s1, which is an e_instance
  the_ads_ncs_s1 : ads_ncs_s1_arbitrator
    port map(
      ads_ncs_s1_address => ads_ncs_s1_address,
      ads_ncs_s1_chipselect => ads_ncs_s1_chipselect,
      ads_ncs_s1_readdata_from_sa => ads_ncs_s1_readdata_from_sa,
      ads_ncs_s1_reset_n => ads_ncs_s1_reset_n,
      ads_ncs_s1_write_n => ads_ncs_s1_write_n,
      ads_ncs_s1_writedata => ads_ncs_s1_writedata,
      d1_ads_ncs_s1_end_xfer => d1_ads_ncs_s1_end_xfer,
      pipeline_bridge_m1_granted_ads_ncs_s1 => pipeline_bridge_m1_granted_ads_ncs_s1,
      pipeline_bridge_m1_qualified_request_ads_ncs_s1 => pipeline_bridge_m1_qualified_request_ads_ncs_s1,
      pipeline_bridge_m1_read_data_valid_ads_ncs_s1 => pipeline_bridge_m1_read_data_valid_ads_ncs_s1,
      pipeline_bridge_m1_requests_ads_ncs_s1 => pipeline_bridge_m1_requests_ads_ncs_s1,
      ads_ncs_s1_readdata => ads_ncs_s1_readdata,
      clk => clk,
      pipeline_bridge_m1_address_to_slave => pipeline_bridge_m1_address_to_slave,
      pipeline_bridge_m1_burstcount => pipeline_bridge_m1_burstcount,
      pipeline_bridge_m1_chipselect => pipeline_bridge_m1_chipselect,
      pipeline_bridge_m1_latency_counter => pipeline_bridge_m1_latency_counter,
      pipeline_bridge_m1_read => pipeline_bridge_m1_read,
      pipeline_bridge_m1_write => pipeline_bridge_m1_write,
      pipeline_bridge_m1_writedata => pipeline_bridge_m1_writedata,
      reset_n => clk_reset_n
    );


  --the_ads_ncs, which is an e_ptf_instance
  the_ads_ncs : ads_ncs
    port map(
      out_port => internal_out_port_from_the_ads_ncs,
      readdata => ads_ncs_s1_readdata,
      address => ads_ncs_s1_address,
      chipselect => ads_ncs_s1_chipselect,
      clk => clk,
      reset_n => ads_ncs_s1_reset_n,
      write_n => ads_ncs_s1_write_n,
      writedata => ads_ncs_s1_writedata
    );


  --the_ads_nirq_s1, which is an e_instance
  the_ads_nirq_s1 : ads_nirq_s1_arbitrator
    port map(
      ads_nirq_s1_address => ads_nirq_s1_address,
      ads_nirq_s1_chipselect => ads_nirq_s1_chipselect,
      ads_nirq_s1_irq_from_sa => ads_nirq_s1_irq_from_sa,
      ads_nirq_s1_readdata_from_sa => ads_nirq_s1_readdata_from_sa,
      ads_nirq_s1_reset_n => ads_nirq_s1_reset_n,
      ads_nirq_s1_write_n => ads_nirq_s1_write_n,
      ads_nirq_s1_writedata => ads_nirq_s1_writedata,
      d1_ads_nirq_s1_end_xfer => d1_ads_nirq_s1_end_xfer,
      pipeline_bridge_m1_granted_ads_nirq_s1 => pipeline_bridge_m1_granted_ads_nirq_s1,
      pipeline_bridge_m1_qualified_request_ads_nirq_s1 => pipeline_bridge_m1_qualified_request_ads_nirq_s1,
      pipeline_bridge_m1_read_data_valid_ads_nirq_s1 => pipeline_bridge_m1_read_data_valid_ads_nirq_s1,
      pipeline_bridge_m1_requests_ads_nirq_s1 => pipeline_bridge_m1_requests_ads_nirq_s1,
      ads_nirq_s1_irq => ads_nirq_s1_irq,
      ads_nirq_s1_readdata => ads_nirq_s1_readdata,
      clk => clk,
      pipeline_bridge_m1_address_to_slave => pipeline_bridge_m1_address_to_slave,
      pipeline_bridge_m1_burstcount => pipeline_bridge_m1_burstcount,
      pipeline_bridge_m1_chipselect => pipeline_bridge_m1_chipselect,
      pipeline_bridge_m1_latency_counter => pipeline_bridge_m1_latency_counter,
      pipeline_bridge_m1_read => pipeline_bridge_m1_read,
      pipeline_bridge_m1_write => pipeline_bridge_m1_write,
      pipeline_bridge_m1_writedata => pipeline_bridge_m1_writedata,
      reset_n => clk_reset_n
    );


  --the_ads_nirq, which is an e_ptf_instance
  the_ads_nirq : ads_nirq
    port map(
      irq => ads_nirq_s1_irq,
      readdata => ads_nirq_s1_readdata,
      address => ads_nirq_s1_address,
      chipselect => ads_nirq_s1_chipselect,
      clk => clk,
      in_port => in_port_to_the_ads_nirq,
      reset_n => ads_nirq_s1_reset_n,
      write_n => ads_nirq_s1_write_n,
      writedata => ads_nirq_s1_writedata
    );


  --the_cpu_jtag_debug_module, which is an e_instance
  the_cpu_jtag_debug_module : cpu_jtag_debug_module_arbitrator
    port map(
      cpu_data_master_granted_cpu_jtag_debug_module => cpu_data_master_granted_cpu_jtag_debug_module,
      cpu_data_master_qualified_request_cpu_jtag_debug_module => cpu_data_master_qualified_request_cpu_jtag_debug_module,
      cpu_data_master_read_data_valid_cpu_jtag_debug_module => cpu_data_master_read_data_valid_cpu_jtag_debug_module,
      cpu_data_master_requests_cpu_jtag_debug_module => cpu_data_master_requests_cpu_jtag_debug_module,
      cpu_instruction_master_granted_cpu_jtag_debug_module => cpu_instruction_master_granted_cpu_jtag_debug_module,
      cpu_instruction_master_qualified_request_cpu_jtag_debug_module => cpu_instruction_master_qualified_request_cpu_jtag_debug_module,
      cpu_instruction_master_read_data_valid_cpu_jtag_debug_module => cpu_instruction_master_read_data_valid_cpu_jtag_debug_module,
      cpu_instruction_master_requests_cpu_jtag_debug_module => cpu_instruction_master_requests_cpu_jtag_debug_module,
      cpu_jtag_debug_module_address => cpu_jtag_debug_module_address,
      cpu_jtag_debug_module_begintransfer => cpu_jtag_debug_module_begintransfer,
      cpu_jtag_debug_module_byteenable => cpu_jtag_debug_module_byteenable,
      cpu_jtag_debug_module_chipselect => cpu_jtag_debug_module_chipselect,
      cpu_jtag_debug_module_debugaccess => cpu_jtag_debug_module_debugaccess,
      cpu_jtag_debug_module_readdata_from_sa => cpu_jtag_debug_module_readdata_from_sa,
      cpu_jtag_debug_module_reset_n => cpu_jtag_debug_module_reset_n,
      cpu_jtag_debug_module_resetrequest_from_sa => cpu_jtag_debug_module_resetrequest_from_sa,
      cpu_jtag_debug_module_write => cpu_jtag_debug_module_write,
      cpu_jtag_debug_module_writedata => cpu_jtag_debug_module_writedata,
      d1_cpu_jtag_debug_module_end_xfer => d1_cpu_jtag_debug_module_end_xfer,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_byteenable => cpu_data_master_byteenable,
      cpu_data_master_debugaccess => cpu_data_master_debugaccess,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      cpu_instruction_master_address_to_slave => cpu_instruction_master_address_to_slave,
      cpu_instruction_master_latency_counter => cpu_instruction_master_latency_counter,
      cpu_instruction_master_read => cpu_instruction_master_read,
      cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register => cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register,
      cpu_instruction_master_read_data_valid_sdram_s1_shift_register => cpu_instruction_master_read_data_valid_sdram_s1_shift_register,
      cpu_jtag_debug_module_readdata => cpu_jtag_debug_module_readdata,
      cpu_jtag_debug_module_resetrequest => cpu_jtag_debug_module_resetrequest,
      reset_n => clk_reset_n
    );


  --the_cpu_data_master, which is an e_instance
  the_cpu_data_master : cpu_data_master_arbitrator
    port map(
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_dbs_address => cpu_data_master_dbs_address,
      cpu_data_master_dbs_write_16 => cpu_data_master_dbs_write_16,
      cpu_data_master_irq => cpu_data_master_irq,
      cpu_data_master_no_byte_enables_and_last_term => cpu_data_master_no_byte_enables_and_last_term,
      cpu_data_master_readdata => cpu_data_master_readdata,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      ads_nirq_s1_irq_from_sa => ads_nirq_s1_irq_from_sa,
      clk => clk,
      cpu_data_master_address => cpu_data_master_address,
      cpu_data_master_byteenable_sdram_s1 => cpu_data_master_byteenable_sdram_s1,
      cpu_data_master_granted_cpu_jtag_debug_module => cpu_data_master_granted_cpu_jtag_debug_module,
      cpu_data_master_granted_epcs_flash_controller_epcs_control_port => cpu_data_master_granted_epcs_flash_controller_epcs_control_port,
      cpu_data_master_granted_jtag_uart_avalon_jtag_slave => cpu_data_master_granted_jtag_uart_avalon_jtag_slave,
      cpu_data_master_granted_pipeline_bridge_s1 => cpu_data_master_granted_pipeline_bridge_s1,
      cpu_data_master_granted_sdram_s1 => cpu_data_master_granted_sdram_s1,
      cpu_data_master_qualified_request_cpu_jtag_debug_module => cpu_data_master_qualified_request_cpu_jtag_debug_module,
      cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port => cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port,
      cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave => cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave,
      cpu_data_master_qualified_request_pipeline_bridge_s1 => cpu_data_master_qualified_request_pipeline_bridge_s1,
      cpu_data_master_qualified_request_sdram_s1 => cpu_data_master_qualified_request_sdram_s1,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_read_data_valid_cpu_jtag_debug_module => cpu_data_master_read_data_valid_cpu_jtag_debug_module,
      cpu_data_master_read_data_valid_epcs_flash_controller_epcs_control_port => cpu_data_master_read_data_valid_epcs_flash_controller_epcs_control_port,
      cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave => cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave,
      cpu_data_master_read_data_valid_pipeline_bridge_s1 => cpu_data_master_read_data_valid_pipeline_bridge_s1,
      cpu_data_master_read_data_valid_pipeline_bridge_s1_shift_register => cpu_data_master_read_data_valid_pipeline_bridge_s1_shift_register,
      cpu_data_master_read_data_valid_sdram_s1 => cpu_data_master_read_data_valid_sdram_s1,
      cpu_data_master_read_data_valid_sdram_s1_shift_register => cpu_data_master_read_data_valid_sdram_s1_shift_register,
      cpu_data_master_requests_cpu_jtag_debug_module => cpu_data_master_requests_cpu_jtag_debug_module,
      cpu_data_master_requests_epcs_flash_controller_epcs_control_port => cpu_data_master_requests_epcs_flash_controller_epcs_control_port,
      cpu_data_master_requests_jtag_uart_avalon_jtag_slave => cpu_data_master_requests_jtag_uart_avalon_jtag_slave,
      cpu_data_master_requests_pipeline_bridge_s1 => cpu_data_master_requests_pipeline_bridge_s1,
      cpu_data_master_requests_sdram_s1 => cpu_data_master_requests_sdram_s1,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      cpu_jtag_debug_module_readdata_from_sa => cpu_jtag_debug_module_readdata_from_sa,
      d1_cpu_jtag_debug_module_end_xfer => d1_cpu_jtag_debug_module_end_xfer,
      d1_epcs_flash_controller_epcs_control_port_end_xfer => d1_epcs_flash_controller_epcs_control_port_end_xfer,
      d1_jtag_uart_avalon_jtag_slave_end_xfer => d1_jtag_uart_avalon_jtag_slave_end_xfer,
      d1_pipeline_bridge_s1_end_xfer => d1_pipeline_bridge_s1_end_xfer,
      d1_sdram_s1_end_xfer => d1_sdram_s1_end_xfer,
      epcs_flash_controller_epcs_control_port_irq_from_sa => epcs_flash_controller_epcs_control_port_irq_from_sa,
      epcs_flash_controller_epcs_control_port_readdata_from_sa => epcs_flash_controller_epcs_control_port_readdata_from_sa,
      jtag_uart_avalon_jtag_slave_irq_from_sa => jtag_uart_avalon_jtag_slave_irq_from_sa,
      jtag_uart_avalon_jtag_slave_readdata_from_sa => jtag_uart_avalon_jtag_slave_readdata_from_sa,
      jtag_uart_avalon_jtag_slave_waitrequest_from_sa => jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
      pipeline_bridge_s1_readdata_from_sa => pipeline_bridge_s1_readdata_from_sa,
      pipeline_bridge_s1_waitrequest_from_sa => pipeline_bridge_s1_waitrequest_from_sa,
      reset_n => clk_reset_n,
      sdram_s1_readdata_from_sa => sdram_s1_readdata_from_sa,
      sdram_s1_waitrequest_from_sa => sdram_s1_waitrequest_from_sa
    );


  --the_cpu_instruction_master, which is an e_instance
  the_cpu_instruction_master : cpu_instruction_master_arbitrator
    port map(
      cpu_instruction_master_address_to_slave => cpu_instruction_master_address_to_slave,
      cpu_instruction_master_dbs_address => cpu_instruction_master_dbs_address,
      cpu_instruction_master_latency_counter => cpu_instruction_master_latency_counter,
      cpu_instruction_master_readdata => cpu_instruction_master_readdata,
      cpu_instruction_master_readdatavalid => cpu_instruction_master_readdatavalid,
      cpu_instruction_master_waitrequest => cpu_instruction_master_waitrequest,
      clk => clk,
      cpu_instruction_master_address => cpu_instruction_master_address,
      cpu_instruction_master_granted_cpu_jtag_debug_module => cpu_instruction_master_granted_cpu_jtag_debug_module,
      cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port => cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port,
      cpu_instruction_master_granted_pipeline_bridge_s1 => cpu_instruction_master_granted_pipeline_bridge_s1,
      cpu_instruction_master_granted_sdram_s1 => cpu_instruction_master_granted_sdram_s1,
      cpu_instruction_master_qualified_request_cpu_jtag_debug_module => cpu_instruction_master_qualified_request_cpu_jtag_debug_module,
      cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port => cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port,
      cpu_instruction_master_qualified_request_pipeline_bridge_s1 => cpu_instruction_master_qualified_request_pipeline_bridge_s1,
      cpu_instruction_master_qualified_request_sdram_s1 => cpu_instruction_master_qualified_request_sdram_s1,
      cpu_instruction_master_read => cpu_instruction_master_read,
      cpu_instruction_master_read_data_valid_cpu_jtag_debug_module => cpu_instruction_master_read_data_valid_cpu_jtag_debug_module,
      cpu_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port => cpu_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port,
      cpu_instruction_master_read_data_valid_pipeline_bridge_s1 => cpu_instruction_master_read_data_valid_pipeline_bridge_s1,
      cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register => cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register,
      cpu_instruction_master_read_data_valid_sdram_s1 => cpu_instruction_master_read_data_valid_sdram_s1,
      cpu_instruction_master_read_data_valid_sdram_s1_shift_register => cpu_instruction_master_read_data_valid_sdram_s1_shift_register,
      cpu_instruction_master_requests_cpu_jtag_debug_module => cpu_instruction_master_requests_cpu_jtag_debug_module,
      cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port => cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port,
      cpu_instruction_master_requests_pipeline_bridge_s1 => cpu_instruction_master_requests_pipeline_bridge_s1,
      cpu_instruction_master_requests_sdram_s1 => cpu_instruction_master_requests_sdram_s1,
      cpu_jtag_debug_module_readdata_from_sa => cpu_jtag_debug_module_readdata_from_sa,
      d1_cpu_jtag_debug_module_end_xfer => d1_cpu_jtag_debug_module_end_xfer,
      d1_epcs_flash_controller_epcs_control_port_end_xfer => d1_epcs_flash_controller_epcs_control_port_end_xfer,
      d1_pipeline_bridge_s1_end_xfer => d1_pipeline_bridge_s1_end_xfer,
      d1_sdram_s1_end_xfer => d1_sdram_s1_end_xfer,
      epcs_flash_controller_epcs_control_port_readdata_from_sa => epcs_flash_controller_epcs_control_port_readdata_from_sa,
      pipeline_bridge_s1_readdata_from_sa => pipeline_bridge_s1_readdata_from_sa,
      pipeline_bridge_s1_waitrequest_from_sa => pipeline_bridge_s1_waitrequest_from_sa,
      reset_n => clk_reset_n,
      sdram_s1_readdata_from_sa => sdram_s1_readdata_from_sa,
      sdram_s1_waitrequest_from_sa => sdram_s1_waitrequest_from_sa
    );


  --the_cpu, which is an e_ptf_instance
  the_cpu : cpu
    port map(
      d_address => cpu_data_master_address,
      d_byteenable => cpu_data_master_byteenable,
      d_read => cpu_data_master_read,
      d_write => cpu_data_master_write,
      d_writedata => cpu_data_master_writedata,
      i_address => cpu_instruction_master_address,
      i_read => cpu_instruction_master_read,
      jtag_debug_module_debugaccess_to_roms => cpu_data_master_debugaccess,
      jtag_debug_module_readdata => cpu_jtag_debug_module_readdata,
      jtag_debug_module_resetrequest => cpu_jtag_debug_module_resetrequest,
      clk => clk,
      d_irq => cpu_data_master_irq,
      d_readdata => cpu_data_master_readdata,
      d_waitrequest => cpu_data_master_waitrequest,
      i_readdata => cpu_instruction_master_readdata,
      i_readdatavalid => cpu_instruction_master_readdatavalid,
      i_waitrequest => cpu_instruction_master_waitrequest,
      jtag_debug_module_address => cpu_jtag_debug_module_address,
      jtag_debug_module_begintransfer => cpu_jtag_debug_module_begintransfer,
      jtag_debug_module_byteenable => cpu_jtag_debug_module_byteenable,
      jtag_debug_module_debugaccess => cpu_jtag_debug_module_debugaccess,
      jtag_debug_module_select => cpu_jtag_debug_module_chipselect,
      jtag_debug_module_write => cpu_jtag_debug_module_write,
      jtag_debug_module_writedata => cpu_jtag_debug_module_writedata,
      reset_n => cpu_jtag_debug_module_reset_n
    );


  --the_epcs_flash_controller_epcs_control_port, which is an e_instance
  the_epcs_flash_controller_epcs_control_port : epcs_flash_controller_epcs_control_port_arbitrator
    port map(
      cpu_data_master_granted_epcs_flash_controller_epcs_control_port => cpu_data_master_granted_epcs_flash_controller_epcs_control_port,
      cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port => cpu_data_master_qualified_request_epcs_flash_controller_epcs_control_port,
      cpu_data_master_read_data_valid_epcs_flash_controller_epcs_control_port => cpu_data_master_read_data_valid_epcs_flash_controller_epcs_control_port,
      cpu_data_master_requests_epcs_flash_controller_epcs_control_port => cpu_data_master_requests_epcs_flash_controller_epcs_control_port,
      cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port => cpu_instruction_master_granted_epcs_flash_controller_epcs_control_port,
      cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port => cpu_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port,
      cpu_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port => cpu_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port,
      cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port => cpu_instruction_master_requests_epcs_flash_controller_epcs_control_port,
      d1_epcs_flash_controller_epcs_control_port_end_xfer => d1_epcs_flash_controller_epcs_control_port_end_xfer,
      epcs_flash_controller_epcs_control_port_address => epcs_flash_controller_epcs_control_port_address,
      epcs_flash_controller_epcs_control_port_chipselect => epcs_flash_controller_epcs_control_port_chipselect,
      epcs_flash_controller_epcs_control_port_dataavailable_from_sa => epcs_flash_controller_epcs_control_port_dataavailable_from_sa,
      epcs_flash_controller_epcs_control_port_endofpacket_from_sa => epcs_flash_controller_epcs_control_port_endofpacket_from_sa,
      epcs_flash_controller_epcs_control_port_irq_from_sa => epcs_flash_controller_epcs_control_port_irq_from_sa,
      epcs_flash_controller_epcs_control_port_read_n => epcs_flash_controller_epcs_control_port_read_n,
      epcs_flash_controller_epcs_control_port_readdata_from_sa => epcs_flash_controller_epcs_control_port_readdata_from_sa,
      epcs_flash_controller_epcs_control_port_readyfordata_from_sa => epcs_flash_controller_epcs_control_port_readyfordata_from_sa,
      epcs_flash_controller_epcs_control_port_reset_n => epcs_flash_controller_epcs_control_port_reset_n,
      epcs_flash_controller_epcs_control_port_write_n => epcs_flash_controller_epcs_control_port_write_n,
      epcs_flash_controller_epcs_control_port_writedata => epcs_flash_controller_epcs_control_port_writedata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      cpu_instruction_master_address_to_slave => cpu_instruction_master_address_to_slave,
      cpu_instruction_master_latency_counter => cpu_instruction_master_latency_counter,
      cpu_instruction_master_read => cpu_instruction_master_read,
      cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register => cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register,
      cpu_instruction_master_read_data_valid_sdram_s1_shift_register => cpu_instruction_master_read_data_valid_sdram_s1_shift_register,
      epcs_flash_controller_epcs_control_port_dataavailable => epcs_flash_controller_epcs_control_port_dataavailable,
      epcs_flash_controller_epcs_control_port_endofpacket => epcs_flash_controller_epcs_control_port_endofpacket,
      epcs_flash_controller_epcs_control_port_irq => epcs_flash_controller_epcs_control_port_irq,
      epcs_flash_controller_epcs_control_port_readdata => epcs_flash_controller_epcs_control_port_readdata,
      epcs_flash_controller_epcs_control_port_readyfordata => epcs_flash_controller_epcs_control_port_readyfordata,
      reset_n => clk_reset_n
    );


  --the_epcs_flash_controller, which is an e_ptf_instance
  the_epcs_flash_controller : epcs_flash_controller
    port map(
      dataavailable => epcs_flash_controller_epcs_control_port_dataavailable,
      dclk => internal_dclk_from_the_epcs_flash_controller,
      endofpacket => epcs_flash_controller_epcs_control_port_endofpacket,
      irq => epcs_flash_controller_epcs_control_port_irq,
      readdata => epcs_flash_controller_epcs_control_port_readdata,
      readyfordata => epcs_flash_controller_epcs_control_port_readyfordata,
      sce => internal_sce_from_the_epcs_flash_controller,
      sdo => internal_sdo_from_the_epcs_flash_controller,
      address => epcs_flash_controller_epcs_control_port_address,
      chipselect => epcs_flash_controller_epcs_control_port_chipselect,
      clk => clk,
      data0 => data0_to_the_epcs_flash_controller,
      read_n => epcs_flash_controller_epcs_control_port_read_n,
      reset_n => epcs_flash_controller_epcs_control_port_reset_n,
      write_n => epcs_flash_controller_epcs_control_port_write_n,
      writedata => epcs_flash_controller_epcs_control_port_writedata
    );


  --the_ili_db_s1, which is an e_instance
  the_ili_db_s1 : ili_db_s1_arbitrator
    port map(
      d1_ili_db_s1_end_xfer => d1_ili_db_s1_end_xfer,
      ili_db_s1_address => ili_db_s1_address,
      ili_db_s1_chipselect => ili_db_s1_chipselect,
      ili_db_s1_readdata_from_sa => ili_db_s1_readdata_from_sa,
      ili_db_s1_reset_n => ili_db_s1_reset_n,
      ili_db_s1_write_n => ili_db_s1_write_n,
      ili_db_s1_writedata => ili_db_s1_writedata,
      pipeline_bridge_m1_granted_ili_db_s1 => pipeline_bridge_m1_granted_ili_db_s1,
      pipeline_bridge_m1_qualified_request_ili_db_s1 => pipeline_bridge_m1_qualified_request_ili_db_s1,
      pipeline_bridge_m1_read_data_valid_ili_db_s1 => pipeline_bridge_m1_read_data_valid_ili_db_s1,
      pipeline_bridge_m1_requests_ili_db_s1 => pipeline_bridge_m1_requests_ili_db_s1,
      clk => clk,
      ili_db_s1_readdata => ili_db_s1_readdata,
      pipeline_bridge_m1_address_to_slave => pipeline_bridge_m1_address_to_slave,
      pipeline_bridge_m1_burstcount => pipeline_bridge_m1_burstcount,
      pipeline_bridge_m1_chipselect => pipeline_bridge_m1_chipselect,
      pipeline_bridge_m1_latency_counter => pipeline_bridge_m1_latency_counter,
      pipeline_bridge_m1_read => pipeline_bridge_m1_read,
      pipeline_bridge_m1_write => pipeline_bridge_m1_write,
      pipeline_bridge_m1_writedata => pipeline_bridge_m1_writedata,
      reset_n => clk_reset_n
    );


  --the_ili_db, which is an e_ptf_instance
  the_ili_db : ili_db
    port map(
      bidir_port => bidir_port_to_and_from_the_ili_db,
      readdata => ili_db_s1_readdata,
      address => ili_db_s1_address,
      chipselect => ili_db_s1_chipselect,
      clk => clk,
      reset_n => ili_db_s1_reset_n,
      write_n => ili_db_s1_write_n,
      writedata => ili_db_s1_writedata
    );


  --the_ili_ncs_s1, which is an e_instance
  the_ili_ncs_s1 : ili_ncs_s1_arbitrator
    port map(
      d1_ili_ncs_s1_end_xfer => d1_ili_ncs_s1_end_xfer,
      ili_ncs_s1_address => ili_ncs_s1_address,
      ili_ncs_s1_chipselect => ili_ncs_s1_chipselect,
      ili_ncs_s1_readdata_from_sa => ili_ncs_s1_readdata_from_sa,
      ili_ncs_s1_reset_n => ili_ncs_s1_reset_n,
      ili_ncs_s1_write_n => ili_ncs_s1_write_n,
      ili_ncs_s1_writedata => ili_ncs_s1_writedata,
      pipeline_bridge_m1_granted_ili_ncs_s1 => pipeline_bridge_m1_granted_ili_ncs_s1,
      pipeline_bridge_m1_qualified_request_ili_ncs_s1 => pipeline_bridge_m1_qualified_request_ili_ncs_s1,
      pipeline_bridge_m1_read_data_valid_ili_ncs_s1 => pipeline_bridge_m1_read_data_valid_ili_ncs_s1,
      pipeline_bridge_m1_requests_ili_ncs_s1 => pipeline_bridge_m1_requests_ili_ncs_s1,
      clk => clk,
      ili_ncs_s1_readdata => ili_ncs_s1_readdata,
      pipeline_bridge_m1_address_to_slave => pipeline_bridge_m1_address_to_slave,
      pipeline_bridge_m1_burstcount => pipeline_bridge_m1_burstcount,
      pipeline_bridge_m1_chipselect => pipeline_bridge_m1_chipselect,
      pipeline_bridge_m1_latency_counter => pipeline_bridge_m1_latency_counter,
      pipeline_bridge_m1_read => pipeline_bridge_m1_read,
      pipeline_bridge_m1_write => pipeline_bridge_m1_write,
      pipeline_bridge_m1_writedata => pipeline_bridge_m1_writedata,
      reset_n => clk_reset_n
    );


  --the_ili_ncs, which is an e_ptf_instance
  the_ili_ncs : ili_ncs
    port map(
      out_port => internal_out_port_from_the_ili_ncs,
      readdata => ili_ncs_s1_readdata,
      address => ili_ncs_s1_address,
      chipselect => ili_ncs_s1_chipselect,
      clk => clk,
      reset_n => ili_ncs_s1_reset_n,
      write_n => ili_ncs_s1_write_n,
      writedata => ili_ncs_s1_writedata
    );


  --the_ili_nrd_s1, which is an e_instance
  the_ili_nrd_s1 : ili_nrd_s1_arbitrator
    port map(
      d1_ili_nrd_s1_end_xfer => d1_ili_nrd_s1_end_xfer,
      ili_nrd_s1_address => ili_nrd_s1_address,
      ili_nrd_s1_chipselect => ili_nrd_s1_chipselect,
      ili_nrd_s1_readdata_from_sa => ili_nrd_s1_readdata_from_sa,
      ili_nrd_s1_reset_n => ili_nrd_s1_reset_n,
      ili_nrd_s1_write_n => ili_nrd_s1_write_n,
      ili_nrd_s1_writedata => ili_nrd_s1_writedata,
      pipeline_bridge_m1_granted_ili_nrd_s1 => pipeline_bridge_m1_granted_ili_nrd_s1,
      pipeline_bridge_m1_qualified_request_ili_nrd_s1 => pipeline_bridge_m1_qualified_request_ili_nrd_s1,
      pipeline_bridge_m1_read_data_valid_ili_nrd_s1 => pipeline_bridge_m1_read_data_valid_ili_nrd_s1,
      pipeline_bridge_m1_requests_ili_nrd_s1 => pipeline_bridge_m1_requests_ili_nrd_s1,
      clk => clk,
      ili_nrd_s1_readdata => ili_nrd_s1_readdata,
      pipeline_bridge_m1_address_to_slave => pipeline_bridge_m1_address_to_slave,
      pipeline_bridge_m1_burstcount => pipeline_bridge_m1_burstcount,
      pipeline_bridge_m1_chipselect => pipeline_bridge_m1_chipselect,
      pipeline_bridge_m1_latency_counter => pipeline_bridge_m1_latency_counter,
      pipeline_bridge_m1_read => pipeline_bridge_m1_read,
      pipeline_bridge_m1_write => pipeline_bridge_m1_write,
      pipeline_bridge_m1_writedata => pipeline_bridge_m1_writedata,
      reset_n => clk_reset_n
    );


  --the_ili_nrd, which is an e_ptf_instance
  the_ili_nrd : ili_nrd
    port map(
      out_port => internal_out_port_from_the_ili_nrd,
      readdata => ili_nrd_s1_readdata,
      address => ili_nrd_s1_address,
      chipselect => ili_nrd_s1_chipselect,
      clk => clk,
      reset_n => ili_nrd_s1_reset_n,
      write_n => ili_nrd_s1_write_n,
      writedata => ili_nrd_s1_writedata
    );


  --the_ili_nrst_s1, which is an e_instance
  the_ili_nrst_s1 : ili_nrst_s1_arbitrator
    port map(
      d1_ili_nrst_s1_end_xfer => d1_ili_nrst_s1_end_xfer,
      ili_nrst_s1_address => ili_nrst_s1_address,
      ili_nrst_s1_chipselect => ili_nrst_s1_chipselect,
      ili_nrst_s1_readdata_from_sa => ili_nrst_s1_readdata_from_sa,
      ili_nrst_s1_reset_n => ili_nrst_s1_reset_n,
      ili_nrst_s1_write_n => ili_nrst_s1_write_n,
      ili_nrst_s1_writedata => ili_nrst_s1_writedata,
      pipeline_bridge_m1_granted_ili_nrst_s1 => pipeline_bridge_m1_granted_ili_nrst_s1,
      pipeline_bridge_m1_qualified_request_ili_nrst_s1 => pipeline_bridge_m1_qualified_request_ili_nrst_s1,
      pipeline_bridge_m1_read_data_valid_ili_nrst_s1 => pipeline_bridge_m1_read_data_valid_ili_nrst_s1,
      pipeline_bridge_m1_requests_ili_nrst_s1 => pipeline_bridge_m1_requests_ili_nrst_s1,
      clk => clk,
      ili_nrst_s1_readdata => ili_nrst_s1_readdata,
      pipeline_bridge_m1_address_to_slave => pipeline_bridge_m1_address_to_slave,
      pipeline_bridge_m1_burstcount => pipeline_bridge_m1_burstcount,
      pipeline_bridge_m1_chipselect => pipeline_bridge_m1_chipselect,
      pipeline_bridge_m1_latency_counter => pipeline_bridge_m1_latency_counter,
      pipeline_bridge_m1_read => pipeline_bridge_m1_read,
      pipeline_bridge_m1_write => pipeline_bridge_m1_write,
      pipeline_bridge_m1_writedata => pipeline_bridge_m1_writedata,
      reset_n => clk_reset_n
    );


  --the_ili_nrst, which is an e_ptf_instance
  the_ili_nrst : ili_nrst
    port map(
      out_port => internal_out_port_from_the_ili_nrst,
      readdata => ili_nrst_s1_readdata,
      address => ili_nrst_s1_address,
      chipselect => ili_nrst_s1_chipselect,
      clk => clk,
      reset_n => ili_nrst_s1_reset_n,
      write_n => ili_nrst_s1_write_n,
      writedata => ili_nrst_s1_writedata
    );


  --the_ili_nwr_s1, which is an e_instance
  the_ili_nwr_s1 : ili_nwr_s1_arbitrator
    port map(
      d1_ili_nwr_s1_end_xfer => d1_ili_nwr_s1_end_xfer,
      ili_nwr_s1_address => ili_nwr_s1_address,
      ili_nwr_s1_chipselect => ili_nwr_s1_chipselect,
      ili_nwr_s1_readdata_from_sa => ili_nwr_s1_readdata_from_sa,
      ili_nwr_s1_reset_n => ili_nwr_s1_reset_n,
      ili_nwr_s1_write_n => ili_nwr_s1_write_n,
      ili_nwr_s1_writedata => ili_nwr_s1_writedata,
      pipeline_bridge_m1_granted_ili_nwr_s1 => pipeline_bridge_m1_granted_ili_nwr_s1,
      pipeline_bridge_m1_qualified_request_ili_nwr_s1 => pipeline_bridge_m1_qualified_request_ili_nwr_s1,
      pipeline_bridge_m1_read_data_valid_ili_nwr_s1 => pipeline_bridge_m1_read_data_valid_ili_nwr_s1,
      pipeline_bridge_m1_requests_ili_nwr_s1 => pipeline_bridge_m1_requests_ili_nwr_s1,
      clk => clk,
      ili_nwr_s1_readdata => ili_nwr_s1_readdata,
      pipeline_bridge_m1_address_to_slave => pipeline_bridge_m1_address_to_slave,
      pipeline_bridge_m1_burstcount => pipeline_bridge_m1_burstcount,
      pipeline_bridge_m1_chipselect => pipeline_bridge_m1_chipselect,
      pipeline_bridge_m1_latency_counter => pipeline_bridge_m1_latency_counter,
      pipeline_bridge_m1_read => pipeline_bridge_m1_read,
      pipeline_bridge_m1_write => pipeline_bridge_m1_write,
      pipeline_bridge_m1_writedata => pipeline_bridge_m1_writedata,
      reset_n => clk_reset_n
    );


  --the_ili_nwr, which is an e_ptf_instance
  the_ili_nwr : ili_nwr
    port map(
      out_port => internal_out_port_from_the_ili_nwr,
      readdata => ili_nwr_s1_readdata,
      address => ili_nwr_s1_address,
      chipselect => ili_nwr_s1_chipselect,
      clk => clk,
      reset_n => ili_nwr_s1_reset_n,
      write_n => ili_nwr_s1_write_n,
      writedata => ili_nwr_s1_writedata
    );


  --the_ili_rs_s1, which is an e_instance
  the_ili_rs_s1 : ili_rs_s1_arbitrator
    port map(
      d1_ili_rs_s1_end_xfer => d1_ili_rs_s1_end_xfer,
      ili_rs_s1_address => ili_rs_s1_address,
      ili_rs_s1_chipselect => ili_rs_s1_chipselect,
      ili_rs_s1_readdata_from_sa => ili_rs_s1_readdata_from_sa,
      ili_rs_s1_reset_n => ili_rs_s1_reset_n,
      ili_rs_s1_write_n => ili_rs_s1_write_n,
      ili_rs_s1_writedata => ili_rs_s1_writedata,
      pipeline_bridge_m1_granted_ili_rs_s1 => pipeline_bridge_m1_granted_ili_rs_s1,
      pipeline_bridge_m1_qualified_request_ili_rs_s1 => pipeline_bridge_m1_qualified_request_ili_rs_s1,
      pipeline_bridge_m1_read_data_valid_ili_rs_s1 => pipeline_bridge_m1_read_data_valid_ili_rs_s1,
      pipeline_bridge_m1_requests_ili_rs_s1 => pipeline_bridge_m1_requests_ili_rs_s1,
      clk => clk,
      ili_rs_s1_readdata => ili_rs_s1_readdata,
      pipeline_bridge_m1_address_to_slave => pipeline_bridge_m1_address_to_slave,
      pipeline_bridge_m1_burstcount => pipeline_bridge_m1_burstcount,
      pipeline_bridge_m1_chipselect => pipeline_bridge_m1_chipselect,
      pipeline_bridge_m1_latency_counter => pipeline_bridge_m1_latency_counter,
      pipeline_bridge_m1_read => pipeline_bridge_m1_read,
      pipeline_bridge_m1_write => pipeline_bridge_m1_write,
      pipeline_bridge_m1_writedata => pipeline_bridge_m1_writedata,
      reset_n => clk_reset_n
    );


  --the_ili_rs, which is an e_ptf_instance
  the_ili_rs : ili_rs
    port map(
      out_port => internal_out_port_from_the_ili_rs,
      readdata => ili_rs_s1_readdata,
      address => ili_rs_s1_address,
      chipselect => ili_rs_s1_chipselect,
      clk => clk,
      reset_n => ili_rs_s1_reset_n,
      write_n => ili_rs_s1_write_n,
      writedata => ili_rs_s1_writedata
    );


  --the_jtag_uart_avalon_jtag_slave, which is an e_instance
  the_jtag_uart_avalon_jtag_slave : jtag_uart_avalon_jtag_slave_arbitrator
    port map(
      cpu_data_master_granted_jtag_uart_avalon_jtag_slave => cpu_data_master_granted_jtag_uart_avalon_jtag_slave,
      cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave => cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave,
      cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave => cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave,
      cpu_data_master_requests_jtag_uart_avalon_jtag_slave => cpu_data_master_requests_jtag_uart_avalon_jtag_slave,
      d1_jtag_uart_avalon_jtag_slave_end_xfer => d1_jtag_uart_avalon_jtag_slave_end_xfer,
      jtag_uart_avalon_jtag_slave_address => jtag_uart_avalon_jtag_slave_address,
      jtag_uart_avalon_jtag_slave_chipselect => jtag_uart_avalon_jtag_slave_chipselect,
      jtag_uart_avalon_jtag_slave_dataavailable_from_sa => jtag_uart_avalon_jtag_slave_dataavailable_from_sa,
      jtag_uart_avalon_jtag_slave_irq_from_sa => jtag_uart_avalon_jtag_slave_irq_from_sa,
      jtag_uart_avalon_jtag_slave_read_n => jtag_uart_avalon_jtag_slave_read_n,
      jtag_uart_avalon_jtag_slave_readdata_from_sa => jtag_uart_avalon_jtag_slave_readdata_from_sa,
      jtag_uart_avalon_jtag_slave_readyfordata_from_sa => jtag_uart_avalon_jtag_slave_readyfordata_from_sa,
      jtag_uart_avalon_jtag_slave_reset_n => jtag_uart_avalon_jtag_slave_reset_n,
      jtag_uart_avalon_jtag_slave_waitrequest_from_sa => jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
      jtag_uart_avalon_jtag_slave_write_n => jtag_uart_avalon_jtag_slave_write_n,
      jtag_uart_avalon_jtag_slave_writedata => jtag_uart_avalon_jtag_slave_writedata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      jtag_uart_avalon_jtag_slave_dataavailable => jtag_uart_avalon_jtag_slave_dataavailable,
      jtag_uart_avalon_jtag_slave_irq => jtag_uart_avalon_jtag_slave_irq,
      jtag_uart_avalon_jtag_slave_readdata => jtag_uart_avalon_jtag_slave_readdata,
      jtag_uart_avalon_jtag_slave_readyfordata => jtag_uart_avalon_jtag_slave_readyfordata,
      jtag_uart_avalon_jtag_slave_waitrequest => jtag_uart_avalon_jtag_slave_waitrequest,
      reset_n => clk_reset_n
    );


  --the_jtag_uart, which is an e_ptf_instance
  the_jtag_uart : jtag_uart
    port map(
      av_irq => jtag_uart_avalon_jtag_slave_irq,
      av_readdata => jtag_uart_avalon_jtag_slave_readdata,
      av_waitrequest => jtag_uart_avalon_jtag_slave_waitrequest,
      dataavailable => jtag_uart_avalon_jtag_slave_dataavailable,
      readyfordata => jtag_uart_avalon_jtag_slave_readyfordata,
      av_address => jtag_uart_avalon_jtag_slave_address,
      av_chipselect => jtag_uart_avalon_jtag_slave_chipselect,
      av_read_n => jtag_uart_avalon_jtag_slave_read_n,
      av_write_n => jtag_uart_avalon_jtag_slave_write_n,
      av_writedata => jtag_uart_avalon_jtag_slave_writedata,
      clk => clk,
      rst_n => jtag_uart_avalon_jtag_slave_reset_n
    );


  --the_pipeline_bridge_s1, which is an e_instance
  the_pipeline_bridge_s1 : pipeline_bridge_s1_arbitrator
    port map(
      cpu_data_master_granted_pipeline_bridge_s1 => cpu_data_master_granted_pipeline_bridge_s1,
      cpu_data_master_qualified_request_pipeline_bridge_s1 => cpu_data_master_qualified_request_pipeline_bridge_s1,
      cpu_data_master_read_data_valid_pipeline_bridge_s1 => cpu_data_master_read_data_valid_pipeline_bridge_s1,
      cpu_data_master_read_data_valid_pipeline_bridge_s1_shift_register => cpu_data_master_read_data_valid_pipeline_bridge_s1_shift_register,
      cpu_data_master_requests_pipeline_bridge_s1 => cpu_data_master_requests_pipeline_bridge_s1,
      cpu_instruction_master_granted_pipeline_bridge_s1 => cpu_instruction_master_granted_pipeline_bridge_s1,
      cpu_instruction_master_qualified_request_pipeline_bridge_s1 => cpu_instruction_master_qualified_request_pipeline_bridge_s1,
      cpu_instruction_master_read_data_valid_pipeline_bridge_s1 => cpu_instruction_master_read_data_valid_pipeline_bridge_s1,
      cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register => cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register,
      cpu_instruction_master_requests_pipeline_bridge_s1 => cpu_instruction_master_requests_pipeline_bridge_s1,
      d1_pipeline_bridge_s1_end_xfer => d1_pipeline_bridge_s1_end_xfer,
      pipeline_bridge_s1_address => pipeline_bridge_s1_address,
      pipeline_bridge_s1_arbiterlock => pipeline_bridge_s1_arbiterlock,
      pipeline_bridge_s1_arbiterlock2 => pipeline_bridge_s1_arbiterlock2,
      pipeline_bridge_s1_burstcount => pipeline_bridge_s1_burstcount,
      pipeline_bridge_s1_byteenable => pipeline_bridge_s1_byteenable,
      pipeline_bridge_s1_chipselect => pipeline_bridge_s1_chipselect,
      pipeline_bridge_s1_debugaccess => pipeline_bridge_s1_debugaccess,
      pipeline_bridge_s1_endofpacket_from_sa => pipeline_bridge_s1_endofpacket_from_sa,
      pipeline_bridge_s1_nativeaddress => pipeline_bridge_s1_nativeaddress,
      pipeline_bridge_s1_read => pipeline_bridge_s1_read,
      pipeline_bridge_s1_readdata_from_sa => pipeline_bridge_s1_readdata_from_sa,
      pipeline_bridge_s1_reset_n => pipeline_bridge_s1_reset_n,
      pipeline_bridge_s1_waitrequest_from_sa => pipeline_bridge_s1_waitrequest_from_sa,
      pipeline_bridge_s1_write => pipeline_bridge_s1_write,
      pipeline_bridge_s1_writedata => pipeline_bridge_s1_writedata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_byteenable => cpu_data_master_byteenable,
      cpu_data_master_debugaccess => cpu_data_master_debugaccess,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      cpu_instruction_master_address_to_slave => cpu_instruction_master_address_to_slave,
      cpu_instruction_master_latency_counter => cpu_instruction_master_latency_counter,
      cpu_instruction_master_read => cpu_instruction_master_read,
      cpu_instruction_master_read_data_valid_sdram_s1_shift_register => cpu_instruction_master_read_data_valid_sdram_s1_shift_register,
      pipeline_bridge_s1_endofpacket => pipeline_bridge_s1_endofpacket,
      pipeline_bridge_s1_readdata => pipeline_bridge_s1_readdata,
      pipeline_bridge_s1_readdatavalid => pipeline_bridge_s1_readdatavalid,
      pipeline_bridge_s1_waitrequest => pipeline_bridge_s1_waitrequest,
      reset_n => clk_reset_n
    );


  --the_pipeline_bridge_m1, which is an e_instance
  the_pipeline_bridge_m1 : pipeline_bridge_m1_arbitrator
    port map(
      pipeline_bridge_m1_address_to_slave => pipeline_bridge_m1_address_to_slave,
      pipeline_bridge_m1_latency_counter => pipeline_bridge_m1_latency_counter,
      pipeline_bridge_m1_readdata => pipeline_bridge_m1_readdata,
      pipeline_bridge_m1_readdatavalid => pipeline_bridge_m1_readdatavalid,
      pipeline_bridge_m1_waitrequest => pipeline_bridge_m1_waitrequest,
      ads_busy_s1_readdata_from_sa => ads_busy_s1_readdata_from_sa,
      ads_clk_s1_readdata_from_sa => ads_clk_s1_readdata_from_sa,
      ads_din_s1_readdata_from_sa => ads_din_s1_readdata_from_sa,
      ads_dout_s1_readdata_from_sa => ads_dout_s1_readdata_from_sa,
      ads_ncs_s1_readdata_from_sa => ads_ncs_s1_readdata_from_sa,
      ads_nirq_s1_readdata_from_sa => ads_nirq_s1_readdata_from_sa,
      clk => clk,
      d1_ads_busy_s1_end_xfer => d1_ads_busy_s1_end_xfer,
      d1_ads_clk_s1_end_xfer => d1_ads_clk_s1_end_xfer,
      d1_ads_din_s1_end_xfer => d1_ads_din_s1_end_xfer,
      d1_ads_dout_s1_end_xfer => d1_ads_dout_s1_end_xfer,
      d1_ads_ncs_s1_end_xfer => d1_ads_ncs_s1_end_xfer,
      d1_ads_nirq_s1_end_xfer => d1_ads_nirq_s1_end_xfer,
      d1_ili_db_s1_end_xfer => d1_ili_db_s1_end_xfer,
      d1_ili_ncs_s1_end_xfer => d1_ili_ncs_s1_end_xfer,
      d1_ili_nrd_s1_end_xfer => d1_ili_nrd_s1_end_xfer,
      d1_ili_nrst_s1_end_xfer => d1_ili_nrst_s1_end_xfer,
      d1_ili_nwr_s1_end_xfer => d1_ili_nwr_s1_end_xfer,
      d1_ili_rs_s1_end_xfer => d1_ili_rs_s1_end_xfer,
      d1_sd_clk_s1_end_xfer => d1_sd_clk_s1_end_xfer,
      d1_sd_din_s1_end_xfer => d1_sd_din_s1_end_xfer,
      d1_sd_dout_s1_end_xfer => d1_sd_dout_s1_end_xfer,
      d1_sd_ncs_s1_end_xfer => d1_sd_ncs_s1_end_xfer,
      ili_db_s1_readdata_from_sa => ili_db_s1_readdata_from_sa,
      ili_ncs_s1_readdata_from_sa => ili_ncs_s1_readdata_from_sa,
      ili_nrd_s1_readdata_from_sa => ili_nrd_s1_readdata_from_sa,
      ili_nrst_s1_readdata_from_sa => ili_nrst_s1_readdata_from_sa,
      ili_nwr_s1_readdata_from_sa => ili_nwr_s1_readdata_from_sa,
      ili_rs_s1_readdata_from_sa => ili_rs_s1_readdata_from_sa,
      pipeline_bridge_m1_address => pipeline_bridge_m1_address,
      pipeline_bridge_m1_burstcount => pipeline_bridge_m1_burstcount,
      pipeline_bridge_m1_byteenable => pipeline_bridge_m1_byteenable,
      pipeline_bridge_m1_chipselect => pipeline_bridge_m1_chipselect,
      pipeline_bridge_m1_granted_ads_busy_s1 => pipeline_bridge_m1_granted_ads_busy_s1,
      pipeline_bridge_m1_granted_ads_clk_s1 => pipeline_bridge_m1_granted_ads_clk_s1,
      pipeline_bridge_m1_granted_ads_din_s1 => pipeline_bridge_m1_granted_ads_din_s1,
      pipeline_bridge_m1_granted_ads_dout_s1 => pipeline_bridge_m1_granted_ads_dout_s1,
      pipeline_bridge_m1_granted_ads_ncs_s1 => pipeline_bridge_m1_granted_ads_ncs_s1,
      pipeline_bridge_m1_granted_ads_nirq_s1 => pipeline_bridge_m1_granted_ads_nirq_s1,
      pipeline_bridge_m1_granted_ili_db_s1 => pipeline_bridge_m1_granted_ili_db_s1,
      pipeline_bridge_m1_granted_ili_ncs_s1 => pipeline_bridge_m1_granted_ili_ncs_s1,
      pipeline_bridge_m1_granted_ili_nrd_s1 => pipeline_bridge_m1_granted_ili_nrd_s1,
      pipeline_bridge_m1_granted_ili_nrst_s1 => pipeline_bridge_m1_granted_ili_nrst_s1,
      pipeline_bridge_m1_granted_ili_nwr_s1 => pipeline_bridge_m1_granted_ili_nwr_s1,
      pipeline_bridge_m1_granted_ili_rs_s1 => pipeline_bridge_m1_granted_ili_rs_s1,
      pipeline_bridge_m1_granted_sd_clk_s1 => pipeline_bridge_m1_granted_sd_clk_s1,
      pipeline_bridge_m1_granted_sd_din_s1 => pipeline_bridge_m1_granted_sd_din_s1,
      pipeline_bridge_m1_granted_sd_dout_s1 => pipeline_bridge_m1_granted_sd_dout_s1,
      pipeline_bridge_m1_granted_sd_ncs_s1 => pipeline_bridge_m1_granted_sd_ncs_s1,
      pipeline_bridge_m1_qualified_request_ads_busy_s1 => pipeline_bridge_m1_qualified_request_ads_busy_s1,
      pipeline_bridge_m1_qualified_request_ads_clk_s1 => pipeline_bridge_m1_qualified_request_ads_clk_s1,
      pipeline_bridge_m1_qualified_request_ads_din_s1 => pipeline_bridge_m1_qualified_request_ads_din_s1,
      pipeline_bridge_m1_qualified_request_ads_dout_s1 => pipeline_bridge_m1_qualified_request_ads_dout_s1,
      pipeline_bridge_m1_qualified_request_ads_ncs_s1 => pipeline_bridge_m1_qualified_request_ads_ncs_s1,
      pipeline_bridge_m1_qualified_request_ads_nirq_s1 => pipeline_bridge_m1_qualified_request_ads_nirq_s1,
      pipeline_bridge_m1_qualified_request_ili_db_s1 => pipeline_bridge_m1_qualified_request_ili_db_s1,
      pipeline_bridge_m1_qualified_request_ili_ncs_s1 => pipeline_bridge_m1_qualified_request_ili_ncs_s1,
      pipeline_bridge_m1_qualified_request_ili_nrd_s1 => pipeline_bridge_m1_qualified_request_ili_nrd_s1,
      pipeline_bridge_m1_qualified_request_ili_nrst_s1 => pipeline_bridge_m1_qualified_request_ili_nrst_s1,
      pipeline_bridge_m1_qualified_request_ili_nwr_s1 => pipeline_bridge_m1_qualified_request_ili_nwr_s1,
      pipeline_bridge_m1_qualified_request_ili_rs_s1 => pipeline_bridge_m1_qualified_request_ili_rs_s1,
      pipeline_bridge_m1_qualified_request_sd_clk_s1 => pipeline_bridge_m1_qualified_request_sd_clk_s1,
      pipeline_bridge_m1_qualified_request_sd_din_s1 => pipeline_bridge_m1_qualified_request_sd_din_s1,
      pipeline_bridge_m1_qualified_request_sd_dout_s1 => pipeline_bridge_m1_qualified_request_sd_dout_s1,
      pipeline_bridge_m1_qualified_request_sd_ncs_s1 => pipeline_bridge_m1_qualified_request_sd_ncs_s1,
      pipeline_bridge_m1_read => pipeline_bridge_m1_read,
      pipeline_bridge_m1_read_data_valid_ads_busy_s1 => pipeline_bridge_m1_read_data_valid_ads_busy_s1,
      pipeline_bridge_m1_read_data_valid_ads_clk_s1 => pipeline_bridge_m1_read_data_valid_ads_clk_s1,
      pipeline_bridge_m1_read_data_valid_ads_din_s1 => pipeline_bridge_m1_read_data_valid_ads_din_s1,
      pipeline_bridge_m1_read_data_valid_ads_dout_s1 => pipeline_bridge_m1_read_data_valid_ads_dout_s1,
      pipeline_bridge_m1_read_data_valid_ads_ncs_s1 => pipeline_bridge_m1_read_data_valid_ads_ncs_s1,
      pipeline_bridge_m1_read_data_valid_ads_nirq_s1 => pipeline_bridge_m1_read_data_valid_ads_nirq_s1,
      pipeline_bridge_m1_read_data_valid_ili_db_s1 => pipeline_bridge_m1_read_data_valid_ili_db_s1,
      pipeline_bridge_m1_read_data_valid_ili_ncs_s1 => pipeline_bridge_m1_read_data_valid_ili_ncs_s1,
      pipeline_bridge_m1_read_data_valid_ili_nrd_s1 => pipeline_bridge_m1_read_data_valid_ili_nrd_s1,
      pipeline_bridge_m1_read_data_valid_ili_nrst_s1 => pipeline_bridge_m1_read_data_valid_ili_nrst_s1,
      pipeline_bridge_m1_read_data_valid_ili_nwr_s1 => pipeline_bridge_m1_read_data_valid_ili_nwr_s1,
      pipeline_bridge_m1_read_data_valid_ili_rs_s1 => pipeline_bridge_m1_read_data_valid_ili_rs_s1,
      pipeline_bridge_m1_read_data_valid_sd_clk_s1 => pipeline_bridge_m1_read_data_valid_sd_clk_s1,
      pipeline_bridge_m1_read_data_valid_sd_din_s1 => pipeline_bridge_m1_read_data_valid_sd_din_s1,
      pipeline_bridge_m1_read_data_valid_sd_dout_s1 => pipeline_bridge_m1_read_data_valid_sd_dout_s1,
      pipeline_bridge_m1_read_data_valid_sd_ncs_s1 => pipeline_bridge_m1_read_data_valid_sd_ncs_s1,
      pipeline_bridge_m1_requests_ads_busy_s1 => pipeline_bridge_m1_requests_ads_busy_s1,
      pipeline_bridge_m1_requests_ads_clk_s1 => pipeline_bridge_m1_requests_ads_clk_s1,
      pipeline_bridge_m1_requests_ads_din_s1 => pipeline_bridge_m1_requests_ads_din_s1,
      pipeline_bridge_m1_requests_ads_dout_s1 => pipeline_bridge_m1_requests_ads_dout_s1,
      pipeline_bridge_m1_requests_ads_ncs_s1 => pipeline_bridge_m1_requests_ads_ncs_s1,
      pipeline_bridge_m1_requests_ads_nirq_s1 => pipeline_bridge_m1_requests_ads_nirq_s1,
      pipeline_bridge_m1_requests_ili_db_s1 => pipeline_bridge_m1_requests_ili_db_s1,
      pipeline_bridge_m1_requests_ili_ncs_s1 => pipeline_bridge_m1_requests_ili_ncs_s1,
      pipeline_bridge_m1_requests_ili_nrd_s1 => pipeline_bridge_m1_requests_ili_nrd_s1,
      pipeline_bridge_m1_requests_ili_nrst_s1 => pipeline_bridge_m1_requests_ili_nrst_s1,
      pipeline_bridge_m1_requests_ili_nwr_s1 => pipeline_bridge_m1_requests_ili_nwr_s1,
      pipeline_bridge_m1_requests_ili_rs_s1 => pipeline_bridge_m1_requests_ili_rs_s1,
      pipeline_bridge_m1_requests_sd_clk_s1 => pipeline_bridge_m1_requests_sd_clk_s1,
      pipeline_bridge_m1_requests_sd_din_s1 => pipeline_bridge_m1_requests_sd_din_s1,
      pipeline_bridge_m1_requests_sd_dout_s1 => pipeline_bridge_m1_requests_sd_dout_s1,
      pipeline_bridge_m1_requests_sd_ncs_s1 => pipeline_bridge_m1_requests_sd_ncs_s1,
      pipeline_bridge_m1_write => pipeline_bridge_m1_write,
      pipeline_bridge_m1_writedata => pipeline_bridge_m1_writedata,
      reset_n => clk_reset_n,
      sd_clk_s1_readdata_from_sa => sd_clk_s1_readdata_from_sa,
      sd_din_s1_readdata_from_sa => sd_din_s1_readdata_from_sa,
      sd_dout_s1_readdata_from_sa => sd_dout_s1_readdata_from_sa,
      sd_ncs_s1_readdata_from_sa => sd_ncs_s1_readdata_from_sa
    );


  --the_pipeline_bridge, which is an e_ptf_instance
  the_pipeline_bridge : pipeline_bridge
    port map(
      m1_address => pipeline_bridge_m1_address,
      m1_burstcount => pipeline_bridge_m1_burstcount,
      m1_byteenable => pipeline_bridge_m1_byteenable,
      m1_chipselect => pipeline_bridge_m1_chipselect,
      m1_debugaccess => pipeline_bridge_m1_debugaccess,
      m1_read => pipeline_bridge_m1_read,
      m1_write => pipeline_bridge_m1_write,
      m1_writedata => pipeline_bridge_m1_writedata,
      s1_endofpacket => pipeline_bridge_s1_endofpacket,
      s1_readdata => pipeline_bridge_s1_readdata,
      s1_readdatavalid => pipeline_bridge_s1_readdatavalid,
      s1_waitrequest => pipeline_bridge_s1_waitrequest,
      clk => clk,
      m1_endofpacket => pipeline_bridge_m1_endofpacket,
      m1_readdata => pipeline_bridge_m1_readdata,
      m1_readdatavalid => pipeline_bridge_m1_readdatavalid,
      m1_waitrequest => pipeline_bridge_m1_waitrequest,
      reset_n => pipeline_bridge_s1_reset_n,
      s1_address => pipeline_bridge_s1_address,
      s1_arbiterlock => pipeline_bridge_s1_arbiterlock,
      s1_arbiterlock2 => pipeline_bridge_s1_arbiterlock2,
      s1_burstcount => pipeline_bridge_s1_burstcount,
      s1_byteenable => pipeline_bridge_s1_byteenable,
      s1_chipselect => pipeline_bridge_s1_chipselect,
      s1_debugaccess => pipeline_bridge_s1_debugaccess,
      s1_nativeaddress => pipeline_bridge_s1_nativeaddress,
      s1_read => pipeline_bridge_s1_read,
      s1_write => pipeline_bridge_s1_write,
      s1_writedata => pipeline_bridge_s1_writedata
    );


  --the_sd_clk_s1, which is an e_instance
  the_sd_clk_s1 : sd_clk_s1_arbitrator
    port map(
      d1_sd_clk_s1_end_xfer => d1_sd_clk_s1_end_xfer,
      pipeline_bridge_m1_granted_sd_clk_s1 => pipeline_bridge_m1_granted_sd_clk_s1,
      pipeline_bridge_m1_qualified_request_sd_clk_s1 => pipeline_bridge_m1_qualified_request_sd_clk_s1,
      pipeline_bridge_m1_read_data_valid_sd_clk_s1 => pipeline_bridge_m1_read_data_valid_sd_clk_s1,
      pipeline_bridge_m1_requests_sd_clk_s1 => pipeline_bridge_m1_requests_sd_clk_s1,
      sd_clk_s1_address => sd_clk_s1_address,
      sd_clk_s1_chipselect => sd_clk_s1_chipselect,
      sd_clk_s1_readdata_from_sa => sd_clk_s1_readdata_from_sa,
      sd_clk_s1_reset_n => sd_clk_s1_reset_n,
      sd_clk_s1_write_n => sd_clk_s1_write_n,
      sd_clk_s1_writedata => sd_clk_s1_writedata,
      clk => clk,
      pipeline_bridge_m1_address_to_slave => pipeline_bridge_m1_address_to_slave,
      pipeline_bridge_m1_burstcount => pipeline_bridge_m1_burstcount,
      pipeline_bridge_m1_chipselect => pipeline_bridge_m1_chipselect,
      pipeline_bridge_m1_latency_counter => pipeline_bridge_m1_latency_counter,
      pipeline_bridge_m1_read => pipeline_bridge_m1_read,
      pipeline_bridge_m1_write => pipeline_bridge_m1_write,
      pipeline_bridge_m1_writedata => pipeline_bridge_m1_writedata,
      reset_n => clk_reset_n,
      sd_clk_s1_readdata => sd_clk_s1_readdata
    );


  --the_sd_clk, which is an e_ptf_instance
  the_sd_clk : sd_clk
    port map(
      out_port => internal_out_port_from_the_sd_clk,
      readdata => sd_clk_s1_readdata,
      address => sd_clk_s1_address,
      chipselect => sd_clk_s1_chipselect,
      clk => clk,
      reset_n => sd_clk_s1_reset_n,
      write_n => sd_clk_s1_write_n,
      writedata => sd_clk_s1_writedata
    );


  --the_sd_din_s1, which is an e_instance
  the_sd_din_s1 : sd_din_s1_arbitrator
    port map(
      d1_sd_din_s1_end_xfer => d1_sd_din_s1_end_xfer,
      pipeline_bridge_m1_granted_sd_din_s1 => pipeline_bridge_m1_granted_sd_din_s1,
      pipeline_bridge_m1_qualified_request_sd_din_s1 => pipeline_bridge_m1_qualified_request_sd_din_s1,
      pipeline_bridge_m1_read_data_valid_sd_din_s1 => pipeline_bridge_m1_read_data_valid_sd_din_s1,
      pipeline_bridge_m1_requests_sd_din_s1 => pipeline_bridge_m1_requests_sd_din_s1,
      sd_din_s1_address => sd_din_s1_address,
      sd_din_s1_chipselect => sd_din_s1_chipselect,
      sd_din_s1_readdata_from_sa => sd_din_s1_readdata_from_sa,
      sd_din_s1_reset_n => sd_din_s1_reset_n,
      sd_din_s1_write_n => sd_din_s1_write_n,
      sd_din_s1_writedata => sd_din_s1_writedata,
      clk => clk,
      pipeline_bridge_m1_address_to_slave => pipeline_bridge_m1_address_to_slave,
      pipeline_bridge_m1_burstcount => pipeline_bridge_m1_burstcount,
      pipeline_bridge_m1_chipselect => pipeline_bridge_m1_chipselect,
      pipeline_bridge_m1_latency_counter => pipeline_bridge_m1_latency_counter,
      pipeline_bridge_m1_read => pipeline_bridge_m1_read,
      pipeline_bridge_m1_write => pipeline_bridge_m1_write,
      pipeline_bridge_m1_writedata => pipeline_bridge_m1_writedata,
      reset_n => clk_reset_n,
      sd_din_s1_readdata => sd_din_s1_readdata
    );


  --the_sd_din, which is an e_ptf_instance
  the_sd_din : sd_din
    port map(
      out_port => internal_out_port_from_the_sd_din,
      readdata => sd_din_s1_readdata,
      address => sd_din_s1_address,
      chipselect => sd_din_s1_chipselect,
      clk => clk,
      reset_n => sd_din_s1_reset_n,
      write_n => sd_din_s1_write_n,
      writedata => sd_din_s1_writedata
    );


  --the_sd_dout_s1, which is an e_instance
  the_sd_dout_s1 : sd_dout_s1_arbitrator
    port map(
      d1_sd_dout_s1_end_xfer => d1_sd_dout_s1_end_xfer,
      pipeline_bridge_m1_granted_sd_dout_s1 => pipeline_bridge_m1_granted_sd_dout_s1,
      pipeline_bridge_m1_qualified_request_sd_dout_s1 => pipeline_bridge_m1_qualified_request_sd_dout_s1,
      pipeline_bridge_m1_read_data_valid_sd_dout_s1 => pipeline_bridge_m1_read_data_valid_sd_dout_s1,
      pipeline_bridge_m1_requests_sd_dout_s1 => pipeline_bridge_m1_requests_sd_dout_s1,
      sd_dout_s1_address => sd_dout_s1_address,
      sd_dout_s1_readdata_from_sa => sd_dout_s1_readdata_from_sa,
      sd_dout_s1_reset_n => sd_dout_s1_reset_n,
      clk => clk,
      pipeline_bridge_m1_address_to_slave => pipeline_bridge_m1_address_to_slave,
      pipeline_bridge_m1_burstcount => pipeline_bridge_m1_burstcount,
      pipeline_bridge_m1_chipselect => pipeline_bridge_m1_chipselect,
      pipeline_bridge_m1_latency_counter => pipeline_bridge_m1_latency_counter,
      pipeline_bridge_m1_read => pipeline_bridge_m1_read,
      pipeline_bridge_m1_write => pipeline_bridge_m1_write,
      reset_n => clk_reset_n,
      sd_dout_s1_readdata => sd_dout_s1_readdata
    );


  --the_sd_dout, which is an e_ptf_instance
  the_sd_dout : sd_dout
    port map(
      readdata => sd_dout_s1_readdata,
      address => sd_dout_s1_address,
      clk => clk,
      in_port => in_port_to_the_sd_dout,
      reset_n => sd_dout_s1_reset_n
    );


  --the_sd_ncs_s1, which is an e_instance
  the_sd_ncs_s1 : sd_ncs_s1_arbitrator
    port map(
      d1_sd_ncs_s1_end_xfer => d1_sd_ncs_s1_end_xfer,
      pipeline_bridge_m1_granted_sd_ncs_s1 => pipeline_bridge_m1_granted_sd_ncs_s1,
      pipeline_bridge_m1_qualified_request_sd_ncs_s1 => pipeline_bridge_m1_qualified_request_sd_ncs_s1,
      pipeline_bridge_m1_read_data_valid_sd_ncs_s1 => pipeline_bridge_m1_read_data_valid_sd_ncs_s1,
      pipeline_bridge_m1_requests_sd_ncs_s1 => pipeline_bridge_m1_requests_sd_ncs_s1,
      sd_ncs_s1_address => sd_ncs_s1_address,
      sd_ncs_s1_chipselect => sd_ncs_s1_chipselect,
      sd_ncs_s1_readdata_from_sa => sd_ncs_s1_readdata_from_sa,
      sd_ncs_s1_reset_n => sd_ncs_s1_reset_n,
      sd_ncs_s1_write_n => sd_ncs_s1_write_n,
      sd_ncs_s1_writedata => sd_ncs_s1_writedata,
      clk => clk,
      pipeline_bridge_m1_address_to_slave => pipeline_bridge_m1_address_to_slave,
      pipeline_bridge_m1_burstcount => pipeline_bridge_m1_burstcount,
      pipeline_bridge_m1_chipselect => pipeline_bridge_m1_chipselect,
      pipeline_bridge_m1_latency_counter => pipeline_bridge_m1_latency_counter,
      pipeline_bridge_m1_read => pipeline_bridge_m1_read,
      pipeline_bridge_m1_write => pipeline_bridge_m1_write,
      pipeline_bridge_m1_writedata => pipeline_bridge_m1_writedata,
      reset_n => clk_reset_n,
      sd_ncs_s1_readdata => sd_ncs_s1_readdata
    );


  --the_sd_ncs, which is an e_ptf_instance
  the_sd_ncs : sd_ncs
    port map(
      out_port => internal_out_port_from_the_sd_ncs,
      readdata => sd_ncs_s1_readdata,
      address => sd_ncs_s1_address,
      chipselect => sd_ncs_s1_chipselect,
      clk => clk,
      reset_n => sd_ncs_s1_reset_n,
      write_n => sd_ncs_s1_write_n,
      writedata => sd_ncs_s1_writedata
    );


  --the_sdram_s1, which is an e_instance
  the_sdram_s1 : sdram_s1_arbitrator
    port map(
      cpu_data_master_byteenable_sdram_s1 => cpu_data_master_byteenable_sdram_s1,
      cpu_data_master_granted_sdram_s1 => cpu_data_master_granted_sdram_s1,
      cpu_data_master_qualified_request_sdram_s1 => cpu_data_master_qualified_request_sdram_s1,
      cpu_data_master_read_data_valid_sdram_s1 => cpu_data_master_read_data_valid_sdram_s1,
      cpu_data_master_read_data_valid_sdram_s1_shift_register => cpu_data_master_read_data_valid_sdram_s1_shift_register,
      cpu_data_master_requests_sdram_s1 => cpu_data_master_requests_sdram_s1,
      cpu_instruction_master_granted_sdram_s1 => cpu_instruction_master_granted_sdram_s1,
      cpu_instruction_master_qualified_request_sdram_s1 => cpu_instruction_master_qualified_request_sdram_s1,
      cpu_instruction_master_read_data_valid_sdram_s1 => cpu_instruction_master_read_data_valid_sdram_s1,
      cpu_instruction_master_read_data_valid_sdram_s1_shift_register => cpu_instruction_master_read_data_valid_sdram_s1_shift_register,
      cpu_instruction_master_requests_sdram_s1 => cpu_instruction_master_requests_sdram_s1,
      d1_sdram_s1_end_xfer => d1_sdram_s1_end_xfer,
      sdram_s1_address => sdram_s1_address,
      sdram_s1_byteenable_n => sdram_s1_byteenable_n,
      sdram_s1_chipselect => sdram_s1_chipselect,
      sdram_s1_read_n => sdram_s1_read_n,
      sdram_s1_readdata_from_sa => sdram_s1_readdata_from_sa,
      sdram_s1_reset_n => sdram_s1_reset_n,
      sdram_s1_waitrequest_from_sa => sdram_s1_waitrequest_from_sa,
      sdram_s1_write_n => sdram_s1_write_n,
      sdram_s1_writedata => sdram_s1_writedata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_byteenable => cpu_data_master_byteenable,
      cpu_data_master_dbs_address => cpu_data_master_dbs_address,
      cpu_data_master_dbs_write_16 => cpu_data_master_dbs_write_16,
      cpu_data_master_no_byte_enables_and_last_term => cpu_data_master_no_byte_enables_and_last_term,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_instruction_master_address_to_slave => cpu_instruction_master_address_to_slave,
      cpu_instruction_master_dbs_address => cpu_instruction_master_dbs_address,
      cpu_instruction_master_latency_counter => cpu_instruction_master_latency_counter,
      cpu_instruction_master_read => cpu_instruction_master_read,
      cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register => cpu_instruction_master_read_data_valid_pipeline_bridge_s1_shift_register,
      reset_n => clk_reset_n,
      sdram_s1_readdata => sdram_s1_readdata,
      sdram_s1_readdatavalid => sdram_s1_readdatavalid,
      sdram_s1_waitrequest => sdram_s1_waitrequest
    );


  --the_sdram, which is an e_ptf_instance
  the_sdram : sdram
    port map(
      za_data => sdram_s1_readdata,
      za_valid => sdram_s1_readdatavalid,
      za_waitrequest => sdram_s1_waitrequest,
      zs_addr => internal_zs_addr_from_the_sdram,
      zs_ba => internal_zs_ba_from_the_sdram,
      zs_cas_n => internal_zs_cas_n_from_the_sdram,
      zs_cke => internal_zs_cke_from_the_sdram,
      zs_cs_n => internal_zs_cs_n_from_the_sdram,
      zs_dq => zs_dq_to_and_from_the_sdram,
      zs_dqm => internal_zs_dqm_from_the_sdram,
      zs_ras_n => internal_zs_ras_n_from_the_sdram,
      zs_we_n => internal_zs_we_n_from_the_sdram,
      az_addr => sdram_s1_address,
      az_be_n => sdram_s1_byteenable_n,
      az_cs => sdram_s1_chipselect,
      az_data => sdram_s1_writedata,
      az_rd_n => sdram_s1_read_n,
      az_wr_n => sdram_s1_write_n,
      clk => clk,
      reset_n => sdram_s1_reset_n
    );


  --reset is asserted asynchronously and deasserted synchronously
  nios32_reset_clk_domain_synch : nios32_reset_clk_domain_synch_module
    port map(
      data_out => clk_reset_n,
      clk => clk,
      data_in => module_input12,
      reset_n => reset_n_sources
    );

  module_input12 <= std_logic'('1');

  --reset sources mux, which is an e_mux
  reset_n_sources <= Vector_To_Std_Logic(NOT (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT reset_n))) OR std_logic_vector'("00000000000000000000000000000000")) OR (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_jtag_debug_module_resetrequest_from_sa)))) OR (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_jtag_debug_module_resetrequest_from_sa))))));
  --pipeline_bridge_m1_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  pipeline_bridge_m1_endofpacket <= std_logic'('0');
  --vhdl renameroo for output signals
  dclk_from_the_epcs_flash_controller <= internal_dclk_from_the_epcs_flash_controller;
  --vhdl renameroo for output signals
  out_port_from_the_ads_clk <= internal_out_port_from_the_ads_clk;
  --vhdl renameroo for output signals
  out_port_from_the_ads_din <= internal_out_port_from_the_ads_din;
  --vhdl renameroo for output signals
  out_port_from_the_ads_ncs <= internal_out_port_from_the_ads_ncs;
  --vhdl renameroo for output signals
  out_port_from_the_ili_ncs <= internal_out_port_from_the_ili_ncs;
  --vhdl renameroo for output signals
  out_port_from_the_ili_nrd <= internal_out_port_from_the_ili_nrd;
  --vhdl renameroo for output signals
  out_port_from_the_ili_nrst <= internal_out_port_from_the_ili_nrst;
  --vhdl renameroo for output signals
  out_port_from_the_ili_nwr <= internal_out_port_from_the_ili_nwr;
  --vhdl renameroo for output signals
  out_port_from_the_ili_rs <= internal_out_port_from_the_ili_rs;
  --vhdl renameroo for output signals
  out_port_from_the_sd_clk <= internal_out_port_from_the_sd_clk;
  --vhdl renameroo for output signals
  out_port_from_the_sd_din <= internal_out_port_from_the_sd_din;
  --vhdl renameroo for output signals
  out_port_from_the_sd_ncs <= internal_out_port_from_the_sd_ncs;
  --vhdl renameroo for output signals
  sce_from_the_epcs_flash_controller <= internal_sce_from_the_epcs_flash_controller;
  --vhdl renameroo for output signals
  sdo_from_the_epcs_flash_controller <= internal_sdo_from_the_epcs_flash_controller;
  --vhdl renameroo for output signals
  zs_addr_from_the_sdram <= internal_zs_addr_from_the_sdram;
  --vhdl renameroo for output signals
  zs_ba_from_the_sdram <= internal_zs_ba_from_the_sdram;
  --vhdl renameroo for output signals
  zs_cas_n_from_the_sdram <= internal_zs_cas_n_from_the_sdram;
  --vhdl renameroo for output signals
  zs_cke_from_the_sdram <= internal_zs_cke_from_the_sdram;
  --vhdl renameroo for output signals
  zs_cs_n_from_the_sdram <= internal_zs_cs_n_from_the_sdram;
  --vhdl renameroo for output signals
  zs_dqm_from_the_sdram <= internal_zs_dqm_from_the_sdram;
  --vhdl renameroo for output signals
  zs_ras_n_from_the_sdram <= internal_zs_ras_n_from_the_sdram;
  --vhdl renameroo for output signals
  zs_we_n_from_the_sdram <= internal_zs_we_n_from_the_sdram;

end europa;


--synthesis translate_off

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add your libraries here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>

entity test_bench is 
end entity test_bench;


architecture europa of test_bench is
component nios32 is 
           port (
                 -- 1) global signals:
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- the_ads_busy
                    signal in_port_to_the_ads_busy : IN STD_LOGIC;

                 -- the_ads_clk
                    signal out_port_from_the_ads_clk : OUT STD_LOGIC;

                 -- the_ads_din
                    signal out_port_from_the_ads_din : OUT STD_LOGIC;

                 -- the_ads_dout
                    signal in_port_to_the_ads_dout : IN STD_LOGIC;

                 -- the_ads_ncs
                    signal out_port_from_the_ads_ncs : OUT STD_LOGIC;

                 -- the_ads_nirq
                    signal in_port_to_the_ads_nirq : IN STD_LOGIC;

                 -- the_epcs_flash_controller
                    signal data0_to_the_epcs_flash_controller : IN STD_LOGIC;
                    signal dclk_from_the_epcs_flash_controller : OUT STD_LOGIC;
                    signal sce_from_the_epcs_flash_controller : OUT STD_LOGIC;
                    signal sdo_from_the_epcs_flash_controller : OUT STD_LOGIC;

                 -- the_ili_db
                    signal bidir_port_to_and_from_the_ili_db : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);

                 -- the_ili_ncs
                    signal out_port_from_the_ili_ncs : OUT STD_LOGIC;

                 -- the_ili_nrd
                    signal out_port_from_the_ili_nrd : OUT STD_LOGIC;

                 -- the_ili_nrst
                    signal out_port_from_the_ili_nrst : OUT STD_LOGIC;

                 -- the_ili_nwr
                    signal out_port_from_the_ili_nwr : OUT STD_LOGIC;

                 -- the_ili_rs
                    signal out_port_from_the_ili_rs : OUT STD_LOGIC;

                 -- the_sd_clk
                    signal out_port_from_the_sd_clk : OUT STD_LOGIC;

                 -- the_sd_din
                    signal out_port_from_the_sd_din : OUT STD_LOGIC;

                 -- the_sd_dout
                    signal in_port_to_the_sd_dout : IN STD_LOGIC;

                 -- the_sd_ncs
                    signal out_port_from_the_sd_ncs : OUT STD_LOGIC;

                 -- the_sdram
                    signal zs_addr_from_the_sdram : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
                    signal zs_ba_from_the_sdram : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal zs_cas_n_from_the_sdram : OUT STD_LOGIC;
                    signal zs_cke_from_the_sdram : OUT STD_LOGIC;
                    signal zs_cs_n_from_the_sdram : OUT STD_LOGIC;
                    signal zs_dq_to_and_from_the_sdram : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal zs_dqm_from_the_sdram : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal zs_ras_n_from_the_sdram : OUT STD_LOGIC;
                    signal zs_we_n_from_the_sdram : OUT STD_LOGIC
                 );
end component nios32;

component sdram_test_component is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal zs_addr : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
                    signal zs_ba : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal zs_cas_n : IN STD_LOGIC;
                    signal zs_cke : IN STD_LOGIC;
                    signal zs_cs_n : IN STD_LOGIC;
                    signal zs_dqm : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal zs_ras_n : IN STD_LOGIC;
                    signal zs_we_n : IN STD_LOGIC;

                 -- outputs:
                    signal zs_dq : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component sdram_test_component;

                signal bidir_port_to_and_from_the_ili_db :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal clk :  STD_LOGIC;
                signal data0_to_the_epcs_flash_controller :  STD_LOGIC;
                signal dclk_from_the_epcs_flash_controller :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_dataavailable_from_sa :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_endofpacket_from_sa :  STD_LOGIC;
                signal epcs_flash_controller_epcs_control_port_readyfordata_from_sa :  STD_LOGIC;
                signal in_port_to_the_ads_busy :  STD_LOGIC;
                signal in_port_to_the_ads_dout :  STD_LOGIC;
                signal in_port_to_the_ads_nirq :  STD_LOGIC;
                signal in_port_to_the_sd_dout :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_dataavailable_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_readyfordata_from_sa :  STD_LOGIC;
                signal out_port_from_the_ads_clk :  STD_LOGIC;
                signal out_port_from_the_ads_din :  STD_LOGIC;
                signal out_port_from_the_ads_ncs :  STD_LOGIC;
                signal out_port_from_the_ili_ncs :  STD_LOGIC;
                signal out_port_from_the_ili_nrd :  STD_LOGIC;
                signal out_port_from_the_ili_nrst :  STD_LOGIC;
                signal out_port_from_the_ili_nwr :  STD_LOGIC;
                signal out_port_from_the_ili_rs :  STD_LOGIC;
                signal out_port_from_the_sd_clk :  STD_LOGIC;
                signal out_port_from_the_sd_din :  STD_LOGIC;
                signal out_port_from_the_sd_ncs :  STD_LOGIC;
                signal pipeline_bridge_m1_debugaccess :  STD_LOGIC;
                signal pipeline_bridge_m1_endofpacket :  STD_LOGIC;
                signal pipeline_bridge_s1_endofpacket_from_sa :  STD_LOGIC;
                signal reset_n :  STD_LOGIC;
                signal sce_from_the_epcs_flash_controller :  STD_LOGIC;
                signal sdo_from_the_epcs_flash_controller :  STD_LOGIC;
                signal zs_addr_from_the_sdram :  STD_LOGIC_VECTOR (11 DOWNTO 0);
                signal zs_ba_from_the_sdram :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal zs_cas_n_from_the_sdram :  STD_LOGIC;
                signal zs_cke_from_the_sdram :  STD_LOGIC;
                signal zs_cs_n_from_the_sdram :  STD_LOGIC;
                signal zs_dq_to_and_from_the_sdram :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal zs_dqm_from_the_sdram :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal zs_ras_n_from_the_sdram :  STD_LOGIC;
                signal zs_we_n_from_the_sdram :  STD_LOGIC;


-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add your component and signal declaration here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>


begin

  --Set us up the Dut
  DUT : nios32
    port map(
      bidir_port_to_and_from_the_ili_db => bidir_port_to_and_from_the_ili_db,
      dclk_from_the_epcs_flash_controller => dclk_from_the_epcs_flash_controller,
      out_port_from_the_ads_clk => out_port_from_the_ads_clk,
      out_port_from_the_ads_din => out_port_from_the_ads_din,
      out_port_from_the_ads_ncs => out_port_from_the_ads_ncs,
      out_port_from_the_ili_ncs => out_port_from_the_ili_ncs,
      out_port_from_the_ili_nrd => out_port_from_the_ili_nrd,
      out_port_from_the_ili_nrst => out_port_from_the_ili_nrst,
      out_port_from_the_ili_nwr => out_port_from_the_ili_nwr,
      out_port_from_the_ili_rs => out_port_from_the_ili_rs,
      out_port_from_the_sd_clk => out_port_from_the_sd_clk,
      out_port_from_the_sd_din => out_port_from_the_sd_din,
      out_port_from_the_sd_ncs => out_port_from_the_sd_ncs,
      sce_from_the_epcs_flash_controller => sce_from_the_epcs_flash_controller,
      sdo_from_the_epcs_flash_controller => sdo_from_the_epcs_flash_controller,
      zs_addr_from_the_sdram => zs_addr_from_the_sdram,
      zs_ba_from_the_sdram => zs_ba_from_the_sdram,
      zs_cas_n_from_the_sdram => zs_cas_n_from_the_sdram,
      zs_cke_from_the_sdram => zs_cke_from_the_sdram,
      zs_cs_n_from_the_sdram => zs_cs_n_from_the_sdram,
      zs_dq_to_and_from_the_sdram => zs_dq_to_and_from_the_sdram,
      zs_dqm_from_the_sdram => zs_dqm_from_the_sdram,
      zs_ras_n_from_the_sdram => zs_ras_n_from_the_sdram,
      zs_we_n_from_the_sdram => zs_we_n_from_the_sdram,
      clk => clk,
      data0_to_the_epcs_flash_controller => data0_to_the_epcs_flash_controller,
      in_port_to_the_ads_busy => in_port_to_the_ads_busy,
      in_port_to_the_ads_dout => in_port_to_the_ads_dout,
      in_port_to_the_ads_nirq => in_port_to_the_ads_nirq,
      in_port_to_the_sd_dout => in_port_to_the_sd_dout,
      reset_n => reset_n
    );


  --the_sdram_test_component, which is an e_instance
  the_sdram_test_component : sdram_test_component
    port map(
      zs_dq => zs_dq_to_and_from_the_sdram,
      clk => clk,
      zs_addr => zs_addr_from_the_sdram,
      zs_ba => zs_ba_from_the_sdram,
      zs_cas_n => zs_cas_n_from_the_sdram,
      zs_cke => zs_cke_from_the_sdram,
      zs_cs_n => zs_cs_n_from_the_sdram,
      zs_dqm => zs_dqm_from_the_sdram,
      zs_ras_n => zs_ras_n_from_the_sdram,
      zs_we_n => zs_we_n_from_the_sdram
    );


  process
  begin
    clk <= '0';
    loop
       wait for 10 ns;
       clk <= not clk;
    end loop;
  end process;
  PROCESS
    BEGIN
       reset_n <= '0';
       wait for 200 ns;
       reset_n <= '1'; 
    WAIT;
  END PROCESS;


-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add additional architecture here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>


end europa;



--synthesis translate_on
