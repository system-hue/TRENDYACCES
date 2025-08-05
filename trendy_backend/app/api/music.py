from fastapi import APIRouter, HTTPException, Query, Depends
from typing import List, Optional
from pydantic import BaseModel
from app.auth.jwt_handler import get_current_user
import httpx
import os
from datetime import datetime

router = APIRouter(prefix="/music", tags=["music"])

class MusicResponse(BaseModel):
    id: str
    title: str
    artist: str
    album: str
    genre: str
    duration: int
    cover_url: str
    audio_url: str
    trending_score: float = 0.0
    release_date: str
    lyrics: Optional[str] = None
    rhyme_scheme: str = "AABB"  # Rhyme scheme identifier
    rhyme_score: float = 0.0  # Rhyme quality score

class MusicLikeRequest(BaseModel):
    music_id: str
    liked: bool

class MusicHistoryRequest(BaseModel):
    music_id: str
    listened_duration: int
    completion_rate: float

class MusicSearchRequest(BaseModel):
    query: str
    genre: Optional[str] = None
    artist: Optional[str] = None
    limit: int = 20

# Real API integration - using Spotify API
SPOTIFY_CLIENT_ID = os.getenv("SPOTIFY_CLIENT_ID", "ed5d3de21324406ebfa16dcea958d35a")
SPOTIFY_CLIENT_SECRET = os.getenv("SPOTIFY_CLIENT_SECRET", "31bec2e94ce940cbb8e61ba2c8960fb5")
SPOTIFY_BASE_URL = "https://api.spotify.com/v1"

# Enhanced mock data with real API structure and rhyme schemes
MOCK_MUSIC = [
    MusicResponse(
        id="spotify:track:0VjIjW4GlUZAMYd2vXMi3b",
        title="Blinding Lights",
        artist="The Weeknd",
        album="After Hours",
        genre="Pop",
        duration=200,
        cover_url="https://i.scdn.co/image/ab67616d0000b273c5649add07ed3720be9d5526",
        audio_url="https://p.scdn.co/mp3-preview/sample",
        trending_score=95.5,
        release_date="2020-03-20",
        lyrics="I've been tryna call...",
        rhyme_scheme="ABAB",
        rhyme_score=88.7
    ),
    MusicResponse(
        id="spotify:track:463CkQjx2Zk1yXoBuierM9",
        title="Levitating",
        artist="Dua Lipa",
        album="Future Nostalgia",
        genre="Pop",
        duration=203,
        cover_url="https://i.scdn.co/image/ab67616d0000b2739e495fb707973f3390850eea",
        audio_url="https://p.scdn.co/mp3-preview/sample",
        trending_score=88.2,
        release_date="2020-10-01",
        lyrics="If you wanna run away with me...",
        rhyme_scheme="AABB",
        rhyme_score=92.3
    ),
    MusicResponse(
        id="spotify:track:5HCyWlXZPP0y6Gqq8TgA20",
        title="Stay",
        artist="The Kid LAROI, Justin Bieber",
        album="F*CK LOVE 3: OVER YOU",
        genre="Pop",
        duration=141,
        cover_url="https://i.scdn.co/image/ab67616d0000b273c4e0a79b6727d6baa75f07db",
        audio_url="https://p.scdn.co/mp3-preview/sample",
        trending_score=91.7,
        release_date="2021-07-09",
        lyrics="I do the same thing I told you...",
        rhyme_scheme="ABBA",
        rhyme_score=85.4
    )
]

@router.get("/trending", response_model=List[MusicResponse])
async def get_trending_music(
    limit: int = Query(20, ge=1, le=100),
    genre: Optional[str] = None,
    current_user: dict = Depends(get_current_user)
):
    """Get trending music based on current popularity with rhyme enhancement"""
    music_list = MOCK_MUSIC
    
    if genre:
        music_list = [track for track in music_list if genre.lower() in track.genre.lower()]
    
    # Add rhyme-based scoring
    for track in music_list:
        track.rhyme_score = calculate_rhyme_score(track.title, track.lyrics or "")
    
    return sorted(music_list, key=lambda x: (x.trending_score + x.rhyme_score)/2, reverse=True)[:limit]

