# Performance Optimization Notes — OrderFlow Analytics

This document details the performance improvements implemented across the OrderFlow SQL analytics project. The focus is on query efficiency, indexing, and summary table usage.

---

## 1. Peak Hour Revenue by City

**Problem:** Original query filtered using `HOUR(order_time)` function, causing full table scan (~5.7 seconds).  

**Solution:**
- Replaced function-based filter with a **datetime range scan**.
- Added **covering index**: `(order_status, order_time, customer_id, total_amount)`.

**Impact:**
- Reduced execution time from ~5.7 seconds → 11 milliseconds.

---

## 2. Rider Efficiency Ranking

**Problem:** Calculating average delivery time on-the-fly over millions of rows was slow.

**Solution:**
- Added `delivery_minutes` pre-computed column.
- Indexed `(delivery_status, rider_id, delivery_minutes)`.
- Used **summary tables** for daily and 90-day aggregates.
- Applied **window functions** (RANK) on summary tables instead of raw data.

**Impact:**
- Query runtime reduced from multiple seconds → milliseconds.
- Real-time ranking became feasible.

---

## 3. Customer Cohort & Retention

**Problem:** Month-over-month retention calculation using raw `orders` table was expensive.

**Solution:**
- Created `customer_cohort` and `customer_retention` tables.
- Added **composite index** `(customer_id, order_time, order_status)` on `orders`.
- Pre-aggregated monthly counts instead of repeated full-table scans.

**Impact:**
- Aggregation queries ran efficiently on 1M+ orders dataset.

---

## 4. RFM Segmentation

**Problem:** NTILE calculations on raw data were slow for large customer base.

**Solution:**
- Computed base RFM metrics in `customer_rfm_base`.
- Applied NTILE on pre-aggregated table `customer_rfm_scored`.
- Segment labels derived in one pass for all customers.

**Impact:**
- Segment assignment for entire dataset runs under seconds.

---

## 5. Restaurant SLA Analysis

**Problem:** SLA breach calculations were slow due to join of orders, deliveries, and restaurants.

**Solution:**
- Indexed `(city, sla_breached)` after SLA computation.
- Calculated `actual_prep_time` once and stored in table.
- Used window functions for top 5 breach ranking per city.

**Impact:**
- Ranking and revenue loss computations became lightweight and queryable.

---

## 6. Rider Utilization & Shortage Detection

**Problem:** Hourly demand and rider availability checks were repetitive and slow.

**Solution:**
- Created `hourly_demand` and `hourly_riders` pre-aggregated tables.
- Indexed `delivery_date` and `delivery_hour`.
- Computed `orders_per_rider` ratio to detect shortages.

**Impact:**
- Enabled near real-time operational insights with minimal query latency.

---

**Summary of Techniques:**
- Covering & composite indexes
- Pre-computed columns (`delivery_minutes`)
- Summary / aggregation tables for large datasets
- Window functions (RANK, NTILE)
- Replacing function filters with range scans
- Eliminating repeated full table scans