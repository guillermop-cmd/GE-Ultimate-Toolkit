<#
.SYNOPSIS
    G.E. SYSADMIN TOOLKIT - SUPPORT EDITION
    Herramienta estandarizada para el equipo de Soporte TI.
    CFT SAN AGUSTIN.

.DESCRIPTION
    Suite de reparacion y diagnostico rapido.
    Version segura para distribucion interna (Sin modulos ofensivos).

.AUTHOR
    Guillermo Escobar (G.E)
    Tecnico en CiberSeguridad
#>

# ==============================================================================
# [0] KERNEL: ELEVACION
# ==============================================================================
$Principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (!($Principal.IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))) {
    Write-Host "[!] Elevando permisos..." -ForegroundColor Yellow
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

$Host.UI.RawUI.WindowTitle = "G.E. SUPPORT TOOLKIT | CFT SAN AGUSTIN"
$ErrorActionPreference = "SilentlyContinue"

function Show-Header {
    Clear-Host
    # ASCII ART: G.E.
    Write-Host "  GGGGGGGGG      EEEEEEEEEEEE " -ForegroundColor Cyan
    Write-Host " GGG::::::::G    E:::::::::::E" -ForegroundColor Cyan
    Write-Host "GG::::::::::G    E:::::::::::E" -ForegroundColor Cyan
    Write-Host "G:::::GGGGGG     EE:::::EEEEEE" -ForegroundColor Cyan
    Write-Host "G:::::G            E:::::E    " -ForegroundColor Cyan
    Write-Host "G:::::G            E:::::E    " -ForegroundColor Cyan
    Write-Host "G:::::G    GGGGGG  E::::::EEEE" -ForegroundColor Cyan
    Write-Host "G:::::G    G::::G  E::::::::::E" -ForegroundColor Cyan
    Write-Host "G:::::G    G::::G  E::::::::::E" -ForegroundColor Cyan
    Write-Host "G:::::GGGGGG::::G  E::::::EEEE" -ForegroundColor Cyan
    Write-Host " G:::::::::::::::G E:::::E    " -ForegroundColor Cyan
    Write-Host "  GG:::::::::::::G E:::::E    " -ForegroundColor Cyan
    Write-Host "    GGG::::::GGG   EEEEEEEEEEEE" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor White
    Write-Host "      CFT SAN AGUSTIN - HERRAMIENTAS DE SOPORTE TI      " -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host "========================================================" -ForegroundColor White
    Write-Host " DEVELOPER : Guillermo Escobar" -ForegroundColor Yellow
    Write-Host " VERSION   : Support Edition (Stable)" -ForegroundColor Gray
    Write-Host " SYSTEM    : Optimizado para Windows 10/11" -ForegroundColor Gray
    Write-Host "========================================================" -ForegroundColor White
    Write-Host ""
}

# ==============================================================================
# [A] MODULOS DE SOPORTE (OPTIMIZADOS)
# ==============================================================================

function Modulo-Red {
    Write-Host "[*] REPARANDO PILA DE RED Y NAVEGADORES..." -ForegroundColor Yellow
    
    Get-Process chrome, msedge, firefox -ErrorAction SilentlyContinue | Stop-Process -Force
    
    $Reg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    Set-ItemProperty -Path $Reg -Name ProxyEnable -Value 0
    Set-ItemProperty -Path $Reg -Name ProxyServer -Value ""
    
    [void](cmd /c "netsh winhttp reset proxy")
    [void](cmd /c "netsh winsock reset")
    [void](cmd /c "netsh int ip reset")
    [void](cmd /c "ipconfig /flushdns")
    [void](cmd /c "certutil -urlcache * delete")
    
    Write-Host "    -> Actualizando politicas..." -ForegroundColor Gray
    [void](cmd /c "gpupdate /target:user /force")
    
    Write-Host "[OK] Conectividad Restaurada." -ForegroundColor Green
    Pause
}

function Modulo-ADUserCheck {
    Write-Host "[*] CONSULTA DE USUARIO (AD)..." -ForegroundColor Yellow
    try { Import-Module ActiveDirectory -ErrorAction Stop } catch { Write-Host "[X] Faltan herramientas RSAT."; Pause; return }

    $InputUser = Read-Host "[?] Usuario (Nombre o ID)"
    if ([string]::IsNullOrWhiteSpace($InputUser)) { return }

    try {
        $U = Get-ADUser -Filter "SamAccountName -eq '$InputUser' -or Name -like '*$InputUser*'" -Properties LockedOut, LastLogon, PasswordLastSet, Created, Title, Department, EmailAddress | Select -First 1
        
        if (!$U) { Write-Host "[!] Usuario no existe." -ForegroundColor Red; Pause; return }

        # FIX: Hora Real exacta
        if ($U.LastLogon -gt 0) {
            $RealLogon = [DateTime]::FromFileTime($U.LastLogon).ToString("dd/MM/yyyy HH:mm:ss")
        } else {
            $RealLogon = "Nunca"
        }

        # Calculo dias clave
        $PwdAge = "N/A"
        if ($U.PasswordLastSet) {
            $Days = ((Get-Date) - $U.PasswordLastSet).Days
            $PwdAge = "$Days dias"
        }

        Write-Host "`n FICHA DE USUARIO:" -ForegroundColor Cyan
        Write-Host " ----------------------------------------"
        Write-Host " Nombre       : $($U.Name)"
        Write-Host " ID (SAM)     : $($U.SamAccountName)"
        Write-Host " Cargo        : $($U.Title)"
        Write-Host " Area         : $($U.Department)"
        Write-Host " Correo       : $($U.EmailAddress)"
        Write-Host " ----------------------------------------"
        Write-Host " ESTADO:"
        if ($U.LockedOut) { Write-Host " BLOQUEO      : [SI] - CUENTA BLOQUEADA" -ForegroundColor Red -BackgroundColor Yellow }
        else { Write-Host " BLOQUEO      : [NO]" -ForegroundColor Green }
        Write-Host " Ultimo Login : $RealLogon" -ForegroundColor Yellow
        Write-Host " Antiguedad Pass: $PwdAge"
        Write-Host " ----------------------------------------"

    } catch {
        Write-Host "[X] Error AD: $_" -ForegroundColor Red
    }
    Pause
}

function Modulo-Wifi {
    Write-Host "[*] CLAVES WI-FI GUARDADAS..." -ForegroundColor Yellow
    $Profiles = netsh wlan show profiles | Select-String "All User Profile"
    if (!$Profiles) { Write-Host "[!] Sin perfiles." -ForegroundColor Red; Pause; return }

    foreach ($P in $Profiles) {
        $SSID = $P.ToString().Split(":")[1].Trim()
        $KeyLine = (netsh wlan show profile name="$SSID" key=clear | Select-String "Key Content")
        
        if ($KeyLine) {
            $Pass = $KeyLine.ToString().Split(":")[1].Trim()
            Write-Host " -> RED: $SSID | CLAVE: $Pass" -ForegroundColor Green
        }
    }
    Pause
}

function Modulo-Impresora {
    Write-Host "[*] REINICIANDO COLA DE IMPRESION..." -ForegroundColor Yellow
    Stop-Service Spooler -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\System32\spool\PRINTERS\*.*" -Force -ErrorAction SilentlyContinue
    Start-Service Spooler
    Write-Host "[OK] Servicio reiniciado." -ForegroundColor Green
    Pause
}

function Modulo-Optimizador {
    Write-Host "[*] LIMPIEZA DE SISTEMA..." -ForegroundColor Yellow
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Write-Host "[OK] Temporales eliminados." -ForegroundColor Green
    Pause
}

# ==============================================================================
# MENU PRINCIPAL
# ==============================================================================
do {
    Show-Header
    Write-Host " MENU DE ACCIONES:" -ForegroundColor White
    Write-Host " [1] Reparar Red (Proxy/SSL/DNS)" -ForegroundColor Cyan
    Write-Host " [2] Consultar Usuario AD (Ficha)" -ForegroundColor Cyan
    Write-Host " [3] Ver Claves Wi-Fi" -ForegroundColor Cyan
    Write-Host " [4] Reparar Cola Impresora" -ForegroundColor Cyan
    Write-Host " [5] Optimizador de Sistema" -ForegroundColor Cyan
    Write-Host " --------------------------" -ForegroundColor Gray
    Write-Host " [Q] Salir" -ForegroundColor Gray
    
    $Sel = Read-Host "`n [Soporte]>"
    
    switch ($Sel) {
        "1" { Modulo-Red }
        "2" { Modulo-ADUserCheck }
        "3" { Modulo-Wifi }
        "4" { Modulo-Impresora }
        "5" { Modulo-Optimizador }
        "Q" { Exit }
        "q" { Exit }
    }
} while ($true)