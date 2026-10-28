# Project Charter: Retail Data Trust Layer
**Owner:** Divya Chalamalasetty · **Dates:** Oct 28 – Dec 1, 2026 · **Status:** Draft v0.1 (review and edit)

## Background
Retail leaders review sales dashboards every week to decide what to reorder, where to send stock and where to promote. When a number looks wrong (for example, a store's sales "drop 40%"), analysts spend hours working out whether the change is real or a data problem. Different teams also calculate the same metric differently. The result is lost time and lost trust in reporting.

## Problem statement
Decision-makers can't quickly tell whether a sudden change in a sales metric is a real business event or a data error, and metric definitions aren't consistent.

## Objectives
1. Publish **one documented definition** for each core sales metric (at least 5 metrics).
2. Build a **tested data mart** with at least 10 automated data-quality tests across three levels: structure, business rules and reconciliation.
3. Build **alert triage** that labels each sharp metric change as *data issue* or *real business change*.
4. **Prove it works** by injecting at least 6 realistic data faults and measuring the share caught and correctly labeled.
5. Deliver a **dashboard and a one-page recommendation memo** by Dec 1, 2026.

## Scope
**In scope:** M5 (Walmart) sales, price and calendar data; Snowflake; dbt models and tests; scheduled runs with failure alerts; fault injection; Tableau Public dashboard; project documentation.
**Out of scope (for now):** real-time streaming, real inventory data (the M5 data has none), production deployment, user access management.

## Users (fictional personas for design)
| Persona | Needs |
|---|---|
| Maya, inventory planner | Trustworthy daily sales by item and store; early warning of likely stockouts |
| Luis, store operations manager | Fast answer to "is this drop real?" |
| Priya, merchandising lead | Consistent sales definitions to measure holiday and event lift |
| Sam, BI/data engineer | Tests and alerts that catch broken loads before users see them |
| Leadership | A weekly view they can trust without double-checking |

## Deliverables and milestones
| Week | Milestone |
|---|---|
| 1 (Oct 28 – Nov 3) | Charter, user stories, raw data loaded and checked, repo live |
| 2 (Nov 4 – Nov 10) | Star-schema data mart, metric definitions, 10+ tests, alerting. **Apply to Nintendo.** |
| 3 (Nov 11 – Nov 17) | Alert triage + fault injection results; Tableau dashboard |
| 4 (Nov 18 – Nov 24) | AI question-answering assistant with an accuracy test (stretch) |
| 5 (Nov 25 – Dec 1) | Memo, README, demo video, retrospective, LinkedIn post |

## Success criteria
- All tests documented and automated; the pipeline runs on a schedule.
- Fault injection: share of faults caught and correctly labeled is measured and reported honestly.
- A stakeholder can answer "is this drop real?" from the dashboard in under 2 minutes.

## Assumptions and constraints
- M5 data has no inventory or returns; sales amount is estimated as units × weekly shelf price.
- Free or student tools only. Snowflake trial credits are limited to 30 days.
- About 8–10 hours per week alongside MSIS coursework.

## Key risks
See [RAID log](04_raid_log.md).
