--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:34:32 05/21/2015
-- Design Name:   
-- Module Name:   /home/salaun/4IR/ProjetSystInfo/processeur/multiplexeur_test.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: multiplexeur
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY multiplexeur_test IS
END multiplexeur_test;
 
ARCHITECTURE behavior OF multiplexeur_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT multiplexeur
    PORT(
         IN_A : IN  std_logic_vector(7 downto 0);
         IN_B : IN  std_logic_vector(7 downto 0);
         PILOT : IN  std_logic;
         DOUT : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal IN_A : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_B : std_logic_vector(7 downto 0) := (others => '0');
   signal PILOT : std_logic := '0';

 	--Outputs
   signal DOUT : std_logic_vector(7 downto 0);


BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: multiplexeur PORT MAP (
          IN_A => IN_A,
          IN_B => IN_B,
          PILOT => PILOT,
          DOUT => DOUT
        );
	
	IN_A <= IN_A + '1' after 10 ns;
	IN_B <= IN_B - '1' after 10 ns;

	PILOT <= '0', '1' after 500 ns;

END;
