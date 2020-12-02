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

--synthesis translate_off

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

entity sdram_test_component_ram_module is 
        port (
              -- inputs:
                 signal data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal rdaddress : IN STD_LOGIC_VECTOR (21 DOWNTO 0);
                 signal rdclken : IN STD_LOGIC;
                 signal wraddress : IN STD_LOGIC_VECTOR (21 DOWNTO 0);
                 signal wrclock : IN STD_LOGIC;
                 signal wren : IN STD_LOGIC;

              -- outputs:
                 signal q : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
              );
end entity sdram_test_component_ram_module;


architecture europa of sdram_test_component_ram_module is
              signal internal_q :  STD_LOGIC_VECTOR (15 DOWNTO 0);
              TYPE mem_array is ARRAY( 4194303 DOWNTO 0) of STD_LOGIC_VECTOR(15 DOWNTO 0);
              signal memory_has_been_read :  STD_LOGIC;
              signal read_address :  STD_LOGIC_VECTOR (21 DOWNTO 0);

      
FUNCTION convert_string_to_number(string_to_convert : STRING;
      final_char_index : NATURAL := 0)
RETURN NATURAL IS
   VARIABLE result: NATURAL := 0;
   VARIABLE current_index : NATURAL := 1;
   VARIABLE the_char : CHARACTER;

   BEGIN
      IF final_char_index = 0 THEN
         result := 0;
	 ELSE
         WHILE current_index <= final_char_index LOOP
            the_char := string_to_convert(current_index);
            IF    '0' <= the_char AND the_char <= '9' THEN
               result := result * 16 + character'pos(the_char) - character'pos('0');
            ELSIF 'A' <= the_char AND the_char <= 'F' THEN
               result := result * 16 + character'pos(the_char) - character'pos('A') + 10;
            ELSIF 'a' <= the_char AND the_char <= 'f' THEN
               result := result * 16 + character'pos(the_char) - character'pos('a') + 10;
            ELSE
               report "Ack, a formatting error!";
            END IF;
            current_index := current_index + 1;
         END LOOP;
      END IF; 
   RETURN result;
