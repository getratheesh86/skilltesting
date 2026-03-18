---
description: 'JUnit 5 API test conventions covering AAA pattern, deterministic tests, naming, config isolation, contract drift detection, and diagnostics. RestAssured is optional — use when the project already depends on it.'
applyTo: 'tests/api/**/*.java, **/*Test.java, **/*IT.java'
---

# JUnit 5 API Test Conventions

> **Note:** Playwright (TypeScript) is the primary framework for API testing. Use these Java conventions when the project requires Java-based API tests. RestAssured is optional — include it only if the project already depends on it or the team prefers it.

## Test Structure (AAA Pattern)

Every test follows **Arrange → Act → Assert**:

```java
@Test
void createOrder_shouldReturn201_whenValidPayload() {
    // Arrange
    OrderRequest request = OrderRequest.builder()
        .customerId("cust-001")
        .items(List.of(new LineItem("SKU-100", 2)))
        .build();

    // Act
    Response response = given()
        .contentType(ContentType.JSON)
        .body(request)
        .post("/api/v1/orders");

    // Assert
    assertThat(response.statusCode()).isEqualTo(201);
    assertThat(response.jsonPath().getString("orderId")).isNotBlank();
}
```

## Naming Convention

Use: `method_shouldExpectedBehavior_whenCondition`

```java
@Test void getUser_shouldReturn404_whenUserDoesNotExist() { ... }
@Test void updateOrder_shouldReturn400_whenMissingRequiredField() { ... }
@Test void deleteItem_shouldReturn204_whenItemExists() { ... }
```

## Deterministic and Idempotent

- Tests must produce the same result on every run
- No dependency on execution order — each test sets up and tears down its own state
- Use `@BeforeEach` / `@AfterEach` for per-test setup and cleanup
- Generate unique test data per run (e.g., UUID-based identifiers)

```java
@BeforeEach
void setUp() {
    testOrderId = "order-" + UUID.randomUUID();
}

@AfterEach
void tearDown() {
    apiClient.deleteIfExists("/api/v1/orders/" + testOrderId);
}
```

## No Hardcoded Secrets

- Never embed API keys, passwords, or tokens in test code
- Load all sensitive config from environment variables or a secure vault
- Fail fast with a clear message if required config is missing

```java
private static final String BASE_URL = System.getenv("API_BASE_URL");
private static final String API_KEY = System.getenv("API_KEY");

@BeforeAll
static void validateConfig() {
    assertThat(BASE_URL).as("API_BASE_URL env var required").isNotBlank();
    assertThat(API_KEY).as("API_KEY env var required").isNotBlank();
}
```

## Configuration from Environment

Use a config helper to centralize environment access:

```java
public class TestConfig {
    public static String baseUrl() {
        return requireEnv("API_BASE_URL");
    }

    public static String apiKey() {
        return requireEnv("API_KEY");
    }

    private static String requireEnv(String name) {
        String value = System.getenv(name);
        if (value == null || value.isBlank()) {
            throw new IllegalStateException("Missing required env var: " + name);
        }
        return value;
    }
}
```

## Contract Drift Detection

- Capture baseline response schemas as JSON files under `tests/api/contracts/`
- After each test run, compare actual response structure against the baseline
- Flag any new, removed, or type-changed fields as contract drift
- Update baselines intentionally — never auto-update in CI

```java
@Test
void getUser_shouldMatchContractSchema() {
    Response response = given().get("/api/v1/users/user-001");

    String actualSchema = SchemaExtractor.extract(response.body().asString());
    String baseline = Files.readString(Path.of("tests/api/contracts/get-user.schema.json"));

    assertThat(actualSchema)
        .as("Contract drift detected — review and update baseline if intentional")
        .isEqualTo(baseline);
}
```

## JUnit XML Output

- Configure Surefire/Failsafe to emit JUnit XML reports
- Output to a predictable path for CI consumption

```xml
<!-- Maven pom.xml -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <configuration>
        <reportsDirectory>${project.build.directory}/test-results</reportsDirectory>
    </configuration>
</plugin>
```

## Triage Diagnostics

- On failure, capture and attach: HTTP status, response body, request headers (redacted), timestamps
- Use JUnit 5 extensions for automatic capture

```java
@ExtendWith(DiagnosticCaptureExtension.class)
class OrderApiTest {

    @Test
    void createOrder_shouldReturn201_whenValidPayload(TestInfo testInfo) {
        Response response = given()
            .contentType(ContentType.JSON)
            .body(validOrderRequest())
            .post("/api/v1/orders");

        DiagnosticCapture.record(testInfo, response);
        assertThat(response.statusCode()).isEqualTo(201);
    }
}
```

## Assertions

- Use AssertJ for fluent, readable assertions
- Assert on specific fields — never assert on full serialized JSON strings
- Include descriptive `as()` messages for non-obvious assertions

```java
assertThat(response.statusCode())
    .as("Expected 200 OK for valid request")
    .isEqualTo(200);

assertThat(response.jsonPath().getList("items"))
    .as("Response should contain exactly 3 items")
    .hasSize(3);
```

## Test Tagging

Use JUnit 5 tags to categorize tests for selective execution:

```java
@Tag("smoke")    // Quick verification of key endpoints
@Tag("contract") // Schema/contract validation
@Tag("e2e")      // Full end-to-end flows
```
