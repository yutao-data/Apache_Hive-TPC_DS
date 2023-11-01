WITH ranked_data AS (
    SELECT
        channel,
        item,
        return_ratio,
        currency_ratio,
        RANK() OVER (PARTITION BY channel ORDER BY return_ratio) AS return_rank,
        RANK() OVER (PARTITION BY channel ORDER BY currency_ratio) AS currency_rank
    FROM (
        SELECT
            'web' AS channel,
            in_web.item,
            in_web.return_ratio,
            in_web.currency_ratio
        FROM (
            SELECT
                ws.ws_item_sk AS item,
                (SUM(COALESCE(wr.wr_return_quantity, 0)) /
                SUM(COALESCE(ws.ws_quantity, 0))) AS return_ratio,
                (SUM(COALESCE(wr.wr_return_amt, 0)) /
                SUM(COALESCE(ws.ws_net_paid, 0))) AS currency_ratio
            FROM
                web_sales ws
                LEFT OUTER JOIN web_returns wr ON (ws.ws_order_number = wr.wr_order_number AND ws.ws_item_sk = wr.wr_item_sk)
                JOIN date_dim ON ws.ws_sold_date_sk = date_dim.d_date_sk
            WHERE
                wr.wr_return_amt > 10000
                AND ws.ws_net_profit > 1
                AND ws.ws_net_paid > 0
                AND ws.ws_quantity > 0
                AND d_year = 2000
                AND d_moy = 11
            GROUP BY
                ws.ws_item_sk
        ) in_web
        UNION
        SELECT
            'catalog' AS channel,
            in_cat.item,
            in_cat.return_ratio,
            in_cat.currency_ratio
        FROM (
            SELECT
                cs.cs_item_sk AS item,
                (SUM(COALESCE(cr.cr_return_quantity, 0)) /
                SUM(COALESCE(cs.cs_quantity, 0)) ) AS return_ratio,
                (SUM(COALESCE(cr.cr_return_amount, 0)) /
                SUM(COALESCE(cs.cs_net_paid, 0)) ) AS currency_ratio
            FROM
                catalog_sales cs
                LEFT OUTER JOIN catalog_returns cr ON (cs.cs_order_number = cr.cr_order_number AND cs.cs_item_sk = cr.cr_item_sk)
                JOIN date_dim ON cs.cs_sold_date_sk = date_dim.d_date_sk
            WHERE
                cr.cr_return_amount > 10000
                AND cs.cs_net_profit > 1
                AND cs.cs_net_paid > 0
                AND cs.cs_quantity > 0
                AND d_year = 2000
                AND d_moy = 11
            GROUP BY
                cs.cs_item_sk
        ) in_cat
        UNION
        SELECT
            'store' AS channel,
            in_store.item,
            in_store.return_ratio,
            in_store.currency_ratio
        FROM (
            SELECT
                sts.ss_item_sk AS item,
                (SUM(COALESCE(sr.sr_return_quantity, 0)) /
                SUM(COALESCE(sts.ss_quantity, 0)) ) AS return_ratio,
                (SUM(COALESCE(sr.sr_return_amt, 0)) /
                SUM(COALESCE(sts.ss_net_paid, 0)) ) AS currency_ratio
            FROM
                store_sales sts
                LEFT OUTER JOIN store_returns sr ON (sts.ss_ticket_number = sr.sr_ticket_number AND sts.ss_item_sk = sr.sr_item_sk)
                JOIN date_dim ON sts.ss_sold_date_sk = date_dim.d_date_sk
            WHERE
                sr.sr_return_amt > 10000
                AND sts.ss_net_profit > 1
                AND sts.ss_net_paid > 0
                AND sts.ss_quantity > 0
                AND d_year = 2000
                AND d_moy = 11
            GROUP BY
                sts.ss_item_sk
        ) in_store
    ) all_data
)

SELECT
    channel,
    item,
    return_ratio,
    return_rank,
    currency_rank
FROM
    ranked_data
WHERE
    return_rank <= 10 OR currency_rank <= 10
ORDER BY
    channel,
    return_rank,
    currency_rank,
    item
LIMIT 100;
