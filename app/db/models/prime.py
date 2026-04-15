from sqlalchemy import Column, Integer, String, DateTime
from datetime import datetime, timezone
from app.db.database import Base


class PrimeRequest(Base):
    __tablename__ = "prime_requests"

    id = Column(Integer, primary_key=True, index=True)
    start = Column(Integer)
    end = Column(Integer)
    result = Column(String)
    created_at = Column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc)
    )