#!/usr/bin/env python3
"""
Test script to verify social authentication implementation
"""

import os
import sys
import asyncio
from dotenv import load_dotenv

# Add the parent directory to the path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Load environment variables
load_dotenv()

async def test_social_auth_instances():
    """Test that social auth instances can be created"""
    try:
        from app.auth.google import google_auth
        print("✅ Google Auth instance created successfully")
        print(f"   Client ID: {google_auth.client_id}")
    except Exception as e:
        print(f"❌ Google Auth failed: {e}")
    
    try:
        from app.auth.facebook import facebook_auth
        print("✅ Facebook Auth instance created successfully")
        print(f"   Client ID: {facebook_auth.client_id}")
    except Exception as e:
        print(f"❌ Facebook Auth failed: {e}")
    
    try:
        from app.auth.apple_fixed import apple_auth
        print("✅ Apple Auth instance created successfully")
        print(f"   Client ID: {apple_auth.client_id}")
    except Exception as e:
        print(f"❌ Apple Auth failed: {e}")

async def test_social_auth_routes():
    """Test that social auth routes can be imported"""
    try:
        from app.routes.social_auth import router
        print("✅ Social Auth routes imported successfully")
    except Exception as e:
        print(f"❌ Social Auth routes failed: {e}")

async def main():
    print("🧪 Testing Social Authentication Implementation")
    print("=" * 50)
    
    await test_social_auth_instances()
    print()
    await test_social_auth_routes()
    
    print("\n" + "=" * 50)
    print("📋 Summary:")
    print("1. All social auth instances should be created successfully")
    print("2. Environment variables should be properly loaded")
    print("3. Social auth routes should be importable")
    print("\n⚠️  Note: This test only verifies setup, not actual authentication")
    print("   For full testing, you need to set valid OAuth credentials")

if __name__ == "__main__":
    asyncio.run(main())
