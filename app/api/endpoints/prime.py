from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session

from app.api.deps import get_db
from app.schemas import PrimeResponseSchema, HistorySchema
from app.services.prime_service import (
    generate_primes,
    create_prime_record,
    get_history
)

router = APIRouter()

@router.get("/primes", response_model=PrimeResponseSchema)
def get_primes_api(start: int, end: int, db: Session = Depends(get_db)):
    if start > end:
        raise HTTPException(status_code=400, detail="Start must be less than end")

    primes = generate_primes(start, end)
    create_prime_record(db, start, end, primes)

    return PrimeResponseSchema(
        range=[start, end],
        count=len(primes),
        primes=primes
    )


@router.get("/history", response_model=list[HistorySchema])
def get_history_api(db: Session = Depends(get_db)):
    return get_history(db)