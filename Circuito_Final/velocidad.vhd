----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:34:16 12/10/2023 
-- Design Name: 
-- Module Name:    velocidad - Behavioral 
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

entity velocidad is
    Port ( f_40KHz : in  STD_LOGIC;
           f_34KHz : in  STD_LOGIC;
           sel_velocidad : in  STD_LOGIC;
           salida_F : out  STD_LOGIC);
end velocidad;

architecture Behavioral of velocidad is

begin
salida_F<=f_40KHz when sel_velocidad='0' else f_34KHz;

end Behavioral;

