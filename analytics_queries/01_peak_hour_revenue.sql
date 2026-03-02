-- BUSINESS PROBLEM:
-- Peak Hour Revenue by City

-- Original Query (Slow - function based filtering)

EXPLAIN ANALYZE
SELECT 
    c.city,
    DATE(o.order_time) AS order_date,
    SUM(o.total_amount) AS total_revenue,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'Delivered'
AND HOUR(o.order_time) BETWEEN 19 AND 22
GROUP BY c.city, DATE(o.order_time)
ORDER BY total_revenue DESC;

-- Optimized Query (Index Range Scan)
-- Reduced execution from seconds to milliseconds

EXPLAIN ANALYZE
SELECT 
    c.city,
    DATE(o.order_time) AS order_date,
    SUM(o.total_amount) AS total_revenue,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'Delivered'
AND o.order_time >= '2023-06-01 19:00:00'
AND o.order_time <  '2023-06-01 23:00:00'
GROUP BY c.city, DATE(o.order_time)
ORDER BY total_revenue DESC;

-- Index used:
-- idx_orders_covering (order_status, order_time, customer_id, total_amount)