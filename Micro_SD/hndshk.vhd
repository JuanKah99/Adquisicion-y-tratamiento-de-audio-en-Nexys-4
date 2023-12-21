----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:48:19 11/08/2023 
-- Design Name: 
-- Module Name:    hndshk - Behavioral 
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

entity hndshk is
    Port ( hnd_o : in  STD_LOGIC;
           hnd_i : out  STD_LOGIC);
end hndshk;

architecture Behavioral of hndshk is

begin
hnd_i<='1' when hnd_o='1' else '0';

end Behavioral;

