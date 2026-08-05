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

$windows = Get-Process Code -ErrorAction SilentlyContinue |
    Where-Object { $_.MainWindowHandle -ne 0 }

$vscode = $windows |
    Where-Object { $_.MainWindowTitle -like '*sigsa-admin2-front*' } |
    Select-Object -First 1

if (-not $vscode) {
    $vscode = $windows | Sort-Object StartTime -Descending | Select-Object -First 1
}

if (-not $vscode) {
    exit 1
}

$handle = [IntPtr]$vscode.MainWindowHandle
[void][WindowApi]::ShowWindowAsync($handle, 9)

# A brief Alt press permits foreground activation under Windows focus rules.
[WindowApi]::keybd_event(0x12, 0, 0, [UIntPtr]::Zero)
[WindowApi]::keybd_event(0x12, 0, 2, [UIntPtr]::Zero)
[void][WindowApi]::SetForegroundWindow($handle)

# Raise VS Code above every window, then immediately remove the topmost state.
$positionFlags = 0x0001 -bor 0x0002 -bor 0x0040
[void][WindowApi]::SetWindowPos($handle, [IntPtr](-1), 0, 0, 0, 0, $positionFlags)
[void][WindowApi]::SetWindowPos($handle, [IntPtr](-2), 0, 0, 0, 0, $positionFlags)
Start-Sleep -Milliseconds 500

# Send F11 directly to VS Code so another application cannot receive it.
[void][WindowApi]::PostMessage($handle, 0x0100, [IntPtr]0x7A, [IntPtr]0)
[void][WindowApi]::PostMessage($handle, 0x0101, [IntPtr]0x7A, [IntPtr]0)

Start-Sleep -Milliseconds 500

# Close only Antigravity's visible window; its background process stays running.
$antigravity = Get-Process Antigravity -ErrorAction SilentlyContinue |
    Where-Object { $_.MainWindowHandle -ne 0 } |
    Select-Object -First 1

if ($antigravity) {
    [void][WindowApi]::PostMessage(
        [IntPtr]$antigravity.MainWindowHandle,
        0x0010,
        [IntPtr]::Zero,
        [IntPtr]::Zero
    )
}
