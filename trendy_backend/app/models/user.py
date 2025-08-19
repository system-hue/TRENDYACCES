from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.orm import relationship
from app.database import Base
from datetime import datetime

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    username = Column(String, unique=True, index=True, nullable=False)
    password = Column(String, nullable=False)
    profile_image = Column(String, nullable=True)
    avatar_url = Column(String, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    posts = relationship("Post", back_populates="user")
    comments = relationship("Comment", back_populates="owner")
    followers = relationship("Follower", foreign_keys="[Follower.followed_id]", back_populates="followed")
    following = relationship("Follower", foreign_keys="[Follower.follower_id]", back_populates="follower")
    sent_messages = relationship("Message", foreign_keys="[Message.sender_id]", back_populates="sender")
    received_messages = relationship("Message", foreign_keys="[Message.receiver_id]", back_populates="receiver")
    groups = relationship("GroupMember", back_populates="user")
    created_groups = relationship("Group", back_populates="creator")
