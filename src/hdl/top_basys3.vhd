--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top_basys3 is
-- TODO
    port(
    --inputs
        clk : in std_logic;
        sw : in std_logic_vector(15 downto 0);
        btnU : in std_logic;
        btnC : in std_logic;
    --outputs
        led : out std_logic_vector(15 downto 0);
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(3 downto 0)
    );
    
    
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
  
	-- declare components and signals
	component sevenSegDecoder is
         port(
             i_D : in std_logic_vector(3 downto 0);
             o_S : out std_logic_vector(6 downto 0)
            );
    end component sevenSegDecoder;
       
       
    component TDM4 is
         generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
         port(      
            i_clk        : in  STD_LOGIC;
            i_reset      : in  STD_LOGIC; 
            i_D3         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
            i_D2         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
            i_D1         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
            i_D0         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
            o_data       : out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
            o_sel        : out STD_LOGIC_VECTOR (3 downto 0)    -- selected data line (one-cold)
         );
    end component TDM4;
    
    component twoscomp_decimal is
        port (
            i_binary: in std_logic_vector(7 downto 0);
            o_negative: out std_logic;
            o_hundreds: out std_logic_vector(3 downto 0);
            o_tens: out std_logic_vector(3 downto 0);
            o_ones: out std_logic_vector(3 downto 0)
        );
    end component twoscomp_decimal;

    component clock_divider is
        generic ( constant k_DIV : natural := 2);
        port (  
            i_clk    : in std_logic;
            i_reset  : in std_logic;       
            o_clk    : out std_logic           
        );
    end component clock_divider;
    
    component controller_fsm is
        Port ( i_reset : in STD_LOGIC;
               i_adv : in STD_LOGIC;
               o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
    end component controller_fsm;
    
    component ALU1 is
        port (
            i_A : in signed(7 downto 0);
            i_B : in signed(7 downto 0);
            i_op : in std_logic_vector(2 downto 0);
            o_result : out std_logic_vector(7 downto 0);
            o_flags : out std_logic_vector(2 downto 0)
        );
    end component ALU1;
    
    component register_unit is
        port (
             i_reset : in STD_LOGIC;
             i_D : in STD_LOGIC_VECTOR (7 downto 0);
             i_enable : in STD_LOGIC;
             o_Q : out STD_LOGIC_VECTOR (7 downto 0));
       end component register_unit;

--signals
    signal w_cycle : std_logic_vector(3 downto 0);
    signal w_regA : std_logic_vector(7 downto 0);
    signal w_regB : std_logic_vector(7 downto 0);
    signal w_result : std_logic_vector(7 downto 0);
    signal w_bin : std_logic_vector(7 downto 0);
    signal w_negative : std_logic;
    signal w_sign : std_logic_vector(3 downto 0);
    signal w_hund : std_logic_vector(3 downto 0);
    signal w_tens : std_logic_vector(3 downto 0);
    signal w_ones : std_logic_vector(3 downto 0);
    signal w_data : std_logic_vector(3 downto 0);
    signal w_anode : std_logic_vector(3 downto 0);
    signal w_clk : std_logic;
    
begin
	-- PORT MAPS ----------------------------------------
	controller_fsm_inst : controller_fsm
       port map(
           i_reset => btnU,
           i_adv => btnC,
           o_cycle => w_cycle
        );
        
    register_unit_instA : register_unit
       port map(
           i_reset => btnU,
           i_D => sw(7 downto 0),
           i_enable => w_cycle(1),
           o_Q => w_regA
       );
              
    register_unit_instB : register_unit
       port map(
           i_reset => btnU,
           i_D => sw(7 downto 0),
           i_enable => w_cycle(2),
           o_Q => w_regB
       );
       
    ALU1_inst : ALU1
       port map(
           i_A => signed(w_regA),
           i_B => signed(w_regB),
           i_op => sw(2 downto 0),
           o_result => w_result,
           o_flags => led(15 downto 13)
       );
 	
 	--mux
 	w_bin <= w_regA when (w_cycle = "0010") else
 	         w_regB when (w_cycle = "0100") else
 	         std_logic_vector(w_result) when (w_cycle = "1000") else
 	         "00000000";
 	
    twoscomp_decimal_inst : twoscomp_decimal
       port map(
           i_binary => w_bin,
           o_negative => w_negative,
           o_hundreds => w_hund,
           o_tens => w_tens,
           o_ones => w_ones
       );      
    --make the sign bit a vector to put into TDM
    --choose hex A and B because cannot use 0-9
    w_sign <= x"A" when (w_negative = '1') else x"B";
    
	TDM4_inst : TDM4
	   port map(
	       i_clk => w_clk,
	       i_reset => btnU,
	       i_D3 => w_sign,
	       i_D2 => w_hund,
	       i_D1 => w_tens,
	       i_D0 => w_ones,
	       o_data => w_data,
	       o_sel => w_anode
	    );
	    
	clock_divider_inst : clock_divider
	   generic map(k_DIV => 31250)
	   port map(
	       i_clk => clk,
	       i_reset => btnU,
	       o_clk => w_clk
	    );
	    
	sevenSegDecoder_inst : sevenSegDecoder
       port map(
           i_D => w_data,
           o_S => seg
       );

	    
	

	-- CONCURRENT STATEMENTS ----------------------------
	an(3) <= w_anode(3);
	an(2) <= w_anode(2);
	an(1) <= w_anode(1);
	an(0) <= w_anode(0);
	
	led(3 downto 0) <= w_cycle;
	led(12 downto 4) <= (others => '0');
	
end top_basys3_arch;
