@ECHO OFF
rem 
rem assignToExe options
rem   Visiblity   : Invisible application
rem   Working dir : current
rem 
call %~dp0\_init.bat

set fn=%1
set dn=%~dp1
if NOT "%dn%" == "" (
	set dn=%dn:~0,-1%
)

IF "%dn% "=="%_FILECASH%" (
	start %EXE_EDIT% -R %fn%
) ELSE (
	start %EXE_EDIT%    %fn%
)

rem set /p INP="Enter return >"

