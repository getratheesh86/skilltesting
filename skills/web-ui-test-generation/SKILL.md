---
name: web-ui-test-generation
description: 'Generate BDD and runnable web UI tests with resilient locators, traces, and reports. Use for web UI automation and multi-browser execution where infra is available.'
metadata:
  author: ai-testing-framework
  version: "2026.02.19"
---

# Web UI Test Generation

## Quick Reference
- **Trigger:** Web UI onboarding, UI changes, regression suite
- **Inputs:** UI context (flows/pages), base URL, auth, browser matrix
- **Outputs:** tests/web/bdd/, tests/web/, reports/web/, reports/web/artifacts/
- **Language:** Playwright (TypeScript) primary; Playwright (Java) supported
- **Pipeline stage:** Generate
- **Prerequisite:** Context pack for target; stable selectors or testid policy

## What this skill does
Generates BDD feature files and runnable web UI tests with required reporting artifacts using a resilient locator policy.

## When to use
- New web UI target onboarding
- Updating tests after UI changes
- Building regression suites with traces and screenshots
- BDD-driven acceptance testing for web flows

## Inputs
- UI context sources (flows, pages, stories)
- Base URL and auth strategy
- Browser matrix and runners

## Outputs
- BDD features: tests/web/bdd/
- Runnable tests: tests/web/
- Reports: reports/web/
- Traces and screenshots: reports/web/artifacts/

## Framework support
- **Playwright (TypeScript)** — primary, recommended for new projects
- **Playwright (Java)** — supported for Java-centric teams

Both language targets use Playwright for consistency in locator strategy, trace capture, and multi-browser execution. The orchestrator selects language based on project configuration.

## Steps
1) Ingest UI context and identify user flows and page structure.
2) Generate BDD feature files (Gherkin) with scenario outlines for each flow.
3) Generate runnable Playwright tests aligned to BDD scenarios using resilient locators (role/label/testid).
4) Configure evidence capture (traces, screenshots).
5) Emit BDD-to-test traceability mapping.
6) Record provenance of sources used.
7) Execute in CI if golden environment is available.

## BDD Integration

### Feature file structure
Feature files use Gherkin syntax and live in `tests/web/bdd/`:

```gherkin
Feature: User Login
  As a registered user
  I want to log into the application
  So that I can access my dashboard

  @smoke @gating
  Scenario: Successful login with valid credentials
    Given I am on the login page
    When I enter valid credentials
    And I click the login button
    Then I should see the dashboard

  @regression
  Scenario: Login fails with invalid password
    Given I am on the login page
    When I enter an invalid password
    And I click the login button
    Then I should see an error message "Invalid credentials"
```

### BDD-to-test traceability
Every generated test file must reference its BDD scenario:

- **TypeScript:** Tag each `test()` with the feature and scenario name
- **Java:** Use `@DisplayName` with the scenario title

### Tagging policy
| Tag | Meaning |
|-----|---------|
| `@smoke` | Minimum viable set — must pass for deploy |
| `@gating` | Blocks pipeline progression on failure |
| `@regression` | Full regression — non-blocking unless all fail |
| `@non-gating` | Known flaky or WIP — tracked but not blocking |

## Validation
- BDD feature file syntax validation
- Compile/typecheck
- BDD-to-test traceability check (every scenario has a matching test)
- Config validation
- Smoke execution

## Edge cases
- Missing stable selectors: request testid policy or document risk
- Safari not available: mark as dependency (requires macOS runners)
- BDD scenario without matching test: flag as gap in traceability report
