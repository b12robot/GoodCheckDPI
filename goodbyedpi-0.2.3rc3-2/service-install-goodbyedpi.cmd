@echo off
title Install GoodbyeDPI Service (Blacklist)

:: Check for administrator privileges
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo GoodbyeDPI requires administrator privileges because it uses a kernel-level driver ^(WinDivert^).
    powershell -Command "Start-Process -FilePath '%~f0' -Verb runAs" || (
        echo Administrator permission denied or an error occurred.
        pause
        exit /b
    )
    exit /b
)
pushd "%~dp0"

:: Check system architecture
if "%Processor_Architecture%" EQU "AMD64" (
    set "arch=x86_64"
) else (
    set "arch=x86"
)

:: Configuration Variables
set "GoodbyeDPIPath=%~dp0%arch%\goodbyedpi.exe"
set "Arguments=--max-payload --set-ttl 3"

:: Construct full binary path
set "FullBinPath="\"%GoodbyeDPIPath%\" %Arguments%""

:: Create GoodbyeDPI service
sc stop "GoodbyeDPI" >nul 2>&1
sc delete "GoodbyeDPI" >nul 2>&1
sc create "GoodbyeDPI" binPath= %FullBinPath% start= auto
sc description "GoodbyeDPI" "An open-source tool that intercepts and modifies traffic packets at the kernel level to bypass DPI-based censorship."
sc start "GoodbyeDPI"

pause
exit
