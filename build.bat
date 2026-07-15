@echo off
setlocal

set PROJECT_DIR=%~dp0
set CUSTOMER_APP=%PROJECT_DIR%apps\customer_app
set ADMIN_APP=%PROJECT_DIR%apps\admin_app

echo ========================================
echo   Studio Leticia - Build Scripts
echo ========================================
echo.

if "%1"=="" goto :usage
if "%1"=="customer" goto :customer
if "%1"=="admin" goto :admin
if "%1"=="all" goto :all
if "%1"=="deps" goto :deps
if "%1"=="clean" goto :clean
goto :usage

:usage
echo Uso: build.bat [comando]
echo.
echo Comandos:
echo   customer    - Rodar customer_app
echo   admin       - Rodar admin_app
echo   all         - Instalar dependencias de todos
echo   deps        - Instalar dependencias
echo   clean       - Limpar caches
echo.
echo Exemplos:
echo   build.bat customer
echo   build.bat admin
echo   build.bat deps
exit /b 1

:deps
echo Instalando dependencias do customer_app...
cd /d "%CUSTOMER_APP%"
call flutter pub get
echo.
echo Instalando dependencias do admin_app...
cd /d "%ADMIN_APP%"
call flutter pub get
echo.
echo Dependencias instaladas!
cd /d "%PROJECT_DIR%"
exit /b 0

:customer
echo Rodando customer_app...
cd /d "%CUSTOMER_APP%"
call flutter run --dart-define-from-file=../../.env
cd /d "%PROJECT_DIR%"
exit /b 0

:admin
echo Rodando admin_app...
cd /d "%ADMIN_APP%"
call flutter run --dart-define-from-file=../../.env
cd /d "%PROJECT_DIR%"
exit /b 0

:all
call :deps
echo.
echo Todos os apps prontos!
exit /b 0

:clean
echo Limpando caches...
cd /d "%CUSTOMER_APP%"
call flutter clean
cd /d "%ADMIN_APP%"
call flutter clean
echo.
echo Caches limpos!
cd /d "%PROJECT_DIR%"
exit /b 0
