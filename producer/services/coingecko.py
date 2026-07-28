from datetime import datetime,timezone
import httpx
from models import CryptoPrice
from config import SUPPORTED_COINS,CURRENCY,REQUEST_TIMEOUT

class CoinGeckoClient:
    BASE_URL = "https://api.coingecko.com/api/v3"

    def __init__(self,timeout:int = 10):
        self.timeout = timeout

    def get_prices(self)-> list[dict]:
        url = f"{self.BASE_URL}/simple/price"
        params = {
            "ids": ",".join(SUPPORTED_COINS),
            "vs_currencies": CURRENCY
        }

        with httpx.Client(timeout=REQUEST_TIMEOUT) as client:
            response = client.get(url, params=params)
            response.raise_for_status()

        data = response.json()

        events = []

        for coin,values in data.items():
            events.append(
                CryptoPrice(
                    symbol=coin.upper(),
                    name=coin.title(),
                    price=values["inr"],
                    currency="INR",
                    source="CoinGecko",
                    event_timestamp=datetime.now(timezone.utc).isoformat()
                )
            )

        return events