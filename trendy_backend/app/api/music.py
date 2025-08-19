from fastapi import APIRouter, HTTPException
from datetime import datetime
import logging

router = APIRouter()
logger = logging.getLogger(__name__)

# Mock music dataset (stable, no DB dependencies)
MOCK_MUSIC = [
    {
        "id": 1,
        "title": "Neon Nights",
        "artist": "DJ Pulse",
        "album": "City Lights",
        "image_url": "https://picsum.photos/seed/neon/400/300",
        "audio_url": "https://www2.cs.uic.edu/~i101/SoundFiles/StarWars60.wav",
        "duration": "3:45",
        "created_at": datetime.utcnow().isoformat(),
        "user": {"id": 1, "username": "dj_pulse", "avatar_url": None},
        "likes": 120,
        "plays": 1024,
        "genre": "EDM",
    },
    {
        "id": 2,
        "title": "Golden Hour",
        "artist": "Luna Sky",
        "album": "Horizons",
        "image_url": "https://picsum.photos/seed/golden/400/300",
        "audio_url": "https://www2.cs.uic.edu/~i101/SoundFiles/ImperialMarch60.wav",
        "duration": "4:10",
        "created_at": datetime.utcnow().isoformat(),
        "user": {"id": 2, "username": "luna", "avatar_url": None},
        "likes": 230,
        "plays": 5432,
        "genre": "Pop",
    },
    {
        "id": 3,
        "title": "Midnight Drive",
        "artist": "The Vibes",
        "album": "Routes",
        "image_url": "https://picsum.photos/seed/midnight/400/300",
        "audio_url": "https://www2.cs.uic.edu/~i101/SoundFiles/StarWars60.wav",
        "duration": "2:58",
        "created_at": datetime.utcnow().isoformat(),
        "user": {"id": 3, "username": "vibes", "avatar_url": None},
        "likes": 75,
        "plays": 850,
        "genre": "Hip-Hop",
    },
]

GENRES = ["Pop", "Rock", "Hip-Hop", "Jazz", "Classical", "EDM"]

@router.get("/")
async def get_music(skip: int = 0, limit: int = 20, genre: str | None = None, search: str | None = None):
    items = MOCK_MUSIC
    if genre:
        items = [m for m in items if m.get("genre", "").lower() == genre.lower()]
    if search:
        q = search.lower()
        items = [m for m in items if q in m["title"].lower() or q in m["artist"].lower()]
    total = len(items)
    items = items[skip: skip + limit]
    return {"music": items, "total": total}

@router.get("/trending")
async def get_trending_music():
    # Simple sort by plays/likes
    items = sorted(MOCK_MUSIC, key=lambda m: (m.get("plays", 0), m.get("likes", 0)), reverse=True)
    return {"music": items[:10]}

@router.get("/genres")
async def get_genres():
    """Get music genres - hardened against unexpected errors"""
    try:
        logger.info("Fetching music genres")
        return {"genres": GENRES}
    except Exception as e:
        logger.error(f"Error fetching genres: {str(e)}")
        raise HTTPException(status_code=500, detail="Internal server error")
