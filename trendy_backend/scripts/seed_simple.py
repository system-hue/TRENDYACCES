#!/usr/bin/env python3
"""
Simple Database Seeding Script for Trendy App
"""

import os
import sys
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.database import Base, engine, SessionLocal
from app.models.post import Post
from app.models.user import User
from app.models.comment import Comment
from app.models.follower import Follower
import random
from datetime import datetime

def create_tables():
    """Create all database tables"""
    Base.metadata.create_all(bind=engine)
    print("✅ Database tables created successfully")

def create_users(db):
    """Create sample users"""
    users_data = [
        {"username": "trendy_user1", "email": "user1@trendy.com", "full_name": "Alex Johnson", "bio": "Music lover and movie enthusiast", "avatar_url": "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150"},
        {"username": "photo_master", "email": "photographer@trendy.com", "full_name": "Sarah Chen", "bio": "Professional photographer capturing moments", "avatar_url": "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150"},
        {"username": "music_guru", "email": "music@trendy.com", "full_name": "Mike Rodriguez", "bio": "Music producer and DJ", "avatar_url": "https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=150"},
        {"username": "sports_fanatic", "email": "sports@trendy.com", "full_name": "Emma Wilson", "bio": "Sports analyst and football enthusiast", "avatar_url": "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150"}
    ]
    
    users = []
    for user_data in users_data:
        user = User(**user_data, is_verified=True)
        db.add(user)
        users.append(user)
    db.commit()
    print(f"✅ Created {len(users)} users")
    return users

def create_posts(db, users):
    """Create sample posts for all categories"""
    
    # Music posts
    music_data = [
        {"title": "Blinding Lights", "artist": "The Weeknd", "genre": "Pop", "duration": "3:20"},
        {"title": "Levitating", "artist": "Dua Lipa", "genre": "Dance", "duration": "3:23"},
        {"title": "Stay", "artist": "The Kid LAROI & Justin Bieber", "genre": "Pop", "duration": "2:21"},
        {"title": "Good 4 U", "artist": "Olivia Rodrigo", "genre": "Pop Rock", "duration": "2:58"},
        {"title": "Montero", "artist": "Lil Nas X", "genre": "Hip Hop", "duration": "2:17"}
    ]
    
    # Movie posts
    movie_data = [
        {"title": "The Shawshank Redemption", "category": "Drama", "description": "Two imprisoned men bond over years, finding redemption"},
        {"title": "The Dark Knight", "category": "Action", "description": "Batman faces the Joker in psychological warfare"},
        {"title": "Inception", "category": "Sci-Fi", "description": "A thief who steals corporate secrets through dream-sharing"},
        {"title": "Pulp Fiction", "category": "Crime", "description": "Intertwining tales of violence and redemption"},
        {"title": "The Matrix", "category": "Action", "description": "A hacker learns about the true nature of reality"}
    ]
    
    # Football posts
    football_data = [
        {"title": "Premier League: Man United vs Liverpool", "category": "Premier League", "description": "Classic rivalry match at Old Trafford"},
        {"title": "Champions League: Real Madrid vs Barcelona", "category": "Champions League", "description": "El Clasico in the semi-finals"},
        {"title": "World Cup: Argentina vs France", "category": "World Cup", "description": "Epic final match with stunning goals"},
        {"title": "La Liga: Atletico vs Real Madrid", "category": "La Liga", "description": "Madrid derby with high stakes"},
        {"title": "Serie A: Milan Derby", "category": "Serie A", "description": "Inter vs AC Milan in historic rivalry"}
    ]
    
    # Photography posts
    photo_data = [
        {"title": "Golden Hour Portrait", "category": "Portrait", "description": "Stunning portrait during golden hour lighting"},
        {"title": "Urban Architecture", "category": "Architecture", "description": "Modern architectural photography"},
        {"title": "Nature Landscape", "category": "Landscape", "description": "Breathtaking natural beauty"},
        {"title": "Street Photography", "category": "Street", "description": "Candid urban moments"},
        {"title": "Wildlife Photography", "category": "Wildlife", "description": "Amazing wildlife shots"}
    ]
    
    posts = []
    
    # Create music posts
    for music in music_data:
        user = random.choice(users)
        post = Post(
            title=music["title"],
            description=f"{music['artist']} - {music['title']} - {music['genre']} track",
            type="music",
            category=music["genre"],
            image_url=f"https://picsum.photos/seed/{music['title']}/400/400",
            content_url="https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
            user_id=user.id,
            views_count=random.randint(100, 5000),
            likes_count=random.randint(10, 500),
            metadata={"duration": music["duration"]}
        )
        db.add(post)
        posts.append(post)
    
    # Create movie posts
    for movie in movie_data:
        user = random.choice(users)
        post = Post(
            title=movie["title"],
            description=movie["description"],
            type="movie",
            category=movie["category"],
            image_url="https://picsum.photos/seed/movie/400/400",
            content_url="https://www.youtube.com/watch?v=dQw4w9WgXcQ",
            user_id=user.id,
            views_count=random.randint(200, 3000),
            likes_count=random.randint(20, 300),
            metadata={"rating": round(random.uniform(7.0, 9.5), 1)}
        )
        db.add(post)
        posts.append(post)
    
    # Create football posts
    for football in football_data:
        user = random.choice(users)
        post = Post(
            title=football["title"],
            description=football["description"],
            type="football",
            category=football["category"],
            image_url="https://picsum.photos/seed/football/400/400",
            content_url="https://www.youtube.com/watch?v=football123",
            user_id=user.id,
            views_count=random.randint(500, 8000),
            likes_count=random.randint(50, 1000),
            metadata={"status": "live" if random.random() > 0.5 else "upcoming"}
        )
        db.add(post)
        posts.append(post)
    
    # Create photography posts
    for photo in photo_data:
        user = random.choice(users)
        post = Post(
            title=photo["title"],
            description=photo["description"],
            type="photo",
            category=photo["category"],
            image_url="https://picsum.photos/seed/photo/400/400",
            content_url="https://picsum.photos/seed/photo/800/800",
            user_id=user.id,
            views_count=random.randint(100, 2000),
            likes_count=random.randint(15, 400),
            metadata={"camera": random.choice(["Canon EOS R5", "Sony A7III", "Nikon Z6"])}
        )
        db.add(post)
        posts.append(post)
    
    db.commit()
    print(f"✅ Created {len(posts)} posts")
    return posts

