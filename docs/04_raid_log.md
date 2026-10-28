# RAID Log (Risks, Assumptions, Issues, Decisions)
_Updated weekly. Last update: 2026-10-27._

## Risks
| ID | Risk | Likelihood | Impact | Mitigation | Owner | Status |
|---|---|---|---|---|---|---|
| R1 | Snowflake trial expires (30 days) before interviews | High | High | Use UW course account if available; keep all SQL/dbt in GitHub; DuckDB fallback for demos | Divya | Open |
| R2 | Coursework load reduces weekly hours | Medium | Medium | Fixed 2-hour sessions; cut stretch scope (AI assistant) first | Divya | Open |
| R3 | 59M-row table uses too many credits | Low | Medium | XSMALL warehouse, 60-second auto-suspend; suspend after each session | Divya | Open |
| R4 | Raw Kaggle data accidentally pushed to GitHub | Low | Medium | `data/` and `*.csv` in .gitignore; check `git status` before every push | Divya | Open |
| R5 | Nintendo roles fill before Dec 1 | Medium | High | Apply at end of week 2 with work in progress | Divya | Open |

## Assumptions
| ID | Assumption |
|---|---|
| A1 | Sales amount = units × weekly shelf price (no discounts or returns in M5) |
| A2 | Long zero-sales runs for normally selling items are a stockout *signal*, not proof |
| A3 | Personas are fictional and used only for design |

## Issues
| ID | Issue | Raised | Resolution | Status |
|---|---|---|---|---|
| | _none yet_ | | | |

## Decisions
| ID | Decision | Date | Reason |
|---|---|---|---|
| D1 | Focus the project on data trust, not forecasting | 2026-10-27 | Companies already forecast; trust and analyst time are the real bottleneck |
| D2 | Load the wide sales file as raw lines and reshape with SPLIT + FLATTEN | 2026-10-27 | Avoids a 1,947-column raw table; simple and explainable |
| D3 | Record source file and load time on every raw row | 2026-10-27 | Lineage supports trust and debugging |
