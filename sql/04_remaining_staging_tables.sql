CREATE TABLE IF NOT EXISTS staging.customers (
    customer_id TEXT PRIMARY KEY,
    customer_signup_date DATE,
    gender TEXT,
    age INTEGER,
    age_group TEXT,
    state TEXT,
    city TEXT,
    pincode_prefix TEXT,
    customer_segment TEXT,
    preferred_device TEXT,
    preferred_payment_method TEXT,
    acquisition_channel TEXT,
    total_orders INTEGER,
    total_spend NUMERIC(14,2),
    last_order_date DATE,
    average_order_value NUMERIC(14,2),
    customer_status TEXT,
    loyalty_tier TEXT
);

CREATE TABLE IF NOT EXISTS staging.order_items (
    order_item_id TEXT PRIMARY KEY,
    order_id TEXT,
    product_id TEXT,
    quantity INTEGER,
    unit_price NUMERIC(14,2),
    discount_percentage NUMERIC(5,2),
    item_revenue NUMERIC(14,2),
    item_cost NUMERIC(14,2),
    profit NUMERIC(14,2)
);

CREATE TABLE IF NOT EXISTS staging.returns (
    return_id TEXT PRIMARY KEY,
    order_id TEXT,
    customer_id TEXT,
    product_id TEXT,
    return_date DATE,
    return_reason TEXT,
    refund_amount NUMERIC(14,2),
    return_status TEXT
);

CREATE TABLE IF NOT EXISTS staging.customer_reviews (
    review_id TEXT PRIMARY KEY,
    order_id TEXT,
    customer_id TEXT,
    product_id TEXT,
    review_date DATE,
    rating NUMERIC(3,1),
    review_sentiment TEXT,
    verified_purchase TEXT
);

CREATE TABLE IF NOT EXISTS staging.marketing_campaigns (
    campaign_id TEXT PRIMARY KEY,
    campaign_name TEXT,
    channel TEXT,
    campaign_start_date DATE,
    campaign_end_date DATE,
    campaign_type TEXT,
    target_segment TEXT,
    discount_percentage NUMERIC(5,2),
    conversions INTEGER,
    revenue_generated NUMERIC(14,2),
    impressions BIGINT,
    clicks BIGINT,
    campaign_cost NUMERIC(14,2),
    roi NUMERIC(14,4)
);

-- Reload staging tables from the preserved raw data.
TRUNCATE TABLE
    staging.customers,
    staging.order_items,
    staging.returns,
    staging.customer_reviews,
    staging.marketing_campaigns;

INSERT INTO staging.customers
SELECT
    NULLIF(TRIM(customer_id), ''),
    NULLIF(TRIM(customer_signup_date), '')::DATE,
    NULLIF(TRIM(gender), ''),
    NULLIF(TRIM(age), '')::NUMERIC::INTEGER,
    NULLIF(TRIM(age_group), ''),
    NULLIF(TRIM(state), ''),
    NULLIF(TRIM(city), ''),
    NULLIF(TRIM(pincode_prefix), ''),
    NULLIF(TRIM(customer_segment), ''),
    NULLIF(TRIM(preferred_device), ''),
    NULLIF(TRIM(preferred_payment_method), ''),
    NULLIF(TRIM(acquisition_channel), ''),
    NULLIF(TRIM(total_orders), '')::INTEGER,
    NULLIF(TRIM(total_spend), '')::NUMERIC(14,2),
    NULLIF(TRIM(last_order_date), '')::DATE,
    NULLIF(TRIM(average_order_value), '')::NUMERIC(14,2),
    NULLIF(TRIM(customer_status), ''),
    NULLIF(TRIM(loyalty_tier), '')
FROM raw.customers;

INSERT INTO staging.order_items
SELECT
    NULLIF(TRIM(order_item_id), ''),
    NULLIF(TRIM(order_id), ''),
    NULLIF(TRIM(product_id), ''),
    NULLIF(TRIM(quantity), '')::INTEGER,
    NULLIF(TRIM(unit_price), '')::NUMERIC(14,2),
    NULLIF(TRIM(discount_percentage), '')::NUMERIC(5,2),
    NULLIF(TRIM(item_revenue), '')::NUMERIC(14,2),
    NULLIF(TRIM(item_cost), '')::NUMERIC(14,2),
    NULLIF(TRIM(profit), '')::NUMERIC(14,2)
FROM raw.order_items;

INSERT INTO staging.returns
SELECT
    NULLIF(TRIM(return_id), ''),
    NULLIF(TRIM(order_id), ''),
    NULLIF(TRIM(customer_id), ''),
    NULLIF(TRIM(product_id), ''),
    NULLIF(TRIM(return_date), '')::DATE,
    NULLIF(TRIM(return_reason), ''),
    NULLIF(TRIM(refund_amount), '')::NUMERIC(14,2),
    NULLIF(TRIM(return_status), '')
FROM raw.returns;

INSERT INTO staging.customer_reviews
SELECT
    NULLIF(TRIM(review_id), ''),
    NULLIF(TRIM(order_id), ''),
    NULLIF(TRIM(customer_id), ''),
    NULLIF(TRIM(product_id), ''),
    NULLIF(TRIM(review_date), '')::DATE,
    NULLIF(TRIM(rating), '')::NUMERIC(3,1),
    NULLIF(TRIM(review_sentiment), ''),
    NULLIF(TRIM(verified_purchase), '')
FROM raw.customer_reviews;

INSERT INTO staging.marketing_campaigns
SELECT
    NULLIF(TRIM(campaign_id), ''),
    NULLIF(TRIM(campaign_name), ''),
    NULLIF(TRIM(channel), ''),
    NULLIF(TRIM(campaign_start_date), '')::DATE,
    NULLIF(TRIM(campaign_end_date), '')::DATE,
    NULLIF(TRIM(campaign_type), ''),
    NULLIF(TRIM(target_segment), ''),
    NULLIF(TRIM(discount_percentage), '')::NUMERIC(5,2),
    NULLIF(TRIM(conversions), '')::INTEGER,
    NULLIF(TRIM(revenue_generated), '')::NUMERIC(14,2),
    NULLIF(TRIM(impressions), '')::BIGINT,
    NULLIF(TRIM(clicks), '')::BIGINT,
    NULLIF(TRIM(campaign_cost), '')::NUMERIC(14,2),
    NULLIF(TRIM(roi), '')::NUMERIC(14,4)
FROM raw.marketing_campaigns;
