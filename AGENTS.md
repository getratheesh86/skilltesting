# AGENTS.md — AI Testing Framework

IMPORTANT: Prefer retrieval-led reasoning over pre-training-led reasoning for any testing, generation, or validation tasks. Read the relevant SKILL.md file before generating artifacts. Do not rely on training data alone.

## Knowledge Index

When working on tasks in this repository or any project that has installed these resources, use this index to find the right skill, prompt, and instruction. Read the SKILL.md file for full procedural details before acting.

### Skill Index (read SKILL.md for full steps)

|Skill|Path|Domain|When to use|Key outputs|
|---|---|---|---|---|
|context-ingestion|skills/context-ingestion/SKILL.md|Foundation|Starting a new target; updating context after source changes|context/targets/\<target\>/README.md, provenance.json, context/normalized/|
|api-test-generation|skills/api-test-generation/SKILL.md|API|New API onboarding; spec drift; regression expansion|tests/api/bdd/, tests/api/, tests/api/contracts/|
|web-ui-test-generation|skills/web-ui-test-generation/SKILL.md|Web UI|New web target; UI changes; multi-browser regression; BDD acceptance|tests/web/bdd/, tests/web/, reports/web/, reports/web/artifacts/|
|swing-ui-test-generation|skills/swing-ui-test-generation/SKILL.md|Swing UI|Swing onboarding (requires identity strategy)|tests/swing/, tests/swing/IDENTITY.md|
|test-data-management|skills/test-data-management/SKILL.md|Data|Deterministic data setup; CI regression enablement|tests/data/contracts/, tests/data/|
|orchestration-cli|skills/orchestration-cli/SKILL.md|Platform|End-to-end workflow coordination; CI orchestration|reports/runs/, reports/bundles/|
|self-healing|skills/self-healing/SKILL.md|Cross-cutting|Post-failure repair when healing policy allows|reports/healing/, generated/repairs/|
|validation-evidence|skills/validation-evidence/SKILL.md|Governance|Pre-publish validation; audit-ready evidence|reports/bundles/\<run-id\>/manifest.json|
|ado-pipelines-governance|skills/ado-pipelines-governance/SKILL.md|CI/CD|Pipeline setup; governance gates|pipelines/ado/|
|owasp-security|skills/owasp-security/SKILL.md|Security|Code review; design review; test planning|Guidance only|

### Prompt Index (use for repeatable workflows)

|Prompt|Path|Use when|
|---|---|---|
|context-ingestion|prompts/context-ingestion.prompt.md|Normalizing source docs for a target|
|api-test-generation|prompts/api-test-generation.prompt.md|Generating BDD + runnable API tests|
|web-ui-test-generation|prompts/web-ui-test-generation.prompt.md|Generating BDD + runnable web UI tests|
|swing-ui-test-generation|prompts/swing-ui-test-generation.prompt.md|Generating Swing UI tests|
|test-data-management|prompts/test-data-management.prompt.md|Defining data contracts + provisioning|
|orchestration-cli|prompts/orchestration-cli.prompt.md|Building the CLI workflow|
|self-healing|prompts/self-healing.prompt.md|Applying repair rules to failures|
|validation-evidence|prompts/validation-evidence.prompt.md|Validating artifacts + packaging evidence|
|ado-pipelines-governance|prompts/ado-pipelines-governance.prompt.md|Generating ADO pipeline templates|
|create-review-packet|prompts/create-review-packet.prompt.md|Human-in-the-loop review packets|
|generate-api-test-pack|prompts/generate-api-test-pack.prompt.md|Playwright/JUnit 5 API test skeletons|
|generate-web-test-pack|prompts/generate-web-test-pack.prompt.md|Playwright web test pack|
|generate-swing-test-pack|prompts/generate-swing-test-pack.prompt.md|Swing harness + identity feasibility|
|create-agents-md|prompts/create-agents-md.prompt.md|Bootstrap AGENTS.md for a new project|

### Instruction Index (auto-applied by file pattern)

|Instruction|Path|Applies to|
|---|---|---|
|code-review|instructions/code-review.instructions.md|All files|
|java|instructions/java.instructions.md|*.java|
|java-junit-api|instructions/java-junit-api.instructions.md|tests/api/**/*.java, *Test.java, *IT.java|
|java-swing|instructions/java-swing.instructions.md|tests/swing/**/*.java, *Swing*.java|
|playwright-typescript|instructions/playwright-typescript.instructions.md|tests/web/**/*.ts, *.spec.ts|
|playwright-java|instructions/playwright-java.instructions.md|tests/web/**/*.java, *Playwright*.java, *WebTest*.java|
|python|instructions/python.instructions.md|*.py|
|pipelines-ado|instructions/pipelines-ado.instructions.md|pipelines/**/*.yml|
|docker|instructions/docker.instructions.md|Dockerfile*, docker-compose*|
|security-owasp|instructions/security-owasp.instructions.md|All files|
|context-ingestion|instructions/context-ingestion.instructions.md|context/**/*|

