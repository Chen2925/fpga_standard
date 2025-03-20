#test begin

vlog +define+tb_04=1 -work work                            {sim_model\define\define.v}
vlog +define+tb_04=1 -work work +incdir+{sim_model\define} {sim_model\tb_top.v}

vsim -t 1ps  -c  -l ./log/vsim_tb_04_report.log work.tb_top -L UNISIMS_VER -L SECUREIP -L SIMPRIMS_VER  -L work  -voptargs=+acc  work.glbl  -wav ./wave/tb_04.wlf
do wave_do/wave_tb_04.do

run -all