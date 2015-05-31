----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:30:44 05/28/2015 
-- Design Name: 
-- Module Name:    gestion_aleas - Behavioral 
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

entity gestion_aleas is
    Port ( CLK : in STD_LOGIC;
			  COP_LI : in  STD_LOGIC_VECTOR (7 downto 0);
           B_LI : in  STD_LOGIC_VECTOR (7 downto 0);
           C_LI : in  STD_LOGIC_VECTOR (7 downto 0);
           COP_DI : in  STD_LOGIC_VECTOR (7 downto 0);
           A_DI : in  STD_LOGIC_VECTOR (7 downto 0);
           COP_EX : in  STD_LOGIC_VECTOR (7 downto 0);
           A_EX : in  STD_LOGIC_VECTOR (7 downto 0);
           COP_MEM : in  STD_LOGIC_VECTOR (7 downto 0);
           A_MEM : in  STD_LOGIC_VECTOR (7 downto 0);
           OUT_EN : out  STD_LOGIC;
           OUT_LOAD : out  STD_LOGIC;
			  OUT_Instruction : out  STD_LOGIC_VECTOR (31 downto 0));
end gestion_aleas;

architecture Behavioral of gestion_aleas is

constant NOP : STD_LOGIC_VECTOR (7 downto 0) := x"00";
constant ADD : STD_LOGIC_VECTOR (7 downto 0) := x"01";
constant SOU : STD_LOGIC_VECTOR (7 downto 0) := x"03";
constant COP : STD_LOGIC_VECTOR (7 downto 0) := x"05";
constant AFC : STD_LOGIC_VECTOR (7 downto 0) := x"06";
-- constant OP_LOAD : STD_LOGIC_VECTOR (7 downto 0) := x"07";
constant STORE : STD_LOGIC_VECTOR (7 downto 0) := x"08";
constant JMP : STD_LOGIC_VECTOR (7 downto 0) := x"09";

signal flag_attente : STD_LOGIC := '0';

begin

	flag_attente <= '1' when ((COP_DI = AFC or COP_DI = COP or 		-- Etage DI
									   COP_DI = ADD or COP_DI = SOU)
									  and
									  (((COP_LI = COP or COP_LI = ADD or	--		Conflit opérande B
										  COP_LI = SOU or COP_LI = STORE)
									    and A_DI = B_LI)
									   or
									   ((COP_LI = ADD or COP_LI = SOU)  	--		Conflit opérande C
									    and A_DI = B_LI)))
									 or
									 ((COP_EX = AFC or COP_EX = COP or 		-- Etage EX
									   COP_EX = ADD or COP_EX = SOU)
									  and
									  (((COP_LI = COP or COP_LI = ADD or	--		Conflit opérande B
										  COP_LI = SOU or COP_LI = STORE)
									    and A_EX = B_LI)
									   or
									   ((COP_LI = ADD or COP_LI = SOU)  	--		Conflit opérande C
									    and A_EX = C_LI)))
									 or
									 ((COP_MEM = AFC or COP_MEM = COP or 	-- Etage MEM
									   COP_MEM = ADD or COP_MEM = SOU)
									  and
									  (((COP_LI = COP or COP_LI = ADD or	--		Conflit opérande B
										  COP_LI = SOU or COP_LI = STORE)
									    and A_MEM = B_LI)
									   or
									   ((COP_LI = ADD or COP_LI = SOU)  	--		Conflit opérande C
									    and A_MEM = C_LI)))
                                     or
                                     (COP_LI = JMP or COP_DI = JMP or       -- JMP
                                      COP_EX = JMP or COP_MEM = JMP)
									 else
						 '0';

		
	OUT_EN <= '1' when flag_attente = '1' else
				 '0';
	OUT_LOAD <= '1' when COP_LI = JMP else
                '0';
	OUT_Instruction <= x"00000000";

end Behavioral;

