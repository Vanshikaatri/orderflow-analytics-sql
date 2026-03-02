-- RESTAURANT SLA BREACH ANALYSIS

CREATE TABLE restaurant_sla_analysis AS
SELECT
    r.restaurant_id,
    r.restaurant_name,
    r.city,
    o.order_id,
    o.total_amount,
    r.avg_preparation_time,
    TIMESTAMPDIFF(MINUTE, o.order_time, d.pickup_time) AS actual_prep_time,
    CASE 
        WHEN TIMESTAMPDIFF(MINUTE, o.order_time, d.pickup_time) 
             > r.avg_preparation_time
        THEN 1 ELSE 0
    END AS sla_breached
FROM orders o
JOIN deliveries d ON o.order_id = d.order_id
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.order_status = 'Delivered';

-- Late %
SELECT
    restaurant_name,
    city,
    COUNT(*) AS total_orders,
    SUM(sla_breached) AS late_orders,
    ROUND(
        SUM(sla_breached) * 100.0 / COUNT(*),
        2
    ) AS late_percentage
FROM restaurant_sla_analysis
GROUP BY restaurant_name, city
ORDER BY late_percentage DESC;

-- Revenue Loss
SELECT
    city,
    SUM(total_amount) AS total_revenue,
    SUM(CASE WHEN sla_breached = 1 THEN total_amount ELSE 0 END) AS delayed_revenue,
    ROUND(
        SUM(CASE WHEN sla_breached = 1 THEN total_amount * 0.05 ELSE 0 END),
        2
    ) AS estimated_revenue_loss
FROM restaurant_sla_analysis
GROUP BY city;