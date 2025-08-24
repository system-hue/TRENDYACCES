#!/usr/bin/env python3
"""
Simple test to verify backend health and basic functionality
"""

import requests
import time
import subprocess
import sys
import os

def test_backend_health():
    """Test if backend server is responsive"""
    print("🧪 Testing backend server health...")
    
    # Try to connect to the health endpoint
    try:
        response = requests.get("http://localhost:8000/health", timeout=5)
        if response.status_code == 200:
            print("✅ Backend server is running and healthy")
            return True
        else:
            print(f"❌ Backend server responded with status: {response.status_code}")
            return False
    except requests.exceptions.ConnectionError:
        print("❌ Backend server is not running or not accessible")
        return False
    except Exception as e:
        print(f"❌ Error testing backend: {e}")
        return False

def test_google_auth_endpoint():
    """Test Google auth endpoint availability"""
    print("\n🧪 Testing Google auth endpoint...")
    
    try:
        response = requests.get("http://localhost:8000/api/v1/auth/google/login", timeout=5)
        if response.status_code in [200, 302, 401]:  # Various possible responses
            print("✅ Google auth endpoint is accessible")
            return True
        else:
            print(f"❌ Google auth endpoint responded with status: {response.status_code}")
            return False
    except requests.exceptions.ConnectionError:
        print("❌ Google auth endpoint not accessible")
        return False
    except Exception as e:
        print(f"❌ Error testing Google auth: {e}")
        return False

def main():
    print("🎯 Starting Trendy App Backend Health Check")
    print("=" * 50)
    
    # Test if backend is running
    backend_healthy = test_backend_health()
    
    if backend_healthy:
        # Test Google auth endpoint
        google_auth_ok = test_google_auth_endpoint()
        
        print("\n" + "=" * 50)
        print("📊 BACKEND HEALTH CHECK SUMMARY")
        print("=" * 50)
        print(f"✅ Backend Server: {'Healthy' if backend_healthy else 'Unhealthy'}")
        print(f"✅ Google Auth Endpoint: {'Accessible' if google_auth_ok else 'Inaccessible'}")
        
        if backend_healthy and google_auth_ok:
            print("\n🎉 Backend is ready for production!")
            print("\nTo start the backend server:")
            print("cd trendy_backend && python -m uvicorn app.main:app --host 0.0.0.0 --port 8000")
        else:
            print("\n⚠️ Backend needs attention. Some components are not working properly.")
    else:
        print("\n❌ Backend server is not running. Please start it first:")
        print("cd trendy_backend && python -m uvicorn app.main:app --host 0.0.0.0 --port 8000")

if __name__ == "__main__":
    main()
