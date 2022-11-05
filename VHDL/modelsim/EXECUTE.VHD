--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY  Execute IS
	PORT(	Read_data_1 	    : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		   	Read_data_2 	    : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			 	Sign_extend 	    : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			 	Function_opcode  : IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			 	ALUOp 		        	: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			 	ALUSrc 		       	: IN 	STD_LOGIC;
			 	Zero 		         	: OUT	STD_LOGIC;
			 	Jr			          	: OUT	STD_LOGIC;
			 	Opcode          	: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			 	jump			          : IN	STD_LOGIC;
			 	ALU_Result 	    	: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			 	Add_Result     		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			 	PC_plus_4 	     	: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			 	clock, reset	    : IN 	STD_LOGIC );
END Execute;

ARCHITECTURE behavior OF Execute IS
  SIGNAL Ainput, Binput 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
  SIGNAL ALU_output_mux		 : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
  SIGNAL ALU_output_mux2		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
  SIGNAL Branch_Add 		   	: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
  SIGNAL ALU_ctl				      : STD_LOGIC_VECTOR( 2 DOWNTO 0 );
  SIGNAL Shifter				      : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
  SIGNAL SLTI 		          : STD_LOGIC;
BEGIN
	Ainput <= Read_data_1;
						-- ALU input mux
	Binput <= Read_data_2 WHEN ( ALUSrc = '0' ) 
  		ELSE  Sign_extend( 31 DOWNTO 0 );
						-- Generate ALU control bits
	SLTI   <= '1' when (Opcode = "001010") else '0' ;
	ALU_ctl( 0 ) <= (( Function_opcode( 0 ) OR Function_opcode( 3 ) ) AND ALUOp(1)) OR SLTI;
	ALU_ctl( 1 ) <= ( NOT Function_opcode( 2 ) ) OR (NOT ALUOp( 1 ) ) OR SLTI;
	ALU_ctl( 2 ) <= ( Function_opcode( 1 ) AND ALUOp( 1 )) OR ALUOp( 0 ) OR SLTI;
						-- Generate Zero Flag
	Zero   <= '1' WHEN ( ALU_output_mux( 31 DOWNTO 0 ) = X"00000000"  )
		        ELSE '0'; 

	Shifter	 <= to_stdlogicvector(to_bitvector(std_logic_vector(Binput)) SLL to_integer(unsigned(Sign_extend(10 downto 6)))) WHEN Function_opcode = "000000" ELSE
				to_stdlogicvector(to_bitvector(std_logic_vector(Binput)) SRL to_integer(unsigned(Sign_extend(10 downto 6))));		
						-- Select ALU output        
	ALU_result <= ALU_output_mux2 when (Opcode="001000" or Opcode="001100" or Opcode="001101" or Opcode = "011100" or Opcode="001110")
	ELSE Shifter WHEN ((Function_opcode = "000000" or Function_opcode = "000010") AND Opcode="000000")
	ELSE X"0000000" & B"000"  & ALU_output_mux( 31 ) WHEN  ALU_ctl = "111" 
		ELSE  	ALU_output_mux( 31 DOWNTO 0 );
		
						-- Adder to compute Branch Address
	Jr     <= '1' when ((Function_opcode = "001000") AND ALUOp(1) = '1') else '0' ;
	Branch_Add	<= PC_plus_4( 9 DOWNTO 2 ) +  Sign_extend( 7 DOWNTO 0 ) WHEN jump = '0' 
	              ELSE Sign_extend( 7 DOWNTO 0 );
	Add_result <= Read_Data_1(9 DOWNTO 2) WHEN ((Function_opcode = "001000") AND ALUOp(1) = '1') 
	              ELSE Branch_Add( 7 DOWNTO 0 ) ;

PROCESS ( ALU_ctl, Ainput, Binput )
	BEGIN
					-- Select ALU operation
 	CASE ALU_ctl IS
						-- ALU performs ALUresult = A_input AND B_input
		WHEN "000" 	=>	ALU_output_mux 	<= Ainput AND Binput; 
						-- ALU performs ALUresult = A_input OR B_input
   	WHEN "001" 	=>	ALU_output_mux 	<= Ainput OR Binput;
						-- ALU performs ALUresult = A_input + B_input
	 	WHEN "010" 	=>	ALU_output_mux 	<= Ainput + Binput;
						-- ALU performs Add Unsigned (Move)
 	 	WHEN "011" 	=>	ALU_output_mux  <= Binput;
						-- ALU performs XOR 
 	 	WHEN "100" 	=>	ALU_output_mux 	<= Ainput Xor Binput;
						-- ALU performs ?
 	 	WHEN "101" 	=>	ALU_output_mux 	<= X"00000000";
						-- ALU performs ALUresult = A_input -B_input
 	 	WHEN "110" 	=>	ALU_output_mux 	<= Ainput - Binput;
						-- ALU performs SLT/SLTI
  	 	WHEN "111" 	=>	ALU_output_mux <= Ainput - Binput ;
						-- ALU performs 
 	 	WHEN OTHERS	=>	ALU_output_mux 	<= X"00000000" ;
  	END CASE;
	  END PROCESS;

	 ------ ALU perform Opcode that not in the ALU_ctl desgien
	 PROCESS ( Opcode, Ainput, Binput )
	 begin
	CASE Opcode IS
						-- ALU performs ALUresult = A_input ADDI B_input
		WHEN "001000" 	=>	ALU_output_mux2  	<= Ainput + Binput; 
						-- ALU performs ALUresult = A_input ANDI B_input
   	WHEN "001100" 	=>	ALU_output_mux2  	<= Ainput AND Binput;
						-- ALU performs ALUresult = A_input ORI B_input
	 	WHEN "001101" 	=>	ALU_output_mux2  	<= Ainput OR Binput;
						-- ALU performs XORI
 	 	WHEN "001110" 	=>	ALU_output_mux2   <= Ainput XOR Binput;
						-- ALU perform mul
		WHEN "011100"   =>  ALU_output_mux2 <= Ainput( 15 DOWNTO 0 )* Binput( 15 DOWNTO 0 );
 	 	WHEN OTHERS	=>	ALU_output_mux2     	<= X"00000000" ;
  	END CASE;
	
	
  END PROCESS;
END behavior;