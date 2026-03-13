---
description: 'Context normalization rules for converting source documents to markdown with provenance, redaction tracking, and target README maintenance'
applyTo: 'context/**/*,**/*.prompt.md'
---

# Context Ingestion Instructions

## Purpose

Context ingestion converts source documents (specs, wikis, emails, screenshots) into normalized markdown context packs that downstream skills consume for test generation, validation, and evidence packaging.

## Conversion Rules

### Convert to Markdown

- All source documents must be converted to Markdown format
- Preserve document structure: headings, lists, tables, code blocks
- Convert images to descriptive alt-text placeholders with a reference to the original file
- Preserve URLs as clickable links
- Remove proprietary formatting (Word styles, HTML layout divs) — keep content only

### File Naming

- Use `kebab-case` for all context pack files: `order-api-spec.md`, `login-flow-requirements.md`
- Prefix with target name when multiple targets exist: `webapp-login-flow.md`

## Provenance

Every context pack file must include a YAML front matter block with provenance metadata:

```yaml
---
source: 'Order API Specification v2.3'
sourceUrl: 'https://wiki.example.com/specs/order-api'
retrievedAt: '2026-02-18T10:30:00Z'
owner: 'API Team'
target: 'order-api'
documentType: 'api-specification'
---
```

### Required Provenance Fields

| Field | Description |
|-------|-------------|
| `source` | Human-readable name of the original document |
| `sourceUrl` | URL or file path where the document was obtained |
| `retrievedAt` | ISO 8601 timestamp of when the document was captured |
| `owner` | Team or person responsible for the source document |
| `target` | The system/application this context applies to |

### Optional Provenance Fields

| Field | Description |
|-------|-------------|
| `documentType` | Category: `api-specification`, `requirements`, `user-story`, `architecture`, `test-plan` |
| `version` | Version of the source document |
| `expiresAt` | Date after which this context should be refreshed |

## No Secrets in Context Packs

- **Never** include API keys, passwords, tokens, connection strings, or PII
- Scan all context packs before committing — reject any containing secrets
- Replace real credentials with placeholder tokens: `<API_KEY>`, `<DB_PASSWORD>`

## Redaction Rules

When source documents contain sensitive information:

1. **Redact** the sensitive content, replacing it with `[REDACTED: <category>]`
2. **Record** every redaction in a `redactions.yml` file alongside the context pack

```markdown
The API endpoint requires authentication with [REDACTED: api-key].
Connect to the database at [REDACTED: connection-string].
```

### Redaction Log

```yaml
# context/normalized/order-api/redactions.yml
redactions:
  - file: order-api-spec.md
    line: 42
    category: api-key
    description: 'Production API key for order service'
  - file: order-api-spec.md
    line: 87
    category: connection-string
    description: 'Database connection string with credentials'
```

## Target README

Each target folder under `context/targets/` must contain a `README.md` with:

### Required Sections

```markdown
# Target: <target-name>

## Sources
| Document | Source URL | Retrieved | Owner |
|----------|-----------|-----------|-------|
| Order API Spec v2.3 | https://wiki.example.com/... | 2026-02-18 | API Team |
| Login Flow Requirements | https://jira.example.com/... | 2026-02-15 | UX Team |

## Assumptions
- List any assumptions made during context normalization
- Example: "API versioning uses URL path prefix /api/v{n}"
- Example: "Authentication uses OAuth 2.0 bearer tokens"

## Prerequisites
- Required access or tools to refresh this context
- Example: "Wiki access requires VPN connection"
- Example: "Jira export requires project-admin role"

## Redaction Summary
- Number of redactions applied and categories
- Reference to the redactions.yml file
```

## Context Pack Structure

```
context/
├── normalized/
│   ├── order-api/
│   │   ├── order-api-spec.md          # Normalized document
│   │   ├── order-api-endpoints.md     # Normalized document
│   │   └── redactions.yml             # Redaction log
│   └── webapp-login/
│       ├── login-flow-requirements.md
│       └── redactions.yml
└── targets/
    ├── order-api/
    │   └── README.md                  # Target README
    └── webapp-login/
        └── README.md                  # Target README
```

## Refresh Workflow

1. Re-fetch source documents from their `sourceUrl`
2. Re-apply normalization and redaction rules
3. Update `retrievedAt` timestamp in provenance
4. Diff against previous version — flag significant changes
5. Update the target README if sources or assumptions changed
