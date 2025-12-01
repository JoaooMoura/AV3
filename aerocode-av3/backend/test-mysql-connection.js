#!/usr/bin/env node

/**
 * Script de Teste de Conexão MySQL
 * 
 * Este script testa a conexão com o MySQL usando as configurações do .env
 * Execute: node test-mysql-connection.js
 */

const { PrismaClient } = require('@prisma/client');
require('dotenv').config();

const prisma = new PrismaClient();

async function testConnection() {
  console.log('\n🔍 Testando conexão com MySQL...\n');
  console.log('📋 Configurações:');
  
  // Parse DATABASE_URL para mostrar informações (sem senha)
  const dbUrl = process.env.DATABASE_URL || '';
  
  try {
    const url = new URL(dbUrl);
    const user = url.username;
    const host = url.hostname;
    const port = url.port;
    const database = url.pathname.substring(1); // Remove leading slash
    
    console.log(`   👤 Usuário: ${user}`);
    console.log(`   🏠 Host: ${host}`);
    console.log(`   🔌 Porta: ${port}`);
    console.log(`   💾 Banco: ${database}`);
    console.log(`   🔐 Senha: ****** (oculta)\n`);
  } catch (error) {
    console.error('❌ DATABASE_URL não está configurada corretamente!');
    console.log('   Verifique o arquivo .env\n');
    process.exit(1);
  }

  try {
    // Tentar conectar ao banco
    await prisma.$connect();
    console.log('✅ Conexão estabelecida com sucesso!\n');
    
    // Tentar executar uma query simples
    const result = await prisma.$queryRaw`SELECT 1 as test`;
    console.log('✅ Query de teste executada com sucesso!\n');
    
    // Verificar se as tabelas existem
    try {
      const funcionarios = await prisma.funcionario.count();
      console.log(`📊 Tabelas encontradas:`);
      console.log(`   👥 Funcionários: ${funcionarios} registros`);
      
      const aeronaves = await prisma.aeronave.count();
      console.log(`   ✈️  Aeronaves: ${aeronaves} registros\n`);
    } catch (error) {
      console.log('⚠️  Banco de dados existe, mas tabelas não foram criadas ainda.');
      console.log('   Execute: npx prisma migrate dev --name init\n');
    }
    
    console.log('🎉 Tudo funcionando perfeitamente!\n');
    
  } catch (error) {
    console.error('❌ Erro ao conectar ao MySQL:\n');
    console.error(`   ${error.message}\n`);
    
    // Diagnóstico do erro
    if (error.message.includes('Can\'t connect to MySQL server')) {
      console.log('💡 Possível solução:');
      console.log('   1. Verifique se o MySQL está rodando');
      console.log('   2. Para XAMPP: Abra o painel e inicie o MySQL');
      console.log('   3. Para Windows Service: Execute "net start MySQL80" como Admin');
      console.log('   4. Verifique se a porta 3306 está correta\n');
    } else if (error.message.includes('Access denied')) {
      console.log('💡 Possível solução:');
      console.log('   1. Verifique a senha no arquivo .env');
      console.log('   2. Para XAMPP sem senha, use: mysql://root:@localhost:3306/aerocode');
      console.log('   3. Para MySQL com senha, use: mysql://root:SUA_SENHA@localhost:3306/aerocode\n');
    } else if (error.message.includes('Unknown database')) {
      console.log('💡 Possível solução:');
      console.log('   1. Crie o banco de dados primeiro');
      console.log('   2. Execute no MySQL: CREATE DATABASE IF NOT EXISTS aerocode;\n');
    } else {
      console.log('💡 Para mais ajuda, consulte:');
      console.log('   📖 MYSQL_SETUP.md\n');
    }
    
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

testConnection();
