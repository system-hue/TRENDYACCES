from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.auth.utils import get_current_user
from app.models.post import Post
from app.schemas.post import PostCreate, PostOut
from app.ai.moderation import detect_offensive_content

router = APIRouter(prefix="/posts", tags=["Posts"])

@router.post("/", response_model=PostOut)
def create_post(post: PostCreate, db: Session = Depends(get_db), user_id: int = Depends(get_current_user)):
    # AI moderation
    if detect_offensive_content(post.content):
        raise HTTPException(status_code=400, detail="Content flagged as inappropriate by AI.")

    new_post = Post(
        user_id=user_id,
        content=post.content,
        image_url=post.image_url
    )
    db.add(new_post)
    db.commit()
    db.refresh(new_post)
    return new_post

@router.get("/", response_model=list[PostOut])
def get_all_posts(db: Session = Depends(get_db)):
    return db.query(Post).order_by(Post.created_at.desc()).all()

@router.get("/me", response_model=list[PostOut])
def get_my_posts(db: Session = Depends(get_db), user_id: int = Depends(get_current_user)):
    return db.query(Post).filter(Post.user_id == user_id).all()

@router.delete("/{post_id}")
def delete_post(post_id: int, db: Session = Depends(get_db), user_id: int = Depends(get_current_user)):
    post = db.query(Post).filter(Post.id == post_id).first()
    if not post:
        raise HTTPException(status_code=404, detail="Post not found")
    if post.user_id != user_id:
        raise HTTPException(status_code=403, detail="Not allowed to delete this post")

    db.delete(post)
    db.commit()
    return {"msg": "Post deleted"}
