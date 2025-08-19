# Trendy - New Database Models

## New Models

### Message
```python
class Message(Base):
    __tablename__ = "messages"
    
    id = Column(Integer, primary_key=True, index=True)
    sender_id = Column(Integer, ForeignKey("users.id"))
    receiver_id = Column(Integer, ForeignKey("users.id"))
    group_id = Column(Integer, ForeignKey("groups.id"), nullable=True)
    content = Column(String, nullable=False)
    media_url = Column(String, nullable=True)
    message_type = Column(String, default="text")  # text, image, video, audio, file
    sent_at = Column(DateTime, default=datetime.utcnow)
    read_at = Column(DateTime, nullable=True)
    is_deleted = Column(Boolean, default=False)
    is_burn_after_reading = Column(Boolean, default=False)
    expires_at = Column(DateTime, nullable=True)
    reply_to_message_id = Column(Integer, ForeignKey("messages.id"), nullable=True)
    is_edited = Column(Boolean, default=False)
    edited_at = Column(DateTime, nullable=True)
    
    # Relationships
    sender = relationship("User", foreign_keys=[sender_id], back_populates="sent_messages")
    receiver = relationship("User", foreign_keys=[receiver_id], back_populates="received_messages")
    group = relationship("Group", back_populates="messages")
    replies = relationship("Message", back_populates="parent")
    parent = relationship("Message", back_populates="replies", remote_side=[id])
    reactions = relationship("MessageReaction", back_populates="message")
```

### Group
```python
class Group(Base):
    __tablename__ = "groups"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    description = Column(String, nullable=True)
    avatar_url = Column(String, nullable=True)
    cover_image_url = Column(String, nullable=True)
    creator_id = Column(Integer, ForeignKey("users.id"))
    created_at = Column(DateTime, default=datetime.utcnow)
    is_public = Column(Boolean, default=True)
    is_verified = Column(Boolean, default=False)
    privacy_level = Column(Integer, default=0)  # 0: Public, 1: Private, 2: Hidden
    max_members = Column(Integer, default=1000)
    category = Column(String, nullable=True)
    rules = Column(String, nullable=True)  # JSON string for group rules
    
    # Relationships
    creator = relationship("User", back_populates="created_groups")
    members = relationship("GroupMember", back_populates="group")
    messages = relationship("Message", back_populates="group")
    events = relationship("Event", back_populates="group")
    polls = relationship("Poll", back_populates="group")
    scheduled_posts = relationship("ScheduledPost", back_populates="group")
```

### GroupMember
```python
class GroupMember(Base):
    __tablename__ = "group_members"
    
    id = Column(Integer, primary_key=True, index=True)
    group_id = Column(Integer, ForeignKey("groups.id"))
    user_id = Column(Integer, ForeignKey("users.id"))
    role = Column(String, default="member")  # member, moderator, admin, owner
    joined_at = Column(DateTime, default=datetime.utcnow)
    is_muted = Column(Boolean, default=False)
    is_banned = Column(Boolean, default=False)
    last_read_message_id = Column(Integer, nullable=True)
    
    # Relationships
    group = relationship("Group", back_populates="members")
    user = relationship("User", back_populates="groups")
```

### Notification
```python
class Notification(Base):
    __tablename__ = "notifications"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    type = Column(String, nullable=False)  # like, comment, follow, mention, etc.
    title = Column(String, nullable=True)
    content = Column(String, nullable=False)
    related_id = Column(Integer, nullable=True)  # ID of related object (post, comment, etc.)
    related_type = Column(String, nullable=True)  # Type of related object
    is_read = Column(Boolean, default=False)
    is_dismissed = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    action_url = Column(String, nullable=True)
    
    # Relationships
    user = relationship("User", back_populates="notifications")
```

### Achievement
```python
class Achievement(Base):
    __tablename__ = "achievements"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    description = Column(String, nullable=False)
    icon_url = Column(String, nullable=True)
    category = Column(String, nullable=False)  # social, creator, engagement, etc.
    points = Column(Integer, default=0)
    is_secret = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    user_achievements = relationship("UserAchievement", back_populates="achievement")
```

