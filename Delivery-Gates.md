# Delivery Gates — Customer Collaboration Checkpoints

**Version:** 1.0 — March 2026
**Purpose:** Enumerate every gate where the delivery team must **confirm or collaborate** with the customer before proceeding. Gates are organized by functional area and mapped to the sprint where they must be cleared.

---

## How to Read This Document

- **STOP gate** = delivery cannot proceed past this point without customer action. Work is blocked.
- **CONFIRM gate** = delivery team proposes; customer validates/approves before work is consumed downstream.
- **REVIEW gate** = customer reviews output; feedback incorporated before next sprint. Does not block other streams.

---

## 1. Context Ingestion (Foundation — All Streams Depend on This)

Context packs are the prerequisite for every generation skill. If context is wrong or incomplete, all downstream artifacts are wrong.

| # | Gate | Type | Sprint | What We Need From Customer | What We Deliver for Review |
|---|------|------|--------|---------------------------|---------------------------|
| CI-1 | **Target Application Nomination** | STOP | 0 | Name, owner (business + technical), repo links, branch, run instructions for each of the **2 demo apps** and **12 artifact apps**. Prioritized list. | Target nomination template (pre-filled where possible) |
| CI-2 | **Source Document Handoff** | STOP | 0 | Specs (OpenAPI/Swagger/GraphQL), user stories, design docs, runbooks, existing test suites — per target. Must be current versions. | Source inventory checklist per target |
| CI-3 | **Context Pack Review** | CONFIRM | 0 | Customer SME reviews the normalized context pack (`context/targets/<target>/README.md`) and confirms: completeness, accuracy, no missing flows, redaction is correct. | Normalized context pack + provenance manifest |
| CI-4 | **Context Refresh Trigger** | REVIEW | 1–2 | Customer notifies when source docs change (spec updates, story revisions). Defines who owns the "source of truth" for each target. | Updated context pack delta + provenance diff |

### Stop-the-Line

> If CI-1 or CI-2 are not cleared by end of Sprint 0 Week 1, no generation work can begin. The entire delivery schedule shifts.

---

## 2. API Test Generation

| # | Gate | Type | Sprint | What We Need From Customer | What We Deliver for Review |
|---|------|------|--------|---------------------------|---------------------------|
| API-1 | **Spec Completeness Confirmation** | STOP | 0 | Confirm spec format (OpenAPI 3.x / Swagger 2.0 / GraphQL SDL), version, and that it reflects current production behavior. Flag any known spec-vs-implementation drift. | Spec gap analysis report |
| API-2 | **Auth Strategy Agreement** | STOP | 0 | Auth method (OIDC, PAT, client credentials, mTLS), how credentials are provisioned for CI, rotation expectations. Service account or test identity. | Auth integration pattern doc |
| API-3 | **Environment Endpoint Confirmation** | STOP | 1 | Stable test environment URL(s), network access from CI runners, any gateway/proxy requirements, rate limits. | Environment config template (populated) |
| API-4 | **BDD Scenario Review** | CONFIRM | 1 | Customer SME reviews generated BDD Gherkin scenarios for the 2 demo APIs. Confirms: coverage of critical paths, acceptance criteria alignment, boundary/negative case completeness. | BDD feature files + traceability matrix |
| API-5 | **Mock Strategy Agreement** | CONFIRM | 1 | For external dependencies and databases: confirm which deps are mocked vs live, who owns mock data, and how mocks are maintained. | Mock strategy doc + stub inventory |
| API-6 | **Contract Baseline Sign-off** | CONFIRM | 1 | Customer accepts the contract snapshot as the drift-detection baseline. Future spec changes are measured against this. | Contract snapshot + drift detection report |
| API-7 | **Execution Results Review** | REVIEW | 1 | Customer reviews execution reports (JUnit XML, HTML summary) for the 2 demo APIs. Feedback on failures, false positives, missing assertions. | Execution evidence bundle |
| API-8 | **Pipeline Integration Validation** | CONFIRM | 2 | Customer confirms pipeline YAML works in their ADO environment, Quality Passport gate receives expected artifacts. | Pipeline template + gate config + dry-run output |

---

## 3. Web UI Test Generation (Playwright)

