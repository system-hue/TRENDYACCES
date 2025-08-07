from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import uvicorn
from app.database import engine, Base
from app.api import music, movies, football
from app.routes import posts, user, notifications, followers
from app.firebase.auth import verify_firebase_token
from app.firebase.config import initialize_firebase

# Initialize database
Base.metadata.create_all(bind=engine)

# Initialize Firebase
initialize_firebase()

app = FastAPI(
    title="Trendy Backend API",
    description="Backend API for Trendy social media app",
    version="1.0.0"
)

# Configure CORS for Flutter app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with your app domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(music.router, prefix="/api/music", tags=["music"])
app.include_router(movies.router, prefix="/api/movies", tags=["movies"])
app.include_router(football.router, prefix="/api/football", tags=["football"])
app.include_router(posts.router, prefix="/api/posts", tags=["posts"])
app.include_router(user.router, prefix="/api/users", tags=["users"])
app.include_router(notifications.router, prefix="/api/notifications", tags=["notifications"])
app.include_router(followers.router, prefix="/api/followers", tags=["followers"])

@app.get("/")
async def root():
    return {"message": "Trendy Backend API is running", "status": "healthy"}

@app.get("/health")
async def root():
    return {"status": "ok", "timestamp": "2024"}

if __name__ != "__main__":
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )
