@echo off
echo ***************************************************************************
echo *** Project :      ATE FPGA Simulation                                  ***
echo *** Ver     :      Ver 0.0.1                                            ***
echo *** Data    :      2019/06/10                                           ***
echo *** Author  :      Jon chen                                             ***
echo ***************************************************************************
echo *************************************************************************** >>log\sim_report.log
echo *** Project :      ATE FPGA Simulation                                  *** >>log\sim_report.log
echo *** Ver     :      Ver 0.0.1                                            *** >>log\sim_report.log
echo *** Data    :      2019/06/10                                           *** >>log\sim_report.log
echo *** Author  :      Jon chen                                             *** >>log\sim_report.log
echo *************************************************************************** >>log\sim_report.log

if not exist log md log
if exist log\sim_report.log del log\*.log
if exist work               vdel -all work
if exist wave\tb_*.wlf      del wave\tb_*.wlf
if exist cov\*.txt          del cov\*.txt
if exist cov\*.ucdb         del cov\*.ucdb
if exist cov\*.rpt          del cov\*.rpt
if exist cov\*.dat          del cov\*.dat
if exist cov\*.log          del cov\*.log

echo *********************************************************
echo ***  Compile Source                                   ***
echo *********************************************************
call 0_compile_all.bat all cov

rem comp_report.log

echo.
echo *********************************************************
echo ***  Simulate All Pattern                             ***
echo *********************************************************

if exist log\sim_report.log del log\sim_report.log
echo *********************************************************                  >>log\sim_report.log
echo ***             ALL SIMULATION REPORT                 ***                  >>log\sim_report.log
echo *********************************************************                  >>log\sim_report.log
echo.                                                                           >>log\sim_report.log
echo =========================================================                  >>log\sim_report.log
echo =                      NOTE                             =                  >>log\sim_report.log
echo =              Simulation START Time                    =                  >>log\sim_report.log
echo =========================================================                  >>log\sim_report.log
date /t                                                                         >>log\sim_report.log
time /t                                                                         >>log\sim_report.log
echo =========================================================                  >>log\sim_report.log
echo.                                                                           >>log\sim_report.log
echo.                                                                           >>log\sim_report.log

if "%1"==""     goto nocover
if "%1"=="cov"  goto cover

:nocover
echo *********************************************************
echo ***           Simulate With No Coverage               ***
echo *********************************************************
    call 5_sim_ptn.bat tb_00
    call 5_sim_ptn.bat tb_01
    call 5_sim_ptn.bat tb_02
    call 5_sim_ptn.bat tb_03
    call 5_sim_ptn.bat tb_04
    call 5_sim_ptn.bat tb_05
    call 5_sim_ptn.bat tb_06
    call 5_sim_ptn.bat tb_07
goto exit

:cover
echo *********************************************************
echo ***             Simulate With Coverage               ***
echo *********************************************************
    call 5_sim_ptn.bat tb_00 cov
    call 5_sim_ptn.bat tb_01 cov
    call 5_sim_ptn.bat tb_02 cov
    call 5_sim_ptn.bat tb_03 cov
    call 5_sim_ptn.bat tb_04 cov
    call 5_sim_ptn.bat tb_05 cov
    call 5_sim_ptn.bat tb_06 cov
    call 5_sim_ptn.bat tb_07 cov

rem coverage
rem vcover merge                    cov/mars_uhs.ucdb               cov/all_files.txt          -log cov/mars_uhs.log
rem vcover report           -output cov/mars_uhs_summary.rpt        cov/mars_uhs.ucdb
rem vcover report -details  -output cov/mars_uhs_details.rpt        cov/mars_uhs.ucdb
rem vcover report -zeros    -output cov/mars_uhs_zeros.rpt          cov/mars_uhs.ucdb
rem vcover report -lines    -output cov/mars_uhs_lines.rpt          cov/mars_uhs.ucdb

cd cov

vcover merge    -inputs     all_files.txt       merge_all.dat
vcover report   -html       merge_all.dat   -htmldir   ./html_rpt

vcover merge    -inputs     all_files.txt       marge_all.ucdb           -log merge_all.log
vcover report               marge_all.ucdb   >  marge_all_summary.rpt
vcover report   -lines      marge_all.ucdb   >  marge_all_detail.rpt
vcover report   -zeros      marge_all.ucdb   >  marge_all_zeros.rpt


cd ..
goto exit

:exit
echo.                                                                           >>log\sim_report.log
echo.                                                                           >>log\sim_report.log
echo.                                                                           >>log\sim_report.log
echo =========================================================                  >>log\sim_report.log
echo =                      NOTE                             =                  >>log\sim_report.log
echo =              Simulation End Time                      =                  >>log\sim_report.log
echo =========================================================                  >>log\sim_report.log
date /t                                                                         >>log\sim_report.log
time /t                                                                         >>log\sim_report.log
echo =========================================================                  >>log\sim_report.log

echo *********************************************************
echo ***                 Simulate END                      ***
echo *********************************************************
echo *********************************************************                  >>log\sim_report.log
echo ***                 Simulate END                      ***                  >>log\sim_report.log
echo *********************************************************                  >>log\sim_report.log

@echo on
