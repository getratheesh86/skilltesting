---
description: 'Create a human-in-the-loop review packet for a branch or PR with structured summaries'
---

# Create Review Packet — Human-in-the-Loop Review

You are creating a review packet for human review of a branch, PR, or generated artifact set.

## Inputs to request (if not provided)

- Target or PR identifier
- Branch name or commit range
- Artifacts to include in review
- Reviewers or stakeholders

## Required output files

All outputs go under `review-packets/<target-or-pr-id>/`:

| File | Purpose |
|------|---------|
| `SUMMARY.md` | One-page overview of what changed and why |
| `ASSUMPTIONS.md` | Assumptions made during generation; items needing confirmation |
| `SCOPE.md` | What is in scope and what is explicitly excluded |
| `VALIDATION.md` | Validation results, pass/fail summary, known issues |
| `PROVENANCE.md` | Source traceability — what inputs produced what outputs |
| `CHECKLIST.md` | Reviewer checklist with actionable items |

### Optional files

| File | Purpose |
|------|---------|
| `TFM.json` | Traceability matrix in machine-readable format |
| `TFM.md` | Traceability matrix in human-readable format |

## Rules

- Keep all files short and scannable — prefer bullet lists and tables over narrative
- Prefer links to source artifacts over inline content
- Every assumption must be flagged for reviewer confirmation
- Every known issue must have a severity and recommended action
