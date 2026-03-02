-- RFM ANALYSIS

-- Anchor Date
SELECT MAX(order_time) FROM orders;

-- Base RFM Table
CREATE TABLE customer_rfm_base AS
SELECT
    o.customer_id,
    DATEDIFF(
        (SELECT MAX(order_time) FROM orders),
        MAX(o.order_time)
    ) AS recency_days,
    COUNT(CASE WHEN o.order_status = 'Delivered' THEN 1 END) AS frequency_orders,
    SUM(CASE WHEN o.order_status = 'Delivered' 
             THEN o.total_amount ELSE 0 END) AS monetary_value
FROM orders o
GROUP BY o.customer_id;

-- Scoring
CREATE TABLE customer_rfm_scored AS
SELECT
    customer_id,
    recency_days,
    frequency_orders,
    monetary_value,
    NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,
    NTILE(5) OVER (ORDER BY frequency_orders) AS f_score,
    NTILE(5) OVER (ORDER BY monetary_value) AS m_score
FROM customer_rfm_base;

-- Segmentation
CREATE TABLE customer_segments AS
SELECT *,
    CONCAT(r_score, f_score, m_score) AS rfm_code,
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customers'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'New Customers'
        WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
        WHEN r_score = 1 AND f_score = 1 THEN 'Lost'
        ELSE 'Potential Loyalists'
    END AS customer_segment
FROM customer_rfm_scored;

-- Segment Distribution
SELECT 
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(monetary_value),2) AS avg_spend,
    ROUND(AVG(frequency_orders),2) AS avg_orders
FROM customer_segments
GROUP BY customer_segment
ORDER BY customer_count DESC;