--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:09:20 04/28/2015
-- Design Name:   
-- Module Name:   /home/salaun/4IR/ProjetSystInfo/processeur/ual_test.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ual
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
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ual_test IS
END ual_test;
 
ARCHITECTURE behavior OF ual_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ual
    PORT(
         A : IN  std_logic_vector(7 downto 0);
         B : IN  std_logic_vector(7 downto 0);
         Ctrl_Ual : IN  std_logic_vector(2 downto 0);
         N : OUT  std_logic;
         Z : OUT  std_logic;
         O : OUT  std_logic;
         C : OUT  std_logic;
         S : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(7 downto 0) := (others => '0');
   signal B : std_logic_vector(7 downto 0) := (others => '0');
   signal Ctrl_Ual : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal N : std_logic;
   signal Z : std_logic;
   signal O : std_logic;
   signal C : std_logic;
   signal S : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ual PORT MAP (
          A => A,
          B => B,
          Ctrl_Ual => Ctrl_Ual,
          N => N,
          Z => Z,
          O => O,
          C => C,
          S => S
        );

	A <= "00000000", "00000001" after 55 ns, "00000000" after 60 ns, "00000001" after 140 ns, "00000000" after 275 ns, "00001000" after 600 ns,
		  "11111101" after 775 ns, "01111101" after 825 ns;
	B <= "00000000", "00000001" after 175 ns, "00000100" after 275 ns, "00001000" after 600 ns, "00000111" after 775 ns, "01111111" after 825 ns;
	Ctrl_Ual <= "000", "001" after 50 ns, "011" after 100 ns, "001" after 150 ns, "000" after 200 ns, "001" after 250 ns, "011" after 300 ns,
					"000" after 450 ns, "011" after 550 ns, "001" after 650 ns, "011" after 700 ns, "000" after 750 ns, "001" after 800 ns;
					--"000" after 850ns, "000" after 900ns, "000" after 950ns;

END;
