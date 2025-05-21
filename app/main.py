from fastapi import FastAPI, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
import os

from .database import get_db, Cliente as ClienteModel, Base, engine
from .schemas import Cliente, ClienteCreate, ClienteUpdate

# Cria as tabelas no banco de dados
Base.metadata.create_all(bind=engine)

# Cria a aplicação FastAPI
app = FastAPI(
    title="DimDimApp API",
    description="API para gerenciamento de clientes da instituição financeira DimDim",
    version="1.0.0"
)

# Rota raiz
@app.get("/", tags=["Root"])
async def root():
    return {"message": "Bem-vindo à API DimDimApp - Gerenciamento de Clientes"}

# Criar um novo cliente
@app.post("/clientes/", response_model=Cliente, status_code=status.HTTP_201_CREATED, tags=["Clientes"])
def create_cliente(cliente: ClienteCreate, db: Session = Depends(get_db)):
    # Verifica se o email já existe
    db_cliente = db.query(ClienteModel).filter(ClienteModel.email == cliente.email).first()
    if db_cliente:
        raise HTTPException(status_code=400, detail="Email já cadastrado")
    
    # Cria o novo cliente
    db_cliente = ClienteModel(**cliente.dict())
    db.add(db_cliente)
    db.commit()
    db.refresh(db_cliente)
    return db_cliente

# Listar todos os clientes
@app.get("/clientes/", response_model=List[Cliente], tags=["Clientes"])
def read_clientes(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    clientes = db.query(ClienteModel).offset(skip).limit(limit).all()
    return clientes

# Obter um cliente específico pelo ID
@app.get("/clientes/{cliente_id}", response_model=Cliente, tags=["Clientes"])
def read_cliente(cliente_id: int, db: Session = Depends(get_db)):
    cliente = db.query(ClienteModel).filter(ClienteModel.id == cliente_id).first()
    if cliente is None:
        raise HTTPException(status_code=404, detail="Cliente não encontrado")
    return cliente

# Atualizar um cliente
@app.put("/clientes/{cliente_id}", response_model=Cliente, tags=["Clientes"])
def update_cliente(cliente_id: int, cliente: ClienteUpdate, db: Session = Depends(get_db)):
    db_cliente = db.query(ClienteModel).filter(ClienteModel.id == cliente_id).first()
    if db_cliente is None:
        raise HTTPException(status_code=404, detail="Cliente não encontrado")
    
    # Atualiza apenas os campos fornecidos
    cliente_data = cliente.dict(exclude_unset=True)
    for key, value in cliente_data.items():
        setattr(db_cliente, key, value)
    
    db.commit()
    db.refresh(db_cliente)
    return db_cliente

# Deletar um cliente
@app.delete("/clientes/{cliente_id}", status_code=status.HTTP_204_NO_CONTENT, tags=["Clientes"])
def delete_cliente(cliente_id: int, db: Session = Depends(get_db)):
    db_cliente = db.query(ClienteModel).filter(ClienteModel.id == cliente_id).first()
    if db_cliente is None:
        raise HTTPException(status_code=404, detail="Cliente não encontrado")
    
    db.delete(db_cliente)
    db.commit()
    return None
