---
name: ado-pipelines-governance
description: 'Define Azure DevOps pipeline templates with generate-validate-execute-publish-gate stages and governance artifact checks. Use when wiring CI/CD and Quality Passport gates.'
metadata:
  author: ai-testing-framework
  version: "2026.02.18"
---

# ADO Pipelines & Governance Gate

## Quick Reference
- **Trigger:** Pipeline setup; adding governance gates; artifact publishing
- **Inputs:** Pipeline naming, stage/gate criteria, QP integration details
- **Outputs:** pipelines/ado/
- **Language:** Azure DevOps YAML
- **Pipeline stage:** All (defines pipeline structure)
- **Prerequisite:** ADO project access; Quality Passport details

## What this skill does
Creates or updates Azure DevOps pipeline templates to run the standard stages and enforce governance checks on evidence bundles.

## When to use
- Initial pipeline setup
- Adding validation or evidence gates
- Updating artifact publishing conventions

## Inputs
- Pipeline naming conventions
- Required stages and gate criteria
- Quality Passport integration details

## Outputs
- Pipeline templates: pipelines/ado/
- Gate documentation and artifact requirements

## Steps
1) Implement stages: Generate → Validate → Execute → Publish → Gate.
2) Require validation artifacts before Gate.
3) Publish evidence bundles as pipeline artifacts.
4) Document gate inputs and dependencies.

## Validation
- YAML lint or schema validation
- Required artifacts produced before Gate

## Edge cases
- Missing QP details: document required inputs and owners
- Environment gaps: list blockers and stop-the-line triggers
