
/* 01) Which region generates the largest amount of money in existing transactions?*/
-- name: transaction_volume_by_region
SELECT
    dc.region,
    SUM(ft.transaction_amount) AS volumen_total
FROM fact_transaction AS ft

JOIN dim_account AS da
    ON ft.account_id = da.account_id

JOIN dim_customer AS dc
    ON da.customer_id = dc.customer_id

WHERE ft.status = 'Success'

GROUP BY dc.region

ORDER BY volumen_total DESC;

/* 02) Which region has the most customers?*/
-- name: customers_by_region
SELECT 
    region,
    COUNT(*) AS total_customers
FROM dim_customer

GROUP BY region

ORDER BY total_customers DESC;

/* 03) Which type of account has the highest average balance?*/
-- name: average_balance_by_account_type
SELECT
    account_type,
    avg(balance) as amount_average
FROM dim_account

GROUP BY account_type

ORDER BY amount_average DESC;

/* 04) What percentage of the accounts is active?*/
-- name: active_accounts_percentage
SELECT
    COUNT(*) AS total_accounts,

    COUNT(
        CASE
            WHEN closed_date IS NULL THEN 1
        END
    ) AS active_accounts,
      ROUND(
        COUNT(CASE WHEN closed_date IS NULL THEN 1 END) * 100.0
        / COUNT(*),
        2
    ) AS active_percentage
FROM dim_account;

/* 05) Which transaction channel is the most widely used?*/
-- name: transaction_count_by_channel
SELECT
    transaction_channel,
    COUNT(*) AS total_channels
FROM fact_transaction

GROUP BY transaction_channel

ORDER BY total_channels DESC;

/* 06) Which product category generates the highest volume of money in successful transactions?*/
-- name: transaction_volume_by_product_category
SELECT
    pc.product_category_name,
    SUM(ft.transaction_amount) AS total_amount
FROM fact_transaction AS ft

JOIN dim_product AS p
    ON ft.product_id = p.product_id

JOIN dim_product_subcategory AS ps
    ON p.product_subcategory_id = ps.product_subcategory_id

JOIN dim_product_category AS pc
    ON ps.product_category_id = pc.product_category_id

WHERE ft.status = 'Success'

GROUP BY pc.product_category_name

ORDER BY total_amount DESC;

/* 07) What type of account generates the highest volume of money in successful transactions?*/
-- name: transaction_volume_by_account_type
SELECT
    da.account_type,
    SUM(ft.transaction_amount) AS total_amount
FROM fact_transaction AS ft

JOIN dim_account AS da
    ON da.account_id = ft.account_id

WHERE ft.status = 'Success'

GROUP BY da.account_type

ORDER BY total_amount DESC;

/* 08) Which regions have a total volume of successful transactions exceeding $1,000,000?*/
-- name: regions_exceeding_one_million
SELECT
    dc.region,
    SUM(ft.transaction_amount) AS total_amount
FROM fact_transaction AS ft

JOIN dim_account AS da
    ON da.account_id = ft.account_id

JOIN dim_customer AS dc
    ON da.customer_id = dc.customer_id

WHERE ft.status = 'Success'

GROUP BY dc.region

HAVING SUM(ft.transaction_amount) > 1000000

ORDER BY total_amount DESC;

/* 09) Who are the 5 clients who have generated the highest volume of money in successful transactions?*/
-- name: top_5_customers_by_transaction_volume
SELECT 
    dc.customer_id,
    dc.full_name,
    sum(ft.transaction_amount) as total_amount
FROM fact_transaction AS ft

JOIN dim_account AS da
    ON da.account_id = ft.account_id

JOIN dim_customer AS dc
    ON dc.customer_id = da.customer_id

WHERE ft.status = 'Success'

GROUP BY dc.full_name, dc.customer_id

ORDER BY total_amount DESC

LIMIT 5;

/* 10) What are the five products that have generated the highest volume of money in successful transactions?*/
-- name: top_5_products_by_transaction_volume
SELECT
    dp.product_id,
    dp.product_name,
    SUM(ft.transaction_amount) AS total_amount

FROM fact_transaction AS ft

JOIN dim_product AS dp
    ON dp.product_id = ft.product_id

WHERE ft.status = 'Success'

GROUP BY
    dp.product_id,
    dp.product_name

ORDER BY total_amount DESC

LIMIT 5;

/* 11) What is the average purchase value for each account type, considering only successful transactions?*/
-- name: average_transaction_by_account_type
SELECT
    da.account_type,
    ROUND(AVG(ft.transaction_amount),2) AS average_amount
FROM fact_transaction AS ft

JOIN dim_account AS da
    ON da.account_id = ft.account_id

WHERE ft.status = 'Success'

GROUP BY da.account_type

ORDER BY average_amount DESC;

