-- DATA CLEANING SCRIPT


SET SQL_SAFE_UPDATES = 0;

-- 1️. Fix delivery_status (remove hidden characters)

UPDATE deliveries
SET delivery_status = REPLACE(delivery_status, '\r', '');

UPDATE deliveries
SET delivery_status = TRIM(delivery_status);

-- Validate cleaning
SELECT DISTINCT delivery_status, LENGTH(delivery_status)
FROM deliveries;


-- 2️. Pre-compute delivery_minutes

UPDATE deliveries
SET delivery_minutes = TIMESTAMPDIFF(
    MINUTE,
    pickup_time,
    delivery_time
)
WHERE pickup_time IS NOT NULL
AND delivery_time IS NOT NULL;

-- 3️. Fix Zero Date Issues (if any)

UPDATE orders
SET order_time = NULL
WHERE order_time = '0000-00-00 00:00:00';

UPDATE deliveries
SET pickup_time = NULL
WHERE pickup_time = '0000-00-00 00:00:00';

UPDATE deliveries
SET delivery_time = NULL
WHERE delivery_time = '0000-00-00 00:00:00';

UPDATE payments
SET payment_time = NULL
WHERE payment_time = '0000-00-00 00:00:00';

SET SQL_SAFE_UPDATES = 1;

