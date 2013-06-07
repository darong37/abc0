@echo off
for %%I in (%1 %1.com %1.exe %1.bat %1.cmd %1.vbs %1.js %1.wsf) do if exist %%~$path:I echo %%~$path:I
