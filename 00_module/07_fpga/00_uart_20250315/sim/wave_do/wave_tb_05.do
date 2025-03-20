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

add wave -noupdate -divider (U_BIST_REG_0)

add wave -noupdate -color yellow    -format Logic -radix hexadecimal -group {REG_IF}     /tb_top/U_FPGA_TOP_SIMA/U_REG_BIST_0/REG_WR_REQ
add wave -noupdate -color yellow    -format Logic -radix hexadecimal -group {REG_IF}     /tb_top/U_FPGA_TOP_SIMA/U_REG_BIST_0/REG_RD_REQ
add wave -noupdate -color yellow    -format Logic -radix hexadecimal -group {REG_IF}     /tb_top/U_FPGA_TOP_SIMA/U_REG_BIST_0/REG_WR_ACK
add wave -noupdate -color yellow    -format Logic -radix hexadecimal -group {REG_IF}     /tb_top/U_FPGA_TOP_SIMA/U_REG_BIST_0/REG_RD_ACK
add wave -noupdate -color yellow    -format Logic -radix hexadecimal -group {REG_IF}     /tb_top/U_FPGA_TOP_SIMA/U_REG_BIST_0/REG_WR_DATA
add wave -noupdate -color yellow    -format Logic -radix hexadecimal -group {REG_IF}     /tb_top/U_FPGA_TOP_SIMA/U_REG_BIST_0/REG_RD_DATA
add wave -noupdate -color yellow    -format Logic -radix hexadecimal -group {REG_IF}     /tb_top/U_FPGA_TOP_SIMA/U_REG_BIST_0/REG_OP_ADDR

add wave -noupdate -color pink      -format Logic -radix hexadecimal -group {REG_EN}     /tb_top/U_FPGA_TOP_SIMA/U_REG_BIST_0/s_REG_FPGA_VER0_EN
add wave -noupdate -color pink      -format Logic -radix hexadecimal -group {REG_EN}     /tb_top/U_FPGA_TOP_SIMA/U_REG_BIST_0/s_REG_FPGA_VER1_EN
add wave -noupdate -color pink      -format Logic -radix hexadecimal -group {REG_EN}     /tb_top/U_FPGA_TOP_SIMA/U_REG_BIST_0/s_REG_FPGA_VER2_EN
add wave -noupdate -color pink      -format Logic -radix hexadecimal -group {REG_EN}     /tb_top/U_FPGA_TOP_SIMA/U_REG_BIST_0/s_REG_FPGA_VER3_EN
add wave -noupdate -color pink      -format Logic -radix hexadecimal -group {REG_EN}     /tb_top/U_FPGA_TOP_SIMA/U_REG_BIST_0/s_REG_BORD_VER0_EN
add wave -noupdate -color pink      -format Logic -radix hexadecimal -group {REG_EN}     /tb_top/U_FPGA_TOP_SIMA/U_REG_BIST_0/s_REG_BORD_VER1_EN

add wave -noupdate -divider (SIM_MODEL)
add wave -noupdate -color cyan      -format Logic  -radix ascii                           /tb_top/U_SIM_MODEL/operation
add wave -noupdate -color magenta   -format Logic  -radix hexadecimal                     /tb_top/U_SIM_MODEL/r_BRAM_WR_REQ
add wave -noupdate -color magenta   -format Logic  -radix hexadecimal                     /tb_top/U_SIM_MODEL/r_BRAM_WR_ADDR
add wave -noupdate -color magenta   -format Logic  -radix hexadecimal                     /tb_top/U_SIM_MODEL/s_BRAM_WR_ACK
add wave -noupdate -color magenta   -format Logic  -radix hexadecimal                     /tb_top/U_SIM_MODEL/r_BRAM_WR_DATA

add wave -noupdate -color magenta   -format analog -radix hexadecimal                     /tb_top/U_SIM_MODEL/r_BRAM_WR_DATA
add wave -noupdate -color magenta   -format analog -radix hexadecimal                     /tb_top/U_SIM_MODEL/r_BRAM_WR_ADDR

add wave -noupdate -color magenta   -format Logic  -radix hexadecimal                     /tb_top/U_SIM_MODEL/r_BRAM_RD_REQ
add wave -noupdate -color magenta   -format Logic  -radix hexadecimal                     /tb_top/U_SIM_MODEL/r_BRAM_RD_ADDR
add wave -noupdate -color magenta   -format Logic  -radix hexadecimal                     /tb_top/U_SIM_MODEL/s_BRAM_RD_ACK
add wave -noupdate -color magenta   -format Logic  -radix hexadecimal                     /tb_top/U_SIM_MODEL/s_BRAM_RD_DATA

#=======================================================
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
#======================================================

add wave -noupdate -divider (U_FPGA_TOP_SIM)
add wave -noupdate -format Logic -radix hexadecimal /tb_top/U_FPGA_TOP_SIM/*

add wave -noupdate -divider (U01_LBUS_TOP)
add wave -noupdate -format Logic -radix hexadecimal /tb_top/U_FPGA_TOP_SIM/U01_LBUS_TOP/*

add wave -noupdate -divider (U00_LBUS_IF)
add wave -noupdate -format Logic -radix hexadecimal /tb_top/U_FPGA_TOP_SIM/U01_LBUS_TOP/U00_LBUS_IF/*

add wave -noupdate -divider (U01_REG_IF)
add wave -noupdate -format Logic -radix hexadecimal /tb_top/U_FPGA_TOP_SIM/U01_LBUS_TOP/U01_REG_IF/*

add wave -noupdate -divider (U_FPGA_TOP_SIMA)
add wave -noupdate -format Logic -radix hexadecimal /tb_top/U_FPGA_TOP_SIM/U_FPGA_TOP_SIMA/*


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