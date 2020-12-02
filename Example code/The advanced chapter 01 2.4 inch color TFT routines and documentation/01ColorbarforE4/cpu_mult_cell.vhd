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
use altera_mf.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library lpm;
use lpm.all;

entity cpu_mult_cell is 
        port (
              -- inputs:
                 signal A_mul_src1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal A_mul_src2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal A_mul_cell_result : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity cpu_mult_cell;


architecture europa of cpu_mult_cell is

component altmult_add
GENERIC (
        addnsub_multiplier_pipeline_aclr1 : STRING;
        addnsub_multiplier_pipeline_register1 : STRING;
        addnsub_multiplier_register1 : STRING;
        dedicated_multiplier_circuitry : STRING;
        input_register_a0 : STRING;
        input_register_b0 : STRING;
        input_source_a0 : STRING;
        input_source_b0 : STRING;
        intended_device_family : STRING;
        lpm_type : STRING;
        multiplier1_direction : STRING;
        multiplier_aclr0 : STRING;
        multiplier_register0 : STRING;
        number_of_multipliers : NATURAL;
        output_register : STRING;
        port_addnsub1 : STRING;
        port_signa : STRING;
        port_signb : STRING;
        representation_a : STRING;
        representation_b : STRING;
        signed_pipeline_aclr_a : STRING;
        signed_pipeline_aclr_b : STRING;
        signed_pipeline_register_a : STRING;
        signed_pipeline_register_b : STRING;
        signed_register_a : STRING;
        signed_register_b : STRING;
        width_a : NATURAL;
        width_b : NATURAL;
        width_result : NATURAL
      );
    PORT (
        clock0 : IN STD_LOGIC;
        result : OUT STD_LOGIC_VECTOR (width_result-1 DOWNTO 0);
        ena0   : IN STD_LOGIC;
        dataa : IN STD_LOGIC_VECTOR (width_a-1 DOWNTO 0);
        datab : IN STD_LOGIC_VECTOR (width_b-1 DOWNTO 0);
        aclr0 : IN STD_LOGIC
      );
  end component altmult_add;
                         signal A_mul_cell_result_part_1 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal A_mul_cell_result_part_2 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal mul_clr :  STD_LOGIC;

begin

  mul_clr <= NOT reset_n;
  the_altmult_add_part_1 : altmult_add
    generic map(
      addnsub_multiplier_pipeline_aclr1 => "ACLR0",
      addnsub_multiplier_pipeline_register1 => "CLOCK0",
      addnsub_multiplier_register1 => "UNREGISTERED",
      dedicated_multiplier_circuitry => "YES",
      input_register_a0 => "UNREGISTERED",
      input_register_b0 => "UNREGISTERED",
      input_source_a0 => "DATAA",
      input_source_b0 => "DATAB",
      intended_device_family => "CYCLONEIVE",
      lpm_type => "altmult_add",
      multiplier1_direction => "ADD",
      multiplier_aclr0 => "ACLR0",
      multiplier_register0 => "CLOCK0",
      number_of_multipliers => 1,
      output_register => "UNREGISTERED",
      port_addnsub1 => "PORT_UNUSED",
      port_signa => "PORT_UNUSED",
      port_signb => "PORT_UNUSED",
      representation_a => "UNSIGNED",
      representation_b => "UNSIGNED",
      signed_pipeline_aclr_a => "ACLR0",
      signed_pipeline_aclr_b => "ACLR0",
      signed_pipeline_register_a => "CLOCK0",
      signed_pipeline_register_b => "CLOCK0",
      signed_register_a => "UNREGISTERED",
      signed_register_b => "UNREGISTERED",
      width_a => 16,
      width_b => 16,
      width_result => 32
    )
    port map(
            aclr0 => mul_clr,
            clock0 => clk,
            dataa => A_mul_src1(15 DOWNTO 0),
            datab => A_mul_src2(15 DOWNTO 0),
            ena0 => std_logic'('1'),
            result => A_mul_cell_result_part_1
    );

  the_altmult_add_part_2 : altmult_add
    generic map(
      addnsub_multiplier_pipeline_aclr1 => "ACLR0",
      addnsub_multiplier_pipeline_register1 => "CLOCK0",
      addnsub_multiplier_register1 => "UNREGISTERED",
      dedicated_multiplier_circuitry => "YES",
      input_register_a0 => "UNREGISTERED",
      input_register_b0 => "UNREGISTERED",
      input_source_a0 => "DATAA",
      input_source_b0 => "DATAB",
      intended_device_family => "CYCLONEIVE",
      lpm_type => "altmult_add",
      multiplier1_direction => "ADD",
      multiplier_aclr0 => "ACLR0",
      multiplier_register0 => "CLOCK0",
      number_of_multipliers => 1,
      output_register => "UNREGISTERED",
      port_addnsub1 => "PORT_UNUSED",
      port_signa => "PORT_UNUSED",
      port_signb => "PORT_UNUSED",
      representation_a => "UNSIGNED",
      representation_b => "UNSIGNED",
      signed_pipeline_aclr_a => "ACLR0",
      signed_pipeline_aclr_b => "ACLR0",
      signed_pipeline_register_a => "CLOCK0",
      signed_pipeline_register_b => "CLOCK0",
      signed_register_a => "UNREGISTERED",
      signed_register_b => "UNREGISTERED",
      width_a => 16,
      width_b => 16,
      width_result => 16
    )
    port map(
            aclr0 => mul_clr,
            clock0 => clk,
            dataa => A_mul_src1(31 DOWNTO 16),
            datab => A_mul_src2(15 DOWNTO 0),
            ena0 => std_logic'('1'),
            result => A_mul_cell_result_part_2
    );

  A_mul_cell_result <= A_EXT (Std_Logic_Vector'(((std_logic_vector'("0") & (A_mul_cell_result_part_1(31 DOWNTO 16))) + (std_logic_vector'("0") & (A_mul_cell_result_part_2))) & A_mul_cell_result_part_1(15 DOWNTO 0)), 32);

end europa;

