from pydantic import BaseModel
from typing import Optional

class MovieBase(BaseModel):
    title: str
    description: Optional[str] = None
    year: int
    genre: str
    rating: float

class MovieCreate(MovieBase):
    pass

class MovieResponse(MovieBase):
    id: int
    
    class Config:
        from_attributes = True

# Alias MovieOut to MovieResponse for compatibility
MovieOut = MovieResponse
