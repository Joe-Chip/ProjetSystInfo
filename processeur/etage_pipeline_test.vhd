--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:21:51 05/21/2015
-- Design Name:   
-- Module Name:   /home/salaun/4IR/ProjetSystInfo/processeur/etage_pipeline_test.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: etage_pipeline
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
 
ENTITY etage_pipeline_test IS
END etage_pipeline_test;
 
ARCHITECTURE behavior OF etage_pipeline_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT etage_pipeline
    PORT(
         IN_COP : IN  std_logic_vector(7 downto 0);
         IN_A : IN  std_logic_vector(7 downto 0);
         IN_B : IN  std_logic_vector(7 downto 0);
         IN_C : IN  std_logic_vector(7 downto 0);
         CLK : IN  std_logic;
         OUT_COP : OUT  std_logic_vector(7 downto 0);
         OUT_A : OUT  std_logic_vector(7 downto 0);
         OUT_B : OUT  std_logic_vector(7 downto 0);
         OUT_C : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal IN_COP : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_A : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_B : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_C : std_logic_vector(7 downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal OUT_COP : std_logic_vector(7 downto 0);
   signal OUT_A : std_logic_vector(7 downto 0);
   signal OUT_B : std_logic_vector(7 downto 0);
   signal OUT_C : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: etage_pipeline PORT MAP (
          IN_COP => IN_COP,
          IN_A => IN_A,
          IN_B => IN_B,
          IN_C => IN_C,
          CLK => CLK,
          OUT_COP => OUT_COP,
          OUT_A => OUT_A,
          OUT_B => OUT_B,
          OUT_C => OUT_C
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;



	------------------- Description du test effectué ------------------
	-- Chaque entrée s'incrémente à un rythme différent, permet de vérifier
	-- qu'elles sont mises à jour uniquement sur front d'horloge

	IN_A <= IN_A + '1' after 10 ns;
	IN_B <= IN_B + '1' after 15 ns;
	IN_C <= IN_C + '1' after 20 ns;
	IN_COP <= IN_COP + '1' after 25 ns;


END;
