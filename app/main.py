from fastapi import FastAPI
from app.api.router import api_router
from app.db.database import Base, engine
from app.db.models import PrimeRequest

Base.metadata.create_all(bind=engine)

app = FastAPI()

app.include_router(api_router)