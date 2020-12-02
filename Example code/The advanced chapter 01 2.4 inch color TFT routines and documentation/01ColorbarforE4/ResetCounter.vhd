library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ResetCounter is
port(
		clk	: in std_logic;
		kb_rst_n : in std_logic;
		
		Reset_n : out std_logic
	);
end ResetCounter;

architecture RTL of ResetCounter is
signal Low_cnt : std_logic_vector(9 downto 0);
signal Mid_cnt : std_logic_vector(9 downto 0);
signal High_cnt : std_logic_vector(9 downto 0);
signal Low_cnt_ov : std_logic;
signal Mid_cnt_ov : std_logic;


begin
	
	
	process(clk)
	begin
		if kb_rst_n = '0' then
			Low_cnt <= (others => '0');
		elsif clk'event and clk = '1' then
			if (Low_cnt = 1023) then
				Low_cnt_ov <= '1';
				Low_cnt <= (others => '0');
			else
				Low_cnt_ov <= '0';
				Low_cnt <= Low_cnt + '1';
			end if;
		end if;
	end process;
	
	process(clk)
	begin
		if kb_rst_n = '0' then
			Mid_cnt <= (others => '0');
		elsif clk'event and clk = '1' and Low_cnt_ov = '1' then
			if (Mid_cnt = 1023) then
				Mid_cnt_ov <= '1';
				Mid_cnt <= (others => '0');
			else
				Mid_cnt_ov <= '0';
				Mid_cnt <= Mid_cnt + '1';
			end if;
		end if;
	end process;
	
	process(clk)
	begin
		if kb_rst_n = '0' then
			High_cnt <= (others => '0');
		elsif clk'event and clk = '1' and Mid_cnt_ov = '1' then
			if (High_cnt >= 1020) then
				Reset_n <= '1';
			--elsif (High_cnt >= 1020 and High_cnt < 1023) then
				--Reset_n <= '0';
				--High_cnt <= High_cnt + '1';
			else
				Reset_n <= '0';
				High_cnt <= High_cnt + '1';
			end if;
		end if;
	end process;
end RTL;