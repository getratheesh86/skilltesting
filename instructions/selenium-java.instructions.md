---
description: 'Selenium Java conventions covering Page Object Model, WebDriverManager, explicit waits, locator priority, JUnit 5 integration, and reporting'
applyTo: 'tests/web/**/*.java, **/*Selenium*.java, **/*WebDriver*.java'
---

# Selenium Java Conventions

## Page Object Model

Every page or significant component gets its own class. Locators and interactions live in page objects; tests express business intent only.

```java
// ✅ Page Object
public class LoginPage {
    private final WebDriver driver;

    private By emailField = By.id("input-email");
    private By passwordField = By.id("input-password");
    private By loginButton = By.cssSelector("[data-testid='btn-login']");
    private By errorMessage = By.cssSelector(".alert-error");

    public LoginPage(WebDriver driver) {
        this.driver = driver;
    }

    public void login(String email, String password) {
        driver.findElement(emailField).sendKeys(email);
        driver.findElement(passwordField).sendKeys(password);
        driver.findElement(loginButton).click();
    }

    public String getErrorMessage() {
        return new WebDriverWait(driver, Duration.ofSeconds(5))
            .until(ExpectedConditions.visibilityOfElementLocated(errorMessage))
            .getText();
    }
}

// ✅ Test — business intent only
@Test
void login_shouldShowError_whenInvalidCredentials() {
    loginPage.login("bad@example.com", "wrongpass");
    assertThat(loginPage.getErrorMessage()).contains("Invalid credentials");
}
```

## WebDriverManager for Browser Setup

Use WebDriverManager to manage browser drivers automatically — never commit driver binaries.

```java
@BeforeAll
static void setupDriver() {
    WebDriverManager.chromedriver().setup();
}

@BeforeEach
void createDriver() {
    ChromeOptions options = new ChromeOptions();
    options.addArguments("--headless=new", "--no-sandbox", "--disable-dev-shm-usage");
    driver = new ChromeDriver(options);
    driver.manage().window().setSize(new Dimension(1920, 1080));
    driver.manage().timeouts().implicitlyWait(Duration.ZERO); // Explicit waits only
}

@AfterEach
void tearDown() {
    if (driver != null) {
        driver.quit();
    }
}
```

## Explicit Waits (Never Thread.sleep)

Use `WebDriverWait` with `ExpectedConditions`. Set implicit wait to zero to avoid conflicts.

```java
// ❌ BAD
Thread.sleep(3000);
driver.findElement(By.id("result")).getText();

// ✅ GOOD
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
WebElement result = wait.until(
    ExpectedConditions.visibilityOfElementLocated(By.id("result"))
);
assertThat(result.getText()).isEqualTo("Order placed");
```

For custom conditions:

```java
wait.until(driver -> {
    List<WebElement> rows = driver.findElements(By.cssSelector("table.orders tbody tr"));
    return rows.size() >= 3;
});
```

## Locator Priority

Use locators in this order of preference:

| Priority | Strategy | Example | Rationale |
|----------|----------|---------|-----------|
| 1 | `By.id` | `By.id("order-form")` | Unique, fast |
| 2 | `By.name` | `By.name("email")` | Stable for forms |
| 3 | `By.cssSelector` | `By.cssSelector("[data-testid='submit']")` | Flexible, performant |
| 4 | `By.xpath` | `By.xpath("//button[text()='Submit']")` | Last resort — fragile |

- Prefer `data-testid` attributes over structural selectors
- Avoid positional XPath (`//div[3]/span[1]`) — extremely brittle
- Document why if you must use XPath

## JUnit 5 Integration

```java
@ExtendWith(SeleniumTestWatcher.class)
@Tag("web")
class OrderFlowTest {

    private WebDriver driver;
    private OrderPage orderPage;

    @BeforeEach
    void setUp() {
        driver = DriverFactory.create("chrome");
        orderPage = new OrderPage(driver);
        driver.get(TestConfig.baseUrl() + "/orders");
    }

    @AfterEach
    void tearDown() {
        if (driver != null) driver.quit();
    }

    @Test
    void createOrder_shouldDisplayConfirmation() {
        orderPage.fillOrder("user@example.com", "SKU-100", 2);
        orderPage.submit();

        assertThat(orderPage.getConfirmationText())
            .contains("Order placed successfully");
    }
}
```

## Screenshot on Failure

Use a JUnit 5 `TestWatcher` extension to capture screenshots automatically:

```java
public class SeleniumTestWatcher implements TestWatcher {

    @Override
    public void testFailed(ExtensionContext context, Throwable cause) {
        WebDriver driver = getDriver(context);
        if (driver instanceof TakesScreenshot ts) {
            String testName = context.getDisplayName();
            Path screenshotPath = Path.of("reports", "screenshots", testName + ".png");
            try {
                byte[] screenshot = ts.getScreenshotAs(OutputType.BYTES);
                Files.createDirectories(screenshotPath.getParent());
                Files.write(screenshotPath, screenshot);
            } catch (IOException e) {
                LoggerFactory.getLogger(SeleniumTestWatcher.class)
                    .warn("Failed to capture screenshot for {}", testName, e);
            }
        }
    }
}
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
    emailField.sendKeys(email);
    skuField.sendKeys(sku);
    quantityField.sendKeys(String.valueOf(quantity));
}
```

## Test Data

- Generate unique identifiers per test (UUID, timestamp)
- Clean up created data in `@AfterEach`
- Load configuration from environment variables, never hardcode

## Parallel Execution

- Each test must own its own `WebDriver` instance
- Never share driver state between tests
- Configure Surefire for parallel execution by method/class if needed:

```xml
<configuration>
    <parallel>methods</parallel>
    <threadCount>4</threadCount>
</configuration>
```
