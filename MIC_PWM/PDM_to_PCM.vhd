library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PDM_to_PCM is
    port (
      clk  : in std_logic;
      rst : in std_logic;

      CLK_2_5_MHz : in std_logic; -- 2.5 MHz
      PDM : in std_logic;
      CLK_312_KHz : in std_logic; -- 312.5 kHz
      CLK_40_KHz : in std_logic; -- 39062.5 Hz
      
      PCM : out signed (17 downto 0)
      );
end entity;

architecture Behavorial of PDM_to_PCM is

    signal aux_FIR : signed (17 downto 0);

begin



  Filtro_FIR_1: entity work.Filtro_FIR_1
    port map -- decimation : premier filtre fir
      (
      clk => clk,
      rst => rst,
      CLK_2_5_MHz => CLK_2_5_MHz,
      DATA => PDM,
      CLK_312_KHz => CLK_312_KHz,
      FIR_1 => aux_FIR
      );

  Filtro_FIR_2: entity work.Filtro_FIR_2
    port map -- decimation : second filtre fir
      (
      clk => clk,
      rst => rst,
      CLK_312_KHz => CLK_312_KHz,
      FIR_1 => aux_FIR,
      CLK_40_KHz => CLK_40_KHz,
      FIR_2 => PCM
      );

end architecture;
