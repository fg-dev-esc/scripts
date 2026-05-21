@echo off
set "FOUND="

echo.
echo K I L L
echo.

for /f "tokens=2,5" %%a in ('netstat -ano ^| findstr ":3000 :3001 :3002 :5173 :5174 :5175"') do (
    set FOUND=1
    call :killport %%a %%b
)

if not defined FOUND (
    echo C L E A R
    echo.
    exit /b
)

echo.
echo D O N E
echo.
exit /b

:killport
for /f "tokens=2 delims=:" %%c in ("%1") do echo %%c
taskkill /F /PID %2 >nul 2>&1
goto :eof
