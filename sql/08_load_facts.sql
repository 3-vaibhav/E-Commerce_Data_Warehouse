--Load core fact tables

-- 1. Order-level facts: one row per order
INSERT INTO analytics.fact_orders (
    order_id, customer_key, order_date_key, order_status,
    shipping_method, marketing_channel, campaign_id,
    subtotal, shipping_fee, tax_amount,
    discount_percentage, final_amount
)
SELECT
    o.order_id,
    c.customer_key,
    d.date_key,
    o.order_status,
    o.shipping_method,
    o.marketing_channel,
    o.campaign_id,
    o.subtotal,
    o.shipping_fee,
    o.tax_amount,
    o.discount_percentage,
    o.final_amount
FROM staging.orders o
LEFT JOIN analytics.dim_customers c
    ON o.customer_id = c.customer_id
LEFT JOIN analytics.dim_date d
    ON o.order_date = d.full_date
ON CONFLICT (order_id) DO UPDATE SET
    customer_key = EXCLUDED.customer_key,
    order_date_key = EXCLUDED.order_date_key,
    order_status = EXCLUDED.order_status,
    shipping_method = EXCLUDED.shipping_method,
    marketing_channel = EXCLUDED.marketing_channel,
    campaign_id = EXCLUDED.campaign_id,
    subtotal = EXCLUDED.subtotal,
    shipping_fee = EXCLUDED.shipping_fee,
    tax_amount = EXCLUDED.tax_amount,
    discount_percentage = EXCLUDED.discount_percentage,
    final_amount = EXCLUDED.final_amount;

-- 2. Item-level facts: one row per order item
INSERT INTO analytics.fact_order_items (
    order_item_id, order_id, customer_key, product_key,
    order_date_key, quantity, unit_price, discount_percentage,
    item_revenue, item_cost, profit
)
SELECT
    i.order_item_id,
    i.order_id,
    c.customer_key,
    p.product_key,
    d.date_key,
    i.quantity,
    i.unit_price,
    i.discount_percentage,
    i.item_revenue,
    i.item_cost,
    i.profit
FROM staging.order_items i
JOIN staging.orders o
    ON i.order_id = o.order_id
LEFT JOIN analytics.dim_customers c
    ON o.customer_id = c.customer_id
LEFT JOIN analytics.dim_products p
    ON i.product_id = p.product_id
LEFT JOIN analytics.dim_date d
    ON o.order_date = d.full_date
ON CONFLICT (order_item_id) DO UPDATE SET
    order_id = EXCLUDED.order_id,
    customer_key = EXCLUDED.customer_key,
    product_key = EXCLUDED.product_key,
    order_date_key = EXCLUDED.order_date_key,
    quantity = EXCLUDED.quantity,
    unit_price = EXCLUDED.unit_price,
    discount_percentage = EXCLUDED.discount_percentage,
    item_revenue = EXCLUDED.item_revenue,
    item_cost = EXCLUDED.item_cost,
    profit = EXCLUDED.profit;

-- 3. Shipment facts: one row per shipment
INSERT INTO analytics.fact_shipments (
    shipment_id, order_id, order_date_key, dispatch_date,
    expected_delivery_date, actual_delivery_date, delivery_days,
    delivery_status, delayed_flag, warehouse_city,
    delivery_city, shipping_method
)
SELECT
    s.shipment_id,
    s.order_id,
    d.date_key,
    s.dispatch_date,
    s.expected_delivery_date,
    s.actual_delivery_date,
    s.delivery_days,
    s.delivery_status,
    s.delayed_flag,
    s.warehouse_city,
    s.delivery_city,
    s.shipping_method
FROM staging.shipments s
LEFT JOIN staging.orders o
    ON s.order_id = o.order_id
LEFT JOIN analytics.dim_date d
    ON o.order_date = d.full_date
ON CONFLICT (shipment_id) DO UPDATE SET
    order_id = EXCLUDED.order_id,
    order_date_key = EXCLUDED.order_date_key,
    dispatch_date = EXCLUDED.dispatch_date,
    expected_delivery_date = EXCLUDED.expected_delivery_date,
    actual_delivery_date = EXCLUDED.actual_delivery_date,
    delivery_days = EXCLUDED.delivery_days,
    delivery_status = EXCLUDED.delivery_status,
    delayed_flag = EXCLUDED.delayed_flag,
    warehouse_city = EXCLUDED.warehouse_city,
    delivery_city = EXCLUDED.delivery_city,
    shipping_method = EXCLUDED.shipping_method;
