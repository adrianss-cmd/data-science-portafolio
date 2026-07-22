/*
=====================================================
IMPORTANT
=====================================================

Before running this script, update the CSV file paths
to match your local project directory.

Example:

FROM '/path/to/your/project/data/FactTransaction.csv'

=====================================================
*/

SET datestyle = 'ISO, DMY';

COPY dim_customer (
    customer_id,
    full_name,
    dob,
    gender,
    region,
    email,
    status,
    join_date
)
FROM '/path/to/your/project/data/DimCustomer.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);

COPY dim_account (
    account_id,
    customer_id,
    account_type,
    open_date,
    closed_date,
    status,
    registration_id,
    balance
)
FROM '/path/to/your/project/data/DimAccount.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);

COPY dim_product_category (
    product_category_id,
    product_category_name
)
FROM '/path/to/your/project/data/DimProductCategory.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);

COPY dim_product_subcategory (
    product_subcategory_id,
    product_category_id,
    product_subcategory_name
)
FROM '/path/to/your/project/data/DimProductSubCategory.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);

COPY dim_product (
    product_id,
    product_subcategory_id,
    product_name
)
FROM '/path/to/your/project/data/Dimproduct.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);

COPY fact_transaction (
    transaction_id,
    account_id,
    transaction_date,
    transaction_amount,
    transaction_type,
    transaction_channel,
    product_id,
    status
)
FROM '/path/to/your/project/data/FactTransaction.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);