# =========================================================================
# compile file
# =========================================================================
do do/compile_lib.do
do do/compile_rtl.do
do do/compile_sim.do

vlog -refresh  -work ./work

# =========================================================================
# coverage rtl file
# =========================================================================
do do/compile_cov.do

# =========================================================================
# coverage tb
# =========================================================================

# tb_00
vlog +define+tb_00=1 -work work                            {sim_model\define\define.v}
vlog +define+tb_00=1 -work work +incdir+{sim_model\define} {sim_model\tb_top.v}
vsim -coverage -novopt -t 1ps  -c  -l ./log/vsim_tb_00_report.log work.tb_top -L UNISIMS_VER -L SECUREIP -L SIMPRIMS_VER -L XILINXCORELIB_VER  -L work  work.glbl  -wav ./wave/tb_00.wlf
do wave_do/wave_tb_00.do
run -all
coverage save cov/tb_00.ucdb

# tb_01
vlog +define+tb_01=1 -work work                            {sim_model\define\define.v}
vlog +define+tb_01=1 -work work +incdir+{sim_model\define} {sim_model\tb_top.v}
vsim -coverage -novopt -t 1ps  -c  -l ./log/vsim_tb_01_report.log work.tb_top -L UNISIMS_VER -L SECUREIP -L SIMPRIMS_VER -L XILINXCORELIB_VER  -L work  work.glbl  -wav ./wave/tb_01.wlf
do wave_do/wave_tb_01.do
run -all
coverage save cov/tb_01.ucdb


# tb_02
vlog +define+tb_02=1 -work work                            {sim_model\define\define.v}
vlog +define+tb_02=1 -work work +incdir+{sim_model\define} {sim_model\tb_top.v}
vsim -coverage -novopt -t 1ps  -c  -l ./log/vsim_tb_02_report.log work.tb_top -L UNISIMS_VER -L SECUREIP -L SIMPRIMS_VER -L XILINXCORELIB_VER  -L work  work.glbl  -wav ./wave/tb_02.wlf
do wave_do/wave_tb_02.do
run -all
coverage save cov/tb_02.ucdb


# tb_03
vlog +define+tb_03=1 -work work                            {sim_model\define\define.v}
vlog +define+tb_03=1 -work work +incdir+{sim_model\define} {sim_model\tb_top.v}
vsim -coverage -novopt -t 1ps  -c  -l ./log/vsim_tb_03_report.log work.tb_top -L UNISIMS_VER -L SECUREIP -L SIMPRIMS_VER -L XILINXCORELIB_VER  -L work  work.glbl  -wav ./wave/tb_03.wlf
do wave_do/wave_tb_03.do
run -all
coverage save cov/tb_03.ucdb


# tb_04
vlog +define+tb_04=1 -work work                            {sim_model\define\define.v}
vlog +define+tb_04=1 -work work +incdir+{sim_model\define} {sim_model\tb_top.v}
vsim -coverage -novopt -t 1ps  -c  -l ./log/vsim_tb_04_report.log work.tb_top -L UNISIMS_VER -L SECUREIP -L SIMPRIMS_VER -L XILINXCORELIB_VER  -L work  work.glbl  -wav ./wave/tb_04.wlf
do wave_do/wave_tb_04.do
run -all
coverage save cov/tb_04.ucdb


# tb_05
vlog +define+tb_05=1 -work work                            {sim_model\define\define.v}
vlog +define+tb_05=1 -work work +incdir+{sim_model\define} {sim_model\tb_top.v}
vsim -coverage -novopt -t 1ps  -c  -l ./log/vsim_tb_05_report.log work.tb_top -L UNISIMS_VER -L SECUREIP -L SIMPRIMS_VER -L XILINXCORELIB_VER  -L work  work.glbl  -wav ./wave/tb_05.wlf
do wave_do/wave_tb_05.do
run -all
coverage save cov/tb_05.ucdb


# tb_06
vlog +define+tb_06=1 -work work                            {sim_model\define\define.v}
vlog +define+tb_06=1 -work work +incdir+{sim_model\define} {sim_model\tb_top.v}
vsim -coverage -novopt -t 1ps  -c  -l ./log/vsim_tb_06_report.log work.tb_top -L UNISIMS_VER -L SECUREIP -L SIMPRIMS_VER -L XILINXCORELIB_VER  -L work  work.glbl  -wav ./wave/tb_06.wlf
do wave_do/wave_tb_06.do
run -all
coverage save cov/tb_06.ucdb


# tb_07
vlog +define+tb_07=1 -work work                            {sim_model\define\define.v}
vlog +define+tb_07=1 -work work +incdir+{sim_model\define} {sim_model\tb_top.v}
vsim -coverage -novopt -t 1ps  -c  -l ./log/vsim_tb_07_report.log work.tb_top -L UNISIMS_VER -L SECUREIP -L SIMPRIMS_VER -L XILINXCORELIB_VER  -L work  work.glbl  -wav ./wave/tb_07.wlf
do wave_do/wave_tb_07.do
run -all
coverage save cov/tb_07.ucdb


# =========================================================================
# Final Report
# =========================================================================
quit -sim
vcover merge                    cov/merge_all.dat           cov/*.ucdb          -log cov/merge_all.log
vcover report           -file   cov/marge_all_summary.rpt   cov/merge_all.dat
vcover report -details  -file   cov/marge_all_detail.rpt    cov/merge_all.dat
vcover report -zeros    -file   cov/marge_all_zeros.rpt     cov/merge_all.dat