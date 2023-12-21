----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:48:03 11/04/2023 
-- Design Name: 
-- Module Name:    U_Operativa - Behavioral 
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

entity U_Operativa is
    Port ( clk : in  STD_LOGIC;
			  rst : in  STD_LOGIC;
			  cont_512 : in  STD_LOGIC;
           cont_WR : in  STD_LOGIC;
 --          cont_RD : in  STD_LOGIC;
			  rst_512 : in std_logic;
			  rst_WR : in std_logic;
--			  rst_RD : in std_logic;
           Fin_512 : out  STD_LOGIC;
           Fin_WR : out  STD_LOGIC);
--           Fin_RD : out  STD_LOGIC
end U_Operativa;

architecture Behavioral of U_Operativa is



	COMPONENT CTR_511
	PORT(
		CLK : IN std_logic;
		CE : IN std_logic;
		rst_512 : in std_logic;
		Reset : IN std_logic;          
		TC : OUT std_logic
		);
	END COMPONENT;

--	COMPONENT CTR_RD
--	PORT(
--		CLK : IN std_logic;
--		CE : IN std_logic;
--		rst_RD : in std_logic;
--		Reset : IN std_logic;          
--		TC : OUT std_logic
--		);
--	END COMPONENT;

	COMPONENT CTR_WR
	PORT(
		CLK : IN std_logic;
		CE : IN std_logic;
		rst_WR : in std_logic;
		Reset : IN std_logic;          
		TC : OUT std_logic
		);
	END COMPONENT;



begin



	Inst_CTR_511: CTR_511 PORT MAP(
		CLK => clk,
		CE => cont_512,
		Reset => rst,
		rst_512 => rst_512,
		TC => Fin_512
	);


--	Inst_CTR_RD: CTR_RD PORT MAP(
--		CLK => clk,
--		CE => cont_RD,
--		rst_RD => rst_RD,
--		Reset => rst,
--		TC => Fin_RD
--	);
	
		Inst_CTR_WR: CTR_WR PORT MAP(
		CLK => clk,
		CE => cont_WR,
		rst_WR => rst_WR,
		Reset => rst,
		TC => Fin_WR
	);

end Behavioral;

