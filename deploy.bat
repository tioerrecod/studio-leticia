@echo off
setlocal

set PROJECT_DIR=%~dp0
set FUNCTIONS_DIR=%PROJECT_DIR%supabase\functions

echo ========================================
echo   Studio Leticia - Deploy Functions
echo ========================================
echo.

if "%1"=="" goto :usage
if "%1"=="all" goto :deploy_all
if "%1"=="create-appointment" goto :deploy_one create-appointment
if "%1"=="send-notification" goto :deploy_one send-notification
if "%1"=="appointment-reminder" goto :deploy_one appointment-reminder
goto :usage

usage
echo Uso: deploy.bat [funcao]
echo.
echo Funcoes:
echo   all                - Deploy todas as funcoes
echo   create-appointment - Deploy funcao de agendamento
echo   send-notification  - Deploy funcao de notificacao
echo   appointment-reminder - Deploy funcao de lembrete
echo.
echo Exemplo:
echo   deploy.bat all
echo   deploy.bat create-appointment
exit /b 1

:deploy_all
echo Deployando todas as funcoes...
echo.

echo [1/3] create-appointment...
cd /d "%FUNCTIONS_DIR%"
call supabase functions deploy create-appointment --no-verify-jwt
if %errorlevel% neq 0 (
    echo Erro ao deployar create-appointment
    exit /b 1
)
echo.

echo [2/3] send-notification...
call supabase functions deploy send-notification --no-verify-jwt
if %errorlevel% neq 0 (
    echo Erro ao deployar send-notification
    exit /b 1
)
echo.

echo [3/3] appointment-reminder...
call supabase functions deploy appointment-reminder --no-verify-jwt
if %errorlevel% neq 0 (
    echo Erro ao deployar appointment-reminder
    exit /b 1
)
echo.

echo Todas as funcoes deployadas com sucesso!
cd /d "%PROJECT_DIR%"
exit /b 0

:deploy_one
set FUNC_NAME=%1
echo Deployando %FUNC_NAME%...
cd /d "%FUNCTIONS_DIR%"
call supabase functions deploy %FUNC_NAME% --no-verify-jwt
if %errorlevel% neq 0 (
    echo Erro ao deployar %FUNC_NAME%
    exit /b 1
)
echo %FUNC_NAME% deployada com sucesso!
cd /d "%PROJECT_DIR%"
exit /b 0
