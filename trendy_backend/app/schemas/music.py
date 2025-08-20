from pydantic import BaseModel
from typing import Optional

class MusicBase(BaseModel):
    title: str
    artist: str
    genre: Optional[str] = None
    year: int

class MusicCreate(MusicBase):
    pass

class MusicResponse(MusicBase):
    id: int
    
    class Config:
        from_attributes = True

# Alias MusicOut to MusicResponse for compatibility
MusicOut = MusicResponse
