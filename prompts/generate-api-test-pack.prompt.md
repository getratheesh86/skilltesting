---
description: 'Generate reviewable BDD features and runnable API test skeletons for one target using Playwright or Java JUnit 5'
---

# Generate API Test Pack — BDD + Runnable Tests

You are generating a complete, reviewable API test pack for one target.

## Inputs to request (if not provided)

- API specification (OpenAPI, Swagger, or GraphQL schema)
- Auth details (strategy, token source, scopes)
- Base URL (or environment variable reference)
- Language preference (TypeScript with Playwright or Java with JUnit 5; defaults to Playwright TypeScript)

## Required outputs

- **BDD feature files** tagged to endpoints under `tests/api/bdd/`
- **Runnable test files** with externalized config under `tests/api/`
  - **Playwright TypeScript (default):** Use `APIRequestContext` from `@playwright/test`
  - **Java:** Use JUnit 5, optionally with RestAssured
- **Smoke subset** — a minimal set of tests suitable for CI gating
- **Test report** output configured for pipeline consumption

## Steps

1. Parse the specification and identify all endpoints and operations.
2. Generate BDD feature files with scenarios covering happy path, error cases, and edge cases.
3. Generate runnable test skeletons implementing the BDD scenarios.
4. Externalize all configuration (base URL, auth, timeouts) into properties or environment variables.
5. Identify and tag a smoke subset for fast CI feedback.
6. Configure report output for pipeline integration.

## Validation checklist

- All generated code compiles without errors
- No hardcoded secrets, URLs, or credentials in test files
- Drift detection: contract snapshot generated for baseline comparison
- Each test is traceable to a specification endpoint