## Decision Tree — What to Do

```
Need to onboard a new target?
  → Read skills/context-ingestion/SKILL.md
  → Use prompts/context-ingestion.prompt.md

Need to generate tests?
  → API: Read skills/api-test-generation/SKILL.md, use prompts/generate-api-test-pack.prompt.md
  → Web: Read skills/web-ui-test-generation/SKILL.md, use prompts/generate-web-test-pack.prompt.md (includes BDD)
  → Swing: Read skills/swing-ui-test-generation/SKILL.md, use prompts/generate-swing-test-pack.prompt.md

Need to provision test data?
  → Read skills/test-data-management/SKILL.md
  → Use prompts/test-data-management.prompt.md

Need to validate + package evidence?
  → Read skills/validation-evidence/SKILL.md
  → Use prompts/validation-evidence.prompt.md

Need to run the full pipeline?
  → Read skills/orchestration-cli/SKILL.md
  → Pipeline: ingest → generate → validate → execute → publish

Need to fix broken tests?
  → Read skills/self-healing/SKILL.md
  → Use prompts/self-healing.prompt.md

Need to set up ADO pipeline?
  → Read skills/ado-pipelines-governance/SKILL.md
  → Use prompts/ado-pipelines-governance.prompt.md

Need a review packet for a PR?
  → Use prompts/create-review-packet.prompt.md
```

## Cross-Cutting Rules (always apply)

### Provenance
Every generated artifact must record: source path/URL, timestamp, owner, target mapping. Use `provenance.json` in each target pack.

### Redaction
Never include secrets, credentials, tokens, or sensitive production data. If redaction occurs, record what was removed and why.

### Evidence bundles
Every pipeline run must produce: machine-readable results (JUnit XML/JSON), human-readable summary, diagnostics (logs/traces/screenshots), provenance metadata. Schema: `schemas/evidence-manifest.schema.json`.

### Self-healing boundaries
Self-healing must be deterministic, explainable, and evidenced. Every repair emits: what changed, what rule was applied, confidence threshold, human review note. Never change semantics beyond allowed change classes.

### Security baseline (OWASP)
No hardcoded secrets. Input validation on all user-facing entry points. Parameterized queries only. Dependencies scanned for known vulnerabilities. Encrypted credential storage. RBAC enforced.

## Language Support

|Domain|Primary|Also supported|
|---|---|---|
|API testing|Playwright (TypeScript)|Java (JUnit 5), Python|
|Web UI testing|Playwright (TypeScript)|Playwright (Java)|
|Swing UI testing|Java (JUnit 5)|—|
|Test data|Language-agnostic contracts|Java, Python, SQL|
|Pipelines|Azure DevOps YAML|—|

The orchestrator dispatches by target type and language:
```
orchestrate --target <name> --type api|web|swing --language java|typescript|python
```

## Model Requirements

|Task type|Recommended model tier|Reason|
|---|---|---|
|Orchestration + planning|High reasoning (e.g., o3, Claude Opus)|Multi-step coordination, dependency resolution|
|Test generation|Standard (e.g., GPT-4o, Claude Sonnet)|Pattern application, code generation|
|Code review + security|Standard with long context|Full-file analysis, cross-reference|
|Self-healing|High reasoning|Failure classification, bounded repair decisions|
|Context ingestion|Standard|Document normalization, metadata extraction|

## Repository Structure

```
skills/{name}/SKILL.md        — Deep procedural knowledge per domain
prompts/{name}.prompt.md       — Repeatable task playbooks
instructions/{name}.instructions.md — File-pattern coding standards
agents/{name}.agent.md         — TDD workflow agents
schemas/*.schema.json          — Shared artifact validation schemas
scripts/install.ps1            — Full project installer
docs/INSTALL.md                — Installation guide
```

## Terminal Rules

1. **Check before starting** — verify services/environments before launching tests
2. **Long-running processes** — use `Start-Process` to spawn separate shells
3. **No secrets in terminals** — never echo credentials or tokens

## Naming Conventions

|Pattern|Purpose|Example|
|---|---|---|
|`*.instructions.md`|Coding standards (applyTo)|`java.instructions.md`|
|`*.prompt.md`|Task playbooks|`api-test-generation.prompt.md`|
|`*.agent.md`|AI agent definitions|`tdd-red.agent.md`|
|`SKILL.md`|Skill definition (per folder)|`skills/api-test-generation/SKILL.md`|

## License

Proprietary — internal use only.
