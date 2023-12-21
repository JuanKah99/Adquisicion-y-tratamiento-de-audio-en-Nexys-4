----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:58:18 11/08/2023 
-- Design Name: 
-- Module Name:    TOP - Behavioral 
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
use work.SdCardPckg.all;	

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           play : in  STD_LOGIC;
           recd : in  STD_LOGIC;
			  miso_i : IN std_logic;  
			  cs_bo : OUT std_logic;
			  sclk_o : OUT std_logic;
			  mosi_o : OUT std_logic;
			  busy_o : OUT std_logic;
			  a_to_g : out  STD_LOGIC_VECTOR (6 downto 0);
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           dp : out  STD_LOGIC);

end TOP;

architecture Behavioral of TOP is



	COMPONENT Decod_7seg
	PORT(
		Dato : IN std_logic_vector(15 downto 0);
		clr : IN std_logic;
		clk : IN std_logic;
		en : IN std_logic;          
		a_to_g : OUT std_logic_vector(6 downto 0);
		an : OUT std_logic_vector(3 downto 0);
		dp : OUT std_logic
		);
	END COMPONENT;

	COMPONENT hndshk
	PORT(
		hnd_o : IN std_logic;          
		hnd_i : OUT std_logic
		);
	END COMPONENT;

	COMPONENT SdCardCtrl
	PORT(
		clk_i : IN std_logic;
		reset_i : IN std_logic;
		rd_i : IN std_logic;
		wr_i : IN std_logic;
		continue_i : IN std_logic;
		addr_i : IN std_logic_vector(31 downto 0);
		data_i : IN std_logic_vector(7 downto 0);
		hndShk_i : IN std_logic;
		miso_i : IN std_logic;          
		data_o : OUT std_logic_vector(7 downto 0);
		busy_o : OUT std_logic;
		hndShk_o : OUT std_logic;
		error_o : OUT std_logic_vector(15 downto 0);
		cs_bo : OUT std_logic;
		sclk_o : OUT std_logic;
		mosi_o : OUT std_logic
		);
	END COMPONENT;

	COMPONENT Detector_flanco
	PORT(
		CLK : IN std_logic;
		Ent : IN std_logic;
		Reset : IN std_logic;          
		FA_S : OUT std_logic
		);
	END COMPONENT;

	COMPONENT reloj_configurable
	Generic (frecuencia_reloj: integer:=50000000; frecuencia_salida: integer:=8000);
	PORT(
		clk : IN std_logic;
		clr : IN std_logic;          
		clk_out : OUT std_logic
		);
	END COMPONENT;





signal aux_play,aux_recd, hdni, hdno, aux244 : std_logic;
signal error_o,sal2 : std_logic_vector(15 downto 0);
signal salida : std_logic_vector(7 downto 0);
begin
	Inst_Detector_flanco: Detector_flanco PORT MAP(
		CLK => clk,
		Ent => play,
		Reset => rst,
		FA_S => aux_play
	);
	
		Inst_Detector_flanco2: Detector_flanco PORT MAP(
		CLK => clk,
		Ent => recd,
		Reset => rst,
		FA_S => aux_recd
	);

	Inst_SdCardCtrl: SdCardCtrl PORT MAP(
		clk_i => clk,
		reset_i => rst,
		rd_i => aux_play,
		wr_i => aux_recd,
		continue_i => '0',
		addr_i => X"00000400",
		data_i => X"2c",
		data_o => salida,
		busy_o => busy_o,
		hndShk_i => hdni,
		hndShk_o => hdno,
		error_o => error_o,
		cs_bo => cs_bo,
		sclk_o => sclk_o,
		mosi_o => mosi_o,
		miso_i => miso_i
	);

	Inst_hndshk: hndshk PORT MAP(
		hnd_o => hdno,
		hnd_i => hdni
	);
sal2<=X"00"&salida(6 downto 0)&salida(7);
	Inst_Decod_7seg: Decod_7seg PORT MAP(
		Dato => X"00"&salida,
		clr => rst,
		clk => clk,
		en => aux244,
		a_to_g => a_to_g,
		an => an,
		dp => dp
	);

	Inst_reloj_configurable: reloj_configurable 
	Generic map(frecuencia_reloj => 100000000, frecuencia_salida => 244000)
	PORT MAP(
		clk => clk,
		clr => rst,
		clk_out => aux244
	);
end Behavioral;

