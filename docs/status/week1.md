# Status Report: Week 1 (Oct 28 – Nov 3, 2026)
**Overall status:** 🟢 On track / 🟡 At risk / 🔴 Off track  _(pick one)_

## Done this week
- [ ] Kaggle account; M5 rules accepted; data downloaded
- [ ] Snowflake account ready (UW course account or free trial; note which)
- [ ] Warehouse, database, stage and raw tables created
- [ ] Raw data loaded with source-file lineage
- [ ] Sales reshaped to one row per item-store-day
- [ ] Load checks T1–T10 run and recorded below
- [ ] GitHub repo created and first commit pushed
- [ ] Charter and user stories reviewed

## Load test log
| Test | What it checks | Expected | Actual | Pass? |
|---|---|---|---|---|
| T1 | Raw series count | 30,490 | | |
| T2 | Stores / items / states / categories / departments | 10 / 3,049 / 3 / 3 / 7 | | |
| T3 | Daily rows | 59,181,090 | | |
| T4 | Days per series | all 1,941 | | |
| T5 | Negative / null units | 0 / 0 | | |
| T6 | Sales days missing from calendar | 0 | | |
| T7 | Date range | 2011-01-29 to 2016-05-22 | | |
| T8 | Calendar rows / price rows | record | | |
| T9 | Zero or negative prices | 0 | | |

## First observation (T10)
_One sentence: which state and category sell the most units?_

## Risks / issues raised
-

## Next week
Data mart (star schema) in dbt, metric definitions, 10+ data-quality tests, alerting. Apply to Nintendo.
