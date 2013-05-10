rem @ECHO OFF
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

"%BSH_MTTY%" -t local-cmd -l %_LOGFIL%  /bin/console.exe cmd.exe

rem "%perlExe%" -0777 -pe 's/\r\r\n/\r\n/g' -i %CMDLOG%

rem set /p INP="Enter return >"
