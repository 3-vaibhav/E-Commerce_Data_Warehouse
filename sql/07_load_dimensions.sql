--Load warehouse dimensions

-- Customers
INSERT INTO analytics.dim_customers (
    customer_id, signup_date, gender, age, age_group,
    state, city, customer_segment, preferred_device,
    preferred_payment_method, acquisition_channel,
    customer_status, loyalty_tier
)
SELECT
    customer_id, customer_signup_date, gender, age, age_group,
    state, city, customer_segment, preferred_device,
    preferred_payment_method, acquisition_channel,
    customer_status, loyalty_tier
FROM staging.customers
ON CONFLICT (customer_id) DO UPDATE SET
    signup_date = EXCLUDED.signup_date,
    gender = EXCLUDED.gender,
    age = EXCLUDED.age,
    age_group = EXCLUDED.age_group,
    state = EXCLUDED.state,
    city = EXCLUDED.city,
    customer_segment = EXCLUDED.customer_segment,
    preferred_device = EXCLUDED.preferred_device,
    preferred_payment_method = EXCLUDED.preferred_payment_method,
    acquisition_channel = EXCLUDED.acquisition_channel,
    customer_status = EXCLUDED.customer_status,
    loyalty_tier = EXCLUDED.loyalty_tier;

-- Products
INSERT INTO analytics.dim_products (
    product_id, product_name, category, subcategory, brand,
    product_type, price, cost_price, product_launch_date
)
SELECT
    product_id, product_name, category, subcategory, brand,
    product_type, price, cost_price, product_launch_date
FROM staging.products
ON CONFLICT (product_id) DO UPDATE SET
    product_name = EXCLUDED.product_name,
    category = EXCLUDED.category,
    subcategory = EXCLUDED.subcategory,
    brand = EXCLUDED.brand,
    product_type = EXCLUDED.product_type,
    price = EXCLUDED.price,
    cost_price = EXCLUDED.cost_price,
    product_launch_date = EXCLUDED.product_launch_date;

-- Calendar dates covering orders and shipment milestones
INSERT INTO analytics.dim_date (
    date_key, full_date, year, quarter, month, month_name,
    day_of_month, day_of_week, day_name, is_weekend
)
SELECT
    TO_CHAR(d::DATE, 'YYYYMMDD')::INTEGER,
    d::DATE,
    EXTRACT(YEAR FROM d)::INTEGER,
    EXTRACT(QUARTER FROM d)::INTEGER,
    EXTRACT(MONTH FROM d)::INTEGER,
    TO_CHAR(d, 'FMMonth'),
    EXTRACT(DAY FROM d)::INTEGER,
    EXTRACT(ISODOW FROM d)::INTEGER,
    TO_CHAR(d, 'FMDay'),
    EXTRACT(ISODOW FROM d) IN (6, 7)
FROM generate_series(
    (SELECT LEAST(
        MIN(order_date),
        (SELECT MIN(dispatch_date) FROM staging.shipments)
    ) FROM staging.orders),
    (SELECT GREATEST(
        MAX(order_date),
        (SELECT MAX(actual_delivery_date) FROM staging.shipments)
    ) FROM staging.orders),
    INTERVAL '1 day'
) AS series(d)
ON CONFLICT (date_key) DO UPDATE SET
    full_date = EXCLUDED.full_date;
