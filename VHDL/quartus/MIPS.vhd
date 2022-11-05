-- Top Level Structural Model for MIPS Processor Core
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY MIPS IS

	PORT( reset, clock					                                  : IN 	STD_LOGIC; 
		-- Output important signals to pins for easy display in Simulator
		    SW						      	       	       	 	                		: IN	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	     	RED_Led_8_9						     	   	               	       	: OUT  STD_LOGIC_VECTOR( 1 DOWNTO 0 );
		    PC							               	                        	: OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	     	Green_leds, Red_leds				                           : BUFFER STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	     	HEX_0,HEX_1,HEX_2,HEX_3		           	   	         	: BUFFER STD_LOGIC_VECTOR( 6 DOWNTO 0 );
		    ALU_result_out, read_data_1_out, 
		    read_data_2_out, write_data_out,	Instruction_out			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		    Branch_out, Zero_out, Memwrite_out, 
		    Regwrite_out				        	     	   	                : OUT 	STD_LOGIC );
END 	MIPS;

ARCHITECTURE structure OF MIPS IS

	COMPONENT Ifetch
	     PORT(	Instruction	   		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
      	     	PC_plus_4_out   	: OUT  	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
      	     	Add_result 	   		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
      	     	Branch 	       		: IN 	STD_LOGIC;
		        	Branch_Not	    		: IN 	STD_LOGIC;
		        	jump		         		: IN	STD_LOGIC;
	    	     	jr				          	: IN	STD_LOGIC;
      	     	Zero 			        	: IN 	STD_LOGIC;
      	     	PC_out 		      		: OUT 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
      	     	clock,reset     	: IN 	STD_LOGIC );
	END COMPONENT; 

	COMPONENT Idecode
 	     PORT(	read_data_1    		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
      		     read_data_2 	   	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		   Instruction 	   	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
      		     read_data 	    		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	   	ALU_result 	   		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	   	PC_plus_4	       : IN  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	   	RegWrite 	       : IN 	STD_LOGIC;
        	   	MemtoReg        	: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0);
        	   	RegDst 			      	: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0);
        	   	Sign_extend 	   	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	   	clock, reset	   	: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT control
	     PORT( Opcode 			      	: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
            	RegDst 			      	: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0);
            	ALUSrc 			      	: OUT 	STD_LOGIC;
            	MemtoReg 		     	: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0);
            	RegWrite 	     		: OUT 	STD_LOGIC;
            	MemRead 			      : OUT 	STD_LOGIC;
            	MemWrite 	     		: OUT 	STD_LOGIC;
            	Branch 			      	: OUT 	STD_LOGIC;
		        	Branch_Not 	   		: OUT 	STD_LOGIC;
		  	      jump	 		        	: OUT 	STD_LOGIC;
            	ALUop 	       			: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
            	clock, reset		   : IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT  Execute
	     PORT( Read_data_1 	   	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
             Read_data_2    		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
            	Sign_Extend    		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
            	Function_opcode		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
            	ALUOp 		       		: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
            	ALUSrc 			      	: IN 	STD_LOGIC;
            	Zero 			        	: OUT	STD_LOGIC;
			      	Opcode         		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			      	jump			         	: IN	STD_LOGIC;
			      	Jr		          			: OUT	STD_LOGIC;
            	ALU_Result    			: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
            	Add_Result 		   	: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
            	PC_plus_4 		    	: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
            	clock, reset		   : IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT dmemory
	     PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	   	address 			: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	   	write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	   	MemRead, Memwrite 	: IN 	STD_LOGIC;
        	   	Clock,reset			: IN 	STD_LOGIC );
	END COMPONENT;

					-- declare signals used to connect VHDL components
	SIGNAL PC_plus_4 	      	: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL read_data_1     		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2 	    	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_Extend     		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Add_result      		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ALU_result      		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data       		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALUSrc 			        : STD_LOGIC;
	SIGNAL Branch         			: STD_LOGIC;
	SIGNAL Branch_Not      		: STD_LOGIC;
	SIGNAL jump		          		: STD_LOGIC;
	SIGNAL Jr 			           	: STD_LOGIC;
	SIGNAL RegDst 	        		: STD_LOGIC_VECTOR( 1 DOWNTO 0);
	SIGNAL Regwrite        		: STD_LOGIC;
	SIGNAL Zero           			: STD_LOGIC;
	SIGNAL MemWrite        		: STD_LOGIC;
	SIGNAL MemtoReg 	       	: STD_LOGIC_VECTOR( 1 DOWNTO 0);
	SIGNAL MemRead 	       		: STD_LOGIC;
	SIGNAL IORead	         		: STD_LOGIC;
	SIGNAL DATA_Memwrite    	: STD_LOGIC;
  SIGNAL KeyReset 	       	: STD_LOGIC;
	SIGNAL read_data_mem    	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL hex0_temp,hex1_temp,hex2_temp,hex3_temp : STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL DMEMORY_ALU_Result  : STD_LOGIC_VECTOR( 9 DOWNTO 0  );
	SIGNAL ALUop 		           	: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL Instruction		       : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	

