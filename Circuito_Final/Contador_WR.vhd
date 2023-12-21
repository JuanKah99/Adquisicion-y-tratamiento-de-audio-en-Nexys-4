---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CTR_WR is
    Port ( CLK : in  STD_LOGIC;
           CE : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
			  rst_WR : in std_logic;
           TC : out  STD_LOGIC);
end CTR_WR;

architecture Behavioral of CTR_WR is
signal cont: std_logic_vector (8 downto 0);
begin
	process(CLK,Reset)
		begin
			if reset='0' then
				cont<=(others=>'0');
			elsif CLK'event and CLK='1' then
				if rst_WR='1' then
					cont<=(others=>'0');
				elsif CE='1' then
					cont<=cont+1;
				end if;
			end if;
	 end process;
TC<='1' when (cont=400 ) else '0';

end Behavioral;