/* 12) What percentage of the total volume of money does each region represent?*/
-- name: regional_transaction_volume_percentage
SELECT
    dc.region,
    SUM(ft.transaction_amount) AS regional_amount,
    ROUND(
    SUM(ft.transaction_amount) * 100.0
    / SUM(SUM(ft.transaction_amount)) OVER (),
    2
) AS percentage_of_total
FROM fact_transaction AS ft

JOIN dim_account AS da
    ON da.account_id = ft.account_id

JOIN dim_customer AS dc
    ON dc.customer_id = da.customer_id

WHERE ft.status = 'Success'

GROUP BY dc.region

ORDER BY percentage_of_total DESC;

/* 13) Which product categories have the highest number of failed transactions?*/
-- name: failed_transactions_by_product_category
SELECT
    pc.product_category_name,
    pc.product_category_id,
    COUNT(*) AS total_counts
FROM fact_transaction AS ft

JOIN dim_product as p
    ON p.product_id = ft.product_id

JOIN dim_product_subcategory AS ps
    ON ps.product_subcategory_id = p.product_subcategory_id

JOIN dim_product_category AS pc
    ON pc.product_category_id = ps.product_category_id

WHERE ft.status = 'Failed'

GROUP BY pc.product_category_id, pc.product_category_name

ORDER BY total_counts DESC;

/* 14) Ranking of regions based on revenue generated from successful transactions*/
-- name: region_transaction_volume_ranking
SELECT
    dc.region,
    SUM(ft.transaction_amount) AS total_amount,
    RANK() OVER (
        ORDER BY SUM(ft.transaction_amount) DESC
    ) AS region_rank
FROM fact_transaction AS ft

JOIN dim_account AS da
    ON ft.account_id = da.account_id

JOIN dim_customer AS dc
    ON dc.customer_id = da.customer_id

WHERE ft.status = 'Success'

GROUP BY dc.region;

/* 15) Ranking of the clients who have generated the most money through successful transactions.*/
-- name: customer_transaction_volume_ranking
SELECT
    dc.full_name,
    dc.customer_id,
    SUM(ft.transaction_amount) AS total_amount,
    RANK() OVER(ORDER BY SUM(ft.transaction_amount) DESC) AS customer_rank
FROM fact_transaction AS ft

JOIN dim_account AS da
    ON da.account_id = ft.account_id

JOIN dim_customer AS dc
    ON dc.customer_id = da.customer_id

WHERE ft.status = 'Success'

GROUP BY dc.customer_id, dc.full_name

ORDER BY customer_rank;

/* 16) Which month generated the highest volume of money in successful transactions?*/
-- name: monthly_transaction_volume
SELECT
    TO_CHAR(DATE_TRUNC('month', ft.transaction_date), 'YYYY-MM') AS month,
    SUM(ft.transaction_amount) AS total_amount
FROM fact_transaction AS ft

WHERE ft.status = 'Success'

GROUP BY DATE_TRUNC('month', ft.transaction_date)

ORDER BY total_amount DESC;

/* 17) What was the average transaction amount for successful transactions per month?*/
-- name: monthly_average_transaction_amount
SELECT
    TO_CHAR(DATE_TRUNC('month', ft.transaction_date), 'YYYY-MM') AS month,
    AVG(ft.transaction_amount) AS average_amount
FROM fact_transaction AS ft

WHERE ft.status = 'Success'

GROUP BY DATE_TRUNC('month', ft.transaction_date)

ORDER BY average_amount DESC;

/* 18) Which product has the highest average ticket value (average amount per successful transaction)?*/
-- name: highest_average_ticket_product
SELECT
    p.product_id,
    p.product_name,
    ROUND(AVG(ft.transaction_amount), 2) AS average_amount
FROM fact_transaction AS ft

JOIN dim_product AS p
    ON p.product_id = ft.product_id

WHERE ft.status = 'Success'

GROUP BY
    p.product_id,
    p.product_name

ORDER BY average_amount DESC

LIMIT 1;

/* 19) What percentage does each product represent of the total revenue from successful transactions?*/
-- name: product_revenue_percentage
SELECT
    p.product_id,
    p.product_name,
    SUM(ft.transaction_amount) AS total_amount,
    ROUND(
        SUM(ft.transaction_amount) * 100.0
        / SUM(SUM(ft.transaction_amount)) OVER (),
        2
    ) AS percentage
FROM fact_transaction AS ft

JOIN dim_product AS p
    ON p.product_id = ft.product_id

WHERE ft.status = 'Success'

GROUP BY
    p.product_id,
    p.product_name

ORDER BY percentage DESC;

/* 20) Which transaction channel generates the highest volume of money in successful transactions? */
-- name: transaction_volume_by_channel
SELECT
    ft.transaction_channel,
    SUM(ft.transaction_amount) AS total_amount
FROM fact_transaction AS ft
WHERE ft.status = 'Success'
GROUP BY ft.transaction_channel
ORDER BY total_amount DESC;