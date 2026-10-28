# User Stories
_Format: As a [user], I want [capability] so that [benefit]. Acceptance criteria are written as Given / When / Then so each one can become a test._

### US-01: One definition of sales
**As** Priya (merchandising), **I want** every report to use the same definition of net sales **so that** teams stop arguing about whose number is right.
- **Given** the metric definitions document, **when** I look up "sales amount", **then** I see its formula, grain, data source, exclusions and owner.
- **Given** any dashboard tile showing sales amount, **when** I trace it, **then** it comes from the single mart model that implements that definition.

### US-02: Complete daily data
**As** Luis (store ops), **I want** to know every store reported for every day **so that** a missing day never looks like a sales drop.
- **Given** a load, **when** any store has no rows for a day in the period, **then** a test fails and names the store and date.

### US-03: No duplicate loads
**As** Sam (data engineer), **I want** duplicate loads caught **so that** sales are never double-counted.
- **Given** a fact table, **when** two rows share the same item, store and day, **then** the uniqueness test fails.

### US-04: Valid values
**As** Maya (planner), **I want** impossible values blocked **so that** I don't plan on bad numbers.
- **Given** a load, **when** units are negative or prices are zero, negative or outside the expected range, **then** a business-rule test fails with the count of bad rows.

### US-05: Totals reconcile
**As** leadership, **I want** mart totals to match the source **so that** nothing is lost or added between raw data and reports.
- **Given** a completed run, **when** total units in the mart differ from raw by more than 0, **then** the reconciliation test fails.

### US-06: Is this change real?
**As** Luis (store ops), **I want** each sharp change in a sales metric labeled **so that** I know whether to act.
- **Given** a store's daily sales change by more than the agreed threshold, **when** any data test failed for that store and date, **then** the alert says "Data issue: don't act on this number" with the failed test named.
- **Given** the same change, **when** all tests passed, **then** the alert says "Real change", with any calendar event on that date.

### US-07: Get told when the pipeline breaks
**As** Sam (data engineer), **I want** an alert when a scheduled run or test fails **so that** I fix it before users see it.
- **Given** the scheduled run, **when** any test fails, **then** a notification is sent within the run with the failing test names.

### US-08: Trace any number to its source
**As** Sam (data engineer), **I want** every row to carry its source file and load time **so that** I can trace any number back to where it came from.
- **Given** any row in the raw layer, **when** I query it, **then** I see `source_file` and `loaded_at`.
