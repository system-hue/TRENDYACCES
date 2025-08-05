import os
import firebase_admin
from firebase_admin import credentials, firestore, auth, storage
from typing import Dict, Any, Optional

class FirebaseConfig:
    """Firebase configuration and initialization"""
    
    def __init__(self):
        self.cred = None
        self.app = None
        self.db = None
        self.bucket = None
        
    def initialize(self):
        """Initialize Firebase Admin SDK"""
        if not firebase_admin._apps:
            # Initialize with environment variables
            self.cred = credentials.ApplicationDefault()
            self.app = firebase_admin.initialize_app(self.cred, {
                'storageBucket': os.getenv('FIREBASE_STORAGE_BUCKET', 'trendy-app.appspot.com')
            })
            self.db = firestore.client()
            self.bucket = storage.bucket()
            
    def get_db(self):
        """Get Firestore client"""
        if not self.db:
            self.initialize()
        return self.db
    
    def get_auth(self):
        """Get Firebase Auth client"""
        return auth
    
    def get_storage(self):
        """Get Firebase Storage bucket"""
        if not self.bucket:
            self.initialize()
        return self.bucket

firebase_config = FirebaseConfig()
