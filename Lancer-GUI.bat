@echo off
:: SecureMover GUI Launcher
:: Automatic admin elevation and PowerShell execution

title SecureMover GUI - Launcher

echo.
echo ================================================
echo   SecureMover GUI v2.0.2
echo   Interface Graphique Moderne
echo ================================================
echo.
echo Lancement de l'interface graphique...
echo.

:: Check for admin rights
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Privileges administrateur detectes
    goto :launch
) else (
    echo [!] Elevation administrateur requise...
    echo.
    goto :elevate
)

:elevate
:: Request admin elevation
powershell -Command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
exit

:launch
:: Launch GUI with PowerShell
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0SecureMover-GUI.ps1"

if %errorLevel% NEQ 0 (
    echo.
    echo [ERREUR] Echec du lancement de la GUI
    echo Code erreur: %errorLevel%
    echo.
    pause
)

exit