| # | Gate | Type | Sprint | What We Need From Customer | What We Deliver for Review |
|---|------|------|--------|---------------------------|---------------------------|
| WEB-1 | **UI Flow Identification** | CONFIRM | 0 | Customer identifies critical user flows per demo target (login, search, CRUD operations, etc.). Provides flow descriptions or walkthroughs. | Flow inventory per target |
| WEB-2 | **Test Account Provisioning** | STOP | 1 | Stable test accounts (credentials, roles, permissions) for each demo environment. Accounts must not expire mid-sprint. | Test account requirements doc |
| WEB-3 | **Environment Stability Confirmation** | STOP | 1 | Stable test environment URL, deployment schedule (no deployments during test windows without notice), network access from CI runners. | Environment stability agreement |
| WEB-4 | **Locator Strategy Agreement** | CONFIRM | 1 | Customer confirms whether apps have `data-testid` attributes, accessible roles/labels, or if we must rely on CSS/XPath. Agreement on locator priority: role → label → testid → CSS. | Locator audit per target app |
| WEB-5 | **Browser Matrix Confirmation** | CONFIRM | 1 | Confirm which browsers are in scope: Chrome, Firefox, Edge, Safari. **Safari requires macOS runners** — customer must confirm availability or explicitly exclude. | Browser matrix doc with runner requirements |
| WEB-6 | **BDD Scenario Review** | CONFIRM | 2 | Customer SME reviews generated BDD Gherkin scenarios for web UI flows. Confirms: flow coverage, step accuracy, edge cases. | BDD feature files + flow traceability |
| WEB-7 | **Execution Results Review** | REVIEW | 2 | Customer reviews Playwright execution reports (traces, screenshots, HTML report) for the 2 demo apps. Feedback on failures, flaky tests, missing flows. | Execution evidence bundle with traces |
| WEB-8 | **Self-Healing Baseline Agreement** | CONFIRM | 2 | Customer agrees on what constitutes a "healed" test vs a test that needs human intervention. Defines healing success threshold (SOW says >70%). | Healing rule registry + classification doc |

---

## 4. Swing UI Test Generation

| # | Gate | Type | Sprint | What We Need From Customer | What We Deliver for Review |
|---|------|------|--------|---------------------------|---------------------------|
| SW-1 | **Component Identity Strategy** | STOP | 0 | Customer confirms: (a) whether Swing components have stable `name` properties or accessible identifiers, (b) willingness to add naming conventions or instrumentation if missing, (c) who owns the identity policy decision. | Identity feasibility assessment template |
| SW-2 | **Automation Driver Selection** | STOP | 0 | Customer confirms automation approach (AssertJ-Swing, FEST, SikuliX, custom driver) and any licensing/procurement constraints. Confirm headless/CI feasibility. | Driver comparison matrix |
| SW-3 | **Application Build Access** | STOP | 0 | Customer provides: runnable Swing app JAR/build, launch instructions, dependency list. Delivery team must be able to launch and inspect the component tree. | Build verification report |
| SW-4 | **GUI Runner Availability** | STOP | 1 | Customer confirms CI runner with GUI capability (desktop VM, virtual framebuffer, remote desktop). Headless Swing requires specific Xvfb or equivalent config. | Runner requirements + validation test |
| SW-5 | **Component Tree Walkthrough** | CONFIRM | 1 | Joint session: delivery team demonstrates enumerated component tree; customer SME confirms component identification accuracy and flow coverage. | Component tree snapshot + identity mapping |
| SW-6 | **Feasibility Gate Decision** | STOP | 1 | Customer and delivery team jointly decide: proceed with Swing automation (prerequisites met) or document boundary and replan. This is a **binary go/no-go**. | Feasibility decision record (evidence-backed) |
| SW-7 | **BDD Scenario Review** | CONFIRM | 2 | Customer SME reviews generated Swing BDD scenarios for the 2 demo apps (if feasibility gate passed). | BDD feature files + identity policy doc |
| SW-8 | **Self-Healing Measurement Agreement** | CONFIRM | 2 | Customer agrees on: what changes are "healable" (renamed component, layout shift, new field) vs. structural redesign. SOW says >90% — must be bounded to specific change classes. | Healing classification matrix |

### Swing-Specific Escalation Path

> If SW-1 reveals no stable component identity and customer cannot instrument, **Swing self-healing claims are not credible**. The delivery team must document this at SW-6 and propose a replan (artifact-only delivery, instrumentation backlog, or scope reduction).

