-- Create schemas
CREATE SCHEMA ubereats_stg_schema;
GO
CREATE SCHEMA ubereats_dim_schema;
GO

-- STAGING TABLES
CREATE TABLE ubereats_stg_schema.stg_customers (
    customer_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    signup_date VARCHAR(50),
    city VARCHAR(50)
);
GO

CREATE TABLE ubereats_stg_schema.stg_deliveries (
    delivery_id INT,
    order_id INT,
    driver_id INT,
    delivery_time_mins INT,
    status VARCHAR(50)
);
GO

CREATE TABLE ubereats_stg_schema.stg_order_items (
    order_item_id INT,
    order_id INT,
    item_name VARCHAR(100),
    category VARCHAR(50),
    quantity INT,
    unit_price DECIMAL(10,2)
);
GO

CREATE TABLE ubereats_stg_schema.stg_orders (
    order_id INT,
    customer_id INT,
    restaurant_id INT,
    order_date VARCHAR(50),
    delivery_date VARCHAR(50),
    total_amount DECIMAL(10,2),
    status VARCHAR(50)
);
GO

CREATE TABLE ubereats_stg_schema.stg_restaurants (
    restaurant_id INT,
    restaurant_name VARCHAR(100),
    cuisine VARCHAR(50),
    city VARCHAR(50),
    rating DECIMAL(2,1)
);
GO

CREATE TABLE ubereats_stg_schema.stg_users (
    user_id INT,
    username VARCHAR(100),
    role VARCHAR(50),
    created_date VARCHAR(50),
    status VARCHAR(20)
);
GO

-- DIMENSION TABLES
CREATE TABLE ubereats_dim_schema.dim_customer (
    customer_key INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT,
    full_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);
GO

CREATE TABLE ubereats_dim_schema.dim_restaurant (
    restaurant_key INT IDENTITY(1,1) PRIMARY KEY,
    restaurant_id INT,
    restaurant_name VARCHAR(100),
    cuisine VARCHAR(50),
    city VARCHAR(50),
    rating DECIMAL(2,1)
);
GO

CREATE TABLE ubereats_dim_schema.dim_product (
    product_key INT IDENTITY(1,1) PRIMARY KEY,
    item_name VARCHAR(100),
    category VARCHAR(50)
);
GO

CREATE TABLE ubereats_dim_schema.dim_user (
    user_key INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    username VARCHAR(100),
    role VARCHAR(50),
    status VARCHAR(20),
    created_date DATE
);
GO

CREATE TABLE ubereats_dim_schema.dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE,
    day INT,
    month INT,
    year INT,
    weekday VARCHAR(20)
);
GO

-- FACT TABLES
CREATE TABLE ubereats_dim_schema.fact_orders (
    order_key INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    customer_key INT,
    restaurant_key INT,
    date_key INT,
    total_amount DECIMAL(10,2),
    delivery_time INT,
    delivery_flag VARCHAR(20),
    FOREIGN KEY (customer_key) REFERENCES ubereats_dim_schema.dim_customer(customer_key),
    FOREIGN KEY (restaurant_key) REFERENCES ubereats_dim_schema.dim_restaurant(restaurant_key),
    FOREIGN KEY (date_key) REFERENCES ubereats_dim_schema.dim_date(date_key)
);
GO

CREATE TABLE ubereats_dim_schema.fact_order_items (
    order_item_key INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    product_key INT,
    customer_key INT,
    restaurant_key INT,
    date_key INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    line_total DECIMAL(10,2),
    FOREIGN KEY (product_key) REFERENCES ubereats_dim_schema.dim_product(product_key),
    FOREIGN KEY (customer_key) REFERENCES ubereats_dim_schema.dim_customer(customer_key),
    FOREIGN KEY (restaurant_key) REFERENCES ubereats_dim_schema.dim_restaurant(restaurant_key),
    FOREIGN KEY (date_key) REFERENCES ubereats_dim_schema.dim_date(date_key)
);
GO