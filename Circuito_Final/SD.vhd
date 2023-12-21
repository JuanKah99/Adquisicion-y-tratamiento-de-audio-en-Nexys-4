library ieee;
use ieee.math_real.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SdCardPckg.all;
entity SdCardCtrl is
  generic (
    FREQ_G          : real       := 100.0;     
    INIT_SPI_FREQ_G : real       := 0.4;  
    SPI_FREQ_G      : real       := 25.0;  
    BLOCK_SIZE_G    : natural    := 512  
    );
  port (
    clk_i      : in  std_logic;        
    reset_i    : in  std_logic                     := '0';  
    rd_i       : in  std_logic                     := '0';  
    wr_i       : in  std_logic                     :='0';  
    continue_i : in  std_logic                     := '0';  
    addr_i     : in  std_logic_vector(31 downto 0) := x"00000000";  
    data_i     : in  std_logic_vector(7 downto 0)  := x"00";  
    data_o     : out std_logic_vector(7 downto 0)  := x"00";  
    busy_o     : out std_logic;  
    hndShk_i   : in  std_logic;  
    hndShk_o   : out std_logic;  
    error_o    : out std_logic;
	 CHEQUEO_ADDR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	 
	 
    cs_bo      : out std_logic                     := '1';  
    sclk_o     : out std_logic                     := '0';  
    mosi_o     : out std_logic                     := '1';  
    miso_i     : in  std_logic                     := '0'  
    );
end entity;

architecture arch of SdCardCtrl is



  signal sclk_r   : std_logic;  
  signal hndShk_r : std_logic;  

