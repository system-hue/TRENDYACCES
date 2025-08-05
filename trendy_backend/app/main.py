from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routes import user, posts, followers, notifications, ai_moderation
from app.api import music, movies, shop

app = FastAPI(
    title="Trendy Backend API",
    description="Full-featured backend for the Trendy social media app",
    version="1.0.0"
)

origins = [
    "http://localhost",
    "http://localhost:8080",
    "http://localhost:3000",
    "https://trendy-app.com",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include all route modules
app.include_router(user.router)
app.include_router(posts.router)
app.include_router(followers.router)
app.include_router(notifications.router)
app.include_router(ai_moderation.router)

# Include new API modules
app.include_router(music.router)
app.include_router(movies.router)
app.include_router(shop.router)
