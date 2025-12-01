# 🔧 Guia de Configuração MySQL para VSCode

Este guia ajudará você a conectar o MySQL no VSCode e resolver problemas comuns de conexão.

## 📋 Pré-requisitos

Antes de começar, você precisa ter o MySQL instalado. Escolha uma das opções:

### Opção 1: XAMPP (Mais Fácil para Windows)
1. Baixe em: https://www.apachefriends.org/
2. Instale e inicie o módulo MySQL no painel de controle
3. A porta padrão é **3306**
4. Usuário padrão: **root** (sem senha)

### Opção 2: MySQL Workbench
1. Baixe em: https://dev.mysql.com/downloads/workbench/
2. Durante a instalação, configure uma senha para o usuário **root**
3. Anote a senha escolhida!

### Opção 3: Docker
```bash
docker run --name mysql-aerocode -e MYSQL_ROOT_PASSWORD=root -p 3306:3306 -d mysql:8
```

## 🚀 Configuração Passo a Passo

### 1. Verificar se o MySQL está rodando

#### Windows (XAMPP):
- Abra o painel XAMPP
- Certifique-se que o botão do MySQL está **verde** (running)

#### Windows (Serviço):
```cmd
# Abra o PowerShell ou CMD como Administrador
net start MySQL80
```

#### Linux/Mac:
```bash
sudo systemctl status mysql
# ou
brew services list | grep mysql
```

### 2. Criar o arquivo .env

1. Vá até a pasta `aerocode-av3/backend/`
2. Copie o arquivo `.env.example` para `.env`:
   ```bash
   cp .env.example .env
   ```
3. Edite o arquivo `.env` com suas credenciais:

#### Para XAMPP (sem senha):
```env
DATABASE_URL="mysql://root:@localhost:3306/aerocode"
```

#### Para MySQL com senha:
```env
DATABASE_URL="mysql://root:SUA_SENHA@localhost:3306/aerocode"
```

**Exemplo:** Se sua senha é `12345`, use:
```env
DATABASE_URL="mysql://root:12345@localhost:3306/aerocode"
```

### 3. Criar o banco de dados

Você precisa criar o banco antes de rodar as migrations. Use uma dessas opções:

#### Opção A: MySQL Workbench
1. Abra o MySQL Workbench
2. Conecte ao servidor local
3. Abra uma nova query (ícone ⚡)
4. Execute:
   ```sql
   CREATE DATABASE IF NOT EXISTS aerocode;
   ```

#### Opção B: Linha de comando
```bash
mysql -u root -p
# Digite a senha quando solicitado

# Dentro do MySQL:
CREATE DATABASE IF NOT EXISTS aerocode;
exit;
```

#### Opção C: phpMyAdmin (XAMPP)
1. Acesse: http://localhost/phpmyadmin
2. Clique em "Novo" no menu lateral
3. Digite `aerocode` como nome do banco
4. Clique em "Criar"

### 4. Rodar as migrations

Agora que o banco foi criado, execute:

```bash
cd aerocode-av3/backend
npm install
npx prisma migrate dev --name init
npx prisma db seed
```

### 5. Testar a conexão

Você pode testar a conexão de duas formas:

#### Opção A: Script de Teste Rápido
```bash
node test-mysql-connection.js
```

Este script verifica:
- ✅ Se as configurações do .env estão corretas
- ✅ Se o MySQL está acessível
- ✅ Se o banco de dados existe
- ✅ Se as tabelas foram criadas

#### Opção B: Prisma Studio
```bash
npx prisma studio
```

Se abrir uma interface web no navegador, a conexão está funcionando! ✅

## 🐛 Resolução de Problemas

### ❌ Erro: "Can't connect to MySQL server"

**Causa:** MySQL não está rodando ou porta errada

**Solução:**
1. Verifique se o MySQL está ativo (veja passo 1)
2. Confirme que a porta é 3306:
   ```bash
   # Windows
   netstat -an | findstr 3306
   
   # Linux/Mac
   sudo lsof -i :3306
   ```
3. Se a porta for diferente, ajuste no `.env`

### ❌ Erro: "Access denied for user 'root'@'localhost'"

**Causa:** Senha incorreta

**Solução:**
1. Verifique a senha no `.env`
2. Para resetar a senha do root (MySQL Workbench):
   ```sql
   ALTER USER 'root'@'localhost' IDENTIFIED BY 'nova_senha';
   FLUSH PRIVILEGES;
   ```

### ❌ Erro: "Unknown database 'aerocode'"

**Causa:** Banco de dados não foi criado

**Solução:**
Execute o comando CREATE DATABASE (veja passo 3)

### ❌ Erro: "Client does not support authentication protocol"

**Causa:** MySQL 8+ usa um novo método de autenticação

**Solução:**
```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'sua_senha';
FLUSH PRIVILEGES;
```

### ❌ Erro no Prisma: "Engine not found"

**Causa:** Prisma Client não foi gerado

**Solução:**
```bash
npx prisma generate
```

## 🔌 Extensões Úteis para VSCode

Instale essas extensões para facilitar o trabalho com MySQL:

1. **MySQL** (by Weijan Chen)
   - Permite conectar e gerenciar bancos direto no VSCode
   - Instalar: `Ctrl+Shift+X` → buscar "MySQL"

2. **Prisma** (by Prisma)
   - Syntax highlighting para arquivos `.prisma`
   - Autocomplete para o schema

### Configurar Extensão MySQL no VSCode

1. Pressione `Ctrl+Shift+P`
2. Digite: `MySQL: Add Connection`
3. Preencha:
   - **Host:** localhost
   - **Port:** 3306
   - **User:** root
   - **Password:** sua senha (ou deixe vazio se usar XAMPP)
   - **Database:** aerocode

## 📱 Teste Rápido de Conexão

Execute este script Node.js para testar:

```javascript
// test-connection.js
const mysql = require('mysql2/promise');

async function testConnection() {
  try {
    const connection = await mysql.createConnection({
      host: 'localhost',
      user: 'root',
      password: '', // Sua senha aqui
      database: 'aerocode'
    });
    
    console.log('✅ Conexão bem-sucedida!');
    await connection.end();
  } catch (error) {
    console.error('❌ Erro na conexão:', error.message);
  }
}

testConnection();
```

## 📚 Recursos Adicionais

- [Documentação Prisma](https://www.prisma.io/docs/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [XAMPP FAQ](https://www.apachefriends.org/faq_windows.html)

## 🆘 Ainda com problemas?

Se nenhuma solução funcionou:

1. Verifique os logs do MySQL:
   - XAMPP: `xampp/mysql/data/*.err`
   - Linux: `/var/log/mysql/error.log`

2. Tente reiniciar o serviço MySQL completamente

3. Abra uma issue no repositório com:
   - Sistema operacional
   - Versão do MySQL (`mysql --version`)
   - Mensagem de erro completa
   - Conteúdo do seu `.env` (SEM A SENHA!)
