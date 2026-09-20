@echo off
@REM start "" "C:\lffg\desk\context-providers-agent\node_modules\electron\dist\electron.exe" "C:\lffg\desk\context-providers-agent"

echo [%date% %time%] Iniciando >> "%~dp0inicio\iniciar-full.log"
cd /d "C:\lffg\esc\sigsa-admin2-front" || (
    echo [%date% %time%] No se encontro el proyecto >> "%~dp0inicio\iniciar-full.log"
    exit /b 1
)
call "%~dp0full.bat" >> "%~dp0inicio\iniciar-full.log" 2>&1
echo [%date% %time%] Aplicaciones iniciadas >> "%~dp0inicio\iniciar-full.log"

timeout /t 90 /nobreak >nul
powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0inicio\poner-vscode-pantalla-completa.ps1"
echo [%date% %time%] Finalizado >> "%~dp0inicio\iniciar-full.log"
