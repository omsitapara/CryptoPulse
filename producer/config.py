import os 

PROJECT_ID = os.getenv("GCP_PROJECT_ID","realtime-crypto-dev")
TOPIC_ID = os.getenv("PUBSUB_TOPIC_ID","live-crypto-prices")

CURRENCY = os.getenv("CURRENCY","inr")
REQUEST_TIMEOUT = int(os.getenv("REQUEST_TIMEOUT","10"))

SUPPORTED_COINS = tuple(os.getenv("SUPPORTED_COUNS","bitcoin,ethereum,solana,ripple,cardano").split(","))