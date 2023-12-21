
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

--library work;
--use work.Paquete_Constantes.ALL;

entity Control_PWM is
    Port ( clk : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           Nueva_Muestra : in  STD_LOGIC;
			  ce : in std_logic;
           Muestra : in  signed (7 downto 0);
			  busy_PWM : out STD_LOGIC;
           Salida_AUD_3_3V : out  STD_LOGIC;
           Salida_AUD_PWM : out  STD_LOGIC);
end Control_PWM;

architecture Behavioral of Control_PWM is
signal aviso : std_logic;
signal cont: signed(7 downto 0);
signal aux_Muestra: signed(7 downto 0);

begin
	process(clk,clr,Nueva_Muestra)
		begin
			if clr='0' then
				cont <= "10000000";
				aux_Muestra <= (others=>'0');
				aviso<='0';
				busy_PWM<='0';
			elsif rising_edge(clk) then
				if (Nueva_Muestra='1') then  -- Puede quitarse y actualizarse sola
					aviso<='1';
					cont <= cont + 1;
				elsif (cont="10000000" and aviso='1') then
					busy_PWM<='1';
					aviso<='0';
					aux_Muestra <= Muestra; -- ACTUALIZAR CUANDO cont=127
					cont <= cont + 1;
				elsif (cont/=-128 and cont/=127) then
					cont <= cont + 1;
				elsif cont=127 then
					busy_PWM<='0';
					cont <= "10000000";
				elsif (cont="10000000") then
					busy_PWM<='1';
					cont <= cont + 1;

				end if;
			end if;
	end process;
	
Salida_AUD_3_3V <= '1';
Salida_AUD_PWM <= 'Z' when (cont<aux_Muestra and ce='1') else '0';

end Behavioral;

