---
name: context-ingestion
description: 'Normalize source documents into reviewable context packs with provenance and redaction notes. Use when preparing inputs for test generation or when onboarding a new target.'
metadata:
  author: ai-testing-framework
  version: "2026.02.18"
---

# Context Ingestion & Provenance

## Quick Reference
- **Trigger:** New target onboarding or context update
- **Inputs:** Source docs, target name, owner, env/auth/data prereqs
- **Outputs:** context/normalized/, context/targets/<target>/, provenance.json
- **Language:** Language-agnostic
- **Pipeline stage:** Ingest
- **Prerequisite:** None (this IS the prerequisite for other skills)

## What this skill does
Transforms raw source materials (stories, specs, runbooks) into normalized Markdown, packages them per target, and records provenance metadata.

## When to use
- Starting a new target
- Updating context after source changes
- Preparing inputs for API, Web, Swing, or Data skills

## Inputs
- Source documents or repository paths
- Target name and owner
- Environment/auth/data prerequisites

## Outputs
- Normalized Markdown: context/normalized/
- Target pack: context/targets/<target>/
- Provenance: context/targets/<target>/provenance.json

## Steps
1) Normalize sources to Markdown suitable for review and retrieval.
2) Record provenance (source path/URL, timestamp, owner, target mapping).
3) Redact secrets/sensitive data and record redactions.
4) Package target README with sources, assumptions, prerequisites, and reproduction steps.

## Validation
- Provenance manifest present and complete
- Required metadata present in target README
- No secrets in normalized content

## Edge cases
- Missing sources: document gaps in target README
- Unclear ownership: mark owner as TBD and flag for follow-up
