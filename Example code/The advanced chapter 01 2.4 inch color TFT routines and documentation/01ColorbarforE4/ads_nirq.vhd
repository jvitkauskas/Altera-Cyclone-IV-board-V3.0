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

entity ads_nirq is 
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
end entity ads_nirq;


architecture europa of ads_nirq is
                signal clk_en :  STD_LOGIC;
                signal d1_data_in :  STD_LOGIC;
                signal d2_data_in :  STD_LOGIC;
                signal data_in :  STD_LOGIC;
                signal edge_capture :  STD_LOGIC;
                signal edge_capture_wr_strobe :  STD_LOGIC;
                signal edge_detect :  STD_LOGIC;
                signal irq_mask :  STD_LOGIC;
                signal read_mux_out :  STD_LOGIC;

begin

  clk_en <= std_logic'('1');
  --s1, which is an e_avalon_slave
  read_mux_out <= (((to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000000000")))) AND data_in)) OR ((to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000000010")))) AND irq_mask))) OR ((to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000000011")))) AND edge_capture));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      readdata <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        readdata <= A_EXT (Std_Logic_Vector'((std_logic_vector'("000000000000000000000000000100000") - std_logic_vector'("000000000000000000000000000000000")) & A_ToStdLogicVector(read_mux_out)), 32);
      end if;
    end if;

  end process;

  data_in <= in_port;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      irq_mask <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((chipselect AND NOT write_n) AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000000010")))))) = '1' then 
        irq_mask <= writedata(0);
      end if;
    end if;

  end process;

  irq <= data_in AND irq_mask;
  edge_capture_wr_strobe <= (chipselect AND NOT write_n) AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000000011"))));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      edge_capture <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        if std_logic'((edge_capture_wr_strobe AND writedata(0))) = '1' then 
          edge_capture <= std_logic'('0');
        elsif std_logic'(edge_detect) = '1' then 
          edge_capture <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
        end if;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_data_in <= std_logic'('0');
      d2_data_in <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(clk_en) = '1' then 
        d1_data_in <= data_in;
        d2_data_in <= d1_data_in;
      end if;
    end if;

  end process;

  edge_detect <= d1_data_in AND NOT d2_data_in;

end europa;

