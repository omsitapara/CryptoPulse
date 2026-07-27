import os 

PROJECT_ID = os.getenv("GCP_PROJECT_ID","realtime-crypto-dev")
TOPIC_ID = os.getenv("PUBSUB_TOPIC_ID","live-crypto-prices")