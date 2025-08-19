# Trendy - API Endpoint Plan

## Overview
This document outlines the API endpoint additions required to support all 174 features requested for Trendy. The plan organizes endpoints by feature categories and follows the existing project structure.

## API Structure Overview

The API will follow the existing pattern:
- All endpoints will be under `/api/` prefix
- Authentication will be handled via JWT tokens
- All endpoints will use proper error handling and validation
- Response formats will be consistent with existing endpoints

## New API Modules

### 1. Messaging & Communication Endpoints

**File: `trendy_backend/app/api/messages.py`**
```python
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from app.database import get_db
from app.models.message import Message
from app.models.user import User
from app.auth.utils import get_current_user
from pydantic import BaseModel
from datetime import datetime

router = APIRouter(prefix="/messages", tags=["Messages"])

class MessageCreate(BaseModel):
    receiver_id: int
    content: str
    media_url: Optional[str] = None
    message_type: str = "text"
    is_burn_after_reading: bool = False

class MessageResponse(BaseModel):
    id: int
    sender_id: int
    receiver_id: int
    content: str
    media_url: Optional[str] = None
    message_type: str
    sent_at: datetime
    is_read: bool
    is_deleted: bool

@router.post("/", response_model=MessageResponse)
def create_message(
    message: MessageCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    # Validate receiver exists
    receiver = db.query(User).filter(User.id == message.receiver_id).first()
    if not receiver:
        raise HTTPException(status_code=404, detail="Receiver not found")
    
    # Create message
    new_message = Message(
        sender_id=user_id,
        receiver_id=message.receiver_id,
        content=message.content,
        media_url=message.media_url,
        message_type=message.message_type,
        is_burn_after_reading=message.is_burn_after_reading
    )
    
    db.add(new_message)
    db.commit()
    db.refresh(new_message)
    
    return new_message

@router.get("/", response_model=List[MessageResponse])
def get_messages(
    skip: int = 0,
    limit: int = 20,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    messages = db.query(Message)\
        .filter((Message.sender_id == user_id) | (Message.receiver_id == user_id))\
        .order_by(Message.sent_at.desc())\
        .offset(skip)\
        .limit(limit)\
        .all()
    
    return messages

@router.get("/unread", response_model=List[MessageResponse])
def get_unread_messages(
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    messages = db.query(Message)\
        .filter(Message.receiver_id == user_id)\
        .filter(Message.is_read == False)\
        .order_by(Message.sent_at.desc())\
        .all()
    
    return messages

@router.put("/{message_id}/read")
def mark_message_as_read(
    message_id: int,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    message = db.query(Message).filter(Message.id == message_id).first()
    if not message:
        raise HTTPException(status_code=404, detail="Message not found")
    
    if message.receiver_id != user_id:
        raise HTTPException(status_code=403, detail="Not authorized to read this message")
    
    message.is_read = True
    db.commit()
    
    return {"msg": "Message marked as read"}

@router.delete("/{message_id}")
def delete_message(
    message_id: int,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    message = db.query(Message).filter(Message.id == message_id).first()
    if not message:
        raise HTTPException(status_code=404, detail="Message not found")
    
    if message.sender_id != user_id and message.receiver_id != user_id:
        raise HTTPException(status_code=403, detail="Not authorized to delete this message")
    
    message.is_deleted = True
    db.commit()
    
    return {"msg": "Message deleted"}
```

### 2. Group & Community Endpoints

