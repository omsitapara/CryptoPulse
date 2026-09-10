MERGE `crypto_gold.market_summary` AS target

USING (
  SELECT
    CURRENT_TIMESTAMP() AS summary_timestamp,
    COUNT(*) AS asset_count,
    (
      SELECT COUNT(*)
      FROM `crypto_silver.crypto_prices`
    ) AS total_events,

    ARRAY_AGG(
      STRUCT(symbol, price)
      ORDER BY price DESC
      LIMIT 1
    )[OFFSET(0)].symbol AS highest_price_symbol,

    MAX(price) AS highest_price,

    ARRAY_AGG(
      STRUCT(symbol, price_change_pct)
      ORDER BY price_change_pct DESC
      LIMIT 1
    )[OFFSET(0)].symbol AS largest_gain_symbol,

    MAX(price_change_pct) AS largest_gain_pct,

    ARRAY_AGG(
      STRUCT(symbol, price_change_pct)
      ORDER BY price_change_pct ASC
      LIMIT 1
    )[OFFSET(0)].symbol AS largest_loss_symbol,

    MIN(price_change_pct) AS largest_loss_pct

  FROM (
    SELECT
      lp.symbol,
      lp.price,
      pm.price_change_pct
    FROM `crypto_gold.latest_prices` AS lp
    LEFT JOIN (
      SELECT
        symbol,
        price_change_pct
      FROM `crypto_gold.price_metrics`
      QUALIFY ROW_NUMBER() OVER (
        PARTITION BY symbol
        ORDER BY window_start DESC
      ) = 1
    ) AS pm
    ON lp.symbol = pm.symbol
  )
) AS source

ON TRUE

WHEN MATCHED THEN
  UPDATE SET
    summary_timestamp = source.summary_timestamp,
    asset_count = source.asset_count,
    total_events = source.total_events,
    highest_price_symbol = source.highest_price_symbol,
    highest_price = source.highest_price,
    largest_gain_symbol = source.largest_gain_symbol,
    largest_gain_pct = source.largest_gain_pct,
    largest_loss_symbol = source.largest_loss_symbol,
    largest_loss_pct = source.largest_loss_pct

WHEN NOT MATCHED THEN
  INSERT (
    summary_timestamp,
    asset_count,
    total_events,
    highest_price_symbol,
    highest_price,
    largest_gain_symbol,
    largest_gain_pct,
    largest_loss_symbol,
    largest_loss_pct
  )
  VALUES (
    source.summary_timestamp,
    source.asset_count,
    source.total_events,
    source.highest_price_symbol,
    source.highest_price,
    source.largest_gain_symbol,
    source.largest_gain_pct,
    source.largest_loss_symbol,
    source.largest_loss_pct
  );