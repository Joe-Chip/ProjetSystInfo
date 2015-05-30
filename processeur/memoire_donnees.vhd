----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:30:37 05/12/2015 
-- Design Name: 
-- Module Name:    memoire_donnees - Behavioral 
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

entity memoire_donnees is
    Port ( ADR : in  STD_LOGIC_VECTOR (7 downto 0);
           DIN : in  STD_LOGIC_VECTOR (7 downto 0);
           RW : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           DOUT : out  STD_LOGIC_VECTOR (7 downto 0));
end memoire_donnees;

architecture Behavioral of memoire_donnees is

type Banc_Memoire_8bit is array (0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
signal Donnees : Banc_Memoire_8bit;

begin

	process 
	begin
		wait until CLK'event AND CLK='0';
		if RST = '0' then
			Donnees <= (others => x"00");
		else
			if RW = '1' then
				DOUT <= Donnees(conv_integer(ADR));
			else
				Donnees(conv_integer(ADR)) <= DIN;
			end if;
		end if;
	end process;

end Behavioral;

