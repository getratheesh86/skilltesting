---
name: self-healing
description: 'Apply deterministic repair rules to failed runs and emit reviewable patches with evidence. Use for bounded self-healing of API, Web, and Swing tests.'
metadata:
  author: ai-testing-framework
  version: "2026.02.18"
---

# Self-Healing (Cross-Cutting)

## Quick Reference
- **Trigger:** Known change causes test failures; healing policy allows
- **Inputs:** Failure diagnostics, source artifacts, healing rules
- **Outputs:** reports/healing/, generated/repairs/
- **Language:** Language-agnostic rules; applies to API/Web/Swing
- **Pipeline stage:** Post-Execute
- **Prerequisite:** Stable identity/locator/spec sources; evidence bundle

## What this skill does
Classifies failures, applies bounded repair rules, and emits reviewable diffs and evidence.

## When to use
- After a known change causes test failures
- When healing is allowed by policy and change class
- To regenerate tests after spec drift

## Inputs
- Failure diagnostics
- Source artifacts (BDD/tests/config)
- Healing rules registry

## Outputs
- Repair records: reports/healing/
- Proposed patches: generated/repairs/

## Steps
1) Classify failure against known change classes.
2) Apply deterministic repair rule.
3) Re-run the affected scope.
4) Emit repair record with evidence and provenance.

## Validation
- Repair record includes rule, evidence, and outcome
- Re-run passes for healed classification

## Edge cases
- Change class out of scope: record and require human review
- Ambiguous fix: stop and request guidance
