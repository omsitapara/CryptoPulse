import os

PROJECT_ID = os.getenv("GCP_PROJECT_ID", "realtime-crypto-dev")
DLQ_TOPIC_ID = "crypto-dlq"

SUBSCRIPTION_ID = os.getenv(
    "PUBSUB_SUBSCRIPTION_ID",
    "crypto-price-subscription-v2"
)

BRONZE_TABLE = (
    f"{PROJECT_ID}:crypto_bronze.crypto_prices"
)

REGION = "us-central1"

TEMP_LOCATION = (
    f"gs://realtime-crypto-dev/dataflow/temp"
)

STAGING_LOCATION = (
    f"gs://realtime-crypto-dev/dataflow/staging"
)