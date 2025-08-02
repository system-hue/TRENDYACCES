from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class PostCreate(BaseModel):
    content: str
    image_url: Optional[str] = None

class PostOut(BaseModel):
    id: int
    user_id: int
    content: str
    image_url: Optional[str]
    created_at: datetime

    class Config:
        orm_mode = True
