---
description: 'Generate BDD features and Playwright web UI tests for one target with resilient locators and evidence on failure'
---

# Generate Web Test Pack — Playwright

You are generating a complete, reviewable web UI test pack for one target including BDD feature files and runnable tests.

## Inputs to request (if not provided)

- Target URLs (base URL, key pages)
- Auth approach (login flow, token injection, cookie-based)
- Named user flows to cover (e.g., login, search, checkout, settings)
- Language preference (TypeScript or Java; defaults to TypeScript)

## Required outputs

- `tests/web/bdd/` — Gherkin feature files for each user flow
- `tests/web/` — Playwright test files (TypeScript or Java) with resilient locators
- Externalized config (base URL, credentials via env vars, timeouts)
- Evidence collection on failure (screenshots, traces, console logs)
- BDD-to-test traceability (every scenario maps to a test)

## Steps

1. Analyze target URLs and user flows to determine test structure.
2. Generate BDD feature files (Gherkin) with scenarios for each user flow.
3. Generate test files aligned to BDD scenarios using resilient locator strategy:
   - Prefer `getByRole` > `getByLabel` > `getByTestId` > CSS as last resort
4. Externalize all configuration — no hardcoded URLs, credentials, or environment-specific values.
5. Configure evidence collection: screenshots and traces on failure, console log capture.
6. Tag tests as gating or non-gating based on reliability assessment.
7. Emit BDD-to-test traceability mapping.

## Validation checklist

- No hard waits (`page.waitForTimeout` / `Thread.sleep`) unless justified with a comment
- Tests pass reliably or are tagged as non-gating with an explanation
- All locators follow the resilient locator policy
- No credentials or secrets in test files
- Evidence artifacts are generated on failure
- Every BDD scenario has a matching runnable test
