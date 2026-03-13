---
description: 'Java coding conventions covering naming, Javadoc, exception handling, immutability, streams, Optional, dependency injection, logging, and build conventions'
applyTo: '**/*.java'
---

# Java Coding Conventions

## Naming

- **Classes**: `PascalCase` — nouns (`OrderService`, `PaymentValidator`)
- **Methods**: `camelCase` — verbs (`calculateTotal`, `findByEmail`)
- **Constants**: `UPPER_SNAKE_CASE` (`MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT_MS`)
- **Packages**: all lowercase, reverse domain (`com.company.service.order`)
- Avoid abbreviations unless universally understood (`id`, `url`, `http`)

## Javadoc

- All public classes and methods must have Javadoc
- Include `@param`, `@return`, `@throws` where applicable
- First sentence is a summary — keep it concise

```java
/**
 * Calculates the discount for a given order.
 *
 * @param order the order to evaluate; must not be null
 * @return calculated discount amount, never negative
 * @throws IllegalArgumentException if order total is negative
 */
public BigDecimal calculateDiscount(Order order) { ... }
```

## Exception Handling

- Catch the most specific exception type possible
- Never catch `Exception` or `Throwable` without re-throwing or explicit justification
- Use custom exceptions for domain errors (`OrderNotFoundException`, `InsufficientFundsException`)
- Always log exception context before wrapping

```java
// ❌ BAD
try { process(order); } catch (Exception e) { return null; }

// ✅ GOOD
try {
    process(order);
} catch (OrderNotFoundException e) {
    log.warn("Order not found: {}", orderId, e);
    throw new ProcessingException("Cannot process missing order", e);
}
```

## Immutability Preference

- Prefer `final` fields and constructor initialization
- Return unmodifiable collections from getters
- Use record types (Java 16+) for value objects

```java
public record OrderSummary(String orderId, BigDecimal total, Instant createdAt) {}
```

## Stream API

- Use streams for collection transformations; prefer readability over chaining length
- Avoid side effects inside `map`/`filter`; use `forEach` only for terminal operations
- Extract complex predicates/mappers into named methods

```java
List<String> activeEmails = users.stream()
    .filter(User::isActive)
    .map(User::getEmail)
    .sorted()
    .toList();
```

## Optional Usage

- Use `Optional` as return type for methods that may not produce a result
- Never use `Optional` as a field or method parameter
- Prefer `orElseThrow` over `get()`

```java
public Optional<User> findByEmail(String email) { ... }

// Caller
User user = userService.findByEmail(email)
    .orElseThrow(() -> new UserNotFoundException(email));
```

## Builder Pattern

- Use builders for objects with more than 3–4 constructor parameters
- Make builders fluent and validate in `build()`

```java
Order order = Order.builder()
    .customerId(customerId)
    .lineItems(items)
    .shippingAddress(address)
    .build();
```

## Dependency Injection

- Use constructor injection; avoid field injection
- Mark injected dependencies as `final`
- Program to interfaces, not implementations

```java
@Service
public class OrderService {
    private final OrderRepository repository;
    private final PaymentGateway paymentGateway;

    public OrderService(OrderRepository repository, PaymentGateway paymentGateway) {
        this.repository = repository;
        this.paymentGateway = paymentGateway;
    }
}
```

## Logging (SLF4J)

- Use SLF4J with parameterized messages — never string concatenation
- Log levels: `ERROR` (failures), `WARN` (recoverable issues), `INFO` (key events), `DEBUG` (diagnostics)
- Never log secrets, tokens, or PII

```java
private static final Logger log = LoggerFactory.getLogger(OrderService.class);

log.info("Processing order: orderId={}, items={}", order.getId(), order.getItemCount());
log.error("Payment failed for order {}: {}", orderId, e.getMessage(), e);
```

## Build Tool Conventions

- **Maven**: Use Bill of Materials (BOM) for dependency version management; enforce via `maven-enforcer-plugin`
- **Gradle**: Use version catalogs (`libs.versions.toml`) for centralized dependency versions
- Pin dependency versions — never use `LATEST` or `RELEASE`
- Separate `compile`, `test`, and `runtime` scopes

## Code Organization

```
src/
├── main/java/com/company/service/
│   ├── config/         # Spring/CDI configuration
│   ├── controller/     # REST endpoints
│   ├── service/        # Business logic
│   ├── repository/     # Data access
│   ├── model/          # Domain entities and DTOs
│   └── exception/      # Custom exceptions
└── test/java/com/company/service/
    ├── unit/           # Unit tests
    └── integration/    # Integration tests
```
