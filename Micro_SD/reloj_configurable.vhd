
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
--- Defino estas librerías para hacer los cálculos previos a la implementación del circuito:
use IEEE.math_real.all;
--- La definición del puerto genérico debe hacerse manualmente. Asigno valor por defecto
entity reloj_configurable is
	 Generic (frecuencia_reloj: integer:=100000000; frecuencia_salida: integer:=1);
    Port ( clk : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           clk_out : out  STD_LOGIC);
end reloj_configurable;

architecture Behavioral of reloj_configurable is
--- Cálculos necesarios para el contador
Constant pulsos: integer:=frecuencia_reloj/frecuencia_salida;
constant limite: integer:= pulsos-1;
Constant bits: integer:= integer(ceil(log2(real(pulsos))));

signal contador: STD_LOGIC_VECTOR(bits-1 downto 0);
begin

	process(Clr,Clk)
	begin
		if Clr = '0' then
			contador <= (others =>'0');
		elsif rising_edge(Clk) then
			if contador = limite then
				contador <= (others => '0');
			else 
				contador <= contador+1;
			end if;
		end if;
	end process;
	clk_out <= '1' when contador >= limite else '0';


end Behavioral;

