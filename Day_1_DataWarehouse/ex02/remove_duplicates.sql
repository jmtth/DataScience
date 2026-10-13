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
        -- Use LAG to get the previous event_time for each row, partitioned by 
        -- event_type, product_id, price, user_id, and user_session,
        -- and ordered by event_time
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