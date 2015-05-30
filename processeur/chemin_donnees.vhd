----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:20:18 05/13/2015 
-- Design Name: 
-- Module Name:    chemin_donnees - Behavioral 
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

entity chemin_donnees is
    Port ( CLK : in  STD_LOGIC;
			  RST : in	STD_LOGIC);
	end chemin_donnees;

architecture Behavioral of chemin_donnees is

	component etage_pipeline
		Port ( IN_COP : in  STD_LOGIC_VECTOR (7 downto 0);
				 IN_A : in  STD_LOGIC_VECTOR (7 downto 0);
				 IN_B : in  STD_LOGIC_VECTOR (7 downto 0);
				 IN_C : in  STD_LOGIC_VECTOR (7 downto 0);
				 CLK : in  STD_LOGIC;
				 OUT_COP : out  STD_LOGIC_VECTOR (7 downto 0);
				 OUT_A : out  STD_LOGIC_VECTOR (7 downto 0);
				 OUT_B : out  STD_LOGIC_VECTOR (7 downto 0);
				 OUT_C : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component banc_registres
		Port ( ADR_A : in  STD_LOGIC_VECTOR (3 downto 0);
				 ADR_B : in  STD_LOGIC_VECTOR (3 downto 0);
				 ADR_W : in  STD_LOGIC_VECTOR (3 downto 0);
				 W : in  STD_LOGIC;
				 DATA : in  STD_LOGIC_VECTOR (7 downto 0);
				 RST : in  STD_LOGIC;
				 CLK : in  STD_LOGIC;
				 QA : out  STD_LOGIC_VECTOR (7 downto 0);
				 QB : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component ual
		Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
				 B : in  STD_LOGIC_VECTOR (7 downto 0);
				 Ctrl_Ual : in  STD_LOGIC_VECTOR (2 downto 0);
				 N : out  STD_LOGIC;
				 Z : out  STD_LOGIC;
				 O : out  STD_LOGIC;
				 C : out  STD_LOGIC;
				 S : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component memoire_donnees
	    Port ( ADR : in  STD_LOGIC_VECTOR (7 downto 0);
				  DIN : in  STD_LOGIC_VECTOR (7 downto 0);
				  RW : in  STD_LOGIC;
				  RST : in  STD_LOGIC;
				  CLK : in  STD_LOGIC;
				  DOUT : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component memoire_instructions
	    Port ( ADR : in  STD_LOGIC_VECTOR (7 downto 0);
				  CLK : in  STD_LOGIC;
				  DOUT : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	component compteur
		Port ( CLK : in  STD_LOGIC;
			    RST : in  STD_LOGIC;
			    SENS : in  STD_LOGIC;
			    LOAD : in  STD_LOGIC;
			    EN : in  STD_LOGIC;
			    Din : in  STD_LOGIC_VECTOR (7 downto 0);
			    Dout : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component multiplexeur
		Port ( IN_A : in  STD_LOGIC_VECTOR (7 downto 0);
				 IN_B : in  STD_LOGIC_VECTOR (7 downto 0);
				 PILOT : in  STD_LOGIC;
				 DOUT : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component gestion_aleas is
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
				 OUT_Instruction : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	-- Constantes pour les Codes Opération
	constant NOP : STD_LOGIC_VECTOR (7 downto 0) := x"00";
	constant ADD : STD_LOGIC_VECTOR (7 downto 0) := x"01";
	-- constant MUL : STD_LOGIC_VECTOR (7 downto 0) := x"02"; -- Non utilisé
	constant SOU : STD_LOGIC_VECTOR (7 downto 0) := x"03";
	-- constant DIV : STD_LOGIC_VECTOR (7 downto 0) := x"04"; -- Non utilisé
	constant COP : STD_LOGIC_VECTOR (7 downto 0) := x"05";
	constant AFC : STD_LOGIC_VECTOR (7 downto 0) := x"06";
	constant LOAD : STD_LOGIC_VECTOR (7 downto 0) := x"07";
	constant STORE : STD_LOGIC_VECTOR (7 downto 0) := x"08";
	
	-- Signaux internes :
	--		Etage LI
	signal compt_inst : STD_LOGIC_VECTOR (7 downto 0);
	signal instruction_out : STD_LOGIC_VECTOR (31 downto 0);
	signal instruction_NOP : STD_LOGIC_VECTOR (31 downto 0);
	signal instruction_choisie : STD_LOGIC_VECTOR (31 downto 0);
	signal enable_cpt : STD_LOGIC;
	
	--		Etage DI
	signal OP_DI : STD_LOGIC_VECTOR (7 downto 0);
	signal A_DI : STD_LOGIC_VECTOR (7 downto 0);
	signal B_DI_IN : STD_LOGIC_VECTOR (7 downto 0);
	signal B_DI_REG_MUX : STD_LOGIC_VECTOR (7 downto 0);
	signal B_DI_OUT : STD_LOGIC_VECTOR (7 downto 0);
	signal C_DI_IN : STD_LOGIC_VECTOR (7 downto 0);
	signal C_DI_OUT : STD_LOGIC_VECTOR (7 downto 0);
	signal PILOT_DI : STD_LOGIC;
	
	--		Etage EX
	signal OP_EX : STD_LOGIC_VECTOR (7 downto 0);
	signal A_EX : STD_LOGIC_VECTOR (7 downto 0);
	signal B_EX_IN : STD_LOGIC_VECTOR (7 downto 0);
	signal B_EX_UAL_MUX : STD_LOGIC_VECTOR (7 downto 0);
	signal B_EX_OUT : STD_LOGIC_VECTOR (7 downto 0);
	signal C_EX : STD_LOGIC_VECTOR (7 downto 0);
	signal CTR_UAL : STD_LOGIC_VECTOR (2 downto 0);
	signal PILOT_EX : STD_LOGIC;
	
	--		Etage MEM
	signal OP_MEM : STD_LOGIC_VECTOR (7 downto 0);
	signal A_MEM : STD_LOGIC_VECTOR (7 downto 0);
	signal B_MEM_IN : STD_LOGIC_VECTOR (7 downto 0);
	signal B_MEM_MUX_LOAD : STD_LOGIC_VECTOR (7 downto 0);
	signal B_MEM_MUX_STORE : STD_LOGIC_VECTOR (7 downto 0);
	signal B_MEM_OUT : STD_LOGIC_VECTOR (7 downto 0);
	signal RW : STD_LOGIC;
	signal PILOT_MEM_LOAD : STD_LOGIC;
	signal PILOT_MEM_STORE : STD_LOGIC;	

	--		Etage ER
	signal OP_ER : STD_LOGIC_VECTOR (7 downto 0);
	signal A_ER : STD_LOGIC_VECTOR (7 downto 0);
	signal B_ER : STD_LOGIC_VECTOR (7 downto 0);
	signal W_ER : STD_LOGIC;

begin

	-- Etage LI : Compteur d'instructions
	cpt_instructions : compteur port map(CLK => CLK,
										 RST => RST,
										 SENS => '1',
										 LOAD => '0',
										 EN => enable_cpt,
										 Din => x"00",
										 Dout => compt_inst);
										 
	-- Etage LI : Mémoire d'instructions
	mem_ins : memoire_instructions port map(ADR => compt_inst,
											 CLK => CLK,
											 DOUT => instruction_out);

	-- Etage LI : Choix de l'instruction à propager
	instruction_choisie <= instruction_out when enable_cpt = '0' else
								  instruction_NOP;

	-- Pipeline : LI/DI
	etage_LI_DI : etage_pipeline port map(IN_COP => instruction_choisie(31 downto 24),
										  IN_A => instruction_choisie(23 downto 16),
										  IN_B => instruction_choisie(15 downto 8),
										  IN_C => instruction_choisie(7 downto 0),
										  CLK => CLK,
										  OUT_COP => OP_DI,
										  OUT_A => A_DI,
										  OUT_B => B_DI_IN,
										  OUT_C => C_DI_IN);

	-- Etage DI : Banc de registres 
	regs : banc_registres port map(ADR_A => B_DI_IN(3 downto 0),
							   ADR_B => C_DI_IN(3 downto 0),
							   ADR_W => A_ER(3 downto 0),
							   W => W_ER,
							   DATA => B_ER,
							   RST => RST,
							   CLK => CLK,
							   QA => B_DI_REG_MUX,
							   QB => C_DI_OUT);

	-- Etage DI : Logique de Controle
	PILOT_DI <= '1' when OP_DI = COP or OP_DI = ADD or OP_DI = SOU or OP_DI = STORE else
					'0';

	-- Etage DI : Multiplexeur
	mux_registres : multiplexeur port map(IN_A => B_DI_IN,
										  IN_B => B_DI_REG_MUX,
										  PILOT => PILOT_DI,
										  DOUT => B_DI_OUT);
										  
	-- Pipeline : DI/EX	
	etage_DI_EX : etage_pipeline port map(IN_COP => OP_DI,
										  IN_A => A_DI,
										  IN_B => B_DI_OUT,
										  IN_C => C_DI_OUT,
										  CLK => CLK,
										  OUT_COP => OP_EX,
										  OUT_A => A_EX,
										  OUT_B => B_EX_IN,
										  OUT_C => C_EX);
										  
	-- Etage EX : Logique de Controle
	CTR_UAL <= OP_EX(2 downto 0) when (OP_EX = ADD) or (OP_EX = SOU) else
				  (others => '0');
	PILOT_EX <= '1' when (OP_EX = ADD) or (OP_EX = SOU) else
				   '0';
	
	-- Etage EX : UAL
	lual : ual port map(A => B_EX_IN,
				  B => C_EX,
				  Ctrl_Ual => CTR_UAL,
				  N => open,
				  Z => open,
				  O => open,
				  C => open,
				  S => B_EX_UAL_MUX);
				  
	-- Etage EX : Multiplexeur
	mux_ual : multiplexeur port map(IN_A => B_EX_IN,
											 IN_B => B_EX_UAL_MUX,
											 PILOT => PILOT_EX,
											 DOUT => B_EX_OUT);
	
	-- Pipeline : EX/MEM			
	etage_EX_MEM : etage_pipeline port map(IN_COP => OP_EX,
											IN_A => A_EX,
											IN_B => B_EX_OUT,
											IN_C => NOP,
											CLK => CLK,
											OUT_COP => OP_MEM,
											OUT_A => A_MEM,
											OUT_B => B_MEM_IN,
											OUT_C => open);
											
	-- Etage MEM : Memoire des donnees
	mem_donnees : memoire_donnees port map(ADR => B_MEM_MUX_STORE,
										   DIN => B_MEM_IN,
										   RW => RW,
										   RST => RST,
										   CLK => CLK,
										   DOUT => B_MEM_MUX_LOAD);

	-- Etage MEM : Multiplexer load
	mux_mem_load : multiplexeur port map(IN_A => B_MEM_IN,
										 IN_B => B_MEM_MUX_LOAD,
										 PILOT => PILOT_MEM_LOAD,
										 DOUT => B_MEM_OUT);
	
	-- Etage MEM : Multiplexer store
	mux_mem_store : multiplexeur port map(IN_A => B_MEM_IN,
										  IN_B => A_MEM,
										  PILOT => PILOT_MEM_STORE,
										  DOUT => B_MEM_MUX_STORE);
								  
	-- Etage MEM : Logique de contrôle
	RW <= '0' when OP_MEM = STORE else
			'1';
	PILOT_MEM_LOAD <= '1' when OP_MEM = LOAD or OP_MEM = STORE else
							'0';
	PILOT_MEM_STORE <= '1' when OP_MEM = STORE else
							 '0';

	-- Pipeline : MEM/ER								
	etage_MEM_ER : etage_pipeline port map(IN_COP => OP_MEM,
											IN_A => A_MEM,
											IN_B => B_MEM_OUT,
											IN_C => NOP,
											CLK => CLK,
											OUT_COP => OP_ER,
											OUT_A => A_ER,
											OUT_B => B_ER,
											OUT_C => open);
										  
	-- Etage ER : Logique de Controle
	W_ER <= '1' when (OP_ER = AFC) or (OP_ER = COP)
						  or (OP_ER = ADD) or (OP_ER = SOU)
						  or (OP_ER = LOAD) else
			  '0';
			  
	-- Gestion des aléas :
	aleas : gestion_aleas port map(CLK => CLK,
											 COP_LI => instruction_out(31 downto 24),
											 B_LI => instruction_out(15 downto 8),
											 C_LI => instruction_out(7 downto 0),
											 COP_DI => OP_DI,
											 A_DI => A_DI,
											 COP_EX => OP_EX,
											 A_EX => A_EX,
											 COP_MEM => OP_MEM,
											 A_MEM => A_MEM,
											 OUT_EN => enable_cpt,
											 OUT_Instruction => instruction_NOP);

end Behavioral;

