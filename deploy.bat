@echo off

if "%~1"=="" goto current

cd /d "C:\lffg\esc\%~1"
if errorlevel 1 exit /b 1

:current
echo.
echo D E P L O Y

call npm run deploy
