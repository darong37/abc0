@ECHO OFF
rem Use in sakura( put created diff.exe into sakura-install-folder)
rem 
rem Bat_To_Exe_Converter options
rem   Visiblity   : Visible application
rem   Working dir : Temporary
rem 
call %~dp0\_init.bat

start %EXE_DIFF% %*
