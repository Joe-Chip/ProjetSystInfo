----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:50:32 04/28/2015 
-- Design Name: 
-- Module Name:    ual - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ual is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           Ctrl_Ual : in  STD_LOGIC_VECTOR (2 downto 0);
           N : out  STD_LOGIC;
           Z : out  STD_LOGIC;
           O : out  STD_LOGIC;
           C : out  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (7 downto 0));
end ual;

architecture Behavioral of ual is

signal AExt : STD_LOGIC_VECTOR (8 downto 0);
signal Bext : STD_LOGIC_VECTOR (8 downto 0);
signal Result : STD_LOGIC_VECTOR (8 downto 0);

constant ADD : STD_LOGIC_VECTOR (2 downto 0) := "001";
constant SOU: STD_LOGIC_VECTOR (2 downto 0) := "011";

begin	

	-- Operation effectuee selon Ctrl_Ual
	with Ctrl_Ual select
		Result <= ('0' & A) + ('0' & B) when ADD,
					 ('0' & A) - ('0' & B) when SOU,
					 (others => '0') when others;
					 
	-- Mise a jour des flags et du resultat
	S <= Result(7 downto 0);
		
	C <= Result(8);
	Z <= '1' when Result (7 downto 0) = x"00" else
		  '0';
	N <= Result(7);
	O <= '1' when (A(7) = '0' and B(7) = '0' and Result(7) = '1')
					  or ((A(7) = '1' or B(7) = '1') and Result(7) = '0') else
		  '0'; 

end Behavioral;

