@echo off

if "%~1"=="" (
    echo Uso: clone URL_DEL_REPO
    exit /b 1
)

cd /d C:\lffg\bs

echo.
echo C L O N E

git clone %1
if errorlevel 1 exit /b 1

for %%i in ("%~1") do set REPO=%%~ni

cd /d "C:\lffg\bs\%REPO%"
if errorlevel 1 exit /b 1

echo.
echo I N S T A L L

call npm install

echo.
echo C O D E
code .
