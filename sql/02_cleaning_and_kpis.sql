
-- =========================================================
-- DHL DELIVERY PERFORMANCE | SQL ANALYTICS CASE STUDY
-- 02_CLEANING_AND_KPIS.SQL
-- Author: Nagehan Bas
-- Database: SQLite 3
--
-- Purpose:
-- Clean shipment data, calculate delivery performance
-- metrics, and create operational KPI summary tables.
--
-- Prerequisite: Run 01_database_setup.sql first.
-- =========================================================


-- =========================================================
-- 1. PREPARE ANALYTICAL TABLES
-- =========================================================

-- Drop previous analytical tables to make the script
-- reproducible without modifying the source records.

DROP TABLE IF EXISTS shipment_kpi_month;
DROP TABLE IF EXISTS shipment_kpi_urgency;
DROP TABLE IF EXISTS shipment_kpi_carrier;
DROP TABLE IF EXISTS shipment_kpi_global;
DROP TABLE IF EXISTS shipment_kpi;


-- =========================================================
-- 2. DATA CLEANING AND KPI CALCULATIONS
-- =========================================================

-- Create a clean analytical table with delivery status,
-- elapsed time metrics, monthly periods, and delay flags.

CREATE TABLE shipment_kpi AS
SELECT
    shipment_id,
    tracking_url,
    carrier,
    urgency,
    order_date,
    dispatch_date,
    arrival_date,
    cancel_date,
    customer_name,
    customer_surname,

    -- Remove separators from tracking codes.
    REPLACE(
        REPLACE(tracking_code, '-', ''),
        ' ',
        ''
    ) AS tracking_code,

    -- Classify the operational status of each shipment.
    CASE
        WHEN cancel_date IS NOT NULL
            THEN 'Cancelled'
        WHEN dispatch_date IS NULL
            THEN 'In Progress'
        WHEN arrival_date IS NULL
            THEN 'In Transit'
        ELSE 'Delivered'
    END AS status,

    -- Time between order placement and dispatch.
    julianday(dispatch_date)
        - julianday(order_date) AS dispatch_time,

    -- Time between dispatch and delivery.
    julianday(arrival_date)
        - julianday(dispatch_date) AS transit_time,

    -- Total time between order and delivery.
    julianday(arrival_date)
        - julianday(order_date) AS total_time,

    -- Order month in YYYY-MM format.
    strftime('%Y-%m', order_date) AS month_order,

    -- Flag deliveries taking more than five days
    -- after dispatch. Missing arrivals remain NULL.
    CASE
        WHEN arrival_date IS NULL THEN NULL
        WHEN date(arrival_date) >
             date(dispatch_date, '+5 days')
            THEN 1
        ELSE 0
    END AS delay

FROM shipment;


-- Preserve one analytical record per shipment.

CREATE UNIQUE INDEX idx_shipment_kpi_id
ON shipment_kpi (shipment_id);


-- =========================================================
-- 3. DATA STANDARDIZATION EXAMPLES
-- =========================================================

-- Standardize carrier names for analysis.
-- Combine customer names for reporting.
-- Keep original fields unchanged in the source table.

SELECT
    shipment_id,
    LOWER(carrier) AS clean_carrier,
    customer_name || ' ' || customer_surname
        AS full_name,
    tracking_code
FROM shipment_kpi;


-- =========================================================
-- 4. GLOBAL DELIVERY PERFORMANCE KPIS
-- =========================================================

-- Calculate overall shipment volumes, delivery times,
-- and the delay rate among evaluable shipments.

CREATE TABLE shipment_kpi_global AS
SELECT
    COUNT(*) AS total_shipments,

    MIN(total_time) AS min_total_time,
    MAX(total_time) AS max_total_time,

    ROUND(AVG(dispatch_time), 2)
        AS avg_dispatch_time,

    ROUND(AVG(transit_time), 2)
        AS avg_transit_time,

    ROUND(AVG(total_time), 2)
        AS avg_total_time,

    ROUND(
        1.0 * SUM(
            CASE
                WHEN delay = 1 THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(delay), 0),
        4
    ) AS delay_rate

FROM shipment_kpi;


-- =========================================================
-- 5. CARRIER PERFORMANCE ANALYSIS
-- =========================================================

-- Compare delivery performance by logistics carrier.
--
-- The original exercise specifies HAVING COUNT(*) > 50.
-- This sample contains only 49 shipments in total,
-- so that filter would exclude every carrier.
-- All carrier groups are retained for meaningful analysis.

CREATE TABLE shipment_kpi_carrier AS
SELECT
    LOWER(carrier) AS carrier,

    COUNT(*) AS total_shipments,

    MIN(total_time) AS min_total_time,
    MAX(total_time) AS max_total_time,

    ROUND(AVG(dispatch_time), 2)
        AS avg_dispatch_time,

    ROUND(AVG(transit_time), 2)
        AS avg_transit_time,

    ROUND(AVG(total_time), 2)
        AS avg_total_time

FROM shipment_kpi

GROUP BY LOWER(carrier);


-- =========================================================
-- 6. URGENCY-BASED PERFORMANCE ANALYSIS
-- =========================================================

-- Compare shipment performance across urgency levels.

CREATE TABLE shipment_kpi_urgency AS
SELECT
    urgency,

    COUNT(*) AS total_shipments,

    MIN(total_time) AS min_total_time,
    MAX(total_time) AS max_total_time,

    ROUND(AVG(dispatch_time), 2)
        AS avg_dispatch_time,

    ROUND(AVG(transit_time), 2)
        AS avg_transit_time,

    ROUND(AVG(total_time), 2)
        AS avg_total_time,

    -- Dispatch time as a proportion of total time.
    ROUND(
        AVG(dispatch_time)
        / NULLIF(AVG(total_time), 0),
        2
    ) AS dispatch_to_total_ratio

FROM shipment_kpi

GROUP BY urgency;


-- =========================================================
-- 7. MONTHLY DELIVERY PERFORMANCE
-- =========================================================

-- Analyze shipment volumes and average delivery times
-- by order month.

CREATE TABLE shipment_kpi_month AS
SELECT
    month_order,

    COUNT(*) AS total_shipments,

    ROUND(AVG(dispatch_time), 2)
        AS avg_dispatch_time,

    ROUND(AVG(transit_time), 2)
        AS avg_transit_time,

    ROUND(AVG(total_time), 2)
        AS avg_total_time

FROM shipment_kpi

GROUP BY month_order;


-- =========================================================
-- 8. KPI REPORTING OUTPUTS
-- =========================================================

-- Operational status distribution.
SELECT
    status,
    COUNT(*) AS total_shipments
FROM shipment_kpi
GROUP BY status
ORDER BY total_shipments DESC;

-- Global KPI summary.
SELECT *
FROM shipment_kpi_global;

-- Carrier performance comparison.
SELECT *
FROM shipment_kpi_carrier
ORDER BY total_shipments DESC;

-- Urgency-level performance comparison.
SELECT *
FROM shipment_kpi_urgency
ORDER BY urgency;

-- Monthly performance trends.
SELECT *
FROM shipment_kpi_month
ORDER BY month_order;


-- =========================================================
-- END OF SCRIPT
-- =========================================================
