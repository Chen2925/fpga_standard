

#================================================================
# Compile RTL/SIM/LIB
#================================================================

do do/compile_lib.do
do do/compile_rtl.do
do do/compile_sim.do

vlog -refresh  -work ./work

#================================================================
# Run all do file
#================================================================

do do/tb_00.do
do do/tb_01.do
do do/tb_02.do
do do/tb_03.do
do do/tb_04.do
do do/tb_05.do
do do/tb_06.do
do do/tb_07.do


