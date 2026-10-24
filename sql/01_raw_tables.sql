CREATE TABLE IF NOT EXISTS raw.customers (
    customer_id TEXT,
    customer_signup_date TEXT,
    gender TEXT,
    age TEXT,
    age_group TEXT,
    state TEXT,
    city TEXT,
    pincode_prefix TEXT,
    customer_segment TEXT,
    preferred_device TEXT,
    preferred_payment_method TEXT,
    acquisition_channel TEXT,
    total_orders TEXT,
    total_spend TEXT,
    last_order_date TEXT,
    average_order_value TEXT,
    customer_status TEXT,
    loyalty_tier TEXT
);

CREATE TABLE IF NOT EXISTS raw.products (
    product_id TEXT,
    product_name TEXT,
    category TEXT,
    subcategory TEXT,
    brand TEXT,
    price TEXT,
    cost_price TEXT,
    discount_range TEXT,
    rating_average TEXT,
    rating_count TEXT,
    stock_quantity TEXT,
    product_launch_date TEXT,
    product_type TEXT,
    return_rate_baseline TEXT
);

CREATE TABLE IF NOT EXISTS raw.orders (
    order_id TEXT,
    customer_id TEXT,
    order_date TEXT,
    order_time TEXT,
    order_status TEXT,
    shipping_method TEXT,
    delivery_city TEXT,
    delivery_state TEXT,
    coupon_code TEXT,
    discount_percentage TEXT,
    marketing_channel TEXT,
    subtotal TEXT,
    shipping_fee TEXT,
    tax_amount TEXT,
    final_amount TEXT,
    campaign_id TEXT
);

CREATE TABLE IF NOT EXISTS raw.order_items (
    order_item_id TEXT,
    order_id TEXT,
    product_id TEXT,
    quantity TEXT,
    unit_price TEXT,
    discount_percentage TEXT,
    item_revenue TEXT,
    item_cost TEXT,
    profit TEXT
);

CREATE TABLE IF NOT EXISTS raw.payments (
    payment_id TEXT,
    order_id TEXT,
    payment_date TEXT,
    payment_method TEXT,
    payment_status TEXT,
    amount_paid TEXT,
    transaction_fee TEXT,
    refund_amount TEXT
);

CREATE TABLE IF NOT EXISTS raw.shipments (
    shipment_id TEXT,
    order_id TEXT,
    warehouse_city TEXT,
    delivery_city TEXT,
    shipping_method TEXT,
    dispatch_date TEXT,
    expected_delivery_date TEXT,
    actual_delivery_date TEXT,
    delivery_days TEXT,
    delivery_status TEXT,
    delayed_flag TEXT
);

CREATE TABLE IF NOT EXISTS raw.returns (
    return_id TEXT,
    order_id TEXT,
    customer_id TEXT,
    product_id TEXT,
    return_date TEXT,
    return_reason TEXT,
    refund_amount TEXT,
    return_status TEXT
);

CREATE TABLE IF NOT EXISTS raw.customer_reviews (
    review_id TEXT,
    order_id TEXT,
    customer_id TEXT,
    product_id TEXT,
    review_date TEXT,
    rating TEXT,
    review_sentiment TEXT,
    verified_purchase TEXT
);

CREATE TABLE IF NOT EXISTS raw.marketing_campaigns (
    campaign_id TEXT,
    campaign_name TEXT,
    channel TEXT,
    campaign_start_date TEXT,
    campaign_end_date TEXT,
    campaign_type TEXT,
    target_segment TEXT,
    discount_percentage TEXT,
    conversions TEXT,
    revenue_generated TEXT,
    impressions TEXT,
    clicks TEXT,
    campaign_cost TEXT,
    roi TEXT
);
