@echo off
title Remove GoodbyeDPI Service
chcp 65001 >nul 2>&1

:: Yönetici yetkilerini kontrol et
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo GoodbyeDPI hizmetini silmek için yönetici yetkileri gereklidir.
    powershell -Command "Start-Process -FilePath '%~f0' -Verb runAs" || (
        echo Yönetici izni reddedildi veya bir hata oluştu.
        pause
        exit /b
    )
    exit /b
)

:: GoodbyeDPI hizmetini sil
sc stop "GoodbyeDPI"
sc delete "GoodbyeDPI"
sc stop "WinDivert"
sc delete "WinDivert"
sc stop "WinDivert14"
sc delete "WinDivert14"

pause
exit
