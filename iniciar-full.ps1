Add-Type @'
using System;
using System.Runtime.InteropServices;

public static class WindowApi
{
    [DllImport("user32.dll")]
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int x, int y, int cx, int cy, uint flags);

    [DllImport("user32.dll")]
    public static extern void keybd_event(byte virtualKey, byte scanCode, uint flags, UIntPtr extraInfo);

    [DllImport("user32.dll")]
    public static extern bool PostMessage(IntPtr hWnd, uint msg, IntPtr wParam, IntPtr lParam);
}
'@

$projectPath = 'C:\lffg\esc\sigsa-admin2-front'
$logPath = 'C:\lffg\scripts\iniciar-full.log'

function Write-Log {
    param([string]$Message)

    "[$(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')] $Message" |
        Out-File -FilePath $logPath -Append -Encoding utf8
}

if (-not (Test-Path $projectPath)) {
    Write-Log 'No se encontro el proyecto'
    exit 1
}

Set-Location $projectPath
Write-Log 'Iniciando'

Start-Process `
    -FilePath "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe" `
    -ArgumentList '.' `
    -WorkingDirectory $projectPath

Start-Process `
    -FilePath 'wt.exe' `
    -ArgumentList @('-d', $projectPath, "$env:APPDATA\npm\opencode.cmd") `
    -WorkingDirectory $projectPath

Write-Log 'Aplicaciones iniciadas'

Start-Sleep -Seconds 90

$windows = Get-Process Code -ErrorAction SilentlyContinue |
    Where-Object { $_.MainWindowHandle -ne 0 }

$vscode = $windows |
    Where-Object { $_.MainWindowTitle -like '*sigsa-admin2-front*' } |
    Select-Object -First 1

if (-not $vscode) {
    $vscode = $windows |
        Sort-Object StartTime -Descending |
        Select-Object -First 1
}

if ($vscode) {
    $handle = [IntPtr]$vscode.MainWindowHandle

    [void][WindowApi]::ShowWindowAsync($handle, 9)
    [WindowApi]::keybd_event(0x12, 0, 0, [UIntPtr]::Zero)
    [WindowApi]::keybd_event(0x12, 0, 2, [UIntPtr]::Zero)
    [void][WindowApi]::SetForegroundWindow($handle)

    $positionFlags = 0x0001 -bor 0x0002 -bor 0x0040
    [void][WindowApi]::SetWindowPos($handle, [IntPtr](-1), 0, 0, 0, 0, $positionFlags)
    [void][WindowApi]::SetWindowPos($handle, [IntPtr](-2), 0, 0, 0, 0, $positionFlags)

    Start-Sleep -Milliseconds 500
    [void][WindowApi]::PostMessage($handle, 0x0100, [IntPtr]0x7A, [IntPtr]0)
    [void][WindowApi]::PostMessage($handle, 0x0101, [IntPtr]0x7A, [IntPtr]0)
}

Start-Sleep -Milliseconds 500

Get-Process Antigravity, ChatGPT, ms-teams -ErrorAction SilentlyContinue |
    Where-Object { $_.MainWindowHandle -ne 0 } |
    ForEach-Object {
        [void][WindowApi]::PostMessage(
            [IntPtr]$_.MainWindowHandle,
            0x0010,
            [IntPtr]::Zero,
            [IntPtr]::Zero
        )
    }

Write-Log 'Finalizado'
