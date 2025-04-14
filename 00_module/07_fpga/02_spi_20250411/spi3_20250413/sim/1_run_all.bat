@echo off
if exist work vdel -all work
if exist wave\*.wlf del wave\*.wlf
if exist log\*.log del log\*.log
if exist cov\*.* del /s /q cov\*.*

:START
rem run mode
set RUN_MODE=%1
rem echo run mode %1

if "%RUN_MODE%" == "cmd"        goto RUN_CMD
if "%RUN_MODE%" == "cmdcov"     goto RUN_CMDCOV
if "%RUN_MODE%" == "ui"         goto RUN_UI
if "%RUN_MODE%" == "uicov"      goto RUN_UICOV
goto RUN_CMDCOV

:RUN_CMD
echo *********************************************************
echo ***  Run command mode with no coverage                ***
echo *********************************************************
echo *********************************************************      >>log\run_all_report.log
echo ***  Run command mode with no coverage                ***      >>log\run_all_report.log
echo *********************************************************      >>log\run_all_report.log
vsim -c -do do\run_all.do
goto RUN_END

:RUN_CMDCOV
echo *********************************************************
echo ***  Run command mode with coverage                   ***
echo *********************************************************
echo *********************************************************      >>log\run_all_report.log
echo ***  Run command mode with coverage                   ***      >>log\run_all_report.log
echo *********************************************************      >>log\run_all_report.log
vsim -c -do do\run_all_cov.do
goto RUN_END

:RUN_UI
echo *********************************************************
echo ***  Run UI mode with no coverage                     ***
echo *********************************************************
echo *********************************************************      >>log\run_all_report.log
echo ***  Run UI mode with no coverage                     ***      >>log\run_all_report.log
echo *********************************************************      >>log\run_all_report.log
vsim -do do\run_all.do
goto RUN_END

:RUN_UICOV
echo *********************************************************
echo ***  Run UI mode with coverage                        ***
echo *********************************************************
echo *********************************************************      >>log\run_all_report.log
echo ***  Run UI mode with coverage                        ***      >>log\run_all_report.log
echo *********************************************************      >>log\run_all_report.log
vsim -do do\run_all_cov.do
goto RUN_END

:RUN_END

echo *********************************************************
echo ***  SIM END                                          ***
echo *********************************************************
echo *********************************************************      >>log\run_all_report.log
echo ***  SIM END                                          ***      >>log\run_all_report.log
echo *********************************************************      >>log\run_all_report.log


echo *********************************************************
echo ***  Warning List                                     ***
echo *********************************************************

echo ***  tb_f0_00
type ..\sim\log\tb_f0_00_vsim.log | find "Warning"
echo ***  tb_f0_01
type ..\sim\log\tb_f0_01_vsim.log | find "Warning"
echo ***  tb_f0_02
type ..\sim\log\tb_f0_02_vsim.log | find "Warning"
echo ***  tb_f0_03
type ..\sim\log\tb_f0_03_vsim.log | find "Warning"
echo ***  tb_f0_04
type ..\sim\log\tb_f0_04_vsim.log | find "Warning"
echo ***  tb_f0_05
type ..\sim\log\tb_f0_05_vsim.log | find "Warning"
echo ***  tb_f0_06
type ..\sim\log\tb_f0_06_vsim.log | find "Warning"
echo ***  tb_f0_07
type ..\sim\log\tb_f0_07_vsim.log | find "Warning"
echo ***  tb_f0_08
type ..\sim\log\tb_f0_08_vsim.log | find "Warning"
echo ***  tb_f0_09
type ..\sim\log\tb_f0_09_vsim.log | find "Warning"
echo ***  tb_f0_10
type ..\sim\log\tb_f0_10_vsim.log | find "Warning"
echo ***  tb_f1_00
type ..\sim\log\tb_f1_00_vsim.log | find "Warning"
echo ***  tb_f1_01
type ..\sim\log\tb_f1_01_vsim.log | find "Warning"
echo ***  tb_f1_02
type ..\sim\log\tb_f1_02_vsim.log | find "Warning"
echo ***  tb_f1_03
type ..\sim\log\tb_f1_03_vsim.log | find "Warning"
echo ***  tb_f1_04
type ..\sim\log\tb_f1_04_vsim.log | find "Warning"
echo ***  tb_f1_05
type ..\sim\log\tb_f1_05_vsim.log | find "Warning"
echo ***  tb_f1_06
type ..\sim\log\tb_f1_06_vsim.log | find "Warning"
echo ***  tb_f6_00
type ..\sim\log\tb_f6_00_vsim.log | find "Warning"
echo ***  tb_f6_01
type ..\sim\log\tb_f6_01_vsim.log | find "Warning"
echo ***  tb_f6_02
type ..\sim\log\tb_f6_02_vsim.log | find "Warning"
echo ***  tb_f6_03
type ..\sim\log\tb_f6_03_vsim.log | find "Warning"

echo *********************************************************      >>log\run_all_warning.log
echo ***  Warning List                                     ***      >>log\run_all_warning.log
echo *********************************************************      >>log\run_all_warning.log

echo ***  tb_f0_00                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f0_00_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f0_01                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f0_01_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f0_02                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f0_02_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f0_03                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f0_03_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f0_04                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f0_04_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f0_05                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f0_05_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f0_06                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f0_06_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f0_07                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f0_07_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f0_08                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f0_08_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f0_09                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f0_09_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f0_10                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f0_10_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f1_00                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f1_00_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f1_01                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f1_01_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f1_02                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f1_02_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f1_03                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f1_03_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f1_04                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f1_04_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f1_05                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f1_05_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f1_06                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f1_06_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f6_00                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f6_00_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f6_01                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f6_01_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f6_02                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f6_02_vsim.log | find "Warning"                  >>log\run_all_warning.log
echo ***  tb_f6_03                                                  >>log\run_all_warning.log
type ..\sim\log\tb_f6_03_vsim.log | find "Warning"                  >>log\run_all_warning.log

