from fastapi import APIRouter, HTTPException, Header
from pydantic import BaseModel
import os
from app.auth.middleware import verify_firebase_token

router = APIRouter()

# Agora configuration
AGORA_APP_ID = "ca957e7ecf104efd8704f26f9848a2df"
AGORA_PRIMARY_CERTIFICATE = "e5937c2b7826413386f9f5f3f004e488"

class TokenRequest(BaseModel):
    channel_name: str
    uid: int

@router.post("/agora/token")
async def generate_agora_token(request: TokenRequest, authorization: str | None = Header(default=None)):
    """Generate Agora token for voice/video calls and live streaming. Accepts any Bearer token (e.g., Firebase) in dev."""
    try:
        # Optional: validate provided bearer token in development
        if authorization and authorization.startswith("Bearer "):
            token = authorization.split(" ", 1)[1]
            # Verify Firebase token
            await verify_firebase_token(token)
        
        # Import Agora token builder
        from agora_token_builder import RtcTokenBuilder
        
        # Generate token with 24-hour expiration
        expiration_time_in_seconds = 3600 * 24
        current_timestamp = int(os.environ.get("CURRENT_TIMESTAMP", "0"))
        privilege_expired_ts = current_timestamp + expiration_time_in_seconds
        
        # Generate RTC token
        token = RtcTokenBuilder.build_token_with_uid(
            AGORA_APP_ID,
            AGORA_PRIMARY_CERTIFICATE,
            request.channel_name,
            request.uid,
            RtcTokenBuilder.Role_Publisher,
            privilege_expired_ts
        )
        
        return {"token": token}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to generate token: {str(e)}")