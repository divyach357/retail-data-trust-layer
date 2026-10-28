# Retail Data Trust Layer
**A governed retail sales data mart that catches data problems before leaders see them.**

> Status: 🚧 Week 1 of 5, in progress

## The problem
In most companies, the hardest part of BI isn't building dashboards. It's getting people to trust them. When sales at a store suddenly drop 40%, the first question is: *is that real, or is the data broken?* Analysts lose hours answering that, and leaders who see a wrong number go back to spreadsheets.

## What this project does
1. **One definition per metric:** documented, version-controlled definitions for net sales, units and average price ([docs/03_metric_definitions.md](docs/03_metric_definitions.md)).
2. **Automated data-quality tests** at three levels: structure, business rules, reconciliation.
3. **Alert triage:** when a metric moves sharply, check data health first, then label it *data issue* or *real business change*.
4. **Fault injection:** deliberately break the data (missing store, duplicate load, bad price, late file) and measure how many faults the system catches and labels correctly.

## Architecture (planned)
```
Kaggle M5 CSVs → Snowflake RAW → dbt STAGING → dbt MARTS (star schema)
                                     │
                         dbt tests + reconciliation
                                     │
                     alert triage → Tableau dashboard
```

## Data
[M5 Forecasting – Accuracy](https://www.kaggle.com/competitions/m5-forecasting-accuracy) (Walmart): daily unit sales for 3,049 items across 10 stores in California, Texas and Wisconsin, with weekly prices and a calendar of events. Raw data is not included in this repo; see [ingestion/README.md](ingestion/README.md) to download it.

## Project management
[Charter](docs/01_project_charter.md) · [User stories](docs/02_user_stories.md) · [RAID log](docs/04_raid_log.md) · [Weekly status](docs/status/)

## Results
_To be filled in with measured results._

## Tech
Snowflake · SQL · dbt Core · Python · GitHub Actions · Tableau Public

---
Built by Divya Chalamalasetty · MS Information Systems, University of Washington
