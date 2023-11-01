SELECT
  SUM(CASE WHEN t_hour = 8 AND t_minute >= 30 THEN count ELSE 0 END) AS h8_30_to_9,
  SUM(CASE WHEN t_hour = 9 AND t_minute < 30 THEN count ELSE 0 END) AS h9_to_9_30,
  SUM(CASE WHEN t_hour = 9 AND t_minute >= 30 THEN count ELSE 0 END) AS h9_30_to_10,
  SUM(CASE WHEN t_hour = 10 AND t_minute < 30 THEN count ELSE 0 END) AS h10_to_10_30,
  SUM(CASE WHEN t_hour = 10 AND t_minute >= 30 THEN count ELSE 0 END) AS h10_30_to_11,
  SUM(CASE WHEN t_hour = 11 AND t_minute < 30 THEN count ELSE 0 END) AS h11_to_11_30,
  SUM(CASE WHEN t_hour = 11 AND t_minute >= 30 THEN count ELSE 0 END) AS h11_30_to_12,
  SUM(CASE WHEN t_hour = 12 AND t_minute < 30 THEN count ELSE 0 END) AS h12_to_12_30
FROM (
  SELECT
    time_dim.t_hour,
    time_dim.t_minute,
    COUNT(*) AS count
  FROM
    store_sales
    JOIN household_demographics ON store_sales.ss_hdemo_sk = household_demographics.hd_demo_sk
    JOIN time_dim ON store_sales.ss_sold_time_sk = time_dim.t_time_sk
    JOIN store ON store_sales.ss_store_sk = store.s_store_sk
  WHERE
    store.s_store_name = 'ese'
    AND time_dim.t_hour BETWEEN 8 AND 12
    AND (
      (household_demographics.hd_dep_count = 3 AND household_demographics.hd_vehicle_count <= 3 + 2) OR
      (household_demographics.hd_dep_count = 1 AND household_demographics.hd_vehicle_count <= 1 + 2) OR
      (household_demographics.hd_dep_count = 0 AND household_demographics.hd_vehicle_count <= 0 + 2)
    )
  GROUP BY time_dim.t_hour, time_dim.t_minute
) AS subquery;
