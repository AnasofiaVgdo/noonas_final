from pydantic import BaseModel, Field


class RecetaBase(BaseModel):
    descripcion: str = Field(..., max_length=100)


class RecetaCreate(RecetaBase):
    pass


class RecetaUpdate(BaseModel):
    descripcion: str | None = Field(None, max_length=100)


class RecetaOut(RecetaBase):
    id_receta: int = Field(..., ge=1)
    id_usuario: int = Field(..., ge=1)
    usuario: str = Field(..., min_length=1, max_length=100)
