# Unimplemented Features and Improvements for TRENDY App

## 1. Email Verification & User Relationships Implementation
### Phase 2: Email Service
- Create email service utilities
- Configure SMTP settings

### Phase 3: Email Verification Routes
- Create email verification endpoints
- Implement send verification email
- Implement verify email endpoint
- Implement password reset request
- Implement password reset confirmation

### Phase 4: Routes Configuration
- Update routes `__init__.py` to export all modules
- Add email verification routes to `main.py`

### Phase 5: Testing
- Test all endpoints
- Verify email sending works
- Test database migrations

## 2. Stripe Service Enhancements
- Update user subscription in the database
- Update subscription status in the database
- Mark subscription as canceled in the database
- Record successful payment in the database

## 3. Shop API Enhancements
- Implement ML-based recommendations using user preferences

## 4. Photos API Enhancements
- Store user preferences
- Retrieve from user preferences
- Retrieve from user history
