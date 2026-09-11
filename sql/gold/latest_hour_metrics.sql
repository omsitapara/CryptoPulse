MERGE `crypto_gold.latest_hour_metrics` AS target

USING (
  SELECT
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
  FROM `crypto_gold.price_metrics`
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY symbol
    ORDER BY window_start DESC
  ) = 1
) AS source

ON target.symbol = source.symbol

WHEN MATCHED THEN
  UPDATE SET
    window_start = source.window_start,
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