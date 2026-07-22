CREATE TABLE dim_customer (
    customer_id INTEGER PRIMARY KEY,
    full_name VARCHAR(100),
    dob DATE,
    gender VARCHAR(10),
    region VARCHAR(50),
    email VARCHAR(100),
    status VARCHAR(20),
    join_date DATE
);

CREATE TABLE dim_account (
    account_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    account_type VARCHAR(20),
    open_date DATE,
    closed_date DATE,
    status VARCHAR(20),
    registration_id INTEGER,
    balance NUMERIC(12,2),

    CONSTRAINT fk_account_customer
        FOREIGN KEY (customer_id)
        REFERENCES dim_customer(customer_id)
);

CREATE TABLE dim_product_category (
    product_category_id INTEGER PRIMARY KEY,
    product_category_name VARCHAR(100)
);

CREATE TABLE dim_product_subcategory (
    product_subcategory_id INTEGER PRIMARY KEY,
    product_category_id INTEGER NOT NULL,
    product_subcategory_name VARCHAR(100),

    CONSTRAINT fk_subcategory_category
        FOREIGN KEY (product_category_id)
        REFERENCES dim_product_category(product_category_id)
);

CREATE TABLE dim_product (
    product_id INTEGER PRIMARY KEY,
    product_subcategory_id INTEGER NOT NULL,
    product_name VARCHAR(100),

    CONSTRAINT fk_product_subcategory
        FOREIGN KEY (product_subcategory_id)
        REFERENCES dim_product_subcategory(product_subcategory_id)
);

CREATE TABLE fact_transaction (
    transaction_id INTEGER PRIMARY KEY,
    account_id INTEGER NOT NULL,
    transaction_date DATE,
    transaction_amount NUMERIC(12,2),
    transaction_type VARCHAR(20),
    transaction_channel VARCHAR(20),
    product_id INTEGER NOT NULL,
    status VARCHAR(20),

    CONSTRAINT fk_transaction_account
        FOREIGN KEY (account_id)
        REFERENCES dim_account(account_id),

    CONSTRAINT fk_transaction_product
        FOREIGN KEY (product_id)
        REFERENCES dim_product(product_id)
);