# AI Testing Framework — Review & Operations Guide

## Part 1: Repository Review

### Overall Assessment

The BlackRockSkills repo is a well-structured, enterprise-grade skill library covering the full AI-driven test automation lifecycle. It uses the **hybrid AGENTS.md + Skills** approach (passive context + retrieval-on-demand) which aligns with Vercel's eval findings for maximum agent effectiveness.

**Inventory:** 10 skills, 15 prompts, 3 agents, 11 instructions, 2 schemas, 1 collection, install script + template.

---

### Efficacy Review

| Area | Rating | Assessment |
|------|--------|------------|
| **Skill coverage** | Strong | Full lifecycle: ingest → generate → validate → execute → publish → heal. API, Web, Swing, and cross-cutting security are all addressed. |
| **BDD integration** | Strong | Both API and Web UI skills now generate Gherkin features + aligned runnable tests with traceability. |
| **Framework consistency** | Strong | Playwright is primary across both API and Web UI (TypeScript + Java). No Selenium residue. RestAssured correctly demoted to optional. |
| **Provenance & governance** | Strong | Every skill mandates provenance recording, evidence bundling, and redaction rules. Evidence manifest schema is well-defined. |
| **Self-healing boundaries** | Strong | Explicitly bounded to deterministic, explainable, evidenced repairs. No "magic" auto-fix. |
| **TDD agents** | Adequate | Red/Green/Refactor cycle is clean. Could benefit from language-specific tool references (e.g., `tools: ['terminal']`). |
| **AGENTS.md template** | Strong | Includes retrieval instruction, skill index, decision tree, cross-cutting rules. Right-sized for context windows. |

### Clarity Review

