--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:55:17 05/12/2015
-- Design Name:   
-- Module Name:   /home/salaun/4IR/ProjetSystInfo/processeur/banc_registres_test.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: banc_registres
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
 
ENTITY banc_registres_test IS
END banc_registres_test;
 
ARCHITECTURE behavior OF banc_registres_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT banc_registres
    PORT(
         ADR_A : IN  std_logic_vector(3 downto 0);
         ADR_B : IN  std_logic_vector(3 downto 0);
         ADR_W : IN  std_logic_vector(3 downto 0);
         W : IN  std_logic;
         DATA : IN  std_logic_vector(7 downto 0);
         RST : IN  std_logic;
         CLK : IN  std_logic;
         QA : OUT  std_logic_vector(7 downto 0);
         QB : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ADR_A : std_logic_vector(3 downto 0) := (others => '0');
   signal ADR_B : std_logic_vector(3 downto 0) := (others => '0');
   signal ADR_W : std_logic_vector(3 downto 0) := (others => '0');
   signal W : std_logic := '0';
   signal DATA : std_logic_vector(7 downto 0) := (others => '0');
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal QA : std_logic_vector(7 downto 0);
   signal QB : std_logic_vector(7 downto 0);

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: banc_registres PORT MAP (
          ADR_A => ADR_A,
          ADR_B => ADR_B,
          ADR_W => ADR_W,
          W => W,
          DATA => DATA,
          RST => RST,
          CLK => CLK,
          QA => QA,
          QB => QB
        );

   -- Clock process definitions
	CLK <= not CLK after 5 ns;

	------------------- Description du test effectué ------------------
	-- Reset
	-- Remplit les registres de données (entre 20 et 340 ns)
	-- Lit les données sur chaque sortie : sur A de 0 à 15
	--		et sur B de 15 à 0 (de 360 à 640 ns)
	-- Reset encore (650 ns)
	-- Lit les données sur la sortie A pour vérifier que le reset a bien été effectué
	
 

	-- Parcours le banc de registre de 0 à 15, une fois lorsque le banc est rempli 
	-- de données, une deuxième fois après un reset
	ADR_A <= x"0", x"1" after 360 ns, x"2" after 380 ns, x"3" after 400 ns,
				x"4" after 420 ns, x"5" after 440 ns, x"6" after 460 ns, x"7" after 480 ns,
				x"8" after 500 ns, x"9" after 520 ns, x"A" after 540 ns, x"B" after 560 ns,
				x"C" after 580 ns, x"D" after 600 ns, x"E" after 620 ns, x"F" after 640 ns,
				x"0" after 680 ns, x"1" after 700 ns, x"2" after 720 ns, x"3" after 740 ns,
				x"4" after 760 ns, x"5" after 780 ns, x"6" after 800 ns, x"7" after 820 ns,
				x"8" after 840 ns, x"9" after 860 ns, x"A" after 880 ns, x"B" after 900 ns,
				x"C" after 920 ns, x"D" after 940 ns, x"E" after 960 ns, x"F" after 980 ns;
	
	-- Parcours le banc de registres de 15 à 0 une fois que le banc est rempli
	ADR_B <= x"F", x"E" after 360 ns, x"D" after 380 ns, x"C" after 400 ns,
				x"B" after 420 ns, x"A" after 440 ns, x"9" after 460 ns, x"8" after 480 ns,
				x"7" after 500 ns, x"6" after 520 ns, x"5" after 540 ns, x"4" after 560 ns,
				x"3" after 580 ns, x"2" after 600 ns, x"1" after 620 ns, x"0" after 640 ns;
		
	
	-- Ecrit à l'adresse suivante toutes les 25 ns
	ADR_W <= ADR_W + '1' after 20 ns;
	
	-- DATA augmente à chaque changement d'état de l'horloge
	process
	begin
		wait until CLK'event;
		DATA <= DATA + '1';
	end process;
	
	-- Remplir les registres
	W <= '0', '1' after 20 ns, '0' after 340 ns;
	
	-- Commencer par reset, jouer, puis reset encore
	RST <= '0', '1' after 15 ns, '0' after 650 ns, '1' after 665 ns;

END;
