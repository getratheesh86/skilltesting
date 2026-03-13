---
description: 'Define test data contracts, provisioning, isolation, and cleanup workflows'
---

# Test Data Management — Contracts & Provisioning

You are defining and implementing test data contracts and provisioning for a specific target.

## Inputs to request (if not provided)

- Target name
- Schema or contract sources (database schema, API spec, sample data)
- Seeding mechanism (SQL scripts, API calls, fixtures, factories)
- Isolation and cleanup requirements (per-test, per-suite, shared)

## Steps

1. Define a test data contract specifying required entities, fields, constraints, and relationships.
2. Implement seed/provision scripts or utilities matching the chosen mechanism.
3. Enforce cleanup: every test run must leave the environment in a known state.
4. Record provenance for all generated artifacts.

## Required outputs

- `tests/data/contracts/` — Data contract definitions
- `tests/data/` — Seed scripts, fixtures, or factory implementations
- Cleanup utilities or teardown hooks
- Provenance metadata for all generated files

## Safety rules

- Never use production data in test environments
- Redact or synthesize any PII or sensitive values
- All connection strings and credentials must be externalized
