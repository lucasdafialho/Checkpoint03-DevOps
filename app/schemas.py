from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List
from datetime import datetime

# Schema para criação de cliente
class ClienteCreate(BaseModel):
    nome: str = Field(..., example="João Silva")
    email: str = Field(..., example="joao.silva@email.com")
    telefone: Optional[str] = Field(None, example="(11) 98765-4321")
    saldo: float = Field(0.0, example=0.0)

# Schema para atualização de cliente
class ClienteUpdate(BaseModel):
    nome: Optional[str] = Field(None, example="João Silva")
    email: Optional[str] = Field(None, example="joao.silva@email.com")
    telefone: Optional[str] = Field(None, example="(11) 98765-4321")
    saldo: Optional[float] = Field(None, example=100.0)

# Schema para resposta de cliente
class Cliente(BaseModel):
    id: int
    nome: str
    email: str
    telefone: Optional[str] = None
    saldo: float
    data_cadastro: datetime
    data_atualizacao: datetime

    class Config:
        orm_mode = True
