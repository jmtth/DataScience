CREATE TABLE customers_clean AS
SELECT
    event_time,
    event_type,
    product_id,
    price,
    user_id,
    user_session
FROM (
    SELECT
        *,
        LAG(event_time) OVER (
            PARTITION BY event_type, product_id, price, user_id, user_session
            ORDER BY event_time
        ) AS previous_event_time
    FROM customers
) t
WHERE previous_event_time IS NULL
   OR event_time - previous_event_time > INTERVAL '1 second';

DROP TABLE customers;

ALTER TABLE customers_clean RENAME TO customers;