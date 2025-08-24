from fastapi import APIRouter, HTTPException, Query, Depends
from typing import List, Optional
from pydantic import BaseModel
from app.auth.middleware import get_current_user

router = APIRouter()

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

@router.get("/")
async def get_photos(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    category: Optional[str] = Query(None, description="Filter by category"),
    search: Optional[str] = Query(None, description="Search term")
):
    """Root photos endpoint expected by client: returns {photos: [...]}"""
    photos_list = MOCK_PHOTOS
    if category:
        photos_list = [p for p in photos_list if category.lower() in p.category.lower()]
    if search:
        q = search.lower()
        photos_list = [
            p for p in photos_list
            if q in p.title.lower()
            or q in p.description.lower()
            or any(q in t.lower() for t in p.tags)
        ]
    sliced = photos_list[skip:skip+limit]
    return {"photos": [p.dict() for p in sliced], "total": len(photos_list)}

@router.get("/trending", response_model=List[PhotoResponse])
async def get_trending_photos(
    limit: int = Query(20, ge=1, le=100),
    category: Optional[str] = Query(None, description="Filter by category")
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
    limit: int = Query(20, ge=1, le=100)
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
async def get_categories():
    """Get available photography categories"""
    categories = set()
    for photo in MOCK_PHOTOS:
        categories.add(photo.category)
    return sorted(list(categories))

@router.post("/like")
async def like_photo(
    request: dict
):
    """Like/unlike a photo"""
    # TODO: Store in user preferences
    return {
        "message": "Photo preference updated",
        "photo_id": request.get("photo_id"),
        "liked": request.get("liked")
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

