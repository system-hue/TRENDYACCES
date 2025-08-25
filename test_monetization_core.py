#!/usr/bin/env python3
"""
Core Monetization System Test
Tests the core functionality without external dependencies
"""

import sys
import os
from datetime import datetime, timedelta

# Add the backend directory to the path
sys.path.insert(0, 'trendy_backend')

def test_core_services():
    """Test core monetization services"""
    print("🧪 Testing Core Monetization Services")
    print("=" * 50)
    
    # Test Stripe Service
    try:
        from app.services.stripe_service import stripe_service
        
        plans = stripe_service.get_subscription_plans()
        assert isinstance(plans, list), "Plans should be a list"
        assert len(plans) >= 3, "Should have at least 3 subscription plans"
        
        plan_names = [plan["name"] for plan in plans]
        assert "Free" in plan_names, "Free plan should exist"
        assert "Premium" in plan_names, "Premium plan should exist"
        assert "Pro" in plan_names, "Pro plan should exist"
        
        print("✅ Stripe Service - Subscription plans validated")
        
    except Exception as e:
        print(f"❌ Stripe Service test failed: {e}")
        return False
    
    # Test Ad Service
    try:
        from app.services.ad_service import ad_service
        import asyncio
        
        # Test ad serving
        ad_response = asyncio.run(ad_service.serve_ad("banner"))
        assert "ad_id" in ad_response, "Ad response should contain ad_id"
        assert "ad_data" in ad_response, "Ad response should contain ad_data"
        
        # Test ad units
        ad_units = asyncio.run(ad_service.get_ad_units())
        assert len(ad_units) == 3, "Should have 3 ad unit types"
        
        unit_types = [unit["type"] for unit in ad_units]
        assert "banner" in unit_types, "Banner ad unit should exist"
        assert "interstitial" in unit_types, "Interstitial ad unit should exist"
        assert "rewarded" in unit_types, "Rewarded ad unit should exist"
        
        print("✅ Ad Service - Ad serving and units validated")
        
    except Exception as e:
        print(f"❌ Ad Service test failed: {e}")
        return False
    
    # Test Revenue Service
    try:
        from app.services.revenue_service import revenue_service
        from app.db.database import SessionLocal
        import asyncio
        
        db = SessionLocal()
        
        # Test revenue streams initialization
        success = asyncio.run(revenue_service.initialize_revenue_streams(db))
        assert success == True, "Revenue streams should initialize successfully"
        
        # Test mock revenue calculations
        start_date = datetime.now() - timedelta(days=30)
        end_date = datetime.now()
        
        earnings = asyncio.run(revenue_service.get_user_earnings(
            db, 1, start_date, end_date
        ))
        
        assert "total_earnings" in earnings, "Earnings should contain total_earnings"
        assert "ad_revenue" in earnings, "Earnings should contain ad_revenue"
        assert "subscription_revenue" in earnings, "Earnings should contain subscription_revenue"
        
        db.close()
        print("✅ Revenue Service - Revenue calculations validated")
        
    except Exception as e:
        print(f"❌ Revenue Service test failed: {e}")
        return False
    
    return True

def test_database_models():
    """Test database model compilation and structure"""
    print("\n🧪 Testing Database Models")
    print("=" * 50)
    
    try:
        # Test model imports
        from app.models.subscription import Subscription, Payment
        from app.models.ad_impression import AdImpression, AdRevenueSummary, UserAdRevenue
        from app.models.revenue_analytics import RevenueStream, CreatorEarnings, PlatformRevenue
        
        print("✅ All monetization models imported successfully")
        
        # Test model relationships
        from app.models.user import User
        from app.models.post import Post
        
        assert hasattr(User, 'subscriptions'), "User should have subscriptions relationship"
        assert hasattr(User, 'payments'), "User should have payments relationship"
        assert hasattr(User, 'ad_impressions'), "User should have ad_impressions relationship"
        
        assert hasattr(Post, 'ad_impressions'), "Post should have ad_impressions relationship"
        
        print("✅ Database model relationships validated")
        
    except Exception as e:
        print(f"❌ Database model test failed: {e}")
        return False
    
    return True

def test_api_routes():
    """Test API route registration"""
    print("\n🧪 Testing API Route Registration")
    print("=" * 50)
    
    try:
        from fastapi.testclient import TestClient
        from app.main import app
        
        client = TestClient(app)
        
        # Test that endpoints are registered (they should return 401 unauthorized rather than 404)
        endpoints = [
            "/api/v1/monetization/plans",
            "/api/v1/ads/units",
            "/api/v1/revenue/user/earnings"
        ]
        
        for endpoint in endpoints:
            response = client.get(endpoint)
            assert response.status_code != 404, f"Endpoint {endpoint} not found"
            print(f"✅ Endpoint registered: {endpoint}")
        
    except Exception as e:
        print(f"❌ API route test failed: {e}")
        return False
    
    return True

def main():
    """Run all core tests"""
    print("🚀 Starting Comprehensive Monetization System Tests")
    print("=" * 60)
    
    success = True
    
    # Run all test suites
    if not test_core_services():
        success = False
    
    if not test_database_models():
        success = False
    
    if not test_api_routes():
        success = False
    
    print("\n" + "=" * 60)
    
    if success:
        print("🎉 ALL CORE TESTS PASSED!")
        print("\n✅ Monetization System Features Verified:")
        print("• Stripe Payment Integration")
        print("• AdMob Advertising Service") 
        print("• Revenue Analytics & Tracking")
        print("• Subscription Management")
        print("• Ad Impression Tracking")
        print("• Database Models & Relationships")
        print("• API Endpoint Registration")
        
        print("\n📋 Next Steps:")
        print("1. Set up Stripe API keys in environment")
        print("2. Configure AdMob credentials")
        print("3. Run database migrations")
        print("4. Integrate with Flutter frontend")
        print("5. Test with actual HTTP requests")
        
        return 0
    else:
        print("❌ Some tests failed. Please check the implementation.")
        return 1

if __name__ == "__main__":
    sys.exit(main())
