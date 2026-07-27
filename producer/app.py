from fastapi import FastAPI

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