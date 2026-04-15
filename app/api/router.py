from fastapi import APIRouter
from app.api.endpoints import prime, health

api_router = APIRouter()

api_router.include_router(prime.router)
api_router.include_router(health.router)