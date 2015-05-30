----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:13:18 05/12/2015 
-- Design Name: 
-- Module Name:    etage_pipeline - Behavioral 
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

entity etage_pipeline is
    Port ( IN_COP : in  STD_LOGIC_VECTOR (7 downto 0);
           IN_A : in  STD_LOGIC_VECTOR (7 downto 0);
           IN_B : in  STD_LOGIC_VECTOR (7 downto 0);
           IN_C : in  STD_LOGIC_VECTOR (7 downto 0);
           CLK : in  STD_LOGIC;
           OUT_COP : out  STD_LOGIC_VECTOR (7 downto 0);
           OUT_A : out  STD_LOGIC_VECTOR (7 downto 0);
           OUT_B : out  STD_LOGIC_VECTOR (7 downto 0);
           OUT_C : out  STD_LOGIC_VECTOR (7 downto 0));
end etage_pipeline;

architecture Behavioral of etage_pipeline is

begin

	process
	begin
		wait until CLK'event and CLK='1';
		OUT_COP <= IN_COP;
      OUT_A <= IN_A;
      OUT_B <= IN_B;
      OUT_C <= IN_C;
	end process;

end Behavioral;