BEGIN
					-- copy important signals to output pins for easy 
					-- display in Simulator
   Instruction_out 	<= Instruction;
   ALU_result_out 	 <= ALU_result;
   read_data_1_out 	<= read_data_1;
   read_data_2_out 	<= read_data_2;
   write_data_out  	<= ALU_result WHEN ( MemtoReg = "00" ) 	
	   ELSE read_data when ( MemtoReg = "01" ) 
	   else Instruction( 15 DOWNTO 0 )& X"0000" when ( MemtoReg = "10" )
	   else X"00000"&B"00"&PC_plus_4	;
   Branch_out  		<= Branch or Branch_Not;
   Zero_out 	   	<= Zero;
   RegWrite_out 	<= RegWrite;
   MemWrite_out 	<= MemWrite;	
   DMEMORY_ALU_Result  <= ALU_Result (9 DOWNTO 2) & "00" ;
  	DATA_Memwrite <= MemWrite AND NOT(ALU_Result(11)); 
  	IORead 	      <= MemRead AND ALU_Result(11);	    -- Check if read from mem or io
	 RED_Led_8_9   <= "00";	                         	---- Making sure the lasts red leds are off
  	read_data     <= X"000000" & SW WHEN IORead = '1' ELSE  read_data_mem;
	 keyReset      <= NOT(reset); 


