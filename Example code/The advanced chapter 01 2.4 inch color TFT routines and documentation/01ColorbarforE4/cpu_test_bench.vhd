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

entity cpu_test_bench is 
        port (
              -- inputs:
                 signal A_bstatus_reg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal A_cmp_result : IN STD_LOGIC;
                 signal A_ctrl_exception : IN STD_LOGIC;
                 signal A_ctrl_ld_non_io : IN STD_LOGIC;
                 signal A_dst_regnum : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
                 signal A_en : IN STD_LOGIC;
                 signal A_estatus_reg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal A_ienable_reg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal A_ipending_reg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal A_iw : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal A_mem_byte_en : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal A_op_hbreak : IN STD_LOGIC;
                 signal A_op_intr : IN STD_LOGIC;
                 signal A_pcb : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal A_st_data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal A_status_reg : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal A_valid : IN STD_LOGIC;
                 signal A_wr_data_unfiltered : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal A_wr_dst_reg : IN STD_LOGIC;
                 signal E_add_br_to_taken_history_unfiltered : IN STD_LOGIC;
                 signal E_logic_result : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal E_valid : IN STD_LOGIC;
                 signal M_bht_ptr_unfiltered : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal M_bht_wr_data_unfiltered : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal M_bht_wr_en_unfiltered : IN STD_LOGIC;
                 signal M_mem_baddr : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal M_target_pcb : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal M_valid : IN STD_LOGIC;
                 signal W_dst_regnum : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
                 signal W_iw : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal W_iw_op : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
                 signal W_iw_opx : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
                 signal W_pcb : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal W_valid : IN STD_LOGIC;
                 signal W_vinst : IN STD_LOGIC_VECTOR (55 DOWNTO 0);
                 signal W_wr_dst_reg : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal d_address : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal d_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal d_read : IN STD_LOGIC;
                 signal d_write : IN STD_LOGIC;
                 signal i_address : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal i_read : IN STD_LOGIC;
                 signal i_readdatavalid : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal A_wr_data_filtered : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal E_add_br_to_taken_history_filtered : OUT STD_LOGIC;
                 signal E_src1_eq_src2 : OUT STD_LOGIC;
                 signal M_bht_ptr_filtered : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal M_bht_wr_data_filtered : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal M_bht_wr_en_filtered : OUT STD_LOGIC;
                 signal test_has_ended : OUT STD_LOGIC
              );
end entity cpu_test_bench;


