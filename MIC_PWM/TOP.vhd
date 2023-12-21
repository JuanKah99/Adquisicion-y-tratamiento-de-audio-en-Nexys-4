----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:53:39 11/05/2023 
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
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
    Port ( PDM : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           PWM : out  STD_LOGIC;
			  ocupado  : out  STD_LOGIC;
			  CLK_2_5_MHz : out std_logic;
			  			  a_to_g : out  STD_LOGIC_VECTOR (6 downto 0);
           an : out  STD_LOGIC_VECTOR (7 downto 0);
           dp : out  STD_LOGIC;
			  m_lrsel: out std_logic;
			  interruptor : in std_logic;
           Vcc_out : out  STD_LOGIC);
end TOP;

architecture Behavioral of TOP is

--	COMPONENT reverb
--	PORT(
--		CLK100MHZ : IN std_logic;
--		CPU_RESETN : IN std_logic;
--		clk_ech : IN std_logic;
--		ech_in : IN signed(17 downto 0);          
--		ech_out : OUT signed(17 downto 0)
--		);
--	END COMPONENT;

	COMPONENT Decod_7seg
	PORT(
		Dato : IN std_logic_vector(31 downto 0);
		clr : IN std_logic;
		clk : IN std_logic;
		en : IN std_logic;          
		a_to_g : OUT std_logic_vector(6 downto 0);
		an : OUT std_logic_vector(7 downto 0);
		dp : OUT std_logic
		);
	END COMPONENT;

	COMPONENT display_muestras
	PORT(
		un_segundo : IN std_logic;
		clk : IN std_logic;
		rst : IN std_logic;
		entrada : IN std_logic_vector(7 downto 0);          
		salida : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;



	COMPONENT PDM_to_PCM
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		CLK_2_5_MHz : IN std_logic;
		PDM : IN std_logic;
		CLK_312_KHz : IN std_logic;
		CLK_40_KHz : IN std_logic;          
		PCM : OUT signed(17 downto 0)
		);
	END COMPONENT;

	COMPONENT Control_PWM
	PORT(
		clk : IN std_logic;
		clr : IN std_logic;
		Nueva_Muestra : IN std_logic;
	   ce : in std_logic;
		busy_PWM : out STD_LOGIC;
		Muestra : IN signed(7 downto 0);          
		Salida_AUD_3_3V : OUT std_logic;
		Salida_AUD_PWM : OUT std_logic
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

	COMPONENT CTR_511
	PORT(
		CLK : IN std_logic;
		CE : IN std_logic;
		Reset : IN std_logic;
		rst_512 : IN std_logic;          
		TC : OUT std_logic
		);
	END COMPONENT;

	COMPONENT memoria_pulsador
	PORT(
		entrada : IN std_logic;
		rst : IN std_logic;
		clk : IN std_logic;
		rst_cnt : IN std_logic;          
		salida : OUT std_logic
		);
	END COMPONENT;

--		COMPONENT auto_vol
--	PORT(
--		clk : IN std_logic;
--		rst : IN std_logic;
--		clk_ce_in : IN std_logic;
--		ech_in : IN signed(17 downto 0);          
--		ech_out : OUT signed(17 downto 0)
--		);
--	END COMPONENT;

	
signal aux_2_5MHz,aux_312KHz,aux_40KHz, activa_cnt, aux_cnt,aux_PWM,contador,aux_244 ,aux_1: std_logic;
signal aux_PCM,aux_reverb,aux_vol : signed(17 downto 0);
signal PORFA : signed(7 downto 0);
signal AYUDA,muestra : std_logic_vector(7 downto 0);
signal aux_display : std_logic_vector(31 downto 0);
begin
m_lrsel<='0';

--	Inst_reverb: reverb PORT MAP(
--		CLK100MHZ => clk,
--		CPU_RESETN => rst,
--		clk_ech => aux_40KHz,
--		ech_in => aux_PCM,
--		ech_out => aux_vol
--	);
--	
--
--	Inst_auto_vol: auto_vol PORT MAP(
--		clk => clk,
--		rst => rst,
--		clk_ce_in => aux_40KHz,
--		ech_in => aux_vol,
--		ech_out => aux_reverb
--	);
contador<= activa_cnt and aux_40KHz;
	Inst_CTR_511: CTR_511 PORT MAP(
		CLK => clk,
		CE =>contador,
		Reset => rst,
		rst_512 => '0',
		TC => aux_cnt
	);

	Inst_memoria_pulsador: memoria_pulsador PORT MAP(
		entrada => interruptor,
		rst => rst,
		clk => clk,
		rst_cnt => aux_cnt,
		salida => activa_cnt
	);
	
	aux_PWM<=not(aux_cnt) and activa_cnt;
	Inst_PDM_to_PCM: PDM_to_PCM PORT MAP(
		clk => CLK,
		rst => rst,
		CLK_2_5_MHz => aux_2_5MHz,
		PDM => PDM,
		CLK_312_KHz => aux_312KHz,
		CLK_40_KHz => aux_40KHz,
		PCM => aux_PCM
	);
		Inst_Control_PWM: Control_PWM PORT MAP(
		clk => CLK,
		clr => rst,
		ce => aux_PWM,
		Nueva_Muestra => aux_40KHz,
		Muestra => aux_PCM(17 downto 10),
		busy_PWM => ocupado,
		Salida_AUD_3_3V => Vcc_out,
		Salida_AUD_PWM => PWM 
	);
	
		Inst_display_muestras: display_muestras PORT MAP(
		un_segundo => aux_1,
		clk => clk,
		rst => rst,
		entrada => std_logic_vector(aux_vol(17 downto 10)),
		salida => muestra
	);
aux_display<=X"FFFFFF"&muestra;
		Inst_Decod_7seg: Decod_7seg PORT MAP(
		Dato => aux_display,
		clr => rst,
		clk => clk,
		en => aux_244,
		a_to_g => a_to_g,
		an => an ,
		dp => dp
	);
	
		Inst_reloj_configurable: reloj_configurable 
		Generic map(frecuencia_reloj => 100000000, frecuencia_salida => 2500000)
		PORT MAP(
		clk => CLK,
		clr => rst,
		clk_out => aux_2_5MHz
	);
	CLK_2_5_MHz<= aux_2_5MHz;
		Inst_reloj_configurable2: reloj_configurable 
	Generic map(frecuencia_reloj => 100000000, frecuencia_salida => 39062)
	PORT MAP(
		clk => clk,
		clr => rst,
		clk_out => aux_40KHz
	);
	Inst_reloj_configurable3: reloj_configurable 
	Generic map(frecuencia_reloj => 100000000, frecuencia_salida => 312500)
	PORT MAP(
		clk => clk,
		clr => rst,
		clk_out => aux_312KHz
	);
	
	
	
		Inst_reloj_configurable244: reloj_configurable 
	Generic map(frecuencia_reloj => 100000000, frecuencia_salida => 244000)
	PORT MAP(
		clk => clk,
		clr => rst,
		clk_out => aux_244
	);
	
			Inst_reloj_configurable1: reloj_configurable 
	Generic map(frecuencia_reloj => 100000000, frecuencia_salida => 1)
	PORT MAP(
		clk => clk,
		clr => rst,
		clk_out => aux_1
	);
end Behavioral;

