-- CUSTOMER COHORT RETENTION ANALYSIS

-- Step 1: Create Cohort Table
CREATE TABLE customer_cohort AS
SELECT 
    customer_id,
    MIN(DATE(order_time)) AS first_order_date,
    DATE_FORMAT(MIN(order_time), '%Y-%m-01') AS cohort_month
FROM orders
GROUP BY customer_id;

-- Step 2: Build Retention Table
CREATE TABLE customer_retention AS
SELECT 
    c.customer_id,
    c.cohort_month,
    DATE_FORMAT(o.order_time, '%Y-%m-01') AS order_month,
    PERIOD_DIFF(
        DATE_FORMAT(o.order_time, '%Y%m'),
        DATE_FORMAT(c.first_order_date, '%Y%m')
    ) AS month_number
FROM orders o
JOIN customer_cohort c 
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'Delivered';

-- Step 3: Retention %
WITH cohort_size AS (
    SELECT 
        cohort_month,
        COUNT(DISTINCT customer_id) AS total_customers
    FROM customer_cohort
    GROUP BY cohort_month
)

SELECT 
    r.cohort_month,
    r.month_number,
    COUNT(DISTINCT r.customer_id) AS active_customers,
    cs.total_customers,
    ROUND(
        COUNT(DISTINCT r.customer_id) * 100.0 / cs.total_customers,
        2
    ) AS retention_percentage
FROM customer_retention r
JOIN cohort_size cs 
    ON r.cohort_month = cs.cohort_month
GROUP BY r.cohort_month, r.month_number, cs.total_customers
ORDER BY r.cohort_month, r.month_number;