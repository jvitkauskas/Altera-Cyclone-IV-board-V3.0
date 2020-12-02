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

entity pipeline_bridge_downstream_adapter is 
        port (
              -- inputs:
                 signal m1_clk : IN STD_LOGIC;
                 signal m1_endofpacket : IN STD_LOGIC;
                 signal m1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal m1_readdatavalid : IN STD_LOGIC;
                 signal m1_reset_n : IN STD_LOGIC;
                 signal m1_waitrequest : IN STD_LOGIC;
                 signal s1_address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
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
                 signal m1_arbiterlock : OUT STD_LOGIC;
                 signal m1_arbiterlock2 : OUT STD_LOGIC;
                 signal m1_burstcount : OUT STD_LOGIC;
                 signal m1_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal m1_chipselect : OUT STD_LOGIC;
                 signal m1_debugaccess : OUT STD_LOGIC;
                 signal m1_nativeaddress : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
                 signal m1_read : OUT STD_LOGIC;
                 signal m1_write : OUT STD_LOGIC;
                 signal m1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s1_endofpacket : OUT STD_LOGIC;
                 signal s1_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s1_readdatavalid : OUT STD_LOGIC;
                 signal s1_waitrequest : OUT STD_LOGIC
              );
end entity pipeline_bridge_downstream_adapter;


architecture europa of pipeline_bridge_downstream_adapter is

begin

  --s1, which is an e_avalon_adapter_slave
  --m1, which is an e_avalon_adapter_master
  s1_endofpacket <= m1_endofpacket;
  s1_readdata <= m1_readdata;
  s1_readdatavalid <= m1_readdatavalid;
  s1_waitrequest <= m1_waitrequest;
  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      m1_address <= std_logic_vector'("00000000");
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(NOT m1_waitrequest) = '1' then 
        m1_address <= s1_address;
      end if;
    end if;

  end process;

  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      m1_arbiterlock <= std_logic'('0');
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(NOT m1_waitrequest) = '1' then 
        m1_arbiterlock <= s1_arbiterlock;
      end if;
    end if;

  end process;

  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      m1_arbiterlock2 <= std_logic'('0');
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(NOT m1_waitrequest) = '1' then 
        m1_arbiterlock2 <= s1_arbiterlock2;
      end if;
    end if;

  end process;

  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      m1_burstcount <= std_logic'('0');
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(NOT m1_waitrequest) = '1' then 
        m1_burstcount <= s1_burstcount;
      end if;
    end if;

  end process;

  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      m1_byteenable <= std_logic_vector'("0000");
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(NOT m1_waitrequest) = '1' then 
        m1_byteenable <= s1_byteenable;
      end if;
    end if;

  end process;

  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      m1_chipselect <= std_logic'('0');
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(NOT m1_waitrequest) = '1' then 
        m1_chipselect <= s1_chipselect;
      end if;
    end if;

  end process;

  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      m1_debugaccess <= std_logic'('0');
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(NOT m1_waitrequest) = '1' then 
        m1_debugaccess <= s1_debugaccess;
      end if;
    end if;

  end process;

  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      m1_nativeaddress <= std_logic_vector'("000000");
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(NOT m1_waitrequest) = '1' then 
        m1_nativeaddress <= s1_nativeaddress;
      end if;
    end if;

  end process;

  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      m1_read <= std_logic'('0');
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(NOT m1_waitrequest) = '1' then 
        m1_read <= s1_read;
      end if;
    end if;

  end process;

  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      m1_write <= std_logic'('0');
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(NOT m1_waitrequest) = '1' then 
        m1_write <= s1_write;
      end if;
    end if;

  end process;

  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      m1_writedata <= std_logic_vector'("00000000000000000000000000000000");
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(NOT m1_waitrequest) = '1' then 
        m1_writedata <= s1_writedata;
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

