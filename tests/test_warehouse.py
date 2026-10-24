import os

import psycopg
import pytest
from dotenv import load_dotenv

load_dotenv()

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "localhost"),
    "port": os.getenv("DB_PORT", "5434"),
    "dbname": os.getenv("DB_NAME", "ecommerce_warehouse"),
    "user": os.getenv("DB_USER", "warehouse_user"),
    "password": os.getenv("DB_PASSWORD"),
}


@pytest.fixture(scope="module")
def conn():
    """Connect to the local PostgreSQL warehouse."""
    with psycopg.connect(**DB_CONFIG) as connection:
        yield connection


def scalar(conn, query):
    """Execute a query and return its first value."""
    with conn.cursor() as cur:
        cur.execute(query)
        return cur.fetchone()[0]


def test_fact_orders_row_count(conn):
    assert scalar(
        conn, "SELECT COUNT(*) FROM analytics.fact_orders"
    ) == 100_000


def test_fact_order_items_row_count(conn):
    assert scalar(
        conn, "SELECT COUNT(*) FROM analytics.fact_order_items"
    ) == 254_331


def test_fact_shipments_row_count(conn):
    assert scalar(
        conn, "SELECT COUNT(*) FROM analytics.fact_shipments"
    ) == 89_681


@pytest.mark.parametrize(
    "table, column",
    [
        ("analytics.fact_orders", "order_id"),
        ("analytics.fact_order_items", "order_item_id"),
        ("analytics.fact_shipments", "shipment_id"),
    ],
)
def test_fact_ids_are_unique(conn, table, column):
    query = f"""
        SELECT COUNT(*) - COUNT(DISTINCT {column})
        FROM {table}
    """
    assert scalar(conn, query) == 0


@pytest.mark.parametrize(
    "table, column",
    [
        ("analytics.fact_orders", "customer_key"),
        ("analytics.fact_orders", "order_date_key"),
        ("analytics.fact_order_items", "customer_key"),
        ("analytics.fact_order_items", "product_key"),
        ("analytics.fact_order_items", "order_date_key"),
        ("analytics.fact_shipments", "order_date_key"),
    ],
)
def test_required_dimension_keys_are_present(conn, table, column):
    query = f"SELECT COUNT(*) FROM {table} WHERE {column} IS NULL"
    assert scalar(conn, query) == 0
