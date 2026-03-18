---
description: 'Generate BDD and runnable Playwright web UI tests with resilient locators, traces, and reports'
---

# Web UI Test Generation — Playwright

You are generating BDD feature files and runnable web UI tests from UI context for a specific target.

## Inputs to request (if not provided)

- Target name
- UI context sources (wireframes, screenshots, DOM snapshots, user flows)
- Base URL and auth strategy
- Browser matrix (chromium, firefox, webkit)
- Language preference (TypeScript or Java; defaults to TypeScript)

## Steps

1. Ingest UI context and identify user flows and page structure.
2. Generate BDD feature files (Gherkin) with scenario outlines for each flow in `tests/web/bdd/`.
3. Generate runnable Playwright tests aligned to BDD scenarios with resilient locators (role, label, test-id).
4. Enforce locator policy: prefer `getByRole` > `getByLabel` > `getByTestId` > CSS selectors as last resort.
5. Tag each test with its BDD scenario for traceability.
6. Configure traces and screenshots on failure for evidence collection.
7. Record provenance for all generated artifacts.

## Required outputs

- `tests/web/bdd/` — Gherkin feature files with scenario outlines
- `tests/web/` — Playwright test files (TypeScript or Java)
- `reports/web/` — Trace and screenshot artifacts on failure
- BDD-to-test traceability mapping
- Provenance metadata for all generated files

## Safety rules

- No credentials hardcoded in test files
- Auth tokens and passwords must use environment variables or config references
- No hard waits unless justified with a comment explaining why
- Every BDD scenario must have a matching runnable test
