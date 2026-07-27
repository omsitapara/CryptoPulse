from fastapi import FastAPI
from services.coingecko import CoinGeckoclient

client = CoinGeckoclient()

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

@app.get("/prices")
def get_prices():
    return client.get_prices()