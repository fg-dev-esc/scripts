@echo off

if not "%~1"=="" (
    cd /d "%~1" || exit /b 1
)

powershell.exe -NoProfile -Command "Start-Process -FilePath (Join-Path $env:LOCALAPPDATA 'Programs\Microsoft VS Code\Code.exe') -ArgumentList '.' -WorkingDirectory (Get-Location).Path"
start "" wt.exe -d . "%APPDATA%\npm\node_modules\opencode-ai\bin\opencode.exe"
