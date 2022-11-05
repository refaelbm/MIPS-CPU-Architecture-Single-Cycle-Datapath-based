onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /mips_tb/ALU_result_out
add wave -noupdate -radix hexadecimal /mips_tb/Branch_out
add wave -noupdate -radix hexadecimal /mips_tb/Instruction_out
add wave -noupdate -radix hexadecimal /mips_tb/Memwrite_out
add wave -noupdate -radix hexadecimal /mips_tb/PC
add wave -noupdate -radix hexadecimal /mips_tb/Regwrite_out
add wave -noupdate -radix hexadecimal /mips_tb/Zero_out
add wave -noupdate -radix hexadecimal /mips_tb/clock
add wave -noupdate -radix hexadecimal /mips_tb/read_data_1_out
add wave -noupdate -radix hexadecimal /mips_tb/read_data_2_out
add wave -noupdate -radix hexadecimal /mips_tb/reset
add wave -noupdate -radix hexadecimal /mips_tb/write_data_out
add wave -noupdate -radix hexadecimal /mips_tb/SW
add wave -noupdate -radix hexadecimal /mips_tb/Green_leds
add wave -noupdate -radix hexadecimal /mips_tb/RED_leds
add wave -noupdate -radix hexadecimal /mips_tb/hex0
add wave -noupdate -radix hexadecimal /mips_tb/hex1
add wave -noupdate -radix hexadecimal /mips_tb/hex2
add wave -noupdate -radix hexadecimal /mips_tb/hex3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1534135194 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1533812249 ps} {1534906595 ps}
