
-- =========================================================
-- DHL DELIVERY PERFORMANCE | SQL ANALYTICS CASE STUDY
-- 03_QUALITY_CHECKS.SQL
-- Author: Nagehan Bas
-- Database: SQLite 3
--
-- Purpose:
-- Validate source data integrity, analytical consistency,
-- missing values, delivery dates, and KPI calculations.
--
-- Prerequisites:
-- 01_database_setup.sql
-- 02_cleaning_and_kpis.sql
--
-- All checks are read-only.
-- =========================================================


-- =========================================================
-- 1. SOURCE DATA COMPLETENESS
-- =========================================================

-- Confirm the expected record counts.

SELECT
    'shipment' AS table_name,
    COUNT(*) AS actual_rows,
    49 AS expected_rows,
    CASE
        WHEN COUNT(*) = 49 THEN 'PASS'
        ELSE 'FAIL'
    END AS check_result
FROM shipment

UNION ALL

SELECT
    'shipment_item',
    COUNT(*),
    199,
    CASE
        WHEN COUNT(*) = 199 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM shipment_item;


-- =========================================================
-- 2. PRIMARY KEY UNIQUENESS
-- =========================================================

-- Every shipment and item must have a unique identifier.

SELECT
    'shipment_id' AS checked_field,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT shipment_id) AS unique_values,
    CASE
        WHEN COUNT(*) = COUNT(DISTINCT shipment_id)
         AND COUNT(shipment_id) = COUNT(*)
        THEN 'PASS'
        ELSE 'FAIL'
    END AS check_result
FROM shipment

UNION ALL

SELECT
    'item_id',
    COUNT(*),
    COUNT(DISTINCT item_id),
    CASE
        WHEN COUNT(*) = COUNT(DISTINCT item_id)
         AND COUNT(item_id) = COUNT(*)
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM shipment_item;


-- =========================================================
-- 3. REFERENTIAL INTEGRITY
-- =========================================================

-- Check that every shipment item belongs to an
-- existing shipment.

SELECT
    COUNT(*) AS orphan_item_count,
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS check_result
FROM shipment_item AS si
LEFT JOIN shipment AS s
    ON si.shipment_id = s.shipment_id
WHERE s.shipment_id IS NULL;


-- SQLite's built-in foreign key validation.

PRAGMA foreign_key_check;


-- =========================================================
-- 4. MISSING VALUE ANALYSIS
-- =========================================================

-- Missing delivery and dispatch dates may be legitimate
-- for shipments that are cancelled or still in progress.

SELECT
    COUNT(*) AS total_shipments,

    SUM(CASE
        WHEN order_date IS NULL THEN 1 ELSE 0
    END) AS missing_order_dates,

    SUM(CASE
        WHEN dispatch_date IS NULL THEN 1 ELSE 0
    END) AS missing_dispatch_dates,

    SUM(CASE
        WHEN arrival_date IS NULL THEN 1 ELSE 0
    END) AS missing_arrival_dates,

    SUM(CASE
        WHEN customer_name IS NULL
          OR TRIM(customer_name) = ''
        THEN 1 ELSE 0
    END) AS missing_customer_names,

    SUM(CASE
        WHEN customer_surname IS NULL
          OR TRIM(customer_surname) = ''
        THEN 1 ELSE 0
    END) AS missing_customer_surnames,

    SUM(CASE
        WHEN tracking_code IS NULL
          OR TRIM(tracking_code) = ''
        THEN 1 ELSE 0
    END) AS missing_tracking_codes

FROM shipment;


-- =========================================================
-- 5. DATE CHRONOLOGY VALIDATION
-- =========================================================

-- Flag logically inconsistent shipment dates.
-- Expected result: zero invalid records.

SELECT
    shipment_id,
    order_date,
    dispatch_date,
    arrival_date,
    cancel_date
