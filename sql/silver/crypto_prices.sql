MERGE `crypto_silver.crypto_prices` AS target

USING (
  SELECT
    event_id,
    event_timestamp,
    LOWER(TRIM(symbol)) AS symbol,
    price,
    UPPER(TRIM(currency)) AS currency,
    source,
    producer_version,
    ingest_timestamp

  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (
        PARTITION BY event_id
        ORDER BY ingest_timestamp DESC
      ) AS rn

    FROM `crypto_bronze.crypto_prices`

    WHERE event_id IS NOT NULL
      AND event_timestamp IS NOT NULL
      AND price IS NOT NULL
  )

  WHERE rn = 1
) AS source

ON target.event_id = source.event_id

WHEN NOT MATCHED THEN
  INSERT (
    event_id,
    event_timestamp,
    symbol,
    price,
    currency,
    source,
    producer_version,
    ingest_timestamp
  )
  VALUES (
    source.event_id,
    source.event_timestamp,
    source.symbol,
    source.price,
    source.currency,
    source.source,
    source.producer_version,
    source.ingest_timestamp
  );