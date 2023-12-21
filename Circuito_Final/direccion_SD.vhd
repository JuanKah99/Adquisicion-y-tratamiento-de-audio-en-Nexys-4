library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity direccion_SD is
    Port ( CLR : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
			  CE : in std_logic;
			  sel_audio: in  STD_LOGIC;
           address: out  STD_LOGIC_vector(31 downto 0);
			  num_audio : out std_logic_vector(3 downto 0));
end direccion_SD;

architecture Behavioral of direccion_SD is
signal cont : std_logic_vector(1 downto 0);
begin

	PROCESS (CLK,CLR)
		BEGIN
			IF CLR='0' THEN
					cont<=(others=>'0');
			ELSIF RISING_EDGE(CLK) THEN
				if (sel_audio='1' and CE='1') then
					cont<=cont+1;
				end if;
			END IF;
	END PROCESS;							 
address<=X"00096000" when cont=0 else -- 
			X"00064000" when cont=1 else --  
			X"00032000" when cont=2 else --  
			X"00000400";					 -- 
num_audio<=X"A" when cont=0 else 
			X"B" when cont=1 else
			X"C" when cont=2 else
			X"D";
end Behavioral;

