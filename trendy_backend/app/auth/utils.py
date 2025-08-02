import firebase_admin
from firebase_admin import credentials, auth
from passlib.context import CryptContext

cred = credentials.Certificate("firebase-key.json")
firebase_admin.initialize_app(cred)

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

def verify_token(token: str):
    try:
        decoded = auth.verify_id_token(token)
        return decoded
    except Exception:
        return None

def get_current_user(token: str):
    user_data = verify_token(token)
    if user_data is None:
        raise HTTPException(status_code=403, detail="Invalid token")
    return user_data
