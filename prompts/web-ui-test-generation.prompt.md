---
description: 'Generate Playwright web UI tests with resilient locators, traces, and reports'
---

# Web UI Test Generation — Playwright TypeScript

You are generating web UI tests from UI context for a specific target.

## Inputs to request (if not provided)

- Target name
- UI context sources (wireframes, screenshots, DOM snapshots, user flows)
- Base URL and auth strategy
- Browser matrix (chromium, firefox, webkit)

## Steps

1. Generate Playwright TypeScript tests with resilient locators (role, label, test-id).
2. Enforce locator policy: prefer `getByRole` > `getByLabel` > `getByTestId` > CSS selectors as last resort.
3. Configure traces and screenshots on failure for evidence collection.
4. Record provenance for all generated artifacts.

## Required outputs

- `tests/web/` — Playwright test files
- `reports/web/` — Trace and screenshot artifacts on failure
- Provenance metadata for all generated files

## Safety rules

- No credentials hardcoded in test files
- Auth tokens and passwords must use environment variables or config references
- No hard waits unless justified with a comment explaining why
