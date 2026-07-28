from google.cloud import pubsub_v1

from config import PROJECT_ID,TOPIC_ID
from models import CryptoPrice

class PubSubPublisher:
    def __init__(self):
        self.publisher = pubsub_v1.PublisherClient()
        self.topic_path = self.publisher.topic_path(PROJECT_ID,TOPIC_ID)

    def publish(self, event:CryptoPrice)->str:
        message =event.model_dump_json().encode("utf-8")
        future = self.publisher.publish(
            self.topic_path,
            message
        )
        return future.result()