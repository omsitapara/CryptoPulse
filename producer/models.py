from datetime import datetime
from pydantic import BaseModel

class CryptoPrice(BaseModel):
    symbol:str
    name:str 
    price:float
    currency:str
    source:str
    event_timestamp:datetime