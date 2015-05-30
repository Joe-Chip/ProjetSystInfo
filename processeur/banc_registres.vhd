----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:01:58 05/12/2015 
-- Design Name: 
-- Module Name:    banc_registres - Behavioral 
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


entity banc_registres is
    Port ( ADR_A : in  STD_LOGIC_VECTOR (3 downto 0);
           ADR_B : in  STD_LOGIC_VECTOR (3 downto 0);
           ADR_W : in  STD_LOGIC_VECTOR (3 downto 0);
           W : in  STD_LOGIC;
           DATA : in  STD_LOGIC_VECTOR (7 downto 0);
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           QA : out  STD_LOGIC_VECTOR (7 downto 0);
           QB : out  STD_LOGIC_VECTOR (7 downto 0));
end banc_registres;

architecture Behavioral of banc_registres is

type Banc_Registre_8bit is array (0 to 15) of STD_LOGIC_VECTOR(7 downto 0);

signal Registres : Banc_Registre_8bit;

begin

	-- Reset et écriture synchrones avec l'horloge
	process 
	begin
		wait until CLK'event AND CLK='0';
		if RST = '0' then
			-- Reset actif à 0
			Registres <= (others => x"00");
		else
			-- Ecriture active à 1
			if W = '1' then
				Registres(conv_integer(ADR_W)) <= DATA;
			end if;
		end if;
	end process;
	
	-- Sortie A recoit le contenu du registre désigné par ADR_A sauf si écriture dans ce registre
	QA <= DATA when W = '1' and ADR_A = ADR_W else
			Registres(conv_integer(ADR_A));
	-- Idem pour B
	QB <= DATA when W = '1' and ADR_B = ADR_W else
			Registres(conv_integer(ADR_B));
			
			
			
end Behavioral;

