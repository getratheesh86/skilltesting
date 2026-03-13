---
name: web-ui-test-generation
description: 'Generate web UI tests with resilient locators, traces, and reports. Use for web UI automation and multi-browser execution where infra is available.'
metadata:
  author: ai-testing-framework
  version: "2026.02.18"
---

# Web UI Test Generation

## Quick Reference
- **Trigger:** Web UI onboarding, UI changes, regression suite
- **Inputs:** UI context (flows/pages), base URL, auth, browser matrix
- **Outputs:** tests/web/, reports/web/, reports/web/artifacts/
- **Language:** Playwright (TypeScript) primary; Selenium (Java) supported
- **Pipeline stage:** Generate
- **Prerequisite:** Context pack for target; stable selectors or testid policy

## What this skill does
Generates web UI tests and required reporting artifacts using a resilient locator policy.

## When to use
- New web UI target onboarding
- Updating tests after UI changes
- Building regression suites with traces and screenshots

## Inputs
- UI context sources (flows, pages, stories)
- Base URL and auth strategy
- Browser matrix and runners

## Outputs
- Tests: tests/web/
- Reports: reports/web/
- Traces and screenshots: reports/web/artifacts/

## Framework support
- **Playwright (TypeScript)** — primary, recommended for new projects
- **Selenium (Java)** — supported for Java-centric teams

The orchestrator selects framework based on project configuration.

## Steps
1) Generate tests using resilient locators (role/label/testid for Playwright; id/name/css for Selenium).
2) Configure evidence capture (traces, screenshots).
3) Record provenance of sources used.
4) Execute in CI if golden environment is available.

## Validation
- Compile/typecheck
- Config validation
- Smoke execution

## Edge cases
- Missing stable selectors: request testid policy or document risk
- Safari not available: mark as dependency (requires macOS runners)
