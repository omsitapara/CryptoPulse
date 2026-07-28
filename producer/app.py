import logging
from fastapi import FastAPI
from services.coingecko import CoinGeckoClient
from services.publisher import PubSubPublisher

client = CoinGeckoClient()
publisher = PubSubPublisher()
logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

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
    logger.info("Fetching latest cryptocurrency prices......")
    prices = client.get_prices()
    logger.info("Fetched %d cryptocurrency prices",len(prices))

    message_ids = []
    for price in prices:
        message_id = publisher.publish(price)
        message_ids.append(message_id)
        logger.info("Published %s with MessageID %s",price.symbol,message_id)

    logger.info("Successfully published %d events.",len(message_ids))

    return {
        "published": len(message_ids),
        "message_ids": message_ids
    }