library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Filtro_FIR_1 is
  port (
    clk  : in std_logic; -- 100MHz
    rst  : in std_logic; 

    CLK_2_5_MHz : in std_logic; 
    DATA : in std_logic; 

    CLK_312_KHz : in std_logic; 
    FIR_1 : out signed(17 downto 0) := (others => '0') 
    );
  end entity;

architecture Behavorial of Filtro_FIR_1 is

  type coef_mem_t is array (natural range <>) of signed(15 downto 0);
  constant coef_mem : coef_mem_t(0 to 128-1) := (
    0   => to_signed( -1      , 16),
    1   => to_signed( -3      , 16),
    2   => to_signed( -5      , 16),
    3   => to_signed( -7      , 16),
    4   => to_signed( -10     , 16),
    5   => to_signed( -13     , 16),
    6   => to_signed( -17     , 16),
    7   => to_signed( -20     , 16),
    8   => to_signed( -22     , 16),
    9   => to_signed( -23     , 16),
    10  => to_signed( -21     , 16),
    11  => to_signed( -15     , 16),
    12  => to_signed( -4      , 16),
    13  => to_signed( 13      , 16),
    14  => to_signed( 37      , 16),
    15  => to_signed( 68      , 16),
    16  => to_signed( 108     , 16),
    17  => to_signed( 154     , 16),
    18  => to_signed( 208     , 16),
    19  => to_signed( 266     , 16),
    20  => to_signed( 325     , 16),
    21  => to_signed( 383     , 16),
    22  => to_signed( 433     , 16),
    23  => to_signed( 471     , 16),
    24  => to_signed( 491     , 16),
    25  => to_signed( 484     , 16),
    26  => to_signed( 445     , 16),
    27  => to_signed( 367     , 16),
    28  => to_signed( 244     , 16),
    29  => to_signed( 72      , 16),
    30  => to_signed( -151    , 16),
    31  => to_signed( -425    , 16),
    32  => to_signed( -747    , 16),
    33  => to_signed( -1110   , 16),
    34  => to_signed( -1503   , 16),
    35  => to_signed( -1912   , 16),
    36  => to_signed( -2319   , 16),
    37  => to_signed( -2701   , 16),
    38  => to_signed( -3033   , 16),
    39  => to_signed( -3287   , 16),
    40  => to_signed( -3434   , 16),
    41  => to_signed( -3445   , 16),
    42  => to_signed( -3289   , 16),
    43  => to_signed( -2939   , 16),
    44  => to_signed( -2373   , 16),
    45  => to_signed( -1572   , 16),
    46  => to_signed( -522    , 16),
    47  => to_signed( 781     , 16),
    48  => to_signed( 2333    , 16),
    49  => to_signed( 4124    , 16),
    50  => to_signed( 6131    , 16),
    51  => to_signed( 8325    , 16),
    52  => to_signed( 10666   , 16),
    53  => to_signed( 13108   , 16),
    54  => to_signed( 15599   , 16),
    55  => to_signed( 18080   , 16),
    56  => to_signed( 20491   , 16),
    57  => to_signed( 22769   , 16),
    58  => to_signed( 24856   , 16),
    59  => to_signed( 26693   , 16),
    60  => to_signed( 28230   , 16),
    61  => to_signed( 29423   , 16),
    62  => to_signed( 30238   , 16),
    63  => to_signed( 30652   , 16),
    64  => to_signed( 30652   , 16),
    65  => to_signed( 30238   , 16),
    66  => to_signed( 29423   , 16),
    67  => to_signed( 28230   , 16),
    68  => to_signed( 26693   , 16),
    69  => to_signed( 24856   , 16),
    70  => to_signed( 22769   , 16),
    71  => to_signed( 20491   , 16),
    72  => to_signed( 18080   , 16),
    73  => to_signed( 15599   , 16),
    74  => to_signed( 13108   , 16),
    75  => to_signed( 10666   , 16),
    76  => to_signed( 8325    , 16),
    77  => to_signed( 6131    , 16),
    78  => to_signed( 4124    , 16),
    79  => to_signed( 2333    , 16),
    80  => to_signed( 781     , 16),
    81  => to_signed( -522    , 16),
    82  => to_signed( -1572   , 16),
    83  => to_signed( -2373   , 16),
    84  => to_signed( -2939   , 16),
    85  => to_signed( -3289   , 16),
    86  => to_signed( -3445   , 16),
    87  => to_signed( -3434   , 16),
    88  => to_signed( -3287   , 16),
    89  => to_signed( -3033   , 16),
    90  => to_signed( -2701   , 16),
    91  => to_signed( -2319   , 16),
    92  => to_signed( -1912   , 16),
    93  => to_signed( -1503   , 16),
    94  => to_signed( -1110   , 16),
    95  => to_signed( -747    , 16),
    96  => to_signed( -425    , 16),
    97  => to_signed( -151    , 16),
    98  => to_signed( 72      , 16),
    99  => to_signed( 244     , 16),
    100 => to_signed( 367     , 16),
    101 => to_signed( 445     , 16),
    102 => to_signed( 484     , 16),
    103 => to_signed( 491     , 16),
    104 => to_signed( 471     , 16),
    105 => to_signed( 433     , 16),
    106 => to_signed( 383     , 16),
    107 => to_signed( 325     , 16),
    108 => to_signed( 266     , 16),
    109 => to_signed( 208     , 16),
    110 => to_signed( 154     , 16),
    111 => to_signed( 108     , 16),
    112 => to_signed( 68      , 16),
    113 => to_signed( 37      , 16),
    114 => to_signed( 13      , 16),
    115 => to_signed( -4      , 16),
    116 => to_signed( -15     , 16),
    117 => to_signed( -21     , 16),
    118 => to_signed( -23     , 16),
    119 => to_signed( -22     , 16),
    120 => to_signed( -20     , 16),
    121 => to_signed( -17     , 16),
    122 => to_signed( -13     , 16),
    123 => to_signed( -10     , 16),
    124 => to_signed( -7      , 16),
    125 => to_signed( -5      , 16),
    126 => to_signed( -3      , 16),
    127 => to_signed( -1      , 16)
           );

  signal coef_out : signed(15 downto 0);
  signal coef_out_reg : signed(15 downto 0);

  type data_in_mem_t is  array (natural range <>) of std_logic;
  signal data_in_mem : data_in_mem_t(0 to 128-1) :=(others => '0');

  signal data_out : std_logic;
  signal data_out_reg : std_logic;

  signal ptr_in : unsigned(6 downto 0) := (others => '0'); 
  signal ptr_out : unsigned(6 downto 0) := (others => '0'); 
  signal ptr_out_reg : unsigned(6 downto 0) := (others => '0'); 
  signal ptr_coef : unsigned(6 downto 0) := (others => '0'); 
  signal ptr_coef_reg : unsigned(6 downto 0); 

  signal cpt : integer range 0 to 127+10; 

  signal acc : signed(20 downto 0) := (others => '0'); 


  begin

  process (clk,rst)

    begin
	 if rst='0' then
		  ptr_in <= (others => '0');
		  cpt <= 0;
		  FIR_1 <= to_signed(0,FIR_1'length);

    elsif rising_edge(clk) then

      if CLK_2_5_MHz='1' then 
        data_in_mem(to_integer(ptr_in)) <= DATA; 
        ptr_in <= ptr_in + 1; 
      end if;

      if (CLK_312_KHz='1' and (cpt=0)) then 
        cpt <= cpt + 1; 
        ptr_out <= ptr_in + 1;  
        ptr_coef <= to_unsigned(127,ptr_coef'length); 
        acc <= (others => '0');
      end if;

      if (cpt /= 0) then 
        cpt <= cpt + 1;
        ptr_out <= ptr_out + 1; 
        ptr_coef <= ptr_coef - 1; 
      end if;

      if (cpt>=4) and (cpt<128+4) then 
        if data_out_reg='0' then
          acc <= acc - coef_out_reg; 
        else
          acc <= acc + coef_out_reg; 
          end if;
      elsif (cpt=128+4) then 
        if (acc(acc'high downto 2) < -2**17) then 
          FIR_1 <= to_signed(-2**17,FIR_1'length);
        elsif (acc(acc'high downto 2) > 2**17 - 1) then 
          FIR_1 <= to_signed(2**17 - 1,FIR_1'length);
        else
          FIR_1 <= acc(17+2 downto 2); 
          end if;
        cpt <= 0;
      end if;

      ptr_out_reg <= ptr_out; 
      data_out <= data_in_mem(to_integer(ptr_out_reg));
      data_out_reg <= data_out; 

      ptr_coef_reg <= ptr_coef; 
      coef_out <= coef_mem(to_integer(ptr_coef_reg)); 
      coef_out_reg <= coef_out;

    end if;
    
  end process;

  end architecture;