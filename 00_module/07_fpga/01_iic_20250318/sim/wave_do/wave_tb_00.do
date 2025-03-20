#======================================================
onerror {resume}
quietly WaveActivateNextPane {} 0
#======================================================
add wave -noupdate -divider (PC_SIM)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PC_SIM}     /tb_top/U_PC_SIM/*

add wave -noupdate -divider (I2C_TOP_SIM)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {I2C_TOP_SIM}     /tb_top/U_I2C_TOP_SIM/*

add wave -noupdate -divider (I2C_MASTER_IF)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {I2C_MASTER_IF}     /tb_top/U_I2C_TOP_SIM/U_I2C_MASTER_IF/*

add wave -noupdate -divider (I2C_SLAVE0_IF)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {I2C_SLAVE0_IF}     /tb_top/U_I2C_TOP_SIM/U0_I2C_SLAVE0_IF/*

add wave -noupdate -divider (I2C_SLAVE1_IF)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {I2C_SLAVE1_IF}     /tb_top/U_I2C_TOP_SIM/U1_I2C_SLAVE1_IF/*

add wave -noupdate -divider (REG_IF)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {REG_IF}     /tb_top/U_REG_IF/*

add wave -noupdate -divider (REG_BIST)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {REG_BIST}     /tb_top/U_REG_BIST/*

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