CREATE TABLE items_clean AS
SELECT DISTINCT ON (product_id)
    product_id,
    category_id,
    NULLIF(TRIM(category_code), '') AS category_code,
    NULLIF(TRIM(brand), '') AS brand
FROM items
ORDER BY
    product_id,
    (NULLIF(TRIM(category_code), '') IS NULL) ASC,
    (NULLIF(TRIM(brand), '') IS NULL) ASC,
    (category_id IS NULL) ASC;

CREATE TABLE customers_tmp AS
SELECT
    c.event_time,
    c.event_type,
    c.product_id,
    c.price,
    c.user_id,
    c.user_session,
    i.category_id,
    i.category_code,
    i.brand
FROM customers c
LEFT JOIN items_clean i
    ON c.product_id = i.product_id;

DROP TABLE customers;
ALTER TABLE customers_tmp RENAME TO customers;