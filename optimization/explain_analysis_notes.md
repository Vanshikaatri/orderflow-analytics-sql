# EXPLAIN / ANALYZE Notes — OrderFlow Analytics

This document explains how query plans were analyzed and optimized.

---

## 1. Peak Hour Revenue

- **Original Query:**
```sql
SELECT ...
WHERE HOUR(order_time) BETWEEN 19 AND 22

Issue: Function on column prevents index usage.

Optimized Query:

WHERE order_time >= '2023-06-01 19:00:00'
AND order_time < '2023-06-01 23:00:00'

Result: EXPLAIN ANALYZE showed index range scan instead of full table scan.

Execution reduced from ~5.7s → 11ms.

2. Rider Efficiency

Before Optimization: AVG(TIMESTAMPDIFF(...)) on millions of rows.

After Optimization:

Added delivery_minutes column.

Created summary table rider_city_performance.

EXPLAIN ANALYZE confirms aggregates computed on smaller, pre-aggregated table.

Window functions executed efficiently.

3. Customer Cohorts

Before: Raw orders table join per month.

After:

Created customer_cohort and customer_retention.

Indexed (customer_id, order_time, order_status).

EXPLAIN ANALYZE shows index lookup used for each join instead of scanning 1M+ rows.

4. RFM Segmentation

NTILE on orders table → slow.

Pre-aggregated metrics in customer_rfm_base → small table, NTILE fast.

Segment assignment done in a single pass.

5. Restaurant SLA

Ranking restaurants by SLA breach: window function only on computed summary table.

EXPLAIN ANALYZE shows minimal row processing due to indexing.

6. Rider Utilization

Original: join orders and deliveries hourly → slow.

Optimization: hourly_demand and hourly_riders pre-aggregated.

Indexing on (delivery_date, delivery_hour) speeds up join.