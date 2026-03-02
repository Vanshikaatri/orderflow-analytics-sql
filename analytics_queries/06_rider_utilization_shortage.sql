-- RIDER UTILIZATION + SHORTAGE DETECTION


-- Rider Utilization
CREATE TABLE rider_utilization AS
SELECT
    r.rider_id,
    r.city,
    DATE(d.pickup_time) AS delivery_date,
    COUNT(d.delivery_id) AS deliveries_count,
    SUM(d.delivery_minutes) AS total_delivery_minutes
FROM deliveries d
JOIN riders r ON d.rider_id = r.rider_id
WHERE d.delivery_status = 'Completed'
GROUP BY r.rider_id, r.city, DATE(d.pickup_time);

SELECT
    rider_id,
    city,
    delivery_date,
    ROUND(total_delivery_minutes / 480.0 * 100, 2) AS utilization_percentage
FROM rider_utilization
ORDER BY utilization_percentage DESC;

-- Hourly Demand
CREATE TABLE hourly_demand AS
SELECT
    DATE(order_time) AS order_date,
    HOUR(order_time) AS order_hour,
    COUNT(*) AS total_orders
FROM orders
WHERE order_status = 'Delivered'
GROUP BY DATE(order_time), HOUR(order_time);

-- Hourly Active Riders
CREATE TABLE hourly_riders AS
SELECT
    DATE(pickup_time) AS delivery_date,
    HOUR(pickup_time) AS delivery_hour,
    COUNT(DISTINCT rider_id) AS active_riders
FROM deliveries
WHERE delivery_status = 'Completed'
GROUP BY DATE(pickup_time), HOUR(pickup_time);

-- Shortage Detection
SELECT
    d.order_date,
    d.order_hour,
    d.total_orders,
    r.active_riders,
    ROUND(d.total_orders / NULLIF(r.active_riders,0), 2) AS orders_per_rider,
    CASE 
        WHEN d.total_orders / NULLIF(r.active_riders,1) > 3
        THEN 'Potential Shortage'
        ELSE 'Normal'
    END AS capacity_status
FROM hourly_demand d
LEFT JOIN hourly_riders r
    ON d.order_date = r.delivery_date
    AND d.order_hour = r.delivery_hour
ORDER BY d.order_date, d.order_hour;