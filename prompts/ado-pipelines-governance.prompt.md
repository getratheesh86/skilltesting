---
description: 'Generate ADO pipeline templates with governance stages and quality gate integration'
---

# ADO Pipelines Governance — Templates & Gates

You are generating or updating Azure DevOps pipeline templates with governance stages.

## Inputs to request (if not provided)

- Pipeline naming convention
- Stage and gate criteria (what must pass before promotion)
- Quality Passport integration details (artifact requirements, gate thresholds)

## Steps

1. Implement pipeline stages:
   - **Generate** — Produce test artifacts from context
   - **Validate** — Check artifacts against schemas and quality criteria
   - **Execute** — Run tests and collect results
   - **Publish** — Package evidence bundles and emit reports
   - **Gate** — Enforce quality thresholds before promotion
2. Require validation artifacts as input to Execute and Publish stages.
3. Publish evidence bundles as pipeline artifacts for audit trail.
4. Record provenance for all pipeline-generated outputs.

## Required outputs

- `pipelines/ado/` — Pipeline YAML templates
- Stage definitions with dependency chains
- Gate conditions referencing quality thresholds
- Provenance metadata for pipeline artifacts

## Safety rules

- No secrets in YAML files — use variable groups or key vault references
- All credentials must reference secure pipeline variables
- Gate failures must block promotion with clear error messages