echo *********************************************************
echo ***  Error List                                       ***
echo *********************************************************

echo ***  tb_f0_00
type ..\sim\log\tb_f0_00_vsim.log | find "Error"
echo ***  tb_f0_01
type ..\sim\log\tb_f0_01_vsim.log | find "Error"
echo ***  tb_f0_02
type ..\sim\log\tb_f0_02_vsim.log | find "Error"
echo ***  tb_f0_03
type ..\sim\log\tb_f0_03_vsim.log | find "Error"
echo ***  tb_f0_04
type ..\sim\log\tb_f0_04_vsim.log | find "Error"
echo ***  tb_f0_05
type ..\sim\log\tb_f0_05_vsim.log | find "Error"
echo ***  tb_f0_06
type ..\sim\log\tb_f0_06_vsim.log | find "Error"
echo ***  tb_f0_07
type ..\sim\log\tb_f0_07_vsim.log | find "Error"
echo ***  tb_f0_08
type ..\sim\log\tb_f0_08_vsim.log | find "Error"
echo ***  tb_f0_09
type ..\sim\log\tb_f0_09_vsim.log | find "Error"
echo ***  tb_f0_10
type ..\sim\log\tb_f0_10_vsim.log | find "Error"
echo ***  tb_f1_00
type ..\sim\log\tb_f1_00_vsim.log | find "Error"
echo ***  tb_f1_01
type ..\sim\log\tb_f1_01_vsim.log | find "Error"
echo ***  tb_f1_02
type ..\sim\log\tb_f1_02_vsim.log | find "Error"
echo ***  tb_f1_03
type ..\sim\log\tb_f1_03_vsim.log | find "Error"
echo ***  tb_f1_04
type ..\sim\log\tb_f1_04_vsim.log | find "Error"
echo ***  tb_f1_05
type ..\sim\log\tb_f1_05_vsim.log | find "Error"
echo ***  tb_f1_06
type ..\sim\log\tb_f1_06_vsim.log | find "Error"
echo ***  tb_f6_00
type ..\sim\log\tb_f6_00_vsim.log | find "Error"
echo ***  tb_f6_01
type ..\sim\log\tb_f6_01_vsim.log | find "Error"
echo ***  tb_f6_02
type ..\sim\log\tb_f6_02_vsim.log | find "Error"
echo ***  tb_f6_03
type ..\sim\log\tb_f6_03_vsim.log | find "Error"

echo *********************************************************      >>log\run_all_error.log
echo ***  Error List                                       ***      >>log\run_all_error.log
echo *********************************************************      >>log\run_all_error.log

echo ***  tb_f0_00                                                  >>log\run_all_error.log
type ..\sim\log\tb_f0_00_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f0_01                                                  >>log\run_all_error.log
type ..\sim\log\tb_f0_01_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f0_02                                                  >>log\run_all_error.log
type ..\sim\log\tb_f0_02_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f0_03                                                  >>log\run_all_error.log
type ..\sim\log\tb_f0_03_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f0_04                                                  >>log\run_all_error.log
type ..\sim\log\tb_f0_04_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f0_05                                                  >>log\run_all_error.log
type ..\sim\log\tb_f0_05_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f0_06                                                  >>log\run_all_error.log
type ..\sim\log\tb_f0_06_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f0_07                                                  >>log\run_all_error.log
type ..\sim\log\tb_f0_07_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f0_08                                                  >>log\run_all_error.log
type ..\sim\log\tb_f0_08_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f0_09                                                  >>log\run_all_error.log
type ..\sim\log\tb_f0_09_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f0_10                                                  >>log\run_all_error.log
type ..\sim\log\tb_f0_10_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f1_00                                                  >>log\run_all_error.log
type ..\sim\log\tb_f1_00_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f1_01                                                  >>log\run_all_error.log
type ..\sim\log\tb_f1_01_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f1_02                                                  >>log\run_all_error.log
type ..\sim\log\tb_f1_02_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f1_03                                                  >>log\run_all_error.log
type ..\sim\log\tb_f1_03_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f1_04                                                  >>log\run_all_error.log
type ..\sim\log\tb_f1_04_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f1_05                                                  >>log\run_all_error.log
type ..\sim\log\tb_f1_05_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f1_06                                                  >>log\run_all_error.log
type ..\sim\log\tb_f1_06_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f6_00                                                  >>log\run_all_error.log
type ..\sim\log\tb_f6_00_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f6_01                                                  >>log\run_all_error.log
type ..\sim\log\tb_f6_01_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f6_02                                                  >>log\run_all_error.log
type ..\sim\log\tb_f6_02_vsim.log | find "Error"                    >>log\run_all_error.log
echo ***  tb_f6_03                                                  >>log\run_all_error.log
type ..\sim\log\tb_f6_03_vsim.log | find "Error"                    >>log\run_all_error.log

date /t
time /t
date /t                                                             >>log\run_all_report.log
time /t                                                             >>log\run_all_report.log
date /t                                                             >>log\run_all_error.log
time /t                                                             >>log\run_all_error.log
date /t                                                             >>log\run_all_warning.log
time /t                                                             >>log\run_all_warning.log

