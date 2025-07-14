@echo off
title Run GoodbyeDPI (Blacklist)
chcp 65001 >nul 2>&1

:: Yönetici yetkilerini kontrol et
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo GoodbyeDPI, çekirdek seviyesinde bir sürücü ^(WinDivert^) kullandığı için yönetici yetkileri gereklidir.
    powershell -Command "Start-Process -FilePath '%~f0' -Verb runAs" || (
        echo Yönetici izni reddedildi veya bir hata oluştu.
        pause
        exit /b
    )
    exit /b
)

:: Mimariyi kontrol et
if "%PROCESSOR_ARCHITECTURE%" EQU "AMD64" (
    set "arch=x86_64"
) else (
    set "arch=x86"
)

pushd "%~dp0%arch%"

:: GoodbyeDPI çalıştır
start "GoodbyeDPI" goodbyedpi.exe --blacklist "%~dp0turkey-blacklist.txt" --set-ttl 3

exit
