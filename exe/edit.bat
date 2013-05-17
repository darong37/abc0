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

echo "'%dn%' : '%_FILECASH%'" > "%DIR_TEMP%\edit.tmp"

if not "%DEBUG%" == "" ( set /p INP="Enter return >" )

IF "%dn%"=="%_FILECASH%" (
	start %EXE_EDIT% -R %fn%
) ELSE (
	start %EXE_EDIT%    %fn%
)

