---
description: 'Normalize source documents into reviewable context packs with provenance and redaction notes'
---

# Context Ingestion — Normalize & Package

You are generating a context pack for a specific target application or API.

## Inputs to request (if not provided)

- Target name
- Source documents (paths or URLs)
- Owner/SME
- Environment/auth/data prerequisites

## Steps

1. Normalize sources into markdown suitable for review and retrieval.
2. Preserve provenance for each source: path/URL, timestamp, owner, target mapping.
3. Redact any secrets or sensitive production data. If redacted, record what and why.
4. Package outputs under `context/targets/<target>/`.

## Required outputs

- `context/targets/<target>/README.md` with sources, assumptions, env/auth/data prerequisites, reproduction steps
- `context/targets/<target>/provenance.json` capturing source metadata
- Normalized files in `context/normalized/` (linked from the target README)

## Validation checklist

- Provenance present and complete
- No secrets or sensitive production data in normalized content
- Target README includes prerequisites and reproduction steps
