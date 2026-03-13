---
description: 'Generic code review checklist covering priorities, clean code, error handling, security, testing, performance, architecture, and documentation'
applyTo: '**'
---

# Code Review Instructions

## Review Priorities

### 🔴 CRITICAL (Block merge)
- **Security**: Vulnerabilities, exposed secrets, authentication/authorization gaps
- **Correctness**: Logic errors, data corruption risks, race conditions
- **Breaking Changes**: API contract changes without versioning
- **Data Loss**: Risk of data loss or corruption

### 🟡 IMPORTANT (Requires discussion)
- **Code Quality**: SOLID violations, excessive duplication
- **Test Coverage**: Missing tests for critical paths or new functionality
- **Performance**: Obvious bottlenecks (N+1 queries, memory leaks)
- **Architecture**: Significant deviations from established patterns

### 🟢 SUGGESTION (Non-blocking improvements)
- **Readability**: Poor naming, complex logic that could be simplified
- **Optimization**: Performance improvements without functional impact
- **Best Practices**: Minor deviations from conventions
- **Documentation**: Missing or incomplete comments/documentation

## Clean Code

- Use descriptive, meaningful names for variables, functions, and classes
- Single Responsibility Principle: each function/class does one thing well
- DRY: no code duplication
- Functions should be small and focused (ideally < 25 lines)
- Avoid deeply nested code (max 3–4 levels)
- Replace magic numbers and strings with named constants
- Code should be self-documenting; add comments only when intent is non-obvious

### Examples

```java
// ❌ BAD
public double calc(double x, double y) {
    if (x > 100) return y * 0.15;
    return y * 0.10;
}

// ✅ GOOD
private static final double PREMIUM_THRESHOLD = 100.0;
private static final double PREMIUM_RATE = 0.15;
private static final double STANDARD_RATE = 0.10;

public double calculateDiscount(double orderTotal, double itemPrice) {
    double rate = orderTotal > PREMIUM_THRESHOLD ? PREMIUM_RATE : STANDARD_RATE;
    return itemPrice * rate;
}
```

```typescript
// ❌ BAD
function proc(d: any) {
  if (d.t === 1) { /* ... */ }
  else if (d.t === 2) { /* ... */ }
}

// ✅ GOOD
type OrderType = 'standard' | 'express';

function processOrder(order: Order): ProcessingResult {
  const handler = orderHandlers.get(order.type);
  if (!handler) throw new UnknownOrderTypeError(order.type);
  return handler.process(order);
}
```

```python
# ❌ BAD
def p(d):
    return d["a"] * 0.08

# ✅ GOOD
TAX_RATE = 0.08

def calculate_tax(order: dict[str, float]) -> float:
    """Calculate tax for the given order amount."""
    return order["amount"] * TAX_RATE
```

## Error Handling

- Handle errors at appropriate levels; do not swallow exceptions silently
- Provide meaningful error messages with context
- Fail fast: validate inputs early
- Use appropriate exception types

```java
// ❌ BAD
try { processOrder(order); } catch (Exception e) { /* ignored */ }

// ✅ GOOD
try {
    processOrder(order);
} catch (OrderNotFoundException e) {
    log.warn("Order {} not found: {}", orderId, e.getMessage());
    throw new ProcessingException("Failed to process order " + orderId, e);
}
```

## Security

- No passwords, API keys, tokens, or PII in code or logs
- Validate and sanitize all user inputs
- Use parameterized queries — never string concatenation for SQL
- Verify authentication and authorization before accessing resources
- Use established cryptography libraries; never roll your own
- Check dependencies for known vulnerabilities

## Testing Standards

- Critical paths and new functionality must have tests
- Test names describe what is being tested: `should_returnDiscount_whenPremiumOrder`
- Follow Arrange-Act-Assert or Given-When-Then structure
- Tests must be independent and deterministic
- Use specific assertions; avoid generic assertTrue/assertFalse
- Cover edge cases, null values, and boundary conditions

## Performance

- Avoid N+1 query patterns; use joins or eager loading
- Use appropriate data structures and algorithms
- Cache expensive or repeated operations
- Clean up connections, files, and streams properly
- Paginate large result sets
- Prefer lazy loading where applicable

## Architecture

- Maintain clear separation of concerns between layers
- High-level modules should not depend on low-level implementation details
- Prefer small, focused interfaces
- Related functionality should be grouped together
- Follow established patterns in the codebase consistently

## Documentation

- Public APIs must be documented (purpose, parameters, return values)
- Non-obvious logic should have explanatory comments
- Update README when adding features or changing setup
- Breaking changes must be documented clearly
- Provide usage examples for complex features

## Comment Format Template

```markdown
**[PRIORITY] Category: Brief title**

Description of the issue or suggestion.

**Why this matters:** Impact or reason.

**Suggested fix:**
[code example if applicable]
```

## Review Checklist

- [ ] Code follows consistent style and conventions
- [ ] Names are descriptive and follow naming conventions
- [ ] Functions are small and focused
- [ ] No code duplication
- [ ] Error handling is appropriate
- [ ] No secrets or PII in code or logs
- [ ] Input validation on all user inputs
- [ ] Auth/authz properly implemented
- [ ] New code has test coverage
- [ ] Tests cover edge cases and error scenarios
- [ ] No obvious performance issues
- [ ] Follows established architectural patterns
- [ ] Public APIs are documented
- [ ] README updated if needed
