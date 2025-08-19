from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import uvicorn
from app.database import engine, Base
from app.api import music, movies, football, photos, enhanced_endpoints, weather, news, crypto, ai_features, messages, groups, omnipotent_endpoints
from app.routes import posts, user, notifications, followers
from app.auth.utils import verify_token
from app.firebase.config import firebase_config

# Initialize database
Base.metadata.create_all(bind=engine)

# Initialize Firebase
firebase_config.initialize()

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
app.include_router(movies.router)
app.include_router(football.router, prefix="/api/football", tags=["football"])
app.include_router(posts.router, prefix="/api", tags=["posts"])
app.include_router(user.router, prefix="/api/users", tags=["users"])
app.include_router(notifications.router, prefix="/api", tags=["notifications"])
app.include_router(followers.router, prefix="/api/users", tags=["followers"])
app.include_router(photos.router, prefix="/api/photos", tags=["photos"])
app.include_router(enhanced_endpoints.router, prefix="/api", tags=["enhanced"])
app.include_router(weather.router)
app.include_router(omnipotent_endpoints.router, prefix="/api", tags=["omnipotent"])
app.include_router(news.router)
app.include_router(crypto.router)
app.include_router(ai_features.router, prefix="/api", tags=["ai"])
app.include_router(messages.router, prefix="/api", tags=["messages"])
app.include_router(groups.router, prefix="/api", tags=["groups"])

@app.get("/")
async def root():
    return {"message": "Trendy Backend API is running", "status": "healthy"}

@app.get("/health")
async def health():
    return {"status": "ok", "timestamp": "2024"}

if __name__ == "__main__":
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=False
    )
