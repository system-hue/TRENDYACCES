from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from typing import List, Optional
from app.database import get_db
from app.models.post import Post
from app.models.user import User
from sqlalchemy import desc, func, or_

router = APIRouter(prefix="/api/movies", tags=["movies"])

@router.get("/")
async def get_movies(
    skip: int = 0,
    limit: int = 20,
    category: Optional[str] = None,
    search: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Get movie-like posts (parsed from content) with pagination and filtering"""
    query = db.query(Post).filter(
        or_(Post.content.contains("Director:"), Post.content.contains("Rating:"))
    )
    
    # Optional filters operate on content since schema doesn't have explicit fields
    if category:
        query = query.filter(Post.content.contains(category))
    
    if search:
        query = query.filter(Post.content.contains(search))
    
    movies = query.order_by(desc(Post.created_at)).offset(skip).limit(limit).all()
    
    return {
        "movies": [
            {
                "id": movie.id,
                "title": (movie.content.split("\n")[0] if movie.content else ""),
                "description": movie.content,
                "image_url": movie.image_url,
                "category": "movies",
                "created_at": movie.created_at.isoformat(),
                "user": {
                    "id": movie.user.id,
                    "username": movie.user.username,
                    "avatar_url": None
                },
                "likes": len(movie.comments),
                "comments": len(movie.comments)
            }
            for movie in movies
        ],
        "total": query.count()
    }

@router.get("/trending")
async def get_trending_movies(db: Session = Depends(get_db)):
    """Get trending movies based on recency (comments used as proxy for engagement)"""
    movies = db.query(Post).filter(
        or_(Post.content.contains("Director:"), Post.content.contains("Rating:"))
    ).order_by(
        desc(Post.created_at)
    ).limit(10).all()
    
    return {
        "movies": [
            {
                "id": movie.id,
                "title": (movie.content.split("\n")[0] if movie.content else ""),
                "description": movie.content,
                "image_url": movie.image_url,
                "likes": len(movie.comments),
                "views": None,
                "user": {
                    "id": movie.user.id,
                    "username": movie.user.username
                }
            }
            for movie in movies
        ]
    }

@router.get("/{movie_id}")
async def get_movie_detail(movie_id: str, db: Session = Depends(get_db)):
    """Get detailed movie information"""
    movie = db.query(Post).filter(Post.id == movie_id).first()
    if not movie:
        raise HTTPException(status_code=404, detail="Movie not found")
    
    return {
        "id": movie.id,
        "title": (movie.content.split("\n")[0] if movie.content else ""),
        "description": movie.content,
        "image_url": movie.image_url,
        "category": "movies",
        "created_at": movie.created_at.isoformat(),
        "user": {
            "id": movie.user.id,
            "username": movie.user.username,
            "avatar_url": None
        },
        "likes": len(movie.comments),
        "comments": [
            {
                "id": comment.id,
                "content": comment.text,
                "created_at": None,
                "user": {
                    "id": comment.owner.id if comment.owner else None,
                    "username": comment.owner.username if comment.owner else None
                }
            }
            for comment in movie.comments
        ]
    }
