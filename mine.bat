@echo off
cls
title miner
cd /d "%~dp0"

:init
echo initializing...
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

rem    Priviledges grabber by endermanch/matt

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
echo no priviledges detected. getting it...
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
echo Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
echo args = "ELEV " >> "%vbsGetPrivileges%"
echo For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
echo args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
echo Next >> "%vbsGetPrivileges%"
echo UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
echo detected priviledges. continue init...
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

cls
echo Start with...
echo 1. config
echo 2. cli
echo e. exit
echo.

choice /c 12e /n /m "choice> "
if %ERRORLEVEL%==0 goto breakexit
if %ERRORLEVEL%==1 goto sconfig
if %ERRORLEVEL%==2 goto scli
if %ERRORLEVEL%==3 goto exit
if %ERRORLEVEL%==255 goto errorexit

:sconfig
echo.
echo config selected. using config to start...
timeout /t 1 /nobreak > nul
cls
xmrig.exe config.json
pause
goto exit

:scli
echo.
echo command line selected. using command to start...
timeout /t 1 /nobreak > nul
cls
xmrig.exe -o pool.hashvault.pro:443 -u 49ms22wR6grVwgcoB9Q2oLTFawCsh6x6uERAnsXVA4v87c17DyxzqwgPuaUZDczZvTihy25yz7grV7EPGAwiGuW2QMRGskE -p RandomPC -k --tls
pause
goto exit

:errorexit
echo error detected. exiting...
goto EOF

:breakexit
echo break exit...
goto EOF

:exit
echo exiting...


:EOF
