---
description: 'Python coding conventions covering PEP 8, type hints, docstrings, exception handling, virtual environments, pytest, and logging'
applyTo: '**/*.py'
---

# Python Coding Conventions

## Style (PEP 8)

- **Indentation**: 4 spaces, no tabs
- **Line length**: max 88 characters (Black formatter default) or 79 (strict PEP 8)
- **Imports**: organized in three groups separated by blank lines: stdlib, third-party, local
- **Naming**:
  - `snake_case` for functions, methods, variables, modules
  - `PascalCase` for classes
  - `UPPER_SNAKE_CASE` for constants
  - `_leading_underscore` for internal/private

```python
import os
from pathlib import Path

import requests
from pydantic import BaseModel

from myapp.services import OrderService
from myapp.models import Order

MAX_RETRIES = 3
DEFAULT_TIMEOUT = 30
```

## Type Hints

- Use type hints on all public function signatures
- Use `from __future__ import annotations` for forward references (Python 3.7+)
- Use `typing` generics: `list[str]`, `dict[str, int]`, `Optional[str]`, `Union[int, str]`
- Use `TypeAlias` for complex types

```python
from __future__ import annotations

def find_user(user_id: str) -> User | None:
    """Look up a user by ID. Returns None if not found."""
    ...

def process_orders(orders: list[Order]) -> dict[str, ProcessingResult]:
    """Process a batch of orders and return results keyed by order ID."""
    ...
```

## Docstrings (PEP 257)

- All public modules, classes, and functions must have docstrings
- Use Google-style or NumPy-style — be consistent within the project
- First line is a one-line summary, followed by a blank line, then details

```python
def calculate_discount(order_total: float, customer_tier: str) -> float:
    """Calculate the discount for an order based on customer tier.

    Args:
        order_total: Total order amount in dollars. Must be non-negative.
        customer_tier: One of 'standard', 'premium', or 'enterprise'.

    Returns:
        Discount amount in dollars.

    Raises:
        ValueError: If order_total is negative or tier is unrecognized.
    """
    if order_total < 0:
        raise ValueError(f"order_total must be non-negative, got {order_total}")
    rates = {"standard": 0.05, "premium": 0.10, "enterprise": 0.15}
    rate = rates.get(customer_tier)
    if rate is None:
        raise ValueError(f"Unknown customer tier: {customer_tier}")
    return order_total * rate
```

## Exception Handling

- Catch specific exceptions — never bare `except:` or `except Exception:`
- Provide context in error messages
- Use custom exceptions for domain errors
- Use `raise ... from e` for exception chaining

```python
# ❌ BAD
try:
    result = process(data)
except:
    pass

# ✅ GOOD
try:
    result = process(data)
except ValidationError as e:
    logger.warning("Validation failed for record %s: %s", record_id, e)
    raise ProcessingError(f"Cannot process record {record_id}") from e
except ConnectionError as e:
    logger.error("Service unavailable: %s", e)
    raise
```

## No Mutable Default Arguments

```python
# ❌ BAD — mutable default is shared across calls
def add_item(item: str, items: list[str] = []) -> list[str]:
    items.append(item)
    return items

# ✅ GOOD
def add_item(item: str, items: list[str] | None = None) -> list[str]:
    if items is None:
        items = []
    items.append(item)
    return items
```

## Virtual Environments and Dependencies

- Always use a virtual environment (`venv`, `conda`, or `poetry`)
- Pin dependency versions in `requirements.txt` or `pyproject.toml`
- Separate production and dev dependencies
- Use `pip freeze` to capture exact versions for reproducibility

```
# requirements.txt
fastapi==0.104.1
uvicorn[standard]==0.24.0
pydantic==2.5.2

# requirements-dev.txt
pytest==7.4.3
pytest-cov==4.1.0
black==23.12.1
mypy==1.8.0
```

## Pytest Conventions

- Test files: `test_<module>.py`
- Test functions: `test_<expected_behavior>_when_<condition>`
- Use fixtures for setup and teardown
- Use parametrize for data-driven tests

```python
import pytest

@pytest.fixture
def order_service(mock_repository):
    return OrderService(repository=mock_repository)

def test_calculate_discount_returns_premium_rate_when_enterprise(order_service):
    discount = order_service.calculate_discount(order_total=1000.0, tier="enterprise")
    assert discount == 150.0

@pytest.mark.parametrize("tier,expected_rate", [
    ("standard", 0.05),
    ("premium", 0.10),
    ("enterprise", 0.15),
])
def test_discount_rate_matches_tier(tier, expected_rate):
    assert get_discount_rate(tier) == expected_rate

def test_calculate_discount_raises_when_negative_total(order_service):
    with pytest.raises(ValueError, match="non-negative"):
        order_service.calculate_discount(order_total=-10.0, tier="standard")
```

## Logging

- Use the `logging` module — never `print()` in production code
- Configure logging at application entry point, not in library modules
- Use parameterized messages (lazy formatting)
- Never log secrets, tokens, or PII

```python
import logging

logger = logging.getLogger(__name__)

def process_order(order_id: str) -> None:
    logger.info("Processing order: %s", order_id)
    try:
        result = _execute(order_id)
        logger.debug("Order %s processed: status=%s", order_id, result.status)
    except OrderError as e:
        logger.error("Failed to process order %s: %s", order_id, e)
        raise
```

## Code Organization

```
src/myapp/
├── __init__.py
├── main.py             # Application entry point
├── config.py           # Configuration loading
├── models/             # Domain models / schemas
│   ├── __init__.py
│   └── order.py
├── services/           # Business logic
│   ├── __init__.py
│   └── order_service.py
├── repositories/       # Data access
│   ├── __init__.py
│   └── order_repo.py
└── utils/              # Shared utilities
    ├── __init__.py
    └── validators.py

tests/
├── conftest.py         # Shared fixtures
├── test_order_service.py
└── test_order_repo.py
```
