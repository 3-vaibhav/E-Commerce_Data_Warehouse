-- E-Commerce Data Warehouse
-- Step 27: Core analytics star schema

CREATE TABLE IF NOT EXISTS analytics.dim_customers (
    customer_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id TEXT UNIQUE NOT NULL,
    signup_date DATE,
    gender TEXT,
    age INTEGER,
    age_group TEXT,
    state TEXT,
    city TEXT,
    customer_segment TEXT,
    preferred_device TEXT,
    preferred_payment_method TEXT,
    acquisition_channel TEXT,
    customer_status TEXT,
    loyalty_tier TEXT
);

CREATE TABLE IF NOT EXISTS analytics.dim_products (
    product_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id TEXT UNIQUE NOT NULL,
    product_name TEXT,
    category TEXT,
    subcategory TEXT,
    brand TEXT,
    product_type TEXT,
    price NUMERIC(14,2),
    cost_price NUMERIC(14,2),
    product_launch_date DATE
);

CREATE TABLE IF NOT EXISTS analytics.dim_date (
    date_key INTEGER PRIMARY KEY,
    full_date DATE UNIQUE NOT NULL,
    year INTEGER NOT NULL,
    quarter INTEGER NOT NULL,
    month INTEGER NOT NULL,
    month_name TEXT NOT NULL,
    day_of_month INTEGER NOT NULL,
    day_of_week INTEGER NOT NULL,
    day_name TEXT NOT NULL,
    is_weekend BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS analytics.fact_orders (
    order_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id TEXT UNIQUE NOT NULL,
    customer_key BIGINT REFERENCES analytics.dim_customers(customer_key),
    order_date_key INTEGER REFERENCES analytics.dim_date(date_key),
    order_status TEXT,
    shipping_method TEXT,
    marketing_channel TEXT,
    campaign_id TEXT,
    subtotal NUMERIC(14,2),
    shipping_fee NUMERIC(12,2),
    tax_amount NUMERIC(12,2),
    discount_percentage NUMERIC(5,2),
    final_amount NUMERIC(14,2)
);

CREATE TABLE IF NOT EXISTS analytics.fact_order_items (
    order_item_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_item_id TEXT UNIQUE NOT NULL,
    order_id TEXT NOT NULL,
    customer_key BIGINT REFERENCES analytics.dim_customers(customer_key),
    product_key BIGINT REFERENCES analytics.dim_products(product_key),
    order_date_key INTEGER REFERENCES analytics.dim_date(date_key),
    quantity INTEGER,
    unit_price NUMERIC(14,2),
    discount_percentage NUMERIC(5,2),
    item_revenue NUMERIC(14,2),
    item_cost NUMERIC(14,2),
    profit NUMERIC(14,2)
);

CREATE TABLE IF NOT EXISTS analytics.fact_shipments (
    shipment_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    shipment_id TEXT UNIQUE NOT NULL,
    order_id TEXT,
    order_date_key INTEGER REFERENCES analytics.dim_date(date_key),
    dispatch_date DATE,
    expected_delivery_date DATE,
    actual_delivery_date DATE,
    delivery_days NUMERIC(8,2),
    delivery_status TEXT,
    delayed_flag TEXT,
    warehouse_city TEXT,
    delivery_city TEXT,
    shipping_method TEXT
);