### UserAchievement
```python
class UserAchievement(Base):
    __tablename__ = "user_achievements"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    achievement_id = Column(Integer, ForeignKey("achievements.id"))
    earned_at = Column(DateTime, default=datetime.utcnow)
    is_hidden = Column(Boolean, default=False)
    
    # Relationships
    user = relationship("User", back_populates="achievements")
    achievement = relationship("Achievement", back_populates="user_achievements")
```

### Subscription
```python
class Subscription(Base):
    __tablename__ = "subscriptions"
    
    id = Column(Integer, primary_key=True, index=True)
    subscriber_id = Column(Integer, ForeignKey("users.id"))
    creator_id = Column(Integer, ForeignKey("users.id"))
    amount = Column(Float, nullable=False)
    currency = Column(String, default="USD")
    billing_cycle = Column(String, default="monthly")  # monthly, yearly
    started_at = Column(DateTime, default=datetime.utcnow)
    next_billing_at = Column(DateTime, nullable=False)
    is_active = Column(Boolean, default=True)
    cancelled_at = Column(DateTime, nullable=True)
    
    # Relationships
    subscriber = relationship("User", foreign_keys=[subscriber_id], back_populates="subscriptions")
    creator = relationship("User", foreign_keys=[creator_id], back_populates="subscribers")
    payments = relationship("SubscriptionPayment", back_populates="subscription")
```

### Transaction
```python
class Transaction(Base):
    __tablename__ = "transactions"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    type = Column(String, nullable=False)  # purchase, withdrawal, tip, boost, etc.
    amount = Column(Float, nullable=False)
    currency = Column(String, default="USD")
    status = Column(String, default="pending")  # pending, completed, failed, refunded
    description = Column(String, nullable=True)
    reference_id = Column(String, nullable=True)  # External payment reference
    created_at = Column(DateTime, default=datetime.utcnow)
    completed_at = Column(DateTime, nullable=True)
    
    # Relationships
    user = relationship("User", back_populates="transactions")
```

### CoinBalance
```python
class CoinBalance(Base):
    __tablename__ = "coin_balances"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), unique=True)
    balance = Column(Integer, default=0)
    last_updated = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    user = relationship("User", back_populates="coins_balance")
    coin_transactions = relationship("CoinTransaction", back_populates="coin_balance")
```

### CoinTransaction
```python
class CoinTransaction(Base):
    __tablename__ = "coin_transactions"
    
    id = Column(Integer, primary_key=True, index=True)
    coin_balance_id = Column(Integer, ForeignKey("coin_balances.id"))
    amount = Column(Integer, nullable=False)  # Positive for earning, negative for spending
    transaction_type = Column(String, nullable=False)  # earn, spend, gift, purchase
    description = Column(String, nullable=True)
    related_id = Column(Integer, nullable=True)  # ID of related object
    related_type = Column(String, nullable=True)  # Type of related object
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    coin_balance = relationship("CoinBalance", back_populates="coin_transactions")
```

### PostLike
```python
class PostLike(Base):
    __tablename__ = "post_likes"
    
    id = Column(Integer, primary_key=True, index=True)
    post_id = Column(Integer, ForeignKey("posts.id"))
    user_id = Column(Integer, ForeignKey("users.id"))
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    post = relationship("Post", back_populates="likes")
    user = relationship("User")
```

### PostShare
```python
class PostShare(Base):
    __tablename__ = "post_shares"
    
    id = Column(Integer, primary_key=True, index=True)
    post_id = Column(Integer, ForeignKey("posts.id"))
    user_id = Column(Integer, ForeignKey("users.id"))
    shared_at = Column(DateTime, default=datetime.utcnow)
    share_text = Column(String, nullable=True)
    
    # Relationships
    post = relationship("Post", back_populates="shares")
    user = relationship("User")
```

