@echo off

echo F U L L

if not "%~1"=="" (
    cd /d "%~1" || exit /b 1
)

start "" "%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe" .

start "" wt.exe -d . "%APPDATA%\npm\node_modules\opencode-ai\bin\opencode.exe"
