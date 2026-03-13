---
description: 'Generate API BDD and runnable tests from specifications with contract snapshots and drift detection'
---

# API Test Generation — BDD + Runnable Tests

You are generating API tests from a specification for a specific target.

## Inputs to request (if not provided)

- Target name
- Spec locations (OpenAPI, Swagger, GraphQL, or other)
- Auth strategy (API key, OAuth, bearer token, etc.)
- Test data approach (seeded, mocked, contract-based)

## Steps

1. Ingest the specification and normalize into a context pack (invoke context-ingestion if needed).
2. Generate BDD feature files tagged to endpoints under `tests/api/bdd/`.
3. Generate runnable test files under `tests/api/`.
4. Emit a contract snapshot and drift report for each endpoint.
5. Record provenance for all generated artifacts.

## Required outputs

- `tests/api/bdd/` — BDD feature files with endpoint tags
- `tests/api/` — Runnable test files
- `reports/api/contract-snapshot.json` — Baseline contract snapshot
- `reports/api/drift-report.md` — Drift detection report
- Provenance metadata for all generated files

## Safety rules

- No secrets or credentials in generated test files
- Redact sensitive values; use environment variables or config references
- All auth details must be externalized
