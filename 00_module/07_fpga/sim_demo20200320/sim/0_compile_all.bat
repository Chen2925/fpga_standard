@echo off
if exist log\comp_report.log del log\comp_report.log

echo *********************************************************                  >>log\comp_report.log
echo ***  Compile Source                                   ***                  >>log\comp_report.log
echo *********************************************************                  >>log\comp_report.log

if exist work vdel -all work
if exist wave\tb_*.wlf del wave\tb_*.wlf
if exist compile_do.bat del compile_do.bat
if exist comp.log del comp.log

vlib work >> comp.log
vmap work

:START
rem compile mode
set COMP_MODE1=%1
set COMP_MODE2=%2
rem echo compile mode %1
echo *********************************************************
echo ***  Compile mode : %COMP_MODE1%   %COMP_MODE2%       ***
echo *********************************************************

if "%COMP_MODE1%" == "rtl"  goto COMP_RTL
if "%COMP_MODE1%" == "lib"  goto COMP_LIB
if "%COMP_MODE1%" == "sim"  goto COMP_SIM
if "%COMP_MODE1%" == "all"  goto COMP_ALL
goto COMP_ALLCOV

:COMP_RTL
rem compile rtl
if "%COMP_MODE2%" == "cov"  goto COMP_RTLCOV
type ..\sim\do\compile_rtl.do | find "vlog"                                     >>compile_do.bat
type ..\sim\do\compile_rtl.do | find "vcom"                                     >>compile_do.bat
goto COMP_DO

:COMP_RTLCOV
type ..\sim\do\compile_rtl.do | find "vlog"                                     >>compile_do.bat
type ..\sim\do\compile_rtl.do | find "vcom"                                     >>compile_do.bat
type ..\sim\do\compile_cov.do | find "vlog"                                     >>compile_do.bat
type ..\sim\do\compile_cov.do | find "vcom"                                     >>compile_do.bat
goto COMP_DO

:COMP_LIB
rem compile lib
type ..\sim\do\compile_lib.do | find "vlog"                                     >>compile_do.bat
type ..\sim\do\compile_lib.do | find "vcom"                                     >>compile_do.bat
goto COMP_DO

:COMP_SIM
rem compile sim
type ..\sim\do\compile_sim.do | find "vlog"                                     >>compile_do.bat
type ..\sim\do\compile_sim.do | find "vcom"                                     >>compile_do.bat
goto COMP_DO

:COMP_ALL
if "%COMP_MODE2%" == "cov"  goto COMP_ALLCOV
type ..\sim\do\compile_rtl.do | find "vlog"                                     >>compile_do.bat
type ..\sim\do\compile_rtl.do | find "vcom"                                     >>compile_do.bat
type ..\sim\do\compile_lib.do | find "vlog"                                     >>compile_do.bat
type ..\sim\do\compile_lib.do | find "vcom"                                     >>compile_do.bat
type ..\sim\do\compile_sim.do | find "vlog"                                     >>compile_do.bat
type ..\sim\do\compile_sim.do | find "vcom"                                     >>compile_do.bat
goto COMP_DO

:COMP_ALLCOV
rem type ..\sim\do\compile_rtl.do | find "vlog"                                     >>compile_do.bat
rem type ..\sim\do\compile_rtl.do | find "vcom"                                     >>compile_do.bat
type ..\sim\do\compile_cov.do | find "vlog"                                     >>compile_do.bat
type ..\sim\do\compile_cov.do | find "vcom"                                     >>compile_do.bat
type ..\sim\do\compile_lib.do | find "vlog"                                     >>compile_do.bat
type ..\sim\do\compile_lib.do | find "vcom"                                     >>compile_do.bat
type ..\sim\do\compile_sim.do | find "vlog"                                     >>compile_do.bat
type ..\sim\do\compile_sim.do | find "vcom"                                     >>compile_do.bat
goto COMP_DO

:COMP_DO
call compile_do.bat                                                             >>log\comp_report.log
goto LOGOUT

:LOGOUT
rem Waring and error pick out
del compile_do.bat
type ..\sim\log\comp_report.log | find "Error"                                 >>log\comp_report.log
type ..\sim\log\comp_report.log | find "Warning"                               >>log\comp_report.log
type ..\sim\log\comp_report.log | find "Error"
type ..\sim\log\comp_report.log | find "Warning"

del comp.log
echo *********************************************************
echo ***  Compile Source  END                              ***
echo *********************************************************
echo *********************************************************                  >>log\comp_report.log
echo ***  Compile Source  END                              ***                  >>log\comp_report.log
echo *********************************************************                  >>log\comp_report.log
date /t                                                                         >>log\comp_report.log
time /t                                                                         >>log\comp_report.log
