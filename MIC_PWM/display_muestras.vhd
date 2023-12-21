----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:33:06 12/04/2023 
-- Design Name: 
-- Module Name:    display_muestras - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display_muestras is
    Port ( un_segundo : in  STD_LOGIC;
	 clk : in std_logic;
	 rst : in std_logic;
           entrada : in  STD_LOGIC_VECTOR (7 downto 0);
           salida : out  STD_LOGIC_VECTOR (7 downto 0));
end display_muestras;

architecture Behavioral of display_muestras is
signal aux : std_logic_vector(7 downto 0);
begin
process(clk,rst)
begin
	if rst='0' then
		aux<=(others=>'0');
	elsif rising_edge(clk) then
		if un_segundo='1' then
			aux<=entrada;
		end if;
	end if;
end process;

salida<=aux;

end Behavioral;

