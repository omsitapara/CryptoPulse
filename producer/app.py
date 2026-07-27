from fastapi import FastAPI
from services.coingecko import CoinGeckoClient
from services.publisher import PubSubPublisher

client = CoinGeckoClient()
publisher = PubSubPublisher()

app = FastAPI(
    title="Crypto Producer Service",
    version="1.0.0"
)


@app.get("/")
def root():
    return {
        "service": "producer",
        "status": "running"
    }


@app.get("/health")
def health():
    return {
        "status": "healthy"
    }

@app.post("/publish")
def publish():
    prices = client.get_prices()

    message_ids = []
    for price in prices:
        message_id = publisher.publish(price)
        message_ids.append(message_id)

    return {
        "published": len(message_ids),
        "message_ids": message_ids
    }