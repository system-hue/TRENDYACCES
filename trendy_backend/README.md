# Trendy Backend - Complete Setup Guide



## 🚀 Quick Start

### Prerequisites
- Python 3.8+
- Node.js 16+ (for Flutter frontend)
- Git

### Installation

1. **Clone the repository:**
```bash
git clone <repository-url>
cd trendy_backend
```

2. **Install dependencies:**
```bash
pip install -r requirements.txt
```

3. **Set up environment variables:**
```bash
# Create .env file
cp .env.example .env
```

## 📋 Backend Commands

### Development Server
```bash
# Development mode with auto-reload
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

# Production mode
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 4
```

### Database Management
```bash
# Create database tables
python scripts/seed_simple.py

# Seed with test data
python scripts/seed_complete.py

# Reset database
python scripts/seed_fixed.py
```

### Testing
```bash
# Run all endpoint tests
python scripts/test_endpoints.py

# Test AI features
python scripts/test_ai_endpoints.py

# Test messaging endpoints
python scripts/test_messaging_endpoints.py
```

### Deployment
```bash
# Production deployment
python scripts/deploy.py

# Complete deployment with tests
python scripts/deploy_complete.py
```

## 🔧 Development Workflow

### 1. Environment Setup
```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

### 2. Database Setup
```bash
# Initialize database
python -c "from app.database import Base, engine; Base.metadata.create_all(bind=engine)"

# Seed with sample data
python scripts/seed_complete.py
```

### 3. Start Development Server
```bash
# Development mode
python -m uvicorn app.main:app --reload

# Server will be available at http://localhost:8000
```

## 📊 API Endpoints

### Health Check
- `GET /` - Root endpoint
- `GET /health` - Health check

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/auth/refresh` - Refresh token

### Posts
- `GET /api/posts` - Get all posts
- `POST /api/posts` - Create new post
- `GET /api/posts/{id}` - Get specific post
- `PUT /api/posts/{id}` - Update post
- `DELETE /api/posts/{id}` - Delete post

### Music
- `GET /api/music` - Get music posts
- `GET /api/music/trending` - Get trending music
- `GET /api/music/genres` - Get music genres

### Movies
- `GET /api/movies` - Get movie posts
- `GET /api/movies/trending` - Get trending movies
- `GET /api/movies/categories` - Get movie categories

### Football
- `GET /api/football` - Get football posts
- `GET /api/football/live` - Get live matches
- `GET /api/football/teams` - Get teams

### Photos
- `GET /api/photos` - Get photo posts
- `GET /api/photos/trending` - Get trending photos
- `GET /api/photos/categories` - Get photo categories

### AI Features
- `POST /api/ai/moderate` - Content moderation
- `POST /api/ai/generate` - AI content generation
- `GET /api/ai/suggestions` - Get AI suggestions

### Messaging
- `GET /api/messages` - Get messages
- `POST /api/messages` - Send message
- `GET /api/groups` - Get groups
- `POST /api/groups` - Create group

## 🧪 Testing

### Unit Tests
```bash
# Run all tests
python -m pytest tests/

# Run specific test file
python -m pytest tests/test_auth.py
```

### Integration Tests
```bash
# Run integration tests
python scripts/test_complete.py
```

### Load Testing
```bash
# Install locust
pip install locust

# Run load tests
locust -f tests/load_test.py --host=http://localhost:8000
```

## 🚀 Deployment

### Production Deployment
```bash
# Production setup
python scripts/deploy.py

# Complete deployment
python scripts/deploy_complete.py
```

### Docker Deployment
```bash
# Build Docker image
docker build -t trendy-backend .

# Run container
docker run -p 8000:8000 trendy-backend
```

### Cloud Deployment
```bash
# Heroku deployment
git push heroku main

# AWS deployment
eb deploy
```

## 🔍 Monitoring

### Health Monitoring
```bash
# Check server health
curl http://localhost:8000/health

# Monitor logs
tail -f logs/app.log
```

### Performance Monitoring
```bash
# Install monitoring tools
pip install prometheus-client

# Start monitoring
python -m prometheus_client
```

## 📚 Documentation

### API Documentation
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

### Database Schema
- ER Diagram: docs/database_schema.png
- Migration Guide: docs/migration_guide.md

## 🛠️ Troubleshooting

### Common Issues

1. **Port already in use:**
```bash
# Kill process on port 8000
lsof -ti:8000 | xargs kill -9
```

2. **Database connection issues:**
```bash
# Check database connection
python -c "from app.database import engine; engine.connect()"
```

3. **Import errors:**
```bash
# Check Python path
export PYTHONPATH="${PYTHONPATH}:$(pwd)"
```

### Debug Mode
```bash
# Enable debug mode
export DEBUG=true
python -m uvicorn app.main:app --reload
```

## 📞 Support

For support and questions:
- GitHub Issues: [Create an issue](https://github.com/your-repo/issues)
- Discord: [Join our Discord](https://discord.gg/your-server)
- Email: support@trendyapp.com

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