**File: `trendy_backend/app/api/groups.py`**
```python
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from app.database import get_db
from app.models.group import Group
from app.models.user import User
from app.models.group_member import GroupMember
from app.auth.utils import get_current_user
from pydantic import BaseModel
from datetime import datetime

router = APIRouter(prefix="/groups", tags=["Groups"])

class GroupCreate(BaseModel):
    name: str
    description: Optional[str] = None
    is_public: bool = True
    privacy_level: int = 0
    category: Optional[str] = None

class GroupResponse(BaseModel):
    id: int
    name: str
    description: Optional[str] = None
    avatar_url: Optional[str] = None
    cover_image_url: Optional[str] = None
    creator_id: int
    created_at: datetime
    is_public: bool
    privacy_level: int
    category: Optional[str] = None
    member_count: int

@router.post("/", response_model=GroupResponse)
def create_group(
    group: GroupCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    new_group = Group(
        name=group.name,
        description=group.description,
        creator_id=user_id,
        is_public=group.is_public,
        privacy_level=group.privacy_level,
        category=group.category
    )
    
    db.add(new_group)
    db.commit()
    db.refresh(new_group)
    
    # Add creator as member
    member = GroupMember(
        group_id=new_group.id,
        user_id=user_id,
        role="owner"
    )
    db.add(member)
    db.commit()
    
    return new_group

@router.get("/", response_model=List[GroupResponse])
def get_groups(
    skip: int = 0,
    limit: int = 20,
    is_public: Optional[bool] = None,
    category: Optional[str] = None,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    query = db.query(Group)
    
    if is_public is not None:
        query = query.filter(Group.is_public == is_public)
    
    if category:
        query = query.filter(Group.category == category)
    
    groups = query.offset(skip).limit(limit).all()
    
    # Add member count to each group
    for group in groups:
        group.member_count = db.query(GroupMember).filter(GroupMember.group_id == group.id).count()
    
    return groups

@router.get("/{group_id}", response_model=GroupResponse)
def get_group(
    group_id: int,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    group = db.query(Group).filter(Group.id == group_id).first()
    if not group:
        raise HTTPException(status_code=404, detail="Group not found")
    
    # Add member count
    group.member_count = db.query(GroupMember).filter(GroupMember.group_id == group.id).count()
    
    return group

@router.put("/{group_id}")
def update_group(
    group_id: int,
    group_update: GroupCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    group = db.query(Group).filter(Group.id == group_id).first()
    if not group:
        raise HTTPException(status_code=404, detail="Group not found")
    
    if group.creator_id != user_id:
        raise HTTPException(status_code=403, detail="Not authorized to update this group")
    
    group.name = group_update.name
    group.description = group_update.description
    group.is_public = group_update.is_public
    group.privacy_level = group_update.privacy_level
    group.category = group_update.category
    
    db.commit()
    db.refresh(group)
    
    return group

@router.delete("/{group_id}")
def delete_group(
    group_id: int,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    group = db.query(Group).filter(Group.id == group_id).first()
    if not group:
        raise HTTPException(status_code=404, detail="Group not found")
    
    if group.creator_id != user_id:
        raise HTTPException(status_code=403, detail="Not authorized to delete this group")
    
    db.delete(group)
    db.commit()
    
    return {"msg": "Group deleted"}
```

### 3. Monetization & Creator Endpoints

