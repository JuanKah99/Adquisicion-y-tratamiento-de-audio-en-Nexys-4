---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CTR_511 is
    Port ( CLK : in  STD_LOGIC;
           CE : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
			  rst_512 : in  STD_LOGIC;
           TC : out  STD_LOGIC);
end CTR_511;

architecture Behavioral of CTR_511 is
signal cont: std_logic_vector (8 downto 0);
begin
	process(CLK,Reset)
		begin
			if reset='0' then
				cont<=(others=>'0');
			elsif CLK'event and CLK='1' then
				if rst_512='1' then
					cont<=(others=>'0');
				elsif CE='1' then
					cont<=cont+1;
				end if;
			end if;
	 end process;
TC<='1' when (cont=511 ) else '0';

end Behavioral;

