----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:25:34 11/11/2023 
-- Design Name: 
-- Module Name:    sel_modo - Behavioral 
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

entity sel_modo is
    Port ( grabar_reproducir  : in  STD_LOGIC;
				modo : out std_logic_vector(15 downto 0));
end sel_modo;

architecture Behavioral of sel_modo is

begin
modo<=X"4567" when grabar_reproducir='1' else X"0123";

end Behavioral;

