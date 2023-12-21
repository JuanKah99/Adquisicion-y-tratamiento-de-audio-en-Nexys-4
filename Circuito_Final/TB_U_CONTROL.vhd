--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:37:37 12/10/2023
-- Design Name:   
-- Module Name:   E:/JuanK/Documents/ELECTRONICA/4TO ANO/TFG Disco/CODIGO/Circuito_Final/TB_U_CONTROL.vhd
-- Project Name:  Circuito_Final
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: u_control
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
 
ENTITY TB_U_CONTROL IS
END TB_U_CONTROL;
 
ARCHITECTURE behavior OF TB_U_CONTROL IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT u_control
    PORT(
         Busy : IN  std_logic;
         rd_wr : IN  std_logic;
         play : IN  std_logic;
         sigue : IN  std_logic;
         grabar : IN  std_logic;
         clk : IN  std_logic;
         clr : IN  std_logic;
         hndshk_o : IN  std_logic;
         clk_40KHz : IN  std_logic;
         Fin_512 : IN  std_logic;
         Fin_WR : IN  std_logic;
         Nueva_Muestra : OUT  std_logic;
         RD : OUT  std_logic;
         WR : OUT  std_logic;
         continue_i : OUT  std_logic;
         cont_512 : OUT  std_logic;
         cont_WR : OUT  std_logic;
         rst_512 : OUT  std_logic;
         rst_WR : OUT  std_logic;
         CE_PWM : OUT  std_logic;
         CE_selector : OUT  std_logic;
         hndshk_i : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Busy : std_logic := '1';
   signal rd_wr : std_logic := '0';
   signal play : std_logic := '0';
   signal sigue : std_logic := '0';
   signal grabar : std_logic := '0';
   signal clk : std_logic := '0';
   signal clr : std_logic := '0';
   signal hndshk_o : std_logic := '0';
   signal clk_40KHz : std_logic := '0';
   signal Fin_512 : std_logic := '0';
   signal Fin_WR : std_logic := '0';

 	--Outputs
   signal Nueva_Muestra : std_logic;
   signal RD : std_logic;
   signal WR : std_logic;
   signal continue_i : std_logic;
   signal cont_512 : std_logic;
   signal cont_WR : std_logic;
   signal rst_512 : std_logic;
   signal rst_WR : std_logic;
   signal CE_PWM : std_logic;
   signal CE_selector : std_logic;
   signal hndshk_i : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: u_control PORT MAP (
          Busy => Busy,
          rd_wr => rd_wr,
          play => play,
          sigue => sigue,
          grabar => grabar,
          clk => clk,
          clr => clr,
          hndshk_o => hndshk_o,
          clk_40KHz => clk_40KHz,
          Fin_512 => Fin_512,
          Fin_WR => Fin_WR,
          Nueva_Muestra => Nueva_Muestra,
          RD => RD,
          WR => WR,
          continue_i => continue_i,
          cont_512 => cont_512,
          cont_WR => cont_WR,
          rst_512 => rst_512,
          rst_WR => rst_WR,
          CE_PWM => CE_PWM,
          CE_selector => CE_selector,
          hndshk_i => hndshk_i
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
			clr<='1';
      wait for clk_period*10;
			Busy<='0';
		wait for 40 ns;
			play<='1';
			sigue<='1';
			hndshk_o<='1';
			clk_40KHz<='1';
		wait for 120 us;
			sigue<='0';
      -- insert stimulus here 

      wait;
   end process;

END;
