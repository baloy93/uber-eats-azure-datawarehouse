# Uber Eats Azure Data Warehouse Project

## Overview

This project demonstrates the design and implementation of an end-to-end cloud-based data warehouse solution for Uber Eats using Microsoft Azure.

The solution ingests raw CSV files into Azure Blob Storage, orchestrates ETL pipelines using Azure Data Factory, transforms the data into a Star Schema model inside Azure SQL Database, and visualizes business insights through Power BI dashboards.

The project follows modern data engineering principles including modular pipeline architecture, dimensional modeling, scalable ETL orchestration, and analytical reporting.

---

# Architecture Diagram

![Architecture](architecture/architecture_diagram.png)

---

# Star Schema Data Model

![Star Schema](architecture/star_schema_model.png)

---

# Technology Stack

| Layer             | Technology         |
| ----------------- | ------------------ |
| Cloud Platform    | Microsoft Azure    |
| Storage           | Azure Blob Storage |
| ETL Orchestration | Azure Data Factory |
| Database          | Azure SQL Database |
| Data Modeling     | Star Schema        |
| Visualization     | Power BI Desktop   |
| Version Control   | GitHub             |

---

# Project Architecture

## Source Layer

Raw CSV files are uploaded into Azure Blob Storage.

Files include:

* customers_raw.csv
* deliveries_raw.csv
* order_items_raw.csv
* orders_raw.csv
* restaurants_raw.csv
* users_raw.csv

---

## Ingestion Layer

Azure Data Factory orchestrates all ETL processes.

### Main Pipeline

* PL_Master_Orchestrator

### Child Pipelines

* PL_Child_Staging
* PL_Child_Dimensions
* PL_Child_DateDimension
* PL_Child_Facts

### Key Features

* Dynamic Lookup + ForEach ingestion
* Metadata-driven processing
* Modular ETL architecture
* Reusable pipelines
* Scalable orchestration

---

# Data Warehouse Design

## Staging Schema

* stg_customers
* stg_deliveries
* stg_order_items
* stg_orders
* stg_restaurants
* stg_users

## Dimension Schema

* dim_customer
* dim_restaurant
* dim_product
* dim_user
* dim_date

## Fact Schema

* fact_orders
* fact_order_items

---

# Data Flow

1. CSV files uploaded to Azure Blob Storage
2. Azure Data Factory reads files dynamically
3. Raw data loaded into staging tables
4. Cleaned data transformed into dimensions
5. Date dimension generated from order dates
6. Fact tables populated
7. Power BI connected for reporting and analytics

---

# Power BI Dashboard

The Power BI dashboard provides insights into:

* Total Revenue
* Total Orders
* Average Delivery Time
* Fast Delivery Percentage
* Monthly Sales Trends
* Orders by Restaurant
* Delivery Performance
* Top Selling Products

---

# Key Design Decisions

| Design Choice     | Reason                            |
| ----------------- | --------------------------------- |
| Modular pipelines | Easier debugging and maintenance  |
| Staging layer     | Preserve raw source data          |
| Star schema       | Optimized analytical queries      |
| Surrogate keys    | Improved dimensional modeling     |
| Dynamic ingestion | Scalable onboarding of new tables |
| Upsert dimensions | Prevent duplicates                |
| Insert-only facts | Preserve historical transactions  |

---

# Sample SQL Queries

## Total Sales by Month

```sql
SELECT 
    d.year,
    d.month,
    SUM(f.total_amount) AS total_sales
FROM ubereats_fact_schema.fact_orders f
JOIN ubereats_dim_schema.dim_date d
    ON f.date_key = d.date_key
GROUP BY d.year, d.month
ORDER BY d.year, d.month;
```

---

## Delivery Performance by Restaurant

```sql
SELECT 
    r.restaurant_name,
    COUNT(*) AS total_orders,
    ROUND(AVG(f.delivery_time), 0) AS avg_delivery_time
FROM ubereats_fact_schema.fact_orders f
JOIN ubereats_dim_schema.dim_restaurant r
    ON f.restaurant_key = r.restaurant_key
GROUP BY r.restaurant_name
ORDER BY total_orders DESC;
```

---

# Repository Structure

```text
uber-eats-azure-datawarehouse/
│
├── datasets/
├── sql/
├── screenshots/
├── architecture/
├── adf/
├── powerbi/
└── README.md
```

---

# Screenshots

## Azure Data Factory

### Master Pipeline

![ADF Master](screenshots/master_pipeline.png)

### Staging Pipeline

![ADF Staging](screenshots/staging_pipeline.png)

### Dimensions Data Flow

![ADF Dimensions](screenshots/dimensions_dataflow.png)

### Facts Data Flow

![ADF Facts](screenshots/facts_dataflow.png)

---

# Power BI Dashboard

![Dashboard](screenshots/dashboard_overview.png)

---

# Skills Demonstrated

* Azure Data Factory
* ETL Pipeline Development
* Azure SQL Database
* Cloud Data Warehousing
* Star Schema Modeling
* Data Transformation
* Power BI Reporting
* SQL Development
* Data Engineering
* Cloud Analytics

---

# Future Improvements

* Incremental loading
* CI/CD pipeline deployment
* Real-time streaming ingestion
* Azure Synapse integration
* Data quality monitoring
* Automated testing

---

# Author

KULANI BALOYI

