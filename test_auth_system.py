#!/usr/bin/env python3
"""
Simple Authentication System Test
Tests the new unified authentication middleware and endpoints
"""

import requests
import json
import sys

BASE_URL = "http://localhost:8000"
TEST_EMAIL = "test_auth@example.com"
TEST_PASSWORD = "testauth123"
TEST_USERNAME = "testauthuser"

def print_status(message, success=True):
    """Print status message with emoji"""
    emoji = "✅" if success else "❌"
    print(f"{emoji} {message}")

def test_auth_system():
    """Test the complete authentication system"""
    print("🧪 Testing Authentication System...")
    print(f"Base URL: {BASE_URL}")
    print()
    
    session = requests.Session()
    access_token = None
    user_id = None
    
    # Test 1: Health Check
    print("1. Testing health check...")
    try:
        response = session.get(f"{BASE_URL}/health")
        if response.status_code == 200 and response.json().get("status") == "healthy":
            print_status("Health check passed")
        else:
            print_status("Health check failed", False)
            return False
    except Exception as e:
        print_status(f"Health check error: {str(e)}", False)
        return False
    
    # Test 2: User Registration
    print("2. Testing user registration...")
    try:
        payload = {
            "email": TEST_EMAIL,
            "password": TEST_PASSWORD,
            "username": TEST_USERNAME,
            "display_name": "Test Auth User"
        }
        response = session.post(f"{BASE_URL}/api/v1/auth/register", json=payload)
        
        if response.status_code in [200, 201]:
            data = response.json()
            access_token = data.get("access_token")
            user_id = data.get("user", {}).get("id")
            if access_token and user_id:
                print_status("Registration successful")
            else:
                print_status("Registration response missing token or user ID", False)
                return False
        elif response.status_code == 400 and "already exists" in response.text.lower():
            print_status("User already exists, testing login instead")
            # Fall through to login test
        else:
            print_status(f"Registration failed: {response.status_code} - {response.text}", False)
            return False
    except Exception as e:
        print_status(f"Registration error: {str(e)}", False)
        return False
    
    # Test 3: User Login (if registration didn't provide token)
    if not access_token:
        print("3. Testing user login...")
        try:
            payload = {
                "email": TEST_EMAIL,
                "password": TEST_PASSWORD
            }
            response = session.post(f"{BASE_URL}/api/v1/auth/login", json=payload)
            
            if response.status_code == 200:
                data = response.json()
                access_token = data.get("access_token")
                user_id = data.get("user", {}).get("id")
                if access_token and user_id:
                    print_status("Login successful")
                else:
                    print_status("Login response missing token or user ID", False)
                    return False
            else:
                print_status(f"Login failed: {response.status_code} - {response.text}", False)
                return False
        except Exception as e:
            print_status(f"Login error: {str(e)}", False)
            return False
    
    # Test 4: Get Current User (protected endpoint)
    print("4. Testing protected endpoint (get current user)...")
    try:
        headers = {"Authorization": f"Bearer {access_token}"}
        response = session.get(f"{BASE_URL}/api/v1/auth/me", headers=headers)
        
        if response.status_code == 200:
            data = response.json()
            if data.get("id") == user_id and data.get("email") == TEST_EMAIL:
                print_status("Protected endpoint access successful")
            else:
                print_status("Protected endpoint returned incorrect user data", False)
                return False
        else:
            print_status(f"Protected endpoint failed: {response.status_code} - {response.text}", False)
            return False
    except Exception as e:
        print_status(f"Protected endpoint error: {str(e)}", False)
        return False
    
    # Test 5: Update Profile (protected endpoint)
    print("5. Testing profile update...")
    try:
        headers = {"Authorization": f"Bearer {access_token}"}
        payload = {
            "display_name": "Updated Test User",
            "bio": "This user was created by the auth system test"
        }
        response = session.put(
            f"{BASE_URL}/api/v1/users/{user_id}",
            json=payload,
            headers=headers
        )
        
        if response.status_code == 200:
            print_status("Profile update successful")
        else:
            print_status(f"Profile update failed: {response.status_code} - {response.text}", False)
            return False
    except Exception as e:
        print_status(f"Profile update error: {str(e)}", False)
        return False
    
    # Test 6: Test without authentication (should fail)
    print("6. Testing unauthenticated access (should fail)...")
    try:
        response = session.get(f"{BASE_URL}/api/v1/auth/me")  # No auth header
        
        if response.status_code == 401:
            print_status("Unauthenticated access correctly rejected")
        else:
            print_status(f"Unauthenticated access should fail but got: {response.status_code}", False)
            return False
    except Exception as e:
        print_status(f"Unauthenticated test error: {str(e)}", False)
        return False
    
    # Test 7: Test with invalid token (should fail)
    print("7. Testing invalid token (should fail)...")
    try:
        headers = {"Authorization": "Bearer invalid_token_12345"}
        response = session.get(f"{BASE_URL}/api/v1/auth/me", headers=headers)
        
        if response.status_code == 401:
            print_status("Invalid token correctly rejected")
        else:
            print_status(f"Invalid token should fail but got: {response.status_code}", False)
            return False
    except Exception as e:
        print_status(f"Invalid token test error: {str(e)}", False)
        return False
    
    print()
    print_status("🎉 All authentication tests passed! The unified auth system is working correctly.", True)
    print()
    print("Summary:")
    print(f"  - User ID: {user_id}")
    print(f"  - Email: {TEST_EMAIL}")
    print(f"  - Access Token: {access_token[:20]}... (truncated)")
    print()
    print("The authentication system is ready for production use.")
    
    return True

if __name__ == "__main__":
    try:
        success = test_auth_system()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print("\nTest interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {str(e)}")
        sys.exit(1)