def create_comments(db, posts, users):
    """Create sample comments"""
    comments = []
    sample_comments = [
        "Amazing content! 🔥",
        "Love this! Great work 👏",
        "This is exactly what I was looking for",
        "Incredible quality, keep it up!",
        "Shared with my friends, they loved it too",
        "This deserves more recognition",
        "Masterpiece! Simply beautiful",
        "Can't stop watching/listening to this"
    ]
    
    for post in posts:
        # Add 2-4 comments per post
        num_comments = random.randint(2, 4)
        for _ in range(num_comments):
            user = random.choice(users)
            comment = Comment(
                content=random.choice(sample_comments),
                post_id=post.id,
                user_id=user.id
            )
            db.add(comment)
            comments.append(comment)
    
    db.commit()
    print(f"✅ Created {len(comments)} comments")

def create_followers(db, users):
    """Create follower relationships"""
    followers = []
    for user in users:
        # Each user follows 1-2 other users
        num_follows = random.randint(1, min(2, len(users) - 1))
        other_users = [u for u in users if u.id != user.id]
        followed_users = random.sample(other_users, num_follows)
        
        for followed_user in followed_users:
            follower = Follower(
                follower_id=user.id,
                followed_id=followed_user.id
            )
            db.add(follower)
            followers.append(follower)
    
    db.commit()
    print(f"✅ Created {len(followers)} follower relationships")

def seed_database():
    """Main function to seed the database"""
    print("🚀 Starting database seeding...")
    
    # Create tables
    create_tables()
    
    # Create database session
    db = SessionLocal()
    
    try:
        # Create users
        users = create_users(db)
        
        # Create posts
        posts = create_posts(db, users)
        
        # Create comments
        create_comments(db, posts, users)
        
        # Create followers
        create_followers(db, users)
        
        print("\n🎉 Database seeding completed successfully!")
        print(f"📊 Summary:")
        print(f"   Users: {len(users)}")
        print(f"   Posts: {len(posts)}")
        print(f"   Categories: Music, Movies, Football, Photography")
        
    except Exception as e:
        print(f"❌ Error seeding database: {e}")
        db.rollback()
        raise
    finally:
        db.close()

if __name__ == "__main__":
    seed_database()
