--Legal Notice: (C)2010 Altera Corporation. All rights reserved.  Your
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

entity led_pio is 
        port (
              -- inputs:
                 signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal chipselect : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal write_n : IN STD_LOGIC;
                 signal writedata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);

              -- outputs:
                 signal out_port : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal readdata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
              );
end entity led_pio;


architecture europa of led_pio is
                signal clk_en :  STD_LOGIC;
                signal data_out :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal read_mux_out :  STD_LOGIC_VECTOR (7 DOWNTO 0);

begin

  clk_en <= std_logic'('1');
  --s1, which is an e_avalon_slave
  read_mux_out <= A_REP(to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000000000")))), 8) AND data_out;
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      data_out <= std_logic_vector'("00000000");
    elsif clk'event and clk = '1' then
      if std_logic'(((chipselect AND NOT write_n) AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & (address)) = std_logic_vector'("00000000000000000000000000000000")))))) = '1' then 
        data_out <= writedata(7 DOWNTO 0);
      end if;
    end if;

  end process;

  readdata <= read_mux_out;
  out_port <= data_out;

end europa;