FROM shipment
WHERE
    (dispatch_date IS NOT NULL
        AND date(dispatch_date) < date(order_date))

    OR (arrival_date IS NOT NULL
        AND dispatch_date IS NOT NULL
        AND date(arrival_date) < date(dispatch_date))

    OR (cancel_date IS NOT NULL
        AND date(cancel_date) < date(order_date))

    OR (arrival_date IS NOT NULL
        AND cancel_date IS NOT NULL);


-- =========================================================
-- 6. PRODUCT QUANTITY VALIDATION
-- =========================================================

-- Item quantities must be positive.

SELECT
    COUNT(*) AS invalid_quantity_count,
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS check_result
FROM shipment_item
WHERE quantity IS NULL
   OR quantity <= 0;


-- =========================================================
-- 7. CARRIER AND URGENCY STANDARDIZATION
-- =========================================================

-- Review carrier values and their frequencies.

SELECT
    LOWER(TRIM(carrier)) AS clean_carrier,
    COUNT(*) AS total_shipments
FROM shipment
GROUP BY LOWER(TRIM(carrier))
ORDER BY total_shipments DESC;


-- Review urgency labels and their frequencies.

SELECT
    urgency,
    COUNT(*) AS total_shipments
FROM shipment
GROUP BY urgency
ORDER BY total_shipments DESC;


-- =========================================================
-- 8. TRACKING AND CARRIER CONSISTENCY
-- =========================================================

-- A tracking-code prefix or tracking URL may reference
-- a carrier different from the source carrier column.
-- These are potential discrepancies, not automatic errors.
-- Preserve the source carrier values for KPI reporting.

SELECT
    shipment_id,
    carrier,
    tracking_code,
    CASE
        WHEN UPPER(tracking_code) LIKE 'UPS%' THEN 'ups'
        WHEN UPPER(tracking_code) LIKE 'DHL%' THEN 'dhl'
        WHEN UPPER(tracking_code) LIKE 'COLISSIMO%'
            THEN 'colissimo'
        ELSE 'unknown'
    END AS tracking_prefix_carrier
FROM shipment
WHERE
    CASE
        WHEN UPPER(tracking_code) LIKE 'UPS%' THEN 'ups'
        WHEN UPPER(tracking_code) LIKE 'DHL%' THEN 'dhl'
        WHEN UPPER(tracking_code) LIKE 'COLISSIMO%'
            THEN 'colissimo'
        ELSE 'unknown'
    END <> LOWER(TRIM(carrier));


-- =========================================================
-- 9. DELIVERY STATUS VALIDATION
-- =========================================================

-- Confirm that each analytical record has a valid status.

SELECT
    status,
    COUNT(*) AS total_shipments
FROM shipment_kpi
GROUP BY status
ORDER BY total_shipments DESC;


-- Check that operational status matches source dates.

SELECT
    COUNT(*) AS invalid_status_count,
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS check_result
FROM shipment_kpi
WHERE status <>
    CASE
        WHEN cancel_date IS NOT NULL THEN 'Cancelled'
        WHEN dispatch_date IS NULL THEN 'In Progress'
        WHEN arrival_date IS NULL THEN 'In Transit'
        ELSE 'Delivered'
    END;


-- =========================================================
-- 10. DELIVERY TIME VALIDATION
-- =========================================================

-- Negative durations would indicate data inconsistencies.

SELECT
    COUNT(*) AS negative_duration_count,
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS check_result
FROM shipment_kpi
WHERE dispatch_time < 0
   OR transit_time < 0
   OR total_time < 0;


-- Check total delivery duration against component times.
-- Only fully delivered shipments can be evaluated.

SELECT
    COUNT(*) AS duration_mismatch_count,
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS check_result
FROM shipment_kpi
WHERE total_time IS NOT NULL
  AND dispatch_time IS NOT NULL
  AND transit_time IS NOT NULL
  AND ABS(
      total_time - (dispatch_time + transit_time)
  ) > 0.000001;


-- =========================================================
-- 11. DELAY RATE VERIFICATION
-- =========================================================

