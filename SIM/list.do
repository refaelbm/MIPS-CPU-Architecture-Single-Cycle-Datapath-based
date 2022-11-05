onerror {resume}
add list /mips_tb/ALU_result_out
add list /mips_tb/Branch_out
add list /mips_tb/Instruction_out
add list /mips_tb/Memwrite_out
add list /mips_tb/PC
add list /mips_tb/Regwrite_out
add list /mips_tb/Zero_out
add list /mips_tb/clock
add list /mips_tb/read_data_1_out
add list /mips_tb/read_data_2_out
add list /mips_tb/reset
add list /mips_tb/write_data_out
add list /mips_tb/SW
add list /mips_tb/Green_leds
add list /mips_tb/RED_leds
add list /mips_tb/hex0
add list /mips_tb/hex1
add list /mips_tb/hex2
add list /mips_tb/hex3
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta all
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
