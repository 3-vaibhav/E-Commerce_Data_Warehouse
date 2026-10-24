-- 1. Monthly revenue and order performance
SELECT
    d.year,
    d.month,
    d.month_name,
    COUNT(*) AS total_orders,
    ROUND(SUM(f.final_amount), 2) AS total_revenue,
    ROUND(AVG(f.final_amount), 2) AS average_order_value
FROM analytics.fact_orders f
JOIN analytics.dim_date d
    ON f.order_date_key = d.date_key
GROUP BY
    d.year,
    d.month,
    d.month_name
ORDER BY
    d.year,
    d.month;

-- 2. Product category profitability
SELECT
    p.category,
    COUNT(*) AS order_item_rows,
    SUM(i.quantity) AS units_sold,
    ROUND(SUM(i.item_revenue), 2) AS total_revenue,
    ROUND(SUM(i.item_cost), 2) AS total_cost,
    ROUND(SUM(i.profit), 2) AS total_profit,
    ROUND(
        100.0 * SUM(i.profit) / NULLIF(SUM(i.item_revenue), 0),
        2
    ) AS profit_margin_pct
FROM analytics.fact_order_items i
JOIN analytics.dim_products p
    ON i.product_key = p.product_key
GROUP BY p.category
ORDER BY total_profit DESC;


-- 3. Delivery performance by shipping method
SELECT
    shipping_method,
    COUNT(*) AS total_shipments,
    COUNT(*) FILTER (
        WHERE actual_delivery_date IS NOT NULL
    ) AS delivered_shipments,
    COUNT(*) FILTER (
        WHERE TRIM(delayed_flag) = '1'
    ) AS delayed_shipments,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE TRIM(delayed_flag) = '1'
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS delayed_shipment_pct
FROM analytics.fact_shipments
GROUP BY shipping_method
ORDER BY delayed_shipment_pct DESC;

-- 4. Delivery KPIs for completed shipments only
SELECT
    shipping_method,
    COUNT(*) FILTER (
        WHERE actual_delivery_date IS NOT NULL
    ) AS delivered_shipments,
    COUNT(*) FILTER (
        WHERE actual_delivery_date IS NOT NULL
          AND TRIM(delayed_flag) = '1'
    ) AS delayed_delivered_shipments,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE actual_delivery_date IS NOT NULL
              AND TRIM(delayed_flag) = '1'
        ) / NULLIF(
            COUNT(*) FILTER (
                WHERE actual_delivery_date IS NOT NULL
            ), 0
        ),
        2
    ) AS delivered_delay_rate_pct,
    ROUND(
        AVG(delivery_days) FILTER (
            WHERE actual_delivery_date IS NOT NULL
        ),
        2
    ) AS avg_days_for_delivered
FROM analytics.fact_shipments
GROUP BY shipping_method
ORDER BY delivered_delay_rate_pct DESC;