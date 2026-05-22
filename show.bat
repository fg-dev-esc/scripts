@echo off
title SHOWBAR

echo.
echo S H O W

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3" /v Settings /t REG_BINARY /d 30000000FEFFFFFF02000000030000003E00000028000000000000001004000080070000380400006000000001000000 /f >nul

taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe >nul 2>&1