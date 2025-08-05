# Request elevation if not running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    try {
        # Relaunch script as administrator
        Write-Host 'Requesting administrative privileges...' -ForegroundColor Cyan
        Start-Process -FilePath PowerShell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -ErrorAction Stop
        exit 0
    }
    catch {
        # Display an error message if elevation fails
        Write-Host "Administrator elevation failed: $($_.Exception.Message)" -ForegroundColor Red
        Read-Host -Prompt "Press Enter to exit"
        exit 1
    }
}

# Function to execute Windows service control commands
function Invoke-ServiceControl {
    param(
        [string[]]$SCArgs
    )

    try {
        # Execute sc.exe with the provided arguments
        Start-Process -FilePath 'sc.exe' -ArgumentList $SCArgs -NoNewWindow -Wait -ErrorAction Stop
    }
    catch {
        # Display an error message if the command fails
        Write-Host "Service command failed: $($_.Exception.Message)" -ForegroundColor Red
        Read-Host -Prompt "Press Enter to exit"
        exit 1
    }
}

# Set architecture and paths
$Arch = if ([Environment]::Is64BitOperatingSystem) { 'x86_64' } else { 'x86' }
$DPIPath = "$PSScriptRoot\$Arch\goodbyedpi.exe"
$DPIArgs = "--max-payload --set-ttl 3"
$BinPath = "`"`"`"$DPIPath`"`"`" $DPIArgs --blacklist `"`"`"$PSScriptRoot\turkey-blacklist.txt`"`"`""
$SCDesc = 'GoodbyeDPI intercepts and modifies DPI-based traffic at kernel level using WinDivert.'

# Ensure the executable exists
if (-not (Test-Path $DPIPath)) {
    # Display an error if the executable is missing
    Write-Host "GoodbyeDPI executable not found at: '$DPIPath'" -ForegroundColor Red
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

# Show current configuration
Write-Host " "
Write-Host "GoodbyeDPI Path: $DPIPath" -ForegroundColor Yellow
Write-Host "GoodbyeDPI Args: $DPIArgs" -ForegroundColor Yellow
Write-Host " "

Read-Host -Prompt "Press Enter to continue"

# Stop old service
Write-Host "Stopping GoodbyeDPI service." -ForegroundColor Cyan
Invoke-ServiceControl @('stop', 'GoodbyeDPI')
Write-Host " "

# Delete old service
Write-Host "Removing GoodbyeDPI service." -ForegroundColor Cyan
Invoke-ServiceControl @('delete', 'GoodbyeDPI')
Write-Host " "

# Create the new service and set its description
Write-Host "Creating GoodbyeDPI service." -ForegroundColor Cyan
Invoke-ServiceControl @('create', 'GoodbyeDPI', "binPath= `"$BinPath`"", 'start= auto')
Invoke-ServiceControl @('description', 'GoodbyeDPI', "`"$SCDesc`"")
Write-Host " "

# Start new service
Write-Host "Starting GoodbyeDPI service." -ForegroundColor Cyan
Invoke-ServiceControl @('start', 'GoodbyeDPI')
Write-Host " "

Read-Host -Prompt "Press Enter to exit"
exit 0
