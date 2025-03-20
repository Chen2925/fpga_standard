@echo off

rem rename test pattern name
set SIM_PTN=%1
set SIM_MODE=%2
rem echo Pattern %1

echo *********************************************************
echo ***               Pattern %SIM_PTN%                   ***
echo *********************************************************

if exist wave\%SIM_PTN%.wlf del wave\%SIM_PTN%.wlf
if exist log\sim_%SIM_PTN%.log del log\sim_%SIM_PTN%.log
if exist log\com_%SIM_PTN%.log del log\com_%SIM_PTN%.log
if exist cov\%SIM_PTN%.ucdb    del cov\%SIM_PTN%.ucdb

if "%SIM_PTN%" == "" goto ERROR_0
if not exist "tb_pattern\%SIM_PTN%" goto ERROR_1
if "%SIM_MODE%" == "cov" goto SIM_COV
goto SIM

:ERROR_0
echo ===== [Error0]  NO Test Pattern Name                       =========                                >>log\sim_report.log
goto EXIT

:ERROR_1
echo ===== [Error1]  NO Floder OF Test Pattern %SIM_PTN%        =========                                >>log\sim_report.log
goto EXIT

:SIM_COV
rem vsim -c -do do/%SIM_PTN%.do

vlog +define+%SIM_PTN%=1 -work work                             sim_model\define\define.v
vlog +define+%SIM_PTN%=1 -work work +incdir+{sim_model\define}  sim_model\tb_top.v
vsim -coverage -c -novopt -t 1ps  -l ./log/vsim_%SIM_PTN%_report.log work.tb_top  -L UNISIMS_VER -L SECUREIP -L SIMPRIMS_VER -L XILINXCORELIB_VER -L work  work.glbl  -wav ./wave/%SIM_PTN%.wlf  -do  "set StdArithNoWarnings 1 ;onbreak {resume};do ./wave_do/wave_%SIM_PTN%.do ;run -all ; coverage save cov/%SIM_PTN%.ucdb ; quit"

goto SIM_REPORT

:SIM
rem vsim -c -do do/%SIM_PTN%.do

vlog +define+%SIM_PTN%=1 -work work                             sim_model\define\define.v
vlog +define+%SIM_PTN%=1 -work work +incdir+{sim_model\define}  sim_model\tb_top.v
vsim  -c -novopt -t 1ps  -l ./log/vsim_%SIM_PTN%_report.log work.tb_top  -L UNISIMS_VER -L SECUREIP -L SIMPRIMS_VER -L XILINXCORELIB_VER -L work  work.glbl  -wav ./wave/%SIM_PTN%.wlf  -do  "set StdArithNoWarnings 1 ;onbreak {resume};do ./wave_do/wave_%SIM_PTN%.do ;run -all ;  quit"

goto EXIT

:SIM_REPORT

echo *********************************************************              >>log\sim_report.log
echo ***          Find Pattern %SIM_PTN% ERROR             ***              >>log\sim_report.log
echo *********************************************************              >>log\sim_report.log

find /I "WARNNING" .\log\vsim_%SIM_PTN%_report.log                          >>log\sim_report.log
find /I "ERROR"    .\log\vsim_%SIM_PTN%_report.log                          >>log\sim_report.log
echo %SIM_PTN%.ucdb >> cov\all_files.txt
goto EXIT

: EXIT

echo *********************************************************
echo ***               Pattern %SIM_PTN% EXIT              ***
echo *********************************************************
date /t                                                                     >>log\sim_report.log
time /t                                                                     >>log\sim_report.log

rem copy modelsim\%SIM_PTN%\sim_%SIM_PTN%.log log\sim_%SIM_PTN%.log
rem del modelsim\%SIM_PTN%\sim_%SIM_PTN%.log