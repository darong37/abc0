@ECHO OFF
if not "%DEBUG%" == "" ( @ECHO ON )
rem 
rem assignToExe options
rem   Visiblity   : Invisible application
rem   Working dir : current
rem 
call %~dp0%_init.bat

set DIR_CALL=%~dp1

set fn=%~nx1

"%BSH_PERL%" -e "print '%fn%'" | clip

set _LOGDIR=%DIR_LOGS%\%_dt08%
IF not EXIST %_LOGDIR% (
  mkdir %_LOGDIR%
)
set _LOGFIL=%_LOGDIR%\local_%_tm06%_bash.log

if not "%DEBUG%" == "" ( set /p INP="Enter return >" )

start %BSH_MTTY% -t "Another Bash Console"  -l %_LOGFIL% /bin/bash --login -i
