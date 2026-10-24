--Staging
-- 1. Check duplicate and missing order IDs
SELECT
    COUNT(*) AS total_rows,
    COUNT(order_id) AS non_null_order_ids,
    COUNT(DISTINCT order_id) AS unique_order_ids
FROM staging.orders;

-- 2. Check invalid or missing order amounts
SELECT
    COUNT(*) FILTER (WHERE subtotal < 0) AS negative_subtotals,
    COUNT(*) FILTER (WHERE final_amount < 0) AS negative_final_amounts,
    COUNT(*) FILTER (WHERE final_amount IS NULL) AS missing_final_amounts
FROM staging.orders;

-- 3. Check order-to-customer relationships
SELECT COUNT(*) AS orders_with_missing_customer
FROM staging.orders o
LEFT JOIN raw.customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 4. Check order-to-payment relationships
SELECT COUNT(*) AS payments_without_matching_order
FROM staging.payments p
LEFT JOIN staging.orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 5. Check product prices and costs
SELECT
    COUNT(*) FILTER (WHERE price < 0) AS negative_prices,
    COUNT(*) FILTER (WHERE cost_price < 0) AS negative_costs,
    COUNT(*) FILTER (WHERE price IS NULL) AS missing_prices
FROM staging.products;

-- 6. Check shipment date consistency
SELECT COUNT(*) AS shipments_before_dispatch
FROM staging.shipments
WHERE actual_delivery_date < dispatch_date;

-- 7. Check missing shipment delivery dates
SELECT COUNT(*) AS missing_actual_delivery_dates
FROM staging.shipments
WHERE actual_delivery_date IS NULL;
