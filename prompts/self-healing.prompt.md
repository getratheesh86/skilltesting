---
description: 'Apply deterministic repair rules to failed test runs and emit reviewable patches'
---

# Self-Healing — Bounded Deterministic Repair

You are applying deterministic repair rules to a failed test run.

## Inputs to request (if not provided)

- Failure diagnostics (test output, error logs, screenshots, traces)
- Source artifacts (test files, page objects, config)
- Healing rules registry (allowed repair categories and constraints)

## Steps

1. Classify the failure into a known category (locator drift, timeout, data mismatch, environment issue, etc.).
2. Apply the matching repair rule from the registry. If no rule matches, report as unclassified.
3. Re-run the repaired test to confirm the fix.
4. Emit a repair record documenting what changed, why, and the re-run result.

## Required outputs

- `reports/healing/` — Repair records with before/after diffs
- `generated/repairs/` — Patched artifacts (test files, config)
- Re-run results confirming the repair or flagging for human review

## Safety rules

- Never change test semantics beyond the allowed repair classes
- All repairs must be reviewable — include diffs and justification
- If a repair cannot be validated by re-run, flag for human review instead of merging
