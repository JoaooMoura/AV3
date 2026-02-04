-- CreateEnum
CREATE TYPE "TipoAeronave" AS ENUM ('COMERCIAL', 'MILITAR');

-- CreateEnum
CREATE TYPE "StatusAeronave" AS ENUM ('EM_MANUTENCAO', 'EM_PRODUCAO', 'CONCLUIDA', 'CANCELADA');

-- CreateEnum
CREATE TYPE "TipoPeca" AS ENUM ('NACIONAL', 'IMPORTADA');

-- CreateEnum
CREATE TYPE "StatusEtapa" AS ENUM ('PENDENTE', 'ANDAMENTO', 'CONCLUIDA');

-- CreateEnum
CREATE TYPE "NivelPermissao" AS ENUM ('ADMINISTRADOR', 'ENGENHEIRO', 'OPERADOR');

-- CreateEnum
CREATE TYPE "TipoTeste" AS ENUM ('ELETRICO', 'HIDRAULICO', 'AERODINAMICO');

-- CreateEnum
CREATE TYPE "ResultadoTeste" AS ENUM ('APROVADO', 'REPROVADO');

-- CreateTable
CREATE TABLE "funcionarios" (
    "id" SERIAL NOT NULL,
    "nome" TEXT NOT NULL,
    "telefone" TEXT NOT NULL,
    "endereco" TEXT NOT NULL,
    "usuario" TEXT NOT NULL,
    "senha" TEXT NOT NULL,
    "nivelPermissao" "NivelPermissao" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "funcionarios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "aeronaves" (
    "id" SERIAL NOT NULL,
    "codigo" TEXT NOT NULL,
    "modelo" TEXT NOT NULL,
    "fabricante" TEXT NOT NULL,
    "tipo" "TipoAeronave" NOT NULL,
    "anoFabricacao" INTEGER NOT NULL,
    "capacidade" INTEGER NOT NULL,
    "kmAtual" INTEGER NOT NULL,
    "status" "StatusAeronave" NOT NULL,
    "alcance" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "aeronaves_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pecas" (
    "id" SERIAL NOT NULL,
    "nome" TEXT NOT NULL,
    "tipo" "TipoPeca" NOT NULL,
    "fornecedor" TEXT NOT NULL,
    "aeronaveId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "pecas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "etapas" (
    "id" SERIAL NOT NULL,
    "nome" TEXT NOT NULL,
    "prazo" TIMESTAMP(3) NOT NULL,
    "status" "StatusEtapa" NOT NULL DEFAULT 'PENDENTE',
    "aeronaveId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "etapas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "testes" (
    "id" SERIAL NOT NULL,
    "tipo" "TipoTeste" NOT NULL,
    "resultado" "ResultadoTeste" NOT NULL,
    "aeronaveId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "testes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "relatorios" (
    "id" SERIAL NOT NULL,
    "titulo" TEXT NOT NULL,
    "descricao" TEXT NOT NULL,
    "aeronaveId" INTEGER NOT NULL,
    "usuarioId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "relatorios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_EtapaToFuncionario" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "funcionarios_usuario_key" ON "funcionarios"("usuario");

-- CreateIndex
CREATE UNIQUE INDEX "aeronaves_codigo_key" ON "aeronaves"("codigo");

-- CreateIndex
CREATE UNIQUE INDEX "_EtapaToFuncionario_AB_unique" ON "_EtapaToFuncionario"("A", "B");

-- CreateIndex
CREATE INDEX "_EtapaToFuncionario_B_index" ON "_EtapaToFuncionario"("B");

-- AddForeignKey
ALTER TABLE "pecas" ADD CONSTRAINT "pecas_aeronaveId_fkey" FOREIGN KEY ("aeronaveId") REFERENCES "aeronaves"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "etapas" ADD CONSTRAINT "etapas_aeronaveId_fkey" FOREIGN KEY ("aeronaveId") REFERENCES "aeronaves"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "testes" ADD CONSTRAINT "testes_aeronaveId_fkey" FOREIGN KEY ("aeronaveId") REFERENCES "aeronaves"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "relatorios" ADD CONSTRAINT "relatorios_aeronaveId_fkey" FOREIGN KEY ("aeronaveId") REFERENCES "aeronaves"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_EtapaToFuncionario" ADD CONSTRAINT "_EtapaToFuncionario_A_fkey" FOREIGN KEY ("A") REFERENCES "etapas"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_EtapaToFuncionario" ADD CONSTRAINT "_EtapaToFuncionario_B_fkey" FOREIGN KEY ("B") REFERENCES "funcionarios"("id") ON DELETE CASCADE ON UPDATE CASCADE;
