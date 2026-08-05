@echo off
start "" "C:\lffg\desk\screen-explainer\node_modules\electron\dist\electron.exe" "C:\lffg\desk\screen-explainer"

cd /d C:\lffg\esc\sigsa-admin2-front
call full

timeout /t 50 /nobreak >nul
powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0poner-vscode-pantalla-completa.ps1"
