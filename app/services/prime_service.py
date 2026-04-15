from sqlalchemy.orm import Session
from app.db.models.prime import PrimeRequest


def generate_primes(start: int, end: int):
    if start < 2:
        start = 2

    sieve = [True] * (end + 1)
    sieve[0:2] = [False, False]

    for i in range(2, int(end ** 0.5) + 1):
        if sieve[i]:
            for j in range(i * i, end + 1, i):
                sieve[j] = False

    return [i for i in range(start, end + 1) if sieve[i]]


def create_prime_record(db: Session, start: int, end: int, primes: list):
    record = PrimeRequest(
        start=start,
        end=end,
        result=str(primes)
    )
    db.add(record)
    db.commit()


def get_history(db: Session):
    return db.query(PrimeRequest).all()