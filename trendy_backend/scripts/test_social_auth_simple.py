#!/usr/bin/env python3
"""
Simple test script to verify social authentication structure
"""

import os
import sys

# Add the parent directory to the path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

def test_class_imports():
    """Test that social auth classes can be imported"""
    try:
        from app.auth.google import GoogleAuth
        print("✅ Google Auth class imported successfully")
    except Exception as e:
        print(f"❌ Google Auth import failed: {e}")
    
    try:
        from app.auth.facebook import FacebookAuth
        print("✅ Facebook Auth class imported successfully")
    except Exception as e:
        print(f"❌ Facebook Auth import failed: {e}")
    
    try:
        from app.auth.apple_fixed import AppleAuth
        print("✅ Apple Auth class imported successfully")
    except Exception as e:
        print(f"❌ Apple Auth import failed: {e}")

def test_routes_import():
    """Test that social auth routes can be imported"""
    try:
        # Mock environment variables to avoid instantiation errors
        os.environ["GOOGLE_CLIENT_ID"] = "test"
        os.environ["GOOGLE_CLIENT_SECRET"] = "test"
        os.environ["FACEBOOK_CLIENT_ID"] = "test"
        os.environ["FACEBOOK_CLIENT_SECRET"] = "test"
        os.environ["APPLE_CLIENT_ID"] = "test"
        os.environ["APPLE_TEAM_ID"] = "test"
        os.environ["APPLE_KEY_ID"] = "test"
        os.environ["APPLE_PRIVATE_KEY"] = "test"
        
        from app.routes.social_auth import router
        print("✅ Social Auth routes imported successfully")
        
        # Check that all expected endpoints exist
        endpoints = [route.path for route in router.routes]
        expected_endpoints = [
            "/auth/social/google",
            "/auth/social/facebook", 
            "/auth/social/apple",
            "/auth/social/providers",
            "/auth/social/user/{user_id}/providers"
        ]
        
        for endpoint in expected_endpoints:
            if any(endpoint in route_path for route_path in endpoints):
                print(f"✅ Endpoint {endpoint} found")
            else:
                print(f"❌ Endpoint {endpoint} not found")
                
    except Exception as e:
        print(f"❌ Social Auth routes failed: {e}")

def main():
    print("🧪 Testing Social Authentication Structure")
    print("=" * 50)
    
    test_class_imports()
    print()
    test_routes_import()
    
    print("\n" + "=" * 50)
    print("📋 Summary:")
    print("1. All social auth classes should be importable")
    print("2. Social auth routes should be importable with all endpoints")
    print("\n✅ Structure verification complete")

if __name__ == "__main__":
    main()
