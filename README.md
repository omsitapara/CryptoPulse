# Real-Time Event-Driven Analytics Platform

A production-grade real-time analytics platform built on **Google Cloud Platform (GCP)** using **Pub/Sub**, **Apache Beam (Dataflow)**, **Cloud Run**, and **BigQuery**.

The platform ingests live cryptocurrency market data, processes it through a streaming ETL pipeline, validates incoming events, stores data using the Medallion Architecture (Bronze → Silver → Gold), and serves analytics through REST APIs and dashboards.

---

## Features

* Event-driven architecture using Google Cloud Pub/Sub
* Real-time streaming ETL with Apache Beam (Dataflow)
* Medallion Architecture (Bronze, Silver, Gold)
* Automated data quality validation
* Dead Letter Queue (DLQ) for invalid events
* BigQuery as the analytical data warehouse
* REST API built with Cloud Run
* CI/CD using GitHub Actions
* Monitoring and logging using Google Cloud Operations Suite
* Interactive dashboards using Looker Studio

---

## Architecture

The platform follows an event-driven architecture where data is ingested, validated, transformed, and aggregated before being exposed for analytics.

```text
                External Data Source
                        │
                        ▼
                 Cloud Run Producer
                        │
                        ▼
                    Pub/Sub Topic
                        │
                        ▼
             Apache Beam (Dataflow)
                │                │
                │                │
          Valid Events     Invalid Events
                │                │
                ▼                ▼
        BigQuery Bronze   Dead Letter Queue
                │
                ▼
        BigQuery Silver
                │
                ▼
         BigQuery Gold
          │            │
          ▼            ▼
     Cloud Run API  Looker Studio
```

> A detailed architecture diagram will be added as the project progresses.

---

## Technology Stack

| Category          | Technology                       |
| ----------------- | -------------------------------- |
| Language          | Python                           |
| Cloud Platform    | Google Cloud Platform            |
| Messaging         | Pub/Sub                          |
| Stream Processing | Apache Beam (Dataflow)           |
| Data Warehouse    | BigQuery                         |
| Compute           | Cloud Run                        |
| CI/CD             | GitHub Actions                   |
| Visualization     | Looker Studio                    |
| Monitoring        | Cloud Monitoring & Cloud Logging |

---

## Repository Structure

```text
.
├── .github/
│   └── workflows/
├── producer/
├── dataflow/
├── api/
├── sql/
├── .gitignore
├── LICENSE
└── README.md
```

---

## Project Roadmap

* [x] Repository initialization
* [ ] Cloud Run Producer
* [ ] Pub/Sub Integration
* [ ] Streaming Dataflow Pipeline
* [ ] Bronze Layer
* [ ] Silver Layer
* [ ] Gold Layer
* [ ] REST API
* [ ] GitHub Actions CI/CD
* [ ] Monitoring and Logging
* [ ] Looker Studio Dashboard

---

## License

This project is licensed under the MIT License.
