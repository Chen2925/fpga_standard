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

add wave -noupdate -divider (U_BIST_REG)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {BIST_REG}     /tb_top/U_BIST_REG/*


add wave -noupdate -divider (U_PCIE_IF_GX)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_IF_GX}     /tb_top/U_PCIE_IF_GX/*

add wave -noupdate -divider (U_PCIE_RX)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_RX}     /tb_top/U_PCIE_IF_GX/U_PCIE_RX/*

add wave -noupdate -divider (U_PCIE_TX)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_TX}     /tb_top/U_PCIE_IF_GX/U_PCIE_TX/*

add wave -noupdate -divider (U_PCIE_REG_IF)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_REG_IF}     /tb_top/U_PCIE_IF_GX/U_PCIE_REG_IF/*

add wave -noupdate -divider (U_PCIE_REG_ACK)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_REG_ACK}     /tb_top/U_PCIE_IF_GX/U_PCIE_REG_ACK/*

add wave -noupdate -divider (U_PCIE_REG_INT)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_REG_INT}     /tb_top/U_PCIE_IF_GX/U_PCIE_REG_INT/*

add wave -noupdate -divider (U_PCIE_DN_REG)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_REG}     /tb_top/U_PCIE_IF_GX/U_PCIE_DN_REG/*

add wave -noupdate -divider (U_PCIE_UP_REG)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_UP_REG}     /tb_top/U_PCIE_IF_GX/U_PCIE_UP_REG/*

add wave -noupdate -divider (U_PCIE_DN_CPLD_IF)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_CPLD_IF}     /tb_top/U_PCIE_IF_GX/U_PCIE_DN_CPLD_IF/*

add wave -noupdate -divider (U_PCIE_DN_IF[0])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_IF[0]}     /tb_top/U_PCIE_IF_GX/GROUP_DN[0]/U_PCIE_DN_IF/*

add wave -noupdate -divider (U_PCIE_DN_LBUF[0])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_LBUF[0]}     /tb_top/U_PCIE_IF_GX/GROUP_DN[0]/U_PCIE_DN_LBUF/*

add wave -noupdate -divider (U_PCIE_DN_DFK[0])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_DFK[0]}     /tb_top/U_PCIE_IF_GX/GROUP_DN[0]/U_PCIE_DN_DFK/*

add wave -noupdate -divider (U_PCIE_DN_DEK[0])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_DEK[0]}     /tb_top/U_PCIE_IF_GX/GROUP_DN[0]/U_PCIE_DN_DEK/*

add wave -noupdate -divider (U_PCIE_DN_FBUF[0])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_FBUF[0]}     /tb_top/U_PCIE_IF_GX/GROUP_DN[0]/U_PCIE_DN_FBUF/*

add wave -noupdate -divider (U_PCIE_DN_DMA[0])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_DMA[0]}     /tb_top/U_PCIE_IF_GX/GROUP_DN[0]/U_PCIE_DN_DMA/*

add wave -noupdate -divider (U_PCIE_DN_CPLD_UEK[0])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_CPLD_UEK[0]}     /tb_top/U_PCIE_IF_GX/GROUP_DN[0]/U_PCIE_DN_CPLD_UEK/*

add wave -noupdate -divider (U_PCIE_DN_CPLD_DFK[0])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_CPLD_DFK[0]}     /tb_top/U_PCIE_IF_GX/GROUP_DN[0]/U_PCIE_DN_CPLD_DFK/*

add wave -noupdate -divider (U_PCIE_DN_CPLD_DPK[0])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_CPLD_DPK[0]}     /tb_top/U_PCIE_IF_GX/GROUP_DN[0]/U_PCIE_DN_CPLD_DPK/*

add wave -noupdate -divider (U_PCIE_DN_IF[1])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_IF[1]}     /tb_top/U_PCIE_IF_GX/GROUP_DN[1]/U_PCIE_DN_IF/*

add wave -noupdate -divider (U_PCIE_DN_LBUF[1])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_LBUF[1]}     /tb_top/U_PCIE_IF_GX/GROUP_DN[1]/U_PCIE_DN_LBUF/*

add wave -noupdate -divider (U_PCIE_DN_DFK[1])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_DFK[1]}     /tb_top/U_PCIE_IF_GX/GROUP_DN[1]/U_PCIE_DN_DFK/*

add wave -noupdate -divider (U_PCIE_DN_DEK[1])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_DEK[1]}     /tb_top/U_PCIE_IF_GX/GROUP_DN[1]/U_PCIE_DN_DEK/*

add wave -noupdate -divider (U_PCIE_DN_FBUF[1])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_FBUF[1]}     /tb_top/U_PCIE_IF_GX/GROUP_DN[1]/U_PCIE_DN_FBUF/*

add wave -noupdate -divider (U_PCIE_DN_DMA[1])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_DMA[1]}     /tb_top/U_PCIE_IF_GX/GROUP_DN[1]/U_PCIE_DN_DMA/*

add wave -noupdate -divider (U_PCIE_DN_CPLD_UEK[1])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_CPLD_UEK[1]}     /tb_top/U_PCIE_IF_GX/GROUP_DN[1]/U_PCIE_DN_CPLD_UEK/*

add wave -noupdate -divider (U_PCIE_DN_CPLD_DFK[1])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_CPLD_DFK[1]}     /tb_top/U_PCIE_IF_GX/GROUP_DN[1]/U_PCIE_DN_CPLD_DFK/*

add wave -noupdate -divider (U_DN_DFK_ARBIT)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {DN_DFK_ARBIT}     /tb_top/U_PCIE_IF_GX/U_DN_DFK_ARBIT/*

add wave -noupdate -divider (U_DN_DEK_ARBIT)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {DN_DEK_ARBIT}     /tb_top/U_PCIE_IF_GX/U_DN_DEK_ARBIT/*

add wave -noupdate -divider (U_PCIE_DN_ARBIT)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_DN_ARBIT}     /tb_top/U_PCIE_IF_GX/U_PCIE_DN_ARBIT/*

add wave -noupdate -divider (U_PCIE_UP_IF[0])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_UP_IF[0]}     /tb_top/U_PCIE_IF_GX/GROUP_UP[0]/U_PCIE_UP_IF/*

add wave -noupdate -divider (U_PCIE_UP_LBUF[0])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_UP_LBUF[0]}     /tb_top/U_PCIE_IF_GX/GROUP_UP[0]/U_PCIE_UP_LBUF/*

add wave -noupdate -divider (U_PCIE_UP_EBUF[0])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_UP_EBUF[0]}     /tb_top/U_PCIE_IF_GX/GROUP_UP[0]/U_PCIE_UP_EBUF/*

add wave -noupdate -divider (U_PCIE_UP_UFK[0])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_UP_UFK[0]}     /tb_top/U_PCIE_IF_GX/GROUP_UP[0]/U_PCIE_UP_UFK/*

add wave -noupdate -divider (U_PCIE_UP_UEK[0])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_UP_UEK[0]}     /tb_top/U_PCIE_IF_GX/GROUP_UP[0]/U_PCIE_UP_UEK/*

add wave -noupdate -divider (U_PCIE_UP_DMA[0])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_UP_DMA[0]}     /tb_top/U_PCIE_IF_GX/GROUP_UP[0]/U_PCIE_UP_DMA/*

add wave -noupdate -divider (U_PCIE_UP_IF[1])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_UP_IF[1]}     /tb_top/U_PCIE_IF_GX/GROUP_UP[1]/U_PCIE_UP_IF/*

add wave -noupdate -divider (U_PCIE_UP_LBUF[1])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_UP_LBUF[1]}     /tb_top/U_PCIE_IF_GX/GROUP_UP[1]/U_PCIE_UP_LBUF/*

add wave -noupdate -divider (U_PCIE_UP_EBUF[1])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_UP_EBUF[1]}     /tb_top/U_PCIE_IF_GX/GROUP_UP[1]/U_PCIE_UP_EBUF/*

add wave -noupdate -divider (U_PCIE_UP_UFK[1])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_UP_UFK[1]}     /tb_top/U_PCIE_IF_GX/GROUP_UP[1]/U_PCIE_UP_UFK/*

add wave -noupdate -divider (U_PCIE_UP_UEK[1])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_UP_UEK[1]}     /tb_top/U_PCIE_IF_GX/GROUP_UP[1]/U_PCIE_UP_UEK/*

add wave -noupdate -divider (U_PCIE_UP_DMA[1])
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_UP_DMA[1]}     /tb_top/U_PCIE_IF_GX/GROUP_UP[1]/U_PCIE_UP_DMA/*

add wave -noupdate -divider (U_UP_UEK_ARBIT)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {UP_UEK_ARBIT}     /tb_top/U_PCIE_IF_GX/U_UP_UEK_ARBIT/*

add wave -noupdate -divider (U_UP_UFK_ARBIT)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {UP_UFK_ARBIT}     /tb_top/U_PCIE_IF_GX/U_UP_UFK_ARBIT/*

add wave -noupdate -divider (U_PCIE_UP_ARBIT)
add wave -noupdate -color green    -format Logic -radix hexadecimal -group {PCIE_UP_ARBIT}     /tb_top/U_PCIE_IF_GX/U_PCIE_UP_ARBIT/*

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