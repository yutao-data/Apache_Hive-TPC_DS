WITH date_dim_bucket AS (
  SELECT *
  FROM date_dim
  WHERE d_week_seq = (SELECT d_week_seq
                      FROM date_dim
                      WHERE d_date = '2000-07-21' LIMIT 1)
)

, ss_items AS (
  SELECT i_item_id AS item_id,
         SUM(ss_ext_sales_price) AS ss_item_rev
  FROM store_sales
  JOIN item ON ss_item_sk = i_item_sk
  JOIN date_dim_bucket ON ss_sold_date_sk = d_date_sk
  GROUP BY i_item_id
)

, cs_items AS (
  SELECT i_item_id AS item_id,
         SUM(cs_ext_sales_price) AS cs_item_rev
  FROM catalog_sales
  JOIN item ON cs_item_sk = i_item_sk
  JOIN date_dim_bucket ON cs_sold_date_sk = d_date_sk
  GROUP BY i_item_id
)

, ws_items AS (
  SELECT i_item_id AS item_id,
         SUM(ws_ext_sales_price) AS ws_item_rev
  FROM web_sales
  JOIN item ON ws_item_sk = i_item_sk
  JOIN date_dim_bucket ON ws_sold_date_sk = d_date_sk
  GROUP BY i_item_id
)

SELECT
  ss.item_id,
  ss_item_rev,
  ss_item_rev / ((ss_item_rev + cs_item_rev + ws_item_rev) / 3) * 100 AS ss_dev,
  cs_item_rev,
  cs_item_rev / ((ss_item_rev + cs_item_rev + ws_item_rev) / 3) * 100 AS cs_dev,
  ws_item_rev,
  ws_item_rev / ((ss_item_rev + cs_item_rev + ws_item_rev) / 3) * 100 AS ws_dev,
  (ss_item_rev + cs_item_rev + ws_item_rev) / 3 AS average
FROM ss_items ss
JOIN cs_items cs ON ss.item_id = cs.item_id
JOIN ws_items ws ON ss.item_id = ws.item_id
WHERE ss_item_rev BETWEEN 0.9 * cs_item_rev AND 1.1 * cs_item_rev
  AND ss_item_rev BETWEEN 0.9 * ws_item_rev AND 1.1 * ws_item_rev
  AND cs_item_rev BETWEEN 0.9 * ss_item_rev AND 1.1 * ss_item_rev
  AND cs_item_rev BETWEEN 0.9 * ws_item_rev AND 1.1 * ws_item_rev
  AND ws_item_rev BETWEEN 0.9 * ss_item_rev AND 1.1 * ss_item_rev
  AND ws_item_rev BETWEEN 0.9 * cs_item_rev AND 1.1 * cs_item_rev
ORDER BY item_id, ss_item_rev
LIMIT 100;

--|    ss.item_id     | ss_item_rev  |       ss_dev       | cs_item_rev  |       cs_dev       | ws_item_rev  |      ws_dev       |   average    |
--+-------------------+--------------+--------------------+--------------+--------------------+--------------+-------------------+--------------+
--| AAAAAAAACFFBAAAA  | 1218.00      | 101.3800336268749  | 1214.46      | 101.0853822976145  | 1171.80      | 97.5345840755106  | 1201.420000  |
--+-------------------+--------------+--------------------+--------------+--------------------+--------------+-------------------+--------------+
--1 row selected (30.956 seconds)
