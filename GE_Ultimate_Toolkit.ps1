$ErrorActionPreference = "SilentlyContinue"

# Deteccion de Modo Tecnico (Admin) vs Modo Usuario
$IsAdmin = "MODO USUARIO (Solo Diagnostico)"
$Identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$Principal = New-Object Security.Principal.WindowsPrincipal($Identity)
if ($Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $IsAdmin = "MODO TECNICO (Acceso Total)"
}

try {
    $Host.UI.RawUI.WindowTitle = "G.E. TOOLKIT | CFT SAN AGUSTIN"
    $Host.UI.RawUI.BackgroundColor = "Black"
    $Host.UI.RawUI.ForegroundColor = "Gray"
    Clear-Host
} catch { }

function Show-Header {
    Clear-Host
    Write-Host "`n"
    Write-Host "      GGGGGGGGG      EEEEEEEEEEEE " -ForegroundColor Cyan
    Write-Host "     GGG::::::::G    E:::::::::::E" -ForegroundColor Cyan
    Write-Host "    GG::::::::::G    E:::::::::::E" -ForegroundColor Cyan
    Write-Host "    G:::::GGGGGG     EE:::::EEEEEE" -ForegroundColor Cyan
    Write-Host "    G:::::G            E:::::E    " -ForegroundColor Cyan
    Write-Host "    G:::::G            E:::::E    " -ForegroundColor Cyan
    Write-Host "    G:::::G    GGGGGG  E::::::EEEE" -ForegroundColor Cyan
    Write-Host "    G:::::G    G::::G  E::::::::::E" -ForegroundColor Cyan
    Write-Host "    G:::::G    G::::G  E::::::::::E" -ForegroundColor Cyan
    Write-Host "    G:::::GGGGGG::::G  E::::::EEEE" -ForegroundColor Cyan
    Write-Host "     G:::::::::::::::G E:::::E    " -ForegroundColor Cyan
    Write-Host "      GG:::::::::::::G E:::::E    " -ForegroundColor Cyan
    Write-Host "        GGG::::::GGG   EEEEEEEEEEEE" -ForegroundColor Cyan
    Write-Host ""
    Write-Host " ===================================================================================" -ForegroundColor White
    Write-Host "         CFT SAN AGUSTIN - CYBER SECURITY OPERATIONS CENTER (CSOC)                  " -ForegroundColor White -BackgroundColor DarkRed
    Write-Host " ===================================================================================" -ForegroundColor White
    Write-Host "  OPERADOR  : Guillermo Escobar (G.E)" -ForegroundColor Yellow
    Write-Host "  PERFIL    : $IsAdmin" -ForegroundColor $(if($IsAdmin -match "TECNICO"){'Green'}else{'Yellow'})
    Write-Host "  EQUIPO    : $env:COMPUTERNAME | USUARIO: $env:USERNAME" -ForegroundColor Gray
    Write-Host " ===================================================================================" -ForegroundColor White
}

