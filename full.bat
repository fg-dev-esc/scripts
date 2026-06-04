@echo off

echo.
echo F U L L
echo.

start comet.exe

if not "%~1"=="" (
    cd /d "%~1" || exit /b 1
)

powershell.exe -NoProfile -Command "Start-Process -FilePath (Join-Path $env:LOCALAPPDATA 'Programs\Microsoft VS Code\Code.exe') -ArgumentList '.' -WorkingDirectory (Get-Location).Path"

start "" wt.exe -d . "%APPDATA%\npm\node_modules\opencode-ai\bin\opencode.exe"

start "" "%LOCALAPPDATA%\Programs\Notion\Notion.exe"

if /I "%CD%"=="C:\lffg\esc\sigsa-admin-front" (
    start http://localhost:5173
    npm run dev

) else if /I "%CD%"=="C:\lffg\ext\subasta-total-web" (
    start http://localhost:5173
    npm run dev

) else if /I "%CD%"=="C:\lffg\ext\dev-web3-uniquemotors" (
    start http://localhost:5173
    npm run dev

) else (
    npm start
)