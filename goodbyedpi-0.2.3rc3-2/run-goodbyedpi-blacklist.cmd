@echo off
title Run GoodbyeDPI (Blacklist)

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
set "BlacklistPath=%~dp0turkey-blacklist.txt"
set "Arguments=--max-payload --set-ttl 3"

:: Run GoodbyeDPI
start "GoodbyeDPI" "%GoodbyeDPIPath%" --blacklist "%BlacklistPath%" %Arguments%
exit
