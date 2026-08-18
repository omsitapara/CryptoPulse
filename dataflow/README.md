# Dataflow Pipeline

Apache Beam / Google Cloud Dataflow pipeline for processing real-time cryptocurrency price events from Pub/Sub.

The pipeline validates incoming events, routes valid events to the Bronze layer in BigQuery, and sends invalid events to a Dead Letter Queue (DLQ).

---

## Architecture

```text
Cloud Run Producer
        │
        ▼
     Pub/Sub
        │
        ▼
   Dataflow / Beam
        │
        ▼
    Parse JSON
        │
        ▼
   Event Validator
      /       \
     /         \
  Valid       Invalid
    │             │
    ▼             ▼
Add Ingest     Publish to
Timestamp       DLQ
    │             │
    ▼             ▼
 BigQuery      crypto-dlq
  Bronze