# Next Steps for TRENDY App Implementation

## Phase 1 Priority Features

### 1. Facebook OAuth Implementation
- [ ] Create FacebookAuth service similar to GoogleAuth
- [ ] Add Facebook API endpoints
- [ ] Update User model for Facebook integration
- [ ] Create Facebook OAuth setup documentation

### 2. Email Verification System
- [ ] Implement email service with templates
- [ ] Add email verification endpoints
- [ ] Update User model with verification fields
- [ ] Create email verification flow

### 3. User Blocking/Ban Functionality
- [ ] Add user moderation endpoints
- [ ] Implement blocking/banning logic
- [ ] Create admin moderation interface
- [ ] Add reporting system

### 4. Basic Privacy Settings
- [ ] Add privacy preferences to User model
- [ ] Implement privacy control endpoints
- [ ] Create privacy settings UI
- [ ] Add content visibility controls

## Database Schema Updates Needed

### User Model Enhancements
```python
# Add to User model
has_social_login = Column(Boolean, default=False)
primary_social_provider = Column(String(50), nullable=True)  # google, facebook, apple
email_verified = Column(Boolean, default=False)
verification_token = Column(String(255), nullable=True)
is_banned = Column(Boolean, default=False)
ban_reason = Column(Text, nullable=True)
privacy_settings = Column(JSON, default=dict)
```

### SocialProvider Model (Already Implemented)
```python
class SocialProvider(Base):
    __tablename__ = "social_providers"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    provider = Column(String(50), nullable=False)  # google, facebook, apple
    provider_user_id = Column(String(255), nullable=False)
    email = Column(String(255), nullable=True)
    display_name = Column(String(100), nullable=True)
    profile_picture = Column(String(500), nullable=True)
    access_token = Column(Text, nullable=True)
    refresh_token = Column(Text, nullable=True)
    token_expires_at = Column(DateTime, nullable=True)
    
    # Relationships
    user = relationship("User", back_populates="social_providers")
    
    # Unique constraint
    __table_args__ = (
        UniqueConstraint('provider', 'provider_user_id', name='uq_provider_user'),
    )
```

## API Endpoints to Implement

### Facebook Auth Endpoints
- `POST /api/v1/auth/facebook/login` - Authenticate with Facebook
- `GET /api/v1/auth/facebook/config` - Get Facebook OAuth config

### Email Verification Endpoints
- `POST /api/v1/auth/verify-email` - Send verification email
- `GET /api/v1/auth/verify-email/{token}` - Verify email token
- `POST /api/v1/auth/resend-verification` - Resend verification email

### Moderation Endpoints
- `POST /api/v1/users/{user_id}/block` - Block a user
- `POST /api/v1/users/{user_id}/unblock` - Unblock a user
- `POST /api/v1/users/{user_id}/ban` - Ban a user
- `GET /api/v1/moderation/reports` - Get user reports

### Privacy Endpoints
- `PUT /api/v1/users/privacy` - Update privacy settings
- `GET /api/v1/users/privacy` - Get privacy settings

## Testing Requirements

### Unit Tests Needed
- Facebook OAuth token verification
- Email service functionality
- User moderation logic
- Privacy settings validation

### Integration Tests
- End-to-end Facebook login flow
- Email verification process
- User blocking functionality
- Privacy settings enforcement

## Documentation

### Setup Guides Needed
- Facebook OAuth setup guide
- Email service configuration
- Moderation system overview
- Privacy settings documentation

### API Documentation
- Facebook auth API docs
- Email verification API docs
- Moderation API docs
- Privacy API docs

## Dependencies to Add

### Required Packages
```python
# For Facebook OAuth
facebook-sdk==3.1.0
httpx==0.25.0

# For email service
python-multipart==0.0.6
email-validator==2.0.0
jinja2==3.1.2
```

## Environment Variables

### New Environment Variables Needed
```
# Facebook OAuth
FACEBOOK_CLIENT_ID=your-facebook-app-id
FACEBOOK_CLIENT_SECRET=your-facebook-app-secret
FACEBOOK_REDIRECT_URI=http://localhost:3000/auth/facebook/callback

# Email Service
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password
EMAIL_FROM=noreply@yourdomain.com

# Frontend URLs
FRONTEND_URL=http://localhost:3000
VERIFICATION_SUCCESS_URL=http://localhost:3000/verification-success
VERIFICATION_FAILURE_URL=http://localhost:3000/verification-failed
```

## Implementation Timeline

### Week 1: Facebook OAuth
- Implement FacebookAuth service
- Create API endpoints
- Write tests
- Update documentation

### Week 2: Email Verification
- Implement email service
- Create verification endpoints
- Add email templates
- Test email delivery

### Week 3: Moderation System
- Implement user blocking
- Create ban system
- Add reporting functionality
- Test moderation flows

### Week 4: Privacy Settings
- Implement privacy controls
- Create settings endpoints
- Test privacy enforcement
- Update documentation

## Quality Assurance

### Code Review Checklist
- [ ] Security validation for all endpoints
- [ ] Proper error handling
- [ ] Database transaction management
- [ ] Input validation and sanitization
- [ ] Rate limiting implementation
- [ ] Logging and monitoring

### Performance Testing
- Load test authentication endpoints
- Test database query performance
- Monitor memory usage
- Test concurrent user scenarios

This completes the planning for Phase 1 implementation. Each feature should be implemented following the existing patterns established in the Google OAuth implementation.
