-- LF_CR
insert into catalog_returns (
cr_returned_date_sk ,
cr_returned_time_sk ,
cr_item_sk ,
cr_refunded_customer_sk ,
cr_refunded_cdemo_sk ,
cr_refunded_hdemo_sk ,
cr_refunded_addr_sk ,
cr_returning_customer_sk ,
cr_returning_cdemo_sk ,
cr_returning_hdemo_sk ,
cr_returning_addr_sk ,
cr_call_center_sk ,
cr_catalog_page_sk ,
cr_ship_mode_sk ,
cr_warehouse_sk ,
cr_reason_sk ,
cr_order_number ,
cr_return_quantity ,
cr_return_amount ,
cr_return_tax ,
cr_return_amt_inc_tax ,
cr_fee ,
cr_return_ship_cost ,
cr_refunded_cash ,
cr_reversed_charge ,
cr_store_credit ,
cr_net_loss
) (select * from crv)
;

-- LF_CS
insert into catalog_sales (
cs_sold_date_sk ,
cs_sold_time_sk ,
cs_ship_date_sk ,
cs_bill_customer_sk ,
cs_bill_cdemo_sk ,
cs_bill_hdemo_sk ,
cs_bill_addr_sk ,
cs_ship_customer_sk ,
cs_ship_cdemo_sk ,
cs_ship_hdemo_sk ,
cs_ship_addr_sk ,
cs_call_center_sk ,
cs_catalog_page_sk ,
cs_ship_mode_sk ,
cs_warehouse_sk ,
cs_item_sk ,
cs_promo_sk ,
cs_order_number ,
cs_quantity ,
cs_wholesale_cost ,
cs_list_price ,
cs_sales_price ,
cs_ext_discount_amt ,
cs_ext_sales_price ,
cs_ext_wholesale_cost ,
cs_ext_list_price ,
cs_ext_tax ,
cs_coupon_amt ,
cs_ext_ship_cost ,
cs_net_paid ,
cs_net_paid_inc_tax ,
cs_net_paid_inc_ship ,
cs_net_paid_inc_ship_tax ,
cs_net_profit
) (select * from csv)
;

-- LF_SR
insert into store_returns (
sr_returned_date_sk ,
sr_return_time_sk ,
sr_item_sk ,
sr_customer_sk ,
sr_cdemo_sk ,
sr_hdemo_sk ,
sr_addr_sk ,
sr_store_sk ,
sr_reason_sk ,
sr_ticket_number ,
sr_return_quantity ,
sr_return_amt ,
sr_return_tax ,
sr_return_amt_inc_tax ,
sr_fee ,
sr_return_ship_cost ,
sr_refunded_cash ,
sr_reversed_charge ,
sr_store_credit ,
sr_net_loss
) (select * from srv)
;

-- LF_SS
insert into store_sales (
ss_sold_date_sk ,
ss_sold_time_sk ,
ss_item_sk ,
ss_customer_sk ,
ss_cdemo_sk ,
ss_hdemo_sk ,
ss_addr_sk ,
ss_store_sk ,
ss_promo_sk ,
ss_ticket_number ,
ss_quantity ,
ss_wholesale_cost ,
ss_list_price ,
ss_sales_price ,
ss_ext_discount_amt ,
ss_ext_sales_price ,
ss_ext_wholesale_cost ,
ss_ext_list_price ,
ss_ext_tax ,
ss_coupon_amt ,
ss_net_paid ,
ss_net_paid_inc_tax ,
ss_net_profit
) (select * from ssv)
;

-- LF_WR
insert into web_returns (
wr_returned_date_sk ,
wr_returned_time_sk ,
wr_item_sk ,
wr_refunded_customer_sk ,
wr_refunded_cdemo_sk ,
wr_refunded_hdemo_sk ,
wr_refunded_addr_sk ,
wr_returning_customer_sk ,
wr_returning_cdemo_sk ,
wr_returning_hdemo_sk ,
wr_returning_addr_sk ,
wr_web_page_sk ,
wr_reason_sk ,
wr_order_number ,
wr_return_quantity ,
wr_return_amt ,
wr_return_tax ,
wr_return_amt_inc_tax ,
wr_fee ,
wr_return_ship_cost ,
wr_refunded_cash ,
wr_reversed_charge ,
wr_account_credit ,
wr_net_loss
) (select * from wrv)
;

