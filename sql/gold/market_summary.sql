MERGE `crypto_gold.market_summary` AS T

USING (
  WITH latest_metrics AS (
    SELECT
      symbol,
      price_change_pct
    FROM (
      SELECT
        symbol,
        price_change_pct,
        ROW_NUMBER() OVER (
          PARTITION BY symbol
          ORDER BY window_start DESC
        ) AS rn
      FROM `crypto_gold.price_metrics`
    )
    WHERE rn = 1
  ),

  market_stats AS (
    SELECT
      COUNT(*) AS asset_count,
      SUM(event_count) AS total_events
    FROM latest_metrics lm
    LEFT JOIN (
      SELECT
        symbol,
        event_count
      FROM (
        SELECT
          symbol,
          event_count,
          ROW_NUMBER() OVER (
            PARTITION BY symbol
            ORDER BY window_start DESC
          ) AS rn
        FROM `crypto_gold.price_metrics`
      )
      WHERE rn = 1
    ) ec
    ON lm.symbol = ec.symbol
  ),

  highest_price AS (
    SELECT
      symbol,
      price
    FROM (
      SELECT
        symbol,
        price,
        ROW_NUMBER() OVER (
          ORDER BY price DESC
        ) AS rn
      FROM `crypto_gold.latest_prices`
    )
    WHERE rn = 1
  ),

  largest_gain AS (
    SELECT
      symbol,
      price_change_pct
    FROM latest_metrics
    WHERE price_change_pct > 0
    QUALIFY ROW_NUMBER() OVER (
      ORDER BY price_change_pct DESC
    ) = 1
  ),

  largest_loss AS (
    SELECT
      symbol,
      price_change_pct
    FROM latest_metrics
    WHERE price_change_pct < 0
    QUALIFY ROW_NUMBER() OVER (
      ORDER BY price_change_pct ASC
    ) = 1
  )

  SELECT
    CURRENT_TIMESTAMP() AS summary_timestamp,

    ms.asset_count,
    ms.total_events,

    hp.symbol AS highest_price_symbol,
    hp.price AS highest_price,

    lg.symbol AS largest_gain_symbol,
    lg.price_change_pct AS largest_gain_pct,

    ll.symbol AS largest_loss_symbol,
    ll.price_change_pct AS largest_loss_pct

  FROM market_stats ms
  CROSS JOIN highest_price hp
  LEFT JOIN largest_gain lg
    ON TRUE
  LEFT JOIN largest_loss ll
    ON TRUE

) AS S

ON TRUE

WHEN MATCHED THEN
UPDATE SET
  summary_timestamp = S.summary_timestamp,
  asset_count = S.asset_count,
  total_events = S.total_events,
  highest_price_symbol = S.highest_price_symbol,
  highest_price = S.highest_price,
  largest_gain_symbol = S.largest_gain_symbol,
  largest_gain_pct = S.largest_gain_pct,
  largest_loss_symbol = S.largest_loss_symbol,
  largest_loss_pct = S.largest_loss_pct

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
  S.summary_timestamp,
  S.asset_count,
  S.total_events,
  S.highest_price_symbol,
  S.highest_price,
  S.largest_gain_symbol,
  S.largest_gain_pct,
  S.largest_loss_symbol,
  S.largest_loss_pct
);