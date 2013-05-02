@ECHO OFF
rem 
rem assignBat2Exe options
rem   Visiblity   : Invisible application
rem   Working dir : current
rem 
call %~dp0\_init.bat

set dn=%~dp1
set nm=%~n1

set batnm=%dn%%nm%.bat
set exenm=%dn%%nm%.exe

IF EXIST %exenm% (
  del %exenm%
)

"%EXE_BAT2%" -bat %batnm% -save %exenm% -invisible -overwrite

echo created %exenm%
set /p INP="Enter return >"
