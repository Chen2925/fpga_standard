#======================================================
onerror {resume}
quietly WaveActivateNextPane {} 0
#======================================================

add wave -noupdate -divider (TB_TOP)
add wave -noupdate -format Logic -radix hexadecimal /tb_top/*

add wave -noupdate -divider (SIM_MODEL)
add wave -noupdate -format Logic -radix hexadecimal /tb_top/U_SIM_MODEL/*

#=======================================================
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
#======================================================

add wave -noupdate -divider (U_PC_SIM)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PC_SIM}     /tb_top/U_PC_SIM/*

add wave -noupdate -divider (UART_IF)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {UART_IF}     /tb_top/U_UART_IF/*

add wave -noupdate -divider (RX_BUF)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {RX_BUF}     /tb_top/U_UART_IF/U_RX_BUF/*

add wave -noupdate -divider (RX_DEC)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {RX_DEC}     /tb_top/U_UART_IF/U_RX_DEC/*

add wave -noupdate -divider (TX_PAK)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {TX_PAK}     /tb_top/U_UART_IF/U_TX_PAK/*

add wave -noupdate -divider (REG_BIST)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {BIST_REG}     /tb_top/U_REG_BIST/*

configure wave -namecolwidth 227
configure wave -valuecolwidth 56
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update