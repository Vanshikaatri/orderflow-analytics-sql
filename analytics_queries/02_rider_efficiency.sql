-- BUSINESS PROBLEM:
-- Rider Efficiency Ranking

-- 1️. Base Window Function Query

EXPLAIN ANALYZE
WITH rider_stats AS (
    SELECT 
        r.city,
        r.rider_id,
        COUNT(d.delivery_id) AS total_deliveries,
        AVG(d.delivery_minutes) AS avg_delivery_minutes
    FROM deliveries d
    JOIN riders r ON d.rider_id = r.rider_id
    WHERE d.delivery_status = 'Completed'
    GROUP BY r.city, r.rider_id
)
SELECT *
FROM (
    SELECT *,
           RANK() OVER (
               PARTITION BY city 
               ORDER BY avg_delivery_minutes
           ) AS city_rank
    FROM rider_stats
) ranked
WHERE city_rank <= 5
ORDER BY city, city_rank;


-- 2️. Optimized Version (Using Summary Table)


CREATE TABLE rider_city_performance (
    city VARCHAR(50),
    rider_id INT,
    total_deliveries INT,
    avg_delivery_minutes DECIMAL(10,2),
    PRIMARY KEY (city, rider_id)
);

INSERT INTO rider_city_performance
SELECT 
    r.city,
    r.rider_id,
    COUNT(d.delivery_id),
    AVG(d.delivery_minutes)
FROM deliveries d
JOIN riders r ON d.rider_id = r.rider_id
WHERE d.delivery_status = 'Completed'
GROUP BY r.city, r.rider_id;

-- Ranking on small summary table
EXPLAIN ANALYZE
WITH ranked AS (
    SELECT 
        city,
        rider_id,
        total_deliveries,
        avg_delivery_minutes,
        RANK() OVER (
            PARTITION BY city
            ORDER BY avg_delivery_minutes
        ) AS city_rank
    FROM rider_city_performance
)
SELECT *
FROM ranked
WHERE city_rank <= 5
ORDER BY city, city_rank;