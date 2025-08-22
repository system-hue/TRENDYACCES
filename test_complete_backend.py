#!/usr/bin/env python3
"""
Complete Backend Test Script for TRENDY App
Tests all implemented endpoints to ensure they work correctly
"""

import requests
import json
import os
import sys
from typing import Dict, Any, List

# Configuration
BASE_URL = "http://localhost:8000"
TEST_USER_EMAIL = "test@example.com"
TEST_USER_PASSWORD = "testpassword123"
TEST_USER_USERNAME = "testuser"

def print_success(message: str):
    """Print success message"""
    print(f"✅ {message}")

def print_error(message: str):
    """Print error message"""
    print(f"❌ {message}")

def print_warning(message: str):
    """Print warning message"""
    print(f"⚠️  {message}")

def print_info(message: str):
    """Print info message"""
    print(f"ℹ️  {message}")

class BackendTester:
    def __init__(self, base_url: str):
        self.base_url = base_url
        self.session = requests.Session()
        self.access_token = None
        self.user_id = None
        self.test_user_id = None
        
    def get_headers(self) -> Dict[str, str]:
        """Get request headers with auth token if available"""
        headers = {
            "Content-Type": "application/json",
            "Accept": "application/json"
        }
        if self.access_token:
            headers["Authorization"] = f"Bearer {self.access_token}"
        return headers
    
    def test_health_check(self) -> bool:
        """Test health check endpoint"""
        try:
            response = self.session.get(f"{self.base_url}/health", headers=self.get_headers())
            if response.status_code == 200:
                data = response.json()
                if data.get("status") == "healthy":
                    print_success("Health check passed")
                    return True
            print_error(f"Health check failed: {response.status_code} - {response.text}")
            return False
        except Exception as e:
            print_error(f"Health check error: {str(e)}")
            return False
    
    def test_register_user(self) -> bool:
        """Test user registration"""
        try:
            payload = {
                "email": TEST_USER_EMAIL,
                "password": TEST_USER_PASSWORD,
                "username": TEST_USER_USERNAME,
                "display_name": "Test User"
            }
            response = self.session.post(
                f"{self.base_url}/api/v1/auth/register",
                json=payload,
                headers=self.get_headers()
            )
            
            if response.status_code in [200, 201]:
                data = response.json()
                if "access_token" in data:
                    self.access_token = data["access_token"]
                    self.user_id = data.get("user", {}).get("id")
                    print_success("User registration successful")
                    return True
                elif response.status_code == 400 and "already exists" in response.text.lower():
                    print_warning("User already exists, testing login instead")
                    return self.test_login()
            print_error(f"Registration failed: {response.status_code} - {response.text}")
            return False
        except Exception as e:
            print_error(f"Registration error: {str(e)}")
            return False
    
    def test_login(self) -> bool:
        """Test user login"""
        try:
            payload = {
                "email": TEST_USER_EMAIL,
                "password": TEST_USER_PASSWORD
            }
            response = self.session.post(
                f"{self.base_url}/api/v1/auth/login",
                json=payload,
                headers=self.get_headers()
            )
            
            if response.status_code == 200:
                data = response.json()
                self.access_token = data["access_token"]
                self.user_id = data.get("user", {}).get("id")
                print_success("User login successful")
                return True
            print_error(f"Login failed: {response.status_code} - {response.text}")
            return False
        except Exception as e:
            print_error(f"Login error: {str(e)}")
            return False
    
    def test_get_current_user(self) -> bool:
        """Test getting current user profile"""
        try:
            response = self.session.get(
                f"{self.base_url}/api/v1/auth/me",
                headers=self.get_headers()
            )
            
            if response.status_code == 200:
                data = response.json()
                if data.get("id") == self.user_id:
                    print_success("Get current user successful")
                    return True
            print_error(f"Get current user failed: {response.status_code} - {response.text}")
            return False
        except Exception as e:
            print_error(f"Get current user error: {str(e)}")
            return False
    
    def test_update_profile(self) -> bool:
        """Test updating user profile"""
        try:
            payload = {
                "display_name": "Updated Test User",
                "bio": "This is a test bio for the test user"
            }
            response = self.session.put(
                f"{self.base_url}/api/v1/users/{self.user_id}",
                json=payload,
                headers=self.get_headers()
            )
            
            if response.status_code == 200:
                print_success("Update profile successful")
                return True
            print_error(f"Update profile failed: {response.status_code} - {response.text}")
            return False
        except Exception as e:
            print_error(f"Update profile error: {str(e)}")
            return False
    
    def test_search_users(self) -> bool:
        """Test user search"""
        try:
            response = self.session.get(
                f"{self.base_url}/api/v1/users/search?query=test",
                headers=self.get_headers()
            )
            
            if response.status_code == 200:
                data = response.json()
                if "users" in data:
                    print_success("User search successful")
                    return True
            print_error(f"User search failed: {response.status_code} - {response.text}")
            return False
        except Exception as e:
            print_error(f"User search error: {str(e)}")
            return False
    
    def test_create_post(self) -> bool:
        """Test creating a post"""
        try:
            payload = {
                "content": "This is a test post from the backend tester",
                "media_urls": [],
                "hashtags": ["test", "backend"],
                "mentions": []
            }
            response = self.session.post(
                f"{self.base_url}/api/v1/posts/",
                json=payload,
                headers=self.get_headers()
            )
            
            if response.status_code == 201:
                data = response.json()
                if data.get("id"):
                    print_success("Create post successful")
                    return True
            print_error(f"Create post failed: {response.status_code} - {response.text}")
            return False
        except Exception as e:
            print_error(f"Create post error: {str(e)}")
            return False
    
    def test_get_posts(self) -> bool:
        """Test getting posts"""
        try:
            response = self.session.get(
                f"{self.base_url}/api/v1/posts/",
                headers=self.get_headers()
            )
            
            if response.status_code == 200:
                data = response.json()
                if isinstance(data, list):
                    print_success("Get posts successful")
                    return True
            print_error(f"Get posts failed: {response.status_code} - {response.text}")
            return False
        except Exception as e:
            print_error(f"Get posts error: {str(e)}")
            return False
    
    def test_get_trending_music(self) -> bool:
        """Test getting trending music"""
        try:
            response = self.session.get(
                f"{self.base_url}/api/v1/content/music/trending",
                headers=self.get_headers()
            )
            
            if response.status_code == 200:
                data = response.json()
                if isinstance(data, list):
                    print_success("Get trending music successful")
                    return True
            print_error(f"Get trending music failed: {response.status_code} - {response.text}")
            return False
        except Exception as e:
            print_error(f"Get trending music error: {str(e)}")
            return False
    
    def test_get_trending_movies(self) -> bool:
        """Test getting trending movies"""
        try:
            response = self.session.get(
                f"{self.base_url}/api/v1/content/movies/trending",
                headers=self.get_headers()
            )
            
            if response.status_code == 200:
                data = response.json()
                if isinstance(data, list):
                    print_success("Get trending movies successful")
                    return True
            print_error(f"Get trending movies failed: {response.status_code} - {response.text}")
            return False
        except Exception as e:
            print_error(f"Get trending movies error: {str(e)}")
            return False
    
    def test_get_football_matches(self) -> bool:
        """Test getting football matches"""
        try:
            response = self.session.get(
                f"{self.base_url}/api/v1/content/football/matches",
                headers=self.get_headers()
            )
            
            if response.status_code == 200:
                data = response.json()
                if "matches" in data:
                    print_success("Get football matches successful")
                    return True
            print_error(f"Get football matches failed: {response.status_code} - {response.text}")
            return False
        except Exception as e:
            print_error(f"Get football matches error: {str(e)}")
            return False
    
    def test_agora_token(self) -> bool:
        """Test Agora token generation"""
        try:
            payload = {
                "channel_name": "test_channel",
                "uid": 12345
            }
            response = self.session.post(
                f"{self.base_url}/api/v1/agora/token",
                json=payload,
                headers=self.get_headers()
            )
            
            if response.status_code == 200:
                data = response.json()
                if "token" in data:
                    print_success("Agora token generation successful")
                    return True
            print_error(f"Agora token generation failed: {response.status_code} - {response.text}")
            return False
        except Exception as e:
            print_error(f"Agora token generation error: {str(e)}")
            return False
    
    def test_follow_system(self) -> bool:
        """Test follow/unfollow system"""
        # This would normally test with another user, but for now just test the endpoints
        try:
            # Test getting followers (should work even if no followers)
            response = self.session.get(
                f"{self.base_url}/api/v1/users/relationships/followers/{self.user_id}",
                headers=self.get_headers()
            )
            
            if response.status_code == 200:
                print_success("Get followers successful")
                return True
            print_error(f"Get followers failed: {response.status_code} - {response.text}")
            return False
        except Exception as e:
            print_error(f"Follow system test error: {str(e)}")
            return False
    
    def run_all_tests(self) -> bool:
        """Run all tests"""
        print_info("Starting comprehensive backend tests...")
        print_info(f"Base URL: {self.base_url}")
        
        tests = [
            ("Health Check", self.test_health_check),
            ("User Registration", self.test_register_user),
            ("User Login", self.test_login),
            ("Get Current User", self.test_get_current_user),
            ("Update Profile", self.test_update_profile),
            ("User Search", self.test_search_users),
            ("Create Post", self.test_create_post),
            ("Get Posts", self.test_get_posts),
            ("Trending Music", self.test_get_trending_music),
            ("Trending Movies", self.test_get_trending_movies),
            ("Football Matches", self.test_get_football_matches),
            ("Agora Token", self.test_agora_token),
            ("Follow System", self.test_follow_system),
        ]
        
        results = []
        for test_name, test_func in tests:
            print_info(f"Running test: {test_name}")
            try:
                result = test_func()
                results.append((test_name, result))
                if result:
                    print_success(f"{test_name}: PASSED")
                else:
                    print_error(f"{test_name}: FAILED")
            except Exception as e:
                print_error(f"{test_name}: ERROR - {str(e)}")
                results.append((test_name, False))
            
            print()  # Empty line for readability
        
        # Summary
        passed = sum(1 for _, result in results if result)
        total = len(results)
        
        print_info("=" * 50)
        print_info("TEST SUMMARY")
        print_info("=" * 50)
        
        for test_name, result in results:
            status = "PASS" if result else "FAIL"
            print_info(f"{test_name}: {status}")
        
        print_info("=" * 50)
        print_info(f"Total: {passed}/{total} tests passed")
        
        if passed == total:
            print_success("🎉 All tests passed! Backend is ready for production.")
        else:
            print_warning(f"⚠️  {total - passed} tests failed. Please check the implementation.")
        
        return passed == total

def main():
    """Main function"""
    # Check if server is running
    tester = BackendTester(BASE_URL)
    
    if not tester.test_health_check():
        print_error("Backend server is not running. Please start the server first.")
        print_info("Run: uvicorn trendy_backend.app.main:app --reload --host 0.0.0.0 --port 8000")
        sys.exit(1)
    
    # Run all tests
    success = tester.run_all_tests()
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
