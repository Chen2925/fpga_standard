#======================================================
onerror {resume}
quietly WaveActivateNextPane {} 0
#======================================================
add wave -noupdate -divider (PC_SIM)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PC_SIM}     /tb_top/U_PC_SIM/*

add wave -noupdate -divider (SPI_SIM)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {SPI_SIM}     /tb_top/U_SPI_SIM/*

add wave -noupdate -divider (SPI_MASTER)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {SPI_MASTER}     /tb_top/U_SPI_SIM/U_SPI_MASTER/*

add wave -noupdate -divider (SPI_SLAVE)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {SPI_SLAVE}     /tb_top/U_SPI_SIM/U_SPI_SLAVE/*

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