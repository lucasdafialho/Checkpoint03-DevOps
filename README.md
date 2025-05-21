# DimDimApp - Gerenciamento de Clientes

Este projeto implementa uma solução conteinerizada para a instituição financeira DimDim, utilizando Docker para criar um ambiente isolado com dois containers: um para o banco de dados PostgreSQL e outro para uma API RESTful desenvolvida em Python com FastAPI.

## Equipe
- Lucas de Assis Fialho - RM557884
- Alice Teixeira Caldeira - RM556293
- Sofia Petruk - RM556585

## Tecnologias Utilizadas

- **Banco de Dados**: PostgreSQL 13
- **Linguagem de Programação**: Python 3.9
- **Framework API**: FastAPI
- **ORM**: SQLAlchemy
- **Containerização**: Docker
- **Versionamento**: Git/GitHub

## Estrutura do Projeto

```
dimdimapp/
├── app/
│   ├── __init__.py
│   ├── database.py    # Configuração do banco e modelos
│   ├── main.py        # Endpoints da API
│   └── schemas.py     # Schemas de validação
├── .env               # Variáveis de ambiente
├── Dockerfile         # Configuração do container da aplicação
├── main.py            # Arquivo principal para iniciar a aplicação
├── requirements.txt   # Dependências do projeto
├── run.sh             # Script para executar os containers
├── cleanup.sh         # Script para limpar recursos Docker
└── test_api.sh        # Script para testar a API
```

## Requisitos Técnicos Implementados

1. **Dois containers**:
   - Container de banco de dados PostgreSQL com volume para persistência
   - Container de aplicação FastAPI com CRUD completo

2. **Rede Docker**:
   - Ambos containers executam na mesma rede Docker criada (`dimdim-network`)

3. **Container da aplicação**:
   - Executa com usuário não-root (`appuser`)
   - Define diretório de trabalho (`/app`)
   - Utiliza variáveis de ambiente
   - Possui Dockerfile personalizado

4. **Container do Banco**:
   - Utiliza imagem pública do PostgreSQL
   - Dados persistidos em volume Docker

5. **Execução em background**:
   - Ambos containers executam em modo detached

6. **Acesso aos containers**:
   - Comandos para acessar e verificar estrutura de diretórios e usuário

## Instruções de Execução

### Pré-requisitos

- Docker instalado
- Git instalado

### Passo a Passo

1. **Clone o repositório**:
   ```bash
   git clone https://github.com/seu-usuario/dimdimapp.git
   cd dimdimapp
   ```

2. **Execute o script de inicialização**:
   ```bash
   ./run.sh
   ```
   Este script irá:
   - Criar a rede Docker `dimdim-network`
   - Iniciar o container do PostgreSQL com volume
   - Construir a imagem da aplicação
   - Iniciar o container da aplicação

3. **Teste a API**:
   ```bash
   ./test_api.sh
   ```
   Este script testa todas as operações CRUD da API.

4. **Acesse a API**:
   - Documentação Swagger: http://localhost:8000/docs
   - Endpoint raiz: http://localhost:8000/

5. **Para limpar os recursos**:
   ```bash
   ./cleanup.sh
   ```

## Comandos Docker Utilizados

### Rede Docker
```bash
docker network create dimdim-network

docker network ls
```

### Container do Banco de Dados
```bash
docker run -d \
  --name dimdim-db \
  --network dimdim-network \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=dimdimapp \
  -v dimdim-db-data:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:13

docker exec -it dimdim-db bash

docker exec -it dimdim-db whoami

docker exec -it dimdim-db ls -la
docker exec -it dimdim-db pwd
```

### Container da Aplicação
```bash
docker build -t dimdim-app:latest .

docker run -d \
  --name dimdim-app \
  --network dimdim-network \
  -e DATABASE_URL=postgresql://postgres:postgres@dimdim-db:5432/dimdimapp \
  -e PORT=8000 \
  -p 8000:8000 \
  dimdim-app:latest

docker exec -it dimdim-app bash

docker exec -it dimdim-app whoami

docker exec -it dimdim-app ls -la
docker exec -it dimdim-app pwd
```

### Verificação de Logs
```bash
docker logs dimdim-app

docker logs dimdim-db
```

## Evidências de Funcionamento

### Verificação de Containers em Execução
```bash
```

### Verificação de Volume
```bash
docker volume ls
```

### Verificação de Rede
```bash
docker network inspect dimdim-network
```

### Verificação de Usuário e Diretório
```bash
docker exec -it dimdim-app whoami

docker exec -it dimdim-app pwd
```

### Teste de Persistência
1. Crie dados via API
2. Reinicie o container do banco
   ```bash
   docker restart dimdim-db
   ```
3. Verifique se os dados ainda estão disponíveis via API

## Troubleshooting

### Problemas de Conexão com o Banco
- Verifique se ambos os containers estão na mesma rede:
  ```bash
  docker network inspect dimdim-network
  ```
- Verifique se o banco está aceitando conexões:
  ```bash
  docker exec -it dimdim-db pg_isready
  ```

### Problemas com a API
- Verifique os logs da aplicação:
  ```bash
  docker logs dimdim-app
  ```
- Verifique se as variáveis de ambiente estão corretas:
  ```bash
  docker exec -it dimdim-app env | grep DATABASE
  ```

## Conclusão

Este projeto implementa uma solução completa utilizando Docker, seguindo as melhores práticas de isolamento, automação e persistência de dados. A aplicação permite o gerenciamento completo de clientes da instituição financeira DimDim, com operações CRUD funcionais e dados persistidos em um banco PostgreSQL.
