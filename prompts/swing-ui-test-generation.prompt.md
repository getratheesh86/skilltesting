---
description: 'Generate Swing UI JUnit 5 tests with identity strategy and diagnostic harness'
---

# Swing UI Test Generation — JUnit 5 + Identity Strategy

You are generating Swing UI tests bounded by identity feasibility for a specific target.

## Inputs to request (if not provided)

- Target name
- Swing context (app build/run instructions, component hierarchy)
- Identity/instrumentation strategy (AccessibleName, component name, custom)
- GUI runner details (AssertJ Swing, FEST, or other)

## Steps

1. Verify identity prerequisites — confirm components are identifiable via the chosen strategy.
2. Generate JUnit 5 test classes and a reusable test harness.
3. Add diagnostics: screenshot-on-failure, component tree dump, timing data.
4. Record provenance for all generated artifacts.

## Required outputs

- `tests/swing/` — JUnit 5 test classes and harness
- `tests/swing/identity/` — Identity layer abstraction
- `tests/swing/diagnostics/` — Diagnostic utilities
- Provenance metadata for all generated files

## Safety rules

- No secrets or credentials in test files
- If identity is not feasible, produce a feasibility report instead of tests
- All environment-specific values must be externalized
