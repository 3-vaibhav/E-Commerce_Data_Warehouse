import csv
from pathlib import Path

from src.db import get_connection


PROJECT_ROOT = Path(__file__).resolve().parent.parent
RAW_DATA_DIR = PROJECT_ROOT / "data" / "raw"

TABLES = {
    "customers.csv": "customers",
    "products.csv": "products",
    "orders.csv": "orders",
    "order_items.csv": "order_items",
    "payments.csv": "payments",
    "shipments.csv": "shipments",
    "returns.csv": "returns",
    "customer_reviews.csv": "customer_reviews",
    "marketing_campaigns.csv": "marketing_campaigns",
}


def ingest_csv(filename, table_name):
    """Load a CSV file into its matching raw PostgreSQL table."""
    file_path = RAW_DATA_DIR / filename

    if not file_path.exists():
        raise FileNotFoundError(f"CSV file not found: {file_path}")

    with file_path.open("r", encoding="utf-8-sig", newline="") as csv_file:
        reader = csv.DictReader(csv_file)
        columns = reader.fieldnames

        if not columns:
            raise ValueError(f"No CSV headers found in {filename}")

        column_sql = ", ".join(f'"{column}"' for column in columns)
        placeholders = ", ".join(["%s"] * len(columns))
        insert_sql = (
            f"INSERT INTO raw.{table_name} ({column_sql}) "
            f"VALUES ({placeholders})"
        )

        rows_loaded = 0

        with get_connection() as conn:
            with conn.cursor() as cur:
                cur.execute(f"TRUNCATE TABLE raw.{table_name}")

                for row in reader:
                    values = [
                        row[column] if row[column] != "" else None
                        for column in columns
                    ]
                    cur.execute(insert_sql, values)
                    rows_loaded += 1

        return rows_loaded


def main():
    total_rows = 0

    for filename, table_name in TABLES.items():
        print(f"Loading {filename}...")
        rows = ingest_csv(filename, table_name)
        total_rows += rows
        print(f"  Loaded {rows:,} rows into raw.{table_name}")

    print(f"\nIngestion complete. Total rows loaded: {total_rows:,}")


if __name__ == "__main__":
    main()
