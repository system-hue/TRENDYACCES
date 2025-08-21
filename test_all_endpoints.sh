#!/bin/bash

# Trendy Backend API Endpoint Testing Script
# This script tests all available endpoints using curl

# Base URL - adjust as needed
BASE_URL="http://localhost:8000"
# For production, use: BASE_URL="https://api.trendyapp.com"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🎯 Testing Trendy Backend API Endpoints${NC}"
echo "======================================"

# Function to test endpoint
test_endpoint() {
    local method=$1
    local endpoint=$2
    local description=$3
    local data=$4
    
    echo -e "\n${YELLOW}Testing: $description${NC}"
    echo "Endpoint: $method $BASE_URL$endpoint"
    
    if [ "$method" = "GET" ]; then
        response=$(curl -s -w "\n%{http_code}" -X GET "$BASE_URL$endpoint")
    elif [ "$method" = "POST" ]; then
        response=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL$endpoint" \
            -H "Content-Type: application/json" \
            -d "$data")
    elif [ "$method" = "DELETE" ]; then
        response=$(curl -s -w "\n%{http_code}" -X DELETE "$BASE_URL$endpoint")
    fi
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 300 ]; then
        echo -e "${GREEN}✅ Success ($http_code)${NC}"
        echo "Response: $body"
    else
        echo -e "${RED}❌ Failed ($http_code)${NC}"
        echo "Response: $body"
    fi
}

# Test basic endpoints
echo -e "\n${GREEN}=== Basic API Health Checks ===${NC}"
test_endpoint "GET" "/" "Root endpoint"
test_endpoint "GET" "/health" "Health check"
test_endpoint "GET" "/health/detailed" "Detailed health check"

# Test user endpoints
echo -e "\n${GREEN}=== User Endpoints ===${NC}"
test_endpoint "POST" "/api/users/register" "User registration" '{"email": "test@example.com", "username": "testuser", "password": "testpass123"}'
test_endpoint "POST" "/api/users/login" "User login" '{"identifier": "testuser", "password": "testpass123"}'
test_endpoint "GET" "/api/users/me" "Get current user"
test_endpoint "GET" "/api/users/1" "Get user profile"
test_endpoint "GET" "/api/users/1/posts" "Get user posts"

# Test posts endpoints
echo -e "\n${GREEN}=== Posts Endpoints ===${NC}"
test_endpoint "GET" "/api/posts" "List all posts"
test_endpoint "GET" "/api/posts/all" "Get all posts"
test_endpoint "POST" "/api/posts" "Create new post" '{"content": "Test post content", "image_url": "https://example.com/image.jpg"}'
test_endpoint "GET" "/api/posts/me" "Get my posts"

# Test followers endpoints
echo -e "\n${GREEN}=== Followers Endpoints ===${NC}"
test_endpoint "POST" "/api/users/2/follow" "Follow user"
test_endpoint "DELETE" "/api/users/2/unfollow" "Unfollow user"
test_endpoint "GET" "/api/users/1/followers" "Get followers"
test_endpoint "GET" "/api/users/1/following" "Get following"
test_endpoint "GET" "/api/users/1/stats" "Get user stats"

# Test notifications endpoints
echo -e "\n${GREEN}=== Notifications Endpoints ===${NC}"
test_endpoint "GET" "/api/notifications" "Get notifications"

# Test system endpoints
echo -e "\n${GREEN}=== System Endpoints ===${NC}"
test_endpoint "GET" "/api/system/config" "System configuration"

# Test API info
echo -e "\n${GREEN}=== API Information ===${NC}"
test_endpoint "GET" "/api" "API information"

# Test with authentication (if you have a valid token)
echo -e "\n${YELLOW}=== Authentication Required Endpoints ===${NC}"
echo "For authenticated endpoints, you'll need to add Authorization header:"
echo "curl -H \"Authorization: Bearer YOUR_FIREBASE_TOKEN\" $BASE_URL/api/auth/me"

# Create a simple test user for testing
echo -e "\n${YELLOW}=== Creating Test Data ===${NC}"
echo "Creating test user..."
curl -s -X POST "$BASE_URL/api/users/register" \
    -H "Content-Type: application/json" \
    -d '{"email": "demo@trendy.app", "username": "demouser", "password": "demo123"}' > /dev/null

echo -e "\n${GREEN}🎉 All endpoint tests completed!${NC}"
echo -e "\n${YELLOW}To test with authentication:${NC}"
echo "1. Register a user: curl -X POST $BASE_URL/api/users/register -H 'Content-Type: application/json' -d '{\"email\":\"test@example.com\",\"username\":\"testuser\",\"password\":\"testpass123\"}'"
echo "2. Login to get token: curl -X POST $BASE_URL/api/users/login -H 'Content-Type: application/json' -d '{\"identifier\":\"testuser\",\"password\":\"testpass123\"}'"
echo "3. Use token: curl -H \"Authorization: Bearer YOUR_TOKEN\" $BASE_URL/api/users/me"
