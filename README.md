# 🛠️ GE Toolkit - IT Support Master Edition (v18.0)

![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)
![IT Support](https://img.shields.io/badge/IT_Support-HelpDesk_L2-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Author](https://img.shields.io/badge/Author-Guillermo_Escobar-darkgrey.svg)

**GE Toolkit** es una herramienta de administración, diagnóstico y soporte técnico desarrollada íntegramente en PowerShell. Diseñada para agilizar los flujos de trabajo operativos en entornos corporativos e institucionales (como el CFT San Agustín), esta "navaja suiza" consolida **23 herramientas críticas de Help Desk y SysAdmin** en una sola interfaz de terminal ágil, estable y a prueba de fallos.

## 🚀 Características Principales

El script cuenta con un **Sistema de Perfiles de Ejecución Automático** que detecta los privilegios del operador al iniciar el programa:

* 🟡 **Modo Usuario (Diagnóstico):** Permite ejecutar diagnósticos básicos, lectura de información del sistema y auditorías sin riesgo de alterar configuraciones críticas. Ideal para operarios de Nivel 1.
* 🟢 **Modo Técnico (Admin):** Desbloquea herramientas de gestión avanzada, reparaciones profundas del sistema operativo y modificaciones directas en el Active Directory.

---

## 🛠️ Herramientas Integradas (23 Funciones)

El menú principal está categorizado estratégicamente para resolver más del 90% de los tickets diarios de soporte IT de manera automatizada:

### 🔐 Active Directory & Cuentas
* **Fichas de Usuario:** Consulta rápida de ID, correo electrónico y estado actual de la cuenta.
* **Membresías:** Verificación de pertenencia a grupos de AD del usuario (Domain Users, VPN, etc.).
* **Gestión Rápida:** Desbloqueo inmediato de cuentas bloqueadas por intentos fallidos.
* **Seguridad:** Restablecimiento forzado de contraseñas con obligación de cambio al iniciar sesión.
* **Auditoría de Equipos:** Consulta de último logon y estado de la máquina en la red del AD.

### 🌐 Redes & Conectividad
* Reparación integral de pila de red (Flush DNS, WinSock Reset, IP Renew).
* Test de conectividad a Gateways, DNS públicos (8.8.8.8) y Servidor AD local.
* Extracción en texto plano de claves Wi-Fi guardadas históricamente en el equipo.

### 💻 Sistema & Hardware
* **Inventario WMI:** Consulta remota o local de Fabricante, Modelo, Número de Serie (S/N), Procesador, RAM y almacenamiento del Disco C:.
* **Monitor de RAM:** Top 10 de procesos que más memoria están consumiendo en tiempo real.
* **Uptime Checker:** Verificación del tiempo activo real del equipo y ejecución de reinicio remoto forzado.
* **Diagnóstico Crítico:** Verificación del estado de servicios clave (Spooler, WinRM, WMI, Windows Update).
* **Licencias:** Verificación del estado de activación de licencias de Windows.
* **Visor de Eventos Forense:** Detección y filtrado de los últimos 10 errores críticos del sistema.

### 🔧 Reparación & Mantenimiento
* Optimización de disco (limpieza profunda de archivos temporales del sistema y usuario).
* Reparador automático de cola de impresión (Spooler Clean).
* Reparación profunda de Windows Update (vaciado y reconstrucción de *SoftwareDistribution*).
* Reparación de imagen nativa de sistema (SFC / DISM).
* Reinicio automático del proceso `explorer.exe` (Taskbar Fix).
* Ejecución forzada de políticas de dominio (`gpupdate /force`).

### 📄 Gestión y Documentación
* Programación de reinicios fuera de horario con cuenta regresiva personalizable y mensaje al usuario.
* **Generación de Reporte Técnico Automático:** Exportación a archivo `.txt` de evidencias de soporte (Usuario logueado, Nombre del Equipo, IP Local, Detalles del Sistema Operativo).

---
