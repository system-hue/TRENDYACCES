from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from app.database import Base
from datetime import datetime

class Post(Base):
    __tablename__ = "posts"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    content = Column(String, nullable=False)
    image_url = Column(String, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    category = Column(String, nullable=False, default="general")
    type = Column(String, nullable=False, default="post")
    likes_count = Column(Integer, default=0)
    views_count = Column(Integer, default=0)
    
    user = relationship("User", back_populates="posts")
    comments = relationship("Comment", back_populates="post")
