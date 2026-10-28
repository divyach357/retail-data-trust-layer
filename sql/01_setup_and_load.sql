/* =====================================================================
   Retail Data Trust Layer: Week 1 setup and raw load (Snowflake)
   Run this in a Snowsight SQL worksheet, ONE PART AT A TIME.
   Put your cursor in a statement and press Cmd+Enter (Mac) to run it,
   or select a whole part and press Cmd+Enter to run the selection.
   ===================================================================== */

/* ---------- PART A: create the warehouse, database, schema, stage, file formats ---------- */
USE ROLE SYSADMIN;   -- if this errors on a trial account, use: USE ROLE ACCOUNTADMIN;

CREATE WAREHOUSE IF NOT EXISTS RDT_WH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60          -- stops after 60 seconds idle, so it doesn't burn credits
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

USE WAREHOUSE RDT_WH;

CREATE DATABASE IF NOT EXISTS RETAIL_TRUST;
CREATE SCHEMA  IF NOT EXISTS RETAIL_TRUST.RAW;   -- raw data, loaded as-is
USE SCHEMA RETAIL_TRUST.RAW;

-- An internal stage = a folder inside Snowflake where you upload files
CREATE STAGE IF NOT EXISTS M5_STAGE;

-- Normal CSV with a header row
CREATE OR REPLACE FILE FORMAT CSV_STD
  TYPE = CSV
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  NULL_IF = ('');

-- Whole line as one value (used for the very wide sales file: 1,941 day columns)
CREATE OR REPLACE FILE FORMAT CSV_LINES
  TYPE = CSV
  FIELD_DELIMITER = NONE
  SKIP_HEADER = 1;

