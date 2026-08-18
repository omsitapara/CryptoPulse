from datetime import datetime
from pydantic import BaseModel


class CryptoPrice(BaseModel):
    event_id: str
    event_timestamp: datetime

    symbol: str
    price: float
    currency: str

    source: str
    producer_version: str