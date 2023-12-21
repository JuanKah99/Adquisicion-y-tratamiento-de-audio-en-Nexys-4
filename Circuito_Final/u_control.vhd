----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:11:47 05/24/2020 
-- Design Name: 
-- Module Name:    u_control - Behavioral 
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
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity u_control is
    Port ( Busy : in  STD_LOGIC;
           rd_wr : in  STD_LOGIC;
           play : in  STD_LOGIC;
			  sigue : in STD_LOGIC;
           grabar  : in  STD_LOGIC;
			  clk  : in  STD_LOGIC;
			  clr  : in  STD_LOGIC;
           hndshk_o : in  STD_LOGIC;
			  clk_40KHz : in  STD_LOGIC;
			  clk_audio_RD : IN std_logic;
			  Fin_512 : in  STD_LOGIC;
			  Fin_WR : in  STD_LOGIC;
			  RD : out  STD_LOGIC;
			  WR : out  STD_LOGIC;
			  continue_i : out STD_LOGIC;
			  cont_512 : out std_logic;
			  cont_WR : out std_logic;
			  rst_512 : out std_logic;
			  rst_WR : out std_logic;
			  CE_PWM : out std_logic;
			  CE_selector: out std_logic;
           hndshk_i : out  STD_LOGIC);
end u_control;

architecture Behavioral of u_control is


type estado_type is (IDLE,
							START,
							HOLD_PLAY,
							PRIMER_RD,
							CONFIRMACION_RD,
							PAUSADO_RD,
							REPRODUCIR_RD,
							MUESTRA_REPRODUCIDA_RD,
							OTRA_MUESTRA_RD,
							DATO_REPRODUCIDO_RD,
							FINALIZADO_RD,
							HOLD_GRABA,
							PRIMER_WR,
							CONFIRMACION_WR,
							ENVIA_WR,
							CUENTA_WR,
							BUCLE_WR,
							DATO_GUARDADO_WR,
							MENSAJE_GUARDADO_WR);
							
signal estado_actual, estado_siguiente : estado_type;

begin

process(clk,clr)
begin
	if clr='0' then
		estado_actual<=IDLE;
	elsif rising_edge(clk) then
		estado_actual<= estado_siguiente;
	end if;
end process;

process(Fin_512,Fin_WR,Busy,rd_wr,play,grabar,clk_40KHz,hndshk_o,sigue,clk_audio_RD,CLR,estado_actual)
begin
	case estado_actual is
	when IDLE=>
		if (Busy='0') then
			estado_siguiente<=START;
		else
			estado_siguiente<=IDLE;
		end if;
	when START=>
		if (rd_wr='0') then
			estado_siguiente<=HOLD_PLAY;
		else
			estado_siguiente<=HOLD_GRABA;
		end if;
		
--================ ETAPA REPRODUCCIÓN===========================
	when HOLD_PLAY=>
		if (play='1') then
			estado_siguiente<=PRIMER_RD;
		elsif (rd_wr='1') then
			estado_siguiente<=HOLD_GRABA;
		else
			estado_siguiente<=HOLD_PLAY;
		end if;
	when PRIMER_RD=>
		if (hndshk_o='1') then
			estado_siguiente<=REPRODUCIR_RD;
		else
			estado_siguiente<=PRIMER_RD;
		end if;		
	when CONFIRMACION_RD=>
		if (hndshk_o='1' and sigue='0') then
			estado_siguiente<=PAUSADO_RD;		
		elsif (hndshk_o='1' and sigue='1') then
			estado_siguiente<=REPRODUCIR_RD; 
		else
			estado_siguiente<=CONFIRMACION_RD;
		end if;
	
	when PAUSADO_RD=>
		if (hndshk_o='1' and sigue='1') then
			estado_siguiente<=REPRODUCIR_RD; 
		else
			estado_siguiente<=PAUSADO_RD;
		end if;
		
	when REPRODUCIR_RD=>
		if (clk_audio_RD='1') then
			estado_siguiente<=MUESTRA_REPRODUCIDA_RD; 
		else
			estado_siguiente<=REPRODUCIR_RD;
		end if;
		
	when MUESTRA_REPRODUCIDA_RD=>
		if (Fin_512='1') then
			estado_siguiente<=DATO_REPRODUCIDO_RD; 
		else
			estado_siguiente<=OTRA_MUESTRA_RD;
		end if;

	when OTRA_MUESTRA_RD=>
			estado_siguiente<=CONFIRMACION_RD; 
	when DATO_REPRODUCIDO_RD =>
		if (Fin_WR='1') then
			estado_siguiente<=FINALIZADO_RD; 
		else
			estado_siguiente<=CONFIRMACION_RD;
		end if;	
	when FINALIZADO_RD=>
			estado_siguiente<=HOLD_PLAY; 
