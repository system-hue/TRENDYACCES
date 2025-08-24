#!/usr/bin/env python3
"""
Simple test to verify basic backend functionality without complex dependencies
"""

import sys
import os

# Add the trendy_backend directory to Python path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'trendy_backend'))

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="TRENDY App API - Test",
    description="Simple test API for TRENDY backend",
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

# Simple health check endpoint
@app.get("/health")
async def health_check():
    return {"status": "healthy", "message": "TRENDY API test is running"}

# Simple test endpoint
@app.get("/test")
async def test_endpoint():
    return {"message": "Backend is working!", "success": True}

if __name__ == "__main__":
    import uvicorn
    print("🚀 Starting simple backend test server...")
    print("📡 Server will be available at: http://localhost:8000")
    print("🔗 Health check: http://localhost:8000/health")
    print("🔗 Test endpoint: http://localhost:8000/test")
    print("⏹️  Press Ctrl+C to stop the server")
    uvicorn.run(app, host="0.0.0.0", port=8000)
