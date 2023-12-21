----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:51:34 11/13/2023 
-- Design Name: 
-- Module Name:    memoria_pulsador - Behavioral 
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

entity memoria_pulsador is
    Port ( entrada : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  clk : in std_logic;
           rst_cnt : in  STD_LOGIC;
           salida : out  STD_LOGIC);
end memoria_pulsador;

architecture Behavioral of memoria_pulsador is
signal aux:std_logic;
begin

process(clk,rst)
begin
	if(rst='0') then
		aux<='0';
	elsif rising_edge(clk) then
		if rst_cnt='1' then
			aux<='0';
		elsif entrada='1' then
			aux<='1';
		end if;
	end if;
end process;
salida<=aux;

end Behavioral;

