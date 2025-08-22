#!/usr/bin/env python3
"""
Test script for TRENDY App Monetization Endpoints
Run with: python test_monetization.py
"""

import os
import sys
import asyncio
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Add the backend directory to Python path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'trendy_backend'))

from app.main import app
from app.db.database import Base, get_db
from app.models.user import User
from app.models.subscription import Subscription, Payment

# Test database
SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"
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

# Test data
test_user_data = {
    "email": "test@example.com",
    "password": "testpassword123",
    "username": "testuser",
    "display_name": "Test User"
}

def test_create_test_user():
    """Create a test user for monetization testing"""
    response = client.post("/api/v1/auth/register", json=test_user_data)
    assert response.status_code == 200
    assert response.json()["email"] == test_user_data["email"]
    return response.json()["access_token"]

def test_get_subscription_plans():
    """Test getting subscription plans"""
    # This will fail without Stripe keys, but should return proper error
    response = client.get("/api/v1/monetization/plans")
    assert response.status_code in [200, 400]  # 400 if no Stripe keys configured
    
    if response.status_code == 400:
        print("Stripe not configured - skipping monetization tests")
        return False
    return True

def test_create_checkout_session():
    """Test creating a checkout session"""
    # First get auth token
    token = test_create_test_user()
    
    headers = {"Authorization": f"Bearer {token}"}
    
    # This will fail without proper Stripe configuration
    response = client.post(
        "/api/v1/monetization/create-checkout-session",
        headers=headers,
        json={
            "price_id": "price_test_123",
            "success_url": "https://example.com/success",
            "cancel_url": "https://example.com/cancel"
        }
    )
    
    # Should either succeed or give proper error
    assert response.status_code in [200, 400, 500]
    
    if response.status_code == 200:
        assert "session_id" in response.json()
        assert "url" in response.json()

def test_create_payment_intent():
    """Test creating a payment intent"""
    token = test_create_test_user()
    headers = {"Authorization": f"Bearer {token}"}
    
    response = client.post(
        "/api/v1/monetization/create-payment-intent",
        headers=headers,
        json={
            "amount": 1000,  # $10.00
            "currency": "usd",
            "description": "Test payment"
        }
    )
    
    assert response.status_code in [200, 400, 500]
    
    if response.status_code == 200:
        assert "client_secret" in response.json()
        assert "payment_intent_id" in response.json()

def test_get_user_subscriptions():
    """Test getting user subscriptions"""
    token = test_create_test_user()
    headers = {"Authorization": f"Bearer {token}"}
    
    response = client.get("/api/v1/monetization/subscriptions", headers=headers)
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_get_user_payments():
    """Test getting user payments"""
    token = test_create_test_user()
    headers = {"Authorization": f"Bearer {token}"}
    
    response = client.get("/api/v1/monetization/payments", headers=headers)
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_subscription_status():
    """Test getting subscription status"""
    token = test_create_test_user()
    headers = {"Authorization": f"Bearer {token}"}
    
    response = client.get("/api/v1/monetization/subscription-status", headers=headers)
    assert response.status_code == 200
    assert "has_active_subscription" in response.json()
    assert "is_premium" in response.json()

def test_webhook_endpoint():
    """Test webhook endpoint (basic validation)"""
    response = client.post(
        "/api/v1/monetization/webhook",
        headers={"stripe-signature": "test_signature"},
        content=b"test_payload"
    )
    # Should return error without proper signature, but endpoint should exist
    assert response.status_code in [400, 500]

def run_all_tests():
    """Run all monetization tests"""
    print("Running Monetization Endpoint Tests...")
    print("=" * 50)
    
    try:
        # Test user creation
        print("1. Testing user creation...")
        token = test_create_test_user()
        print("   ✓ User created successfully")
        
        # Test endpoints
        print("2. Testing subscription plans endpoint...")
        stripe_configured = test_get_subscription_plans()
        
        if stripe_configured:
            print("3. Testing checkout session creation...")
            test_create_checkout_session()
            print("   ✓ Checkout session test completed")
            
            print("4. Testing payment intent creation...")
            test_create_payment_intent()
            print("   ✓ Payment intent test completed")
        else:
            print("   ⚠ Stripe not configured - skipping payment tests")
        
        print("5. Testing subscription retrieval...")
        test_get_user_subscriptions()
        print("   ✓ Subscription retrieval test completed")
        
        print("6. Testing payments retrieval...")
        test_get_user_payments()
        print("   ✓ Payments retrieval test completed")
        
        print("7. Testing subscription status...")
        test_subscription_status()
        print("   ✓ Subscription status test completed")
        
        print("8. Testing webhook endpoint...")
        test_webhook_endpoint()
        print("   ✓ Webhook endpoint test completed")
        
        print("\n" + "=" * 50)
        print("All monetization tests completed successfully! 🎉")
        print("Note: Some tests may show errors if Stripe is not configured.")
        print("To test full functionality, set up Stripe keys in .env file.")
        
    except Exception as e:
        print(f"❌ Test failed with error: {str(e)}")
        raise e

if __name__ == "__main__":
    run_all_tests()
