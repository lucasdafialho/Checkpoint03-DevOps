#!/bin/bash

# Script para criar e executar os containers Docker para o DimDimApp

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}=== Iniciando setup do DimDimApp ===${NC}"

echo -e "${GREEN}Criando rede Docker 'dimdim-network'...${NC}"
docker network create dimdim-network

echo -e "${GREEN}Iniciando container do PostgreSQL...${NC}"
docker run -d \
  --name dimdim-db \
  --network dimdim-network \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=dimdimapp \
  -v dimdim-db-data:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:13

echo -e "${GREEN}Construindo imagem da aplicação...${NC}"
docker build -t dimdim-app:latest .

echo -e "${GREEN}Iniciando container da aplicação...${NC}"
docker run -d \
  --name dimdim-app \
  --network dimdim-network \
  -e DATABASE_URL=postgresql://postgres:postgres@dimdim-db:5432/dimdimapp \
  -e PORT=8000 \
  -p 8000:8000 \
  dimdim-app:latest

echo -e "${YELLOW}=== Setup concluído! ===${NC}"
echo -e "API disponível em: http://localhost:8000"
echo -e "Para verificar os logs da aplicação: docker logs dimdim-app"
echo -e "Para verificar os logs do banco: docker logs dimdim-db"
