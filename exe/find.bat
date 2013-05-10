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

start %EXE_FIND% -path %dn%

rem set /p INP="Enter return >"

