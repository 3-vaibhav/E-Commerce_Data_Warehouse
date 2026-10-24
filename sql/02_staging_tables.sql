CREATE TABLE IF NOT EXISTS staging.orders (
    order_id TEXT PRIMARY KEY,
    customer_id TEXT,
    order_date DATE,
    order_time TIME,
    order_status TEXT,
    shipping_method TEXT,
    delivery_city TEXT,
    delivery_state TEXT,
    coupon_code TEXT,
    discount_percentage NUMERIC(5,2),
    marketing_channel TEXT,
    subtotal NUMERIC(14,2),
    shipping_fee NUMERIC(12,2),
    tax_amount NUMERIC(12,2),
    final_amount NUMERIC(14,2),
    campaign_id TEXT
);

CREATE TABLE IF NOT EXISTS staging.products (
    product_id TEXT PRIMARY KEY,
    product_name TEXT,
    category TEXT,
    subcategory TEXT,
    brand TEXT,
    price NUMERIC(14,2),
    cost_price NUMERIC(14,2),
    discount_range TEXT,
    rating_average NUMERIC(4,2),
    rating_count INTEGER,
    stock_quantity INTEGER,
    product_launch_date DATE,
    product_type TEXT,
    return_rate_baseline NUMERIC(7,4)
);

CREATE TABLE IF NOT EXISTS staging.payments (
    payment_id TEXT PRIMARY KEY,
    order_id TEXT,
    payment_date DATE,
    payment_method TEXT,
    payment_status TEXT,
    amount_paid NUMERIC(14,2),
    transaction_fee NUMERIC(12,2),
    refund_amount NUMERIC(14,2)
);

CREATE TABLE IF NOT EXISTS staging.shipments (
    shipment_id TEXT PRIMARY KEY,
    order_id TEXT,
    warehouse_city TEXT,
    delivery_city TEXT,
    shipping_method TEXT,
    dispatch_date DATE,
    expected_delivery_date DATE,
    actual_delivery_date DATE,
    delivery_days NUMERIC(8,2),
    delivery_status TEXT,
    delayed_flag TEXT
);


TRUNCATE TABLE
    staging.orders,
    staging.products,
    staging.payments,
    staging.shipments;

INSERT INTO staging.orders
SELECT
    NULLIF(TRIM(order_id), ''),
    NULLIF(TRIM(customer_id), ''),
    NULLIF(TRIM(order_date), '')::DATE,
    NULLIF(TRIM(order_time), '')::TIME,
    NULLIF(TRIM(order_status), ''),
    NULLIF(TRIM(shipping_method), ''),
    NULLIF(TRIM(delivery_city), ''),
    NULLIF(TRIM(delivery_state), ''),
    NULLIF(TRIM(coupon_code), ''),
    NULLIF(TRIM(discount_percentage), '')::NUMERIC(5,2),
    NULLIF(TRIM(marketing_channel), ''),
    NULLIF(TRIM(subtotal), '')::NUMERIC(14,2),
    NULLIF(TRIM(shipping_fee), '')::NUMERIC(12,2),
    NULLIF(TRIM(tax_amount), '')::NUMERIC(12,2),
    NULLIF(TRIM(final_amount), '')::NUMERIC(14,2),
    NULLIF(TRIM(campaign_id), '')
FROM raw.orders;

INSERT INTO staging.products
SELECT
    NULLIF(TRIM(product_id), ''),
    NULLIF(TRIM(product_name), ''),
    NULLIF(TRIM(category), ''),
    NULLIF(TRIM(subcategory), ''),
    NULLIF(TRIM(brand), ''),
    NULLIF(TRIM(price), '')::NUMERIC(14,2),
    NULLIF(TRIM(cost_price), '')::NUMERIC(14,2),
    NULLIF(TRIM(discount_range), ''),
    NULLIF(TRIM(rating_average), '')::NUMERIC(4,2),
    NULLIF(TRIM(rating_count), '')::INTEGER,
    NULLIF(TRIM(stock_quantity), '')::INTEGER,
    NULLIF(TRIM(product_launch_date), '')::DATE,
    NULLIF(TRIM(product_type), ''),
    NULLIF(TRIM(return_rate_baseline), '')::NUMERIC(7,4)
FROM raw.products;

INSERT INTO staging.payments
SELECT
    NULLIF(TRIM(payment_id), ''),
    NULLIF(TRIM(order_id), ''),
    NULLIF(TRIM(payment_date), '')::DATE,
    NULLIF(TRIM(payment_method), ''),
    NULLIF(TRIM(payment_status), ''),
    NULLIF(TRIM(amount_paid), '')::NUMERIC(14,2),
    NULLIF(TRIM(transaction_fee), '')::NUMERIC(12,2),
    NULLIF(TRIM(refund_amount), '')::NUMERIC(14,2)
FROM raw.payments;

INSERT INTO staging.shipments
SELECT
    NULLIF(TRIM(shipment_id), ''),
    NULLIF(TRIM(order_id), ''),
    NULLIF(TRIM(warehouse_city), ''),
    NULLIF(TRIM(delivery_city), ''),
    NULLIF(TRIM(shipping_method), ''),
    NULLIF(TRIM(dispatch_date), '')::DATE,
    NULLIF(TRIM(expected_delivery_date), '')::DATE,
    NULLIF(TRIM(actual_delivery_date), '')::DATE,
    NULLIF(TRIM(delivery_days), '')::NUMERIC(8,2),
    NULLIF(TRIM(delivery_status), ''),
    NULLIF(TRIM(delayed_flag), '')
FROM raw.shipments;
