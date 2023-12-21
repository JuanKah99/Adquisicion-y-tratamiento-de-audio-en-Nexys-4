
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;


entity Decod_7seg is
    Port ( 
 Dato : in  STD_LOGIC_VECTOR (15 downto 0);
	 
				clr : in  STD_LOGIC;
				clk : in  STD_LOGIC;
				en : in  STD_LOGIC;
				
           a_to_g : out  STD_LOGIC_VECTOR (6 downto 0);
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           dp : out  STD_LOGIC);
end Decod_7seg;

architecture Behavioral of Decod_7seg is

signal cuenta:std_logic_vector(1 downto 0);
signal numero:std_logic_vector(3 downto 0);


begin


--contador ctr2bit
process (clk,clr)
begin
	if clr='0' then
		cuenta<="00";
	elsif rising_edge(clk) then
		if en='1' then
		cuenta<=cuenta+1;
		end if;
	end if;
end process;

--multiplexor mux44
process (cuenta,dato)
begin

case cuenta is
when "00"=>
	numero<=dato(15 downto 12);
when "01"=>
	numero<=dato(11 downto 8);
when "10"=>
	numero<=dato(7 downto 4);
when others=>
	numero<=dato(3 downto 0);
end case;
	

end process;

--hex7seg

	process(numero)
         begin
           case numero is
               when X"0" => a_to_g <= "0000001"; --0
               when X"1" => a_to_g <= "1001111"; --1
               when X"2" => a_to_g <= "0010010"; --2
               when X"3" => a_to_g <= "0000110"; --3
               when X"4" => a_to_g <= "1001100"; --4
               when X"5" => a_to_g <= "0100100"; --5
               when X"6" => a_to_g <= "0100000"; --6
               when X"7" => a_to_g <= "0001101"; --7
               when X"8" => a_to_g <= "0000000"; --8
               when X"9" => a_to_g <= "0000100"; --9
               when X"A" => a_to_g <= "0001000"; --A
               when X"B" => a_to_g <= "1100000"; --b
               when X"C" => a_to_g <= "0110001"; --C 
               when X"D" => a_to_g <= "1000010"; --d 
               when X"E" => a_to_g <= "0110000"; --E
               when others => a_to_g <= "0111000"; --F
					
          end case;
	end process;
	
--ancode decodificador

process (cuenta)
begin

case cuenta is
when "00"=>
	an<="1110";
when "01"=>
	an<="1101";
when "10"=>
	an<="1011";
when others=>
	an<="0111";
end case;
	
end process;

dp<='1';
-- fin

end Behavioral;
