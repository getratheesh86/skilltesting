---
name: swing-ui-test-generation
description: 'Generate Swing UI JUnit tests with a deterministic component identity strategy and diagnostics. Use for Swing automation once identity and GUI runner prerequisites exist.'
metadata:
  author: ai-testing-framework
  version: "2026.02.18"
---

# Swing UI Test Generation

## Quick Reference
- **Trigger:** Swing UI automation onboarding
- **Inputs:** Swing context, identity strategy, GUI runner details
- **Outputs:** tests/swing/, tests/swing/IDENTITY.md
- **Language:** Java (JUnit 5)
- **Pipeline stage:** Generate
- **Prerequisite:** Component identity strategy MUST exist

## What this skill does
Creates JUnit 5 Swing tests and harness scaffolding with diagnostics, contingent on a stable component identity strategy.

## When to use
- Swing UI automation onboarding
- Expanding Swing regression coverage
- After identity/instrumentation strategy is confirmed

## Inputs
- Swing UI context (screens, flows, existing tests)
- Identity/instrumentation strategy
- GUI runner details

## Outputs
- Tests: tests/swing/
- Identity policy: tests/swing/IDENTITY.md
- Diagnostics outputs location documented

## Steps
1) Verify identity strategy prerequisites.
2) Generate tests and harness scaffolding.
3) Add diagnostics hooks where feasible.
4) Record provenance of sources used.

## Validation
- Compile and smoke execution on GUI runner
- Identity policy present

## Edge cases
- Identity missing: stop and document prerequisite
- GUI runners unavailable: document dependency
