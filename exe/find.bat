@ECHO OFF
if not "%DEBUG%" == "" ( @ECHO ON )
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

if not "%DEBUG%" == "" ( set /p INP="Enter return >" )

start %EXE_FIND% -path %dn%
