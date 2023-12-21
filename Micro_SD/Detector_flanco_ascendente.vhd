-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Detector_flanco is
    Port ( CLK : in  STD_LOGIC;
           Ent : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           FA_S : out  STD_LOGIC
           );
end Detector_flanco;

architecture Behavioral of Detector_flanco is
signal Qt,Qant:std_logic;
begin

--Primer biestable
	process(clk,reset)
		begin
		if reset='0' then 
			Qt <= '0';
		elsif clk='1' and clk'event then
			Qt<=Ent;
		end if;
	end process;
--Segundo biestable
	process(clk,reset)
		begin
		if reset='0' then 
			Qant <= '0';
		elsif clk='1' and clk'event then
			Qant<=Qt;
		end if;
	end process;
FA_S<=not(Qant) and Qt;
end Behavioral;

