#test begin

vlog +define+tb_09=1 -work work                            {sim_model\define\define.v}
vlog +define+tb_09=1 -work work +incdir+{sim_model\define} {sim_model\tb_top.v}

vsim -novopt -t 1ps  -c  -l ./log/vsim_tb_09_report.log work.tb_top -L UNISIMS_VER -L SECUREIP -L SIMPRIMS_VER -L XILINXCORELIB_VER  -L work  work.glbl  -wav ./wave/tb_09.wlf
do wave_do/wave_tb_09.do

run -all