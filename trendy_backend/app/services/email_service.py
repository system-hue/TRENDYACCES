"""
Email Service for TRENDY App
Handles sending verification emails and other email-related functionalities
"""

import os
from fastapi import HTTPException
from fastapi_mail import FastMail, MessageSchema, ConnectionConfig
from pydantic import EmailStr

class EmailService:
    def __init__(self):
        self.conf = ConnectionConfig(
            MAIL_USERNAME=os.getenv("MAIL_USERNAME"),
            MAIL_PASSWORD=os.getenv("MAIL_PASSWORD"),
            MAIL_FROM=os.getenv("MAIL_FROM"),
            MAIL_PORT=int(os.getenv("MAIL_PORT")),
            MAIL_SERVER=os.getenv("MAIL_SERVER"),
            MAIL_FROM_NAME=os.getenv("MAIL_FROM_NAME"),
            MAIL_TLS=True,
            MAIL_SSL=False,
            USE_CREDENTIALS=True,
            VALIDATE_CERTS=True
        )
    
    async def send_verification_email(self, email: EmailStr, token: str):
        """
        Send verification email to the user
        """
        try:
            link = f"http://localhost:8000/verify-email?token={token}"
            message = MessageSchema(
                subject="Email Verification",
                recipients=[email],
                body=f"Please verify your email by clicking on the following link: {link}",
                subtype="html"
            )
            fm = FastMail(self.conf)
            await fm.send_message(message)
        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f"Failed to send verification email: {str(e)}"
            )

email_service = EmailService()