-------- output: LEDs or LCD ------
	PROCESS 
		BEGIN
		  wait until clock'event and clock ='1' ;
		  if   (ALU_Result(11) = '1') AND (MemWrite = '1')   then  ---- Checking if we need to right to LED/LCD

		    	if ALU_Result(10 DOWNTO 2) = "000000000" then  -- Green Leds 0x800  		          	
		      		Green_leds <= read_data_2(7 DOWNTO 0);   
		        	
	     		elsif ALU_Result(10 DOWNTO 2) = "000000001" then  -- Red Leds 0x804
	       			Red_leds   <= read_data_2(15 DOWNTO 8);
			
			   elsif ALU_Result(10 DOWNTO 2) = "000000010" then  -- HEX0 0x808
		      		HEX_0      <= hex0_temp;
			
		    	elsif ALU_Result(10 DOWNTO 2) = "000000011" then  -- HEX1 0x80C
		      		HEX_1      <= hex1_temp;
		    	
		    	elsif ALU_Result(10 DOWNTO 2) = "000000100" then  -- HEX2 0x810
			     	HEX_2      <= hex2_temp;
						
		    	elsif ALU_Result(10 DOWNTO 2) = "000000101" then  -- HEX3 0x814	
			     	HEX_3      <= hex3_temp;
		    	end if;
	   	end if;
	END PROCESS;

					-- connect the 5 MIPS components   
  IFE : Ifetch
	PORT MAP (	Instruction   	=> Instruction,
  	         	PC_plus_4_out 	=> PC_plus_4,
			      	Add_result 	  	=> Add_result,
			      	Branch 		     	=> Branch,
			      	Branch_Not   		=> Branch_Not,
				     jump		        	=> jump,
			      	Jr 		        		=> Jr,
			      	Zero 	       		=> Zero,
			      	PC_out 	     		=> PC,        		
			      	clock 	      		=> clock,  
			      	reset 	      		=> keyReset );

  ID : Idecode
 	PORT MAP (	read_data_1   	=> read_data_1,
        	   	read_data_2   	=> read_data_2,
        	   	Instruction   	=> Instruction,
           		read_data 	   	=> read_data,
			      	ALU_result   		=> ALU_result,
			      	PC_plus_4      => PC_plus_4,
		       		RegWrite 	    	=> RegWrite,
		       		MemtoReg     		=> MemtoReg,
		       		RegDst 	     		=> RegDst,
		       		Sign_extend   	=> Sign_extend,
           		clock 	      		=> clock,  
			      	reset 	      		=> keyReset );


  CTL:   control
	PORT MAP ( Opcode 		     	=> Instruction( 31 DOWNTO 26 ),
				     RegDst 		     	=> RegDst,
			      	ALUSrc 	     		=> ALUSrc,
			      	MemtoReg     		=> MemtoReg,
			      	RegWrite 	    	=> RegWrite,
				    	MemRead 	     	=> MemRead,
				    	MemWrite     		=> MemWrite,
				    	Branch 		     	=> Branch,
				    	Branch_Not   		=> Branch_Not,
				    	jump		        	=> jump,
				    	ALUop       			=> ALUop,
             clock 		      	=> clock,
				    	reset 	      		=> keyReset );

  EXE:  Execute
 	PORT MAP (	Read_data_1   	=> read_data_1,
            	Read_data_2   	=> read_data_2,
				     Sign_extend   	=> Sign_extend,
             Function_opcode	=> Instruction( 5 DOWNTO 0 ),
			      	ALUOp 		      	=> ALUop,
				    	ALUSrc      			=> ALUSrc,
				    	Zero 		       	=> Zero,
				    	Jr			         	=> jr,
				    	Opcode        	=> Instruction( 31 DOWNTO 26 ),
				    	jump		        	=> jump,
             ALU_Result   		=> ALU_Result,
				    	Add_Result 	  	=> Add_Result,
				    	PC_plus_4	    	=> PC_plus_4,
             Clock	       		=> clock,
				    	Reset	       		=> keyReset );
								

  MEM:  dmemory
	PORT MAP (	read_data    		=> read_data_mem,
				    	address 	     	=> DMEMORY_ALU_Result,--jump memory address by 4
			     		write_data   		=> read_data_2,
				    	MemRead 	     	=> MemRead, 
			     		Memwrite     		=> DATA_Memwrite, 
             clock 		      	=> clock,  
				    	reset 		      	=> keyReset );
				
				
  PROCESS (Read_data_2)
    BEGIN
      CASE Read_data_2(3 downto 0) is
        when "0000"=>HEX0_temp<="1000000";   --print 0
        when "0001"=>HEX0_temp<="1111001";   --print 1
        when "0010"=>HEX0_temp<="0100100";   --print 2
        when "0011"=>HEX0_temp<="0110000";   --print 3
        when "0100"=>HEX0_temp<="0011001";   --print 4
        when "0101"=>HEX0_temp<="0010010";   --print 5
        when "0110"=>HEX0_temp<="0000010";   --print 6
        when "0111"=>HEX0_temp<="1011000";   --print 7
        when "1000"=>HEX0_temp<="0000000";   --print 8
        when "1001"=>HEX0_temp<="0010000";   --print 9
        when "1010"=>HEX0_temp<="0001000";   --print A
        when "1011"=>HEX0_temp<="0000011";   --print B
        when "1100"=>HEX0_temp<="1000110";   --print C
        when "1101"=>HEX0_temp<="0100001";   --print D
        when "1110"=>HEX0_temp<="0000110";   --print E
        when "1111"=>HEX0_temp<="0001110";   --print F
        when others =>HEX0_temp<="0110111";  --print H
      END CASE;
  END PROCESS;

  PROCESS (Read_data_2)
    BEGIN
      CASE Read_data_2(7 downto 4) is
        when "0000"=>HEX1_temp<="1000000";   --print 0
        when "0001"=>HEX1_temp<="1111001";   --print 1
        when "0010"=>HEX1_temp<="0100100";   --print 2
        when "0011"=>HEX1_temp<="0110000";   --print 3
        when "0100"=>HEX1_temp<="0011001";   --print 4
        when "0101"=>HEX1_temp<="0010010";   --print 5
        when "0110"=>HEX1_temp<="0000010";   --print 6
        when "0111"=>HEX1_temp<="1011000";   --print 7
        when "1000"=>HEX1_temp<="0000000";   --print 8
        when "1001"=>HEX1_temp<="0010000";   --print 9
        when "1010"=>HEX1_temp<="0001000";   --print A
        when "1011"=>HEX1_temp<="0000011";   --print B
        when "1100"=>HEX1_temp<="1000110";   --print C
        when "1101"=>HEX1_temp<="0100001";   --print D
        when "1110"=>HEX1_temp<="0000110";   --print E
        when "1111"=>HEX1_temp<="0001110";   --print F
        when others =>HEX1_temp<="0110111";  --print H
      END CASE;
  END PROCESS;

  PROCESS (Read_data_2)
    BEGIN
      CASE Read_data_2(11 downto 8) is
        when "0000"=>HEX2_temp<="1000000";   --print 0
        when "0001"=>HEX2_temp<="1111001";   --print 1
        when "0010"=>HEX2_temp<="0100100";   --print 2
        when "0011"=>HEX2_temp<="0110000";   --print 3
        when "0100"=>HEX2_temp<="0011001";   --print 4
        when "0101"=>HEX2_temp<="0010010";   --print 5
        when "0110"=>HEX2_temp<="0000010";   --print 6
        when "0111"=>HEX2_temp<="1011000";   --print 7
        when "1000"=>HEX2_temp<="0000000";   --print 8
        when "1001"=>HEX2_temp<="0010000";   --print 9
        when "1010"=>HEX2_temp<="0001000";   --print A
        when "1011"=>HEX2_temp<="0000011";   --print B
        when "1100"=>HEX2_temp<="1000110";   --print C
        when "1101"=>HEX2_temp<="0100001";   --print D
        when "1110"=>HEX2_temp<="0000110";   --print E
        when "1111"=>HEX2_temp<="0001110";   --print F
        when others =>HEX2_temp<="0110111";  --print H
      END CASE;
  END PROCESS;

  PROCESS (Read_data_2)
    BEGIN
      CASE Read_data_2(15 downto 12) is
        when "0000"=>HEX3_temp<="1000000";   --print 0
        when "0001"=>HEX3_temp<="1111001";   --print 1
        when "0010"=>HEX3_temp<="0100100";   --print 2
        when "0011"=>HEX3_temp<="0110000";   --print 3
        when "0100"=>HEX3_temp<="0011001";   --print 4
        when "0101"=>HEX3_temp<="0010010";   --print 5
        when "0110"=>HEX3_temp<="0000010";   --print 6
        when "0111"=>HEX3_temp<="1011000";   --print 7
        when "1000"=>HEX3_temp<="0000000";   --print 8
        when "1001"=>HEX3_temp<="0010000";   --print 9
        when "1010"=>HEX3_temp<="0001000";   --print A
        when "1011"=>HEX3_temp<="0000011";   --print B
        when "1100"=>HEX3_temp<="1000110";   --print C
        when "1101"=>HEX3_temp<="0100001";   --print D
        when "1110"=>HEX3_temp<="0000110";   --print E
        when "1111"=>HEX3_temp<="0001110";   --print F
        when others =>HEX3_temp<="0110111";  --print H
      END CASE;
  END PROCESS;
				
				
END structure;