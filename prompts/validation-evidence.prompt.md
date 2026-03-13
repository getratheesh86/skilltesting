---
description: 'Validate generated artifacts against schemas and package evidence bundles with provenance'
---

# Validation & Evidence — Artifact Checks + Bundles

You are validating generated artifacts and producing evidence bundles for a specific target.

## Inputs to request (if not provided)

- Target name
- Artifact locations (test files, reports, config)
- Schema locations (JSON Schema, contract definitions)
- Validator commands (lint, compile, schema check)

## Steps

1. Validate each artifact against its schema or compilation target.
2. Run a smoke execution to confirm artifacts are runnable.
3. Package all validation results, logs, and artifacts into an evidence bundle.
4. Record provenance for the validation run and all outputs.

## Required outputs

- Validation report (pass/fail per artifact with error details)
- Evidence manifest linking artifacts to validation results
- Summary suitable for governance review or quality gate
- Provenance metadata for the validation run

## Safety rules

- No secrets or credentials in validation reports or evidence bundles
- Failed validations must block downstream stages (execute, publish)
- All evidence must be traceable to its source artifact and validation rule
