#!/usr/bin/env python3
"""
Simple script to check posts in the database
"""

import sys
import os

# Add the trendy_backend directory to the Python path
sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'trendy_backend'))

from app.database import SessionLocal
from app.models.post import Post

def check_posts():
    db = SessionLocal()
    try:
        posts = db.query(Post).all()
        print(f'Total posts: {len(posts)}')
        
        for post in posts:
            print(f'ID: {post.id}')
            print(f'Content: {post.content[:200]}...')
            print(f'Has Director: {"Director:" in post.content}')
            print(f'Has Rating: {"Rating:" in post.content}')
            print('---')
            
    finally:
        db.close()

if __name__ == "__main__":
    check_posts()
