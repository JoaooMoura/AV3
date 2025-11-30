
# AV3 - Projeto Aerocode

Aplicação web full-stack desenvolvida para a avaliação AV3 da FATEC. O projeto unifica trabalhos anteriores com integração real de banco de dados usando Prisma ORM e MySQL, apresentando um **Dashboard Completo** para Gestão de Aeronaves e **Monitoramento de Performance**.

## 🚀 Guia Rápido (Quick Start)

### 1. Clonar o Repositório
```bash
git clone [https://github.com/JoaooMoura/AV3.git](https://github.com/JoaooMoura/AV3.git)
cd AV3/aerocode-av3
````

### 2\. Configurar o Banco de Dados (MySQL)

**Atenção:** Antes de rodar o código, você precisa preparar o seu banco de dados.

1.  **Inicie o MySQL:** Certifique-se de que o serviço do MySQL está rodando no seu computador (via XAMPP, Workbench, Docker ou Serviço do Windows).
2.  **Crie o Schema:** Abra seu gerenciador (ex: MySQL Workbench ou DBeaver), abra uma nova query e execute:
    ```sql
    CREATE DATABASE aerocode;
    USE aerocode;
    ```
3.  **Configure a Conexão:**
      * Vá até a pasta `backend/`.
      * Crie um arquivo chamado `.env` (você pode copiar o `.env.example`).
      * Edite a variável `DATABASE_URL` com seu usuário e senha do MySQL:
    <!-- end list -->
    ```env
    DATABASE_URL="mysql://root:SUA_SENHA@localhost:3306/aerocode"
    JWT_SECRET="segredo-av3-fatec"
    PORT=3000
    ```

### 3\. Iniciar o Backend (Porta 3000)

Abra um terminal, navegue até a pasta `backend/` e execute:

```bash
# Instalar dependências
npm install

# Criar as tabelas no banco de dados
npx prisma migrate dev --name init

# Popular o banco com usuários e dados de teste
npx prisma db seed

# Iniciar o servidor
npm run dev
```

### 4\. Iniciar o Frontend (Porta 5173)

Abra **outro terminal**, navegue até a pasta `frontend/` e execute:

```bash
# Instalar dependências
npm install

# Iniciar a interface
npm run dev
```

Acesse a aplicação no navegador em: **http://localhost:5173**

-----

## 👤 Credenciais de Acesso

Utilize estes usuários já cadastrados pelo sistema para testar os diferentes níveis de permissão:

| Função | Usuário | Senha | Permissões |
| :--- | :--- | :--- | :--- |
| **Administrador** | `admin` | `admin123` | Acesso Total (Criar, Editar, Excluir, Ver Métricas) |
| **Engenheiro** | `engenheiro` | `eng123` | Gerenciar Aeronaves e Etapas (Sem Excluir) |
| **Operador** | `operador` | `op123` | Visualizar Dados e Executar Tarefas |

-----

## 📁 Estrutura do Projeto

```text
aerocode-av3/
├── backend/           # API Node.js + TypeScript + Express
│   ├── src/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── middleware/ (Coleta de Métricas de Performance)
│   │   └── routes/
│   ├── prisma/        # Schema do Banco de Dados & Seeds
│   └── tests/         # Scripts de Teste de Carga
└── frontend/          # Interface React + JavaScript (.jsx) + Vite
    ├── src/
    │   ├── components/ (Modals, Gráficos, Inputs)
    │   ├── pages/      (Dashboard, Detalhes, Login)
    │   ├── services/   (Configuração Axios)
    │   └── styles/     (CSS Customizado - Dark Theme)
```

## 🌟 Funcionalidades Principais

  * **Gestão de Aeronaves:** CRUD completo para aeronaves, peças e etapas de manutenção.
  * **Relatórios em PDF:** Geração automática de relatórios técnicos detalhados com download direto (Blob).
  * **Monitoramento de Performance:** Middleware personalizado que mede Latência, Tempo de Processamento e Tempo de Resposta em tempo real.
  * **Testes de Carga:** Script automatizado (`tests/loadTest.js`) para simular acessos concorrentes (1, 5 e 10 usuários simultâneos).
  * **Dashboard Interativo:** Gráficos visuais utilizando a biblioteca `Recharts`.

-----

## 🔧 Comandos Úteis

### Backend (`/backend`)

  * `npm run dev`: Roda o servidor em modo de desenvolvimento com hot-reload.
  * `npx prisma studio`: Abre uma interface visual no navegador para inspecionar o banco de dados.
  * `node tests/loadTest.js`: Executa o teste de estresse/performance e gera o relatório HTML.

### Frontend (`/frontend`)

  * `npm run dev`: Roda a aplicação React.

-----

## 🔍 Tecnologias Utilizadas

  * **Frontend:** React 18, Vite, Axios, Recharts, CSS Modules.
  * **Backend:** Node.js, Express, TypeScript, Prisma ORM.
  * **Banco de Dados:** MySQL.
  * **Ferramentas:** PDFKit (Relatórios), BCrypt (Segurança), JWT (Autenticação).

-----

## 📞 Suporte

**Repositório:** JoaooMoura/AV3
**Autor:** João Vitor de Moura (Estudante FATEC)

```
```
