vlib work
vmap work

#================================================================
# IPcore
#================================================================

vlog    -reportprogress 300 -work work      ../rtl/00_xilinx_ip/0_sbram/sram_i64o64_d256/sram_i64o64_d256_sim_netlist.V

vlog    -reportprogress 300 -work work      ../rtl/00_xilinx_ip/1_afifo/afifo_i72o72_d2048/afifo_i72o72_d2048_sim_netlist.V
vlog    -reportprogress 300 -work work      ../rtl/00_xilinx_ip/1_afifo/afifo_i90o90_d512/afifo_i90o90_d512_sim_netlist.V

vlog    -reportprogress 300 -work work      ../rtl/00_xilinx_ip/2_sfifo/sfifo_i72o72_d512/sfifo_i72o72_d512_sim_netlist.V
vlog    -reportprogress 300 -work work      ../rtl/00_xilinx_ip/2_sfifo/sfifo_i180_o180_d512/sfifo_i180_o180_d512_sim_netlist.V
vlog    -reportprogress 300 -work work      ../rtl/00_xilinx_ip/2_sfifo/sfifo_i108o108_d512/sfifo_i108o108_d512_sim_netlist.V

#================================================================
# RTL
#================================================================

vlog    -reportprogress 300 -work work      ../rtl/01_user_ip/*.V
vlog    -reportprogress 300 -work work      ../rtl/03_pcie_if_gx/*.V
vlog    -reportprogress 300 -work work      ../rtl/04_bist/*.V
vlog    -reportprogress 300 -work work      ../rtl/05_pc_sim/*.V
vlog    -reportprogress 300 -work work      ../rtl/fpga_top_sim.V