-- Only shipments with a known arrival date
-- are included in the delay-rate denominator.
-- NULL delay values are excluded.

SELECT
    COUNT(*) AS total_shipments,

    COUNT(delay) AS evaluable_shipments,

    SUM(CASE
        WHEN delay = 1 THEN 1
        ELSE 0
    END) AS delayed_shipments,

    SUM(CASE
        WHEN delay = 0 THEN 1
        ELSE 0
    END) AS on_time_shipments,

    ROUND(
        100.0 * SUM(CASE
            WHEN delay = 1 THEN 1
            ELSE 0
        END) / NULLIF(COUNT(delay), 0),
        2
    ) AS delay_percentage

FROM shipment_kpi;


-- =========================================================
-- 12. ANALYTICAL TABLE COMPLETENESS
-- =========================================================

-- Check that each shipment has exactly one KPI record.

SELECT
    COUNT(*) AS analytical_rows,
    COUNT(DISTINCT shipment_id) AS unique_shipments,

    CASE
        WHEN COUNT(*) = (SELECT COUNT(*) FROM shipment)
         AND COUNT(*) = COUNT(DISTINCT shipment_id)
        THEN 'PASS'
        ELSE 'FAIL'
    END AS check_result

FROM shipment_kpi;


-- =========================================================
-- 13. SUMMARY TABLE RECONCILIATION
-- =========================================================

-- Carrier, urgency, and monthly summaries should
-- reconcile to the total shipment count.

SELECT
    'Carrier summary' AS summary_name,
    SUM(total_shipments) AS summarized_shipments,
    (SELECT COUNT(*) FROM shipment) AS source_shipments,
    CASE
        WHEN SUM(total_shipments) =
             (SELECT COUNT(*) FROM shipment)
        THEN 'PASS'
        ELSE 'FAIL'
    END AS check_result
FROM shipment_kpi_carrier

UNION ALL

SELECT
    'Urgency summary',
    SUM(total_shipments),
    (SELECT COUNT(*) FROM shipment),
    CASE
        WHEN SUM(total_shipments) =
             (SELECT COUNT(*) FROM shipment)
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM shipment_kpi_urgency

UNION ALL

SELECT
    'Monthly summary',
    SUM(total_shipments),
    (SELECT COUNT(*) FROM shipment),
    CASE
        WHEN SUM(total_shipments) =
             (SELECT COUNT(*) FROM shipment)
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM shipment_kpi_month;


-- =========================================================
-- 14. FINAL KPI RECONCILIATION
-- =========================================================

-- Verify the global reporting metrics against
-- the analytical shipment table.

SELECT
    g.total_shipments AS reported_shipments,
    COUNT(k.shipment_id) AS calculated_shipments,

    g.avg_total_time AS reported_avg_total_time,
    ROUND(AVG(k.total_time), 2)
        AS calculated_avg_total_time,

    g.delay_rate AS reported_delay_rate,
    ROUND(
        1.0 * SUM(CASE
            WHEN k.delay = 1 THEN 1
            ELSE 0
        END) / NULLIF(COUNT(k.delay), 0),
        4
    ) AS calculated_delay_rate,

    CASE
        WHEN g.total_shipments = COUNT(k.shipment_id)
         AND g.avg_total_time =
             ROUND(AVG(k.total_time), 2)
         AND g.delay_rate =
             ROUND(
                 1.0 * SUM(CASE
                     WHEN k.delay = 1 THEN 1
                     ELSE 0
                 END) / NULLIF(COUNT(k.delay), 0),
                 4
             )
        THEN 'PASS'
        ELSE 'FAIL'
    END AS check_result

FROM shipment_kpi_global AS g
CROSS JOIN shipment_kpi AS k
GROUP BY
    g.total_shipments,
    g.avg_total_time,
    g.delay_rate;


-- =========================================================
-- END OF QUALITY ASSURANCE SCRIPT
-- =========================================================
