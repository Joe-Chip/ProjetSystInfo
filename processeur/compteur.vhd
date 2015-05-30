----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:24:34 03/23/2015 
-- Design Name: 
-- Module Name:    compteur - Behavioral 
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

entity compteur is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           SENS : in  STD_LOGIC;
           LOAD : in  STD_LOGIC;
           EN : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (7 downto 0);
           Dout : out  STD_LOGIC_VECTOR (7 downto 0));
end compteur;

architecture Behavioral of compteur is
	signal compteur: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
begin

	process 
		begin
			wait until CLK'event AND CLK='1'; 			
			if RST='0' then compteur <= "00000000" ; 
			else
				if LOAD='1' then compteur <= Din ;
				elsif EN='0' then
					if SENS='1' then compteur <= compteur + 1;
					else compteur <= compteur - 1 ;
					end if ; 
				end if;
			end if;
	end process;
Dout <= compteur;

end Behavioral;



