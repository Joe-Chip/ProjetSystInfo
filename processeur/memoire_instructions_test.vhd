--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:58:03 05/27/2015
-- Design Name:   
-- Module Name:   /home/salaun/4IR/ProjetSystInfo/processeur/memoire_instructions_test.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: memoire_instructions
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY memoire_instructions_test IS
END memoire_instructions_test;
 
ARCHITECTURE behavior OF memoire_instructions_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT memoire_instructions
    PORT(
         ADR : IN  std_logic_vector(7 downto 0);
         CLK : IN  std_logic;
         DOUT : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ADR : std_logic_vector(7 downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal DOUT : std_logic_vector(31 downto 0);

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: memoire_instructions PORT MAP (
          ADR => ADR,
          CLK => CLK,
          DOUT => DOUT
        );

   -- Clock process definitions
	CLK <= not CLK after 5 ns;

	-- Test : Il faut mettre des éléments en dur dans la mémoire pour voir
	-- les actions sur la sortie
	ADR <= ADR + '1' after 3 ns;

END;