function Menu-Soporte {
    do {
        Show-Header
        Write-Host " --- PANEL DE SOPORTE IT AVANZADO ---" -ForegroundColor Green
        Write-Host " [1] Reparacion de Red (Flush, Reset)         [13] Desbloqueo Rapido de Cuenta AD" -ForegroundColor White
        Write-Host " [2] Consultar Usuario AD (Ficha)             [14] Test de Conectividad Completa" -ForegroundColor Cyan
        Write-Host " [3] Informacion de Hardware                  [15] Diagnostico de Servicios Criticos" -ForegroundColor Yellow
        Write-Host " [4] Monitor de Sistema (Top RAM)             [16] Limpieza de Cache DNS + Winsock" -ForegroundColor White
        Write-Host " [5] Reparacion de Impresion                  [17] Ver Membresia de Grupos AD" -ForegroundColor White
        Write-Host " [6] Optimizacion de Disco                    [18] Restablecer Contrasena AD (Forzado)" -ForegroundColor Red
        Write-Host " [7] Claves Wi-Fi Guardadas                   [19] Ver Estado de Equipo en AD" -ForegroundColor White
        Write-Host " [8] Reparacion de Sistema (SFC)              [20] Deteccion de Errores en Eventos" -ForegroundColor Cyan
        Write-Host " [9] Forzar GPUpdate                          [21] Uso de Licencias (Win/Office)" -ForegroundColor White
        Write-Host " [10] Reiniciar Explorador Windows            [22] Programar Reinicio Fuera de Horario" -ForegroundColor White
        Write-Host " [11] Uptime Checker y Reinicio               [23] GENERAR REPORTE TECNICO (TXT)" -ForegroundColor Green
        Write-Host " [12] Reparador de Windows Update" -ForegroundColor White
        Write-Host " -----------------------------------------------------------------------------------" -ForegroundColor Gray
        Write-Host " [B] Volver al Menu Principal" -ForegroundColor Gray
        
        $Sel = Read-Host "`n [Soporte]>"
        switch ($Sel) {
            "1" { ipconfig /release | Out-Null; ipconfig /renew | Out-Null; ipconfig /flushdns | Out-Null; netsh winsock reset | Out-Null; netsh int ip reset | Out-Null; Write-Host " [OK] Red operativa." -ForegroundColor Green; Pause }
            "2" {
                $InputUser = Read-Host " [?] Usuario (ID o Nombre)"
                $U = Get-ADUser -Filter "SamAccountName -eq '$InputUser' -or Name -like '*$InputUser*'" -Properties LockedOut, EmailAddress | Select-Object -First 1
                if ($U) {
                    Write-Host "`n FICHA: $($U.Name) | ID: $($U.SamAccountName) | Correo: $($U.EmailAddress)" -ForegroundColor Cyan
                    if ($U.LockedOut) { Write-Host " ESTADO: BLOQUEADA" -ForegroundColor Red } else { Write-Host " ESTADO: ACTIVA" -ForegroundColor Green }
                } else { Write-Host " [!] No encontrado." -ForegroundColor Red }
                Pause
            }
            "3" {
                $Target = Read-Host " [?] Nombre del equipo o IP (Enter para local)"
                if ($Target -eq "") { $Target = "localhost" }
                try {
                    $Bios = Get-WmiObject Win32_Bios -ComputerName $Target -ErrorAction Stop
                    $Comp = Get-WmiObject Win32_ComputerSystem -ComputerName $Target
                    $OS   = Get-WmiObject Win32_OperatingSystem -ComputerName $Target
                    Write-Host "`n REPORTE: $Target | Fab: $($Comp.Manufacturer) | Mod: $($Comp.Model) | S/N: $($Bios.SerialNumber)" -ForegroundColor Cyan
                    Write-Host " RAM: $([math]::Round($Comp.TotalPhysicalMemory/1GB,2)) GB | OS: $($OS.Caption) | User: $($Comp.UserName)" -ForegroundColor White
                } catch { Write-Host " [X] Error de conexion." -ForegroundColor Red }
                Pause
            }
            "4" { Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 10 Name, @{Name="RAM(MB)";Expression={[math]::round($_.WorkingSet64 / 1MB,2)}} | FT -AutoSize; Pause }
            "5" { Stop-Service Spooler -Force; Remove-Item "C:\Windows\System32\spool\PRINTERS\*.*" -Force -Recurse; Start-Service Spooler; Write-Host " [OK] Spooler reiniciado." -ForegroundColor Green; Pause }
            "6" { Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue; Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue; Write-Host " [OK] Limpio." -ForegroundColor Green; Pause }
            "7" { 
                (netsh wlan show profiles) | Select-String "\:(.+)$" | ForEach-Object {
                    $n = $_.Matches.Groups[1].Value.Trim()
                    $p = (netsh wlan show profile name="$n" key=clear | Select-String "Key Content\W+\:(.+)$").Matches.Groups[1].Value.Trim()
                    if($p){ Write-Host " -> $n | KEY: $p" -ForegroundColor Cyan }
                }
                Pause 
            }
            "8" { if($IsAdmin -match "TECNICO"){ Write-Host " Reparando..."; sfc /scannow; Dism /Online /Cleanup-Image /RestoreHealth } else { Write-Host " [X] Requiere Modo Tecnico" -ForegroundColor Red }; Pause }
            "9" { Write-Host " Forzando directivas..."; gpupdate /force; Pause }
            "10" { Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue; Write-Host " [OK] Explorador reiniciado." -ForegroundColor Green; Pause }
            "11" {
                $Target = Read-Host " [?] Equipo (Enter para local)"; if ($Target -eq "") { $Target = "localhost" }
                try {
                    $OS = Get-WmiObject Win32_OperatingSystem -ComputerName $Target -ErrorAction Stop
                    $LastBoot = $OS.ConvertToDateTime($OS.LastBootUpTime)
                    $Uptime = (Get-Date) - $LastBoot
                    Write-Host "`n Equipo: $Target | Activo: $($Uptime.Days) dias, $($Uptime.Hours) hrs, $($Uptime.Minutes) min" -ForegroundColor Yellow
                    $Confirm = Read-Host " Forzar reinicio? (S/N)"
                    if ($Confirm -match '^[sS]$') { Restart-Computer -ComputerName $Target -Force; Write-Host " [OK] Reiniciando." -ForegroundColor Green }
                } catch { Write-Host " [X] Error." -ForegroundColor Red }
                Pause
            }
            "12" {
                if($IsAdmin -match "TECNICO"){
                    Stop-Service wuauserv -Force; Stop-Service bits -Force
                    Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
                    Start-Service wuauserv; Start-Service bits
                    Write-Host " [OK] Windows Update reseteado." -ForegroundColor Green
                } else { Write-Host " [X] Requiere Modo Tecnico" -ForegroundColor Red }
                Pause
            }
            "13" {
                if($IsAdmin -match "TECNICO"){
                    $InputUser = Read-Host " [?] ID de Usuario"
                    try { Unlock-ADAccount -Identity $InputUser -ErrorAction Stop; Write-Host " [OK] Cuenta desbloqueada." -ForegroundColor Green } catch { Write-Host " [X] Error." -ForegroundColor Red }
                } else { Write-Host " [X] Requiere Modo Tecnico" -ForegroundColor Red }
                Pause
            }
            "14" {
                Write-Host "`n [*] TEST DE CONECTIVIDAD:" -ForegroundColor Yellow
                $gw = (Get-NetRoute -DestinationPrefix "0.0.0.0/0" -ErrorAction SilentlyContinue | Select-Object -First 1).NextHop
                Write-Host " -> Ping a Gateway ($gw): " -NoNewline; if(Test-Connection $gw -Count 1 -Quiet){ Write-Host "OK" -ForegroundColor Green } else { Write-Host "FALLO" -ForegroundColor Red }
                Write-Host " -> Ping a DNS Google (8.8.8.8): " -NoNewline; if(Test-Connection 8.8.8.8 -Count 1 -Quiet){ Write-Host "OK" -ForegroundColor Green } else { Write-Host "FALLO" -ForegroundColor Red }
                $dc = $env:LOGONSERVER -replace "\\\\",""
                Write-Host " -> Ping a AD Server ($dc): " -NoNewline; if(Test-Connection $dc -Count 1 -Quiet){ Write-Host "OK" -ForegroundColor Green } else { Write-Host "FALLO" -ForegroundColor Red }
                Pause
            }
            "15" {
                Write-Host "`n [*] SERVICIOS CRITICOS:" -ForegroundColor Yellow
                Get-Service Spooler, wuauserv, WinRM, Winmgmt | Select-Object Name, Status, DisplayName | Format-Table -AutoSize
                Pause
            }
            "16" {
                Write-Host " Limpiando DNS y Winsock..."; ipconfig /flushdns | Out-Null; netsh winsock reset | Out-Null
                Write-Host " [OK] Cache limpio. Se recomienda reiniciar." -ForegroundColor Green; Pause
            }
            "17" {
                $usr = Read-Host " [?] Usuario"
                try { Get-ADPrincipalGroupMembership $usr | Select-Object Name, GroupCategory | Format-Table -AutoSize } catch { Write-Host " [X] Error." -ForegroundColor Red }
                Pause
            }
            "18" {
                if($IsAdmin -match "TECNICO"){
                    $usr = Read-Host " [?] Usuario"
                    $pwd = Read-Host " [?] Nueva Clave" -AsSecureString
                    try {
                        Set-ADAccountPassword -Identity $usr -NewPassword $pwd -Reset:$true -ErrorAction Stop
                        Set-ADUser -Identity $usr -ChangePasswordAtLogon $true
                        Write-Host " [OK] Clave cambiada. Se pedira cambio al iniciar sesion." -ForegroundColor Green
                    } catch { Write-Host " [X] Error. Verifique politicas de longitud." -ForegroundColor Red }
                } else { Write-Host " [X] Requiere Modo Tecnico" -ForegroundColor Red }
                Pause
            }
            "19" {
                $comp = Read-Host " [?] Nombre de Equipo"
                try {
                    $c = Get-ADComputer $comp -Properties Enabled, LastLogonDate, OperatingSystem | Select-Object Name, Enabled, LastLogonDate, OperatingSystem
                    $c | Format-List
                } catch { Write-Host " [X] Equipo no encontrado en AD." -ForegroundColor Red }
                Pause
            }
            "20" {
                Write-Host "`n [*] ULTIMOS 10 ERRORES DEL SISTEMA:" -ForegroundColor Yellow
                Get-EventLog -LogName System -EntryType Error -Newest 10 -ErrorAction SilentlyContinue | Select-Object TimeGenerated, Source, Message | Format-Table -AutoSize -Wrap
                Pause
            }
            "21" {
                Write-Host "`n [*] ESTADO DE LICENCIA WINDOWS:" -ForegroundColor Yellow
                cscript.exe /nologo $env:windir\system32\slmgr.vbs /dli
                Pause
            }
            "22" {
                if($IsAdmin -match "TECNICO"){
                    $min = Read-Host " [?] Minutos para el reinicio"
                    $msg = Read-Host " [?] Mensaje para el usuario"
                    $sec = [int]$min * 60
                    shutdown.exe /r /t $sec /c "$msg"
                    Write-Host " [OK] Reinicio programado en $min minutos." -ForegroundColor Green
                } else { Write-Host " [X] Requiere Modo Tecnico" -ForegroundColor Red }
                Pause
            }
            "23" {
                Write-Host "`n [*] GENERANDO REPORTE..." -ForegroundColor Yellow
                $path = "$env:USERPROFILE\Desktop\Reporte_Tecnico_$env:COMPUTERNAME.txt"
                "=== REPORTE TECNICO G.E TOOLKIT ===" | Out-File $path
                "Fecha: $(Get-Date)" | Out-File $path -Append
                "Tecnico: $env:USERNAME" | Out-File $path -Append
                "Equipo: $env:COMPUTERNAME" | Out-File $path -Append
                "IP Local: $((Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias 'Wi-Fi','Ethernet' -ErrorAction SilentlyContinue | Select-Object -First 1).IPAddress)" | Out-File $path -Append
                "Sistema: $((Get-WmiObject Win32_OperatingSystem).Caption)" | Out-File $path -Append
                Write-Host " [OK] Reporte basico guardado en el Escritorio ($path)." -ForegroundColor Green
                Pause
            }
            "b" { return }
        }
    } while ($true)
}

