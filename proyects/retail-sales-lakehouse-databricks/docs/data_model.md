# Data Model

This document describes the relationships between all tables contained in the Olist Brazilian E-Commerce Dataset.

# Entity Relationship Diagram

## Tables and Keys

| Table | Primary Key | Foreign Keys | Granularity |
|---|---|---|---|
| customers | customer_id | — | One customer record associated with an order |
| orders | order_id | customer_id | One order |
| order_items | order_id + order_item_id | order_id, product_id, seller_id | One item within an order |
| products | product_id | — | One product |
| sellers | seller_id | — | One seller |
| payments | order_id + payment_sequential | order_id | One payment transaction for an order |
| reviews | To be defined | order_id | One review associated with an order |
| geolocation | No clear primary key | geolocation_zip_code_prefix | One geographic observation for a ZIP code prefix |

## Relationships

- One customer record can be associated with one order.
- One order belongs to one customer record.
- One order can contain multiple order items.
- One product can appear in multiple order items.
- One seller can appear in multiple order items.
- One order can have multiple payment transactions.
- One order can have one or more reviews.
- One ZIP code prefix can have multiple geolocation observations.

---
### Relationship Diagram

## Relationship Diagram

```text
                  Customers
                      │
                      │ (1:N)
                      ▼
                   Orders
                  /      \
                 /        \
             (1:N)      (1:N)
               ▼           ▼
        Order Items     Payments
          /      \
     (N:1)      (N:1)
        ▼          ▼
    Products    Sellers

                   │
                 (1:N)
                   ▼
                Reviews
```
---

### Referential Integrity Validation

| Relationship | Result |
|--------------|--------|
| Orders → Customers | ✅ No orphan records |
| Order Items → Orders | ✅ No orphan records |
| Order Items → Products | ✅ No orphan records |
| Order Items → Sellers | ✅ No orphan records |
