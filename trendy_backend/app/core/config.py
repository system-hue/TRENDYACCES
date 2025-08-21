import os
from typing import Optional
from pydantic import BaseSettings, Field
from functools import lru_cache

class Settings(BaseSettings):
    # Environment
    env: str = Field(default="development", env="ENV")
    debug: bool = Field(default=True, env="DEBUG")
    
    # Database
    database_url: str = Field(..., env="DATABASE_URL")
    db_kind: str = Field(default="postgres", env="DB_KIND")
    
    # Redis
    redis_url: str = Field(..., env="REDIS_URL")
    
    # Firebase
    firebase_project_id: str = Field(..., env="FIREBASE_PROJECT_ID")
    firebase_credentials_json_path: str = Field(..., env="FIREBASE_CREDENTIALS_JSON_PATH")
    
    # API Keys
    apisports_key: str = Field(..., env="APISPORTS_KEY")
    spotify_client_id: str = Field(..., env="SPOTIFY_CLIENT_ID")
    spotify_client_secret: str = Field(..., env="SPOTIFY_CLIENT_SECRET")
    tmdb_api_key: str = Field(..., env="TMDB_API_KEY")
    
    # Payment Providers
    stripe_secret_key: str = Field(..., env="STRIPE_SECRET_KEY")
    stripe_webhook_secret: str = Field(..., env="STRIPE_WEBHOOK_SECRET")
    google_play_service_acc_json_path: str = Field(..., env="GOOGLE_PLAY_SERVICE_ACC_JSON_PATH")
    apple_api_key_id: str = Field(..., env="APPLE_API_KEY_ID")
    apple_issuer_id: str = Field(..., env="APPLE_ISSUER_ID")
    apple_private_key_path: str = Field(..., env="APPLE_PRIVATE_KEY_PATH")
    
    # AdMob
    admob_banner_id: str = Field(..., env="ADMOB_BANNER_ID")
    admob_interstitial_id: str = Field(..., env="ADMOB_INTERSTITIAL_ID")
    admob_rewarded_id: str = Field(..., env="ADMOB_REWARDED_ID")
    
    # Storage
    cloud_storage_bucket: str = Field(..., env="CLOUD_STORAGE_BUCKET")
    cdn_url: str = Field(..., env="CDN_URL")
    
    # Monitoring
    sentry_dsn: Optional[str] = Field(default=None, env="SENTRY_DSN")
    otel_exporter_otlp_endpoint: Optional[str] = Field(default=None, env="OTEL_EXPORTER_OTLP_ENDPOINT")
    
    # Security
    secret_key: str = Field(..., env="SECRET_KEY")
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
