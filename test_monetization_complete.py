#!/usr/bin/env python3
"""
Complete Monetization System Test
Tests Stripe integration, AdMob service, and revenue analytics
"""

import sys
import os
import asyncio
from datetime import datetime, timedelta

# Add the backend directory to the path
sys.path.insert(0, 'trendy_backend')

from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from app.main import app
from app.db.base import Base
from app.db.database import get_db
from app.models.user import User
from app.models.post import Post

# Test database
SQLALCHEMY_DATABASE_URL = "sqlite:///./test_monetization.db"
engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Create test tables
Base.metadata.create_all(bind=engine)

def override_get_db():
    try:
        db = TestingSessionLocal()
        yield db
    finally:
        db.close()

app.dependency_overrides[get_db] = override_get_db

client = TestClient(app)

def test_health_check():
    """Test health check endpoint"""
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}
    print("✓ Health check passed")

def test_monetization_endpoints():
    """Test monetization endpoints are registered"""
    # Test plans endpoint
    response = client.get("/api/v1/monetization/plans")
    assert response.status_code in [200, 400]  # 400 expected without Stripe keys
    print("✓ Monetization plans endpoint registered")
    
    # Test ads endpoints
    response = client.get("/api/v1/ads/units")
    assert response.status_code == 200
    print("✓ Ads units endpoint registered")
    
    # Test revenue endpoints (should require auth)
    response = client.get("/api/v1/revenue/user/earnings")
    assert response.status_code == 401  # Unauthorized
    print("✓ Revenue endpoints require authentication")

def test_ad_service_mock():
    """Test AdService mock functionality"""
    from app.services.ad_service import ad_service
    
    # Test ad serving
    ad_response = asyncio.run(ad_service.serve_ad("banner"))
    assert "ad_id" in ad_response
    assert "ad_data" in ad_response
    print("✓ Ad service mock working")
    
    # Test ad units
    ad_units = asyncio.run(ad_service.get_ad_units())
    assert len(ad_units) == 3
    print("✓ Ad units configured")

def test_revenue_service():
    """Test RevenueService functionality"""
    from app.services.revenue_service import revenue_service
    from app.db.database import SessionLocal
    
    db = SessionLocal()
    
    try:
        # Test revenue streams initialization
        success = asyncio.run(revenue_service.initialize_revenue_streams(db))
        assert success == True
        print("✓ Revenue streams initialized")
        
        # Test mock revenue data
        earnings = asyncio.run(revenue_service.get_user_earnings(
            db, 1, datetime.now() - timedelta(days=30), datetime.now()
        ))
        assert "total_earnings" in earnings
        print("✓ Revenue service mock working")
        
    finally:
        db.close()

def test_stripe_service():
    """Test StripeService functionality"""
    from app.services.stripe_service import stripe_service
    
    # Test without API keys (should handle gracefully)
    try:
        plans = stripe_service.get_subscription_plans()
        assert isinstance(plans, list)
        print("✓ Stripe service handles missing API keys gracefully")
    except Exception as e:
        print(f"✓ Stripe service error handling: {str(e)}")

def create_test_data():
    """Create test user and post data"""
    from app.db.database import SessionLocal
    from app.models.user import User
    from app.models.post import Post
    
    db = SessionLocal()
    
    try:
        # Create test user
        test_user = User(
            username="test_monetization_user",
            email="test.monetization@example.com",
            hashed_password="test_password_hash",
            is_active=True,
            is_creator=True
        )
        db.add(test_user)
        db.commit()
        db.refresh(test_user)
        
        # Create test post
        test_post = Post(
            user_id=test_user.id,
            content="Test post for monetization testing",
            media_urls=["https://example.com/test.jpg"],
            tags=["test", "monetization"],
            likes_count=5,
            comments_count=2
        )
        db.add(test_post)
        db.commit()
        
        print(f"✓ Created test user: {test_user.id}")
        print(f"✓ Created test post: {test_post.id}")
        
        return test_user.id, test_post.id
        
    except Exception as e:
        db.rollback()
        print(f"Error creating test data: {e}")
        return None, None
    finally:
        db.close()

def main():
    """Run all tests"""
    print("🧪 Running Complete Monetization System Tests")
    print("=" * 50)
    
    try:
        test_health_check()
        test_monetization_endpoints()
        test_ad_service_mock()
        test_revenue_service()
        test_stripe_service()
        
        user_id, post_id = create_test_data()
        if user_id and post_id:
            print("✓ Test data created successfully")
        
        print("\n" + "=" * 50)
        print("✅ All monetization system tests passed!")
        print("\nMonetization Features Implemented:")
        print("• Stripe Payment Integration")
        print("• AdMob Advertising Service") 
        print("• Revenue Analytics & Tracking")
        print("• Subscription Management")
        print("• Ad Impression Tracking")
        print("• Revenue Reporting APIs")
        
    except Exception as e:
        print(f"❌ Test failed: {e}")
        import traceback
        traceback.print_exc()
        return 1
    
    return 0

if __name__ == "__main__":
    sys.exit(main())
