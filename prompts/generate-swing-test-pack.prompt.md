---
description: 'Generate Swing test harness and JUnit 5 tests bounded by component identity feasibility'
---

# Generate Swing Test Pack — JUnit 5 + Identity Layer

You are generating a Swing UI test pack bounded by identity feasibility for one target.

## Inputs to request (if not provided)

- Swing app build and run instructions
- Component identity approach (AccessibleName, component name, custom instrumentation)
- Target flows to automate (e.g., login, data entry, navigation)

## Required outputs

- `tests/swing/` — JUnit 5 test harness and test classes
- `tests/swing/identity/` — Separate identity layer abstracting component lookup
- `tests/swing/diagnostics/` — Screenshot-on-failure, component tree dump, timing data

### If identity is not feasible

- Feasibility report explaining why components cannot be reliably identified
- Prerequisites list for enabling identity (code changes, instrumentation)
- POC plan with estimated effort and success criteria

## Steps

1. Assess component identity feasibility — can target components be reliably found?
2. If feasible: generate JUnit 5 harness, identity layer, and test classes.
3. If not feasible: produce feasibility report, prerequisites, and POC plan.
4. Add diagnostics for all test runs: screenshots, component hierarchy, timing.
5. Record provenance for all generated artifacts.

## Validation checklist

- Harness compiles and launches the Swing application under test
- Identity layer is separated from test logic for maintainability
- No secrets or credentials in test files
- Diagnostic artifacts are produced on every test failure
