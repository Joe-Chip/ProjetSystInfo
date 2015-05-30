--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:48:05 05/21/2015
-- Design Name:   
-- Module Name:   /home/salaun/4IR/ProjetSystInfo/processeur/memoire_donnees_test.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: memoire_donnees
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
 
ENTITY memoire_donnees_test IS
END memoire_donnees_test;
 
ARCHITECTURE behavior OF memoire_donnees_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT memoire_donnees
    PORT(
         ADR : IN  std_logic_vector(7 downto 0);
         DIN : IN  std_logic_vector(7 downto 0);
         RW : IN  std_logic;
         RST : IN  std_logic;
         CLK : IN  std_logic;
         DOUT : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ADR : std_logic_vector(7 downto 0) := (others => '0');
   signal DIN : std_logic_vector(7 downto 0) := (others => '0');
   signal RW : std_logic := '0';
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal DOUT : std_logic_vector(7 downto 0);

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: memoire_donnees PORT MAP (
          ADR => ADR,
          DIN => DIN,
          RW => RW,
          RST => RST,
          CLK => CLK,
          DOUT => DOUT
        );

   -- Clock process definitions
	CLK <= not CLK after 5 ns;

	------------------- Description du test effectué ------------------
	-- Reset
	-- Remplit les adresses entre 0 et 7 de données (de 20 et 140 ns)
	-- Lit les données sur des adresses de 0 à 7 (de 180 à 320 ns)
	-- Reset encore (340 ns)
	-- Lit les données sur la sortie A pour vérifier que le reset a bien été effectué

	ADR <= x"00", x"01" after 20 ns, x"02" after 40 ns, x"03" after 60 ns,
			 x"04" after 80 ns, x"05" after 100 ns, x"06" after 120 ns, x"07" after 140 ns,
			 x"00" after 180 ns, x"01" after 200 ns, x"02" after 220 ns, x"03" after 240 ns,
			 x"04" after 260 ns, x"05" after 280 ns, x"06" after 300 ns, x"07" after 320 ns,
			 x"00" after 360 ns, x"01" after 380 ns, x"02" after 400 ns, x"03" after 420 ns,
			 x"04" after 440 ns, x"05" after 460 ns, x"06" after 480 ns, x"07" after 500 ns;


	DIN <= DIN + '1' after 20 ns;


	RW <= '0', '1' after 160 ns;


	-- Commencer par reset, jouer, puis reset encore
	RST <= '0', '1' after 15 ns, '0' after 330 ns, '1' after 350 ns;

END;
