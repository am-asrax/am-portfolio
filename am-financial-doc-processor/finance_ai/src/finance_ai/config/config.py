from pydantic import BaseSettings

class Settings(BaseSettings):
    MONGO_URI: str = "mongodb://localhost:27017"
    DATABASE_NAME: str = "finance_db"
    COLLECTION_NAME: str = "fund_data"
    OPENAI_API_KEY: str
    
    class Config:
        env_file = ".env"

settings = Settings()
