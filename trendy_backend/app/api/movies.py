from fastapi import APIRouter, HTTPException, Query, Depends
from typing import List, Optional
from pydantic import BaseModel
from app.auth.jwt_handler import get_current_user

router = APIRouter(prefix="/movies", tags=["movies"])

class MovieResponse(BaseModel):
    id: str
    title: str
    year: int
    genre: List[str]
    director: str
    cast: List[str]
    duration: int
    rating: float
    poster_url: str
    trailer_url: str
    trending_score: float = 0.0
    description: str
    release_date: str

class WatchlistRequest(BaseModel):
    movie_id: str
    action: str  # "add" or "remove"

class MovieHistoryRequest(BaseModel):
    movie_id: str
    watched_duration: int
    completion_rate: float

class MovieSearchRequest(BaseModel):
    query: str
    genre: Optional[str] = None
    year: Optional[int] = None
    limit: int = 20

# Mock data - replace with actual movie API integration
MOCK_MOVIES = [
    MovieResponse(
        id="1",
        title="Inception",
        year=2010,
        genre=["Sci-Fi", "Action", "Thriller"],
        director="Christopher Nolan",
        cast=["Leonardo DiCaprio", "Marion Cotillard", "Tom Hardy"],
        duration=148,
        rating=8.8,
        poster_url="https://example.com/poster1.jpg",
        trailer_url="https://example.com/trailer1.mp4",
        trending_score=92.3,
        description="A thief who steals corporate secrets through dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.",
        release_date="2010-07-16"
    ),
    MovieResponse(
        id="2",
        title="The Matrix",
        year=1999,
        genre=["Action", "Sci-Fi"],
        director="Lana Wachowski, Lilly Wachowski",
        cast=["Keanu Reeves", "Laurence Fishburne", "Carrie-Anne Moss"],
        duration=136,
        rating=8.7,
        poster_url="https://example.com/poster2.jpg",
        trailer_url="https://example.com/trailer2.mp4",
        trending_score=89.7,
        description="A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.",
        release_date="1999-03-31"
    ),
    MovieResponse(
        id="3",
        title="Interstellar",
        year=2014,
        genre=["Adventure", "Drama", "Sci-Fi"],
        director="Christopher Nolan",
        cast=["Matthew McConaughey", "Anne Hathaway", "Jessica Chastain"],
        duration=169,
        rating=8.6,
        poster_url="https://example.com/poster3.jpg",
        trailer_url="https://example.com/trailer3.mp4",
        trending_score=91.2,
        description="A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.",
        release_date="2014-11-07"
    ),
    MovieResponse(
        id="4",
        title="The Dark Knight",
        year=2008,
        genre=["Action", "Crime", "Drama"],
        director="Christopher Nolan",
        cast=["Christian Bale", "Heath Ledger", "Aaron Eckhart"],
        duration=152,
        rating=9.0,
        poster_url="https://example.com/poster4.jpg",
        trailer_url="https://example.com/trailer4.mp4",
        trending_score=94.8,
        description="When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.",
        release_date="2008-07-18"
    ),
    MovieResponse(
        id="5",
        title="Pulp Fiction",
        year=1994,
        genre=["Crime", "Drama"],
        director="Quentin Tarantino",
        cast=["John Travolta", "Uma Thurman", "Samuel L. Jackson"],
        duration=154,
        rating=8.9,
        poster_url="https://example.com/poster5.jpg",
        trailer_url="https://example.com/trailer5.mp4",
        trending_score=93.1,
        description="The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.",
        release_date="1994-10-14"
    )
]

@router.get("/popular", response_model=List[MovieResponse])
async def get_popular_movies(
    limit: int = Query(20, ge=1, le=100),
    genre: Optional[str] = Query(None, description="Filter by genre"),
    current_user: dict = Depends(get_current_user)
):
    """Get popular movies based on current popularity"""
    movies_list = MOCK_MOVIES
    
    if genre:
        movies_list = [movie for movie in movies_list if genre.lower() in [g.lower() for g in movie.genre]]
    
    return sorted(movies_list, key=lambda x: x.trending_score, reverse=True)[:limit]

@router.get("/search", response_model=List[MovieResponse])
async def search_movies(
    q: str = Query(..., min_length=2, description="Search query"),
    genre: Optional[str] = Query(None, description="Filter by genre"),
    year: Optional[int] = Query(None, description="Filter by release year"),
    limit: int = Query(20, ge=1, le=100),
    current_user: dict = Depends(get_current_user)
):
    """Search movies by title, genre, cast, or director"""
    query = q.lower()
    movies_list = MOCK_MOVIES
    
    if genre:
        movies_list = [movie for movie in movies_list if genre.lower() in [g.lower() for g in movie.genre]]
    
    if year:
        movies_list = [movie for movie in movies_list if movie.year == year]
    
    return [
        movie for movie in movies_list
        if query in movie.title.lower() or 
           any(query in cast_member.lower() for cast_member in movie.cast) or
           query in movie.director.lower() or
           any(query in g.lower() for g in movie.genre)
    ][:limit]

