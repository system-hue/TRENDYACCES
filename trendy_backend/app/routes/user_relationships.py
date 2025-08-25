"""
User Relationships API Routes for TRENDY App
Handles following/followers system and user blocking functionality
"""

from fastapi import APIRouter, HTTPException, Depends, BackgroundTasks
from sqlalchemy.orm import Session
from pydantic import BaseModel
from datetime import datetime

from app.database import get_db
from app.models.user import User
from app.models.user_relationships import Follow, UserBlock
from app.auth.middleware import get_current_user

router = APIRouter(prefix="/users/relationships", tags=["user-relationships"])

class FollowRequest(BaseModel):
    user_id: int

class BlockRequest(BaseModel):
    user_id: int
    reason: str = None

class RelationshipResponse(BaseModel):
    success: bool
    message: str

@router.post("/follow/{user_id}", response_model=RelationshipResponse)
async def follow_user(
    user_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Follow a user"""
    
    if user_id == current_user.id:
        raise HTTPException(status_code=400, detail="Cannot follow yourself")
    
    # Check if user exists
    target_user = db.query(User).filter(User.id == user_id).first()
    if not target_user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Check if already following
    existing_follow = db.query(Follow).filter(
        Follow.follower_id == current_user.id,
        Follow.following_id == user_id
    ).first()
    
    if existing_follow:
        raise HTTPException(status_code=400, detail="Already following this user")
    
    # Create follow relationship
    follow = Follow(
        follower_id=current_user.id,
        following_id=user_id,
        created_at=datetime.utcnow()
    )
    db.add(follow)
    db.commit()
    
    return RelationshipResponse(success=True, message="Successfully followed user")

@router.delete("/unfollow/{user_id}", response_model=RelationshipResponse)
async def unfollow_user(
    user_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Unfollow a user"""
    
    follow = db.query(Follow).filter(
        Follow.follower_id == current_user.id,
        Follow.following_id == user_id
    ).first()
    
    if not follow:
        raise HTTPException(status_code=400, detail="Not following this user")
    
    db.delete(follow)
    db.commit()
    
    return RelationshipResponse(success=True, message="Successfully unfollowed user")

@router.post("/block/{user_id}", response_model=RelationshipResponse)
async def block_user(
    user_id: int,
    request: BlockRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Block a user"""
    
    if user_id == current_user.id:
        raise HTTPException(status_code=400, detail="Cannot block yourself")
    
    # Check if user exists
    target_user = db.query(User).filter(User.id == user_id).first()
    if not target_user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Check if already blocked
    existing_block = db.query(UserBlock).filter(
        UserBlock.blocker_id == current_user.id,
        UserBlock.blocked_id == user_id
    ).first()
    
    if existing_block:
        raise HTTPException(status_code=400, detail="Already blocking this user")
    
    # Create block relationship
    block = UserBlock(
        blocker_id=current_user.id,
        blocked_id=user_id,
        reason=request.reason,
        created_at=datetime.utcnow()
    )
    db.add(block)
    db.commit()
    
    return RelationshipResponse(success=True, message="Successfully blocked user")

@router.delete("/unblock/{user_id}", response_model=RelationshipResponse)
async def unblock_user(
    user_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Unblock a user"""
    
    block = db.query(UserBlock).filter(
        UserBlock.blocker_id == current_user.id,
        UserBlock.blocked_id == user_id
    ).first()
    
    if not block:
        raise HTTPException(status_code=400, detail="Not blocking this user")
    
    db.delete(block)
    db.commit()
    
    return RelationshipResponse(success=True, message="Successfully unblocked user")

@router.get("/followers/{user_id}")
async def get_followers(
    user_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get followers of a user"""
    
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    followers = db.query(User).join(
        Follow, User.id == Follow.follower_id
    ).filter(
        Follow.following_id == user_id
    ).all()
    
    return {
        "followers": [
            {
                "id": u.id,
                "username": u.username,
                "full_name": u.full_name,
                "profile_picture": u.profile_picture,
                "is_verified": u.is_verified
            }
            for u in followers
        ],
        "count": len(followers)
    }

@router.get("/following/{user_id}")
async def get_following(
    user_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get users that a user is following"""
    
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    following = db.query(User).join(
        Follow, User.id == Follow.following_id
    ).filter(
        Follow.follower_id == user_id
    ).all()
    
    return {
        "following": [
            {
                "id": u.id,
                "username": u.username,
                "full_name": u.full_name,
                "profile_picture": u.profile_picture,
                "is_verified": u.is_verified
            }
            for u in following
        ],
        "count": len(following)
    }

@router.get("/blocked")
async def get_blocked_users(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get list of blocked users"""
    
    blocked_users = db.query(User).join(
        UserBlock, User.id == UserBlock.blocked_id
    ).filter(
        UserBlock.blocker_id == current_user.id
    ).all()
    
    return {
        "blocked_users": [
            {
                "id": u.id,
                "username": u.username,
                "full_name": u.full_name,
                "profile_picture": u.profile_picture,
                "is_verified": u.is_verified
            }
            for u in blocked_users
        ],
        "count": len(blocked_users)
    }

@router.get("/relationship-status/{user_id}")
async def get_relationship_status(
    user_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get relationship status with a user"""
    
    if user_id == current_user.id:
        return {"status": "self"}
    
    # Check if following
    is_following = db.query(Follow).filter(
        Follow.follower_id == current_user.id,
        Follow.following_id == user_id
    ).first() is not None
    
    # Check if blocked
    is_blocked = db.query(UserBlock).filter(
        UserBlock.blocker_id == current_user.id,
        UserBlock.blocked_id == user_id
    ).first() is not None
    
    # Check if blocked by
    is_blocked_by = db.query(UserBlock).filter(
        UserBlock.blocker_id == user_id,
        UserBlock.blocked_id == current_user.id
    ).first() is not None
    
    return {
        "is_following": is_following,
        "is_blocked": is_blocked,
        "is_blocked_by": is_blocked_by
    }
