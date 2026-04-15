from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    DATABASE_URL: str = "postgresql://user:password@db:5432/primes"
    APP_NAME: str = "Prime Service"
    DEBUG: bool = True

    class Config:
        env_file = ".env"


settings = Settings()