begin
  
  process(clk_i)  

    type FsmState_t is (    
      START_INIT,   
      SEND_CMD0,                        
      CHK_CMD0_RESPONSE,   
      SEND_CMD8,  
      GET_CMD8_RESPONSE,               
      SEND_CMD55,                      
      SEND_CMD41,                       
		ENVIA_DATO,
      CHK_ACMD41_RESPONSE,   
      WAIT_FOR_HOST_RW,  
      RD_BLK,    
      WR_BLK,    
      WR_WAIT,   
      START_TX,                         
      TX_BITS,   
      GET_CMD_RESPONSE,  
      RX_BITS,  
      DESELECT,  
      PULSE_SCLK,  
      REPORT_ERROR                      
      );
    variable state_v    : FsmState_t := START_INIT;  
    variable rtnState_v : FsmState_t; 
    constant CLKS_PER_INIT_SCLK_C      : real    := FREQ_G / INIT_SPI_FREQ_G;
    constant CLKS_PER_SCLK_C           : real    := FREQ_G / SPI_FREQ_G;
    constant MAX_CLKS_PER_SCLK_C       : real    := realmax(CLKS_PER_INIT_SCLK_C, CLKS_PER_SCLK_C);
    constant MAX_CLKS_PER_SCLK_PHASE_C : natural := integer(round(MAX_CLKS_PER_SCLK_C / 2.0));
    constant INIT_SCLK_PHASE_PERIOD_C  : natural := integer(round(CLKS_PER_INIT_SCLK_C / 2.0));
    constant SCLK_PHASE_PERIOD_C       : natural := integer(round(CLKS_PER_SCLK_C / 2.0));
    constant DELAY_BETWEEN_BLOCK_RW_C  : natural := SCLK_PHASE_PERIOD_C;

    variable clkDivider_v     : natural range 0 to MAX_CLKS_PER_SCLK_PHASE_C;  
    variable sclkPhaseTimer_v : natural range 0 to MAX_CLKS_PER_SCLK_PHASE_C;  


    constant CRC_SZ_C    : natural := 2;  
    -- When reading blocks of data, get 0xFE + [DATA_BLOCK] + [CRC]. 1+512+2
    constant RD_BLK_SZ_C : natural := 1 + BLOCK_SIZE_G + CRC_SZ_C;
    -- When writing blocks of data, send 0xFF + 0xFE + [DATA BLOCK] + [CRC] then receive response byte. 1+1+512+2+1
    constant WR_BLK_SZ_C : natural := 1 + 1 + BLOCK_SIZE_G + CRC_SZ_C + 1;
    variable byteCnt_v   : natural range 0 to 517;  -- Tx/Rx byte counter.


    subtype Cmd_t is std_logic_vector(7 downto 0);
    constant CMD0_C          : Cmd_t := std_logic_vector(to_unsigned(16#40# + 0, Cmd_t'length));
    constant CMD8_C          : Cmd_t := std_logic_vector(to_unsigned(16#40# + 8, Cmd_t'length));
    constant CMD55_C         : Cmd_t := std_logic_vector(to_unsigned(16#40# + 55, Cmd_t'length));
    constant CMD41_C         : Cmd_t := std_logic_vector(to_unsigned(16#40# + 41, Cmd_t'length));
    constant READ_BLK_CMD_C  : Cmd_t := std_logic_vector(to_unsigned(16#40# + 17, Cmd_t'length));
    constant WRITE_BLK_CMD_C : Cmd_t := std_logic_vector(to_unsigned(16#40# + 24, Cmd_t'length));

    constant FAKE_CRC_C : std_logic_vector(7 downto 0) := x"FF";

    variable rx_v               : std_logic_vector(data_i'range);  

    variable addr_v : unsigned(addr_i'range); 

    subtype Response_t is std_logic_vector(rx_v'range);
    constant ACTIVE_NO_ERRORS_C : Response_t := "00000000";  
    constant IDLE_NO_ERRORS_C   : Response_t := "00000001"; 
    constant DATA_ACCEPTED_C    : Response_t := "---00101";  
    constant DATA_REJ_CRC_C     : Response_t := "---01011";  
    constant DATA_REJ_WERR_C    : Response_t := "---01101";  
    subtype Token_t is std_logic_vector(rx_v'range);
    constant NO_TOKEN_C         : Token_t    := x"FF";  
    constant START_TOKEN_C      : Token_t    := x"FE";  

    variable getCmdResponse_v : boolean;  
    variable rtnData_v        : boolean;  
    variable doDeselect_v     : boolean;  
    
	 -- Maximum Tx to SD card consists of command + address + CRC. Data Tx is just a single byte.
    variable tx_v : std_logic_vector(CMD0_C'length + addr_v'length + FAKE_CRC_C'length - 1 downto 0);  -- Data/command to SD card. 48 bits
    alias txCmd_v is tx_v;              -- Command transmission shift register.
    alias txData_v is tx_v(tx_v'high downto tx_v'high - data_i'length + 1);  -- Data byte transmission shift register.



    constant NUM_INIT_CLKS_C : natural := 160;  
    variable bitCnt_v        : natural range 0 to NUM_INIT_CLKS_C;  -- Tx/Rx bit counter.

  begin
    if rising_edge(clk_i) then
	 CHEQUEO_ADDR<= std_logic_vector(addr_v);
      if reset_i = '0' then             
        state_v          := START_INIT;  
        sclkPhaseTimer_v := 0;  
        busy_o           <= '1';  
			rtnState_v       := SEND_CMD0;
      elsif sclkPhaseTimer_v /= 0 then
        sclkPhaseTimer_v := sclkPhaseTimer_v - 1;
      elsif state_v /= START_INIT and hndShk_r ='1' and hndShk_i = '0' then
        null;            
      elsif state_v /= START_INIT and hndShk_r = '1' and hndShk_i ='1' then
        txData_v := data_i;             
        hndShk_r <= '0';  
      elsif state_v /= START_INIT and hndShk_r = '0' and hndShk_i = '1' then
        null;            
      elsif (state_v = START_INIT) or (hndShk_r = '0' and hndShk_i = '0') then
       
        
        busy_o <= '1';  

        case state_v is

          when START_INIT =>  
            error_o          <= '0';  
            clkDivider_v     := INIT_SCLK_PHASE_PERIOD_C - 1;  
            sclkPhaseTimer_v := INIT_SCLK_PHASE_PERIOD_C - 1;  
            sclk_r           <= '0';    
            hndShk_r         <= '0';     
            addr_v           := (others => '0');  
            rtnData_v        := false;  
            bitCnt_v         := NUM_INIT_CLKS_C;  
            state_v          := DESELECT;  
            rtnState_v       := SEND_CMD0;  
          when SEND_CMD0 =>            
            cs_bo            <='0';     
            txCmd_v          := CMD0_C & x"00000000" & x"95"; 
            bitCnt_v         := txCmd_v'length;  
            getCmdResponse_v := true;  
            doDeselect_v     := true;  
            state_v          := START_TX;  
            rtnState_v       := CHK_CMD0_RESPONSE; 
          when CHK_CMD0_RESPONSE =>  
            if rx_v = IDLE_NO_ERRORS_C then
              state_v := SEND_CMD8;  
            else
              state_v := SEND_CMD0;    
            end if;
            
          when SEND_CMD8 =>  
            cs_bo            <= '0';    
            txCmd_v          := CMD8_C & x"000001aa" & x"87";  
            bitCnt_v         := txCmd_v'length;  
            getCmdResponse_v := true;  
            doDeselect_v     := false;  
            state_v          := START_TX;  
            rtnState_v       := GET_CMD8_RESPONSE; 
            
          when GET_CMD8_RESPONSE =>     
            cs_bo            <= '0';  
            bitCnt_v         := 31;     
            getCmdResponse_v := false;  
            doDeselect_v     := true;  
            state_v          := RX_BITS;  
            rtnState_v       := SEND_CMD55;  

          when SEND_CMD55 =>  
            cs_bo            <= '0';     
            txCmd_v          := CMD55_C & x"00000000" & FAKE_CRC_C;
            bitCnt_v         := txCmd_v'length;  
            getCmdResponse_v := true;  
            doDeselect_v     := true;  
            state_v          := START_TX;  
            rtnState_v       := SEND_CMD41;  
            
          when SEND_CMD41 =>  
            cs_bo            <= '0';     
            txCmd_v          := CMD41_C & x"40000000" & FAKE_CRC_C; 
            bitCnt_v         := txCmd_v'length;  
            getCmdResponse_v := true;  
            doDeselect_v     := true;  
            state_v          := START_TX;  
            rtnState_v       := CHK_ACMD41_RESPONSE;  
            
          when CHK_ACMD41_RESPONSE =>
            if rx_v = ACTIVE_NO_ERRORS_C then   
              state_v := WAIT_FOR_HOST_RW;  
            elsif rx_v = IDLE_NO_ERRORS_C then  
              state_v := SEND_CMD55;    
            else                        
              state_v := REPORT_ERROR;  
            end if;
            
          when WAIT_FOR_HOST_RW =>  
            clkDivider_v     := SCLK_PHASE_PERIOD_C - 1;  
            getCmdResponse_v := true;  
            if rd_i = '1' then  
              cs_bo <= '0';             
              if continue_i = '1' then  
                  addr_v := addr_v + BLOCK_SIZE_G;  
                txCmd_v := READ_BLK_CMD_C & std_logic_vector(addr_v) & FAKE_CRC_C; 
              else                      
                txCmd_v := READ_BLK_CMD_C & addr_i & FAKE_CRC_C;  
                addr_v  := unsigned(addr_i);  
              end if;
              bitCnt_v   := txCmd_v'length;  
              byteCnt_v  := RD_BLK_SZ_C;
              state_v    := START_TX;  
              rtnState_v := RD_BLK; 
            elsif wr_i = '1' then  
              cs_bo <= '0';              
              if continue_i = '1' then  
                  addr_v := addr_v + BLOCK_SIZE_G;  
                txCmd_v := WRITE_BLK_CMD_C & std_logic_vector(addr_v) & FAKE_CRC_C;
              else                      
               txCmd_v := WRITE_BLK_CMD_C & addr_i & FAKE_CRC_C;  
               addr_v  := unsigned(addr_i);  
              end if;
              bitCnt_v   := txCmd_v'length;  
              byteCnt_v  := WR_BLK_SZ_C;    
              state_v    := START_TX; 
              rtnState_v := WR_BLK;  
            else              
              cs_bo   <= '1';           
              busy_o  <= '0';  
              state_v := WAIT_FOR_HOST_RW;  
            end if;

          when RD_BLK =>          
            rtnData_v  := false;  
            bitCnt_v   := rx_v'length - 1;   
            state_v    := RX_BITS;      
            rtnState_v := RD_BLK;   
            if byteCnt_v = RD_BLK_SZ_C then  
              byteCnt_v := byteCnt_v - 1;
            elsif byteCnt_v = RD_BLK_SZ_C -1 then  
              if rx_v = NO_TOKEN_C then  
                null;
              elsif rx_v = START_TOKEN_C then
                rtnData_v := true;  
                byteCnt_v := byteCnt_v - 1;
              else  
                state_v := REPORT_ERROR;
              end if;
            elsif byteCnt_v >= 3 then  
              rtnData_v := true;        
              byteCnt_v := byteCnt_v - 1;
            elsif byteCnt_v = 2 then  
              byteCnt_v := byteCnt_v - 1;
            elsif byteCnt_v = 1 then   
              byteCnt_v := byteCnt_v - 1;
            else    
              sclk_r     <= '0';
              bitCnt_v   := 2;
              state_v    := DESELECT;
              rtnState_v := WAIT_FOR_HOST_RW;
            end if;
            
          when WR_BLK =>             
            
            getCmdResponse_v := false;  
            bitCnt_v         := txData_v'length;  
            state_v          := START_TX;  
            rtnState_v       := WR_BLK;  
            if byteCnt_v = WR_BLK_SZ_C then
              txData_v := NO_TOKEN_C;  
            elsif byteCnt_v = WR_BLK_SZ_C - 1 then     
              txData_v := START_TOKEN_C;   
            elsif byteCnt_v >= 4 then   
              hndShk_r <= '1';           
           
            elsif byteCnt_v = 3 or byteCnt_v = 2 then  
              txData_v := FAKE_CRC_C;
            elsif byteCnt_v = 1 then
              bitCnt_v   := rx_v'length - 1;
              state_v    := RX_BITS;  
              rtnState_v := WR_WAIT;
            else                       
              if std_match(rx_v, DATA_ACCEPTED_C) then 
                state_v := WR_WAIT;  
              else                      
                error_o <= '1';
                state_v              := REPORT_ERROR;  
              end if;
            end if;
            byteCnt_v := byteCnt_v - 1;
            
          when WR_WAIT =>  

            sclk_r           <= not sclk_r;   
            sclkPhaseTimer_v := clkDivider_v;  
            if sclk_r = '1' and miso_i = '1' then 
              bitCnt_v   := 2;
              state_v    := DESELECT;
              rtnState_v := WAIT_FOR_HOST_RW;
            end if;
            
          when START_TX =>
            sclk_r           <= '0';  
            sclkPhaseTimer_v := clkDivider_v;  
            mosi_o           <= tx_v(tx_v'high);  
            tx_v             := tx_v(tx_v'high-1 downto 0) & '1';  
            bitCnt_v         := bitCnt_v - 1;  
            state_v          := TX_BITS;  
            
          when TX_BITS =>  
            sclk_r           <= not sclk_r;    
            sclkPhaseTimer_v := clkDivider_v;  
            if sclk_r = '1' then
              if bitCnt_v /= 0 then  
                mosi_o   <= tx_v(tx_v'high);
                tx_v     := tx_v(tx_v'high-1 downto 0) & '1';
                bitCnt_v := bitCnt_v - 1;
              else
                if getCmdResponse_v then
                  state_v  := GET_CMD_RESPONSE;  
                  bitCnt_v := Response_t'length - 1;  
                else
                  state_v          := rtnState_v;  
                  sclkPhaseTimer_v := 0;  
                end if;
              end if;
            end if;

          when GET_CMD_RESPONSE =>  
            if sclk_r = '1' and miso_i = '0' then
				hndShk_r <='0' ;
              rx_v     := rx_v(rx_v'high-1 downto 0) & miso_i;
              bitCnt_v := bitCnt_v - 1;
              state_v  := RX_BITS;  
            end if;
            sclk_r           <= not sclk_r;    
            sclkPhaseTimer_v := clkDivider_v;  

          when RX_BITS =>               
            if sclk_r ='1' then   
              rx_v := rx_v(rx_v'high-1 downto 0) & miso_i;
              if bitCnt_v /= 0 then    
                bitCnt_v := bitCnt_v - 1;
              else                     
                if rtnData_v then       
                  data_o   <= rx_v;     
                  hndShk_r <= '1';
                end if;
                if doDeselect_v then
                  bitCnt_v := 1;	
                  state_v  := DESELECT;  
                else
                  state_v := rtnState_v; 
                end if;
              end if;
            end if;
            sclk_r           <= not sclk_r;   
            sclkPhaseTimer_v := clkDivider_v; 

          when DESELECT => 
            doDeselect_v     := false; 
            cs_bo            <= '1';     
            mosi_o           <= '1';  
            state_v          := PULSE_SCLK;  
            sclk_r           <= '0';  
            sclkPhaseTimer_v := clkDivider_v;  
            
          when PULSE_SCLK =>  
            if sclk_r = '1' then
              if bitCnt_v /= 0 then
                bitCnt_v := bitCnt_v - 1;
              else  
                state_v := rtnState_v;
              end if;
            end if;
            sclk_r           <= not sclk_r;    
            sclkPhaseTimer_v := clkDivider_v;  
            
          when REPORT_ERROR =>  
            error_o <= '1';  
            busy_o              <= '0';  

          when others =>
            state_v := START_INIT;
        end case;
      end if;
    end if;
  end process;


  sclk_o   <= sclk_r;    
  hndShk_o <= hndShk_r; 
  
end architecture;
