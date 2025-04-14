
# =========================================================================
# coverage rtl file
# =========================================================================
vlib work
vmap work


# =========================================================================
# IPcore
# =========================================================================

vlog -cover sbce -reportprogress 300 -work work      ../rtl/00_xilinx_ip/0_sbram/*.V

# =========================================================================
# RTL
# =========================================================================

vlog -cover sbcetf -reportprogress 300 -work work      ../rtl/10_bist/*.V
vlog -cover sbcetf -reportprogress 300 -work work      ../rtl/04_lbus_if/*.V

vlog -cover sbcetf -reportprogress 300 -work work      ../rtl/fpga_top_sim.V
vlog -cover sbcetf -reportprogress 300 -work work      ../rtl/fpga_top_sima.V


