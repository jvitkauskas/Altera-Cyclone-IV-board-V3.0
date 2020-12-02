library ieee;
use ieee.std_logic_1164.all;

entity led_and is
port (
	SIGNAL a : in std_logic;	
	SIGNAL b : in std_logic;	
	SIGNAL c : out std_logic
);	
END led_and;

ARCHITECTURE led_and OF led_and IS
BEGIN
    c <= (a and b);
END led_and;
