---
description: 'OWASP baseline security practices covering secrets management, input validation, parameterized queries, auth/authz, dependency scanning, and audit logging'
applyTo: '**'
---

# OWASP Security Baseline

## No Hardcoded Secrets

Never embed credentials, API keys, tokens, or connection strings in source code.

```java
// ❌ BAD
private static final String DB_PASSWORD = "s3cret!";
String apiKey = "sk_live_abc123xyz789";

// ✅ GOOD
private static final String DB_PASSWORD = System.getenv("DB_PASSWORD");
String apiKey = System.getenv("API_KEY");
```

```python
# ❌ BAD
API_KEY = "sk_live_abc123xyz789"

# ✅ GOOD
import os
API_KEY = os.environ["API_KEY"]
```

- Store secrets in environment variables, a vault (Azure Key Vault, HashiCorp Vault), or CI/CD secret variables
- Use `.env` files for local development only — always add `.env` to `.gitignore`
- Rotate secrets on a regular schedule and after any suspected breach

## Input Validation

Validate all inputs at the boundary — never trust user-supplied data.

- **Allowlist** over denylist: define what is acceptable, reject everything else
- Validate type, length, format, and range
- Sanitize before use in HTML, SQL, file paths, or shell commands

```java
// ✅ GOOD — validate early
public void createUser(String email, int age) {
    if (email == null || !EMAIL_PATTERN.matcher(email).matches()) {
        throw new ValidationException("Invalid email format");
    }
    if (age < 0 || age > 150) {
        throw new ValidationException("Age must be between 0 and 150");
    }
    // proceed
}
```

```python
# ✅ GOOD
from pydantic import BaseModel, EmailStr, Field

class CreateUserRequest(BaseModel):
    email: EmailStr
    age: int = Field(ge=0, le=150)
```

## Parameterized Queries

Never construct SQL queries with string concatenation or interpolation.

```java
// ❌ BAD — SQL injection
String query = "SELECT * FROM users WHERE email = '" + email + "'";

// ✅ GOOD — parameterized
PreparedStatement stmt = conn.prepareStatement(
    "SELECT * FROM users WHERE email = ?"
);
stmt.setString(1, email);
```

```python
# ❌ BAD
cursor.execute(f"SELECT * FROM users WHERE email = '{email}'")

# ✅ GOOD
cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
```

```typescript
// ❌ BAD
const query = `SELECT * FROM users WHERE email = '${email}'`;

// ✅ GOOD (with a query builder or ORM)
const user = await db.query('SELECT * FROM users WHERE email = $1', [email]);
```

## Authentication and Authorization

- Verify authentication on every request that accesses protected resources
- Implement authorization checks at the service/business layer, not just the UI
- Use established frameworks (Spring Security, Passport.js, FastAPI dependencies)
- Enforce principle of least privilege

```java
// ✅ GOOD — check authorization in service layer
public Order getOrder(String orderId, UserContext currentUser) {
    Order order = orderRepository.findById(orderId)
        .orElseThrow(() -> new OrderNotFoundException(orderId));
    
    if (!order.getOwnerId().equals(currentUser.getUserId()) 
            && !currentUser.hasRole("ADMIN")) {
        throw new AccessDeniedException("Not authorized to view this order");
    }
    return order;
}
```

## Role-Based Access Control (RBAC)

- Define roles with minimum required permissions
- Never grant blanket admin access for convenience
- Review and audit role assignments periodically
- Log all privilege escalation events

## Dependency Scanning

- Scan dependencies for known vulnerabilities in every CI build
- Use tools: OWASP Dependency-Check, Snyk, GitHub Dependabot, npm audit, pip-audit
- Block merges when CRITICAL or HIGH vulnerabilities are detected
- Update dependencies regularly — do not let vulnerability debt accumulate

```yaml
# ADO pipeline step
- script: |
    npm audit --audit-level=high
  displayName: 'Check npm Dependencies'

# Or for Python
- script: |
    pip-audit --strict
  displayName: 'Check Python Dependencies'
```

## Error Handling (No Stack Traces Exposed)

- Return generic error messages to clients
- Log detailed errors (including stack traces) server-side only
- Never return internal paths, class names, or database details in API responses

```java
// ❌ BAD — leaks internal details
@ExceptionHandler(Exception.class)
public ResponseEntity<String> handleError(Exception e) {
    return ResponseEntity.status(500).body(e.toString());
}

// ✅ GOOD — generic message to client, details in logs
@ExceptionHandler(Exception.class)
public ResponseEntity<ErrorResponse> handleError(Exception e) {
    log.error("Unhandled exception", e);
    return ResponseEntity.status(500)
        .body(new ErrorResponse("INTERNAL_ERROR", "An unexpected error occurred"));
}
```

```python
# ✅ GOOD
@app.exception_handler(Exception)
async def unhandled_exception_handler(request, exc):
    logger.error("Unhandled exception: %s", exc, exc_info=True)
    return JSONResponse(
        status_code=500,
        content={"error": "INTERNAL_ERROR", "message": "An unexpected error occurred"},
    )
```

## Encrypted Credentials

- Use TLS/HTTPS for all network communication
- Encrypt sensitive data at rest (database encryption, encrypted file storage)
- Use bcrypt, scrypt, or Argon2 for password hashing — never MD5 or SHA-1 alone
- Encrypt API keys and tokens in configuration stores

## Audit Logging

- Log all authentication events (login, logout, failed attempts)
- Log authorization decisions (access granted, access denied)
- Log data modifications (create, update, delete) with who/what/when
- Never log passwords or full tokens — log only identifiers
- Ship audit logs to a centralized, tamper-resistant store

```java
auditLog.info("action=ORDER_CREATED userId={} orderId={} timestamp={}",
    currentUser.getId(), order.getId(), Instant.now());

auditLog.warn("action=ACCESS_DENIED userId={} resource={} reason={}",
    currentUser.getId(), resourceId, "insufficient_permissions");
```

## Security Checklist

- [ ] No secrets in source code, logs, or error responses
- [ ] All user inputs validated at the boundary
- [ ] SQL queries use parameterized statements
- [ ] Authentication verified on every protected endpoint
- [ ] Authorization checked at the service layer
- [ ] Dependencies scanned for vulnerabilities
- [ ] Error responses do not leak internal details
- [ ] Credentials encrypted at rest and in transit
- [ ] RBAC enforced with least privilege
- [ ] Audit logs capture security-relevant events
