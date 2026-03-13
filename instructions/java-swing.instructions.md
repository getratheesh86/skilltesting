---
description: 'Swing UI test conventions covering identity strategy, locator separation, runner requirements, bounded self-healing, JUnit 5, and diagnostics capture'
applyTo: 'tests/swing/**/*.java, **/*Swing*.java'
---

# Swing UI Test Conventions

## Identity Strategy Prerequisite

Before writing any Swing tests, the application under test **must** expose a reliable identity strategy:

- **Preferred**: `setName()` on all interactive components (buttons, fields, tables, menus)
- **Acceptable**: Accessible names via `AccessibleContext`
- **Last resort**: Component hierarchy path (fragile — document risk)

If the application lacks named components, **file a prerequisite issue** before proceeding with test generation.

```java
// Application code — set names on components
JButton submitButton = new JButton("Submit");
submitButton.setName("btn-submit-order");

JTextField emailField = new JTextField();
emailField.setName("input-email");
```

## Separate Locator from Test Intent

Use a Page Object (or Panel Object) pattern. Locators live in page objects; test methods express business intent only.

```java
// ✅ Page Object — locators here
public class OrderPanel {
    private final JFrameFixture frame;

    public OrderPanel(JFrameFixture frame) {
        this.frame = frame;
    }

    public JTextComponentFixture emailField() {
        return frame.textBox("input-email");
    }

    public JButtonFixture submitButton() {
        return frame.button("btn-submit-order");
    }

    public JTableFixture ordersTable() {
        return frame.table("table-orders");
    }

    public void submitOrder(String email) {
        emailField().setText(email);
        submitButton().click();
    }
}

// ✅ Test — business intent only
@Test
void submitOrder_shouldAddRowToTable_whenValidEmail() {
    orderPanel.submitOrder("user@example.com");

    assertThat(orderPanel.ordersTable().rowCount()).isGreaterThan(0);
}
```

## Document Runner Requirements

Every Swing test class must document its runtime prerequisites in class-level Javadoc:

```java
/**
 * Tests for the Order Management panel.
 *
 * <h3>Runner Requirements</h3>
 * <ul>
 *   <li>Display: Virtual framebuffer (Xvfb) or headed desktop</li>
 *   <li>JDK: 17+</li>
 *   <li>Framework: AssertJ Swing 3.x</li>
 *   <li>Application: Must be started before test execution</li>
 *   <li>Screen resolution: Minimum 1280×1024</li>
 * </ul>
 */
@Tag("swing")
class OrderManagementPanelTest { ... }
```

## Bounded Self-Healing Only

Self-healing of failed Swing tests is permitted **only** when all three conditions are met:

1. **Deterministic**: The fix follows a known, repeatable rule (e.g., component renamed → update locator)
2. **Explainable**: The change rationale is documented in the patch/commit message
3. **Evidenced**: Before/after screenshots or component tree dumps are attached

### Allowed Self-Healing Actions
- Update component name in locator when application renamed it
- Adjust wait timeout when a timing issue is confirmed by diagnostics
- Update expected text when a label change is intentional and documented

### Prohibited
- Guessing at locator changes without evidence
- Disabling or weakening assertions to make tests pass
- Changing multiple locators in a single healing pass without individual evidence

## JUnit 5 Integration

- Use `@ExtendWith` for setup/teardown of the Swing test framework
- Use `@Tag("swing")` for all Swing tests to enable selective execution
- Use `@BeforeEach` to ensure a clean application state

```java
@ExtendWith(SwingTestExtension.class)
@Tag("swing")
class LoginPanelTest {

    private JFrameFixture frame;
    private LoginPanel loginPanel;

    @BeforeEach
    void setUp() {
        frame = SwingTestUtil.launchApplication();
        loginPanel = new LoginPanel(frame);
    }

    @AfterEach
    void tearDown() {
        frame.cleanUp();
    }
}
```

## Diagnostics Capture

On every test failure, automatically capture:

- **Screenshot** of the current frame state
- **Component tree** dump (names, types, visibility, enabled status)
- **Timing data**: how long each wait/find took
- **Application logs** from the test window (if available)

```java
public class SwingDiagnosticExtension implements TestWatcher {

    @Override
    public void testFailed(ExtensionContext context, Throwable cause) {
        JFrameFixture frame = getFrame(context);
        String testName = context.getDisplayName();
        Path outputDir = Path.of("reports", "swing-diagnostics", testName);

        // Capture screenshot
        ScreenshotUtil.capture(frame, outputDir.resolve("screenshot.png"));

        // Capture component tree
        ComponentTreeDumper.dump(frame.target(), outputDir.resolve("component-tree.txt"));

        // Log timing
        TimingCapture.save(context, outputDir.resolve("timing.json"));
    }
}
```

## Wait Strategy

- Use AssertJ Swing's built-in `Pause` and `Condition` — never `Thread.sleep`
- Set reasonable timeouts (default 5s, configurable)
- Log a warning when waits approach the timeout threshold

```java
// ❌ BAD
Thread.sleep(3000);

// ✅ GOOD
Pause.pause(new Condition("Order table populated") {
    @Override
    public boolean test() {
        return frame.table("table-orders").rowCount() > 0;
    }
}, timeout(5, SECONDS));
```