architecture europa of cpu_test_bench is
                signal A_mem_baddr :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal A_target_pcb :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal A_wr_data_unfiltered_0_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_10_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_11_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_12_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_13_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_14_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_15_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_16_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_17_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_18_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_19_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_1_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_20_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_21_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_22_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_23_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_24_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_25_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_26_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_27_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_28_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_29_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_2_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_30_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_31_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_3_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_4_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_5_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_6_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_7_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_8_is_x :  STD_LOGIC;
                signal A_wr_data_unfiltered_9_is_x :  STD_LOGIC;
                signal W_op_add :  STD_LOGIC;
                signal W_op_addi :  STD_LOGIC;
                signal W_op_and :  STD_LOGIC;
                signal W_op_andhi :  STD_LOGIC;
                signal W_op_andi :  STD_LOGIC;
                signal W_op_beq :  STD_LOGIC;
                signal W_op_bge :  STD_LOGIC;
                signal W_op_bgeu :  STD_LOGIC;
                signal W_op_blt :  STD_LOGIC;
                signal W_op_bltu :  STD_LOGIC;
                signal W_op_bne :  STD_LOGIC;
                signal W_op_br :  STD_LOGIC;
                signal W_op_break :  STD_LOGIC;
                signal W_op_bret :  STD_LOGIC;
                signal W_op_call :  STD_LOGIC;
                signal W_op_callr :  STD_LOGIC;
                signal W_op_cmpeq :  STD_LOGIC;
                signal W_op_cmpeqi :  STD_LOGIC;
                signal W_op_cmpge :  STD_LOGIC;
                signal W_op_cmpgei :  STD_LOGIC;
                signal W_op_cmpgeu :  STD_LOGIC;
                signal W_op_cmpgeui :  STD_LOGIC;
                signal W_op_cmplt :  STD_LOGIC;
                signal W_op_cmplti :  STD_LOGIC;
                signal W_op_cmpltu :  STD_LOGIC;
                signal W_op_cmpltui :  STD_LOGIC;
                signal W_op_cmpne :  STD_LOGIC;
                signal W_op_cmpnei :  STD_LOGIC;
                signal W_op_crst :  STD_LOGIC;
                signal W_op_custom :  STD_LOGIC;
                signal W_op_div :  STD_LOGIC;
                signal W_op_divu :  STD_LOGIC;
                signal W_op_eret :  STD_LOGIC;
                signal W_op_flushd :  STD_LOGIC;
                signal W_op_flushda :  STD_LOGIC;
                signal W_op_flushi :  STD_LOGIC;
                signal W_op_flushp :  STD_LOGIC;
                signal W_op_hbreak :  STD_LOGIC;
                signal W_op_initd :  STD_LOGIC;
                signal W_op_initda :  STD_LOGIC;
                signal W_op_initi :  STD_LOGIC;
                signal W_op_intr :  STD_LOGIC;
                signal W_op_jmp :  STD_LOGIC;
                signal W_op_jmpi :  STD_LOGIC;
                signal W_op_ldb :  STD_LOGIC;
                signal W_op_ldbio :  STD_LOGIC;
                signal W_op_ldbu :  STD_LOGIC;
                signal W_op_ldbuio :  STD_LOGIC;
                signal W_op_ldh :  STD_LOGIC;
                signal W_op_ldhio :  STD_LOGIC;
                signal W_op_ldhu :  STD_LOGIC;
                signal W_op_ldhuio :  STD_LOGIC;
                signal W_op_ldl :  STD_LOGIC;
                signal W_op_ldw :  STD_LOGIC;
                signal W_op_ldwio :  STD_LOGIC;
                signal W_op_mul :  STD_LOGIC;
                signal W_op_muli :  STD_LOGIC;
                signal W_op_mulxss :  STD_LOGIC;
                signal W_op_mulxsu :  STD_LOGIC;
                signal W_op_mulxuu :  STD_LOGIC;
                signal W_op_nextpc :  STD_LOGIC;
                signal W_op_nor :  STD_LOGIC;
                signal W_op_opx :  STD_LOGIC;
                signal W_op_or :  STD_LOGIC;
                signal W_op_orhi :  STD_LOGIC;
                signal W_op_ori :  STD_LOGIC;
                signal W_op_rdctl :  STD_LOGIC;
                signal W_op_rdprs :  STD_LOGIC;
                signal W_op_ret :  STD_LOGIC;
                signal W_op_rol :  STD_LOGIC;
                signal W_op_roli :  STD_LOGIC;
                signal W_op_ror :  STD_LOGIC;
                signal W_op_rsv02 :  STD_LOGIC;
                signal W_op_rsv09 :  STD_LOGIC;
                signal W_op_rsv10 :  STD_LOGIC;
                signal W_op_rsv17 :  STD_LOGIC;
                signal W_op_rsv18 :  STD_LOGIC;
                signal W_op_rsv25 :  STD_LOGIC;
                signal W_op_rsv26 :  STD_LOGIC;
                signal W_op_rsv33 :  STD_LOGIC;
                signal W_op_rsv34 :  STD_LOGIC;
                signal W_op_rsv41 :  STD_LOGIC;
                signal W_op_rsv42 :  STD_LOGIC;
                signal W_op_rsv49 :  STD_LOGIC;
                signal W_op_rsv57 :  STD_LOGIC;
                signal W_op_rsv61 :  STD_LOGIC;
                signal W_op_rsv62 :  STD_LOGIC;
                signal W_op_rsv63 :  STD_LOGIC;
                signal W_op_rsvx00 :  STD_LOGIC;
                signal W_op_rsvx10 :  STD_LOGIC;
                signal W_op_rsvx15 :  STD_LOGIC;
                signal W_op_rsvx17 :  STD_LOGIC;
                signal W_op_rsvx21 :  STD_LOGIC;
                signal W_op_rsvx25 :  STD_LOGIC;
                signal W_op_rsvx33 :  STD_LOGIC;
                signal W_op_rsvx34 :  STD_LOGIC;
                signal W_op_rsvx35 :  STD_LOGIC;
                signal W_op_rsvx42 :  STD_LOGIC;
                signal W_op_rsvx43 :  STD_LOGIC;
                signal W_op_rsvx44 :  STD_LOGIC;
                signal W_op_rsvx47 :  STD_LOGIC;
                signal W_op_rsvx50 :  STD_LOGIC;
                signal W_op_rsvx51 :  STD_LOGIC;
                signal W_op_rsvx55 :  STD_LOGIC;
                signal W_op_rsvx56 :  STD_LOGIC;
                signal W_op_rsvx60 :  STD_LOGIC;
                signal W_op_rsvx63 :  STD_LOGIC;
                signal W_op_sll :  STD_LOGIC;
                signal W_op_slli :  STD_LOGIC;
                signal W_op_sra :  STD_LOGIC;
                signal W_op_srai :  STD_LOGIC;
                signal W_op_srl :  STD_LOGIC;
                signal W_op_srli :  STD_LOGIC;
                signal W_op_stb :  STD_LOGIC;
                signal W_op_stbio :  STD_LOGIC;
                signal W_op_stc :  STD_LOGIC;
                signal W_op_sth :  STD_LOGIC;
                signal W_op_sthio :  STD_LOGIC;
                signal W_op_stw :  STD_LOGIC;
                signal W_op_stwio :  STD_LOGIC;
                signal W_op_sub :  STD_LOGIC;
                signal W_op_sync :  STD_LOGIC;
                signal W_op_trap :  STD_LOGIC;
                signal W_op_wrctl :  STD_LOGIC;
                signal W_op_wrprs :  STD_LOGIC;
                signal W_op_xor :  STD_LOGIC;
                signal W_op_xorhi :  STD_LOGIC;
                signal W_op_xori :  STD_LOGIC;
                signal internal_A_wr_data_filtered :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_test_has_ended :  STD_LOGIC;
  file trace_handle : TEXT ;


