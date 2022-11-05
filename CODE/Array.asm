#-------------------- MEMORY Mapped I/O -----------------------
#define PORT_LEDG[7-0] 0x800 - LSB byte (Output Mode)
#define PORT_LEDR[7-0] 0x804 - LSB byte (Output Mode)
#define PORT_HEX0[7-0] 0x808 - LSB byte (Output Mode)
#define PORT_HEX1[7-0] 0x80C - LSB byte (Output Mode)
#define PORT_HEX2[7-0] 0x810 - LSB byte (Output Mode)
#define PORT_HEX3[7-0] 0x814 - LSB byte (Output Mode)
#define PORT_SW[7-0]   0x818 - LSB byte (Input Mode)
#--------------------------------------------------------------
.data 
	ID_Size : .word 8
	N: .word 5b8d80       #length needed for one second delay
	ID: .word 4,3,8,2,7,2,9,3
	ID_sorted: .word
	

.text
#-------Sort The Array----------
START:
      la   $t3,ID               #start of ID   
      la   $t4,ID_sorted  	#Start of ID_sorted  
      move $s2,$0
      addi $s2, $s2, 1 		#$s2=1
      lw   $s5,ID_Size 
      lw   $s4,N 
#------- Function sort ----------      
COPY : #Copy ID to ID_Sorted
      lw   $t5,0($t3)
      sw   $t5,0($t4)		
      addi $t3,$t3,4
      addi $t4,$t4,4
      addi $s5,$s5,-1
      bne  $s5,$0,COPY
      
LOOP1: 
      addi $t4, $0, 0    		# $t4 is an indicator       
      la  $s3, ID_sorted	#Start of ID_sorted
      addi $t3,$t3,28		#End of ID_sorted				
    		
LOOP2:  	#now we check if we need to swap else we continue                
      lw  $t5, 0($s3)         
      lw  $t0, 4($s3)         
      slt $t1, $t5, $t0       # if $t5 < $t0 -> $t1 = 1 else =0 
      beq $t1, $0, JUMP      # if $t1 = 1, then swap them else jumop
      addi $t4, $0, 1         # if swap is needed than indicator=1
      sw  $t5, 4($s3)         #save the bigger number in the lower array element
      sw  $t0, 0($s3)         #save the smaller number in the higher array element
JUMP:
      addi $s3, $s3, 4  
      slt $t7, $s3, $t3      
      beq $t7, $s2, LOOP2       # moving to the next element in the array and checking if its the end of the array
      beq $t4,$s2, LOOP1        # if indicator=1 than jump to LOOP1
 
#------- SHOWING ON FPGA ----------

      move $t4,$0	      # i counter for the  for loop 
      la   $s3, ID_sorted 
     #Reseting the leds
      sw   $t4,0x800   	  # write to PORT_LEDG[7-0]
      sw   $t4,0x804   	  # write to PORT_LEDR[7-0]
      sw   $t4,0x808       # write to PORT_HEX0[7-0] 
      sw   $t4,0x80C   	  # write to PORT_HEX1[7-0]
      sw   $t4,0x810       # write to PORT_HEX2[7-0]
      sw   $t4,0x814       # write to PORT_HEX3[7-0] 
      
SW0_Check: lw $t9,0x818     #Read switch input
	   andi $t9,$t9,0x01
	   beq  $t9,$0, ZERO
	   
HEX0: andi $t8,$t4,0x07    # i modulue 8
      sll  $t8,$t8,2
      add  $s7,$s3,$t8
      lw   $t3, 0($s7)	  
      sw   $t3,0x808      # write to PORT_HEX0[7-0]
      addi $t4,$t4,1      # i+1 counter for the  for loop 
      move $t6,$0	  #Counter for the delay
DELAY:	
      addi $t6,$t6,1        	
      slt  $t5,$t6,$s4      #if $t6<N than $t5=1  else =0
      beq  $t5,$0,SW0_Check        #$if t6>=N than jump to LOOP3
      j   DELAY
     #showing 0 when SW0=0
ZERO: move $t4,$0
      sw   $t4,0x808    # write to PORT_HEX0[7-0]
      j SW0_Check
end: 
      j end            # Protction loop


