from fastapi import APIRouter

router = APIRouter()

@router.get("/health")
def health():
    return {"status": "healthy"}


@router.get("/")
def root():
    return {
        "message": "Prime Number Generator API",
        "endpoints": {
            "generate_primes": "/primes?start=1&end=10",
            "history": "/history",
            "docs": "/docs"
        },
        "status": "running"
    }