-- control module (implements MIPS control unit)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY control IS
   PORT( Opcode 	  	  : IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	       RegDst 	  	  : OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0);
	       ALUSrc   		  : OUT 	STD_LOGIC;
        	MemtoReg  	  : OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0);
        	RegWrite    	: OUT 	STD_LOGIC;
	       MemRead   	  : OUT 	STD_LOGIC;
	       MemWrite  	  : OUT 	STD_LOGIC;
        	Branch   		  : OUT 	STD_LOGIC;
        	Branch_Not	  : OUT 	STD_LOGIC;
	       jump	       	: OUT 	STD_LOGIC;
        	ALUop      		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	       clock, reset	: IN 	STD_LOGIC );

END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  R_format, Lw, Sw, Beq, Bne,Jal,slti ,MUL,addi,andi,ori,lui,xori	: STD_LOGIC;

BEGIN           
				-- Code to generate control signals using opcode bits
	R_format 	<=  '1'  WHEN  Opcode = "000000"  ELSE '0';
	Jal       <=  '1'  WHEN  Opcode = "000011"  ELSE '0';
  Beq       <=  '1'  WHEN  Opcode = "000100"  ELSE '0';
	Bne       <=  '1'  WHEN  Opcode = "000101"  ELSE '0';
	addi      <=  '1'  WHEN  Opcode = "001000"  ELSE '0';
	slti      <=  '1'  WHEN  Opcode = "001010"  ELSE '0';
	andi      <=  '1'  WHEN  Opcode = "001100"  ELSE '0';
	ori       <=  '1'  WHEN  Opcode = "001101"  ELSE '0';
	lui       <=  '1'  WHEN  Opcode = "001111"  ELSE '0';
	xori      <=  '1'  WHEN  Opcode = "001110"  ELSE '0';
	MUL       <=  '1'  WHEN  Opcode = "011100"  ELSE '0';
	Lw        <=  '1'  WHEN  Opcode = "100011"  ELSE '0';
 	Sw        <=  '1'  WHEN  Opcode = "101011"  ELSE '0';
	
---- Control output	
	Jump       <=  '1'  WHEN  (Opcode = "000010") OR Jal='1'	ELSE '0';
 	RegDst    	<=  "01" when (R_format='1') OR (MUL = '1') else "10" when (JAL='1') else "00";
 	ALUSrc    	<=  '1' when (Lw='1') OR (Sw='1') OR (addi='1') OR (slti='1') OR (andi='1') OR (ori='1') OR (xori='1') else '0';
	MemtoReg 	 <=  "01" when Lw = '1' else "10" when (lui='1') else "11" when( JAL='1') else "00";
 	RegWrite 	 <=  '1' when (R_format = '1') OR (MUL = '1') OR (Lw='1') OR (addi='1') OR (andi='1') OR (ori='1') OR (xori='1') OR (lui='1') OR ( JAL='1') OR (slti='1')	else '0' ;
 	MemRead 	  <=  Lw;
 	MemWrite 	 <=  Sw; 
 	Branch     <=  Beq;
	Branch_Not	<= 	Bne;
	ALUOp( 1 ) <=  '1' when ((R_format = '1') OR (slti='1')) else '0';
	ALUOp( 0 ) <=  Beq OR Bne; 

END behavior;