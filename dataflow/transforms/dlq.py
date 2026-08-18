import json 
import apache_beam as beam 
from google.cloud import pubsub_v1
from config import PROJECT_ID,DLQ_TOPIC_ID

class PublishToDLQ(beam.DoFn):
    def setup(self):
        self.publisher = pubsub_v1.PublisherClient()
        self.topic_path = self.publisher.topic_path(
            PROJECT_ID,
            DLQ_TOPIC_ID
        )

    def process(self,element):
        message = json.dumps(element).encode("utf-8")
        self.publisher.publish(self.topic_path,message)