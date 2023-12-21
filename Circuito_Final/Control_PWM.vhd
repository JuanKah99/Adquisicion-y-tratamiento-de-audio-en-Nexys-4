
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

			
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity Control_PWM is
    Port ( clk : in  STD_LOGIC;
           clr : in  STD_LOGIC;
			  CE : in  STD_LOGIC;
           Muestra : in  signed (7 downto 0);
           Salida_AUD_3_3V : out  STD_LOGIC;
           Salida_AUD_PWM : out  STD_LOGIC);
end Control_PWM;

architecture Behavioral of Control_PWM is

signal cont: signed(7 downto 0);
signal aux_Muestra: signed(7 downto 0);
begin
	process(clk,clr)
		begin
			if clr='0' then
				cont <= "10000000";
				aux_Muestra <= (others=>'0');
			elsif rising_edge(clk) then
				if (cont=-128) then
					cont <= cont + 1;
				elsif (cont/=-128 and cont/=127) then
					cont <= cont + 1;
				elsif cont=127 then
					cont <= "10000000";
					aux_Muestra <= Muestra;
				end if;
			end if;
	end process;
	
Salida_AUD_3_3V <= '1';
Salida_AUD_PWM <= 'Z' when (cont<aux_Muestra and CE='1') else '0';

end Behavioral;

