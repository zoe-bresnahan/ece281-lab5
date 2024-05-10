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
            i_op : in signed(2 downto 0);
            i_A : in signed(7 downto 0);
            i_B : in signed(7 downto 0);
            o_result : out signed(7 downto 0);
            o_flags : out std_logic_vector(2 downto 0)
        );
    end component ALU1;
    
    signal w_op : signed(2 downto 0);
    signal w_A : signed(7 downto 0);
    signal w_B : signed(7 downto 0);
    signal w_result : signed(7 downto 0);
    signal w_flags : std_logic_vector(2 downto 0);
    
    
begin
    uut_inst : ALU1
     port map (
               i_op => w_op,
               i_A => w_A,
               i_B => w_B,
               o_result => w_result,
               o_flags => w_flags
           );
           
       process
       begin
           w_op <= "000";
           w_A <= to_signed(2, 8);
           w_B <= to_signed(1, 8);
           wait for 10 ns;
           assert (w_result = to_signed(2 + 1, 8)) and (w_flags = "100") report "bad add 1" severity error;
           wait for 10 ns;
           
           w_op <= "001";
           w_A <= to_signed(3, 8);
           w_B <= to_signed(7, 8);
           wait for 10 ns;
           assert (w_result = to_signed(3 - 7, 8)) and (w_flags = "000") report "bad sub 1" severity error;
           wait for 10 ns;
           
           w_op <= "000";
           w_A <= to_signed(120, 8);
           w_B <= to_signed(10, 8);
           wait for 10 ns;
           assert (w_result = to_signed(120 + 10, 8)) and (w_flags = "010") report "bad add 2" severity error;
           wait for 10 ns;
           
           w_op <= "001";
           w_A <= to_signed(0, 8);
           w_B <= to_signed(-127, 8);
           wait for 10 ns;
           assert (w_result = to_signed(-127, 8)) and (w_flags = "010") report "bad sub 2" severity error;
           wait for 10 ns;
   
   
           w_op <= "010";  -- OR
           w_A <= "01010001";
           w_B <= "00110100";
           wait for 10 ns;
           assert (w_result = "01100101") and (w_flags = "100") report "bad or" severity error;
           wait for 10 ns;
           
           w_op <= "011";  -- AND
           w_A <= "01010001";
           w_B <= "00110100";
           wait for 10 ns;
           assert (w_result = "00010000") and (w_flags = "100") report "bad and" severity error;
           wait for 10 ns;
                   
           w_op <= "100";  -- LLS
           w_A <= "00001000";
           w_B <= "00000001";
           wait for 10 ns;
           assert (w_result = "00010000") and (w_flags = "100") report "bad left shift" severity error;
           wait for 10 ns;
                           
           w_op <= "101";  -- RLS
           w_A <= "00001000";
           w_B <= "00000010";
           wait for 10 ns;
           assert (w_result = "00000010") and (w_flags = "100") report "bad right shift" severity error;
           wait for 10 ns;
           
           wait;
       end process;   

end Behavioral;
