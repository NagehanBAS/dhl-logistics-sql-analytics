
# DHL Delivery Performance | SQL Analytics Case Study

**SQLite · Data Quality · Operational KPIs · Segmentation · Reporting**

An end-to-end SQL case study analyzing shipment operations using an educational logistics dataset. The project develops a reproducible analytical model, evaluates delivery performance, and identifies operational patterns across carriers, shipment priorities, and order months.

> **Disclaimer:** This is an independent Workintech educational case study. It is not affiliated with DHL and does not represent DHL's actual operational performance.

---

## Executive Summary

| KPI | Result |
|---|---:|
| Total Shipments | 49 |
| Shipment Line Items | 199 |
| Delivered Shipments | 34 |
| Cancelled Shipments | 3 |
| In Transit | 10 |
| In Progress | 2 |
| Average Dispatch Time | 2.13 days |
| Average Transit Time | 1.94 days |
| Average Total Delivery Time | 4.24 days |
| Global Delay Rate | 2.94% |

**Key Finding:** Among 34 shipments with recorded delivery dates, only one exceeded the five-day transit threshold.

*Average duration metrics exclude NULL values. The delay rate is calculated using only shipments with known arrival dates.*

---

## Business Objectives

This project addresses four key business questions:

1. How efficiently are shipments processed and delivered?
2. How does delivery performance vary across carriers and shipment priority levels?
3. What operational trends emerge from monthly shipment data?
4. What percentage of completed deliveries exceeds the defined delivery-time threshold?

The objective is to transform raw operational data into structured KPIs that support data-driven logistics performance management.

---

## Data Model

The project uses a relational database containing two primary tables.

### Shipment Table

- **Primary Key:** `shipment_id`
- **Records:** 49
- **Purpose:** Stores shipment information, delivery dates, carrier details, customer information, and tracking codes.

### Shipment Item Table

- **Primary Key:** `item_id`
- **Foreign Key:** `shipment_id`
- **Records:** 199
- **Purpose:** Stores products and quantities associated with individual shipments.

### Relationship

```text
shipment (1)
    |
    | shipment_id
    |
    v
shipment_item (N)
```

Each shipment may contain multiple shipment items.

The analytical layer includes:

- `shipment_kpi`
- `shipment_kpi_global`
- `shipment_kpi_carrier`
- `shipment_kpi_urgency`
- `shipment_kpi_month`

---

## Technical Implementation

**Database:** SQLite 3

**Core SQL Skills Demonstrated:**

- Relational database modeling
- Primary and foreign key identification
- Data integrity validation
- Text standardization using `LOWER()` and `REPLACE()`
- Customer name concatenation
- Conditional logic with `CASE WHEN`
- Date calculations using `julianday()`
- Monthly grouping using `strftime()`
- Aggregations using `COUNT()`, `MIN()`, `MAX()`, `SUM()`, and `AVG()`
- Segmentation using `GROUP BY` and `HAVING`
- Numerical formatting using `ROUND()`
- Division-by-zero protection using `NULLIF()`
- KPI table creation and validation

### Delivery Time Metrics

**Dispatch Time**

```sql
julianday(dispatch_date) - julianday(order_date)
```

**Transit Time**

```sql
julianday(arrival_date) - julianday(dispatch_date)
```

**Total Delivery Time**

```sql
julianday(arrival_date) - julianday(order_date)
```

All delivery durations are calculated in days. Missing date values produce NULL duration results.

### Delivery Status Classification

```sql
CASE
    WHEN cancel_date IS NOT NULL THEN 'Cancelled'
    WHEN dispatch_date IS NULL THEN 'In Progress'
    WHEN arrival_date IS NULL THEN 'In Transit'
    ELSE 'Delivered'
END AS status
```

### Delay Classification

A shipment is classified as delayed when its recorded arrival date exceeds five days after dispatch.

```sql
CASE
    WHEN arrival_date IS NULL THEN NULL
    WHEN date(arrival_date) > date(dispatch_date, '+5 days') THEN 1
    ELSE 0
END AS delay
```

---

## Key Business Insights

### 1. Carrier Performance Comparison

| KPI | Colissimo | UPS |
|---|---:|---:|
| Total Shipments | 38 | 11 |
| Average Dispatch Time | 2.22 days | 1.80 days |
| Average Transit Time | 2.00 days | 1.67 days |
| Average Total Delivery Time | 4.43 days | 3.33 days |

**Business Insight:**

UPS records a 1.10-day shorter average total delivery time than Colissimo in the available dataset.

