if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    try {
        Write-Host 'Requesting administrative privileges...' -ForegroundColor Cyan
        Start-Process -FilePath PowerShell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -ErrorAction Stop
        exit 0
    }
    catch {
        Write-Host "Administrator elevation failed: $($_.Exception.Message)" -ForegroundColor Red
        Read-Host -Prompt "Press Enter to exit"
        exit 1
    }
}

function Invoke-SC {
    param(
        [string[]]$SCArgs
    )
    try {
        Start-Process -FilePath 'sc.exe' -ArgumentList $SCArgs -NoNewWindow -Wait -ErrorAction Stop
    }
    catch {
        Write-Host "Service command failed: $($_.Exception.Message)" -ForegroundColor Red
        Read-Host -Prompt "Press Enter to exit"
        exit 1
    }
}

$Arch = if ([Environment]::Is64BitOperatingSystem) { 'x86_64' } else { 'x86' }
$DPIPath = "$PSScriptRoot\$Arch\goodbyedpi.exe"
$DPIArgs = '--set-ttl 3'
$SCDesc = 'GoodbyeDPI intercepts and modifies DPI-based traffic at kernel level using WinDivert.'

if (-not (Test-Path $DPIPath)) {
    Write-Host "GoodbyeDPI executable not found at: '$DPIPath'" -ForegroundColor Red
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

Write-Host " "
Write-Host "GoodbyeDPI Path: $DPIPath" -ForegroundColor Yellow
Write-Host "GoodbyeDPI Args: $DPIArgs" -ForegroundColor Yellow
Write-Host " "

Read-Host -Prompt "Press Enter to continue"

Write-Host "Stopping GoodbyeDPI service." -ForegroundColor Cyan
Invoke-SC @('stop', 'GoodbyeDPI')
Write-Host " "

Write-Host "Removing GoodbyeDPI service." -ForegroundColor Cyan
Invoke-SC @('delete', 'GoodbyeDPI')
Write-Host " "

Write-Host "Creating GoodbyeDPI service." -ForegroundColor Cyan
Invoke-SC @('create', 'GoodbyeDPI', "binPath= `"`"`"`"$DPIPath`"`"`" $DPIArgs`"", 'start= auto')
Invoke-SC @('description', 'GoodbyeDPI', "`"$SCDesc`"")
Write-Host " "

Write-Host "Starting GoodbyeDPI service." -ForegroundColor Cyan
Invoke-SC @('start', 'GoodbyeDPI')
Write-Host " "

Read-Host -Prompt "Press Enter to exit"
exit 0