begin

  W_op_call <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000000000")));
  W_op_jmpi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000000001")));
  W_op_ldbu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000000011")));
  W_op_addi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000000100")));
  W_op_stb <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000000101")));
  W_op_br <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000000110")));
  W_op_ldb <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000000111")));
  W_op_cmpgei <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000001000")));
  W_op_ldhu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000001011")));
  W_op_andi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000001100")));
  W_op_sth <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000001101")));
  W_op_bge <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000001110")));
  W_op_ldh <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000001111")));
  W_op_cmplti <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000010000")));
  W_op_initda <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000010011")));
  W_op_ori <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000010100")));
  W_op_stw <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000010101")));
  W_op_blt <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000010110")));
  W_op_ldw <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000010111")));
  W_op_cmpnei <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000011000")));
  W_op_flushda <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000011011")));
  W_op_xori <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000011100")));
  W_op_stc <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000011101")));
  W_op_bne <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000011110")));
  W_op_ldl <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000011111")));
  W_op_cmpeqi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000100000")));
  W_op_ldbuio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000100011")));
  W_op_muli <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000100100")));
  W_op_stbio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000100101")));
  W_op_beq <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000100110")));
  W_op_ldbio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000100111")));
  W_op_cmpgeui <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000101000")));
  W_op_ldhuio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000101011")));
  W_op_andhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000101100")));
  W_op_sthio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000101101")));
  W_op_bgeu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000101110")));
  W_op_ldhio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000101111")));
  W_op_cmpltui <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000110000")));
  W_op_initd <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000110011")));
  W_op_orhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000110100")));
  W_op_stwio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000110101")));
  W_op_bltu <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000110110")));
  W_op_ldwio <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000110111")));
  W_op_rdprs <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000111000")));
  W_op_flushd <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000111011")));
  W_op_xorhi <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000111100")));
  W_op_rsv02 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000000010")));
  W_op_rsv09 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000001001")));
  W_op_rsv10 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000001010")));
  W_op_rsv17 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000010001")));
  W_op_rsv18 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000010010")));
  W_op_rsv25 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000011001")));
  W_op_rsv26 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000011010")));
  W_op_rsv33 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000100001")));
  W_op_rsv34 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000100010")));
  W_op_rsv41 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000101001")));
  W_op_rsv42 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000101010")));
  W_op_rsv49 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000110001")));
  W_op_rsv57 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000111001")));
  W_op_rsv61 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000111101")));
  W_op_rsv62 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000111110")));
  W_op_rsv63 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000111111")));
  W_op_eret <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000000001"))));
  W_op_roli <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000000010"))));
  W_op_rol <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000000011"))));
  W_op_flushp <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000000100"))));
  W_op_ret <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000000101"))));
  W_op_nor <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000000110"))));
  W_op_mulxuu <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000000111"))));
  W_op_cmpge <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000001000"))));
  W_op_bret <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000001001"))));
  W_op_ror <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000001011"))));
  W_op_flushi <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000001100"))));
  W_op_jmp <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000001101"))));
  W_op_and <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000001110"))));
  W_op_cmplt <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000010000"))));
  W_op_slli <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000010010"))));
  W_op_sll <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000010011"))));
  W_op_wrprs <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000010100"))));
  W_op_or <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000010110"))));
  W_op_mulxsu <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000010111"))));
  W_op_cmpne <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000011000"))));
  W_op_srli <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000011010"))));
  W_op_srl <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000011011"))));
  W_op_nextpc <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000011100"))));
  W_op_callr <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000011101"))));
  W_op_xor <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000011110"))));
  W_op_mulxss <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000011111"))));
  W_op_cmpeq <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000100000"))));
  W_op_divu <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000100100"))));
  W_op_div <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000100101"))));
  W_op_rdctl <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000100110"))));
  W_op_mul <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000100111"))));
  W_op_cmpgeu <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000101000"))));
  W_op_initi <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000101001"))));
  W_op_trap <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000101101"))));
  W_op_wrctl <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000101110"))));
  W_op_cmpltu <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000110000"))));
  W_op_add <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000110001"))));
  W_op_break <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000110100"))));
  W_op_hbreak <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000110101"))));
  W_op_sync <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000110110"))));
  W_op_sub <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000111001"))));
  W_op_srai <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000111010"))));
  W_op_sra <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000111011"))));
  W_op_intr <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000111101"))));
  W_op_crst <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000111110"))));
  W_op_rsvx00 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000000000"))));
  W_op_rsvx10 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000001010"))));
  W_op_rsvx15 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000001111"))));
  W_op_rsvx17 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000010001"))));
  W_op_rsvx21 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000010101"))));
  W_op_rsvx25 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000011001"))));
  W_op_rsvx33 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000100001"))));
  W_op_rsvx34 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000100010"))));
  W_op_rsvx35 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000100011"))));
  W_op_rsvx42 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000101010"))));
  W_op_rsvx43 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000101011"))));
  W_op_rsvx44 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000101100"))));
  W_op_rsvx47 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000101111"))));
  W_op_rsvx50 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000110010"))));
  W_op_rsvx51 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000110011"))));
  W_op_rsvx55 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000110111"))));
  W_op_rsvx56 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000111000"))));
  W_op_rsvx60 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000111100"))));
  W_op_rsvx63 <= W_op_opx AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (W_iw_opx)) = std_logic_vector'("00000000000000000000000000111111"))));
  W_op_opx <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000111010")));
  W_op_custom <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (W_iw_op)) = std_logic_vector'("00000000000000000000000000110010")));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_target_pcb <= std_logic_vector'("00000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_target_pcb <= M_target_pcb;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      A_mem_baddr <= std_logic_vector'("00000000000000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'(A_en) = '1' then 
        A_mem_baddr <= M_mem_baddr;
      end if;
    end if;

  end process;

  E_src1_eq_src2 <= to_std_logic((E_logic_result = std_logic_vector'("00000000000000000000000000000000")));
  --Propagating 'X' data bits
  E_add_br_to_taken_history_filtered <= E_add_br_to_taken_history_unfiltered;
  --Propagating 'X' data bits
  M_bht_wr_en_filtered <= M_bht_wr_en_unfiltered;
  --Propagating 'X' data bits
  M_bht_wr_data_filtered <= M_bht_wr_data_unfiltered;
  --Propagating 'X' data bits
  M_bht_ptr_filtered <= M_bht_ptr_unfiltered;
  internal_test_has_ended <= std_logic'('0');
  --vhdl renameroo for output signals
  A_wr_data_filtered <= internal_A_wr_data_filtered;
  --vhdl renameroo for output signals
  test_has_ended <= internal_test_has_ended;
--synthesis translate_off
    --Clearing 'X' data bits
    A_wr_data_unfiltered_0_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(0))), '1','0');
    internal_A_wr_data_filtered(0) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_0_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(0));
    A_wr_data_unfiltered_1_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(1))), '1','0');
    internal_A_wr_data_filtered(1) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_1_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(1));
    A_wr_data_unfiltered_2_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(2))), '1','0');
    internal_A_wr_data_filtered(2) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_2_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(2));
    A_wr_data_unfiltered_3_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(3))), '1','0');
    internal_A_wr_data_filtered(3) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_3_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(3));
    A_wr_data_unfiltered_4_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(4))), '1','0');
    internal_A_wr_data_filtered(4) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_4_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(4));
    A_wr_data_unfiltered_5_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(5))), '1','0');
    internal_A_wr_data_filtered(5) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_5_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(5));
    A_wr_data_unfiltered_6_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(6))), '1','0');
    internal_A_wr_data_filtered(6) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_6_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(6));
    A_wr_data_unfiltered_7_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(7))), '1','0');
    internal_A_wr_data_filtered(7) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_7_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(7));
    A_wr_data_unfiltered_8_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(8))), '1','0');
    internal_A_wr_data_filtered(8) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_8_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(8));
    A_wr_data_unfiltered_9_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(9))), '1','0');
    internal_A_wr_data_filtered(9) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_9_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(9));
    A_wr_data_unfiltered_10_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(10))), '1','0');
    internal_A_wr_data_filtered(10) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_10_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(10));
    A_wr_data_unfiltered_11_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(11))), '1','0');
    internal_A_wr_data_filtered(11) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_11_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(11));
    A_wr_data_unfiltered_12_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(12))), '1','0');
    internal_A_wr_data_filtered(12) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_12_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(12));
    A_wr_data_unfiltered_13_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(13))), '1','0');
    internal_A_wr_data_filtered(13) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_13_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(13));
    A_wr_data_unfiltered_14_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(14))), '1','0');
    internal_A_wr_data_filtered(14) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_14_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(14));
    A_wr_data_unfiltered_15_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(15))), '1','0');
    internal_A_wr_data_filtered(15) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_15_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(15));
    A_wr_data_unfiltered_16_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(16))), '1','0');
    internal_A_wr_data_filtered(16) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_16_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(16));
    A_wr_data_unfiltered_17_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(17))), '1','0');
    internal_A_wr_data_filtered(17) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_17_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(17));
    A_wr_data_unfiltered_18_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(18))), '1','0');
    internal_A_wr_data_filtered(18) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_18_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(18));
    A_wr_data_unfiltered_19_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(19))), '1','0');
    internal_A_wr_data_filtered(19) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_19_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(19));
    A_wr_data_unfiltered_20_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(20))), '1','0');
    internal_A_wr_data_filtered(20) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_20_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(20));
    A_wr_data_unfiltered_21_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(21))), '1','0');
    internal_A_wr_data_filtered(21) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_21_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(21));
    A_wr_data_unfiltered_22_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(22))), '1','0');
    internal_A_wr_data_filtered(22) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_22_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(22));
    A_wr_data_unfiltered_23_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(23))), '1','0');
    internal_A_wr_data_filtered(23) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_23_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(23));
    A_wr_data_unfiltered_24_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(24))), '1','0');
    internal_A_wr_data_filtered(24) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_24_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(24));
    A_wr_data_unfiltered_25_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(25))), '1','0');
    internal_A_wr_data_filtered(25) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_25_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(25));
    A_wr_data_unfiltered_26_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(26))), '1','0');
    internal_A_wr_data_filtered(26) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_26_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(26));
    A_wr_data_unfiltered_27_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(27))), '1','0');
    internal_A_wr_data_filtered(27) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_27_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(27));
    A_wr_data_unfiltered_28_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(28))), '1','0');
    internal_A_wr_data_filtered(28) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_28_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(28));
    A_wr_data_unfiltered_29_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(29))), '1','0');
    internal_A_wr_data_filtered(29) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_29_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(29));
    A_wr_data_unfiltered_30_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(30))), '1','0');
    internal_A_wr_data_filtered(30) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_30_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(30));
    A_wr_data_unfiltered_31_is_x <= A_WE_StdLogic(is_x(std_ulogic(A_wr_data_unfiltered(31))), '1','0');
    internal_A_wr_data_filtered(31) <= A_WE_StdLogic((std_logic'(((A_wr_data_unfiltered_31_is_x AND (A_ctrl_ld_non_io)))) = '1'), std_logic'('0'), A_wr_data_unfiltered(31));
    process (clk)
    VARIABLE write_line : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(reset_n) = '1' then 
          if is_x(std_ulogic(W_wr_dst_reg)) then 
            write(write_line, now);
            write(write_line, string'(": "));
            write(write_line, string'("ERROR: cpu_test_bench/W_wr_dst_reg is 'x'"));
            write(output, write_line.all & CR);
            deallocate (write_line);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    process (clk, reset_n)
    VARIABLE write_line1 : line;
    begin
      if reset_n = '0' then
      elsif clk'event and clk = '1' then
        if std_logic'(W_wr_dst_reg) = '1' then 
          if is_x(W_dst_regnum) then 
            write(write_line1, now);
            write(write_line1, string'(": "));
            write(write_line1, string'("ERROR: cpu_test_bench/W_dst_regnum is 'x'"));
            write(output, write_line1.all & CR);
            deallocate (write_line1);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    process (clk)
    VARIABLE write_line2 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(reset_n) = '1' then 
          if is_x(std_ulogic(W_valid)) then 
            write(write_line2, now);
            write(write_line2, string'(": "));
            write(write_line2, string'("ERROR: cpu_test_bench/W_valid is 'x'"));
            write(output, write_line2.all & CR);
            deallocate (write_line2);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    process (clk, reset_n)
    VARIABLE write_line3 : line;
    begin
      if reset_n = '0' then
      elsif clk'event and clk = '1' then
        if std_logic'(W_valid) = '1' then 
          if is_x(W_pcb) then 
            write(write_line3, now);
            write(write_line3, string'(": "));
            write(write_line3, string'("ERROR: cpu_test_bench/W_pcb is 'x'"));
            write(output, write_line3.all & CR);
            deallocate (write_line3);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    process (clk, reset_n)
    VARIABLE write_line4 : line;
    begin
      if reset_n = '0' then
      elsif clk'event and clk = '1' then
        if std_logic'(W_valid) = '1' then 
          if is_x(W_iw) then 
            write(write_line4, now);
            write(write_line4, string'(": "));
            write(write_line4, string'("ERROR: cpu_test_bench/W_iw is 'x'"));
            write(output, write_line4.all & CR);
            deallocate (write_line4);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    process (clk)
    VARIABLE write_line5 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(reset_n) = '1' then 
          if is_x(std_ulogic(A_en)) then 
            write(write_line5, now);
            write(write_line5, string'(": "));
            write(write_line5, string'("ERROR: cpu_test_bench/A_en is 'x'"));
            write(output, write_line5.all & CR);
            deallocate (write_line5);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    process (clk)
    VARIABLE write_line6 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(reset_n) = '1' then 
          if is_x(std_ulogic(E_valid)) then 
            write(write_line6, now);
            write(write_line6, string'(": "));
            write(write_line6, string'("ERROR: cpu_test_bench/E_valid is 'x'"));
            write(output, write_line6.all & CR);
            deallocate (write_line6);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    process (clk)
    VARIABLE write_line7 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(reset_n) = '1' then 
          if is_x(std_ulogic(M_valid)) then 
            write(write_line7, now);
            write(write_line7, string'(": "));
            write(write_line7, string'("ERROR: cpu_test_bench/M_valid is 'x'"));
            write(output, write_line7.all & CR);
            deallocate (write_line7);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    process (clk)
    VARIABLE write_line8 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(reset_n) = '1' then 
          if is_x(std_ulogic(A_valid)) then 
            write(write_line8, now);
            write(write_line8, string'(": "));
            write(write_line8, string'("ERROR: cpu_test_bench/A_valid is 'x'"));
            write(output, write_line8.all & CR);
            deallocate (write_line8);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    process (clk, reset_n)
    VARIABLE write_line9 : line;
    begin
      if reset_n = '0' then
      elsif clk'event and clk = '1' then
        if std_logic'(((A_valid AND A_en) AND A_wr_dst_reg)) = '1' then 
          if is_x(A_wr_data_unfiltered) then 
            write(write_line9, now);
            write(write_line9, string'(": "));
            write(write_line9, string'("WARNING: cpu_test_bench/A_wr_data_unfiltered is 'x'"));
            write(output, write_line9.all & CR);
            deallocate (write_line9);
          end if;
        end if;
      end if;

    end process;

    process (clk)
    VARIABLE write_line10 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(reset_n) = '1' then 
          if is_x(A_status_reg) then 
            write(write_line10, now);
            write(write_line10, string'(": "));
            write(write_line10, string'("ERROR: cpu_test_bench/A_status_reg is 'x'"));
            write(output, write_line10.all & CR);
            deallocate (write_line10);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    process (clk)
    VARIABLE write_line11 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(reset_n) = '1' then 
          if is_x(A_estatus_reg) then 
            write(write_line11, now);
            write(write_line11, string'(": "));
            write(write_line11, string'("ERROR: cpu_test_bench/A_estatus_reg is 'x'"));
            write(output, write_line11.all & CR);
            deallocate (write_line11);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    process (clk)
    VARIABLE write_line12 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(reset_n) = '1' then 
          if is_x(A_bstatus_reg) then 
            write(write_line12, now);
            write(write_line12, string'(": "));
            write(write_line12, string'("ERROR: cpu_test_bench/A_bstatus_reg is 'x'"));
            write(output, write_line12.all & CR);
            deallocate (write_line12);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    process (clk)
    VARIABLE write_line13 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(reset_n) = '1' then 
          if is_x(std_ulogic(i_read)) then 
            write(write_line13, now);
            write(write_line13, string'(": "));
            write(write_line13, string'("ERROR: cpu_test_bench/i_read is 'x'"));
            write(output, write_line13.all & CR);
            deallocate (write_line13);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    process (clk, reset_n)
    VARIABLE write_line14 : line;
    begin
      if reset_n = '0' then
      elsif clk'event and clk = '1' then
        if std_logic'(i_read) = '1' then 
          if is_x(i_address) then 
            write(write_line14, now);
            write(write_line14, string'(": "));
            write(write_line14, string'("ERROR: cpu_test_bench/i_address is 'x'"));
            write(output, write_line14.all & CR);
            deallocate (write_line14);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    process (clk)
    VARIABLE write_line15 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(reset_n) = '1' then 
          if is_x(std_ulogic(i_readdatavalid)) then 
            write(write_line15, now);
            write(write_line15, string'(": "));
            write(write_line15, string'("ERROR: cpu_test_bench/i_readdatavalid is 'x'"));
            write(output, write_line15.all & CR);
            deallocate (write_line15);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    process (clk)
    VARIABLE write_line16 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(reset_n) = '1' then 
          if is_x(std_ulogic(d_write)) then 
            write(write_line16, now);
            write(write_line16, string'(": "));
            write(write_line16, string'("ERROR: cpu_test_bench/d_write is 'x'"));
            write(output, write_line16.all & CR);
            deallocate (write_line16);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    process (clk, reset_n)
    VARIABLE write_line17 : line;
    begin
      if reset_n = '0' then
      elsif clk'event and clk = '1' then
        if std_logic'(d_write) = '1' then 
          if is_x(d_byteenable) then 
            write(write_line17, now);
            write(write_line17, string'(": "));
            write(write_line17, string'("ERROR: cpu_test_bench/d_byteenable is 'x'"));
            write(output, write_line17.all & CR);
            deallocate (write_line17);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    process (clk, reset_n)
    VARIABLE write_line18 : line;
    begin
      if reset_n = '0' then
      elsif clk'event and clk = '1' then
        if std_logic'((d_write OR d_read)) = '1' then 
          if is_x(d_address) then 
            write(write_line18, now);
            write(write_line18, string'(": "));
            write(write_line18, string'("ERROR: cpu_test_bench/d_address is 'x'"));
            write(output, write_line18.all & CR);
            deallocate (write_line18);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    process (clk)
    VARIABLE write_line19 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(reset_n) = '1' then 
          if is_x(std_ulogic(d_read)) then 
            write(write_line19, now);
            write(write_line19, string'(": "));
            write(write_line19, string'("ERROR: cpu_test_bench/d_read is 'x'"));
            write(output, write_line19.all & CR);
            deallocate (write_line19);
            assert false report "VHDL STOP" severity failure;
          end if;
        end if;
      end if;

    end process;

    
    process is
      variable status : file_open_status; -- status for fopen
    VARIABLE write_line20 : line;
    VARIABLE write_line21 : line;
    
    begin  -- process
      file_open(status, trace_handle, "cpu.tr", WRITE_MODE);
      write(write_line20, string'("version 3"));
    write(trace_handle, write_line20.all & LF);
    deallocate (write_line20);
    write(write_line21, string'("numThreads 1"));
    write(trace_handle, write_line21.all & LF);
    deallocate (write_line21);
    
      wait;                               -- wait forever
    end process;
    process (clk)
    VARIABLE write_line22 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((((NOT reset_n OR ((A_valid AND A_en)))) AND NOT internal_test_has_ended)) = '1' then 
          write(write_line22, now);
          write(write_line22, string'(": "));
          write(write_line22, to_hex_string(NOT reset_n, pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(A_pcb, pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(std_logic_vector'("00000000000000000000000000000000"), pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(A_op_intr, pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(A_op_hbreak, pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(A_iw, pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(NOT ((A_op_intr OR A_op_hbreak)), pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(A_wr_dst_reg, pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(A_dst_regnum, pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(std_logic_vector'("00000000000000000000000000000000"), pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(internal_A_wr_data_filtered, pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(A_mem_baddr, pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(A_st_data, pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(A_mem_byte_en, pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(A_cmp_result, pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(A_target_pcb, pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(A_status_reg, pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(A_estatus_reg, pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(A_bstatus_reg, pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(A_ienable_reg, pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(A_ipending_reg, pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(std_logic_vector'("00000000000000000000000000000000"), pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(std_logic_vector'("00000000000000000000000000000000"), pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(std_logic_vector'("00000000000000000000000000000000"), pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(std_logic_vector'("00000000000000000000000000000000"), pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(std_logic_vector'("00000000000000000000000000000000"), pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(std_logic_vector'("00000000000000000000000000000000"), pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(std_logic_vector'("00000000000000000000000000000000"), pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(std_logic_vector'("00000000000000000000000000000000"), pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(std_logic_vector'("00000000000000000000000000000000"), pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(std_logic_vector'("00000000000000000000000000000000"), pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(A_WE_StdLogicVector((std_logic'(A_ctrl_exception) = '1'), std_logic_vector'("00000000000000000000000000000001"), std_logic_vector'("00000000000000000000000000000000")), pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(std_logic_vector'("00000000000000000000000000000000"), pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(std_logic_vector'("00000000000000000000000000000000"), pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(std_logic_vector'("00000000000000000000000000000000"), pad_none));
          write(write_line22, string'(","));
          write(write_line22, to_hex_string(std_logic_vector'("00000000000000000000000000000000"), pad_none));
          write(write_line22, string'(""));
          write(trace_handle, write_line22.all & LF);
          deallocate (write_line22);
        end if;
      end if;

    end process;

--synthesis translate_on
--synthesis read_comments_as_HDL on
--    
--    internal_A_wr_data_filtered <= A_wr_data_unfiltered;
--synthesis read_comments_as_HDL off

end europa;

