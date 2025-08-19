from sqlalchemy import Column, Integer, String, Boolean, DateTime, Text, Float, JSON
from sqlalchemy.sql import func
from .base import Base

class EnhancedPost(Base:
    __tablename__ = "enhanced_posts"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, nullable=False, index=True)
    
    # Content types
    post_type = Column(String(20), default="text")  # text, image, video, story, reel, live
    content = Column(Text)
    media_urls = Column(JSON)  # Array of media URLs
    thumbnail_url = Column(String(500))
    
    # TikTok features
    is_reel = Column(Boolean, default=False)
    reel_duration = Column(Integer)  # in seconds
    music_id = Column(String(100))
    music_start_time = Column(Float, default=0.0)
    effects_used = Column(JSON)  # Array of effect IDs
    
    # Instagram features
    is_story = Column(Boolean, default=False)
    story_expires_at = Column(DateTime(timezone=True))
    story_polls = Column(JSON)
    story_questions = Column(JSON)
    
    # Twitter features
    is_tweet = Column(Boolean, default=False)
    tweet_thread_id = Column(Integer)
    retweet_count = Column(Integer, default=0)
    quote_tweet_count = Column(Integer, default=0)
    
    # Facebook features
    is_facebook_post = Column(Boolean, default=False)
    facebook_audience = Column(String(20), default="public")  # public, friends, private
    
    # Spotify features
    spotify_track_id = Column(String(100))
    spotify_playlist_id = Column(String(100))
    
    # Monetization
    is_monetized = Column(Boolean, default=False)
    price = Column(Float, default=0.0)
    earnings = Column(Float, default=0.0)
    
    # Engagement metrics
    likes_count = Column(Integer, default=0)
    comments_count = Column(Integer, default=0)
    shares_count = Column(Integer, default=0)
    views_count = Column(Integer, default=0)
    
    # AI features
    ai_generated = Column(Boolean, default=False)
    ai_caption = Column(Text)
    ai_hashtags = Column(JSON)
    
    # Location
    location_name = Column(String(200))
    location_lat = Column(Float)
    location_lng = Column(Float)
    
    # Status
    is_published = Column(Boolean, default=True)
    is_archived = Column(Boolean, default=False)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
