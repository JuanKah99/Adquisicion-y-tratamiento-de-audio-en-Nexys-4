----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:19:44 11/12/2023 
-- Design Name: 
-- Module Name:    Conmutador - Behavioral 
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

entity Conmutador is
    Port ( A : in  STD_LOGIC;
			  clk : in std_logic;
			  rst : in std_logic;
			  clr_conmutador : in std_logic;
           B : out  STD_LOGIC);
end Conmutador;

architecture Behavioral of Conmutador is
signal aux : std_logic:='0';
begin
process(clk,rst)
begin
	if rst='0' then
		aux<='0';
	elsif rising_edge(clk) then
		if clr_conmutador='0' then
			aux<='0';
		elsif A='1' then
			if aux='0' then
				aux<='1';
			else
				aux<='0';
			end if;
		end if;
	end if;
end process;
B<=aux;
end Behavioral;

