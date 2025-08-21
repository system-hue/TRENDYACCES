"""
Email Verification System for Trendy App
"""

from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.user import User
from app.auth.jwt_handler import create_access_token
import secrets
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import os

router = APIRouter(prefix="/auth/verify", tags=["Email Verification"])

# Email configuration
SMTP_SERVER = os.getenv("SMTP_SERVER", "smtp.gmail.com")
SMTP_PORT = int(os.getenv("SMTP_PORT", "587"))
SMTP_USERNAME = os.getenv("SMTP_USERNAME", "your-email@gmail.com")
SMTP_PASSWORD = os.getenv("SMTP_PASSWORD", "your-app-password")
FROM_EMAIL = os.getenv("FROM_EMAIL", "noreply@trendy.app")

def generate_verification_token():
    """Generate a secure verification token"""
    return secrets.token_urlsafe(32)

def send_verification_email(email: str, token: str):
    """Send verification email to user"""
    try:
        msg = MIMEMultipart()
        msg['From'] = FROM_EMAIL
        msg['To'] = email
        msg['Subject'] = "Verify your Trendy account"
        
        verification_url = f"https://trendy.app/verify-email?token={token}"
        
        body = f"""
        <html>
            <body>
                <h2>Welcome to Trendy!</h2>
                <p>Please click the link below to verify your email address:</p>
                <p><a href="{verification_url}" style="background-color: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Verify Email</a></p>
                <p>If you didn't create this account, please ignore this email.</p>
            </body>
        </html>
        """
        
        msg.attach(MIMEText(body, 'html'))
        
        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()
        server.login(SMTP_USERNAME, SMTP_PASSWORD)
        server.send_message(msg)
        server.quit()
        
        return True
    except Exception as e:
        print(f"Error sending email: {e}")
        return False

@router.post("/send")
async def send_verification(user_id: int, db: Session = Depends(get_db)):
    """Send verification email to user"""
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    if user.is_verified:
        raise HTTPException(status_code=400, detail="Email already verified")
    
    # Generate verification token
    token = generate_verification_token()
    
    # Store token in user record (in production, use a separate table)
    user.verification_token = token
    db.commit()
    
    # Send email
    if send_verification_email(user.email, token):
        return {"message": "Verification email sent successfully"}
    else:
        raise HTTPException(status_code=500, detail="Failed to send verification email")

@router.post("/verify")
async def verify_email(token: str, db: Session = Depends(get_db)):
    """Verify email with token"""
    user = db.query(User).filter(User.verification_token == token).first()
    if not user:
        raise HTTPException(status_code=400, detail="Invalid verification token")
    
    user.is_verified = True
    user.verification_token = None
    db.commit()
    
    return {"message": "Email verified successfully"}
