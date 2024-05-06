----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2024 09:52:11 PM
-- Design Name: 
-- Module Name: register - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_unit is
    Port ( i_reset : in STD_LOGIC;
           i_D : in STD_LOGIC_VECTOR (7 downto 0);
           i_enable : in STD_LOGIC;
           o_Q : out STD_LOGIC_VECTOR (7 downto 0));
end register_unit;

architecture Behavioral of register_unit is

begin
    
    process (i_enable, i_D) 
        begin
            if i_enable = '1' then
                o_Q <= i_D;
            end if;
    end process;


end Behavioral;