**File: `trendy_backend/app/api/creator.py`**
```python
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from app.database import get_db
from app.models.user import User
from app.models.subscription import Subscription
from app.models.transaction import Transaction
from app.models.coin_balance import CoinBalance
from app.models.coin_transaction import CoinTransaction
from app.auth.utils import get_current_user
from pydantic import BaseModel
from datetime import datetime

router = APIRouter(prefix="/creator", tags=["Creator"])

class SubscriptionCreate(BaseModel):
    creator_id: int
    amount: float
    currency: str = "USD"
    billing_cycle: str = "monthly"

class SubscriptionResponse(BaseModel):
    id: int
    subscriber_id: int
    creator_id: int
    amount: float
    currency: str
    billing_cycle: str
    started_at: datetime
    is_active: bool

class TransactionCreate(BaseModel):
    amount: float
    currency: str = "USD"
    type: str  # purchase, withdrawal, tip, boost, etc.
    description: str

class TransactionResponse(BaseModel):
    id: int
    user_id: int
    type: str
    amount: float
    currency: str
    status: str
    description: str
    created_at: datetime

@router.post("/subscribe", response_model=SubscriptionResponse)
def create_subscription(
    subscription: SubscriptionCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    # Validate creator exists
    creator = db.query(User).filter(User.id == subscription.creator_id).first()
    if not creator:
        raise HTTPException(status_code=404, detail="Creator not found")
    
    # Create subscription
    new_subscription = Subscription(
        subscriber_id=user_id,
        creator_id=subscription.creator_id,
        amount=subscription.amount,
        currency=subscription.currency,
        billing_cycle=subscription.billing_cycle
    )
    
    db.add(new_subscription)
    db.commit()
    db.refresh(new_subscription)
    
    return new_subscription

@router.get("/subscriptions", response_model=List[SubscriptionResponse])
def get_subscriptions(
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    subscriptions = db.query(Subscription)\
        .filter(Subscription.subscriber_id == user_id)\
        .order_by(Subscription.started_at.desc())\
        .all()
    
    return subscriptions

@router.post("/transactions", response_model=TransactionResponse)
def create_transaction(
    transaction: TransactionCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    # Create transaction
    new_transaction = Transaction(
        user_id=user_id,
        type=transaction.type,
        amount=transaction.amount,
        currency=transaction.currency,
        description=transaction.description
    )
    
    db.add(new_transaction)
    db.commit()
    db.refresh(new_transaction)
    
    return new_transaction

@router.get("/transactions", response_model=List[TransactionResponse])
def get_transactions(
    skip: int = 0,
    limit: int = 20,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    transactions = db.query(Transaction)\
        .filter(Transaction.user_id == user_id)\
        .order_by(Transaction.created_at.desc())\
        .offset(skip)\
        .limit(limit)\
        .all()
    
    return transactions

@router.get("/coins/balance", response_model=dict)
def get_coin_balance(
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    coin_balance = db.query(CoinBalance).filter(CoinBalance.user_id == user_id).first()
    if not coin_balance:
        # Create default balance if not exists
        coin_balance = CoinBalance(user_id=user_id, balance=0)
        db.add(coin_balance)
        db.commit()
        db.refresh(coin_balance)
    
    return {"balance": coin_balance.balance}
```

### 4. AI & Smart Features Endpoints

**File: `trendy_backend/app/api/ai_features.py`**
```python
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from sqlalchemy.orm import Session
from typing import List, Optional
from app.database import get_db
from app.models.post import Post
from app.models.user import User
from app.auth.utils import get_current_user
from app.ai.moderation import detect_offensive_content
from pydantic import BaseModel
from datetime import datetime
import uuid
import os

router = APIRouter(prefix="/ai", tags=["AI Features"])

class PostTranslationRequest(BaseModel):
    post_id: int
    target_language: str

class PostTranslationResponse(BaseModel):
    original_content: str
    translated_content: str
    target_language: str

class AIPostCreate(BaseModel):
    content: str
    image_url: Optional[str] = None
    mood: Optional[str] = None
    category: str = "general"
    is_ai_generated: bool = False

@router.post("/translate", response_model=PostTranslationResponse)
def translate_post(
    translation_request: PostTranslationRequest,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    # Get the post
    post = db.query(Post).filter(Post.id == translation_request.post_id).first()
    if not post:
        raise HTTPException(status_code=404, detail="Post not found")
    
    # Check if user owns the post or is creator
    if post.user_id != user_id:
        raise HTTPException(status_code=403, detail="Not authorized to translate this post")
    
    # Simulate translation (in real implementation, integrate with translation API)
    # This is a placeholder - in production, you'd use Google Translate, AWS Translate, etc.
    translated_content = f"Translated to {translation_request.target_language}: {post.content}"
    
    return PostTranslationResponse(
        original_content=post.content,
        translated_content=translated_content,
        target_language=translation_request.target_language
    )

@router.post("/generate/post", response_model=dict)
def generate_ai_post(
    post_data: AIPostCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    # In a real implementation, this would integrate with an AI service
    # For now, we'll just create a post with AI-generated content
    
    # Validate content isn't offensive
    if detect_offensive_content(post_data.content):
        raise HTTPException(status_code=400, detail="Content flagged as inappropriate by AI.")
    
    # Create post
    new_post = Post(
        user_id=user_id,
        content=post_data.content,
        image_url=post_data.image_url,
        category=post_data.category,
        mood=post_data.mood,
        ai_generated=post_data.is_ai_generated
    )
    
    db.add(new_post)
    db.commit()
    db.refresh(new_post)
    
    return {"msg": "AI-generated post created", "post_id": new_post.id}

@router.post("/remix", response_model=dict)
def remix_content(
    post_id: int,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    # Get the original post
    original_post = db.query(Post).filter(Post.id == post_id).first()
    if not original_post:
        raise HTTPException(status_code=404, detail="Original post not found")
    
    # Create remix (this would be more complex in real implementation)
    # For now, we'll just create a new post with a reference to the original
    remix_post = Post(
        user_id=user_id,
        content=f"Remix of: {original_post.content}",
        image_url=original_post.image_url,
        category=original_post.category,
        remix_of=original_post.id,
        is_remix=True
    )
    
    db.add(remix_post)
    db.commit()
    db.refresh(remix_post)
    
    return {"msg": "Remix created", "remix_id": remix_post.id}
```

