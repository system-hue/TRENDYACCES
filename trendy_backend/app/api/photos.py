from fastapi import APIRouter, HTTPException, Query, Depends
from typing import List, Optional
from pydantic import BaseModel
from app.auth.jwt_handler import get_current_user

router = APIRouter(prefix="/photos", tags=["photos"])

class PhotoResponse(BaseModel):
    id: str
    title: str
    description: str
    photographer: str
    tags: List[str]
    category: str
    resolution: str
    file_size: int
    image_url: str
    thumbnail_url: str
    trending_score: float = 0.0
    upload_date: str
    location: Optional[str] = None
    camera: Optional[str] = None
    settings: Optional[str] = None

class PhotoLikeRequest(BaseModel):
    photo_id: str
    liked: bool

class PhotoSearchRequest(BaseModel):
    query: str
    category: Optional[str] = None
    photographer: Optional[str] = None
    limit: int = 20

# Mock data - replace with actual photography API integration
MOCK_PHOTOS = [
    PhotoResponse(
        id="1",
        title="Sunset Over Mountains",
        description="Beautiful sunset captured over mountain peaks",
        photographer="Jane Doe",
        tags=["sunset", "mountains", "landscape", "nature"],
        category="Landscape",
        resolution="4000x3000",
        file_size=5242880,
        image_url="https://example.com/photo1.jpg",
        thumbnail_url="https://example.com/thumb1.jpg",
        trending_score=89.5,
        upload_date="2024-01-15",
        location="Rocky Mountains, Colorado",
        camera="Canon EOS R5",
        settings="f/8, 1/125s, ISO 100"
    ),
    PhotoResponse(
        id="2",
        title="Urban Street Life",
        description="Street photography capturing city life",
        photographer="John Smith",
        tags=["street", "urban", "city", "people"],
        category="Street Photography",
        resolution="3000x2000",
        file_size=3145728,
        image_url="https://example.com/photo2.jpg",
        thumbnail_url="https://example.com/thumb2.jpg",
        trending_score=92.1,
        upload_date="2024-01-20",
        location="New York City",
        camera="Sony A7III",
        settings="f/2.8, 1/250s, ISO 400"
    ),
    PhotoResponse(
        id="3",
        title="Portrait of Nature",
        description="Stunning portrait with natural lighting",
        photographer="Alice Johnson",
        tags=["portrait", "natural", "lighting", "model"],
        category="Portrait",
        resolution="4000x6000",
        file_size=6291456,
        image_url="https://example.com/photo3.jpg",
        thumbnail_url="https://example.com/thumb3.jpg",
        trending_score=87.3,
        upload_date="2024-01-25",
        camera="Nikon Z9",
        settings="f/1.8, 1/200s, ISO 200"
    )
]

@router.get("/trending", response_model=List[PhotoResponse])
async def get_trending_photos(
    limit: int = Query(20, ge=1, le=100),
    category: Optional[str] = Query(None, description="Filter by category"),
    current_user: dict = Depends(get_current_user)
):
    """Get trending photos based on current popularity"""
    photos_list = MOCK_PHOTOS
    
    if category:
        photos_list = [photo for photo in photos_list if category.lower() in photo.category.lower()]
    
    return sorted(photos_list, key=lambda x: x.trending_score, reverse=True)[:limit]

@router.get("/search", response_model=List[PhotoResponse])
async def search_photos(
    q: str = Query(..., min_length=2, description="Search query"),
    category: Optional[str] = Query(None, description="Filter by category"),
    photographer: Optional[str] = Query(None, description="Filter by photographer"),
    limit: int = Query(20, ge=1, le=100),
    current_user: dict = Depends(get_current_user)
):
    """Search photos by title, tags, photographer, or category"""
    query = q.lower()
    results = []
    
    for photo in MOCK_PHOTOS:
        match = False
        
        # Check title
        if query in photo.title.lower():
            match = True
        
        # Check tags
        if any(query in tag.lower() for tag in photo.tags):
            match = True
            
        # Check photographer
        if photographer and photographer.lower() in photo.photographer.lower():
            match = True
        elif not photographer and query in photo.photographer.lower():
            match = True
            
        # Check category
        if category and category.lower() in photo.category.lower():
            match = True
        elif not category and query in photo.category.lower():
            match = True
            
        if match:
            results.append(photo)
    
    return results[:limit]

@router.get("/categories", response_model=List[str])
async def get_categories(current_user: dict = Depends(get_current_user)):
    """Get available photography categories"""
    categories = set()
    for photo in MOCK_PHOTOS:
        categories.add(photo.category)
    return sorted(list(categories))

@router.post("/like")
async def like_photo(
    request: dict,
    current_user: dict = Depends(get_current_user)
):
    """Like/unlike a photo"""
    # TODO: Store in user preferences
    return {
        "message": "Photo preference updated",
        "photo_id": request.get("photo_id"),
        "liked": request.get("liked"),
        "user_id": current_user.get("id")
    }

@router.get("/favorites", response_model=List[PhotoResponse])
async def get_favorite_photos(
    limit: int = Query(50, ge=1, le=100),
    current_user: dict = Depends(get_current_user)
):
    """Get user's favorite photos"""
    # TODO: Retrieve from user preferences
    return MOCK_PHOTOS[:5]  # Mock response

@router.get("/history", response_model=List[PhotoResponse])
async def get_photo_history(
    limit: int = Query(50, ge=1, le=100),
    current_user: dict = Depends(get_current_user)
):
    """Get user's photo viewing history"""
    # TODO: Retrieve from user history
    return MOCK_PHOTOS[:10]  # Mock response
It seems there is no photography API implemented yet in the backend. 

Here is the plan to proceed:

Information Gathered:
- ContentApiService.dart has API calls for music, movies, and photography endpoints.
- AudioPlayerService.dart provides audio player functionality.
- Backend has music.py and movies.py API modules with mock data and endpoints for trending, search, recommendations, etc.
- Photography API is missing in the backend.
- Screens for music, movies, and photography exist but are placeholders without real data or search functionality.
- Theming in main.dart uses Material3 with a seed color but no dark/light mode toggle yet.

Plan:
1. Backend:
   - Implement photography API module similar to music and movies with trending, search, and recommendations endpoints.
2. Frontend:
   - Update music_screen.dart, movies_screen.dart, photography_screen.dart to fetch and display real data from APIs.
   - Implement search functionality in these screens.
   - Integrate AudioPlayerService for playing music audio.
3. Theming:
   - Add dark/light mode toggle in main.dart and propagate theme changes app-wide.

Dependent Files:
- trendy_backend/app/api/photos.py (new)
- trendy/lib/screens/music_screen.dart
- trendy/lib/screens/movies_screen.dart
- trendy/lib/screens/photography_screen.dart
- trendy/lib/services/content_api_service.dart (if needed)
- trendy/lib/main.dart

Followup Steps:
- Implement backend photography API.
- Implement frontend API integration and UI updates.
- Implement audio player integration.
- Implement search functionality.
- Implement theming support with dark/light mode toggle.

Please confirm if I can proceed with this plan or if you want to adjust anything before I start implementing. 

<ask_followup_question>
<question>Do you confirm the plan to implement the photography API backend, update frontend screens with API integration, add audio player and search functionality, and add theming support with dark/light mode toggle?</question>
</ask_followup_question>
