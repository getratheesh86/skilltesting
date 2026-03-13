---
description: 'Orchestrate ingest-generate-validate-execute-publish stages with run manifests and evidence'
---

# Orchestration CLI — Multi-Stage Pipeline

You are implementing a CLI that coordinates the ingest → generate → validate → execute → publish pipeline.

## Inputs to request (if not provided)

- Target list (one or more targets to process)
- Required stages (all, or a subset like "ingest,generate,validate")
- Environment config sources (env files, key vault references, config JSON)

## Steps

1. Implement each stage as an independently invocable step:
   - **Ingest** — Normalize sources into context packs
   - **Generate** — Produce test artifacts from context
   - **Validate** — Check artifacts against schemas and run smoke tests
   - **Execute** — Run tests and collect results
   - **Publish** — Package evidence bundles and emit reports
2. Produce a run manifest capturing stage results, timing, and status.
3. Produce an evidence index linking all artifacts to their provenance.
4. Record provenance for the orchestration run itself.

## Required outputs

- CLI entrypoint (script or binary)
- `reports/runs/` — Run manifests per execution
- `reports/bundles/` — Evidence bundles per target
- Provenance metadata for the orchestration run

## Safety rules

- No secrets in CLI defaults, arguments, or log output
- All credentials must be loaded from environment variables or secure config
- Fail loudly on missing prerequisites rather than proceeding with partial data