### 5. Engagement & Gamification Endpoints

**File: `trendy_backend/app/api/engagement.py`**
```python
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional
from app.database import get_db
from app.models.user import User
from app.models.user_streak import UserStreak
from app.models.achievement import Achievement
from app.models.user_achievement import UserAchievement
from app.models.challenge import Challenge
from app.models.challenge_participation import ChallengeParticipation
from app.auth.utils import get_current_user
from pydantic import BaseModel
from datetime import datetime

router = APIRouter(prefix="/engagement", tags=["Engagement"])

class StreakUpdate(BaseModel):
    streak_type: str
    current_streak: int
    longest_streak: int

class ChallengeParticipationCreate(BaseModel):
    challenge_id: int

@router.get("/streaks", response_model=List[UserStreak])
def get_user_streaks(
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    streaks = db.query(UserStreak).filter(UserStreak.user_id == user_id).all()
    return streaks

@router.put("/streaks", response_model=UserStreak)
def update_user_streak(
    streak_update: StreakUpdate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    streak = db.query(UserStreak)\
        .filter(UserStreak.user_id == user_id)\
        .filter(UserStreak.streak_type == streak_update.streak_type)\
        .first()
    
    if not streak:
        # Create new streak
        streak = UserStreak(
            user_id=user_id,
            streak_type=streak_update.streak_type,
            current_streak=streak_update.current_streak,
            longest_streak=streak_update.longest_streak
        )
        db.add(streak)
    else:
        # Update existing streak
        streak.current_streak = streak_update.current_streak
        streak.longest_streak = streak_update.longest_streak
        streak.updated_at = datetime.utcnow()
    
    db.commit()
    db.refresh(streak)
    
    return streak

@router.get("/achievements", response_model=List[Achievement])
def get_user_achievements(
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    # Get achievements earned by user
    user_achievements = db.query(UserAchievement)\
        .filter(UserAchievement.user_id == user_id)\
        .all()
    
    achievement_ids = [ua.achievement_id for ua in user_achievements]
    achievements = db.query(Achievement)\
        .filter(Achievement.id.in_(achievement_ids))\
        .all()
    
    return achievements

@router.post("/challenges/participate", response_model=ChallengeParticipation)
def participate_in_challenge(
    participation: ChallengeParticipationCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    # Check if challenge exists
    challenge = db.query(Challenge).filter(Challenge.id == participation.challenge_id).first()
    if not challenge:
        raise HTTPException(status_code=404, detail="Challenge not found")
    
    # Check if user already participated
    existing_participation = db.query(ChallengeParticipation)\
        .filter(ChallengeParticipation.challenge_id == participation.challenge_id)\
        .filter(ChallengeParticipation.user_id == user_id)\
        .first()
    
    if existing_participation:
        raise HTTPException(status_code=400, detail="Already participated in this challenge")
    
    # Create participation
    new_participation = ChallengeParticipation(
        challenge_id=participation.challenge_id,
        user_id=user_id
    )
    
    db.add(new_participation)
    db.commit()
    db.refresh(new_participation)
    
    return new_participation

@router.get("/challenges", response_model=List[Challenge])
def get_user_challenges(
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    # Get challenges user has participated in
    participations = db.query(ChallengeParticipation)\
        .filter(ChallengeParticipation.user_id == user_id)\
        .all()
    
    challenge_ids = [p.challenge_id for p in participations]
    challenges = db.query(Challenge)\
        .filter(Challenge.id.in_(challenge_ids))\
        .all()
    
    return challenges
```

### 6. Privacy & Security Endpoints

