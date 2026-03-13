---
name: validation-evidence
description: 'Validate generated artifacts and package evidence bundles with reports and provenance. Use when enforcing deterministic gates before execution or governance checks.'
metadata:
  author: ai-testing-framework
  version: "2026.02.18"
---

# Validation & Evidence Bundle

## Quick Reference
- **Trigger:** Pre-publish gate; post-generation validation; audit packaging
- **Inputs:** Generated artifacts, schemas, validator commands, run ID
- **Outputs:** reports/validation/, reports/bundles/<run-id>/manifest.json
- **Language:** Language-agnostic
- **Pipeline stage:** Validate + Publish
- **Prerequisite:** Generated artifacts exist

## What this skill does
Runs schema, lint, compile, and smoke checks for generated artifacts and packages evidence bundles for governance and review.

## When to use
- Before publishing or gating a pipeline run
- After generation to ensure artifacts are valid
- For audit-ready evidence packaging

## Inputs
- Generated artifacts and their schemas
- Validator commands
- Target name and run identifier

## Outputs
- Validation reports: reports/validation/
- Evidence bundle manifest: reports/bundles/<run-id>/manifest.json
- Human-readable summary report

## Steps
1) Validate against schemas and lint/compile rules.
2) Run smoke execution where applicable.
3) Generate machine-readable and human-readable summaries.
4) Record provenance for inputs and checks.

## Validation
- All required validators pass
- Evidence manifest includes inputs, versions, and timestamps

## Edge cases
- Validator missing: document dependency and skip with explicit warning
- Partial failures: emit a failed status and preserve diagnostics
