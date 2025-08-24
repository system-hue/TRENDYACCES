import os
from typing import Optional
from pydantic import Field
from pydantic_settings import BaseSettings
from functools import lru_cache

class Settings(BaseSettings):
    # Environment
    env: str = Field(default="development", env="ENV")
    debug: bool = Field(default=True, env="DEBUG")
    
    # Database
    database_url: str = Field(default="sqlite:///./trendy.db", env="DATABASE_URL")
    db_kind: str = Field(default="sqlite", env="DB_KIND")
    
    # Redis
    redis_url: str = Field(default="redis://localhost:6379", env="REDIS_URL")
    
    # Firebase
    firebase_project_id: str = Field(default="trendy-app-dev", env="FIREBASE_PROJECT_ID")
    firebase_credentials_json_path: str = Field(default="firebase-credentials.json", env="FIREBASE_CREDENTIALS_JSON_PATH")
    firebase_api_key: str = Field(default="your_firebase_api_key_here", env="FIREBASE_API_KEY")
    
    # API Keys
    apisports_key: str = Field(default="your_apisports_key_here", env="APISPORTS_KEY")
    spotify_client_id: str = Field(default="your_spotify_client_id_here", env="SPOTIFY_CLIENT_ID")
    spotify_client_secret: str = Field(default="your_spotify_client_secret_here", env="SPOTIFY_CLIENT_SECRET")
    tmdb_api_key: str = Field(default="your_tmdb_api_key_here", env="TMDB_API_KEY")
    
    # Social OAuth
    google_client_id: str = Field(default="your_google_client_id", env="GOOGLE_CLIENT_ID")
    facebook_client_id: str = Field(default="your_facebook_client_id", env="FACEBOOK_CLIENT_ID")
    facebook_client_secret: str = Field(default="your_facebook_client_secret", env="FACEBOOK_CLIENT_SECRET")
    
    # Payment Providers
    stripe_secret_key: str = Field(default="sk_test_your_stripe_secret_key_here", env="STRIPE_SECRET_KEY")
    stripe_webhook_secret: str = Field(default="whsec_your_webhook_secret_here", env="STRIPE_WEBHOOK_SECRET")
    google_play_service_acc_json_path: str = Field(default="google-play-service-account.json", env="GOOGLE_PLAY_SERVICE_ACC_JSON_PATH")
    apple_api_key_id: str = Field(default="your_apple_api_key_id_here", env="APPLE_API_KEY_ID")
    apple_issuer_id: str = Field(default="your_apple_issuer_id_here", env="APPLE_ISSUER_ID")
    apple_private_key_path: str = Field(default="apple-private-key.p8", env="APPLE_PRIVATE_KEY_PATH")
    
    # AdMob
    admob_banner_id: str = Field(default="ca-app-pub-3940256099942544/6300978111", env="ADMOB_BANNER_ID")
    admob_interstitial_id: str = Field(default="ca-app-pub-3940256099942544/1033173712", env="ADMOB_INTERSTITIAL_ID")
    admob_rewarded_id: str = Field(default="ca-app-pub-3940256099942544/5224354917", env="ADMOB_REWARDED_ID")
    
    # Storage
    cloud_storage_bucket: str = Field(default="your-cloud-storage-bucket", env="CLOUD_STORAGE_BUCKET")
    cdn_url: str = Field(default="https://cdn.yourdomain.com", env="CDN_URL")
    
    # Monitoring
    sentry_dsn: Optional[str] = Field(default=None, env="SENTRY_DSN")
    otel_exporter_otlp_endpoint: Optional[str] = Field(default=None, env="OTEL_EXPORTER_OTLP_ENDPOINT")
    
    # Security
    secret_key: str = Field(default="your-super-secret-key-change-this-in-production", env="SECRET_KEY")
    jwt_algorithm: str = Field(default="HS256", env="JWT_ALGORITHM")
    access_token_expire_minutes: int = Field(default=30, env="ACCESS_TOKEN_EXPIRE_MINUTES")
    
    # Rate Limiting
    rate_limit_per_minute: int = Field(default=60, env="RATE_LIMIT_PER_MINUTE")
    rate_limit_per_hour: int = Field(default=1000, env="RATE_LIMIT_PER_HOUR")
    
    # Cache
    cache_ttl: int = Field(default=3600, env="CACHE_TTL")
    
    class Config:
        env_file = ".env"
        case_sensitive = False

@lru_cache()
def get_settings() -> Settings:
    return Settings()
