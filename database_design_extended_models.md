# Trendy - Extended Database Models

## Extended Models

### User (Extended)
```python
class User(Base):
    __tablename__ = "users"
    
    # Existing fields
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    username = Column(String, unique=True, index=True, nullable=False)
    password = Column(String, nullable=False)
    profile_image = Column(String, nullable=True)
    avatar_url = Column(String, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Extended fields
    bio = Column(String, nullable=True)
    location = Column(String, nullable=True)
    website = Column(String, nullable=True)
    birth_date = Column(Date, nullable=True)
    phone_number = Column(String, nullable=True)
    is_verified = Column(Boolean, default=False)
    verification_level = Column(Integer, default=0)  # 0: None, 1: Email, 2: Phone, 3: ID
    is_creator = Column(Boolean, default=False)
    is_pro_account = Column(Boolean, default=False)
    privacy_level = Column(Integer, default=0)  # 0: Public, 1: Friends, 2: Private
    last_active = Column(DateTime, nullable=True)
    preferred_language = Column(String, default="en")
    timezone = Column(String, default="UTC")
    profile_theme = Column(String, nullable=True)  # JSON string for theme settings
    profile_background = Column(String, nullable=True)  # URL to background image/video
    music_signature = Column(String, nullable=True)  # URL to signature music
    is_invisible = Column(Boolean, default=False)
    vault_enabled = Column(Boolean, default=False)
    vault_password_hash = Column(String, nullable=True)
    
    # Relationships
    posts = relationship("Post", back_populates="user")
    comments = relationship("Comment", back_populates="owner")
    followers = relationship("Follower", foreign_keys="[Follower.followed_id]", back_populates="followed")
    following = relationship("Follower", foreign_keys="[Follower.follower_id]", back_populates="follower")
    sent_messages = relationship("Message", foreign_keys="[Message.sender_id]", back_populates="sender")
    received_messages = relationship("Message", foreign_keys="[Message.receiver_id]", back_populates="receiver")
    notifications = relationship("Notification", back_populates="user")
    achievements = relationship("UserAchievement", back_populates="user")
    subscriptions = relationship("Subscription", foreign_keys="[Subscription.subscriber_id]", back_populates="subscriber")
    subscribers = relationship("Subscription", foreign_keys="[Subscription.creator_id]", back_populates="creator")
    transactions = relationship("Transaction", back_populates="user")
    coins_balance = relationship("CoinBalance", back_populates="user", uselist=False)
    profile_views = relationship("ProfileView", back_populates="user")
    blocked_users = relationship("BlockedUser", foreign_keys="[BlockedUser.blocker_id]", back_populates="blocker")
    blocked_by = relationship("BlockedUser", foreign_keys="[BlockedUser.blocked_id]", back_populates="blocked")
    groups = relationship("GroupMember", back_populates="user")
    created_groups = relationship("Group", back_populates="creator")
    events = relationship("Event", back_populates="creator")
    event_attendances = relationship("EventAttendance", back_populates="user")
    challenges = relationship("ChallengeParticipation", back_populates="user")
    streaks = relationship("UserStreak", back_populates="user")
    preferences = relationship("UserPreference", back_populates="user", uselist=False)
    devices = relationship("UserDevice", back_populates="user")
    sessions = relationship("UserSession", back_populates="user")
```

### Post (Extended)
```python
class Post(Base):
    __tablename__ = "posts"
    
    # Existing fields
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    content = Column(String, nullable=False)
    image_url = Column(String, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    category = Column(String, nullable=False, default="general")
    type = Column(String, nullable=False, default="post")
    likes_count = Column(Integer, default=0)
    views_count = Column(Integer, default=0)
    
    # Extended fields
    title = Column(String, nullable=True)
    video_url = Column(String, nullable=True)
    audio_url = Column(String, nullable=True)
    location = Column(String, nullable=True)  # JSON string for coordinates
    mood = Column(String, nullable=True)  # e.g., "happy", "sad", "excited"
    is_edited = Column(Boolean, default=False)
    edited_at = Column(DateTime, nullable=True)
    scheduled_at = Column(DateTime, nullable=True)
    expires_at = Column(DateTime, nullable=True)
    is_draft = Column(Boolean, default=False)
    is_collaborative = Column(Boolean, default=False)
    collaborative_editors = Column(String, nullable=True)  # JSON array of user IDs
    privacy_level = Column(Integer, default=0)  # 0: Public, 1: Friends, 2: Private, 3: Custom
    custom_audience = Column(String, nullable=True)  # JSON array of user IDs
    hashtags = Column(String, nullable=True)  # JSON array of hashtags
    mentions = Column(String, nullable=True)  # JSON array of mentioned user IDs
    language = Column(String, default="en")
    translation_status = Column(Integer, default=0)  # 0: Not translated, 1: Translated, 2: Auto-translated
    translated_content = Column(String, nullable=True)
    ai_generated = Column(Boolean, default=False)
    ai_prompt = Column(String, nullable=True)
    remix_of = Column(Integer, ForeignKey("posts.id"), nullable=True)  # For remixes/duets
    is_remix = Column(Boolean, default=False)
    is_paid = Column(Boolean, default=False)
    price = Column(Float, nullable=True)
    currency = Column(String, default="USD")
    is_nft = Column(Boolean, default=False)
    nft_metadata = Column(String, nullable=True)  # JSON string for NFT details
    
    # Relationships
    user = relationship("User", back_populates="posts")
    comments = relationship("Comment", back_populates="post")
    likes = relationship("PostLike", back_populates="post")
    shares = relationship("PostShare", back_populates="post")
    bookmarks = relationship("PostBookmark", back_populates="post")
    remixes = relationship("Post", back_populates="remixed_from")
    remixed_from = relationship("Post", back_populates="remixes", remote_side=[id])
    tags = relationship("PostTag", back_populates="post")
    analytics = relationship("PostAnalytics", back_populates="post", uselist=False)