| Area | Rating | Issues Found |
|------|--------|--------------|
| **Skill SKILL.md files** | Strong | Consistent structure: Quick Reference → What/When/Inputs/Outputs/Steps/Validation/Edge cases. Easy to scan. |
| **Prompt files** | Strong | Clear inputs-to-request, steps, required outputs, and safety rules. All follow the same template. |
| **Instructions** | Strong | Each has clear `applyTo` patterns, code examples with ✅/❌ patterns, and rationale. |
| **Duplicate prompt coverage** | Needs attention | Some skills have two prompts (e.g., `api-test-generation.prompt.md` + `generate-api-test-pack.prompt.md`). The distinction between "workflow prompt" and "pack generation prompt" is not immediately clear to teams. See [Finding F1](#f1-duplicate-prompt-pairs). |
| **Collection manifest** | Adequate | Includes key items but omits most prompts and all instructions. See [Finding F4](#f4-collection-manifest-incomplete). |
| **README navigation** | Strong | Clear skill table, installation options, language matrix, workflow diagram. |

### Usability Review

| Area | Rating | Issues Found |
|------|--------|--------------|
| **Installation** | Strong | Four methods documented (script, npx, submodule, manual). Install levels (global vs. project) clearly explained. |
| **First-use path** | Needs attention | No quickstart walkthrough for "I just installed, now what?" See [Finding F3](#f3-no-quickstart-walkthrough). |
| **Orchestration CLI** | Needs attention | The skill describes a CLI (`orchestrate --target ...`) but no actual CLI script exists in the repo. See [Finding F2](#f2-orchestration-cli-is-aspirational). |
| **Schema usage** | Adequate | Two schemas exist but no tooling or instructions explain how to validate against them. |
| **Version tracking** | Adequate | Skills have `metadata.version` but package.json is `1.0.0` with no build/release process. |

---

### Findings

#### F1: Duplicate Prompt Pairs {#f1-duplicate-prompt-pairs}

**Severity:** Low — clarity risk

Three domains have two prompts each:

| Workflow Prompt | Pack Prompt | Difference |
|-----------------|-------------|------------|
| `api-test-generation.prompt.md` | `generate-api-test-pack.prompt.md` | Workflow is process-oriented; pack is output-oriented |
| `web-ui-test-generation.prompt.md` | `generate-web-test-pack.prompt.md` | Same pattern |
| `swing-ui-test-generation.prompt.md` | `generate-swing-test-pack.prompt.md` | Same pattern |

**Recommendation:** Add a one-line comment to each prompt's description clarifying the distinction. Example: *"Workflow prompt — use for end-to-end generation with ingestion"* vs. *"Pack prompt — use to generate a standalone test pack for one target."*

#### F2: Orchestration CLI is Aspirational {#f2-orchestration-cli-is-aspirational}

**Severity:** Medium — usability gap

The `orchestration-cli` skill describes `orchestrate --target <name> --type api|web|swing --language java|typescript|python` but no actual script/binary exists. The `scripts/` directory only contains `install.ps1` and `AGENTS.md.template`.

**Recommendation:** Either:
- (a) Build a `scripts/orchestrate.ps1` (or `.sh`) that implements the stage dispatch, or
- (b) Clearly document that the skill is a blueprint for teams to implement, and provide a reference implementation blueprint.

#### F3: No Quickstart Walkthrough {#f3-no-quickstart-walkthrough}

**Severity:** Medium — onboarding friction

After installation, teams must piece together the workflow from AGENTS.md, multiple skills, and prompts. There's no "Day 1" walkthrough.

**Recommendation:** Add a `docs/QUICKSTART.md` that walks through: install → ingest first target → generate tests → validate → run → review evidence.

#### F4: Collection Manifest is Incomplete {#f4-collection-manifest-incomplete}

**Severity:** Low

The collection only includes 10 skills, 2 prompts (of 15), and 3 agents. It omits all generation prompts and all instructions.

**Recommendation:** Add the remaining prompts (at minimum the "generate-*-test-pack" prompts) to the collection for discoverability.

#### F5: Agent Files Missing `tools` Field

**Severity:** Low — best practice

The three TDD agents specify `model` but not `tools`. Adding `tools: ['terminal', 'codebase']` would help Copilot know what capabilities to use.

**Recommendation:** Add `tools` to agent frontmatter.

#### F6: No BDD Runner Configuration Guidance

**Severity:** Low — completeness

BDD feature files are generated but there's no guidance on how to connect Gherkin to test runners (e.g., cucumber-js, cucumber-java, or using BDD as a documentation layer without a Cucumber runner).

**Recommendation:** Add a note in the BDD sections of both API and Web UI skills clarifying the intended BDD usage pattern (documentation-driven vs. executable specs).

---

## Part 2: Operations Guide

### Who This Guide Is For

Teams adopting the AI Testing Framework to automate test generation, validation, and governance across API, Web UI, and Swing UI targets.

### Prerequisites

| Requirement | Details |
|-------------|---------|
| VS Code | With GitHub Copilot extension |
| Node.js | 18+ (for Playwright TypeScript) |
| Java | 17+ (for Playwright Java, JUnit 5, Swing) |
| PowerShell | 7+ (for install and orchestration scripts) |
| Azure DevOps | For pipeline governance (optional) |

---

### Phase 1: Installation

#### 1.1 Choose Your Install Level

```
Is it a universal guardrail (security, code review)?
  → Install GLOBAL (on every developer machine)

Does it depend on this project's tech stack or specs?
  → Install at PROJECT level (in .github/)

Do you want centralized updates across many repos?
  → Use GIT SUBMODULE
```

#### 1.2 Project Install (Recommended)

```powershell
# Clone the skills repo
git clone <skills-repo-url> --depth 1 C:\temp\skills-repo

# Install into your project
pwsh C:\temp\skills-repo\scripts\install.ps1 -TargetProject C:\path\to\your\project

# Clean up
Remove-Item C:\temp\skills-repo -Recurse -Force
```

#### 1.3 Post-Install Cleanup

Remove instructions that don't match your tech stack:

| If your project... | Remove these instructions |
|---------------------|---------------------------|
| Is TypeScript-only | `java.instructions.md`, `java-junit-api.instructions.md`, `java-swing.instructions.md`, `playwright-java.instructions.md` |
| Is Java-only | `playwright-typescript.instructions.md`, `python.instructions.md` |
| Has no Swing | `java-swing.instructions.md` |
| Has no Docker | `docker.instructions.md` |

#### 1.4 Generate Project AGENTS.md

```
# In VS Code Copilot Chat:
@workspace Use the create-project-agents-md prompt to generate an AGENTS.md for this project
```

This creates an optimized AGENTS.md (<10KB) tailored to your project's tech stack.

---

### Phase 2: Day-to-Day Operations

#### 2.1 Onboard a New Target

**When:** You have a new API, web app, or Swing app to test.

```
Step 1: Gather source documents (specs, stories, wireframes)
Step 2: In Copilot Chat, invoke the context-ingestion prompt
Step 3: Review the generated context pack in context/targets/<target>/
Step 4: Confirm the README.md has correct prerequisites and assumptions
```

**Outputs:** `context/targets/<target>/README.md`, `provenance.json`, normalized docs

#### 2.2 Generate Tests

**API Tests:**
```
# In Copilot Chat:
@workspace Use generate-api-test-pack for target: <target-name>
  Spec: path/to/openapi.yaml
  Auth: bearer token from env var API_TOKEN
  Language: TypeScript (default)
```

**Web UI Tests:**
```
# In Copilot Chat:
@workspace Use generate-web-test-pack for target: <target-name>
  Base URL: https://app.example.com
  Flows: login, search, checkout
  Language: TypeScript (default)
```

**Both generate:**
- BDD feature files in `tests/{api|web}/bdd/`
- Runnable Playwright tests in `tests/{api|web}/`
- Evidence configuration (traces, screenshots on failure)

#### 2.3 Validate Artifacts

```
# In Copilot Chat:
@workspace Use validation-evidence prompt for target: <target-name>
```

This validates:
- BDD feature syntax
- TypeScript/Java compilation
- BDD-to-test traceability (every scenario has a matching test)
- No hardcoded secrets

**Output:** Validation report + evidence manifest

#### 2.4 Execute Tests Locally

```powershell
# API tests (Playwright TypeScript)
npx playwright test tests/api/ --reporter=junit

# Web UI tests (Playwright TypeScript)
npx playwright test tests/web/ --reporter=html

# Java tests
mvn test -pl tests -Dtest="*Test" -Dsurefire.reportsDirectory=reports/
```

#### 2.5 Review & Heal Failures

**For test failures after known changes:**
```
# In Copilot Chat:
@workspace Use self-healing prompt
  Failure: tests/web/login.spec.ts - locator changed
  Evidence: reports/web/artifacts/login-trace.zip
```

Self-healing is bounded:
- Only locator drift, timeout, data mismatch, or environment issues
- Must be deterministic and reviewable
- Produces `reports/healing/` with before/after diffs

**For human review:**
```
# In Copilot Chat:
@workspace Use create-review-packet for this PR
```

**Output:** `review-packets/<id>/` with SUMMARY, ASSUMPTIONS, VALIDATION, CHECKLIST

#### 2.6 TDD Workflow (For New Features)

Use the three TDD agents in sequence:

| Phase | Agent | What It Does |
|-------|-------|--------------|
| Red | `@workspace /tdd-red` | Writes failing tests describing desired behavior |
| Green | `@workspace /tdd-green` | Writes minimal implementation to pass tests |
| Refactor | `@workspace /tdd-refactor` | Improves quality while keeping tests green |

---

### Phase 3: Pipeline Integration (Azure DevOps)

#### 3.1 Generate Pipeline Templates

```
# In Copilot Chat:
@workspace Use ado-pipelines-governance prompt
  Pipeline: my-app-tests
  Gate: all smoke tests must pass before deploy
  QP: publish evidence to Quality Passport
```

**Output:** `pipelines/ado/` with YAML templates

#### 3.2 Reference Pipeline Architecture

```yaml
# pipelines/ado/test-pipeline.yml
stages:
  - stage: Generate
    displayName: 'Generate Test Artifacts'
    jobs:
      - job: GenerateTests
        steps:
          # Context ingestion has already been done; artifacts are in repo
          - script: echo "Tests already generated and committed"

  - stage: Validate
    displayName: 'Validate Artifacts'
    dependsOn: Generate
    jobs:
      - job: ValidateArtifacts
        steps:
          - task: NodeTool@0
            inputs: { versionSpec: '18.x' }
          - script: |
              npm ci
              npx tsc --noEmit                    # TypeScript compile check
              npx playwright test --list          # Verify tests are loadable
            displayName: 'Compile & lint check'

  - stage: Execute
    displayName: 'Execute Tests'
    dependsOn: Validate
    jobs:
      - job: RunSmoke
        displayName: 'Smoke Tests (Gating)'
        steps:
          - script: |
              npx playwright install --with-deps chromium
              npx playwright test --grep @smoke --reporter=junit
            displayName: 'Run smoke suite'
          - task: PublishTestResults@2
            inputs:
              testResultsFiles: '**/test-results/*.xml'
              testRunTitle: 'Smoke Tests'

      - job: RunRegression
        displayName: 'Regression Tests (Non-Gating)'
        dependsOn: RunSmoke
        condition: succeeded()
        steps:
          - script: |
              npx playwright install --with-deps
              npx playwright test --grep @regression --reporter=junit,html
            displayName: 'Run regression suite'
          - task: PublishTestResults@2
            inputs:
              testResultsFiles: '**/test-results/*.xml'
              testRunTitle: 'Regression Tests'
          - publish: $(System.DefaultWorkingDirectory)/playwright-report
            artifact: playwright-report

  - stage: Publish
    displayName: 'Publish Evidence'
    dependsOn: Execute
    jobs:
      - job: PackageEvidence
        steps:
          - script: |
              # Package evidence bundle per evidence-manifest.schema.json
              node scripts/package-evidence.js \
                --target $(TARGET_NAME) \
                --runId $(Build.BuildId) \
                --results test-results/ \
                --artifacts playwright-report/
            displayName: 'Package evidence bundle'
          - publish: $(System.DefaultWorkingDirectory)/reports/bundles
            artifact: evidence-bundle

  - stage: Gate
    displayName: 'Quality Gate'
    dependsOn: Publish
    jobs:
      - job: QualityGate
        steps:
          - script: |
              # Validate evidence manifest against schema
              # Check smoke pass rate >= threshold
              # Publish to Quality Passport if configured
              node scripts/quality-gate.js \
                --manifest reports/bundles/$(Build.BuildId)/manifest.json \
                --threshold 100    # All smoke tests must pass
            displayName: 'Enforce quality gate'
```

#### 3.3 Pipeline Stages Mapped to Skills

| ADO Stage | Skill | What Happens |
|-----------|-------|-------------|
| **Generate** | `context-ingestion` + `*-test-generation` | Typically done pre-pipeline (artifacts committed). In fully automated mode, can be triggered by spec changes. |
| **Validate** | `validation-evidence` | Compile check, lint, BDD traceability, schema validation |
| **Execute** | (Playwright/JUnit runner) | Run tests, collect JUnit XML + traces + screenshots |
| **Publish** | `validation-evidence` | Package evidence bundle per `evidence-manifest.schema.json` |
| **Gate** | `ado-pipelines-governance` | Enforce pass thresholds, publish to Quality Passport |

#### 3.4 Test Tagging for Pipeline Control

| Tag | Pipeline Behavior |
|-----|-------------------|
| `@smoke` | Runs in every build. Failures block the pipeline. |
| `@gating` | Same as smoke — must pass for deployment. |
| `@regression` | Runs after smoke passes. Failures are reported but don't block. |
| `@non-gating` | Tracked/reported only. Known flaky or WIP tests. |

Configure in `playwright.config.ts`:
```typescript
// Run only smoke tests in CI gating
export default defineConfig({
  grep: process.env.CI_GATING ? /@smoke/ : undefined,
  // ...
});
```

---

### Phase 4: Ongoing Maintenance

#### 4.1 Contract Drift Detection (API)

When API specs change:
1. Re-run `generate-api-test-pack` with the updated spec
2. Compare the new contract snapshot against `tests/api/contracts/`
3. Review the drift report at `tests/api/reports/drift-report.md`
4. Update baselines intentionally — never auto-update

#### 4.2 Self-Healing After UI Changes

When UI changes break web tests:
1. Collect failure evidence (traces, screenshots)
2. Run self-healing prompt with the failure diagnostics
3. Review the proposed patch in `generated/repairs/`
4. If repair is valid: apply and re-run. If not: manual fix.

**Self-healing boundaries:**
- Allowed: locator updates, timeout adjustments, data fixture changes
- Not allowed: changing test assertions, adding `waitForTimeout`, disabling tests

#### 4.3 Updating Skills Across Teams

```powershell
# If using submodule
cd .github/shared-skills
git pull origin main

# If using install script
pwsh /path/to/skills-repo/scripts/install.ps1 -TargetProject .

# If using npx
npx skills update
```

**Breaking change notice:** If `selenium-java.instructions.md` exists locally, delete it:
```powershell
Remove-Item .github/instructions/selenium-java.instructions.md -ErrorAction SilentlyContinue
```

---

### Quick Reference Card

| Task | Command / Prompt |
|------|-----------------|
| Install skills | `pwsh scripts/install.ps1 -TargetProject .` |
| Onboard target | `@workspace /context-ingestion` |
| Generate API tests | `@workspace /generate-api-test-pack` |
| Generate Web tests | `@workspace /generate-web-test-pack` |
| Generate Swing tests | `@workspace /generate-swing-test-pack` |
| Validate artifacts | `@workspace /validation-evidence` |
| Run smoke tests | `npx playwright test --grep @smoke` |
| Run full regression | `npx playwright test` |
| Heal failures | `@workspace /self-healing` |
| Create review packet | `@workspace /create-review-packet` |
| Generate AGENTS.md | `@workspace /create-project-agents-md` |
| TDD Red phase | `@workspace /tdd-red` |
| TDD Green phase | `@workspace /tdd-green` |
| TDD Refactor phase | `@workspace /tdd-refactor` |

---

### Appendix: Evidence Manifest Schema

Every pipeline run should produce an evidence manifest conforming to `schemas/evidence-manifest.schema.json`:

```json
{
  "target": "my-api",
  "runId": "2026-02-19-143022",
  "timestamp": "2026-02-19T14:30:22Z",
  "stages": ["validate", "execute", "publish"],
  "testResults": {
    "total": 42,
    "passed": 40,
    "failed": 1,
    "skipped": 1
  },
  "artifacts": {
    "junit": "reports/test-results/results.xml",
    "html": "reports/playwright-report/index.html",
    "screenshots": "reports/web/artifacts/",
    "traces": "reports/web/artifacts/",
    "logs": "reports/logs/"
  },
  "environment": {
    "framework": "Playwright",
    "language": "TypeScript",
    "browser": "chromium",
    "runner": "ADO Pipeline"
  },
  "provenance": {
    "source": "context/targets/my-api/",
    "generatedBy": "ai-testing-framework v2026.02.19",
    "generatedAt": "2026-02-19T14:00:00Z",
    "contextPack": "context/targets/my-api/provenance.json"
  },
  "governance": {
    "qualityPassportStatus": "pass",
    "gateInputs": ["smoke-results.xml", "regression-results.xml"],
    "retentionPolicy": "90-days"
  }
}
```
