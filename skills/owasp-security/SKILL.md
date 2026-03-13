---
name: owasp-security
description: 'Secure-by-build guidance using OWASP Top 10 for code review, design review, and test planning. Use for identifying common risks and adding preventive controls.'
metadata:
  author: ai-testing-framework
  version: "2026.02.18"
---

# OWASP Security (Cross-Cutting)

## Quick Reference
- **Trigger:** Code review; design review; test planning; security audit
- **Inputs:** Code/config under review
- **Outputs:** Guidance only (no generated files)
- **Language:** Language-agnostic
- **Pipeline stage:** All (cross-cutting)
- **Prerequisite:** None

## What this skill does
Provides secure-by-build guidance based on OWASP Top 10, applicable during code review, design review, and test planning.

## When to use
- Code review with security focus
- Design review for new features
- Test planning to identify security test cases
- Any time secrets, auth, or input handling is involved

## Guidance areas

### Secrets management
- Never hardcode credentials, API keys, or tokens
- Use environment variables or approved secret stores
- Audit logs for credential access

### Input validation
- Validate and sanitize all user inputs
- Use parameterized queries (never string concatenation for SQL)
- Validate file uploads (type, size, content)

### Authentication & authorization
- Verify authentication before accessing resources
- Check authorization for every action
- Use established libraries (never roll your own crypto)

### Injection prevention
- SQL injection: parameterized queries only
- XSS: output encoding, content security policy
- SSRF: validate/whitelist URLs, block internal addresses
- Command injection: avoid shell execution with user input

### Dependency security
- Check for known vulnerabilities in dependencies
- Keep dependencies up to date
- Use lockfiles for reproducible builds

### Error handling
- Never expose stack traces or internal details to users
- Log errors with context for debugging
- Fail securely (deny by default)

## Validation
- No hardcoded secrets in code or config
- Input validation present for user-facing entry points
- Parameterized queries for all database access
- Dependencies scanned for known vulnerabilities

## Edge cases
- Legacy code with known vulnerabilities: document and create remediation plan
- Third-party integrations: verify their security posture separately
