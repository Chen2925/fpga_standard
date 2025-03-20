@echo off
echo *********************************************************
echo ***  Del Source                                       ***
echo *********************************************************

title simulation

:START
set DEL_MODE=%1

if "%DEL_MODE%" == "log"   goto DEL_LOG
if "%DEL_MODE%" == "wave"  goto DEL_WAVE
if "%DEL_MODE%" == "work"  goto DEL_WORK
if "%DEL_MODE%" == "cov"   goto DEL_COV
if "%DEL_MODE%" == "all"   goto DEL_ALL
goto DEL_ALL

:DEL_LOG
echo *********************************************************
echo ***  Del LOG                                          ***
echo *********************************************************
if exist log\*.log del log\*.log
goto DEL_END

:DEL_WAVE
echo *********************************************************
echo ***  Del WAVE                                         ***
echo *********************************************************
if exist wave\*.wlf del wave\*.wlf
goto DEL_END

:DEL_COV
echo *********************************************************
echo ***  Del WAVE                                         ***
echo *********************************************************
if exist cov\*.* del cov\*.*
goto DEL_END

:DEL_WORK
echo *********************************************************
echo ***  Del WORK                                         ***
echo *********************************************************
if exist work vdel -all work
goto DEL_END

:DEL_ALL
echo *********************************************************
echo ***  Del ALL                                          ***
echo *********************************************************
if exist log\*.log del log\*.log
if exist wave\*.wlf del wave\*.wlf
if exist cov\*.* del /q cov\*.*
if exist work vdel -all work
goto DEL_END

:DEL_END
echo *********************************************************
echo ***  DEL END                                          ***
echo *********************************************************

rem echo file del success ?
rem choice /c:yn
rem if errorlevel 2 goto DEL_ALL
rem if errorlevel 1 goto DEL_END

rem pause

date /t & time /t