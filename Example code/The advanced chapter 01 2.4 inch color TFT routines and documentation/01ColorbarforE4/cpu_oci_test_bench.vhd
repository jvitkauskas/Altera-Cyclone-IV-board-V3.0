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

entity cpu_oci_test_bench is 
        port (
              -- inputs:
                 signal dct_buffer : IN STD_LOGIC_VECTOR (29 DOWNTO 0);
                 signal dct_count : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal test_ending : IN STD_LOGIC;
                 signal test_has_ended : IN STD_LOGIC
              );
end entity cpu_oci_test_bench;


architecture europa of cpu_oci_test_bench is

begin


end europa;

