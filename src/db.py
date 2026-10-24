import os

import psycopg
from dotenv import load_dotenv

load_dotenv()


def get_connection():
    """Connect to the e-commerce PostgreSQL database."""
    return psycopg.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=os.getenv("DB_PORT", "5434"),
        dbname=os.getenv("DB_NAME", "ecommerce_warehouse"),
        user=os.getenv("DB_USER", "warehouse_user"),
        password=os.getenv("DB_PASSWORD"),
    )


if __name__ == "__main__":
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT current_database(), version();")
            database, version = cur.fetchone()
            print(f"Connected to database: {database}")
            print(f"PostgreSQL: {version.split(',')[0]}")