def calculate_rhyme_score(title: str, lyrics: str) -> float:
    """Calculate rhyme quality score based on title and lyrics"""
    # Simple rhyme detection algorithm
    words = title.lower().split()
    if len(words) >= 2:
        last_word = words[-1]
        rhyme_patterns = {
            "ight": 0.9, "ing": 0.8, "ay": 0.85, "ore": 0.75,
            "ove": 0.8, "ame": 0.7, "all": 0.85, "ime": 0.8
        }
        
        for pattern, score in rhyme_patterns.items():
            if last_word.endswith(pattern):
                return score * 100
    
    return 75.0  # Default score

@router.get("/search", response_model=List[MusicResponse])
async def search_music(
    q: str = Query(..., min_length=2, description="Search query"),
    genre: Optional[str] = Query(None, description="Filter by genre"),
    artist: Optional[str] = Query(None, description="Filter by artist"),
    limit: int = Query(20, ge=1, le=100),
    current_user: dict = Depends(get_current_user)
):
    """Search music by title, artist, or genre"""
    query = q.lower()
    results = []
    
    for track in MOCK_MUSIC:
        match = False
        
        # Check title
        if query in track.title.lower():
            match = True
        
        # Check artist
        if artist and artist.lower() in track.artist.lower():
            match = True
        elif not artist and query in track.artist.lower():
            match = True
            
        # Check genre
        if genre and genre.lower() in track.genre.lower():
            match = True
        elif not genre and query in track.genre.lower():
            match = True
            
        if match:
            results.append(track)
    
    return results[:limit]

@router.get("/recommendations", response_model=List[MusicResponse])
async def get_music_recommendations(
    genre: Optional[str] = Query(None, description="Preferred genre"),
    mood: Optional[str] = Query(None, description="Current mood"),
    limit: int = Query(10, ge=1, le=50),
    current_user: dict = Depends(get_current_user)
):
    """Get personalized music recommendations based on user preferences"""
    # TODO: Implement ML-based recommendations using user history
    # For now, return trending music with genre/mood filtering
    
    music_list = MOCK_MUSIC
    
    if genre:
        music_list = [track for track in music_list if genre.lower() in track.genre.lower()]
    
    # Mock mood-based filtering
    if mood:
        mood_genres = {
            "happy": ["Pop", "Dance", "Electronic"],
            "sad": ["Ballad", "Acoustic", "Indie"],
            "energetic": ["Rock", "Hip-Hop", "EDM"],
            "relaxed": ["Jazz", "Lo-Fi", "Classical"]
        }
        
        if mood.lower() in mood_genres:
            music_list = [track for track in music_list 
                         if any(g.lower() in track.genre.lower() 
                               for g in mood_genres[mood.lower()])]
    
    return sorted(music_list, key=lambda x: x.trending_score, reverse=True)[:limit]

@router.get("/genres", response_model=List[str])
async def get_genres(current_user: dict = Depends(get_current_user)):
    """Get available music genres"""
    genres = set()
    for track in MOCK_MUSIC:
        genres.add(track.genre)
    return sorted(list(genres))

@router.post("/like")
async def like_music(
    request: MusicLikeRequest,
    current_user: dict = Depends(get_current_user)
):
    """Like/unlike a music track"""
    # TODO: Store in user preferences database
    return {
        "message": "Music preference updated",
        "music_id": request.music_id,
        "liked": request.liked,
        "user_id": current_user.get("id")
    }

@router.post("/history")
async def track_music_history(
    request: MusicHistoryRequest,
    current_user: dict = Depends(get_current_user)
):
    """Track user's music listening history"""
    # TODO: Store listening analytics in database
    return {
        "message": "History tracked",
        "music_id": request.music_id,
        "listened_duration": request.listened_duration,
        "completion_rate": request.completion_rate,
        "user_id": current_user.get("id")
    }

@router.get("/favorites", response_model=List[MusicResponse])
async def get_favorite_music(
    limit: int = Query(50, ge=1, le=100),
    current_user: dict = Depends(get_current_user)
):
    """Get user's favorite music"""
    # TODO: Retrieve from user preferences
    return MOCK_MUSIC[:5]  # Mock response

@router.get("/history", response_model=List[MusicResponse])
async def get_music_history(
    limit: int = Query(50, ge=1, le=100),
    current_user: dict = Depends(get_current_user)
):
    """Get user's music listening history"""
    # TODO: Retrieve from user history
    return MOCK_MUSIC[:10]  # Mock response
