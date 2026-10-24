CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS analytics;

COMMENT ON SCHEMA raw IS
    'Landing layer for source CSV data';

COMMENT ON SCHEMA staging IS
    'Cleaned and validated data';

COMMENT ON SCHEMA analytics IS
    'Business-ready warehouse tables and views';
