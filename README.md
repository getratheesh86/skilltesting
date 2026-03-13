# AI Testing Framework Skills

A curated collection of **skills, agents, prompts, and instructions** for AI-driven test automation across API, Web UI, Swing UI, and Test Data workflows. Designed for enterprise adoption — install into any project to enable automated test generation, validation, governance, and self-healing.

## Architecture: Hybrid AGENTS.md + Skills

This repo uses a **hybrid approach** based on [Vercel's eval findings](https://vercel.com/blog/agents-md-outperforms-skills-in-our-agent-evals) showing that passive context (AGENTS.md) achieves 100% pass rate vs. 53% for skills alone:

| Layer | What | Why |
|-------|------|-----|
| **AGENTS.md** | Compressed knowledge index + retrieval instructions + decision tree | Always in context — no decision point for the agent |
| **Skills** | Deep procedural knowledge per domain | For explicit user-triggered workflows ("generate API tests") |
| **Instructions** | File-pattern guardrails | Passive context, auto-applied by file match |
| **Prompts** | Repeatable task playbooks | User-invoked workflows |

**Key principle:** The AGENTS.md file tells the agent *where* to find knowledge (SKILL.md paths). The agent reads the relevant SKILL.md when it needs deep procedural steps. This avoids context bloat while ensuring the agent always knows what resources exist.

## What's Included

| Type | Count | Purpose |
|------|-------|---------|
| **Skills** | 10 | Specialized AI capabilities (context ingestion, test generation, validation, etc.) |
| **Prompts** | 15 | Task playbooks for repeatable workflows |
| **Instructions** | 11 | Coding standards applied by file pattern |
| **Agents** | 3 | TDD workflow agents (red/green/refactor) |
| **Schemas** | 2 | Shared artifact validation schemas |

## Skills Overview

| Skill | Workstream | Description |
|-------|-----------|-------------|
| `context-ingestion` | Foundation | Normalize source docs into reviewable context packs with provenance |
| `api-test-generation` | API | Generate BDD + runnable tests from OpenAPI/Swagger/GraphQL specs |
| `web-ui-test-generation` | Web UI | Generate Playwright tests with resilient locators and traces |
| `swing-ui-test-generation` | Swing UI | Generate JUnit 5 Swing tests with identity strategy |
| `test-data-management` | Test Data | Define data contracts, provisioning, isolation, and cleanup |
| `orchestration-cli` | Platform | Coordinate ingest-generate-validate-execute-publish stages |
| `self-healing` | Cross-cutting | Apply bounded deterministic repair rules to failed runs |
| `validation-evidence` | Governance | Validate artifacts and package evidence bundles |
| `ado-pipelines-governance` | CI/CD | ADO pipeline templates with Quality Passport gates |
| `owasp-security` | Security | OWASP Top 10 secure-by-build guidance |

## Installation

### Option A: Full install (recommended for project teams)

Clone and copy all resources into your project's `.github/` directory:

```bash
git clone <repo-url> --depth 1 /tmp/skills-repo
pwsh /tmp/skills-repo/scripts/install.ps1 -TargetProject /path/to/your/project
rm -rf /tmp/skills-repo
```

### Option B: npx skills (skills only)

```bash
# Install skills into your project
npx skills add <repo-url>

# Install skills globally (all projects on this machine)
npx skills add <repo-url> -g -a github-copilot
```

> **Note:** `npx skills` only installs SKILL.md files. Agents, prompts, and instructions require Option A or manual copy.

### Option C: Git submodule (version-controlled updates)

```bash
cd your-project
git submodule add <repo-url> .github/shared-skills
```

See [docs/INSTALL.md](docs/INSTALL.md) for detailed instructions and enterprise deployment patterns.

## Installation Level Guide

Not all resources should be installed at the same level. Use this guide:

### Global install (developer machine, all projects)

Install these once — they provide universal guardrails:

| Resource | Why Global |
|----------|-----------|
| `owasp-security` skill | Security guidance applies to every project |
| `code-review.instructions.md` | Org-wide review standards |
| `security-owasp.instructions.md` | Security baseline for all code |
| `docker.instructions.md` | Container best practices (if applicable) |

```bash
npx skills add <repo-url> --skill owasp-security -g -a github-copilot
```

### Project install (per repo, committed to git)

Install these into each project — they drive domain-specific work:

| Resource | Why Project-Level |
|----------|------------------|
| `context-ingestion` | Each project has different source docs |
| `api-test-generation` | Bound to project's API specs and language |
| `web-ui-test-generation` | Bound to project's UI stack |
| `swing-ui-test-generation` | Bound to project's identity strategy |
| `test-data-management` | Data contracts are project-specific |
| `orchestration-cli` | Pipeline stages may vary per project |
| `self-healing` | Repair rules depend on the project's test stack |
| `validation-evidence` | Evidence schemas may be customized |
| `ado-pipelines-governance` | Pipeline templates are project-specific |
| All prompts | Task workflows are project-context-dependent |
| Language-specific instructions | Match the project's tech stack |

```bash
# Full project install
pwsh scripts/install.ps1 -TargetProject /path/to/your/project
```

### Decision tree

```
Is it a universal guardrail (security, code review)?
  → Install GLOBAL

Does it depend on this project's tech stack, specs, or data?
  → Install at PROJECT level

Do you want centralized updates across many repos?
  → Use GIT SUBMODULE
```

## Supported Languages & Frameworks

| Domain | Primary | Also Supported |
|--------|---------|----------------|
| API Testing | Java (JUnit 5, RestAssured) | TypeScript, Python |
| Web UI Testing | Playwright (TypeScript) | Selenium (Java) |
| Swing UI Testing | Java (JUnit 5) | — |
| Test Data | Language-agnostic contracts | Java, Python, SQL |
| Pipelines | Azure DevOps YAML | — |

## Workflow: How Skills Drive Testing

```
1. context-ingestion    → Normalize specs, docs, stories into context packs
2. *-test-generation    → Generate BDD + runnable tests for API/Web/Swing
3. test-data-management → Provision deterministic test data
4. validation-evidence  → Validate all artifacts (schema/lint/compile)
5. orchestration-cli    → Coordinate the full pipeline
6. ado-pipelines        → Publish to ADO with governance gates
7. self-healing         → Repair failures deterministically (post-execution)
```

## Contributing

- Changes must come via PRs
- Every instruction change must include motivation and a validator impact statement
- File names use lower-case-with-hyphens
- All markdown files require proper front matter

## Model Requirements

| Task | Recommended Tier | Why |
|------|-----------------|-----|
| Orchestration + planning | High reasoning (o3, Claude Opus) | Multi-step coordination |
| Test generation | Standard (GPT-4o, Claude Sonnet) | Pattern application, code gen |
| Code review + security | Standard with long context | Full-file analysis |
| Self-healing | High reasoning | Failure classification, bounded repair |
| Context ingestion | Standard | Document normalization |

## License

Proprietary — internal use only.