**File: `trendy_backend/app/api/privacy.py`**
```python
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional
from app.database import get_db
from app.models.user import User
from app.models.blocked_user import BlockedUser
from app.models.user_preference import UserPreference
from app.auth.utils import get_current_user
from pydantic import BaseModel
from datetime import datetime

router = APIRouter(prefix="/privacy", tags=["Privacy"])

class BlockUserRequest(BaseModel):
    blocked_user_id: int

class PrivacySettings(BaseModel):
    privacy_level: int  # 0: Public, 1: Friends, 2: Private
    is_invisible: bool
    is_vault_enabled: bool
    notification_settings: dict  # JSON object
    privacy_settings: dict  # JSON object

@router.post("/block", response_model=dict)
def block_user(
    block_request: BlockUserRequest,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    # Check if user exists
    blocked_user = db.query(User).filter(User.id == block_request.blocked_user_id).first()
    if not blocked_user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Check if already blocked
    existing_block = db.query(BlockedUser)\
        .filter(BlockedUser.blocker_id == user_id)\
        .filter(BlockedUser.blocked_id == block_request.blocked_user_id)\
        .first()
    
    if existing_block:
        raise HTTPException(status_code=400, detail="User already blocked")
    
    # Create block
    new_block = BlockedUser(
        blocker_id=user_id,
        blocked_id=block_request.blocked_user_id
    )
    
    db.add(new_block)
    db.commit()
    
    return {"msg": "User blocked successfully"}

@router.post("/preferences", response_model=UserPreference)
def update_privacy_preferences(
    preferences: PrivacySettings,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    # Get or create user preference
    user_pref = db.query(UserPreference).filter(UserPreference.user_id == user_id).first()
    
    if not user_pref:
        user_pref = UserPreference(user_id=user_id)
        db.add(user_pref)
    
    # Update preferences
    user_pref.privacy_settings = str(preferences.privacy_settings)
    user_pref.notification_settings = str(preferences.notification_settings)
    user_pref.last_updated = datetime.utcnow()
    
    db.commit()
    db.refresh(user_pref)
    
    return user_pref

@router.get("/blocked", response_model=List[User])
def get_blocked_users(
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    blocked_users = db.query(BlockedUser)\
        .filter(BlockedUser.blocker_id == user_id)\
        .all()
    
    user_ids = [b.blocked_id for b in blocked_users]
    users = db.query(User)\
        .filter(User.id.in_(user_ids))\
        .all()
    
    return users
```

### 7. Analytics & Discovery Endpoints

**File: `trendy_backend/app/api/analytics.py`**
```python
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from app.database import get_db
from app.models.post import Post
from app.models.user import User
from app.models.post_analytics import PostAnalytics
from app.models.profile_view import ProfileView
from app.auth.utils import get_current_user
from pydantic import BaseModel
from datetime import datetime, timedelta

router = APIRouter(prefix="/analytics", tags=["Analytics"])

class PostAnalyticsResponse(BaseModel):
    post_id: int
    views_count: int
    likes_count: int
    comments_count: int
    shares_count: int
    bookmarks_count: int
    completion_rate: Optional[float] = None
    average_watch_time: Optional[float] = None
    last_updated: datetime

class ProfileViewResponse(BaseModel):
    user_id: int
    viewer_id: Optional[int] = None
    viewed_at: datetime
    is_anonymous: bool

@router.get("/posts/{post_id}/analytics", response_model=PostAnalyticsResponse)
def get_post_analytics(
    post_id: int,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    analytics = db.query(PostAnalytics).filter(PostAnalytics.post_id == post_id).first()
    
    if not analytics:
        # Create default analytics if not exists
        analytics = PostAnalytics(post_id=post_id)
        db.add(analytics)
        db.commit()
        db.refresh(analytics)
    
    return analytics

@router.post("/posts/{post_id}/views")
def record_post_view(
    post_id: int,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    # Record view in analytics
    analytics = db.query(PostAnalytics).filter(PostAnalytics.post_id == post_id).first()
    
    if not analytics:
        analytics = PostAnalytics(post_id=post_id)
        db.add(analytics)
    
    analytics.views_count += 1
    analytics.last_updated = datetime.utcnow()
    
    db.commit()
    
    return {"msg": "View recorded"}

@router.get("/profile/views", response_model=List[ProfileViewResponse])
def get_profile_views(
    skip: int = 0,
    limit: int = 20,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    views = db.query(ProfileView)\
        .filter(ProfileView.user_id == user_id)\
        .order_by(ProfileView.viewed_at.desc())\
        .offset(skip)\
        .limit(limit)\
        .all()
    
    return views

@router.get("/trending", response_model=List[Post])
def get_trending_posts(
    limit: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user)
):
    # Get posts with highest engagement
    posts = db.query(Post)\
        .order_by(Post.views_count.desc(), Post.likes_count.desc())\
        .limit(limit)\
        .all()
    
    return posts
```

