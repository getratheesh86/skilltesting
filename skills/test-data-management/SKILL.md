---
name: test-data-management
description: 'Define test data contracts, provisioning, isolation, and cleanup workflows. Use when enabling reliable API, Web, or Swing test execution.'
metadata:
  author: ai-testing-framework
  version: "2026.02.18"
---

# Test Data Management

## Quick Reference
- **Trigger:** Deterministic data setup needed; data-related test failures
- **Inputs:** Domain schema, seeding mechanism, isolation/cleanup requirements
- **Outputs:** tests/data/contracts/, tests/data/
- **Language:** Language-agnostic contracts
- **Pipeline stage:** Generate (supports Execute)
- **Prerequisite:** Auth + permissions for data seeding

## What this skill does
Defines and implements data provisioning workflows with isolation, cleanup, and reproducibility.

## When to use
- Any target needing deterministic data setup
- When execution fails due to data state
- Before enabling CI regression

## Inputs
- Domain schema or API contracts
- Seeding mechanism (API or DB)
- Isolation and cleanup requirements

## Outputs
- Data contracts: tests/data/contracts/
- Seed/teardown scripts: tests/data/
- Cleanup reports: reports/data/

## Steps
1) Define data contract (setup/exercise/teardown).
2) Implement seed and teardown modules.
3) Enforce cleanup and reproducibility seed logging.
4) Record provenance of sources used.

## Validation
- Contract schema validation
- Teardown idempotency checks

## Edge cases
- Missing auth: block execution and document dependency
- Production data risk: redact and require approval
