@ECHO OFF
if not "%DEBUG%" == "" ( @ECHO ON )
rem 
rem assignToExe options
rem   Visiblity   : Invisible application
rem   Working dir : current
rem 
call %~dp0\_init.bat

set fn=%~nx1
set dn=%~dp1
if NOT "%dn%" == "" (
  set dn=%dn:~0,-1%
)

"%BSH_PERL%" -e "print '%fn%'" | clip

set _LOGDIR=%DIR_LOGS%\%_dt08%
IF NOT EXIST %_LOGDIR% (
  mkdir %_LOGDIR%
)
set _LOGFIL=%_LOGDIR%\local_%_tm06%_cmd.log

cd %dn%

if not "%DEBUG%" == "" ( set /p INP="Enter return >" )

start %BSH_MTTY% -t local-cmd -l %_LOGFIL%  /bin/console.exe cmd.exe
