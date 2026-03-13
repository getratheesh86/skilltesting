---
description: 'Playwright TypeScript conventions covering resilient locators, web-first assertions, traces, deterministic self-healing, and multi-browser considerations'
applyTo: 'tests/web/**/*.ts, tests/web/**/*.tsx, **/*.spec.ts'
---

# Playwright TypeScript Conventions

## Framework

- Use `@playwright/test` — do not mix with raw Playwright library calls
- Import `test` and `expect` from `@playwright/test`
- Use `test.describe` for grouping related scenarios

```typescript
import { test, expect } from '@playwright/test';

test.describe('Order Management', () => {
  test('should create a new order', async ({ page }) => {
    // ...
  });
});
```

## Resilient Locators

Use user-facing locators in this priority order:

1. `page.getByRole()` — most resilient, matches accessibility tree
2. `page.getByLabel()` — for form inputs with associated labels
3. `page.getByText()` — for visible text content
4. `page.getByTestId()` — for explicit test identifiers
5. `page.locator('css=...')` — last resort, document why

```typescript
// ✅ GOOD — resilient locators
await page.getByRole('button', { name: 'Submit Order' }).click();
await page.getByLabel('Email address').fill('user@example.com');
await page.getByTestId('order-total').toContainText('$42.00');

// ❌ BAD — brittle selectors
await page.locator('#btn-submit').click();
await page.locator('div > form > input:nth-child(3)').fill('user@example.com');
```

## No Hard Waits

Never use `page.waitForTimeout()` or `setTimeout`. Use web-first assertions and auto-waiting.

```typescript
// ❌ BAD
await page.waitForTimeout(3000);
expect(await page.locator('.order-row').count()).toBeGreaterThan(0);

// ✅ GOOD — web-first assertion with auto-retry
await expect(page.getByTestId('order-list')).toBeVisible();
await expect(page.getByRole('row')).toHaveCount(5);
```

## Web-First Assertions

Always use `expect(locator)` assertions — they auto-retry until timeout:

```typescript
await expect(page.getByRole('heading')).toHaveText('Order Confirmation');
await expect(page.getByRole('alert')).toBeVisible();
await expect(page.getByLabel('Status')).toHaveValue('completed');
await expect(page.getByRole('row')).toHaveCount(3);
```

## Trace and Screenshot on Failure

Configure `playwright.config.ts` for automatic diagnostics:

```typescript
export default defineConfig({
  use: {
    trace: 'on-first-retry',       // Capture trace on failure
    screenshot: 'only-on-failure',  // Screenshot on failure
    video: 'retain-on-failure',     // Video on failure (optional)
  },
  retries: 1,
});
```

For manual capture in tests:

```typescript
test('checkout flow', async ({ page }, testInfo) => {
  // ... actions ...
  if (testInfo.retry) {
    await testInfo.attach('screenshot', {
      body: await page.screenshot(),
      contentType: 'image/png',
    });
  }
});
```

## Page Object Model

Separate locators and interactions from test intent:

```typescript
// page-objects/order-page.ts
export class OrderPage {
  constructor(private page: Page) {}

  get emailField() { return this.page.getByLabel('Email'); }
  get submitButton() { return this.page.getByRole('button', { name: 'Submit' }); }
  get orderTable() { return this.page.getByRole('table', { name: 'Orders' }); }

  async submitOrder(email: string) {
    await this.emailField.fill(email);
    await this.submitButton.click();
  }
}

// tests/order.spec.ts
test('should submit order', async ({ page }) => {
  const orderPage = new OrderPage(page);
  await orderPage.submitOrder('user@example.com');
  await expect(orderPage.orderTable).toBeVisible();
});
```

## Deterministic Self-Healing Only

Self-healing of failed tests is permitted **only** when all three conditions are met:

1. **Deterministic**: Fix follows a known, repeatable rule (e.g., label text changed → update locator)
2. **Explainable**: Rationale is documented in the patch/commit
3. **Evidenced**: Before/after screenshots or trace files are attached

### Prohibited
- Guessing at selector changes without evidence
- Adding `waitForTimeout` to fix flaky tests
- Disabling or weakening assertions to make tests green

## Multi-Browser Considerations

- **Safari/WebKit** requires macOS — do not assume WebKit runs on Windows/Linux CI
- Configure browser matrix in `playwright.config.ts`:

```typescript
projects: [
  { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
  { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
  // WebKit — requires macOS runner
  { name: 'webkit', use: { ...devices['Desktop Safari'] } },
],
```

## Test Data

- Generate unique data per test run (timestamps, UUIDs)
- Clean up created resources in `afterEach` or use API calls for setup
- Never rely on pre-existing data in shared environments

## Test Organization

```
tests/web/
├── page-objects/        # Page Object Model classes
│   ├── login-page.ts
│   └── order-page.ts
├── fixtures/            # Custom test fixtures
│   └── auth.fixture.ts
├── login.spec.ts        # Test files
├── order.spec.ts
└── checkout.spec.ts
```
