# MIPS-CPU-Architecture-Single-Cycle-Datapath-based

Introduction:

The aim of this laboratory is to design a simple MIPS compatible CPU. The CPU 
will use a Single Cycle MIPS architecture and must be capable of performing 
Instructions from the MIPS instruction set.

Design Scope:

 The architecture includes a MIPS ISA compatible CPU with data and program 
 memory Caches for hosting data and code.
 The GPIO (General Purpose I/O) is a simple decoder with buffer registers 
 Mapped to data address (Higher than data memory) to enable the CPU to output data to LEDs and 7-Segment and to read the Switches state.
 The CPU will be based on the standard 32bit MIPS ISA and the instructions will be 
 32 bit wide. 

 

 The following table shows the MIPS instruction format:

 ![image](https://user-images.githubusercontent.com/94614385/202234572-59ee448c-9942-4f29-8d9a-f6d2496d8ee8.png)

 The architecture has 6 design units implemented:
  1. Top level (MIPS)
  2. Control design 
  3. DeMemory
  4. Execute
  5. IDeCode
  6. IFetch

 The Top level:
 - The top level envelop toghter the other 5 design that we will talk about
 The Control: 
 - Doing the needed decoding
 - Manage the other units
 - Responsible for all the control lines, and putting the values in them according to the relevant command. 
 The DeMemory: 
 - Unit that responsible for the write and reading in the memory
 The Execute: 
 - This is the unit that performs the arithmetic/logical operations that some commands require
 The IDecode: 
 - This is the unit that decodes the command, and decides which registers are used.
 The IFetch: 
 - This is the unit that calculates the address of the next command to be executed, and calls the next command to be executed from memory.

 

Verification Scope: 
 - Implemented with VHDL generator, function checker and coverage using ModelSim  
 - Loading the design into the FPGA using Quartus
  - Running simulations from the first implementation.
 - Running Assembly code that we implement in IAR

   

Program languages:
 - VHDL
 - Assembly

Backend Tools: 
 - FPGA
 - ModleSim
 - Quartus
 - IAR
 
 
 
Design, synthesis and analysis of a simple MIPS compatible CPU with Memory Mapped I/O.

The desing was based on standart 32bits MIPS ISA and the instraction will be 32 bit wide 
The instractions will support R,I and J types ![image](https://user-images.githubusercontent.com/94614385/202234572-59ee448c-9942-4f29-8d9a-f6d2496d8ee8.png)

We used VHDL code to create the design( Using Quartus and Modelsim) and used Assembly code to check it ( Using IAR)