entity pipeline_bridge_upstream_adapter is 
        port (
              -- inputs:
                 signal m1_clk : IN STD_LOGIC;
                 signal m1_endofpacket : IN STD_LOGIC;
                 signal m1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal m1_readdatavalid : IN STD_LOGIC;
                 signal m1_reset_n : IN STD_LOGIC;
                 signal m1_waitrequest : IN STD_LOGIC;
                 signal s1_address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal s1_arbiterlock : IN STD_LOGIC;
                 signal s1_arbiterlock2 : IN STD_LOGIC;
                 signal s1_burstcount : IN STD_LOGIC;
                 signal s1_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal s1_chipselect : IN STD_LOGIC;
                 signal s1_clk : IN STD_LOGIC;
                 signal s1_debugaccess : IN STD_LOGIC;
                 signal s1_flush : IN STD_LOGIC;
                 signal s1_nativeaddress : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
                 signal s1_read : IN STD_LOGIC;
                 signal s1_reset_n : IN STD_LOGIC;
                 signal s1_write : IN STD_LOGIC;
                 signal s1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal m1_address : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal m1_arbiterlock : OUT STD_LOGIC;
                 signal m1_arbiterlock2 : OUT STD_LOGIC;
                 signal m1_burstcount : OUT STD_LOGIC;
                 signal m1_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal m1_chipselect : OUT STD_LOGIC;
                 signal m1_debugaccess : OUT STD_LOGIC;
                 signal m1_nativeaddress : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
                 signal m1_read : OUT STD_LOGIC;
                 signal m1_write : OUT STD_LOGIC;
                 signal m1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s1_endofpacket : OUT STD_LOGIC;
                 signal s1_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s1_readdatavalid : OUT STD_LOGIC;
                 signal s1_waitrequest : OUT STD_LOGIC
              );
end entity pipeline_bridge_upstream_adapter;


architecture europa of pipeline_bridge_upstream_adapter is

begin

  --s1, which is an e_avalon_adapter_slave
  --m1, which is an e_avalon_adapter_master
  process (s1_clk, s1_reset_n)
  begin
    if s1_reset_n = '0' then
      s1_readdatavalid <= std_logic'('0');
    elsif s1_clk'event and s1_clk = '1' then
      if std_logic'(s1_flush) = '1' then 
        s1_readdatavalid <= std_logic'('0');
      else
        s1_readdatavalid <= m1_readdatavalid;
      end if;
    end if;

  end process;

  s1_waitrequest <= m1_waitrequest;
  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      s1_endofpacket <= std_logic'('0');
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(m1_readdatavalid) = '1' then 
        s1_endofpacket <= m1_endofpacket;
      end if;
    end if;

  end process;

  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      s1_readdata <= std_logic_vector'("00000000000000000000000000000000");
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(m1_readdatavalid) = '1' then 
        s1_readdata <= m1_readdata;
      end if;
    end if;

  end process;

  m1_address <= s1_address;
  m1_arbiterlock <= s1_arbiterlock;
  m1_arbiterlock2 <= s1_arbiterlock2;
  m1_burstcount <= s1_burstcount;
  m1_byteenable <= s1_byteenable;
  m1_chipselect <= s1_chipselect;
  m1_debugaccess <= s1_debugaccess;
  m1_nativeaddress <= s1_nativeaddress;
  m1_read <= s1_read;
  m1_write <= s1_write;
  m1_writedata <= s1_writedata;

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

entity pipeline_bridge_waitrequest_adapter is 
        port (
              -- inputs:
                 signal m1_clk : IN STD_LOGIC;
                 signal m1_endofpacket : IN STD_LOGIC;
                 signal m1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal m1_readdatavalid : IN STD_LOGIC;
                 signal m1_reset_n : IN STD_LOGIC;
                 signal m1_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal s1_address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
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
                 signal m1_arbiterlock : OUT STD_LOGIC;
                 signal m1_arbiterlock2 : OUT STD_LOGIC;
                 signal m1_burstcount : OUT STD_LOGIC;
                 signal m1_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal m1_chipselect : OUT STD_LOGIC;
                 signal m1_debugaccess : OUT STD_LOGIC;
                 signal m1_nativeaddress : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
                 signal m1_read : OUT STD_LOGIC;
                 signal m1_write : OUT STD_LOGIC;
                 signal m1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s1_endofpacket : OUT STD_LOGIC;
                 signal s1_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s1_readdatavalid : OUT STD_LOGIC;
                 signal s1_waitrequest : OUT STD_LOGIC
              );
end entity pipeline_bridge_waitrequest_adapter;