### PostBookmark
```python
class PostBookmark(Base):
    __tablename__ = "post_bookmarks"
    
    id = Column(Integer, primary_key=True, index=True)
    post_id = Column(Integer, ForeignKey("posts.id"))
    user_id = Column(Integer, ForeignKey("users.id"))
    bookmarked_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    post = relationship("Post", back_populates="bookmarks")
    user = relationship("User")
```

### PostTag
```python
class PostTag(Base):
    __tablename__ = "post_tags"
    
    id = Column(Integer, primary_key=True, index=True)
    post_id = Column(Integer, ForeignKey("posts.id"))
    user_id = Column(Integer, ForeignKey("users.id"))
    tagged_at = Column(DateTime, default=datetime.utcnow)
    coordinates = Column(String, nullable=True)  # JSON string for x,y coordinates
    
    # Relationships
    post = relationship("Post", back_populates="tags")
    user = relationship("User")
```

### PostAnalytics
```python
class PostAnalytics(Base):
    __tablename__ = "post_analytics"
    
    id = Column(Integer, primary_key=True, index=True)
    post_id = Column(Integer, ForeignKey("posts.id"))
    views_count = Column(Integer, default=0)
    likes_count = Column(Integer, default=0)
    comments_count = Column(Integer, default=0)
    shares_count = Column(Integer, default=0)
    bookmarks_count = Column(Integer, default=0)
    completion_rate = Column(Float, default=0.0)  # For videos
    average_watch_time = Column(Float, default=0.0)  # For videos
    last_updated = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    post = relationship("Post", back_populates="analytics")
```

### ProfileView
```python
class ProfileView(Base):
    __tablename__ = "profile_views"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    viewer_id = Column(Integer, ForeignKey("users.id"), nullable=True)  # Null for anonymous
    viewed_at = Column(DateTime, default=datetime.utcnow)
    is_anonymous = Column(Boolean, default=False)
    
    # Relationships
    user = relationship("User", foreign_keys=[user_id], back_populates="profile_views")
    viewer = relationship("User", foreign_keys=[viewer_id])
```

### BlockedUser
```python
class BlockedUser(Base):
    __tablename__ = "blocked_users"
    
    id = Column(Integer, primary_key=True, index=True)
    blocker_id = Column(Integer, ForeignKey("users.id"))
    blocked_id = Column(Integer, ForeignKey("users.id"))
    blocked_at = Column(DateTime, default=datetime.utcnow)
    reason = Column(String, nullable=True)
    
    # Relationships
    blocker = relationship("User", foreign_keys=[blocker_id], back_populates="blocked_users")
    blocked = relationship("User", foreign_keys=[blocked_id], back_populates="blocked_by")
```

### UserPreference
```python
class UserPreference(Base):
    __tablename__ = "user_preferences"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), unique=True)
    notification_settings = Column(String, nullable=True)  # JSON string for notification preferences
    privacy_settings = Column(String, nullable=True)  # JSON string for privacy preferences
    content_preferences = Column(String, nullable=True)  # JSON string for content preferences
    language_preferences = Column(String, nullable=True)  # JSON string for language preferences
    accessibility_settings = Column(String, nullable=True)  # JSON string for accessibility preferences
    last_updated = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    user = relationship("User", back_populates="preferences")
```

### UserDevice
```python
class UserDevice(Base):
    __tablename__ = "user_devices"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    device_id = Column(String, nullable=False)
    device_type = Column(String, nullable=False)  # mobile, tablet, desktop
    os = Column(String, nullable=True)
    browser = Column(String, nullable=True)
    ip_address = Column(String, nullable=True)
    last_active = Column(DateTime, default=datetime.utcnow)
    is_active = Column(Boolean, default=True)
    
    # Relationships
    user = relationship("User", back_populates="devices")
```

### UserSession
```python
class UserSession(Base):
    __tablename__ = "user_sessions"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    session_token = Column(String, nullable=False)
    device_id = Column(String, nullable=True)
    ip_address = Column(String, nullable=True)
    user_agent = Column(String, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    expires_at = Column(DateTime, nullable=False)
    is_active = Column(Boolean, default=True)
    
    # Relationships
    user = relationship("User", back_populates="sessions")