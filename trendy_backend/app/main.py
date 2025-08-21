"""
Trendy Backend API - Complete Production-Ready FastAPI Application
All endpoints implemented and tested for immediate deployment
"""

from fastapi import FastAPI, HTTPException, Depends, Request, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi.staticfiles import StaticFiles
from fastapi.responses import JSONResponse
import uvicorn
from contextlib import asynccontextmanager
import time
import logging

from app.core.config import settings
from app.core.logging import get_logger, setup_logging
from app.core.telemetry import setup_telemetry
from app.core.cache import cache_manager
from app.core.rate_limit import RateLimitMiddleware
from app.auth.firebase import verify_firebase_token, get_current_user
from app.db.session import get_db
from app.services.health_service import HealthService

# Import all routers
from app.routes import (
    auth, users, posts, notifications, followers, messages, groups,
    music, movies, photos, sports, weather, news, crypto, ai,
    monetization, omnipost, analytics, admin
)

logger = get_logger(__name__)

security = HTTPBearer()

@asynccontextmanager
async def lifespan(app: FastAPI):
    """Manage application lifespan with proper startup/shutdown procedures."""
    # Startup
    try:
        setup_logging()
        await cache_manager.connect()
        
        # Initialize services
        health_service = HealthService()
        await health_service.initialize()
        
        logger.info("🚀 Trendy Backend starting up...")
        logger.info(f"Environment: {settings.env}")
        logger.info(f"Debug mode: {settings.debug}")
        
        yield
        
    except Exception as e:
        logger.error(f"❌ Startup error: {e}")
        raise
    finally:
        # Shutdown
        await cache_manager.disconnect()
        logger.info("👋 Trendy Backend shutting down...")

# Create FastAPI application
app = FastAPI(
    title="Trendy Backend API",
    description="""
    Complete production-ready backend for Trendy social media application.
    
    Features:
    - 🔐 Firebase Authentication
    - 🎵 Music API Integration (Spotify/YouTube)
    - 🎬 Movies API Integration (TMDB)
    - 📸 Photos API Integration
    - 📝 Universal Posting System
    - 💰 Monetization (AdMob + In-App Purchases)
    - 🤖 AI Automation
    - 📊 Analytics & Monitoring
    - 🔔 Push Notifications
    - 🚀 Real-time Features
    """,
    version="2.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan
)

# Setup telemetry and monitoring
setup_telemetry(app)

# Configure CORS for production
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",
        "http://localhost:8080",
        "https://trendyapp.com",
        "https://www.trendyapp.com",
        "https://trendy-frontend.vercel.app",
    ],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"],
    allow_headers=["*"],
)

# Add rate limiting
app.add_middleware(RateLimitMiddleware)

# Global exception handler
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    """Handle all unhandled exceptions."""
    logger.error(f"Unhandled exception: {exc}", exc_info=True)
    return JSONResponse(
        status_code=500,
        content={
            "detail": "Internal server error",
            "error_id": str(time.time())
        }
    )

# Health check endpoints
@app.get("/", tags=["root"])
async def root():
    """Root endpoint with API information."""
    return {
        "message": "🎯 Trendy Backend API is running",
        "status": "healthy",
        "version": "2.0.0",
        "environment": settings.env,
        "docs": "/docs",
        "health": "/health"
    }

@app.get("/health", tags=["health"])
async def health_check():
    """Comprehensive health check endpoint."""
    try:
        health_service = HealthService()
        return await health_service.get_health_status()
    except Exception as e:
        logger.error(f"Health check failed: {e}")
        raise HTTPException(status_code=503, detail="Service unavailable")

@app.get("/health/detailed", tags=["health"])
async def detailed_health_check():
    """Detailed health check with all services."""
    try:
        health_service = HealthService()
        return await health_service.get_detailed_health()
    except Exception as e:
        logger.error(f"Detailed health check failed: {e}")
        raise HTTPException(status_code=503, detail="Service unavailable")

# Mount static files
app.mount("/static", StaticFiles(directory="static"), name="static")

# Include all routers with proper prefixes
routers = [
    # Authentication
    (auth.router, "/api/auth", ["authentication"]),
    (users.router, "/api/users", ["users"]),
    
    # Content APIs
    (music.router, "/api/music", ["music"]),
    (movies.router, "/api/movies", ["movies"]),
    (photos.router, "/api/photos", ["photos"]),
    (sports.router, "/api/sports", ["sports"]),
    
    # Social Features
    (posts.router, "/api/posts", ["posts"]),
    (omnipost.router, "/api/omnipost", ["omnipost"]),
    (followers.router, "/api/followers", ["followers"]),
    (messages.router, "/api/messages", ["messages"]),
    (groups.router, "/api/groups", ["groups"]),
    
    # Notifications & Real-time
    (notifications.router, "/api/notifications", ["notifications"]),
    
    # Monetization
    (monetization.router, "/api/monetization", ["monetization"]),
    
    # AI Features
    (ai.router, "/api/ai", ["ai"]),
    
    # Analytics & Admin
    (analytics.router, "/api/analytics", ["analytics"]),
    (admin.router, "/api/admin", ["admin"]),
    
    # Utility APIs
    (weather.router, "/api/weather", ["weather"]),
    (news.router, "/api/news", ["news"]),
    (crypto.router, "/api/crypto", ["crypto"]),
]

for router, prefix, tags in routers:
    app.include_router(router, prefix=prefix, tags=tags)

# System configuration endpoint
@app.get("/api/system/config", tags=["system"])
async def get_system_config(current_user: dict = Depends(get_current_user)):
    """Get system configuration and feature flags."""
    return {
        "features": {
            "authentication": True,
            "music_api": True,
            "movies_api": True,
            "photos_api": True,
            "omnipost": True,
            "real_time_messaging": True,
            "push_notifications": True,
            "monetization": True,
            "ai_features": True,
            "analytics": True,
            "admin_panel": True,
        },
        "limits": {
            "max_file_size": "50MB",
            "max_posts_per_day": 100,
            "max_messages_per_minute": 30,
            "max_api_calls_per_hour": 1000,
        },
        "environment": settings.env,
        "version": "2.0.0",
    }

# API documentation customization
@app.get("/api", tags=["api"])
async def api_info():
    """API information and quick start guide."""
    return {
        "name": "Trendy Backend API",
        "version": "2.0.0",
        "documentation": {
            "swagger_ui": "/docs",
            "redoc": "/redoc",
            "openapi_json": "/openapi.json",
        },
        "authentication": {
            "type": "Firebase Auth",
            "header": "Authorization: Bearer <firebase_token>",
        },
        "base_url": "https://api.trendyapp.com",
        "endpoints": {
            "auth": "/api/auth",
            "users": "/api/users",
            "posts": "/api/posts",
            "music": "/api/music",
            "movies": "/api/movies",
            "photos": "/api/photos",
            "ai": "/api/ai",
            "monetization": "/api/monetization",
        },
    }

if __name__ == "__main__":
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=settings.debug,
        log_level="info"
    )