-- LF_WS
insert into web_sales (
ws_sold_date_sk ,
ws_sold_time_sk ,
ws_ship_date_sk ,
ws_item_sk ,
ws_bill_customer_sk ,
ws_bill_cdemo_sk ,
ws_bill_hdemo_sk ,
ws_bill_addr_sk ,
ws_ship_customer_sk ,
ws_ship_cdemo_sk ,
ws_ship_hdemo_sk ,
ws_ship_addr_sk ,
ws_web_page_sk ,
ws_web_site_sk ,
ws_ship_mode_sk ,
ws_warehouse_sk ,
ws_promo_sk ,
ws_order_number ,
ws_quantity ,
ws_wholesale_cost ,
ws_list_price ,
ws_sales_price ,
ws_ext_discount_amt ,
ws_ext_sales_price ,
ws_ext_wholesale_cost ,
ws_ext_list_price ,
ws_ext_tax ,
ws_coupon_amt ,
ws_ext_ship_cost ,
ws_net_paid ,
ws_net_paid_inc_tax ,
ws_net_paid_inc_ship ,
ws_net_paid_inc_ship_tax ,
ws_net_profit
) (select * from wsv)
;

-- LF_I
insert into inventory (
inv_date_sk ,
inv_item_sk ,
inv_warehouse_sk ,
inv_quantity_on_hand
) (select * from iv)
;


--hive不支持delete所以所以删除处理都使用overwrite
-- DF_CS
-- 删除catalog订单信息
-- 创建一个新表，只包含要保留的数据
CREATE TABLE temp_store_sales AS
SELECT *
FROM store_sales
WHERE ss_sold_date_sk NOT IN (SELECT d_date_sk FROM date_dim WHERE d_date BETWEEN '1920-09-10' AND '1920-09-18');
-- 覆盖原表
INSERT OVERWRITE TABLE store_sales
SELECT * FROM temp_store_sales;
-- 删除临时表
DROP TABLE temp_store_sales;

-- 删除catalog退单信息
-- 创建一个新表，只包含要保留的数据
CREATE TABLE temp_catalog_returns AS
SELECT *
FROM catalog_returns
WHERE cr_order_number NOT IN (
  SELECT cs_order_number
  FROM catalog_sales
  WHERE cs_sold_date_sk IN (
    SELECT d_date_sk
    FROM date_dim
    WHERE d_date BETWEEN '1920-09-10' AND '1920-09-18'
  )
);
-- 覆盖原表
INSERT OVERWRITE TABLE catalog_returns
SELECT * FROM temp_catalog_returns;
-- 删除临时表
DROP TABLE temp_catalog_returns;


-- DF_SS
-- 删除store订单信息
-- 创建一个新表，只包含要保留的数据
CREATE TABLE temp_store_sales AS
SELECT *
FROM store_sales
WHERE ss_sold_date_sk NOT IN (
  SELECT d_date_sk
  FROM date_dim
  WHERE d_date BETWEEN '1920-09-10' AND '1920-09-18'
);
-- 覆盖原表
INSERT OVERWRITE TABLE store_sales
SELECT * FROM temp_store_sales;
-- 删除临时表
DROP TABLE temp_store_sales;


-- 删除store退单信息
-- 创建一个新表，只包含要保留的数据
CREATE TABLE temp_store_sales AS
SELECT *
FROM store_sales
WHERE ss_sold_date_sk NOT IN (
  SELECT d_date_sk
  FROM date_dim
  WHERE d_date BETWEEN '1920-09-10' AND '1920-09-18'
);
-- 覆盖原表
INSERT OVERWRITE TABLE store_sales
SELECT * FROM temp_store_sales;
-- 删除临时表
DROP TABLE temp_store_sales;


-- DF_WS
-- 删除web订单信息
-- 创建一个新表，只包含要保留的数据
CREATE TABLE temp_web_sales AS
SELECT *
FROM web_sales
WHERE ws_sold_date_sk NOT IN (
  SELECT d_date_sk
  FROM date_dim
  WHERE d_date BETWEEN '1920-09-10' AND '1920-09-18'
);
-- 覆盖原表
INSERT OVERWRITE TABLE web_sales
SELECT * FROM temp_web_sales;
-- 删除临时表
DROP TABLE temp_web_sales;

-- 删除web退单信息
-- 创建一个新表，只包含要保留的数据
CREATE TABLE temp_web_returns AS
SELECT *
FROM web_returns
WHERE wr_order_number NOT IN (
  SELECT ws_order_number
  FROM web_sales
  WHERE ws_sold_date_sk IN (
    SELECT d_date_sk
    FROM date_dim
    WHERE d_date BETWEEN '1920-09-10' AND '1920-09-18'
  )
);
-- 覆盖原表
INSERT OVERWRITE TABLE web_returns
SELECT * FROM temp_web_returns;
-- 删除临时表
DROP TABLE temp_web_returns;


-- DF_I
-- 删除仓储
-- 创建一个新表，只包含要保留的数据
CREATE TABLE temp_inventory AS
SELECT *
FROM inventory
WHERE inv_date_sk NOT IN (
  SELECT d_date_sk
  FROM date_dim
  WHERE d_date BETWEEN '1920-09-10' AND '1920-09-18'
);
-- 覆盖原表
INSERT OVERWRITE TABLE inventory
SELECT * FROM temp_inventory;
-- 删除临时表
DROP TABLE temp_inventory;

