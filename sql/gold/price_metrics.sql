MERGE `crypto_gold.price_metrics` AS target

USING (
  SELECT
    symbol,
    TIMESTAMP_TRUNC(event_timestamp, HOUR) AS window_start,

    ARRAY_AGG(price ORDER BY event_timestamp ASC LIMIT 1)[OFFSET(0)]
      AS opening_price,

    ARRAY_AGG(price ORDER BY event_timestamp DESC LIMIT 1)[OFFSET(0)]
      AS closing_price,

    AVG(price) AS avg_price,
    MIN(price) AS min_price,
    MAX(price) AS max_price,

    ARRAY_AGG(price ORDER BY event_timestamp DESC LIMIT 1)[OFFSET(0)]
      - ARRAY_AGG(price ORDER BY event_timestamp ASC LIMIT 1)[OFFSET(0)]
      AS price_change,

    SAFE_DIVIDE(
      ARRAY_AGG(price ORDER BY event_timestamp DESC LIMIT 1)[OFFSET(0)]
      - ARRAY_AGG(price ORDER BY event_timestamp ASC LIMIT 1)[OFFSET(0)],
      ARRAY_AGG(price ORDER BY event_timestamp ASC LIMIT 1)[OFFSET(0)]
    ) * 100 AS price_change_pct,

    COUNT(*) AS event_count

  FROM `crypto_silver.crypto_prices`

  WHERE symbol IS NOT NULL
    AND price IS NOT NULL
    AND event_timestamp IS NOT NULL

  GROUP BY
    symbol,
    window_start
) AS source

ON target.symbol = source.symbol
AND target.window_start = source.window_start

WHEN MATCHED THEN
  UPDATE SET
    opening_price = source.opening_price,
    closing_price = source.closing_price,
    avg_price = source.avg_price,
    min_price = source.min_price,
    max_price = source.max_price,
    price_change = source.price_change,
    price_change_pct = source.price_change_pct,
    event_count = source.event_count

WHEN NOT MATCHED THEN
  INSERT (
    symbol,
    window_start,
    opening_price,
    closing_price,
    avg_price,
    min_price,
    max_price,
    price_change,
    price_change_pct,
    event_count
  )
  VALUES (
    source.symbol,
    source.window_start,
    source.opening_price,
    source.closing_price,
    source.avg_price,
    source.min_price,
    source.max_price,
    source.price_change,
    source.price_change_pct,
    source.event_count
  );