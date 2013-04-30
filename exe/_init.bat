rem @ECHO OFF
rem 
rem 
rem dirname : %~dp0
rem basename: %~nx0
rem 
rem %~0     �c �t�@�C����    �F[test]
rem %~f0    �c �t���p�X      �F[C:\home\edu\BAT\expand\test.bat]
rem %~d0    �c �h���C�u��    �F[C:]
rem %~p0    �c �p�X���̂�    �F[\home\edu\BAT\expand\]
rem %~n0    �c �t�@�C����    �F[test]�i�g���q�����j
rem %~x0    �c �g���q        �F[.bat]
rem %~s0    �c �Z�����O�̂�  �F[C:\home\edu\BAT\expand\test.bat]
rem %~a0    �c �t�@�C������  �F[--a------]
rem %~t0    �c �t�@�C�����t  �F[2010/02/05 00:45]
rem %~z0    �c �t�@�C���T�C�Y�F[204]
rem %~dp0   �c �t�@�C���̏ꏊ�F[C:\home\edu\BAT\expand\]
rem %~nx0   �c �t�@�C����    �F[test.bat]�i�g���q�t���j
rem %~fs0   �c ���S�ȃp�X�ƒZ�����O�F[C:\home\edu\BAT\expand\test.bat]
rem %~ftza0 �c �����\��      �F[--a------ 2010/02/05 00:45 204 C:\home\edu\BAT\expand\test.bat]
rem 

rem 
rem Folder path
rem 
set HOME=C:\Users\JKK0544\.abc

set APPSBASE=%HOME%\apps
set BASHBASE=%HOME%\.sys
set EXECBASE=%HOME%\exe
set LOGSBASE=%HOME%\logs
set TEMPBASE=%HOME%\tmp
set WORKSPAC=%HOME%\workspace

set LAUNDIR=%APPSBASE%\_LAUNCHER
set SENDDIR=%HOME%\AppData\Roaming\Microsoft\Windows\SendTo

rem 
rem Exe path
rem 
set asinExe=%APPSBASE%\assignBat2Exe\assignBat2Exe\Bat_To_Exe_Converter.exe
set bashExe=%BASHBASE%\bin\bash.exe
set consExe=%APPSBASE%\console2\Console2\Console.exe
set diffExe=%APPSBASE%\df\df141\DF.exe
set editExe=%HOME%\AppData\Roaming\sakura\sakura.exe
set ffftExe=%APPSBASE%\ffftp\FFFTP.exe
set mttyExe=%BASHBASE%\bin\mintty.exe
set perlExe=%BASHBASE%\bin\perl.exe
set rubyExe=%APPSBASE%\ruby\current\bin\ruby.exe

set cmdWins=c:\Windows\system32\cmd.exe
set expWins=c:\Windows\explorer.exe
set ps1Wins=c:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe

rem 
rem Work path
rem 
set asinBatD=%EXECBASE%\bat
set ffftCash=%WORKSPAC%\.ffftp\file

rem 
rem Date Time
rem 
set dt08=%date:~-10,4%%date:~-5,2%%date:~-2,2%
set tm11=%time: =0%
set tm06=%tm11:~0,2%%tm11:~3,2%%tm11:~6,2%


rem 
rem Else
rem 
set http_proxy=http://xxxx:8080

