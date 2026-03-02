# 🚀 OrderFlow Analytics  
### High-Performance SQL Intelligence System for Food Delivery Platforms

---

## 📌 Project Overview

OrderFlow Analytics is a performance-optimized SQL analytics system simulating a large-scale food delivery platform.

The system models:

- 1M+ order records  
- Multi-city operations  
- Rider performance monitoring  
- Restaurant SLA compliance tracking  
- Customer cohort retention analysis  
- RFM-based customer segmentation  
- Rider utilization & operational shortage detection  

This project focuses on:

- Advanced SQL  
- Window functions  
- Execution plan analysis  
- Composite & covering index design  
- Query performance optimization  
- Scalable analytics architecture  

The objective was not just correctness — but measurable performance improvement.

---

# 🏗 Project Structure

```
orderflow-analytics-sql/
│
├── schema/
├── data_loading/
├── analytics_queries/
├── optimization/
├── data/
├── er_diagram.png
├── LICENSE
└── README.md
```

---

# 📊 Business Modules

## 1. Peak Hour Revenue Optimization

Problem: Identify revenue during peak hours.

Initial issue:
```sql
WHERE HOUR(order_time) BETWEEN 19 AND 22;
```

Optimized:
```sql
WHERE order_time >= '2023-06-01 19:00:00'
AND order_time <  '2023-06-01 23:00:00';
```

Supporting index:
```sql
CREATE INDEX idx_orders_covering 
ON orders(order_status, order_time, customer_id, total_amount);
```

Result: Execution reduced from ~5.7s → 11ms.

---

## 2. Rider Efficiency Ranking

- Precomputed delivery_minutes
- Composite index on (delivery_status, rider_id)
- Created summary table rider_city_performance
- Applied RANK() on smaller dataset

Result: Reduced window function overhead significantly.

---

## 3. Customer Cohort Retention

- Built customer_cohort
- Built customer_retention
- Used PERIOD_DIFF() for month indexing
- Indexed (customer_id, order_time, order_status)

Outcome: Efficient retention matrix generation.

---

## 4. RFM Segmentation

Metrics:
- Recency
- Frequency
- Monetary

Used NTILE(5) for quantile scoring.
Generated customer segments:
- Champions
- Loyal Customers
- At Risk
- Lost
- Potential Loyalists

---

## 5. Restaurant SLA Monitoring

- Compared actual vs expected prep time
- Flagged SLA breaches
- Ranked worst performers
- Estimated revenue impact

---

## 6. Rider Utilization & Shortage Detection

- Built hourly_demand
- Built hourly_riders
- Calculated orders-per-rider ratio
- Flagged operational shortages

---

# ⚡ Performance Engineering

Techniques used:

- Covering indexes
- Composite indexes
- Join key indexing
- Precomputed metrics
- Summary table strategy
- Execution plan benchmarking

---

# 🔍 Execution Validation

All major queries validated using:

```sql
EXPLAIN ANALYZE;
```

Measured:
- Scan type
- Rows examined
- Temporary tables
- Execution time

---

# 📦 Dataset

Small sample dataset included in /data.

Full 1M+ synthetic dataset:

👉 Download here: PASTE_YOUR_GOOGLE_DRIVE_LINK_HERE

---

# 🎤 Interview Summary

"I built a high-performance SQL analytics system simulating a food delivery platform with over 1M orders. I implemented revenue optimization, rider ranking, cohort retention, RFM segmentation, SLA monitoring, and rider shortage detection. I validated improvements using EXPLAIN ANALYZE and optimized queries using composite and covering indexes."

---

# 📜 License

MIT License

---

# 👩‍💻 Author

Vanshika
