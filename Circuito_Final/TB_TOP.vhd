--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:29:04 12/06/2023
-- Design Name:   
-- Module Name:   E:/JuanK/Documents/ELECTRONICA/4TO ANO/TFG Disco/CODIGO/Circuito_Final/TB_TOP.vhd
-- Project Name:  Circuito_Final
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
 use ieee.math_real.all; 
  use ieee.numeric_std.all;
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
         play_pause : IN  std_logic;
         graba : IN  std_logic;
			sel_velocidad : in std_logic;
         sel_audio : IN  std_logic;
         grabar_reproducir : IN  std_logic;
         cs_bo : OUT  std_logic;
         sclk_o : OUT  std_logic;
         mosi_o : OUT  std_logic;
         miso_i : IN  std_logic;
         error_o : OUT  std_logic;
         playing : OUT  std_logic;
         busyled : OUT  std_logic;
         senal_mic : OUT  std_logic;
         a_to_g : OUT  std_logic_vector(6 downto 0);
         an : OUT  std_logic_vector(7 downto 0);
         dp : OUT  std_logic;
         m_lrsel : OUT  std_logic;
         Vcc_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal PDM : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
	signal sel_velocidad :  std_logic :='0';
   signal play_pause : std_logic := '0';
   signal graba : std_logic := '0';
   signal sel_audio : std_logic := '0';
   signal grabar_reproducir : std_logic := '0';
   signal miso_i : std_logic := '0';

 	--Outputs
   signal PWM : std_logic;
   signal cs_bo : std_logic;
   signal sclk_o : std_logic;
   signal mosi_o : std_logic;
   signal error_o : std_logic;
   signal playing : std_logic;
   signal busyled : std_logic;
   signal senal_mic : std_logic;
   signal a_to_g : std_logic_vector(6 downto 0);
   signal an : std_logic_vector(7 downto 0);
   signal dp : std_logic;
   signal m_lrsel : std_logic;
   signal Vcc_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
    signal data_in_ana : integer;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TOP PORT MAP (
          PDM => PDM,
          clk => clk,
          rst => rst,
          PWM => PWM,
          play_pause => play_pause,
          graba => graba,
			 sel_velocidad => sel_velocidad,
          sel_audio => sel_audio,
          grabar_reproducir => grabar_reproducir,
          cs_bo => cs_bo,
          sclk_o => sclk_o,
          mosi_o => mosi_o,
          miso_i => miso_i,
          error_o => error_o,
          playing => playing,
          busyled => busyled,
          senal_mic => senal_mic,
          a_to_g => a_to_g,
          an => an,
          dp => dp,
          m_lrsel => m_lrsel,
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
   		
      -- hold reset state for 100 ns.
    variable ana,a,acc : real;
		variable randn : real := 0.5;
      variable seed1: positive := 1;
      variable seed2: positive := 1;
    begin
	a := 0.0;
    acc := 0.0;
    data_in_ana <= 0;
			wait for clk_period;
				rst<='1';
	      wait for 545 us;	
				miso_i<='1';
			wait for 2.5 us;
				miso_i<='0';
	 	wait for 580 ns;


	 
--===================== ESCRITURA =======================================
--grabar_reproducir<='1';
--wait until busyled='0';
--wait for 30 ns;
--sel_audio<='1';
--wait for clk_period*4;
--sel_audio<='0';
--wait for clk_period*4;
--		graba<='1';
--	wait for clk_period;
--		graba<='0'; 
--loop
--    for i in 0 to 33312 loop -- 2,5MHz*517/40KHz
--      wait until (senal_mic='1' and rising_edge(clk));
--      a:=a+2.0*MATH_PI*10000.0/2500000.0; -- 1kHz phase en radians
--      ana:=0.9*SIN(a);
--      acc:=acc+ana;
--      if acc>=0.0 then
--        PDM <= '1';
--        acc:=acc - (+1.0);
--      else
--        PDM <= '0';
--        acc:=acc - (-1.0);
--      end if;
--      data_in_ana <= integer(ROUND(1000.0*ana));
--		wait for clk_period;
--    end loop;
--		miso_i<='1';
--	 wait for clk_period*3;
--		miso_i<='0';
--wait for clk_period*200;
--		graba<='1';
--	wait for clk_period;
--		graba<='0'; 
--end loop;	
--======================================================================	 
	
--========================= LECTURA ====================================
grabar_reproducir<='0';
wait until busyled<='0';

wait for 30 ns;
sel_audio<='1';
wait for clk_period*4;
sel_audio<='0';

wait for 30 ns;
play_pause<='1';
wait for 10 ns;
play_pause<='0';
			wait for 1800 ns;
			miso_i<='1';
			wait for 270 ns;
			miso_i<='0';
			
					wait for 13.098 ms;
								miso_i<='1';
			wait for 420 us;
			wait for 50 ns;
			miso_i<='0';
				
for i in 0 to 3670 loop  ----------- para probar miso_i
  uniform(seed1,seed2,randn);
  if integer(randn) = 1 then
	 miso_i <= '1';
  else
	 miso_i <= '0';
  end if;
  wait until sclk_o = '0';
end loop;
 	 
	 
--======================================================================
	 
   end process;

END;
