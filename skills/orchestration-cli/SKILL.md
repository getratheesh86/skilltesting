---
name: orchestration-cli
description: 'Orchestrate ingest-generate-validate-execute-publish stages and emit run manifests. Use when coordinating multi-skill workflows for a target.'
metadata:
  author: ai-testing-framework
  version: "2026.02.18"
---

# Unified Orchestration & CLI

## Quick Reference
- **Trigger:** End-to-end workflow; CI coordination; multi-skill runs
- **Inputs:** Target list, env config, required stages
- **Outputs:** reports/runs/, reports/bundles/
- **Language:** Language-agnostic (dispatches by target config)
- **Pipeline stage:** All (ingest → generate → validate → execute → publish)
- **Prerequisite:** Target skills installed; env config available

## What this skill does
Provides a CLI workflow to coordinate skill stages and emit standardized run manifests and evidence indexes.

## When to use
- Running end-to-end workflows for a target
- Coordinating multiple skills in CI
- Standardizing run artifacts

## Inputs
- Target list and selection mechanism
- Environment configuration sources
- Required stages and outputs

## Outputs
- Run manifests: reports/runs/
- Evidence bundle index: reports/bundles/

## Dispatch model
The orchestrator selects the appropriate generation skill and language based on target configuration:

```
orchestrate --target <name> --type api|web|swing --language java|typescript|python
  → ingest (language-agnostic)
  → generate (dispatches to api/web/swing skill + language-specific prompt)
  → validate (schema + compile/lint for target language)
  → execute (runner per framework: JUnit/Playwright)
  → publish (standard evidence bundle)
```

## Steps
1) Execute stages: ingest → generate → validate → execute → publish.
2) Emit run manifest and evidence index.
3) Record provenance for each stage.

## Validation
- Stage-level exit codes
- Evidence index includes required bundles

## Edge cases
- Missing stage output: stop and document dependency
- Partial runs: mark run status and preserve diagnostics
