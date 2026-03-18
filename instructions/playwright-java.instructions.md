---
description: 'Playwright Java conventions covering resilient locators, web-first assertions, traces, Page Object Model, JUnit 5 integration, and multi-browser considerations'
applyTo: 'tests/web/**/*.java, **/*Playwright*.java, **/*WebTest*.java'
---

# Playwright Java Conventions

## Framework

- Use `com.microsoft.playwright` — the official Playwright for Java library
- Manage browser lifecycle with `Playwright.create()`, `Browser`, `BrowserContext`, `Page`
- Use JUnit 5 for test structure and lifecycle

```java
import com.microsoft.playwright.*;
import org.junit.jupiter.api.*;

@Tag("web")
class OrderFlowTest {
    static Playwright playwright;
    static Browser browser;
    BrowserContext context;
    Page page;

    @BeforeAll
    static void setupBrowser() {
        playwright = Playwright.create();
        browser = playwright.chromium().launch(
            new BrowserType.LaunchOptions().setHeadless(true)
        );
    }

    @BeforeEach
    void createContext() {
        context = browser.newContext(new Browser.NewContextOptions()
            .setViewportSize(1920, 1080));
        page = context.newPage();
    }

    @AfterEach
    void closeContext() {
        if (context != null) context.close();
    }

    @AfterAll
    static void tearDown() {
        if (browser != null) browser.close();
        if (playwright != null) playwright.close();
    }
}
```

## Resilient Locators

Use user-facing locators in this priority order:

1. `page.getByRole()` — most resilient, matches accessibility tree
2. `page.getByLabel()` — for form inputs with associated labels
3. `page.getByText()` — for visible text content
4. `page.getByTestId()` — for explicit test identifiers
5. `page.locator("css=...")` — last resort, document why

```java
// ✅ GOOD — resilient locators
page.getByRole(AriaRole.BUTTON, new Page.GetByRoleOptions().setName("Submit Order")).click();
page.getByLabel("Email address").fill("user@example.com");
assertThat(page.getByTestId("order-total")).containsText("$42.00");

// ❌ BAD — brittle selectors
page.locator("#btn-submit").click();
page.locator("div > form > input:nth-child(3)").fill("user@example.com");
```

## No Hard Waits

Never use `Thread.sleep()` or `page.waitForTimeout()`. Use web-first assertions and Playwright's auto-waiting.

```java
// ❌ BAD
Thread.sleep(3000);
page.locator(".order-row").count();

// ✅ GOOD — web-first assertion with auto-retry
assertThat(page.getByTestId("order-list")).isVisible();
assertThat(page.getByRole(AriaRole.ROW)).hasCount(5);
```

## Web-First Assertions

Always use `PlaywrightAssertions.assertThat(locator)` — they auto-retry until timeout:

```java
import static com.microsoft.playwright.assertions.PlaywrightAssertions.assertThat;

assertThat(page.getByRole(AriaRole.HEADING)).hasText("Order Confirmation");
assertThat(page.getByRole(AriaRole.ALERT)).isVisible();
assertThat(page.getByLabel("Status")).hasValue("completed");
assertThat(page.getByRole(AriaRole.ROW)).hasCount(3);
```

## Trace and Screenshot on Failure

Configure tracing per context for automatic diagnostics:

```java
@BeforeEach
void createContext() {
    context = browser.newContext();
    context.tracing().start(new Tracing.StartOptions()
        .setScreenshots(true)
        .setSnapshots(true)
        .setSources(true));
    page = context.newPage();
}

@AfterEach
void closeContext(TestInfo testInfo) {
    if (context != null) {
        Path tracePath = Path.of("reports", "web", "artifacts",
            testInfo.getDisplayName() + ".zip");
        context.tracing().stop(new Tracing.StopOptions().setPath(tracePath));
        context.close();
    }
}
```

For screenshot capture on failure using a JUnit 5 `TestWatcher`:

```java
public class PlaywrightTestWatcher implements TestWatcher {

    @Override
    public void testFailed(ExtensionContext context, Throwable cause) {
        Page page = getPage(context);
        if (page != null) {
            String testName = context.getDisplayName();
            Path screenshotPath = Path.of("reports", "web", "artifacts", testName + ".png");
            try {
                Files.createDirectories(screenshotPath.getParent());
                page.screenshot(new Page.ScreenshotOptions()
                    .setPath(screenshotPath)
                    .setFullPage(true));
            } catch (Exception e) {
                LoggerFactory.getLogger(PlaywrightTestWatcher.class)
                    .warn("Failed to capture screenshot for {}", testName, e);
            }
        }
    }
}
```

## Page Object Model

Separate locators and interactions from test intent:

