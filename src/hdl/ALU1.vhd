----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2024 09:58:07 PM
-- Design Name: 
-- Module Name: ALU1 - Behavioral
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

--ADD 000
--SUB 001
--OR 010
--AND 011
--Left 10X
--RIGHT 11X
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

entity ALU1 is
    Port ( i_A : in signed (7 downto 0);
           i_B : in signed (7 downto 0);
           i_op : in signed (2 downto 0);
           o_result : out signed (7 downto 0);
           o_flags : out std_logic_vector (2 downto 0));
end ALU1;

architecture Behavioral of ALU1 is
    signal w_result : signed(7 downto 0);
    signal w_adder : signed(7 downto 0);
    signal w_boolean : signed(7 downto 0);
    signal w_leftshift : signed(7 downto 0);
    signal w_rightshift : signed(7 downto 0);
    signal w_check1 : signed(8 downto 0);
    signal w_check2 : signed(8 downto 0);
    signal w_check3 : signed(8 downto 0);
    
begin
    
    w_check1 <=
        to_signed(to_integer(i_A) + to_integer(i_B), 9) when (i_op(0) = '0') else
        to_signed(to_integer(i_A) - to_integer(i_B), 9);
        
   w_adder <= 
        to_signed(to_integer(i_A) + to_integer(i_B),8) when (i_op(0) = '0') else
        to_signed(to_integer(i_A) - to_integer(i_B),8);
        
   w_boolean <=
       (i_A or i_B) when (i_op(0) = '0') else
       (i_A and i_B);
       
   w_leftshift <=
        resize(signed(shift_right(unsigned(i_A), to_integer(i_B(2 downto 0)))), 8) when (i_op(2 downto 1) = "10");
   
   w_check2 <=
       resize(signed(shift_left(unsigned(i_A), to_integer(i_B(2 downto 0)))), 9) when (i_op(2 downto 1) = "10");
   
   w_rightshift <=
       resize(signed(shift_left(unsigned(i_A), to_integer(i_B(2 downto 0)))), 8) when (i_op(2 downto 1) = "11");
       
   w_check3 <=
       resize(signed(shift_right(unsigned(i_A), to_integer(i_B(2 downto 0)))), 9) when (i_op(2 downto 1) = "11");

    w_result <= 
        w_adder when (i_op(2 downto 1) = "00") else
        w_boolean when (i_op(2 downto 1) = "01") else
        w_leftshift when (i_op(2 downto 1) = "10") else
        w_rightshift when (i_op(2 downto 1) = "11");
        
    o_result <= signed(w_result(7 downto 0));
    o_flags(0) <= w_check1(8) or w_check2(8) or w_check3(8); --carry
    o_flags(1) <= '1' when (w_result(7 downto 0) = "00000000") else '0'; --zero
    o_flags(2) <= not(w_result(7)); --sign flag (on when +)
        
    

end Behavioral;
