#!/bin/bash

# Script para testar o CRUD da API DimDimApp
# Este script utiliza curl para testar todas as operações CRUD

# Cores para melhor visualização
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

API_URL="http://localhost:8000"

echo -e "${YELLOW}=== Testando API DimDimApp ===${NC}"

# Testar endpoint raiz
echo -e "${BLUE}Testando endpoint raiz...${NC}"
curl -s $API_URL | jq

# Criar um novo cliente
echo -e "\n${BLUE}Criando novo cliente...${NC}"
CREATE_RESPONSE=$(curl -s -X POST \
  "$API_URL/clientes/" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Maria Silva",
    "email": "maria.silva@email.com",
    "telefone": "(11) 98765-4321",
    "saldo": 1000.0
  }')

echo $CREATE_RESPONSE | jq

# Extrair o ID do cliente criado
CLIENT_ID=$(echo $CREATE_RESPONSE | jq -r '.id')

# Listar todos os clientes
echo -e "\n${BLUE}Listando todos os clientes...${NC}"
curl -s "$API_URL/clientes/" | jq

# Obter cliente específico
echo -e "\n${BLUE}Obtendo cliente específico (ID: $CLIENT_ID)...${NC}"
curl -s "$API_URL/clientes/$CLIENT_ID" | jq

# Atualizar cliente
echo -e "\n${BLUE}Atualizando cliente (ID: $CLIENT_ID)...${NC}"
curl -s -X PUT \
  "$API_URL/clientes/$CLIENT_ID" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Maria Silva Atualizado",
    "saldo": 2000.0
  }' | jq

# Verificar cliente atualizado
echo -e "\n${BLUE}Verificando cliente atualizado (ID: $CLIENT_ID)...${NC}"
curl -s "$API_URL/clientes/$CLIENT_ID" | jq

# Deletar cliente
echo -e "\n${BLUE}Deletando cliente (ID: $CLIENT_ID)...${NC}"
curl -s -X DELETE "$API_URL/clientes/$CLIENT_ID" -v

# Verificar se o cliente foi deletado
echo -e "\n${BLUE}Verificando se o cliente foi deletado (ID: $CLIENT_ID)...${NC}"
curl -s "$API_URL/clientes/$CLIENT_ID" | jq

echo -e "\n${YELLOW}=== Testes concluídos! ===${NC}"
