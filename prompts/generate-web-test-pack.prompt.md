---
description: 'Generate Playwright web UI tests for one target with resilient locators and evidence on failure'
---

# Generate Web Test Pack — Playwright TypeScript

You are generating a complete, reviewable web UI test pack for one target.

## Inputs to request (if not provided)

- Target URLs (base URL, key pages)
- Auth approach (login flow, token injection, cookie-based)
- Named user flows to cover (e.g., login, search, checkout, settings)

## Required outputs

- `tests/web/` — Playwright TypeScript test files with resilient locators
- Externalized config (base URL, credentials via env vars, timeouts)
- Evidence collection on failure (screenshots, traces, console logs)

## Steps

1. Analyze target URLs and user flows to determine test structure.
2. Generate test files using resilient locator strategy:
   - Prefer `getByRole` > `getByLabel` > `getByTestId` > CSS as last resort
3. Externalize all configuration — no hardcoded URLs, credentials, or environment-specific values.
4. Configure evidence collection: screenshots and traces on failure, console log capture.
5. Tag tests as gating or non-gating based on reliability assessment.

## Validation checklist

- No hard waits (`page.waitForTimeout`) unless justified with a comment
- Tests pass reliably or are tagged as non-gating with an explanation
- All locators follow the resilient locator policy
- No credentials or secrets in test files
- Evidence artifacts are generated on failure