architecture europa of pipeline_bridge_waitrequest_adapter is
                signal d1_s1_address :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal d1_s1_arbiterlock :  STD_LOGIC;
                signal d1_s1_arbiterlock2 :  STD_LOGIC;
                signal d1_s1_burstcount :  STD_LOGIC;
                signal d1_s1_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal d1_s1_chipselect :  STD_LOGIC;
                signal d1_s1_debugaccess :  STD_LOGIC;
                signal d1_s1_nativeaddress :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal d1_s1_read :  STD_LOGIC;
                signal d1_s1_write :  STD_LOGIC;
                signal d1_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_s1_waitrequest :  STD_LOGIC;
                signal set_use_registered :  STD_LOGIC;
                signal use_registered :  STD_LOGIC;

begin

  --s1, which is an e_avalon_adapter_slave
  --m1, which is an e_avalon_adapter_master
  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      internal_s1_waitrequest <= std_logic'('0');
    elsif m1_clk'event and m1_clk = '1' then
      internal_s1_waitrequest <= m1_waitrequest;
    end if;

  end process;

  s1_endofpacket <= m1_endofpacket;
  s1_readdata <= m1_readdata;
  s1_readdatavalid <= m1_readdatavalid;
  --set use registered, which is an e_assign
  set_use_registered <= m1_waitrequest AND NOT internal_s1_waitrequest;
  --use registered, which is an e_register
  process (m1_clk, reset_n)
  begin
    if reset_n = '0' then
      use_registered <= std_logic'('0');
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'((NOT m1_waitrequest AND internal_s1_waitrequest)) = '1' then 
        use_registered <= std_logic'('0');
      elsif std_logic'(set_use_registered) = '1' then 
        use_registered <= Vector_To_Std_Logic(-SIGNED(std_logic_vector'("00000000000000000000000000000001")));
      end if;
    end if;

  end process;

  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      d1_s1_address <= std_logic_vector'("00000000");
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(set_use_registered) = '1' then 
        d1_s1_address <= s1_address;
      end if;
    end if;

  end process;

  m1_address <= A_WE_StdLogicVector((std_logic'((use_registered)) = '1'), d1_s1_address, s1_address);
  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      d1_s1_arbiterlock <= std_logic'('0');
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(set_use_registered) = '1' then 
        d1_s1_arbiterlock <= s1_arbiterlock;
      end if;
    end if;

  end process;

  m1_arbiterlock <= A_WE_StdLogic((std_logic'((use_registered)) = '1'), d1_s1_arbiterlock, s1_arbiterlock);
  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      d1_s1_arbiterlock2 <= std_logic'('0');
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(set_use_registered) = '1' then 
        d1_s1_arbiterlock2 <= s1_arbiterlock2;
      end if;
    end if;

  end process;

  m1_arbiterlock2 <= A_WE_StdLogic((std_logic'((use_registered)) = '1'), d1_s1_arbiterlock2, s1_arbiterlock2);
  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      d1_s1_burstcount <= std_logic'('0');
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(set_use_registered) = '1' then 
        d1_s1_burstcount <= s1_burstcount;
      end if;
    end if;

  end process;

  m1_burstcount <= A_WE_StdLogic((std_logic'((use_registered)) = '1'), d1_s1_burstcount, s1_burstcount);
  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      d1_s1_byteenable <= std_logic_vector'("0000");
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(set_use_registered) = '1' then 
        d1_s1_byteenable <= s1_byteenable;
      end if;
    end if;

  end process;

  m1_byteenable <= A_WE_StdLogicVector((std_logic'((use_registered)) = '1'), d1_s1_byteenable, s1_byteenable);
  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      d1_s1_chipselect <= std_logic'('0');
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(set_use_registered) = '1' then 
        d1_s1_chipselect <= s1_chipselect;
      end if;
    end if;

  end process;

  m1_chipselect <= A_WE_StdLogic((std_logic'((use_registered)) = '1'), d1_s1_chipselect, s1_chipselect);
  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      d1_s1_debugaccess <= std_logic'('0');
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(set_use_registered) = '1' then 
        d1_s1_debugaccess <= s1_debugaccess;
      end if;
    end if;

  end process;

  m1_debugaccess <= A_WE_StdLogic((std_logic'((use_registered)) = '1'), d1_s1_debugaccess, s1_debugaccess);
  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      d1_s1_nativeaddress <= std_logic_vector'("000000");
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(set_use_registered) = '1' then 
        d1_s1_nativeaddress <= s1_nativeaddress;
      end if;
    end if;

  end process;

  m1_nativeaddress <= A_WE_StdLogicVector((std_logic'((use_registered)) = '1'), d1_s1_nativeaddress, s1_nativeaddress);
  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      d1_s1_read <= std_logic'('0');
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(set_use_registered) = '1' then 
        d1_s1_read <= s1_read;
      end if;
    end if;

  end process;

  m1_read <= A_WE_StdLogic((std_logic'((use_registered)) = '1'), d1_s1_read, s1_read);
  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      d1_s1_write <= std_logic'('0');
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(set_use_registered) = '1' then 
        d1_s1_write <= s1_write;
      end if;
    end if;

  end process;

  m1_write <= A_WE_StdLogic((std_logic'((use_registered)) = '1'), d1_s1_write, s1_write);
  process (m1_clk, m1_reset_n)
  begin
    if m1_reset_n = '0' then
      d1_s1_writedata <= std_logic_vector'("00000000000000000000000000000000");
    elsif m1_clk'event and m1_clk = '1' then
      if std_logic'(set_use_registered) = '1' then 
        d1_s1_writedata <= s1_writedata;
      end if;
    end if;

  end process;

  m1_writedata <= A_WE_StdLogicVector((std_logic'((use_registered)) = '1'), d1_s1_writedata, s1_writedata);
  --vhdl renameroo for output signals
  s1_waitrequest <= internal_s1_waitrequest;

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

entity pipeline_bridge is 
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
end entity pipeline_bridge;


architecture europa of pipeline_bridge is
component pipeline_bridge_downstream_adapter is 
           port (
                 -- inputs:
                    signal m1_clk : IN STD_LOGIC;
                    signal m1_endofpacket : IN STD_LOGIC;
                    signal m1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal m1_readdatavalid : IN STD_LOGIC;
                    signal m1_reset_n : IN STD_LOGIC;
                    signal m1_waitrequest : IN STD_LOGIC;
                    signal s1_address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
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
                    signal m1_arbiterlock : OUT STD_LOGIC;
                    signal m1_arbiterlock2 : OUT STD_LOGIC;
                    signal m1_burstcount : OUT STD_LOGIC;
                    signal m1_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal m1_chipselect : OUT STD_LOGIC;
                    signal m1_debugaccess : OUT STD_LOGIC;
                    signal m1_nativeaddress : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
                    signal m1_read : OUT STD_LOGIC;
                    signal m1_write : OUT STD_LOGIC;
                    signal m1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s1_endofpacket : OUT STD_LOGIC;
                    signal s1_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s1_readdatavalid : OUT STD_LOGIC;
                    signal s1_waitrequest : OUT STD_LOGIC
                 );
end component pipeline_bridge_downstream_adapter;

component pipeline_bridge_upstream_adapter is 
           port (
                 -- inputs:
                    signal m1_clk : IN STD_LOGIC;
                    signal m1_endofpacket : IN STD_LOGIC;
                    signal m1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal m1_readdatavalid : IN STD_LOGIC;
                    signal m1_reset_n : IN STD_LOGIC;
                    signal m1_waitrequest : IN STD_LOGIC;
                    signal s1_address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal s1_arbiterlock : IN STD_LOGIC;
                    signal s1_arbiterlock2 : IN STD_LOGIC;
                    signal s1_burstcount : IN STD_LOGIC;
                    signal s1_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s1_chipselect : IN STD_LOGIC;
                    signal s1_clk : IN STD_LOGIC;
                    signal s1_debugaccess : IN STD_LOGIC;
                    signal s1_flush : IN STD_LOGIC;
                    signal s1_nativeaddress : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
                    signal s1_read : IN STD_LOGIC;
                    signal s1_reset_n : IN STD_LOGIC;
                    signal s1_write : IN STD_LOGIC;
                    signal s1_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal m1_address : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal m1_arbiterlock : OUT STD_LOGIC;
                    signal m1_arbiterlock2 : OUT STD_LOGIC;
                    signal m1_burstcount : OUT STD_LOGIC;
                    signal m1_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal m1_chipselect : OUT STD_LOGIC;
                    signal m1_debugaccess : OUT STD_LOGIC;
                    signal m1_nativeaddress : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
                    signal m1_read : OUT STD_LOGIC;
                    signal m1_write : OUT STD_LOGIC;
                    signal m1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s1_endofpacket : OUT STD_LOGIC;
                    signal s1_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s1_readdatavalid : OUT STD_LOGIC;
                    signal s1_waitrequest : OUT STD_LOGIC
                 );
end component pipeline_bridge_upstream_adapter;

component pipeline_bridge_waitrequest_adapter is 
           port (
                 -- inputs:
                    signal m1_clk : IN STD_LOGIC;
                    signal m1_endofpacket : IN STD_LOGIC;
                    signal m1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal m1_readdatavalid : IN STD_LOGIC;
                    signal m1_reset_n : IN STD_LOGIC;
                    signal m1_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal s1_address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
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
                    signal m1_arbiterlock : OUT STD_LOGIC;
                    signal m1_arbiterlock2 : OUT STD_LOGIC;
                    signal m1_burstcount : OUT STD_LOGIC;
                    signal m1_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal m1_chipselect : OUT STD_LOGIC;
                    signal m1_debugaccess : OUT STD_LOGIC;
                    signal m1_nativeaddress : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
                    signal m1_read : OUT STD_LOGIC;
                    signal m1_write : OUT STD_LOGIC;
                    signal m1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s1_endofpacket : OUT STD_LOGIC;
                    signal s1_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s1_readdatavalid : OUT STD_LOGIC;
                    signal s1_waitrequest : OUT STD_LOGIC
                 );
end component pipeline_bridge_waitrequest_adapter;

                signal downstream_m1_address :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal downstream_m1_arbiterlock :  STD_LOGIC;
                signal downstream_m1_arbiterlock2 :  STD_LOGIC;
                signal downstream_m1_burstcount :  STD_LOGIC;
                signal downstream_m1_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal downstream_m1_chipselect :  STD_LOGIC;
                signal downstream_m1_debugaccess :  STD_LOGIC;
                signal downstream_m1_endofpacket :  STD_LOGIC;
                signal downstream_m1_nativeaddress :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal downstream_m1_read :  STD_LOGIC;
                signal downstream_m1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal downstream_m1_readdatavalid :  STD_LOGIC;
                signal downstream_m1_waitrequest :  STD_LOGIC;
                signal downstream_m1_write :  STD_LOGIC;
                signal downstream_m1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal downstream_s1_address :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal downstream_s1_arbiterlock :  STD_LOGIC;
                signal downstream_s1_arbiterlock2 :  STD_LOGIC;
                signal downstream_s1_burstcount :  STD_LOGIC;
                signal downstream_s1_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal downstream_s1_chipselect :  STD_LOGIC;
                signal downstream_s1_debugaccess :  STD_LOGIC;
                signal downstream_s1_endofpacket :  STD_LOGIC;
                signal downstream_s1_nativeaddress :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal downstream_s1_read :  STD_LOGIC;
                signal downstream_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal downstream_s1_readdatavalid :  STD_LOGIC;
                signal downstream_s1_waitrequest :  STD_LOGIC;
                signal downstream_s1_write :  STD_LOGIC;
                signal downstream_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal m1_arbiterlock :  STD_LOGIC;
                signal m1_arbiterlock2 :  STD_LOGIC;
                signal m1_nativeaddress :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal module_input :  STD_LOGIC;
                signal upstream_m1_address :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal upstream_m1_arbiterlock :  STD_LOGIC;
                signal upstream_m1_arbiterlock2 :  STD_LOGIC;
                signal upstream_m1_burstcount :  STD_LOGIC;
                signal upstream_m1_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal upstream_m1_chipselect :  STD_LOGIC;
                signal upstream_m1_debugaccess :  STD_LOGIC;
                signal upstream_m1_endofpacket :  STD_LOGIC;
                signal upstream_m1_nativeaddress :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal upstream_m1_read :  STD_LOGIC;
                signal upstream_m1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal upstream_m1_readdatavalid :  STD_LOGIC;
                signal upstream_m1_waitrequest :  STD_LOGIC;
                signal upstream_m1_write :  STD_LOGIC;
                signal upstream_m1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal upstream_s1_address :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal upstream_s1_arbiterlock :  STD_LOGIC;
                signal upstream_s1_arbiterlock2 :  STD_LOGIC;
                signal upstream_s1_burstcount :  STD_LOGIC;
                signal upstream_s1_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal upstream_s1_chipselect :  STD_LOGIC;
                signal upstream_s1_debugaccess :  STD_LOGIC;
                signal upstream_s1_endofpacket :  STD_LOGIC;
                signal upstream_s1_nativeaddress :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal upstream_s1_read :  STD_LOGIC;
                signal upstream_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal upstream_s1_readdatavalid :  STD_LOGIC;
                signal upstream_s1_waitrequest :  STD_LOGIC;
                signal upstream_s1_write :  STD_LOGIC;
                signal upstream_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal waitrequest_m1_address :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal waitrequest_m1_arbiterlock :  STD_LOGIC;
                signal waitrequest_m1_arbiterlock2 :  STD_LOGIC;
                signal waitrequest_m1_burstcount :  STD_LOGIC;
                signal waitrequest_m1_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal waitrequest_m1_chipselect :  STD_LOGIC;
                signal waitrequest_m1_debugaccess :  STD_LOGIC;
                signal waitrequest_m1_endofpacket :  STD_LOGIC;
                signal waitrequest_m1_nativeaddress :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal waitrequest_m1_read :  STD_LOGIC;
                signal waitrequest_m1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal waitrequest_m1_readdatavalid :  STD_LOGIC;
                signal waitrequest_m1_waitrequest :  STD_LOGIC;
                signal waitrequest_m1_write :  STD_LOGIC;
                signal waitrequest_m1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal waitrequest_s1_address :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal waitrequest_s1_arbiterlock :  STD_LOGIC;
                signal waitrequest_s1_arbiterlock2 :  STD_LOGIC;
                signal waitrequest_s1_burstcount :  STD_LOGIC;
                signal waitrequest_s1_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal waitrequest_s1_chipselect :  STD_LOGIC;
                signal waitrequest_s1_debugaccess :  STD_LOGIC;
                signal waitrequest_s1_endofpacket :  STD_LOGIC;
                signal waitrequest_s1_nativeaddress :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal waitrequest_s1_read :  STD_LOGIC;
                signal waitrequest_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal waitrequest_s1_readdatavalid :  STD_LOGIC;
                signal waitrequest_s1_waitrequest :  STD_LOGIC;
                signal waitrequest_s1_write :  STD_LOGIC;
                signal waitrequest_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

  --the_pipeline_bridge_downstream_adapter, which is an e_instance
  the_pipeline_bridge_downstream_adapter : pipeline_bridge_downstream_adapter
    port map(
      m1_address => downstream_m1_address,
      m1_arbiterlock => downstream_m1_arbiterlock,
      m1_arbiterlock2 => downstream_m1_arbiterlock2,
      m1_burstcount => downstream_m1_burstcount,
      m1_byteenable => downstream_m1_byteenable,
      m1_chipselect => downstream_m1_chipselect,
      m1_debugaccess => downstream_m1_debugaccess,
      m1_nativeaddress => downstream_m1_nativeaddress,
      m1_read => downstream_m1_read,
      m1_write => downstream_m1_write,
      m1_writedata => downstream_m1_writedata,
      s1_endofpacket => downstream_s1_endofpacket,
      s1_readdata => downstream_s1_readdata,
      s1_readdatavalid => downstream_s1_readdatavalid,
      s1_waitrequest => downstream_s1_waitrequest,
      m1_clk => clk,
      m1_endofpacket => downstream_m1_endofpacket,
      m1_readdata => downstream_m1_readdata,
      m1_readdatavalid => downstream_m1_readdatavalid,
      m1_reset_n => reset_n,
      m1_waitrequest => downstream_m1_waitrequest,
      s1_address => downstream_s1_address,
      s1_arbiterlock => downstream_s1_arbiterlock,
      s1_arbiterlock2 => downstream_s1_arbiterlock2,
      s1_burstcount => downstream_s1_burstcount,
      s1_byteenable => downstream_s1_byteenable,
      s1_chipselect => downstream_s1_chipselect,
      s1_debugaccess => downstream_s1_debugaccess,
      s1_nativeaddress => downstream_s1_nativeaddress,
      s1_read => downstream_s1_read,
      s1_write => downstream_s1_write,
      s1_writedata => downstream_s1_writedata
    );


  --the_pipeline_bridge_upstream_adapter, which is an e_instance
  the_pipeline_bridge_upstream_adapter : pipeline_bridge_upstream_adapter
    port map(
      m1_address => upstream_m1_address,
      m1_arbiterlock => upstream_m1_arbiterlock,
      m1_arbiterlock2 => upstream_m1_arbiterlock2,
      m1_burstcount => upstream_m1_burstcount,
      m1_byteenable => upstream_m1_byteenable,
      m1_chipselect => upstream_m1_chipselect,
      m1_debugaccess => upstream_m1_debugaccess,
      m1_nativeaddress => upstream_m1_nativeaddress,
      m1_read => upstream_m1_read,
      m1_write => upstream_m1_write,
      m1_writedata => upstream_m1_writedata,
      s1_endofpacket => upstream_s1_endofpacket,
      s1_readdata => upstream_s1_readdata,
      s1_readdatavalid => upstream_s1_readdatavalid,
      s1_waitrequest => upstream_s1_waitrequest,
      m1_clk => clk,
      m1_endofpacket => upstream_m1_endofpacket,
      m1_readdata => upstream_m1_readdata,
      m1_readdatavalid => upstream_m1_readdatavalid,
      m1_reset_n => reset_n,
      m1_waitrequest => upstream_m1_waitrequest,
      s1_address => upstream_s1_address,
      s1_arbiterlock => upstream_s1_arbiterlock,
      s1_arbiterlock2 => upstream_s1_arbiterlock2,
      s1_burstcount => upstream_s1_burstcount,
      s1_byteenable => upstream_s1_byteenable,
      s1_chipselect => upstream_s1_chipselect,
      s1_clk => clk,
      s1_debugaccess => upstream_s1_debugaccess,
      s1_flush => module_input,
      s1_nativeaddress => upstream_s1_nativeaddress,
      s1_read => upstream_s1_read,
      s1_reset_n => reset_n,
      s1_write => upstream_s1_write,
      s1_writedata => upstream_s1_writedata
    );

  module_input <= std_logic'('0');

  --the_pipeline_bridge_waitrequest_adapter, which is an e_instance
  the_pipeline_bridge_waitrequest_adapter : pipeline_bridge_waitrequest_adapter
    port map(
      m1_address => waitrequest_m1_address,
      m1_arbiterlock => waitrequest_m1_arbiterlock,
      m1_arbiterlock2 => waitrequest_m1_arbiterlock2,
      m1_burstcount => waitrequest_m1_burstcount,
      m1_byteenable => waitrequest_m1_byteenable,
      m1_chipselect => waitrequest_m1_chipselect,
      m1_debugaccess => waitrequest_m1_debugaccess,
      m1_nativeaddress => waitrequest_m1_nativeaddress,
      m1_read => waitrequest_m1_read,
      m1_write => waitrequest_m1_write,
      m1_writedata => waitrequest_m1_writedata,
      s1_endofpacket => waitrequest_s1_endofpacket,
      s1_readdata => waitrequest_s1_readdata,
      s1_readdatavalid => waitrequest_s1_readdatavalid,
      s1_waitrequest => waitrequest_s1_waitrequest,
      m1_clk => clk,
      m1_endofpacket => waitrequest_m1_endofpacket,
      m1_readdata => waitrequest_m1_readdata,
      m1_readdatavalid => waitrequest_m1_readdatavalid,
      m1_reset_n => reset_n,
      m1_waitrequest => waitrequest_m1_waitrequest,
      reset_n => reset_n,
      s1_address => waitrequest_s1_address,
      s1_arbiterlock => waitrequest_s1_arbiterlock,
      s1_arbiterlock2 => waitrequest_s1_arbiterlock2,
      s1_burstcount => waitrequest_s1_burstcount,
      s1_byteenable => waitrequest_s1_byteenable,
      s1_chipselect => waitrequest_s1_chipselect,
      s1_debugaccess => waitrequest_s1_debugaccess,
      s1_nativeaddress => waitrequest_s1_nativeaddress,
      s1_read => waitrequest_s1_read,
      s1_write => waitrequest_s1_write,
      s1_writedata => waitrequest_s1_writedata
    );


  m1_nativeaddress <= downstream_m1_nativeaddress;
  downstream_s1_nativeaddress <= upstream_m1_nativeaddress;
  upstream_s1_nativeaddress <= waitrequest_m1_nativeaddress;
  waitrequest_s1_nativeaddress <= s1_nativeaddress;
  m1_debugaccess <= downstream_m1_debugaccess;
  downstream_s1_debugaccess <= upstream_m1_debugaccess;
  upstream_s1_debugaccess <= waitrequest_m1_debugaccess;
  waitrequest_s1_debugaccess <= s1_debugaccess;
  m1_arbiterlock <= downstream_m1_arbiterlock;
  downstream_s1_arbiterlock <= upstream_m1_arbiterlock;
  upstream_s1_arbiterlock <= waitrequest_m1_arbiterlock;
  waitrequest_s1_arbiterlock <= s1_arbiterlock;
  m1_writedata <= downstream_m1_writedata;
  downstream_s1_writedata <= upstream_m1_writedata;
  upstream_s1_writedata <= waitrequest_m1_writedata;
  waitrequest_s1_writedata <= s1_writedata;
  m1_chipselect <= downstream_m1_chipselect;
  downstream_s1_chipselect <= upstream_m1_chipselect;
  upstream_s1_chipselect <= waitrequest_m1_chipselect;
  waitrequest_s1_chipselect <= s1_chipselect;
  m1_burstcount <= downstream_m1_burstcount;
  downstream_s1_burstcount <= upstream_m1_burstcount;
  upstream_s1_burstcount <= waitrequest_m1_burstcount;
  waitrequest_s1_burstcount <= s1_burstcount;
  m1_byteenable <= downstream_m1_byteenable;
  downstream_s1_byteenable <= upstream_m1_byteenable;
  upstream_s1_byteenable <= waitrequest_m1_byteenable;
  waitrequest_s1_byteenable <= s1_byteenable;
  m1_arbiterlock2 <= downstream_m1_arbiterlock2;
  downstream_s1_arbiterlock2 <= upstream_m1_arbiterlock2;
  upstream_s1_arbiterlock2 <= waitrequest_m1_arbiterlock2;
  waitrequest_s1_arbiterlock2 <= s1_arbiterlock2;
  m1_read <= downstream_m1_read;
  downstream_s1_read <= upstream_m1_read;
  upstream_s1_read <= waitrequest_m1_read;
  waitrequest_s1_read <= s1_read;
  m1_write <= downstream_m1_write;
  downstream_s1_write <= upstream_m1_write;
  upstream_s1_write <= waitrequest_m1_write;
  waitrequest_s1_write <= s1_write;
  waitrequest_s1_address <= s1_address & std_logic_vector'("00");
  upstream_s1_address <= waitrequest_m1_address;
  downstream_s1_address <= upstream_m1_address;
  m1_address <= downstream_m1_address;
  downstream_m1_readdatavalid <= m1_readdatavalid;
  upstream_m1_readdatavalid <= downstream_s1_readdatavalid;
  waitrequest_m1_readdatavalid <= upstream_s1_readdatavalid;
  s1_readdatavalid <= waitrequest_s1_readdatavalid;
  downstream_m1_waitrequest <= m1_waitrequest;
  upstream_m1_waitrequest <= downstream_s1_waitrequest;
  waitrequest_m1_waitrequest <= upstream_s1_waitrequest;
  s1_waitrequest <= waitrequest_s1_waitrequest;
  downstream_m1_endofpacket <= m1_endofpacket;
  upstream_m1_endofpacket <= downstream_s1_endofpacket;
  waitrequest_m1_endofpacket <= upstream_s1_endofpacket;
  s1_endofpacket <= waitrequest_s1_endofpacket;
  downstream_m1_readdata <= m1_readdata;
  upstream_m1_readdata <= downstream_s1_readdata;
  waitrequest_m1_readdata <= upstream_s1_readdata;
  s1_readdata <= waitrequest_s1_readdata;
  --s1, which is an e_avalon_slave
  --m1, which is an e_avalon_master

end europa;

