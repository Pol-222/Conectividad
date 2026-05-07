@echo off
title Diagnostico de Conectividad - %computername%
setlocal enabledelayedexpansion

:LOG_SETUP
set LOGFOLDER=%USERPROFILE%\Desktop\NetworkLogs
if not exist "%LOGFOLDER%" mkdir "%LOGFOLDER%"

:menu
cls
echo ================================
echo  DIAGNOSTICO DE CONECTIVIDAD
echo ================================
echo 1. Verificacion de Bucle Local (ping 127.0.0.1)
echo 2. Obtener IP de la placa (ipconfig)
echo 3. Prueba de Conectividad Estandar (ping a URL - 4 paquetes)
echo 4. Monitoreo Continuo (ping -t)
echo 5. Definir Cantidad de Paquetes (ping -n 10)
echo 6. Prueba de Carga (ping -l 1000)
echo 7. Resolucion de Nombres desde IP (ping -a)
echo s. Salir
echo.
set /p opt=Elija una opcion:

if "%opt%"=="1" goto loopback
if "%opt%"=="2" goto obtener_ip
if "%opt%"=="3" goto prueba_estandar
if "%opt%"=="4" goto ping_continuo
if "%opt%"=="5" goto ping_10
if "%opt%"=="6" goto ping_carga
if "%opt%"=="7" goto resolucion_inversa
if /i "%opt%"=="s" goto end
goto menu

:loopback
cls
echo Opcion 1: Verificacion de Bucle Local
echo Ejecutando: ping 127.0.0.1 -n 4
ping 127.0.0.1 -n 4 -w 1000
echo.
echo Observa: paquetes enviados/recibidos/perdidos y latencias.
pause
goto menu

:obtener_ip
cls
echo Opcion 2: Obtener IP de la placa (ipconfig)
echo Mostrando adaptadores y Direccion IPv4...
ipconfig
echo.
echo Extrayendo la primera Direccion IPv4 encontrada...
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /R /C:"IPv4 Address" /C:"Direcci.n IPv4"') do (
  set ipline=%%A
  goto :print_ip
)
:print_ip
if defined ipline (
  set ipline=%ipline: =%
  echo Direccion IPv4: %ipline%
) else (
  echo No se encontro Direccion IPv4.
)
pause
goto menu

:prueba_estandar
cls
echo Opcion 3: Prueba de Conectividad Estandar
set /p target=Ingrese URL o dominio (ej: www.inet.edu.ar):
if "%target%"=="" goto menu
echo Ejecutando: ping %target% -n 4
ping "%target%" -n 4 -w 1000
pause
goto menu

:ping_continuo
cls
echo Opcion 4: Monitoreo Continuo (ping -t)
set /p target=Ingrese URL o direccion IP para ping continuo (Ctrl+C para detener):
if "%target%"=="" goto menu
echo Iniciando ping continuo a %target% (presione Ctrl+C para detener)...
ping "%target%" -t
echo Ping continuo detenido.
pause
goto menu

:ping_10
cls
echo Opcion 5: Enviar exactamente 10 paquetes (ping -n 10)
set /p target=Ingrese URL o direccion IP:
if "%target%"=="" goto menu
echo Ejecutando: ping %target% -n 10
ping "%target%" -n 10 -w 1000
pause
goto menu

:ping_carga
cls
echo Opcion 6: Prueba de Carga (paquetes de 1000 bytes)
set /p target=Ingrese URL o direccion IP:
if "%target%"=="" goto menu
echo Ejecutando: ping %target% -n 4 -l 1000
ping "%target%" -n 4 -l 1000 -w 2000
echo Nota: algunos routers o destinos pueden bloquear paquetes grandes o ICMP.
pause
goto menu

:resolucion_inversa
cls
echo Opcion 7: Resolucion de Nombres desde IP (ping -a)
set /p ipaddr=Ingrese direccion IP (ej: 8.8.8.8):
if "%ipaddr%"=="" goto menu
echo Ejecutando: ping -a %ipaddr% -n 1
ping -a "%ipaddr%" -n 1 -w 1000
echo Si el nombre no aparece, puede que no exista un PTR (registro inverso) o el host no responda a ICMP.
pause
goto menu

:end
endlocal
exit /b