```java
// page-objects/OrderPage.java
public class OrderPage {
    private final Page page;

    public OrderPage(Page page) {
        this.page = page;
    }

    public Locator emailField() { return page.getByLabel("Email"); }
    public Locator submitButton() { return page.getByRole(AriaRole.BUTTON,
        new Page.GetByRoleOptions().setName("Submit")); }
    public Locator orderTable() { return page.getByRole(AriaRole.TABLE,
        new Page.GetByRoleOptions().setName("Orders")); }

    public void submitOrder(String email) {
        emailField().fill(email);
        submitButton().click();
    }
}

// tests/OrderTest.java
@Test
void shouldSubmitOrder() {
    OrderPage orderPage = new OrderPage(page);
    orderPage.submitOrder("user@example.com");
    assertThat(orderPage.orderTable()).isVisible();
}
```

## Locator Priority

| Priority | Method | Example | Rationale |
|----------|--------|---------|-----------|
| 1 | `getByRole` | `page.getByRole(AriaRole.BUTTON, ...)` | Matches accessibility tree |
| 2 | `getByLabel` | `page.getByLabel("Email")` | Stable for forms |
| 3 | `getByText` | `page.getByText("Submit Order")` | Visible content |
| 4 | `getByTestId` | `page.getByTestId("submit-btn")` | Explicit test markers |
| 5 | `locator("css=")` | `page.locator("[data-id='order']")` | Last resort — document why |

## JUnit 5 Integration

```java
@ExtendWith(PlaywrightTestWatcher.class)
@Tag("web")
class OrderFlowTest {

    static Playwright playwright;
    static Browser browser;
    BrowserContext context;
    Page page;

    @BeforeAll
    static void setupBrowser() {
        playwright = Playwright.create();
        browser = playwright.chromium().launch();
    }

    @BeforeEach
    void setUp() {
        context = browser.newContext();
        page = context.newPage();
        page.navigate(TestConfig.baseUrl() + "/orders");
    }

    @AfterEach
    void tearDown() {
        if (context != null) context.close();
    }

    @AfterAll
    static void closeBrowser() {
        if (browser != null) browser.close();
        if (playwright != null) playwright.close();
    }

    @Test
    void createOrder_shouldDisplayConfirmation() {
        OrderPage orderPage = new OrderPage(page);
        orderPage.fillOrder("user@example.com", "SKU-100", 2);
        orderPage.submit();

        assertThat(page.getByText("Order placed successfully")).isVisible();
    }
}
```

## Deterministic Self-Healing Only

Self-healing of failed tests is permitted **only** when all three conditions are met:

1. **Deterministic**: Fix follows a known, repeatable rule (e.g., label text changed → update locator)
2. **Explainable**: Rationale is documented in the patch/commit
3. **Evidenced**: Before/after screenshots or trace files are attached

### Prohibited
- Guessing at selector changes without evidence
- Adding `Thread.sleep()` or `waitForTimeout()` to fix flaky tests
- Disabling or weakening assertions to make tests green

## Multi-Browser Considerations

- **Safari/WebKit** requires macOS — do not assume WebKit runs on Windows/Linux CI
- Configure browser matrix in test configuration or CI:

```java
@ParameterizedTest
@ValueSource(strings = {"chromium", "firefox", "webkit"})
void crossBrowserTest(String browserName) {
    BrowserType browserType = switch (browserName) {
        case "chromium" -> playwright.chromium();
        case "firefox" -> playwright.firefox();
        case "webkit" -> playwright.webkit();
        default -> throw new IllegalArgumentException("Unknown browser: " + browserName);
    };
    Browser browser = browserType.launch();
    Page page = browser.newPage();
    // ... test logic ...
    browser.close();
}
```

## Dependency Setup (Maven)

```xml
<dependency>
    <groupId>com.microsoft.playwright</groupId>
    <artifactId>playwright</artifactId>
    <version>1.49.0</version>
    <scope>test</scope>
</dependency>
```

Install browsers after adding the dependency:

```bash
mvn exec:java -e -D exec.mainClass=com.microsoft.playwright.CLI -D exec.args="install"
```

## Test Data

- Generate unique data per test run (timestamps, UUIDs)
- Clean up created resources in `@AfterEach` or use API calls for setup
- Never rely on pre-existing data in shared environments

## Test Organization

```
tests/web/
├── page-objects/        # Page Object Model classes
│   ├── LoginPage.java
│   └── OrderPage.java
├── fixtures/            # Custom test fixtures and utilities
│   └── TestConfig.java
├── LoginTest.java       # Test files
├── OrderTest.java
└── CheckoutTest.java
```

## Reporting

### JUnit XML (default)
Configure Surefire to emit JUnit XML:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <configuration>
        <reportsDirectory>${project.build.directory}/test-results</reportsDirectory>
    </configuration>
</plugin>
```

### Allure (optional)
For rich HTML reports with screenshots and steps:

```java
@Step("Fill order form with email: {email}")
public void fillOrder(String email, String sku, int quantity) {
    page.getByLabel("Email").fill(email);
    page.getByLabel("SKU").fill(sku);
    page.getByLabel("Quantity").fill(String.valueOf(quantity));
}
```
