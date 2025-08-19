from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from typing import List, Optional
from app.database import get_db
from app.models.post import Post
from app.models.user import User
from sqlalchemy import desc, func

router = APIRouter(prefix="/api/music", tags=["music"])

@router.get("/")
async def get_music(
    skip: int = 0,
    limit: int = 20,
    genre: Optional[str] = None,
    search: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Get real music data with pagination and filtering"""
    query = db.query(Post).filter(Post.category == "music")
    
    if search:
        query = query.filter(Post.content.contains(search))
    
    music = query.order_by(desc(Post.created_at)).offset(skip).limit(limit).all()
    
    return {
        "music": [
            {
                "id": m.id,
                "title": m.content.split("\n")[0],
                "artist": m.content.split("\n")[1] if len(m.content.split("\n")) > 1 else "Unknown Artist",
                "description": m.content,
                "image_url": m.image_url,
                "created_at": m.created_at.isoformat(),
                "user": {
                    "id": m.user.id,
                    "username": m.user.username,
                    "avatar_url": m.user.avatar_url
                },
                "likes": m.likes_count,
                "genre": "music"
            }
            for m in music
        ],
        "total": query.count()
    }

@router.get("/trending")
async def get_trending_music(db: Session = Depends(get_db)):
    """Get trending music based on likes"""
    music = db.query(Post).filter(
        Post.category == "music"
    ).order_by(
        desc(Post.likes_count),
        desc(Post.created_at)
    ).limit(10).all()
    
    return {
        "music": [
            {
                "id": m.id,
                "title": m.content.split("\n")[0],
                "artist": m.content.split("\n")[1] if len(m.content.split("\n")) > 1 else "Unknown Artist",
                "image_url": m.image_url,
                "likes": m.likes_count,
                "user": {
                    "id": m.user.id,
                    "username": m.user.username
                }
            }
            for m in music
        ]
    }

@router.get("/genres")
async def get_genres(db: Session = Depends(get_db)):
    """Get music genres from database"""
    genres = db.query(Post.category).filter(Post.category == "music").distinct().all()
    return {"genres": [g[0] for g in genres]}