---

## 5. Test Data Management

| # | Gate | Type | Sprint | What We Need From Customer | What We Deliver for Review |
|---|------|------|--------|---------------------------|---------------------------|
| TD-1 | **Data Provisioning Mechanism** | STOP | 0 | Customer confirms: how test data is created (API seed, DB seed, fixture files). Who owns the data schema? Are there data governance restrictions? | Data provisioning assessment |
| TD-2 | **Isolation & Cleanup Agreement** | CONFIRM | 1 | Customer confirms: per-run isolation model (namespace, tenant, user), cleanup/reset procedure, teardown ownership. Data must not leak between runs. | Data contract (setup/exercise/teardown) |
| TD-3 | **Sensitive Data Policy** | STOP | 0 | Customer confirms: any PII/sensitive data in test datasets. Redaction requirements. Synthetic data generation approval. | Data sensitivity assessment |
| TD-4 | **Data Contract Sign-off** | CONFIRM | 1 | Customer SME reviews data contracts per target and confirms: schema accuracy, seed data validity, cleanup procedure correctness. | Data contracts (JSON/YAML) per target |
| TD-5 | **Production Data Boundary** | STOP | 0 | Explicit written confirmation that test data environments are isolated from production. No production data used without approval and redaction. | Environment isolation confirmation doc |

---

## 6. ADO Pipeline & Governance Integration

| # | Gate | Type | Sprint | What We Need From Customer | What We Deliver for Review |
|---|------|------|--------|---------------------------|---------------------------|
| PL-1 | **ADO Project Access** | STOP | 0 | Customer provides: ADO organization URL, project name, service connection permissions, pipeline creation rights. | Access verification checklist |
| PL-2 | **Quality Passport Integration Details** | CONFIRM | 0 | Customer provides: QP gate schema, required artifact formats, QP API or webhook details, expected attestation fields. | QP integration requirements doc |
| PL-3 | **Secret Management Agreement** | STOP | 0 | Customer confirms: secret store approach (Key Vault, ADO variable groups, GitHub secrets), injection pattern into pipelines, who owns rotation. | Secret management pattern doc |
| PL-4 | **Pipeline Template Review** | CONFIRM | 1 | Customer reviews pipeline YAML (Generate → Validate → Execute → Publish → Gate) and confirms: stage naming, trigger conventions, artifact publishing paths work in their ADO environment. | Pipeline YAML templates + dry-run log |
| PL-5 | **Governance Gate Criteria** | CONFIRM | 2 | Customer confirms: what conditions must pass for the governance gate to approve (all tests pass? coverage threshold? evidence bundle complete?). | Gate criteria doc + pass/fail examples |
| PL-6 | **Pipeline Production Handoff** | REVIEW | 2 | Customer confirms: final pipeline templates are production-ready, integrated with their existing CI/CD, and owned by their team post-engagement. | Final pipeline package + handoff doc |

---

## 7. Self-Healing (Cross-Cutting)

| # | Gate | Type | Sprint | What We Need From Customer | What We Deliver for Review |
|---|------|------|--------|---------------------------|---------------------------|
| SH-1 | **Change Class Definition** | CONFIRM | 1 | Customer agrees on classification of changes: spec drift, selector rename, layout shift, new field, structural redesign. Which classes are "auto-healable" vs require human review. | Change classification matrix |
| SH-2 | **Healing Success Criteria** | CONFIRM | 1 | Customer agrees on measurement: what counts as a "healed" test? Re-run passes after repair? Diff is reviewable? SOW thresholds: API (implicit), Web (>70%), Swing (>90%). | Healing measurement framework |
| SH-3 | **Repair Review Workflow** | CONFIRM | 2 | Customer confirms: who reviews repair diffs before they merge? Auto-merge allowed for safe classes? PR-based review for others? | Repair workflow agreement |

---

## 8. Unified Platform & Orchestration

