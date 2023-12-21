--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:29:47 11/08/2023
-- Design Name:   
-- Module Name:   E:/JuanK/Documents/ELECTRONICA/4TO ANO/TFG Disco/CODIGO/Micro_SD/TB_TOP.vhd
-- Project Name:  Micro_SD
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TOP
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_TOP IS
END TB_TOP;
 
ARCHITECTURE behavior OF TB_TOP IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TOP
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         play : IN  std_logic;
         recd : IN  std_logic;
         miso_i : IN  std_logic;
         cs_bo : OUT  std_logic;
         sclk_o : OUT  std_logic;
         mosi_o : OUT  std_logic;
         busy_o : OUT  std_logic;
         a_to_g : OUT  std_logic_vector(6 downto 0);
         an : OUT  std_logic_vector(3 downto 0);
         dp : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal play : std_logic := '0';
   signal recd : std_logic := '0';
   signal miso_i : std_logic := '0';

 	--Outputs
   signal cs_bo : std_logic;
   signal sclk_o : std_logic;
   signal mosi_o : std_logic;
   signal busy_o : std_logic;
   signal a_to_g : std_logic_vector(6 downto 0);
   signal an : std_logic_vector(3 downto 0);
   signal dp : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TOP PORT MAP (
          clk => clk,
          rst => rst,
          play => play,
          recd => recd,
          miso_i => miso_i,
          cs_bo => cs_bo,
          sclk_o => sclk_o,
          mosi_o => mosi_o,
          busy_o => busy_o,
          a_to_g => a_to_g,
          an => an,
          dp => dp
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
			rst<='1';
wait for 545 us;
		
			miso_i<='1';
			wait for 2.5 us;
			miso_i<='0';
			wait until busy_o='0';
			recd<='1';
			wait for 40 ns;
			recd<='0';
      -- insert stimulus here 

      wait;
   end process;

END;
