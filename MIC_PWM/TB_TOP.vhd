--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:01:23 11/06/2023
-- Design Name:   
-- Module Name:   E:/JuanK/Documents/ELECTRONICA/4TO ANO/TFG Disco/CODIGO/mic_PWM/TB_TOP.vhd
-- Project Name:  mic_PWM
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
 use ieee.numeric_std.all;
use ieee.math_real.all; -- pour sinus
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_TOP IS
END TB_TOP;
 
ARCHITECTURE behavior OF TB_TOP IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TOP
    PORT(
         PDM : IN  std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic;
         PWM : OUT  std_logic;
			CLK_2_5_MHz : out std_logic;
			m_lrsel: out std_logic;
			interruptor : in std_logic;
         Vcc_out : OUT  std_logic
        );
    END COMPONENT;
    
  signal data_in_ana : integer;
   --Inputs
   signal PDM : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
signal CLK_2_5_MHz :  std_logic;
		signal	  m_lrsel:  std_logic;
		signal	  interruptor :  std_logic:='0';

 	--Outputs
   signal PWM : std_logic;
   signal Vcc_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TOP PORT MAP (
          PDM => PDM,
          clk => clk,
			 CLK_2_5_MHz =>CLK_2_5_MHz,
			 m_lrsel => m_lrsel,
			 interruptor => interruptor,
          rst => rst,
          PWM => PWM,
          Vcc_out => Vcc_out
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
      -- insert stimulus here 
wait for 50 ns;
rst<='1';

      wait;
   end process;

  process
    variable ana,a,acc : real;
    begin
    a := 0.0;
    acc := 0.0;
    data_in_ana <= 0;
    loop
      wait for 400 ns;
      a:=a+2.0*MATH_PI*10000.0/2500000.0; -- 1kHz phase en radians
      ana:=0.9*SIN(a);
      acc:=acc+ana;
      if acc>=0.0 then
        PDM <= '1';
        acc:=acc - (+1.0);
      else
        PDM <= '0';
        acc:=acc - (-1.0);
      end if;
      data_in_ana <= integer(ROUND(1000.0*ana));
			 wait for 20 ns;
	 interruptor<='1';
	 wait for 20 ns;
	 interruptor<='0';
    end loop;

  end process;

END;
