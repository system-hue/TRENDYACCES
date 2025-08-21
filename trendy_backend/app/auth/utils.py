from fastapi import HTTPException, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from passlib.context import CryptContext
from .jwt_handler import decode_token

# Mock Firebase configuration for development
# In production, replace with actual Firebase credentials
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
security = HTTPBearer()

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

# Unified FastAPI dependency that returns the authenticated user's ID
# Expects a Bearer token created by jwt_handler.create_access_token with {"sub": user.id}

def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)) -> int:
    try:
        token = credentials.credentials
        payload = decode_token(token)
        user_id = payload.get("sub")
        if user_id is None:
            raise HTTPException(status_code=401, detail="Invalid token payload")
        return user_id
    except Exception:
        raise HTTPException(status_code=401, detail="Could not validate credentials")
