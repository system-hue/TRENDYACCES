from fastapi import HTTPException
from passlib.context import CryptContext

# Mock Firebase configuration for development
# In production, replace with actual Firebase credentials
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

def verify_token(token: str):
    # Mock token verification for development
    # In production, use actual Firebase token verification
    if token and len(token) > 10:
        return {"uid": "mock-user-id", "email": "mock@example.com"}
    return None

def get_current_user(token: str):
    user_data = verify_token(token)
    if user_data is None:
        raise HTTPException(status_code=403, detail="Invalid token")
    return user_data
