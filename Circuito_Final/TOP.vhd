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
				sel_velocidad : in std_logic;
			  play_pause : in  STD_LOGIC;
			  graba : in  STD_LOGIC;
			  sel_audio : in  STD_LOGIC;
			  grabar_reproducir : in  STD_LOGIC;
			  cs_bo      : out std_logic:= '1';  
			  sclk_o     : out std_logic:= '0';  
			  mosi_o     : out std_logic:= '1';  
			  error_o : out std_logic;
			  miso_i     : in  std_logic:= '0';
			  playing : out std_logic;
			  busyled : out std_logic;
			  senal_mic : out std_logic;
			  a_to_g : out  STD_LOGIC_VECTOR (6 downto 0);
           an : out  STD_LOGIC_VECTOR (7 downto 0);
           dp : out  STD_LOGIC;
			  m_lrsel: out std_logic;
           Vcc_out : out  STD_LOGIC);
end TOP;

architecture Behavioral of TOP is

	COMPONENT Detector_flanco
	PORT(
		CLK : IN std_logic;
		Ent : IN std_logic;
		Reset : IN std_logic;          
		FA_S : OUT std_logic
		);
	END COMPONENT;


	
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
	   ce : in std_logic;
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

	COMPONENT U_Operativa
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		cont_512 : IN std_logic;
		cont_WR : IN std_logic;
		rst_512 : IN std_logic;
		rst_WR : IN std_logic;          
		Fin_512 : OUT std_logic;
		Fin_WR : OUT std_logic
		);
	END COMPONENT;

	COMPONENT u_control
	PORT(
		Busy : IN std_logic;
		rd_wr : IN std_logic;
		play : IN std_logic;
		sigue : IN std_logic;
		grabar : IN std_logic;
		clk : IN std_logic;
		clr : IN std_logic;
		hndshk_o : IN std_logic;
		clk_40KHz : IN std_logic;
		clk_audio_RD : IN std_logic;
		Fin_512 : IN std_logic;
		Fin_WR : IN std_logic;          
		RD : OUT std_logic;
		WR : OUT std_logic;
		continue_i : OUT std_logic;
		cont_512 : OUT std_logic;
		cont_WR : OUT std_logic;
		rst_512 : OUT std_logic;
		rst_WR : OUT std_logic;
		CE_PWM : OUT std_logic;
		CE_selector : OUT std_logic;
		hndshk_i : OUT std_logic
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
		
		CHEQUEO_ADDR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		
		data_o : OUT std_logic_vector(7 downto 0);
		busy_o : OUT std_logic;
		hndShk_o : OUT std_logic;
		error_o : OUT std_logic;
		cs_bo : OUT std_logic;
		sclk_o : OUT std_logic;
		mosi_o : OUT std_logic
		);
	END COMPONENT;
	COMPONENT sel_modo
	PORT(
		grabar_reproducir : IN std_logic;          
		modo : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	COMPONENT Conmutador
	PORT(
		A : IN std_logic;
		clk : IN std_logic;
		rst : IN std_logic;
		clr_conmutador : IN std_logic;          
		B : OUT std_logic
		);
	END COMPONENT;


	COMPONENT prueba_MIC
	PORT(
		Microfono : IN signed(7 downto 0);
		Micro_SD : IN signed(7 downto 0);
		WR : IN std_logic;          
		PWM : OUT signed(7 downto 0)
		);
	END COMPONENT;

	COMPONENT direccion_SD
	PORT(
		CLR : IN std_logic;
		CLK : IN std_logic;
		CE : IN std_logic;
		sel_audio : IN std_logic;          
		address : OUT std_logic_vector(31 downto 0);
		num_audio : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	COMPONENT velocidad
	PORT(
		f_40KHz : IN std_logic;
		f_34KHz : IN std_logic;
		sel_velocidad : IN std_logic;          
		salida_F : OUT std_logic
		);
	END COMPONENT;


	

signal aux_2_5MHz,aux_312KHz,aux_40KHz,aux_PWM,aux_244,aux_1,dato_display,RD,WR,continue,FA_reproducir,aux_sigue,FA_graba,
		 aux_BUSY,aux_hndShk_i,aux_hndShk_o,aux_Fin_512, aux_Fin_WR,aux_Nueva_Muestra,aux_cont_WR,aux_rst_512,
		 aux_rst_WR,aux_CE_PWM,aux_CE_selector,fa_sel_audio,aux_cont_512,activar_PWM,aux_34KHz,aux_F_PWM  : std_logic;
signal aux_PCM : signed(17 downto 0);
signal muestra, aux_SD : std_logic_vector(7 downto 0);
signal aux_display,aux_addr,CHECK : std_logic_vector(31 downto 0);  
signal aux_error_o,selector : std_logic_vector(15 downto 0);
signal aux_num_audio : std_logic_vector(3 downto 0);
begin
m_lrsel<='0';

--====================================== INTERRUPTORES, PULSADORES Y FLANCOS ===============================================

	Inst_Detector_flanco_244: Detector_flanco PORT MAP(
		CLK => clk,
		Ent => aux_244,
		Reset => rst,
		FA_S => dato_display
	);	

	Inst_Detector_flanco_PLAY: Detector_flanco PORT MAP(
		CLK => clk,
		Ent => play_pause,
		Reset => rst,
		FA_S => FA_reproducir
	);	

	Inst_Detector_flanco_GRABAR: Detector_flanco PORT MAP(
		CLK => clk,
		Ent => graba,
		Reset => rst,
		FA_S => FA_graba
	);	

	Inst_Detector_flanco_SEL_AUDIO: Detector_flanco PORT MAP(
		CLK => clk,
		Ent => sel_audio,
		Reset => rst,
		FA_S => FA_sel_audio
	);
	
	Inst_Conmutador: Conmutador PORT MAP(
		A => FA_reproducir,
		clk => clk,
		rst => rst,
		clr_conmutador => aux_BUSY,
		B => aux_sigue
	);
	
playing<=aux_CE_PWM;

	Inst_direccion_SD: direccion_SD PORT MAP(
		CLR => rst,
		CLK => clk,
		CE => aux_CE_selector,
		sel_audio => FA_sel_audio,
		address => aux_addr,
		num_audio => aux_num_audio
	);

	Inst_sel_modo: sel_modo PORT MAP(
		grabar_reproducir => grabar_reproducir,
		modo => selector
	);
	
	Inst_velocidad: velocidad PORT MAP(
		f_40KHz => aux_40KHz,
		f_34KHz => aux_34KHz,
		sel_velocidad => sel_velocidad,
		salida_F => aux_F_PWM
	);
--====================================== GESTION DE AUDIOS =================================================================

	Inst_SdCardCtrl: SdCardCtrl PORT MAP(
		clk_i => clk,
		reset_i => rst,
		rd_i => RD,
		wr_i => WR,
		continue_i => continue,
		addr_i => aux_addr,
		data_i => std_logic_vector(aux_PCM(17 downto 10)),
		data_o => aux_SD,
		busy_o => aux_BUSY,
		
		CHEQUEO_ADDR => CHECK,
		
		hndShk_i => aux_hndShk_i,
		hndShk_o => aux_hndShk_o,
		error_o => error_o,
		cs_bo => cs_bo,
		sclk_o => sclk_o,
		mosi_o => mosi_o,
		miso_i => miso_i
	);
	
busyled<=aux_BUSY;

	Inst_u_control: u_control PORT MAP(
		Busy => aux_BUSY,
		rd_wr => grabar_reproducir,
		play => FA_reproducir,
		sigue => not(aux_sigue),
		grabar => FA_graba,
		clk => clk,
		clr => rst,
		hndshk_o => aux_hndShk_o,
		clk_40KHz => aux_40KHz,
		clk_audio_RD => aux_F_PWM,
		Fin_512 => aux_Fin_512,
		Fin_WR => aux_Fin_WR,
		RD => RD,
		WR => WR,
		continue_i => continue,
		cont_512 => aux_cont_512,
		cont_WR => aux_cont_WR,
		rst_512 => aux_rst_512,
		rst_WR => aux_rst_WR,
		CE_PWM => aux_CE_PWM,
		CE_selector => aux_CE_selector,
		hndshk_i => aux_hndShk_i
	);

	Inst_U_Operativa: U_Operativa PORT MAP(
		clk => clk,
		rst => rst,
		cont_512 => aux_cont_512,
		cont_WR => aux_cont_WR,
		rst_512 => aux_rst_512,
		rst_WR => aux_rst_WR,
		Fin_512 => aux_Fin_512,
		Fin_WR => aux_Fin_WR
	);

--====================================== SISTEMA ENTRADA Y SALIDA DE AUDIO =================================================
	Inst_PDM_to_PCM: PDM_to_PCM PORT MAP(
		clk => CLK,
		rst => rst,
		CLK_2_5_MHz => aux_2_5MHz,
		PDM => PDM,
		CLK_312_KHz => aux_312KHz,
		CLK_40_KHz => aux_40KHz,
		PCM => aux_PCM
	);
	
	
activar_PWM<=aux_CE_PWM or grabar_reproducir;	
		Inst_Control_PWM: Control_PWM PORT MAP(
		clk => clk,
		clr => rst,
		ce => activar_PWM,
		Muestra => signed(aux_SD),
		Salida_AUD_3_3V => Vcc_out,
		Salida_AUD_PWM => PWM 
	);
--====================================== DISPLAY 7 SEGMENTOS ===============================================================	
--		Inst_display_muestras: display_muestras PORT MAP(
--		un_segundo => aux_1,
--		clk => clk,
--		rst => rst,
--		entrada => std_logic_vector(audio_salida),
--		salida => muestra
--	);
aux_display<=X"FFF"&aux_num_audio&selector;
		Inst_Decod_7seg: Decod_7seg PORT MAP(
		Dato => aux_display,
		clr => rst,
		clk => clk,
		en => dato_display,
		a_to_g => a_to_g,
		an => an ,
		dp => dp
	);

--======================================== RELOJES CONFIGURABLES=====================================================0	
		Inst_reloj_configurable2_5MHz: reloj_configurable 
		Generic map(frecuencia_reloj => 100000000, frecuencia_salida => 2500000)
		PORT MAP(
		clk => CLK,
		clr => rst,
		clk_out => aux_2_5MHz
	);
senal_mic<= aux_2_5MHz;
		Inst_reloj_configurable40KHz: reloj_configurable 
	Generic map(frecuencia_reloj => 100000000, frecuencia_salida => 39062)
	PORT MAP(
		clk => clk,
		clr => rst,
		clk_out => aux_40KHz
	);
	Inst_reloj_configurable312KHz: reloj_configurable 
	Generic map(frecuencia_reloj => 100000000, frecuencia_salida => 312500)
	PORT MAP(
		clk => clk,
		clr => rst,
		clk_out => aux_312KHz
	);
	
	
	
		Inst_reloj_configurable244Hz: reloj_configurable 
	Generic map(frecuencia_reloj => 100000000, frecuencia_salida => 500)
	PORT MAP(
		clk => clk,
		clr => rst,
		clk_out => aux_244
	);
	
--			Inst_reloj_configurable1Hz: reloj_configurable 
--	Generic map(frecuencia_reloj => 100000000, frecuencia_salida => 1)
--	PORT MAP(
--		clk => clk,
--		clr => rst,
--		clk_out => aux_1
--	);
	
				Inst_reloj_configurable34KHz: reloj_configurable 
	Generic map(frecuencia_reloj => 100000000, frecuencia_salida => 35000)
	PORT MAP(
		clk => clk,
		clr => rst,
		clk_out => aux_34KHz
	);
end Behavioral;

