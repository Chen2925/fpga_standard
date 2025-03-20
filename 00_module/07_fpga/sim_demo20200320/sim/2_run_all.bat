@echo off
if exist work vdel -all work
if exist wave\*.wlf del wave\*.wlf
if exist log\*.log del log\*.log
if exist cov\*.* del /q cov\*.*

:START
rem run mode
set RUN_MODE=%1
rem echo run mode %1

if "%RUN_MODE%" == "cmd"        goto RUN_CMD
if "%RUN_MODE%" == "cmdcov"     goto RUN_CMDCOV
if "%RUN_MODE%" == "ui"         goto RUN_UI
if "%RUN_MODE%" == "uicov"      goto RUN_UICOV
goto RUN_UI

:RUN_CMD
echo *********************************************************
echo ***  Run command mode with no coverage                ***
echo *********************************************************
vsim -c -do do\run_all.do
goto RUN_END

:RUN_CMDCOV
echo *********************************************************
echo ***  Run command mode with coverage                   ***
echo *********************************************************
vsim -c -do do\coverage_all.do
goto RUN_END

:RUN_UI
echo *********************************************************
echo ***  Run UI mode with no coverage                     ***
echo *********************************************************
vsim -do do\run_all.do
goto RUN_END

:RUN_UICOV
echo *********************************************************
echo ***  Run UI mode with coverage                        ***
echo *********************************************************
vsim -do do\coverage_all.do
goto RUN_END

:RUN_END
echo *********************************************************
echo ***  SIM END                                          ***
echo *********************************************************