However, the comparison is descriptive rather than a definitive performance ranking because of the limited sample size and differences in shipment characteristics.

### 2. Priority-Based Performance

| Priority | Total Shipments | Average Total Delivery Time |
|---|---:|---:|
| High | 31 | 4.05 days |
| Medium | 11 | 4.33 days |
| Low | 7 | 4.71 days |

**Business Insight:**

High-priority shipments show the shortest average delivery duration.

This pattern is consistent with priority-based fulfillment, although the dataset is insufficient to establish a causal relationship.

### 3. Monthly Performance Trends

| Month | Shipments | Avg. Total Delivery Time |
|---|---:|---:|
| April 2022 | 3 | 4.00 days |
| May 2022 | 2 | 5.50 days |
| June 2022 | 11 | 4.50 days |
| July 2022 | 7 | 4.20 days |
| August 2022 | 15 | 3.93 days |
| September 2022 | 11 | NULL |

**Business Insight:**

Among months with recorded deliveries, August has the shortest average total delivery time at 3.93 days, compared with 5.50 days in May.

September's average total delivery time cannot be calculated because its shipments have no recorded arrival dates.

### 4. Delivery Delay Analysis

| Metric | Value |
|---|---:|
| Total Shipments | 49 |
| Evaluated Shipments | 34 |
| Delayed Shipments | 1 |
| On-Time Shipments | 33 |
| Unknown Delivery Outcomes | 15 |
| **Global Delay Rate** | **2.94%** |

**Business Insight:**

Only 2.94% of evaluated shipments exceeded the five-day transit threshold.

The remaining 15 shipments were excluded from the calculation because their arrival dates were unavailable.

This avoids incorrectly classifying unresolved shipments as on time.

---

## Repository Structure

```text
dhl-logistics-sql-analytics/
├── README.md
├── data/
│   ├── shipment.csv
│   └── shipment_item.csv
└── sql/
    ├── 01_database_setup.sql
    ├── 02_cleaning_and_kpis.sql
    └── 03_quality_checks.sql
```

---

## How to Reproduce the Analysis

**Requirements:** SQLite 3

Create a fresh SQLite database and execute the SQL scripts in the following order:

```bash
sqlite3 dhl_analysis.db < sql/01_database_setup.sql
sqlite3 dhl_analysis.db < sql/02_cleaning_and_kpis.sql
sqlite3 -header -column dhl_analysis.db < sql/03_quality_checks.sql
```

Alternatively, open the scripts in [SQLite Online](https://sqliteonline.com/) and execute them sequentially.

The scripts recreate the seven DHL-specific tables. Use a fresh database to avoid overwriting existing tables.

---

## Data Quality and Limitations

### Carrier Consistency

Some carrier values in the course-provided SQL records differ from the accompanying spreadsheet.

The project preserves the provided SQL carrier values rather than modifying them without authoritative confirmation.

### Tracking Code Inconsistencies

Certain tracking-code prefixes do not match their associated carrier labels.

These inconsistencies are documented rather than automatically corrected.

### Sample Size

The dataset contains 49 shipments.

The course exercise specifies a `HAVING COUNT(*) > 50` carrier filter. As no carrier meets this threshold, the persisted carrier KPI table includes all groups for meaningful descriptive comparison.

### Missing Values

Shipments without recorded arrival dates are excluded from completed-delivery averages and delay-rate calculations.

### KPI Ratio Interpretation

The urgency-level `dispatch_to_total_ratio` is calculated as:

```sql
AVG(dispatch_time) / NULLIF(AVG(total_time), 0)
```

Because missing observations can affect the averages differently, this metric represents a ratio of group averages rather than an average per-shipment ratio.

### Data Provenance

This project uses educational data supplied as part of the Workintech program. Redistribution permissions should be confirmed before publishing the source records.

---

## Future Improvements

Potential extensions include:

- Automated KPI monitoring and reporting
- Interactive Power BI dashboards
- Carrier-level service-level agreement (SLA) monitoring
- Advanced shipment cohort analysis
- Larger-scale operational performance benchmarking
- Predictive delivery delay modeling

---

## Project Information

**Project:** DHL Delivery Performance — SQL Analytics Case Study

**Program:** Workintech — Data Science & AI

**Technologies:** SQLite, SQL

**Focus Areas:** Logistics Analytics, Operational KPIs, Data Cleaning, Performance Reporting

**Project Type:** Independent Educational Portfolio Project

---

*This project was developed for educational and portfolio purposes and is not affiliated with DHL.*

**Author:** Nagehan BAS
