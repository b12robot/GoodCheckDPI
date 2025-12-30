@echo off
title Remove GoodbyeDPI Service

:: Check for administrator privileges
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Administrator privileges are required to remove the GoodbyeDPI service.
    powershell -Command "Start-Process -FilePath '%~f0' -Verb runAs" || (
        echo Administrator permission denied or an error occurred.
        pause
        exit /b
    )
    exit /b
)
pushd "%~dp0"

:: Remove GoodbyeDPI service
sc stop "GoodbyeDPI"
sc delete "GoodbyeDPI"
sc stop "WinDivert"
sc delete "WinDivert"
sc stop "WinDivert14"
sc delete "WinDivert14"

pause
exit
