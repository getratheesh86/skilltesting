---
description: 'Azure DevOps pipeline conventions covering required stage order, machine-readable results, secrets handling, and schema versioning'
applyTo: 'pipelines/**/*.yml, pipelines/**/*.yaml'
---

# ADO Pipeline Conventions

## Required Stage Order

Every test/quality pipeline must follow this five-stage sequence:

```
Generate → Validate → Execute → Publish → Gate
```

### Stage Definitions

| Stage | Purpose | Required Outputs |
|-------|---------|-----------------|
| **Generate** | Produce test artifacts from context packs | Test files, generation manifest |
| **Validate** | Verify artifacts are well-formed before execution | Validation report (pass/fail per artifact) |
| **Execute** | Run tests and capture results | JUnit XML, traces, screenshots, logs |
| **Publish** | Package results into evidence bundles | Evidence bundle (ZIP), summary report |
| **Gate** | Enforce quality thresholds; block or approve progression | Gate decision (pass/fail), reasons |

### Pipeline Template

```yaml
trigger:
  branches:
    include:
      - main
      - release/*

pool:
  vmImage: 'ubuntu-latest'

stages:
  - stage: Generate
    displayName: 'Generate Test Artifacts'
    jobs:
      - job: GenerateTests
        steps:
          - script: echo "Generate tests from context packs"
          - publish: $(Build.ArtifactStagingDirectory)/generated
            artifact: generated-tests

  - stage: Validate
    displayName: 'Validate Artifacts'
    dependsOn: Generate
    jobs:
      - job: ValidateArtifacts
        steps:
          - download: current
            artifact: generated-tests
          - script: echo "Validate artifact structure and schemas"
          - publish: $(Build.ArtifactStagingDirectory)/validation
            artifact: validation-report

  - stage: Execute
    displayName: 'Execute Tests'
    dependsOn: Validate
    jobs:
      - job: RunTests
        steps:
          - download: current
            artifact: generated-tests
          - script: echo "Run test suites"
          - task: PublishTestResults@2
            inputs:
              testResultsFormat: 'JUnit'
              testResultsFiles: '**/test-results/*.xml'
          - publish: $(Build.ArtifactStagingDirectory)/execution
            artifact: execution-results

  - stage: Publish
    displayName: 'Publish Evidence'
    dependsOn: Execute
    jobs:
      - job: PackageEvidence
        steps:
          - download: current
            artifact: execution-results
          - script: echo "Package evidence bundle"
          - publish: $(Build.ArtifactStagingDirectory)/evidence
            artifact: evidence-bundle

  - stage: Gate
    displayName: 'Quality Gate'
    dependsOn: Publish
    jobs:
      - job: EvaluateGate
        steps:
          - download: current
            artifact: evidence-bundle
          - script: echo "Evaluate quality thresholds"
```

## Machine-Readable Results

- Always emit **JUnit XML** for test results
- Publish results via `PublishTestResults@2` task
- Include diagnostics as pipeline artifacts:
  - Screenshots and traces (for UI tests)
  - Request/response logs (for API tests)
  - Component tree dumps (for Swing tests)

```yaml
- task: PublishTestResults@2
  displayName: 'Publish Test Results'
  inputs:
    testResultsFormat: 'JUnit'
    testResultsFiles: '**/test-results/**/*.xml'
    mergeTestResults: true
    failTaskOnFailedTests: true

- publish: $(Build.ArtifactStagingDirectory)/diagnostics
  artifact: test-diagnostics
  condition: always()  # Publish diagnostics even on failure
```

## No Secrets in Logs

- **Never** echo, print, or log secrets, tokens, or credentials
- Use ADO secret variables (`$(SECRET_NAME)`) or Key Vault references
- Mark variables as secret: `isSecret: true`
- Mask secrets in script output using `##vso[setVariable]`

```yaml
variables:
  - name: API_KEY
    value: $(api-key-from-keyvault)  # Pulled from Key Vault
    isSecret: true

steps:
  - script: |
      # ❌ BAD — leaks secret
      echo "Using key: $API_KEY"
      
      # ✅ GOOD — use without echoing
      curl -H "Authorization: Bearer $API_KEY" https://api.example.com/health
    env:
      API_KEY: $(API_KEY)
```

## Schema Versioning

- Define a `schemaVersion` field in pipeline manifest files
- Increment the version when changing artifact format, stage structure, or gate criteria
- Validate schema version at the start of each stage

```yaml
variables:
  schemaVersion: '2.1'

steps:
  - script: |
      EXPECTED_VERSION="2.1"
      ACTUAL_VERSION=$(cat manifest.json | jq -r '.schemaVersion')
      if [ "$ACTUAL_VERSION" != "$EXPECTED_VERSION" ]; then
        echo "##vso[task.logissue type=error]Schema version mismatch: expected $EXPECTED_VERSION, got $ACTUAL_VERSION"
        exit 1
      fi
    displayName: 'Validate Schema Version'
```

## Additional Best Practices

- Use **templates** for reusable stage/job definitions
- Use **conditions** to skip stages when prerequisites fail
- Set `timeoutInMinutes` on long-running jobs
- Use `dependsOn` with `condition: succeeded()` to enforce stage ordering
- Tag builds with metadata: schema version, commit SHA, test count

```yaml
- script: |
    echo "##vso[build.addbuildtag]schema-v$(schemaVersion)"
    echo "##vso[build.addbuildtag]tests-$(TEST_COUNT)"
  displayName: 'Tag Build'
```
