-- Additional staging data quality checks

-- 1. Order items with missing order or product references
SELECT
    COUNT(*) FILTER (WHERE o.order_id IS NULL) AS missing_orders,
    COUNT(*) FILTER (WHERE p.product_id IS NULL) AS missing_products
FROM staging.order_items i
LEFT JOIN staging.orders o ON i.order_id = o.order_id
LEFT JOIN staging.products p ON i.product_id = p.product_id;

-- 2. Returns with missing order or product references
SELECT
    COUNT(*) FILTER (WHERE o.order_id IS NULL) AS missing_orders,
    COUNT(*) FILTER (WHERE p.product_id IS NULL) AS missing_products,
    COUNT(*) FILTER (WHERE c.customer_id IS NULL) AS missing_customers
FROM staging.returns r
LEFT JOIN staging.orders o ON r.order_id = o.order_id
LEFT JOIN staging.products p ON r.product_id = p.product_id
LEFT JOIN staging.customers c ON r.customer_id = c.customer_id;

-- 3. Reviews with invalid ratings
SELECT
    COUNT(*) AS total_reviews,
    COUNT(*) FILTER (
        WHERE rating IS NULL OR rating < 1 OR rating > 5
    ) AS invalid_ratings
FROM staging.customer_reviews;

-- 4. Customer age and numeric sanity checks
SELECT
    COUNT(*) FILTER (WHERE age < 0 OR age > 120) AS invalid_ages,
    COUNT(*) FILTER (WHERE total_orders < 0) AS negative_order_counts,
    COUNT(*) FILTER (WHERE total_spend < 0) AS negative_total_spend
FROM staging.customers;

-- 5. Order item numeric sanity checks
SELECT
    COUNT(*) FILTER (WHERE quantity <= 0) AS nonpositive_quantities,
    COUNT(*) FILTER (WHERE unit_price < 0) AS negative_unit_prices,
    COUNT(*) FILTER (WHERE item_revenue < 0) AS negative_item_revenue
FROM staging.order_items;

-- 6. Campaign date consistency
SELECT COUNT(*) AS campaigns_ending_before_start
FROM staging.marketing_campaigns
WHERE campaign_end_date < campaign_start_date;

-- 7. Shipment delay flag distribution
SELECT delayed_flag, COUNT(*) AS shipment_count
FROM staging.shipments
GROUP BY delayed_flag
ORDER BY delayed_flag;