@router.get("/recommendations", response_model=List[MovieResponse])
async def get_movie_recommendations(
    genre: Optional[str] = Query(None, description="Preferred genre"),
    mood: Optional[str] = Query(None, description="Current mood"),
    limit: int = Query(10, ge=1, le=50),
    current_user: dict = Depends(get_current_user)
):
    """Get personalized movie recommendations"""
    # TODO: Implement ML-based recommendations using user history
    movies_list = MOCK_MOVIES
    
    if genre:
        movies_list = [movie for movie in movies_list if genre.lower() in [g.lower() for g in movie.genre]]
    
    return sorted(movies_list, key=lambda x: x.trending_score, reverse=True)[:limit]

@router.post("/watchlist")
async def manage_watchlist(
    request: WatchlistRequest,
    current_user: dict = Depends(get_current_user)
):
    """Add/remove movie from watchlist"""
    # TODO: Store in user watchlist database
    return {
        "message": f"Movie {request.action}ed from watchlist",
        "movie_id": request.movie_id,
        "action": request.action
    }

@router.post("/history")
async def track_movie_history(
    request: MovieHistoryRequest,
    current_user: dict = Depends(get_current_user)
):
    """Track user's movie watching history"""
    # TODO: Store viewing analytics in database
    return {
        "message": "History tracked",
        "movie_id": request.movie_id,
        "watched_duration": request.watched_duration,
        "completion_rate": request.completion_rate
    }

@router.get("/genres", response_model=List[str])
async def get_genres(current_user: dict = Depends(get_current_user)):
    """Get available movie genres"""
    genres = set()
    for movie in MOCK_MOVIES:
        for genre in movie.genre:
            genres.add(genre)
    return sorted(list(genres))

@router.get("/watchlist", response_modelI have successfully added the Music API module. Next, I will proceed to add the Movies API module to the backend.

<create_file>
<path>trendy_backend/app/api/movies.py</path>
<content>
from fastapi import APIRouter, HTTPException, Query, Depends
from typing import List, Optional
from pydantic import BaseModel
from app.auth.jwt_handler import get_current_user

router = APIRouter(prefix="/movies", tags=["movies"])

class MovieResponse(BaseModel):
    id: str
    title: str
    year: int
    genre: List[str]
    director: str
    cast: List[str]
    duration: int
    rating: float
    poster_url: str
    trailer_url: str
    trending_score: float = 0.0

class WatchlistRequest(BaseModel):
    movie_id: str
    action: str  # "add" or "remove"

class MovieHistoryRequest(BaseModel):
    movie_id: str
    watched_duration: int
    completion_rate: float

# Mock data - replace with actual movie API integration
MOCK_MOVIES = [
    MovieResponse(
        id="1",
        title="Inception",
        year=2010,
        genre=["Sci-Fi", "Action", "Thriller"],
        director="Christopher Nolan",
        cast=["Leonardo DiCaprio", "Marion Cotillard"],
        duration=148,
        rating=8.8,
        poster_url="https://example.com/poster1.jpg",
        trailer_url="https://example.com/trailer1.mp4",
        trending_score=92.3
    ),
    MovieResponse(
        id="2",
        title="The Matrix",
        year=1999,
        genre=["Action", "Sci-Fi"],
        director="Lana Wachowski, Lilly Wachowski",
        cast=["Keanu Reeves", "Laurence Fishburne"],
        duration=136,
        rating=8.7,
        poster_url="https://example.com/poster2.jpg",
        trailer_url="https://example.com/trailer2.mp4",
        trending_score=89.7
    )
]

@router.get("/popular", response_model=List[MovieResponse])
async def get_popular_movies(limit: int = Query(20, ge=1, le=100)):
    """Get popular movies"""
    return sorted(MOCK_MOVIES, key=lambda x: x.trending_score, reverse=True)[:limit]

@router.get("/search", response_model=List[MovieResponse])
async def search_movies(q: str = Query(..., min_length=2)):
    """Search movies by title, genre, or cast"""
    query = q.lower()
    return [
        movie for movie in MOCK_MOVIES
        if query in movie.title.lower() or 
           any(query in genre.lower() for genre in movie.genre) or
           any(query in cast_member.lower() for cast_member in movie.cast)
    ]

@router.get("/recommendations", response_model=List[MovieResponse])
async def get_movie_recommendations(current_user: dict = Depends(get_current_user)):
    """Get personalized movie recommendations"""
    # TODO: Implement ML-based recommendations
    return MOCK_MOVIES[:5]

@router.post("/watchlist")
async def manage_watchlist(request: WatchlistRequest, current_user: dict = Depends(get_current_user)):
    """Add/remove movie from watchlist"""
    # TODO: Store in user watchlist
    return {"message": f"Movie {request.action}ed from watchlist", "movie_id": request.movie_id}

@router.post("/history")
async def track_movie_history(request: MovieHistoryRequest, current_user: dict = Depends(get_current_user)):
    """Track user's movie watching history"""
    # TODO: Store viewing analytics
    return {"message": "History tracked", "movie_id": request.movie_id}
