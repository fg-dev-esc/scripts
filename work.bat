@echo off

if "%~1"=="" goto current

cd /d "%~1"
if errorlevel 1 exit /b 1

:current
echo.
echo C O D E
echo.

start "" code .

echo.
echo O P E N C O D E
echo.

wt.exe -d . powershell -NoExit -Command opencode