--===========================================================

--================ ETAPA GRABACIÓN===========================

	when HOLD_GRABA=>
		if (grabar='1') then
			estado_siguiente<=PRIMER_WR;
		elsif (rd_wr='0') then
			estado_siguiente<=HOLD_PLAY;
		else
			estado_siguiente<=HOLD_GRABA;
		end if;
	when PRIMER_WR=>
		if (hndshk_o='1' and clk_40KHz='1') then
			estado_siguiente<=ENVIA_WR; 
		else
			estado_siguiente<=PRIMER_WR;
		end if;
	when CONFIRMACION_WR=>
		if (hndshk_o='1' and clk_40KHz='1') then
			estado_siguiente<=ENVIA_WR; 
		else
			estado_siguiente<=CONFIRMACION_WR;
		end if;
	when ENVIA_WR=>
			estado_siguiente<=CUENTA_WR; 
	when CUENTA_WR=>
		if (Fin_512='1') then
			estado_siguiente<=DATO_GUARDADO_WR; 
		else
			estado_siguiente<=BUCLE_WR;
		end if;

	when BUCLE_WR=>
			estado_siguiente<=CONFIRMACION_WR;
		
	when DATO_GUARDADO_WR=>
		if (Fin_WR='1') then
			estado_siguiente<=MENSAJE_GUARDADO_WR; 
		else
			estado_siguiente<=CONFIRMACION_WR;
		end if;

	when MENSAJE_GUARDADO_WR=>
			estado_siguiente<=HOLD_GRABA; 
--==========================================================

-----------------CASO RESET---------------------------------
	when others=>
		estado_siguiente<=IDLE;

		
	end case;
end process;


continue_i<='1' when (estado_actual=CONFIRMACION_RD or estado_actual=CONFIRMACION_WR) else '0';
RD<='1' when (estado_actual=CONFIRMACION_RD or estado_actual=PRIMER_RD) else '0';
WR<='1' when (estado_actual=CONFIRMACION_WR or estado_actual=PRIMER_WR) else '0';
hndshk_i<= '1' when (estado_actual=ENVIA_WR or estado_actual=REPRODUCIR_RD) else '0';
cont_512<='1' when (estado_actual=BUCLE_WR or estado_actual=OTRA_MUESTRA_RD) else '0';
cont_WR<='1' when (estado_actual=DATO_GUARDADO_WR or estado_actual=DATO_REPRODUCIDO_RD) else '0';
rst_512<='1' when (estado_actual=DATO_GUARDADO_WR or estado_actual=DATO_REPRODUCIDO_RD) else '0';
rst_WR<='1' when (estado_actual=MENSAJE_GUARDADO_WR or estado_actual=FINALIZADO_RD) else '0';
CE_PWM<= '1' when (estado_actual=REPRODUCIR_RD or estado_actual=CONFIRMACION_RD or estado_actual=PRIMER_RD or estado_actual=MUESTRA_REPRODUCIDA_RD or estado_actual=OTRA_MUESTRA_RD) else '0';
CE_selector<='1' when (estado_actual=HOLD_PLAY or estado_actual=HOLD_GRABA) else '0';
end Behavioral;