END convert_string_to_number;

 FUNCTION convert_string_to_std_logic(value : STRING; num_chars : INTEGER; mem_width_bits : INTEGER)
 RETURN STD_LOGIC_VECTOR is			   
     VARIABLE conv_string: std_logic_vector((mem_width_bits + 4)-1 downto 0);
     VARIABLE result : std_logic_vector((mem_width_bits -1) downto 0);
     VARIABLE curr_char : integer;
              
     BEGIN
     result := (others => '0');
     conv_string := (others => '0');
     
          FOR I IN 1 TO num_chars LOOP
	     curr_char := num_chars - (I-1);

             CASE value(I) IS
               WHEN '0' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0000";
               WHEN '1' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0001";
               WHEN '2' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0010";
               WHEN '3' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0011";
               WHEN '4' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0100";
               WHEN '5' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0101";
               WHEN '6' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0110";
               WHEN '7' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0111";
               WHEN '8' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1000";
               WHEN '9' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1001";
               WHEN 'A' | 'a' => conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1010";
               WHEN 'B' | 'b' => conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1011";
               WHEN 'C' | 'c' => conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1100";
               WHEN 'D' | 'd' => conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1101";
               WHEN 'E' | 'e' => conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1110";
               WHEN 'F' | 'f' => conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1111";
               WHEN 'X' | 'x' => conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "XXXX";
               WHEN ' ' => EXIT;
               WHEN HT  => exit;
               WHEN others =>
                  ASSERT False
                  REPORT "function From_Hex: string """ & value & """ contains non-hex character"
                       severity Error;
                  EXIT;
               END case;
            END loop;

          -- convert back to normal bit size
          result(mem_width_bits - 1 downto 0) := conv_string(mem_width_bits - 1 downto 0);

          RETURN result;
        END convert_string_to_std_logic;



begin
   process (wrclock, rdaddress) -- MG
    VARIABLE data_line : LINE;
    VARIABLE the_character_from_data_line : CHARACTER;
    VARIABLE b_munging_address : BOOLEAN := FALSE;
    VARIABLE converted_number : NATURAL := 0;
    VARIABLE found_string_array : STRING(1 TO 128);
    VARIABLE string_index : NATURAL := 0;
    VARIABLE line_length : NATURAL := 0;
    VARIABLE b_convert : BOOLEAN := FALSE;
    VARIABLE b_found_new_val : BOOLEAN := FALSE;
    VARIABLE load_address : NATURAL := 0;
    VARIABLE mem_index : NATURAL := 0;
    VARIABLE mem_init : BOOLEAN := FALSE;

    VARIABLE wr_address_internal : STD_LOGIC_VECTOR (21 DOWNTO 0) := (others => '0');
    FILE memory_contents_file : TEXT OPEN read_mode IS "sdram.dat";  
    variable Marc_Gaucherons_Memory_Variable : mem_array; -- MG
    
    begin
   -- need an initialization process
   -- this process initializes the whole memory array from a named file by copying the
   -- contents of the *.dat file to the memory array.

   -- find the @<address> thingy to load the memory from this point 
IF(NOT mem_init) THEN
   WHILE NOT(endfile(memory_contents_file)) LOOP

      readline(memory_contents_file, data_line);
      line_length := data_line'LENGTH;


      WHILE line_length > 0 LOOP
         read(data_line, the_character_from_data_line);

	       -- check for the @ character indicating a new address wad
 	       -- if not found, we're either still reading the new address _or_loading data
         IF '@' = the_character_from_data_line AND NOT b_munging_address THEN
  	    b_munging_address := TRUE;
            b_found_new_val := TRUE; 
	    -- get the rest of characters before white space and then convert them
	    -- to a number
	 ELSE 

            IF (' ' = the_character_from_data_line AND b_found_new_val) 
		OR (line_length = 1) THEN
               b_convert := TRUE;
	    END IF;

            IF NOT(' ' = the_character_from_data_line) THEN
               string_index := string_index + 1;
               found_string_array(string_index) := the_character_from_data_line;
--               IF NOT(b_munging_address) THEN
--                 dat_string_array(string_index) := the_character_from_data_line;
--               END IF;
	       b_found_new_val := TRUE;
            END IF;
	 END IF;

     IF b_convert THEN

       IF b_munging_address THEN
          converted_number := convert_string_to_number(found_string_array, string_index);    
          load_address := converted_number;
          mem_index := load_address;
--          mem_index := load_address / 2;
          b_munging_address := FALSE;
       ELSE
	  IF (mem_index < 4194304) THEN
	    Marc_Gaucherons_Memory_Variable(mem_index) := convert_string_to_std_logic(found_string_array, string_index, 16);
            mem_index := mem_index + 1;
          END IF;
       END IF; 
       b_convert := FALSE;
       b_found_new_val := FALSE;
       string_index := 0;
    END IF;
    line_length := line_length - 1; 
    END LOOP;

END LOOP;
-- get the first _real_ block of data, sized to our memory width
-- and keep on loading.
  mem_init := TRUE;
END IF;
-- END OF READMEM



      -- Write data
      if wrclock'event and wrclock = '1' then
        wr_address_internal := wraddress;
        if wren = '1' then 
          Marc_Gaucherons_Memory_Variable(CONV_INTEGER(UNSIGNED(wr_address_internal))) := data;
        end if;
      end if;

      -- read data
      q <= Marc_Gaucherons_Memory_Variable(CONV_INTEGER(UNSIGNED(rdaddress)));
      


    end process;
end europa;

--synthesis translate_on


--synthesis read_comments_as_HDL on
--library altera;
--use altera.altera_europa_support_lib.all;
--
--library altera_mf;
--use altera_mf.altera_mf_components.all;
--
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
--
--library std;
--use std.textio.all;
--
--entity sdram_test_component_ram_module is 
--        port (
--              
--                 signal data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
--                 signal rdaddress : IN STD_LOGIC_VECTOR (21 DOWNTO 0);
--                 signal rdclken : IN STD_LOGIC;
--                 signal wraddress : IN STD_LOGIC_VECTOR (21 DOWNTO 0);
--                 signal wrclock : IN STD_LOGIC;
--                 signal wren : IN STD_LOGIC;
--
--              
--                 signal q : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
--              );
--end entity sdram_test_component_ram_module;
--
--
--architecture europa of sdram_test_component_ram_module is
--  component lpm_ram_dp is
--GENERIC (
--      lpm_file : STRING;
--        lpm_hint : STRING;
--        lpm_indata : STRING;
--        lpm_outdata : STRING;
--        lpm_rdaddress_control : STRING;
--        lpm_width : NATURAL;
--        lpm_widthad : NATURAL;
--        lpm_wraddress_control : STRING;
--        suppress_memory_conversion_warnings : STRING
--      );
--    PORT (
--    signal q : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
--        signal rdaddress : IN STD_LOGIC_VECTOR (21 DOWNTO 0);
--        signal wren : IN STD_LOGIC;
--        signal wrclock : IN STD_LOGIC;
--        signal wraddress : IN STD_LOGIC_VECTOR (21 DOWNTO 0);
--        signal data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
--        signal rdclken : IN STD_LOGIC
--      );
--  end component lpm_ram_dp;
--                signal internal_q :  STD_LOGIC_VECTOR (15 DOWNTO 0);
--                TYPE mem_array is ARRAY( 4194303 DOWNTO 0) of STD_LOGIC_VECTOR(15 DOWNTO 0);
--                signal memory_has_been_read :  STD_LOGIC;
--                signal read_address :  STD_LOGIC_VECTOR (21 DOWNTO 0);
--
--begin
--
--  process (rdaddress)
--  begin
--      read_address <= rdaddress;
--
--  end process;
--
--  lpm_ram_dp_component : lpm_ram_dp
--    generic map(
--      lpm_file => "UNUSED",
--      lpm_hint => "USE_EAB=ON",
--      lpm_indata => "REGISTERED",
--      lpm_outdata => "UNREGISTERED",
--      lpm_rdaddress_control => "UNREGISTERED",
--      lpm_width => 16,
--      lpm_widthad => 22,
--      lpm_wraddress_control => "REGISTERED",
--      suppress_memory_conversion_warnings => "ON"
--    )
--    port map(
--            data => data,
--            q => internal_q,
--            rdaddress => read_address,
--            rdclken => rdclken,
--            wraddress => wraddress,
--            wrclock => wrclock,
--            wren => wren
--    );
--
--  
--  q <= internal_q;
--end europa;
--
--synthesis read_comments_as_HDL off


-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 



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

entity sdram_test_component is 
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
end entity sdram_test_component;


architecture europa of sdram_test_component is
component sdram_test_component_ram_module is 
           port (
                 -- inputs:
                    signal data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal rdaddress : IN STD_LOGIC_VECTOR (21 DOWNTO 0);
                    signal rdclken : IN STD_LOGIC;
                    signal wraddress : IN STD_LOGIC_VECTOR (21 DOWNTO 0);
                    signal wrclock : IN STD_LOGIC;
                    signal wren : IN STD_LOGIC;

                 -- outputs:
                    signal q : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component sdram_test_component_ram_module;

                signal CODE :  STD_LOGIC_VECTOR (23 DOWNTO 0);
                signal a :  STD_LOGIC_VECTOR (11 DOWNTO 0);
                signal addr_col :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal addr_crb :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal ba :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cas_n :  STD_LOGIC;
                signal cke :  STD_LOGIC;
                signal cmd_code :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal cs_n :  STD_LOGIC;
                signal dqm :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal index :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal latency :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal mask :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal mem_bytes :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal module_input :  STD_LOGIC_VECTOR (21 DOWNTO 0);
                signal module_input1 :  STD_LOGIC;
                signal module_input2 :  STD_LOGIC;
                signal ras_n :  STD_LOGIC;
                signal rd_addr_pipe_0 :  STD_LOGIC_VECTOR (21 DOWNTO 0);
                signal rd_addr_pipe_1 :  STD_LOGIC_VECTOR (21 DOWNTO 0);
                signal rd_addr_pipe_2 :  STD_LOGIC_VECTOR (21 DOWNTO 0);
                signal rd_mask_pipe_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal rd_mask_pipe_1 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal rd_mask_pipe_2 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal rd_valid_pipe :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal read_addr :  STD_LOGIC_VECTOR (21 DOWNTO 0);
                signal read_data :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal read_mask :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal read_temp :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal read_valid :  STD_LOGIC;
                signal rmw_temp :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal test_addr :  STD_LOGIC_VECTOR (21 DOWNTO 0);
                signal txt_code :  STD_LOGIC_VECTOR (23 DOWNTO 0);
                signal we_n :  STD_LOGIC;

begin

  process
VARIABLE write_line : line;
VARIABLE write_line1 : line;
VARIABLE write_line2 : line;
VARIABLE write_line3 : line;
VARIABLE write_line4 : line;

    begin
      write(write_line, string'("************************************************************"));
      write(output, write_line.all & CR);
      deallocate (write_line);
      write(write_line1, string'("This testbench includes an SOPC Builder Generated Altera model:"));
      write(output, write_line1.all & CR);
      deallocate (write_line1);
      write(write_line2, string'("'sdram_test_component.vhd', to simulate accesses to SDRAM."));
      write(output, write_line2.all & CR);
      deallocate (write_line2);
      write(write_line3, string'("Initial contents are loaded from the file: 'sdram.dat'."));
      write(output, write_line3.all & CR);
      deallocate (write_line3);
      write(write_line4, string'("************************************************************"));
      write(output, write_line4.all & CR);
      deallocate (write_line4);
    wait;
  end process;
  --Synchronous write when (CODE == 24'h205752 (write))
  sdram_test_component_ram : sdram_test_component_ram_module
    port map(
      q => read_data,
      data => rmw_temp,
      rdaddress => module_input,
      rdclken => module_input1,
      wraddress => test_addr,
      wrclock => clk,
      wren => module_input2
    );

  module_input <= A_WE_StdLogicVector(((CODE = std_logic_vector'("001000000101011101010010"))), test_addr, read_addr);
  module_input1 <= std_logic'('1');
  module_input2 <= to_std_logic((CODE = std_logic_vector'("001000000101011101010010")));

  cke <= zs_cke;
  cs_n <= zs_cs_n;
  ras_n <= zs_ras_n;
  cas_n <= zs_cas_n;
  we_n <= zs_we_n;
  dqm <= zs_dqm;
  ba <= zs_ba;
  a <= zs_addr;
  cmd_code <= Std_Logic_Vector'(A_ToStdLogicVector(ras_n) & A_ToStdLogicVector(cas_n) & A_ToStdLogicVector(we_n));
  CODE <= A_WE_StdLogicVector((std_logic'((cs_n)) = '1'), std_logic_vector'("010010010100111001001000"), txt_code);
  addr_col <= a(7 DOWNTO 0);
  test_addr <= addr_crb & addr_col;
  mem_bytes <= read_data;
  rmw_temp(7 DOWNTO 0) <= A_WE_StdLogicVector((std_logic'(dqm(0)) = '1'), mem_bytes(7 DOWNTO 0), zs_dq(7 DOWNTO 0));
  rmw_temp(15 DOWNTO 8) <= A_WE_StdLogicVector((std_logic'(dqm(1)) = '1'), mem_bytes(15 DOWNTO 8), zs_dq(15 DOWNTO 8));
  -- Handle Input.
  process (clk)
  begin
    if clk'event and clk = '1' then
      -- No Activity of Clock Disabled
      if std_logic'(cke) = '1' then 
        -- LMR: Get CAS_Latency.
        if CODE = std_logic_vector'("010011000100110101010010") then 
          latency <= a(6 DOWNTO 4);
        end if;
        -- ACT: Get Row/Bank Address.
        if CODE = std_logic_vector'("010000010100001101010100") then 
          addr_crb <= Std_Logic_Vector'(A_ToStdLogicVector(ba(1)) & a & A_ToStdLogicVector(ba(0)));
        end if;
        rd_valid_pipe(2) <= rd_valid_pipe(1);
        rd_valid_pipe(1) <= rd_valid_pipe(0);
        rd_valid_pipe(0) <= to_std_logic((CODE = std_logic_vector'("001000000101001001000100")));
        rd_addr_pipe_2 <= rd_addr_pipe_1;
        rd_addr_pipe_1 <= rd_addr_pipe_0;
        rd_addr_pipe_0 <= test_addr;
        rd_mask_pipe_2 <= rd_mask_pipe_1;
        rd_mask_pipe_1 <= rd_mask_pipe_0;
        rd_mask_pipe_0 <= dqm;
      end if;
    end if;

  end process;

  read_temp(7 DOWNTO 0) <= A_WE_StdLogicVector((std_logic'(mask(0)) = '1'), std_logic_vector'("ZZZZZZZZ"), read_data(7 DOWNTO 0));
  read_temp(15 DOWNTO 8) <= A_WE_StdLogicVector((std_logic'(mask(1)) = '1'), std_logic_vector'("ZZZZZZZZ"), read_data(15 DOWNTO 8));
  --use index to select which pipeline stage drives addr
  read_addr <= A_WE_StdLogicVector((((std_logic_vector'("00000000000000000000000000000") & (index)) = std_logic_vector'("00000000000000000000000000000000"))), rd_addr_pipe_0, A_WE_StdLogicVector((((std_logic_vector'("00000000000000000000000000000") & (index)) = std_logic_vector'("00000000000000000000000000000001"))), rd_addr_pipe_1, rd_addr_pipe_2));
  --use index to select which pipeline stage drives mask
  read_mask <= A_WE_StdLogicVector((((std_logic_vector'("00000000000000000000000000000") & (index)) = std_logic_vector'("00000000000000000000000000000000"))), rd_mask_pipe_0, A_WE_StdLogicVector((((std_logic_vector'("00000000000000000000000000000") & (index)) = std_logic_vector'("00000000000000000000000000000001"))), rd_mask_pipe_1, rd_mask_pipe_2));
  --use index to select which pipeline stage drives valid
  read_valid <= A_WE_StdLogic((((std_logic_vector'("00000000000000000000000000000") & (index)) = std_logic_vector'("00000000000000000000000000000000"))), rd_valid_pipe(0), A_WE_StdLogic((((std_logic_vector'("00000000000000000000000000000") & (index)) = std_logic_vector'("00000000000000000000000000000001"))), rd_valid_pipe(1), rd_valid_pipe(2)));
  index <= A_EXT (((std_logic_vector'("0") & (latency)) - (std_logic_vector'("000") & (A_TOSTDLOGICVECTOR(std_logic'('1'))))), 3);
  mask <= read_mask;
  zs_dq <= A_WE_StdLogicVector((std_logic'(read_valid) = '1'), read_temp, A_REP(std_logic'('Z'), 16));
--synthesis translate_off
    txt_code <= A_WE_StdLogicVector(((cmd_code = std_logic_vector'("000"))), std_logic_vector'("010011000100110101010010"), A_WE_StdLogicVector(((cmd_code = std_logic_vector'("001"))), std_logic_vector'("010000010101001001000110"), A_WE_StdLogicVector(((cmd_code = std_logic_vector'("010"))), std_logic_vector'("010100000101001001000101"), A_WE_StdLogicVector(((cmd_code = std_logic_vector'("011"))), std_logic_vector'("010000010100001101010100"), A_WE_StdLogicVector(((cmd_code = std_logic_vector'("100"))), std_logic_vector'("001000000101011101010010"), A_WE_StdLogicVector(((cmd_code = std_logic_vector'("101"))), std_logic_vector'("001000000101001001000100"), A_WE_StdLogicVector(((cmd_code = std_logic_vector'("110"))), std_logic_vector'("010000100101001101010100"), A_WE_StdLogicVector(((cmd_code = std_logic_vector'("111"))), std_logic_vector'("010011100100111101010000"), std_logic_vector'("010000100100000101000100")))))))));
--synthesis translate_on

end europa;