-- Raw tables. Every raw table records which file each row came from and when it was loaded.
-- This "lineage" is part of the trust story: you can always trace a number back to its source file.
CREATE OR REPLACE TABLE CALENDAR (
  date DATE, wm_yr_wk INT, weekday VARCHAR, wday INT, month INT, year INT, d VARCHAR,
  event_name_1 VARCHAR, event_type_1 VARCHAR, event_name_2 VARCHAR, event_type_2 VARCHAR,
  snap_ca INT, snap_tx INT, snap_wi INT,
  source_file VARCHAR, loaded_at TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE SELL_PRICES (
  store_id VARCHAR, item_id VARCHAR, wm_yr_wk INT, sell_price NUMBER(10,2),
  source_file VARCHAR, loaded_at TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE SALES_LINES (
  line VARCHAR, source_file VARCHAR, loaded_at TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

/* >>> STOP HERE. Upload the 3 CSV files to the stage (see the guide, step 5), then continue. <<< */

/* ---------- PART B: confirm the upload, then load the files ---------- */
LIST @M5_STAGE;   -- you should see calendar.csv, sell_prices.csv, sales_train_evaluation.csv

COPY INTO CALENDAR (date, wm_yr_wk, weekday, wday, month, year, d, event_name_1, event_type_1,
                     event_name_2, event_type_2, snap_ca, snap_tx, snap_wi, source_file)
FROM (SELECT $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14, METADATA$FILENAME
      FROM @M5_STAGE/calendar.csv)
FILE_FORMAT = (FORMAT_NAME = CSV_STD);

COPY INTO SELL_PRICES (store_id, item_id, wm_yr_wk, sell_price, source_file)
FROM (SELECT $1,$2,$3,$4, METADATA$FILENAME
      FROM @M5_STAGE/sell_prices.csv)
FILE_FORMAT = (FORMAT_NAME = CSV_STD);

COPY INTO SALES_LINES (line, source_file)
FROM (SELECT $1, METADATA$FILENAME
      FROM @M5_STAGE/sales_train_evaluation.csv)
FILE_FORMAT = (FORMAT_NAME = CSV_LINES);
-- Each COPY result should show status = LOADED and errors_seen = 0.
-- loaded_at fills in automatically (DEFAULT CURRENT_TIMESTAMP()).
-- Note: Snowsight may compress uploads to .csv.gz; the paths above still match, and COPY decompresses automatically.

/* ---------- PART C: reshape sales from "wide" (one column per day) to "long" (one row per item-store-day) ---------- */
-- The file has 6 ID columns then d_1 ... d_1941. SPLIT turns each line into an array;
-- FLATTEN turns the array into rows. Array positions 0-5 are IDs, position 6 is day d_1, and so on.
-- This creates about 59 million rows. On an XSMALL warehouse expect a few minutes.
CREATE OR REPLACE TABLE SALES_DAILY AS
SELECT
  SPLIT_PART(s.line, ',', 1)  AS id,
  SPLIT_PART(s.line, ',', 2)  AS item_id,
  SPLIT_PART(s.line, ',', 3)  AS dept_id,
  SPLIT_PART(s.line, ',', 4)  AS cat_id,
  SPLIT_PART(s.line, ',', 5)  AS store_id,
  SPLIT_PART(s.line, ',', 6)  AS state_id,
  'd_' || (f.index - 5)       AS d,
  TRY_TO_NUMBER(TRIM(f.value::STRING, ' \r\n'))::INT AS units_sold,   -- TRY_: a bad value becomes NULL (caught by T5) instead of crashing
  s.source_file,
  s.loaded_at
FROM SALES_LINES s,
     LATERAL FLATTEN(input => SPLIT(s.line, ',')) f
WHERE f.index >= 6;

/* ---------- PART D: load checks (your first test log) ----------
   Run each query and write the ACTUAL result in docs/status/week1.md.
   "Expected" values are what the M5 dataset should contain. If an actual
   result differs, that is a finding: note it, don't hide it. */

-- T1: one raw line per item-store series. Expected 30,490
SELECT COUNT(*) AS series FROM SALES_LINES;

-- T2: stores, items, states, categories, departments. Expected 10, 3,049, 3, 3, 7
SELECT COUNT(DISTINCT store_id) stores, COUNT(DISTINCT item_id) items,
       COUNT(DISTINCT state_id) states, COUNT(DISTINCT cat_id) categories,
       COUNT(DISTINCT dept_id) departments
FROM SALES_DAILY;

-- T3: total rows = series x days. Expected 30,490 x 1,941 = 59,181,090
SELECT COUNT(*) AS daily_rows FROM SALES_DAILY;

-- T4: every series has the same number of days. Expected one row: days = 1941, series = 30490
SELECT days, COUNT(*) AS series
FROM (SELECT id, COUNT(*) AS days FROM SALES_DAILY GROUP BY id) per_series
GROUP BY days;

-- T5: no negative or missing units. Expected 0 and 0
SELECT SUM(IFF(units_sold < 0, 1, 0)) AS negative_units,
       SUM(IFF(units_sold IS NULL, 1, 0)) AS null_units
FROM SALES_DAILY;

-- T6: every sales day exists in the calendar. Expected 0
SELECT COUNT(DISTINCT s.d) AS days_missing_from_calendar
FROM SALES_DAILY s LEFT JOIN CALENDAR c ON s.d = c.d
WHERE c.d IS NULL;

-- T7: date range of the sales data. Expected 2011-01-29 to 2016-05-22
SELECT MIN(c.date) AS first_day, MAX(c.date) AS last_day
FROM (SELECT DISTINCT d FROM SALES_DAILY) s JOIN CALENDAR c ON s.d = c.d;

-- T8: calendar and prices row counts (record them; prices should be roughly 6.8 million)
SELECT (SELECT COUNT(*) FROM CALENDAR) AS calendar_rows,
       (SELECT COUNT(*) FROM SELL_PRICES) AS price_rows;

-- T9: no zero or negative prices. Expected 0
SELECT COUNT(*) AS bad_prices FROM SELL_PRICES WHERE sell_price <= 0 OR sell_price IS NULL;

-- T10: a first look at the business. Units sold by state and category
SELECT state_id, cat_id, SUM(units_sold) AS units
FROM SALES_DAILY GROUP BY 1, 2 ORDER BY 1, 2;

-- When you finish, suspend the warehouse to save credits:
ALTER WAREHOUSE RDT_WH SUSPEND;