function Menu-BlueTeam {
    if ($IsAdmin -notmatch "TECNICO") { Write-Host "`n [X] ACCESO DENEGADO: El Blue Team requiere Modo Tecnico (Admin)." -ForegroundColor Red; Start-Sleep 3; return }
    do {
        Show-Header
        Write-Host " --- PANEL BLUE TEAM (SEGURIDAD & AUDITORIA) ---" -ForegroundColor Cyan
        Write-Host " [1] Estado de Proteccion (Defender)          [4] Auditoria Basica de Seguridad (Bitlocker/UAC)" -ForegroundColor White
        Write-Host " [2] Conexiones TCP (Listening)               [5] Escaneo Rapido con Windows Defender" -ForegroundColor White
        Write-Host " [3] Administradores Locales                  [6] Auditoria de Software Instalado" -ForegroundColor White
        Write-Host " [B] Volver" -ForegroundColor Gray
        $Sel = Read-Host "`n [BlueTeam]>"
        switch ($Sel) {
            "1" { Get-MpComputerStatus | Select-Object AntivirusEnabled, RealTimeProtectionEnabled | Format-List; Pause }
            "2" { Get-NetTCPConnection -State Listen | Select-Object LocalPort, OwningProcess | Format-Table -AutoSize; Pause }
            "3" { Get-LocalGroupMember -Group "Administradores" | Select-Object Name, ObjectClass | Format-Table -AutoSize; Pause }
            "4" { 
                Write-Host "`n [*] AUDITORIA DE SEGURIDAD:" -ForegroundColor Yellow
                $UAC = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLUA -ErrorAction SilentlyContinue
                Write-Host " -> UAC Habilitado: $(if($UAC.EnableLUA -eq 1){'SI'}else{'NO'})" -ForegroundColor Cyan
                Write-Host " -> Estado Firewall Perfil Dominio: $((Get-NetFirewallProfile -Name Domain).Enabled)" -ForegroundColor Cyan
                Write-Host " -> Estado BitLocker Disco C:" -ForegroundColor Cyan
                manage-bde -status c: | Select-String "Conversion Status|Percentage|Protection Status"
                Pause
            }
            "5" { 
                Write-Host "`n [*] Iniciando Escaneo Rapido en Segundo Plano... Esto tomara unos minutos." -ForegroundColor Yellow
                Start-MpScan -ScanType QuickScan
                Write-Host " [OK] Escaneo completado o enviado a cola de Defender." -ForegroundColor Green
                Pause
            }
            "6" { 
                Write-Host "`n [*] LISTADO DE SOFTWARE INSTALADO:" -ForegroundColor Yellow
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* -ErrorAction SilentlyContinue | Select-Object DisplayName, DisplayVersion | Where-Object {$_.DisplayName -ne $null} | Sort-Object DisplayName | Format-Table -AutoSize
                Pause
            }
            "b" { return }
        }
    } while ($true)
}

