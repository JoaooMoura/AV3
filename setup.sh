#!/bin/bash

# Script de Configuração Rápida - AV3 Aerocode
# Este script ajuda na configuração inicial do projeto

echo "🚀 Bem-vindo ao Setup do AV3 - Aerocode!"
echo ""

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Verificar se estamos no diretório correto
if [ ! -d "aerocode-av3" ]; then
    echo -e "${RED}❌ Erro: Execute este script na raiz do repositório AV3${NC}"
    exit 1
fi

echo "📋 Verificando pré-requisitos..."
echo ""

# Verificar Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    echo -e "${GREEN}✅ Node.js instalado:${NC} $NODE_VERSION"
else
    echo -e "${RED}❌ Node.js não encontrado!${NC}"
    echo "   Instale em: https://nodejs.org/"
    exit 1
fi

# Verificar npm
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm -v)
    echo -e "${GREEN}✅ npm instalado:${NC} $NPM_VERSION"
else
    echo -e "${RED}❌ npm não encontrado!${NC}"
    exit 1
fi

# Verificar MySQL
echo ""
echo "🔍 Verificando MySQL..."
if command -v mysql &> /dev/null; then
    MYSQL_VERSION=$(mysql --version)
    echo -e "${GREEN}✅ MySQL instalado:${NC} $MYSQL_VERSION"
else
    echo -e "${YELLOW}⚠️  MySQL não encontrado no PATH${NC}"
    echo "   Se você usa XAMPP ou Workbench, pode estar instalado."
fi

echo ""
echo "================================================"
echo "📁 Configurando Backend..."
echo "================================================"
cd aerocode-av3/backend

# Criar .env se não existir
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        echo -e "${YELLOW}📝 Criando arquivo .env...${NC}"
        cp .env.example .env
        echo -e "${GREEN}✅ Arquivo .env criado!${NC}"
        echo -e "${YELLOW}⚠️  Importante: Edite o arquivo .env com suas credenciais MySQL${NC}"
    else
        echo -e "${RED}❌ Arquivo .env.example não encontrado!${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✅ Arquivo .env já existe${NC}"
fi

# Instalar dependências
echo ""
echo "📦 Instalando dependências do backend..."
npm install

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Dependências do backend instaladas!${NC}"
else
    echo -e "${RED}❌ Erro ao instalar dependências do backend${NC}"
    cd ../..
    exit 1
fi

echo ""
echo "================================================"
echo "📁 Configurando Frontend..."
echo "================================================"
cd ../frontend

# Criar .env se não existir
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        echo -e "${YELLOW}📝 Criando arquivo .env...${NC}"
        cp .env.example .env
        echo -e "${GREEN}✅ Arquivo .env criado!${NC}"
    else
        echo -e "${RED}❌ Arquivo .env.example não encontrado!${NC}"
    fi
else
    echo -e "${GREEN}✅ Arquivo .env já existe${NC}"
fi

# Instalar dependências
echo ""
echo "📦 Instalando dependências do frontend..."
npm install

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Dependências do frontend instaladas!${NC}"
else
    echo -e "${RED}❌ Erro ao instalar dependências do frontend${NC}"
    cd ../..
    exit 1
fi

# Voltar para o diretório backend
cd ../backend

echo ""
echo "================================================"
echo "✅ Configuração básica concluída!"
echo "================================================"
echo ""
echo "📝 Próximos passos:"
echo ""
echo "1. Configure o MySQL:"
echo "   - Certifique-se que o MySQL está rodando"
echo "   - Crie o banco: CREATE DATABASE IF NOT EXISTS aerocode;"
echo "   - Edite backend/.env com suas credenciais"
echo ""
echo "2. Configure o banco de dados:"
echo "   cd aerocode-av3/backend"
echo "   npx prisma migrate dev --name init"
echo "   npx prisma db seed"
echo ""
echo "3. Inicie o backend:"
echo "   npm run dev"
echo ""
echo "4. Em outro terminal, inicie o frontend:"
echo "   cd aerocode-av3/frontend"
echo "   npm run dev"
echo ""
echo "📖 Problemas com MySQL? Consulte: backend/MYSQL_SETUP.md"
echo ""
