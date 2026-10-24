# E-Commerce Data Warehouse & ETL Pipeline

I built this project to get hands on experience with the kind of work a data engineer does: collecting raw data, cleaning it, organizing it into a warehouse, and making it useful for analysis.

The project uses synthetic e-commerce marketplace data and a stack of Python, PostgreSQL, SQL, and Docker. The goal was to build a complete batch ETL pipeline and understand how raw data becomes something a business can actually use.

## What does this project do?

Imagine an online marketplace generating thousands of orders, product records, customer details, and shipment updates. All that information is useful, but analyzing it directly from separate CSV files can quickly become messy.

This project brings that data into PostgreSQL, transforms it into structured tables, and organizes it into a warehouse that can answer questions like:

- How does revenue change from month to month?
- Which product categories generate the most profit?
- Which shipping methods have the highest delay rates?
- How much are customers spending per order?

## Tech Stack

- **Python** — loading CSV data and connecting to PostgreSQL
- **PostgreSQL** — storing raw data, staging tables, and the analytics warehouse
- **SQL** — cleaning data, building tables, and writing business queries
- **Docker** — running PostgreSQL locally in a container
- **pytest** — checking that important warehouse rules hold
- **python-dotenv** — managing local database configuration

## How the pipeline works

```text
CSV Files
   |
   v
Python Ingestion
   |
   v
Raw Tables
   |
   v
Staging Tables
   |
   v
Analytics Warehouse
   |
   v
Business Queries + Tests
```

### 1. Loading the raw data

I started by loading the source CSV files into PostgreSQL. The raw tables keep source values as text so that type conversion and validation can happen in a separate step.

The ingestion script loads the data into the database, making it easier to work with than a collection of disconnected files.

### 2. Cleaning and preparing the data

Next, I created staging tables with appropriate data types, such as dates, numbers, and identifiers.

I also wrote SQL checks to look for issues such as missing relationships, invalid values, and inconsistent records. One example was handling customer ages stored as decimal-looking text values, such as `44.0`, before converting them into integers.

### 3. Building the warehouse

I designed a dimensional model with customer, product, and date dimensions, along with three fact tables.

**Dimension tables**
- `analytics.dim_customers`
- `analytics.dim_products`
- `analytics.dim_date`

**Fact tables**
- `analytics.fact_orders`
- `analytics.fact_order_items`
- `analytics.fact_shipments`

One design decision I paid attention to was keeping orders and order items in separate fact tables. An order can contain multiple products, so combining order-level amounts with item-level rows without care can inflate revenue totals.

### 4. Analyzing the data

Once the warehouse was populated, I wrote SQL queries to explore the data from a business perspective.

Some of the reports include monthly revenue and order volume, category-level profitability, and delivery performance by shipping method.

A few interesting findings from the current synthetic dataset:

- Fashion has a profit margin of approximately **33.14%**.
- Electronics generates substantial revenue but has a much lower profit margin of approximately **0.69%**.
- Delivery delay rates vary considerably across shipping methods.

These are observations from the sample dataset, not real-world company results.

## Dataset at a glance

The pipeline loads **659,318 raw business records** across nine datasets.

| Dataset | Records |
|---|---:|
| Customers | 25,000 |
| Products | 550 |
| Orders | 100,000 |
| Order items | 254,331 |
| Payments | 100,000 |
| Shipments | 89,681 |
| Customer reviews | 77,530 |
| Returns | 12,075 |
| Marketing campaigns | 151 |
| **Total** | **659,318** |

The data is synthetic and intended for learning and portfolio demonstration.

## Data quality and testing

I didn't want to stop at loading data successfully, so I added automated tests with `pytest`.

The current tests check:
- Whether fact tables contain the expected number of records
- Whether fact-table identifiers are unique
- Whether required customer, product, and date keys are populated

The test suite is passing against my local warehouse.

To run the tests:

```bash
python -m pytest -v
```

## Running the project locally

You'll need Python 3 and Docker Desktop installed.

### 1. Create a virtual environment

```bash
python3 -m venv .venv
source .venv/bin/activate
```

### 2. Install the dependencies

```bash
pip install -r requirements.txt
```

### 3. Configure the database

Create a `.env` file in the project root with your local PostgreSQL settings:

```dotenv
DB_HOST=localhost
DB_PORT=5434
DB_NAME=ecommerce_warehouse
DB_USER=warehouse_user
DB_PASSWORD=your_local_password
```

Keep `.env` out of version control. Never publish database passwords or other secrets.

### 4. Initialize and load the database

Start the PostgreSQL Docker container and run