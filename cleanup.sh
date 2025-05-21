#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}=== Limpando recursos do DimDimApp ===${NC}"

echo -e "${RED}Parando e removendo containers...${NC}"
docker stop dimdim-app dimdim-db 2>/dev/null || true
docker rm dimdim-app dimdim-db 2>/dev/null || true

echo -e "${RED}Removendo imagem da aplicação...${NC}"
docker rmi dimdim-app:latest 2>/dev/null || true

echo -e "${RED}Removendo rede Docker 'dimdim-network'...${NC}"
docker network rm dimdim-network 2>/dev/null || true

echo -e "${YELLOW}=== Limpeza concluída! ===${NC}"