| # | Gate | Type | Sprint | What We Need From Customer | What We Deliver for Review |
|---|------|------|--------|---------------------------|---------------------------|
| UP-1 | **Interface Preference** | CONFIRM | 1 | Customer confirms preferred interface for orchestration: CLI-only, API-only, web dashboard, or combination. Drives build scope. | Interface options brief |
| UP-2 | **Reporting Requirements** | CONFIRM | 1 | Customer confirms: report formats (HTML, PDF, JUnit XML), dashboard metrics (pass rate, coverage, healing rate, execution time), export requirements. | Report template mockups |
| UP-3 | **Config Management Model** | CONFIRM | 2 | Customer confirms: how environment configs, browser configs, and target lists are managed (repo-based, env vars, config service). | Config management pattern doc |
| UP-4 | **12-App Artifact Acceptance Criteria** | CONFIRM | 2 | Customer confirms: what makes a reviewable artifact "accepted" for the 12 additional apps? Template conformance? SME sign-off? Completeness threshold? | Acceptance criteria doc per app type |

---

## 9. Security & Compliance (Cross-Cutting)

| # | Gate | Type | Sprint | What We Need From Customer | What We Deliver for Review |
|---|------|------|--------|---------------------------|---------------------------|
| SEC-1 | **RBAC Model** | CONFIRM | 0 | Customer confirms: role-based access model for the platform (who can generate, execute, review, publish). | RBAC requirements doc |
| SEC-2 | **Credential Encryption** | STOP | 0 | Customer confirms: encrypted credential storage approach and that no secrets are stored in plaintext in repos or pipelines. | Credential management verification |
| SEC-3 | **Network Access & Egress** | STOP | 0 | Customer confirms: CI runner network access to test environments, any firewall/proxy rules, egress restrictions that could block Playwright browser downloads or API calls. | Network requirements checklist |
| SEC-4 | **Audit Trail Requirements** | CONFIRM | 2 | Customer confirms: what audit trail is required for generated artifacts and execution results. Retention period, immutability, compliance tagging. | Audit trail design doc |

---

## Gate Summary — Sprint Timeline View

```
Sprint 0 (Foundations)
├── STOP:    CI-1, CI-2, API-1, API-2, SW-1, SW-2, SW-3, TD-1, TD-3, TD-5,
│            PL-1, PL-3, SEC-1, SEC-2, SEC-3
├── CONFIRM: CI-3, WEB-1, PL-2, SW-1 (identity)

Sprint 1 (API Demo + Swing Feasibility)
├── STOP:    API-3, WEB-2, WEB-3, SW-4, SW-6 (feasibility go/no-go)
├── CONFIRM: API-4, API-5, API-6, WEB-4, WEB-5, SW-5, TD-2, TD-4,
│            PL-4, SH-1, SH-2, UP-1, UP-2
├── REVIEW:  API-7, CI-4

Sprint 2 (Web UI Demo + Scale + Harden)
├── CONFIRM: WEB-6, WEB-8, SW-7, SW-8, PL-5, SH-3, UP-3, UP-4, SEC-4
├── REVIEW:  WEB-7, API-8, PL-6
```

---

## Gate Dependency Chain (Critical Path)

```
CI-1 (targets named)
 └→ CI-2 (sources handed off)
     └→ CI-3 (context pack reviewed)
         ├→ API-1 → API-2 → API-3 → API-4 → API-7
         ├→ WEB-1 → WEB-2 → WEB-3 → WEB-4 → WEB-6 → WEB-7
         └→ SW-1 → SW-2 → SW-3 → SW-4 → SW-5 → SW-6 (binary go/no-go)
                                                    ├→ GO: SW-7 → SW-8
                                                    └→ NO-GO: replan

PL-1 (ADO access) → PL-3 (secrets) → PL-4 (template review) → PL-5 (gate criteria) → PL-6 (handoff)

TD-1 (provisioning) → TD-3 (sensitive data) → TD-5 (isolation) → TD-2 (cleanup) → TD-4 (contract sign-off)
```

---

## Customer Responsibility Summary

| Sprint | Customer Must Deliver | Count |
|--------|----------------------|-------|
| Sprint 0 | Target nominations, source docs, auth strategy, ADO access, secrets approach, Swing builds, data provisioning model, network access, RBAC model | 15 STOP + CONFIRM gates |
| Sprint 1 | Test environments, test accounts, feasibility decision, BDD reviews, mock strategy, data contracts, pipeline review, browser matrix | 14 STOP + CONFIRM gates |
| Sprint 2 | Artifact acceptance criteria, healing agreements, pipeline handoff, audit requirements, 12-app source context | 10 CONFIRM + REVIEW gates |
