MERGE `crypto_gold.latest_prices` AS target

USING (
  SELECT
    symbol,
    price,
    currency,
    event_timestamp,
    source,
    producer_version,
    ingest_timestamp
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (
        PARTITION BY symbol
        ORDER BY event_timestamp DESC, ingest_timestamp DESC
      ) AS rn
    FROM `crypto_silver.crypto_prices`
  )
  WHERE rn = 1
) AS source

ON target.symbol = source.symbol

WHEN MATCHED THEN
  UPDATE SET
    price = source.price,
    currency = source.currency,
    event_timestamp = source.event_timestamp,
    source = source.source,
    producer_version = source.producer_version,
    ingest_timestamp = source.ingest_timestamp

WHEN NOT MATCHED THEN
  INSERT (
    symbol,
    price,
    currency,
    event_timestamp,
    source,
    producer_version,
    ingest_timestamp
  )
  VALUES (
    source.symbol,
    source.price,
    source.currency,
    source.event_timestamp,
    source.source,
    source.producer_version,
    source.ingest_timestamp
  );