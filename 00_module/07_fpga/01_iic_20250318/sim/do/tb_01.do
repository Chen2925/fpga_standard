#test begin

vlog +define+tb_01=1 -work work                            {sim_model\define\define.v}
vlog +define+tb_01=1 -work work +incdir+{sim_model\define} {sim_model\tb_top.v}

vsim -t 1ps  -c  -l ./log/vsim_tb_01_report.log work.tb_top -L UNISIMS_VER -L SECUREIP -L SIMPRIMS_VER  -L work  -voptargs=+acc  work.glbl  -wav ./wave/tb_01.wlf
do wave_do/wave_tb_01.do

run -all