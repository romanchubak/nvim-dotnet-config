Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;

public class Win32 {
    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);

    [DllImport("user32.dll", SetLastError=true)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);


    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@

$windowTitles = @()
$windowTitle = "C:\Users\rchubak\scoop\shims\netcoredbg.exe"

$callback = [Win32+EnumWindowsProc]{
    param($hWnd, $lParam)

    if ([Win32]::IsWindowVisible($hWnd)) {
        $sb = New-Object System.Text.StringBuilder 1024
        [Win32]::GetWindowText($hWnd, $sb, $sb.Capacity) | Out-Null
        $title = $sb.ToString()
        if ($title -eq $windowTitle) {
            [Win32]::ShowWindow($hwnd, 6)
            $script:windowTitles += $title
        }
    }

    return $true
}

[Win32]::EnumWindows($callback, [IntPtr]::Zero) | Out-Null

# Print results
$windowTitles | Sort-Object | ForEach-Object { Write-Output $_ }
