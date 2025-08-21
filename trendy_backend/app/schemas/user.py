from pydantic import BaseModel, EmailStr, Field
from typing import Optional, Dict, Any
from datetime import datetime

class UserBase(BaseModel):
    email: EmailStr
    username: str = Field(..., min_length=3, max_length=50)
    display_name: Optional[str] = Field(None, max_length=100)
    bio: Optional[str] = None
    avatar_url: Optional[str] = None
    phone_number: Optional[str] = None

class UserCreate(UserBase):
    firebase_uid: str

class UserUpdate(BaseModel):
    display_name: Optional[str] = Field(None, max_length=100)
    bio: Optional[str] = None
    avatar_url: Optional[str] = None
    phone_number: Optional[str] = None
    preferences: Optional[Dict[str, Any]] = None

class UserResponse(UserBase):
    id: int
    firebase_uid: str
    is_verified: bool
    is_active: bool
    is_premium: bool
    subscription_tier: str
    subscription_expires_at: Optional[datetime]
    preferences: Dict[str, Any]
    metadata: Dict[str, Any]
    created_at: datetime
    updated_at: Optional[datetime]
    last_login_at: Optional[datetime]
    
    class Config:
        from_attributes = True

class UserProfile(UserResponse):
    followers_count: int
    following_count: int
    posts_count: int

class UserList(BaseModel):
    users: list[UserResponse]
    total: int
    page: int
    per_page: int
