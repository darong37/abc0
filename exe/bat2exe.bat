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

"%asinExe%" -bat %batnm% -save %exenm% -invisible -overwrite
rem "%asinExe%" -bat %batnm% -save %exenm% -invisible -overwrite

call "%EXECBASE%\ShortCut.bat" /t:"%dn%%nm%.exe" "%dn%%nm%.lnk"

copy "%dn%%nm%.lnk" "%SENDDIR%"
copy "%dn%%nm%.lnk" "%LAUNDIR%"

echo created %exenm%
set /p INP="Enter return >"
