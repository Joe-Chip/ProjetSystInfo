----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:29:21 05/12/2015 
-- Design Name: 
-- Module Name:    memoire_instructions - Behavioral 
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

entity memoire_instructions is
    Port ( ADR : in  STD_LOGIC_VECTOR (7 downto 0);
           CLK : in  STD_LOGIC;
           DOUT : out  STD_LOGIC_VECTOR (31 downto 0));
end memoire_instructions;

architecture Behavioral of memoire_instructions is

type Banc_Memoire_32bit is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);

-- Initialisation de la ROM
signal Instructions : Banc_Memoire_32bit := (x"06010100", -- AFC R1 x01
															x"06030600", -- AFC R3 x06
															x"06020F00", -- AFC R2 x0F
															x"05000100", -- COP R0 R1
															x"05040000", -- COP R4 R0														
															x"01060003", -- ADD R6 R0 R3												
															x"03050600", -- SOU R5 R6 R0													
															x"08020500", -- STORE x02 R5 														
															x"07090200", -- LOAD R9 x02													
															others => (others => '0'));


begin

	process 
	begin
		wait until CLK'event AND CLK='0';
		DOUT <= Instructions(conv_integer(ADR));
	end process;

end Behavioral;

