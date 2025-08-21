"""
Main FastAPI application for TRENDY App
Complete implementation with all enhanced features
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from app.db.database import engine, Base
from app.routes import (
    agora,
    followers_new,
    user_relationships,
    enhanced_content,
    social_auth,
    email_verification
)

# Create all tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="TRENDY App API",
    description="Complete API for TRENDY social media platform",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include all routes
app.include_router(social_auth.router, prefix="/api/v1")
app.include_router(email_verification.router, prefix="/api/v1")
app.include_router(user_relationships.router, prefix="/api/v1")
app.include_router(enhanced_content.router, prefix="/api/v1")
app.include_router(followers_new.router, prefix="/api/v1")
app.include_router(agora.router, prefix="/api/v1")

# Health check endpoint
@app.get("/health")
async def health_check():
    return {"status": "healthy", "message": "TRENDY API is running"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
