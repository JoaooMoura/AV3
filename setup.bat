@echo off
REM Script de Configuração Rápida - AV3 Aerocode (Windows)
REM Este script ajuda na configuração inicial do projeto

echo.
echo ========================================
echo   Bem-vindo ao Setup do AV3 - Aerocode!
echo ========================================
echo.

REM Verificar se estamos no diretório correto
if not exist "aerocode-av3" (
    echo [ERRO] Execute este script na raiz do repositorio AV3
    pause
    exit /b 1
)

echo Verificando pre-requisitos...
echo.

REM Verificar Node.js
where node >nul 2>nul
if %errorlevel% equ 0 (
    echo [OK] Node.js instalado
    node -v
) else (
    echo [ERRO] Node.js nao encontrado!
    echo        Instale em: https://nodejs.org/
    pause
    exit /b 1
)

REM Verificar npm
where npm >nul 2>nul
if %errorlevel% equ 0 (
    echo [OK] npm instalado
    npm -v
) else (
    echo [ERRO] npm nao encontrado!
    pause
    exit /b 1
)

echo.
echo ========================================
echo Configurando Backend...
echo ========================================
cd aerocode-av3\backend

REM Criar .env se não existir
if not exist ".env" (
    if exist ".env.example" (
        echo Criando arquivo .env...
        copy .env.example .env >nul
        echo [OK] Arquivo .env criado!
        echo [IMPORTANTE] Edite o arquivo .env com suas credenciais MySQL
    ) else (
        echo [ERRO] Arquivo .env.example nao encontrado!
        pause
        exit /b 1
    )
) else (
    echo [OK] Arquivo .env ja existe
)

REM Instalar dependências
echo.
echo Instalando dependencias do backend...
call npm install
if %errorlevel% neq 0 (
    echo [ERRO] Falha ao instalar dependencias do backend
    pause
    exit /b 1
)
echo [OK] Dependencias do backend instaladas!

echo.
echo ========================================
echo Configurando Frontend...
echo ========================================
cd ..\frontend

REM Criar .env se não existir
if not exist ".env" (
    if exist ".env.example" (
        echo Criando arquivo .env...
        copy .env.example .env >nul
        echo [OK] Arquivo .env criado!
    ) else (
        echo [AVISO] Arquivo .env.example nao encontrado
    )
) else (
    echo [OK] Arquivo .env ja existe
)

REM Instalar dependências
echo.
echo Instalando dependencias do frontend...
call npm install
if %errorlevel% neq 0 (
    echo [ERRO] Falha ao instalar dependencias do frontend
    pause
    exit /b 1
)
echo [OK] Dependencias do frontend instaladas!

echo.
echo ========================================
echo   Configuracao basica concluida!
echo ========================================
echo.
echo Proximos passos:
echo.
echo 1. Configure o MySQL:
echo    - Certifique-se que o MySQL esta rodando (XAMPP ou servico)
echo    - Crie o banco: CREATE DATABASE IF NOT EXISTS aerocode;
echo    - Edite backend\.env com suas credenciais
echo.
echo 2. Configure o banco de dados:
echo    cd aerocode-av3\backend
echo    npx prisma migrate dev --name init
echo    npx prisma db seed
echo.
echo 3. Inicie o backend:
echo    npm run dev
echo.
echo 4. Em outro terminal, inicie o frontend:
echo    cd aerocode-av3\frontend
echo    npm run dev
echo.
echo Problemas com MySQL? Consulte: backend\MYSQL_SETUP.md
echo.
pause
