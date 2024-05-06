----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2024 09:54:09 AM
-- Design Name: 
-- Module Name: ALU1_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU1_tb is
--  Port ( );
end ALU1_tb;

architecture Behavioral of ALU1_tb is

    component ALU1 is
        port( 
            i_op : in std_logic_vector(2 downto 0);
            i_A : in signed(7 downto 0);
            i_B : in signed(7 downto 0);
            o_result : out signed(7 downto 0);
            o_flags : out std_logic_vector(2 downto 0)
        );
    end component ALU1;
    
    signal w_op : std_logic_vector(2 downto 0);
    signal w_A : signed(7 downto 0);
    signal w_B : signed(7 downto 0);
    signal w_result : signed(7 downto 0);
    signal w_flags : std_logic_vector(2 downto 0);
    
    
begin
    uut_inst : ALU1
        

end Behavioral;
