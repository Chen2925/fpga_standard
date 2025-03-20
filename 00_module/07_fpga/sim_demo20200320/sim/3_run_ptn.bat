@echo off

:START
set RUN_PTN=%1
set RUN_MODE=%2

if exist wave\%RUN_PTN%.wlf del wave\%RUN_PTN%.wlf
if exist log\*%RUN_PTN%*.log del log\*%RUN_PTN%*.log
if exist cov\*%RUN_PTN%*.* del cov\*%RUN_PTN%*.*

echo *********************************************************
echo ***  Run %RUN_PTN%                                 ***
echo *********************************************************

if "%RUN_MODE%" == "cmd"        goto RUN_CMD
if "%RUN_MODE%" == "ui"         goto RUN_UI
goto RUN_UI

:RUN_CMD
echo *********************************************************
echo ***  Run command mode with no coverage                ***
echo *********************************************************
vsim -c -do do\%RUN_PTN%.do
goto RUN_END

:RUN_UI
echo *********************************************************
echo ***  Run UI mode with no coverage                     ***
echo *********************************************************
vsim -do do\%RUN_PTN%.do
goto RUN_END

:RUN_END
echo *********************************************************
echo ***  %RUN_PTN%  SIM END                             ***
echo *********************************************************


