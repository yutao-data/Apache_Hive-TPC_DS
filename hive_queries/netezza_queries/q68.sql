WITH frequent_ss_items AS (
  SELECT
    SUBSTR(i_item_desc, 1, 30) AS itemdesc,
    i_item_sk AS item_sk,
    d_date AS solddate,
    COUNT(*) AS cnt
  FROM
    store_sales
    JOIN date_dim ON ss_sold_date_sk = d_date_sk
    JOIN item ON ss_item_sk = i_item_sk
  WHERE
    d_year IN (2000, 2001, 2002, 2003)
  GROUP BY
    SUBSTR(i_item_desc, 1, 30), i_item_sk, d_date
  HAVING
    COUNT(*) > 4
),
max_store_sales AS (
  SELECT
    MAX(ss_quantity * ss_sales_price) AS tpcds_cmax
  FROM
    store_sales
  WHERE
    ss_sold_date_sk IN (SELECT d_date_sk FROM date_dim WHERE d_year IN (2000, 2001, 2002, 2003))
),
best_ss_customer AS (
  SELECT
    ss_customer_sk AS c_customer_sk,
    SUM(ss_quantity * ss_sales_price) AS ssales
  FROM
    store_sales
  WHERE
    ss_customer_sk IN (SELECT c_customer_sk FROM customer)
  GROUP BY
    ss_customer_sk
  HAVING
    SUM(ss_quantity * ss_sales_price) > (0.95) * (SELECT tpcds_cmax FROM max_store_sales)
)
SELECT
  SUM(sales) AS total_sales
FROM (
  SELECT
    cs_quantity * cs_list_price AS sales
  FROM
    catalog_sales
  WHERE
    cs_sold_date_sk IN (SELECT d_date_sk FROM date_dim WHERE d_year = 2000 AND d_moy = 7)
    AND cs_item_sk IN (SELECT item_sk FROM frequent_ss_items)
    AND cs_bill_customer_sk IN (SELECT c_customer_sk FROM best_ss_customer)
  UNION ALL
  SELECT
    ws_quantity * ws_list_price AS sales
  FROM
    web_sales
  WHERE
    ws_sold_date_sk IN (SELECT d_date_sk FROM date_dim WHERE d_year = 2000 AND d_moy = 7)
    AND ws_item_sk IN (SELECT item_sk FROM frequent_ss_items)
    AND ws_bill_customer_sk IN (SELECT c_customer_sk FROM best_ss_customer)
) AS subquery;
