---
name: api-test-generation
description: 'Generate BDD and runnable API tests from specs with contract snapshots and drift detection. Use when onboarding APIs or regenerating tests after spec changes.'
metadata:
  author: ai-testing-framework
  version: "2026.02.19"
---

# API Test Generation

## Quick Reference
- **Trigger:** API onboarding, spec drift, regression expansion
- **Inputs:** OpenAPI/Swagger/GraphQL spec, auth strategy, env endpoints
- **Outputs:** tests/api/bdd/, tests/api/, tests/api/contracts/
- **Language:** Playwright (TypeScript) primary; Java (JUnit 5), Python supported
- **Pipeline stage:** Generate
- **Prerequisite:** Context pack for target

## What this skill does
Converts API specifications into BDD feature files and runnable tests, and produces contract snapshots and drift reports.

## When to use
- New API onboarding
- Spec changes or contract drift
- Regression suite expansion

## Inputs
- OpenAPI/Swagger/GraphQL specs
- Auth strategy and environment endpoints
- Test data setup/teardown approach

## Outputs
- BDD features: tests/api/bdd/
- Runnable tests: tests/api/
- Contract snapshots: tests/api/contracts/
- Drift reports: tests/api/reports/

## Steps
1) Ingest spec and normalize endpoints.
2) Generate BDD features with endpoint tags.
3) Generate runnable tests aligned to BDD.
4) Emit contract snapshot and drift report.
5) Record provenance for sources used.

## Language support
- **Playwright (TypeScript)** — primary, using `APIRequestContext` for API testing
- **Java** (JUnit 5) — supported; optionally with RestAssured for Java-centric teams
- **Python** (pytest + requests) — supported

Using Playwright for both API and web UI testing provides a consistent framework, shared config, and unified reporting. The orchestrator selects language based on project configuration.

## Playwright API testing pattern

Playwright's `APIRequestContext` enables API testing without a browser, using the same framework as web UI tests:

```typescript
import { test, expect } from '@playwright/test';

test.describe('Orders API', () => {
  test('POST /orders should return 201 for valid payload', async ({ request }) => {
    const response = await request.post('/api/v1/orders', {
      data: { customerId: 'cust-001', items: [{ sku: 'SKU-100', qty: 2 }] }
    });
    expect(response.ok()).toBeTruthy();
    expect(response.status()).toBe(201);
    const body = await response.json();
    expect(body.orderId).toBeTruthy();
  });
});
```

## Validation
- BDD metadata validation
- Compile and smoke execution
- Drift report generated

## Edge cases
- Spec missing or outdated: document source-of-truth gap
- Auth undefined: block execution and request owner input
