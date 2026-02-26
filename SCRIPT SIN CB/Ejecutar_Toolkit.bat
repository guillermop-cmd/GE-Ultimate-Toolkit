@echo off
TITLE SOPORTE TI - CFT SAN AGUSTIN
CLS
ECHO ========================================================
ECHO   INICIANDO TOOLKIT DE SOPORTE
ECHO   DEV: GUILLERMO ESCOBAR (G.E)
ECHO ========================================================
ECHO.
ECHO   [!] Solicitando permisos...

PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0GE_Support_Toolkit.ps1""' -Verb RunAs}"

EXIT