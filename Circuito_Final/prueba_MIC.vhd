----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:17:30 11/25/2023 
-- Design Name: 
-- Module Name:    prueba_MIC - Behavioral 
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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity prueba_MIC is
    Port ( Microfono : in  signed (7 downto 0);
           Micro_SD : in  signed (7 downto 0);
           PWM : out  signed (7 downto 0);
           WR : in  STD_LOGIC);
end prueba_MIC;

architecture Behavioral of prueba_MIC is

begin
PWM<= Microfono when WR='1' else Micro_SD;

end Behavioral;

