# Metric Definitions (draft v0.1)
_One definition per metric. Each one will be implemented once in the data mart and reused everywhere. Grain = the level each row represents._

| Metric | Definition | Formula | Grain | Exclusions / notes | Owner |
|---|---|---|---|---|---|
| **Units sold** | Number of units sold | `SUM(units_sold)` | item × store × day | None; source has no returns | Merchandising |
| **Sales amount (estimated)** | Revenue estimate | `SUM(units_sold × sell_price)`; price matched on store, item and week (`wm_yr_wk`) | item × store × day | Estimate: shelf price only, no discounts or returns. If units > 0 and no price exists, flag as data issue | Finance / BI |
| **Average selling price** | Average price per unit sold | `sales_amount / units_sold` (null when units = 0) | any level | Weighted by units, not a simple average of prices | Pricing |
| **Active items** | Items with at least one sale | `COUNT(DISTINCT item_id) WHERE units_sold > 0` | store × period | | Merchandising |
| **Store reporting completeness** | Share of expected store-days present | `days with rows ÷ days in period` | store × period | Expected = 100%; anything less is a data issue, not a sales drop | BI / data engineering |
| **Week-over-week change %** | Change versus the prior week | `(this week − last week) ÷ last week` | store or category × week | Used by alert triage | BI |
| **Zero-sales streak** (stockout signal) | Consecutive zero-sales days for an item that normally sells | defined in week 3 (threshold on trailing average) | item × store × day | A signal, not proof; M5 has no inventory data | Inventory planning |

**Open questions to decide in week 2:** the alert threshold for week-over-week change; the minimum trailing average for the zero-sales streak.
