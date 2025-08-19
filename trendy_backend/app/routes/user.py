from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.user import User
from app.schemas.user import UserCreate, UserOut
from app.auth.utils import get_password_hash, verify_password, get_current_user
from app.auth.jwt_handler import create_access_token
from pydantic import BaseModel

router = APIRouter()

class UserLogin(BaseModel):
    identifier: str  # can be email or username
    password: str

@router.post("/register", response_model=UserOut)
def register(user: UserCreate, db: Session = Depends(get_db)):
    # Check email
    existing_email = db.query(User).filter(User.email == user.email).first()
    if existing_email:
        raise HTTPException(status_code=400, detail="Email already registered")

    # Check username
    existing_username = db.query(User).filter(User.username == user.username).first()
    if existing_username:
        raise HTTPException(status_code=400, detail="Username already taken")

    # Hash password
    hashed = get_password_hash(user.password)

    # Create user
    new_user = User(
        email=user.email,
        username=user.username,
        password=hashed
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user

@router.post("/login")
def login(credentials: UserLogin, db: Session = Depends(get_db)):
    user = db.query(User).filter(
        (User.email == credentials.identifier) |
        (User.username == credentials.identifier)
    ).first()

    if not user or not verify_password(credentials.password, user.password):
        raise HTTPException(status_code=401, detail="Invalid credentials")

    token = create_access_token({"sub": user.id})
    return {"access_token": token, "token_type": "bearer"}

@router.get("/me", response_model=UserOut)
def get_me(db: Session = Depends(get_db), user_id=Depends(get_current_user)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.get("/{user_id}", response_model=UserOut)
def get_user_profile(user_id: int, db: Session = Depends(get_db)):
    """Get user profile by ID"""
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.get("/{user_id}/posts")
def get_user_posts(
    user_id: int,
    skip: int = 0,
    limit: int = 20,
    db: Session = Depends(get_db)
):
    """Get user posts with pagination - matches Flutter client expectations"""
    from app.models.post import Post
    from sqlalchemy import desc
    
    # Validate user exists
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Query posts with pagination
    query = db.query(Post).filter(Post.user_id == user_id)
    total = query.count()
    posts = query.order_by(desc(Post.created_at)).offset(skip).limit(limit).all()
    
    return {
        "posts": [
            {
                "id": post.id,
                "content": post.content,
                "image_url": post.image_url,
                "created_at": post.created_at.isoformat(),
                "user": {
                    "id": post.user.id,
                    "username": post.user.username
                },
                "likes": len(post.comments),
                "comments": len(post.comments)
            }
            for post in posts
        ],
        "total": total
    }
