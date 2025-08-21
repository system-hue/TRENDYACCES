# Trendy Backend API - Complete Curl Commands

## Base URL
- **Local Development**: `http://localhost:8000`
- **Production**: `https://api.trendyapp.com`

## Quick Start Commands

### 1. Health Checks
```bash
# Basic health check
curl http://localhost:8000/

# Health status
curl http://localhost:8000/health

# Detailed health check
curl http://localhost:8000/health/detailed
```

### 2. User Management
```bash
# Register new user
curl -X POST http://localhost:8000/api/users/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "username": "testuser",
    "password": "testpass123"
  }'

# Login
curl -X POST http://localhost:8000/api/users/login \
  -H "Content-Type: application/json" \
  -d '{
    "identifier": "testuser",
    "password": "testpass123"
  }'

# Get current user (requires auth)
curl -X GET http://localhost:8000/api/users/me \
  -H "Authorization: Bearer YOUR_TOKEN"

# Get user profile
curl -X GET http://localhost:8000/api/users/1

# Get user posts
curl -X GET http://localhost:8000/api/users/1/posts
```

### 3. Posts Management
```bash
# Get all posts
curl -X GET http://localhost:8000/api/posts

# Create new post
curl -X POST http://localhost:8000/api/posts \
  -H "Content-Type: application/json" \
  -d '{
    "content": "This is a test post from curl",
    "image_url": "https://example.com/image.jpg"
  }'

# Get specific post
curl -X GET http://localhost:8000/api/posts/1

# Like a post
curl -X POST http://localhost:8000/api/posts/1/like

# Unlike a post
curl -X DELETE http://localhost:8000/api/posts/1/unlike

# Add comment to post
curl -X POST http://localhost:8000/api/posts/1/comments \
  -H "Content-Type: application/json" \
  -d '{
    "content": "Great post!"
  }'
```

### 4. Followers System
```bash
# Follow a user
curl -X POST http://localhost:8000/api/users/2/follow

# Unfollow a user
curl -X DELETE http://localhost:8000/api/users/2/unfollow

# Get user followers
curl -X GET http://localhost:8000/api/users/1/followers

# Get user following
curl -X GET http://localhost:8000/api/users/1/following

# Check if following
curl -X GET http://localhost:8000/api/users/1/is_following/2

# Get user stats
curl -X GET http://localhost:8000/api/users/1/stats

# Search users
curl -X GET "http://localhost:8000/api/users/search?query=test"
```

### 5. Notifications
```bash
# Get notifications
curl -X GET http://localhost:8000/api/notifications
```

### 6. System Endpoints
```bash
# Get system configuration
curl -X GET http://localhost:8000/api/system/config

# Get API information
curl -X GET http://localhost:8000/api
```

### 7. Documentation
```bash
# Swagger UI
open http://localhost:8000/docs

# ReDoc
open http://localhost:8000/redoc

# OpenAPI Schema
curl -X GET http://localhost:8000/openapi.json
```

## Advanced Testing with Authentication

### 1. Get Firebase Token (for production)
```bash
# You'll need to get a Firebase ID token from your Flutter app
# or use Firebase Admin SDK to generate test tokens
```

### 2. Using Bearer Token
```bash
# Example with token
curl -X GET http://localhost:8000/api/users/me \
  -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjFkYTFkM..."

# Example with query parameter (for testing)
curl -X GET "http://localhost:8000/api/users/me?token=YOUR_TOKEN"
```

## Testing Scripts

### Run the automated test script
```bash
# Make executable
chmod +x test_all_endpoints.sh

# Run all tests
./test_all_endpoints.sh

# Run specific tests
./test_all_endpoints.sh | grep -E "(Testing|Success|Failed)"
```

### Batch Testing
```bash
# Create test data
curl -X POST http://localhost:8000/api/users/register \
  -H "Content-Type: application/json" \
  -d '{"email":"demo@trendy.app","username":"demouser","password":"demo123"}'

# Test multiple endpoints
for endpoint in "/health" "/api" "/api/posts" "/api/users/1"; do
  echo "Testing: $endpoint"
  curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8000$endpoint
done
```

## Error Handling Examples

### 400 Bad Request
```bash
curl -X POST http://localhost:8000/api/users/register \
  -H "Content-Type: application/json" \
  -d '{"email":"invalid-email"}'
```

### 404 Not Found
```bash
curl -X GET http://localhost:8000/api/users/99999
```

### 401 Unauthorized
```bash
curl -X GET http://localhost:8000/api/users/me
```

## Environment Variables
Make sure your `.env` file has:
```bash
DATABASE_URL=sqlite:///./trendy.db
SECRET_KEY=your-secret-key
DEBUG=True
```

## Docker Testing
```bash
# Start the backend
docker-compose up -d

# Test from container
docker-compose exec backend curl http://localhost:8000/health

# Test from host
curl http://localhost:8000/health
```

## Performance Testing
```bash
# Load test with curl
for i in {1..100}; do
  curl -s http://localhost:8000/api/posts > /dev/null &
done
wait

# Concurrent requests
seq 1 10 | xargs -n1 -P10 -I{} curl -s http://localhost:8000/api/posts
