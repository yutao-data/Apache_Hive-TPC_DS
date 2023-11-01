
select
  cast(count(case when t1.t_hour between 10 and 11 then 1 else null end) as decimal(15,4)) /
  cast(count(case when t1.t_hour between 18 and 19 then 1 else null end) as decimal(15,4)) as am_pm_ratio
from
  web_sales ws
  join household_demographics hd on ws.ws_ship_hdemo_sk = hd.hd_demo_sk
  join time_dim t1 on ws.ws_sold_time_sk = t1.t_time_sk
  join web_page wp on ws.ws_web_page_sk = wp.wp_web_page_sk
where
  hd.hd_dep_count = 6
  and wp.wp_char_count between 5000 and 5200
  and (t1.t_hour between 10 and 11 or t1.t_hour between 18 and 19)
limit 100;
-- 1 row selected (2.346 seconds)