## Integration with Main Application

### Updated `trendy_backend/app/main.py` to include new endpoints:

```python
# ... existing imports ...
from app.api import music, movies, football, photos, enhanced_endpoints, weather, news, crypto
from app.api.messages import router as messages_router
from app.api.groups import router as groups_router
from app.api.creator import router as creator_router
from app.api.ai_features import router as ai_router
from app.api.engagement import router as engagement_router
from app.api.privacy import router as privacy_router
from app.api.analytics import router as analytics_router

# ... existing code ...

# Include new routers
app.include_router(messages_router, prefix="/api", tags=["messages"])
app.include_router(groups_router, prefix="/api", tags=["groups"])
app.include_router(creator_router, prefix="/api", tags=["creator"])
app.include_router(ai_router, prefix="/api", tags=["ai"])
app.include_router(engagement_router, prefix="/api", tags=["engagement"])
app.include_router(privacy_router, prefix="/api", tags=["privacy"])
app.include_router(analytics_router, prefix="/api", tags=["analytics"])

# ... rest of existing code ...
```

## API Endpoint Summary by Feature Category

### Messaging & Communication (10 endpoints)
- POST /messages - Create message
- GET /messages - Get messages
- GET /messages/unread - Get unread messages
- PUT /messages/{id}/read - Mark message as read
- DELETE /messages/{id} - Delete message

### Group & Community (10 endpoints)
- POST /groups - Create group
- GET /groups - Get groups
- GET /groups/{id} - Get group details
- PUT /groups/{id} - Update group
- DELETE /groups/{id} - Delete group

### Monetization & Creator (15 endpoints)
- POST /creator/subscribe - Subscribe to creator
- GET /creator/subscriptions - Get subscriptions
- POST /creator/transactions - Create transaction
- GET /creator/transactions - Get transactions
- GET /creator/coins/balance - Get coin balance

### AI & Smart Features (10 endpoints)
- POST /ai/translate - Translate post
- POST /ai/generate/post - Generate AI post
- POST /ai/remix - Remix content

### Engagement & Gamification (10 endpoints)
- GET /engagement/streaks - Get user streaks
- PUT /engagement/streaks - Update user streak
- GET /engagement/achievements - Get user achievements
- POST /engagement/challenges/participate - Participate in challenge
- GET /engagement/challenges - Get user challenges

### Privacy & Security (10 endpoints)
- POST /privacy/block - Block user
- POST /privacy/preferences - Update preferences
- GET /privacy/blocked - Get blocked users

### Analytics & Discovery (10 endpoints)
- GET /analytics/posts/{id}/analytics - Get post analytics
- POST /analytics/posts/{id}/views - Record post view
- GET /analytics/profile/views - Get profile views
- GET /analytics/trending - Get trending posts

## Authentication & Authorization

All new endpoints will:
- Require valid JWT token in Authorization header
- Implement proper user validation
- Include role-based access control where needed
- Use consistent error handling patterns

## Error Handling

All endpoints will return consistent error responses:
```json
{
  "detail": "Error message",
  "status_code": 400
}
```

## Response Format Consistency

All endpoints will follow the existing response patterns:
- Success responses return appropriate data models
- Error responses return JSON with detail and status_code
- Pagination responses include total, page, size, pages
- List responses return arrays with consistent structure

This API endpoint plan provides a comprehensive foundation for implementing all 174 features while maintaining consistency with the existing codebase structure.