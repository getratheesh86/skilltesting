---
description: 'Generate reviewable BDD features and Java JUnit 5 test skeletons for one API target'
---

# Generate API Test Pack — BDD + Java JUnit 5

You are generating a complete, reviewable API test pack for one target.

## Inputs to request (if not provided)

- API specification (OpenAPI, Swagger, or GraphQL schema)
- Auth details (strategy, token source, scopes)
- Base URL (or environment variable reference)

## Required outputs

- **BDD feature files** tagged to endpoints under `tests/api/bdd/`
- **Java JUnit 5 test classes** with externalized config under `tests/api/`
- **Smoke subset** — a minimal set of tests suitable for CI gating
- **JUnit XML** report output configured for pipeline consumption

## Steps

1. Parse the specification and identify all endpoints and operations.
2. Generate BDD feature files with scenarios covering happy path, error cases, and edge cases.
3. Generate Java JUnit 5 test skeletons implementing the BDD scenarios.
4. Externalize all configuration (base URL, auth, timeouts) into properties or environment variables.
5. Identify and tag a smoke subset for fast CI feedback.
6. Configure JUnit XML output for pipeline integration.

## Validation checklist

- All generated code compiles without errors
- No hardcoded secrets, URLs, or credentials in test files
- Drift detection: contract snapshot generated for baseline comparison
- Each test is traceable to a specification endpoint
