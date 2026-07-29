import json 
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions
from apache_beam.io.gcp.pubsub import ReadFromPubSub
from apache_beam.io.gcp.bigquery import WriteToBigQuery
from apache_beam.io.gcp.bigquery import BigQueryDisposition
from datetime import datetime,timezone

from config import PROJECT_ID, SUBSCRIPTION_ID, BRONZE_TABLE


class ParseMessage(beam.DoFn):
    def process(self, element):
        message = element.decode("utf-8")
        data = json.loads(message)

        print(data)
        yield data

class AddIngestTimestamp(beam.DoFn):
    def process(self, element):
        element["ingest_timestamp"]=(
            datetime.now(timezone.utc).isoformat()
        )
        yield element


def run():

    options = PipelineOptions(
        streaming=True,
        project=PROJECT_ID,
    )

    with beam.Pipeline(options=options) as pipeline:

        (
            pipeline
            | "Read PubSub" >> ReadFromPubSub(
                subscription=f"projects/{PROJECT_ID}/subscriptions/{SUBSCRIPTION_ID}"
            )
            | "Parse JSON" >> beam.ParDo(ParseMessage())
            | "Add Ingest Timestamp" >> beam.ParDo(AddIngestTimestamp())
            | "Write to Bronze" >> WriteToBigQuery(
                table=BRONZE_TABLE,
                write_disposition= BigQueryDisposition.WRITE_APPEND,
                create_disposition=BigQueryDisposition.CREATE_NEVER
            )
        )


if __name__ == "__main__":
    run()