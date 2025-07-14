@echo off
title Install GoodbyeDPI Service (Blacklist)
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

pushd "%~dp0"

:: GoodbyeDPI hizmetini oluştur
sc stop "GoodbyeDPI"
sc delete "GoodbyeDPI"
sc create "GoodbyeDPI" binPath= "\"%~dp0%arch%\goodbyedpi.exe\" --blacklist \"%~dp0turkey-blacklist.txt\" --set-ttl 3" start= auto
sc description "GoodbyeDPI" "GoodbyeDPI, DPI tabanlı sansürü atlatmak için trafik paketlerini çekirdek seviyesinde yakalayıp değiştiren açık kaynaklı bir araçtır. WinDivert sürücüsü ile IP/TCP paketlerini sistemin işleyişine müdahale etmeden modifiye eder."
sc start "GoodbyeDPI"

pause
exit
