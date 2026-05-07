# Conectividad

@echo off
title Diagnostico de Conectividad - %computername%
setlocal enabledelayedexpansion

:: Carpeta de logs en Escritorio
set LOGFOLDER=%USERPROFILE%\Desktop\NetworkLogs
if not exist "%LOGFOLDER%" mkdir "%LOGFOLDER%"

:menu
cls
echo ===========================
echo  DIAGNOSTICO DE CONECTIVIDAD
echo ===========================
echo 1. ipconfig /all (mostrar IPv4)
echo 2. Mostrar Direccion IPv4 de la placa (primer adaptador activo)
echo 3. ping 127.0.0.1 (localhost)
echo 4. ping google.com (4 paquetes)
echo 5. ping personalizado
echo 6. ping www.inet.edu.ar (4 paquetes)
echo 7. tracert personalizado
echo 8. nslookup dominio
echo 9. pathping dominio
echo a. Ejecutar pruebas 1,3,4,6 y guardar log
echo x. Salir
echo.
set /p opt=Elija una opcion:

if "%opt%"=="1" goto ipconfig
if "%opt%"=="2" goto show_ipv4
if "%opt%"=="3" goto ping_localhost
if "%opt%"=="4" goto ping_google
if "%opt%"=="5" goto ping_custom
if "%opt%"=="6" goto ping_inet
if "%opt%"=="7" goto tracert_custom
if "%opt%"=="8" goto nslookup_custom
if "%opt%"=="9" goto pathping_custom
if /i "%opt%"=="a" goto run_and_save
if /i "%opt%"=="x" goto end
goto menu

:ipconfig
cls
echo Ejecutando ipconfig /all...
ipconfig /all
pause
goto menu

:show_ipv4
cls
echo Buscando Direccion IPv4 del primer adaptador con IPv4...
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /R /C:"IPv4 Address" /C:"Direcci.n IPv4"') do (
  set ipline=%%A
  goto :printip
)
:printip
if defined ipline (
  set ipline=%ipline: =%
  echo Direccion IPv4 encontrada: %ipline%
) else (
  echo No se encontro una Direccion IPv4 en la salida de ipconfig.
)
pause
goto menu

:ping_localhost
cls
echo PING a 127.0.0.1 (localhost) - 4 paquetes...
ping 127.0.0.1 -n 4 -w 1000
pause
goto menu

:ping_google
cls
echo PING a google.com - 4 paquetes...
ping google.com -n 4 -w 1000
pause
goto menu

:ping_custom
set /p target=Ingrese direccion o dominio a pingear:
ping %target% -n 4 -w 1000
pause
goto menu

:ping_inet
cls
echo PING a www.inet.edu.ar - 4 paquetes...
ping www.inet.edu.ar -n 4 -w 1000
pause
goto menu

:tracert_custom
set /p target=Ingrese direccion o dominio para tracert:
tracert %target%
pause
goto menu

:nslookup_custom
set /p target=Ingrese dominio para nslookup:
nslookup %target%
pause
goto menu

:pathping_custom
set /p target=Ingrese dominio para pathping:
echo Pathping puede tardar varios minutos...
pathping %target%
pause
goto menu

:run_and_save
set timestamp=%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set logfile=%LOGFOLDER%\netdiag_%timestamp%.txt
echo Guardando resultados en %logfile%
(
echo ===== IPCONFIG =====
ipconfig /all
echo.
echo ===== IPV4 (primer adaptador) =====
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /R /C:"IPv4 Address" /C:"Direcci.n IPv4"') do (
  set ipline=%%A
  echo %%A
  goto :skipfor
)
:skipfor
echo.
echo ===== PING 127.0.0.1 =====
ping 127.0.0.1 -n 4 -w 1000
echo.
echo ===== PING google.com =====
ping google.com -n 4 -w 1000
echo.
echo ===== PING www.inet.edu.ar =====
ping www.inet.edu.ar -n 4 -w 1000
echo.
echo ===== TRACERT google.com (primeros saltos) =====
tracert -h 10 google.com
) > "%logfile%"
echo Listo. Archivo creado: %logfile%
pause
goto menu

:end
endlocal
exit /b
