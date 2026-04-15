from pydantic import BaseModel
from datetime import datetime
from typing import List


class PrimeRequestSchema(BaseModel):
    start: int
    end: int


class PrimeResponseSchema(BaseModel):
    range: List[int]
    count: int
    primes: List[int]


class HistorySchema(BaseModel):
    start: int
    end: int
    result: str
    created_at: datetime

    class Config:
        from_attributes = True