function Menu-RedTeam {
    if ($IsAdmin -notmatch "TECNICO") { Write-Host "`n [X] ACCESO DENEGADO: El Red Team requiere Modo Tecnico (Admin)." -ForegroundColor Red; Start-Sleep 3; return }
    Clear-Host
    Write-Host "`n [!] INGRESE CLAVE MAESTRA" -ForegroundColor Red
    $P = Read-Host
    if ($P -ne "Binary24@") { Write-Host " [X] DENEGADO" -ForegroundColor Red; Start-Sleep 2; return }

    do {
        Show-Header
        Write-Host " --- PANEL RED TEAM ---" -ForegroundColor Red
        Write-Host " [1] Escaneo de Red Local (Ping Sweep)" -ForegroundColor White
        Write-Host " [2] Escaneo de Puertos (Port Scan)" -ForegroundColor White
        Write-Host " [3] Consultar IP Publica" -ForegroundColor White
        Write-Host " [B] Volver" -ForegroundColor Gray
        $Sel = Read-Host "`n [RedTeam]>"
        switch ($Sel) {
            "1" { $s = Read-Host "Segmento (Ej: 192.168.1)"; 1..254 | ForEach-Object { if(Test-Connection "$s.$_" -Count 1 -Quiet){ Write-Host "VIVO: $s.$_" -ForegroundColor Green } }; Pause }
            "2" { $t = Read-Host "IP"; $p = Read-Host "Puerto"; if(Test-NetConnection $t -Port $p -WarningAction SilentlyContinue | Select-Object -ExpandProperty TcpTestSucceeded){ Write-Host "OPEN" -ForegroundColor Green } else { Write-Host "CLOSED" -ForegroundColor Red }; Pause }
            "3" { try { (Invoke-RestMethod "http://ipinfo.io/json") | Format-List } catch { Write-Host "Sin internet." }; Pause }
            "b" { return }
        }
    } while ($true)
}

do {
    Show-Header
    Write-Host " [1] SOPORTE TECNICO IT (23 Herramientas)" -ForegroundColor Green
    Write-Host " [2] BLUE TEAM (Seguridad & Auditoria)" -ForegroundColor Cyan
    Write-Host " [3] RED TEAM (Ofensiva Estricta)" -ForegroundColor Red
    Write-Host " [Q] Salir" -ForegroundColor Gray
    
    $MainSel = Read-Host "`n [CyberOps]>"
    switch ($MainSel) {
        "1" { Menu-Soporte }
        "2" { Menu-BlueTeam }
        "3" { Menu-RedTeam }
        "q" { exit }
    }
} while ($true)